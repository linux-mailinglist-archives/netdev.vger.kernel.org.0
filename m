Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63330FC2D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbhBDTEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbhBDTB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:01:59 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91D7C06121C
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:25 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id u20so4406682qku.7
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gQEKwzGNeKKGM9QBw7KGFZRHia4VbYUsBnhBruWwEdQ=;
        b=D35KOdpBMQSjl+6ACFMu+ILDnl6aid8g7rUasGVUxtd2M8LrIzIoQ/bIsPvdfQqEJ4
         3UETXCq0jCS3N91/SY26kd6Hx9RvdtkSBJFT0D/AuKRbbM6jPOWlOuwzb1OWU426WA+I
         PmExL67moFfBSz/VstLs5S6BQU6xGmiUvA0QFjBIevHfbE2VeCjGWHDLbrvcabq7n7WN
         Dc5fqoErMCw11qJ9MD3+/MHyzHAGMbVLGXUJtE8yooMyy+dRIRCVj4bQjwrveDwaZRJi
         AQw5wOUK31A6DfDXRAHxh1XTlKn8HqyHQjGvljBdioeEL1Gs5uZqHJ8MehcQAVVljALY
         uQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gQEKwzGNeKKGM9QBw7KGFZRHia4VbYUsBnhBruWwEdQ=;
        b=csj0ok+/UpSmyh9KdtVrpWv7twKOBk/Gn9VguMfBYfA2+twKXanBu3USMhv+wILB68
         +tc8weRGRNZydlsH/aQamW1RMHFzrrBr1DL5L2stskagnk1bVAXBZxtvRvwZ6fk2VqO4
         jPXB8dw+cf5HojA2PJABUkkONn7bfKuzfz3cwr6/EKond3HoIhkxjmMO3aKuVCFgb2lL
         BeuL8HEA9EK4hEhHN86iaLFUt0RKvOK5i8WlSHYuXLO4x2M1onYXfuPNQaqveUm6R8MH
         i5TSCq0uvP+gVVdBG7ABAmZevQhrAdrQuvl/+ed1gT6g9xAJYL8uBckE3C1sTShH2dpI
         pt3g==
X-Gm-Message-State: AOAM533PIgzCayP/5b73ei2oLwoIU5NupintsDiuHFmcugfAXy0fQmPP
        oTPK+xenyloBIpokHTZjIf1pU8ZUWSGVYjK1JDMbDA==
X-Google-Smtp-Source: ABdhPJzYjUJBUq3mpxZGL+CfaOdtDhDiVKASM4vPKJo+YY0v02HeiW/0YfPRcciJy87QFRxflpdpBBr7FdgS0KPUbAk=
X-Received: by 2002:a05:620a:66c:: with SMTP id a12mr563893qkh.385.1612465224922;
 Thu, 04 Feb 2021 11:00:24 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com> <1612253821-1148-14-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-14-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 20:00:13 +0100
Message-ID: <CAPv3WKeZWudzCV99Y0nnv5-7KZXBnVznCwJn40Wb86wNk7_gqA@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 13/15] net: mvpp2: add PPv23 RX FIFO flow control
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
> New FIFO flow control feature were added in PPv23.

s/were/was/

Thanks,
Marcin


