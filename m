Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555D56C06DE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 01:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCTAkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 20:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCTAkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 20:40:05 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB1613533
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 17:40:03 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id u9so304907qkp.8
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 17:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679272802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JD624h8ZvMG/AbmcGoI6WMUerZBHh1sB+0dNUQOAtD4=;
        b=qP5z0iZtSQEK4B+UiSaVKMDXPRGllxKXtNR3B9JWGD0x4ppA6J1fiCuGFe+jk2L326
         ChpFIW/p5rHdlujxlsLgeMcaOxViAywAg0HcuPHzO9V0GVce5JWCVISMUQ4QBE8BtLOD
         e2UXrqrPqzNcCcPnStsInFxt7hlyq2l6zMh7GIqsqPg5LfzqHvnFYm31l8Md/gc9NjwV
         peu/2W7I/PdG70ua34ZL6uREKxE4gZoqCs0IQqcANgMMcMo+8vu6ezfKAIaOvti3Ncy0
         zjKDPmiCCn719O3RU772JVbnWYq2795ZNdNKH/21U/tvkGXgwMpF90k/lW2H09p2FVJA
         nKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679272802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JD624h8ZvMG/AbmcGoI6WMUerZBHh1sB+0dNUQOAtD4=;
        b=2QjZVLfWoQWORYoulFABgJmvIBM1oAz3+JYt0/iYujenF5yjey61FQukAKPcQk3ZG8
         Hsdrf6JgFIsE58Bgjyx28vLR9DYByf68tTvE9UwyZvQZuTdQxjVb+lDrVKx3ZkvNkr3l
         QK5FE6lM4++i0LkT5wBHj0znQtfgOZgIISEMuqLWUUIM4mmx/Yp8TmCTwsV+DXo0Gl79
         NQlt0rGKueBrMjkRqqVnXlmVqzogbTNGS8lodWZgJA3Gse93CUegv7rCqCZ28EFEuNKE
         GID+d20HFXd1/M240BN89Wid/8/M3Ea8QRZphggiPOkmAeAqvtMKSCImNI8rxaegqyDF
         tdbA==
X-Gm-Message-State: AO0yUKXh97/3tz7nJ1KJ2Vjrk1m9kspoSN6IbILwR3xh5TytM70Gkf9e
        aLKS5VK7GbwhKvBSUsCXtyD2kGrmgJj9RuFV6L7ITdAS5ugEYA==
X-Google-Smtp-Source: AK7set9HdGZHlCYg5DqAEhkcTJLSVV6qeMYN02Sq/DkjqxX8ojqrLZGddEqXdtoPNqHbHkTJtl8+VvObChQjweHUx9w=
X-Received: by 2002:a05:620a:260a:b0:72b:25b4:565f with SMTP id
 z10-20020a05620a260a00b0072b25b4565fmr2909951qko.5.1679272802530; Sun, 19 Mar
 2023 17:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com> <192db694-5bda-513c-31c5-96ec3b2425d9@gmail.com>
In-Reply-To: <192db694-5bda-513c-31c5-96ec3b2425d9@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 19 Mar 2023 17:39:51 -0700
Message-ID: <CAFXsbZo-pdP+b3iWyQwPe4FA4Pdxr-HO5-4rHB-ZLJApZyJ3DQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: smsc: export functions for use by
 meson-gxl PHY driver
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a dev board with SMSC LAN8720, this change was tested and confirmed
to still operate normally.

Signed-off-by: Chris Healy <healych@amazon.com>

