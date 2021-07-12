Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7848F3C410F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 03:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhGLBqi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Jul 2021 21:46:38 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53672 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGLBqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 21:46:36 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16C1hI9l9017941, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16C1hI9l9017941
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Jul 2021 09:43:18 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Jul 2021 09:43:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Jul 2021 09:43:17 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 12 Jul 2021 09:43:17 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Len Baker <len.baker@gmx.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88: Fix out-of-bounds write
Thread-Topic: [PATCH] rtw88: Fix out-of-bounds write
Thread-Index: AQHXdl+EGA/su576nUeih433YVyLrqs+jtWA
Date:   Mon, 12 Jul 2021 01:43:16 +0000
Message-ID: <b0811e08c4a04d2093f3251c55c0edb8@realtek.com>
References: <20210711141634.6133-1-len.baker@gmx.com>
In-Reply-To: <20210711141634.6133-1-len.baker@gmx.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/7/11_=3F=3F_01:07:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?us-ascii?Q?Clean,_bases:_2021/7/12_=3F=3F_12:23:00?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/12/2021 01:29:20
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164962 [Jul 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/12/2021 01:32:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Len Baker [mailto:len.baker@gmx.com]
> Sent: Sunday, July 11, 2021 10:17 PM
> To: Yan-Hsuan Chuang; Kalle Valo; David S. Miller; Jakub Kicinski
> Cc: Len Baker; Stanislaw Gruszka; Brian Norris; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: [PATCH] rtw88: Fix out-of-bounds write
> 
> In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> statement guarantees that len is less than or equal to GENMASK(11, 0) or
> in other words that len is less than or equal to 4095. However the
> rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> way it is possible an out-of-bounds write in the for statement due to
> the i variable can exceed the rx_ring->buff size.
> 
> Fix it using the ARRAY_SIZE macro.
> 
> Cc: stable@vger.kernel.org
> Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")
> Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index e7d17ab8f113..b9d8c049e776 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -280,7 +280,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,

I think "if (len > TRX_BD_IDX_MASK)" you mentioned is

	if (len > TRX_BD_IDX_MASK) {
		rtw_err(rtwdev, "len %d exceeds maximum RX entries\n", len);
		return -EINVAL;
	}

This statement is used to ensure the length doesn't exceed hardware capability.

To prevent the 'len' argument from exceeding the array size of rx_ring->buff, I
suggest to add another checking statement, like

	if (len > ARRAY_SIZE(rx_ring->buf)) {
		rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer\n", len);
		return -EINVAL;
	}

But, I wonder if this a false alarm because 'len' is equal to ARRAY_SIZE(rx_ring->buf)
for now.


>  	}
>  	rx_ring->r.head = head;
> 
> -	for (i = 0; i < len; i++) {
> +	for (i = 0; i < ARRAY_SIZE(rx_ring->buf); i++) {
>  		skb = dev_alloc_skb(buf_sz);
>  		if (!skb) {
>  			allocated = i;
> --
> 2.25.1

--
Ping-Ke

