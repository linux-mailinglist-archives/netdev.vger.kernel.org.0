Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758452C0144
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgKWITq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:19:46 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41033 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKWITq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:19:46 -0500
Received: by mail-ed1-f65.google.com with SMTP id t9so16140805edq.8;
        Mon, 23 Nov 2020 00:19:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vGHEv9tO/TuylPKziKq+WNYNan9WllujiyJ2jgN6u4c=;
        b=ZWwb+RJ8BLMdi86ulY/XSFJ132pR719ZB+1L+ditgobp65tN/dsjKJFmSrHv6caYnu
         Ju74IGYBIcTlMPU/j+abFYTPcdFGMmEK6zcNYYy4NUDG1DpXniNtDOJieSAHlXJw0pw5
         b4Thhu/sIg/c7NFuR8fLbSXAYdPCDk187gxLsFSIKURP50lKMQneFDDcw+BOxZT42c4b
         3cG4eYrFpMo2uhtWqhfCAXVnd3Dm66UwCdEQUxWR0PEPOQttbitsHy/Fh5IwOhSs66mF
         cs4ZX7MQqa97I7YUyYprF2KOytSZ5bVGmCP+QRmpLQOuBD5rAy6u3UQeb+mjkqkGrVHW
         DuHA==
X-Gm-Message-State: AOAM530QDrFzZHyEu0jo5xBVSoh2pPscXuQjtGEcPnA0ONzJ2f5Ub3rV
        CZsL4YvnDbtcvZ7vYr3m9do=
X-Google-Smtp-Source: ABdhPJzjbkWc6uWsPqF+tYZNsTY0q8W9kDTcHzlKde+Vbda30Si58oOoq+NJaPx8hiDSCqnW57MAOQ==
X-Received: by 2002:aa7:d3cc:: with SMTP id o12mr5276583edr.331.1606119582909;
        Mon, 23 Nov 2020 00:19:42 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id bx21sm4531740ejc.26.2020.11.23.00.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 00:19:41 -0800 (PST)
Date:   Mon, 23 Nov 2020 09:19:40 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: nfc: s3fwrn5: Support a UART interface
Message-ID: <20201123081940.GA9323@kozik-lap>
References: <CGME20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
 <20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 04:56:58PM +0900, Bongsu Jeon wrote:
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 uses NCI protocol and supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Please start sending emails properly, e.g. with git send-email, so all
your patches in the patchset are referencing the first patch.

> ---
>  drivers/nfc/s3fwrn5/Kconfig  |  12 ++
>  drivers/nfc/s3fwrn5/Makefile |   2 +
>  drivers/nfc/s3fwrn5/uart.c   | 250 +++++++++++++++++++++++++++++++++++
>  3 files changed, 264 insertions(+)
>  create mode 100644 drivers/nfc/s3fwrn5/uart.c
> 
> diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
> index 3f8b6da58280..6f88737769e1 100644
> --- a/drivers/nfc/s3fwrn5/Kconfig
> +++ b/drivers/nfc/s3fwrn5/Kconfig
> @@ -20,3 +20,15 @@ config NFC_S3FWRN5_I2C
>  	  To compile this driver as a module, choose m here. The module will
>  	  be called s3fwrn5_i2c.ko.
>  	  Say N if unsure.
> +
> +config NFC_S3FWRN82_UART
> +	tristate "Samsung S3FWRN82 UART support"
> +	depends on NFC_NCI && SERIAL_DEV_BUS

What about SERIAL_DEV_BUS as module? Shouldn't this be
SERIAL_DEV_BUS || !SERIAL_DEV_BUS?

> +	select NFC_S3FWRN5
> +	help
> +	  This module adds support for a UART interface to the S3FWRN82 chip.
> +	  Select this if your platform is using the UART bus.
> +
> +	  To compile this driver as a module, choose m here. The module will
> +	  be called s3fwrn82_uart.ko.
> +	  Say N if unsure.
> diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
> index d0ffa35f50e8..d1902102060b 100644
> --- a/drivers/nfc/s3fwrn5/Makefile
> +++ b/drivers/nfc/s3fwrn5/Makefile
> @@ -5,6 +5,8 @@
>  
>  s3fwrn5-objs = core.o firmware.o nci.o
>  s3fwrn5_i2c-objs = i2c.o
> +s3fwrn82_uart-objs = uart.o
>  
>  obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
>  obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
> +obj-$(CONFIG_NFC_S3FWRN82_UART) += s3fwrn82_uart.o
> diff --git a/drivers/nfc/s3fwrn5/uart.c b/drivers/nfc/s3fwrn5/uart.c
> new file mode 100644
> index 000000000000..b3c36a5b28d3
> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/uart.c
> @@ -0,0 +1,250 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * UART Link Layer for S3FWRN82 NCI based Driver
> + *
> + * Copyright (C) 2020 Samsung Electronics
> + * Author: Bongsu Jeon <bongsu.jeon@samsung.com>

