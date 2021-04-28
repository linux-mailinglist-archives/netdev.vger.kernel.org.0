Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF39F36D724
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhD1MVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhD1MVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 08:21:10 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C970C061574
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 05:20:26 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id p202so29926920ybg.8
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 05:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7XZs9DcYI/T9rdDPt94265Oxt5ZBbgW/2qZ6z6xTpM=;
        b=CEkBEPMHrdABZrnuf7AE2InumYypBr3mI8elHoox7BBM7lK1M2ZE3821VX/WmwAyR0
         xKIP7pVKo65pI+iKroWpZjR8NST//GKIdGFX8TGAeAEp+Wxwn1D+10RuYVdsrKFYrX3p
         U1enszbokwetwEBKVAs0uqh+bU7sCrR9/wo62/BWTDUbZPhrBjHqxQTc4Rj21pXs0I5Z
         wb5SNlN3Jzc4OAE2tIiGOJNvj16r5JWklb+SeGdp7yuQ5g0rZAVk3VMbZTu7HCtnwHvW
         GwtqcwDNinAabezN0r7+SN/eUyqcbsXvTQCH0on1pm22vU1ywdD5kMwnNHujpxQpVIbl
         oN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7XZs9DcYI/T9rdDPt94265Oxt5ZBbgW/2qZ6z6xTpM=;
        b=GE07ewl0sQiQd8tkjEOLcsRAN9qk9Z89rguUm201VWVYAIX4MEF/sGLKhmmgfPTl88
         VOOrxJvIKHBNbAmMsHyux5xLxvCTHs9SPrwoUGlIpUrfJJG9oGmD+QYQt9JctJoOYMRY
         ENvVI3zViGGOByN77lR0KqfXhxEETvK/GQ/lNuCYQJuK1iNPTA5gl7gxpTTz4C4wNrYp
         1JE6op5D1+DdZGwlaLuB7OhsXAN1d5hsnHKVgDbMEGMsJ0H2eQwIaqBFOvkbAYECqCsJ
         0HCtqQV1Lz08LPMsZAE7BQnHEAZGvV8ohE0N3oXHlNwkSHh5jfroTnoDeeD/nHh0xocd
         njjg==
X-Gm-Message-State: AOAM533g6SEu0OnGpUzrjzSOkmIpjKT7+vzMFT50T6j7Xzx+IlfyhO/S
        JbT19d84cmp4nC30J+lP8fS4d3AUFvlpC9B97TaWmA==
X-Google-Smtp-Source: ABdhPJwitFA9cFv7ugcVj+ew8kIkuAR2BL10OA0+lSScZgEDV6kESTGH5iOoLOUYMgpzypbbn8On1YjNdt5t89SnOC8=
X-Received: by 2002:a5b:906:: with SMTP id a6mr31660607ybq.446.1619612424901;
 Wed, 28 Apr 2021 05:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
In-Reply-To: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Apr 2021 14:20:13 +0200
Message-ID: <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 4:29 AM Matt Corallo
<netdev-list@mattcorallo.com> wrote:
>
> The default IP reassembly timeout of 30 seconds predates git
> history (and cursory web searches turn up nothing related to it).
> The only relevant source cited in net/ipv4/ip_fragment.c is RFC
> 791 defining IPv4 in 1981. RFC 791 suggests allowing the timer to
> increase on the receipt of each fragment (which Linux deliberately
> does not do), with a default timeout for each fragment of 15
> seconds. It suggests 15s to cap a 10Kb/s flow to a 150Kb buffer of
> fragments.
>
> When Linux receives a fragment, if the total memory used for the
> fragment reassembly buffer (across all senders) exceeds
> net.ipv4.ipfrag_high_thresh (or the equivalent for IPv6), it
> silently drops all future fragments fragments until the timers on
> the original expire.
>
> All the way in 2021, these numbers feel almost comical. The default
> buffer size for fragmentation reassembly is hard-coded at 4MiB as
> `net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;` capping a host at
> 1.06Mb/s of lost fragments before all fragments received on the
> host are dropped (with independent limits for IPv6).
>
> At 1.06Mb/s of lost fragments, we move from DoS attack threshold to
> real-world scenarios - at moderate loss rates on consumer networks
> today its fairly easy to hit this, causing end hosts with their MTU
> (mis-)configured to fragment to have nearly 10-20 second blocks of
> 100% packet loss.
>
> Reducing the default fragment timeout to 1sec gives us 32Mb/s of
> fragments before we drop all fragments, which is certainly more in
> line with today's network speeds than 1.06Mb/s, though an optimal
> value may be still lower. Sadly, reducing it further requires a
> change to the sysctl interface, as net.ipv4.ipfrag_time is only
> specified in seconds.
> ---
>   include/net/ip.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 2d6b985d11cc..f1473ac5a27c 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -135,7 +135,7 @@ struct ip_ra_chain {
>   #define IP_MF        0x2000        /* Flag: "More Fragments"    */
>   #define IP_OFFSET    0x1FFF        /* "Fragment Offset" part    */
>
> -#define IP_FRAG_TIME    (30 * HZ)        /* fragment lifetime    */
> +#define IP_FRAG_TIME    (1 * HZ)        /* fragment lifetime    */
>
>   struct msghdr;
>   struct net_device;
> --
> 2.30.2


This is going to break many use cases.

I can certainly say that in many cases, we need more than 1 second to
complete reassembly.
Some Internet users share satellite links with 600 ms RTT, not
everybody has fiber links in 2021.

There is a sysctl, exactly for the cases where admins can decide to
make the value smaller.

You can laugh all you want, the sad thing with IP frags is that really
some applications still want to use them.

Also, admins willing to use 400 MB of memory instead of 4MB can just
change a sysctl.

Again, nothing will prevent reassembly units to be DDOS targets.

At Google, we use 100 MB for /proc/sys/net/ipv4/ipfrag_high_thresh and
/proc/sys/net/ipv6/ip6frag_high_thresh,
no kernel patch is needed.
