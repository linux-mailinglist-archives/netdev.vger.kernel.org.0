Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88683CCDA3
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 07:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhGSFuZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Jul 2021 01:50:25 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56219 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhGSFuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 01:50:20 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16J5lAuuD028599, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16J5lAuuD028599
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Jul 2021 13:47:10 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Jul 2021 13:47:09 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Jul 2021 13:47:09 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 19 Jul 2021 13:47:09 +0800
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
Subject: RE: [PATCH RFC v1 5/7] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Thread-Topic: [PATCH RFC v1 5/7] rtw88: Configure the registers from
 rtw_bf_assoc() outside the RCU lock
Thread-Index: AQHXe0w0JoHHz5CoNkymlQ8rINQ1TKtJyCDg
Date:   Mon, 19 Jul 2021 05:47:09 +0000
Message-ID: <1a299cd8c1be4fba8360780ef6f70f0f@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-6-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210717204057.67495-6-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
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
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
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
> Subject: [PATCH RFC v1 5/7] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
> 
> Upcoming SDIO support may sleep in the read/write handlers. Configure
> the chip's BFEE configuration set from rtw_bf_assoc() outside the
> rcu_read_lock section to prevent a "scheduling while atomic" issue.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/bf.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
> index aff70e4ae028..06034d5d6f6c 100644
> --- a/drivers/net/wireless/realtek/rtw88/bf.c
> +++ b/drivers/net/wireless/realtek/rtw88/bf.c
> @@ -39,6 +39,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>  	struct ieee80211_sta_vht_cap *vht_cap;
>  	struct ieee80211_sta_vht_cap *ic_vht_cap;
>  	const u8 *bssid = bss_conf->bssid;
> +	bool config_bfee = false;
>  	u32 sound_dim;
>  	u8 i;
> 

The rcu_read_lock() in this function is used to access ieee80211_find_sta() and protect 'sta'.
A simple way is to shrink the critical section, like:

	rcu_read_lock();

	sta = ieee80211_find_sta(vif, bssid);
	if (!sta) {
		rtw_warn(rtwdev, "failed to find station entry for bss %pM\n",
			 bssid);
		rcu_read_unlock();
	}

	vht_cap = &sta->vht_cap;

	rcu_read_unlock();


--
Ping-Ke


