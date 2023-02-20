Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4525F69C3A3
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 01:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjBTA1j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Feb 2023 19:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjBTA1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 19:27:38 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03474E384;
        Sun, 19 Feb 2023 16:27:22 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31K0RAG30009846, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31K0RAG30009846
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 20 Feb 2023 08:27:10 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Feb 2023 08:27:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 20 Feb 2023 08:27:13 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 20 Feb 2023 08:27:13 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 5/5] wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing
Thread-Topic: [PATCH v2 5/5] wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO)
 efuse parsing
Thread-Index: AQHZQ63rMCLWuNGH80+RhMdnfBFBV67W/LtA
Date:   Mon, 20 Feb 2023 00:27:13 +0000
Message-ID: <c3042a4d40c441cb947162b005fe25db@realtek.com>
References: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
 <20230218152944.48842-6-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230218152944.48842-6-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/2/19_=3F=3F_05:27:00?=
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
> Sent: Saturday, February 18, 2023 11:30 PM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Neo
> Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v2 5/5] wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing
> 
> The efuse of the SDIO RTL8822CS chip has only one known member: the mac
> address is at offset 0x16a. Add a struct rtw8822cs_efuse describing this
> and use it for copying the mac address when the SDIO bus is used.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> - add the new function/union member/case statement last (after USB)
> - while here, also sort the union members to be consistent with
>   the switch case (PCIe first, USB second, SDIO last)
> 
> 
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 9 +++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8822c.h | 8 +++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> index 964e27887fe2..5a2c004b12df 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> @@ -35,6 +35,12 @@ static void rtw8822cu_efuse_parsing(struct rtw_efuse *efuse,
>         ether_addr_copy(efuse->addr, map->u.mac_addr);
>  }
> 
> +static void rtw8822cs_efuse_parsing(struct rtw_efuse *efuse,
> +                                   struct rtw8822c_efuse *map)
> +{
> +       ether_addr_copy(efuse->addr, map->s.mac_addr);
> +}
> +
>  static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>  {
>         struct rtw_efuse *efuse = &rtwdev->efuse;
> @@ -67,6 +73,9 @@ static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>         case RTW_HCI_TYPE_USB:
>                 rtw8822cu_efuse_parsing(efuse, map);
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               rtw8822cs_efuse_parsing(efuse, map);
> +               break;
>         default:
>                 /* unsupported now */
>                 return -ENOTSUPP;
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
> b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
> index 479d5d769c52..1bc0e7f5d6bb 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
> @@ -16,6 +16,11 @@ struct rtw8822cu_efuse {
>         u8 res2[0x3d];
>  };
> 
> +struct rtw8822cs_efuse {
> +       u8 res0[0x4a];                  /* 0x120 */
> +       u8 mac_addr[ETH_ALEN];          /* 0x16a */
> +} __packed;
> +
>  struct rtw8822ce_efuse {
>         u8 mac_addr[ETH_ALEN];          /* 0x120 */
>         u8 vender_id[2];
> @@ -91,8 +96,9 @@ struct rtw8822c_efuse {
>         u8 res9;
>         u8 res10[0x42];
>         union {
> -               struct rtw8822cu_efuse u;
>                 struct rtw8822ce_efuse e;
> +               struct rtw8822cu_efuse u;
> +               struct rtw8822cs_efuse s;
>         };
>  };
> 
> --
> 2.39.2

