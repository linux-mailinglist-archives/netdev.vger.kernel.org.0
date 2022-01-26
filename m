Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229B449D389
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiAZUfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiAZUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:35:31 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BEFC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:35:30 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bb37so1948509oib.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KHglc5vJkbnm28HgY1xpUb2xhX1VfY+rqpwXpuulm4Y=;
        b=Cjj6Nnzq1u5qn7wiHjPFI2d+KJQwz0c3ySIw8G0F1hDx6df/Uplw8yyRypVphh5ASY
         fojAadqCvPF8wFv8lPKChfojeLAms23b0CWkrM4ajLp65VMDf/727fXYWQNg/XLtOx/t
         dyIG37mgh6gjpDi5rtRKyT1xDWdwCSOzNqGrhtHOkA6C2TeN/lx9BOytrzGZEUYTToMD
         lnReDA3Kb1k1h/YFFGno+5VCKKxDfEO4cVlivrPP0yvtsfxU9y/P7jz/cvLcDw7J5bEe
         4/48Fwsi+CPGKq/gbgK8+b3ZtC2+BukHEGtO3EggqsJ2caHjKBhXvkJvvj+MZS6uYUST
         l+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KHglc5vJkbnm28HgY1xpUb2xhX1VfY+rqpwXpuulm4Y=;
        b=yI+/GA1XiKo6yVWanWYgWhEe2KcAqmJ8W8VUWF3LgwIWX0Tvf8Jglj3jteptNvRmdG
         IHtfsLm75x7C7n3wrt3a6DmdYEVcYIgFpDjWMKITSxInx8Io5vrBq4WPe2B9qTc/12kk
         nffDSXlcZMk1qJV42UEIdPxX9lZ2NrVRccffg0Qt6kWzFVwSBsQJgICA0/bFG+98oXcF
         MnYiuTS62Aw+Z1vpChE30CiDd68+8Y9TkhCPzUtwvfNvUuswKJ/BQ6P7W8Zlq+xZm2a9
         v1IIsXgiLqkhfJsmeIVGh0XGw0Bo8EW79AOvuv2S0n6GNGO2qxtfInBLh6Mlq3VmmA42
         vCug==
X-Gm-Message-State: AOAM531jrlI7wIBqe8z8dUdrlwQxubWcgip2cIOZZuKYMQmcAyK9s0oe
        9vJ9u55x+WXnxINr41WITyE=
X-Google-Smtp-Source: ABdhPJw/Dz49TmbA+6LNNlTGeIBcOxPK/Qelp5pAzd+E8Kw8x9eCZ556XV/uIKrJ7MgplpMd/mmCAA==
X-Received: by 2002:a05:6808:1283:: with SMTP id a3mr240936oiw.150.1643229330386;
        Wed, 26 Jan 2022 12:35:30 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id l18sm9909450otv.49.2022.01.26.12.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 12:35:30 -0800 (PST)
Message-ID: <66b70cba-b9e7-8fb1-df65-2d3f14ac2ae7@gmail.com>
Date:   Wed, 26 Jan 2022 13:35:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net 1/2] ipv4: tcp: send zero IPID in SYNACK messages
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ray Che <xijiache@gmail.com>,
        Geoff Alexander <alexandg@cs.unm.edu>, Willy Tarreau <w@1wt.eu>
References: <20220126200518.990670-1-eric.dumazet@gmail.com>
 <20220126200518.990670-2-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220126200518.990670-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 1:05 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In commit 431280eebed9 ("ipv4: tcp: send zero IPID for RST and
> ACK sent in SYN-RECV and TIME-WAIT state") we took care of some
> ctl packets sent by TCP.
> 
> It turns out we need to use a similar strategy for SYNACK packets.
> 
> By default, they carry IP_DF and IPID==0, but there are ways
> to ask them to use the hashed IP ident generator and thus
> be used to build off-path attacks.
> (Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)
> 
> One of this way is to force (before listener is started)
> echo 1 >/proc/sys/net/ipv4/ip_no_pmtu_disc
> 
> Another way is using forged ICMP ICMP_FRAG_NEEDED
> with a very small MTU (like 68) to force a false return from
> ip_dont_fragment()
> 
> In this patch, ip_build_and_send_pkt() uses the following
> heuristics.
> 
> 1) Most SYNACK packets are smaller than IPV4_MIN_MTU and therefore
> can use IP_DF regardless of the listener or route pmtu setting.
> 
> 2) In case the SYNACK packet is bigger than IPV4_MIN_MTU,
> we use prandom_u32() generator instead of the IPv4 hashed ident one.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Ray Che <xijiache@gmail.com>
> Cc: Geoff Alexander <alexandg@cs.unm.edu>
> Cc: Willy Tarreau <w@1wt.eu>
> ---
>  net/ipv4/ip_output.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

