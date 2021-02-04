Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA8930FC3E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbhBDTI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbhBDTB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:01:57 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C05C0617AA
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:22 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id t63so4452084qkc.1
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JmmlZWo7Xqrp0UE9G+4VhAKI5wBoXIwLF2jVC9LxlW0=;
        b=jtdVq2ndbXQRoH/ql3Xr39yaBcJvlZ1ccC+ySOc27+DjYhmL9FdkUcH+fhDLPWjaw7
         zUwyk/bIfAnD1dxbXCTwiHURUErPXrt1+P/4gpxreawPMta0RxYB3EeaxXXjl4wGbHfZ
         5n1ymMC1P/FhksOzjEUqqre9Aflu5Jo8jB3D1PomXzgBB+Dw9kAq11RMFEDj3DpzyFYa
         BT1H/1bHzuQYrc90lXg/uhDUUbg8lvPTKFQeCEnL9pDkYhS90Xv5KvGAY1H1bMMgxd9n
         IuIE8v2+6d5go/l1Un0sWI+Yj8171CoK3iu+Zupyb+4RAO7wrKvxYXMWzF3aQFf+wO6E
         kdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JmmlZWo7Xqrp0UE9G+4VhAKI5wBoXIwLF2jVC9LxlW0=;
        b=AUsMDgnvOrR8kTm8y1MMKj6LLLK+GL2ZhyeK7sDz1lLgykJYlfqde7haAHvDO7At/4
         S4GW0jlZ3h+U0nlz0kppjnvGcDyhbBdWHVZbE0YEmE+BVG5UepaSzTvzj8BJDY3rwfO6
         sJ+tlkmnObSamlqY6Hw/1aLcZGDIlX9jEGSkwAlyadPQAvcLb5mwNmjTVJMhWdSmSeB0
         Q0zlYMTDS4t6vZqyeGyCywcDUkhO+tqN8sRJuaKmffi90sH7VoXxOjtx/a2RbX5gkDXW
         gcyUfpih0HCodJ9TSvDiUgGSRGajK/V/APS63pdG3jUP96CjCTgdYfjTnIWQ1nVsNw1R
         XE3g==
X-Gm-Message-State: AOAM532EVPVyo84Q4e8bu3GaA+KpBvgzpQceHf73pm+/aql7nbm3ymL0
        L0FMcsBSSkiGLPBfOw7w/2WL1wR1wMp7RFutorit4g==
X-Google-Smtp-Source: ABdhPJxZelanzMg9O5NxwZfwU3jsFfBgSpMqfIQyTbdtX5w+/XFZH4znCQy9Y24CiHRP6LJBzAYT2RJqOp9vQNWEHcM=
X-Received: by 2002:a37:9d97:: with SMTP id g145mr639226qke.300.1612465221466;
 Thu, 04 Feb 2021 11:00:21 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com> <1612253821-1148-13-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-13-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 20:00:10 +0100
Message-ID: <CAPv3WKdQ2cfsmrnSaWyfE871YYd9N=k_m=gygn1taoYC8Zy0Pw@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 12/15] net: mvpp2: add BM protection underrun
 feature support
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

wt., 2 lut 2021 o 09:18 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Feature double size of BPPI by decreasing number of pools from 16 to 8.

How about:
'The PP2v23 hardware supports a feature allowing to double the size of...' =
?

