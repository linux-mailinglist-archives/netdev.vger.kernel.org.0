Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6760A49EFCF
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 01:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiA1AfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 19:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiA1AfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 19:35:11 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551E0C061714;
        Thu, 27 Jan 2022 16:35:11 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m26so700355wms.0;
        Thu, 27 Jan 2022 16:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m/g5IjygHJdyBKa2C2i5Lt6BGh/ss5sQbCSaGRICTRg=;
        b=BWGnBi5+KKUxmMgIPzihbmEtdStfDql5LFNa3t7qhAkP4CzcuL3rc/v8NVx7h5x4rz
         MGM+D0f9MfRJ2pdcH7EZ9TRm6B1KdSej8kSEykEeKGP/aaug1NpMh0wx7Uuj3wawpvP8
         u30n0bkuBQcY162Ycig87EuDpHqx5M2SMDhsHoScaBXifbARLpNvzwZnVErfGH3Bc4XN
         fltJ9Dw25vzOpLR6PJDtV5mkFH+cFH4wnzv/G6Qw7GrA9LPJ2PDjNiuuH5QAcryrlC+b
         oAoCkA4I6bZxc837fX4qPkXq4Uglbio6/3WcNW/gg8jWBJiFiNKU2zIiTe6uQCUvvBS0
         Phqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m/g5IjygHJdyBKa2C2i5Lt6BGh/ss5sQbCSaGRICTRg=;
        b=bhI7qYg8Ps0G7uGIPyl4u+p5sdQcg02Dxl7xaIlKnoGn6WBquQjHySz6soMjsFcFPj
         CBTO94R1Ib7FmnWugxhX/y/R1t3dHWqxHNemLwVmYIJiaZfB7TKssiLaVPen3ZvzDLA1
         6aHlZ4ZfUclI2SJojYHB0X+1gL+jnW0apI4UExIVpXKu5MgXS3VzCGhAGmOd0ZtFzxNs
         WxjHndxfKB5MsBHZ3RS/0bmXleUH4qNEoM9bSxqvZM9iqKBbyazR3Sh3MG3K1INl/+Rz
         SY62RHTyJYghhevNo98As6KcCXUrEj0JrTPkZpoYb16Vyalp+RJfUGfdunsGOH/SivXj
         3X/g==
X-Gm-Message-State: AOAM530oLAdCdh6C8UGa6GL6KSaoO/3lf2KW1ja5xVjLbJ8W9EtJ9qUZ
        0Qv50kJn3SYdoTW7OfJnRyyyRuDvSlMuOK3s2W8=
X-Google-Smtp-Source: ABdhPJwt5kyj7zQQKu3804qzOAkMC2XQufGAyX7XIhycOJzEK2MZ3CX7s+dcYXK8SjRF689fQEaaLz+dyi/iLsBbtrw=
X-Received: by 2002:a05:600c:3b90:: with SMTP id n16mr9129542wms.178.1643330109877;
 Thu, 27 Jan 2022 16:35:09 -0800 (PST)
MIME-Version: 1.0
References: <20220125122540.855604-1-miquel.raynal@bootlin.com> <b07b446d-a48e-78bd-1841-2802e12cf1d1@datenfreihafen.org>
In-Reply-To: <b07b446d-a48e-78bd-1841-2802e12cf1d1@datenfreihafen.org>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 27 Jan 2022 19:34:58 -0500
Message-ID: <CAB_54W6-z-k-sUkPsbWr5BuTOuAAD5YY=L=A9qpe5dgXWQ6rXA@mail.gmail.com>
Subject: Re: [wpan-next v3 0/3] ieee802154: A bunch of light changes
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jan 27, 2022 at 10:54 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
> Hello.
>
> On 25.01.22 13:25, Miquel Raynal wrote:
> > Here are a few small cleanups and improvements in preparation of a wider
> > series bringing a lot of features. These are aside changes, hence they
> > have their own small series.
> >
> > Changes in v3:
> > * Split the v2 into two series: fixes for the wpan branch and cleanups
> >    for wpan-next. Here are random "cleanups".
> > * Reworded the ieee802154_wake/stop_queue helpers kdoc as discussed
> >    with Alexander.
> >
> > Miquel Raynal (3):
> >    net: ieee802154: hwsim: Ensure frame checksum are valid
> >    net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
> >    net: mac802154: Explain the use of ieee802154_wake/stop_queue()
> >
> >   drivers/net/ieee802154/mac802154_hwsim.c |  2 +-
> >   include/net/mac802154.h                  | 12 ++++++++++++
> >   net/ieee802154/nl-phy.c                  |  4 ++--
> >   3 files changed, 15 insertions(+), 3 deletions(-)
> >
>
> I am happy with all three of them now. Alex, let me know if there is
> anything else you want to be adressed and ack if not so I can pull these in.

Everything is fine.

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks.

- Alex
