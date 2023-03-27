Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DC46CA8B0
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjC0PKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjC0PKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:10:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB793586
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:10:30 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pgoTu-000738-IA; Mon, 27 Mar 2023 17:09:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 220B119D61D;
        Mon, 27 Mar 2023 15:09:51 +0000 (UTC)
Date:   Mon, 27 Mar 2023 17:09:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, michal.swiatkowski@linux.intel.com,
        Steen.Hegelund@microchip.com, mailhol.vincent@wanadoo.fr,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Subject: Re: [PATCH V3] can: usb: f81604: add Fintek F81604 support
Message-ID: <20230327150949.ywchpe26cg54oe5v@pengutronix.de>
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pa3ryuyfedvb6l65"
Content-Disposition: inline
In-Reply-To: <20230327051048.11589-1-peter_hong@fintek.com.tw>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pa3ryuyfedvb6l65
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.03.2023 13:10:48, Ji-Ze Hong (Peter Hong) wrote:
> This patch add support for Fintek USB to 2CAN controller support.

In addition to Vincent's comment, please describe your change
declarative, e.g.:

| Add support for the Fintek USB to 2CAN controller.

Please add an entry in the MAINTAINERS file.

> Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>

[...]

> diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
> index 1ea16be5743b..9de0305a5cce 100644
> --- a/drivers/net/can/usb/Makefile
> +++ b/drivers/net/can/usb/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_CAN_KVASER_USB) +=3D kvaser_usb/
>  obj-$(CONFIG_CAN_MCBA_USB) +=3D mcba_usb.o
>  obj-$(CONFIG_CAN_PEAK_USB) +=3D peak_usb/
>  obj-$(CONFIG_CAN_UCAN) +=3D ucan.o
> +obj-$(CONFIG_CAN_F81604) +=3D f81604.o

As Vincent said: Please sort the targets by alphabetical order, move the
entry in the Kconfig to the corresponding place.

> diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
> new file mode 100644
> index 000000000000..06cd5d95c44d
> --- /dev/null
> +++ b/drivers/net/can/usb/f81604.c
> @@ -0,0 +1,1232 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Fintek F81604 USB-to-2CAN controller driver.
> + *
> + * Copyright (C) 2023 Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> + */
> +#include <linux/netdevice.h>
> +#include <linux/usb.h>
> +#include <linux/bitfield.h>
> +#include <linux/units.h>
> +
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +#include <linux/can/error.h>
> +#include <linux/can/platform/sja1000.h>
> +
> +/* vendor and product id */
> +#define F81604_VENDOR_ID 0x2c42
> +#define F81604_PRODUCT_ID 0x1709
> +#define F81604_CAN_CLOCK (24 * MEGA / 2)
> +#define F81604_MAX_DEV 2
> +#define F81604_SET_DEVICE_RETRY 100
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
> +#define F81604_CMD_OFFSET 0x00
> +#define F81604_CMD_DATA 0x00
> +
> +#define F81604_DLC_LEN_MASK 0x0f
> +#define F81604_DLC_EFF_BIT BIT(7)
> +#define F81604_DLC_RTR_BIT BIT(6)
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

Please add the common prefix "F81604_" to these defines, too.

> +/* SJA1000 registers - manual section 6.4 (Pelican Mode) */
> +#define SJA1000_MOD 0x00
> +#define SJA1000_CMR 0x01
> +#define SJA1000_IR 0x03
> +#define SJA1000_IER 0x04
> +#define SJA1000_ALC 0x0B
> +#define SJA1000_ECC 0x0C
> +#define SJA1000_RXERR 0x0E
> +#define SJA1000_TXERR 0x0F
> +#define SJA1000_ACCC0 0x10
> +#define SJA1000_ACCC1 0x11
> +#define SJA1000_ACCC2 0x12
> +#define SJA1000_ACCC3 0x13
> +#define SJA1000_ACCM0 0x14
> +#define SJA1000_ACCM1 0x15
> +#define SJA1000_ACCM2 0x16
> +#define SJA1000_ACCM3 0x17
> +#define SJA1000_MAX_FILTER_CNT 4

If these are SJA1000 registers, bits, also add SJA1000 as prefix.

