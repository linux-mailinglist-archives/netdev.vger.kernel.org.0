Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56B3D584C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhGZK2x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Jul 2021 06:28:53 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40035 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbhGZK2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 06:28:49 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16QB97Bj8004450, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16QB97Bj8004450
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 19:09:07 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 19:09:07 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 19:09:06 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 26 Jul 2021 19:09:06 +0800
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
Thread-Index: AQHXgdL4UhnFIS2opkGLRT1L0R8XUatUWD4AgACR1mD//38YAIAAqNrw
Date:   Mon, 26 Jul 2021 11:09:06 +0000
Message-ID: <47801164b7b3406b895be1542e0ce4a2@realtek.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
 <1394712342-15778-373-Taiwan-albertk@realtek.com>
 <YP5mFKeJsGezjdve@kroah.com> <c6b44f93a5b14fbb98d4c6cb0ed2a77f@realtek.com>
 <YP50SIgqAEyKWSpA@kroah.com>
In-Reply-To: <YP50SIgqAEyKWSpA@kroah.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/7/26_=3F=3F_10:24:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 10:49:04
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165241 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 10:51:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, July 26, 2021 4:37 PM
[...]
> You also do other things, like renaming defines, which is not just
> moving code around, right?

Yes. You are right.

[...]
> I do not know, is it really easier to find things in 3 different files
> instead of one?  That's up to you, but you did not say why this change
> is needed.

We support a new chip or feature with a test driver.
The test driver is similar with the upstream driver, except
the method of the firmware. After we confirm that the
test driver work fine, we compare the differences with
the upstream driver and submit patches. And the code
about firmware takes us more time to find out the
differences. Therefore, I wish to move the part of
the firmware out.

I don't sure if it is acceptable for such patches.
If it is unacceptable, I would abandon these patches.

Best Regards,
Hayes


