Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9F56821F6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjAaCUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjAaCUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:20:47 -0500
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF5B15571;
        Mon, 30 Jan 2023 18:20:44 -0800 (PST)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-163bd802238so5522892fac.1;
        Mon, 30 Jan 2023 18:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0lcjMsQIVWWWo09HvDpUaTb9NJyH9kvcGcMAzx2eYdI=;
        b=CedlBkAnsWJBn+Ma7iLvtWZANz2wcM+NgS077QpeNhVGjCbKFcUTeoiLH+gjv9/fqz
         Wm8IY+ef2QTZDXMeLb3PjdlfjTx9MwEpxupBVsKXRQimNOxuvMP7UMTmQT1Do0t3Z/B7
         vSiG94khYmPq6Fk249UWfJtjm7YAGfIKXwRP13niYbJNC/IyRefdwfFWRU7aNe8CzN/j
         OdDc+Qqb7FYbaLBHqtQZRvlqEXg7zUZ+AM3ZeTaxHS49i9S/IztzaTNgQYrKc4IDPpfK
         ghMUvfdo6VMv/N1hbFmg/mB/g3VUY+NJtOng0yTuvLaJ3YgjjII3O3+WZjg/wSIkl7Py
         bR5Q==
X-Gm-Message-State: AO0yUKXVHSmRAmVs5EqRh6CkZKtf/Aeh4BPbW7q8BEDMptN7Ao2Vy4R3
        coIlisHlf8KipAcM+4uG/A==
X-Google-Smtp-Source: AK7set8UxD32wODbVtXYHeynxwinBpPSRfiRHCsefx0s8X5iuetQipUe5UQp49c9nLWIgIBfYfzuCA==
X-Received: by 2002:a05:6870:9a2a:b0:163:7d36:6758 with SMTP id fo42-20020a0568709a2a00b001637d366758mr6616836oab.26.1675131643108;
        Mon, 30 Jan 2023 18:20:43 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u16-20020a056870701000b0014fd7e7c3fesm5850452oae.27.2023.01.30.18.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 18:20:42 -0800 (PST)
Received: (nullmailer pid 4126515 invoked by uid 1000);
        Tue, 31 Jan 2023 02:20:41 -0000
Date:   Mon, 30 Jan 2023 20:20:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v2 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <20230131022041.GB4082140-robh@kernel.org>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
 <20230130180504.2029440-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130180504.2029440-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:35:04PM +0530, Neeraj Sanjay Kale wrote:
> This adds a driver based on serdev driver for the NXP BT serial
> protocol based on running H:4, which can enable the built-in
> Bluetooth device inside a generic NXP BT chip.

These are rebranded or descend from Marvell chips, right? Maybe this 
should be merged with the 88w8897. The firmware download seems to match 
the v1 protocol.

