Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05125628E69
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiKOAb7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Nov 2022 19:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKOAb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:31:58 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52387D2D9;
        Mon, 14 Nov 2022 16:31:57 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AF0UxnS6016872, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AF0UxnS6016872
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 15 Nov 2022 08:30:59 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 15 Nov 2022 08:31:39 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 15 Nov 2022 08:31:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Tue, 15 Nov 2022 08:31:38 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Timlee <timlee@realtek.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: Fix some error handling path in rtw89_wow_enable()
Thread-Topic: [PATCH] wifi: rtw89: Fix some error handling path in
 rtw89_wow_enable()
Thread-Index: AQHY93aSGfNpN1UcU0efciL+7dUV5q4/JDqg
Date:   Tue, 15 Nov 2022 00:31:38 +0000
Message-ID: <3e97dad2b634434abf266a17030df464@realtek.com>
References: <32320176eeff1c635baeea25ef0e87d116859e65.1668354083.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <32320176eeff1c635baeea25ef0e87d116859e65.1668354083.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/14_=3F=3F_10:23:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, November 13, 2022 11:42 PM
> To: Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Timlee <timlee@realtek.com>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org
> Subject: [PATCH] wifi: rtw89: Fix some error handling path in rtw89_wow_enable()
> 
> 'ret' is not updated after several function calls in rtw89_wow_enable().
> This prevent error handling from working.
> 
> Add the missing assignments.
> 
> Fixes: 19e28c7fcc74 ("wifi: rtw89: add WoWLAN function support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Thanks for the fixes.

> ---
>  drivers/net/wireless/realtek/rtw89/wow.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
> index 7de4dd047d6b..b2b826b2e09a 100644
> --- a/drivers/net/wireless/realtek/rtw89/wow.c
> +++ b/drivers/net/wireless/realtek/rtw89/wow.c
> @@ -744,13 +744,13 @@ static int rtw89_wow_enable(struct rtw89_dev *rtwdev)
>  		goto out;
>  	}
> 
> -	rtw89_wow_swap_fw(rtwdev, true);
> +	ret = rtw89_wow_swap_fw(rtwdev, true);
>  	if (ret) {
>  		rtw89_err(rtwdev, "wow: failed to swap to wow fw\n");
>  		goto out;
>  	}
> 
> -	rtw89_wow_fw_start(rtwdev);
> +	ret = rtw89_wow_fw_start(rtwdev);
>  	if (ret) {
>  		rtw89_err(rtwdev, "wow: failed to let wow fw start\n");
>  		goto out;
> @@ -758,7 +758,7 @@ static int rtw89_wow_enable(struct rtw89_dev *rtwdev)
> 
>  	rtw89_wow_enter_lps(rtwdev);
> 
> -	rtw89_wow_enable_trx_post(rtwdev);
> +	ret = rtw89_wow_enable_trx_post(rtwdev);
>  	if (ret) {
>  		rtw89_err(rtwdev, "wow: failed to enable trx_post\n");
>  		goto out;
> --
> 2.34.1

