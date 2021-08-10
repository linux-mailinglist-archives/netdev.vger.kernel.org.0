Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C09B3E55B8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhHJIl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhHJIlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 04:41:55 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A427FC0613D3;
        Tue, 10 Aug 2021 01:41:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id f11so31047535ioj.3;
        Tue, 10 Aug 2021 01:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xB1ACiy7Io0kW/dBZ3duTDNb8SeLXwDQNctKQur/fh8=;
        b=WyyT1rbehAfV2SiLbf+Z59W37jcNL2wHrtZIEBmyJEHmeMTEWOEp121p7nNWgkGLkl
         g5/AEobroGqP7YelCTbTmT2PDz1oaj/AVhItZ+lV/KiIOoDigWZ6kbqlviZT1CDUPsww
         i5uJsPFRi0q65h2vtyFju/j0s+KuZPztx2oxUF4QjHfh3T+PZWOtGmnB28iAvVaZLeG8
         Bfy9KYqPbp6wmnb9lJi1Wlxo/Z0JRex4P5Qxc+ZJG5ebPx+LoqqID9A6tv7FWYs+DCSV
         3S177aikTY8CxPH79pcmhgng3GWUJdZseBrPRL/vlHCWWYpSW6Xp39ETr4MlfhZ+LrFY
         3zzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xB1ACiy7Io0kW/dBZ3duTDNb8SeLXwDQNctKQur/fh8=;
        b=KOhaZpTGEEA46Zne0N6E+j5ac4Yz57AwB8KNMfcFgUTZGONbyPb925ubS8x7DfhEQu
         /ROTlkP2AIolc3AfNIdwxX2fJRPDmUgWCUlrWvCDx5dQPl5HFRpWc9JzSbB6JXM94nhV
         J49gZ1H+8D4uk6a7GVSdRKf7l79zbz2QSIzWa5CxkLH+tr/+cANigXhrPa+NMOiQoF22
         Gmo5pqswmpE7vvaTcURBkY/uazBnJpYspomxJ6y4SnLYBe0swzsPZbz/lGLalKjjt0/s
         KMOsyQsR8U4EHeTutAWc2jNlEu3Bz7Rmc/XCra5DMsU8xgThnZeJVg2lpSnJirqdkNXg
         ozlQ==
X-Gm-Message-State: AOAM530q3uHaI+CXUMd1S3GBzMCtK9mJI1KfUZUCQi68bcOsvb+NVgNj
        vAQAe+MLYIqJdiCQztrBZ0KiV9FyNVRPtC8hds0=
X-Google-Smtp-Source: ABdhPJzqMo9V5pQJsK+5D81gy4SX3IpJ5wO1t4vb+Ak3Z2jc9b20h2i1IYQY/j+sZtJZiGv/rULFj5j6VVw6UMdP/Jo=
X-Received: by 2002:a05:6602:24d9:: with SMTP id h25mr2370ioe.11.1628584893196;
 Tue, 10 Aug 2021 01:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdU7-AahJmKLabba_ZF2bcPwktU00Q_uBOYm+AdiBVGyTA@mail.gmail.com>
 <CA+V-a8vfnnfgK1cY8dqsPJUwotK7SZZu5MjeGuJTa--+qaN4gg@mail.gmail.com> <20210810083925.weikjhpnzmq77oeh@pengutronix.de>
In-Reply-To: <20210810083925.weikjhpnzmq77oeh@pengutronix.de>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 10 Aug 2021 09:41:07 +0100
Message-ID: <CA+V-a8uVrzyOhdJFU+vy9Bpp8GuZrZAq4gnfZ-YfisJBPNwmmA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 9:39 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 10.08.2021 09:36:50, Lad, Prabhakar wrote:
> > > > +static void rcar_canfd_handle_global_recieve(struct rcar_canfd_global *gpriv, u32 ch)
> > >
> > > receive (everywhere)
> > >
> > Ouch, I'll respin with the typo's fixed.
>
> No need, I've fixed it here.
>
Thanks Marc.

Cheers,
Prabhakar

> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
