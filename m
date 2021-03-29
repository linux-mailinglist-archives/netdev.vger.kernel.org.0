Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9334D3C1
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC2PZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhC2PZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:25:10 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBFDC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:25:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a7so20110765ejs.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3BUYKVSWXeI1TOcoAookS/QZXm6eUJdVbtEkboNTYo=;
        b=PzG/xhjb+U5nF5hYrhPGYIKbHlg0T9/PJlk+PLLlco909qAId1KWQrXD4+xXoXbsxp
         eUclP0/BMczGtrqwJ6ulJePA4PkAzqmKaeEyp27nbCBnGPo4kICfuAg8QD5fJ2TMIr4h
         bd96ojhrLIqve0rpUoFOq2ZDZSZacZmR92vo2pIJrVNnSwADX3Y1hyZMjKqaFoDP91ZJ
         dz5/uXY+dcgSN/BgIIOlDV03elyVtZ2lkC6UjxtVFfCAUTN81lVKePtSOdnIe9ggUAC+
         E3H4KZ1DdSmvm+uvRTQwW0f/6Eq2Zxn6HS2lwhi2F1IEUqssMkhFg2upq/S71oACr1TN
         IuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3BUYKVSWXeI1TOcoAookS/QZXm6eUJdVbtEkboNTYo=;
        b=Ei1vDiPzYhE6opyAhX0n7nNIp6GCxN57I6ymOdDAIxJIiEdOgfPnOLib2awGWx2b77
         ZNlsSNOPrWxUoUIeyzKWMi4SjVPrrSEE09qkO+dsRfzErOwof5oFEPD22Jz3KoWFIyHj
         7fBCRnvlau5uWt8kvnS50OPFwVNtD7R/m9r0ENFCXYTrFxbgHKBJvQ7gMXOWke3eDbfy
         k4DI17ZQa/DH2mLD3wFQXhRdxpbw3ppiTXeLzJFs2Cgrvbpo65vxuH/3mbFjc+Yt1hpN
         5eNJJjmikUMbkwG5dB/SPW2tS9QqSbDV/Ixch460NdGdz5rwgXczEKvbDAQ9ljCOWttJ
         rr2Q==
X-Gm-Message-State: AOAM531K038Qk6qaTyZfBo5W54PMHJ07HgZdGzyE7k3lv4MZcahhUxdG
        F6QngABtqlqHKZqmXq50BOboO8VDUBY=
X-Google-Smtp-Source: ABdhPJxykXOnaiqbdU5ha0Ue+mjxrzOjLvSbuCsLXTc0sgawCOadkfv9Qrh9cHCaeSZjYVSroKfDvA==
X-Received: by 2002:a17:906:f1c8:: with SMTP id gx8mr29832822ejb.385.1617031508355;
        Mon, 29 Mar 2021 08:25:08 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id f19sm9155230edu.12.2021.03.29.08.25.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 08:25:07 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so6886806wmj.1
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:25:07 -0700 (PDT)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr25329789wmm.120.1617031507132;
 Mon, 29 Mar 2021 08:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
 <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
 <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
 <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
 <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
 <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com> <c296fa344bacdcd23049516e8404931abc70b793.camel@redhat.com>
In-Reply-To: <c296fa344bacdcd23049516e8404931abc70b793.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Mar 2021 11:24:30 -0400
X-Gmail-Original-Message-ID: <CA+FuTScQW-jYCHksXk=85Ssa=HWWce7103A=Y69uduNzpfd6cA@mail.gmail.com>
Message-ID: <CA+FuTScQW-jYCHksXk=85Ssa=HWWce7103A=Y69uduNzpfd6cA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow path
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 11:01 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-03-29 at 09:52 -0400, Willem de Bruijn wrote:
> > > > That breaks the checksum-and-copy optimization when delivering to
> > > > local sockets. I wonder if that is a regression.
> > >
> > > The conversion to CHECKSUM_UNNECESSARY happens since
> > > commit 573e8fca255a27e3573b51f9b183d62641c47a3d.
> > >
> > > Even the conversion to CHECKSUM_PARTIAL happens independently from this
> > > series, since commit 6f1c0ea133a6e4a193a7b285efe209664caeea43.
> > >
> > > I don't see a regression here ?!?
> >
> > I mean that UDP packets with local destination socket and no tunnels
> > that arrive with CHECKSUM_NONE normally benefit from the
> > checksum-and-copy optimization in recvmsg() when copying to user.
> >
> > If those packets are now checksummed during GRO, that voids that
> > optimization, and the packet payload is now touched twice.
>
> The 'now' part confuses me. Nothing in this patch or this series
> changes the processing of CHECKSUM_NONE UDP packets with no tunnel.

Agreed. I did not mean to imply that this patch changes that. I was
responding to

> > > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > > +               skb->csum_valid = 1;
> >
> > Not entirely obvious is that UDP packets arriving on a device with rx
> > checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> > this test.
> >
> > I assume that such packets are not coalesced by the GRO layer in the
> > first place. But I can't immediately spot the reason for it..

As you point out, such packets will already have had their checksum
verified at this point, so this branch only matches tunneled packets.
That point is just not immediately obvious from the code.

> I do see checksum validation in the GRO engine for CHECKSUM_NONE UDP
> packet prior to this series.
>
> I *think* the checksum-and-copy optimization is lost
> since 573e8fca255a27e3573b51f9b183d62641c47a3d.

Wouldn't this have been introduced with UDP_GRO?