> +
> +/* Common registers - manual section 6.5 */
> +#define SJA1000_BTR0 0x06
> +#define SJA1000_BTR1 0x07
> +#define SJA1000_BTR1_SAMPLE_TRIPLE BIT(7)
> +#define SJA1000_OCR 0x08
> +#define SJA1000_CDR 0x1F
> +
> +/* mode register */
> +#define MOD_RM 0x01
> +#define MOD_LOM 0x02
> +#define MOD_STM 0x04
> +
> +/* commands */
> +#define CMD_CDO 0x08
> +
> +/* interrupt sources */
> +#define IRQ_BEI 0x80
> +#define IRQ_ALI 0x40
> +#define IRQ_EPI 0x20
> +#define IRQ_DOI 0x08
> +#define IRQ_EI 0x04
> +#define IRQ_TI 0x02
> +#define IRQ_RI 0x01
> +#define IRQ_ALL 0xFF
> +#define IRQ_OFF 0x00
> +
> +/* status register content */
> +#define SR_BS 0x80
> +#define SR_ES 0x40
> +#define SR_TS 0x20
> +#define SR_RS 0x10
> +#define SR_TCS 0x08
> +#define SR_TBS 0x04
> +#define SR_DOS 0x02
> +#define SR_RBS 0x01
> +
> +/* ECC register */
> +#define ECC_SEG 0x1F
> +#define ECC_DIR 0x20
> +#define ECC_BIT 0x00
> +#define ECC_FORM 0x40
> +#define ECC_STUFF 0x80
> +#define ECC_MASK 0xc0
> +
> +/* ALC register */
> +#define ALC_MASK 0x1f
> +
> +/* table of devices that work with this driver */
> +static const struct usb_device_id f81604_table[] =3D {
> +	{ USB_DEVICE(F81604_VENDOR_ID, F81604_PRODUCT_ID) },
> +	{} /* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, f81604_table);
> +
> +static const struct ethtool_ops f81604_ethtool_ops =3D {
> +	.get_ts_info =3D ethtool_op_get_ts_info,
> +};
> +
> +static const u16 f81604_termination[] =3D { F81604_TERMINATION_DISABLED,
> +					  F81604_TERMINATION_ENABLED };
> +
> +struct f81604_priv {
> +	struct net_device *netdev[F81604_MAX_DEV];
> +	struct mutex mutex; /* for terminator setting */
> +};
> +
> +struct f81604_port_priv {
> +	struct can_priv can;
> +	struct net_device *netdev;
> +	struct sk_buff *echo_skb;
> +
> +	/* For synchronize need_clear_alc/need_clear_ecc in worker & interrupt
> +	 * callback.
> +	 */
> +	spinlock_t lock;
> +	bool need_clear_alc;
> +	bool need_clear_ecc;

What about creating a u8 with 2 flags, use set_bit() and
test_and_clear_bit().

> +
> +	struct work_struct handle_clear_reg_work;
> +	struct work_struct handle_clear_overrun_work;

Can you combine both workers? Add a 3rd flag to the u8 you created
above.

> +
> +	struct usb_device *dev;
> +	struct usb_interface *intf;
> +
> +	struct urb *int_urb;
> +	u8 int_read_buffer[F81604_INT_SIZE];
> +
> +	struct urb *read_urb[F81604_MAX_RX_URBS];

Please use an struct usb_anchor for this.

> +	u8 bulk_read_buffer[F81604_MAX_RX_URBS][F81604_BULK_SIZE];

allocate the URB dynamic with kmalloc() and use urb->transfer_flags |=3D
URB_FREE_BUFFER for automatic free()ing.

> +
> +	struct urb *write_urb;
> +	u8 bulk_write_buffer[F81604_DATA_SIZE];

With just 1 TX URB the TX would be quite slow. Does your hardware
support more than 1 TX URB at a time? USB devices usually answer with
NAK it they are busy, automatic and transparent retry is handled by the
USB host controller.

> +
> +	u8 ocr;
> +	u8 cdr;

These are compile time constant, please remove.

> +};
> +
> +/* Interrupt endpoint data format: SR/IR/IER/ALC/ECC/EWLR/RXERR/TXERR/VA=
L */
> +struct f81604_int_data {
> +	u8 sr;
> +	u8 isrc;
> +	u8 ier;
> +	u8 alc;
> +	u8 ecc;
> +	u8 ewlr;
> +	u8 rxerr;
> +	u8 txerr;
> +	u8 val;
> +} __packed;

I think this struct is always aligned to 4 bytes, so add a __aligned(4)
behind __packed.
> +
> +struct f81604_sff {
> +	__be16 id;
> +	u8 data[CAN_MAX_DLEN];
> +} __packed;

__aligned(2)

> +
> +struct f81604_eff {
> +	__be32 id;
> +	u8 data[CAN_MAX_DLEN];
> +} __packed;

__aligned(2)

> +
> +struct f81604_bulk_data {
> +	u8 cmd;
> +
> +	/* According for F81604 DLC define:
> +	 *	#define F81604_DLC_LEN_MASK 0x0f
> +	 *	#define F81604_DLC_EFF_BIT BIT(7)
> +	 *	#define F81604_DLC_RTR_BIT BIT(6)

no need to duplicate code

> +	 */
> +	u8 dlc;
> +
> +	union {
> +		struct f81604_sff sff;
> +		struct f81604_eff eff;
> +	};
> +} __packed;

__aligned(4)

> +
> +static int f81604_set_register(struct usb_device *dev, u16 reg, u8 data)

What about renaming these to f81604_write(), f81604_read().

I would change the 1st argument to struct f81604_port_priv *priv.

> +{
> +	int ret;
> +
> +	ret =3D usb_control_msg_send(dev, 0, F81604_SET_GET_REGISTER,
> +				   USB_TYPE_VENDOR | USB_DIR_OUT, 0, reg,
> +				   &data, sizeof(data), F81604_USB_TIMEOUT,
> +				   GFP_KERNEL);
> +	if (ret)
> +		dev_err(&dev->dev, "%s: reg: %x data: %x failed: %pe\n",
> +			__func__, reg, data, ERR_PTR(ret));
> +
> +	return ret;
> +}
> +
> +static int f81604_get_register(struct usb_device *dev, u16 reg, u8 *data)
> +{
> +	int ret;
> +
> +	ret =3D usb_control_msg_recv(dev, 0, F81604_SET_GET_REGISTER,
> +				   USB_TYPE_VENDOR | USB_DIR_IN, 0, reg, data,
> +				   sizeof(*data), F81604_USB_TIMEOUT,
> +				   GFP_KERNEL);
> +
> +	if (ret < 0)
> +		dev_err(&dev->dev, "%s: reg: %x failed: %pe\n", __func__, reg,
> +			ERR_PTR(ret));
> +
> +	return ret;
> +}
> +
> +static int f81604_mask_set_register(struct usb_device *dev, u16 reg, u8 =
mask,
> +				    u8 data)

=2E..to f81604_update_bits().

> +{
> +	int status;
> +	u8 tmp;
> +
> +	status =3D f81604_get_register(dev, reg, &tmp);
> +	if (status)
> +		return status;
> +
> +	tmp &=3D ~mask;
> +	tmp |=3D (mask & data);
> +
> +	return f81604_set_register(dev, reg, tmp);
> +}
> +
> +static int f81604_set_sja1000_register(struct usb_device *dev, u8 port,
> +				       u16 reg, u8 data)

=2E..to f81604_sja1000_read(), f81604_sja1000_write().

Make the first argument struct f81604_port_priv *priv, too, then you
don't need to pass port.

