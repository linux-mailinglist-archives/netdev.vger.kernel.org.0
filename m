Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AA830FC4E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbhBDTMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbhBDTBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:01:37 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E79C0617A9
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:18 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id l23so3159070qtq.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N9US/5TNc0Ok0VGdX9ZNieOm9Pf1B0RTE4+h0FHKiuk=;
        b=pbDl3mO+6QkOjkpgzThk9A/rv100jH0QMtWDj/tR+zPF1tdHeI0phwXjjPePwcixFH
         Guov4anWa/y27woOBpf/qJbn9SXINCONz/w7pQ4iyMpADrP7B+X2r4dSUTDzsmcNC5il
         DrAuh50UT/RhFhvIuSLanwXxY3a/MzhCvn/CUaPbTfMphjLONHoaqjkk2nk5Gev260p0
         eAGdLMk6teSE83K9lz2auJW1UFbE8Nd0otRFOOFsLfLEFr3fQr43wE1okvSTm746lK/B
         Wvjnc4xiZLfjPzBWWeI4+6MfGV4OYoW7pEB8GKW2OB2V7EeLslDtfN6/pyYx6Z1uw+FB
         k8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N9US/5TNc0Ok0VGdX9ZNieOm9Pf1B0RTE4+h0FHKiuk=;
        b=ohuo8NDk8enqCgPkeTJMV2T8frBj4oNAKbL3BrsarmPXvyx27u+XDDyTicBJwadSig
         4Qlu7qNdW0DiHUbqX0kFjxBlbZpULVWdoCfukMFKTzKOEdwMG70Aeov1EMfCkDYfz/zD
         c/RoLcSxNJh3BUooFdw/kDchfYYOwhqa/6WodFT1dRAJN5nqk2F8p4kFv/oTAHu2cfK4
         exCuZZ4QNqmm3+LboiXZgFLXki6lbIIljmxESkFkcyo89p7Xe9e2NQO1jNZ9Xf5Ru33y
         KkTfwIj+IhPePX16oIzxROoPghd+zlXXS0PygH/dP3RpT0WMBWvyOzfiDj55yv/G8JQo
         PVdg==
X-Gm-Message-State: AOAM531I2KwLfZq8crjo38OhCU2iQQmjEswF15DHhqnpzrGguji76LwP
        gvl8F0L8M82iqMWlkBgp5uxSzgZjsVH1hW51D+sTiw==
X-Google-Smtp-Source: ABdhPJwwFwAy3Zm/OAQwuxbMWkD6r6yUM7IFHt+usGrI1/dv2Qayk6IRQGrc2gR0VKmN1cclGDI6tNhaOiGBCbr8FNo=
X-Received: by 2002:ac8:130d:: with SMTP id e13mr1007372qtj.216.1612465218070;
 Thu, 04 Feb 2021 11:00:18 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com> <1612253821-1148-11-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-11-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 20:00:07 +0100
Message-ID: <CAPv3WKcO5TLMrsTLMumG1fc=cPA4JLSh4JMBgSjT45oiCgxLLw@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 10/15] net: mvpp2: add RXQ flow control configurations
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
> This patch adds RXQ flow control configurations.
> Flow control disabled by default.
> Minimum ring size limited to 1024 descriptors.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  35 +++++-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 116 ++++++++++++++++++=
++
>  2 files changed, 150 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/eth=
ernet/marvell/mvpp2/mvpp2.h
> index e010410..0f27be0 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -766,9 +766,36 @@
>  #define MSS_SRAM_SIZE                  0x800
>  #define MSS_FC_COM_REG                 0
>  #define FLOW_CONTROL_ENABLE_BIT                BIT(0)
> +#define FLOW_CONTROL_UPDATE_COMMAND_BIT        BIT(31)
>  #define FC_QUANTA                      0xFFFF
>  #define FC_CLK_DIVIDER                 100
> -#define MSS_THRESHOLD_STOP             768
> +
> +#define MSS_RXQ_TRESH_BASE             0x200
> +#define MSS_RXQ_TRESH_OFFS             4
> +#define MSS_RXQ_TRESH_REG(q, fq)       (MSS_RXQ_TRESH_BASE + (((q) + (fq=
)) \
> +                                       * MSS_RXQ_TRESH_OFFS))
> +
> +#define MSS_RXQ_TRESH_START_MASK       0xFFFF
> +#define MSS_RXQ_TRESH_STOP_MASK                (0xFFFF << MSS_RXQ_TRESH_=
STOP_OFFS)
> +#define MSS_RXQ_TRESH_STOP_OFFS                16
> +
> +#define MSS_RXQ_ASS_BASE       0x80
> +#define MSS_RXQ_ASS_OFFS       4
> +#define MSS_RXQ_ASS_PER_REG    4
> +#define MSS_RXQ_ASS_PER_OFFS   8
> +#define MSS_RXQ_ASS_PORTID_OFFS        0
> +#define MSS_RXQ_ASS_PORTID_MASK        0x3
> +#define MSS_RXQ_ASS_HOSTID_OFFS        2
> +#define MSS_RXQ_ASS_HOSTID_MASK        0x3F
> +
> +#define MSS_RXQ_ASS_Q_BASE(q, fq) ((((q) + (fq)) % MSS_RXQ_ASS_PER_REG) =
        \
