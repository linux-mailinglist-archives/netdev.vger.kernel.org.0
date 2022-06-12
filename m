Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3429C54784C
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 05:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiFLDUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 23:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiFLDUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 23:20:49 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373E25D669;
        Sat, 11 Jun 2022 20:20:45 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s135so2682171pgs.10;
        Sat, 11 Jun 2022 20:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6b6HVzG//C5+uWO0npDD6WC/hHq94VsqfYMM9aEPkZk=;
        b=TfN0957zbCKzPJv9qp9Z1f9IENZKYhpT98VBo5NnAUK0MkAV8gcCC2ZCaBj0udWzbQ
         8+dT+eXaMBjMveQlk2D3SQkUGWsQQLsXaOTqDBZ9szMmv+eyrUHgRM7lfWg0gKbqAHHn
         iva7jRKXPqBbScatEWHEy9HYOGo3VpRSMjo/dQJ//5RYrRcwtM/eyR08nw17DKTQmkPB
         oX+hIKB0p5HtS2qGrJKB1vucjrFsxnlPj9loMOLAGR3GaFcsyMzIy06BDBmYxBVnAmtn
         Vh6IoUBZpsxa6Mj5KjJMnCBCdY+phss8obvmkAAJ6vIy3mtf9pu87Tl9ct+GjXG04ERk
         fozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6b6HVzG//C5+uWO0npDD6WC/hHq94VsqfYMM9aEPkZk=;
        b=1Ml+xJNmwhRfbheqW4cfn1V7HsMwy+sKO6QJU+STSm1bBdIOWrYKU3Nb9qdqYJ6rmi
         f4hYzR/2+uv0qdSr/uzJO+RiewR/IVriKoJZ5l8/yXHfzp2FGKx/RXS7c8/YppdbWaHL
         c+mrApsDEhbwTQcOIR51Ms5bnZ2ynexdPcbwZk5GoOAYgIrofwvVXNUqTw4pN1BcFp9Z
         GxWzObyN8807ffKbfKKhi8UDX832MZQUDf4AXRU81xeE1FzIo5PPiUBWgrjNJ7c08drt
         MSFi9aN4V02d3BMrEEJ4KV09XMXG4oCBYuEK98mLFk3w0fLR4w0AB98rt/YSr+MIBrIo
         tvyw==
X-Gm-Message-State: AOAM532zvdc4rm7UrOdb6tEJ2JFNkbGukSD+Wvc72nWRjzVVFgOIWQzd
        mpa3mO+Pxah2EV+AzCF6Qgp1uadRQaGevH7Lruw=
X-Google-Smtp-Source: ABdhPJyal2ak/JirmOnd5qwNChgaOHfNEMkXnppwkp6MyVPjCW6CI6xN7iGq0u5xMVl6IwNXbWuCdl9Je0jaOyN70sY=
X-Received: by 2002:a63:cc09:0:b0:3fb:aae7:4964 with SMTP id
 x9-20020a63cc09000000b003fbaae74964mr45428424pgf.118.1655004044445; Sat, 11
 Jun 2022 20:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220610153829.446516-1-alvin@pqrs.dk> <20220610153829.446516-6-alvin@pqrs.dk>
In-Reply-To: <20220610153829.446516-6-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 12 Jun 2022 00:20:32 -0300
Message-ID: <CAJq09z6R+-Uwp0+y5aNenMQoxefdwN2uoj--mUrCjQmocUW08A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

