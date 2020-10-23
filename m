Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFF329717F
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750717AbgJWOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750695AbgJWOkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:40:33 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0401C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:40:33 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z5so2082477iob.1
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dlTssvod3NAwaQ0KWaXjtNtlgF0fVCEX/2+CUR1FppY=;
        b=iDr+PF16qJ/reAbhoG2/I18EzZf5qDYnYqw0dXe1Exf39y6YrNquhG5JQ0aBo4hIpO
         T82nrfEdGzV/wg6hrxcSlWJsYnMcgr3ruDIzE0FdrUmK3XdER6WrEz88/OjTBOgG4bIz
         tszjKBQvwXIiyyJHyL116cDA9iETMPW4hu+7KgVS7Bb7sbYVSLL6eL2kBiFI3LUzjMur
         yZw2UqRxQsHcI7s5yLxcFpHTxEO51Co/RbsbrxAoC0ImV4xccInAnGWmMjgULSzgXCZc
         EXy/wA49pL8O0W8LKAIpC8zmYRXhKJ4CrIQWEENmWwcHK8gcAF/4T+kPixagmSlqPRL4
         vjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dlTssvod3NAwaQ0KWaXjtNtlgF0fVCEX/2+CUR1FppY=;
        b=bhveJLcbW6q4+TALVeBB52hg/ZarmTzsAylFfl20OgzKxpi7XHBN+0C2CwQQ7s1q8i
         oyWhQLOVAYTB3TaOyd6dpj2BpKGdKEqQPDnIcR6werO2Pfatm8DpX9srg6kQXK42detY
         I3NazL9pEjQKZx3SfI1Cv9ue6a7LtrtcuFCOoaQcIMBvgkF4TjrB21vaytWrjiHcPPKR
         0WDug+GcvSopRBSJxqNip/7GhKfm8cBTHaHdNBl5r7V8ChmH7NA80/jGq3L6bNCGZiVg
         0D2nsxNF8IdhrWzbj/HrCycdhqbChXLpj5Nmn4FuLXdoUJ3XoKS5bSfGQ3oZPz0Qu4SU
         aaQg==
X-Gm-Message-State: AOAM5310T+tba+tYx4cIZQofsr0gda6TdyloZENwJYGbeLt+NoCtuevZ
        qsmR+0tGU08H/MBjENkmMBWAbojmMa0=
X-Google-Smtp-Source: ABdhPJy51i5XSqYnpraFFo3vaU6nEJb1h/1gJptXmeiTrFkYKv7G/yDYvxxG3/HKCRLfGcjmfm3BYw==
X-Received: by 2002:a02:c85a:: with SMTP id r26mr2077429jao.99.1603464033138;
        Fri, 23 Oct 2020 07:40:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6052:3bc7:efe9:3aec])
        by smtp.googlemail.com with ESMTPSA id i82sm1044952ill.84.2020.10.23.07.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 07:40:32 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for
 non-root users
To:     Vincent Bernat <vincent@bernat.ch>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Laurent Fasnacht <fasnacht@protonmail.ch>
References: <20200331132009.1306283-1-vincent@bernat.ch>
 <20200402.174735.1088204254915987225.davem@davemloft.net>
 <m37drhs1jn.fsf@bernat.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ac5341e0-2ed7-2cfb-ec96-5e063fca9598@gmail.com>
Date:   Fri, 23 Oct 2020 08:40:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <m37drhs1jn.fsf@bernat.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/20 4:02 AM, Vincent Bernat wrote:
>  ❦  2 avril 2020 17:47 -07, David Miller:
> 
>>> Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
>>> non-root user to bind a socket to an interface if it is not already
>>> bound.
>>  ...
>>
>> Ok I'm convinced now, thanks for your patience.
> 
> I've got some user feedback about this patch. I didn't think the patch
> would allow to circumvent routing policies on most common setups, but
> VPN may setup a default route with a lower metric and an application may
> (on purpose or by accident) use SO_BINDTODEVICE to circumvent the lower
> metric route:
> 
> default via 10.81.0.1 dev tun0 proto static metric 50
> default via 192.168.122.1 dev enp1s0 proto dhcp metric 100

I thought we discussed this at the time you submitted your patch. That
was a known issue then, so nothing has really changed. Again, this patch
just brings equivalence to TCP for capabilities in UDP and raw sockets.

> 
> I am wondering if we should revert the patch for 5.10 while we can,
> waiting for a better solution (and breaking people relying on the new
> behavior in 5.9).
> 
> Then, I can propose a patch with a sysctl to avoid breaking existing
> setups.
> 

I have not walked the details, but it seems like a security policy can
be installed to get the previous behavior.
