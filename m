Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B553CCD9D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 07:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhGSFt4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Jul 2021 01:49:56 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56195 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhGSFt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 01:49:56 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16J5kfuX7028550, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16J5kfuX7028550
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Jul 2021 13:46:41 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Jul 2021 13:46:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Jul 2021 13:46:38 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 19 Jul 2021 13:46:38 +0800
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
Subject: RE: [PATCH RFC v1 1/7] mac80211: Add stations iterator where the iterator function may sleep
Thread-Topic: [PATCH RFC v1 1/7] mac80211: Add stations iterator where the
 iterator function may sleep
Thread-Index: AQHXe0wjq+ZTIn5bM0GxLYVmi50q+atJnqoQ
Date:   Mon, 19 Jul 2021 05:46:37 +0000
Message-ID: <acc6859708ca4514b76f60e7a648a86a@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210717204057.67495-2-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
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
> Subject: [PATCH RFC v1 1/7] mac80211: Add stations iterator where the iterator function may sleep
> 
> ieee80211_iterate_active_interfaces() and
> ieee80211_iterate_active_interfaces_atomic() already exist, where the
> former allows the iterator function to sleep. Add
> ieee80211_iterate_stations() which is similar to
> ieee80211_iterate_stations_atomic() but allows the iterator to sleep.
> This is needed for adding SDIO support to the rtw88 driver. Some
> interators there are reading or writing registers. With the SDIO ops
> (sdio_readb, sdio_writeb and friends) this means that the iterator
> function may sleep.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  include/net/mac80211.h | 18 ++++++++++++++++++
>  net/mac80211/util.c    | 13 +++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d8a1d09a2141..77de89690008 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -5575,6 +5575,24 @@ void ieee80211_iterate_active_interfaces_mtx(struct ieee80211_hw *hw,
>  						struct ieee80211_vif *vif),
>  					     void *data);
> 
> +/**
> + * ieee80211_iterate_stations_atomic - iterate stations

ieee80211_iterate_stations - ...

[...]

--
Ping-Ke

