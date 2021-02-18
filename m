Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3731ED65
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhBRRfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhBRPJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 10:09:24 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C0BC061788
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 07:08:16 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id q8so1028573qvx.11
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 07:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JSZMhQtFwQmcHJuRQN1k7+NRHL2GRstbwzpb8C4ob/c=;
        b=fE1sCg7gc4lQ/0DD/xLqQyrfl13aEIdr9kAsgJJ27nQMZaub+6324yTe905ZwAtmX9
         6v+SDXlrxNn1LlswVlFpJCUOetY9gZzJy8mo11vJH1raarXPf81fYovt1b+h8OwiZnVZ
         fTtB7kNfZD14wMVfjnXzfzRLrUm/XbdQg6EWxLxrmL9uHxSaVtQAEiYffuwoSJx/d3yS
         4JhoHod/R7dwtZtR+HQ5xI7cgJsmhUamEJBjL/QdREVTfkmnH0J3PbEkgq2Mcm4S0kQy
         0/VERD7LBnird+jxhRZZYd3M3FB8hqiBuOv9OgWgnQXEsfLXSHg8hRpKx/NfsCkeLf+o
         Bdyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JSZMhQtFwQmcHJuRQN1k7+NRHL2GRstbwzpb8C4ob/c=;
        b=rPS3yqDc+FLG+16TKRJbUiXt/xBvbxbLAqu4+vER0j8GiZ1dkSzSc8l0FWUPrrB6So
         sLiouvVBVS5hBHHdKwjDzx8V09OduLgE50fCqTeyfWZ3+Y1tq63bDGdlgW5hLpzEh+nA
         n1ClXl5jMqkW1dPmHEaF2Dj/aJL/qJ5dngaffg56Zm71J/LZ3X/Qf6jhOT4dY+3EW5eg
         uIJlmF8+h0XJxKRk2x2pE0wlMMPkEiTuxxmcsvIJMoSBG550GX/3T/yGTS5nS10r/Vh/
         dLOIlTNZCld0H/2Lnlu2WaATsay+07uzE8va5DANImJx26HC92KOkerocUOuHgXIB/9D
         Px8g==
X-Gm-Message-State: AOAM5332blRD1o18J+jXc7uVkLvV1QNiaay4hLiuJQPC96OfqzfCixlg
        m7SKBQ45lAZFkhUSRw2M8lMBK3IMJw7wAeFTSCJo0g==
X-Google-Smtp-Source: ABdhPJxVVbnGNWMd3ujkcA2sMnOF/xQscxlRWIR0Wf4FXSfzuX2BTwWf+o1aOYkmpP6g+Ako3AIm2KfE6mzJzWqTr2I=
X-Received: by 2002:a0c:eb92:: with SMTP id x18mr4534399qvo.10.1613660896100;
 Thu, 18 Feb 2021 07:08:16 -0800 (PST)
MIME-Version: 1.0
References: <1613652123-19021-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1613652123-19021-1-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 18 Feb 2021 16:08:05 +0100
Message-ID: <CAPv3WKfsmJuV909D+os3ukH5F3X1oRPQrjD6y_t7R7U-AONxFw@mail.gmail.com>
Subject: Re: [net-next] net: mvpp2: skip RSS configurations on loopback port
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


