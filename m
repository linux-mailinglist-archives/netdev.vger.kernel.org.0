Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621046E308A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDOK27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 06:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOK27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 06:28:59 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D5C421B;
        Sat, 15 Apr 2023 03:28:55 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id la3so20630593plb.11;
        Sat, 15 Apr 2023 03:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681554534; x=1684146534;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yy4ledyPEci/TYoNyI5ZWG9laD/wmZMGJC+OzO3oEVg=;
        b=VUt38y59628GgKN5CReDbJK4kY2ZQJGZg3Ea5SexonXpxEUqs7Ufe86mxupXWsvggJ
         L42HuJsmMj8Ya+76pLevWyC6+HYBCPPcjMiXFFq1qVXqpDMPzYX8JQ78ltNN5aGJnrmV
         1fKzmT3chwValaoaEHcPysKLv4VAVpVIUCYJh/dNbGDhd+W7/S8enMXGpeL/2b67Tysk
         DC6MfmkIrpj+9/vKe7CB8qjZsPZvMmdQfmTEj9bgZN9OfHJ28vM3K3qvBLTjtfMGsKTL
         YdoqilL/rTxYpnwOZfdS0C1qOhWLzS3Ss5wHsgP/O3I0zEc3ZkdRXZvveTQabdmENoCQ
         VkZw==
X-Gm-Message-State: AAQBX9cYuJPg767Tjpo5aJx/eAZ3MUjxBBOfKBUDocLcCSAuwwtdubq9
        r4d9ayLYpWSNNn5fOLpox7docYJJ4MdUOHLEAc3E14smxsI=
X-Google-Smtp-Source: AKy350bSiF4LZbXInQwTnaEfyzL5y13CcBLnBr7xHmeJmFabWvIwjUTKcTVhq8KngHpNfF4ymGI/LFHQnyNoIrszu1s=
X-Received: by 2002:a17:90a:2fc7:b0:247:4a26:72d4 with SMTP id
 n7-20020a17090a2fc700b002474a2672d4mr3988673pjm.32.1681554534144; Sat, 15 Apr
 2023 03:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230413084253.1524-1-peter_hong@fintek.com.tw>
In-Reply-To: <20230413084253.1524-1-peter_hong@fintek.com.tw>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 15 Apr 2023 19:28:42 +0900
Message-ID: <CAMZ6RqKuBuZigMAW7CMOFSaWxNS=Q-kWh2xAE2TVtcoBLs+ybA@mail.gmail.com>
Subject: Re: [PATCH V4] can: usb: f81604: add Fintek F81604 support
To:     "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, mkl@pengutronix.de,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

The patch is getting better. But there are a lot of u8 * buffers I
would like to get rid of.

On Tue. 13 Apr 2023 at 17:42, Ji-Ze Hong (Peter Hong)
<peter_hong@fintek.com.tw> wrote:
> This patch adds support for Fintek USB to 2CAN controller.
>
> Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> ---
> Changelog:
> v4:
>         1. Remove f81604_prepare_urbs/f81604_remove_urbs() and alloc URB/buffer
>            dynamically in f81604_register_urbs(), using "urbs_anchor" for manage
>            all rx/int URBs.
>         2. Add F81604 to MAINTAINERS list.
>         3. Change handle_clear_reg_work/handle_clear_overrun_work to single
>            clear_reg_work and using bitwise "clear_flags" to record it.
>         4. Move __f81604_set_termination in front of f81604_probe() to avoid
>            rarely racing condition.
>         5. Add __aligned to struct f81604_int_data / f81604_sff / f81604_eff.
>         6. Add aligned operations in f81604_start_xmit/f81604_process_rx_packet().
>         7. Change lots of CANBUS functions first parameter from struct usb_device*
>            to struct f81604_port_priv *priv. But remain f81604_write / f81604_read
>            / f81604_update_bits() as struct usb_device* for
>            __f81604_set_termination() in probe() stage.
>         8. Simplify f81604_read_int_callback() and separate into
>            f81604_handle_tx / f81604_handle_can_bus_errors() functions.
>
> v3:
>         1. Change CAN clock to using MEGA units.
>         2. Remove USB set/get retry, only remain SJA1000 reset/operation retry.
>         3. Fix all numberic constant to define.
>         4. Add terminator control. (only 0 & 120 ohm)
>         5. Using struct data to represent INT/TX/RX endpoints data instead byte
>            arrays.
>         6. Error message reports changed from %d to %pe for mnemotechnic values.
>         7. Some bit operations are changed to FIELD_PREP().
>         8. Separate TX functions from f81604_read_int_callback().
>         9. cf->can_id |= CAN_ERR_CNT in f81604_read_int_callback to report valid
>            TX/RX error counts.
>         10. Move f81604_prepare_urbs/f81604_remove_urbs() from CAN open/close() to
>             USB probe/disconnect().
>         11. coding style refactoring.
>
> v2:
>         1. coding style refactoring.
>         2. some const number are defined to describe itself.
>         3. fix wrong usage for can_get_echo_skb() in f81604_write_bulk_callback().
>
>  MAINTAINERS                  |    6 +
>  drivers/net/can/usb/Kconfig  |   12 +
>  drivers/net/can/usb/Makefile |    1 +
>  drivers/net/can/usb/f81604.c | 1221 ++++++++++++++++++++++++++++++++++
>  4 files changed, 1240 insertions(+)
>  create mode 100644 drivers/net/can/usb/f81604.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f375bbf3bc80..fa573f637c2f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8058,6 +8058,12 @@ S:       Maintained
>  F:     drivers/hwmon/f75375s.c
>  F:     include/linux/f75375s.h
>
> +FINTEK F81604 USB to 2xCANBUS DEVICE DRIVER
> +M:     Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> +L:     linux-can@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/can/usb/f81604.c
> +
>  FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET STREAMING ENGINE
>  M:     Clemens Ladisch <clemens@ladisch.de>
>  M:     Takashi Sakamoto <o-takashi@sakamocchi.jp>
> diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
> index 445504ababce..58fcd2b34820 100644
> --- a/drivers/net/can/usb/Kconfig
> +++ b/drivers/net/can/usb/Kconfig
> @@ -38,6 +38,18 @@ config CAN_ETAS_ES58X
>           To compile this driver as a module, choose M here: the module
>           will be called etas_es58x.
>
> +config CAN_F81604
> +        tristate "Fintek F81604 USB to 2CAN interface"
> +        help
> +          This driver supports the Fintek F81604 USB to 2CAN interface.
> +          The device can support CAN2.0A/B protocol and also support
> +          2 output pins to control external terminator (optional).
> +
> +          To compile this driver as a module, choose M here: the module will
> +          be called f81604.
> +
> +          (see also https://www.fintek.com.tw).
> +
>  config CAN_GS_USB
>         tristate "Geschwister Schneider UG and candleLight compatible interfaces"
>         help
> diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
> index 1ea16be5743b..8b11088e9a59 100644
> --- a/drivers/net/can/usb/Makefile
> +++ b/drivers/net/can/usb/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_CAN_8DEV_USB) += usb_8dev.o
>  obj-$(CONFIG_CAN_EMS_USB) += ems_usb.o
>  obj-$(CONFIG_CAN_ESD_USB) += esd_usb.o
>  obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x/
> +obj-$(CONFIG_CAN_F81604) += f81604.o
>  obj-$(CONFIG_CAN_GS_USB) += gs_usb.o
>  obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb/
>  obj-$(CONFIG_CAN_MCBA_USB) += mcba_usb.o
> diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
> new file mode 100644
> index 000000000000..ce83a7993c4b
> --- /dev/null
> +++ b/drivers/net/can/usb/f81604.c
> @@ -0,0 +1,1221 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Fintek F81604 USB-to-2CAN controller driver.
> + *
> + * Copyright (C) 2023 Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> + */
> +#include <linux/bitfield.h>
> +#include <linux/netdevice.h>
> +#include <linux/units.h>
> +#include <linux/usb.h>
> +
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +#include <linux/can/error.h>
> +#include <linux/can/platform/sja1000.h>
> +
> +#include <asm-generic/unaligned.h>
> +
> +/* vendor and product id */
> +#define F81604_VENDOR_ID 0x2c42
> +#define F81604_PRODUCT_ID 0x1709
> +#define F81604_CAN_CLOCK (24 * MEGA / 2)

