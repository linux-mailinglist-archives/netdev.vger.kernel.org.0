Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA04552B8B
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345131AbiFUHMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345845AbiFUHMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:12:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34A0220EE
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:12:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o3Y3a-0006RY-Ql; Tue, 21 Jun 2022 09:12:14 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-bd72-15a3-eb10-2206.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:bd72:15a3:eb10:2206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8CA3A9B3C9;
        Tue, 21 Jun 2022 07:11:52 +0000 (UTC)
Date:   Tue, 21 Jun 2022 09:11:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] can/esd_usb2: Added support for esd CAN-USB/3
Message-ID: <20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de>
References: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
 <20220620202603.2069841-2-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ui3xm5ockcxnl4z4"
Content-Disposition: inline
In-Reply-To: <20220620202603.2069841-2-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ui3xm5ockcxnl4z4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hallo Frank,

some comments inline. As said in my previous mail, please move the
formatting and renaming changes into a separate patch.

Can you create an entry in the MAINTAINERS file for the driver (separate
patch, too)?

On 20.06.2022 22:26:03, Frank Jungclaus wrote:
> This patch adds support for the newly available esd CAN-USB/3.
> ---
>  drivers/net/can/usb/esd_usb2.c | 647 ++++++++++++++++++++++++---------
>  1 file changed, 467 insertions(+), 180 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb=
2.c
> index 286daaaea0b8..062f3dd922d2 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -1,9 +1,11 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * CAN driver for esd CAN-USB/2 and CAN-USB/Micro
> + * CAN driver for esd CAN-USB/2, CAN-USB/3 and CAN-USB/Micro
>   *
> - * Copyright (C) 2010-2012 Matthias Fuchs <matthias.fuchs@esd.eu>, esd g=
mbh
> + * Copyright (C) 2010-     Matthias Fuchs                          , esd=
 gmbh
> + * Copyright (C) 2022-     Frank Jungclaus <frank.jungclaus@esd.eu>, esd=
 gmbh

The copyright with a starting year, a dash "-", and no end year looks
unfamiliar.

>   */
> +
>  #include <linux/signal.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> @@ -14,20 +16,25 @@
>  #include <linux/can/dev.h>
>  #include <linux/can/error.h>
> =20
> -MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd.eu>");
> -MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2 and CAN-USB/Micro inter=
faces");
> +MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
> +MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2, CAN-USB/3 and CAN-USB/=
Micro interfaces");
>  MODULE_LICENSE("GPL v2");

Why have you removed the former author?

> -/* Define these values to match your devices */
> +/* USB vendor and product ID */
>  #define USB_ESDGMBH_VENDOR_ID	0x0ab4
>  #define USB_CANUSB2_PRODUCT_ID	0x0010
>  #define USB_CANUSBM_PRODUCT_ID	0x0011
> +#define USB_CANUSB3_PRODUCT_ID	0x0014
> =20
> +/* CAN controller clock frequencies */
>  #define ESD_USB2_CAN_CLOCK	60000000
>  #define ESD_USBM_CAN_CLOCK	36000000
> -#define ESD_USB2_MAX_NETS	2
> +#define ESD_USB3_CAN_CLOCK	80000000
> +
> +/* Maximum number of CAN nets */
> +#define ESD_USB_MAX_NETS	2
> =20
> -/* USB2 commands */
> +/* USB commands */
>  #define CMD_VERSION		1 /* also used for VERSION_REPLY */
>  #define CMD_CAN_RX		2 /* device to host only */
>  #define CMD_CAN_TX		3 /* also used for TX_DONE */
> @@ -36,20 +43,29 @@ MODULE_LICENSE("GPL v2");
>  #define CMD_IDADD		6 /* also used for IDADD_REPLY */
> =20
>  /* esd CAN message flags - dlc field */
> -#define ESD_RTR			0x10
> +#define ESD_DLC_RTR		0x10
> +#define ESD_DLC_NO_BRS		0x10
> +#define ESD_DLC_ESI		0x20
> +#define ESD_DLC_FD		0x80
> +
> =20
>  /* esd CAN message flags - id field */
>  #define ESD_EXTID		0x20000000
>  #define ESD_EVENT		0x40000000
>  #define ESD_IDMASK		0x1fffffff
> =20
> -/* esd CAN event ids used by this driver */
> -#define ESD_EV_CAN_ERROR_EXT	2
> +/* esd CAN event ids */
> +#define ESD_EV_CAN_ERROR	0 /* General bus diagnostics data */
> +#define ESD_EV_BAUD_CHANGE	1 /* Bit rate change event (unused within thi=
s driver) */
> +#define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic dat=
a */
> +#define ESD_EV_BUSLOAD		3 /* Busload event (unused within this driver) */
> =20
> -/* baudrate message flags */
> +/* Baudrate message flags */
>  #define ESD_USB2_UBR		0x80000000
>  #define ESD_USB2_LOM		0x40000000
>  #define ESD_USB2_NO_BAUDRATE	0x7fffffff
> +
> +/* Bit timing CAN-USB/2 */
>  #define ESD_USB2_TSEG1_MIN	1
>  #define ESD_USB2_TSEG1_MAX	16
>  #define ESD_USB2_TSEG1_SHIFT	16
> @@ -64,6 +80,28 @@ MODULE_LICENSE("GPL v2");
>  #define ESD_USB2_BRP_INC	1
>  #define ESD_USB2_3_SAMPLES	0x00800000
> =20
> +/* Bit timing CAN-USB/3 */
> +#define ESD_USB3_TSEG1_MIN	1
> +#define ESD_USB3_TSEG1_MAX	256
> +#define ESD_USB3_TSEG2_MIN	1
> +#define ESD_USB3_TSEG2_MAX	128
> +#define ESD_USB3_SJW_MAX	128
> +#define ESD_USB3_BRP_MIN	1
> +#define ESD_USB3_BRP_MAX	1024
> +#define ESD_USB3_BRP_INC	1
> +/* Bit timing CAN-USB/3, data phase */
> +#define ESD_USB3_DATA_TSEG1_MIN	1
> +#define ESD_USB3_DATA_TSEG1_MAX	32
> +#define ESD_USB3_DATA_TSEG2_MIN	1
> +#define ESD_USB3_DATA_TSEG2_MAX	16
> +#define ESD_USB3_DATA_SJW_MAX	8
> +#define ESD_USB3_DATA_BRP_MIN	1
> +#define ESD_USB3_DATA_BRP_MAX	32
> +#define ESD_USB3_DATA_BRP_INC	1
> +
> +/* Transmitter Delay Compensation */
> +#define ESD_TDC_MODE_AUTO       0

Please do consistent indenting, here you use spaces not tabs.

> +
>  /* esd IDADD message */
>  #define ESD_ID_ENABLE		0x80
>  #define ESD_MAX_ID_SEGMENT	64
> @@ -78,15 +116,31 @@ MODULE_LICENSE("GPL v2");
>  #define SJA1000_ECC_MASK	0xc0
> =20
>  /* esd bus state event codes */
> -#define ESD_BUSSTATE_MASK	0xc0
> +#define ESD_BUSSTATE_OK         0x00
>  #define ESD_BUSSTATE_WARN	0x40
>  #define ESD_BUSSTATE_ERRPASSIVE	0x80
>  #define ESD_BUSSTATE_BUSOFF	0xc0
> +#define ESD_BUSSTATE_MASK	0xc0
> =20
>  #define RX_BUFFER_SIZE		1024
>  #define MAX_RX_URBS		4
>  #define MAX_TX_URBS		16 /* must be power of 2 */
> =20
> +/* Modes for NTCAN_BAUDRATE_X */
> +#define ESD_BAUDRATE_MODE_DISABLE          0      /* Remove from bus    =
    */
