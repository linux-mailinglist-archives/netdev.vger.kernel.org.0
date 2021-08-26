Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC363F8B17
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242925AbhHZPem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhHZPel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:34:41 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADA8C0613C1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:33:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b6so5697112wrh.10
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NKQHjgSXACuCK3NartetwamP6Lz6Q0ZQdPM75F6K/sA=;
        b=BsPy/aEQQJl6mCtUnSjzipauNbVbyrICBnxni56sSlSLny4uMl22ew/PxBEcgAtOWQ
         lD8DZDnBTy5jDhxDm0lALevVJVUQ8M/BvmpX6ni+3tEmROVECFmUwrl6BKTMIT69snUI
         6Pa4CwXmxoLl1I1Wm3t2Kqfv578msIWxINeawef7CFTWFdJhffy/9kUedp2x4Si/tD6h
         IUEIY73NGJA2uP6v6ZBNHY8hIWpXBuzIR/mxalxmdN8eUVJJXGvUg5pyue1o7dQ1nYqw
         idWH027gzJ6DYFI5ggkgiDIOmeIIe7m+8qro1azXtvpTJzPpKh2B/NeqSIYGCMvhQAxP
         chzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NKQHjgSXACuCK3NartetwamP6Lz6Q0ZQdPM75F6K/sA=;
        b=Me9cfLGWS7hcQoHWxX+TdpRq1nUwuXRT7QZLYSmPVMqFcnTQMUz1gpA1oA4Trqes9S
         ZJraFdnPGs/2N3Z8yTAEjbVj5qgFQfFpkiViNN/Q86CdjklsYwb9bq62BWsTdzLgePqQ
         mg6iRmiffvaiGaVJxEo8C95N6grTY7NOFdX5xtyOIzuPO67DM0Tgi8jUkiutkoRsaFGv
         hSZVxeTkiIiBZrBhNaV+nzjl9e4ARVHIjm+PUU3V19G4Aa7CVrNiApelpWpFONe9JCAM
         jtph1Np1M8aNgEKz32SdKu2eCpNSruBMqWmLeKM6hbZkMEm0I5hplYAMIKRZM/1C99ys
         jk7g==
X-Gm-Message-State: AOAM533KOCVWFdqHpmYq6bAR84Tsfog1uxb2RVKAZC95gScNsXXJ5jeS
        PEp9jgpGHVYu8QCfEzClCVk3hw==
X-Google-Smtp-Source: ABdhPJwviO8Zl8nXZ/dv4J73hcfS4RWHUl8cGWNJtqHW2e/sfCyQN02D5z/L0MUqgazclAUB3Ls72A==
X-Received: by 2002:a5d:508e:: with SMTP id a14mr4798042wrt.306.1629992032726;
        Thu, 26 Aug 2021 08:33:52 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:9871:c4a8:efb1:30ac? ([2a01:e0a:410:bb00:9871:c4a8:efb1:30ac])
        by smtp.gmail.com with ESMTPSA id n15sm7892426wmq.7.2021.08.26.08.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 08:33:52 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, edumazet@google.com
