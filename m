Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142503C6D21
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhGMJWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:22:32 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55525 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbhGMJWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 05:22:31 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16D9JWKd8010080, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16D9JWKd8010080
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 13 Jul 2021 17:19:32 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Jul 2021 17:19:32 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 13 Jul
 2021 17:19:31 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/2] r8152: split the source code
Date:   Tue, 13 Jul 2021 17:18:34 +0800
Message-ID: <1394712342-15778-368-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/13/2021 03:03:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMTMgpFekyCAwMTowNjowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMTMgpFekyCAwNzo0OTowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/13/2021 08:57:21
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165001 [Jul 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/13/2021 09:01:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The r8152.c is too large to find out the desired part, so I speparate it
into r8152_main.c and r8152_fw.c.

Hayes Wang (2):
  r8152: group the usb ethernet of realtek
  r8152: separate the r8152.c into r8152_main.c and r8152_fw.c

 MAINTAINERS                                   |   10 +-
 drivers/net/usb/Kconfig                       |   30 +-
 drivers/net/usb/Makefile                      |    4 +-
 drivers/net/usb/realtek/Kconfig               |   33 +
 drivers/net/usb/realtek/Makefile              |    9 +
 drivers/net/usb/realtek/r8152_basic.h         |  860 ++++++
 drivers/net/usb/realtek/r8152_fw.c            | 1557 ++++++++++
 .../net/usb/{r8152.c => realtek/r8152_main.c} | 2585 +----------------
 drivers/net/usb/{ => realtek}/r8153_ecm.c     |    0
 drivers/net/usb/{ => realtek}/rtl8150.c       |    0
 10 files changed, 2576 insertions(+), 2512 deletions(-)
 create mode 100644 drivers/net/usb/realtek/Kconfig
 create mode 100644 drivers/net/usb/realtek/Makefile
 create mode 100644 drivers/net/usb/realtek/r8152_basic.h
 create mode 100644 drivers/net/usb/realtek/r8152_fw.c
 rename drivers/net/usb/{r8152.c => realtek/r8152_main.c} (75%)
 rename drivers/net/usb/{ => realtek}/r8153_ecm.c (100%)
 rename drivers/net/usb/{ => realtek}/rtl8150.c (100%)

-- 
2.26.3

