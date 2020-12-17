Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD7C2DCFFB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgLQLBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQLBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:01:44 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2DC061282
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 03:01:02 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id h4so21033922qkk.4
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 03:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9Imzg8e8xlIRFIOdl2DY/7SAx12RI7ioSsy2IScl6E0=;
        b=kDRP/xhfnrHzPCmRqaLzaDTwvF0zEJZMvJLflkpZyd9nJKClvtZtWymdXNIXWfZqeB
         /VM5SySkKDDqlEsAgUa8MmkMLPKZVk9tWSDs7Pjm8LEWdCDWuCEnf5dpgpBvrqgc5Myl
         xqytZN6Up1tZdVDylWxTKOHaY10a9oJacBRIO2kidBjPdCbmuzEsd20tivJrK/BaRhnD
         VBJ0DZhlVpF2DqRZZfVUsX/o2WRUiXJyUm+p+I3fUDlORxHI/oBfyNeOStAY/Tmd2xx+
         hmt4PAUc9x1Ai83/YUdPLhLJ1/RpStpc+DqtP/25/uxvDmlarPSTB8wEogXsm8BtgUD6
         Cbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9Imzg8e8xlIRFIOdl2DY/7SAx12RI7ioSsy2IScl6E0=;
        b=B6nqiAL8A9+PozoSJnsaS/9OzgVoKaVSFd/3O2TiI4pA6R6s49UYG1SHBJ+rgB7uqC
         s2PD5m1kxH5xLVg3BLb4lnCmiyqIKNQ/qAS1S3dNkBcQMd9JALwcQMA9kaupWRBPfh9S
         w7eK437933YfBmfc0aDRwtUdCcDL7B3A2SNaBvwzPkdwllQhSCCEPVbPSNiZG0vnKjId
         VfCzt+MOAPe5Ww/Dl35ciWs8mZeJEPkNgU1zv6eJXvRWS5+hrmAOfS4muxQhq1gxtM0U
         9DMXCsYJ8PI0qnMYqkUuXR5kSnRm0KHl96pr1PfjYxVgUcxTLtUmHN76bVxA0MgOQRhj
         ZR2Q==
X-Gm-Message-State: AOAM531xXwfwBujnO848zR0Zx431u3UiUxy2I19H8bFPjgkrMGISCjIf
        alvbrHCOhfPzM+dBHmcHtS6DpSGNKm4Oxi/zcR/Arg==
X-Google-Smtp-Source: ABdhPJw1il1BYSqi4VSEYZluhba8w6tFNcfSV2KFj5T4imgrdg26rf0keo4ft1+EWvlnT2aKbhc1lCQSgD05CEyFCIw=
X-Received: by 2002:a37:7806:: with SMTP id t6mr47141561qkc.360.1608202861827;
 Thu, 17 Dec 2020 03:01:01 -0800 (PST)
MIME-Version: 1.0
References: <1608198007-10143-1-git-send-email-stefanc@marvell.com> <1608198007-10143-2-git-send-email-stefanc@marvell.com>
In-Reply-To: <1608198007-10143-2-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 17 Dec 2020 12:00:49 +0100
Message-ID: <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net: mvpp2: disable force link UP during port
 init procedure
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

czw., 17 gru 2020 o 10:42 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Force link UP can be enabled by bootloader during tftpboot
> and breaks NFS support.
> Force link UP disabled during port init procedure.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---

What are the updates against v1? Please note them in this place for
individual patches and list all in the cover letter (in case sending a
group of patches).

Do you think it's a fix that should be backported to stable branches?
If yes, please add 'Fixes: <commit ID> ("commit title")' and it may be
good to add 'Cc: stable@vger.kernel.org' adjacent to the Signed-off-by
tag.

Thanks,
Marcin

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
> 1.9.1
>
