Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B635947E9E2
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 01:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbhLXA26 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Dec 2021 19:28:58 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38060 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhLXA2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 19:28:55 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BO0SYiH4000307, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BO0SYiH4000307
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Dec 2021 08:28:34 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 24 Dec 2021 08:28:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 24 Dec 2021 08:28:34 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Fri, 24 Dec 2021 08:28:33 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "kernel@collabora.com" <kernel@collabora.com>
Subject: RE: [PATCH] rtw88: check for validity before using pointer
Thread-Topic: [PATCH] rtw88: check for validity before using pointer
Thread-Index: AQHX+CW4CiEO5Mr47Uyo81NvZcLlw6xAwyPg
Date:   Fri, 24 Dec 2021 00:28:33 +0000
Message-ID: <100d06e2398742bb82bd5300ce70d900@realtek.com>
References: <YcS3D2lwMd0Kox3z@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <YcS3D2lwMd0Kox3z@debian-BULLSEYE-live-builder-AMD64>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/23_=3F=3F_07:48:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Sent: Friday, December 24, 2021 1:51 AM
> To: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Pkshih <pkshih@realtek.com>; Bernie Huang
> <phhuang@realtek.com>; open list:REALTEK WIRELESS DRIVER (rtw88) <linux-wireless@vger.kernel.org>; open
> list:NETWORKING DRIVERS <netdev@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Cc: usama.anjum@collabora.com; kernel@collabora.com
> Subject: [PATCH] rtw88: check for validity before using pointer
> 
> ieee80211_probereq_get() can return NULL. Pointer skb should be checked
> for validty before use.
> 
> Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 2f7c036f9022..0fc05a810d05 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1866,6 +1866,8 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
>  					     req->ssids[i].ssid,
>  					     req->ssids[i].ssid_len,
>  					     req->ie_len);
> +		if (!skb)
> +			return -ENOMEM;
>  		rtw_append_probe_req_ie(rtwdev, skb, &list, rtwvif);
>  		kfree_skb(skb);
>  	}

Without properly freeing skb(s) in list, it leads memory leak.
We need something below to free them:

	if (!skb)
		goto out;

	[...]

out:
	skb_queue_walk(&list, skb)
		kfree_skb(skb);

	return -ENOMEM;

So, NACK this patch.

--
Ping-Ke

