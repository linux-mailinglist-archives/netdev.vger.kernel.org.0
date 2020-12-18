Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD432DDD66
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 04:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbgLRDhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 22:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgLRDhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 22:37:11 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE32BC0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 19:36:30 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id a6so470348qtw.6
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 19:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AS4QO2aiPpRGxi4OIcY1tpp38QFNKOBoTfBX1bCvzo8=;
        b=2D+NhQiLBB+vTHtA1vZqk/qXLnSAU7ytpRZYo8CVqZoNpl6HFYIRNc7xHw+CkunziF
         IRJPGi0gSpATu+0p10FJOnTSfQerBpR0Dxrjs2JKGryTNNeNY2ljLO8Bk7ux1B+Tx1y1
         9LWJGRth5Y+PbXTPtM5MEEtD60Q0vlPgflSvKZdtyReS+TVj5cUPmnSGnxyxP4f1yd+x
         hTKNvVYeOKWhfybp5Wi8qQXkGsq74s4M5OHdPRjgi6nRZZrFBksT5WzJDLruyiQkmba1
         EAOrwJiitibtR8k3HBiOA+4xPLxg1DpfNJwFD+TTi3/EEOxBLP8D/BVVGnmsVcRDhBHV
         py5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AS4QO2aiPpRGxi4OIcY1tpp38QFNKOBoTfBX1bCvzo8=;
        b=qc33TUahy1AAWpK22VI3WC20BOCGqEPRWsp+GxxdyVPmsoN83wG2E5EYw2ioQMvRus
         DuQydOo2HWxF9O4Ckx25irmEI5EuKGiMCWQAmLlHD7koIcM+qFH54zbHd+P0tKNFG7jT
         YuznQhhLeo7fWi36FGwkGpLPyHfJkmjzVnEfO/vkg3y1VCcXJJwV5yMfeEgI2TnPmFI/
         JXtNLBi1X3STLyp6d40Wus2jfthO2qAXqKAc/oXNvNYMdAyX2x088FliWmvt4cGSCKgj
         R4y5ndIYzMMe3qdL1L+hw08I27/X4WDu+1MlCNZcL8Gm0M0S/9HEWfyKX8ruT38BYCpc
         dR+A==
X-Gm-Message-State: AOAM5302naWVbOMqGn+q+Yq/KoGETLpvpQSJHcXZ3GHQlIZhsuhsyN02
        7m8RsoXTuwcbYBkvu+4T1kjJeYOrmSZcKi16XrxpoA==
X-Google-Smtp-Source: ABdhPJzJme+8LABJvm0hH+CfYwtd+4qE2JHpIaQzDZutWN4YvBLGhZZszBDXEleaGkV0cl51IrMaeJjQjRvkNTZ8yLQ=
X-Received: by 2002:ac8:7b82:: with SMTP id p2mr2078557qtu.16.1608262590004;
 Thu, 17 Dec 2020 19:36:30 -0800 (PST)
MIME-Version: 1.0
References: <1608216735-14501-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1608216735-14501-1-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 18 Dec 2020 04:36:18 +0100
Message-ID: <CAPv3WKcL_mj=Zk8MrnQ_=m1nv5EzbpurYsLadSXMNZ3BKjzQVw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: mvpp2: disable force link UP during port init procedure
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

czw., 17 gru 2020 o 15:54 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Force link UP can be enabled by bootloader during tftpboot
> and breaks NFS support.
> Force link UP disabled during port init procedure.
>
> Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>
> Changes in v3:
> - Added Fixes tag.
> Changes in v2:
> - No changes.
>
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index d2b0506..0ad3177 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5479,7 +5479,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
>         struct mvpp2 *priv =3D port->priv;
>         struct mvpp2_txq_pcpu *txq_pcpu;
>         unsigned int thread;
> -       int queue, err;
> +       int queue, err, val;
>
>         /* Checks for hardware constraints */
>         if (port->first_rxq + port->nrxqs >
> @@ -5493,6 +5493,18 @@ static int mvpp2_port_init(struct mvpp2_port *port=
)
>         mvpp2_egress_disable(port);
>         mvpp2_port_disable(port);
>
> +       if (mvpp2_is_xlg(port->phy_interface)) {
> +               val =3D readl(port->base + MVPP22_XLG_CTRL0_REG);
> +               val &=3D ~MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
> +               val |=3D MVPP22_XLG_CTRL0_FORCE_LINK_DOWN;
> +               writel(val, port->base + MVPP22_XLG_CTRL0_REG);
> +       } else {
> +               val =3D readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> +               val &=3D ~MVPP2_GMAC_FORCE_LINK_PASS;
> +               val |=3D MVPP2_GMAC_FORCE_LINK_DOWN;
> +               writel(val, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> +       }
> +
>         port->tx_time_coal =3D MVPP2_TXDONE_COAL_USEC;
>
>         port->txqs =3D devm_kcalloc(dev, port->ntxqs, sizeof(*port->txqs)=
,
> --

I confirm the patch fixes issue - tested on CN913x-DB and RGMII port.
Other boards there I see no regression.

Acked-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