Why not:

  #define F81604_CAN_CLOCK (12 * MEGA)

?

> +#define F81604_MAX_DEV 2
> +#define F81604_SET_DEVICE_RETRY 10
> +
> +#define F81604_USB_TIMEOUT 2000
> +#define F81604_SET_GET_REGISTER 0xA0
> +#define F81604_PORT_OFFSET 0x1000
> +
> +#define F81604_BULK_SIZE 64
> +#define F81604_INT_SIZE 16
> +#define F81604_DATA_SIZE 14
> +#define F81604_MAX_RX_URBS 4
> +
> +#define F81604_CMD_DATA 0x00
> +
> +#define F81604_DLC_LEN_MASK 0x0f
> +#define F81604_DLC_EFF_BIT BIT(7)
> +#define F81604_DLC_RTR_BIT BIT(6)
> +
> +#define F81604_BRP_MASK GENMASK(5, 0)
> +#define F81604_SJW_MASK GENMASK(7, 6)
> +
> +#define F81604_SEG1_MASK GENMASK(3, 0)
> +#define F81604_SEG2_MASK GENMASK(6, 4)
> +
> +#define F81604_CLEAR_ALC 0
> +#define F81604_CLEAR_ECC 1
> +#define F81604_CLEAR_OVERRUN 2
> +
> +/* device setting */
> +#define F81604_CTRL_MODE_REG 0x80
> +#define F81604_TX_ONESHOT (0x03 << 3)
> +#define F81604_TX_NORMAL (0x01 << 3)
> +#define F81604_RX_AUTO_RELEASE_BUF BIT(1)
> +#define F81604_INT_WHEN_CHANGE BIT(0)
> +
> +#define F81604_TERMINATOR_REG 0x105
> +#define F81604_CAN0_TERM BIT(2)
> +#define F81604_CAN1_TERM BIT(3)
> +
> +#define F81604_TERMINATION_DISABLED CAN_TERMINATION_DISABLED
> +#define F81604_TERMINATION_ENABLED 120
> +
> +/* SJA1000 registers - manual section 6.4 (Pelican Mode) */
> +#define F81604_SJA1000_MOD 0x00
> +#define F81604_SJA1000_CMR 0x01
> +#define F81604_SJA1000_IR 0x03
> +#define F81604_SJA1000_IER 0x04
> +#define F81604_SJA1000_ALC 0x0B
> +#define F81604_SJA1000_ECC 0x0C
> +#define F81604_SJA1000_RXERR 0x0E
> +#define F81604_SJA1000_TXERR 0x0F
> +#define F81604_SJA1000_ACCC0 0x10
> +#define F81604_SJA1000_ACCM0 0x14
> +#define F81604_MAX_FILTER_CNT 4
> +
> +/* Common registers - manual section 6.5 */
> +#define F81604_SJA1000_BTR0 0x06
> +#define F81604_SJA1000_BTR1 0x07
> +#define F81604_SJA1000_BTR1_SAMPLE_TRIPLE BIT(7)
> +#define F81604_SJA1000_OCR 0x08
> +#define F81604_SJA1000_CDR 0x1F
> +
> +/* mode register */
> +#define F81604_SJA1000_MOD_RM 0x01
> +#define F81604_SJA1000_MOD_LOM 0x02
> +#define F81604_SJA1000_MOD_STM 0x04
> +
> +/* commands */
> +#define F81604_SJA1000_CMD_CDO 0x08
> +
> +/* interrupt sources */
> +#define F81604_SJA1000_IRQ_BEI 0x80
> +#define F81604_SJA1000_IRQ_ALI 0x40
> +#define F81604_SJA1000_IRQ_EPI 0x20
> +#define F81604_SJA1000_IRQ_DOI 0x08
> +#define F81604_SJA1000_IRQ_EI 0x04
> +#define F81604_SJA1000_IRQ_TI 0x02
> +#define F81604_SJA1000_IRQ_RI 0x01
> +#define F81604_SJA1000_IRQ_ALL 0xFF
> +#define F81604_SJA1000_IRQ_OFF 0x00
> +
> +/* status register content */
> +#define F81604_SJA1000_SR_BS 0x80
> +#define F81604_SJA1000_SR_ES 0x40
> +#define F81604_SJA1000_SR_TCS 0x08
> +
> +/* ECC register */
> +#define F81604_SJA1000_ECC_SEG 0x1F
> +#define F81604_SJA1000_ECC_DIR 0x20
> +#define F81604_SJA1000_ECC_BIT 0x00
> +#define F81604_SJA1000_ECC_FORM 0x40
> +#define F81604_SJA1000_ECC_STUFF 0x80
> +#define F81604_SJA1000_ECC_MASK 0xc0
> +
> +/* ALC register */
> +#define F81604_SJA1000_ALC_MASK 0x1f
> +
> +/* table of devices that work with this driver */
> +static const struct usb_device_id f81604_table[] = {
> +       { USB_DEVICE(F81604_VENDOR_ID, F81604_PRODUCT_ID) },
> +       {} /* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, f81604_table);
> +
> +static const struct ethtool_ops f81604_ethtool_ops = {
> +       .get_ts_info = ethtool_op_get_ts_info,
> +};
> +
> +static const u16 f81604_termination[] = { F81604_TERMINATION_DISABLED,
> +                                         F81604_TERMINATION_ENABLED };
> +
> +struct f81604_priv {
> +       struct net_device *netdev[F81604_MAX_DEV];
> +};
> +
> +struct f81604_port_priv {
> +       struct can_priv can;
> +       struct net_device *netdev;
> +       struct sk_buff *echo_skb;
> +
> +       unsigned long clear_flags;
> +       struct work_struct clear_reg_work;
> +
> +       struct usb_device *dev;
> +       struct usb_interface *intf;
> +
> +       struct usb_anchor urbs_anchor;
> +};
> +
> +/* Interrupt endpoint data format:
> + *     Byte 0: Status register.
> + *     Byte 1: Interrupt register.
> + *     Byte 2: Interrupt enable register.
> + *     Byte 3: Arbitration lost capture(ALC) register.
> + *     Byte 4: Error code capture(ECC) register.
> + *     Byte 5: Error warning limit register.
> + *     Byte 6: RX error counter register.
> + *     Byte 7: TX error counter register.
> + *     Byte 8: Reserved.
> + */
> +struct f81604_int_data {
> +       u8 sr;
> +       u8 isrc;
> +       u8 ier;
> +       u8 alc;
> +       u8 ecc;
> +       u8 ewlr;
> +       u8 rxerr;
> +       u8 txerr;
> +       u8 val;
> +} __packed __aligned(4);
> +
> +struct f81604_sff {
> +       __be16 id;
> +       u8 data[CAN_MAX_DLEN];
> +} __packed __aligned(2);
> +
> +struct f81604_eff {
> +       __be32 id;
> +       u8 data[CAN_MAX_DLEN];
> +} __packed __aligned(2);
> +
> +struct f81604_can_frame {
> +       u8 cmd;
> +
> +       /* According for F81604 DLC define:
> +        *      bit 3~0: data length (0~8)
> +        *      bit6: is RTR flag.
> +        *      bit7: is EFF frame.
> +        */
> +       u8 dlc;
> +
> +       union {
> +               struct f81604_sff sff;
> +               struct f81604_eff eff;
> +       };
> +} __packed;

__aligned(2)?

> +
> +static_assert(sizeof(struct f81604_can_frame) == F81604_DATA_SIZE);
> +
> +static const u8 bulk_in_addr[F81604_MAX_DEV] = { 2, 4 };
> +static const u8 bulk_out_addr[F81604_MAX_DEV] = { 1, 3 };
> +static const u8 int_in_addr[F81604_MAX_DEV] = { 1, 3 };
> +
> +static int f81604_write(struct usb_device *dev, u16 reg, u8 data)
> +{
> +       int ret;
> +
> +       ret = usb_control_msg_send(dev, 0, F81604_SET_GET_REGISTER,
> +                                  USB_TYPE_VENDOR | USB_DIR_OUT, 0, reg,
> +                                  &data, sizeof(data), F81604_USB_TIMEOUT,
> +                                  GFP_KERNEL);
> +       if (ret)
> +               dev_err(&dev->dev, "%s: reg: %x data: %x failed: %pe\n",
> +                       __func__, reg, data, ERR_PTR(ret));
> +
> +       return ret;
> +}
> +
> +static int f81604_read(struct usb_device *dev, u16 reg, u8 *data)
> +{
> +       int ret;
> +
> +       ret = usb_control_msg_recv(dev, 0, F81604_SET_GET_REGISTER,
> +                                  USB_TYPE_VENDOR | USB_DIR_IN, 0, reg, data,
> +                                  sizeof(*data), F81604_USB_TIMEOUT,
> +                                  GFP_KERNEL);
> +
> +       if (ret < 0)
> +               dev_err(&dev->dev, "%s: reg: %x failed: %pe\n", __func__, reg,
> +                       ERR_PTR(ret));
> +
> +       return ret;
> +}
> +
> +static int f81604_update_bits(struct usb_device *dev, u16 reg, u8 mask,
> +                             u8 data)
> +{
> +       int ret;
> +       u8 tmp;
> +
> +       ret = f81604_read(dev, reg, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       tmp &= ~mask;
> +       tmp |= (mask & data);
> +
> +       return f81604_write(dev, reg, tmp);
> +}
> +
> +static int f81604_sja1000_write(struct f81604_port_priv *priv, u16 reg,
> +                               u8 data)
> +{
> +       int port = priv->netdev->dev_id;
> +       int real_reg;
> +
> +       real_reg = reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET;
> +       return f81604_write(priv->dev, real_reg, data);
> +}
> +
> +static int f81604_sja1000_read(struct f81604_port_priv *priv, u16 reg,
> +                              u8 *data)
> +{
> +       int port = priv->netdev->dev_id;
> +       int real_reg;
> +
> +       real_reg = reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET;
> +       return f81604_read(priv->dev, real_reg, data);
> +}
> +
> +static int f81604_set_reset_mode(struct f81604_port_priv *priv)
> +{
> +       int ret, i;
> +       u8 tmp;
> +
> +       /* disable interrupts */
> +       ret = f81604_sja1000_write(priv, F81604_SJA1000_IER,
> +                                  F81604_SJA1000_IRQ_OFF);
> +       if (ret)
> +               return ret;
> +
> +       for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
> +               ret = f81604_sja1000_read(priv, F81604_SJA1000_MOD, &tmp);
> +               if (ret)
> +                       return ret;
> +
> +               /* check reset bit */
> +               if (tmp & F81604_SJA1000_MOD_RM) {
> +                       priv->can.state = CAN_STATE_STOPPED;
> +                       return 0;
> +               }
> +
> +               /* reset chip */
> +               ret = f81604_sja1000_write(priv, F81604_SJA1000_MOD,
> +                                          F81604_SJA1000_MOD_RM);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return -EPERM;
> +}
> +
> +static int f81604_set_normal_mode(struct f81604_port_priv *priv)
> +{
> +       u8 tmp, ier = 0;
> +       u8 mod_reg = 0;
> +       int ret, i;
> +
> +       for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
> +               ret = f81604_sja1000_read(priv, F81604_SJA1000_MOD, &tmp);
> +               if (ret)
> +                       return ret;
> +
> +               /* check reset bit */
> +               if ((tmp & F81604_SJA1000_MOD_RM) == 0) {
> +                       priv->can.state = CAN_STATE_ERROR_ACTIVE;
> +                       /* enable interrupts, RI handled by bulk-in */
> +                       ier = F81604_SJA1000_IRQ_ALL & ~F81604_SJA1000_IRQ_RI;
> +                       if (!(priv->can.ctrlmode &
> +                             CAN_CTRLMODE_BERR_REPORTING))
> +                               ier &= ~F81604_SJA1000_IRQ_BEI;
> +
> +                       return f81604_sja1000_write(priv, F81604_SJA1000_IER,
> +                                                   ier);
> +               }
> +
> +               /* set chip to normal mode */
> +               if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> +                       mod_reg |= F81604_SJA1000_MOD_LOM;
> +               if (priv->can.ctrlmode & CAN_CTRLMODE_PRESUME_ACK)
> +                       mod_reg |= F81604_SJA1000_MOD_STM;
> +
> +               ret = f81604_sja1000_write(priv, F81604_SJA1000_MOD, mod_reg);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return -EPERM;
> +}
> +
> +static int f81604_chipset_init(struct f81604_port_priv *priv)
> +{
> +       int i, ret;
> +
> +       /* set clock divider and output control register */
> +       ret = f81604_sja1000_write(priv, F81604_SJA1000_CDR,
> +                                  CDR_CBP | CDR_PELICAN);
> +       if (ret)
> +               return ret;
> +
> +       /* set acceptance filter (accept all) */
> +       for (i = 0; i < F81604_MAX_FILTER_CNT; ++i) {
> +               ret = f81604_sja1000_write(priv, F81604_SJA1000_ACCC0 + i, 0);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       for (i = 0; i < F81604_MAX_FILTER_CNT; ++i) {
> +               ret = f81604_sja1000_write(priv, F81604_SJA1000_ACCM0 + i,
> +                                          0xFF);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return f81604_sja1000_write(priv, F81604_SJA1000_OCR,
> +                                   OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL |
> +                                           OCR_MODE_NORMAL);
> +}
> +
> +static void f81604_process_rx_packet(struct urb *urb)
> +{
> +       struct net_device *netdev = urb->context;
> +       struct net_device_stats *stats;
> +       struct f81604_can_frame *frame;
> +       struct can_frame *cf;
> +       struct sk_buff *skb;
> +       unsigned int count;
> +       unsigned int i;
:> +       u8 *data;

Do not use an opaque pointer. You can directly cast to an array of
struct f81604_can_frame:

          struct f81604_can_frame *frames = urb->transfer_buffer;

> +       data = urb->transfer_buffer;
> +       stats = &netdev->stats;
> +
> +       if (urb->actual_length % F81604_DATA_SIZE)
> +               netdev_warn(netdev, "URB length %u not multiple of %u\n",
> +                           urb->actual_length, F81604_DATA_SIZE);
> +       else if (!urb->actual_length)
> +               netdev_warn(netdev, "URB length is 0\n");
> +
> +       count = urb->actual_length / F81604_DATA_SIZE;

It would be better to have the URB sanitization inside
f81604_read_bulk_callback().

> +       for (i = 0; i < count; ++i) {

The loop iteration can also be in f81604_read_bulk_callback().

> +               frame = (struct f81604_can_frame *)&data[i * F81604_DATA_SIZE];
> +
> +               if (frame->cmd != F81604_CMD_DATA)
> +                       continue;
> +
> +               skb = alloc_can_skb(netdev, &cf);
> +               if (!skb) {
> +                       stats->rx_dropped++;
> +                       continue;
> +               }
> +
> +               cf->len = can_cc_dlc2len(frame->dlc & F81604_DLC_LEN_MASK);
> +
> +               if (frame->dlc & F81604_DLC_EFF_BIT) {
> +                       cf->can_id = get_unaligned_be32(&frame->eff.id) >> 3;

Use a #define instead of magic number.

> +                       cf->can_id |= CAN_EFF_FLAG;
> +
> +                       if (cf->len)

No need to check if len is not zero. memcpy(cf->data, frame->eff.data,
0) works fine. However, you need to check that this is not an RTR
frame:

          if (!(frame->dlc & F81604_DLC_RTR_BIT))

> +                               memcpy(cf->data, frame->eff.data, cf->len);
> +               } else {
> +                       cf->can_id = get_unaligned_be16(&frame->sff.id) >> 5;

Use a #define instead of magic number.

> +
> +                       if (cf->len)

No need to check if len is not zero. memcpy(cf->data, frame->eff.data,
0) works fine. However, you need to check that this is not an RTR
frame:

          if (!(frame->dlc & F81604_DLC_RTR_BIT))

> +                               memcpy(cf->data, frame->sff.data, cf->len);
> +               }
> +
> +               if (frame->dlc & F81604_DLC_RTR_BIT)
> +                       cf->can_id |= CAN_RTR_FLAG;
> +               else
> +                       stats->rx_bytes += cf->len;
> +
> +               stats->rx_packets++;
> +               netif_rx(skb);
> +       }
> +}
> +
> +static void f81604_read_bulk_callback(struct urb *urb)
> +{
> +       struct net_device *netdev = urb->context;

+        struct f81604_can_frame *frames = urb->transfer_buffer;
+        int i;

> +       int ret;
> +
> +       if (!netif_device_present(netdev))
> +               return;
> +
> +       if (urb->status)
> +               netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
> +                           ERR_PTR(urb->status));
> +
> +       switch (urb->status) {
> +       case 0: /* success */
> +               break;
> +
> +       case -ENOENT:
> +       case -EPIPE:
> +       case -EPROTO:
> +       case -ESHUTDOWN:
> +               return;
> +
> +       default:
> +               goto resubmit_urb;
> +       }

Something like that (c.f. above):

+       if (urb->actual_length % F81604_DATA_SIZE)
+               netdev_warn(netdev, "URB length %u not multiple of %u\n",
+                           urb->actual_length, F81604_DATA_SIZE);
+       else if (!urb->actual_length)
+               netdev_warn(netdev, "URB length is 0\n");
+
+       for (i = 0; i < urb->actual_length / sizeof(f81604_can_frame[0]; i++)
+              f81604_process_rx_packet(netdev, &f81604_can_frame[i]);

> +resubmit_urb:
> +       ret = usb_submit_urb(urb, GFP_ATOMIC);
> +       if (ret == -ENODEV)
> +               netif_device_detach(netdev);
> +       else if (ret)
> +               netdev_err(netdev,
> +                          "%s: failed to resubmit read bulk urb: %pe\n",
> +                          __func__, ERR_PTR(ret));
> +}
> +
> +static void f81604_handle_tx(struct f81604_port_priv *priv,
> +                            struct f81604_int_data *data)
> +{
> +       struct net_device *netdev = priv->netdev;
> +       struct net_device_stats *stats;
> +
> +       stats = &netdev->stats;
> +
> +       /* transmission buffer released */
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
> +           !(data->sr & F81604_SJA1000_SR_TCS)) {
> +               stats->tx_errors++;
> +               can_free_echo_skb(netdev, 0, NULL);
> +       } else {
> +               /* transmission complete */
> +               stats->tx_bytes += can_get_echo_skb(netdev, 0, NULL);
> +               stats->tx_packets++;
> +       }
> +
> +       netif_wake_queue(netdev);
> +}
> +
> +static void f81604_handle_can_bus_errors(struct f81604_port_priv *priv,
> +                                        struct f81604_int_data *data)
> +{
> +       enum can_state can_state = priv->can.state;
> +       struct net_device *netdev = priv->netdev;
> +       enum can_state tx_state, rx_state;
> +       struct net_device_stats *stats;
> +       struct can_frame *cf;
> +       struct sk_buff *skb;
> +
> +       stats = &netdev->stats;
> +
> +       /* Note: ALC/ECC will not auto clear by read here, must be cleared by
> +        * read register (via clear_reg_work).
> +        */
> +
> +       skb = alloc_can_err_skb(netdev, &cf);
> +       if (skb) {
> +               cf->can_id |= CAN_ERR_CNT;
> +               cf->data[6] = data->txerr;
> +               cf->data[7] = data->rxerr;
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_DOI) {
> +               /* data overrun interrupt */
> +               netdev_dbg(netdev, "data overrun interrupt\n");
> +
> +               if (skb) {
> +                       cf->can_id |= CAN_ERR_CRTL;
> +                       cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
> +               }
> +
> +               stats->rx_over_errors++;
> +               stats->rx_errors++;
> +
> +               set_bit(F81604_CLEAR_OVERRUN, &priv->clear_flags);
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_EI) {
> +               /* error warning interrupt */
> +               netdev_dbg(netdev, "error warning interrupt\n");
> +
> +               if (data->sr & F81604_SJA1000_SR_BS)
> +                       can_state = CAN_STATE_BUS_OFF;
> +               else if (data->sr & F81604_SJA1000_SR_ES)
> +                       can_state = CAN_STATE_ERROR_WARNING;
> +               else
> +                       can_state = CAN_STATE_ERROR_ACTIVE;
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_BEI) {
> +               /* bus error interrupt */
> +               netdev_dbg(netdev, "bus error interrupt\n");
> +
> +               priv->can.can_stats.bus_error++;
> +               stats->rx_errors++;
> +
> +               if (skb) {
> +                       cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +
> +                       /* set error type */
> +                       switch (data->ecc & F81604_SJA1000_ECC_MASK) {
> +                       case F81604_SJA1000_ECC_BIT:
> +                               cf->data[2] |= CAN_ERR_PROT_BIT;
> +                               break;
> +                       case F81604_SJA1000_ECC_FORM:
> +                               cf->data[2] |= CAN_ERR_PROT_FORM;
> +                               break;
> +                       case F81604_SJA1000_ECC_STUFF:
> +                               cf->data[2] |= CAN_ERR_PROT_STUFF;
> +                               break;
> +                       default:
> +                               break;
> +                       }
> +
> +                       /* set error location */
> +                       cf->data[3] = data->ecc & F81604_SJA1000_ECC_SEG;
> +
> +                       /* Error occurred during transmission? */
> +                       if ((data->ecc & F81604_SJA1000_ECC_DIR) == 0)
> +                               cf->data[2] |= CAN_ERR_PROT_TX;
> +               }
> +
> +               set_bit(F81604_CLEAR_ECC, &priv->clear_flags);
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_EPI) {
> +               if (can_state == CAN_STATE_ERROR_PASSIVE)
> +                       can_state = CAN_STATE_ERROR_WARNING;
> +               else
> +                       can_state = CAN_STATE_ERROR_PASSIVE;
> +
> +               /* error passive interrupt */
> +               netdev_dbg(netdev, "error passive interrupt: %d\n", can_state);
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_ALI) {
> +               /* arbitration lost interrupt */
> +               netdev_dbg(netdev, "arbitration lost interrupt\n");
> +
> +               priv->can.can_stats.arbitration_lost++;
> +
> +               if (skb) {
> +                       cf->can_id |= CAN_ERR_LOSTARB;
> +                       cf->data[0] = data->alc & F81604_SJA1000_ALC_MASK;
> +               }
> +
> +               set_bit(F81604_CLEAR_ALC, &priv->clear_flags);
> +       }
> +
> +       if (can_state != priv->can.state) {
> +               tx_state = data->txerr >= data->rxerr ? can_state : 0;
> +               rx_state = data->txerr <= data->rxerr ? can_state : 0;
> +
> +               can_change_state(netdev, cf, tx_state, rx_state);
> +
> +               if (can_state == CAN_STATE_BUS_OFF)
> +                       can_bus_off(netdev);
> +       }
> +
> +       if (priv->clear_flags)
> +               schedule_work(&priv->clear_reg_work);
> +
> +       if (skb)
> +               netif_rx(skb);
> +}
> +
> +static void f81604_read_int_callback(struct urb *urb)
> +{
> +       struct f81604_int_data *data = urb->transfer_buffer;
> +       struct net_device *netdev = urb->context;
> +       struct f81604_port_priv *priv;
> +       int ret;
> +
> +       priv = netdev_priv(netdev);
> +
> +       if (!netif_device_present(netdev))
> +               return;
> +
> +       if (urb->status)
> +               netdev_info(netdev, "%s: Int URB aborted: %pe\n", __func__,
> +                           ERR_PTR(urb->status));
> +
> +       switch (urb->status) {
> +       case 0: /* success */
> +               break;
> +
> +       case -ENOENT:
> +       case -EPIPE:
> +       case -EPROTO:
> +       case -ESHUTDOWN:
> +               return;
> +
> +       default:
> +               goto resubmit_urb;
> +       }
> +
> +       /* handle Errors */
> +       if (data->isrc & (F81604_SJA1000_IRQ_DOI | F81604_SJA1000_IRQ_EI |
> +                         F81604_SJA1000_IRQ_BEI | F81604_SJA1000_IRQ_EPI |
> +                         F81604_SJA1000_IRQ_ALI))
> +               f81604_handle_can_bus_errors(priv, data);
> +
> +       /* handle TX */
> +       if (priv->can.state != CAN_STATE_BUS_OFF &&
> +           (data->isrc & F81604_SJA1000_IRQ_TI))
> +               f81604_handle_tx(priv, data);
> +
> +resubmit_urb:
> +       ret = usb_submit_urb(urb, GFP_ATOMIC);
> +       if (ret == -ENODEV)
> +               netif_device_detach(netdev);
> +       else if (ret)
> +               netdev_err(netdev, "%s: failed to resubmit int urb: %pe\n",
> +                          __func__, ERR_PTR(ret));
> +}
> +
> +static void f81604_unregister_urbs(struct f81604_port_priv *priv)
> +{
> +       usb_kill_anchored_urbs(&priv->urbs_anchor);
> +}
> +
> +static int f81604_register_urbs(struct f81604_port_priv *priv)
> +{
> +       struct net_device *netdev = priv->netdev;
> +       struct urb *rx_urb, *int_urb;
> +       int id = netdev->dev_id;
> +       u8 *rx_buf, *int_buf;

No opaque buffer, please.

> +       int rx_urb_cnt;
> +       int ret;
> +
> +       for (rx_urb_cnt = 0; rx_urb_cnt < F81604_MAX_RX_URBS; ++rx_urb_cnt) {
> +               rx_urb = usb_alloc_urb(0, GFP_KERNEL);
> +               if (!rx_urb) {
> +                       ret = -ENOMEM;
> +                       break;
> +               }
> +
> +               rx_buf = kmalloc(F81604_BULK_SIZE, GFP_KERNEL);

If I understand correctly, rx_buf contains some struct
f81604_can_frame. What about:

          struct f81604_can_frame *frames;
          frames = kmalloc_array(F81604_RX_MAX_FRAMES_CNT,
sizeof(*frame), GFP_KERNEL);

?

With F81604_RX_MAX_FRAMES_CNT the maximum number of frames the device
is capable of sending in one bulk.

> +               if (!rx_buf) {
> +                       usb_free_urb(rx_urb);
> +                       ret = -ENOMEM;
> +                       break;
> +               }
> +
> +               usb_fill_bulk_urb(rx_urb, priv->dev,
> +                                 usb_rcvbulkpipe(priv->dev, bulk_in_addr[id]),
> +                                 rx_buf, F81604_BULK_SIZE,
> +                                 f81604_read_bulk_callback, netdev);
> +
> +               rx_urb->transfer_flags |= URB_FREE_BUFFER;
> +               usb_anchor_urb(rx_urb, &priv->urbs_anchor);
> +
> +               ret = usb_submit_urb(rx_urb, GFP_KERNEL);
> +               if (ret) {
> +                       usb_unanchor_urb(rx_urb);
> +                       usb_free_urb(rx_urb);
> +
> +                       break;
> +               }
> +
> +               /* Drop reference, USB core will take care of freeing it */
> +               usb_free_urb(rx_urb);
> +       }
> +
> +       if (rx_urb_cnt == 0) {
> +               netdev_warn(netdev, "%s: submit rx urb failed: %pe\n",
> +                           __func__, ERR_PTR(ret));
> +
> +               goto error;
> +       }
> +       int_urb = usb_alloc_urb(0, GFP_KERNEL);
> +       if (!int_urb) {
> +               ret = -ENOMEM;
> +               goto error;
> +       }
> +
> +       int_buf = kmalloc(F81604_BULK_SIZE, GFP_KERNEL);

Why F81604_BULK_SIZE?

The int_buf is a struct f81604_int_data, right?

         struct f81604_int_data *int_data;
         int_data = kmalloc(sizeof(*int_data), GFP_KERNEL);

> +       if (!int_buf) {
> +               usb_free_urb(int_urb);
> +               ret = -ENOMEM;
> +               goto error;
> +       }
> +
> +       usb_fill_int_urb(int_urb, priv->dev,
> +                        usb_rcvintpipe(priv->dev, int_in_addr[id]), int_buf,
> +                        F81604_INT_SIZE, f81604_read_int_callback, netdev, 1);

       usb_fill_int_urb(int_urb, priv->dev,
                        usb_rcvintpipe(priv->dev, int_in_addr[id]), int_data,
                        sizeof(*int_data), f81604_read_int_callback, netdev, 1);

> +
> +       int_urb->transfer_flags |= URB_FREE_BUFFER;
> +       usb_anchor_urb(int_urb, &priv->urbs_anchor);
> +
> +       ret = usb_submit_urb(int_urb, GFP_KERNEL);
> +       if (ret) {
> +               usb_unanchor_urb(int_urb);
> +               usb_free_urb(int_urb);
> +
> +               netdev_warn(netdev, "%s: submit int urb failed: %pe\n",
> +                           __func__, ERR_PTR(ret));
> +               goto error;
> +       }
> +
> +       /* Drop reference, USB core will take care of freeing it */
> +       usb_free_urb(int_urb);
> +
> +       return 0;
> +
> +error:
> +       f81604_unregister_urbs(priv);
> +       return ret;
> +}
> +
> +static int f81604_start(struct net_device *netdev)
> +{
> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> +       int ret;
> +       u8 mode;
> +       u8 tmp;
> +
> +       mode = F81604_RX_AUTO_RELEASE_BUF | F81604_INT_WHEN_CHANGE;
> +
> +       /* Set TR/AT mode */
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> +               mode |= F81604_TX_ONESHOT;
> +       else
> +               mode |= F81604_TX_NORMAL;
> +
> +       ret = f81604_sja1000_write(priv, F81604_CTRL_MODE_REG, mode);
> +       if (ret)
> +               return ret;
> +
> +       /* set reset mode */
> +       ret = f81604_set_reset_mode(priv);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_chipset_init(priv);
> +       if (ret)
> +               return ret;
> +
> +       /* Clear error counters and error code capture */
> +       ret = f81604_sja1000_write(priv, F81604_SJA1000_TXERR, 0);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_sja1000_write(priv, F81604_SJA1000_RXERR, 0);
> +       if (ret)
> +               return ret;
> +
> +       /* Read clear for ECC/ALC/IR register */
> +       ret = f81604_sja1000_read(priv, F81604_SJA1000_ECC, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_sja1000_read(priv, F81604_SJA1000_ALC, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_sja1000_read(priv, F81604_SJA1000_IR, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_register_urbs(priv);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_set_normal_mode(priv);
> +       if (ret) {
> +               f81604_unregister_urbs(priv);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int f81604_set_bittiming(struct net_device *dev)
> +{
> +       struct f81604_port_priv *priv = netdev_priv(dev);
> +       struct can_bittiming *bt = &priv->can.bittiming;
> +       u8 btr0, btr1;
> +       int ret;
> +
> +       btr0 = FIELD_PREP(F81604_BRP_MASK, bt->brp - 1) |
> +              FIELD_PREP(F81604_SJW_MASK, bt->sjw - 1);
> +
> +       btr1 = FIELD_PREP(F81604_SEG1_MASK,
> +                         bt->prop_seg + bt->phase_seg1 - 1) |
> +              FIELD_PREP(F81604_SEG2_MASK, bt->phase_seg2 - 1);
> +
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
> +               btr1 |= F81604_SJA1000_BTR1_SAMPLE_TRIPLE;
> +
> +       ret = f81604_sja1000_write(priv, F81604_SJA1000_BTR0, btr0);
> +       if (ret) {
> +               netdev_warn(dev, "%s: Set BTR0 failed: %pe\n", __func__,
> +                           ERR_PTR(ret));
> +               return ret;
> +       }
> +
> +       ret = f81604_sja1000_write(priv, F81604_SJA1000_BTR1, btr1);
> +       if (ret) {
> +               netdev_warn(dev, "%s: Set BTR1 failed: %pe\n", __func__,
> +                           ERR_PTR(ret));
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int f81604_set_mode(struct net_device *netdev, enum can_mode mode)
> +{
> +       int ret;
> +
> +       switch (mode) {
> +       case CAN_MODE_START:
> +               ret = f81604_start(netdev);
> +               if (!ret && netif_queue_stopped(netdev))
> +                       netif_wake_queue(netdev);
> +               break;
> +
> +       default:
> +               ret = -EOPNOTSUPP;
> +       }
> +
> +       return ret;
> +}
> +
> +static void f81604_write_bulk_callback(struct urb *urb)
> +{
> +       struct net_device *netdev = urb->context;
> +
> +       if (!netif_device_present(netdev))
> +               return;
> +
> +       if (urb->status)
> +               netdev_info(netdev, "%s: Tx URB error: %pe\n", __func__,
> +                           ERR_PTR(urb->status));
> +}
> +
> +static void f81604_clear_reg_work(struct work_struct *work)
> +{
> +       struct f81604_port_priv *priv;
> +       struct net_device *netdev;
> +       u8 tmp;
> +
> +       priv = container_of(work, struct f81604_port_priv, clear_reg_work);
> +       netdev = priv->netdev;
> +
> +       /* dummy read for clear Arbitration lost capture(ALC) register. */
> +       if (test_and_clear_bit(F81604_CLEAR_ALC, &priv->clear_flags))
> +               f81604_sja1000_read(priv, F81604_SJA1000_ALC, &tmp);
> +
> +       /* dummy read for clear Error code capture(ECC) register. */
> +       if (test_and_clear_bit(F81604_CLEAR_ECC, &priv->clear_flags))
> +               f81604_sja1000_read(priv, F81604_SJA1000_ECC, &tmp);
> +
> +       /* dummy write for clear data overrun flag. */
> +       if (test_and_clear_bit(F81604_CLEAR_OVERRUN, &priv->clear_flags))
> +               f81604_sja1000_write(priv, F81604_SJA1000_CMR,
> +                                    F81604_SJA1000_CMD_CDO);
> +}
> +
> +static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
> +                                    struct net_device *netdev)
> +{
> +       struct can_frame *cf = (struct can_frame *)skb->data;
> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> +       struct net_device_stats *stats = &netdev->stats;
> +       struct f81604_can_frame *frame;
> +       u32 id = priv->netdev->dev_id;
> +       struct urb *write_urb;
> +       u8 *bulk_write_buffer;

Do not use an opaque buffer. Instead, directly use struct f81604_can_frame.

> +       int ret;
> +
> +       if (can_dev_dropped_skb(netdev, skb))
> +               return NETDEV_TX_OK;
> +
> +       netif_stop_queue(netdev);
> +
> +       write_urb = usb_alloc_urb(0, GFP_ATOMIC);
> +       if (!write_urb)
> +               goto nomem_urb;
> +
> +       bulk_write_buffer = kzalloc(F81604_DATA_SIZE, GFP_ATOMIC);

         frame = kzalloc(sizeof(*frame), GFP_ATOMIC);

> +       if (!bulk_write_buffer)
> +               goto nomem_buf;
> +
> +       usb_fill_bulk_urb(write_urb, priv->dev,
> +                         usb_sndbulkpipe(priv->dev, bulk_out_addr[id]),
> +                         bulk_write_buffer, F81604_DATA_SIZE,
> +                         f81604_write_bulk_callback, priv->netdev);

       usb_fill_bulk_urb(write_urb, priv->dev,
                         usb_sndbulkpipe(priv->dev, bulk_out_addr[id]),
                         frame, sizeof(*frame),
                         f81604_write_bulk_callback, priv->netdev);

> +
> +       write_urb->transfer_flags |= URB_FREE_BUFFER;
> +
> +       frame = (struct f81604_can_frame *)bulk_write_buffer;
> +       frame->cmd = F81604_CMD_DATA;
> +       frame->dlc = cf->len;
> +
> +       if (cf->can_id & CAN_RTR_FLAG)
> +               frame->dlc |= F81604_DLC_RTR_BIT;
> +
> +       if (cf->can_id & CAN_EFF_FLAG) {
> +               id = (cf->can_id & CAN_EFF_MASK) << 3;

Same as above: use a define instead of magic number.

> +               put_unaligned_be32(id, &frame->eff.id);
> +
> +               frame->dlc |= F81604_DLC_EFF_BIT;
> +
> +               if (!(cf->can_id & CAN_RTR_FLAG))
> +                       memcpy(&frame->eff.data, cf->data, cf->len);
> +       } else {
> +               id = (cf->can_id & CAN_SFF_MASK) << 5;

Same as above: use a define instead of magic number.

> +               put_unaligned_be16(id, &frame->sff.id);
> +
> +               if (!(cf->can_id & CAN_RTR_FLAG))
> +                       memcpy(&frame->sff.data, cf->data, cf->len);
> +       }
> +
> +       can_put_echo_skb(skb, netdev, 0, 0);
> +
> +       ret = usb_submit_urb(write_urb, GFP_ATOMIC);
> +       if (ret) {
> +               netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %pe\n",
> +                          __func__, ERR_PTR(ret));
> +
> +               can_free_echo_skb(netdev, 0, NULL);
> +               stats->tx_dropped++;
> +
> +               if (ret == -ENODEV)
> +                       netif_device_detach(netdev);
> +               else
> +                       netif_wake_queue(netdev);
> +       }
> +
> +       /* let usb core take care of this urb */
> +       usb_free_urb(write_urb);
> +
> +       return NETDEV_TX_OK;
> +
> +nomem_buf:
> +       usb_free_urb(write_urb);
> +
> +nomem_urb:
> +       dev_kfree_skb(skb);
> +       stats->tx_dropped++;
> +       netif_wake_queue(netdev);
> +
> +       return NETDEV_TX_OK;
> +}
> +
> +static int f81604_get_berr_counter(const struct net_device *netdev,
> +                                  struct can_berr_counter *bec)
> +{
> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> +       u8 txerr, rxerr;
> +       int ret;
> +
> +       ret = f81604_sja1000_read(priv, F81604_SJA1000_TXERR, &txerr);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_sja1000_read(priv, F81604_SJA1000_RXERR, &rxerr);
> +       if (ret)
> +               return ret;
> +
> +       bec->txerr = txerr;
> +       bec->rxerr = rxerr;
> +
> +       return 0;
> +}
> +
> +/* Open USB device */
> +static int f81604_open(struct net_device *netdev)
> +{
> +       int ret;
> +
> +       ret = open_candev(netdev);
> +       if (ret)
> +               return ret;
> +
> +       ret = f81604_start(netdev);
> +       if (ret)
> +               goto start_failed;
> +
> +       netif_start_queue(netdev);
> +       return 0;
> +
> +start_failed:
> +       if (ret == -ENODEV)
> +               netif_device_detach(netdev);
> +
> +       close_candev(netdev);
> +
> +       return ret;
> +}
> +
> +/* Close USB device */
> +static int f81604_close(struct net_device *netdev)
> +{
> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> +
> +       f81604_set_reset_mode(priv);
> +
> +       netif_stop_queue(netdev);
> +       cancel_work_sync(&priv->clear_reg_work);
> +       close_candev(netdev);
> +
> +       f81604_unregister_urbs(priv);
> +
> +       return 0;
> +}
> +
> +static const struct net_device_ops f81604_netdev_ops = {
> +       .ndo_open = f81604_open,
> +       .ndo_stop = f81604_close,
> +       .ndo_start_xmit = f81604_start_xmit,
> +       .ndo_change_mtu = can_change_mtu,
> +};
> +
> +static const struct can_bittiming_const f81604_bittiming_const = {
> +       .name = KBUILD_MODNAME,
> +       .tseg1_min = 1,
> +       .tseg1_max = 16,
> +       .tseg2_min = 1,
> +       .tseg2_max = 8,
> +       .sjw_max = 4,
> +       .brp_min = 1,
> +       .brp_max = 64,
> +       .brp_inc = 1,
> +};
> +
> +/* Called by the usb core when driver is unloaded or device is removed */
> +static void f81604_disconnect(struct usb_interface *intf)
> +{
> +       struct f81604_priv *priv = usb_get_intfdata(intf);
> +       struct f81604_port_priv *port_priv;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(priv->netdev); ++i) {
> +               if (!priv->netdev[i])
> +                       continue;
> +
> +               port_priv = netdev_priv(priv->netdev[i]);
> +
> +               unregister_netdev(priv->netdev[i]);
> +               free_candev(priv->netdev[i]);
> +       }
> +}
> +
> +static int __f81604_set_termination(struct usb_device *dev, int idx, u16 term)
> +{
> +       u8 mask, data = 0;
> +
> +       if (idx == 0)
> +               mask = F81604_CAN0_TERM;
> +       else
> +               mask = F81604_CAN1_TERM;
> +
> +       if (term)
> +               data = mask;
> +
> +       return f81604_update_bits(dev, F81604_TERMINATOR_REG, mask, data);
> +}
> +
> +static int f81604_set_termination(struct net_device *netdev, u16 term)
> +{
> +       struct f81604_port_priv *port_priv = netdev_priv(netdev);
> +
> +       ASSERT_RTNL();
> +
> +       return __f81604_set_termination(port_priv->dev, netdev->dev_id, term);
> +}
> +
> +static int f81604_probe(struct usb_interface *intf,
> +                       const struct usb_device_id *id)
> +{
> +       struct usb_device *dev = interface_to_usbdev(intf);
> +       struct f81604_port_priv *port_priv;
> +       struct net_device *netdev;
> +       struct f81604_priv *priv;
> +       int i, ret;
> +
> +       priv = devm_kzalloc(&intf->dev, sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       usb_set_intfdata(intf, priv);
> +
> +       for (i = 0; i < ARRAY_SIZE(priv->netdev); ++i) {
> +               ret = __f81604_set_termination(dev, i, 0);
> +               if (ret) {
> +                       dev_err(&intf->dev,
> +                               "Set can%d termination failed: %pe\n", i,

That would print:

  Set can0 termination failed

or:

  Set can1 termination failed

But can0 and can1 could be already use if there are other can devices
connected to the host. You should use a less ambiguous notation. e.g.

  "Setting termination of channel #%d failed: %pe"

> +                               ERR_PTR(ret));
> +                       return ret;
> +               }
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(priv->netdev); ++i) {
> +               netdev = alloc_candev(sizeof(*port_priv), 1);
> +               if (!netdev) {
> +                       dev_err(&intf->dev, "Couldn't alloc candev: %d\n", i);
> +                       ret = -ENOMEM;
> +
> +                       goto failure_cleanup;
> +               }
> +
> +               port_priv = netdev_priv(netdev);
> +               netdev->dev_id = i;

I think that dev_port is more appropriated than dev_id here. c.f.:

  https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net

> +               INIT_WORK(&port_priv->clear_reg_work, f81604_clear_reg_work);
> +               init_usb_anchor(&port_priv->urbs_anchor);
> +
> +               port_priv->intf = intf;
> +               port_priv->dev = dev;
> +               port_priv->netdev = netdev;
> +               port_priv->can.clock.freq = F81604_CAN_CLOCK;
> +
> +               port_priv->can.termination_const = f81604_termination;
> +               port_priv->can.termination_const_cnt =
> +                       ARRAY_SIZE(f81604_termination);
> +               port_priv->can.bittiming_const = &f81604_bittiming_const;
> +               port_priv->can.do_set_bittiming = f81604_set_bittiming;
> +               port_priv->can.do_set_mode = f81604_set_mode;
> +               port_priv->can.do_set_termination = f81604_set_termination;
> +               port_priv->can.do_get_berr_counter = f81604_get_berr_counter;
> +               port_priv->can.ctrlmode_supported =
> +                       CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
> +                       CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
> +                       CAN_CTRLMODE_PRESUME_ACK;
> +
> +               netdev->ethtool_ops = &f81604_ethtool_ops;
> +               netdev->netdev_ops = &f81604_netdev_ops;
> +               netdev->flags |= IFF_ECHO;
> +
> +               SET_NETDEV_DEV(netdev, &intf->dev);
> +
> +               ret = register_candev(netdev);
> +               if (ret) {
> +                       netdev_err(netdev, "register CAN device failed: %pe\n",
> +                                  ERR_PTR(ret));
> +                       free_candev(netdev);
> +
> +                       goto failure_cleanup;
> +               }
> +
> +               priv->netdev[i] = netdev;
> +
> +               dev_info(&intf->dev, "Channel #%d registered as %s\n", i,
> +                        netdev->name);

Do not print this message. Instead do:

          netdev->dev_port = i;

With this, you can then confirm the mapping using:

  udevadm info --attribute-walk /sys/class/net/canX | grep dev_port

> +       }
> +
> +       return 0;
> +
> +failure_cleanup:
> +       f81604_disconnect(intf);
> +       return ret;
> +}
> +
> +static struct usb_driver f81604_driver = {
> +       .name = KBUILD_MODNAME,
> +       .probe = f81604_probe,
> +       .disconnect = f81604_disconnect,
> +       .id_table = f81604_table,
> +};
> +
> +module_usb_driver(f81604_driver);
> +
> +MODULE_AUTHOR("Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>");
> +MODULE_DESCRIPTION("Fintek F81604 USB to 2xCANBUS");
> +MODULE_LICENSE("GPL");
> --
> 2.17.1
>