> +{
> +	int real_reg;
> +
> +	real_reg =3D reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET;
> +	return f81604_set_register(dev, real_reg, data);
> +}
> +
> +static int f81604_get_sja1000_register(struct usb_device *dev, u8 port,
> +				       u16 reg, u8 *data)
> +{
> +	int real_reg;
> +
> +	real_reg =3D reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET;
> +	return f81604_get_register(dev, real_reg, data);
> +}
> +
> +static int f81604_set_reset_mode(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int status, i;
> +	u8 tmp;
> +
> +	/* disable interrupts */
> +	status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_IER, IRQ_OFF);
> +	if (status)
> +		return status;
> +
> +	for (i =3D 0; i < F81604_SET_DEVICE_RETRY; i++) {
> +		status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +						     SJA1000_MOD, &tmp);
> +		if (status)
> +			return status;
> +
> +		/* check reset bit */
> +		if (tmp & MOD_RM) {
> +			priv->can.state =3D CAN_STATE_STOPPED;
> +			return 0;
> +		}
> +
> +		/* reset chip */
> +		status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +						     SJA1000_MOD, MOD_RM);
> +		if (status)
> +			return status;
> +	}
> +
> +	return -EPERM;
> +}
> +
> +static int f81604_set_normal_mode(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	u8 mod_reg =3D 0x00;
> +	u8 tmp, ier =3D 0;
> +	int status, i;
> +
> +	for (i =3D 0; i < F81604_SET_DEVICE_RETRY; i++) {
> +		status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +						     SJA1000_MOD, &tmp);
> +		if (status)
> +			return status;
> +
> +		/* check reset bit */
> +		if ((tmp & MOD_RM) =3D=3D 0) {
> +			priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> +			/* enable interrupts, RI handled by bulk-in */
> +			ier =3D IRQ_ALL & ~IRQ_RI;
> +			if (!(priv->can.ctrlmode &
> +			      CAN_CTRLMODE_BERR_REPORTING))
> +				ier &=3D ~IRQ_BEI;
> +
> +			return f81604_set_sja1000_register(priv->dev,
> +							   netdev->dev_id,
> +							   SJA1000_IER, ier);
> +		}
> +
> +		/* set chip to normal mode */
> +		if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> +			mod_reg |=3D MOD_LOM;
> +		if (priv->can.ctrlmode & CAN_CTRLMODE_PRESUME_ACK)
> +			mod_reg |=3D MOD_STM;
> +
> +		status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +						     SJA1000_MOD, mod_reg);
> +		if (status)
> +			return status;
> +	}
> +
> +	return -EPERM;
> +}
> +
> +static int f81604_chipset_init(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int status;
> +	int i;
> +
> +	/* set clock divider and output control register */
> +	status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_CDR,
> +					     priv->cdr | CDR_PELICAN);
> +	if (status)
> +		return status;
> +
> +	/* set acceptance filter (accept all) */
> +	for (i =3D 0; i < SJA1000_MAX_FILTER_CNT; ++i) {
> +		status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +						     SJA1000_ACCC0 + i, 0);
> +		if (status)
> +			return status;
> +	}
> +
> +	for (i =3D 0; i < SJA1000_MAX_FILTER_CNT; ++i) {
> +		status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +						     SJA1000_ACCM0 + i, 0xFF);
> +		if (status)
> +			return status;
> +	}
> +
> +	return f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +					   SJA1000_OCR,
> +					   priv->ocr | OCR_MODE_NORMAL);
> +}
> +
> +static void f81604_unregister_urbs(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int i;
> +
> +	for (i =3D 0; i < F81604_MAX_RX_URBS; ++i)
> +		usb_kill_urb(priv->read_urb[i]);
> +
> +	usb_kill_urb(priv->write_urb);
> +	usb_kill_urb(priv->int_urb);
> +}
> +
> +static int f81604_register_urbs(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int status, i;
> +
> +	for (i =3D 0; i < F81604_MAX_RX_URBS; ++i) {
> +		status =3D usb_submit_urb(priv->read_urb[i], GFP_KERNEL);
> +		if (status) {
> +			netdev_warn(netdev, "%s: submit rx urb failed: %pe\n",
> +				    __func__, ERR_PTR(status));
> +			return status;
> +		}
> +	}
> +
> +	status =3D usb_submit_urb(priv->int_urb, GFP_KERNEL);
> +	if (status) {
> +		netdev_warn(netdev, "%s: submit int urb failed: %pe\n",
> +			    __func__, ERR_PTR(status));
> +		return status;
> +	}
> +
> +	return 0;
> +}
> +
> +static int f81604_start(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int status;
> +	u8 mode;
> +	u8 tmp;
> +
> +	f81604_unregister_urbs(netdev);
> +
> +	mode =3D F81604_RX_AUTO_RELEASE_BUF | F81604_INT_WHEN_CHANGE;
> +
> +	/* Set TR/AT mode */
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> +		mode |=3D F81604_TX_ONESHOT;
> +	else
> +		mode |=3D F81604_TX_NORMAL;
> +
> +	status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +					     F81604_CTRL_MODE_REG, mode);
> +	if (status)
> +		return status;
> +
> +	/* set reset mode */
> +	status =3D f81604_set_reset_mode(netdev);

I would make port_priv the first argument of all (internal) functions.

