Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418CA14EA99
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 11:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgAaK1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 05:27:55 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:43072
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728302AbgAaK1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 05:27:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQbjM/dOkxc1wl+uQmUm8WOSVakGXLl6+HDEK3AYM8GCi1122EjVs5MJBh5KDDbl/MlEi1/ZuheyDcyLC8QcR75HIsk1+UmnWwnUIwDGjY58VHizCbZWVIiVewvOJ4JQ6FDHCU3VL4QIzw4ZprXCHZBNS1DwWLOHjeH5A0cu+SI9OiGvW7GLBuj3gdAB6wNpEiuBMLpuJFGVNFRfqTk+ks72S3/UQcfcRfYMTdAzpkTgoPmGvMYmYKy8oZX2b4DN+/vn+8yVvK00orIaOhmAJ3WkAzc4NWIaU+huybuO6VU4e2XS7NTpfIefq8V1FYSFofOqlzTnzYtquvQ0Ti5TTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfJv7pTEMZ6rMw74v9KwD2o91hIAGJULsf3YAtksBME=;
 b=ioT4XCZbHX7K513YyJ5qmhr09Blv9XFEeBBV7dZ84jC6egE9W4J3tUq1XNR5fBNOPkVYVExIPZj65SAycaLfrbtk4DNiwE+ZvH6GiWZCLGOPGqOTrX/0PVztmzLXoT485+CT+jhGFe/Eg52rdGJs0+ju26ZVXnfa9aP7ZgV+TeuzJcn8R/J16U4usjzyYHWP4bBlWSrRviyAGNse4VTMfEGzoNAWyN00Z9mknVSUL9TgrkIsY65F3YTFkI7Jgf96KlcHwdU3tJIFgnWn/8wGa20M0Bl18pNOxCBTeoyahf+Up0bukhumjSi+ZTLiT5beYqARZOAYs0K6gorKfedGfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfJv7pTEMZ6rMw74v9KwD2o91hIAGJULsf3YAtksBME=;
 b=l/TBNhIf5kV7H6lszj6XTULGXTZC4ZXYTcpOEd5RZElteZWNqXppSPYYI/R1oBZQWSTFgY72Dfs13l7K8okxRhQdKJf/Nsknv7wJliYkG+MzjPQzHSooj00OPXfxFVBx3X/DpQWr+vZIPKihEJw0jXzzIFfKsTRyvpCwlTSaUQU=
Received: from BYAPR02CA0049.namprd02.prod.outlook.com (2603:10b6:a03:54::26)
 by MN2PR02MB6351.namprd02.prod.outlook.com (2603:10b6:208:1bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.26; Fri, 31 Jan
 2020 10:27:52 +0000
Received: from SN1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by BYAPR02CA0049.outlook.office365.com
 (2603:10b6:a03:54::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27 via Frontend
 Transport; Fri, 31 Jan 2020 10:27:52 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT061.mail.protection.outlook.com (10.152.72.196) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 10:27:51 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWh-0003vC-Ii; Fri, 31 Jan 2020 02:27:51 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWc-0007is-FC; Fri, 31 Jan 2020 02:27:46 -0800
Received: from xsj-pvapsmtp01 (maildrop.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VARcC6027999;
        Fri, 31 Jan 2020 02:27:39 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWU-0007h3-B9; Fri, 31 Jan 2020 02:27:38 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH 0/2] TSO bug fixes
Date:   Fri, 31 Jan 2020 15:57:33 +0530
Message-Id: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(189003)(199004)(426003)(8676002)(81156014)(356004)(81166006)(44832011)(336012)(107886003)(6666004)(5660300002)(2906002)(4326008)(9786002)(7696005)(36756003)(2616005)(8936002)(478600001)(70206006)(26005)(4744005)(70586007)(316002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6351;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65126fbd-da00-4e9d-06b2-08d7a6383a2d
X-MS-TrafficTypeDiagnostic: MN2PR02MB6351:
X-Microsoft-Antispam-PRVS: <MN2PR02MB6351B10D744505D53A9F2A0EC9070@MN2PR02MB6351.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MII5SWT0Ji5oP/ce88v/SYeGIoZwMnZRjTTYKVWoIiyU1XFrPxedrkA8chsIuJ9MY9I5QF9/NGbIsThUlpl/+DkovEPyY1OmDyHqwNkq7giS2YNCtRfCfj0MoyobETOcDkAk9/y1ZhF5NWUcb5mhDqb8Uu+LM/a8RbY1Hr/qaen8MTawwYWhozluEDf1NDfkmXxqmyhA8LzeJxXp4nXcf3DQ/O1DERT3B4xkwkfJjpNKpGrtbPeceooTS8o1wqeCYBHVPQx47QVYtgblOmH4Sxj47g2Lw08up4YPklwNZnNMIKrSjDTVQqJJ+3BY+NfVcus9uaYncQYZ8IYysaKIF15hlf3A6SgGO5I/0ntxpscEsU5YjtMxkCtmszFj+SHAaHUXoXdJNzA+pzpYjb+gET+pyrI+y8XQhLgJsoqMidQXwtLGoytFE/QC/+ma4VnD
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 10:27:51.9502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65126fbd-da00-4e9d-06b2-08d7a6383a2d
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6351
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

Harini Katakam (2):
  net: macb: Remove unnecessary alignment check for TSO
  net: macb: Limit maximum GEM TX length in TSO

 drivers/net/ethernet/cadence/macb_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.7.4

