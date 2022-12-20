Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33B0651A5D
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 06:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiLTFpU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Dec 2022 00:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLTFpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 00:45:18 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C9F66343;
        Mon, 19 Dec 2022 21:45:14 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BK5hpWW3002719, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BK5hpWW3002719
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 20 Dec 2022 13:43:51 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 20 Dec 2022 13:44:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 20 Dec 2022 13:44:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Tue, 20 Dec 2022 13:44:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Thread-Topic: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for
 rtl8192eu
Thread-Index: AQHZEcSxpWNKKfbUGEumZ8h5P7r+XK52Rmng
Date:   Tue, 20 Dec 2022 05:44:42 +0000
Message-ID: <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
In-Reply-To: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/20_=3F=3F_02:24:00?=
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
> From: Jun ASAKA <JunASAKA@zzy040330.moe>
> Sent: Saturday, December 17, 2022 11:07 AM
> To: Jes.Sorensen@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
> <JunASAKA@zzy040330.moe>
> Subject: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
> 
> Fixing transmission failure which results in
> "authentication with ... timed out". This can be
> fixed by disable the REG_TXPAUSE.
> 
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> index a7d76693c02d..9d0ed6760cb6 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>  	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>  	val8 &= ~BIT(0);
>  	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
> +
> +	/*
> +	 * Fix transmission failure of rtl8192e.
> +	 */
> +	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);

I trace when rtl8xxxu set REG_TXPAUSE=0xff that will stop TX.
The occasions include RF calibration, LPS mode (called by power off), and
going to stop. So, I think RF calibration does TX pause but not restore
settings after calibration, and causes TX stuck. As the flow I traced,
this patch looks reasonable. But, I wonder why other people don't meet
this problem.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

>  }
> 
>  static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
> --
> 2.31.1