> +	if (status)
> +		return status;
> +
> +	status =3D f81604_chipset_init(netdev);
> +	if (status)
> +		return status;
> +
> +	/* Clear error counters and error code capture */
> +	status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_TXERR, 0);
> +	if (status)
> +		return status;
> +
> +	status =3D f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_RXERR, 0);
> +	if (status)
> +		return status;
> +
> +	/* Read clear for ECC/ALC/IR register */
> +	status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_ECC, &tmp);
> +	if (status)
> +		return status;
> +
> +	status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_ALC, &tmp);
> +	if (status)
> +		return status;
> +
> +	status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_IR, &tmp);
> +	if (status)
> +		return status;
> +
> +	status =3D f81604_register_urbs(netdev);
> +	if (status)
> +		return status;
> +
> +	return f81604_set_normal_mode(netdev);
> +}
> +
> +static int f81604_set_bittiming(struct net_device *dev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(dev);
> +	struct can_bittiming *bt =3D &priv->can.bittiming;
> +	int status =3D 0;
> +	u8 btr0, btr1;
> +
> +	btr0 =3D FIELD_PREP(GENMASK(5, 0), bt->brp - 1) |
> +	       FIELD_PREP(GENMASK(7, 6), bt->sjw - 1);
> +
> +	btr1 =3D FIELD_PREP(GENMASK(3, 0), bt->prop_seg + bt->phase_seg1 - 1) |
> +	       FIELD_PREP(GENMASK(6, 4), bt->phase_seg2 - 1);
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
> +		btr1 |=3D SJA1000_BTR1_SAMPLE_TRIPLE;
> +
> +	status =3D f81604_set_sja1000_register(priv->dev, dev->dev_id,
> +					     SJA1000_BTR0, btr0);
> +	if (status) {
> +		netdev_warn(dev, "%s: Set BTR0 failed: %pe\n", __func__,
> +			    ERR_PTR(status));
> +		return status;
> +	}
> +
> +	status =3D f81604_set_sja1000_register(priv->dev, dev->dev_id,
> +					     SJA1000_BTR1, btr1);
> +	if (status) {
> +		netdev_warn(dev, "%s: Set BTR1 failed: %pe\n", __func__,
> +			    ERR_PTR(status));
> +		return status;
> +	}
> +
> +	return 0;
> +}
> +
> +static int f81604_set_mode(struct net_device *netdev, enum can_mode mode)
> +{
> +	int err;
> +
> +	switch (mode) {
> +	case CAN_MODE_START:
> +		err =3D f81604_start(netdev);
> +		if (!err && netif_queue_stopped(netdev))
> +			netif_wake_queue(netdev);
> +		break;
> +
> +	default:
> +		err =3D -EOPNOTSUPP;
> +	}
> +
> +	return err;
> +}
> +
> +static void f81604_process_rx_packet(struct urb *urb)
> +{
> +	struct net_device *netdev =3D urb->context;
> +	struct net_device_stats *stats;
> +	struct f81604_bulk_data *ptr;
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +	int i, count;

both should be unsigned.

> +	u8 *data;
> +
> +	WARN_ON(sizeof(*ptr) !=3D F81604_DATA_SIZE);

WARN_ON is a runtime check and makes no sense on compile time constants.

> +
> +	data =3D urb->transfer_buffer;
> +	stats =3D &netdev->stats;
> +
> +	if (urb->actual_length % F81604_DATA_SIZE)
> +		netdev_warn(netdev, "actual_length %% %d !=3D 0 (%d)\n",
> +			    F81604_DATA_SIZE, urb->actual_length);

Please rephrase, so that the normal user understands the problem, e.g.
"URB length %u not multiple of %u".

> +	else if (!urb->actual_length)
> +		netdev_warn(netdev, "actual_length =3D 0 (%d)\n",
> +			    urb->actual_length);

same here.

> +
> +	count =3D urb->actual_length / F81604_DATA_SIZE;
> +
> +	for (i =3D 0; i < count; ++i) {
> +		ptr =3D (struct f81604_bulk_data *)&data[i * F81604_DATA_SIZE];
> +
> +		if (ptr->cmd !=3D F81604_CMD_DATA)
> +			continue;
> +
> +		skb =3D alloc_can_skb(netdev, &cf);
> +		if (!skb) {

stats->rx_dropped++;
Don't write to the log, in OOM situations, other parts of the kernel
usually will write something.

> +			netdev_warn(netdev, "%s: not enough memory", __func__);
> +			continue;
> +		}
> +
> +		cf->len =3D can_cc_dlc2len(ptr->dlc & F81604_DLC_LEN_MASK);

If you claim to support CAN_CTRLMODE_CC_LEN8_DLC:

		can_frame_set_cc_len((cf, dlc, priv->can.ctrlmode);

> +
> +		if (ptr->dlc & F81604_DLC_EFF_BIT) {
> +			cf->can_id =3D be32_to_cpu(ptr->eff.id) >> 3;
> +			cf->can_id |=3D CAN_EFF_FLAG;
> +		} else {
> +			cf->can_id =3D be16_to_cpu(ptr->sff.id) >> 5;
> +		}
> +
> +		if (ptr->dlc & F81604_DLC_RTR_BIT)
> +			cf->can_id |=3D CAN_RTR_FLAG;
> +		else if (ptr->dlc & F81604_DLC_EFF_BIT)
> +			memcpy(cf->data, ptr->eff.data, cf->len);
> +		else
> +			memcpy(cf->data, ptr->sff.data, cf->len);
> +
> +		if (!(cf->can_id & CAN_RTR_FLAG))
> +			stats->rx_bytes +=3D cf->len;
> +
> +		stats->rx_packets++;
> +		netif_rx(skb);
> +	}
> +}
> +
> +static void f81604_read_bulk_callback(struct urb *urb)
> +{
> +	struct net_device *netdev =3D urb->context;
> +	int status;
> +
> +	if (!netif_device_present(netdev))
> +		return;
> +
> +	if (urb->status)
> +		netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
> +			    ERR_PTR(urb->status));
> +
> +	switch (urb->status) {
> +	case 0: /* success */
> +		break;
> +
> +	case -ENOENT:
> +	case -EPIPE:
> +	case -EPROTO:
> +	case -ESHUTDOWN:
> +		return;
> +
> +	default:
> +		goto resubmit_urb;
> +	}
> +
> +	f81604_process_rx_packet(urb);
> +
> +resubmit_urb:
> +	status =3D usb_submit_urb(urb, GFP_ATOMIC);
> +	if (status =3D=3D -ENODEV)
> +		netif_device_detach(netdev);
> +	else if (status)
> +		netdev_err(netdev,
> +			   "%s: failed to resubmit read bulk urb: %pe\n",
> +			   __func__, ERR_PTR(status));
> +}
> +
> +static void f81604_write_bulk_callback(struct urb *urb)
> +{
> +	struct net_device *netdev =3D urb->context;
> +
> +	if (!netif_device_present(netdev))
> +		return;
> +
> +	if (urb->status)
> +		netdev_info(netdev, "%s: Tx URB error: %pe\n", __func__,
> +			    ERR_PTR(urb->status));
> +}
> +
> +static void f81604_handle_clear_overrun_work(struct work_struct *work)
> +{
> +	struct f81604_port_priv *priv;
> +	struct net_device *netdev;
> +
> +	priv =3D container_of(work, struct f81604_port_priv,
> +			    handle_clear_overrun_work);
> +	netdev =3D priv->netdev;
> +
> +	f81604_set_sja1000_register(priv->dev, netdev->dev_id, SJA1000_CMR,
> +				    CMD_CDO);
> +}
> +
> +static void f81604_handle_clear_reg_work(struct work_struct *work)
> +{
> +	struct f81604_port_priv *priv;
> +	struct net_device *netdev;
> +	bool clear_ecc, clear_alc;
> +	unsigned long flags;
> +	u8 tmp;
> +
> +	priv =3D container_of(work, struct f81604_port_priv,
> +			    handle_clear_reg_work);
> +	netdev =3D priv->netdev;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	clear_alc =3D priv->need_clear_alc;
> +	clear_ecc =3D priv->need_clear_ecc;
> +	priv->need_clear_alc =3D false;
> +	priv->need_clear_ecc =3D false;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	if (clear_alc)
> +		f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					    SJA1000_ALC, &tmp);
> +
> +	if (clear_ecc)
> +		f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					    SJA1000_ECC, &tmp);
> +}
> +
> +static void f81604_handle_tx(struct urb *urb)
> +{
> +	struct f81604_int_data *data =3D urb->transfer_buffer;
> +	struct net_device *netdev =3D urb->context;
> +	struct net_device_stats *stats;
> +	struct f81604_port_priv *priv;
> +
> +	priv =3D netdev_priv(netdev);
> +	stats =3D &netdev->stats;
> +
> +	if (!(data->isrc & IRQ_TI))
> +		return;
> +
> +	/* transmission buffer released */
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
> +	    !(data->sr & SR_TCS)) {
> +		stats->tx_errors++;
> +		can_free_echo_skb(netdev, 0, NULL);
> +	} else {
> +		/* transmission complete */
> +		stats->tx_bytes +=3D can_get_echo_skb(netdev, 0, NULL);
> +		stats->tx_packets++;
> +	}
> +
> +	netif_wake_queue(netdev);
> +}
> +
> +static void f81604_read_int_callback(struct urb *urb)
> +{
> +	struct f81604_int_data *data =3D urb->transfer_buffer;
> +	struct net_device *netdev =3D urb->context;
> +	struct net_device_stats *stats;
> +	struct f81604_port_priv *priv;
> +	enum can_state can_state;
> +	enum can_state rx_state;
> +	enum can_state tx_state;
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +	unsigned long flags;
> +	int r;
> +
> +	priv =3D netdev_priv(netdev);
> +	can_state =3D priv->can.state;
> +	stats =3D &netdev->stats;
> +
> +	if (!netif_device_present(netdev))
> +		return;
> +
> +	if (urb->status)
> +		netdev_info(netdev, "%s: Int URB aborted: %pe\n", __func__,
> +			    ERR_PTR(urb->status));
> +
> +	switch (urb->status) {
> +	case 0: /* success */
> +		break;
> +
> +	case -ENOENT:
> +	case -EPIPE:
> +	case -EPROTO:
> +	case -ESHUTDOWN:
> +		return;
> +
> +	default:
> +		goto resubmit_urb;
> +	}
> +
> +	/* Note: ALC/ECC will not auto clear by read here, must to clear by
                                                           ^^^^^^^^^^^^^
                                                           must be cleared
> +	 * read register (via handle_clear_reg_work).
> +	 */
> +
> +	/* handle can bus errors */
> +	if (data->isrc & (IRQ_DOI | IRQ_EI | IRQ_BEI | IRQ_EPI | IRQ_ALI)) {

Move this in a function....

> +		skb =3D alloc_can_err_skb(netdev, &cf);

Please continue the error handling, even in case of OOM.

> +		if (!skb) {
> +			netdev_warn(netdev,
> +				    "no memory to alloc_can_err_skb\n");
> +			goto resubmit_urb;
> +		}
> +
> +		cf->can_id |=3D CAN_ERR_CNT;
> +		cf->data[6] =3D data->txerr;
> +		cf->data[7] =3D data->rxerr;
> +
> +		if (data->isrc & IRQ_DOI) {
> +			/* data overrun interrupt */
> +			netdev_dbg(netdev, "data overrun interrupt\n");
> +			cf->can_id |=3D CAN_ERR_CRTL;
> +			cf->data[1] =3D CAN_ERR_CRTL_RX_OVERFLOW;
> +			stats->rx_over_errors++;
> +			stats->rx_errors++;
> +
> +			schedule_work(&priv->handle_clear_overrun_work);
> +		}
> +
> +		if (data->isrc & IRQ_EI) {
> +			/* error warning interrupt */
> +			netdev_dbg(netdev, "error warning interrupt\n");
> +
> +			if (data->sr & SR_BS)
> +				can_state =3D CAN_STATE_BUS_OFF;
> +			else if (data->sr & SR_ES)
> +				can_state =3D CAN_STATE_ERROR_WARNING;
> +			else
> +				can_state =3D CAN_STATE_ERROR_ACTIVE;
> +		}
> +
> +		if (data->isrc & IRQ_BEI) {
> +			/* bus error interrupt */
> +			netdev_dbg(netdev, "bus error interrupt\n");
> +
> +			priv->can.can_stats.bus_error++;
> +			stats->rx_errors++;
> +
> +			cf->can_id |=3D CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +
> +			/* set error type */
> +			switch (data->ecc & ECC_MASK) {
> +			case ECC_BIT:
> +				cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +				break;
> +			case ECC_FORM:
> +				cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +				break;
> +			case ECC_STUFF:
> +				cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> +				break;
> +			default:
> +				break;
> +			}
> +
> +			/* set error location */
> +			cf->data[3] =3D data->ecc & ECC_SEG;
> +
> +			/* Error occurred during transmission? */
> +			if ((data->ecc & ECC_DIR) =3D=3D 0)
> +				cf->data[2] |=3D CAN_ERR_PROT_TX;
> +
> +			spin_lock_irqsave(&priv->lock, flags);
> +			priv->need_clear_ecc =3D true;
> +			spin_unlock_irqrestore(&priv->lock, flags);
> +
> +			schedule_work(&priv->handle_clear_reg_work);
> +		}
> +
> +		if (data->isrc & IRQ_EPI) {
> +			if (can_state =3D=3D CAN_STATE_ERROR_PASSIVE)
> +				can_state =3D CAN_STATE_ERROR_WARNING;
> +			else
> +				can_state =3D CAN_STATE_ERROR_PASSIVE;
> +
> +			/* error passive interrupt */
> +			netdev_dbg(netdev, "error passive interrupt: %d\n",
> +				   can_state);
> +		}
> +
> +		if (data->isrc & IRQ_ALI) {
> +			/* arbitration lost interrupt */
> +			netdev_dbg(netdev, "arbitration lost interrupt\n");
> +
> +			priv->can.can_stats.arbitration_lost++;
> +			stats->tx_errors++;

Don't increase tx_errors, see bd0ccb92efb0 ("can: sja1000:
sja1000_err(): don't count arbitration lose as an error").

> +			cf->can_id |=3D CAN_ERR_LOSTARB;
> +			cf->data[0] =3D data->alc & ALC_MASK;
> +
> +			spin_lock_irqsave(&priv->lock, flags);
> +			priv->need_clear_alc =3D true;
> +			spin_unlock_irqrestore(&priv->lock, flags);
> +
> +			schedule_work(&priv->handle_clear_reg_work);

                        I'd move the schedule work call to the end of
                        this..:
                        if (priv->work_flags)
                                schedule_work()
> +		}
> +
> +		if (can_state !=3D priv->can.state) {
> +			tx_state =3D data->txerr >=3D data->rxerr ? can_state : 0;
> +			rx_state =3D data->txerr <=3D data->rxerr ? can_state : 0;
> +
> +			can_change_state(netdev, cf, tx_state, rx_state);
> +
> +			if (can_state =3D=3D CAN_STATE_BUS_OFF)
> +				can_bus_off(netdev);
> +		}
> +
> +		netif_rx(skb);
> +	}
> +
> +	/* handle TX */
> +	if (can_state !=3D CAN_STATE_BUS_OFF)

you might move the data->isrc & IRQ_TI check here

> +		f81604_handle_tx(urb);

I'd change the signature to struct f81604_port_priv *, struct f81604_int_da=
ta *data.

> +
> +resubmit_urb:
> +	r =3D usb_submit_urb(urb, GFP_ATOMIC);
> +	if (r) {
> +		netdev_err(netdev,
> +			   "%s: failed resubmitting int bulk urb: %pe\n",
> +			   __func__, ERR_PTR(r));
> +
> +		if (r =3D=3D -ENODEV)
> +			netif_device_detach(netdev);
> +	}
> +}
> +
> +static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
> +				     struct net_device *netdev)
> +{
> +	struct can_frame *cf =3D (struct can_frame *)skb->data;
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	struct net_device_stats *stats =3D &netdev->stats;
> +	struct f81604_bulk_data *ptr;
> +	int status, len;
> +
> +	if (can_dropped_invalid_skb(netdev, skb))
> +		return NETDEV_TX_OK;
> +
> +	netif_stop_queue(netdev);
> +
> +	WARN_ON(sizeof(*ptr) !=3D F81604_DATA_SIZE);

WARN_ON is a runtime check and makes no sense on compile time constants.

> +
> +	ptr =3D (struct f81604_bulk_data *)priv->bulk_write_buffer;
> +	memset(ptr, 0, F81604_DATA_SIZE);
> +
> +	len =3D can_get_cc_dlc(cf, priv->can.ctrlmode);

This functions returns the "dlc" not the len. dlc might be > 8.

> +	ptr->cmd =3D F81604_CMD_DATA;
> +	ptr->dlc =3D len;
> +
> +	if (cf->can_id & CAN_RTR_FLAG)
> +		ptr->dlc |=3D F81604_DLC_RTR_BIT;
> +
> +	if (cf->can_id & CAN_EFF_FLAG) {
> +		ptr->eff.id =3D cpu_to_be32((cf->can_id & CAN_EFF_MASK) << 3);
> +		ptr->dlc |=3D F81604_DLC_EFF_BIT;
> +
> +		if (!(cf->can_id & CAN_RTR_FLAG))
> +			memcpy(&ptr->eff.data, cf->data, len);

You must use cf->len instead of len here.

> +	} else {
> +		ptr->sff.id =3D cpu_to_be16((cf->can_id & CAN_SFF_MASK) << 5);
> +
> +		if (!(cf->can_id & CAN_RTR_FLAG))
> +			memcpy(&ptr->sff.data, cf->data, len);

You must use cf->len instead of len here.

> +	}
> +
> +	can_put_echo_skb(skb, netdev, 0, 0);
> +
> +	status =3D usb_submit_urb(priv->write_urb, GFP_ATOMIC);
> +	if (status) {
> +		netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %pe\n",
> +			   __func__, ERR_PTR(status));
> +
> +		can_free_echo_skb(netdev, 0, NULL);
> +		stats->tx_dropped++;
> +
> +		if (status =3D=3D -ENODEV)
> +			netif_device_detach(netdev);

In the else path you probably want to netif_wake_queue()?

> +	}
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static int f81604_get_berr_counter(const struct net_device *netdev,
> +				   struct can_berr_counter *bec)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int status;
> +	u8 txerr;
> +	u8 rxerr;
> +
> +	status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_TXERR, &txerr);
> +	if (status)
> +		return status;
> +
> +	status =3D f81604_get_sja1000_register(priv->dev, netdev->dev_id,
> +					     SJA1000_RXERR, &rxerr);
> +	if (status)
> +		return status;
> +
> +	bec->txerr =3D txerr;
> +	bec->rxerr =3D rxerr;
> +
> +	return 0;
> +}
> +
> +static void f81604_remove_urbs(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int i;
> +
> +	for (i =3D 0; i < F81604_MAX_RX_URBS; ++i)
> +		usb_free_urb(priv->read_urb[i]);

usb_kill_anchored_urbs()

> +
> +	usb_free_urb(priv->write_urb);
> +	usb_free_urb(priv->int_urb);
> +}
> +
> +static int f81604_prepare_urbs(struct net_device *netdev)
> +{
> +	static const u8 bulk_in_addr[F81604_MAX_DEV] =3D { 0x82, 0x84 };
> +	static const u8 bulk_out_addr[F81604_MAX_DEV] =3D { 0x01, 0x03 };
> +	static const u8 int_in_addr[F81604_MAX_DEV] =3D { 0x81, 0x83 };

Remove the 0x80 from the in endpoints, we need the proper endpoint
number here.

> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +	int id =3D netdev->dev_id;
> +	int i;
> +
> +	for (i =3D 0; i < F81604_MAX_RX_URBS; ++i) {
> +		priv->read_urb[i] =3D usb_alloc_urb(0, GFP_KERNEL);
> +		if (!priv->read_urb[i])
> +			goto error;
> +

                usb_anchor_urb()

> +		usb_fill_bulk_urb(priv->read_urb[i], priv->dev,
> +				  usb_rcvbulkpipe(priv->dev, bulk_in_addr[id]),
> +				  priv->bulk_read_buffer[i], F81604_BULK_SIZE,
> +				  f81604_read_bulk_callback, netdev);
> +	}
> +
> +	priv->write_urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +	if (!priv->write_urb)
> +		goto error;
> +
> +	usb_fill_bulk_urb(priv->write_urb, priv->dev,
> +			  usb_sndbulkpipe(priv->dev, bulk_out_addr[id]),
> +			  priv->bulk_write_buffer, F81604_DATA_SIZE,
> +			  f81604_write_bulk_callback, netdev);
> +
> +	priv->int_urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +	if (!priv->int_urb)
> +		goto error;
> +
> +	usb_fill_int_urb(priv->int_urb, priv->dev,
> +			 usb_rcvintpipe(priv->dev, int_in_addr[id]),
> +			 priv->int_read_buffer, F81604_INT_SIZE,
> +			 f81604_read_int_callback, netdev, 1);

Does the endpoint descriptor specify a proper interval?

> +
> +	return 0;
> +
> +error:
> +	f81604_remove_urbs(netdev);
> +	return -ENOMEM;
> +}
> +
> +/* Open USB device */
> +static int f81604_open(struct net_device *netdev)
> +{
> +	int err;
> +
> +	err =3D open_candev(netdev);
> +	if (err)
> +		return err;
> +
> +	err =3D f81604_start(netdev);
> +	if (err)
> +		goto start_failed;
> +
> +	netif_start_queue(netdev);
> +	return 0;
> +
> +start_failed:
> +	if (err =3D=3D -ENODEV)
> +		netif_device_detach(netdev);
> +
> +	close_candev(netdev);
> +
> +	return err;
> +}
> +
> +/* Close USB device */
> +static int f81604_close(struct net_device *netdev)
> +{
> +	struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +
> +	f81604_set_reset_mode(netdev);
> +
> +	netif_stop_queue(netdev);
> +	cancel_work_sync(&priv->handle_clear_overrun_work);
> +	cancel_work_sync(&priv->handle_clear_reg_work);
> +	close_candev(netdev);
> +
> +	f81604_unregister_urbs(netdev);
> +
> +	return 0;
> +}
> +
> +static const struct net_device_ops f81604_netdev_ops =3D {
> +	.ndo_open =3D f81604_open,
> +	.ndo_stop =3D f81604_close,
> +	.ndo_start_xmit =3D f81604_start_xmit,
> +	.ndo_change_mtu =3D can_change_mtu,
> +};
> +
> +static const struct can_bittiming_const f81604_bittiming_const =3D {
> +	.name =3D "f81604",
> +	.tseg1_min =3D 1,
> +	.tseg1_max =3D 16,
> +	.tseg2_min =3D 1,
> +	.tseg2_max =3D 8,
> +	.sjw_max =3D 4,
> +	.brp_min =3D 1,
> +	.brp_max =3D 64,
> +	.brp_inc =3D 1,
> +};
> +
> +/* Called by the usb core when driver is unloaded or device is removed */
> +static void f81604_disconnect(struct usb_interface *intf)
> +{
> +	struct f81604_priv *priv =3D usb_get_intfdata(intf);
> +	int i;
> +
> +	for (i =3D 0; i < F81604_MAX_DEV; ++i) {
                        ^^^^^^^^^^^^^^
                        ARRAY_SIZE(priv->netdev)

> +		if (!priv->netdev[i])
> +			continue;
> +
> +		unregister_netdev(priv->netdev[i]);
> +		f81604_remove_urbs(priv->netdev[i]);
> +		free_candev(priv->netdev[i]);
> +	}
> +}
> +
> +static int f81604_set_termination(struct net_device *netdev, u16 term)
> +{
> +	struct f81604_port_priv *port_priv =3D netdev_priv(netdev);
> +	struct f81604_priv *priv;
> +	u8 mask, data =3D 0;
> +	int r;
> +
> +	priv =3D usb_get_intfdata(port_priv->intf);
> +
> +	if (netdev->dev_id =3D=3D 0)
> +		mask =3D F81604_CAN0_TERM;
> +	else
> +		mask =3D F81604_CAN1_TERM;
> +
> +	if (term =3D=3D F81604_TERMINATION_ENABLED)
> +		data =3D mask;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	r =3D f81604_mask_set_register(port_priv->dev, F81604_TERMINATOR_REG,
> +				     mask, data);
> +
> +	mutex_unlock(&priv->mutex);
> +
> +	return r;
> +}
> +
> +static int f81604_probe(struct usb_interface *intf,
> +			const struct usb_device_id *id)
> +{
> +	struct usb_device *dev =3D interface_to_usbdev(intf);
> +	struct f81604_port_priv *port_priv;
> +	struct net_device *netdev;
> +	struct f81604_priv *priv;
> +	int i, err;
> +
> +	priv =3D devm_kzalloc(&intf->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	usb_set_intfdata(intf, priv);
> +
> +	for (i =3D 0; i < F81604_MAX_DEV; ++i) {
                        ^^^^^^^^^^^^^^^^^^
same here
> +		netdev =3D alloc_candev(sizeof(*port_priv), 1);
> +		if (!netdev) {
> +			dev_err(&intf->dev, "Couldn't alloc candev: %d\n", i);
> +			err =3D -ENOMEM;
> +
> +			goto failure_cleanup;
> +		}
> +
> +		port_priv =3D netdev_priv(netdev);
> +		netdev->dev_id =3D i;
> +
> +		mutex_init(&priv->mutex);
> +		spin_lock_init(&port_priv->lock);
> +
> +		INIT_WORK(&port_priv->handle_clear_overrun_work,
> +			  f81604_handle_clear_overrun_work);
> +		INIT_WORK(&port_priv->handle_clear_reg_work,
> +			  f81604_handle_clear_reg_work);
> +
> +		port_priv->intf =3D intf;
> +		port_priv->dev =3D dev;
> +		port_priv->ocr =3D OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL;
> +		port_priv->cdr =3D CDR_CBP;
> +		port_priv->can.state =3D CAN_STATE_STOPPED;

not need to assign

> +		port_priv->can.clock.freq =3D F81604_CAN_CLOCK;
> +
> +		port_priv->can.termination_const =3D f81604_termination;
> +		port_priv->can.termination_const_cnt =3D
> +			ARRAY_SIZE(f81604_termination);
> +		port_priv->can.bittiming_const =3D &f81604_bittiming_const;
> +		port_priv->can.do_set_bittiming =3D f81604_set_bittiming;
> +		port_priv->can.do_set_mode =3D f81604_set_mode;
> +		port_priv->can.do_set_termination =3D f81604_set_termination;
> +		port_priv->can.do_get_berr_counter =3D f81604_get_berr_counter;
> +		port_priv->can.ctrlmode_supported =3D
> +			CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
> +			CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
> +			CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_PRESUME_ACK;
> +
> +		netdev->ethtool_ops =3D &f81604_ethtool_ops;
> +		netdev->netdev_ops =3D &f81604_netdev_ops;
> +		netdev->flags |=3D IFF_ECHO;
> +
> +		SET_NETDEV_DEV(netdev, &intf->dev);
> +
> +		err =3D f81604_set_termination(netdev,
> +					     F81604_TERMINATION_DISABLED);
> +		if (err)
> +			goto clean_candev;
> +
> +		err =3D f81604_prepare_urbs(netdev);
> +		if (err)
> +			goto clean_candev;

In case of a failure, the driver leaks urb, as priv->netdev[i] is not
assigned.

> +
> +		err =3D register_candev(netdev);
> +		if (err)
> +			goto clean_candev;
> +
> +		port_priv->netdev =3D netdev;
> +		priv->netdev[i] =3D netdev;
> +
> +		dev_info(&intf->dev, "Channel #%d registered as %s\n", i,
> +			 netdev->name);
> +	}
> +
> +	return 0;
> +
> +clean_candev:
> +	netdev_err(netdev, "couldn't enable CAN device: %pe\n", ERR_PTR(err));
> +	free_candev(netdev);
> +
> +failure_cleanup:
> +	f81604_disconnect(intf);
> +	return err;
> +}
> +
> +static struct usb_driver f81604_driver =3D {
> +	.name =3D "f81604",
> +	.probe =3D f81604_probe,
> +	.disconnect =3D f81604_disconnect,
> +	.id_table =3D f81604_table,
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
>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pa3ryuyfedvb6l65
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQhsboACgkQvlAcSiqK
BOiOzAgAh5ZWhajtx748wJbfVoKi4DRCZXg7JsENhpBTRAHXkmWD08AEnW1z783n
DiXy1C7/inBF1Mlg3uQjTGOzFVIni+3vErmshqg8oDwh7mTEr0EXYUSw/E1OvbfE
JuwUJOfYzII1Eqcl5EcwxmKL204tiq1g0y0hGe1phMcFuOCzzinIsSOtL0oYXMJF
MXNnu7QsyL1NwNcU9p7vnvxTYnQm5YuIph7ypClok3UNT8EreDrdDNXvYnwhMLXW
Hg2h5/IMRxMS3SNNaYKBy9IukvMCkPbs8wPZvRAThWdsr47NJWxdNzglhhSfAPlA
2SQwwXDsJ8ZmnKxQi3hTPUVy0AE0gg==
=epbp
-----END PGP SIGNATURE-----

--pa3ryuyfedvb6l65--
