Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4658C6574CB
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 10:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiL1JkM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Dec 2022 04:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiL1JkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 04:40:04 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 940ACE09D;
        Wed, 28 Dec 2022 01:40:02 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BS9cs5X3020226, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BS9cs5X3020226
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 28 Dec 2022 17:38:54 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 28 Dec 2022 17:39:47 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 28 Dec 2022 17:39:47 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 28 Dec 2022 17:39:47 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [RFC PATCH v1 12/19] rtw88: sdio: Add HCI implementation for SDIO based chipsets
Thread-Topic: [RFC PATCH v1 12/19] rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Thread-Index: AQHZGktCsajZQIMfG02cvFqSiCFada6C3HLQ
Date:   Wed, 28 Dec 2022 09:39:47 +0000
Message-ID: <2a9e671ef17444238fee3e7e6f14484b@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-13-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221227233020.284266-13-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/28_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Wednesday, December 28, 2022 7:30 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [RFC PATCH v1 12/19] rtw88: sdio: Add HCI implementation for SDIO based chipsets
> 
> Add a sub-driver for SDIO based chipsets which implements the following
> functionality:
> - register accessors for 8, 16 and 32 bits for all states of the card
>   (including usage of 4x 8 bit access for one 32 bit buffer if the card
>   is not fully powered on yet - or if it's fully powered on then 1x 32
>   bit access is used)
> - checking whether there's space in the TX FIFO queue to transmit data
> - transfers from the host to the device for actual network traffic,
>   reserved pages (for firmware download) and H2C (host-to-card)
>   transfers
> - receiving data from the device
> - deep power saving state
> 
> The transmit path is optimized so DMA-capable SDIO host controllers can
> directly use the buffers provided because the buffer's physical
> addresses are 8 byte aligned.
> 
> The receive path is prepared to support RX aggregation where the
> chipset combines multiple MAC frames into one bigger buffer to reduce
> SDIO transfer overhead.
> 
> Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/Kconfig  |    3 +
>  drivers/net/wireless/realtek/rtw88/Makefile |    3 +
>  drivers/net/wireless/realtek/rtw88/debug.h  |    1 +
>  drivers/net/wireless/realtek/rtw88/mac.h    |    1 -
>  drivers/net/wireless/realtek/rtw88/reg.h    |   10 +
>  drivers/net/wireless/realtek/rtw88/sdio.c   | 1242 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/sdio.h   |  175 +++
>  7 files changed, 1434 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h
> 

[...]

> +
> +static void rtw_sdio_writel(struct rtw_sdio *rtwsdio, u32 val,
> +			    u32 addr, int *ret)
> +{
> +	u8 buf[4];
> +	int i;
> +
> +	if (!(addr & 3) && rtwsdio->is_powered_on) {
> +		sdio_writel(rtwsdio->sdio_func, val, addr, ret);
> +		return;
> +	}
> +
> +	*(__le32 *)buf = cpu_to_le32(val);
> +
> +	for (i = 0; i < 4; i++) {
> +		sdio_writeb(rtwsdio->sdio_func, buf[i], addr + i, ret);
> +		if (*ret)

Do you need some messages to know something wrong?

> +			return;
> +	}
> +}
> +
> +static u32 rtw_sdio_readl(struct rtw_sdio *rtwsdio, u32 addr, int *ret)
> +{
> +	u8 buf[4];
> +	int i;
> +
> +	if (!(addr & 3) && rtwsdio->is_powered_on)
> +		return sdio_readl(rtwsdio->sdio_func, addr, ret);
> +
> +	for (i = 0; i < 4; i++) {
> +		buf[i] = sdio_readb(rtwsdio->sdio_func, addr + i, ret);
> +		if (*ret)
> +			return 0;
> +	}
> +
> +	return le32_to_cpu(*(__le32 *)buf);
> +}
> +
> +static u8 rtw_sdio_read_indirect8(struct rtw_dev *rtwdev, u32 addr, int *ret)
> +{
> +	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +	u32 reg_cfg, reg_data;
> +	int retry;
> +	u8 tmp;
> +
> +	reg_cfg = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_CFG);
> +	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
> +
> +	rtw_sdio_writel(rtwsdio, BIT(19) | addr, reg_cfg, ret);
> +	if (*ret)
> +		return 0;
> +
> +	for (retry = 0; retry < RTW_SDIO_INDIRECT_RW_RETRIES; retry++) {
> +		tmp = sdio_readb(rtwsdio->sdio_func, reg_cfg + 2, ret);
> +		if (!ret && tmp & BIT(4))

'ret' is pointer, do you need '*' ?

if (!*ret && tmp & BIT(4)) 

As I look into sdio_readb(), it use 'int *err_ret' as arugment. 
Would you like to change ' int *ret' to 'int *err_ret'?
It could help to misunderstand. 

> +			break;
> +	}
> +
> +	if (*ret)
> +		return 0;
> +
> +	return sdio_readb(rtwsdio->sdio_func, reg_data, ret);
> +}
> +

