Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299BA47ECE0
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 08:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343679AbhLXHv6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Dec 2021 02:51:58 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36097 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbhLXHvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 02:51:55 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BO7pbtR7026286, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BO7pbtR7026286
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Dec 2021 15:51:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 24 Dec 2021 15:51:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 15:51:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Fri, 24 Dec 2021 15:51:36 +0800
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
Subject: RE: [PATCH v2] rtw88: check for validity before using a pointer
Thread-Topic: [PATCH v2] rtw88: check for validity before using a pointer
Thread-Index: AQHX+JjdqbMhpjQqZU2TmT2RdU93eaxBQ8nw
Date:   Fri, 24 Dec 2021 07:51:36 +0000
Message-ID: <df6c53db84a14723b6ba059cfa8cb0ae@realtek.com>
References: <YcV4Qkc9PrrmkOim@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <YcV4Qkc9PrrmkOim@debian-BULLSEYE-live-builder-AMD64>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/24_=3F=3F_04:02:00?=
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
> Sent: Friday, December 24, 2021 3:36 PM
> To: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Bernie Huang <phhuang@realtek.com>; Pkshih
> <pkshih@realtek.com>; open list:REALTEK WIRELESS DRIVER (rtw88) <linux-wireless@vger.kernel.org>; open
> list:NETWORKING DRIVERS <netdev@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Cc: usama.anjum@collabora.com; kernel@collabora.com
> Subject: [PATCH v2] rtw88: check for validity before using a pointer
> 
> ieee80211_probereq_get() can return NULL. Pointer skb should be checked
> for validty before use. If it is not valid, list of skbs needs to be
> freed to not memory leak.
> 
> Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> 
> ---
> v2:
> Free the list in case of error
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 2f7c036f9022..7e1fab7afb69 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1857,7 +1857,7 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
>  {
>  	struct cfg80211_scan_request *req = rtwvif->scan_req;
>  	struct sk_buff_head list;
> -	struct sk_buff *skb;
> +	struct sk_buff *skb, *tmp;
>  	u8 num = req->n_ssids, i;
> 
>  	skb_queue_head_init(&list);
> @@ -1866,11 +1866,19 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
>  					     req->ssids[i].ssid,
>  					     req->ssids[i].ssid_len,
>  					     req->ie_len);
> +		if (!skb)
> +			goto out;
>  		rtw_append_probe_req_ie(rtwdev, skb, &list, rtwvif);
>  		kfree_skb(skb);
>  	}
> 
>  	return _rtw_hw_scan_update_probe_req(rtwdev, num, &list);
> +
> +out:
> +	skb_queue_walk_safe(&list, skb, tmp)

Don't you think skb_queue_walk() is enough? Because we don't need to do
skb_unlink() in the loop.

> +		kfree_skb(skb);
> +
> +	return -ENOMEM;
>  }
> 
>  static int rtw_add_chan_info(struct rtw_dev *rtwdev, struct rtw_chan_info *info,
> --

Ping-Ke

