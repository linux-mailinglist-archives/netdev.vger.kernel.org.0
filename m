Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B5A411680
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhITOOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:14:01 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:58374 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234845AbhITONz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 10:13:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632147148; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=xEUPffocEcLd0zxK99tRaqOOXGj+H2f2r9+78rm0ZNQ=; b=B9+BpOoXpWyip/lORYVQoTEfk+cTDipMqFQbPAT0p2fJzG72auiHMXhqA1tG99bxCJ5Biuq8
 NkAKaGQw5zZjPfYVuzcWgFNmFk510e0pDkbgXr1n1Wo40cI8nx/8sKcjQ53I8pe69QeFyUK+
 KqJt/y8Obwarc5LfCZkiYU9TUh8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 614896b4b585cc7d24424a21 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Sep 2021 14:12:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AD935C4360D; Mon, 20 Sep 2021 14:12:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2240BC43460;
        Mon, 20 Sep 2021 14:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2240BC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v15] wireless: Initial driver submission for pureLiFi STA devices
References: <20210226130810.119216-1-srini.raju@purelifi.com>
        <20210818141343.7833-1-srini.raju@purelifi.com>
Date:   Mon, 20 Sep 2021 17:11:58 +0300
In-Reply-To: <20210818141343.7833-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Wed, 18 Aug 2021 15:13:00 +0100")
Message-ID: <87a6k7wd3l.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>
> This driver implementation has been based on the zd1211rw driver.
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

[...]

