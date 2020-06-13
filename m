Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514301F850E
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 22:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgFMULG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 16:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgFMULF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 16:11:05 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86ABC03E96F;
        Sat, 13 Jun 2020 13:11:03 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c35so8793866edf.5;
        Sat, 13 Jun 2020 13:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KL79S4+hUgkObdOESgcRP8w9AwkMqIeg4ECaVOYZgXE=;
        b=aAAn9YbnKyY3xakCpUQqmSfpJ8TBXDoz23BN7tfWAmWXBB8ya095FrkwGKa6V4kKOz
         bVgAz0+si/wTWRgNjiZVvgkc/KYla72rQEyHuzs+iDwIDglotg0+LiTFuPvA3NcNtgho
         9rD2ESZb45Crnwt7ueXOTwfS6j1IcY6DBWUntQTSaTh7rt1mHKyjnFAoi5GfL3dP/Epx
         B4zannS0VQNwZ8xScJkSWRSNNUDjtqas1c8EsTgGjT7YOWmFCFSFgXrW2wo/+VQc6ZUW
         nDKf9REM9haCNwESR3woKWiQKVHEWwzzn1x8dv49Q0EITlcTO9G0dmJPAh7F9teWRs2z
         A3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KL79S4+hUgkObdOESgcRP8w9AwkMqIeg4ECaVOYZgXE=;
        b=G1vaXoL1pg/l5GVy8HlwY1wz00FPjs+PqSio/D50ZKUGxqbTVf4g3psi2LwLdUQRUp
         LkHJQeHN4J5DQ3Kb0SXac0c/3fOxl42t7Yyrgx8OYu8A9q6TRWQlW4JMFurvFZdFpeMI
         c+ZTLK+08wq0mCQTHvJUB68nJfXTYV6Y9ZCYqMEKOkt9tNclC5QAQ6lk6ZOzwluPuAkP
         2jM/2XqadgSEb/Cwtn3XLvzLBLvu7AeM+iaC0BI6KcAx0Uyl19YOnHtvR5rT9f9AYZ5n
         5Tpmt4hSYQiStq2OOTBOJk0NU2OMnBi7iX/w/tmLK4A68lpkkyXc1bvMyLtaw3bCYj5K
         VnYQ==
X-Gm-Message-State: AOAM531EMbKNd5Z1ac5KbLW450Ur+cFhV1zMZjMfFcQtpYVE0+rG0aIO
        verxXECgUl3Nr50WJn63/tUET+vDurODUJdsa1E=
X-Google-Smtp-Source: ABdhPJwmxCe3l7l+Q2sFU7DbBzL37uzSSvcK6IcY+3h34anGdhvzqzUr8OcdrPcp1XZ5TYekTfV+lESNz/ueDQd6ei4=
X-Received: by 2002:a50:fb0b:: with SMTP id d11mr17783731edq.118.1592079060818;
 Sat, 13 Jun 2020 13:11:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592047530.git.noodles@earth.li> <05dba86946541267e64438c2001aaeea16916391.1592047530.git.noodles@earth.li>
In-Reply-To: <05dba86946541267e64438c2001aaeea16916391.1592047530.git.noodles@earth.li>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 13 Jun 2020 23:10:49 +0300
Message-ID: <CA+h21hoCb4w2s=KHT_nemFsYn-W9BctB=ycfTUb5DPdiW=SLiA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/2] net: dsa: qca8k: Improve SGMII interface handling
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Jun 2020 at 14:32, Jonathan McDowell <noodles@earth.li> wrote:
>
> This patch improves the handling of the SGMII interface on the QCA8K
> devices. Previously the driver did no configuration of the port, even if
> it was selected. We now configure it up in the appropriate
> PHY/MAC/Base-X mode depending on what phylink tells us we are connected
> to and ensure it is enabled.
>
> Tested with a device where the CPU connection is RGMII (i.e. the common
> current use case) + one where the CPU connection is SGMII. I don't have
> any devices where the SGMII interface is brought out to something other
> than the CPU.
>
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  drivers/net/dsa/qca8k.c | 33 ++++++++++++++++++++++++++++++++-
>  drivers/net/dsa/qca8k.h | 13 +++++++++++++
>  2 files changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index dadf9ab2c14a..da7d2b92ed3e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -673,6 +673,9 @@ qca8k_setup(struct dsa_switch *ds)
>         /* Flush the FDB table */
>         qca8k_fdb_flush(priv);
>
> +       /* We don't have interrupts for link changes, so we need to poll */
> +       priv->ds->pcs_poll = true;
> +

You can access ds directly here.

