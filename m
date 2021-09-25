Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655CC418338
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbhIYP1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 11:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhIYP1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 11:27:15 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F8DC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 08:25:41 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso17459874ota.8
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 08:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xtppztuQTUZZg+8iKk9a/80SqOmmIdZgmSM57UH1kdg=;
        b=kO2wUNiwardqCPLzdlq5bPJJFecsCXChOhFmvmMrCmOU+fcs2koRWse4X9QJEGBqYq
         /l9Z8k1xcqOITntUGPqaWsC7Fn0mK0Pg2gMYEqZHj/Bo36EueOOSgdZ3ykFb6uRRMOF/
         Yl3GRiOs7J0qief08d0AfMdyeTJaUhhZV3RwBchI5Nzo2KiFfav23K4C+1LNGt3EwMHJ
         k2iMtE0hBcB4s0z+y0xjovzLFS/oTXEq0p/E7GcvjjdXM8I2sKt0IDoqSut4VDpV8o0f
         GXynDOlCyaZnjfMjPBhVdge9E+Wu+ZSbKsZMwKmEoYnql0qyiSGzkKEE7v9yyIWaEkw+
         u0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xtppztuQTUZZg+8iKk9a/80SqOmmIdZgmSM57UH1kdg=;
        b=S2Ncl/lPgY5XOF0fmmfK23lQNxd13AhvFItXmmQJqcMNQdT8HJS9vQy9Fk8Z+ptMlt
         18RFUIqI7vLvfG80JP2rDO66TNcZCgIgiP6vndu8yIpDAPbZC/tfbkmZ6ZrjOu9BTm7u
         iV/ZhLC69XVjor31jK+vJuheX2fXvo6MoHFHD2YHgjDPZFi4Vyzqj+UvK+V7l/j2TVFf
         FGeLNd4o4SpWMWfoVXm1e+gDh/6YZE0qr4hwLncr9zy8wWnEqMZqoVM3Sxd0E5uyR/rX
         V+LS92TngVrktEuP/JnpIxv7IzHuGaJoJ8RrX/PHVjPaG2YqJGTUZaGciuV3JvsNqgV9
         OWaQ==
X-Gm-Message-State: AOAM5320Uwnnq/LJ/9/cfan5FdGFDkd8rl7QjhjLbEJowqn2sadb7XPG
        Pjwd1Rn/K9KUdYy0x1xEVW0=
X-Google-Smtp-Source: ABdhPJz7yToafsKNspBnZLdAdPmoX5lPqieYGjsj1fsrFFb2Ixg3oxmujWYzxULtQOfx98k7LD5jcQ==
X-Received: by 2002:a9d:7116:: with SMTP id n22mr9611792otj.56.1632583540361;
        Sat, 25 Sep 2021 08:25:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id d4sm2871847oth.47.2021.09.25.08.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 08:25:39 -0700 (PDT)
Subject: Re: [PATCH] ipv6: enable net.ipv6.route sysctls in network namespace
To:     Florian Westphal <fw@strlen.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Kuznetsov <wwfq@yandex-team.ru>, netdev@vger.kernel.org,
        zeil@yandex-team.ru
References: <20210921062204.16571-1-wwfq@yandex-team.ru>
 <20210921060909.380179f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210921153203.GK15906@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <25693a6e-1919-f02d-6026-46839ea11bf7@gmail.com>
Date:   Sat, 25 Sep 2021 09:25:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210921153203.GK15906@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 9:32 AM, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
>> On Tue, 21 Sep 2021 09:22:04 +0300 Alexander Kuznetsov wrote:
>>> We want to increase route cache size in network namespace
>>> created with user namespace. Currently ipv6 route settings
>>> are disabled for non-initial network namespaces.
>>> Since routes are per network namespace it is safe
>>> to enable these sysctls.
> 
> Are routes accounted towards memcg or something like that?
> 
> Otherwise userns could start eating up memory by cranking the limit
> up to 11 and just adds a gazillion routes?
> 

Adding FIB entries I believe is now handled after commit:

commit 6126891c6d4f6f4ef50323d2020635ee255a796e
Author: Vasily Averin <vvs@virtuozzo.com>
Date:   Mon Jul 19 13:44:31 2021 +0300

    memcg: enable accounting for IP address and routing-related objects


The ip6_rt_max_size sysctl manages the number of dst entries (cached
dst's and exceptions) that can be created, and there should be some
limit that network namespace users can not exceed.
