Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2653D551706
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiFTLPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiFTLOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:14:51 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E061313EB8;
        Mon, 20 Jun 2022 04:14:12 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3137316bb69so96407207b3.10;
        Mon, 20 Jun 2022 04:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P6R5v1MXtNS2uiB35EoDn55uj4tg8g5j1ZLT2HRS62E=;
        b=Q1QhmRVS94hZsCkCd4JH/HSsJAbzPS+Gnri4MTUT1WglOYf4cP9lnKosELNfdk2tJn
         lgb7iji8wL5l0KjQJ5MQvXWjfucELIaHOc3mbMkVbIqls5nIsPInkn7v+b/9XWDqayI1
         IDUCF/1wBEOBVElr9OtIOGX1YNM75DUOflvGhVDJWX6BmVQ6abOuYXm1oVqrTZnFmLdy
         lSpzMI/PGf6vaXycX25pRxnM1NpIHdfi4X7ztDgnz3g7s9MMkrFQPqu9RM0sf6UTJ7Oj
         cC8PUoG34KLXMc40j9T4cTEBqlrQpCkxSBRcg39CCeghcoM49hUXeccxkVlpvpBGqSom
         DXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P6R5v1MXtNS2uiB35EoDn55uj4tg8g5j1ZLT2HRS62E=;
        b=0xPnMJmDclf6cFDPHiIAK42GxFgbpUyzXtXwrfJxt2ZUJS4F2hdllhh/0LYDaUOHMK
         Vmz/9sEBYgxnBbKsXEYWfy82Efa5MkGMoUCVpU+stOaASWoZEIIzEDrvfzj9QjXT1ofk
         baUuvohMNU0qXu7L74TQG5VFZ7yO7PGGDVbc7T4XpML3cXhstuUaDolt9QgKvn4CWzNp
         HBKBHV9AEg1M5/0KCW6PDXwfLsEJyJErGAkI/FfVnKbuIRT3YapO0aaELicOyAI4y4Mu
         6ooJrSRbv6to43AbG2UuajKSOKG0/rMK9JrZOTxPDP/InwGCskT0gc6v005ezcgc6PM+
         tDxg==
X-Gm-Message-State: AJIora85/wOHpToKPEkCZak38WVqcr/Wgwe4gHY9eoXIJ7dIT5avCNiZ
        E7HxwdsBTogy4PbIeDE5nlTwPtOTP4rLq//+0i0=
X-Google-Smtp-Source: AGRyM1tmNGeBJDlpH+SMzQ2MFIh6vodRKPn8NytCcsIk33TF40/9sAnbfwEr7E1rMHp6WlIJKudoHgvNPqVUrspUymI=
X-Received: by 2002:a0d:dbc5:0:b0:317:8ac6:3ac9 with SMTP id
 d188-20020a0ddbc5000000b003178ac63ac9mr16393234ywe.498.1655723651921; Mon, 20
 Jun 2022 04:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220620023621.1852-1-Frank.Sae@motor-comm.com>
In-Reply-To: <20220620023621.1852-1-Frank.Sae@motor-comm.com>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Mon, 20 Jun 2022 07:14:01 -0400
Message-ID: <CAMdYzYrxSyo4nCV7jvnC6uHNstSdkQd0r014dcs2eX4aro6N7w@mail.gmail.com>
Subject: Re: [PATCH v1] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 19, 2022 at 10:37 PM Frank <Frank.Sae@motor-comm.com> wrote:
>
>  Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have veri=
fied
>  the driver on StarFive VisionFive development board, which is developed =
by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit eth=
ernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, =
and
>  wol(magic package).
>
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>

Good Morning Frank,

Please run this patch through checkpatch.pl --strict. I will try to
avoid repeating what other reviewers have stated already.

> ---
>  MAINTAINERS                 |   1 +
>  drivers/net/phy/Kconfig     |   2 +-
>  drivers/net/phy/motorcomm.c | 819 +++++++++++++++++++++++++++++++++++-
>  3 files changed, 817 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a6d3bd9..59813c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13437,6 +13437,7 @@ F:      include/uapi/linux/meye.h
>
>  MOTORCOMM PHY DRIVER
>  M:     Peter Geis <pgwipeout@gmail.com>
> +M:     Frank <Frank.Sae@motor-comm.com>
>  L:     netdev@vger.kernel.org
>  S:     Maintained
>  F:     drivers/net/phy/motorcomm.c
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 9fee639..9061c76 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -253,7 +253,7 @@ config MOTORCOMM_PHY
>         tristate "Motorcomm PHYs"
>         help
>           Enables support for Motorcomm network PHYs.
> -         Currently supports the YT8511 gigabit PHY.
> +         Currently supports the YT8511, YT8521 Gigabit Ethernet PHYs.
>
>  config NATIONAL_PHY
>         tristate "National Semiconductor PHYs"
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index 7e6ac2c..2db2ef3 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -1,15 +1,112 @@
>  // SPDX-License-Identifier: GPL-2.0+
>  /*
> - * Driver for Motorcomm PHYs
> + * motorcomm.c: Motorcomm 8511/8521 PHY driver.
>   *
> - * Author: Peter Geis <pgwipeout@gmail.com>
> + * Author: Frank <Frank.Sae@motor-comm.com>
>   */

