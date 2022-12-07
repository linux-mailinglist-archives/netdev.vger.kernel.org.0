Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5454F64529D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLGDno convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Dec 2022 22:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLGDnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:43:42 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24DDAB57;
        Tue,  6 Dec 2022 19:43:41 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B73gUfqD027835, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B73gUfqD027835
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 7 Dec 2022 11:42:30 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 7 Dec 2022 11:43:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 7 Dec 2022 11:43:17 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 7 Dec 2022 11:43:17 +0800
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
Subject: RE: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Topic: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Index: AQHZCe2b+2Cm8cdsR0GFzEgG7Xr+X65hx/Zw
Date:   Wed, 7 Dec 2022 03:43:17 +0000
Message-ID: <2ac07b1d6e06443b95befb79d27549d2@realtek.com>
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
In-Reply-To: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/7_=3F=3F_01:28:00?=
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
> Sent: Wednesday, December 7, 2022 11:39 AM
> To: Jes.Sorensen@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
> <JunASAKA@zzy040330.moe>; Ping-Ke Shih <pkshih@realtek.com>
> Subject: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
> 
> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
> issues for rtl8192eu chips by replacing the arguments with
> the ones in the updated official driver as shown below.
> 1. https://github.com/Mange/rtl8192eu-linux-driver
> 2. vendor driver version: 5.6.4
> 
> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
> v5:
>  - no modification.

Then, why do you need v5?

> v4:
>  - fixed some mistakes.
> v3:
>  - add detailed info about the newer version this patch used.
>  - no functional update.
> ---
> ---

[...]

