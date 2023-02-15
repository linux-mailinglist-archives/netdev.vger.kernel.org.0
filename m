Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D4B697386
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbjBOBWl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Feb 2023 20:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbjBOBWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:22:20 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A926334C0A;
        Tue, 14 Feb 2023 17:21:47 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31F1LXAM0009995, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31F1LXAM0009995
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 15 Feb 2023 09:21:33 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 15 Feb 2023 09:21:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 15 Feb 2023 09:21:34 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Wed, 15 Feb 2023 09:21:34 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v1 4/5] wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
Thread-Topic: [PATCH v1 4/5] wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO)
 efuse parsing
Thread-Index: AQHZQLlVYRxFC8DYgUSIrrVEWedGBa7PLmvg
Date:   Wed, 15 Feb 2023 01:21:34 +0000
Message-ID: <ef11acd2c4054365b76d06966f40cc61@realtek.com>
References: <20230214211421.2290102-1-martin.blumenstingl@googlemail.com>
 <20230214211421.2290102-5-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230214211421.2290102-5-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/2/14_=3F=3F_11:07:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
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
> Sent: Wednesday, February 15, 2023 5:14 AM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Neo
> Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v1 4/5] wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
> 
> The efuse of the SDIO RTL8822BS chip has only one known member: the mac
> address is at offset 0x11a. Add a struct rtw8822bs_efuse describing this
> and use it for copying the mac address when the SDIO bus is used.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c | 10 ++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8822b.h |  6 ++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> index 74dfb89b2c94..4ed5b98fab23 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> @@ -26,10 +26,17 @@ static void rtw8822be_efuse_parsing(struct rtw_efuse *efuse,
>         ether_addr_copy(efuse->addr, map->e.mac_addr);
>  }
> 
> +static void rtw8822bs_efuse_parsing(struct rtw_efuse *efuse,
> +                                   struct rtw8822b_efuse *map)
> +{
> +       ether_addr_copy(efuse->addr, map->s.mac_addr);
> +}
> +
>  static void rtw8822bu_efuse_parsing(struct rtw_efuse *efuse,
>                                     struct rtw8822b_efuse *map)
>  {
>         ether_addr_copy(efuse->addr, map->u.mac_addr);
> +

Don't need to stir USB code.

>  }
> 
>  static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
> @@ -62,6 +69,9 @@ static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>         case RTW_HCI_TYPE_PCIE:
>                 rtw8822be_efuse_parsing(efuse, map);
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               rtw8822bs_efuse_parsing(efuse, map);
> +               break;
>         case RTW_HCI_TYPE_USB:
>                 rtw8822bu_efuse_parsing(efuse, map);
>                 break;
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> index 01d3644e0c94..8d05805c046c 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> @@ -65,6 +65,11 @@ struct rtw8822be_efuse {
>         u8 res7;
>  };
> 
> +struct rtw8822bs_efuse {
> +       u8 res4[0x4a];                  /* 0xd0 */
> +       u8 mac_addr[ETH_ALEN];          /* 0x11a */
> +} __packed;
> +
>  struct rtw8822b_efuse {
>         __le16 rtl_id;
>         u8 res0[0x0e];
> @@ -94,6 +99,7 @@ struct rtw8822b_efuse {
>         union {
>                 struct rtw8822bu_efuse u;
>                 struct rtw8822be_efuse e;
> +               struct rtw8822bs_efuse s;

No obvious problem in whole patchset. Only a nit about the order of PCIE-USB-SDIO.
Can we have them in consistent order?

Here, the order is USB-PCIE-SDIO, but patch 3/5 and 5/5 in different order.
It seems like we messed up the order when adding USB, but we can correct them
along with this patch. My prefer order is PCIE-USB-SDIO after adding SDIO,
because the order of existing code of 'switch...case' is PCIE-USB.

Apply this rule not only here also 'switch...case' and 'efuse parser'.

Ping-Ke

