Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D456C6CFA8E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjC3FIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3FIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:08:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB424C35;
        Wed, 29 Mar 2023 22:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjbuUiQt2PDggD2THk2me79ZXWK93KVA9Rn8qR7DerqcL+HSBFfdn4EoZkOncYIKPSY8BqaZ/wiGufpXIRMgdqE3oUTsy8KQI884+5DZlfBLdsw+f12X47bwH5X0du9wo/BRdATmVkrmGjAXkl+UrwNp+lct5ZQ83lbLuh3Old6s+HFTFEqcdwR2ptytUXAZ1qpPcHqwCoVsjlAO+ZOXoJrpkVe58O4MH0HMRu9O9ItP07+e2aeBvpMdRlsEkKlxxapHfj+VFef7Sk2DvFUwkoMwbRl63Afbm5elA/lTK2hORMGhZ6+bnsxvnAovJ/JF2h7cFyJkAxK0GX55M3AHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERyANljwrDtE/ai6V8lRLBft6yb2HuRD48xFT53iwYQ=;
 b=mBJBVjtXsFK9tRjOmp22ID1FiF7ZAGdix+XgiXxisWCnHp7Bld/CfsXWAl/xwEAe6d+ntLI0ICYcxHSCFqzHIhG1qyPHviQEhUjpoP79Jzjkai8Q9kK7Z4BAYVMoIEGwHy4uALj6b6SiHy03jmOWFC6kVJ7aApiIcsOaa3IedO/su+BZkTLmJnnn6np+I/cszqsiUNustWjeFpHwdSuJkm/gZdTYtzOwnzEE/5P4Zk3y2/ctUwliypGhcUrlKkovk1exiHMaEc9y3c0RAoPqH7R4PdBvJhkYiBDvuA91fLaeh2D9QG+KOSIBqlDiHk4GXnIMnEJxZMeQPc/4Pg39Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERyANljwrDtE/ai6V8lRLBft6yb2HuRD48xFT53iwYQ=;
 b=UOcD44QvoPmAHOXtDTzm78jssXu+6lbTyW3UzmcYiCd0T6PqCVDwezQWp4V7hWG1TzUnHFIhCY1pyyO7VOR8W36wmWrrYGa/ZlOZ5piVZ3fvRfbCWDp4M0cDIowvXds6ln+YT5ucLhW9iiDHJ64giXnip+3GR3T2qm4cbn3xBN8=
Received: from MW4PR02CA0008.namprd02.prod.outlook.com (2603:10b6:303:16d::27)
 by DM4PR12MB7766.namprd12.prod.outlook.com (2603:10b6:8:101::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 05:08:18 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::ef) by MW4PR02CA0008.outlook.office365.com
 (2603:10b6:303:16d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 05:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.21 via Frontend Transport; Thu, 30 Mar 2023 05:08:18 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 00:08:14 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 29 Mar
 2023 22:08:13 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 30 Mar 2023 00:08:10 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v4 0/3] Macb PTP minor updates
Date:   Thu, 30 Mar 2023 10:38:06 +0530
Message-ID: <20230330050809.19180-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT041:EE_|DM4PR12MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 2173cab3-ca11-4531-8c66-08db30dcc699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aM85TFWMCfURRYzoOZg21Q1/ztroCzB7wUr1UjDqZQqGE9dI4901Dd89lfwYpZ4TFgMUQiSGSLF38baGvLwTumtQ+Tvpfw3WSzADmtsx6Uj5YqmvxPedn8jFWtzPYPxeE7JeSBPT9EFZqhO0+6tyBeL81YnFPTdh+sg26VpA2MBk7PgBJnzHMGPxcYNJKmCPZlcCD6nnwJatdIS6Ypnp4mxkfBpQhSl09VliSBEZCrUlD0nhIiYiia8OPcFIVAlUUMP2TDH7Z67IDwZ9qGOMn9HX7bkAjxs8sVhvQJhQlaQFKz+hXsVyrLCGL40mNoQEJwUeWH45jCzJgSASxhlOxWp7v9/v3Erhl1ajBOA4O5WNSJAt8t1nr+wUVGCW8Alj0euNxeJ2H6ZmnY/G5xNAlhBZ0fKJfVCa0qj1nP7TYeqq3+p2+2XKkcyqtjTuNo8Ujha0ItGrATjVQ5tRzzY2irvIIziMDm0aoB9WB02m5VtCJbsaURVdN0STwpjWXF2Ud+l+rEYyDd/VEQ9sF0x4LZql0OQMcote69zWINQA1X92P6i5XFqaz3TLSzyMXnrJNlLQIs5vEOI7q+bVWk3xX2I7QCDjLDyBmAj2tRmuzi06pNpxJZwRQlfv4KrkXiKvly9WEq01hKH3G72/kjMOHt9o2lQ7W3CTR+zLCj3c7T2kkpGRicji94niRnww43/Mu8wleCbliHGRVmLSxrsh6nus3jE/DbfE8uWL6/Lv2M8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199021)(46966006)(36840700001)(40470700004)(2906002)(4744005)(15650500001)(2616005)(426003)(83380400001)(44832011)(336012)(40460700003)(478600001)(7416002)(5660300002)(6666004)(8936002)(41300700001)(36756003)(70206006)(54906003)(4326008)(316002)(8676002)(70586007)(110136005)(86362001)(82310400005)(81166007)(1076003)(356005)(47076005)(26005)(40480700001)(186003)(36860700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 05:08:18.4384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2173cab3-ca11-4531-8c66-08db30dcc699
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7766
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enable PTP unicast
- Optimize HW timestamp reading

v4:
Fix kernel test robot error; use static check for
CONFIG_MACB_USE_HWTSTAMP where necessary.

v3:
Add patch to move CONFIG_MACB_USE_HWTSTAMP check into gem_has_ptp

v2:
- Handle unicast setting with one register R/W operation
- Update HW timestamp logic to remove sec_rollover variable
- Removed Richard Cochran's ACK as patch 2/2 changed

Harini Katakam (3):
  net: macb: Update gem PTP support check
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  6 +++++-
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++----
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++--
 3 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.17.1

