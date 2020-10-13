Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE328CE87
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgJMMlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgJMMlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 08:41:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C151C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 05:41:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b8so10642967wrn.0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 05:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pNavMPzBv1bWO2xJwWPv5IVzSCbtuf1nLt+5l6s1J/o=;
        b=QA9+6FdNmLc9+EsoJDJrBGGmTC5iiFjqGfllRgq3RGRTamRpABhV4rusN+5zqzN702
         emKaLOMbIkEo5dOVentURYS/7neEoDRtXpwAmcujjawrtqPyPRZS22zxcy3+NbtQx0lR
         +kn2x+oXtSfTVHvQw/6QXz2N0bmidJ/bA+TXQPeYwWL/uR5tWaivGgD+HFL/Dn3rphks
         YWIhIAes8IxqMFWaynEbijWYBFi2rgpRGJeWEvAoK6s+g4KZDvvos1/SfAnZGgu607XT
         1AArDT9hbjWUIb/fhAu0pDYkf5gA4xYry/I1foS4hV4WZUgfNPuhGm4VpY5g4OXUIn1z
         tvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pNavMPzBv1bWO2xJwWPv5IVzSCbtuf1nLt+5l6s1J/o=;
        b=II4c/5JwLMon3Dt17cYwatPiTTxITwa0ElAkhhnOBxI+7HRIH4bdKos5ufo2G4g3Sl
         TLHrUP6o+PGwrCqPkavUQAv/3CXD3E/G2Ak2NhoP5RODq8xyWHepTMhKh4VyY1Fb5LMq
         lDqyYMJwSgqd2w8dqliVUcFw3EjKl1b297/dLXw9dDSzkVMpM4mWdZ74o8AQVXJ/1Ur4
         kbGrdYqp0WwjqCNColOb/ugm5LAbDsiq4D9D163Iq1nEVE0PsWtUM6fijoLqHbCdOCq9
         v/TPWleD1yIHxPI7ThFuxUCpezE1Rtz0+Xn0UtTiSgndjpeOkUlLuShIONLr8AXcHile
         h0rA==
X-Gm-Message-State: AOAM533qfcoEPZa1qd4bWLDFQmO272m+l28ln3ma3X/Drkcjp35Us4b9
        3DiGk44PPWjfYLYepIIK+6hb2A==
X-Google-Smtp-Source: ABdhPJxMq5zb0ocLPTn93Nm0G/M+mG3D5usUkfrCZOqEX0hKVywgbdmx0FDxg6OZ3G5AU4BxISpXXQ==
X-Received: by 2002:adf:f4d2:: with SMTP id h18mr30712574wrp.99.1602592880111;
        Tue, 13 Oct 2020 05:41:20 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:b907:592:b05a:33d2? ([2a01:e0a:410:bb00:b907:592:b05a:33d2])
        by smtp.gmail.com with ESMTPSA id x64sm27005735wmg.33.2020.10.13.05.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 05:41:19 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: interface: fix the priorities for ipip and
 ipv6 tunnels
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <99c1ec6ed0212992474d19f4e15ef5d077fe99b3.1602144804.git.lucien.xin@gmail.com>
 <20201013092856.GU20687@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <df21f95b-f3eb-d853-49a6-e68b3830f566@6wind.com>
Date:   Tue, 13 Oct 2020 14:41:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201013092856.GU20687@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/10/2020 à 11:28, Steffen Klassert a écrit :
> On Thu, Oct 08, 2020 at 04:13:24PM +0800, Xin Long wrote:
>> As Nicolas noticed in his case, when xfrm_interface module is installed
>> the standard IP tunnels will break in receiving packets.
>>
>> This is caused by the IP tunnel handlers with a higher priority in xfrm
>> interface processing incoming packets by xfrm_input(), which would drop
>> the packets and return 0 instead when anything wrong happens.
>>
>> Rather than changing xfrm_input(), this patch is to adjust the priority
>> for the IP tunnel handlers in xfrm interface, so that the packets would
>> go to xfrmi's later than the others', as the others' would not drop the
>> packets when the handlers couldn't process them.
>>
>> Note that IPCOMP also defines its own IPIP tunnel handler and it calls
>> xfrm_input() as well, so we must make its priority lower than xfrmi's,
>> which means having xfrmi loaded would still break IPCOMP. We may seek
>> another way to fix it in xfrm_input() in the future.
>>
>> Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
>> FIxes: d7b360c2869f ("xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler")
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> Applied, thanks a lot Xin!
> 
Is it possible to queue this for stable branches?


Thank you,
Nicolas
