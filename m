Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EDB295D1F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896919AbgJVLCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:02:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41976 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502976AbgJVLCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:02:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5B1F41C0B78; Thu, 22 Oct 2020 13:02:29 +0200 (CEST)
Date:   Thu, 22 Oct 2020 13:02:13 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v6 3/6] can: ctucanfd: add support for CTU CAN FD
 open-source IP core - bus independent part.
Message-ID: <20201022110213.GC26350@duo.ucw.cz>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz>
 <886a8e0749e0521bf83a88313008a3f38031590b.1603354744.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <886a8e0749e0521bf83a88313008a3f38031590b.1603354744.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Martin Jerabek <martin.jerabek01@gmail.com>
>=20
> This driver adds support for the CTU CAN FD open-source IP core.
> More documentation and core sources at project page
> (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
> The core integration to Xilinx Zynq system as platform driver
> is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top=
).
> Implementation on Intel FGA based PCI Express board is available
> from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).

Is "FGA" a typo? Yes, it is.

Anyway, following link tells me:

Project 'canbus/pcie-ctu_can_fd' was moved to
'canbus/pcie-ctucanfd'. Please update any links and bookmarks that may
still have the old path. Fixing it in Kconfig is more important.

> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -0,0 +1,15 @@

> +if CAN_CTUCANFD
> +
> +endif

Empty -> drop?

> +++ b/drivers/net/can/ctucanfd/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only

> +++ b/drivers/net/can/ctucanfd/ctu_can_fd.c
> @@ -0,0 +1,1105 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

Having Makefile and sources with different licenses is rather unusual.

> +static const char * const ctucan_state_strings[] =3D {
> +	"CAN_STATE_ERROR_ACTIVE",
> +	"CAN_STATE_ERROR_WARNING",
> +	"CAN_STATE_ERROR_PASSIVE",
> +	"CAN_STATE_BUS_OFF",
> +	"CAN_STATE_STOPPED",
> +	"CAN_STATE_SLEEPING"
> +};

Put this near function that uses this?

> +/**
> + * ctucan_set_bittiming - CAN set bit timing routine
> + * @ndev:	Pointer to net_device structure
> + *
> + * This is the driver set bittiming routine.
> + * Return: 0 on success and failure value on error
> + */

> +/**
> + * ctucan_chip_start - This routine starts the driver
> + * @ndev:	Pointer to net_device structure
> + *
> + * This is the drivers start routine.
> + *
> + * Return: 0 on success and failure value on error
> + */

Good documentation is nice, but repeating "This routine starts the
driver" in "This is the drivers start routine." is not too helpful.

> +/**
> + * ctucan_start_xmit - Starts the transmission
> + * @skb:	sk_buff pointer that contains data to be Txed
> + * @ndev:	Pointer to net_device structure
> + *
> + * This function is invoked from upper layers to initiate transmission. =
This
> + * function uses the next available free txbuf and populates their field=
s to
> + * start the transmission.
> + *
> + * Return: %NETDEV_TX_OK on success and failure value on error
> + */

Based on other documentation, I'd expect this to return -ESOMETHING on
error, but it returns NETDEV_TX_BUSY.

> +	/* Check if the TX buffer is full */
> +	if (unlikely(!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))) {
> +		netif_stop_queue(ndev);
> +		netdev_err(ndev, "BUG!, no TXB free when queue awake!\n");
> +		return NETDEV_TX_BUSY;
> +	}

You call stop_queue() without spinlock...

> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +
> +	ctucan_hw_txt_set_rdy(&priv->p, txb_id);
> +
> +	priv->txb_head++;
> +
> +	/* Check if all TX buffers are full */
> +	if (!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))
> +		netif_stop_queue(ndev);
> +
> +	spin_unlock_irqrestore(&priv->tx_lock, flags);

=2E..and then with spinlock held. One of them is buggy.

