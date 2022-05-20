Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD6352F2E4
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352678AbiETSd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347042AbiETSdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:33:24 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88A733A3A;
        Fri, 20 May 2022 11:33:22 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id s23-20020a9d7597000000b0060ae566f9a1so3408769otk.1;
        Fri, 20 May 2022 11:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DrAZZxkVrUyTHdBazulgdQCa5gihBl4sbgvdaps+um8=;
        b=VsuXuBBYifUXmaHIVEb9xbWl6/xLmhrK14OXfG8fp9HmdSnwpK4EHs9P9+cE91qMrm
         nWlyID9kJYNl5DY7kVp6mtsHXiQGPl0Sbse5OhRv/iLrwmn7rXbPPdn2NkxoRrDQTGck
         31cgpZwrwJ02NfI/XYkzhHK/aC0dc/5e/r+JnfdSlmPIk80ljmXAkJbiOT3vXLQxFEDV
         83ZEWbqj+Ay3XaNfwoQDvO0V64+ko6nFo+mz/p9SixzI9Prr8+I0RkhUHKAnZzqtdQ6+
         MyW0JvVqvE8IKn2/OQap8TWwyY8S/zhBPVFz29z7JKLa3ucvpMMg1YuZ/dLFPqaWLYJ6
         /v5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DrAZZxkVrUyTHdBazulgdQCa5gihBl4sbgvdaps+um8=;
        b=erb3I9xy97UNRF1jetscY7ZJL0QROGGF3iNen9xxB4oM0qA74UWhmOKRjvXZBNdhrh
         sG84P2YxbCrMgwwBllVcMjl5Q2kSmYHfykf+CphlhWhVWqNCeKL33fHQgCFRnAqCz1/D
         lOmpr8/LJCqB1xLAlV52aXgdzWHIIdzHnTL56cezjRli7SK5eluqMHV/9Dr6JMYBW1s9
         4PM4FUNsiCKJlAL+n9YTvOxOtxcZGRLTTmxooYyPt9eQwY6Ws7uJmOtq8a/6tm5Rql4q
         GNmDgsv4NK6Z/2g5L9a7V0R0LJcfqTO/ACPOcbksDfjC4uXDTTq76ywOzGY2ySOTKRn7
         vFsg==
X-Gm-Message-State: AOAM531jvE6T6hmmQ3J+A5hm4ON+sX5a1d8tRhrpfJbhEtfQRrugDBCX
        79/wy828SjaGumFevutblxM=
X-Google-Smtp-Source: ABdhPJwhmQsp1k2lQqwi3q1tWqY7CCIx9Hls+0ouo2Fc+qXfx0sJ6gJvTzH7NwOgxu2NV5GSU+lIlg==
X-Received: by 2002:a05:6830:1c65:b0:606:3cc:862 with SMTP id s5-20020a0568301c6500b0060603cc0862mr4512272otg.75.1653071601830;
        Fri, 20 May 2022 11:33:21 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::100e? (2603-8090-2005-39b3-0000-0000-0000-100e.res6.spectrum.com. [2603:8090:2005:39b3::100e])
        by smtp.gmail.com with ESMTPSA id b18-20020a4ae212000000b0035eb4e5a6bfsm1317989oot.21.2022.05.20.11.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 11:33:21 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <d948602c-0695-c479-9059-d48a5056d3a1@lwfinger.net>