"
> Realtek switches in the rtl8365mb family always have at least one port
> with a so-called external interface, supporting PHY interface modes such
> as RGMII or SGMII. The purpose of this patch is to improve the driver's
> handling of these ports.
>
> A new struct rtl8365mb_chip_info is introduced together with a static
> array of such structs. An instance of this struct is added for each
> supported switch, distinguished by its chip ID and version. Embedded in
> each chip_info struct is an array of struct rtl8365mb_extint, describing
> the external interfaces available. This is more specific than the old
> rtl8365mb_extint_port_map, which was only valid for switches with up to
> 6 ports.
>
> The struct rtl8365mb_extint also contains a bitmask of supported PHY
> interface modes, which allows the driver to distinguish which ports
> support RGMII. This corrects a previous mistake in the driver whereby it
> was assumed that any port with an external interface supports RGMII.
> This is not actually the case: for example, the RTL8367S has two
> external interfaces, only the second of which supports RGMII. The first
> supports only SGMII and HSGMII. This new design will make it easier to
> add support for other interface modes.
>
> Finally, rtl8365mb_phylink_get_caps() is fixed up to return supported
> capabilities based on the external interface properties described above.
> This allows for ports with an external interface to be treated as DSA
> user ports, and for ports with an internal PHY to be treated as DSA CPU
> ports.
>
> Link: https://lore.kernel.org/netdev/20220510192301.5djdt3ghoavxulhl@bang=
-olufsen.dk/
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 281 +++++++++++++++++-----------
>  1 file changed, 174 insertions(+), 107 deletions(-)
>
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realte=
k/rtl8365mb.c
> index 676b88798976..da31d8b839ac 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -101,26 +101,14 @@
>
>  #include "realtek.h"
>
> -/* Chip-specific data and limits */
> -#define RTL8365MB_CHIP_ID_8365MB_VC    0x6367
> -#define RTL8365MB_CHIP_VER_8365MB_VC   0x0040
> -
> -#define RTL8365MB_CHIP_ID_8367S                0x6367
> -#define RTL8365MB_CHIP_VER_8367S       0x00A0
> -
> -#define RTL8365MB_CHIP_ID_8367RB_VB    0x6367
> -#define RTL8365MB_CHIP_VER_8367RB_VB   0x0020
> -
>  /* Family-specific data and limits */
>  #define RTL8365MB_PHYADDRMAX           7
>  #define RTL8365MB_NUM_PHYREGS          32
>  #define RTL8365MB_PHYREGMAX            (RTL8365MB_NUM_PHYREGS - 1)
>  #define RTL8365MB_MAX_NUM_PORTS                11
> +#define RTL8365MB_MAX_NUM_EXTINTS      3
>  #define RTL8365MB_LEARN_LIMIT_MAX      2112
>
> -/* valid for all 6-port or less variants */
> -static const int rtl8365mb_extint_port_map[]  =3D { -1, -1, -1, -1, -1, =
-1, 1, 2, -1, -1};
> -
>  /* Chip identification registers */
>  #define RTL8365MB_CHIP_ID_REG          0x1300
>
> @@ -200,7 +188,7 @@ static const int rtl8365mb_extint_port_map[]  =3D { -=
1, -1, -1, -1, -1, -1, 1, 2,
>  /* The PHY OCP addresses of PHY registers 0~31 start here */
>  #define RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE             0xA400
>
> -/* EXT interface port mode values - used in DIGITAL_INTERFACE_SELECT */
> +/* External interface port mode values - used in DIGITAL_INTERFACE_SELEC=
T */
>  #define RTL8365MB_EXT_PORT_MODE_DISABLE                0
>  #define RTL8365MB_EXT_PORT_MODE_RGMII          1
>  #define RTL8365MB_EXT_PORT_MODE_MII_MAC                2
> @@ -216,19 +204,7 @@ static const int rtl8365mb_extint_port_map[]  =3D { =
-1, -1, -1, -1, -1, -1, 1, 2,
>  #define RTL8365MB_EXT_PORT_MODE_1000X          12
>  #define RTL8365MB_EXT_PORT_MODE_100FX          13
>
> -/* Realtek docs and driver uses logic number as EXT_PORT0=3D16, EXT_PORT=
1=3D17,
> - * EXT_PORT2=3D18, to interact with switch ports. That logic number is i=
nternally
> - * converted to either a physical port number (0..9) or an external inte=
rface id (0..2),
> - * depending on which function was called. The external interface id is =
calculated as
> - * (ext_id=3Dlogic_port-15), while the logical to physical map depends o=
n the chip id/version.
> - *
> - * EXT_PORT0 mentioned in datasheets and rtl8367c driver is used in this=
 driver
> - * as extid=3D=3D1, EXT_PORT2, mentioned in Realtek rtl8367c driver for =
10-port switches,
> - * would have an ext_id of 3 (out of range for most extint macros) and e=
xt_id 0 does
> - * not seem to be used as well for this family.
> - */
> -
> -/* EXT interface mode configuration registers 0~1 */
> +/* External interface mode configuration registers 0~1 */
>  #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0                0x1305 /*=
 EXT1 */
>  #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1                0x13C3 /*=
 EXT2 */
>  #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
> @@ -240,7 +216,7 @@ static const int rtl8365mb_extint_port_map[]  =3D { -=
1, -1, -1, -1, -1, -1, 1, 2,
>  #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
>                 (((_extint) % 2) * 4)
>
> -/* EXT interface RGMII TX/RX delay configuration registers 0~2 */
> +/* External interface RGMII TX/RX delay configuration registers 0~2 */
>  #define RTL8365MB_EXT_RGMXF_REG0               0x1306 /* EXT0 */
>  #define RTL8365MB_EXT_RGMXF_REG1               0x1307 /* EXT1 */
>  #define RTL8365MB_EXT_RGMXF_REG2               0x13C5 /* EXT2 */
> @@ -257,7 +233,7 @@ static const int rtl8365mb_extint_port_map[]  =3D { -=
1, -1, -1, -1, -1, -1, 1, 2,
>  #define RTL8365MB_PORT_SPEED_100M      1
>  #define RTL8365MB_PORT_SPEED_1000M     2
>
> -/* EXT interface force configuration registers 0~2 */
> +/* External interface force configuration registers 0~2 */
>  #define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0         0x1310 /* EXT0 */
>  #define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1         0x1311 /* EXT1 */
>  #define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2         0x13C4 /* EXT2 */
> @@ -489,6 +465,95 @@ static const struct rtl8365mb_jam_tbl_entry rtl8365m=
b_init_jam_common[] =3D {
>         { 0x1D32, 0x0002 },
>  };
>
> +enum rtl8365mb_phy_interface_mode {
> +       RTL8365MB_PHY_INTERFACE_MODE_INVAL =3D 0,
> +       RTL8365MB_PHY_INTERFACE_MODE_INTERNAL =3D BIT(0),
> +       RTL8365MB_PHY_INTERFACE_MODE_MII =3D BIT(1),
> +       RTL8365MB_PHY_INTERFACE_MODE_TMII =3D BIT(2),
> +       RTL8365MB_PHY_INTERFACE_MODE_RMII =3D BIT(3),
> +       RTL8365MB_PHY_INTERFACE_MODE_RGMII =3D BIT(4),
> +       RTL8365MB_PHY_INTERFACE_MODE_SGMII =3D BIT(5),
> +       RTL8365MB_PHY_INTERFACE_MODE_HSGMII =3D BIT(6),
> +};
> +
> +/**
> + * struct rtl8365mb_extint - external interface info
> + * @port: the port with an external interface
> + * @id: the external interface ID, which is either 0, 1, or 2
> + * @supported_interfaces: a bitmask of supported PHY interface modes
> + *
> + * Represents a mapping: port -> { id, supported_interfaces }. To be emb=
edded
> + * in &struct rtl8365mb_chip_info for every port with an external interf=
ace.
> + */
> +struct rtl8365mb_extint {
> +       int port;
> +       int id;
> +       unsigned int supported_interfaces;

It is more a doubt than an issue but should we use an int for a 0-11
value or a char?
And maybe a short for supported_interfaces to keep it 32-bit aligned.

> +};
> +
> +/**
> + * struct rtl8365mb_chip_info - static chip-specific info
> + * @name: human-readable chip name
> + * @chip_id: chip identifier
> + * @chip_ver: chip silicon revision
> + * @extints: available external interfaces
> + * @jam_table: chip-specific initialization jam table
> + * @jam_size: size of the chip's jam table
> + *
> + * These data are specific to a given chip in the family of switches sup=
ported
> + * by this driver. When adding support for another chip in the family, a=
 new
> + * chip info should be added to the rtl8365mb_chip_infos array.
> + */
> +struct rtl8365mb_chip_info {
> +       const char *name;
> +       u32 chip_id;
> +       u32 chip_ver;
> +       const struct rtl8365mb_extint extints[RTL8365MB_MAX_NUM_EXTINTS];
> +       const struct rtl8365mb_jam_tbl_entry *jam_table;
> +       size_t jam_size;
> +};
> +
> +/* Chip info for each supported switch in the family */
> +#define PHY_INTF(_mode) (RTL8365MB_PHY_INTERFACE_MODE_ ## _mode)
> +static const struct rtl8365mb_chip_info rtl8365mb_chip_infos[] =3D {
> +       {
> +               .name =3D "RTL8365MB-VC",
> +               .chip_id =3D 0x6367,
> +               .chip_ver =3D 0x0040,
> +               .extints =3D {
> +                       { 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) |
> +                               PHY_INTF(RMII) | PHY_INTF(RGMII) },
> +               },
> +               .jam_table =3D rtl8365mb_init_jam_8365mb_vc,
> +               .jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
> +       },
> +       {
> +               .name =3D "RTL8367S",
> +               .chip_id =3D 0x6367,
> +               .chip_ver =3D 0x00A0,
> +               .extints =3D {
> +                       { 6, 1, PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
> +                       { 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) |
> +                               PHY_INTF(RMII) | PHY_INTF(RGMII) },
> +               },
> +               .jam_table =3D rtl8365mb_init_jam_8365mb_vc,
> +               .jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
> +       },
> +       {
> +               .name =3D "RTL8367RB-VB",
> +               .chip_id =3D 0x6367,
> +               .chip_ver =3D 0x0020,
> +               .extints =3D {
> +                       { 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) |
> +                               PHY_INTF(RMII) | PHY_INTF(RGMII) },
> +                       { 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) |
> +                               PHY_INTF(RMII) | PHY_INTF(RGMII) },
> +               },
> +               .jam_table =3D rtl8365mb_init_jam_8365mb_vc,
> +               .jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
> +       },
> +};
> +
>  enum rtl8365mb_stp_state {
>         RTL8365MB_STP_STATE_DISABLED =3D 0,
>         RTL8365MB_STP_STATE_BLOCKING =3D 1,
> @@ -558,29 +623,23 @@ struct rtl8365mb_port {
>  };
>
>  /**
> - * struct rtl8365mb - private chip-specific driver data
> + * struct rtl8365mb - driver private data
>   * @priv: pointer to parent realtek_priv data
>   * @irq: registered IRQ or zero
> - * @chip_id: chip identifier
> - * @chip_ver: chip silicon revision
> + * @chip_info: chip-specific info about the attached switch
>   * @cpu: CPU tagging and CPU port configuration for this chip
>   * @mib_lock: prevent concurrent reads of MIB counters
>   * @ports: per-port data
> - * @jam_table: chip-specific initialization jam table
> - * @jam_size: size of the chip's jam table
>   *
>   * Private data for this driver.
>   */
>  struct rtl8365mb {
>         struct realtek_priv *priv;
>         int irq;
> -       u32 chip_id;
> -       u32 chip_ver;
> +       const struct rtl8365mb_chip_info *chip_info;
>         struct rtl8365mb_cpu cpu;
>         struct mutex mib_lock;
>         struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
> -       const struct rtl8365mb_jam_tbl_entry *jam_table;
> -       size_t jam_size;
>  };
>
>  static int rtl8365mb_phy_poll_busy(struct realtek_priv *priv)
> @@ -775,6 +834,26 @@ static int rtl8365mb_dsa_phy_write(struct dsa_switch=
 *ds, int phy, int regnum,
>         return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
>  }
>
> +static const struct rtl8365mb_extint *
> +rtl8365mb_get_port_extint(struct realtek_priv *priv, int port)
> +{
> +       struct rtl8365mb *mb =3D priv->chip_data;
> +       int i;
> +
> +       for (i =3D 0; i < RTL8365MB_MAX_NUM_EXTINTS; i++) {

All extint lookups use port as the search key and port is only used as
a search key. If this was an array of ports, you could have avoided
the loop. I believe the kernel now requires C99 and we could even
initialize as a sparse array (if it is acceptable by kernel code
sytle). Something like this untested code:

struct rtl8365mb_extint {
       int id;
       unsigned int supported_interfaces;
};
struct rtl8365mb_chip_info {
       ...
      const struct rtl8365mb_extint extints[RTL8365MB_MAX_NUM_PORTS];
      ...
};

.extints =3D {
           [6] =3D {1, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
PHY_INTF(RGMII) },
           [7] =3D {2, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
PHY_INTF(RGMII) },
}

We still need to check boundaries if the caller does not guarantee
port id is within boundaries. Maybe ds->num_ports is enough to make
sure the port is in range.

> +               const struct rtl8365mb_extint *extint =3D
> +                       &mb->chip_info->extints[i];
> +
> +               if (!extint->supported_interfaces)
> +                       continue;
> +
> +               if (extint->port =3D=3D port)
> +                       return extint;
> +       }
> +
> +       return NULL;
> +}
> +
>  static enum dsa_tag_protocol
>  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
>                            enum dsa_tag_protocol mp)
> @@ -795,20 +874,17 @@ rtl8365mb_get_tag_protocol(struct dsa_switch *ds, i=
nt port,
>  static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int por=
t,
>                                       phy_interface_t interface)
>  {
> +       const struct rtl8365mb_extint *extint =3D
> +               rtl8365mb_get_port_extint(priv, port);
>         struct device_node *dn;
>         struct dsa_port *dp;
>         int tx_delay =3D 0;
>         int rx_delay =3D 0;
> -       int ext_int;
>         u32 val;
>         int ret;
>
> -       ext_int =3D rtl8365mb_extint_port_map[port];
> -
> -       if (ext_int <=3D 0) {
> -               dev_err(priv->dev, "Port %d is not an external interface =
port\n", port);
> -               return -EINVAL;
> -       }
> +       if (!extint)
> +               return -ENODEV;
>
>         dp =3D dsa_to_port(priv->ds, port);
>         dn =3D dp->dn;
> @@ -842,7 +918,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_=
priv *priv, int port,
>                         tx_delay =3D val / 2;
>                 else
>                         dev_warn(priv->dev,
> -                                "EXT interface TX delay must be 0 or 2 n=
s\n");
> +                                "RGMII TX delay must be 0 or 2 ns\n");
>         }
>
>         if (!of_property_read_u32(dn, "rx-internal-delay-ps", &val)) {
> @@ -852,11 +928,11 @@ static int rtl8365mb_ext_config_rgmii(struct realte=
k_priv *priv, int port,
>                         rx_delay =3D val;
>                 else
>                         dev_warn(priv->dev,
> -                                "EXT interface RX delay must be 0 to 2.1=
 ns\n");
> +                                "RGMII RX delay must be 0 to 2.1 ns\n");
>         }
>
>         ret =3D regmap_update_bits(
> -               priv->map, RTL8365MB_EXT_RGMXF_REG(ext_int),
> +               priv->map, RTL8365MB_EXT_RGMXF_REG(extint->id),
>                 RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
>                         RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
>                 FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
> @@ -865,11 +941,11 @@ static int rtl8365mb_ext_config_rgmii(struct realte=
k_priv *priv, int port,
>                 return ret;
>
>         ret =3D regmap_update_bits(
> -               priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_int=
),
> -               RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_int),
> +               priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(extint-=
>id),
> +               RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(extint->id),
>                 RTL8365MB_EXT_PORT_MODE_RGMII
>                         << RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET=
(
> -                                  ext_int));
> +                                  extint->id));
>         if (ret)
>                 return ret;
>
> @@ -880,21 +956,18 @@ static int rtl8365mb_ext_config_forcemode(struct re=
altek_priv *priv, int port,
>                                           bool link, int speed, int duple=
x,
>                                           bool tx_pause, bool rx_pause)
>  {
> +       const struct rtl8365mb_extint *extint =3D
> +               rtl8365mb_get_port_extint(priv, port);
>         u32 r_tx_pause;
>         u32 r_rx_pause;
>         u32 r_duplex;
>         u32 r_speed;
>         u32 r_link;
> -       int ext_int;
>         int val;
>         int ret;
>
> -       ext_int =3D rtl8365mb_extint_port_map[port];
> -
> -       if (ext_int <=3D 0) {
> -               dev_err(priv->dev, "Port %d is not an external interface =
port\n", port);
> -               return -EINVAL;
> -       }
> +       if (!extint)
> +               return -ENODEV;
>
>         if (link) {
>                 /* Force the link up with the desired configuration */
> @@ -942,7 +1015,7 @@ static int rtl8365mb_ext_config_forcemode(struct rea=
ltek_priv *priv, int port,
>                          r_duplex) |
>               FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_=
speed);
>         ret =3D regmap_write(priv->map,
> -                          RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_int)=
,
> +                          RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(extint->=
id),
>                            val);
>         if (ret)
>                 return ret;
> @@ -953,7 +1026,13 @@ static int rtl8365mb_ext_config_forcemode(struct re=
altek_priv *priv, int port,
>  static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
>                                        struct phylink_config *config)
>  {
> -       if (dsa_is_user_port(ds, port)) {
> +       const struct rtl8365mb_extint *extint =3D
> +               rtl8365mb_get_port_extint(ds->priv, port);
> +
> +       config->mac_capabilities =3D MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> +                                  MAC_10 | MAC_100 | MAC_1000FD;
> +
> +       if (!extint) {
>                 __set_bit(PHY_INTERFACE_MODE_INTERNAL,
>                           config->supported_interfaces);
>
> @@ -962,12 +1041,16 @@ static void rtl8365mb_phylink_get_caps(struct dsa_=
switch *ds, int port,
>                  */
>                 __set_bit(PHY_INTERFACE_MODE_GMII,
>                           config->supported_interfaces);
> -       } else if (dsa_is_cpu_port(ds, port)) {
> -               phy_interface_set_rgmii(config->supported_interfaces);
> +               return;
>         }
>
> -       config->mac_capabilities =3D MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> -                                  MAC_10 | MAC_100 | MAC_1000FD;
> +       /* Populate according to the modes supported by _this driver_,
> +        * not necessarily the modes supported by the hardware, some of
> +        * which remain unimplemented.
> +        */
> +
> +       if (extint->supported_interfaces & RTL8365MB_PHY_INTERFACE_MODE_R=
GMII)
> +               phy_interface_set_rgmii(config->supported_interfaces);
>  }
>
>  static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port=
,
> @@ -1782,14 +1865,17 @@ static int rtl8365mb_change_tag_protocol(struct d=
sa_switch *ds,
>  static int rtl8365mb_switch_init(struct realtek_priv *priv)
>  {
>         struct rtl8365mb *mb =3D priv->chip_data;
> +       const struct rtl8365mb_chip_info *ci;
>         int ret;
>         int i;
>
> +       ci =3D mb->chip_info;
> +
>         /* Do any chip-specific init jam before getting to the common stu=
ff */
> -       if (mb->jam_table) {
> -               for (i =3D 0; i < mb->jam_size; i++) {
> -                       ret =3D regmap_write(priv->map, mb->jam_table[i].=
reg,
> -                                          mb->jam_table[i].val);
> +       if (ci->jam_table) {
> +               for (i =3D 0; i < ci->jam_size; i++) {
> +                       ret =3D regmap_write(priv->map, ci->jam_table[i].=
reg,
> +                                          ci->jam_table[i].val);
>                         if (ret)
>                                 return ret;
>                 }
> @@ -1962,6 +2048,7 @@ static int rtl8365mb_detect(struct realtek_priv *pr=
iv)
>         u32 chip_id;
>         u32 chip_ver;
>         int ret;
> +       int i;
>
>         ret =3D rtl8365mb_get_chip_id_and_ver(priv->map, &chip_id, &chip_=
ver);
>         if (ret) {
> @@ -1970,52 +2057,32 @@ static int rtl8365mb_detect(struct realtek_priv *=
priv)
>                 return ret;
>         }
>
> -       switch (chip_id) {
> -       case RTL8365MB_CHIP_ID_8365MB_VC:
> -               switch (chip_ver) {
> -               case RTL8365MB_CHIP_VER_8365MB_VC:
> -                       dev_info(priv->dev,
> -                                "found an RTL8365MB-VC switch (ver=3D0x%=
04x)\n",
> -                                chip_ver);
> -                       break;
> -               case RTL8365MB_CHIP_VER_8367RB_VB:
> -                       dev_info(priv->dev,
> -                                "found an RTL8367RB-VB switch (ver=3D0x%=
04x)\n",
> -                                chip_ver);
> -                       break;
> -               case RTL8365MB_CHIP_VER_8367S:
> -                       dev_info(priv->dev,
> -                                "found an RTL8367S switch (ver=3D0x%04x)=
\n",
> -                                chip_ver);
> +       for (i =3D 0; i < ARRAY_SIZE(rtl8365mb_chip_infos); i++) {
> +               const struct rtl8365mb_chip_info *ci =3D &rtl8365mb_chip_=
infos[i];
> +
> +               if (ci->chip_id =3D=3D chip_id && ci->chip_ver =3D=3D chi=
p_ver) {
> +                       mb->chip_info =3D ci;
>                         break;
> -               default:
> -                       dev_err(priv->dev, "unrecognized switch version (=
ver=3D0x%04x)",
> -                               chip_ver);
> -                       return -ENODEV;
>                 }
> +       }
>
> -               priv->num_ports =3D RTL8365MB_MAX_NUM_PORTS;
> -
> -               mb->priv =3D priv;
> -               mb->chip_id =3D chip_id;
> -               mb->chip_ver =3D chip_ver;
> -               mb->jam_table =3D rtl8365mb_init_jam_8365mb_vc;
> -               mb->jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc)=
;
> -
> -               mb->cpu.trap_port =3D RTL8365MB_MAX_NUM_PORTS;
> -               mb->cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
> -               mb->cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
> -               mb->cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
> -               mb->cpu.format =3D RTL8365MB_CPU_FORMAT_8BYTES;
> -
> -               break;
> -       default:
> +       if (!mb->chip_info) {
>                 dev_err(priv->dev,
> -                       "found an unknown Realtek switch (id=3D0x%04x, ve=
r=3D0x%04x)\n",
> -                       chip_id, chip_ver);
> +                       "unrecognized switch (id=3D0x%04x, ver=3D0x%04x)"=
, chip_id,
> +                       chip_ver);
>                 return -ENODEV;
>         }
>
> +       dev_info(priv->dev, "found an %s switch\n", mb->chip_info->name);
> +
> +       priv->num_ports =3D RTL8365MB_MAX_NUM_PORTS;
> +       mb->priv =3D priv;
> +       mb->cpu.trap_port =3D RTL8365MB_MAX_NUM_PORTS;
> +       mb->cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
> +       mb->cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
> +       mb->cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
> +       mb->cpu.format =3D RTL8365MB_CPU_FORMAT_8BYTES;
> +
>         return 0;
>  }
>
> --
> 2.36.1
>

In spite of my style comments, it looks good.

Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
