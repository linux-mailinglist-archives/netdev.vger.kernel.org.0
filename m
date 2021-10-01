Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3721C41E60C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 04:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351578AbhJACm2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Sep 2021 22:42:28 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39036 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhJACm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 22:42:27 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1912e6Ho9025237, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1912e6Ho9025237
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 1 Oct 2021 10:40:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 10:40:05 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 1 Oct 2021 10:40:05 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Fri, 1 Oct 2021 10:40:05 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>
CC:     Jason-ch Chen <jason-ch.chen@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] r8152: stop submitting rx for -EPROTO
Thread-Topic: [PATCH] r8152: stop submitting rx for -EPROTO
Thread-Index: AQHXtPF6mRt31KuIqUSf0ySwz113xKu6nqYQ//+g0oCAAYwXgIAAYT6AgAFAzFA=
Date:   Fri, 1 Oct 2021 02:40:05 +0000
Message-ID: <3694347f29ed431e9f8f2c065b8df0a7@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
 <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
 <20210930151819.GC464826@rowland.harvard.edu>
In-Reply-To: <20210930151819.GC464826@rowland.harvard.edu>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/9/29_=3F=3F_11:27:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu>
[...]
> There has been some discussion about this in the past.
> 
> In general, -EPROTO is almost always a non-recoverable error.

Excuse me. I am confused about the above description.
I got -EPROTO before, when I debugged another issue.
However, the bulk transfer still worked after I resubmitted
the transfer. I didn't do anything to recover it. That is why
I do resubmission for -EPROTO.

Best Regards,
Hayes