You copied a lot from existing i2c.c. Please keep also the original
copyrights.

> + * All rights reserved.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/nfc.h>
> +#include <linux/netdevice.h>
> +#include <linux/of.h>
> +#include <linux/serdev.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +
> +#include "s3fwrn5.h"
> +
> +#define S3FWRN82_UART_DRIVER_NAME "s3fwrn82_uart"

Remove the define, it is used only once.

> +#define S3FWRN82_NCI_HEADER 3
> +#define S3FWRN82_NCI_IDX 2
> +#define S3FWRN82_EN_WAIT_TIME 20
> +#define NCI_SKB_BUFF_LEN 258
> +
> +struct s3fwrn82_uart_phy {
> +	struct serdev_device *ser_dev;
> +	struct nci_dev *ndev;
> +	struct sk_buff *recv_skb;
> +
> +	unsigned int gpio_en;
> +	unsigned int gpio_fw_wake;
> +
> +	/* mutex is used to synchronize */

Please do not write obvious comments. Mutex is always used to
synchronize, what else is it for? Instead you must describe what exactly
is protected with mutex.

> +	struct mutex mutex;
> +	enum s3fwrn5_mode mode;
> +};
> +
> +static void s3fwrn82_uart_set_wake(void *phy_id, bool wake)
> +{
> +	struct s3fwrn82_uart_phy *phy = phy_id;
> +
> +	mutex_lock(&phy->mutex);
> +	gpio_set_value(phy->gpio_fw_wake, wake);
> +	msleep(S3FWRN82_EN_WAIT_TIME);
> +	mutex_unlock(&phy->mutex);
> +}
> +
> +static void s3fwrn82_uart_set_mode(void *phy_id, enum s3fwrn5_mode mode)
> +{
> +	struct s3fwrn82_uart_phy *phy = phy_id;
> +
> +	mutex_lock(&phy->mutex);
> +	if (phy->mode == mode)
> +		goto out;
> +	phy->mode = mode;
> +	gpio_set_value(phy->gpio_en, 1);
> +	gpio_set_value(phy->gpio_fw_wake, 0);
> +	if (mode == S3FWRN5_MODE_FW)
> +		gpio_set_value(phy->gpio_fw_wake, 1);
> +	if (mode != S3FWRN5_MODE_COLD) {
> +		msleep(S3FWRN82_EN_WAIT_TIME);
> +		gpio_set_value(phy->gpio_en, 0);
> +		msleep(S3FWRN82_EN_WAIT_TIME);
> +	}
> +out:
> +	mutex_unlock(&phy->mutex);
> +}
> +
> +static enum s3fwrn5_mode s3fwrn82_uart_get_mode(void *phy_id)
> +{
> +	struct s3fwrn82_uart_phy *phy = phy_id;
> +	enum s3fwrn5_mode mode;
> +
> +	mutex_lock(&phy->mutex);
> +	mode = phy->mode;
> +	mutex_unlock(&phy->mutex);
> +	return mode;
> +}

All this duplicates I2C version. You need to start either reusing common
blocks.

