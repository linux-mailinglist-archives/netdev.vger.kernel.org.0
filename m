Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6393663FCA0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiLBAPW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Dec 2022 19:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiLBAPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:15:21 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 058A6CEFA3;
        Thu,  1 Dec 2022 16:15:18 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B20E0Tx8024077, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B20E0Tx8024077
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 2 Dec 2022 08:14:00 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 2 Dec 2022 08:14:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 2 Dec 2022 08:14:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 2 Dec 2022 08:14:45 +0800
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
Subject: RE: [PATCH v4] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Topic: [PATCH v4] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Index: AQHZBaAttu+xtGf8D06PUMSs/AI8oq5Zussw
Date:   Fri, 2 Dec 2022 00:14:45 +0000
Message-ID: <48d5141e5b2f4309bde78cacb67341a3@realtek.com>
References: <20221201161453.16800-1-JunASAKA@zzy040330.moe>
In-Reply-To: <20221201161453.16800-1-JunASAKA@zzy040330.moe>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/1_=3F=3F_10:08:00?=
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
> From: Jun ASAKA <JunASAKA@zzy040330.moe>
> Sent: Friday, December 2, 2022 12:15 AM
> To: Jes.Sorensen@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
> <JunASAKA@zzy040330.moe>
> Subject: [PATCH v4] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
> 
> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
> issues for rtl8192eu chips by replacing the arguments with
> the ones in the updated official driver as shown below.
> 1. https://github.com/Mange/rtl8192eu-linux-driver
> 2. vendor driver version: 5.6.4
> 
> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> v4:
>  - fixed some mistakes.
> v3:
>  - add detailed info about the newer version this patch used.
>  - no functional update.
> ---
>  .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 73 +++++++++++++------
>  1 file changed, 51 insertions(+), 22 deletions(-)
> 

[...]

