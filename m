Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78EB63E6BC
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLAAyl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Nov 2022 19:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLAAyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:54:41 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 655C654356;
        Wed, 30 Nov 2022 16:54:37 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B10rQZO1013390, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B10rQZO1013390
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 1 Dec 2022 08:53:26 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 1 Dec 2022 08:54:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 1 Dec 2022 08:54:11 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 1 Dec 2022 08:54:11 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     JunASAKA <JunASAKA@zzy040330.moe>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Topic: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Index: AQHZBMW0Ra7MKeD5kEmSajNwR0qaiK5YM5hw
Date:   Thu, 1 Dec 2022 00:54:11 +0000
Message-ID: <663e6d79c34f44998a937fe9fbd228e9@realtek.com>
References: <20221130140849.153705-1-JunASAKA@zzy040330.moe>
In-Reply-To: <20221130140849.153705-1-JunASAKA@zzy040330.moe>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/30_=3F=3F_10:00:00?=
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
> From: JunASAKA <JunASAKA@zzy040330.moe>
> Sent: Wednesday, November 30, 2022 10:09 PM
> To: Jes.Sorensen@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; JunASAKA
> <JunASAKA@zzy040330.moe>
> Subject: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
> 
> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
> issues for rtl8192eu chips by replacing the arguments with
> the ones in the updated official driver.

I think it would be better if you can point out which version you use, and
people will not modify them back to old version suddenly.

> 
> Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
> ---
>  .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 76 +++++++++++++------
>  1 file changed, 54 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> index b06508d0cd..82346500f2 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c

[...]

> @@ -891,22 +907,28 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
> 
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00180);
> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> 
> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x20000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0x07f77);
> +
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> 
> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> +

I think this is a test code of vendor driver. No need them here. 


>  	/* Path B IQK setting */
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
> 
> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x821403e2);
> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82140303);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160000);
> 
>  	/* LO calibration setting */
> -	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00492911);
> +	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
> 
>  	/* One shot, path A LOK & IQK */
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);

[...]

I have compared your patch with internal code, and they are the same.
But, I don't have a test.

Ping-Ke

