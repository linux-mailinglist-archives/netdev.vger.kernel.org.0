Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0099B658844
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 02:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiL2BPT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Dec 2022 20:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiL2BPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 20:15:17 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F90013E2A;
        Wed, 28 Dec 2022 17:15:12 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT1E4IT0019796, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT1E4IT0019796
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 09:14:04 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 29 Dec 2022 09:14:58 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 09:14:57 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 09:14:57 +0800
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
Subject: RE: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics in the power on sequence
Thread-Topic: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics
 in the power on sequence
Thread-Index: AQHZGktC3vnvtmQgSkm40YvvOQDovq6ECyLw
Date:   Thu, 29 Dec 2022 01:14:57 +0000
Message-ID: <b30273c693fd4868873d9bf4a1b5c0ca@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-14-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221227233020.284266-14-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/28_=3F=3F_10:54:00?=
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
> Subject: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics in the power on sequence
> 
> Add the code specific to SDIO HCI in the MAC power on sequence. This is
> based on the RTL8822BS and RTL8822CS vendor drivers.
> 
> Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/mac.c | 41 ++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index 8e1fa824b32b..ad71f9838d1d 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -7,6 +7,7 @@
>  #include "reg.h"
>  #include "fw.h"
>  #include "debug.h"
> +#include "sdio.h"
> 
>  void rtw_set_channel_mac(struct rtw_dev *rtwdev, u8 channel, u8 bw,
>  			 u8 primary_ch_idx)
> @@ -60,6 +61,7 @@ EXPORT_SYMBOL(rtw_set_channel_mac);
> 
>  static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
>  {
> +	unsigned int retry;
>  	u32 value32;
>  	u8 value8;
> 
> @@ -77,6 +79,26 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
>  	case RTW_HCI_TYPE_PCIE:
>  		rtw_write32_set(rtwdev, REG_HCI_OPT_CTRL, BIT_USB_SUS_DIS);
>  		break;
> +	case RTW_HCI_TYPE_SDIO:
> +		rtw_write8_clr(rtwdev, REG_SDIO_HSUS_CTRL, BIT(0));

BIT_HCI_SUS_REQ BIT(0)

> +
> +		for (retry = 0; retry < RTW_PWR_POLLING_CNT; retry++) {
> +			if (rtw_read8(rtwdev, REG_SDIO_HSUS_CTRL) & BIT(1))

BIT_HCI_RESUME_RDY BIT(1)

> +				break;
> +
> +			usleep_range(10, 50);
> +		}
> +
> +		if (retry == RTW_PWR_POLLING_CNT) {
> +			rtw_err(rtwdev, "failed to poll REG_SDIO_HSUS_CTRL[1]");
> +			return -ETIMEDOUT;
> +		}
> +
> +		if (rtw_sdio_is_sdio30_supported(rtwdev))
> +			rtw_write8_set(rtwdev, REG_HCI_OPT_CTRL + 2, BIT(2));

BIT_USB_LPM_ACT_EN BIT(10)   // reg_addr +2, so bit >> 8

> +		else
> +			rtw_write8_clr(rtwdev, REG_HCI_OPT_CTRL + 2, BIT(2));
> +		break;
>  	case RTW_HCI_TYPE_USB:
>  		break;
>  	default:

[...]

