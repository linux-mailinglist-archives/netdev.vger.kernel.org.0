Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07C9462B66
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhK3EEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhK3EEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:04:31 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9B6C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:01:12 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id t26so50194513lfk.9
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpfJur1QYE2rvU84HwIrDOOzWm6gtJBXI5SMWtLmk7U=;
        b=EdCxD7x2CYKKefvSxQG/qa+mE2dauxtKD16jMDYFrR8v+KqFZkIU8Dtn9HkU7JuUwn
         P4KOJT5U/lp7dXlH4BSbpYu13MpESteYXGwEfv0WIViiJVJaYHg8EiC1KSR5TFSt5NC5
         VKGbaM5kI/QDvR6oGqQAZwlVTYyU+DXNIVgs3sssfHKC6XDRoObeKEhC7A+Ini9cibDg
         JFXpNNOr9ci+FGH3ieBjXjXieqAP2jnBNh0FN+dJZYTKt7qzLnH2YyaAn8H4Zll4IhHz
         LPsM5H7Y3BdWDVraEJ0yzciwaTlKIP72mP+VfOmz1CZ3i1jxdTZkCzKAcVfHnStsdmBR
         RPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpfJur1QYE2rvU84HwIrDOOzWm6gtJBXI5SMWtLmk7U=;
        b=M98zsmS9wnu0fr7Nu2Vg7FzkDFVnRmdzuybn+2rCT9K1sf/QQi1N9kVzI1d9fViSSD
         xitWmyTeU+0SUYrX5XB3HkzOSnUKK8o1gg7YUYRSbDvGaUEcR7/HMPs3aAZwEUqLzfb/
         K5hsoy6E2jcapmGC9fvef0khuKWRPw+4BNV2NLGWh5GwyXEtAdFbUbFcAWwqzsJOutHR
         0woHriUbkDofDE1fg2wHe0NR0FibSolUm7WlDUC5lRC4AdVe/OHB+eKmYRumTvcYBFIw
         cMfo9Q0Yj7dM1BmUm5JlDEtSYVu+Q+SKOYp6mvJ8r/AOb58Wym7bT8zAh8AQV6TLd58w
         hXYA==
X-Gm-Message-State: AOAM532kjrdzXtCHSIx3DR1Pn0bqPQHeRgJI+rJWdx3VvF/oRteSMpss
        dE+vX2jo1gYtFpdTizRCLTydldQyz9WCdPi8QOGBA/pc
X-Google-Smtp-Source: ABdhPJxI/ZSOC1AOn22iXcD4g6ge26Y4dsD9skSFXauTk3N2IJhzuxDsNlDPaY7U7kDwQGA2nJfCAAoTMTscsYCP32I=
X-Received: by 2002:a05:6512:1151:: with SMTP id m17mr53816770lfg.154.1638244871039;
 Mon, 29 Nov 2021 20:01:11 -0800 (PST)
MIME-Version: 1.0
References: <20211125021822.6236-1-radhac@marvell.com> <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
 <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com> <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Radha Mohan <mohun106@gmail.com>
Date:   Mon, 29 Nov 2021 20:00:59 -0800
Message-ID: <CAC8NTUVmfNMNNJ3aT6=fB3S_9jb0XtyOt4s0VU8o1Q3RfQwY3Q@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP VF devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sgoutham@marvell.com,
        Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>,
        Satananda Burla <sburla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Nov 2021 22:00:49 -0800 Radha Mohan wrote:
> > On Wed, Nov 24, 2021 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 24 Nov 2021 18:21:04 -0800 Radha Mohan wrote:
> > > > This patch adds netdev interface for SDP VFs. This interface can be used
> > > > to communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
> > > > mode.
> > >
> > > All your SDP/SDK/management interfaces do not fit into our netdev
> > > model of the world and should be removed upstream.
> >
> > SDP is our System DMA Packet Interface which sends/receives network
> > packets to NIX block. It is similar to CGX, LBK blocks but only
> > difference is the medium being PCIe. So if you have accepted that I
> > believe you can accept this as well.
>
> Nope, I have not accepted that. I was just too lazy to send a revert
> after it was merged.
I think you have misunderstood what I am saying. The currently merged
changes (not the ones what you were lazy about) support our networking
blocks NIX which has send/receive queues to transfer packets over CGX
(externally over the wire) and LBK (internally looping).
Now we are adding support for NIX to send/receive using SDP (over
PCIe). The earlier changes that you thought of rejecting (for reasons
unknown) are initial support and this change completes that.
Can you please elaborate on your outright rejection criteria only for
SDP ? Just saying I will not have XYZ support added just because I am
the maintainer now doesn't make a good argument.
