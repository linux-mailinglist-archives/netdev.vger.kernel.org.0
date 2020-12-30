Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36E2E75DF
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 04:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL3Dr6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Dec 2020 22:47:58 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40013 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgL3Dr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 22:47:58 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0BU3kxNqB019409, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0BU3kxNqB019409
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Dec 2020 11:46:59 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 30 Dec 2020 11:46:59 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 30 Dec 2020 11:46:58 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Wed, 30 Dec 2020 11:46:58 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Tian Tao <tiantao6@hisilicon.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] rtw88: coex: remove useless if and else
Thread-Topic: [PATCH] rtw88: coex: remove useless if and else
Thread-Index: AQHW2F4yxyUKKBxgKEKYnoZyzpOw4KoPCTkg
Date:   Wed, 30 Dec 2020 03:46:58 +0000
Message-ID: <b5be281952ed470a8af59044909a8fda@realtek.com>
References: <1608640137-8914-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1608640137-8914-1-git-send-email-tiantao6@hisilicon.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Tian Tao [mailto:tiantao6@hisilicon.com]
> Sent: Tuesday, December 22, 2020 8:29 PM
> To: tony0620emma@gmail.com; kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org
> Subject: [PATCH] rtw88: coex: remove useless if and else
> 
> Fix the following coccinelle report:
> drivers/net/wireless/realtek/rtw88/coex.c:1619:3-5: WARNING:
> possible condition with no effect (if == else)
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/net/wireless/realtek/rtw88/coex.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
> index 24530ca..df6676a 100644
> --- a/drivers/net/wireless/realtek/rtw88/coex.c
> +++ b/drivers/net/wireless/realtek/rtw88/coex.c
> @@ -1616,12 +1616,7 @@ static void rtw_coex_action_bt_relink(struct rtw_dev *rtwdev)
>  	if (efuse->share_ant) { /* Shared-Ant */
>  		if (coex_stat->wl_gl_busy) {
>  			table_case = 26;
> -			if (coex_stat->bt_hid_exist &&
> -			    coex_stat->bt_profile_num == 1) {
> -				tdma_case = 20;
> -			} else {
> -				tdma_case = 20;
> -			}
> +			tdma_case = 20;
>  		} else {
>  			table_case = 1;
>  			tdma_case = 0;

I found we miss something in these branches, so I sent a patch,
namely "rtw88: coex: set 4 slot TDMA for BT link and WL busy", to fix it.

The link is
https://patchwork.kernel.org/project/linux-wireless/patch/20201230033602.13636-1-pkshih@realtek.com/

---
Ping-Ke


