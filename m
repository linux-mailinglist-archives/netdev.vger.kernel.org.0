Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535211530E2
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBEMia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:38:30 -0500
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:54561
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbgBEMi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 07:38:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1EV8PN4QmLEUJDjFz0Qgp7it9PMgXSydudgzbEgRIh0V5EsGlqre+FrEInDvam2aG7T65mid3fWAWJk73Q+LnBw1KyoX369Me8WB2kYXsVHQpO4En95DJTrPm6RhhP3X6vtbD1Tg+fRomi8zi6SXzi37g4boqkDCd4LW298qBPL3SpEqgAPNf2/1i6qykvwcssw7SaZJv632RbuO3X/YP8j48fjBXMkagDqyv6hgWCJT+lpmOvFCoWnd/iunsa85H+2IL/TnQ+/ivotcX01P0KItSpd/BX3+5J8bakjM2meIuYZdwdlv2oi3ne+gzQ/8mmwW33ypRF3doGiDq4HMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6qw6+VfszUYjflUjek9CgjnQsL4hjffM/LZB92hNPg=;
 b=AJP+z4AaXArKpBYIUgNuil8Ws1aTeZCJgdYLcwGfKXWiXTTI2Vc9Dnna2LNvinfthp6K4E0oFM8c/Rj3ge82hXfQEjH8+IcpnGQJ8SB8LnQUI7uFw1A5tED6bBbR7efDdBSrbRoMhwHD5htRbFjOOxl4d6auVyAL7S602+j+TnFRnUMZYu2MuZxQdpoQfaUJu1Y9tSYKdandpepdgdxcesa+3+iGWTWdk6AQkEfP/kV3HBL2eLkHXX2f/XlZ6pvgN9Yvm9QLqULys0JT/o62CVLXlMP01hsFPu71ECpegzQ5XImy6rgyrkXtbbiZQwxvpvpAeYNEVsuOcFg7gpwsjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6qw6+VfszUYjflUjek9CgjnQsL4hjffM/LZB92hNPg=;
 b=sBsUdT/FJvnVmaGznI0LfipyNNBy+JLGa0HP/ZnirTtttzVmylHrxtrEb5Tv80dzNnFsK0FY5+2TnKp1qYPCWepHSpNXFbWk0dki0zEO0YazqUT4ImZoN8w4DhCetab93+kGuihvHVodU1j3CNmQuRZtBBO/YM2JSmkxkyDBXL8=
Received: from BYAPR02CA0044.namprd02.prod.outlook.com (2603:10b6:a03:54::21)
 by BL0PR02MB4561.namprd02.prod.outlook.com (2603:10b6:208:42::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.26; Wed, 5 Feb
 2020 12:38:25 +0000
Received: from BL2NAM02FT043.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by BYAPR02CA0044.outlook.office365.com
 (2603:10b6:a03:54::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.34 via Frontend
 Transport; Wed, 5 Feb 2020 12:38:24 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT043.mail.protection.outlook.com (10.152.77.95) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2707.21
 via Frontend Transport; Wed, 5 Feb 2020 12:38:24 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwl-0001wt-Ot; Wed, 05 Feb 2020 04:38:23 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwg-0007vR-KC; Wed, 05 Feb 2020 04:38:18 -0800
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 015CcGir009590;
        Wed, 5 Feb 2020 04:38:16 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwd-0007uq-PR; Wed, 05 Feb 2020 04:38:16 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH v3 0/2] TSO bug fixes
Date:   Wed,  5 Feb 2020 18:08:10 +0530
Message-Id: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(189003)(199004)(70586007)(5660300002)(70206006)(4744005)(8936002)(81166006)(81156014)(8676002)(9786002)(7696005)(498600001)(26005)(336012)(186003)(426003)(6666004)(356004)(2616005)(44832011)(107886003)(4326008)(36756003)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB4561;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d90e22eb-978e-45b2-268b-08d7aa384acd
X-MS-TrafficTypeDiagnostic: BL0PR02MB4561:
X-Microsoft-Antispam-PRVS: <BL0PR02MB45610E4B8509D97B8DCDDBC7C9020@BL0PR02MB4561.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0304E36CA3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DumXfbNshiYNB2/h9JyPPHSWA8TxuEAutyiOzFNrTzeue7gUqcWiz/+PAoH8H/sZoQYrKF/bIYscmGHgu89viWEHEBHM9CUbuDbNc3wYwHyQmcmchHqC5GsRCrpTf04ccjDs+M5cnlXlAyrn86+pFX06j6uOBWH3S4ezWI0ANZOWB7aZLAxJDccN9vgHqPLIw9cRkUeE8u0YmoQjliWfyg77XHV5BNaDyRnpp39Z13sk2nuSQcTe0j6aVQpDSy7+nK7R42bU84ZuYUr9TVx6wB3bz4q5wwfGOXRXI4YF5JYlft8K3DVPuWuMHmqYM0dRo9yvETLxo+vM5/urEN9S7dGv2DVKAAd3KA/FAUD0wpe4mDA/hbMdAh5gs9TQ+JiHa6vn0BQeO+AOA1OsqbTv3Ju7pCHVCI7UeAQldP3UNDNiRiE1OPCtwbWO2VlxL0jc
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 12:38:24.4292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d90e22eb-978e-45b2-268b-08d7aa384acd
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4561
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An IP errata was recently discovered when testing TSO enabled versions
with perf test tools where a false amba error is reported by the IP.
Some ways to reproduce would be to use iperf or applications with payload
descriptor sizes very close to 16K. Once the error is observed TXERR (or
bit 6 of ISR) will be constantly triggered leading to a series of tx path
error handling and clean up. Workaround the same by limiting this size to
0x3FC0 as recommended by Cadence. There was no performance impact on 1G
system that I tested with.

Note on patch 1: The alignment code may be unused but leaving it there
in case anyone is using UFO.

Added Fixes tag to patch 1.

Harini Katakam (2):
  net: macb: Remove unnecessary alignment check for TSO
  net: macb: Limit maximum GEM TX length in TSO

 drivers/net/ethernet/cadence/macb_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
2.7.4