On Sat, Mar 18, 2023 at 1:36=E2=80=AFPM Heiner Kallweit <hkallweit1@gmail.c=
om> wrote:
>
> The Amlogic Meson internal PHY's have the same register layout as
> certain SMSC PHY's (also for non-c22-standard registers). This seems
> to be more than just coincidence. Apparently they also need the same
> workaround for EDPD mode (energy detect power down). Therefore let's
> export SMSC PHY driver functionality for use by the meson-gxl PHY
> driver.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c  | 20 +++++++++++++-------
>  include/linux/smscphy.h |  6 ++++++
>  2 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 721871184..730964b85 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -54,7 +54,7 @@ static int smsc_phy_ack_interrupt(struct phy_device *ph=
ydev)
>         return rc < 0 ? rc : 0;
>  }
>
> -static int smsc_phy_config_intr(struct phy_device *phydev)
> +int smsc_phy_config_intr(struct phy_device *phydev)
>  {
>         int rc;
>
> @@ -75,8 +75,9 @@ static int smsc_phy_config_intr(struct phy_device *phyd=
ev)
>
>         return rc < 0 ? rc : 0;
>  }
> +EXPORT_SYMBOL_GPL(smsc_phy_config_intr);
>
> -static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
> +irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
>  {
>         int irq_status;
>
> @@ -95,18 +96,20 @@ static irqreturn_t smsc_phy_handle_interrupt(struct p=
hy_device *phydev)
>
>         return IRQ_HANDLED;
>  }
> +EXPORT_SYMBOL_GPL(smsc_phy_handle_interrupt);
>
> -static int smsc_phy_config_init(struct phy_device *phydev)
> +int smsc_phy_config_init(struct phy_device *phydev)
>  {
>         struct smsc_phy_priv *priv =3D phydev->priv;
>
> -       if (!priv->energy_enable || phydev->irq !=3D PHY_POLL)
> +       if (!priv || !priv->energy_enable || phydev->irq !=3D PHY_POLL)
>                 return 0;
>
>         /* Enable energy detect power down mode */
>         return phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
>                             MII_LAN83C185_EDPWRDOWN);
>  }
> +EXPORT_SYMBOL_GPL(smsc_phy_config_init);
>
>  static int smsc_phy_reset(struct phy_device *phydev)
>  {
> @@ -186,7 +189,7 @@ static int lan95xx_config_aneg_ext(struct phy_device =
*phydev)
>   * The workaround is only applicable to poll mode. Energy Detect Power-D=
own may
>   * not be used in interrupt mode lest link change detection becomes unre=
liable.
>   */
> -static int lan87xx_read_status(struct phy_device *phydev)
> +int lan87xx_read_status(struct phy_device *phydev)
>  {
>         struct smsc_phy_priv *priv =3D phydev->priv;
>         int err;
> @@ -195,7 +198,8 @@ static int lan87xx_read_status(struct phy_device *phy=
dev)
>         if (err)
>                 return err;
>
> -       if (!phydev->link && priv->energy_enable && phydev->irq =3D=3D PH=
Y_POLL) {
> +       if (!phydev->link && priv && priv->energy_enable &&
> +           phydev->irq =3D=3D PHY_POLL) {
>                 /* Disable EDPD to wake up PHY */
>                 int rc =3D phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
>                 if (rc < 0)
> @@ -229,6 +233,7 @@ static int lan87xx_read_status(struct phy_device *phy=
dev)
>
>         return err;
>  }
> +EXPORT_SYMBOL_GPL(lan87xx_read_status);
>
>  static int smsc_get_sset_count(struct phy_device *phydev)
>  {
> @@ -269,7 +274,7 @@ static void smsc_get_stats(struct phy_device *phydev,
>                 data[i] =3D smsc_get_stat(phydev, i);
>  }
>
> -static int smsc_phy_probe(struct phy_device *phydev)
> +int smsc_phy_probe(struct phy_device *phydev)
>  {
>         struct device *dev =3D &phydev->mdio.dev;
>         struct smsc_phy_priv *priv;
> @@ -294,6 +299,7 @@ static int smsc_phy_probe(struct phy_device *phydev)
>
>         return clk_set_rate(refclk, 50 * 1000 * 1000);
>  }
> +EXPORT_SYMBOL_GPL(smsc_phy_probe);
>
>  static struct phy_driver smsc_phy_driver[] =3D {
>  {
> diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
> index 1a136271b..80f37c1db 100644
> --- a/include/linux/smscphy.h
> +++ b/include/linux/smscphy.h
> @@ -28,4 +28,10 @@
>  #define MII_LAN83C185_MODE_POWERDOWN 0xC0 /* Power Down mode */
>  #define MII_LAN83C185_MODE_ALL       0xE0 /* All capable mode */
>
> +int smsc_phy_config_intr(struct phy_device *phydev);
> +irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev);
> +int smsc_phy_config_init(struct phy_device *phydev);
> +int lan87xx_read_status(struct phy_device *phydev);
> +int smsc_phy_probe(struct phy_device *phydev);
> +
>  #endif /* __LINUX_SMSCPHY_H__ */
> --
> 2.39.2
>
>
