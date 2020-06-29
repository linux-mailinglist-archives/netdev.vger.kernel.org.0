Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EC220E0EA
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbgF2Uuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgF2TNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47410C02E2EF
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 07:26:07 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id e22so12986124edq.8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 07:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OSeAlgcuklQhkcnb7RqjqWxPVgTss7/UdFxCI84iwfY=;
        b=yxQKGhZQzlhmNGorOHP+1ObPX6ZcYyAU71eqSGpdowfiFmsZ/0IKFfXLPNUZbo80tn
         jRB07QfFIpRBwiU0PquzsTGdg6ks89doSAImtB+HHlEQHFiXAz+awHujbTL93oaoo3Zf
         BriQCOarFWOur4OXRcj/kS234IscUHAh2uFKPNykSRUUTthudF0KPhyD5KXXwmXQ5Mzq
         lNyDPYQnwT/syA8Iftbz3lU0oFSqmw5QM3XpRi1AEeUyY7FhF9CTTxNHnw9h5botgFTI
         dkXqYASO4Adue8UX0YSNua/qi3qs7v4VSPMt4P8xcM6X+oESB/ZS4rXJPd1GoLBVv9sd
         44Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OSeAlgcuklQhkcnb7RqjqWxPVgTss7/UdFxCI84iwfY=;
        b=WGsHFg3xflqdnLF/KZwSpdnOR1n0XwPR/tC5RGU77PIvIwYRFblgHlj2vwGwSgt3zA
         lLKKa8koLRrTU/MwSwDC812l0htj6N2qgMDG5PuG9G9LTYhEVH7Vq9SkrO+6rJqB5ol7
         P5BOEW2GpUoUD2+0nCc6J276BVuvZliS+v5/kZr6kLIABpuupZj1hNJ+wCBuO3R50Nbe
         +DQJASvMKGZX4C1X7tKXFyy6U7+AkAPSNBJAVK7E1znSDcwsNApVIWvZo0WQJiPt29ou
         vD6AyL5icrBJLhtLaK/pk5nxxnuGcQci0D/aUxTyuwefLVMg5f6Tw0UwGVLYuKxMjDNr
         py1w==
X-Gm-Message-State: AOAM531P6bq0WV9USr/hdtMSuG2n5L54Y7Eex3kz/DfIo8j+I9YCH8HC
        Ae8DytjiSBABKLHEVrwKJqCEzBwknag3DCVSg9HsMA==
X-Google-Smtp-Source: ABdhPJyk+ldT83eFYgufM6RSooIZ5K/q9ekI/ZyZjQSVUd2xnt4ix2yDrLw9AGW4WC+q/e3GyHOTlu7JY6VLuZMncyg=
X-Received: by 2002:a50:934e:: with SMTP id n14mr17982549eda.88.1593440764773;
 Mon, 29 Jun 2020 07:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200627211727.259569-1-saeedm@mellanox.com> <20200627211727.259569-5-saeedm@mellanox.com>
 <CALx6S37gn4mQx97xXUPpjW4Fm9NxOwfagunhygHrvaGS5Uxs4w@mail.gmail.com> <90af87c36100323d8a28c70c0223c865a2bab266.camel@mellanox.com>
In-Reply-To: <90af87c36100323d8a28c70c0223c865a2bab266.camel@mellanox.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 29 Jun 2020 07:25:53 -0700
Message-ID: <CALx6S34JRJh6zdOwyjjbW+gMm+qDz9tVYbCkSAd-O82wa__Xng@mail.gmail.com>
Subject: Re: [net-next 04/15] net/mlx5e: Receive flow steering framework for
 accelerated TCP flows
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 11:57 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Sat, 2020-06-27 at 15:34 -0700, Tom Herbert wrote:
> > On Sat, Jun 27, 2020 at 2:19 PM Saeed Mahameed <saeedm@mellanox.com>
> > wrote:
> > > From: Boris Pismenny <borisp@mellanox.com>
> > >
> > > The framework allows creating flow tables to steer incoming traffic
> > > of
> > > TCP sockets to the acceleration TIRs.
> > > This is used in downstream patches for TLS, and will be used in the
> > > future for other offloads.
> > >
> > > Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> > > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > ---
> > >  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
> > >  .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  10 +
> > >  .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 280
> > > ++++++++++++++++++
> > >  .../mellanox/mlx5/core/en_accel/fs_tcp.h      |  18 ++
> > >  .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
> >
> > Saeed,
> >
> > What is the relationship between this and RFS, accelerated RFS, and
> > now PTQ? Is this something that we can generalize in the stack and
>
> Hi Tom,
>
> This is very similar to our internal aRFS HW tables implementation but
> is only meant for TCP state-full acceleration filtering and processing,
> mainly for TLS ecrypt/decrypt in downstream patches and nvme accel in a
> future submission.
>

Saeed,

Receive Flow Steering is a specific kernel stack functionality that
has been in the kernel over ten years, and accelerated Receive Flow
Steering is the hardware acceleration variant that has been in kernel
almost as long (see scaling.txt). If these patches don't leverage or
extend RFS then please call this something else to avoid confusion.

> what this mlx5 framework does for now is add a TCP steering filter in
> the HW and attach an action to it  (for now RX TLS decrypt) and then
> forward to regular RSS rx queue. similar to aRFS where we add 5 tuple
> filter in the HW and the action will be forward to specific CPU RX
> queue instead of the default RSS table.
>
> For PTQ i am not really sure, since i felt a bit confused when I read
> the doc and i couldn't really see how PTQ creates/asks for dedicated
> hwardware queues/filters, i will try to go through the patches
> tomorrow.
>
> > support in the driver/device with a simple interface like we do with
> > aRFS and ndo_rx_flow_steer?
> >
>
> Currently just like the aRFS HW tables which are programmed via
> ndo_rx_flow_steer this TCP Flow table is programmed via
> netdev->tlsdev_ops->tls_dev_add/del(), for TLS sockets to be offloaded
> to HW.
>
> as implemented in:
> [net-next 08/15] net/mlx5e: kTLS, Add kTLS RX HW offload support
>
> But yes the HW filter is is always similar, only the actions are
> different (encrypt or Forward to specific CPU),
>
> So maybe a unified generic ndo can work for TLS, aRFS, PTQ, XSK,
> intel's ADQ, and maybe more. Also make it easier to introduce more flow
> based offloads (flows that do not belong to the TC layer) such as nvme
> zero copy.
>
That's an admirable goal, but I don't see how these patches steer
towards that. The patch set is over 1600 LOC, nearly all of which are
in MLNX driver code. Can some proportion of this code be generalized
and moved in the stack to become common code that other drivers can
use instead of having to recreate this code per each driver that might
want to support advanced offloads?

Tom

> There were lots of talks and discussions by Magnus, Jesper, Bjorn,
> Maxim and many others to improve netdev queue management and make
> networking queues a "first class kernel citizen" I believe flow based
> filters should be part of that effort, and i think you already address
> some of this in your PTQ series.
>
> - Saeed.
>