> Increasing of BPPI size protect BM drop from BPPI underrun.
> Underrun could occurred due to stress on DDR and as result slow buffer
> transition from BPPE to BPPI.
> New BPPI threshold recommended by spec is:
> BPPI low threshold - 640 buffers
> BPPI high threshold - 832 buffers
> Supported only in PPv23.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  8 +++++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 35 +++++++++++++++++++=
-
>  2 files changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index 9071ab6..1967493 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -324,6 +324,10 @@
>  #define     MVPP2_BM_HIGH_THRESH_MASK          0x7f0000
>  #define     MVPP2_BM_HIGH_THRESH_VALUE(val)    ((val) << \
>                                                 MVPP2_BM_HIGH_THRESH_OFFS=
)
> +#define     MVPP2_BM_BPPI_HIGH_THRESH          0x1E
> +#define     MVPP2_BM_BPPI_LOW_THRESH           0x1C
> +#define     MVPP23_BM_BPPI_HIGH_THRESH         0x34
> +#define     MVPP23_BM_BPPI_LOW_THRESH          0x28
>  #define MVPP2_BM_INTR_CAUSE_REG(pool)          (0x6240 + ((pool) * 4))
>  #define     MVPP2_BM_RELEASED_DELAY_MASK       BIT(0)
>  #define     MVPP2_BM_ALLOC_FAILED_MASK         BIT(1)
> @@ -352,6 +356,10 @@
>  #define MVPP2_OVERRUN_ETH_DROP                 0x7000
>  #define MVPP2_CLS_ETH_DROP                     0x7020
>
> +#define MVPP22_BM_POOL_BASE_ADDR_HIGH_REG      0x6310
> +#define     MVPP22_BM_POOL_BASE_ADDR_HIGH_MASK 0xff
> +#define     MVPP23_BM_8POOL_MODE               BIT(8)
> +
>  /* Hit counters registers */
>  #define MVPP2_CTRS_IDX                         0x7040
>  #define     MVPP22_CTRS_TX_CTR(port, txq)      ((txq) | ((port) << 3) | =
BIT(7))
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index bbefc7e..f153060 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -70,6 +70,11 @@ enum mvpp2_bm_pool_log_num {
>  module_param(queue_mode, int, 0444);
>  MODULE_PARM_DESC(queue_mode, "Set queue_mode (single=3D0, multi=3D1)");
>
> +static int bm_underrun_protect =3D 1;
> +
> +module_param(bm_underrun_protect, int, 0444);
> +MODULE_PARM_DESC(bm_underrun_protect, "Set BM underrun protect feature (=
0-1), def=3D1");
> +
>  /* Utility/helper methods */
>
>  void mvpp2_write(struct mvpp2 *priv, u32 offset, u32 data)
> @@ -424,6 +429,21 @@ static int mvpp2_bm_pool_create(struct device *dev, =
struct mvpp2 *priv,
>
>         val =3D mvpp2_read(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id));
>         val |=3D MVPP2_BM_START_MASK;
> +
> +       val &=3D ~MVPP2_BM_LOW_THRESH_MASK;
> +       val &=3D ~MVPP2_BM_HIGH_THRESH_MASK;
> +
> +       /* Set 8 Pools BPPI threshold if BM underrun protection feature
> +        * were enabled

Nit:
s/were/was/

Thanks,
Marcin


> +        */
> +       if (priv->hw_version =3D=3D MVPP23 && bm_underrun_protect) {
> +               val |=3D MVPP2_BM_LOW_THRESH_VALUE(MVPP23_BM_BPPI_LOW_THR=
ESH);
> +               val |=3D MVPP2_BM_HIGH_THRESH_VALUE(MVPP23_BM_BPPI_HIGH_T=
HRESH);
> +       } else {
> +               val |=3D MVPP2_BM_LOW_THRESH_VALUE(MVPP2_BM_BPPI_LOW_THRE=
SH);
> +               val |=3D MVPP2_BM_HIGH_THRESH_VALUE(MVPP2_BM_BPPI_HIGH_TH=
RESH);
> +       }
> +
>         mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
>
>         bm_pool->size =3D size;
> @@ -592,6 +612,16 @@ static int mvpp2_bm_pools_init(struct device *dev, s=
truct mvpp2 *priv)
>         return err;
>  }
>
> +/* Routine enable PPv23 8 pool mode */
> +static void mvpp23_bm_set_8pool_mode(struct mvpp2 *priv)
> +{
> +       int val;
> +
> +       val =3D mvpp2_read(priv, MVPP22_BM_POOL_BASE_ADDR_HIGH_REG);
> +       val |=3D MVPP23_BM_8POOL_MODE;
> +       mvpp2_write(priv, MVPP22_BM_POOL_BASE_ADDR_HIGH_REG, val);
> +}
> +
>  static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
>  {
>         enum dma_data_direction dma_dir =3D DMA_FROM_DEVICE;
> @@ -645,6 +675,9 @@ static int mvpp2_bm_init(struct device *dev, struct m=
vpp2 *priv)
>         if (!priv->bm_pools)
>                 return -ENOMEM;
>
> +       if (priv->hw_version =3D=3D MVPP23 && bm_underrun_protect)
> +               mvpp23_bm_set_8pool_mode(priv);
> +
>         err =3D mvpp2_bm_pools_init(dev, priv);
>         if (err < 0)
>                 return err;
> @@ -6491,7 +6524,7 @@ static void mvpp2_mac_link_up(struct phylink_config=
 *config,
>                              val);
>         }
>
> -       if (port->priv->global_tx_fc) {
> +       if (port->priv->global_tx_fc && bm_underrun_protect) {
>                 port->tx_fc =3D tx_pause;
>                 if (tx_pause)
>                         mvpp2_rxq_enable_fc(port);
> --
> 1.9.1
>
