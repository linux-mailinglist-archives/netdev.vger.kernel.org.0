Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E6F57C05
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfF0GVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 02:21:20 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:41120
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbfF0GVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 02:21:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=O+j0kcZVejYm5ysJ+WsPcV78k6Q9f88wSKxOHEScOXIMglKwjlVYswR64KT9BSlr8eZOaNzUw7jGPbTta17q4scZ2bjriR4Ei14ftBWXsf6lBFf77tNxzxNl5gNC8LzIvTJYc/44vHg5ziIXPATZnORL3PeBAtE5lN1nrpkvp7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46r8f9mobkZAbaAajx8ul/ZN/mmfgY8LpqR3gTMNYbU=;
 b=HDEmMXnlEA65c1qbVlOtX9KEYcKcg1fCkK0kis0HjePg2EHVP9HWa//DUP/JEh1Sqnz9V2mzlRYBwxDMhulThmRDi7SjbdH919w8MXLp1gLOXxFr8midoh5B26soA6gn8NB89VbbPfeW3Zu9cMNBNEbBiXf4w2ZxO1MiEfdpEpI=
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=gmail.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46r8f9mobkZAbaAajx8ul/ZN/mmfgY8LpqR3gTMNYbU=;
 b=G8JysHyXJPloJ1PwYx10ZPrJiytG0NglhzBZUL8vDik8mLss2QtTf1mR///EocDl6apyfDtRWEUVGSsXNXc7I58Us8Wk38bYVvea+beTxz98iSHK0m6h3JpMGKugiB/GdaCMhMjt4ZR7mUD2FftRfk6ALIFIxw0Z2qKMbNoSiOY=
Received: from SN4PR0201CA0052.namprd02.prod.outlook.com
 (2603:10b6:803:20::14) by BL0PR02MB3731.namprd02.prod.outlook.com
 (2603:10b6:207:48::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Thu, 27 Jun
 2019 06:21:17 +0000
Received: from BL2NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by SN4PR0201CA0052.outlook.office365.com
 (2603:10b6:803:20::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2032.17 via Frontend
 Transport; Thu, 27 Jun 2019 06:21:16 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT028.mail.protection.outlook.com (10.152.77.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2032.15
 via Frontend Transport; Thu, 27 Jun 2019 06:21:16 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:40868 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmV-0005e6-Rl; Wed, 26 Jun 2019 23:21:15 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmP-0007pI-O5; Wed, 26 Jun 2019 23:21:09 -0700
Received: from xsj-pvapsmtp01 (smtp3.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x5R6L5Ki000576;
        Wed, 26 Jun 2019 23:21:06 -0700
Received: from [172.23.37.92] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmK-0007mn-GI; Wed, 26 Jun 2019 23:21:04 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        rafalo@cadence.com, andrei.pistirica@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH 0/2] Sub ns increment fixes in Macb PTP
Date:   Thu, 27 Jun 2019 11:50:58 +0530
Message-Id: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(2980300002)(189003)(199004)(9786002)(186003)(63266004)(4326008)(8676002)(81156014)(316002)(44832011)(16586007)(305945005)(2906002)(50226002)(478600001)(26005)(8936002)(77096007)(81166006)(47776003)(486006)(107886003)(7696005)(48376002)(106002)(4744005)(2616005)(51416003)(36756003)(476003)(336012)(6666004)(356004)(70206006)(70586007)(5660300002)(50466002)(126002)(426003)(36386004)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB3731;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af1e7efa-ab20-4cd1-2898-08d6fac7a955
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR02MB3731;
X-MS-TrafficTypeDiagnostic: BL0PR02MB3731:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BL0PR02MB3731F3FCFF56A250C022E224C9FD0@BL0PR02MB3731.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 008184426E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: frGW2ceLnaCckf0ME8RdNiCKDQb3VNKULqcHW9S8K50jECSwrEpuB9cro734RGDi7a5M4mhL5URV5Y2TlntW7IPd83NYMqILkMkPWkHRONXs2mmC0AFg6/yUh72OO8xjyZ/4eLYqqtTJSHBqbNE0MXe/FxMY9afe5nmBjKZOvwETVwxu5pCXwjzsKtOptnBQnthMGQIKjR3epPAobeqOO1oKDeLzrIha+CACRSIUGiFddjGGbg9Vb2bd/Gr8lqSnPPF3vnZPwNTDZP8jAxcMQEm/TuqryPHw+PNyzP1w2/j8kxUPhEoFhc6em5obBGDxDA+UqNHa6HnlYj6keQP1q4mQ702xC2i/HYNDIeCSo+6ZYboeUlCocfTXZYpZUAJgVNsU0CMD2EQ37OIcjNcA+Q5XAttJU//R+IwX/f5G5Jw=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2019 06:21:16.4158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af1e7efa-ab20-4cd1-2898-08d6fac7a955
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subns increment register fields are not captured correctly in the
driver. Fix the same and also increase the subns incr resolution.

Sub ns resolution was increased to 24 bits in r1p06f2 version. To my
knowledge, this PTP driver, with its current BD time stamp
implementation, is only useful to that version or above. So, I have
increased the resolution unconditionally. Please let me know if there
is any IP versions incompatible with this - there is no register to
obtain this information from.

Changes from RFC:
None

Harini Katakam (2):
  net: macb: Add separate definition for PPM fraction
  net: macb: Fix SUBNS increment and increase resolution

 drivers/net/ethernet/cadence/macb.h     | 9 ++++++++-
 drivers/net/ethernet/cadence/macb_ptp.c | 7 +++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.7.4

