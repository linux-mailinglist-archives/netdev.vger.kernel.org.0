Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E143E3CCDA0
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 07:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhGSFuO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Jul 2021 01:50:14 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56211 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhGSFuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 01:50:13 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16J5l3Cs9028589, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16J5l3Cs9028589
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Jul 2021 13:47:03 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Jul 2021 13:47:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Jul 2021 13:47:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 19 Jul 2021 13:47:01 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
Thread-Topic: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the
 iterator reads or writes registers
Thread-Index: AQHXe0wjJ2b05+r4fEiABzib9kTzlatJpBFQ
Date:   Mon, 19 Jul 2021 05:47:01 +0000
Message-ID: <2170471a1c144adb882d06e08f3c9d1a@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210717204057.67495-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/7/19_=3F=3F_01:06:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/19/2021 05:35:23
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165067 [Jul 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/19/2021 05:38:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl [mailto:martin.blumenstingl@googlemail.com]
> Sent: Sunday, July 18, 2021 4:41 AM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Neo Jou; Jernej Skrabec; Martin Blumenstingl
> Subject: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
> 
> Upcoming SDIO support may sleep in the read/write handlers. Switch
> all users of rtw_iterate_vifs_atomic() which are either reading or
> writing a register to rtw_iterate_vifs().
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 6 +++---
>  drivers/net/wireless/realtek/rtw88/ps.c   | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index c6364837e83b..207161a8f5bd 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -229,8 +229,8 @@ static void rtw_watch_dog_work(struct work_struct *work)
>  	rtw_phy_dynamic_mechanism(rtwdev);
> 
>  	data.rtwdev = rtwdev;
> -	/* use atomic version to avoid taking local->iflist_mtx mutex */
> -	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
> +
> +	rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);

You revert the fix of [1].

I think we can move out rtw_chip_cfg_csi_rate() from rtw_dynamic_csi_rate(), and
add/set a field cfg_csi_rate to itera data. Then, we do rtw_chip_cfg_csi_rate()
outside iterate function. Therefore, we can keep the atomic version of iterate_vifs.


[1] https://lore.kernel.org/linux-wireless/1556886547-23632-1-git-send-email-sgruszka@redhat.com/

--
Ping-Ke

