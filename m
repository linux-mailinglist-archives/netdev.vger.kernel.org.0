Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC028A7CB
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 16:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgJKOfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 10:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388008AbgJKOfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 10:35:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89D4C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 07:35:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h6so11528192pgk.4
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 07:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wy5QvizAeXnuABsCtWkZJK2SeD8FZ20HNIGyAV0RiD0=;
        b=F/+qdPcGkTBmONyNFPadJxomOU9yp5H29HdKkkY4LOn04AL6Kc1eivyiSL78Q13dIY
         qFyCDEfO4horP6k4Rpn+jp14DZuNANCGrjtpoynKVvg5nww3kjuKgCDz61kG0eY1AMhO
         isqQ2mlAs6maB+SlBEoLfQJXndtp3MkoSFLvGLUKfl86P5TYCqbzCyH1h/L3RjVZve2n
         DkB9JLTJAXQjwg6XNMtkRgBuJSTw3hsBLVLEyngiolmZ3x75Aw3NEvrX7bS6MYLuHdTi
         4CsPxVPfdRY5Dqe+IIe5Go+u6kTrguGLOullYsZKb/qjYJyn2mFq+tz3ReU7sW73OvQK
         /i6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wy5QvizAeXnuABsCtWkZJK2SeD8FZ20HNIGyAV0RiD0=;
        b=d4G4PYCLKSwzOA18Hw8/cOGzgeg7i24cbGfiFilUp/CQyFU5PLNm4qjwMX0ZLZjYte
         i/9rEqEPjV3uqrfdbiwVwXyeuFHwsJcmGU1k6jXTLdrej9hV3vihcgak6rd1v/y7/5fV
         wy/YzPlu/oCD3IxOw0Kk2uL7qYDASucRTqD8Vm9WzY1aSL9JUTxj7br+qWvUDjhpLOjN
         ICUHz+tfJV3gdG7iJhgIe42utjkHVZwMwHmAjcqY5hmC9BIH5RSSVp+a+yoc5qCAoHtY
         vsRN7/69LzSks26QcWveXF/e1XrajUhOWz8JAUEBcgZgHCRZJhzB+cU2wxCL5oDEVnqu
         vK4w==
X-Gm-Message-State: AOAM530+WaYz5gno2pBiCCc/y3Z/I7F5A02oZPOfgmp3Vbk9EMbsLtwA
        HfELY/a19fO7VQIkBh3srBbqDHZDDGqyQGYnf14=
X-Google-Smtp-Source: ABdhPJxUwxvOD7u/VJ9/f+DfuwgSqih91tP2+kKfV5ASyQYE8YbI2Wp+R9TsWomflxLH1gQcO38gGNFkPYtuyBNJB4Q=
X-Received: by 2002:a17:90b:d91:: with SMTP id bg17mr15571354pjb.66.1602426938368;
 Sun, 11 Oct 2020 07:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
 <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
 <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
 <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
 <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
 <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
 <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
 <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com>
 <CAJht_EO99yYQeUPUFR-qvWwrpZQfXToUu6x7LBS+0yhqiYg_XQ@mail.gmail.com> <CAM_iQpX0zjZUDE_iuf4WWXiodwb2UpqyjjQPYrfD0CMXnMSymQ@mail.gmail.com>
In-Reply-To: <CAM_iQpX0zjZUDE_iuf4WWXiodwb2UpqyjjQPYrfD0CMXnMSymQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 11 Oct 2020 07:35:27 -0700
Message-ID: <CAJht_EOyOrRoqExrKHVV5DQp8Sk1Zx4sqgkfQ63TQ==cV8+b5g@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 11:58 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Well, AF_PACKET RAW socket is supposed to construct L2 headers
> from the user buffer, and for a tunnel device these headers are indeed its
> L2. If users do not want to do this, they can switch to DGRAM anyway.
>
> I know how inconvenient it is to construct a GRE tunnel header, I guess
> this is why all other tunnel devices do not provide a header_ops::create.
> GRE tunnel is not a special case, this is why I agree on removing its
> ->create() although it does look like all tunnel devices should let users
> construct headers by definition of RAW.
>
> Of course, it may be too late to change this behavior even if we really
> want, users may already assume there is always no tunnel header needed
> to construct.

Sorry. I was re-thinking about whether we should expose certain
headers in header_ops or not. Now my thoughts are a little bit
different, so I want to re-reply to your email.

1.

The first reason why I think we should not expose the GRE header in
header_ops, is that in this way we can keep the un-exposed headers of
GRE devices consistent with those of GRETAP devices. (This is just
like the consistency between "universal TUN devices" and "universal
TAP devices".) This is similar to what I wrote in my previous replies.

However, after thinking I think this only applies to GRE/GRETAP but
not to some other tunnel devices. For example, for PPP, we can't
actually transmit Ethernet frames directly over PPP (but need to
encapsulate them in BCP over PPP), so there's no way to keep the
un-exposed headers of PPP devices consistent with those of "PPP TAP"
(PPP bridging) devices anyway.

2.

Second, I think the headers before the GRE header (the outer IP header
and the "encap" header) should actually belong to the underlying
network being tunneled through, and should not be viewed as L2 headers
of the tunneling network. As for the GRE header, it might be better
viewed as a "bridge" between the tunneled network and the tunneling
network, and belongs neither of the two, so it should not be viewed as
the L2 header of the tunneling network either.

However, for PPP tunnels, I think the PPP header clearly belongs to
the tunneling network's L2 header (because PPP can run directly over a
hardware link, and even if it is used for a tunnel, it needs a
specific underlying network's protocol, such as SSH or PPPoE, to
transport). So I think it is better to expose the PPP header in
header_ops.
