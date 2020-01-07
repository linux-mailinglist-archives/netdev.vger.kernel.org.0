Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2314E132A6B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgAGPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:49:25 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41547 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAGPtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:49:25 -0500
Received: by mail-ed1-f68.google.com with SMTP id c26so50715505eds.8;
        Tue, 07 Jan 2020 07:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q2dBMzJh1iqJhUE2UWcOEtoI19XwUDJebl5Ro3YyPJU=;
        b=KUlABEirfWRnzjtocFxdIdVHqfMySuShVFGI6CrCqeviroT2bWoz7jMJ+ue0nO09Gs
         jx5GKl0ptt9RV17YIu2BLBI8Nbh5cj+teqlXm/Fe2pDPGOS/QuTTcF2hi6SXIUdCI9oH
         TzfVyBkXNDrvLIg13dWjGGkHmyU0L9pUmhk658bcVFejA9PVvmrAt5oYHsvO6FpUKZZ/
         m4CA+ZAxNRKigoTM2l1u71Y/lv+AmIH1QUVsSmZIWIlCdFIPaZ9TUArWn6okwCTsO4pI
         st1kdE6bEziDEJqxbjh1rtvS0ytNjfdgh81Mt47Js3oB2xKcLjcVefpmQ7tT9tRPPzGv
         ojDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q2dBMzJh1iqJhUE2UWcOEtoI19XwUDJebl5Ro3YyPJU=;
        b=aaeZdhKeCIJdnoLsEPYWPdboGhkyAArigdFWgqi9/ilejom6uYm7FoseKOpjP+pcoJ
         PmFk5kyasTe8fVvcFSSQeYZfRfH18FnF54mICLvCV/y2oH7Ki72tkO6Wc9bjWoti35/h
         rwHg3suFPFnh4+qfF4ac8scx+ozTfvR3cujkg+NKxqauuK8LkEPWz5sLBR7G6kfK0ZXg
         /4KoHATmtlc8WWv6yNKtFkiBgoPPoBAzpmJifH3gdQ0wIKBph6KuRRPjh9RyazSR6W/2
         nm6Aein5E2S/Govewm1a1JPeQZsATXEUkACNIBaBBHjT8TTrjJ4ykqjFf40klqwrKzGO
         iChw==
X-Gm-Message-State: APjAAAUiGMCJQOq+AU4a+SjMx+XFcMekWg9Vh1RrXDuObuDkCtTYqDSs
        PBwowgS3gFy8eH8Ny8s69nWKkmpTjpLQU1nGAjKbog==
X-Google-Smtp-Source: APXvYqzhf3gjK3FTDjFr5iw2WqmK9Jg7BY+62kmOfi7P7wa+NKewrDAuHRr/r5Q1CtrRCIy2HzoxKaKKII4JfC5I9mI=
X-Received: by 2002:a50:fb96:: with SMTP id e22mr515499edq.18.1578412163371;
 Tue, 07 Jan 2020 07:49:23 -0800 (PST)
MIME-Version: 1.0
References: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
In-Reply-To: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 Jan 2020 17:49:12 +0200
Message-ID: <CA+h21hpERd-yko+X9G-D9eFwu3LVq625qDUYvNGtEA8Ere_vYw@mail.gmail.com>
Subject: Re: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
To:     =?UTF-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>
Cc:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen,

On Tue, 7 Jan 2020 at 12:37, Johnson CH Chen (=E9=99=B3=E6=98=AD=E5=8B=B3)
<JohnsonCH.Chen@moxa.com> wrote:
>
> Add dma_endian_le to solve ethernet TX/RX problems for freescale ls1021a.=
 Without this, it will result in
> rx-busy-errors by ethtool, and transmit queue timeout in ls1021a's platfo=
rms.
>
> Signed-off-by: Johnson Chen <johnsonch.chen@moxa.com>
> ---

This patch is not valid. The endianness configuration in
eTSECx_DMACTRL is reserved and not applicable.
What is the value of SCFG_ETSECDMAMCR bits ETSEC_BD and ETSEC_FR_DATA
on your board? Typically this is configured by the bootloader.

>  drivers/net/ethernet/freescale/gianfar.c | 3 +++
>  drivers/net/ethernet/freescale/gianfar.h | 4 ++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ether=
net/freescale/gianfar.c
> index 72868a28b621..ab4e45199df9 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -833,6 +833,7 @@ static int gfar_of_init(struct platform_device *ofdev=
, struct net_device **pdev)
>
>         /* Find the TBI PHY.  If it's not there, we don't support SGMII *=
/
>         priv->tbi_node =3D of_parse_phandle(np, "tbi-handle", 0);
> +       priv->dma_endian_le =3D of_property_read_bool(np, "fsl,dma-endian=
-le");
>
>         return 0;
>
> @@ -1209,6 +1210,8 @@ static void gfar_start(struct gfar_private *priv)
>         /* Initialize DMACTRL to have WWR and WOP */
>         tempval =3D gfar_read(&regs->dmactrl);
>         tempval |=3D DMACTRL_INIT_SETTINGS;
> +       if (priv->dma_endian_le)
> +               tempval |=3D DMACTRL_LE;
>         gfar_write(&regs->dmactrl, tempval);
>
>         /* Make sure we aren't stopped */
> diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ether=
net/freescale/gianfar.h
> index 432c6a818ae5..aae07db5206b 100644
> --- a/drivers/net/ethernet/freescale/gianfar.h
> +++ b/drivers/net/ethernet/freescale/gianfar.h
> @@ -215,6 +215,7 @@ extern const char gfar_driver_version[];
>  #define DMACTRL_INIT_SETTINGS   0x000000c3
>  #define DMACTRL_GRS             0x00000010
>  #define DMACTRL_GTS             0x00000008
> +#define DMACTRL_LE             0x00008000
>
>  #define TSTAT_CLEAR_THALT_ALL  0xFF000000
>  #define TSTAT_CLEAR_THALT      0x80000000
> @@ -1140,6 +1141,9 @@ struct gfar_private {
>                 tx_pause_en:1,
>                 rx_pause_en:1;
>
> +       /* little endian dma buffer and descriptor host interface */
> +       unsigned int dma_endian_le;
> +
>         /* The total tx and rx ring size for the enabled queues */
>         unsigned int total_tx_ring_size;
>         unsigned int total_rx_ring_size;
> --
> 2.11.0
>
> Best regards,
> Johnson

Regards,
-Vladimir