> 
> This driver has Power Save feature that will put the chip into
> sleep state whenever there is no activity for 2000ms, and will
> be woken up when any activity is to be initiated.
> 
> This driver enables the power save feature by default by sending
> the vendor specific commands to the chip during setup.
> 
> During setup, the driver is capable of validating correct chip
> is attached to the host based on the compatibility parameter
> from DT and chip's unique bootloader signature, and download
> firmware.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip based
> on compatibility devices mentioned in DT bindings. Handled potential
> memory leaks and null pointer dereference issues, simplified FW download
> feature, handled byte-order and few cosmetic changes. (Ilpo Järvinen,
> Alok Tiwari, Hillf Danton)
> ---
>  MAINTAINERS                   |    1 +
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1145 +++++++++++++++++++++++++++++++++
>  drivers/bluetooth/btnxpuart.h |  227 +++++++
>  5 files changed, 1385 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
>  create mode 100644 drivers/bluetooth/btnxpuart.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d465c1124699..1190e46e9b13 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22840,6 +22840,7 @@ M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
>  M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> +F:      drivers/bluetooth/btnxpuart*
>  
>  THE REST
>  M:	Linus Torvalds <torvalds@linux-foundation.org>
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..773b40d34b7b 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -465,4 +465,15 @@ config BT_VIRTIO
>  	  Say Y here to compile support for HCI over Virtio into the
>  	  kernel or say M to compile as a module.
>  
> +config BT_NXPUART
> +	tristate "NXP protocol support"
> +	depends on SERIAL_DEV_BUS
> +	help
> +	  NXP is serial driver required for NXP Bluetooth
> +	  devices with UART interface.
> +
> +	  Say Y here to compile support for NXP Bluetooth UART device into
> +	  the kernel, or say M here to compile as a module.
> +
> +
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index e0b261f24fc9..7a5967e9ac48 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
>  obj-$(CONFIG_BT_MTK)		+= btmtk.o
>  
>  obj-$(CONFIG_BT_VIRTIO)		+= virtio_bt.o
> +obj-$(CONFIG_BT_NXPUART)	+= btnxpuart.o
>  
>  obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
>  
> diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
> new file mode 100644
> index 000000000000..6e6bc5a70af2
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1145 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP
> + *
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +
> +#include <linux/serdev.h>
> +#include <linux/of.h>
> +#include <linux/skbuff.h>
> +#include <asm/unaligned.h>
> +#include <linux/firmware.h>
> +#include <linux/string.h>
> +#include <linux/crc8.h>
> +
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +#include "btnxpuart.h"
> +#include "h4_recv.h"
> +
> +#define BTNXPUART_TX_STATE_ACTIVE	1
> +#define BTNXPUART_TX_STATE_WAKEUP	2
> +#define BTNXPUART_FW_DOWNLOADING	3
> +
> +static u8 crc8_table[CRC8_TABLE_SIZE];
> +static unsigned long crc32_table[256];
> +
> +static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode,
> +										u32 plen, void *param)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	struct sk_buff *skb;
> +
> +	psdata->driver_sent_cmd = true;	/* set flag to prevent re-sending command in nxp_enqueue */
> +	skb = __hci_cmd_sync(hdev, opcode, plen, param, HCI_CMD_TIMEOUT);
> +	psdata->driver_sent_cmd = false;
> +
> +	return skb;
> +}
> +
> +/* NXP Power Save Feature */
> +int wakeupmode = WAKEUP_METHOD_BREAK;
> +int ps_mode = PS_MODE_ENABLE;
> +
> +static void ps_start_timer(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (!psdata)
> +		return;
> +
> +	if (psdata->cur_psmode == PS_MODE_ENABLE) {
> +		psdata->timer_on = 1;
> +		mod_timer(&psdata->ps_timer, jiffies + (psdata->interval * HZ) / 1000);
> +	}
> +}
> +
> +static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (!psdata)
> +		return;
> +
> +	flush_work(&psdata->work);
> +	if (psdata->timer_on)
> +		del_timer_sync(&psdata->ps_timer);
> +	kfree(psdata);
> +}
> +
> +static void ps_control(struct hci_dev *hdev, u8 ps_state)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (psdata->ps_state == ps_state)
> +		return;
> +
> +	switch (psdata->cur_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		if (ps_state == PS_STATE_AWAKE)
> +			serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		else
> +			serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		BT_INFO("Set UART break: %s", ps_state == PS_STATE_AWAKE ? "off" : "on");
> +		if (ps_state == PS_STATE_AWAKE)
> +			serdev_device_break_ctl(nxpdev->serdev, 0);
> +		else
> +			serdev_device_break_ctl(nxpdev->serdev, -1);
> +		break;
> +	}
> +	psdata->ps_state = ps_state;
> +
> +	if (ps_state == PS_STATE_AWAKE)
> +		btnxpuart_tx_wakeup(nxpdev);
> +}
> +
> +static void ps_work_func(struct work_struct *work)
> +{
> +	struct ps_data *data = container_of(work, struct ps_data, work);
> +
> +	if (data->ps_cmd == PS_CMD_ENTER_PS && data->cur_psmode == PS_MODE_ENABLE)
> +		ps_control(data->hdev, PS_STATE_SLEEP);
> +	else if (data->ps_cmd == PS_CMD_EXIT_PS)
> +		ps_control(data->hdev, PS_STATE_AWAKE);
> +}
> +
> +static void ps_timeout_func(struct timer_list *t)
> +{
> +	struct ps_data *data = from_timer(data, t, ps_timer);
> +	struct hci_dev *hdev = data->hdev;
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	data->timer_on = 0;
> +	if (test_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
> +		ps_start_timer(nxpdev);
> +	} else {
> +		data->ps_cmd = PS_CMD_ENTER_PS;
> +		schedule_work(&data->work);
> +	}
> +}
> +
> +static int ps_init_work(struct hci_dev *hdev)
> +{
> +	struct ps_data *psdata = kzalloc(sizeof(*psdata), GFP_KERNEL);
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (!psdata) {
> +		BT_ERR("Can't allocate control structure for Power Save feature");
> +		return -ENOMEM;
> +	}
> +	nxpdev->psdata = psdata;
> +
> +	psdata->interval = PS_DEFAULT_TIMEOUT_PERIOD;
> +	psdata->ps_state = PS_STATE_AWAKE;
> +	psdata->ps_mode = ps_mode;
> +	psdata->hdev = hdev;
> +
> +	switch (wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		psdata->wakeupmode = WAKEUP_METHOD_DTR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		psdata->wakeupmode = WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +
> +	psdata->cur_psmode = PS_MODE_DISABLE;
> +	psdata->cur_wakeupmode = WAKEUP_METHOD_INVALID;
> +	INIT_WORK(&psdata->work, ps_work_func);
> +
> +	return 0;
> +}
> +
> +static void ps_init_timer(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	psdata->timer_on = 0;
> +	timer_setup(&psdata->ps_timer, ps_timeout_func, 0);
> +}
> +
> +static int ps_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +	int ret = 1;
> +
> +	if (psdata->ps_state == PS_STATE_AWAKE)
> +		ret = 0;
> +	psdata->ps_cmd = PS_CMD_EXIT_PS;
> +	schedule_work(&psdata->work);
> +
> +	return ret;
> +}
> +
> +static int send_ps_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 pcmd;
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	if (psdata->ps_mode == PS_MODE_ENABLE)
> +		pcmd = BT_PS_ENABLE;
> +	else
> +		pcmd = BT_PS_DISABLE;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd);
> +
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +
> +	if (status) {
> +		if (!*status)
> +			psdata->cur_psmode = psdata->ps_mode;
> +		else
> +			psdata->ps_mode = psdata->cur_psmode;
> +		if (psdata->cur_psmode == PS_MODE_ENABLE)
> +			ps_start_timer(nxpdev);
> +		else
> +			ps_wakeup(nxpdev);
> +		BT_INFO("Power Save mode response: status=%d, ps_mode=%d",
> +			*status, psdata->cur_psmode);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +static int send_wakeup_method_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 pcmd[4];
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	pcmd[0] = BT_HOST_WAKEUP_METHOD_NONE;
> +	pcmd[1] = BT_HOST_WAKEUP_DEFAULT_GPIO;
> +	switch (psdata->wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		pcmd[2] = BT_CTRL_WAKEUP_METHOD_DSR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		pcmd[2] = BT_CTRL_WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +	pcmd[3] = 0xFF;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_WAKEUP_METHOD, 4, pcmd);
> +
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting wake-up method failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0)
> +			psdata->cur_wakeupmode = psdata->wakeupmode;
> +		else
> +			psdata->wakeupmode = psdata->cur_wakeupmode;
> +		BT_INFO("Set Wakeup Method response: status=%d, wakeupmode=%d",
> +			*status, psdata->cur_wakeupmode);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +static int ps_init(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	serdev_device_set_tiocm(nxpdev->serdev, TIOCM_RTS, 0);
> +
> +	switch (psdata->wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		serdev_device_break_ctl(nxpdev->serdev, -1);
> +		serdev_device_break_ctl(nxpdev->serdev, 0);
> +		break;
> +	}
> +	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
> +		BT_ERR("HCI_RUNNING is not set");
> +		return -EBUSY;
> +	}
> +	if (psdata->cur_wakeupmode != psdata->wakeupmode)
> +		hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +	if (psdata->cur_psmode != psdata->ps_mode)
> +		hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +
> +	return 0;
> +}
> +
> +/* NXP Firmware Download Feature */
> +static void nxp_fw_dnld_gen_crc_table(void)
> +{
> +	int i, j;
> +	unsigned long crc_accum;
> +
> +	for (i = 0; i < 256; i++) {
> +		crc_accum = ((unsigned long)i << 24);
> +		for (j = 0; j < 8; j++) {
> +			if (crc_accum & 0x80000000L)
> +				crc_accum = (crc_accum << 1) ^ POLYNOMIAL32;
> +			else
> +				crc_accum = (crc_accum << 1);
> +		}
> +		crc32_table[i] = crc_accum;
> +	}
> +}
> +
> +static unsigned long nxp_fw_dnld_update_crc(unsigned long crc_accum,
> +										char *data_blk_ptr,
> +										int data_blk_size)
> +{
> +	unsigned long i, j;
> +
> +	for (j = 0; j < data_blk_size; j++) {
> +		i = ((unsigned long)(crc_accum >> 24) ^ *data_blk_ptr++) & 0xff;
> +		crc_accum = (crc_accum << 8) ^ crc32_table[i];
> +	}
> +	return crc_accum;
> +}
> +
> +static int nxp_download_firmware(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	const char *fw_name_dt;
> +	int err = 0;
> +
> +	nxpdev->fw_dnld_offset = 0;
> +	nxpdev->fw_sent_bytes = 0;
> +
> +	set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +	crc8_populate_msb(crc8_table, POLYNOMIAL8);
> +	nxp_fw_dnld_gen_crc_table();
> +
> +	if (!device_property_read_string(&nxpdev->serdev->dev, "firmware-name",
> +										&fw_name_dt))
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "nxp/%s",
> +					fw_name_dt);
> +	else
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +					nxp_data->fw_name);
> +
> +	BT_INFO("Request Firmware: %s", nxpdev->fw_name);
> +	err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
> +	if (err < 0) {
> +		BT_ERR("Firmware file %s not found", nxpdev->fw_name);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +	}
> +
> +	serdev_device_set_baudrate(nxpdev->serdev, nxp_data->fw_dnld_pri_baudrate);
> +	serdev_device_set_flow_control(nxpdev->serdev, 0);
> +	nxpdev->current_baudrate = nxp_data->fw_dnld_pri_baudrate;
> +	nxpdev->fw_v3_offset_correction = 0;
> +
> +	/* Wait till FW is downloaded and CTS becomes low */
> +	init_waitqueue_head(&nxpdev->suspend_wait_q);
> +	err = wait_event_interruptible_timeout(nxpdev->suspend_wait_q,
> +			!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state),
> +			msecs_to_jiffies(60000));
> +	if (err == 0) {
> +		BT_ERR("FW Download Timeout.");
> +		return -ETIMEDOUT;
> +	}
> +
> +	err = serdev_device_wait_for_cts(nxpdev->serdev, 1, 60000);
> +	if (err < 0) {
> +		BT_ERR("CTS is still high. FW Download failed.");
> +		return err;
> +	}
> +	BT_INFO("CTS is low");
> +	release_firmware(nxpdev->fw);
> +
> +	/* Allow the downloaded FW to initialize */
> +	usleep_range(20000, 22000);
> +
> +	return 0;
> +}
> +
> +static int nxp_send_ack(u8 ack, struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	u8 ack_nak[2];
> +
> +	if (ack == NXP_ACK_V1 || ack == NXP_NAK_V1) {
> +		ack_nak[0] = ack;
> +		serdev_device_write_buf(nxpdev->serdev, ack_nak, 1);
> +	} else if (ack == NXP_ACK_V3) {
> +		ack_nak[0] = ack;
> +		ack_nak[1] = crc8(crc8_table, ack_nak, 1, 0xFF);
> +		serdev_device_write_buf(nxpdev->serdev, ack_nak, 2);
> +	}
> +	return 0;
> +}
> +
> +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct nxp_bootloader_cmd nxp_cmd5;
> +	struct uart_config uart_config;
> +
> +	if (req_len == sizeof(nxp_cmd5)) {
> +		nxp_cmd5.header = __cpu_to_le32(5);
> +		nxp_cmd5.arg = 0;
> +		nxp_cmd5.payload_len = __cpu_to_le32(sizeof(uart_config));
> +		nxp_cmd5.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +									 (char *)&nxp_cmd5,
> +									 sizeof(nxp_cmd5) - 4));
> +
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd5, req_len);
> +		nxpdev->fw_v3_offset_correction += req_len;
> +	} else if (req_len == sizeof(uart_config)) {
> +		uart_config.clkdiv.address = __cpu_to_le32(CLKDIVADDR);
> +		uart_config.clkdiv.value = __cpu_to_le32(0x00C00000);
> +		uart_config.uartdiv.address = __cpu_to_le32(UARTDIVADDR);
> +		uart_config.uartdiv.value = __cpu_to_le32(1);
> +		uart_config.mcr.address = __cpu_to_le32(UARTMCRADDR);
> +		uart_config.mcr.value = __cpu_to_le32(MCR);
> +		uart_config.re_init.address = __cpu_to_le32(UARTREINITADDR);
> +		uart_config.re_init.value = __cpu_to_le32(INIT);
> +		uart_config.icr.address = __cpu_to_le32(UARTICRADDR);
> +		uart_config.icr.value = __cpu_to_le32(ICR);
> +		uart_config.fcr.address = __cpu_to_le32(UARTFCRADDR);
> +		uart_config.fcr.value = __cpu_to_le32(FCR);
> +		uart_config.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +										(char *)&uart_config,
> +										sizeof(uart_config) - 4));
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_config, req_len);
> +		serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +		nxpdev->fw_v3_offset_correction += req_len;
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static bool nxp_fw_change_timeout(struct hci_dev *hdev, u16 req_len)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct nxp_bootloader_cmd nxp_cmd7;
> +
> +	if (req_len == sizeof(nxp_cmd7)) {
> +		nxp_cmd7.header = __cpu_to_le32(7);
> +		nxp_cmd7.arg = __cpu_to_le32(0x70);
> +		nxp_cmd7.payload_len = 0;
> +		nxp_cmd7.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +										(char *)&nxp_cmd7,
> +										sizeof(nxp_cmd7) - 4));
> +
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7, req_len);
> +		serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +		nxpdev->fw_v3_offset_correction += req_len;
> +		return true;
> +	}
> +	return false;
> +}
> +
> +
> +static u32 nxp_get_data_len(const u8 *buf)
> +{
> +	struct nxp_bootloader_cmd *hdr = (struct nxp_bootloader_cmd *)buf;
> +	return __le32_to_cpu(hdr->payload_len);
> +}
> +
> +/* for legacy chipsets with V1 bootloader */
> +static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct v1_data_req *req = skb_pull_data(skb, sizeof(struct v1_data_req));
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	static bool timeout_changed;
> +	static bool baudrate_changed;
> +	u32 requested_len;
> +	static u32 expected_len = HDR_LEN;
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	if (!nxpdev->fw)
> +		goto ret;
> +
> +	if (req && (req->len ^ req->len_comp) != 0xffff) {
> +		BT_INFO("ERR: Send NAK");
> +		nxp_send_ack(NXP_NAK_V1, hdev);
> +		goto ret;
> +	}
> +
> +	if (nxp_data->fw_dnld_sec_baudrate != nxpdev->current_baudrate) {
> +		if (!timeout_changed) {
> +			nxp_send_ack(NXP_ACK_V1, hdev);
> +			timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto ret;
> +		}
> +		if (!baudrate_changed) {
> +			nxp_send_ack(NXP_ACK_V1, hdev);
> +			baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +								nxp_data->fw_dnld_sec_baudrate);
> +				nxpdev->current_baudrate = nxp_data->fw_dnld_sec_baudrate;
> +			}
> +			goto ret;
> +		}
> +	}
> +
> +	nxp_send_ack(NXP_ACK_V1, hdev);
> +	requested_len = req->len;
> +	if (requested_len == 0) {
> +		BT_INFO("FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->suspend_wait_q);
> +		goto ret;
> +	}
> +	if (requested_len & 0x01) {
> +		/* The CRC did not match at the other end.
> +		* That's why the request to re-send.
> +		* Simply send the same bytes again.
> +		*/
> +		requested_len = nxpdev->fw_sent_bytes;
> +		BT_ERR("CRC error. Resend %d bytes of FW.", requested_len);
> +	} else {
> +		/* The FW bin file is made up of many blocks of
> +		* 16 byte header and payload data chunks. If the
> +		* FW has requested a header, read the payload length
> +		* info from the header, before sending the header.
> +		* In the next iteration, the FW should request the
> +		* payload data chunk, which should be equal to the
> +		* payload length read from header. If there is a
> +		* mismatch, clearly the driver and FW are out of sync,
> +		* and we need to re-send the previous chunk again.
> +		*/
> +		if (requested_len == expected_len) {
> +			/* All OK here. Increment offset by number
> +			* of previous successfully sent bytes.
> +			*/
> +			nxpdev->fw_dnld_offset += nxpdev->fw_sent_bytes;
> +
> +			if (requested_len == HDR_LEN)
> +				expected_len = nxp_get_data_len(nxpdev->fw->data +
> +									nxpdev->fw_dnld_offset);
> +			else
> +				expected_len = HDR_LEN;
> +		}
> +	}
> +
> +	if (nxpdev->fw_dnld_offset + requested_len <= nxpdev->fw->size)
> +		serdev_device_write_buf(nxpdev->serdev,
> +				nxpdev->fw->data + nxpdev->fw_dnld_offset,
> +				requested_len);
> +	nxpdev->fw_sent_bytes = requested_len;
> +
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct v3_start_ind *req = skb_pull_data(skb, sizeof(struct v3_start_ind));
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	if (!req)
> +		goto ret;
> +
> +	if (req->chip_id != nxp_data->chip_signature) {
> +		BT_ERR("Invalid chip signature received");
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +	} else {
> +		nxp_send_ack(NXP_ACK_V3, hdev);
> +	}
> +
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct v3_data_req *req = skb_pull_data(skb, sizeof(struct v3_data_req));
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	static bool timeout_changed;
> +	static bool baudrate_changed;
> +
> +	if (!req || !nxpdev || !nxpdev->fw->data)
> +		goto ret;
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	nxp_send_ack(NXP_ACK_V3, hdev);
> +
> +	if (nxpdev->current_baudrate != nxp_data->fw_dnld_sec_baudrate) {
> +		if (!timeout_changed) {
> +			timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto ret;
> +		}
> +
> +		if (!baudrate_changed) {
> +			baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +								nxp_data->fw_dnld_sec_baudrate);
> +				nxpdev->current_baudrate = nxp_data->fw_dnld_sec_baudrate;
> +			}
> +			goto ret;
> +		}
> +	}
> +
> +	if (req->len == 0) {
> +		BT_INFO("FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->suspend_wait_q);
> +		goto ret;
> +	}
> +	if (req->error)
> +		BT_ERR("FW Download received err 0x%02X from chip. Resending FW chunk.",
> +			   req->error);
> +
> +	if (req->offset < nxpdev->fw_v3_offset_correction) {
> +		/* This scenario should ideally never occur.
> +		 * But if it ever does, FW is out of sync and
> +		 * needs a power cycle.
> +		 */
> +		BT_ERR("Something went wrong during FW download. Please power cycle and try again");
> +		goto ret;
> +	}
> +
> +	serdev_device_write_buf(nxpdev->serdev,
> +				nxpdev->fw->data + req->offset - nxpdev->fw_v3_offset_correction,
> +				req->len);
> +
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_set_baudrate_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	u32 new_baudrate = __cpu_to_le32(nxpdev->new_baudrate);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 *pcmd = (u8 *)&new_baudrate;
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	if (!psdata)
> +		return -EFAULT;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_SET_OPER_SPEED, 4, pcmd);
> +
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting baudrate failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0) {
> +			serdev_device_set_baudrate(nxpdev->serdev, nxpdev->new_baudrate);
> +			nxpdev->current_baudrate = nxpdev->new_baudrate;
> +		}
> +		BT_INFO("Set baudrate response: status=%d, baudrate=%d",
> +			*status, nxpdev->new_baudrate);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +/* NXP protocol */
> +static int nxp_setup(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	int ret = 0;
> +
> +	if (!serdev_device_get_cts(nxpdev->serdev)) {
> +		BT_INFO("CTS high. Need FW Download");
> +		ret = nxp_download_firmware(hdev);
> +		if (ret < 0)
> +			goto err;
> +	} else {
> +		BT_INFO("CTS low. FW already running.");
> +	}
> +
> +	serdev_device_set_flow_control(nxpdev->serdev, 1);
> +	serdev_device_set_baudrate(nxpdev->serdev, nxp_data->fw_init_baudrate);
> +	nxpdev->current_baudrate = nxp_data->fw_init_baudrate;
> +
> +	if (nxpdev->current_baudrate != nxp_data->oper_speed) {
> +		nxpdev->new_baudrate = nxp_data->oper_speed;
> +		hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +	}
> +
> +	if (!ps_init_work(hdev))
> +		ps_init_timer(hdev);
> +	ps_init(hdev);
> +err:
> +	return ret;
> +}
> +
> +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	struct hci_command_hdr *hdr;
> +	u8 *param;
> +
> +	if (!psdata) {
> +		kfree_skb(skb);
> +		goto ret;
> +	}
> +
> +	/* if commands are received from user space (e.g. hcitool), update
> +	 * driver flags accordingly and ask driver to re-send the command
> +	 */
> +	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata->driver_sent_cmd) {
> +		hdr = (struct hci_command_hdr *)skb->data;
> +		param = skb->data + HCI_COMMAND_HDR_SIZE;
> +		switch (__le16_to_cpu(hdr->opcode)) {
> +		case HCI_NXP_AUTO_SLEEP_MODE:
> +			if (hdr->plen >= 1) {
> +				if (param[0] == BT_PS_ENABLE)
> +					psdata->ps_mode = PS_MODE_ENABLE;
> +				else if (param[0] == BT_PS_DISABLE)
> +					psdata->ps_mode = PS_MODE_DISABLE;
> +				hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +				kfree_skb(skb);
> +				goto ret;
> +			}
> +			break;
> +		case HCI_NXP_WAKEUP_METHOD:
> +			if (hdr->plen >= 4) {
> +				switch (param[2]) {
> +				case BT_CTRL_WAKEUP_METHOD_DSR:
> +					psdata->wakeupmode = WAKEUP_METHOD_DTR;
> +					break;
> +				case BT_CTRL_WAKEUP_METHOD_BREAK:
> +				default:
> +					psdata->wakeupmode = WAKEUP_METHOD_BREAK;
> +					break;
> +				}
> +				hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +				kfree_skb(skb);
> +				goto ret;
> +			}
> +			break;
> +		case HCI_NXP_SET_OPER_SPEED:
> +			if (hdr->plen == 4) {
> +				nxpdev->new_baudrate = *((u32 *)param);
> +				hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +				kfree_skb(skb);
> +				goto ret;
> +			}
> +		}
> +	}
> +
> +	/* Prepend skb with frame type */
> +	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> +	skb_queue_tail(&nxpdev->txq, skb);
> +
> +	btnxpuart_tx_wakeup(nxpdev);
> +ret:
> +	return 0;
> +}
> +
> +static struct sk_buff *nxp_dequeue(void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = (struct btnxpuart_dev *)data;
> +
> +	ps_wakeup(nxpdev);
> +	ps_start_timer(nxpdev);
> +	return skb_dequeue(&nxpdev->txq);
> +}
> +
> +/* btnxpuart based on serdev */
> +static void btnxpuart_tx_work(struct work_struct *work)
> +{
> +	struct btnxpuart_dev *nxpdev = container_of(work, struct btnxpuart_dev,
> +						   tx_work);
> +	struct serdev_device *serdev = nxpdev->serdev;
> +	struct hci_dev *hdev = nxpdev->hdev;
> +
> +	if (!nxpdev->nxp_data->dequeue)

Never true.

> +		return;
> +
> +	while (1) {
> +		clear_bit(BTNXPUART_TX_STATE_WAKEUP, &nxpdev->tx_state);
> +
> +		while (1) {
> +			struct sk_buff *skb = nxpdev->nxp_data->dequeue(nxpdev);
> +			int len;
> +
> +			if (!skb)
> +				break;
> +
> +			len = serdev_device_write_buf(serdev, skb->data, skb->len);
> +			hdev->stat.byte_tx += len;
> +
> +			skb_pull(skb, len);
> +			if (skb->len > 0) {
> +				skb_queue_head(&nxpdev->txq, skb);
> +				break;
> +			}
> +
> +			switch (hci_skb_pkt_type(skb)) {
> +			case HCI_COMMAND_PKT:
> +				hdev->stat.cmd_tx++;
> +				break;
> +			case HCI_ACLDATA_PKT:
> +				hdev->stat.acl_tx++;
> +				break;
> +			case HCI_SCODATA_PKT:
> +				hdev->stat.sco_tx++;
> +				break;
> +			}
> +
> +			kfree_skb(skb);
> +		}
> +
> +		if (!test_bit(BTNXPUART_TX_STATE_WAKEUP, &nxpdev->tx_state))
> +			break;
> +	}
> +	clear_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
> +}
> +
> +static void btnxpuart_tx_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	if (test_and_set_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
> +		set_bit(BTNXPUART_TX_STATE_WAKEUP, &nxpdev->tx_state);
> +		return;
> +	}
> +	schedule_work(&nxpdev->tx_work);
> +}
> +
> +static int btnxpuart_open(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err;
> +
> +	err = serdev_device_open(nxpdev->serdev);
> +	if (err) {
> +		bt_dev_err(hdev, "Unable to open UART device %s",
> +			   dev_name(&nxpdev->serdev->dev));
> +		return err;
> +	}
> +
> +	if (nxpdev->nxp_data->open) {
> +		err = nxpdev->nxp_data->open(hdev);
> +		if (err) {
> +			serdev_device_close(nxpdev->serdev);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int btnxpuart_close(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err;
> +
> +	if (nxpdev->nxp_data->close) {
> +		err = nxpdev->nxp_data->close(hdev);
> +		if (err)
> +			return err;
> +	}
> +
> +	serdev_device_close(nxpdev->serdev);
> +
> +	return 0;
> +}
> +
> +static int btnxpuart_flush(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	/* Flush any pending characters */
> +	serdev_device_write_flush(nxpdev->serdev);
> +	skb_queue_purge(&nxpdev->txq);
> +
> +	cancel_work_sync(&nxpdev->tx_work);
> +
> +	kfree_skb(nxpdev->rx_skb);
> +	nxpdev->rx_skb = NULL;
> +
> +	return 0;
> +}
> +
> +static int btnxpuart_setup(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (nxpdev->nxp_data->setup)
> +		return nxpdev->nxp_data->setup(hdev);
> +
> +	return 0;
> +}
> +
> +static int btnxpuart_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (nxpdev->nxp_data->enqueue)
> +		nxpdev->nxp_data->enqueue(hdev, skb);
> +
> +	return 0;
> +}
> +
> +static int btnxpuart_receive_buf(struct serdev_device *serdev, const u8 *data,
> +								 size_t count)
> +{
> +	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +
> +	if (test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state)) {
> +		if (*data != NXP_V1_FW_REQ_PKT && *data != NXP_V1_CHIP_VER_PKT &&
> +		   *data != NXP_V3_FW_REQ_PKT && *data != NXP_V3_CHIP_VER_PKT) {
> +			/* Unknown bootloader signature, skip without returning error */
> +			return count;
> +		}
> +	}
> +
> +	ps_start_timer(nxpdev);
> +
> +	nxpdev->rx_skb = h4_recv_buf(nxpdev->hdev, nxpdev->rx_skb, data, count,
> +						nxp_data->recv_pkts, nxp_data->recv_pkts_cnt);
> +	if (IS_ERR(nxpdev->rx_skb)) {
> +		int err = PTR_ERR(nxpdev->rx_skb);
> +
> +		bt_dev_err(nxpdev->hdev, "Frame reassembly failed (%d)", err);
> +		nxpdev->rx_skb = NULL;
> +		return err;
> +	}
> +	nxpdev->hdev->stat.byte_rx += count;
> +	return count;
> +}
> +
> +static void btnxpuart_write_wakeup(struct serdev_device *serdev)
> +{
> +	serdev_device_write_wakeup(serdev);
> +}
> +
> +static const struct serdev_device_ops btnxpuart_client_ops = {
> +	.receive_buf = btnxpuart_receive_buf,
> +	.write_wakeup = btnxpuart_write_wakeup,
> +};
> +
> +static int nxp_serdev_probe(struct serdev_device *serdev)
> +{
> +	struct hci_dev *hdev;
> +	struct btnxpuart_dev *nxpdev;
> +
> +	nxpdev = devm_kzalloc(&serdev->dev, sizeof(*nxpdev), GFP_KERNEL);
> +	if (!nxpdev)
> +		return -ENOMEM;
> +
> +	nxpdev->nxp_data = device_get_match_data(&serdev->dev);
> +
> +	nxpdev->serdev = serdev;
> +	serdev_device_set_drvdata(serdev, nxpdev);
> +
> +	serdev_device_set_client_ops(serdev, &btnxpuart_client_ops);
> +
> +	INIT_WORK(&nxpdev->tx_work, btnxpuart_tx_work);
> +	skb_queue_head_init(&nxpdev->txq);
> +
> +	/* Initialize and register HCI device */
> +	hdev = hci_alloc_dev();
> +	if (!hdev) {
> +		dev_err(&serdev->dev, "Can't allocate HCI device\n");
> +		return -ENOMEM;
> +	}
> +
> +	nxpdev->hdev = hdev;
> +
> +	hdev->bus = HCI_UART;
> +	hci_set_drvdata(hdev, nxpdev);
> +
> +	hdev->manufacturer = 37;
> +	hdev->open  = btnxpuart_open;
> +	hdev->close = btnxpuart_close;
> +	hdev->flush = btnxpuart_flush;
> +	hdev->setup = btnxpuart_setup;
> +	hdev->send  = btnxpuart_send_frame;
> +	SET_HCIDEV_DEV(hdev, &serdev->dev);
> +
> +	if (hci_register_dev(hdev) < 0) {
> +		dev_err(&serdev->dev, "Can't register HCI device\n");
> +		hci_free_dev(hdev);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static void nxp_serdev_remove(struct serdev_device *serdev)
> +{
> +	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
> +	const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	struct hci_dev *hdev = nxpdev->hdev;
> +
> +	/* Restore FW baudrate to fw_init_baudrate if changed.
> +	 * This will ensure FW baudrate is in sync with
> +	 * driver baudrate in case this driver is re-inserted.
> +	 */
> +	if (nxp_data->fw_init_baudrate != nxpdev->current_baudrate) {
> +		nxpdev->new_baudrate = nxp_data->fw_init_baudrate;
> +		nxp_set_baudrate_cmd(hdev, NULL);
> +	}
> +
> +	ps_cancel_timer(nxpdev);
> +	hci_unregister_dev(hdev);
> +	hci_free_dev(hdev);
> +}
> +
> +static const struct h4_recv_pkt nxp_recv_pkts[] = {
> +	{ H4_RECV_ACL,          .recv = hci_recv_frame },
> +	{ H4_RECV_SCO,          .recv = hci_recv_frame },
> +	{ H4_RECV_EVENT,        .recv = hci_recv_frame },
> +	{ NXP_RECV_FW_REQ_V1,   .recv = nxp_recv_fw_req_v1 },
> +	{ NXP_RECV_CHIP_VER_V3, .recv = nxp_recv_chip_ver_v3 },
> +	{ NXP_RECV_FW_REQ_V3,   .recv = nxp_recv_fw_req_v3 },
> +};
> +
> +static const struct btnxpuart_data w8987_data = {
> +	.recv_pkts	= nxp_recv_pkts,
> +	.recv_pkts_cnt	= ARRAY_SIZE(nxp_recv_pkts),
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.setup		= nxp_setup,
> +	.enqueue    = nxp_enqueue,
> +	.dequeue    = nxp_dequeue,
> +	.chip_signature = 0xffff,
> +	.fw_name = FIRMWARE_W8987,
> +};
> +
> +static const struct btnxpuart_data w8997_data = {
> +	.recv_pkts	= nxp_recv_pkts,
> +	.recv_pkts_cnt	= ARRAY_SIZE(nxp_recv_pkts),
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.setup		= nxp_setup,
> +	.enqueue    = nxp_enqueue,
> +	.dequeue    = nxp_dequeue,
> +	.chip_signature = 0xffff,
> +	.fw_name = FIRMWARE_W8997,
> +};
> +
> +static const struct btnxpuart_data w9098_data = {
> +	.recv_pkts	= nxp_recv_pkts,
> +	.recv_pkts_cnt	= ARRAY_SIZE(nxp_recv_pkts),
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 3000000,
> +	.oper_speed		= 3000000,
> +	.setup		= nxp_setup,
> +	.enqueue    = nxp_enqueue,
> +	.dequeue    = nxp_dequeue,
> +	.chip_signature = 0x5c03,
> +	.fw_name = FIRMWARE_W9098,
> +};
> +
> +static const struct btnxpuart_data iw416_data = {
> +	.recv_pkts	= nxp_recv_pkts,
> +	.recv_pkts_cnt	= ARRAY_SIZE(nxp_recv_pkts),
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 3000000,
> +	.oper_speed		= 3000000,
> +	.setup		= nxp_setup,
> +	.enqueue    = nxp_enqueue,
> +	.dequeue    = nxp_dequeue,
> +	.chip_signature = 0x7201,
> +	.fw_name = FIRMWARE_IW416,
> +};
> +
> +static const struct btnxpuart_data iw612_data = {

> +	.recv_pkts	= nxp_recv_pkts,

> +	.setup		= nxp_setup,
> +	.enqueue    = nxp_enqueue,
> +	.dequeue    = nxp_dequeue,

These are always the same functions. Just call them directly.

> +	.chip_signature = 0x7601,
> +	.fw_name = FIRMWARE_IW612,
> +};
> +
> +#ifdef CONFIG_OF

This driver only supports DT, so you don't need this ifdef.

> +static const struct of_device_id nxpuart_of_match_table[] = {
> +	{ .compatible = "nxp,w8987-bt", .data = &w8987_data },
> +	{ .compatible = "nxp,w8997-bt", .data = &w8997_data },
> +	{ .compatible = "nxp,w9098-bt", .data = &w9098_data },
> +	{ .compatible = "nxp,iw416-bt", .data = &iw416_data },
> +	{ .compatible = "nxp,iw612-bt", .data = &iw612_data },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, nxpuart_of_match_table);
> +#endif
> +
> +static struct serdev_device_driver nxp_serdev_driver = {
> +	.probe = nxp_serdev_probe,
> +	.remove = nxp_serdev_remove,
> +	.driver = {
> +		.name = "btnxpuart",
> +		.of_match_table = of_match_ptr(nxpuart_of_match_table),
> +	},
> +};
> +
> +module_serdev_device_driver(nxp_serdev_driver);
> +
> +MODULE_AUTHOR("Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>");
> +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
> +MODULE_VERSION("v1.0");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/bluetooth/btnxpuart.h b/drivers/bluetooth/btnxpuart.h
> new file mode 100644
> index 000000000000..105204ef88f1
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.h

This header is only included by 1 .c file, move it all there.

> @@ -0,0 +1,227 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP
> + *
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef BT_NXP_H_
> +#define BT_NXP_H_
> +
> +#define FIRMWARE_W8987	"nxp/uartuart8987_bt.bin"
> +#define FIRMWARE_W8997	"nxp/uartuart8997_bt_v4.bin"
> +#define FIRMWARE_W9098	"nxp/uartuart9098_bt_v1.bin"
> +#define FIRMWARE_IW416	"nxp/uartuart_iw416_bt.bin"
> +#define FIRMWARE_IW612	"nxp/uartspi_n61x_v1.bin"
> +
> +#define MAX_CHIP_NAME_LEN       20
> +#define MAX_FW_FILE_NAME_LEN    50
> +#define MAX_NO_OF_CHIPS_SUPPORT 20
> +
> +/* Default ps timeout period in milli-second */
> +#define PS_DEFAULT_TIMEOUT_PERIOD     2000
> +
> +/* wakeup methods */
> +#define WAKEUP_METHOD_DTR       0
> +#define WAKEUP_METHOD_BREAK     1
> +#define WAKEUP_METHOD_EXT_BREAK 2
> +#define WAKEUP_METHOD_RTS       3
> +#define WAKEUP_METHOD_INVALID   0xff
> +
> +/* power save mode status */
> +#define PS_MODE_DISABLE         0
> +#define PS_MODE_ENABLE          1
> +
> +/* Power Save Commands to ps_work_func  */
> +#define PS_CMD_EXIT_PS          1
> +#define PS_CMD_ENTER_PS         2
> +
> +/* power save state */
> +#define PS_STATE_AWAKE          0
> +#define PS_STATE_SLEEP          1
> +
> +/* Bluetooth vendor command : Sleep mode */
> +#define HCI_NXP_AUTO_SLEEP_MODE	0xfc23
> +/* Bluetooth vendor command : Wakeup method */
> +#define HCI_NXP_WAKEUP_METHOD	0xfc53
> +/* Bluetooth vendor command : Set operational baudrate */
> +#define HCI_NXP_SET_OPER_SPEED	0xfc09
> +
> +/* Bluetooth Power State : Vendor cmd params */
> +#define BT_PS_ENABLE			0x02
> +#define BT_PS_DISABLE			0x03
> +
> +/* Bluetooth Host Wakeup Methods */
> +#define BT_HOST_WAKEUP_METHOD_NONE      0x00
> +#define BT_HOST_WAKEUP_METHOD_DTR       0x01
> +#define BT_HOST_WAKEUP_METHOD_BREAK     0x02
> +#define BT_HOST_WAKEUP_METHOD_GPIO      0x03
> +#define BT_HOST_WAKEUP_DEFAULT_GPIO     5
> +
> +/* Bluetooth Chip Wakeup Methods */
> +#define BT_CTRL_WAKEUP_METHOD_DSR       0x00
> +#define BT_CTRL_WAKEUP_METHOD_BREAK     0x01
> +#define BT_CTRL_WAKEUP_METHOD_GPIO      0x02
> +#define BT_CTRL_WAKEUP_METHOD_EXT_BREAK 0x04
> +#define BT_CTRL_WAKEUP_METHOD_RTS       0x05
> +#define BT_CTRL_WAKEUP_DEFAULT_GPIO     4
> +
> +struct ps_data {
> +	u8    ps_mode;
> +	u8    cur_psmode;
> +	u8    ps_state;
> +	u8    ps_cmd;
> +	u8    wakeupmode;
> +	u8    cur_wakeupmode;
> +	bool  driver_sent_cmd;
> +	u8    timer_on;
> +	u32   interval;
> +	struct hci_dev *hdev;
> +	struct work_struct work;
> +	struct timer_list ps_timer;
> +};
> +
> +struct btnxpuart_data {
> +	const struct h4_recv_pkt *recv_pkts;
> +	int recv_pkts_cnt;
> +	int (*open)(struct hci_dev *hdev);
> +	int (*close)(struct hci_dev *hdev);
> +	int (*setup)(struct hci_dev *hdev);
> +	int (*enqueue)(struct hci_dev *hdev, struct sk_buff *skb);
> +	struct sk_buff *(*dequeue)(void *data);
> +	u32 fw_dnld_pri_baudrate;
> +	u32 fw_dnld_sec_baudrate;
> +	u32 fw_init_baudrate;
> +	u32 oper_speed;
> +	u16 chip_signature;
> +	const u8 *fw_name;
> +};
> +
> +struct btnxpuart_dev {
> +	struct hci_dev *hdev;
> +	struct serdev_device *serdev;
> +
> +	struct work_struct tx_work;
> +	unsigned long tx_state;
> +	struct sk_buff_head txq;
> +	struct sk_buff *rx_skb;
> +
> +	const struct firmware *fw;
> +	u8 fw_name[MAX_FW_FILE_NAME_LEN];
> +	u32 fw_dnld_offset;
> +	u32 fw_sent_bytes;
> +	u32 fw_v3_offset_correction;
> +	wait_queue_head_t suspend_wait_q;
> +
> +	u32 new_baudrate;
> +	u32 current_baudrate;
> +
> +	struct ps_data *psdata;
> +	const struct btnxpuart_data *nxp_data;
> +};
> +
> +#define NXP_V1_FW_REQ_PKT      0xa5
> +#define NXP_V1_CHIP_VER_PKT    0xaa
> +#define NXP_V3_FW_REQ_PKT      0xa7
> +#define NXP_V3_CHIP_VER_PKT    0xab
> +
> +#define NXP_ACK_V1             0x5a
> +#define NXP_NAK_V1             0xbf
> +#define NXP_ACK_V3             0x7a
> +#define NXP_NAK_V3             0x7b
> +#define NXP_CRC_ERROR_V3       0x7c
> +
> +#define HDR_LEN					16
> +
> +#define NXP_RECV_FW_REQ_V1 \
> +	.type = NXP_V1_FW_REQ_PKT, \
> +	.hlen = 4, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 4
> +
> +#define NXP_RECV_CHIP_VER_V3 \
> +	.type = NXP_V3_CHIP_VER_PKT, \
> +	.hlen = 4, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 4
> +
> +#define NXP_RECV_FW_REQ_V3 \
> +	.type = NXP_V3_FW_REQ_PKT, \
> +	.hlen = 9, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 9
> +
> +struct v1_data_req {
> +	__le16 len;
> +	__le16 len_comp;
> +} __packed;
> +
> +struct v3_data_req {
> +	__le16 len;
> +	__le32 offset;
> +	__le16 error;
> +	u8 crc;
> +} __packed;
> +
> +struct v3_start_ind {
> +	__le16 chip_id;
> +	u8 loader_ver;
> +	u8 crc;
> +} __packed;
> +
> +/* UART register addresses of BT chip */
> +#define CLKDIVADDR       0x7f00008f
> +#define UARTDIVADDR      0x7f000090
> +#define UARTMCRADDR      0x7f000091
> +#define UARTREINITADDR   0x7f000092
> +#define UARTICRADDR      0x7f000093
> +#define UARTFCRADDR      0x7f000094
> +
> +#define MCR   0x00000022
> +#define INIT  0x00000001
> +#define ICR   0x000000c7
> +#define FCR   0x000000c7
> +
> +#define POLYNOMIAL8				0x07
> +#define POLYNOMIAL32			0x04c11db7L
> +
> +struct uart_reg {
> +	__le32 address;
> +	__le32 value;
> +} __packed;
> +
> +struct uart_config {
> +	struct uart_reg clkdiv;
> +	struct uart_reg uartdiv;
> +	struct uart_reg mcr;
> +	struct uart_reg re_init;
> +	struct uart_reg icr;
> +	struct uart_reg fcr;
> +	__le32 crc;
> +} __packed;
> +
> +struct nxp_bootloader_cmd {
> +	__le32 header;
> +	__le32 arg;
> +	__le32 payload_len;
> +	__le32 crc;
> +} __packed;
> +
> +static void btnxpuart_tx_wakeup(struct btnxpuart_dev *nxpdev);
> +
> +#endif
> -- 
> 2.34.1
> 