Date:   Fri, 20 May 2022 13:33:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
Content-Language: en-US
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        neo_jou <neo_jou@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-7-s.hauer@pengutronix.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20220518082318.3898514-7-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/22 03:23, Sascha Hauer wrote:
> Add the common bits and pieces to add USB support to the RTW88 driver.
> This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> itself is first written by Neo Jou.
> 
> Signed-off-by: neo_jou <neo_jou@realtek.com>
> Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>   drivers/net/wireless/realtek/rtw88/Kconfig  |    3 +
>   drivers/net/wireless/realtek/rtw88/Makefile |    2 +
>   drivers/net/wireless/realtek/rtw88/mac.c    |    3 +
>   drivers/net/wireless/realtek/rtw88/main.c   |    5 +
>   drivers/net/wireless/realtek/rtw88/main.h   |    4 +
>   drivers/net/wireless/realtek/rtw88/reg.h    |    1 +
>   drivers/net/wireless/realtek/rtw88/tx.h     |   31 +
>   drivers/net/wireless/realtek/rtw88/usb.c    | 1051 +++++++++++++++++++
>   drivers/net/wireless/realtek/rtw88/usb.h    |  109 ++
>   9 files changed, 1209 insertions(+)
>   create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
>   create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
> index e3d7cb6c12902..1624c5db69bac 100644
> --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> @@ -16,6 +16,9 @@ config RTW88_CORE
>   config RTW88_PCI
>   	tristate
>   
> +config RTW88_USB
> +	tristate
> +
>   config RTW88_8822B
>   	tristate
>   
> diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
> index 834c66ec0af9e..9e095f8181483 100644
> --- a/drivers/net/wireless/realtek/rtw88/Makefile
> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -45,4 +45,6 @@ obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
>   rtw88_8821ce-objs		:= rtw8821ce.o
>   
>   obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
> +obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
>   rtw88_pci-objs			:= pci.o
> +rtw88_usb-objs			:= usb.o
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index d1678aed9d9cb..19728c705eaa9 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -1032,6 +1032,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
>   	if (rtw_chip_wcpu_11ac(rtwdev))
>   		rtw_write32(rtwdev, REG_H2CQ_CSR, BIT_H2CQ_FULL);
>   
> +	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB)
> +		rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_ARBBW_EN);
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 5afb8bef9696a..162fa432ce0d1 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1715,6 +1715,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
>   		rtwdev->hci.rpwm_addr = 0x03d9;
>   		rtwdev->hci.cpwm_addr = 0x03da;
>   		break;
> +	case RTW_HCI_TYPE_USB:
> +		rtwdev->hci.rpwm_addr = 0xfe58;
> +		rtwdev->hci.cpwm_addr = 0xfe57;
> +		break;
>   	default:
>   		rtw_err(rtwdev, "unsupported hci type\n");
>   		return -EINVAL;
> @@ -2105,6 +2109,7 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
>   	hw->wiphy->available_antennas_rx = hal->antenna_rx;
>   
>   	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
> +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
>   			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
>   
>   	hw->wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index fc27066a67a72..007da6df088a3 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -876,6 +876,10 @@ struct rtw_chip_ops {
>   			       bool is_tx2_path);
>   	void (*config_txrx_mode)(struct rtw_dev *rtwdev, u8 tx_path,
>   				 u8 rx_path, bool is_tx2_path);
> +	/* for USB/SDIO only */
> +	void (*fill_txdesc_checksum)(struct rtw_dev *rtwdev,
> +				     struct rtw_tx_pkt_info *pkt_info,
> +				     u8 *txdesc);
>   
>   	/* for coex */
>   	void (*coex_set_init)(struct rtw_dev *rtwdev);
> diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
> index 84ba9ec489c37..a928899030863 100644
> --- a/drivers/net/wireless/realtek/rtw88/reg.h
> +++ b/drivers/net/wireless/realtek/rtw88/reg.h
> @@ -184,6 +184,7 @@
>   #define BIT_TXDMA_VIQ_MAP(x)                                                   \
>   	(((x) & BIT_MASK_TXDMA_VIQ_MAP) << BIT_SHIFT_TXDMA_VIQ_MAP)
>   #define REG_TXDMA_PQ_MAP	0x010C
> +#define BIT_RXDMA_ARBBW_EN	BIT(0)
>   #define BIT_SHIFT_TXDMA_BEQ_MAP	8
>   #define BIT_MASK_TXDMA_BEQ_MAP	0x3
>   #define BIT_TXDMA_BEQ_MAP(x)                                                   \
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
> index 56371eff9f7ff..c02d7a15895c6 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.h
> +++ b/drivers/net/wireless/realtek/rtw88/tx.h
> @@ -67,6 +67,14 @@
>   	le32p_replace_bits((__le32 *)(txdesc) + 0x03, value, BIT(15))
>   #define SET_TX_DESC_BT_NULL(txdesc, value)				       \
>   	le32p_replace_bits((__le32 *)(txdesc) + 0x02, value, BIT(23))
> +#define SET_TX_DESC_TXDESC_CHECKSUM(txdesc, value)                             \
> +	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(15, 0))
> +#define SET_TX_DESC_DMA_TXAGG_NUM(txdesc, value)                             \
> +	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(31, 24))
> +#define GET_TX_DESC_PKT_OFFSET(txdesc)                                  \
> +	le32_get_bits(*((__le32 *)(txdesc) + 0x01), GENMASK(28, 24))
> +#define GET_TX_DESC_QSEL(txdesc)                                        \
> +	le32_get_bits(*((__le32 *)(txdesc) + 0x01), GENMASK(12, 8))
>   
>   enum rtw_tx_desc_queue_select {
>   	TX_DESC_QSEL_TID0	= 0,
> @@ -119,4 +127,27 @@ rtw_tx_write_data_h2c_get(struct rtw_dev *rtwdev,
>   			  struct rtw_tx_pkt_info *pkt_info,
>   			  u8 *buf, u32 size);
>   
> +static inline
> +void fill_txdesc_checksum_common(u8 *txdesc, size_t words)
> +{
> +	__le16 chksum = 0;
> +	__le16 *data = (__le16 *)(txdesc);
> +
> +	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, 0x0000);
> +
> +	while (words--)
> +		chksum ^= *data++;
> +
> +	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, __le16_to_cpu(chksum));
> +}
> +
> +static inline void rtw_tx_fill_txdesc_checksum(struct rtw_dev *rtwdev,
> +					       struct rtw_tx_pkt_info *pkt_info,
> +					       u8 *txdesc)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +
> +	chip->ops->fill_txdesc_checksum(rtwdev, pkt_info, txdesc);
> +}
> +
>   #endif
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> new file mode 100644
> index 0000000000000..7641ea6f6ad1a
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -0,0 +1,1051 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright(c) 2018-2019  Realtek Corporation
> + */
> +
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +#include <linux/mutex.h>
> +#include "main.h"
> +#include "debug.h"
> +#include "reg.h"
> +#include "tx.h"
> +#include "rx.h"
> +#include "fw.h"
> +#include "ps.h"
> +#include "usb.h"
> +
> +#define RTW_USB_MAX_RXQ_LEN	128
> +
> +struct rtw_usb_txcb {
> +	struct rtw_dev *rtwdev;
> +	struct sk_buff_head tx_ack_queue;
> +};
> +
> +static void rtw_usb_fill_tx_checksum(struct rtw_usb *rtwusb,
> +				     struct sk_buff *skb, int agg_num)
> +{
> +	struct rtw_dev *rtwdev = rtwusb->rtwdev;
> +	struct rtw_tx_pkt_info pkt_info;
> +
> +	SET_TX_DESC_DMA_TXAGG_NUM(skb->data, agg_num);
> +	pkt_info.pkt_offset = GET_TX_DESC_PKT_OFFSET(skb->data);
> +	rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, skb->data);
> +}
> +
> +static void usbctrl_async_callback(struct urb *urb)
> +{
> +	/* free dr */
> +	kfree(urb->setup_packet);
> +	/* free databuf */
> +	kfree(urb->transfer_buffer);
> +}
> +
> +static int usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
> +					  u16 value, u16 index, void *pdata,
> +					  u16 len)
> +{
> +	int rc;
> +	unsigned int pipe;
> +	u8 reqtype;
> +	struct usb_ctrlrequest *dr;
> +	struct urb *urb;
> +	const u16 databuf_maxlen = RTW_USB_VENQT_MAX_BUF_SIZE;
> +	u8 *databuf;
> +
> +	if (WARN_ON_ONCE(len > databuf_maxlen))
> +		len = databuf_maxlen;
> +
> +	pipe = usb_sndctrlpipe(udev, 0); /* write_out */
> +	reqtype = RTW_USB_CMD_WRITE;
> +
> +	dr = kzalloc(sizeof(*dr), GFP_ATOMIC);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	databuf = kmemdup(pdata, len, GFP_ATOMIC);
> +	if (!databuf) {
> +		kfree(dr);
> +		return -ENOMEM;
> +	}
> +
> +	urb = usb_alloc_urb(0, GFP_ATOMIC);
> +	if (!urb) {
> +		kfree(databuf);
> +		kfree(dr);
> +		return -ENOMEM;
> +	}
> +
> +	dr->bRequestType = reqtype;
> +	dr->bRequest = request;
> +	dr->wValue = cpu_to_le16(value);
> +	dr->wIndex = cpu_to_le16(index);
> +	dr->wLength = cpu_to_le16(len);
> +
> +	usb_fill_control_urb(urb, udev, pipe,
> +			     (unsigned char *)dr, databuf, len,
> +			     usbctrl_async_callback, NULL);
> +	rc = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (rc < 0) {
> +		kfree(databuf);
> +		kfree(dr);
> +	}
> +
> +	usb_free_urb(urb);
> +
> +	return rc;
> +}
> +
> +static u32 rtw_usb_read_sync(struct rtw_dev *rtwdev, u32 addr, u16 len)
> +{
> +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
> +	struct usb_device *udev = rtwusb->udev;
> +	__le32 *data;
> +	unsigned long flags;
> +	int ret;
> +	static int count;
> +
> +	spin_lock_irqsave(&rtwusb->usb_lock, flags);
> +
> +	if (++rtwusb->usb_data_index >= RTW_USB_MAX_RX_COUNT)
> +		rtwusb->usb_data_index = 0;
> +	data = &rtwusb->usb_data[rtwusb->usb_data_index];
> +
> +	spin_unlock_irqrestore(&rtwusb->usb_lock, flags);
> +
> +	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +				 RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
> +				 RTW_USB_VENQT_CMD_IDX, data, len, 1000);
> +	if (ret < 0 && ret != -ENODEV && count++ < 4)
> +		rtw_err(rtwdev, "reg 0x%x, usbctrl_vendorreq failed with %d\n",
> +			addr, ret);
> +
> +	return le32_to_cpu(*data);
> +}
> +
> +static u8 rtw_usb_read8_sync(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	return (u8)rtw_usb_read_sync(rtwdev, addr, 1);
> +}
> +
> +static u16 rtw_usb_read16_sync(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	return (u16)rtw_usb_read_sync(rtwdev, addr, 2);
> +}
> +
> +static u32 rtw_usb_read32_sync(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	return (u32)rtw_usb_read_sync(rtwdev, addr, 4);
> +}
> +
> +static void rtw_usb_write_async(struct rtw_dev *rtwdev, u32 addr, u32 val,
> +				u16 len)
> +{
> +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
> +	struct usb_device *udev = rtwusb->udev;
> +	u8 request;
> +	u16 wvalue;
> +	u16 index;
> +	__le32 data;
> +
> +	request = RTW_USB_CMD_REQ;
> +	index = RTW_USB_VENQT_CMD_IDX; /* n/a */
> +	wvalue = (u16)(addr & 0x0000ffff);
> +	data = cpu_to_le32(val);
> +	usbctrl_vendorreq_async_write(udev, request, wvalue, index, &data, len);
> +}
> +
> +static void rtw_usb_write8_async(struct rtw_dev *rtwdev, u32 addr, u8 val)
> +{
> +	rtw_usb_write_async(rtwdev, addr, val, 1);
> +}
> +
> +static void rtw_usb_write16_async(struct rtw_dev *rtwdev, u32 addr, u16 val)
> +{
> +	rtw_usb_write_async(rtwdev, addr, val, 2);
> +}
> +
> +static void rtw_usb_write32_async(struct rtw_dev *rtwdev, u32 addr, u32 val)
> +{
> +	rtw_usb_write_async(rtwdev, addr, val, 4);
> +}
> +
> +static int rtw_usb_parse(struct rtw_dev *rtwdev,
> +			 struct usb_interface *interface)
> +{
> +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
> +	struct usb_host_interface *host_interface = &interface->altsetting[0];
> +	struct usb_interface_descriptor *interface_desc = &host_interface->desc;
> +	struct usb_endpoint_descriptor *endpoint;
> +	struct usb_device *usbd = interface_to_usbdev(interface);
> +	int num_out_pipes = 0;
> +	int i;
> +	u8 num;
> +
> +	for (i = 0; i < interface_desc->bNumEndpoints; i++) {
> +		endpoint = &host_interface->endpoint[i].desc;
> +		num = usb_endpoint_num(endpoint);
> +
> +		if (usb_endpoint_dir_in(endpoint) &&
> +		    usb_endpoint_xfer_bulk(endpoint)) {
> +			if (rtwusb->pipe_in) {
> +				rtw_err(rtwdev, "IN pipes overflow\n");
> +				return -EINVAL;
> +			}
> +
> +			rtwusb->pipe_in = num;
> +		}
> +
> +		if (usb_endpoint_dir_in(endpoint) &&
> +		    usb_endpoint_xfer_int(endpoint)) {
> +			if (rtwusb->pipe_interrupt) {
> +				rtw_err(rtwdev, "INT pipes overflow\n");
> +				return -EINVAL;
> +			}
> +
> +			rtwusb->pipe_interrupt = num;
> +		}
> +
> +		if (usb_endpoint_dir_out(endpoint) &&
> +		    usb_endpoint_xfer_bulk(endpoint)) {
> +			if (num_out_pipes >= ARRAY_SIZE(rtwusb->out_ep)) {
> +				rtw_err(rtwdev, "OUT pipes overflow\n");
> +				return -EINVAL;
> +			}
> +
> +			rtwusb->out_ep[num_out_pipes++] = num;
> +		}
> +	}
> +
> +	switch (usbd->speed) {
> +	case USB_SPEED_LOW:
> +	case USB_SPEED_FULL:
> +		rtwusb->bulkout_size = RTW_USB_FULL_SPEED_BULK_SIZE;
> +		break;
> +	case USB_SPEED_HIGH:
> +		rtwusb->bulkout_size = RTW_USB_HIGH_SPEED_BULK_SIZE;
> +		break;
> +	case USB_SPEED_SUPER:
> +		rtwusb->bulkout_size = RTW_USB_SUPER_SPEED_BULK_SIZE;
> +		break;
> +	default:
> +		rtw_err(rtwdev, "failed to detect usb speed\n");
> +		return -EINVAL;
> +	}
> +
> +	rtwdev->hci.bulkout_num = num_out_pipes;
> +
> +	switch (num_out_pipes) {
> +	case 4:
> +	case 3:
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 2;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 2;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 2;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 2;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID4] = 1;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID5] = 1;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID6] = 1;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID7] = 1;
> +		break;
> +	case 2:
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 1;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 1;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 1;
> +		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 1;
> +		break;
> +	case 1:
> +		break;
> +	default:
> +		rtw_err(rtwdev, "failed to get out_pipes(%d)\n", num_out_pipes);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rtw_usb_txcb_enqueue(struct rtw_usb_txcb *txcb, struct sk_buff *skb)
> +{
> +	skb_queue_tail(&txcb->tx_ack_queue, skb);
> +}
> +
> +static void rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list,
> +			       struct sk_buff *skb_head, struct sk_buff *skb,
> +			       struct rtw_usb_txcb *txcb)
> +{
> +	struct sk_buff *skb_iter;
> +	unsigned long flags;
> +	u8 *data_ptr;
> +	int agg_num = 0, len, max_len;
> +
> +	data_ptr = skb_head->data;
> +	skb_iter = skb;
> +
> +	while (skb_iter) {
> +		memcpy(data_ptr, skb_iter->data, skb_iter->len);
> +		len = ALIGN(skb_iter->len, 8);
> +		skb_put(skb_head, len);
> +		data_ptr += len;
> +		agg_num++;
> +
> +		rtw_usb_txcb_enqueue(txcb, skb_iter);
> +
> +		spin_lock_irqsave(&list->lock, flags);
> +
> +		skb_iter = skb_peek(list);
> +		max_len = RTW_USB_MAX_XMITBUF_SZ - skb_head->len;
> +
> +		if (skb_iter && skb_iter->len < max_len)
> +			__skb_unlink(skb_iter, list);
> +		else
> +			skb_iter = NULL;
> +		spin_unlock_irqrestore(&list->lock, flags);
> +	}
> +
> +	if (agg_num > 1)
> +		rtw_usb_fill_tx_checksum(rtwusb, skb_head, agg_num);
> +}
> +
> +static void rtw_usb_indicate_tx_status(struct rtw_dev *rtwdev,
> +				       struct sk_buff *skb)
> +{
> +	struct ieee80211_hw *hw = rtwdev->hw;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct rtw_usb_tx_data *tx_data = rtw_usb_get_tx_data(skb);
> +
> +	/* enqueue to wait for tx report */
> +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
> +		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
> +		return;
> +	}
> +
> +	/* always ACK for others, then they won't be marked as drop */
> +	ieee80211_tx_info_clear_status(info);
> +	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> +		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
> +	else
> +		info->flags |= IEEE80211_TX_STAT_ACK;
> +
> +	ieee80211_tx_status_irqsafe(hw, skb);
> +}
> +
> +static void rtw_usb_write_port_tx_complete(struct urb *urb)
> +{
> +	struct rtw_usb_txcb *txcb = urb->context;
> +	struct rtw_dev *rtwdev = txcb->rtwdev;
> +
> +	while (true) {
> +		struct sk_buff *skb = skb_dequeue(&txcb->tx_ack_queue);
> +		if (!skb)
> +			break;
> +
> +		if (GET_TX_DESC_QSEL(skb->data) <= TX_DESC_QSEL_TID7)
> +			rtw_usb_indicate_tx_status(rtwdev, skb);
> +		else
> +			dev_kfree_skb_any(skb);
> +	}
> +
> +	kfree(txcb);
> +}
> +
> +static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *skb,
> +			      usb_complete_t cb, void *context)
> +{
> +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
> +	struct usb_device *usbd = rtwusb->udev;
> +	struct urb *urb;
> +	unsigned int pipe;
> +	int ret;
> +	int ep = rtwusb->qsel_to_ep[qsel];
> +
> +	pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
> +	urb = usb_alloc_urb(0, GFP_ATOMIC);
> +	if (!urb)
> +		return -ENOMEM;
> +
> +	usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len, cb, context);
> +	ret = usb_submit_urb(urb, GFP_ATOMIC);
> +
> +	usb_free_urb(urb);
> +
> +	return ret;
> +}
> +
> +static struct sk_buff *rtw_usb_tx_agg_check(struct rtw_usb *rtwusb,
> +					    struct sk_buff *skb,
> +					    int index,
> +					    struct rtw_usb_txcb *txcb)
> +{
> +	struct sk_buff_head *list;
> +	struct sk_buff *skb_head;
> +
> +	list = &rtwusb->tx_queue[index];
> +	if (skb_queue_empty(list))
> +		return NULL;
> +
> +	skb_head = dev_alloc_skb(RTW_USB_MAX_XMITBUF_SZ);
> +	if (!skb_head)
> +		return NULL;
> +
> +	rtw_usb_tx_agg_skb(rtwusb, list, skb_head, skb, txcb);
> +
> +	return skb_head;
> +}
> +
> +static void rtw_usb_tx_agg(struct rtw_usb *rtwusb, struct sk_buff *skb, int index)
> +{
> +	struct rtw_dev *rtwdev = rtwusb->rtwdev;
> +	struct sk_buff *skb_head;
> +	struct rtw_usb_txcb *txcb;
> +	u8 qsel;
> +
> +	txcb = kmalloc(sizeof(*txcb), GFP_ATOMIC);
> +	if (!txcb)
> +		return;
> +
> +	txcb->rtwdev = rtwdev;
> +	skb_queue_head_init(&txcb->tx_ack_queue);
> +
> +	skb_head = rtw_usb_tx_agg_check(rtwusb, skb, index, txcb);
> +	if (!skb_head) {
> +		skb_head = skb;
> +		rtw_usb_txcb_enqueue(txcb, skb);
> +	}
> +
> +	qsel = GET_TX_DESC_QSEL(skb->data);
> +
> +	rtw_usb_write_port(rtwdev, qsel, skb_head,
> +			   rtw_usb_write_port_tx_complete, txcb);
> +
> +	if (skb_head != skb)
> +		dev_kfree_skb(skb_head);
> +}
> +
> +static void rtw_usb_tx_handler(struct work_struct *work)
> +{
> +	struct rtw_usb *rtwusb = container_of(work, struct rtw_usb, tx_work);
> +	struct sk_buff *skb;
> +	int index, limit;
> +
> +	for (index = ARRAY_SIZE(rtwusb->tx_queue) - 1; index >= 0; index--) {
> +		for (limit = 0; limit < 200; limit++) {
> +			skb = skb_dequeue(&rtwusb->tx_queue[index]);
> +			if (skb)
> +				rtw_usb_tx_agg(rtwusb, skb, index);
> +			else
> +				break;
> +		}
> +	}
> +}
> +
> +static void rtw_usb_tx_queue_purge(struct rtw_usb *rtwusb)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(rtwusb->tx_queue); i++)
> +		skb_queue_purge(&rtwusb->tx_queue[i]);
> +}
> +
> +static void rtw_usb_write_port_complete(struct urb *urb)
> +{
> +	struct sk_buff *skb = urb->context;
> +
> +	dev_kfree_skb_any(skb);
> +}
> +
> +static int rtw_usb_write_data(struct rtw_dev *rtwdev,
> +			      struct rtw_tx_pkt_info *pkt_info,
> +			      u8 *buf)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct sk_buff *skb;
> +	unsigned int desclen, headsize, size;
> +	u8 qsel;
> +	int ret = 0;
> +
> +	size = pkt_info->tx_pkt_size;
> +	qsel = pkt_info->qsel;
> +	desclen = chip->tx_pkt_desc_sz;
> +	headsize = pkt_info->offset ? pkt_info->offset : desclen;
> +
> +	skb = dev_alloc_skb(headsize + size);
> +	if (unlikely(!skb))
> +		return -ENOMEM;
> +
> +	skb_reserve(skb, headsize);
> +	skb_put_data(skb, buf, size);
> +	skb_push(skb, headsize);
> +	memset(skb->data, 0, headsize);
> +	rtw_tx_fill_tx_desc(pkt_info, skb);
> +	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
> +
> +	ret = rtw_usb_write_port(rtwdev, qsel, skb,
> +				 rtw_usb_write_port_complete, skb);
> +	if (unlikely(ret))
> +		rtw_err(rtwdev, "failed to do USB write, ret=%d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
> +					u32 size)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_usb *rtwusb;
> +	struct rtw_tx_pkt_info pkt_info = {0};
> +	u32 len, desclen;
> +
> +	if (unlikely(!rtwdev))
> +		return -EINVAL;

You check rtwdev after you dereference it to get the chip info. I think the test 
can be dropped. If rtwdev is NULL, a lot of things will have brohen earlier.

Larry