> +
> +static int s3fwrn82_uart_write(void *phy_id, struct sk_buff *out)
> +{
> +	struct s3fwrn82_uart_phy *phy = phy_id;
> +	int err;
> +
> +	err = serdev_device_write(phy->ser_dev,
> +				  out->data, out->len,
> +				  MAX_SCHEDULE_TIMEOUT);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static const struct s3fwrn5_phy_ops uart_phy_ops = {
> +	.set_wake = s3fwrn82_uart_set_wake,
> +	.set_mode = s3fwrn82_uart_set_mode,
> +	.get_mode = s3fwrn82_uart_get_mode,
> +	.write = s3fwrn82_uart_write,
> +};
> +
> +static int s3fwrn82_uart_read(struct serdev_device *serdev,
> +			      const unsigned char *data,
> +			      size_t count)
> +{
> +	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> +	size_t i;
> +
> +	for (i = 0; i < count; i++) {
> +		skb_put_u8(phy->recv_skb, *data++);
> +
> +		if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
> +			continue;
> +
> +		if ((phy->recv_skb->len - S3FWRN82_NCI_HEADER)
> +				< phy->recv_skb->data[S3FWRN82_NCI_IDX])
> +			continue;
> +
> +		s3fwrn5_recv_frame(phy->ndev, phy->recv_skb, phy->mode);
> +		phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
> +		if (!phy->recv_skb)
> +			return 0;
> +	}
> +
> +	return i;
> +}
> +
> +static struct serdev_device_ops s3fwrn82_serdev_ops = {

const

> +	.receive_buf = s3fwrn82_uart_read,
> +	.write_wakeup = serdev_device_write_wakeup,
> +};
> +
> +static const struct of_device_id s3fwrn82_uart_of_match[] = {
> +	{ .compatible = "samsung,s3fwrn82-uart", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, s3fwrn82_uart_of_match);
> +
> +static int s3fwrn82_uart_parse_dt(struct serdev_device *serdev)
> +{
> +	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> +	struct device_node *np = serdev->dev.of_node;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> +	if (!gpio_is_valid(phy->gpio_en))
> +		return -ENODEV;
> +
> +	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);

You should not cast it it unsigned int. I'll fix the s3fwrn5 from which
you copied this apparently.

> +	if (!gpio_is_valid(phy->gpio_fw_wake))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int s3fwrn82_uart_probe(struct serdev_device *serdev)
> +{
> +	struct s3fwrn82_uart_phy *phy;
> +	int ret = -ENOMEM;
> +
> +	phy = devm_kzalloc(&serdev->dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy)
> +		goto err_exit;
> +
> +	phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
> +	if (!phy->recv_skb)
> +		goto err_free;
> +
> +	mutex_init(&phy->mutex);
> +	phy->mode = S3FWRN5_MODE_COLD;
> +
> +	phy->ser_dev = serdev;
> +	serdev_device_set_drvdata(serdev, phy);
> +	serdev_device_set_client_ops(serdev, &s3fwrn82_serdev_ops);
> +	ret = serdev_device_open(serdev);
> +	if (ret) {
> +		dev_err(&serdev->dev, "Unable to open device\n");
> +		goto err_skb;
> +	}
> +
> +	ret = serdev_device_set_baudrate(serdev, 115200);

Why baudrate is fixed?

> +	if (ret != 115200) {
> +		ret = -EINVAL;
> +		goto err_serdev;
> +	}
> +
> +	serdev_device_set_flow_control(serdev, false);
> +
> +	ret = s3fwrn82_uart_parse_dt(serdev);
> +	if (ret < 0)
> +		goto err_serdev;
> +
> +	ret = devm_gpio_request_one(&phy->ser_dev->dev,
> +				    phy->gpio_en,
> +				    GPIOF_OUT_INIT_HIGH,
> +				    "s3fwrn82_en");

This is weirdly wrapped.

> +	if (ret < 0)
> +		goto err_serdev;
> +
> +	ret = devm_gpio_request_one(&phy->ser_dev->dev,
> +				    phy->gpio_fw_wake,
> +				    GPIOF_OUT_INIT_LOW,
> +				    "s3fwrn82_fw_wake");
> +	if (ret < 0)
> +		goto err_serdev;
> +
> +	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->ser_dev->dev, &uart_phy_ops);
> +	if (ret < 0)
> +		goto err_serdev;
> +
> +	return ret;
> +
> +err_serdev:
> +	serdev_device_close(serdev);
> +err_skb:
> +	kfree_skb(phy->recv_skb);
> +err_free:
> +	kfree(phy);

Eee.... why? Did you test this code?

> +err_exit:
> +	return ret;
> +}
> +
> +static void s3fwrn82_uart_remove(struct serdev_device *serdev)
> +{
> +	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> +
> +	s3fwrn5_remove(phy->ndev);
> +	serdev_device_close(serdev);
> +	kfree_skb(phy->recv_skb);
> +	kfree(phy);

This does not look like tested...

Best regards,
Krzysztof
