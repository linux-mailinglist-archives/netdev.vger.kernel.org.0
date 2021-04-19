Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16C93646AE
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbhDSPFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbhDSPEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:04:54 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5FDC06174A;
        Mon, 19 Apr 2021 08:04:24 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id x16so35222715iob.1;
        Mon, 19 Apr 2021 08:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sK9kJH32/DEKrA6KoYri3PZGBlZT1dWah2hqamZZ9Cc=;
        b=s7wVo0vApXU/OM1jt4+gMA9B0M0TVD8p1XDGpgxiXAxuyzaHz2Gj1uaR28sDh9Meyq
         M+ZPjuGWqIFb91kh+t5jJbJhqs8vxijOqlUhQ4V3TEo8yK7ZobGdz5Hr1JHP3AjtAn59
         Re249SBEmo/8oNw//lAyJDppVQ0CHLS5EtwgWyNYZNNCIRMuCnfCXdAvTdD4zSc/vpbc
         vTMTAbEzFLOBOQTWIt4/WlgQzt3Iahmlb6W8ItRJAayJiQUHk2q6qO7zju/SgZJ6EGFn
         YBYjVlEXIUwLGeNoNGzxjQ0CwwpVAeSLagMmZf0XzsRv0HX/+FQoSJGxYUlm4OUkYYnA
         TiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sK9kJH32/DEKrA6KoYri3PZGBlZT1dWah2hqamZZ9Cc=;
        b=L2/BomEruN9lYVixdEFEhq0ZQGQA2sLIisIUrfphUTndu2xlRGi2jDHEQkMt62pWZm
         cyWHCVdhhtCYCWC4BRxodLuWUgy2gsGwNQEHcK/nK/2NrGsYUCPOklvcrdNfnKqW1v5w
         /kXiuQswFAaVYZvf0Anzelf7s+HOZSb7bWd/VKp7YyaWwoMgW+sVtmrLYn9eoBC5EanF
         0hGlS/O0F4CI4KbdvMU3IPtxJiRLBB8DNu0O2oiY212/2NbGvdEVy14D5LzDI2wmAH9V
         mASv5sRidOOTX2DycB2YzOGBiDa5l3tUWx/F+n/UeNTzd6R7GBBF9bRRV0t0BV2ILgYh
         lPrA==
X-Gm-Message-State: AOAM530spKkFxu5Cca/rbuXtOvSKZ7DyN2TJTLw6AI49O+nVeSDsblHZ
        rrDW/yZTp4yxIwQZnRQ/1zvAdrVS3DUF70B2nes=
X-Google-Smtp-Source: ABdhPJzEZQjUJvUvF+QDBgYHgewS1rUZVS39JXLXF5zSRaqhTgFexQhrwFdP/SIkUu/RjU+JN91KzcVrPuuY0GRWz/U=
X-Received: by 2002:a02:a487:: with SMTP id d7mr2653012jam.84.1618844661634;
 Mon, 19 Apr 2021 08:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
 <20210419040352.2452-3-ilya.lipnitskiy@gmail.com> <YH10UNuJZ5s7dfLh@lunn.ch>
In-Reply-To: <YH10UNuJZ5s7dfLh@lunn.ch>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 19 Apr 2021 08:04:10 -0700
Message-ID: <CALCv0x2SSGjiqKOBhK1GT2ksjc9J--Qm3Uq-0xc3sgHvDju5-A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: ethernet: mediatek: support custom GMAC label
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 5:15 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Apr 18, 2021 at 09:03:52PM -0700, Ilya Lipnitskiy wrote:
> > The MAC device name can now be set within DTS file instead of always
> > being "ethX". This is helpful for DSA to clearly label the DSA master
> > device and distinguish it from DSA slave ports.
> >
> > For example, some devices, such as the Ubiquiti EdgeRouter X, may have
> > ports labeled ethX. Labeling the master GMAC with a different prefix
> > than DSA ports helps with clarity.
> >
> > Suggested-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
> > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.c
> > index 6b00c12c6c43..4c0ce4fb7735 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -2845,6 +2845,7 @@ static const struct net_device_ops mtk_netdev_ops=
 =3D {
> >
> >  static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
> >  {
> > +     const char *label =3D of_get_property(np, "label", NULL);
> >       const __be32 *_id =3D of_get_property(np, "reg", NULL);
> >       phy_interface_t phy_mode;
> >       struct phylink *phylink;
> > @@ -2940,6 +2941,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struc=
t device_node *np)
> >       else
> >               eth->netdev[id]->max_mtu =3D MTK_MAX_RX_LENGTH_2K - MTK_R=
X_ETH_HLEN;
> >
> > +     if (label)
> > +             strscpy(eth->netdev[id]->name, label, IFNAMSIZ);
>
> It is better to use alloc_netdev_mqs() so you get validation the name
> is unique.
It doesn't look like the name validation happens until the netdev is
registered, and it does not get registered at alloc, right?

I do agree that it's better to use the correct name in the first place
instead of renaming, regardless, so using alloc_netdev_mqs() seems
like a better solution - I'll make the change.

Ilya
