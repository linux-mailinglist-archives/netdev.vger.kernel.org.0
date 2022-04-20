Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E722508685
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377851AbiDTLGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 07:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351910AbiDTLGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 07:06:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC675403DE;
        Wed, 20 Apr 2022 04:03:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYrGNNjp61RXT7zFXgIFWYzhkTwVidbvzHjf1Qhrs7/20LGlnDSe3f/HYB+3FQRgNVH6nNwO7ur7Sfy83xo5Nbxf36mbvCdz1uvMegO18SbKnADSh7yFNIeFEQyZOAJTSXo5LBb2vbNJCWCOKJubSS0EH/zR7xiwDPy9DBgBSZFVYIYo5iwyCOj2wyVXwAEpY1mxuRyFncXBiyzeNP8cu5NnqRtX9g7rx3CCt8L4cQdaSV8VLNfncLCQJnGMD1moObzOC+Vs4IDfiYdA73FoYoNKKsxiY4fvlpHDIuodJN3ZXzwvVC+PlI0HxP0QNOyUIO6glb7lXvRW8sr3u0CeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7P3N2D2y6pxTWuOwDVKWtOLwnFsKpUx3dMhbWWNcJ4=;
 b=ZtdoGGHXLZZc82BAO5Mjqy0L1dHZxKpYRxjCiGct74WkAPuNWvxBWXVexMyzqrFV2sOIO6zoTD26XH0j0NCa7iQKNVkqnwvUxxgezHv8iAwOQgRQqzRSmDFEGJcZwrEp7FDQY7ci48EWSHxcXEmxVZoAdjb04v/MfzTfzOvGvqudv49SmrUNGmFZEIOquo4Jy2MFdzTQ9poz6ByYAF1pfcrk2IWUK88gbkfMQR/B7tv8oRSWFTMWo5qhLuyAve/B9lRSfnzCLA0h5I1jJvs6jUWmvmGpRCHQOdOIHT+8B1STERfgP+HC1n7X/v/eqtEq5mWsHo1m098WKLjLvANn5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7P3N2D2y6pxTWuOwDVKWtOLwnFsKpUx3dMhbWWNcJ4=;
 b=bn6EiC86lH1bfZ2qsPAJQCnqPc2m6HJtAYMnQ62L+U/VI3hNWtBMG664rur7IwsPu4GlkTvisjSB1MB1xcGphmqZpP+6QoEZ88Zbq6fYwWCp5GdEUeGYz9N/qSI3p3Ksf82A+ESKt5qYy7YsofVau9f9scVw125UPTd4NPjG9vM=
Received: from DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18) by
 DM6PR02MB5243.namprd02.prod.outlook.com (2603:10b6:5:43::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Wed, 20 Apr 2022 11:03:40 +0000
Received: from DM3NAM02FT024.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::4e) by DM6PR01CA0013.outlook.office365.com
 (2603:10b6:5:296::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Wed, 20 Apr 2022 11:03:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT024.mail.protection.outlook.com (10.13.5.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 11:03:39 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Apr 2022 04:03:38 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Apr 2022 04:03:38 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 krzk+dt@kernel.org,
 kuba@kernel.org,
 robh+dt@kernel.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.63.71] (port=43966 helo=xhdvnc211.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nh87W-00062E-1t; Wed, 20 Apr 2022 04:03:38 -0700
Received: by xhdvnc211.xilinx.com (Postfix, from userid 13245)
        id 47D80606CD; Wed, 20 Apr 2022 16:33:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzk+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michals@xilinx.com>,
        <harinik@xilinx.com>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 0/2] net: macb: Make ZynqMP SGMII phy configuration optional
Date:   Wed, 20 Apr 2022 16:33:08 +0530
Message-ID: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8951018-de63-42b9-5b32-08da22bd6d13
X-MS-TrafficTypeDiagnostic: DM6PR02MB5243:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB5243A63DAC43A4E472962655C7F59@DM6PR02MB5243.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVhLF8JPwIMgdg8pqeJvJPLbIBFa3VfirNpHMFejVC9PMMWLbcapwSfQ+GXigCrFHcY1sURLxa1euBsR9RfI3L1L+D9YaicQUtXUhsnZmKKj0p/DOAsFhCD4TCbZ/uspEDJGDUKSJxvApu67KnydMJNceSZw2OStBzO8EvFupKJviqw9OhB49pF+93Q6dOD5Wj1q58sN95oW55dyP+Sh0UcGX64EdMO9cM/Z4adul9LiYeKU90WO36ZPahMhTvQc9Q5DCZFl2dkBS4cfLGKEPNlfqHef62lviCvCrdjROKD0jA2aFsKVbeu5uXI80o9A1eCEOQsuQxPJ7D4ysTq/V2Qdz8YoSzETz+T1N9QUHLI+Fq0l+XUWVhHgI1rS857H/W1QVGJohDXBUO50FbhOn+KqkEFGFU83nNDCmkIXmGNUkCgYbXJSnWeWAsAReZBCtdqHNRyPJ9IgOXtYdLsGZ6Ek12aakL3ZgmBLLZFodfRU+xagm/1hIyMw3wRvrFlh+u1w8084WRxwk+4MHq4hQmaE1gpTj6aEi1le7yaJa5jzKmjKGoVEq1jbEYbynMAvQNGrwHrULOZwowgh3ytDPObJUDoFLWqX7rWX05SO3vFQBXBuH0Jxv3yWHND8ojv6H7tipMZXPDhh1jC1vXTMDLuIHMU8a7uUgAlJZ8PvMcXXLSTXXERXITKwe7J3QD0VotkcgzEIlBnKmWCZ7yu2Ag==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(356005)(36860700001)(4744005)(6666004)(2906002)(5660300002)(508600001)(7416002)(7636003)(83380400001)(8936002)(2616005)(107886003)(6266002)(40460700003)(186003)(426003)(336012)(47076005)(70586007)(70206006)(110136005)(36756003)(82310400005)(42186006)(54906003)(8676002)(316002)(4326008)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 11:03:39.9557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8951018-de63-42b9-5b32-08da22bd6d13
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT024.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5243
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset drop phy-names property from MACB node and also make
SGMII Phy configuration optional. The motivation for this change
is to support traditional usescase in which first stage bootloader
does PS-GT configuration, and should still be supported in macb 
driver.


Radhey Shyam Pandey (2):
  dt-bindings: net: cdns,macb: Drop phy-names property for ZynqMP SGMII
    PHY
  net: macb: In ZynqMP initialization make SGMII phy configuration
    optional

 Documentation/devicetree/bindings/net/cdns,macb.yaml | 8 --------
 drivers/net/ethernet/cadence/macb_main.c             | 2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

-- 
2.7.4