> +int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
> +				 u8 dtim_period, int type)
> +{
> +	if (!interval ||
> +	    (chip->beacon_set &&
> +	     le16_to_cpu(chip->beacon_interval) == interval))
> +		return 0;
> +
> +	chip->beacon_interval = cpu_to_le16(interval);
> +	chip->beacon_set = true;
> +	return plf_usb_wreq((const u8 *)&chip->beacon_interval,
> +			     sizeof(chip->beacon_interval),
> +			     USB_REQ_BEACON_INTERVAL_WR);

Can't you make plf_usb_wreq() to a void pointer? Then that ugly "const
u8 *" cast is not needed.

> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/chip.h
> @@ -0,0 +1,84 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2021 pureLiFi
> + */
> +
> +#ifndef _LF_X_CHIP_H
> +#define _LF_X_CHIP_H
> +
> +#include <net/mac80211.h>
> +
> +#include "usb.h"
> +
> +enum unit_type_t {
> +	STA = 0,
> +	AP = 1,
> +};

unit_type_t -> unit_type

> +struct purelifi_chip {
> +	struct purelifi_usb usb;
> +	struct mutex mutex; /* lock to protect chip data */
> +	enum unit_type_t unit_type;
> +	u16 link_led;
> +	u8  beacon_set;

Extra space after u8.

> +int download_fpga(struct usb_interface *intf)
> +{
> +#define PLF_VNDR_FPGA_STATE_REQ 0x30
> +#define PLF_VNDR_FPGA_SET_REQ 0x33
> +#define PLF_VNDR_FPGA_SET_CMD 0x34
> +#define PLF_VNDR_FPGA_STATE_CMD 0x35

Please move these to a .h file.

> +	kfree(fpga_dmabuff);/* free PLF_FPGA_STATUS_LEN*/

Pointless comment.

> +	fpga_dmabuff = NULL;
> +	fpga_dmabuff = kmalloc(PLF_FPGA_STATE_LEN, GFP_KERNEL);

No need to assign fpga_dmabuff to NULL.

> +int download_xl_firmware(struct usb_interface *intf)
> +{
> +#define PLF_VNDR_XL_FW_CMD 0x80
> +#define PLF_VNDR_XL_DATA_CMD 0x81
> +#define PLF_VNDR_XL_FILE_CMD 0x82
> +#define PLF_VNDR_XL_EX_CMD 0x83

Please move these to a .h file.

> +struct flash_t {
> +	unsigned char enabled;
> +	unsigned int sector_size;
> +	unsigned int sectors;
> +	unsigned char ec;
> +};

Remove all _t suffixes in names.

> +int upload_mac_and_serial(struct usb_interface *intf,
> +			  unsigned char *hw_address,
> +			  unsigned char *serial_number)
> +{
> +#define PLF_MAC_VENDOR_REQUEST 0x36
> +#define PLF_SERIAL_NUMBER_VENDOR_REQUEST 0x37
> +#define PLF_FIRMWARE_VERSION_VENDOR_REQUEST 0x39
> +#define PLF_SERIAL_LEN 14
> +#define PLF_FW_VER_LEN 8

Move to .h file.

> +void purelifi_block_queue(struct purelifi_usb *usb, bool block)
> +{
> +	if (block)
> +		ieee80211_stop_queues(purelifi_usb_to_hw(usb));
> +	else
> +		ieee80211_wake_queues(purelifi_usb_to_hw(usb));
> +}

Looks like a useless abstraction to me, just use ieee80211_stop_queues()
and ieee80211_wake_queues() directly.

> +/**
> + * purelifi_mac_tx_status: reports tx status of a packet if required
> + * @hw: a &struct ieee80211_hw pointer
> + * @skb: a sk-buffer
> + * @flags: extra flags to set in the TX status info
> + * @ackssi: ACK signal strength
> + * @success: True for successful transmission of the frame
> + *
> + * This information calls ieee80211_tx_status_irqsafe() if required by the
> + * control information. It copies the control information into the status
> + * information.
> + *
> + */

I'm against this kind of documentation in wireless drivers, they get out
of date so easily.

> +	/*check if 32 bit aligned and align data*/

Correct format is:

/* check if 32 bit aligned and align data */

> +	/* check if not multiple of 512 and align data*/

/* check if not multiple of 512 and align data */

> +int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
> +		    unsigned int length)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct ieee80211_rx_status stats;
> +	const struct rx_status *status;
> +	struct sk_buff *skb;
> +	int bad_frame = 0;
> +	__le16 fc;
> +	int need_padding;
> +	unsigned int payload_length;
> +	static unsigned short int min_exp_seq_nmb;

No static variables, "static const" are only exceptions. Otherwise two
devices on the same host won't work correctly.

> +	switch (buffer[0]) {
> +	unsigned short int seq_nmb;

Please move the variable declaration to the beginning of the function.

> +	case IEEE80211_STYPE_PROBE_REQ:
> +		dev_dbg(purelifi_mac_dev(mac), "Probe request\n");
> +		break;
> +	case IEEE80211_STYPE_ASSOC_REQ:
> +		dev_dbg(purelifi_mac_dev(mac), "Association request\n");
> +		break;
> +	case IEEE80211_STYPE_AUTH:
> +		dev_dbg(purelifi_mac_dev(mac), "Authentication req\n");
> +		min_exp_seq_nmb = 0;
> +		break;
> +	case IEEE80211_FTYPE_DATA:
> +		seq_nmb = (buffer[23] << 4) | ((buffer[22] & 0xF0) >> 4);

No magic numbers, please.

> +		if (seq_nmb < min_exp_seq_nmb &&
> +		    ((min_exp_seq_nmb - seq_nmb) < 3000))
> +			dev_dbg(purelifi_mac_dev(mac), "seq_nmb < min_exp\n");
> +		else
> +			min_exp_seq_nmb = (seq_nmb + 1) % 4096;
> +		break;

Here are also 3000 and 4096.

> +static const struct ieee80211_ops purelifi_ops = {
> +	.tx                 = purelifi_op_tx,
> +	.start              = purelifi_op_start,
> +	.stop               = purelifi_op_stop,
> +	.add_interface      = purelifi_op_add_interface,
> +	.remove_interface   = purelifi_op_remove_interface,
> +	.set_rts_threshold  = purelifi_set_rts_threshold,
> +	.config             = purelifi_op_config,
> +	.configure_filter   = purelifi_op_configure_filter,
> +	.bss_info_changed   = purelifi_op_bss_info_changed,
> +	.get_stats          = purelifi_get_stats,
> +	.get_et_sset_count  = purelifi_get_et_sset_count,
> +	.get_et_stats       = purelifi_get_et_stats,
> +	.get_et_strings     = purelifi_get_et_strings,

AFAICS, purelife is the vendor and plfxlc is the driver, so you should
"plfxlc_" as the prefix here.

> +	hw->extra_tx_headroom = sizeof(struct purelifi_ctrlset) + 4;
> +	/* 4 for 32 bit alignment if no tailroom */

Move the comment before the actual code.

> +#define purelifi_mac_dev(mac) (purelifi_chip_dev(&(mac)->chip))

Isn't the parenthesis unnecessary?

> +
> +#define PURELIFI_MAC_STATS_BUFFER_SIZE 16
> +#define PURELIFI_MAC_MAX_ACK_WAITERS 50
> +
> +struct purelifi_ctrlset {
> +	__be32		id;/*should be usb_req_enum_t*/

Move the comment to a separate line, above this line. And fix the
comment format.

> +	__be32		len;
> +	u8              modulation;
> +	u8              control;
> +	u8              service;
> +	u8		pad;
> +	__le16		packet_length;
> +	__le16		current_length;
> +	__le16		next_frame_length;
> +	__le16		tx_length;
> +	__be32		payload_len_nw;
> +} __packed;
> +
> +/*overlay*/

Fix comment format.

> +	/* whether to pass frames with CRC errors to stack */
> +	unsigned int pass_failed_fcs:1;
> +
> +	/* whether to pass control frames to stack */
> +	unsigned int pass_ctrl:1;
> +
> +	/* whether we have received a 802.11 ACK that is pending */
> +	bool ack_pending;

Inconsistent use of flags/booleans, either use unsigned int or bool.

> +static atomic_t data_queue_flag;

No static variables.

> +/*Tx retry backoff timer (in milliseconds).*/

I'm going to stop commenting about comment format now, you should know
by now.

> +# define TX_RETRY_BACKOFF_MS 10
> +# define STA_QUEUE_CLEANUP_MS 5000

No space after #. Applies to all usage in the driver.


> +static struct usb_device_id usb_ids[] = {

static const

> +	{ USB_DEVICE(PURELIFI_X_VENDOR_ID_0, PURELIFI_X_PRODUCT_ID_0),
> +	  .driver_info = DEVICE_LIFI_X },
> +	{ USB_DEVICE(PURELIFI_XC_VENDOR_ID_0, PURELIFI_XC_PRODUCT_ID_0),
> +	  .driver_info = DEVICE_LIFI_XC },
> +	{ USB_DEVICE(PURELIFI_XL_VENDOR_ID_0, PURELIFI_XL_PRODUCT_ID_0),
> +	  .driver_info = DEVICE_LIFI_XL },
> +	{}
> +};
> +
> +static struct usb_interface *ez_usb_interface;

No static variables.

> +#define STATION_FIFO_ALMOST_FULL_MESSAGE     0
> +#define STATION_FIFO_ALMOST_FULL_NOT_MESSAGE 1
> +#define STATION_CONNECT_MESSAGE              2
> +#define STATION_DISCONNECT_MESSAGE           3

Move to a .h file.

> +static void rx_urb_complete(struct urb *urb)
> +{
> +	int r;
> +	static u8 retry;

No static variables.

> +	struct purelifi_usb *usb;
> +	struct purelifi_usb_tx *tx;
> +	const u8 *buffer;
> +	static u8 fpga_link_connection_f;

Ditto.

> +	unsigned int length;
> +	u16 status;
> +	u8 sidx;
> +
> +	if (!urb) {
> +		dev_err(purelifi_usb_dev(usb), "urb is NULL.\n");
> +		return;
> +	} else if (!urb->context) {
> +		dev_err(purelifi_usb_dev(usb), "urb ctx is NULL.\n");
> +		return;
> +	}
> +	usb = urb->context;
> +
> +	if (usb->initialized != 1)
> +		return;
> +
> +	switch (urb->status) {
> +	case 0:
> +		break;
> +	case -ESHUTDOWN:
> +	case -EINVAL:
> +	case -ENODEV:
> +	case -ENOENT:
> +	case -ECONNRESET:
> +	case -EPIPE:
> +		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
> +		return;
> +	default:
> +		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
> +		if (retry++ < PURELIFI_URB_RETRY_MAX) {
> +			dev_dbg(urb_dev(urb), "urb %p resubmit %d", urb, retry);
> +			goto resubmit;
> +		} else {
> +			dev_dbg(urb_dev(urb), "urb %p  max resubmits reached", urb);
> +			retry = 0;
> +			return;
> +		}
> +	}
> +
> +	buffer = urb->transfer_buffer;
> +	length = (*(u32 *)(buffer + sizeof(struct rx_status)))

This does not look endian safe.

> +		 + sizeof(u32);
> +
> +	tx = &usb->tx;
> +
> +	if (urb->actual_length != 8) {

Magic value.

> +		if (usb->initialized && fpga_link_connection_f)
> +			handle_rx_packet(usb, buffer, length);
> +		goto resubmit;
> +	}
> +
> +	status = buffer[7];

Magic value. A proper struct for these 8 bytes would be the best way to
document and access it.

> +
> +	dev_dbg(&usb->intf->dev, "Recv status=%u\n", status);
> +	dev_dbg(&usb->intf->dev, "Tx packet MAC=%x:%x:%x:%x:%x:%x\n",
> +		buffer[0], buffer[1], buffer[2], buffer[3],
> +		buffer[4], buffer[5]);

Ok, so that struct should start with a mac address.

> +
> +	switch (status) {
> +	case STATION_FIFO_ALMOST_FULL_NOT_MESSAGE:
> +		dev_dbg(&usb->intf->dev,
> +			"FIFO full not packet receipt\n");
> +		tx->mac_fifo_full = 1;
> +		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
> +			tx->station[sidx].flag |= STATION_FIFO_FULL_FLAG;
> +		break;
> +	case STATION_FIFO_ALMOST_FULL_MESSAGE:
> +		dev_dbg(&usb->intf->dev, "FIFO full packet receipt\n");
> +
> +		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
> +			tx->station[sidx].flag &= 0xFD;

Magic value.

> +
> +		purelifi_send_packet_from_data_queue(usb);
> +		break;
> +	case STATION_CONNECT_MESSAGE:
> +		fpga_link_connection_f = 1;

I remember if I said this already, but no "_f" style of naming. What
does it even mean, a flag?

> +	for (i = 0; i < RX_URBS_COUNT; i++) {
> +		r = usb_submit_urb(urbs[i], GFP_KERNEL);
> +		if (r)
> +			goto error_submit;
> +	}
> +
> +	return 0; /*no error return*/

A useless comment.

> +void purelifi_usb_disable_tx(struct purelifi_usb *usb)
> +{
> +	struct purelifi_usb_tx *tx = &usb->tx;
> +	unsigned long flags;
> +
> +	atomic_set(&tx->enabled, 0);

I didn't check, but I suspect you are misusing atomic variables here.
Just use SET_BIT() & co.

> +void tx_urb_complete(struct urb *urb)
> +{
> +	struct sk_buff *skb;
> +	struct ieee80211_tx_info *info;
> +	struct purelifi_usb *usb;
> +
> +	skb = (struct sk_buff *)urb->context;

urb->context is a void pointer, no need to cast it.

> +int purelifi_usb_tx(struct purelifi_usb *usb, struct sk_buff *skb)
> +{
> +	int r;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct usb_device *udev = purelifi_usb_to_usbdev(usb);
> +	struct urb *urb;
> +	struct purelifi_usb_tx *tx = &usb->tx;
> +
> +	if (!atomic_read(&tx->enabled)) {

Yeah, just use TEST_BIT().

> +void purelifi_usb_init(struct purelifi_usb *usb, struct ieee80211_hw *hw,
> +		       struct usb_interface *intf)
> +{
> +	memset(usb, 0, sizeof(*usb));
> +	usb->intf = usb_get_intf(intf);
> +	usb_set_intfdata(usb->intf, hw);
> +	hw->conf.chandef.width = NL80211_CHAN_WIDTH_20;

I was expecting to set the width in mac.c.

> +static void get_usb_req(struct usb_device *udev, const u8 *buffer,
> +			u32 buffer_len, enum usb_req_enum_t usb_req_id,
> +			struct usb_req_t *usb_req)
> +{
> +	u8 *buffer_dst_p = usb_req->buf;

No "_p" naming either. Is that hungarian notation or what? Anyway, we
don't use that in upstream.

> +static int probe(struct usb_interface *intf,
> +		 const struct usb_device_id *id)
> +{
> +	int r = 0;
> +	struct purelifi_chip *chip;
> +	struct purelifi_usb *usb;
> +	struct purelifi_usb_tx *tx;
> +	struct ieee80211_hw *hw = NULL;
> +	static u8 hw_address[ETH_ALEN];
> +	static u8 serial_number[PURELIFI_SERIAL_LEN];

No static variables.

> +	unsigned int i;
> +
> +	ez_usb_interface = intf;
> +
> +	hw = purelifi_mac_alloc_hw(intf);
> +
> +	if (!hw) {
> +		r = -ENOMEM;
> +		goto error;
> +	}
> +
> +	chip = &purelifi_hw_mac(hw)->chip;
> +	usb = &chip->usb;
> +	tx = &usb->tx;
> +
> +	r = upload_mac_and_serial(intf, hw_address, serial_number);
> +
> +	if (r) {
> +		dev_err(&intf->dev, "MAC and Serial upload failed (%d)\n", r);
> +		goto error;
> +	}
> +	chip->unit_type = STA;
> +	dev_dbg(&intf->dev, "unit type is station");
> +
> +	r = purelifi_mac_preinit_hw(hw, hw_address);
> +	if (r) {
> +		dev_dbg(&intf->dev, "init mac failed (%d)\n", r);
> +		goto error;
> +	}
> +
> +	r = ieee80211_register_hw(hw);
> +	if (r) {
> +		dev_dbg(&intf->dev, "register device failed (%d)\n", r);
> +		goto error;
> +	}
> +	dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));

Looks like a pointless info message to me, please remove.

> +	if ((le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor) ==
> +				PURELIFI_XL_VENDOR_ID_0) &&
> +	    (le16_to_cpu(interface_to_usbdev(intf)->descriptor.idProduct) ==
> +				PURELIFI_XL_PRODUCT_ID_0)) {
> +		r = download_xl_firmware(intf);
> +	} else {
> +		r = download_fpga(intf);
> +	}
> +	if (r != 0) {
> +		dev_err(&intf->dev, "FPGA download failed (%d)\n", r);
> +		goto error;
> +	}
> +
> +	tx->mac_fifo_full = 0;
> +	spin_lock_init(&tx->lock);
> +
> +	msleep(PLF_MSLEEP_TIME);
> +	r = purelifi_usb_init_hw(usb);
> +	if (r < 0) {
> +		dev_dbg(&intf->dev, "usb_init_hw failed (%d)\n", r);
> +		goto error;
> +	}
> +
> +	msleep(PLF_MSLEEP_TIME);
> +	r = purelifi_chip_switch_radio(chip, 1); /* Switch ON Radio */

A pointless comment. You can change the integer to an enum
(PLFXLC_RADIO_ON) if you want to document clearly when it's turned on.

> +	if (r < 0) {
> +		dev_dbg(&intf->dev, "chip_switch_radio_on failed (%d)\n", r);
> +		goto error;
> +	}
> +
> +	msleep(PLF_MSLEEP_TIME);
> +	r = purelifi_chip_set_rate(chip, 8);
> +	if (r < 0) {
> +		dev_dbg(&intf->dev, "chip_set_rate failed (%d)\n", r);
> +		goto error;
> +	}
> +
> +	msleep(PLF_MSLEEP_TIME);
> +	r = plf_usb_wreq(hw_address, ETH_ALEN, USB_REQ_MAC_WR);
> +	if (r < 0) {
> +		dev_dbg(&intf->dev, "MAC_WR failure (%d)\n", r);
> +		goto error;
> +	}
> +
> +	purelifi_chip_enable_rxtx(chip);
> +
> +	/* Initialise the data plane Tx queue */
> +	atomic_set(&data_queue_flag, 1);

Misuse of atomic variables again, SET_BIT().

> +static struct workqueue_struct *purelifi_workqueue;

This static variable actually might be ok as it's called only from
usb_init() and usb_exit(). Just rename it to plfxlc_workqueue.

> +static int __init usb_init(void)
> +{
> +	int r;
> +
> +	purelifi_workqueue = create_singlethread_workqueue(driver.name);
> +	if (!purelifi_workqueue) {
> +		pr_err("%s couldn't create workqueue\n", driver.name);
> +		r = -ENOMEM;
> +		goto error;
> +	}
> +
> +	r = usb_register(&driver);
> +	if (r) {
> +		destroy_workqueue(purelifi_workqueue);
> +		pr_err("%s usb_register() failed %d\n", driver.name, r);
> +		return r;
> +	}
> +
> +	pr_debug("Driver initialized :%s\n", driver.name);
> +	return 0;
> +
> +error:
> +	return r;
> +}
> +
> +static void __exit usb_exit(void)
> +{
> +	usb_deregister(&driver);
> +	destroy_workqueue(purelifi_workqueue);
> +	pr_debug("%s %s\n", driver.name, __func__);
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("USB driver for pureLiFi devices");
> +MODULE_AUTHOR("pureLiFi");
> +MODULE_VERSION("1.0");
> +MODULE_FIRMWARE("plfxlc/lifi-x.bin");
> +MODULE_DEVICE_TABLE(usb, usb_ids);
> +module_init(usb_init);
> +module_exit(usb_exit);

I see that you have MODULE_LICENSE() three times:

chip.c.97:MODULE_LICENSE("GPL");
mac.c.841:MODULE_LICENSE("GPL");
usb.c.1006:MODULE_LICENSE("GPL");

But you only have one module. So remove MODULE_LICENSE() from chip.c and
mac.c, and leave it only here.

> +/* USB interrupt */
> +struct purelifi_usb_interrupt {

A useless comment.

> +	spinlock_t lock;/* spin lock for usb interrupt buffer */

Add space before the comment.

> +	struct urb *urb;
> +	void *buffer;
> +	int interval;
> +};
> +
> +#define RX_URBS_COUNT 5
> +
> +struct purelifi_usb_rx {
> +	spinlock_t lock;/* spin lock for rx urb */

Here too.

> +	struct mutex setup_mutex; /* mutex lockt for rx urb */
> +	u8 fragment[2 * USB_MAX_RX_SIZE];
> +	unsigned int fragment_length;
> +	unsigned int usb_packet_size;
> +	struct urb **urbs;
> +	int urbs_count;
> +};
> +
> +struct station_t {
> +   //  7...3    |    2      |     1     |     0	    |
> +   // Reserved  | Heartbeat | FIFO full | Connected |

No C++ comments, please.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
