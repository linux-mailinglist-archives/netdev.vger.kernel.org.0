Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EAF65731E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiL1GVw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Dec 2022 01:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1GVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:21:51 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82162AE6B;
        Tue, 27 Dec 2022 22:21:48 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BS6KYogC001141, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BS6KYogC001141
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 28 Dec 2022 14:20:34 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 28 Dec 2022 14:21:28 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 28 Dec 2022 14:21:28 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 28 Dec 2022 14:21:27 +0800
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
Subject: RE: [RFC PATCH v1 06/19] rtw88: rtw8821c: Add support for parsing the RTL8821CS (SDIO) efuse
Thread-Topic: [RFC PATCH v1 06/19] rtw88: rtw8821c: Add support for parsing
 the RTL8821CS (SDIO) efuse
Thread-Index: AQHZGks+HXgF0Jfl1UCsDAdyYOhe0q6C099A
Date:   Wed, 28 Dec 2022 06:21:27 +0000
Message-ID: <695c976e02ed44a2b2345a3ceb226fc4@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-7-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221227233020.284266-7-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/28_=3F=3F_01:41:00?=
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
> Subject: [RFC PATCH v1 06/19] rtw88: rtw8821c: Add support for parsing the RTL8821CS (SDIO) efuse
> 
> The efuse of the SDIO RTL8821CS chip has only one known member: the mac
> address is at offset 0x11a. Add a struct rtw8821cs_efuse describing this
> and use it for copying the mac address when the SDIO bus is used.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c | 9 +++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8821c.h | 6 ++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> index 17f800f6efbd..dd01b22f9770 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> @@ -26,6 +26,12 @@ static void rtw8821ce_efuse_parsing(struct rtw_efuse *efuse,
>  	ether_addr_copy(efuse->addr, map->e.mac_addr);
>  }
> 
> +static void rtw8821cs_efuse_parsing(struct rtw_efuse *efuse,
> +				    struct rtw8821c_efuse *map)
> +{
> +	ether_addr_copy(efuse->addr, map->s.mac_addr);
> +}
> +
>  static void rtw8821cu_efuse_parsing(struct rtw_efuse *efuse,
>  				    struct rtw8821c_efuse *map)
>  {
> @@ -74,6 +80,9 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>  	case RTW_HCI_TYPE_PCIE:
>  		rtw8821ce_efuse_parsing(efuse, map);
>  		break;
> +	case RTW_HCI_TYPE_SDIO:
> +		rtw8821cs_efuse_parsing(efuse, map);
> +		break;
>  	case RTW_HCI_TYPE_USB:
>  		rtw8821cu_efuse_parsing(efuse, map);
>  		break;
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> index 1c81260f3a54..1deea54575b5 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> @@ -65,6 +65,11 @@ struct rtw8821ce_efuse {
>  	u8 res7;
>  };
> 
> +struct rtw8821cs_efuse {
> +	u8 res4[0x4a];			/* 0xd0 */
> +	u8 mac_addr[ETH_ALEN];		/* 0x11a */
> +};
> +

This struct should be __packed, as well as rtw8821c_efuse.

Would you mind to create additional patch to add __packed to these struct of
efuse layout?

>  struct rtw8821c_efuse {
>  	__le16 rtl_id;
>  	u8 res0[0x0e];
> @@ -93,6 +98,7 @@ struct rtw8821c_efuse {
>  	u8 res[3];
>  	union {
>  		struct rtw8821ce_efuse e;
> +		struct rtw8821cs_efuse s;
>  		struct rtw8821cu_efuse u;
>  	};
>  };
> --
> 2.39.0