> +#define ESD_BAUDRATE_MODE_INDEX            1      /* ESD (CiA) bit rate =
idx */
> +#define ESD_BAUDRATE_MODE_BTR_CTRL         2      /* BTR values (Control=
ler)*/
> +#define ESD_BAUDRATE_MODE_BTR_CANONICAL    3      /* BTR values (Canonic=
al) */
> +#define ESD_BAUDRATE_MODE_NUM              4      /* Numerical bit rate =
    */
> +#define ESD_BAUDRATE_MODE_AUTOBAUD         5      /* Autobaud           =
    */
> +
> +/* Flags for NTCAN_BAUDRATE_X */
> +#define ESD_BAUDRATE_FLAG_FD     0x0001        /* Enable CAN FD Mode    =
    */
> +#define ESD_BAUDRATE_FLAG_LOM    0x0002        /* Enable Listen Only mod=
e   */
> +#define ESD_BAUDRATE_FLAG_STM    0x0004        /* Enable Self test mode =
    */
> +#define ESD_BAUDRATE_FLAG_TRS    0x0008        /* Enable Triple Sampling=
    */
> +#define ESD_BAUDRATE_FLAG_TXP    0x0010        /* Enable Transmit Pause =
    */
> +
>  struct header_msg {
>  	u8 len; /* len is always the total message length in 32bit words */
>  	u8 cmd;
> @@ -119,7 +173,10 @@ struct rx_msg {
>  	u8 dlc;
>  	__le32 ts;
>  	__le32 id; /* upper 3 bits contain flags */
> -	u8 data[8];
> +	union {
> +		u8 cc[8];  /* classic CAN */
> +		u8 fd[64]; /* CAN FD */
> +	} data;
>  };
> =20
>  struct tx_msg {
> @@ -127,9 +184,12 @@ struct tx_msg {
>  	u8 cmd;
>  	u8 net;
>  	u8 dlc;
> -	u32 hnd;	/* opaque handle, not used by device */
> +	u32 hnd;   /* opaque handle, not used by device */
>  	__le32 id; /* upper 3 bits contain flags */
> -	u8 data[8];
> +	union {
> +		u8 cc[8];  /* classic CAN */
> +		u8 fd[64]; /* CAN FD */
> +	} data;
>  };
> =20
>  struct tx_done_msg {
> @@ -149,16 +209,41 @@ struct id_filter_msg {
>  	__le32 mask[ESD_MAX_ID_SEGMENT + 1];
>  };
> =20
> +struct baudrate_x_cfg {
> +	__le16 brp;          /* Bit rate pre-scaler                   */
> +	__le16 tseg1;        /* TSEG1 register                        */
> +	__le16 tseg2;        /* TSEG2 register                        */
> +	__le16 sjw;          /* SJW register                          */
> +};
> +
> +struct tdc_cfg {
> +	u8 tdc_mode;    /* Transmitter Delay Compensation mode  */
> +	u8 ssp_offset;  /* Secondary Sample Point offset in mtq */
> +	s8 ssp_shift;   /* Secondary Sample Point shift in mtq  */
> +	u8 tdc_filter;  /* Transmitter Delay Compensation       */
> +};
> +
> +struct baudrate_x {

Nitpick: The tdc_cfg struct has a nice name, IMHO "baudrate_x" deserves
a nice name, too.

> +	__le16 mode;        /* Mode word                          */
> +	__le16 flags;       /* Control flags                      */
> +	struct tdc_cfg tdc; /* TDC configuration                  */
> +	struct baudrate_x_cfg arb;  /* Bit rate during arbitration phase  */
> +	struct baudrate_x_cfg data; /* Bit rate during data phase         */
> +};
> +
>  struct set_baudrate_msg {
>  	u8 len;
>  	u8 cmd;
>  	u8 net;
>  	u8 rsvd;
> -	__le32 baud;
> +	union {
> +		__le32 baud;
> +		struct baudrate_x baud_x;
> +	} u;

BTW: you can use an anonymous union here, remove the "u" the you can
access the members directly, e.g.:

struct set_baudrate_msg {
	u8 len;
	u8 cmd;
	u8 net;
	u8 rsvd;
	__le32 baud;
	union {
		__le32 baud;
		struct baudrate_x baud_x;
	};
};

struct set_baudrate_msg *foo;

foo->baud =3D 10;

>  };
> =20
>  /* Main message type used between library and application */
> -struct __attribute__ ((packed)) esd_usb2_msg {
> +struct __packed esd_usb_msg {
>  	union {
>  		struct header_msg hdr;
>  		struct version_msg version;
> @@ -171,23 +256,24 @@ struct __attribute__ ((packed)) esd_usb2_msg {
>  	} msg;
>  };
> =20
> -static struct usb_device_id esd_usb2_table[] =3D {
> +static struct usb_device_id esd_usb_table[] =3D {
>  	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
>  	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
> +	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB3_PRODUCT_ID)},
>  	{}
>  };
> -MODULE_DEVICE_TABLE(usb, esd_usb2_table);
> +MODULE_DEVICE_TABLE(usb, esd_usb_table);
> =20
> -struct esd_usb2_net_priv;
> +struct esd_usb_net_priv;
> =20
>  struct esd_tx_urb_context {
> -	struct esd_usb2_net_priv *priv;
> +	struct esd_usb_net_priv *priv;
>  	u32 echo_index;
>  };
> =20
> -struct esd_usb2 {
> +struct esd_usb {
>  	struct usb_device *udev;
> -	struct esd_usb2_net_priv *nets[ESD_USB2_MAX_NETS];
> +	struct esd_usb_net_priv *nets[ESD_USB_MAX_NETS];
> =20
>  	struct usb_anchor rx_submitted;
> =20
> @@ -198,36 +284,64 @@ struct esd_usb2 {
>  	dma_addr_t rxbuf_dma[MAX_RX_URBS];
>  };
> =20
> -struct esd_usb2_net_priv {
> +struct esd_usb_net_priv {
>  	struct can_priv can; /* must be the first member */
> =20
>  	atomic_t active_tx_jobs;
>  	struct usb_anchor tx_submitted;
>  	struct esd_tx_urb_context tx_contexts[MAX_TX_URBS];
> =20
> -	struct esd_usb2 *usb2;
> +	struct esd_usb *usb;
>  	struct net_device *netdev;
>  	int index;
>  	u8 old_state;
>  	struct can_berr_counter bec;
>  };
> =20
> -static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
> -			      struct esd_usb2_msg *msg)
> +static void esd_usb_rx_event(struct esd_usb_net_priv *priv, struct esd_u=
sb_msg *msg)
>  {
>  	struct net_device_stats *stats =3D &priv->netdev->stats;
>  	struct can_frame *cf;
>  	struct sk_buff *skb;
>  	u32 id =3D le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
> =20
> +#if defined(DEBUG)

please remove this debug code

> +	{
> +		static struct esd_usb_msg old_msg;
> +		static u32 rx_event_cnt;
> +
> +		msg->msg.rx.ts =3D 0;
> +		if (memcmp(msg, &old_msg, 16)) {
> +			netdev_info(priv->netdev,
> +				    "EVENT:%08d: id=3D%#02x dlc=3D%#02x %02x %02x %02x %02x - %02x %=
02x %02x %02x\n",
> +				    rx_event_cnt,
> +				    id,
> +				    msg->msg.rx.dlc,
> +				    msg->msg.rx.data.cc[0],
> +				    msg->msg.rx.data.cc[1],
> +				    msg->msg.rx.data.cc[2],
> +				    msg->msg.rx.data.cc[3],
> +				    msg->msg.rx.data.cc[4],
> +				    msg->msg.rx.data.cc[5],
> +				    msg->msg.rx.data.cc[6],
> +				    msg->msg.rx.data.cc[7]);
> +			memcpy(&old_msg, msg, 16);
> +		}
> +		rx_event_cnt++;
> +	}
> +#endif /* DEBUG */
> +
>  	if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
> -		u8 state =3D msg->msg.rx.data[0];
> -		u8 ecc =3D msg->msg.rx.data[1];
> -		u8 rxerr =3D msg->msg.rx.data[2];
> -		u8 txerr =3D msg->msg.rx.data[3];
> +		/* Here, for ESD_EV_CAN_ERROR_EXT we don't need
> +		 * any special treatment for EVMSG_X
> +		 */
> +		u8 state =3D msg->msg.rx.data.cc[0];
> +		u8 ecc	 =3D msg->msg.rx.data.cc[1];
> +		u8 rxerr =3D msg->msg.rx.data.cc[2];
> +		u8 txerr =3D msg->msg.rx.data.cc[3];

Can you add a new member to the union that allows easier decoding of the
error?

> =20
>  		skb =3D alloc_can_err_skb(priv->netdev, &cf);
> -		if (skb =3D=3D NULL) {
> +		if (!skb) {
>  			stats->rx_dropped++;
>  			return;
>  		}
> @@ -280,7 +394,7 @@ static void esd_usb2_rx_event(struct esd_usb2_net_pri=
v *priv,
>  				cf->data[2] |=3D CAN_ERR_PROT_TX;
> =20
>  			if (priv->can.state =3D=3D CAN_STATE_ERROR_WARNING ||
> -			    priv->can.state =3D=3D CAN_STATE_ERROR_PASSIVE) {
> +				priv->can.state =3D=3D CAN_STATE_ERROR_PASSIVE) {
>  				cf->data[1] =3D (txerr > rxerr) ?
>  					CAN_ERR_CRTL_TX_PASSIVE :
>  					CAN_ERR_CRTL_RX_PASSIVE;
> @@ -293,16 +407,40 @@ static void esd_usb2_rx_event(struct esd_usb2_net_p=
riv *priv,
>  		priv->bec.rxerr =3D rxerr;
> =20
>  		netif_rx(skb);
> +
> +	} else if (id =3D=3D ESD_EV_CAN_ERROR) {
> +		u8 state =3D msg->msg.rx.data.cc[1];
> +
> +		/* Switching back to Error Warn and back to Error Passive
> +		 * only is announced by means of a non-extended Error Event ...
> +		 */
> +		switch (state & ESD_BUSSTATE_MASK) {
> +		case ESD_BUSSTATE_OK:
> +			priv->old_state =3D state;
> +			priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> +			priv->bec.txerr =3D 0;
> +			priv->bec.rxerr =3D 0;
> +			break;
> +		case ESD_BUSSTATE_WARN:
> +			/* ... intentionally, don't set priv->old_state here! */
> +			priv->can.state =3D CAN_STATE_ERROR_WARNING;
> +			break;
> +		default:
> +			/* Do nothing ... */
> +			break;
> +		}
>  	}
>  }
> =20
> -static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
> -				struct esd_usb2_msg *msg)
> +static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv, struct esd=
_usb_msg *msg)
>  {
>  	struct net_device_stats *stats =3D &priv->netdev->stats;
> -	struct can_frame *cf;
> +	/* can.h:
> +	 *	  ... the struct can_frame and struct canfd_frame intentionally
> +	 *	      share the same layout ...
> +	 */

Please remove this comment.

> +	struct canfd_frame *cfd;
>  	struct sk_buff *skb;
> -	int i;
>  	u32 id;
> =20
>  	if (!netif_device_present(priv->netdev))
> @@ -311,39 +449,63 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net=
_priv *priv,
>  	id =3D le32_to_cpu(msg->msg.rx.id);
> =20
>  	if (id & ESD_EVENT) {
> -		esd_usb2_rx_event(priv, msg);
> +		esd_usb_rx_event(priv, msg);
>  	} else {
> -		skb =3D alloc_can_skb(priv->netdev, &cf);
> -		if (skb =3D=3D NULL) {
> -			stats->rx_dropped++;
> -			return;
> -		}
> =20
> -		cf->can_id =3D id & ESD_IDMASK;
> -		can_frame_set_cc_len(cf, msg->msg.rx.dlc & ~ESD_RTR,
> -				     priv->can.ctrlmode);
> +		if (msg->msg.rx.dlc & ESD_DLC_FD) {
> +			/* CAN FD */
> +			skb =3D alloc_canfd_skb(priv->netdev, &cfd);
> +			if (!skb) {
> +				stats->rx_dropped++;
> +				return;
> +			}
> =20
> -		if (id & ESD_EXTID)
> -			cf->can_id |=3D CAN_EFF_FLAG;
> +			/* Masking by 0x0F is already done within can_fd_dlc2len()! */
> +			cfd->len =3D can_fd_dlc2len(msg->msg.rx.dlc);
> +
> +			if ((msg->msg.rx.dlc & ESD_DLC_NO_BRS) =3D=3D 0)
> +				cfd->flags |=3D CANFD_BRS;
> +
> +			if (msg->msg.rx.dlc & ESD_DLC_ESI)
> +				cfd->flags |=3D CANFD_ESI;
> =20
> -		if (msg->msg.rx.dlc & ESD_RTR) {
> -			cf->can_id |=3D CAN_RTR_FLAG;
> +			memcpy(cfd->data, msg->msg.rx.data.fd, cfd->len);
> +			stats->rx_bytes +=3D cfd->len;
>  		} else {
> -			for (i =3D 0; i < cf->len; i++)
> -				cf->data[i] =3D msg->msg.rx.data[i];
> +			/* Classic CAN */
> +			skb =3D alloc_can_skb(priv->netdev, (struct can_frame **)&cfd);
> +			if (!skb) {
> +				stats->rx_dropped++;
> +				return;
> +			}
> =20
> -			stats->rx_bytes +=3D cf->len;
> +			can_frame_set_cc_len((struct can_frame *)cfd,
> +					     msg->msg.rx.dlc & 0x0F,
> +					     priv->can.ctrlmode);
> +
> +			if (msg->msg.rx.dlc & ESD_DLC_RTR) {
> +				/* No data copy for a RTR frame */
> +				cfd->can_id |=3D CAN_RTR_FLAG; // ok, due to memset(0)
> +							     // in alloc_can_skb()
> +			} else {
> +				memcpy(cfd->data, msg->msg.rx.data.cc, cfd->len);
> +				stats->rx_bytes +=3D cfd->len;
> +			}
>  		}
> -		stats->rx_packets++;
> =20
> +		/* Common part for CAN FD and CAN classic ... */
> +		cfd->can_id |=3D id & ESD_IDMASK;
> +
> +		if (id & ESD_EXTID)
> +			cfd->can_id |=3D CAN_EFF_FLAG;
> +
> +		stats->rx_packets++;
>  		netif_rx(skb);
>  	}
> =20
> -	return;
>  }
> =20
> -static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
> -				 struct esd_usb2_msg *msg)
> +static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv, struct es=
d_usb_msg *msg)
>  {
>  	struct net_device_stats *stats =3D &priv->netdev->stats;
>  	struct net_device *netdev =3D priv->netdev;
> @@ -356,8 +518,7 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_=
priv *priv,
> =20
>  	if (!msg->msg.txdone.status) {
>  		stats->tx_packets++;
> -		stats->tx_bytes +=3D can_get_echo_skb(netdev, context->echo_index,
> -						    NULL);
> +		stats->tx_bytes +=3D can_get_echo_skb(netdev, context->echo_index, NUL=
L);
>  	} else {
>  		stats->tx_errors++;
>  		can_free_echo_skb(netdev, context->echo_index, NULL);
> @@ -370,9 +531,9 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_=
priv *priv,
>  	netif_wake_queue(netdev);
>  }
> =20
> -static void esd_usb2_read_bulk_callback(struct urb *urb)
> +static void esd_usb_read_bulk_callback(struct urb *urb)
>  {
> -	struct esd_usb2 *dev =3D urb->context;
> +	struct esd_usb *dev =3D urb->context;
>  	int retval;
>  	int pos =3D 0;
>  	int i;
> @@ -394,9 +555,9 @@ static void esd_usb2_read_bulk_callback(struct urb *u=
rb)
>  	}
> =20
>  	while (pos < urb->actual_length) {
> -		struct esd_usb2_msg *msg;
> +		struct esd_usb_msg *msg;
> =20
> -		msg =3D (struct esd_usb2_msg *)(urb->transfer_buffer + pos);
> +		msg =3D (struct esd_usb_msg *)(urb->transfer_buffer + pos);
> =20
>  		switch (msg->msg.hdr.cmd) {
>  		case CMD_CAN_RX:
> @@ -405,7 +566,7 @@ static void esd_usb2_read_bulk_callback(struct urb *u=
rb)
>  				break;
>  			}
> =20
> -			esd_usb2_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
> +			esd_usb_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
>  			break;
> =20
>  		case CMD_CAN_TX:
> @@ -414,8 +575,7 @@ static void esd_usb2_read_bulk_callback(struct urb *u=
rb)
>  				break;
>  			}
> =20
> -			esd_usb2_tx_done_msg(dev->nets[msg->msg.txdone.net],
> -					     msg);
> +			esd_usb_tx_done_msg(dev->nets[msg->msg.txdone.net], msg);
>  			break;
>  		}
> =20
> @@ -429,8 +589,8 @@ static void esd_usb2_read_bulk_callback(struct urb *u=
rb)
> =20
>  resubmit_urb:
>  	usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 1),
> -			  urb->transfer_buffer, RX_BUFFER_SIZE,
> -			  esd_usb2_read_bulk_callback, dev);
> +			urb->transfer_buffer, RX_BUFFER_SIZE,
> +			esd_usb_read_bulk_callback, dev);
> =20
>  	retval =3D usb_submit_urb(urb, GFP_ATOMIC);
>  	if (retval =3D=3D -ENODEV) {
> @@ -443,18 +603,17 @@ static void esd_usb2_read_bulk_callback(struct urb =
*urb)
>  			"failed resubmitting read bulk urb: %d\n", retval);
>  	}
> =20
> -	return;
>  }
> =20
>  /*
>   * callback for bulk IN urb
>   */
> -static void esd_usb2_write_bulk_callback(struct urb *urb)
> +static void esd_usb_write_bulk_callback(struct urb *urb)
>  {
>  	struct esd_tx_urb_context *context =3D urb->context;
> -	struct esd_usb2_net_priv *priv;
> +	struct esd_usb_net_priv *priv;
>  	struct net_device *netdev;
> -	size_t size =3D sizeof(struct esd_usb2_msg);
> +	size_t size =3D sizeof(struct esd_usb_msg);
> =20
>  	WARN_ON(!context);
> =20
> @@ -478,7 +637,7 @@ static ssize_t firmware_show(struct device *d,
>  			     struct device_attribute *attr, char *buf)
>  {
>  	struct usb_interface *intf =3D to_usb_interface(d);
> -	struct esd_usb2 *dev =3D usb_get_intfdata(intf);
> +	struct esd_usb *dev =3D usb_get_intfdata(intf);
> =20
>  	return sprintf(buf, "%d.%d.%d\n",
>  		       (dev->version >> 12) & 0xf,
> @@ -491,7 +650,7 @@ static ssize_t hardware_show(struct device *d,
>  			     struct device_attribute *attr, char *buf)
>  {
>  	struct usb_interface *intf =3D to_usb_interface(d);
> -	struct esd_usb2 *dev =3D usb_get_intfdata(intf);
> +	struct esd_usb *dev =3D usb_get_intfdata(intf);
> =20
>  	return sprintf(buf, "%d.%d.%d\n",
>  		       (dev->version >> 28) & 0xf,
> @@ -504,13 +663,13 @@ static ssize_t nets_show(struct device *d,
>  			 struct device_attribute *attr, char *buf)
>  {
>  	struct usb_interface *intf =3D to_usb_interface(d);
> -	struct esd_usb2 *dev =3D usb_get_intfdata(intf);
> +	struct esd_usb *dev =3D usb_get_intfdata(intf);
> =20
>  	return sprintf(buf, "%d", dev->net_count);
>  }
>  static DEVICE_ATTR_RO(nets);
> =20
> -static int esd_usb2_send_msg(struct esd_usb2 *dev, struct esd_usb2_msg *=
msg)
> +static int esd_usb_send_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
>  {
>  	int actual_length;
> =20
> @@ -522,8 +681,7 @@ static int esd_usb2_send_msg(struct esd_usb2 *dev, st=
ruct esd_usb2_msg *msg)
>  			    1000);
>  }
> =20
> -static int esd_usb2_wait_msg(struct esd_usb2 *dev,
> -			     struct esd_usb2_msg *msg)
> +static int esd_usb_wait_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
>  {
>  	int actual_length;
> =20
> @@ -535,7 +693,7 @@ static int esd_usb2_wait_msg(struct esd_usb2 *dev,
>  			    1000);
>  }
> =20
> -static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
> +static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
>  {
>  	int i, err =3D 0;
> =20
> @@ -554,8 +712,7 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *de=
v)
>  			break;
>  		}
> =20
> -		buf =3D usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
> -					 &buf_dma);
> +		buf =3D usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL, &buf=
_dma);
>  		if (!buf) {
>  			dev_warn(dev->udev->dev.parent,
>  				 "No memory left for USB buffer\n");
> @@ -568,15 +725,14 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *=
dev)
>  		usb_fill_bulk_urb(urb, dev->udev,
>  				  usb_rcvbulkpipe(dev->udev, 1),
>  				  buf, RX_BUFFER_SIZE,
> -				  esd_usb2_read_bulk_callback, dev);
> +				  esd_usb_read_bulk_callback, dev);
>  		urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
>  		usb_anchor_urb(urb, &dev->rx_submitted);
> =20
>  		err =3D usb_submit_urb(urb, GFP_KERNEL);
>  		if (err) {
>  			usb_unanchor_urb(urb);
> -			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
> -					  urb->transfer_dma);
> +			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf, urb->transfer_dma);
>  			goto freeurb;
>  		}
> =20
> @@ -609,11 +765,11 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *=
dev)
>  /*
>   * Start interface
>   */
> -static int esd_usb2_start(struct esd_usb2_net_priv *priv)
> +static int esd_usb_start(struct esd_usb_net_priv *priv)
>  {
> -	struct esd_usb2 *dev =3D priv->usb2;
> +	struct esd_usb *dev =3D priv->usb;
>  	struct net_device *netdev =3D priv->netdev;
> -	struct esd_usb2_msg *msg;
> +	struct esd_usb_msg *msg;
>  	int err, i;
> =20
>  	msg =3D kmalloc(sizeof(*msg), GFP_KERNEL);
> @@ -624,7 +780,7 @@ static int esd_usb2_start(struct esd_usb2_net_priv *p=
riv)
> =20
>  	/*
>  	 * Enable all IDs
> -	 * The IDADD message takes up to 64 32 bit bitmasks (2048 bits).
> +	 * The IDADD message takes up to 64 32-bit bitmasks (2048 bits).
>  	 * Each bit represents one 11 bit CAN identifier. A set bit
>  	 * enables reception of the corresponding CAN identifier. A cleared
>  	 * bit disabled this identifier. An additional bitmask value
> @@ -641,14 +797,15 @@ static int esd_usb2_start(struct esd_usb2_net_priv =
*priv)
>  	msg->msg.filter.option =3D ESD_ID_ENABLE; /* start with segment 0 */
>  	for (i =3D 0; i < ESD_MAX_ID_SEGMENT; i++)
>  		msg->msg.filter.mask[i] =3D cpu_to_le32(0xffffffff);
> +
>  	/* enable 29bit extended IDs */
>  	msg->msg.filter.mask[ESD_MAX_ID_SEGMENT] =3D cpu_to_le32(0x00000001);
> =20
> -	err =3D esd_usb2_send_msg(dev, msg);
> +	err =3D esd_usb_send_msg(dev, msg);
>  	if (err)
>  		goto out;
> =20
> -	err =3D esd_usb2_setup_rx_urbs(dev);
> +	err =3D esd_usb_setup_rx_urbs(dev);
>  	if (err)
>  		goto out;
> =20
> @@ -664,16 +821,16 @@ static int esd_usb2_start(struct esd_usb2_net_priv =
*priv)
>  	return err;
>  }
> =20
> -static void unlink_all_urbs(struct esd_usb2 *dev)
> +static void unlink_all_urbs(struct esd_usb *dev)
>  {
> -	struct esd_usb2_net_priv *priv;
> +	struct esd_usb_net_priv *priv;
>  	int i, j;
> =20
>  	usb_kill_anchored_urbs(&dev->rx_submitted);
> =20
>  	for (i =3D 0; i < MAX_RX_URBS; ++i)
> -		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
> -				  dev->rxbuf[i], dev->rxbuf_dma[i]);
> +		usb_free_coherent(dev->udev, RX_BUFFER_SIZE, dev->rxbuf[i], dev->rxbuf=
_dma[i]);
> +
> =20
>  	for (i =3D 0; i < dev->net_count; i++) {
>  		priv =3D dev->nets[i];
> @@ -687,9 +844,9 @@ static void unlink_all_urbs(struct esd_usb2 *dev)
>  	}
>  }
> =20
> -static int esd_usb2_open(struct net_device *netdev)
> +static int esd_usb_open(struct net_device *netdev)
>  {
> -	struct esd_usb2_net_priv *priv =3D netdev_priv(netdev);
> +	struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
>  	int err;
> =20
>  	/* common open */
> @@ -698,7 +855,7 @@ static int esd_usb2_open(struct net_device *netdev)
>  		return err;
> =20
>  	/* finally start device */
> -	err =3D esd_usb2_start(priv);
> +	err =3D esd_usb_start(priv);
>  	if (err) {
>  		netdev_warn(netdev, "couldn't start device: %d\n", err);
>  		close_candev(netdev);
> @@ -710,20 +867,23 @@ static int esd_usb2_open(struct net_device *netdev)
>  	return 0;
>  }
> =20
> -static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
> -				      struct net_device *netdev)
> +static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb, struct net_de=
vice *netdev)
>  {
> -	struct esd_usb2_net_priv *priv =3D netdev_priv(netdev);
> -	struct esd_usb2 *dev =3D priv->usb2;
> +	struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
> +	struct esd_usb *dev =3D priv->usb;
>  	struct esd_tx_urb_context *context =3D NULL;
>  	struct net_device_stats *stats =3D &netdev->stats;
> -	struct can_frame *cf =3D (struct can_frame *)skb->data;
> -	struct esd_usb2_msg *msg;
> +	/* can.h:
> +	 *    ... the struct can_frame and struct canfd_frame intentionally
> +	 *	  share the same layout ...
> +	 */
> +	struct canfd_frame *cfd =3D (struct canfd_frame *)skb->data;
> +	struct esd_usb_msg *msg;
>  	struct urb *urb;
>  	u8 *buf;
>  	int i, err;
>  	int ret =3D NETDEV_TX_OK;
> -	size_t size =3D sizeof(struct esd_usb2_msg);
> +	size_t size =3D sizeof(struct esd_usb_msg);
> =20
>  	if (can_dropped_invalid_skb(netdev, skb))
>  		return NETDEV_TX_OK;
> @@ -736,8 +896,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff=
 *skb,
>  		goto nourbmem;
>  	}
> =20
> -	buf =3D usb_alloc_coherent(dev->udev, size, GFP_ATOMIC,
> -				 &urb->transfer_dma);
> +	buf =3D usb_alloc_coherent(dev->udev, size, GFP_ATOMIC, &urb->transfer_=
dma);
>  	if (!buf) {
>  		netdev_err(netdev, "No memory left for USB buffer\n");
>  		stats->tx_dropped++;
> @@ -745,24 +904,35 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_bu=
ff *skb,
>  		goto nobufmem;
>  	}
> =20
> -	msg =3D (struct esd_usb2_msg *)buf;
> +	msg =3D (struct esd_usb_msg *)buf;
> =20
>  	msg->msg.hdr.len =3D 3; /* minimal length */
>  	msg->msg.hdr.cmd =3D CMD_CAN_TX;
>  	msg->msg.tx.net =3D priv->index;
> -	msg->msg.tx.dlc =3D can_get_cc_dlc(cf, priv->can.ctrlmode);
> -	msg->msg.tx.id =3D cpu_to_le32(cf->can_id & CAN_ERR_MASK);
> =20
> -	if (cf->can_id & CAN_RTR_FLAG)
> -		msg->msg.tx.dlc |=3D ESD_RTR;
> +	if (can_is_canfd_skb(skb)) {
> +		/* CAN FD */
> +		msg->msg.tx.dlc =3D can_fd_len2dlc(cfd->len);
> +		msg->msg.tx.dlc |=3D ESD_DLC_FD;
> =20
> -	if (cf->can_id & CAN_EFF_FLAG)
> -		msg->msg.tx.id |=3D cpu_to_le32(ESD_EXTID);
> +		if ((cfd->flags & CANFD_BRS) =3D=3D 0)
> +			msg->msg.tx.dlc |=3D ESD_DLC_NO_BRS;
> +	} else {
> +		/* Classic CAN */
> +		msg->msg.tx.dlc =3D can_get_cc_dlc((struct can_frame *)cfd, priv->can.=
ctrlmode);
> +
> +		if (cfd->can_id & CAN_RTR_FLAG)
> +			msg->msg.tx.dlc |=3D ESD_DLC_RTR;
> +	}
> =20
> -	for (i =3D 0; i < cf->len; i++)
> -		msg->msg.tx.data[i] =3D cf->data[i];
> +	/* Common for classic CAN and CAN FD */
> +	msg->msg.hdr.len +=3D (cfd->len + 3) >> 2;
> =20
> -	msg->msg.hdr.len +=3D (cf->len + 3) >> 2;
> +	msg->msg.tx.id	=3D cpu_to_le32(cfd->can_id & CAN_ERR_MASK);
> +	if (cfd->can_id & CAN_EFF_FLAG)
> +		msg->msg.tx.id |=3D cpu_to_le32(ESD_EXTID);
> +
> +	memcpy(msg->msg.tx.data.fd, cfd->data, cfd->len);
> =20
>  	for (i =3D 0; i < MAX_TX_URBS; i++) {
>  		if (priv->tx_contexts[i].echo_index =3D=3D MAX_TX_URBS) {
> @@ -788,7 +958,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff=
 *skb,
> =20
>  	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
>  			  msg->msg.hdr.len << 2,
> -			  esd_usb2_write_bulk_callback, context);
> +			  esd_usb_write_bulk_callback, context);
> =20
>  	urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
> =20
> @@ -839,33 +1009,34 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_b=
uff *skb,
>  	return ret;
>  }
> =20
> -static int esd_usb2_close(struct net_device *netdev)
> +static int esd_usb_close(struct net_device *netdev)
>  {
> -	struct esd_usb2_net_priv *priv =3D netdev_priv(netdev);
> -	struct esd_usb2_msg *msg;
> +	struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
> +	struct esd_usb_msg *msg;
>  	int i;
> =20
>  	msg =3D kmalloc(sizeof(*msg), GFP_KERNEL);
>  	if (!msg)
>  		return -ENOMEM;
> =20
> -	/* Disable all IDs (see esd_usb2_start()) */
> +	/* Disable all IDs (see esd_usb_start()) */
>  	msg->msg.hdr.cmd =3D CMD_IDADD;
>  	msg->msg.hdr.len =3D 2 + ESD_MAX_ID_SEGMENT;
>  	msg->msg.filter.net =3D priv->index;
>  	msg->msg.filter.option =3D ESD_ID_ENABLE; /* start with segment 0 */
>  	for (i =3D 0; i <=3D ESD_MAX_ID_SEGMENT; i++)
>  		msg->msg.filter.mask[i] =3D 0;
> -	if (esd_usb2_send_msg(priv->usb2, msg) < 0)
> +	if (esd_usb_send_msg(priv->usb, msg) < 0)
>  		netdev_err(netdev, "sending idadd message failed\n");
> =20
> -	/* set CAN controller to reset mode */
> +	/* Set CAN controller to reset mode */
>  	msg->msg.hdr.len =3D 2;
>  	msg->msg.hdr.cmd =3D CMD_SETBAUD;
>  	msg->msg.setbaud.net =3D priv->index;
>  	msg->msg.setbaud.rsvd =3D 0;
> -	msg->msg.setbaud.baud =3D cpu_to_le32(ESD_USB2_NO_BAUDRATE);
> -	if (esd_usb2_send_msg(priv->usb2, msg) < 0)
> +	/* Sending ESD_USB2_NO_BAUDRATE is sufficient for CAN-USB/3, even in CA=
N FD mode, too */
> +	msg->msg.setbaud.u.baud =3D cpu_to_le32(ESD_USB2_NO_BAUDRATE);
> +	if (esd_usb_send_msg(priv->usb, msg) < 0)
>  		netdev_err(netdev, "sending setbaud message failed\n");
> =20
>  	priv->can.state =3D CAN_STATE_STOPPED;
> @@ -879,10 +1050,10 @@ static int esd_usb2_close(struct net_device *netde=
v)
>  	return 0;
>  }
> =20
> -static const struct net_device_ops esd_usb2_netdev_ops =3D {
> -	.ndo_open =3D esd_usb2_open,
> -	.ndo_stop =3D esd_usb2_close,
> -	.ndo_start_xmit =3D esd_usb2_start_xmit,
> +static const struct net_device_ops esd_usb_netdev_ops =3D {
> +	.ndo_open =3D esd_usb_open,
> +	.ndo_stop =3D esd_usb_close,
> +	.ndo_start_xmit =3D esd_usb_start_xmit,
>  	.ndo_change_mtu =3D can_change_mtu,
>  };
> =20
> @@ -898,11 +1069,35 @@ static const struct can_bittiming_const esd_usb2_b=
ittiming_const =3D {
>  	.brp_inc =3D ESD_USB2_BRP_INC,
>  };
> =20
> +static const struct can_bittiming_const esd_usb3_bittiming_const =3D {
> +	.name =3D "esd_usb3",
> +	.tseg1_min =3D ESD_USB3_TSEG1_MIN,
> +	.tseg1_max =3D ESD_USB3_TSEG1_MAX,
> +	.tseg2_min =3D ESD_USB3_TSEG2_MIN,
> +	.tseg2_max =3D ESD_USB3_TSEG2_MAX,
> +	.sjw_max =3D ESD_USB3_SJW_MAX,
> +	.brp_min =3D ESD_USB3_BRP_MIN,
> +	.brp_max =3D ESD_USB3_BRP_MAX,
> +	.brp_inc =3D ESD_USB3_BRP_INC,
> +};
> +
> +static const struct can_bittiming_const esd_usb3_data_bittiming_const =
=3D {
> +	.name =3D "esd_usb3",
> +	.tseg1_min =3D ESD_USB3_DATA_TSEG1_MIN,
> +	.tseg1_max =3D ESD_USB3_DATA_TSEG1_MAX,
> +	.tseg2_min =3D ESD_USB3_DATA_TSEG2_MIN,
> +	.tseg2_max =3D ESD_USB3_DATA_TSEG2_MAX,
> +	.sjw_max =3D ESD_USB3_DATA_SJW_MAX,
> +	.brp_min =3D ESD_USB3_DATA_BRP_MIN,
> +	.brp_max =3D ESD_USB3_DATA_BRP_MAX,
> +	.brp_inc =3D ESD_USB3_DATA_BRP_INC,
> +};
> +
>  static int esd_usb2_set_bittiming(struct net_device *netdev)
>  {
> -	struct esd_usb2_net_priv *priv =3D netdev_priv(netdev);
> +	struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
>  	struct can_bittiming *bt =3D &priv->can.bittiming;
> -	struct esd_usb2_msg *msg;
> +	struct esd_usb_msg *msg;
>  	int err;
>  	u32 canbtr;
>  	int sjw_shift;
> @@ -913,19 +1108,15 @@ static int esd_usb2_set_bittiming(struct net_devic=
e *netdev)
> =20
>  	canbtr |=3D (bt->brp - 1) & (ESD_USB2_BRP_MAX - 1);
> =20
> -	if (le16_to_cpu(priv->usb2->udev->descriptor.idProduct) =3D=3D
> -	    USB_CANUSBM_PRODUCT_ID)
> +	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) =3D=3D USB_CANUS=
BM_PRODUCT_ID)
>  		sjw_shift =3D ESD_USBM_SJW_SHIFT;
>  	else
>  		sjw_shift =3D ESD_USB2_SJW_SHIFT;
> =20
> -	canbtr |=3D ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1))
> -		<< sjw_shift;
> -	canbtr |=3D ((bt->prop_seg + bt->phase_seg1 - 1)
> -		   & (ESD_USB2_TSEG1_MAX - 1))
> +	canbtr |=3D ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1)) << sjw_shift;
> +	canbtr |=3D ((bt->prop_seg + bt->phase_seg1 - 1) & (ESD_USB2_TSEG1_MAX =
- 1))
>  		<< ESD_USB2_TSEG1_SHIFT;
> -	canbtr |=3D ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1))
> -		<< ESD_USB2_TSEG2_SHIFT;
> +	canbtr |=3D ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1)) << ESD_US=
B2_TSEG2_SHIFT;
>  	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
>  		canbtr |=3D ESD_USB2_3_SAMPLES;
> =20
> @@ -937,20 +1128,97 @@ static int esd_usb2_set_bittiming(struct net_devic=
e *netdev)
>  	msg->msg.hdr.cmd =3D CMD_SETBAUD;
>  	msg->msg.setbaud.net =3D priv->index;
>  	msg->msg.setbaud.rsvd =3D 0;
> -	msg->msg.setbaud.baud =3D cpu_to_le32(canbtr);
> +	msg->msg.setbaud.u.baud =3D cpu_to_le32(canbtr);
> =20
>  	netdev_info(netdev, "setting BTR=3D%#x\n", canbtr);
> =20
> -	err =3D esd_usb2_send_msg(priv->usb2, msg);
> +	err =3D esd_usb_send_msg(priv->usb, msg);
> +
> +	kfree(msg);
> +	return err;
> +}
> +
> +static int esd_usb3_set_bittiming(struct net_device *netdev)
> +{
> +	struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
> +	struct can_bittiming *bt   =3D &priv->can.bittiming;
> +	struct can_bittiming *d_bt =3D &priv->can.data_bittiming;
> +	struct esd_usb_msg *msg;
> +	int err;
> +	u16 mode;
> +	u16 flags =3D 0;
> +	u16 brp, tseg1, tseg2, sjw;
> +	u16 d_brp, d_tseg1, d_tseg2, d_sjw;
> +
> +	msg =3D kmalloc(sizeof(*msg), GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	/* Canonical is the most reasonable mode for SocketCAN on CAN-USB/3 ...=
 */
> +	mode =3D ESD_BAUDRATE_MODE_BTR_CANONICAL;
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> +		flags |=3D ESD_BAUDRATE_FLAG_LOM;
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
> +		flags |=3D ESD_BAUDRATE_FLAG_TRS;
> +
> +	brp =3D bt->brp & (ESD_USB3_BRP_MAX - 1);
> +	sjw =3D bt->sjw & (ESD_USB3_SJW_MAX - 1);
> +	tseg1 =3D (bt->prop_seg + bt->phase_seg1) & (ESD_USB3_TSEG1_MAX - 1);
> +	tseg2 =3D bt->phase_seg2 & (ESD_USB3_TSEG2_MAX - 1);
> +
> +	msg->msg.setbaud.u.baud_x.arb.brp   =3D cpu_to_le16(brp);
> +	msg->msg.setbaud.u.baud_x.arb.sjw   =3D cpu_to_le16(sjw);
> +	msg->msg.setbaud.u.baud_x.arb.tseg1 =3D cpu_to_le16(tseg1);
> +	msg->msg.setbaud.u.baud_x.arb.tseg2 =3D cpu_to_le16(tseg2);
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +		d_brp =3D d_bt->brp & (ESD_USB3_DATA_BRP_MAX - 1);
> +		d_sjw =3D d_bt->sjw & (ESD_USB3_DATA_SJW_MAX - 1);
> +		d_tseg1 =3D (d_bt->prop_seg + d_bt->phase_seg1) & (ESD_USB3_DATA_TSEG1=
_MAX - 1);
> +		d_tseg2 =3D d_bt->phase_seg2 & (ESD_USB3_DATA_TSEG2_MAX - 1);
> +		flags |=3D ESD_BAUDRATE_FLAG_FD;
> +	} else {
> +		d_brp   =3D 0;
> +		d_sjw   =3D 0;
> +		d_tseg1 =3D 0;
> +		d_tseg2 =3D 0;
> +	}
> +
> +	msg->msg.setbaud.u.baud_x.data.brp   =3D cpu_to_le16(d_brp);
> +	msg->msg.setbaud.u.baud_x.data.sjw   =3D cpu_to_le16(d_sjw);
> +	msg->msg.setbaud.u.baud_x.data.tseg1 =3D cpu_to_le16(d_tseg1);
> +	msg->msg.setbaud.u.baud_x.data.tseg2 =3D cpu_to_le16(d_tseg2);
> +	msg->msg.setbaud.u.baud_x.mode	     =3D cpu_to_le16(mode);
> +	msg->msg.setbaud.u.baud_x.flags	     =3D cpu_to_le16(flags);
> +	msg->msg.setbaud.u.baud_x.tdc.tdc_mode   =3D ESD_TDC_MODE_AUTO;
> +	msg->msg.setbaud.u.baud_x.tdc.ssp_offset =3D 0;
> +	msg->msg.setbaud.u.baud_x.tdc.ssp_shift  =3D 0;
> +	msg->msg.setbaud.u.baud_x.tdc.tdc_filter =3D 0;
> +
> +	msg->msg.hdr.len =3D 7;
> +	msg->msg.hdr.cmd =3D CMD_SETBAUD;
> +
> +	msg->msg.setbaud.net =3D priv->index;
> +	msg->msg.setbaud.rsvd =3D 0;
> +
> +	netdev_info(netdev,
> +		    "ctrlmode:{ is:%#x, spprted:%#x },  esd-net:%u, esd-mode:%#x, esd-=
flg:%#x, arb:{ brp:%u, ts1:%u, ts2:%u, sjw:%u }, data:{ dbrp:%u, dts1:%u, d=
ts2:%u dsjw:%u }\n",
> +		    priv->can.ctrlmode, priv->can.ctrlmode_supported,
> +		    priv->index, mode, flags,
> +		    brp, tseg1, tseg2, sjw,
> +		    d_brp, d_tseg1, d_tseg2, d_sjw);