>         return 0;
>  }
>
> @@ -681,7 +684,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>                          const struct phylink_link_state *state)
>  {
>         struct qca8k_priv *priv = ds->priv;
> -       u32 reg;
> +       u32 reg, val;
>
>         switch (port) {
>         case 0: /* 1st CPU port */
> @@ -740,6 +743,34 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>         case PHY_INTERFACE_MODE_1000BASEX:
>                 /* Enable SGMII on the port */
>                 qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> +
> +               /* Enable/disable SerDes auto-negotiation as necessary */
> +               val = qca8k_read(priv, QCA8K_REG_PWS);
> +               if (phylink_autoneg_inband(mode))
> +                       val &= ~QCA8K_PWS_SERDES_AEN_DIS;
> +               else
> +                       val |= QCA8K_PWS_SERDES_AEN_DIS;
> +               qca8k_write(priv, QCA8K_REG_PWS, val);
> +
> +               /* Configure the SGMII parameters */
> +               val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> +
> +               val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> +                       QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> +
> +               if (dsa_is_cpu_port(ds, port)) {

I don't see any device tree in mainline for qca,qca8334 that uses
SGMII on the CPU port, but there are some assumptions being made here,
and there are also going to be some assumptions made in the MAC
driver, and I just want to make sure that those assumptions are not
going to be incompatible, so I would like you to make some
clarifications.
So there's a single SGMII interface which can go to port 0 (the CPU
port) or to port 6, right? The SGMII port can behave as an AN master
or as an AN slave, depending on whether MODE_CTRL is 1 or 2, or can
have a forced speed (if SERDES_AEN is disabled)?
We don't have a standard way to describe an SGMII AN master that is
not a PHY in the device tree, because I don't think anybody needed to
do that so far.
Typically a MAC would describe the link towards the CPU port of the
switch as a fixed-link. In that case, if the phy-mode is sgmii, it
would disable in-band autoneg, because there's nothing really to
negotiate (the link speed and duplex is fixed). For these, I think the
expectation is that the switch does not enable in-band autoneg either,
and has a fixed-link too. Per your configuration, you would disable
SerDes AN, and you would configure the port as SGMII AN master (PHY),
but that setting would be ignored because AN is disabled.
In other configurations, the MAC might want to receive in-band status
from the CPU port. In those cases, your answer to that problem seems
to be to implement phylink ops on both drivers, and to set both to
managed = "in-band-status" (MLO_AN_INBAND). This isn't a use case
explicitly described by phylink (I would even go as far as saying that
MLO_AN_INBAND means to be an SGMII AN slave), but it would work
because of the check that we are a CPU port.
As for the case of a cascaded qca8334-to-qca8334 setup, this would
again work, because on one of the switches, dsa_is_cpu_port would be
true and on the other one it would be false.
So I'm not suggesting we should change anything, I just want to make
sure I understand if this is the reason why you are configuring it
like this.

> +                       /* CPU port, we're talking to the CPU MAC, be a PHY */
> +                       val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +                       val |= QCA8K_SGMII_MODE_CTRL_PHY;
> +               } else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> +                       val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +                       val |= QCA8K_SGMII_MODE_CTRL_MAC;
> +               } else if (state->interface == PHY_INTERFACE_MODE_1000BASEX) {
> +                       val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +                       val |= QCA8K_SGMII_MODE_CTRL_BASEX;
> +               }
> +
> +               qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
>                 break;
>         default:
>                 dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 42d6ea24eb14..10ef2bca2cde 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -36,6 +36,8 @@
>  #define   QCA8K_MAX_DELAY                              3
>  #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN             BIT(24)
>  #define   QCA8K_PORT_PAD_SGMII_EN                      BIT(7)
> +#define QCA8K_REG_PWS                                  0x010
> +#define   QCA8K_PWS_SERDES_AEN_DIS                     BIT(7)
>  #define QCA8K_REG_MODULE_EN                            0x030
>  #define   QCA8K_MODULE_EN_MIB                          BIT(0)
>  #define QCA8K_REG_MIB                                  0x034
> @@ -69,6 +71,7 @@
>  #define   QCA8K_PORT_STATUS_LINK_UP                    BIT(8)
>  #define   QCA8K_PORT_STATUS_LINK_AUTO                  BIT(9)
>  #define   QCA8K_PORT_STATUS_LINK_PAUSE                 BIT(10)
> +#define   QCA8K_PORT_STATUS_FLOW_AUTO                  BIT(12)
>  #define QCA8K_REG_PORT_HDR_CTRL(_i)                    (0x9c + (_i * 4))
>  #define   QCA8K_PORT_HDR_CTRL_RX_MASK                  GENMASK(3, 2)
>  #define   QCA8K_PORT_HDR_CTRL_RX_S                     2
> @@ -77,6 +80,16 @@
>  #define   QCA8K_PORT_HDR_CTRL_ALL                      2
>  #define   QCA8K_PORT_HDR_CTRL_MGMT                     1
>  #define   QCA8K_PORT_HDR_CTRL_NONE                     0
> +#define QCA8K_REG_SGMII_CTRL                           0x0e0
> +#define   QCA8K_SGMII_EN_PLL                           BIT(1)
> +#define   QCA8K_SGMII_EN_RX                            BIT(2)
> +#define   QCA8K_SGMII_EN_TX                            BIT(3)
> +#define   QCA8K_SGMII_EN_SD                            BIT(4)
> +#define   QCA8K_SGMII_CLK125M_DELAY                    BIT(7)
> +#define   QCA8K_SGMII_MODE_CTRL_MASK                   (BIT(22) | BIT(23))
> +#define   QCA8K_SGMII_MODE_CTRL_BASEX                  (0 << 22)
> +#define   QCA8K_SGMII_MODE_CTRL_PHY                    (1 << 22)
> +#define   QCA8K_SGMII_MODE_CTRL_MAC                    (2 << 22)
>
>  /* EEE control registers */
>  #define QCA8K_REG_EEE_CTRL                             0x100
> --
> 2.20.1
>
