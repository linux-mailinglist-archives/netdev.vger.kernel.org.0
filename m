Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA227A5CB
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 05:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgI1Did (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 23:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1Dic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 23:38:32 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB39C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:38:32 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mm21so2779558pjb.4
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T0Q/8SGFggsU6V883Qd01n8lDqAnY4fKNhFE0gnMqgU=;
        b=kOZm4+hGF0oJabSx9hyonCYWDUKY5a4JCdkp6ybihER76M9DsiRHJMDrNHBEZxpzMZ
         PRWA18vANBnC5xzvVaxO0RkGrAUog+QQQJI86YfMa7NyKju9MwClsVV3dRoZSN1TNAoq
         G1epQdAuEy1rGb5radJXB9KdGTBhwJDnefxHLqIQiid+WcgJnwKsRln8y5rgiI6mgvSl
         RicXd6eC7/fdBiKGVSEKLgIo8mjW1DHSjHibJJE5RyZ/PPPlYbFDPJLGlJAVBKu0mLoR
         AgC/UdeQs1kl9csIQ16exCLcUrypjHhwebYqCMyV1N7+DPdu+CQ+uNuw8JeuvtgruFBA
         GB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T0Q/8SGFggsU6V883Qd01n8lDqAnY4fKNhFE0gnMqgU=;
        b=f67kvXbljVhP3anoBfU1lgFCKAQR1mlp5P0/FVWwfr3BDSAeY+41DHdfvKOE2+zGvX
         vkfbZ46jRLADaz8nJVtvSspyhAQwvzwlsb4GCXLpSNJVMtm0F38k6f2PKY2r0BSgEzRN
         hcUvs7gEJqAMN60Ld8Cc71BTnsqnqGle8PrS25zbnE31+cpqJ1KW7imEmBjdH6w+dKsv
         VJBiW4KZmdt9TmxgqvfFyjE177BYgavM2Jpqdo2hqo92qLh26+SFaCVfrKgsAJlBLI2j
         2fYbmxZPJMbRQHbAzuudtsQTPagpMDW2cP7VSiIa0IrYY5p+bV7ja90U/1gG0NcL8lIA
         MZlg==
X-Gm-Message-State: AOAM530IH3FOR7HfQYpRWVo+4VsN06n8IsYm+JCqzSmkkayGR8P+vRSB
        RisgV6b3DoKXMGrfoYoggRI=
X-Google-Smtp-Source: ABdhPJyaVAbO+TJ6XTchI91mCpMuAVdkGXgppABuUdXkQuk28m9SO400t7ESXEZ2106QzK+boAEUWA==
X-Received: by 2002:a17:90b:4b82:: with SMTP id lr2mr7521983pjb.184.1601264310547;
        Sun, 27 Sep 2020 20:38:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id w206sm9531068pfc.1.2020.09.27.20.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2020 20:38:29 -0700 (PDT)
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Baptiste Jonglez <baptiste@bitsofnetworks.org>
Cc:     Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Vincent Bernat <bernat@debian.org>,
        Oliver <bird-o@sernet.de>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200927153552.GA471334@fedic> <20200927161031.GB471334@fedic>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <66345b05-7864-ced2-7f3c-493260be39f7@gmail.com>
Date:   Sun, 27 Sep 2020 20:38:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200927161031.GB471334@fedic>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/20 9:10 AM, Baptiste Jonglez wrote:
> On 27-09-20, Baptiste Jonglez wrote:
>> 1) failing IPv6 neighbours, what Alarig reported.  We are seeing this
>>    on a full-view BGP router with rather low amount of IPv6 traffic
>>    (around 10-20 Mbps)
> 
> Ok, I found a quick way to reproduce this issue:
> 
>     # for net in {1..9999}; do ip -6 route add 2001:db8:ffff:${net}::/64 via fe80::4242 dev lo; done
> 
> and then:
> 
>     # for net in {1..9999}; do ping -c1 2001:db8:ffff:${net}::1; done
> 
> This quickly gets to a situation where ping fails early with:
> 
>     ping: connect: Network is unreachable
> 
> At this point, IPv6 connectivity is broken.  The kernel is no longer
> replying to IPv6 neighbor solicitation from other hosts on local
> networks.
> 
> When this happens, the "fib_rt_alloc" field from /proc/net/rt6_stats
> is roughly equal to net.ipv6.route.max_size (a bit more in my tests).
> 
> Interestingly, the system appears to stay in this broken state
> indefinitely, even without trying to send new IPv6 traffic.  The
> fib_rt_alloc statistics does not decrease.
> 

fib_rt_alloc is incremented by calls to ip6_dst_alloc. Each of your
9,999 pings is to a unique address and hence causes a dst to be
allocated and the counter to be incremented. It is never decremented.
That is standard operating procedure.
