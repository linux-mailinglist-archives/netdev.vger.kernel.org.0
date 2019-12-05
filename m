Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DBA113D5D
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfLEIw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 03:52:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34008 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfLEIwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 03:52:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so2494775wrr.1
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 00:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54Oo8O+WoSdE+d9b0d6Cj6WIDzkBm0gBFOBZzeQ6IFs=;
        b=GKEvClM6ybxBjnJCBRWqnA/jgDJitgM+qdEmZaoIOwYkvxQVG4KzhvgYMK16qyfWD4
         cYlk1drvgFdhNL6tSk+XCyLiU8N4NEUzIaKgiabChLoDvgcoeTGHNDHV0xL898xTBALK
         TA642pJh6bYVHlCMgZjn4tvmgR7vpmxBPgHNhnU2i+nAI8d/w8Fvcfd6GndQdoXSTDKy
         8Fw3C41xqfp5J+/S5Pd+j/N1FRdqwAZaFTynzh1oFCcr3Qfp1alPCQMxI0bhoxeJ7Mb2
         P/cwOPvXRlWu3cwc5hj/Go62QDggoz+66o2+VYJgSrJ/goLdpvIACUr169Y53MQkaZy0
         aR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=54Oo8O+WoSdE+d9b0d6Cj6WIDzkBm0gBFOBZzeQ6IFs=;
        b=Eiw/vO5Y54tgmC/QgMyNCM86/2u4scPggEvm5IoAT6ehfhGdZkDlMKUizbn1rdtoOo
         hR5Lk2EdESkT07tls1tbvPt7hdfBYOfH2sMsfh3tS5PsF7eiibEBclB73acp4T2dstUk
         2xpXbuKzz60YI8ythknL9A9GI99gfwhN3cgMob36+aTk1TDFWx8wl6Hco47t0EKzFuc9
         uqGduduixA7lOcw6GTjRoK5DasTHLtLZpOHnOeviFztTjFYtx1FK24BuuLhTGw8pk3CY
         5oabzbK/LXwN/71VjSF0oYkfnikaX8Ex9cSSee6S5S0Kow7+25+5pqlxYUixYVHnwEBl
         SwBg==
X-Gm-Message-State: APjAAAWaaLnHdZN2q4U4IyRcJeCcE8HoaEZkF0Z7dgMhzJwUu9Kpqn64
        VvWhsPAraIjJzOQnGhgOYHKyGg==
X-Google-Smtp-Source: APXvYqxclD5NMbvrJZjJpaLu0mvDfpFR9nDrsF3OU+jmiZn5s02FbJsFaicL5uBojc3TWvQqTJvJlA==
X-Received: by 2002:adf:e2cc:: with SMTP id d12mr8383292wrj.168.1575535943214;
        Thu, 05 Dec 2019 00:52:23 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:1153:c308:9cc8:f584? ([2a01:e0a:410:bb00:1153:c308:9cc8:f584])
        by smtp.gmail.com with ESMTPSA id s16sm11480936wrn.78.2019.12.05.00.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 00:52:22 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: check DST_NOPOLICY as well as DST_NOXFRM
To:     Mark Gillott <mgillott@vyatta.att-mail.com>, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
References: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
 <5a033c2e-dbf3-426a-007c-e7eec85fc3a6@6wind.com>
 <9a0813f2446b0423963d871795e34b3fe99e301d.camel@vyatta.att-mail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c050dc8c-eb17-7195-51ed-18de0a270f5b@6wind.com>
Date:   Thu, 5 Dec 2019 09:52:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <9a0813f2446b0423963d871795e34b3fe99e301d.camel@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/12/2019 à 09:10, Mark Gillott a écrit :
> On Wed, 2019-12-04 at 17:57 +0100, Nicolas Dichtel wrote:
>> Le 04/12/2019 à 16:17, Mark Gillott a écrit :
>>> Before performing a policy bundle lookup, check the DST_NOPOLICY
>>> option, as well as DST_NOXFRM. That is, skip further processing if
>>> either of the disable_policy or disable_xfrm sysctl attributes are
>>> set.
>>
>> Can you elaborate why this change is needed?
> 
> We have a separate DPDK-based dataplane that is responsible for all
> IPsec processing - policy handing/encryption/decryption. Consequently
> we set the net.ipv[4|6].conf.<if>.disable_policy sysctl to 1 for all
> "interesting" interfaces. That is we want the kernel to ignore any
> IPsec policies.
> 
> Despite the above & depending on configuration, we found that
> originating traffic was ending up deep inside XFRM where it would get
> dropped because of a route lookup problem.
And why don't you set disable_xfrm to thoses interfaces also?
disable_policy means no xfrm policy lookup on output, disable_xfrm means no xfrm
policy check on input.

Nicolas