Hello there.

>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/phy.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +
> +// clang-format off

Is there a particular reason you are including clang-format off? This
strikes me as something that should stay in your IDE.

> +#define YTPHY_KERNEL_DRIVER_VERSION            "1.0.47"
> +#define YT8521_DRIVER_ENAME                    "YT8521 Gigabit Ethernet"
> +
>
>  #define PHY_ID_YT8511          0x0000010a
> +#define PHY_ID_YT8521                          0x0000011A
> +#define YT_PHY_ID_MASK                         0x00000FFF
> +
> +/* Specific Function Control Register */
> +#define YTPHY_SPECIFIC_FUNCTION_CONTROL_REG    0x10
> +
> +/* 2b00 Manual MDI configuration
> + * 2b01 Manual MDIX configuration
> + * 2b10 Reserved
> + * 2b11 Enable automatic crossover for all modes  *default*
> + */
> +#define YTPHY_SFCR_MDI_CROSSOVER_MODE_MASK     (BIT(6) | BIT(5))
> +#define YTPHY_SFCR_CROSSOVER_EN                        BIT(3)
> +#define YTPHY_SFCR_SQE_TEST_EN                 BIT(2)
> +#define YTPHY_SFCR_POLARITY_REVERSAL_EN                BIT(1)
> +#define YTPHY_SFCR_JABBER_DIS                  BIT(0)
> +
> +/* Specific Status Register */
> +#define YTPHY_SPECIFIC_STATUS_REG              0x11
> +#define YTPHY_SSR_SPEED_MODE_BIT               14
> +
> +/* 2b00 10 Mbps
> + * 2b01 100 Mbps
> + * 2b10 1000 Mbps
> + * 2b11 Reserved
> + */
> +#define YTPHY_SSR_SPEED_MODE_MASK              (BIT(15) | BIT(14))
> +#define YTPHY_SSR_SPEED_10M                    0x0
> +#define YTPHY_SSR_SPEED_100M                   0x1
> +#define YTPHY_SSR_SPEED_1000M                  0x2
> +#define YTPHY_SSR_DUPLEX_BIT                   13
> +#define YTPHY_SSR_DUPLEX                       BIT(13)
> +#define YTPHY_SSR_PAGE_RECEIVED                        BIT(12)
> +#define YTPHY_SSR_SPEED_DUPLEX_RESOLVED                BIT(11)
> +#define YTPHY_SSR_LINK                         BIT(10)
> +#define YTPHY_SSR_MDIX_CROSSOVER               BIT(6)
> +#define YTPHY_SSR_DOWNGRADE                    BIT(5)
> +#define YTPHY_SSR_TRANSMIT_PAUSE               BIT(3)
> +#define YTPHY_SSR_RECEIVE_PAUSE                        BIT(2)
> +#define YTPHY_SSR_POLARITY                     BIT(1)
> +#define YTPHY_SSR_JABBER                       BIT(0)
> +
> +/* Interrupt enable Register */
> +#define YTPHY_INTERRUPT_ENABLE_REG             0x12
> +#define YTPHY_IER_AUTONEG_ERR                  BIT(15)
> +#define YTPHY_IER_SPEED_CHANGED                        BIT(14)
> +#define YTPHY_IER_DUPLEX_CHANGED               BIT(13)
> +#define YTPHY_IER_PAGE_RECEIVED                        BIT(12)
> +#define YTPHY_IER_LINK_FAILED                  BIT(11)
> +#define YTPHY_IER_LINK_SUCCESSED               BIT(10)
> +#define YTPHY_IER_WOL                          BIT(6)
> +#define YTPHY_IER_WIRESPEED_DOWNGRADE          BIT(5)
> +#define YTPHY_IER_SERDES_LINK_FAILED           BIT(3)
> +#define YTPHY_IER_SERDES_LINK_SUCCESSED                BIT(2)
> +#define YTPHY_IER_POLARITY_CHANGED             BIT(1)
> +#define YTPHY_IER_JABBER_HAPPENED              BIT(0)
> +
> +/* Interrupt Status Register */
> +#define YTPHY_INTERRUPT_STATUS_REG             0x13
> +#define YTPHY_ISR_AUTONEG_ERR                  BIT(15)
> +#define YTPHY_ISR_SPEED_CHANGED                        BIT(14)
> +#define YTPHY_ISR_DUPLEX_CHANGED               BIT(13)
> +#define YTPHY_ISR_PAGE_RECEIVED                        BIT(12)
> +#define YTPHY_ISR_LINK_FAILED                  BIT(11)
> +#define YTPHY_ISR_LINK_SUCCESSED               BIT(10)
> +#define YTPHY_ISR_WOL                          BIT(6)
> +#define YTPHY_ISR_WIRESPEED_DOWNGRADE          BIT(5)
> +#define YTPHY_ISR_SERDES_LINK_FAILED           BIT(3)
> +#define YTPHY_ISR_SERDES_LINK_SUCCESSED                BIT(2)
> +#define YTPHY_ISR_POLARITY_CHANGED             BIT(1)
> +#define YTPHY_ISR_JABBER_HAPPENED              BIT(0)
> +
> +/* Speed Auto Downgrade Control Register */
> +#define YTPHY_SPEED_AUTO_DOWNGRADE_CONTROL_REG 0x14
> +#define YTPHY_SADCR_SPEED_DOWNGRADE_EN         BIT(5)
> +
> +/* If these bits are set to 3, the PHY attempts five times ( 3(set value=
) +
> + * additional 2) before downgrading, default 0x3
> + */
> +#define YTPHY_SADCR_SPEED_RETRY_LIMIT          (0x3 << 2)
> +
> +/* Rx Error Counter Register */
> +#define YTPHY_RX_ERROR_COUNTER_REG             0x15

