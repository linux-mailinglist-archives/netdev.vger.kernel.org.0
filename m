Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0857D36607B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbhDTT63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhDTT62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:58:28 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85077C06174A;
        Tue, 20 Apr 2021 12:57:54 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id l21so3125415iob.1;
        Tue, 20 Apr 2021 12:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ulOh35YKTzDGjHHbOIeKgCUjEcwsBwlNnX1HkWl6feU=;
        b=hBVbeV4BnJGRV3FquaMNFY/ntM0zt3JBUFcQsMJEsKzY0P5cmc7WNpusW18VkSN+za
         Dn75WQbqI+m0NWAJLwp2P4O6SRuNKeAVPjt+g7EBTmL2TjwB06SJFC4vNQe6d2xYQ1VX
         S2Sn3TpTxLY9z0lmHSmt3TQJlvR2hVuWJ7j9PoOS0ffJIL4c0cTLRakKwljssQffYaJY
         /n4dU8E4sr+5sqCh64amQMw1Gk2jk7qF6NC9DzZH6g/9GmjPqtUy2NusyMxvA6KxoO60
         Q/IO5lDqPfGgaKM0eSrxM92CudrgLCFqexslTn19gyZ/nnUYjKZ6zrX10QIPWamkgUOX
         tFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ulOh35YKTzDGjHHbOIeKgCUjEcwsBwlNnX1HkWl6feU=;
        b=ZXOesiSFR6/WjzcmQr7PQuRhniVuyvyRzlrCoaQurfc+mhFOqktWqGTTIB7GSb5dKY
         ES8xKn+4NONjMzp2wMOkfGSArWrv73SlgMUgZcrZvbFWDdv0jc+Cu5DmSF9RqCMRCeW4
         mH+3a3a6OE0fY8lHc8HnZHDHjI9mCVbvHV6UcxvGMR7qg35PGkrp8UR+gZvaNWSnw/0K
         H9IXfqLIeBR8nkKv7FZq03Bkl7bngwr34i7nAXO2B6zseyr7ZXPek7C9NffByAzaSp7F
         KOhsBx1tjPK5Y1NCev6Oh7T4Let+xEpOle9GH9vRPyP1igHkbxxdWf7NmL41Ub0ZuRCH
         5jUQ==
X-Gm-Message-State: AOAM530yMVz21GMbxo97vvKYM9OVm834KzcMbqU+8cT+3AzKsKpUEg8q
        q2VehD0oXSAJXUK735N89bQr+p3V5C+Hi3OjIgk=
X-Google-Smtp-Source: ABdhPJyMtm2IMk51TN8sNwc+pk0lMCf5V4+rL5Se/aXrIjyF3C9M7dwVP19yTmlfQ0ZT0pj/BxHd6sVsIRvAtY4pj3Y=
X-Received: by 2002:a6b:fc05:: with SMTP id r5mr20312524ioh.103.1618948674007;
 Tue, 20 Apr 2021 12:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
 <20210419154659.44096-3-ilya.lipnitskiy@gmail.com> <20210420195132.GA3686955@robh.at.kernel.org>
In-Reply-To: <20210420195132.GA3686955@robh.at.kernel.org>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Tue, 20 Apr 2021 12:57:43 -0700
Message-ID: <CALCv0x2SG=0kBRnxfSPxi+FvaBK=QGPHQkHWHvTXOw64KawPUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: ethernet: mediatek: support custom
 GMAC label
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
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

On Tue, Apr 20, 2021 at 12:51 PM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Apr 19, 2021 at 08:46:59AM -0700, Ilya Lipnitskiy wrote:
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
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.c
> > index 6b00c12c6c43..df3cda63a8c5 100644
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
> > @@ -2867,9 +2868,10 @@ static int mtk_add_mac(struct mtk_eth *eth, stru=
ct device_node *np)
> >               return -EINVAL;
> >       }
> >
> > -     eth->netdev[id] =3D alloc_etherdev(sizeof(*mac));
> > +     eth->netdev[id] =3D alloc_netdev(sizeof(*mac), label ? label : "e=
th%d",
> > +                                    NET_NAME_UNKNOWN, ether_setup);
>
> 'label' is generally supposed to correspond to the sticker for the
> device connector for a human to id. I can't really tell if that's the
> case here. I don't see how 'gmacX' vs. 'ethX' maps to DSA master vs.
> slave.
The ports on devices such as Ubiquiti ER-X are named eth0 through
eth4, all of them DSA slaves. The gmac (DSA master) is hard-coded to
eth0 without this change.
>
> I don't think this should be handled within a specific driver either. If
> we're going to have a way to name things, then fix it in
> alloc_etherdev().
>
> It can also be argued that device naming for userspace is a userspace
> (udev) problem.
Yeah, that is a valid argument. We can drop this changeset if the
agreement is that it doesn't belong in the specific driver or the
kernel-space at all.
Some discussion (and device picture) here if you are interested:
https://github.com/openwrt/openwrt/pull/3971

Ilya
