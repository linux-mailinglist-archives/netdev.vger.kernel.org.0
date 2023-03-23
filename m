Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280576C5C9A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 03:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCWC3D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Mar 2023 22:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjCWC26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 22:28:58 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FC48A73;
        Wed, 22 Mar 2023 19:28:51 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32N2SJcS4005671, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32N2SJcS4005671
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 10:28:19 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 23 Mar 2023 10:28:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 23 Mar 2023 10:28:34 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 23 Mar 2023 10:28:34 +0800
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
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v3 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
Thread-Topic: [PATCH v3 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX
 headroom for SDIO cards
Thread-Index: AQHZW3Pm2NYSSGss/0ucWqQyYxl0iK8Hp1pA
Date:   Thu, 23 Mar 2023 02:28:34 +0000
Message-ID: <6f57da7c547f424194b2cf1d03fadfeb@realtek.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-6-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230320213508.2358213-6-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Tuesday, March 21, 2023 5:35 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Larry Finger <Larry.Finger@lwfinger.net>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v3 5/9] wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
> 
> For SDIO host controllers with DMA support the TX buffer physical memory
> address need to be aligned at an 8-byte boundary. Reserve 8 bytes of
> extra TX headroom so we can align the data without re-allocating the
> transmit buffer.
> 
> While here, also remove the TODO comment regarding extra headroom for
> USB and SDIO. For SDIO the extra headroom is now handled and for USB it
> was not needed so far.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> Changes since v2:
> - none
> 
> Changes since v1:
> - none
> 
> 
>  drivers/net/wireless/realtek/rtw88/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index cdc4703ead5f..1cb553485cff 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2163,9 +2163,11 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
>         int max_tx_headroom = 0;
>         int ret;
> 
> -       /* TODO: USB & SDIO may need extra room? */
>         max_tx_headroom = rtwdev->chip->tx_pkt_desc_sz;
> 
> +       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
> +               max_tx_headroom += RTW_SDIO_DATA_PTR_ALIGN;
> +
>         hw->extra_tx_headroom = max_tx_headroom;
>         hw->queues = IEEE80211_NUM_ACS;
>         hw->txq_data_size = sizeof(struct rtw_txq);
> --
> 2.40.0

