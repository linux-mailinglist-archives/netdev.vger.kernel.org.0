Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8519369C39C
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 01:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjBTA1D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Feb 2023 19:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBTA1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 19:27:01 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C27DBE1;
        Sun, 19 Feb 2023 16:26:48 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31K0QZpjC003602, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31K0QZpjC003602
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 20 Feb 2023 08:26:35 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Feb 2023 08:26:38 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 20 Feb 2023 08:26:38 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 20 Feb 2023 08:26:38 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 3/5] wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
Thread-Topic: [PATCH v2 3/5] wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO)
 efuse parsing
Thread-Index: AQHZQ63r9mGKodBsGUirD1pxGEbbR67W/IsQ
Date:   Mon, 20 Feb 2023 00:26:38 +0000
Message-ID: <ddc15e3efa264570a0d9066829342334@realtek.com>
References: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
 <20230218152944.48842-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230218152944.48842-4-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, February 18, 2023 11:30 PM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Neo
> Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v2 3/5] wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
> 
> The efuse of the SDIO RTL8821CS chip has only one known member: the mac
> address is at offset 0x11a. Add a struct rtw8821cs_efuse describing this
> and use it for copying the mac address when the SDIO bus is used.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> changes from v1 -> v2:
> - add the new function/union member/case statement last (after USB)
> 
> 
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c | 9 +++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8821c.h | 6 ++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> index 17f800f6efbd..7ae0541d7b99 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> @@ -32,6 +32,12 @@ static void rtw8821cu_efuse_parsing(struct rtw_efuse *efuse,
>         ether_addr_copy(efuse->addr, map->u.mac_addr);
>  }
> 
> +static void rtw8821cs_efuse_parsing(struct rtw_efuse *efuse,
> +                                   struct rtw8821c_efuse *map)
> +{
> +       ether_addr_copy(efuse->addr, map->s.mac_addr);
> +}
> +
>  enum rtw8821ce_rf_set {
>         SWITCH_TO_BTG,
>         SWITCH_TO_WLG,
> @@ -77,6 +83,9 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>         case RTW_HCI_TYPE_USB:
>                 rtw8821cu_efuse_parsing(efuse, map);
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               rtw8821cs_efuse_parsing(efuse, map);
> +               break;
>         default:
>                 /* unsupported now */
>                 return -ENOTSUPP;
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> index 1c81260f3a54..fcff31688c45 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
> @@ -65,6 +65,11 @@ struct rtw8821ce_efuse {
>         u8 res7;
>  };
> 
> +struct rtw8821cs_efuse {
> +       u8 res4[0x4a];                  /* 0xd0 */
> +       u8 mac_addr[ETH_ALEN];          /* 0x11a */
> +} __packed;
> +
>  struct rtw8821c_efuse {
>         __le16 rtl_id;
>         u8 res0[0x0e];
> @@ -94,6 +99,7 @@ struct rtw8821c_efuse {
>         union {
>                 struct rtw8821ce_efuse e;
>                 struct rtw8821cu_efuse u;
> +               struct rtw8821cs_efuse s;
>         };
>  };
> 
> --
> 2.39.2