> PPv2 FIFO polled by HW and trigger pause frame if FIFO
> fill level is below threshold.
> FIFO HW flow control enabled with CM3 RXQ&BM flow
> control with ethtool.
> Current  FIFO thresholds is:
> 9KB for port with maximum speed 10Gb/s port
> 4KB for port with maximum speed 5Gb/s port
> 2KB for port with maximum speed 1Gb/s port
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 15 ++++++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 53 +++++++++++++++++++=
+
>  2 files changed, 68 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index 1967493..9947385 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -770,6 +770,18 @@
>  #define MVPP2_TX_FIFO_THRESHOLD(kb)    \
>                 ((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
>
> +/* RX FIFO threshold in 1KB granularity */
> +#define MVPP23_PORT0_FIFO_TRSH (9 * 1024)
> +#define MVPP23_PORT1_FIFO_TRSH (4 * 1024)
> +#define MVPP23_PORT2_FIFO_TRSH (2 * 1024)
> +
> +/* RX Flow Control Registers */
> +#define MVPP2_RX_FC_REG(port)          (0x150 + 4 * (port))
> +#define     MVPP2_RX_FC_EN             BIT(24)
> +#define     MVPP2_RX_FC_TRSH_OFFS      16
> +#define     MVPP2_RX_FC_TRSH_MASK      (0xFF << MVPP2_RX_FC_TRSH_OFFS)
> +#define     MVPP2_RX_FC_TRSH_UNIT      256
> +
>  /* MSS Flow control */
>  #define MSS_SRAM_SIZE                  0x800
>  #define MSS_FC_COM_REG                 0
> @@ -1502,6 +1514,8 @@ struct mvpp2_bm_pool {
>
>  void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
>
> +void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en);
> +
>  #ifdef CONFIG_MVPP2_PTP
>  int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv);
>  void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
> @@ -1534,4 +1548,5 @@ static inline bool mvpp22_rx_hwtstamping(struct mvp=
p2_port *port)
>  {
>         return IS_ENABLED(CONFIG_MVPP2_PTP) && port->rx_hwtstamp;
>  }
> +
>  #endif
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index f153060..06d3239 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6537,6 +6537,8 @@ static void mvpp2_mac_link_up(struct phylink_config=
 *config,
>                         mvpp2_bm_pool_update_fc(port, port->pool_long, tx=
_pause);
>                         mvpp2_bm_pool_update_fc(port, port->pool_short, t=
x_pause);
>                 }
> +               if (port->priv->hw_version =3D=3D MVPP23)
> +                       mvpp23_rx_fifo_fc_en(port->priv, port->id, tx_pau=
se);
>         }
>
>         mvpp2_port_enable(port);
> @@ -7005,6 +7007,55 @@ static void mvpp22_rx_fifo_init(struct mvpp2 *priv=
)
>         mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);
>  }
>
> +/* Configure Rx FIFO Flow control thresholds */
> +static void mvpp23_rx_fifo_fc_set_tresh(struct mvpp2 *priv)
> +{
> +       int port, val;
> +
> +       /* Port 0: maximum speed -10Gb/s port
> +        *         required by spec RX FIFO threshold 9KB
> +        * Port 1: maximum speed -5Gb/s port
> +        *         required by spec RX FIFO threshold 4KB
> +        * Port 2: maximum speed -1Gb/s port
> +        *         required by spec RX FIFO threshold 2KB
> +        */
> +
> +       /* Without loopback port */
> +       for (port =3D 0; port < (MVPP2_MAX_PORTS - 1); port++) {
> +               if (port =3D=3D 0) {
> +                       val =3D (MVPP23_PORT0_FIFO_TRSH / MVPP2_RX_FC_TRS=
H_UNIT)
> +                               << MVPP2_RX_FC_TRSH_OFFS;
> +                       val &=3D MVPP2_RX_FC_TRSH_MASK;
> +                       mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
> +               } else if (port =3D=3D 1) {
> +                       val =3D (MVPP23_PORT1_FIFO_TRSH / MVPP2_RX_FC_TRS=
H_UNIT)
> +                               << MVPP2_RX_FC_TRSH_OFFS;
> +                       val &=3D MVPP2_RX_FC_TRSH_MASK;
> +                       mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
> +               } else {
> +                       val =3D (MVPP23_PORT2_FIFO_TRSH / MVPP2_RX_FC_TRS=
H_UNIT)
> +                               << MVPP2_RX_FC_TRSH_OFFS;
> +                       val &=3D MVPP2_RX_FC_TRSH_MASK;
> +                       mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
> +               }
> +       }
> +}
> +
> +/* Configure Rx FIFO Flow control thresholds */
> +void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en)
> +{
> +       int val;
> +
> +       val =3D mvpp2_read(priv, MVPP2_RX_FC_REG(port));
> +
> +       if (en)
> +               val |=3D MVPP2_RX_FC_EN;
> +       else
> +               val &=3D ~MVPP2_RX_FC_EN;
> +
> +       mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
> +}
> +
>  static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int size=
)
>  {
>         int threshold =3D MVPP2_TX_FIFO_THRESHOLD(size);
> @@ -7156,6 +7207,8 @@ static int mvpp2_init(struct platform_device *pdev,=
 struct mvpp2 *priv)
>         } else {
>                 mvpp22_rx_fifo_init(priv);
>                 mvpp22_tx_fifo_init(priv);
> +               if (priv->hw_version =3D=3D MVPP23)
> +                       mvpp23_rx_fifo_fc_set_tresh(priv);
>         }
>
>         if (priv->hw_version =3D=3D MVPP21)
> --
> 1.9.1
>
