Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F51F644D70
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLFUrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLFUrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:47:06 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9538143855
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:47:05 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id o12so11299677qvn.3
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 12:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kP7xsKdbsJnV7eX2PXYmKBHDGfp9CdWlKUxOxjYqK+g=;
        b=SINTljCj2a/781y8cx4VnSpHr6ZUCL9KGB3ZlHV29Mzrd9PCyVX208Cfa1B5SYBg1m
         uP22A06j5sPP6i5b7+F0JUBb6URj1Fj5P7kKGxMP6U8wHVgknputMX+ZLB0mT8vQMWAA
         6GdbJHuCLNHP8VhS0YISLnlYpuEb0kvjZj8KHQOkv3NtV3vaIaoaD15CAU21KQbDChFg
         TIJ2gO+gxU3TyE06nLh1gtwyONBQOGJFn0+q80aeeN4aN0tqwBHGptgLKNgtx8s2YBMv
         tbX/6hozpmVkMhTHDkXBlpJbAWguGV2AXnTiRSei5ByF28PP1i5L7ie2CEDFaP4oktc0
         gLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kP7xsKdbsJnV7eX2PXYmKBHDGfp9CdWlKUxOxjYqK+g=;
        b=RyZEigQlYMk00q+wzqbaN/X0Ju33wBJvscBJeF2cEIW7YEgov4ynnbAzTLiBzdUdAk
         T/lNKjrGp57MO5BqlRuxP7Kk7DkQRBpuMia//PEq06EAXlhMR/QADQ6ir+Bc0leJwDCA
         5UbDgO0vKSZv+LitXLb60tDHUVS+hY+RXrrNgPZgwLGsA5cq5vDA0AhHCjFDS9KcvNIm
         tI4duUHggPzrOFfLnBJ/a2mdvqgi8xqox20aHk5P/HKnL50OOWT2BlQ5RaFRZqruV3H1
         jZHRD9I2Mq9jFGjoayFa7iraOoj/tTojxeFVV0XvqSaFadtxDapvnFXW1MNVT0Ew1ko3
         gZDQ==
X-Gm-Message-State: ANoB5pmpPj2BVwrYaQcVRYQyaWDbiE/cmD0vAp6E497gC54+L7yc8zF3
        vQc5E3GBq7Oh+HAzfKImy54LI46DyJU=
X-Google-Smtp-Source: AA0mqf64yi4UHOFuwI1Cj5aCEjPFHGjhpWsteArzxnvmv5/fYbj6ntkf4O1Housve7UFjqwr28Qbcg==
X-Received: by 2002:a0c:90f1:0:b0:4b1:8788:21ff with SMTP id p104-20020a0c90f1000000b004b1878821ffmr83286773qvp.16.1670359624653;
        Tue, 06 Dec 2022 12:47:04 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id r26-20020ac867da000000b003a5689134afsm12298577qtp.36.2022.12.06.12.47.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 12:47:04 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id c140so20123538ybf.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 12:47:03 -0800 (PST)
X-Received: by 2002:a25:e6ce:0:b0:703:e000:287 with SMTP id
 d197-20020a25e6ce000000b00703e0000287mr3301148ybh.171.1670359623589; Tue, 06
 Dec 2022 12:47:03 -0800 (PST)
