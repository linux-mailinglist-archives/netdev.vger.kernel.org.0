Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C622AF43E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKKO6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgKKO6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:58:50 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94961C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:58:50 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id x11so1291504vsx.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ymEvgJS7rVbY5xVZhevn94lQHneRjvkfCvwDRO8xie0=;
        b=ZghKI3QiRUOD7epvEcjCkm2x5OmXbfdOwP07/1zFHYgFbUDsISeOqY6HnA61S4QxSj
         qW64wt7QdXHCxCNqVBrKtlK4rO3Opip0/x/SVNA38DsiPdv6xzPytjwCaNi7vGs52ANU
         a4jcMS/reMNkJKvttl1hXcWrHGek4sZG2KWwV+DL6OlZM2rdgaCqrrhGowDyOiEf3AcH
         ifSNQhvqrmoXaTGeiWSyhA0TVNY1MBiVbMuDldlTDloEQVFcdlzQM+fIzSIwt7NDC9rQ
         ht9CY+dKjPm2+WWdyLOynPYwu144U1u07WhT1gZ+jLACW8VPSbm6U65jbtSiLkXc0zVI
         lrMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ymEvgJS7rVbY5xVZhevn94lQHneRjvkfCvwDRO8xie0=;
        b=AVtaLFLe1QdieSMJDBC5WuKa2On/pObGahnmNtKCRA6bU00ObPsRH//M+86Qb9ltsF
         rXFYfLDSb5QX6R79KEnFG1D7j/2krNl766SrKrnOUJGQZmtcR2PXp29wfoTvn8+iGuG5
         y7YkZ8hNGMMTWXJEB8e8XT0ML0XmGQlTFlYXbDysu+8p5K4CYsKTnPVPzAMcswCV2thb
         EVWkPg78q89X5P3100hZzJKWqQz5CcoHBXMr7jKyJh1U3yubPnMUMIyBU6+q8GV6utvU
         y5ijXVtW29ZIKTZLBoTWQPN8tHSHa6NhQYU3dpfQFcrpZAMTcceY0PX4G9DN05MVJ2E+
         Gzew==
X-Gm-Message-State: AOAM5301ySMx5u5SCXnZ50mfqsZxCG9V6OnSt+/0zJ7hw8ALNs2hS0PD
        8bv8dQz8Ii1HTGJDR9XVJiKxMkM/EA8=
X-Google-Smtp-Source: ABdhPJzCu4vwJEhOsz4bSkpmOM5BX7Xp7kMKlmyffsFueBDXdtqvzE2tSdTOgBsWZJPNkcrKk1QiuA==
X-Received: by 2002:a05:6102:21c6:: with SMTP id r6mr14800806vsg.0.1605106729423;
        Wed, 11 Nov 2020 06:58:49 -0800 (PST)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com. [209.85.221.173])
        by smtp.gmail.com with ESMTPSA id 36sm203275uam.16.2020.11.11.06.58.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 06:58:48 -0800 (PST)
Received: by mail-vk1-f173.google.com with SMTP id v5so535330vkn.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:58:48 -0800 (PST)
X-Received: by 2002:a1f:6dc4:: with SMTP id i187mr10642006vkc.12.1605106727755;
 Wed, 11 Nov 2020 06:58:47 -0800 (PST)
MIME-Version: 1.0
References: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch>
 <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com> <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch>
In-Reply-To: <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 11 Nov 2020 09:58:10 -0500
X-Gmail-Original-Message-ID: <CA+FuTScQ0nZH-eaBr0Rn0PXVhjoW7xPBFeRiPXh6FeDAZ+DYwA@mail.gmail.com>
Message-ID: <CA+FuTScQ0nZH-eaBr0Rn0PXVhjoW7xPBFeRiPXh6FeDAZ+DYwA@mail.gmail.com>
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 6:29 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Tue, 10 Nov 2020 13:49:56 -0500
>
> > On Mon, Nov 9, 2020 at 7:29 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >>
> >> From: Alexander Lobakin <alobakin@pm.me>
> >> Date: Tue, 10 Nov 2020 00:17:18 +0000
> >>
> >>> While testing UDP GSO fraglists forwarding through driver that uses
> >>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> >>> iperf packets:
> >>>
> >>> [ ID] Interval           Transfer     Bitrate         Jitter
> >>> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
> >>>
> >>> Simple switch to napi_gro_receive() or any other method without frag0
> >>> shortcut completely resolved them.
> >>>
> >>> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
> >>> callback. While it's probably OK for non-frag0 paths (when all
> >>> headers or even the entire frame are already in skb->data), this
> >>> inline points to junk when using Fast GRO (napi_gro_frags() or
> >>> napi_gro_receive() with only Ethernet header in skb->data and all
> >>> the rest in shinfo->frags) and breaks GRO packet compilation and
> >>> the packet flow itself.
> >>> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> >>> are typically used. UDP even has an inline helper that makes use of
> >>> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> >>> to get rid of the out-of-order delivers.
> >>>
> >>> Present since the introduction of plain UDP GRO in 5.0-rc1.
> >>>
> >>> Since v3 [1]:
> >>>  - restore the original {,__}udp{4,6}_lib_lookup_skb() and use
> >>>    private versions of them inside GRO code (Willem).
> >>
> >> Note: this doesn't cover a support for nested tunnels as it's out of
> >> the subject and requires more invasive changes. It will be handled
> >> separately in net-next series.
> >
> > Thanks for looking into that.
>
> Thank you (and Eric) for all your comments and reviews :)
>
> > In that case, should the p->data + off change be deferred to that,
> > too? It adds some risk unrelated to the bug fix.
>
> Change to p->data + off is absolutely safe and even can prevent from
> any other potentional problems with Fast/frag0 GRO of UDP fraglists.
> I find them pretty fragile currently.

Especially for fixes that go to net and eventually stable branches,
I'm in favor of the smallest possible change, minimizing odds of
unintended side effects.

Skipping this would also avoid the int to u32 change.

But admittedly at some point it is a matter of preference. Overall
makes sense to me. Thanks for the fix!

Acked-by: Willem de Bruijn <willemb@google.com>
