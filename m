Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE542AEF62
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKKLPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKKLPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:15:48 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E00C0613D1;
        Wed, 11 Nov 2020 03:15:48 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id j14so1797032ots.1;
        Wed, 11 Nov 2020 03:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDGt8ma/Ki7z732IZFIEIBCAmcZZzkinHzRJMbdIpOk=;
        b=NXvTO6/RXFrl8YidjDfskiLCdvh2F6y9c9UXMDaHseaL4steWStoXPMW4aAnz1ojkF
         zlvLquT43M7QoiCK5QOEWk8xRwK/H7NQQcVIgV03MOKu/K9iA0QvJsCGvBXIg/vn7YR8
         1uPlVf1D6WQTqwR8THwySy/JOjGdVR9HLUE+EFDHefKtNZdoUZmdj2APNIt4/1g8FVMm
         YvJXklFF7VD1znuJ88HqUsyRDgSsFlcH6logMzXaLF3b0nLOY5G9KmgNPOs0NZBKAI5P
         Cgc/Ev8p/oWPiIhh+7E9pP73I+7G9ce9f/4h+ddr/kSNDZuymnnw+C3ZX3jlYwNtLOsN
         wydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDGt8ma/Ki7z732IZFIEIBCAmcZZzkinHzRJMbdIpOk=;
        b=N9PoAdcYA2ftQFUUaUFWG8QdvYqrVhDQ7v/nXzpNqowCWR0M7+zEx1pmZy0Wk4mSrs
         vRxOXtVqfHdRDgnPryUW7pbnM+6KdFTtZkXgIXwbzUe9YtjWa56y3Vm+2iJ0RbouSMWF
         9lqRgEepL//0WDFEfOVakCxHrMLMrN92N4i+iU/e6I1HLMR2RSPCRzXkWe038eqfcZUA
         r7bzRZmnNRHQ/24ByWg2jfDONPNFicx320t/TcCY4nRUebZYJzpp8SxlaMsbengFYZpG
         Fb/zCKHM9dEt7VH1wgWewjFyDCE6gPpl0XTdjoQklUpUfDOiqWxY9xmA+JO8b5zRiV4G
         s41w==
X-Gm-Message-State: AOAM532BjQSdUXRLUBod2smDBRdxdCFAu33UGUOeObNXDI5b5SI5/z4R
        FLY0MZpEm6pGPTa9j31P2IakJwr2IRkecx5Ht1s=
X-Google-Smtp-Source: ABdhPJzoyiezA6bxrPG+J4Zvz0VXzT/Cs5WFODvqu/lWnWWqhMomQ8cYyoJvawhKXqCfOi37Fp4ACpPMTFxJWttZ3Dw=
X-Received: by 2002:a9d:2f61:: with SMTP id h88mr18012985otb.278.1605093347705;
 Wed, 11 Nov 2020 03:15:47 -0800 (PST)
MIME-Version: 1.0
References: <20201107122617.55d0909c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <222b9c1b-9d60-22f3-6097-8abd651cc192@gmail.com> <CAD=hENdP8sJrBZ7uDEWtatZ3D6bKQY=wBKdM5NQ79xveohAnhQ@mail.gmail.com>
 <20201109102518.6b3d92a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAD=hENcAc8TZSeW1ba_BDiT7M7+HeyWUHSVwnFQjOi6vk5TPMQ@mail.gmail.com>
In-Reply-To: <CAD=hENcAc8TZSeW1ba_BDiT7M7+HeyWUHSVwnFQjOi6vk5TPMQ@mail.gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Wed, 11 Nov 2020 19:15:36 +0800
Message-ID: <CAD=hENcBQ=A9UrrciM2L7PJUD2wCNnQPh8tCNCHc6nT+0N1cDg@mail.gmail.com>
Subject: Re: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 9:58 AM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> On Tue, Nov 10, 2020 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 8 Nov 2020 13:27:32 +0800 Zhu Yanjun wrote:
> > > On Sun, Nov 8, 2020 at 1:24 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > > > On Thu, 5 Nov 2020 19:12:01 +0800 Zhu Yanjun wrote:
> > > >
> > > > In the original design, in rx, skb packet would pass ethernet
> > > > layer and IP layer, eventually reach udp tunnel.
> > > >
> > > > Now rxe fetches the skb packets from the ethernet layer directly.
> > > > So this bypasses the IP and UDP layer. As such, the skb packets
> > > > are sent to the upper protocals directly from the ethernet layer.
> > > >
> > > > This increases bandwidth and decreases latency.
> > > >
> > > > Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
> > > >
> > > >
> > > > Nope, no stealing UDP packets with some random rx handlers.
> > >
> > > Why? Is there any risks?
> >
> > Are there risks in layering violations? Yes.
> >
> > For example - you do absolutely no protocol parsing,
>
> Protocol parsing is in rxe driver.
>
> > checksum validation, only support IPv4, etc.
>
> Since only ipv4 is supported in rxe, if ipv6 is supported in rxe, I
> will add ipv6.
>
> >
> > Besides it also makes the code far less maintainable, rx_handler is a
>
> This rx_handler is also used in openvswitch and bridge.

in Vacation. I will reply as soon as I come back.

Zhu Yanjun

>
> Zhu Yanjun
>
> > singleton, etc. etc.
> >
> > > > The tunnel socket is a correct approach.