[...]

> +
> +static void rtw_sdio_rx_aggregation(struct rtw_dev *rtwdev, bool enable)
> +{
> +	u8 size, timeout;
> +
> +	if (enable) {
> +		if (rtwdev->chip->id == RTW_CHIP_TYPE_8822C) {
> +			size = 0xff;
> +			timeout = 0x20;
> +		} else {
> +			size = 0x6;
> +			timeout = 0x6;
> +		}
> +
> +		/* Make the firmware honor the size limit configured below */
> +		rtw_write32_set(rtwdev, REG_RXDMA_AGG_PG_TH, BIT_EN_PRE_CALC);
> +
> +		rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_AGG_EN);
> +
> +		rtw_write16(rtwdev, REG_RXDMA_AGG_PG_TH, size |
> +			    (timeout << BIT_SHIFT_DMA_AGG_TO_V1));

BIT_RXDMA_AGG_PG_TH GENMASK(7, 0)	// for size
BIT_DMA_AGG_TO_V1 GENMASK(15, 8)	// for timeout

> +
> +		rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
> +	} else {
> +		rtw_write32_clr(rtwdev, REG_RXDMA_AGG_PG_TH, BIT_EN_PRE_CALC);
> +		rtw_write8_clr(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_AGG_EN);
> +		rtw_write8_clr(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
> +	}
> +}
> +
> +static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +
> +	rtw_write32(rtwdev, REG_SDIO_HIMR, rtwsdio->irq_mask);
> +}
> +
> +static void rtw_sdio_disable_interrupt(struct rtw_dev *rtwdev)
> +{
> +	rtw_write32(rtwdev, REG_SDIO_HIMR, 0x0);
> +}
> +
> +static u8 rtw_sdio_get_tx_qsel(struct rtw_dev *rtwdev, struct sk_buff *skb,
> +			       u8 queue)
> +{
> +	switch (queue) {
> +	case RTW_TX_QUEUE_BCN:
> +		return TX_DESC_QSEL_BEACON;
> +	case RTW_TX_QUEUE_H2C:
> +		return TX_DESC_QSEL_H2C;
> +	case RTW_TX_QUEUE_MGMT:
> +		if (rtw_chip_wcpu_11n(rtwdev))
> +			return TX_DESC_QSEL_HIGH;
> +		else
> +			return TX_DESC_QSEL_MGMT;
> +	case RTW_TX_QUEUE_HI0:
> +		return TX_DESC_QSEL_HIGH;
> +	default:
> +		return skb->priority;
> +	}
> +};

no need ';'

[...]

> +
> +static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
> +{
> +	u32 rx_len;
> +
> +	while (true) {

add a limit to prevent infinite loop.

> +		if (rtw_chip_wcpu_11n(rtwdev))
> +			rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
> +		else
> +			rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
> +
> +		if (!rx_len)
> +			break;
> +
> +		rtw_sdio_rxfifo_recv(rtwdev, rx_len);
> +	}
> +}
> +

[...]

> +
> +static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
> +				      enum rtw_tx_queue_type queue)
> +{
> +	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +	struct sk_buff *skb;
> +	int ret;
> +
> +	while (true) {

Can we have a limit?

> +		skb = skb_dequeue(&rtwsdio->tx_queue[queue]);
> +		if (!skb)
> +			break;
> +
> +		ret = rtw_sdio_write_port(rtwdev, skb, queue);
> +		if (ret) {
> +			skb_queue_head(&rtwsdio->tx_queue[queue], skb);
> +			break;
> +		}
> +
> +		if (queue <= RTW_TX_QUEUE_VO)
> +			rtw_sdio_indicate_tx_status(rtwdev, skb);
> +		else
> +			dev_kfree_skb_any(skb);
> +	}
> +}
> +

[...]


