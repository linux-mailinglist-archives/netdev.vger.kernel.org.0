Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5486C3D5599
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhGZHpn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Jul 2021 03:45:43 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55731 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhGZHpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:45:42 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16Q8Q25q8028578, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16Q8Q25q8028578
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 16:26:02 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 16:26:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 16:26:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 26 Jul 2021 16:26:00 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next RESEND 2/2] r8152: separate the r8152.c into r8152_main.c and r8152_fw.c
Thread-Topic: [PATCH net-next RESEND 2/2] r8152: separate the r8152.c into
 r8152_main.c and r8152_fw.c
Thread-Index: AQHXgdL4UhnFIS2opkGLRT1L0R8XUatUWD4AgACR1mA=
Date:   Mon, 26 Jul 2021 08:26:00 +0000
Message-ID: <c6b44f93a5b14fbb98d4c6cb0ed2a77f@realtek.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
 <1394712342-15778-373-Taiwan-albertk@realtek.com>
 <YP5mFKeJsGezjdve@kroah.com>
In-Reply-To: <YP5mFKeJsGezjdve@kroah.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/7/26_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 08:11:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165233 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 08:15:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, July 26, 2021 3:37 PM
[...]
> That is a lot of different things all happening in one commit, why?

I plan to separate the file into two files. And
I find I need an additional header file for it, so
The patch includes adding that header file.

> Please break this up into "one patch per change" and submit it that way.
> 
> But the real question is why break this file up in the first place?
> What is wrong with the way it is today?  What future changes require
> this file to be in smaller pieces?  If none, why make this?  If there
> are future changes, then please submit this change when you submit
> those, as that would show a real need.

The purpose is let me easy to maintain the driver.
The code is larger and larger. And I find that the
r8169.c has been separated into three files.
Therefore, I think maybe I could split the driver
into small parts like r8169. Then, the code wouldn't
be complex.

Should I abandon these patches?

Best Regards,
Hayes

