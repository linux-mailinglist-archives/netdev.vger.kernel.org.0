Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9415963CCF7
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiK3Blc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Nov 2022 20:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiK3Bl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:41:29 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EA0C7343B;
        Tue, 29 Nov 2022 17:41:25 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AU1dqjiF025207, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AU1dqjiF025207
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 30 Nov 2022 09:39:52 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 30 Nov 2022 09:40:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 30 Nov 2022 09:40:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 30 Nov 2022 09:40:36 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>,
        "Bernie Huang" <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        neo_jou <neo_jou@realtek.com>
Subject: RE: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
Thread-Topic: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
Thread-Index: AQHZA9rfU40VmmVRiUGte21yFx1HBa5WonIA
Date:   Wed, 30 Nov 2022 01:40:36 +0000
Message-ID: <4eee82341ef84d4aa063edeb6f23a70d@realtek.com>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
 <20221129100754.2753237-8-s.hauer@pengutronix.de>
In-Reply-To: <20221129100754.2753237-8-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/29_=3F=3F_10:00:00?=
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
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, November 29, 2022 6:08 PM
> To: linux-wireless@vger.kernel.org
> Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> Sascha Hauer <s.hauer@pengutronix.de>; neo_jou <neo_jou@realtek.com>
> Subject: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
> 
> Add the common bits and pieces to add USB support to the RTW88 driver.
> This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> itself is first written by Neo Jou.
> 
> Signed-off-by: neo_jou <neo_jou@realtek.com>
> Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> Notes:
>     Changes since v3:
>     - Add sanity break out of potentially endless loop
>     - Do not interleave PCI and USB support in Makefile
>     - fix rtwusb->usb_data_index locking
>     - make data_ptr variable in rtw_usb_tx_agg_skb() unnecessary
>     - Some coding style fixup
>     - drop set-but-unused variable in rtw_usb_write_data()
>     - Increase RTW_USB_MAX_RXQ_LEN to 512. I've seen "failed to get rx_queue, overflow\n"
>       trigger otherwise
> 
>     Changes since v2:
>     - Fix buffer length for aggregated tx packets
>     - Increase maximum transmit buffer size to 20KiB as found in downstream drivers
>     - Change register write functions to synchronous accesses instead of just firing
>       a URB without waiting for its completion
>     - requeue rx URBs directly in completion handler rather than having a workqueue
>       for it.
> 
>     Changes since v1:
>     - Make checkpatch.pl clean
>     - Drop WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL flag
>     - Use 'ret' as variable name for return values
>     - Sort variable declarations in reverse Xmas tree order
>     - Change potentially endless loop to a limited loop
>     - Change locking to be more obviously correct
>     - drop unnecessary check for !rtwdev
>     - make sure the refill workqueue is not restarted again after we have
>       cancelled it
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig  |   3 +
>  drivers/net/wireless/realtek/rtw88/Makefile |   3 +
>  drivers/net/wireless/realtek/rtw88/mac.c    |   3 +
>  drivers/net/wireless/realtek/rtw88/main.c   |   4 +
>  drivers/net/wireless/realtek/rtw88/main.h   |   4 +
>  drivers/net/wireless/realtek/rtw88/reg.h    |   1 +
>  drivers/net/wireless/realtek/rtw88/tx.h     |  31 +
>  drivers/net/wireless/realtek/rtw88/usb.c    | 917 ++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/usb.h    | 107 +++
>  9 files changed, 1073 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
> 

[...]

> +static void rtw_usb_write_port_tx_complete(struct urb *urb)
> +{
> +	struct rtw_usb_txcb *txcb = urb->context;
> +	struct rtw_dev *rtwdev = txcb->rtwdev;
> +	struct ieee80211_hw *hw = rtwdev->hw;
> +	int max_iter = RTW_USB_MAX_XMITBUF_SZ;
> +
> +	while (true) {
> +		struct sk_buff *skb = skb_dequeue(&txcb->tx_ack_queue);
> +		struct ieee80211_tx_info *info;
> +		struct rtw_usb_tx_data *tx_data;
> +
> +		if (!skb)
> +			break;
> +
> +		if (!--max_iter) {

Don't you need to free 'skb'? or you should not dequeue skb in this situation?

> +			rtw_err(rtwdev, "failed to empty TX ack queue\n");
> +			break;
> +		}
> +
> +		info = IEEE80211_SKB_CB(skb);
> +		tx_data = rtw_usb_get_tx_data(skb);
> +
> +		/* enqueue to wait for tx report */
> +		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
> +			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
> +			continue;
> +		}
> +
> +		/* always ACK for others, then they won't be marked as drop */
> +		ieee80211_tx_info_clear_status(info);
> +		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> +			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
> +		else
> +			info->flags |= IEEE80211_TX_STAT_ACK;
> +
> +		ieee80211_tx_status_irqsafe(hw, skb);
> +	}
> +
> +	kfree(txcb);
> +}
> +

[...]

I have reviewed patchset v4, and only one comment.

--
Ping-Ke