czw., 18 lut 2021 o 13:42 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> PPv2 loopback port doesn't support RSS, so we should
> skip RSS configurations for this port.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 25 +++++++++++--------=
-
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 10c17d1..d415447 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4699,9 +4699,10 @@ static void mvpp2_irqs_deinit(struct mvpp2_port *p=
ort)
>         }
>  }
>
> -static bool mvpp22_rss_is_supported(void)
> +static bool mvpp22_rss_is_supported(struct mvpp2_port *port)
>  {
> -       return queue_mode =3D=3D MVPP2_QDIST_MULTI_MODE;
> +       return (queue_mode =3D=3D MVPP2_QDIST_MULTI_MODE) &&
> +               !(port->flags & MVPP2_F_LOOPBACK);
>  }
>
>  static int mvpp2_open(struct net_device *dev)
> @@ -5513,7 +5514,7 @@ static int mvpp2_ethtool_get_rxnfc(struct net_devic=
e *dev,
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         int ret =3D 0, i, loc =3D 0;
>
> -       if (!mvpp22_rss_is_supported())
> +       if (!mvpp22_rss_is_supported(port))
>                 return -EOPNOTSUPP;
>
>         switch (info->cmd) {
> @@ -5548,7 +5549,7 @@ static int mvpp2_ethtool_set_rxnfc(struct net_devic=
e *dev,
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         int ret =3D 0;
>
> -       if (!mvpp22_rss_is_supported())
> +       if (!mvpp22_rss_is_supported(port))
>                 return -EOPNOTSUPP;
>
>         switch (info->cmd) {
> @@ -5569,7 +5570,9 @@ static int mvpp2_ethtool_set_rxnfc(struct net_devic=
e *dev,
>
>  static u32 mvpp2_ethtool_get_rxfh_indir_size(struct net_device *dev)
>  {
> -       return mvpp22_rss_is_supported() ? MVPP22_RSS_TABLE_ENTRIES : 0;
> +       struct mvpp2_port *port =3D netdev_priv(dev);
> +
> +       return mvpp22_rss_is_supported(port) ? MVPP22_RSS_TABLE_ENTRIES :=
 0;
>  }
>
>  static int mvpp2_ethtool_get_rxfh(struct net_device *dev, u32 *indir, u8=
 *key,
> @@ -5578,7 +5581,7 @@ static int mvpp2_ethtool_get_rxfh(struct net_device=
 *dev, u32 *indir, u8 *key,
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         int ret =3D 0;
>
> -       if (!mvpp22_rss_is_supported())
> +       if (!mvpp22_rss_is_supported(port))
>                 return -EOPNOTSUPP;
>
>         if (indir)
> @@ -5596,7 +5599,7 @@ static int mvpp2_ethtool_set_rxfh(struct net_device=
 *dev, const u32 *indir,
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         int ret =3D 0;
>
> -       if (!mvpp22_rss_is_supported())
> +       if (!mvpp22_rss_is_supported(port))
>                 return -EOPNOTSUPP;
>
>         if (hfunc !=3D ETH_RSS_HASH_NO_CHANGE && hfunc !=3D ETH_RSS_HASH_=
CRC32)
> @@ -5617,7 +5620,7 @@ static int mvpp2_ethtool_get_rxfh_context(struct ne=
t_device *dev, u32 *indir,
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         int ret =3D 0;
>
> -       if (!mvpp22_rss_is_supported())
> +       if (!mvpp22_rss_is_supported(port))
>                 return -EOPNOTSUPP;
>         if (rss_context >=3D MVPP22_N_RSS_TABLES)
>                 return -EINVAL;
> @@ -5639,7 +5642,7 @@ static int mvpp2_ethtool_set_rxfh_context(struct ne=
t_device *dev,
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         int ret;
>
> -       if (!mvpp22_rss_is_supported())
> +       if (!mvpp22_rss_is_supported(port))
>                 return -EOPNOTSUPP;
>
>         if (hfunc !=3D ETH_RSS_HASH_NO_CHANGE && hfunc !=3D ETH_RSS_HASH_=
CRC32)
> @@ -5956,7 +5959,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
>         mvpp2_cls_oversize_rxq_set(port);
>         mvpp2_cls_port_config(port);
>
> -       if (mvpp22_rss_is_supported())
> +       if (mvpp22_rss_is_supported(port))
>                 mvpp22_port_rss_init(port);
>
>         /* Provide an initial Rx packet size */
> @@ -6861,7 +6864,7 @@ static int mvpp2_port_probe(struct platform_device =
*pdev,
>         dev->hw_features |=3D features | NETIF_F_RXCSUM | NETIF_F_GRO |
>                             NETIF_F_HW_VLAN_CTAG_FILTER;
>
> -       if (mvpp22_rss_is_supported()) {
> +       if (mvpp22_rss_is_supported(port)) {
>                 dev->hw_features |=3D NETIF_F_RXHASH;
>                 dev->features |=3D NETIF_F_NTUPLE;
>         }
> --
> 1.9.1
>

Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Thanks!