Do the above YTPHY_ apply universally to all YT designated PHYs? If
not, please define these to the model that introduced them, such as
YT8521_, or if they apply also to the YT8511 continue with common
convention and name them YT8511_.

> +
> +/* Extended Register's Address Offset Register */
> +#define YTPHY_PAGE_SELECT                      0x1E
> +
> +/* Extended Register's Data Register */
> +#define YTPHY_PAGE_DATA                                0x1F

These are defined exactly the same way as below. Please reuse code
where possible.

> +
>
>  #define YT8511_PAGE_SELECT     0x1e
>  #define YT8511_PAGE            0x1f
> @@ -38,6 +135,301 @@
>  #define YT8511_DELAY_FE_TX_EN  (0xf << 12)
>  #define YT8511_DELAY_FE_TX_DIS (0x2 << 12)
>
> +
> +/* Extended register is different from MMD Register and MII Register.
> + * We can use ytphy_read_ext/ytphy_write_ext/ytphy_modify_ext function t=
o
> + * operate extended register.
> + * Extended Register  start
> + */
> +
> +#define YT8521_EXTREG_SLEEP_CONTROL1_REG       0x27
> +#define YT8521_ESC1R_SLEEP_SW                  BIT(15)
> +#define YT8521_ESC1R_PLLON_SLP                 BIT(14)
> +
> +#define YT8521_REG_SPACE_SELECT_REG            0xA000
> +#define YT8521_RSSR_FIBER_SPACE                        BIT(1)
> +#define YT8521_RSSR_UTP_SPACE                  0x0
> +
> +#define YT8521_CHIP_CONFIG_REG                 0xA001
> +#define YT8521_CCR_SW_RST                      BIT(15)
> +
> +/* 8 working modes:
> + * 3b000 UTP_TO_RGMII  *default*
> + * 3b001 FIBER_TO_RGMII
> + * 3b010 UTP_FIBER_TO_RGMII
> + * 3b011 UTP_TO_SGMII
> + * 3b100 SGPHY_TO_RGMAC
> + * 3b101 SGMAC_TO_RGPHY
> + * 3b110 UTP_TO_FIBER_AUTO
> + * 3b111 UTP_TO_FIBER_FORCE
> + */
> +#define YT8521_CCR_MODE_SEL_MASK               (BIT(2) | BIT(1) | BIT(0)=
)
> +
> +/* 3 Phy register space pooling modes */
> +#define YT8521_MODE_FIBER                      0x1
> +#define YT8521_MODE_UTP                                0x2
> +#define YT8521_MODE_POLL                       0x3
> +
> +#define YT8521_RGMII_CONFIG1_REG               0xA003
> +
> +/* TX Gig-E Delay is bits 3:0, default 0x1
> + * TX Fast-E Delay is bits 7:4, default 0xf
> + * RX Delay is bits 13:10, default 0x0
> + * Delay =3D 150ps * N
> + * On =3D 2250ps, off =3D 0ps
> + */
> +#define YT8521_RC1R_RX_DELAY_MASK              (0xF << 10)
> +#define YT8521_RC1R_RX_DELAY_EN                        (0xF << 10)
> +#define YT8521_RC1R_RX_DELAY_DIS               (0x0 << 10)
> +#define YT8521_RC1R_FE_TX_DELAY_MASK           (0xF << 4)
> +#define YT8521_RC1R_FE_TX_DELAY_EN             (0xF << 4)
> +#define YT8521_RC1R_FE_TX_DELAY_DIS            (0x0 << 4)
> +#define YT8521_RC1R_GE_TX_DELAY_MASK           (0xF << 0)
> +#define YT8521_RC1R_GE_TX_DELAY_EN             (0xF << 0)
> +#define YT8521_RC1R_GE_TX_DELAY_DIS            (0x0 << 0)
> +
> +#define YTPHY_WOL_MACADDR2_REG                 0xA007
> +#define YTPHY_WOL_MACADDR1_REG                 0xA008
> +#define YTPHY_WOL_MACADDR0_REG                 0xA009
> +
> +#define YTPHY_WOL_CONFIG_REG                   0xA00A
> +#define YTPHY_WCR_INTR_SEL                     BIT(6)
> +#define YTPHY_WCR_ENABLE                       BIT(3)
> +
> +/* 2b00 84ms
> + * 2b01 168ms  *default*
> + * 2b10 336ms
> + * 2b11 672ms
> + */
> +#define YTPHY_WCR_PUSEL_WIDTH_MASK             (BIT(2) | BIT(1))
> +#define YTPHY_WCR_PUSEL_WIDTH_672MS            (BIT(2) | BIT(1))
> +
> +/* 1b0 Interrupt and WOL events is level triggerd and active LOW  *defau=
lt*
> + * 1b1 Interrupt and WOL events is pulse triggered and active LOW
> + */
> +#define YTPHY_WCR_TYPE_PULSE                   BIT(0)
> +
> +#define YTPHY_SYNC_CLK_CONFIG_REG              0xA012
> +
> +/* 1b1 output 125m clock  *default*
> + * 1b0 output 25m clock
> + */
> +#define YTPHY_SCCR_Clk_125M                    BIT(3)
> +/* Extended Register  end */
> +
> +// clang-format on
> +
> +/**
> + * ytphy_read_ext() - read a PHY's extended register
> + * @phydev: a pointer to a &struct phy_device
> + * @regnum: register number to read
> + *
> + * returns the value of regnum reg or negative error code
> + */
> +static int ytphy_read_ext(struct phy_device *phydev, u16 regnum)
> +{
> +       int ret;
> +
> +       ret =3D phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
> +       if (ret < 0)
> +               return ret;
> +
> +       return phy_read(phydev, YTPHY_PAGE_DATA);
> +}
> +
> +/**
> + * ytphy_write_ext() - write a PHY's extended register
> + * @phydev: a pointer to a &struct phy_device
> + * @regnum: register number to write
> + * @val: value to write to @regnum
> + *
> + * returns 0 or negative error code
> + */
> +static int ytphy_write_ext(struct phy_device *phydev, u16 regnum, u16 va=
l)
> +{
> +       int ret;
> +
> +       ret =3D phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
> +       if (ret < 0)
> +               return ret;
> +
> +       return phy_write(phydev, YTPHY_PAGE_DATA, val);
> +}
> +
> +/**
> + * ytphy_modify_ext() - bits modify a PHY's extended register
> + * @phydev: a pointer to a &struct phy_device
> + * @regnum: register number to write
> + * @mask: bit mask of bits to clear
> + * @set: bit mask of bits to set
> + *
> + * NOTE: Convenience function which allows a PHY=E2=80=98s extended regi=
ster to be
> + * modified as new register value =3D (old register value & ~mask) | set
> + *
> + * returns 0 or negative error code
> + */
> +static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 m=
ask,
> +                           u16 set)
> +{
> +       u16 val;
> +       int ret;
> +
> +       ret =3D ytphy_read_ext(phydev, regnum);
> +       if (ret < 0)
> +               return ret;
> +
> +       val =3D ret & 0xffff;
> +       val &=3D ~mask;
> +       val |=3D set;
> +
> +       return ytphy_write_ext(phydev, regnum, val);

This should all be done within a single lock context.

> +}
> +
> +/**
> + * ytphy_read_page() - read reg page
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns current reg space of yt8521 (YT8521_RSSR_FIBER_SPACE /
> + * YT8521_RSSR_UTP_SPACE) or negative errno code
> + */
> +static int ytphy_read_page(struct phy_device *phydev)
> +{
> +       int ret;
> +
> +       ret =3D ytphy_read_ext(phydev, YT8521_REG_SPACE_SELECT_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (ret & YT8521_RSSR_FIBER_SPACE)
> +               return YT8521_RSSR_FIBER_SPACE;
> +
> +       return YT8521_RSSR_UTP_SPACE;

So there's only two possible pages that can be used in the extended
register space?

> +};
> +
> +/**
> + * ytphy_write_page() - write reg page
> + * @phydev: a pointer to a &struct phy_device
> + * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to=
 write.
> + *
> + * returns 0 or negative errno code
> + */
> +static int ytphy_write_page(struct phy_device *phydev, int page)
> +{
> +       int mask =3D YT8521_RSSR_FIBER_SPACE;
> +       int set =3D YT8521_RSSR_UTP_SPACE;
> +
> +       if (page =3D=3D YT8521_RSSR_FIBER_SPACE)
> +               set =3D YT8521_RSSR_FIBER_SPACE;
> +
> +       return ytphy_modify_ext(phydev, YT8521_REG_SPACE_SELECT_REG, mask=
, set);
> +};
> +
> +/**
> + * ytphy_get_wol() - report whether wake-on-lan is enabled
> + * @phydev: a pointer to a &struct phy_device
> + * @wol: a pointer to a &struct ethtool_wolinfo
> + *
> + */
> +static void ytphy_get_wol(struct phy_device *phydev,
> +                         struct ethtool_wolinfo *wol)
> +{
> +       int val =3D 0;
> +
> +       wol->supported =3D WAKE_MAGIC;
> +       wol->wolopts =3D 0;
> +
> +       val =3D ytphy_read_ext(phydev, YTPHY_WOL_CONFIG_REG);
> +       if (val < 0)
> +               return;
> +
> +       if (val & YTPHY_WCR_ENABLE)
> +               wol->wolopts |=3D WAKE_MAGIC;
> +}
> +
> +/**
> + * ytphy_set_wol() - turn wake-on-lan on or off
> + * @phydev: a pointer to a &struct phy_device
> + * @wol: a pointer to a &struct ethtool_wolinfo
> + *
> + * returns 0 or negative errno code
> + */
> +static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolin=
fo *wol)
> +{
> +       int ret;
> +       u16 mask;
> +       u16 val;
> +       u8 i;
> +       int curr_reg_space;
> +       const u8 *mac_addr;
> +       struct net_device *p_attached_dev;
> +       static const u16 mac_addr_reg[] =3D {
> +               YTPHY_WOL_MACADDR2_REG,
> +               YTPHY_WOL_MACADDR1_REG,
> +               YTPHY_WOL_MACADDR0_REG,
> +       };
> +
> +       curr_reg_space =3D ytphy_read_page(phydev);
> +       if (curr_reg_space < 0)
> +               return curr_reg_space;
> +
> +       if (wol->wolopts & WAKE_MAGIC) {
> +               p_attached_dev =3D phydev->attached_dev;
> +               if (!p_attached_dev)
> +                       return -ENODEV;
> +
> +               mac_addr =3D (const u8 *)p_attached_dev->dev_addr;
> +               if (!is_valid_ether_addr(mac_addr))
> +                       return -EINVAL;
> +
> +               /* switch to UTP reg space */
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +               if (ret < 0)
> +                       goto err_restore_page;
> +
> +               /* Store the device address for the magic packet */
> +               for (i =3D 0; i < 3; i++) {
> +                       ret =3D ytphy_write_ext(phydev, mac_addr_reg[i],
> +                                             ((mac_addr[i * 2] << 8)) |
> +                                                     (mac_addr[i * 2 + 1=
]));
> +                       if (ret < 0)
> +                               goto err_restore_page;
> +               }
> +
> +               /* Enable the WOL feature */
> +               val =3D 0;
> +               mask =3D YTPHY_WCR_PUSEL_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
> +               val |=3D YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
> +               val |=3D YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PUSEL_WIDTH_672=
MS;
> +               ret =3D ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, ma=
sk, val);
> +               if (ret < 0)
> +                       goto err_restore_page;
> +
> +               /* Enable the WOL feature interrupt */
> +               ret =3D phy_set_bits(phydev, YTPHY_INTERRUPT_ENABLE_REG,
> +                                  YTPHY_IER_WOL);
> +               if (ret < 0)
> +                       goto err_restore_page;
> +
> +       } else {
> +               /* switch to UTP reg space */
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +               if (ret < 0)
> +                       goto err_restore_page;
> +
> +               /* Disable the WOL feature */
> +               val =3D 0;
> +               mask =3D YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
> +               ret =3D ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, ma=
sk, val);
> +               if (ret < 0)
> +                       goto err_restore_page;
> +       }
> +
> +err_restore_page:
> +       /* Recover to previous register space page */
> +       return ytphy_write_page(phydev, curr_reg_space);
> +}
> +
> +// clang-format off
>  static int yt8511_read_page(struct phy_device *phydev)
>  {
>         return __phy_read(phydev, YT8511_PAGE_SELECT);
> @@ -111,6 +503,406 @@ err_restore_page:
>         return phy_restore_page(phydev, oldpage, ret);
>  }
>
> +// clang-format on
> +
> +/**
> + * yt8521_get_mode() - get the mode of yt8521(pooling mode)
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns current mode of yt8521 (YT8521_MODE_FIBER / YT8521_MODE_UTP /
> + * YT8521_MODE_POLL) or negative errno code
> + */
> +static int yt8521_get_mode(struct phy_device *phydev)
> +{
> +       int val =3D 0;
> +
> +       val =3D ytphy_read_ext(phydev, YT8521_CHIP_CONFIG_REG);
> +       if (val < 0)
> +               return val;
> +
> +       switch (val & YT8521_CCR_MODE_SEL_MASK) {
> +       case 1:
> +       case 4:
> +       case 5:
> +               return YT8521_MODE_FIBER;
> +       case 2:
> +       case 6:
> +       case 7:
> +               return YT8521_MODE_POLL;
> +       case 3:
> +       case 0:
> +               return YT8521_MODE_UTP;
> +       default: /* do not support other modes */
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +/**
> + * yt8521_adjust_status() - adjust speed and duplex according to is_utp,=
 then
> + * update speed and duplex to phydev
> + *
> + * @phydev: a pointer to a &struct phy_device
> + * @status: yt8521 status read from YTPHY_SPECIFIC_STATUS_REG
> + * @is_utp: false(yt8521 work in fiber mode) or true(yt8521 work in utp =
mode)
> + *
> + * NOTE: there is no 10M speed mode in fiber mode, so need adjust.
> + *
> + * returns 0
> + */
> +static int yt8521_adjust_status(struct phy_device *phydev, int status,
> +                               bool is_utp)
> +{
> +       int speed_mode, duplex;
> +       int speed =3D SPEED_UNKNOWN;
> +
> +       if (is_utp)
> +               duplex =3D (status & YTPHY_SSR_DUPLEX) >> YTPHY_SSR_DUPLE=
X_BIT;
> +       else
> +               duplex =3D 1;
> +
> +       speed_mode =3D (status & YTPHY_SSR_SPEED_MODE_MASK) >>
> +                    YTPHY_SSR_SPEED_MODE_BIT;
> +       switch (speed_mode) {
> +       case YTPHY_SSR_SPEED_10M:
> +               if (is_utp)
> +                       speed =3D SPEED_10;
> +               break;
> +       case YTPHY_SSR_SPEED_100M:
> +               speed =3D SPEED_100;
> +               break;
> +       case YTPHY_SSR_SPEED_1000M:
> +               speed =3D SPEED_1000;
> +               break;
> +       default:
> +               speed =3D SPEED_UNKNOWN;
> +               break;
> +       }
> +
> +       phydev->speed =3D speed;
> +       phydev->duplex =3D duplex;
> +       phydev->port =3D is_utp ? PORT_TP : PORT_FIBRE;
> +
> +       return 0;
> +}
> +/**
> + * yt8521_read_status() -  determines the negotiated speed and duplex
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_read_status(struct phy_device *phydev)
> +{
> +       int ret;
> +       int val;
> +       int yt8521_fiber_latch_val;
> +       int yt8521_fiber_curr_val;
> +       int link;
> +       int link_utp =3D 0, link_fiber =3D 0;
> +       int yt8521_mode;
> +
> +       yt8521_mode =3D yt8521_get_mode(phydev);
> +       if (yt8521_mode < 0)
> +               return yt8521_mode;
> +
> +       /* YT8521 has two reg space (utp/fiber) and three work mode (utp/=
fiber/poll),
> +        * each reg space has YTPHY_SPECIFIC_STATUS_REG. The mode must be=
 set
> +        * before we can read the state (YTPHY_SPECIFIC_STATUS_REG). Pool=
 mode
> +        * combines utp and faber mode ,so we need do both.
> +        */
> +
> +       if ((yt8521_mode =3D=3D YT8521_MODE_UTP) ||
> +           (yt8521_mode =3D=3D YT8521_MODE_POLL)) {
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +               if (ret < 0)
> +                       return ret;
> +
> +               ret =3D genphy_read_status(phydev);
> +               if (ret)
> +                       return ret;
> +
> +               val =3D phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +               if (val < 0)
> +                       return val;
> +
> +               link =3D val & YTPHY_SSR_LINK;
> +               if (link) {
> +                       link_utp =3D 1;
> +                       ret =3D yt8521_adjust_status(phydev, val, true);
> +                       if (ret < 0)
> +                               return ret;
> +               } else {
> +                       link_utp =3D 0;
> +               }
> +       }
> +
> +       if ((yt8521_mode =3D=3D YT8521_MODE_FIBER) ||
> +           (yt8521_mode =3D=3D YT8521_MODE_POLL)) {
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_FIBER_SPACE)=
;
> +               if (ret < 0)
> +                       return ret;
> +
> +               ret =3D genphy_read_status(phydev);
> +               if (ret)
> +                       return ret;
> +
> +               val =3D phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +               if (val < 0)
> +                       return val;
> +
> +               /* When PHY is in fiber mode, speed transferred
> +                * from 1000Mbps to 100Mbps, there is not link down
> +                * from 0x11, so we need check reg 1 to identify such cas=
e.
> +                */
> +               yt8521_fiber_latch_val =3D phy_read(phydev, MII_BMSR);
> +               if (yt8521_fiber_latch_val < 0)
> +                       return yt8521_fiber_latch_val;
> +
> +               yt8521_fiber_curr_val =3D phy_read(phydev, MII_BMSR);
> +               if (yt8521_fiber_curr_val < 0)
> +                       return yt8521_fiber_curr_val;
> +
> +               link =3D val & YTPHY_SSR_LINK;
> +               if (link && yt8521_fiber_latch_val !=3D yt8521_fiber_curr=
_val) {
> +                       link =3D 0;
> +
> +                       netdev_info(
> +                               phydev->attached_dev,
> +                               "%s, phy addr: %d, fiber link down detect=
, latch =3D %04x, curr =3D %04x\n",
> +                               __func__, phydev->mdio.addr,
> +                               yt8521_fiber_latch_val, yt8521_fiber_curr=
_val);
> +               }
> +               if (link) {
> +                       link_fiber =3D 1;
> +                       ret =3D yt8521_adjust_status(phydev, val, false);
> +                       if (ret < 0)
> +                               return ret;
> +               } else {
> +                       link_fiber =3D 0;
> +               }
> +       }
> +
> +       if (link_utp || link_fiber) {
> +               if (phydev->link =3D=3D 0)
> +                       phydev->link =3D 1;
> +       } else {
> +               phydev->link =3D 0;
> +       }
> +
> +       /* set utp reg space as default reg space */
> +       return ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +}
> +
> +/**
> + * yt8521_modify_BMCR - bits modify a PHY's BMCR register according to t=
he
> + * current mode
> + * @phydev: the phy_device struct
> + * @mask: bit mask of bits to clear
> + * @set: bit mask of bits to set
> + *
> + * NOTE: Convenience function which allows a PHY=E2=80=98s BMCR register=
 to be
> + * modified as new register value =3D (old register value & ~mask) | set=
.
> + * YT8521 has two space (utp/fiber) and three mode (utp/fiber/poll), eac=
h space
> + * has MII_BMCR. pool mode combines utp and faber,so need do both.
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_modify_BMCR(struct phy_device *phydev, u16 mask, u16 s=
et)
> +{
> +       int ret;
> +       int yt8521_mode;
> +
> +       yt8521_mode =3D yt8521_get_mode(phydev);
> +       if (yt8521_mode < 0)
> +               return yt8521_mode;
> +
> +       if ((yt8521_mode =3D=3D YT8521_MODE_UTP) ||
> +           (yt8521_mode =3D=3D YT8521_MODE_POLL)) {
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +               if (ret < 0)
> +                       return ret;
> +
> +               ret =3D phy_modify(phydev, MII_BMCR, mask, set);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       if ((yt8521_mode =3D=3D YT8521_MODE_FIBER) ||
> +           (yt8521_mode =3D=3D YT8521_MODE_POLL)) {
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_FIBER_SPACE)=
;
> +               if (ret < 0)
> +                       return ret;
> +
> +               ret =3D phy_modify(phydev, MII_BMCR, mask, set);
> +               if (ret < 0)
> +                       return ret;
> +
> +               /* set utp reg apace as default reg apace*/
> +               ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +       return 0;
> +}
> +
> +/**
> + * yt8521_soft_reset() - called to issue a PHY software reset
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +int yt8521_soft_reset(struct phy_device *phydev)
> +{
> +       return yt8521_modify_BMCR(phydev, 0, BMCR_RESET);
> +}
> +
> +/**
> + * yt8521_suspend() - suspend the hardware
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +int yt8521_suspend(struct phy_device *phydev)
> +{
> +       int val;
> +       int wol_enabled;
> +
> +       val =3D ytphy_read_ext(phydev, YTPHY_WOL_CONFIG_REG);
> +       if (val < 0)
> +               return val;
> +
> +       wol_enabled =3D (val & YTPHY_WCR_ENABLE);
> +       if (wol_enabled)
> +               val =3D BMCR_ISOLATE;
> +       else
> +               val =3D BMCR_PDOWN;
> +
> +       return yt8521_modify_BMCR(phydev, 0, val);
> +}
> +
> +/**
> + * yt8521_resume() - resume the hardware
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +int yt8521_resume(struct phy_device *phydev)
> +{
> +       int ret;
> +       /* disable auto sleep */
> +       ret =3D ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG=
,
> +                              YT8521_ESC1R_SLEEP_SW, 0);
> +       if (ret < 0)
> +               return ret;
> +
> +       return yt8521_modify_BMCR(phydev, BMCR_ISOLATE | BMCR_PDOWN, 0);
> +}
> +
> +/**
> + * yt8521_config_init() - called to initialize the PHY
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8521_config_init(struct phy_device *phydev)
> +{
> +       int ret;
> +       u16 val =3D 0;
> +       int hw_strap_mode;
> +
> +       /* Explicitly switch to UTP reg space, just to be sure */
> +       ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret =3D phy_read(phydev, MII_PHYSID2);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> +           phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID)
> +               val |=3D (YT8521_RC1R_RX_DELAY_EN);
> +
> +       if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> +           phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)
> +               val |=3D (YT8521_RC1R_GE_TX_DELAY_EN |
> +                       YT8521_RC1R_FE_TX_DELAY_EN);
> +
> +       ret =3D ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG,
> +                              (YT8521_RC1R_RX_DELAY_MASK |
> +                               YT8521_RC1R_FE_TX_DELAY_MASK |
> +                               YT8521_RC1R_GE_TX_DELAY_MASK),
> +                              val);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* disable auto sleep */
> +       ret =3D ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG=
,
> +                              YT8521_ESC1R_SLEEP_SW, 0);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* enable RXC clock when no wire plug */
> +       ret =3D ytphy_modify_ext(phydev, 0xc, BIT(12), 0);
> +       if (ret < 0)
> +               return ret;
> +
> +       hw_strap_mode =3D ytphy_read_ext(phydev, YT8521_CHIP_CONFIG_REG);
> +       if (hw_strap_mode < 0)
> +               return hw_strap_mode;
> +
> +       netdev_info(
> +               phydev->attached_dev,
> +               "%s done, phy addr: %d, strap mode =3D %ld, polling mode =
=3D %d\n",
> +               __func__, phydev->mdio.addr,
> +               hw_strap_mode & YT8521_CCR_MODE_SEL_MASK,
> +               yt8521_get_mode(phydev));
> +
> +       return ret;
> +}
> +
> +/**
> + * yt8521_aneg_done() - determines the auto negotiation result
> + * @phydev: a pointer to a &struct phy_device
> + *
> + * NOTE: for fiber mode, when speed is 100M, there is no definition for
> + * autonegotiation, and this function handles this case and return
> + * 1 per linux kernel's polling.
> + *
> + * returns 0(no link)or 1( fiber or utp link) or negative errno code
> + */
> +int yt8521_aneg_done(struct phy_device *phydev)
> +{
> +       int link_fiber =3D 0, link_utp =3D 0;
> +       int ret;
> +
> +       /* Explicitly switch to FIBER reg space*/
> +       ret =3D ytphy_write_page(phydev, YT8521_RSSR_FIBER_SPACE);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret =3D ytphy_write_page(phydev, YTPHY_SPECIFIC_STATUS_REG);
> +       if (ret < 0)
> +               return ret;
> +
> +       link_fiber =3D !!(ret & YTPHY_SSR_LINK);
> +
> +       /* Explicitly switch to UTP reg space */
> +       ret =3D ytphy_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (!link_fiber) {
> +               ret =3D ytphy_write_page(phydev, YTPHY_SPECIFIC_STATUS_RE=
G);
> +               if (ret < 0)
> +                       return ret;
> +
> +               link_fiber =3D !!(ret & YTPHY_SSR_LINK);
> +       }
> +
> +       return !!(link_fiber | link_utp);
> +}
> +
> +// clang-format off
>  static struct phy_driver motorcomm_phy_drvs[] =3D {
>         {
>                 PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
> @@ -121,16 +913,35 @@ static struct phy_driver motorcomm_phy_drvs[] =3D {
>                 .read_page      =3D yt8511_read_page,
>                 .write_page     =3D yt8511_write_page,
>         },
> +       {
> +               .phy_id         =3D PHY_ID_YT8521,
> +               .name           =3D YT8521_DRIVER_ENAME,
> +               .phy_id_mask    =3D YT_PHY_ID_MASK,
> +               .read_page      =3D ytphy_read_page,
> +               .write_page     =3D ytphy_write_page,
> +               .get_wol        =3D ytphy_get_wol,
> +               .set_wol        =3D ytphy_set_wol,
> +               .config_aneg    =3D genphy_config_aneg,
> +               .soft_reset     =3D yt8521_soft_reset,
> +               .aneg_done      =3D yt8521_aneg_done,
> +               .config_init    =3D yt8521_config_init,
> +               .read_status    =3D yt8521_read_status,
> +               .suspend        =3D yt8521_suspend,
> +               .resume         =3D yt8521_resume,
> +       },
>  };
> +// clang-format on
>
>  module_phy_driver(motorcomm_phy_drvs);
>
> -MODULE_DESCRIPTION("Motorcomm PHY driver");
> -MODULE_AUTHOR("Peter Geis");
> +MODULE_DESCRIPTION("Motorcomm 8511/8521 PHY driver");
> +MODULE_AUTHOR("Frank");
>  MODULE_LICENSE("GPL");
> +MODULE_VERSION(YTPHY_KERNEL_DRIVER_VERSION);
>
>  static const struct mdio_device_id __maybe_unused motorcomm_tbl[] =3D {
>         { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> +       { PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
>         { /* sentinal */ }
>  };
>
> --
> 2.31.0.windows.1
>

I've been working on extending the YT8511 support, as well as adding
support for the YT8531. I look forward to your V2.

Very Respectfully,
Peter Geis