Please remove it make it a netdev_debug()

> +
> +	err =3D esd_usb_send_msg(priv->usb, msg);
> =20
>  	kfree(msg);
>  	return err;
>  }
> =20
> -static int esd_usb2_get_berr_counter(const struct net_device *netdev,
> -				     struct can_berr_counter *bec)
> +static int esd_usb_get_berr_counter(const struct net_device *netdev, str=
uct can_berr_counter *bec)
>  {
> -	struct esd_usb2_net_priv *priv =3D netdev_priv(netdev);
> +	struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
> =20
>  	bec->txerr =3D priv->bec.txerr;
>  	bec->rxerr =3D priv->bec.rxerr;
> @@ -958,7 +1226,7 @@ static int esd_usb2_get_berr_counter(const struct ne=
t_device *netdev,
>  	return 0;
>  }
> =20
> -static int esd_usb2_set_mode(struct net_device *netdev, enum can_mode mo=
de)
> +static int esd_usb_set_mode(struct net_device *netdev, enum can_mode mod=
e)
>  {
>  	switch (mode) {
>  	case CAN_MODE_START:
> @@ -972,11 +1240,11 @@ static int esd_usb2_set_mode(struct net_device *ne=
tdev, enum can_mode mode)
>  	return 0;
>  }
> =20
> -static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
> +static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
>  {
> -	struct esd_usb2 *dev =3D usb_get_intfdata(intf);
> +	struct esd_usb *dev =3D usb_get_intfdata(intf);
>  	struct net_device *netdev;
> -	struct esd_usb2_net_priv *priv;
> +	struct esd_usb_net_priv *priv;
>  	int err =3D 0;
>  	int i;
> =20
> @@ -995,30 +1263,45 @@ static int esd_usb2_probe_one_net(struct usb_inter=
face *intf, int index)
>  	for (i =3D 0; i < MAX_TX_URBS; i++)
>  		priv->tx_contexts[i].echo_index =3D MAX_TX_URBS;
> =20
> -	priv->usb2 =3D dev;
> +	priv->usb =3D dev;
>  	priv->netdev =3D netdev;
>  	priv->index =3D index;
> =20
>  	priv->can.state =3D CAN_STATE_STOPPED;
> -	priv->can.ctrlmode_supported =3D CAN_CTRLMODE_LISTENONLY |
> -		CAN_CTRLMODE_CC_LEN8_DLC;
> +	priv->can.ctrlmode_supported =3D CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE=
_CC_LEN8_DLC;
> +
> +	switch (le16_to_cpu(dev->udev->descriptor.idProduct)) {
> +	case USB_CANUSB3_PRODUCT_ID:
> +		priv->can.clock.freq =3D ESD_USB3_CAN_CLOCK;
> +		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_3_SAMPLES;
> +		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
> +		priv->can.bittiming_const =3D &esd_usb3_bittiming_const;
> +		priv->can.data_bittiming_const =3D &esd_usb3_data_bittiming_const;
> +		priv->can.do_set_bittiming =3D esd_usb3_set_bittiming;
> +		priv->can.do_set_data_bittiming =3D esd_usb3_set_bittiming;
> +		break;
> =20
> -	if (le16_to_cpu(dev->udev->descriptor.idProduct) =3D=3D
> -	    USB_CANUSBM_PRODUCT_ID)
> +	case USB_CANUSBM_PRODUCT_ID:
>  		priv->can.clock.freq =3D ESD_USBM_CAN_CLOCK;
> -	else {
> +		priv->can.bittiming_const =3D &esd_usb2_bittiming_const;
> +		priv->can.do_set_bittiming =3D esd_usb2_set_bittiming;
> +		break;
> +
> +	case USB_CANUSB2_PRODUCT_ID:
> +	default:
>  		priv->can.clock.freq =3D ESD_USB2_CAN_CLOCK;
>  		priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_3_SAMPLES;
> +		priv->can.bittiming_const =3D &esd_usb2_bittiming_const;
> +		priv->can.do_set_bittiming =3D esd_usb2_set_bittiming;
> +		break;
>  	}
> =20
> -	priv->can.bittiming_const =3D &esd_usb2_bittiming_const;
> -	priv->can.do_set_bittiming =3D esd_usb2_set_bittiming;
> -	priv->can.do_set_mode =3D esd_usb2_set_mode;
> -	priv->can.do_get_berr_counter =3D esd_usb2_get_berr_counter;
> +	priv->can.do_set_mode =3D esd_usb_set_mode;
> +	priv->can.do_get_berr_counter =3D esd_usb_get_berr_counter;
> =20
>  	netdev->flags |=3D IFF_ECHO; /* we support local echo */
> =20
> -	netdev->netdev_ops =3D &esd_usb2_netdev_ops;
> +	netdev->netdev_ops =3D &esd_usb_netdev_ops;
> =20
>  	SET_NETDEV_DEV(netdev, &intf->dev);
>  	netdev->dev_id =3D index;
> @@ -1044,11 +1327,10 @@ static int esd_usb2_probe_one_net(struct usb_inte=
rface *intf, int index)
>   * check version information and number of available
>   * CAN interfaces
>   */
> -static int esd_usb2_probe(struct usb_interface *intf,
> -			 const struct usb_device_id *id)
> +static int esd_usb_probe(struct usb_interface *intf, const struct usb_de=
vice_id *id)
>  {
> -	struct esd_usb2 *dev;
> -	struct esd_usb2_msg *msg;
> +	struct esd_usb *dev;
> +	struct esd_usb_msg *msg;
>  	int i, err;
> =20
>  	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> @@ -1076,13 +1358,13 @@ static int esd_usb2_probe(struct usb_interface *i=
ntf,
>  	msg->msg.version.flags =3D 0;
>  	msg->msg.version.drv_version =3D 0;
> =20
> -	err =3D esd_usb2_send_msg(dev, msg);
> +	err =3D esd_usb_send_msg(dev, msg);
>  	if (err < 0) {
>  		dev_err(&intf->dev, "sending version message failed\n");
>  		goto free_msg;
>  	}
> =20
> -	err =3D esd_usb2_wait_msg(dev, msg);
> +	err =3D esd_usb_wait_msg(dev, msg);
>  	if (err < 0) {
>  		dev_err(&intf->dev, "no version message answer\n");
>  		goto free_msg;
> @@ -1091,21 +1373,26 @@ static int esd_usb2_probe(struct usb_interface *i=
ntf,
>  	dev->net_count =3D (int)msg->msg.version_reply.nets;
>  	dev->version =3D le32_to_cpu(msg->msg.version_reply.version);
> =20
> +	dev_info(&intf->dev, "version:{ hw:%d.%d.%d fw:%d.%d.%d }\n",
> +		 (dev->version >> 28) & 0xf,
> +		 (dev->version >> 24) & 0xf,
> +		 (dev->version >> 16) & 0xff,
> +		 (dev->version >> 12) & 0xf,
> +		 (dev->version >>  8) & 0xf,
> +		 (dev->version)       & 0xff);
> +
>  	if (device_create_file(&intf->dev, &dev_attr_firmware))
> -		dev_err(&intf->dev,
> -			"Couldn't create device file for firmware\n");
> +		dev_err(&intf->dev, "Couldn't create device file for firmware\n");
> =20
>  	if (device_create_file(&intf->dev, &dev_attr_hardware))
> -		dev_err(&intf->dev,
> -			"Couldn't create device file for hardware\n");
> +		dev_err(&intf->dev, "Couldn't create device file for hardware\n");
> =20
>  	if (device_create_file(&intf->dev, &dev_attr_nets))
> -		dev_err(&intf->dev,
> -			"Couldn't create device file for nets\n");
> +		dev_err(&intf->dev, "Couldn't create device file for nets\n");
> =20
>  	/* do per device probing */
>  	for (i =3D 0; i < dev->net_count; i++)
> -		esd_usb2_probe_one_net(intf, i);
> +		esd_usb_probe_one_net(intf, i);
> =20
>  free_msg:
>  	kfree(msg);
> @@ -1118,9 +1405,9 @@ static int esd_usb2_probe(struct usb_interface *int=
f,
>  /*
>   * called by the usb core when the device is removed from the system
>   */
> -static void esd_usb2_disconnect(struct usb_interface *intf)
> +static void esd_usb_disconnect(struct usb_interface *intf)
>  {
> -	struct esd_usb2 *dev =3D usb_get_intfdata(intf);
> +	struct esd_usb *dev =3D usb_get_intfdata(intf);
>  	struct net_device *netdev;
>  	int i;
> =20
> @@ -1144,11 +1431,11 @@ static void esd_usb2_disconnect(struct usb_interf=
ace *intf)
>  }
> =20
>  /* usb specific object needed to register this driver with the usb subsy=
stem */
> -static struct usb_driver esd_usb2_driver =3D {
> -	.name =3D "esd_usb2",
> -	.probe =3D esd_usb2_probe,
> -	.disconnect =3D esd_usb2_disconnect,
> -	.id_table =3D esd_usb2_table,
> +static struct usb_driver esd_usb_driver =3D {
> +	.name =3D "esd_usb",
> +	.probe =3D esd_usb_probe,
> +	.disconnect =3D esd_usb_disconnect,
> +	.id_table =3D esd_usb_table,
>  };
> =20
> -module_usb_driver(esd_usb2_driver);
> +module_usb_driver(esd_usb_driver);

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ui3xm5ockcxnl4z4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKxbzUACgkQrX5LkNig
010ZEwf7BDdZKG4cyHeszFxDEZ2ZXrfjejdhF/AvkypVg7BY01HdKr7cyAI9R43z
6qrVBwfnpHJld07os6CcGVzCJ6rhgZHh+uLZfU1iK+K6FwBpm9xUADGqZEsyD0+n
SL+TRFd4zGbVOpRrKSGEOdaLI2WmIPLvhL54QIYwcTn8foZKnITzKy3oOLkyflxR
3dBVPDuej9sdXyH9Ohs3ON6K5sP6KPn/JaNgDLqpCvZ4l4qS660CdcED9AekAvaU
pkjkb4SBXudKyhkK2gRdoxF6AwYCE2yngivaS8Fv1XIc6qWcWohDhfjrkpNNvSLy
5v3RafNYGSgXS3xuMRhbikkVszMuLg==
=SiJY
-----END PGP SIGNATURE-----

--ui3xm5ockcxnl4z4--