> +/**
> + * xcan_rx -  Is called from CAN isr to complete the received
> + *		frame processing
> + * @ndev:	Pointer to net_device structure
> + *
> + * This function is invoked from the CAN isr(poll) to process the Rx fra=
mes. It
> + * does minimal processing and invokes "netif_receive_skb" to complete f=
urther
> + * processing.
> + * Return: 1 on success and 0 on failure.
> + */

Adapt to usual 0 / -EFOO?

> +	/* Check for Arbitration Lost interrupt */
> +	if (isr.s.ali) {
> +		if (dologerr)
> +			netdev_info(ndev, "  arbitration lost");
> +		priv->can.can_stats.arbitration_lost++;
> +		if (skb) {
> +			cf->can_id |=3D CAN_ERR_LOSTARB;
> +			cf->data[0] =3D CAN_ERR_LOSTARB_UNSPEC;
> +		}
> +	}
> +
> +	/* Check for Bus Error interrupt */
> +	if (isr.s.bei) {
> +		netdev_info(ndev, "  bus error");

Missing "if (dologerr)" here?

> +static int ctucan_rx_poll(struct napi_struct *napi, int quota)
> +{
> +	struct net_device *ndev =3D napi->dev;
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	int work_done =3D 0;
> +	union ctu_can_fd_status status;
> +	u32 framecnt;
> +
> +	framecnt =3D ctucan_hw_get_rx_frame_count(&priv->p);
> +	netdev_dbg(ndev, "rx_poll: %d frames in RX FIFO", framecnt);

This will be rather noisy, right?

> +	/* Check for RX FIFO Overflow */
> +	status =3D ctu_can_get_status(&priv->p);
> +	if (status.s.dor) {
> +		struct net_device_stats *stats =3D &ndev->stats;
> +		struct can_frame *cf;
> +		struct sk_buff *skb;
> +
> +		netdev_info(ndev, "  rx fifo overflow");

And this goes at different loglevel, which will be confusing?

> +/**
> + * xcan_tx_interrupt - Tx Done Isr
> + * @ndev:	net_device pointer
> + */
> +static void ctucan_tx_interrupt(struct net_device *ndev)

Mismatch between code and docs.

> +	netdev_dbg(ndev, "%s", __func__);

This is inconsistent with other debugging.... and perhaps it is time
to remove this kind of debugging for merge.

> +/**
> + * xcan_interrupt - CAN Isr
> + */
> +static irqreturn_t ctucan_interrupt(int irq, void *dev_id)

Inconsistent.

> +		/* Error interrupts */
> +		if (isr.s.ewli || isr.s.fcsi || isr.s.ali) {
> +			union ctu_can_fd_int_stat ierrmask =3D { .s =3D {
> +				  .ewli =3D 1, .fcsi =3D 1, .ali =3D 1, .bei =3D 1 } };
> +			icr.u32 =3D isr.u32 & ierrmask.u32;

We normally do bit arithmetics instead of this.=20

> +	{
> +		union ctu_can_fd_int_stat imask;
> +
> +		imask.u32 =3D 0xffffffff;
> +		ctucan_hw_int_ena_clr(&priv->p, imask);
> +		ctucan_hw_int_mask_set(&priv->p, imask);
> +	}

More like this. Plus avoid block here...?

> +/**
> + * ctucan_close - Driver close routine
> + * @ndev:	Pointer to net_device structure
> + *
> + * Return: 0 always
> + */

You see, this is better. No need to say "Driver close routine"
twice. Now, make the rest consistent :-).


> +EXPORT_SYMBOL(ctucan_suspend);
> +EXPORT_SYMBOL(ctucan_resume);

_GPL?

And what kind of multi-module stuff are you doing that you need
symbols exported?

> +int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq,=
 unsigned int ntxbufs,
> +			unsigned long can_clk_rate, int pm_enable_call,
> +			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
> +{

Splitting/simplifying this somehow would be good.

> +/* Register descriptions: */
> +union ctu_can_fd_frame_form_w {
> +	uint32_t u32;

u32, as you write elsewhere.

> +	struct ctu_can_fd_frame_form_w_s {
> +#ifdef __LITTLE_ENDIAN_BITFIELD
> +  /* FRAME_FORM_W */
> +		uint32_t dlc                     : 4;
> +		uint32_t reserved_4              : 1;
> +		uint32_t rtr                     : 1;
> +		uint32_t ide                     : 1;
> +		uint32_t fdf                     : 1;
> +		uint32_t reserved_8              : 1;
> +		uint32_t brs                     : 1;
> +		uint32_t esi_rsv                 : 1;
> +		uint32_t rwcnt                   : 5;
> +		uint32_t reserved_31_16         : 16;
> +#else

I believe you should simply avoid using bitfields.

> +union ctu_can_fd_timestamp_l_w {
> +	uint32_t u32;
> +	struct ctu_can_fd_timestamp_l_w_s {
> +  /* TIMESTAMP_L_W */
> +		uint32_t time_stamp_31_0        : 32;
> +	} s;
> +};

This is crazy.

> +union ctu_can_fd_data_5_8_w {
> +	uint32_t u32;
> +	struct ctu_can_fd_data_5_8_w_s {
> +#ifdef __LITTLE_ENDIAN_BITFIELD
> +  /* DATA_5_8_W */
> +		uint32_t data_5                  : 8;
> +		uint32_t data_6                  : 8;
> +		uint32_t data_7                  : 8;
> +		uint32_t data_8                  : 8;
> +#else
> +		uint32_t data_8                  : 8;
> +		uint32_t data_7                  : 8;
> +		uint32_t data_6                  : 8;
> +		uint32_t data_5                  : 8;
> +#endif
> +	} s;
> +};

even more crazy.

> +#ifdef __KERNEL__
> +# include <linux/can/dev.h>
> +#else
> +/* The hardware registers mapping and low level layer should build
> + * in userspace to allow development and verification of CTU CAN IP
> + * core VHDL design when loaded into hardware. Debugging hardware
> + * from kernel driver is really difficult, leads to system stucks
> + * by error reporting etc. Testing of exactly the same code
> + * in userspace together with headers generated automatically
> + * generated from from IP-XACT/cactus helps to driver to hardware
> + * and QEMU emulation model consistency keeping.
> + */
> +# include "ctu_can_fd_linux_defs.h"
> +#endif

Please remove non-kernel code for merge.

> +void ctucan_hw_write32(struct ctucan_hw_priv *priv,
> +		       enum ctu_can_fd_can_registers reg, u32 val)
> +{
> +	iowrite32(val, priv->mem_base + reg);
> +}

And get rid of this kind of abstraction layer.

> +// TODO: rename or do not depend on previous value of id

TODO: grep for TODO and C++ comments before attempting merge.

> +static bool ctucan_hw_len_to_dlc(u8 len, u8 *dlc)
> +{
> +	*dlc =3D can_len2dlc(len);
> +	return true;
> +}

Compared to how well other code is documented... This one is voodoo.

> +bool ctucan_hw_set_ret_limit(struct ctucan_hw_priv *priv, bool enable, u=
8 limit)
> +{
> +	union ctu_can_fd_mode_settings reg;
> +
> +	if (limit > CTU_CAN_FD_RETR_MAX)
> +		return false;
> +
> +	reg.u32 =3D priv->read_reg(priv, CTU_CAN_FD_MODE);
> +	reg.s.rtrle =3D enable ? RTRLE_ENABLED : RTRLE_DISABLED;
> +	reg.s.rtrth =3D limit & 0xF;
> +	priv->write_reg(priv, CTU_CAN_FD_MODE, reg.u32);
> +	return true;
> +}

As elsewhere, I'd suggest 0/-ERRNO.

> +void ctucan_hw_set_mode_reg(struct ctucan_hw_priv *priv,
> +			    const struct can_ctrlmode *mode)
> +{
> +	u32 flags =3D mode->flags;
> +	union ctu_can_fd_mode_settings reg;
> +
> +	reg.u32 =3D priv->read_reg(priv, CTU_CAN_FD_MODE);

> +	if (mode->mask & CAN_CTRLMODE_LOOPBACK)
> +		reg.s.ilbp =3D flags & CAN_CTRLMODE_LOOPBACK ?
> +					INT_LOOP_ENABLED : INT_LOOP_DISABLED;

Not sure what is going on here, but having mode->flags in same format
as hardware register would help...?

> +	switch (fnum) {
> +	case CTU_CAN_FD_FILTER_A:
> +		if (reg.s.sfa)
> +			return true;
> +	break;
> +	case CTU_CAN_FD_FILTER_B:
> +		if (reg.s.sfb)
> +			return true;
> +	break;
> +	case CTU_CAN_FD_FILTER_C:
> +		if (reg.s.sfc)
> +			return true;
> +	break;
> +	}

Check indentation of break statemnts, also elsewhere in this file

> +bool ctucan_hw_get_range_filter_support(struct ctucan_hw_priv *priv)
> +{
> +	union ctu_can_fd_filter_control_filter_status reg;
> +
> +	reg.u32 =3D priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
> +
> +	if (reg.s.sfr)
> +		return true;

return !!reg.s.sfr; ?

> +enum ctu_can_fd_tx_status_tx1s ctucan_hw_get_tx_status(struct ctucan_hw_=
priv
> +							*priv, u8 buf)
=2E..
> +	default:
> +		status =3D ~0;
> +	}
> +	return (enum ctu_can_fd_tx_status_tx1s)status;
> +}

Is ~0 in the enum?

> +	// TODO: use named constants for the command

TODO...

> +// TODO: AL_CAPTURE and ERROR_CAPTURE

=2E..

> +#if defined(__LITTLE_ENDIAN_BITFIELD) =3D=3D defined(__BIG_ENDIAN_BITFIE=
LD)
> +# error __BIG_ENDIAN_BITFIELD or __LITTLE_ENDIAN_BITFIELD must be define=
d.
> +#endif

:-).
> +// True if Core is transceiver of current frame
> +#define CTU_CAN_FD_IS_TRANSMITTER(stat) (!!(stat).ts)
> +
> +// True if Core is receiver of current frame
> +#define CTU_CAN_FD_IS_RECEIVER(stat) (!!(stat).s.rxs)

Why not, documentation is nice. But it is in big contrast to other
parts of code where there's no docs at all.

> +struct ctucan_hw_priv;
> +#ifndef ctucan_hw_priv
> +struct ctucan_hw_priv {
> +	void __iomem *mem_base;
> +	u32 (*read_reg)(struct ctucan_hw_priv *priv,
> +			enum ctu_can_fd_can_registers reg);
> +	void (*write_reg)(struct ctucan_hw_priv *priv,
> +			  enum ctu_can_fd_can_registers reg, u32 val);
> +};
> +#endif

Should not be needed in kernel.

> +/**
> + * ctucan_hw_read_rx_word - Reads one word of CAN Frame from RX FIFO Buf=
fer.
> + *
> + * @priv: Private info
> + *
> + * Return: One wword of received frame

Typo 'word'.

> +++ b/drivers/net/can/ctucanfd/ctu_can_fd_regs.h
> @@ -0,0 +1,971 @@
> +
> +/* This file is autogenerated, DO NOT EDIT! */
> +

Yay. How is that supposed to work after merge?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5FmtQAKCRAw5/Bqldv6
8vGvAJ9uJYXCbakJMeRM74nm7C5yS5WNjgCfedqWhCgGitgON8XcH8L7t1FjLYU=
=malX
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