> +                                 * MSS_RXQ_ASS_PER_OFFS)
> +#define MSS_RXQ_ASS_PQ_BASE(q, fq) ((((q) + (fq)) / MSS_RXQ_ASS_PER_REG)=
 \
> +                                  * MSS_RXQ_ASS_OFFS)
> +#define MSS_RXQ_ASS_REG(q, fq) (MSS_RXQ_ASS_BASE + MSS_RXQ_ASS_PQ_BASE(q=
, fq))
> +
> +#define MSS_THRESHOLD_STOP     768
> +#define MSS_THRESHOLD_START    1024
>
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
> @@ -1026,6 +1053,9 @@ struct mvpp2 {
>
>         /* Global TX Flow Control config */
>         bool global_tx_fc;
> +
> +       /* Spinlocks for CM3 shared memory configuration */
> +       spinlock_t mss_spinlock;
>  };
>
>  struct mvpp2_pcpu_stats {
> @@ -1188,6 +1218,9 @@ struct mvpp2_port {
>         bool rx_hwtstamp;
>         enum hwtstamp_tx_types tx_hwtstamp_type;
>         struct mvpp2_hwtstamp_queue tx_hwtstamp_queue[2];
> +
> +       /* Firmware TX flow control */
> +       bool tx_fc;
>  };
>
>  /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 770f45a..d778ae1 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -742,6 +742,110 @@ static void *mvpp2_buf_alloc(struct mvpp2_port *por=
t,
>         return data;
>  }
>
> +/* Routine enable flow control for RXQs condition */
> +static void mvpp2_rxq_enable_fc(struct mvpp2_port *port)
> +{
> +       int val, cm3_state, host_id, q;
> +       int fq =3D port->first_rxq;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->priv->mss_spinlock, flags);
> +
> +       /* Remove Flow control enable bit to prevent race between FW and =
Kernel
> +        * If Flow control were enabled, it would be re-enabled.

Nit:

s/were/was/

Thanks,
Marcin


> +        */
> +       val =3D mvpp2_cm3_read(port->priv, MSS_FC_COM_REG);
> +       cm3_state =3D (val & FLOW_CONTROL_ENABLE_BIT);
> +       val &=3D ~FLOW_CONTROL_ENABLE_BIT;
> +       mvpp2_cm3_write(port->priv, MSS_FC_COM_REG, val);
> +
> +       /* Set same Flow control for all RXQs */
> +       for (q =3D 0; q < port->nrxqs; q++) {
> +               /* Set stop and start Flow control RXQ thresholds */
> +               val =3D MSS_THRESHOLD_START;
> +               val |=3D (MSS_THRESHOLD_STOP << MSS_RXQ_TRESH_STOP_OFFS);
> +               mvpp2_cm3_write(port->priv, MSS_RXQ_TRESH_REG(q, fq), val=
);
> +
> +               val =3D mvpp2_cm3_read(port->priv, MSS_RXQ_ASS_REG(q, fq)=
);
> +               /* Set RXQ port ID */
> +               val &=3D ~(MSS_RXQ_ASS_PORTID_MASK << MSS_RXQ_ASS_Q_BASE(=
q, fq));
> +               val |=3D (port->id << MSS_RXQ_ASS_Q_BASE(q, fq));
> +               val &=3D ~(MSS_RXQ_ASS_HOSTID_MASK << (MSS_RXQ_ASS_Q_BASE=
(q, fq)
> +                       + MSS_RXQ_ASS_HOSTID_OFFS));
> +
> +               /* Calculate RXQ host ID:
> +                * In Single queue mode: Host ID equal to Host ID used fo=
r
> +                *                       shared RX interrupt
> +                * In Multi queue mode: Host ID equal to number of
> +                *                      RXQ ID / number of CoS queues
> +                * In Single resource mode: Host ID always equal to 0
> +                */
> +               if (queue_mode =3D=3D MVPP2_QDIST_SINGLE_MODE)
> +                       host_id =3D port->nqvecs;
> +               else if (queue_mode =3D=3D MVPP2_QDIST_MULTI_MODE)
> +                       host_id =3D q;
> +               else
> +                       host_id =3D 0;
> +
> +               /* Set RXQ host ID */
> +               val |=3D (host_id << (MSS_RXQ_ASS_Q_BASE(q, fq)
> +                       + MSS_RXQ_ASS_HOSTID_OFFS));
> +
> +               mvpp2_cm3_write(port->priv, MSS_RXQ_ASS_REG(q, fq), val);
> +       }
> +
> +       /* Notify Firmware that Flow control config space ready for updat=
e */
> +       val =3D mvpp2_cm3_read(port->priv, MSS_FC_COM_REG);
> +       val |=3D FLOW_CONTROL_UPDATE_COMMAND_BIT;
> +       val |=3D cm3_state;
> +       mvpp2_cm3_write(port->priv, MSS_FC_COM_REG, val);
> +
> +       spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
> +}
> +
> +/* Routine disable flow control for RXQs condition */
> +static void mvpp2_rxq_disable_fc(struct mvpp2_port *port)
> +{
> +       int val, cm3_state, q;
> +       unsigned long flags;
> +       int fq =3D port->first_rxq;
> +
> +       spin_lock_irqsave(&port->priv->mss_spinlock, flags);
> +
> +       /* Remove Flow control enable bit to prevent race between FW and =
Kernel
> +        * If Flow control were enabled, it would be re-enabled.
> +        */
> +       val =3D mvpp2_cm3_read(port->priv, MSS_FC_COM_REG);
> +       cm3_state =3D (val & FLOW_CONTROL_ENABLE_BIT);
> +       val &=3D ~FLOW_CONTROL_ENABLE_BIT;
> +       mvpp2_cm3_write(port->priv, MSS_FC_COM_REG, val);
> +
> +       /* Disable Flow control for all RXQs */
> +       for (q =3D 0; q < port->nrxqs; q++) {
> +               /* Set threshold 0 to disable Flow control */
> +               val =3D 0;
> +               val |=3D (0 << MSS_RXQ_TRESH_STOP_OFFS);
> +               mvpp2_cm3_write(port->priv, MSS_RXQ_TRESH_REG(q, fq), val=
);
> +
> +               val =3D mvpp2_cm3_read(port->priv, MSS_RXQ_ASS_REG(q, fq)=
);
> +
> +               val &=3D ~(MSS_RXQ_ASS_PORTID_MASK << MSS_RXQ_ASS_Q_BASE(=
q, fq));
> +
> +               val &=3D ~(MSS_RXQ_ASS_HOSTID_MASK << (MSS_RXQ_ASS_Q_BASE=
(q, fq)
> +                       + MSS_RXQ_ASS_HOSTID_OFFS));
> +
> +               mvpp2_cm3_write(port->priv, MSS_RXQ_ASS_REG(q, fq), val);
> +       }
> +
> +       /* Notify Firmware that Flow control config space ready for updat=
e */
> +       val =3D mvpp2_cm3_read(port->priv, MSS_FC_COM_REG);
> +       val |=3D FLOW_CONTROL_UPDATE_COMMAND_BIT;
> +       val |=3D cm3_state;
> +       mvpp2_cm3_write(port->priv, MSS_FC_COM_REG, val);
> +
> +       spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
> +}
> +
>  /* Release buffer to BM */
>  static inline void mvpp2_bm_pool_put(struct mvpp2_port *port, int pool,
>                                      dma_addr_t buf_dma_addr,
> @@ -3006,6 +3110,9 @@ static void mvpp2_cleanup_rxqs(struct mvpp2_port *p=
ort)
>
>         for (queue =3D 0; queue < port->nrxqs; queue++)
>                 mvpp2_rxq_deinit(port, port->rxqs[queue]);
> +
> +       if (port->tx_fc)
> +               mvpp2_rxq_disable_fc(port);
>  }
>
>  /* Init all Rx queues for port */
> @@ -3018,6 +3125,10 @@ static int mvpp2_setup_rxqs(struct mvpp2_port *por=
t)
>                 if (err)
>                         goto err_cleanup;
>         }
> +
> +       if (port->tx_fc)
> +               mvpp2_rxq_enable_fc(port);
> +
>         return 0;
>
>  err_cleanup:
> @@ -4317,6 +4428,8 @@ static int mvpp2_check_ringparam_valid(struct net_d=
evice *dev,
>
>         if (ring->rx_pending > MVPP2_MAX_RXD_MAX)
>                 new_rx_pending =3D MVPP2_MAX_RXD_MAX;
> +       else if (ring->rx_pending < MSS_THRESHOLD_START)
> +               new_rx_pending =3D MSS_THRESHOLD_START;
>         else if (!IS_ALIGNED(ring->rx_pending, 16))
>                 new_rx_pending =3D ALIGN(ring->rx_pending, 16);
>
> @@ -7170,6 +7283,9 @@ static int mvpp2_probe(struct platform_device *pdev=
)
>                         priv->hw_version =3D MVPP23;
>         }
>
> +       /* Init mss lock */
> +       spin_lock_init(&priv->mss_spinlock);
> +
>         /* Initialize network controller */
>         err =3D mvpp2_init(pdev, priv);
>         if (err < 0) {
> --
> 1.9.1
>
