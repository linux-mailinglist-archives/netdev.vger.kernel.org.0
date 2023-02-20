Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7CB69C396
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 01:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBTA0b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Feb 2023 19:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBTA02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 19:26:28 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE47CD50D;
        Sun, 19 Feb 2023 16:26:27 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31K0QDSb8030485, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31K0QDSb8030485
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 20 Feb 2023 08:26:13 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Feb 2023 08:26:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 20 Feb 2023 08:26:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 20 Feb 2023 08:26:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 2/5] wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
Thread-Topic: [PATCH v2 2/5] wifi: rtw88: mac: Add SDIO HCI support in the
 TX/page table setup
Thread-Index: AQHZQ63qVMbDC3Kvq0mGfBoKHs3n1K7W/EAw
Date:   Mon, 20 Feb 2023 00:26:16 +0000
Message-ID: <55637080d690477fb42d1dac843c4b6f@realtek.com>
References: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
 <20230218152944.48842-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230218152944.48842-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
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
> Subject: [PATCH v2 2/5] wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
> 
> txdma_queue_mapping() and priority_queue_cfg() can use the first entry
> of each chip's rqpn_table and page_table. Add this mapping so data
> transmission is possible on SDIO based chipsets.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index 3ed88d38f1b4..6a234eec09ff 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -1033,6 +1033,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
>                 else
>                         return -EINVAL;
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               rqpn = &chip->rqpn_table[0];
> +               break;
>         default:
>                 return -EINVAL;
>         }
> @@ -1195,6 +1198,9 @@ static int priority_queue_cfg(struct rtw_dev *rtwdev)
>                 else
>                         return -EINVAL;
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               pg_tbl = &chip->page_table[0];
> +               break;
>         default:
>                 return -EINVAL;
>         }
> --
> 2.39.2

