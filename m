Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C643B638536
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiKYIaI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Nov 2022 03:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiKYIaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:30:06 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F30731210;
        Fri, 25 Nov 2022 00:30:05 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AP8StpE6006039, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AP8StpE6006039
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 25 Nov 2022 16:28:55 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 25 Nov 2022 16:29:38 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 25 Nov 2022 16:29:38 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 25 Nov 2022 16:29:38 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>,
        "Bernie Huang" <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: RE: [PATCH v3 03/11] rtw88: Drop rf_lock
Thread-Topic: [PATCH v3 03/11] rtw88: Drop rf_lock
Thread-Index: AQHY/oIygBK3Wh67DEaTX45BCElsma5PUv2Q
Date:   Fri, 25 Nov 2022 08:29:38 +0000
Message-ID: <71f8444cb3bf4859843339614f61a6e8@realtek.com>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
 <20221122145226.4065843-4-s.hauer@pengutronix.de>
In-Reply-To: <20221122145226.4065843-4-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/25_=3F=3F_06:00:00?=
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
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, November 22, 2022 10:52 PM
> To: linux-wireless@vger.kernel.org
> Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> Sascha Hauer <s.hauer@pengutronix.de>
> Subject: [PATCH v3 03/11] rtw88: Drop rf_lock
> 
> The rtwdev->rf_lock spinlock protects the rf register accesses in
> rtw_read_rf() and rtw_write_rf(). Most callers of these functions hold
> rtwdev->mutex already with the exception of the callsites in the debugfs
> code. The debugfs code doesn't justify an extra lock, so acquire the mutex
> there as well before calling rf register accessors and drop the now
> unnecessary spinlock.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

