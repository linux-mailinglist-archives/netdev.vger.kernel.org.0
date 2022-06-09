Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF255445A4
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbiFIIZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiFIIZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:25:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657BF149D8D;
        Thu,  9 Jun 2022 01:24:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7BSn7IGY6HD3zbkHo+Ce3DTGKRhfnLoWx2QffpV7WpL/gTDbPP+xIoqqWclR35pw2n5SvPAEvSvhMIoE5IP7JqFcBH0K7fsyxD1jZDhooN+s+4pu7i4vPSYncFIEDFJYJvifSCD4GUCZG/Q9tdBGqOi2dN6iNzCCvJKf8G479v+h7cFrehxdQGQTalQNLYqGDLE7fegpu/34T+C8YUK+i4QDbxxPlPe/1cnbqyic3SC7cqSs2ICMXcR3QU95LXXODXu2BWASLQEKyQVwZcqGoRWDaB1svnox2PQFPCKNOLGvsxb2T743rrsigdC6ZvONmFBqL0kkX2SUznJW7x3zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwxFh3BM6fI1LyvUZq2hprAOoTb1DT+YPNd2IiuuPQ4=;
 b=ZKqFGesrFCpsHKi2Y8OnMIcStsu+p2uocXk6CWLJS97H52YtA/2Ku5skPGIifr/Ik+vnxjBXb2c+DxvxpZ9qIwFJ8JxJV+Ky2mUR1v/T3uafbmPBom00PsrnqJ9msHc/beQqJ89U3s7f+QWXFotKtzq7U6F0EPPFUIUeHr+ynTuVHJGzoytIPlxjEWeOQlnScHqP90xHhIl7GFDlXMV3jCCnJ9p/u/EvvzzPqmaePI1t0o2IFXeArpdTZdet54xvFK8jE40PLJcxkgpTLG/wWP+gc3V8LbmGdyF6tIPLGSJFAcQzqkjPbWowML3MXxO2Td3bH7t2t0s2bHc3aVy0mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwxFh3BM6fI1LyvUZq2hprAOoTb1DT+YPNd2IiuuPQ4=;
 b=EtfBr9S2JrdY6xxhK8EQDzm3yO0UDqU8qLEcB8CCM+rRHaJGeIvkKu8gbT5YjuAABsRNPUFE8P2ksXkyjpFFk7HMX5apoYUpaOQjMrOrwrRGRYLYSaBDOmxwu0fJRzfNXX1Ag1TaPM+Vh/HRRD19Y4EqEZPt4Vo3D3LXiQXVp3Y=
Received: from DM5PR18CA0082.namprd18.prod.outlook.com (2603:10b6:3:3::20) by
 DM6PR02MB4073.namprd02.prod.outlook.com (2603:10b6:5:a5::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 9 Jun 2022 08:24:56 +0000
Received: from DM3NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::f6) by DM5PR18CA0082.outlook.office365.com
 (2603:10b6:3:3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Thu, 9 Jun 2022 08:24:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT032.mail.protection.outlook.com (10.13.5.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Thu, 9 Jun 2022 08:24:55 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Jun 2022 01:24:54 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 9 Jun 2022 01:24:54 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 edumazet@google.com,
 srinivas.neeli@amd.com,
 neelisrinivas18@gmail.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.39] (port=37838 helo=xhdsgoud40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nzDTJ-0008BE-RE; Thu, 09 Jun 2022 01:24:54 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <srinivas.neeli@amd.com>,
        <neelisrinivas18@gmail.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V3 0/2] xilinx_can: Update on xilinx can
Date:   Thu, 9 Jun 2022 13:54:31 +0530
Message-ID: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 834141eb-1637-4535-7f45-08da49f188c5
X-MS-TrafficTypeDiagnostic: DM6PR02MB4073:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB40732DE94AEAC6A6A517AD77AFA79@DM6PR02MB4073.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwV0hJ6FQZXI9hg8tV/zyBtpU5jtwO70m7fcUCztQ4hoWvWs/e9/MhdxzDLQKvOaDz+eqqP6hqeL2gE9rT2miYVBWogDXbMesHaYLP+iB5p5Be0FSFEaFQY8PVBNE7fBHJTGCwbl/wpau7BiuWIanhsm/lH9daEaKRYzXdRk3v6GgSxZGgwL9fOhaA3HdWcDJyW6KvOKGbLOFmSpB1fYzTVTtQKc+sFK4rBYu4J0vefwGaTRx0ZWivD/RqgeCRKbmz5JvHA4Pi6/NatMzw5kaVsGrZGAZwLjnSYxOKemDeOKzE2WcBS1dN47NurFfrpt+UTLBql5tU3ukVovyi3JUE4e2KaZNaylmtwL/bWK1MzoE4AI/2EQhlv/IwBlDpT0tQqbFxuaIfQBbA0XNNliC+LsTvtG4Kw6sjDeT6S6+oXGR6UDSjkRSCGXouN//Q3W81w/mAu5U1trXYA5NSlgWIOk1yDiQPJ+VdXXDCm7tINeOFepp55xf6U87LQgR+7LJ07U2S1EnQibGnh4V61qg1sILBr5Y2haCDo7iEedB6irb50BR2A2Yg1hnHdylX7yiFGVl758B5a/RaUUqued+Qc1lDg6cUEJ35RWs8iCVcVr6P72vwfipnndzANG1+IOOy2ZBtrhOnnFLPv7s4WOZFuY+IXTDKwHCM1PoYiXiKrS3oxcpcuQaqVsnNPltiqxg8ktc/nDHn9DlH0HMokdCA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(82310400005)(7416002)(8936002)(186003)(2616005)(83380400001)(54906003)(316002)(6636002)(110136005)(26005)(336012)(47076005)(426003)(7636003)(2906002)(36756003)(508600001)(9786002)(356005)(7696005)(4744005)(36860700001)(4326008)(44832011)(8676002)(40460700003)(5660300002)(107886003)(70586007)(70206006)(6666004)(1076003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 08:24:55.5999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 834141eb-1637-4535-7f45-08da49f188c5
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT032.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4073
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series addresses
1) Reverts the limiting CANFD brp_min to 2.
2) Adds TDC support for Xilinx can driver.

Hi Marc,
Please apply PATCH V3 1/2 on stable branch.
Due to some mailing issue i didn't receive your mail.

Changes in V3:
-Implemented GENMASK,FIELD_PERP & FIELD_GET Calls.
-Implemented TDC feature for all Xilinx CANFD controllers.
-corrected prescalar to prescaler(typo).

Changes in V2:
- Created two patches one for revert another for TDC support.

Srinivas Neeli (2):
  Revert "can: xilinx_can: Limit CANFD brp to 2"
  can: xilinx_can: Add Transmitter delay compensation (TDC) feature
    support

 drivers/net/can/xilinx_can.c | 52 +++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 7 deletions(-)

-- 
2.25.1