MIME-Version: 1.0
References: <20221205230925.3002558-1-willemdebruijn.kernel@gmail.com> <20221206122239.58e16ae4@kernel.org>
In-Reply-To: <20221206122239.58e16ae4@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 6 Dec 2022 15:46:25 -0500
X-Gmail-Original-Message-ID: <CA+FuTScpBNEDy6D+dBaj3avMzXCQBRMUQib_gkono4V5k+Ke9w@mail.gmail.com>
Message-ID: <CA+FuTScpBNEDy6D+dBaj3avMzXCQBRMUQib_gkono4V5k+Ke9w@mail.gmail.com>
Subject: Re: [PATCH net-next] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, soheil@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 3:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  5 Dec 2022 18:09:25 -0500 Willem de Bruijn wrote:
> > Add an option to initialize SOF_TIMESTAMPING_OPT_ID for TCP from
> > write_seq sockets instead of snd_una.
> >
> > Intuitively the contract is that the counter is zero after the
> > setsockopt, so that the next write N results in a notification for
> > last byte N - 1.
> >
> > On idle sockets snd_una == write_seq so this holds for both. But on
> > sockets with data in transmission, snd_una depends on the ACK response
> > from the peer. A process cannot learn this in a race free manner
> > (ioctl SIOCOUTQ is one racy approach).
>
> We can't just copy back the value of
>
>         tcp_sk(sk)->snd_una - tcp_sk(sk)->write_seq
>
> to the user if the input of setsockopt is large enough (ie. extend the
> struct, if len >= sizeof(new struct) -> user is asking to get this?
> Or even add a bit somewhere that requests a copy back?

We could, but indeed then we first need a way to signal that the
kernel is new enough to actually write something meaningful back that
is safe to read.

And if we change the kernel API and applications, I find this a
somewhat hacky approach: why program the slightly wrong thing and
return the offset to patch it up in userspace, if we can just program
the right thing to begin with?

> Highly unlikely to break anything, I reckon? But whether setsockopt()
> can copy back is not 100% clear to me...
>
> > write_seq is a better starting point because based on the seqno of
> > data written by the process only.
> >
> > But the existing behavior may already be relied upon. So make the new
> > behavior optional behind a flag.
> >
> > The new timestamp flag necessitates increasing sk_tsflags to 32 bits.
> > Move the field in struct sock to avoid growing the socket (for some
> > common CONFIG variants). The UAPI interface so_timestamping.flags is
> > already int, so 32 bits wide.
> >
> > Reported-by: Jakub Kicinski <kuba@kernel.org>
>
> Reported-by: Sotirios Delimanolis <sotodel@meta.com>
>
> I'm just a bad human information router.
>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> > ---
> >
> > Alternative solutions are
> >
> > * make the change unconditionally: a one line change.
> > * make the condition a (per netns) sysctl instead of flag
> > * make SOF_TIMESTAMPING_OPT_ID_TCP not a modifier of, but alternative
> >   to SOF_TIMESTAMPING_OPT_ID. That requires also updating all existing
> >   code that now tests OPT_ID to test a new OPT_ID_MASK.
>
>  * copy back the SIOCOUTQ
>
> ;)
>
> > Weighing the variants, this seemed the best option to me.
> > ---
> >  Documentation/networking/timestamping.rst | 19 +++++++++++++++++++
> >  include/net/sock.h                        |  6 +++---
> >  include/uapi/linux/net_tstamp.h           |  3 ++-
> >  net/core/sock.c                           |  9 ++++++++-
> >  net/ethtool/common.c                      |  1 +
> >  5 files changed, 33 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> > index be4eb1242057..578f24731be5 100644
> > --- a/Documentation/networking/timestamping.rst
> > +++ b/Documentation/networking/timestamping.rst
> > @@ -192,6 +192,25 @@ SOF_TIMESTAMPING_OPT_ID:
> >    among all possibly concurrently outstanding timestamp requests for
> >    that socket.
> >
> > +SOF_TIMESTAMPING_OPT_ID_TCP:
> > +  Pass this modifier along with SOF_TIMESTAMPING_OPT_ID for new TCP
> > +  timestamping applications. SOF_TIMESTAMPING_OPT_ID defines how the
> > +  counter increments for stream sockets, but its starting point is
> > +  not entirely trivial. This modifier option changes that point.
> > +
> > +  A reasonable expectation is that the counter is reset to zero with
> > +  the system call, so that a subsequent write() of N bytes generates
> > +  a timestamp with counter N-1. SOF_TIMESTAMPING_OPT_ID_TCP
> > +  implements this behavior under all conditions.
> > +
> > +  SOF_TIMESTAMPING_OPT_ID without modifier often reports the same,
> > +  especially when the socket option is set when no data is in
> > +  transmission. If data is being transmitted, it may be off by the
> > +  length of the output queue (SIOCOUTQ) due to being based on snd_una
> > +  rather than write_seq. That offset depends on factors outside of
> > +  process control, including network RTT and peer response time. The
> > +  difference is subtle and unlikely to be noticed when confiugred at

note to self: confiugred -> configured

> > +  initial socket creation. But .._OPT_ID behavior is more predictable.
>
> I reckon this needs to be more informative. Say how exactly they differ
> (written vs queued for transmission). And I'd add to
> SOF_TIMESTAMPING_OPT_ID docs a note to "see also .._OPT_ID_TCP version".

Will do. Assuming we're good with this approach.