References: <20210826140150.19920-1-justin.iurman@uliege.be>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com>
Date:   Thu, 26 Aug 2021 17:33:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210826140150.19920-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/08/2021 à 16:01, Justin Iurman a écrit :
> Nowadays, there are more and more private domains where a lot of ingresses and
> egresses must be linked altogether. Configuring each possible tunnel explicitly
> could quickly become a nightmare in such use case. Therefore, introducing
> support for ip6ip6 decapsulation without an explicit tunnel configuration looks
> like the best solution (e.g., for IOAM). For now, this patch only adds support
> for ip6ip6 decap, but ip6ip4 could probably be added too if needed.
> 
> Last year, we had an interesting discussion [1] with Tom about this topic, and
> especially on how such solution could be implemented in a more generic way. Here
> is the summary of the thread.
> 
> Tom said:
> "This is just IP in IP encapsulation that happens to be terminated at
> an egress node of the IOAM domain. The fact that it's IOAM isn't
> germaine, this IP in IP is done in a variety of ways. We should be
> using the normal protocol handler for NEXTHDR_IPV6  instead of special
> case code."
> 
> He also said:
> "The current implementation might not be what you're looking for since
> ip6ip6 wants a tunnel configured. What we really want is more like
> anonymous decapsulation, that is just decap the ip6ip6 packet and
> resubmit the packet into the stack (this is what you patch is doing).
> The idea has been kicked around before, especially in the use case
> where we're tunneling across a domain and there could be hundreds of
> such tunnels to some device. I think it's generally okay to do this,
> although someone might raise security concerns since it sort of
> obfuscates the "real packet". Probably makes sense to have a sysctl to
> enable this and probably could default to on. Of course, if we do this
> the next question is should we also implement anonymous decapsulation
> for 44,64,46 tunnels."
> 
> Based on the above, here is a generic solution to introduce anonymous tunnels
> for IPv6. We know that the tunnel6 module is, when loaded, already responsible
> for handling IPPROTO_IPV6 from an IPv6 context (= ip6ip6). Therefore, when
> tunnel6 is loaded, it handles ip6ip6 with its tunnel6_rcv handler. Inside the
> handler, we add a check for anonymous tunnel decapsulation and, if enabled,
> perform the decap. When tunnel6 is unloaded, it gives the responsability back to
> tunnel6_anonymous and its own handler. Note that the introduced sysctl to
> enable anonymous decapsulation is equal to 0 (= disabled) by default. Indeed,
> as opposed to what Tom suggested, I think it should be disabled by default in
> order to make sure that users won't have it enabled without knowing it (for
> security reasons, obviously).
> 
> Thoughts?
I'm not sure to understand why the current code isn't enough. The fallback
tunnels created by legacy IP tunnels drivers are able to receive and decapsulate
any encapsulated packets.
I made a quick try with an ip6 tunnel and it works perfectly:

host1 -- router1 -- router2 -- host2

A ping is done from host1 to host2. router1 is configured with a standard ip6
tunnel and screenshots are done on router2:

$ modprobe ip6_tunnel
$ ip l s ip6tnl0 up
$ tcpdump -ni ip6tnl0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ip6tnl0, link-type LINUX_SLL (Linux cooked), capture size 262144 bytes
17:22:22.749246 IP6 fd00:100::1 > fd00:200::1: ICMP6, echo request, seq 0, length 64

And a tcpdump on the link interface:
$ tcpdump -ni ntfp2
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ntfp2, link-type EN10MB (Ethernet), capture size 262144 bytes
17:23:41.587252 IP6 fd00:125::1 > fd00:125::2: IP6 fd00:100::1 > fd00:200::1:
ICMP6, echo request, seq 0, length 64
17:23:41.589291 IP6 fd00:200::1 > fd00:100::1: ICMP6, echo reply, seq 0, length 64

$ ip -d a l dev ip6tnl0
6: ip6tnl0@NONE: <NOARP,UP,LOWER_UP> mtu 1452 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/tunnel6 :: brd :: promiscuity 0 minmtu 68 maxmtu 65407
    ip6tnl ip6ip6 remote any local any hoplimit inherit encaplimit 0 tclass 0x00
flowlabel 0x00000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
    inet6 fe80::b47d:abff:feac:ec09/64 scope link
       valid_lft forever preferred_lft forever

Am I missing something?


Regards,
Nicolas

> 
> Some feedback would be really appreciated, specifically on these points:
>  - Should the anonymous decapsulation happen before (as it is right now) or
>    after tunnel6 handlers? "Before" looks like the most logical solution as,
>    even if you configure a tunnel and enable anonymous decap, the latter will
>    take precedence.
>  - Any comments on the choice of the sysctl name ("tunnel66_decap_enabled")?
>  - Any comments on the patch in general?
> 
> [1] https://lore.kernel.org/netdev/CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com
