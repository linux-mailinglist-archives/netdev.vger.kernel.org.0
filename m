Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5254569B73C
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 01:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBRA4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 19:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBRA4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 19:56:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5775EC82;
        Fri, 17 Feb 2023 16:56:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1lRAVwbVsh5xgdsXUSxoHqAs7H2ceo7+C7bgAAspj8/nRpdb45QjbxkaERBpYpxK7fc5BLuaOUs5YuyYDgrlOT3CHc/Lb6+htKh6Hl7xNHJGbxN+pWpFwK6vJ5Kaw6DEeLtdfjQDq/GYbArqJT2hbPMef0tJgfCPd+a6Uuh5lqX+3uzHBZ+kko3undBh6NjGOgDKSTf3yR+c/Vf4ZeVA0I6UkDui0NhaVrqr+uwxbQW1iFwqRYKOabLyQsY98XKXx2F+3lIkYb+MKiVC2pBMCURE1kQnm7TkqVTOjt0Qxzf0aMyHiyGYJuCcSzIREW2Q1kgHBRrk4v4/ZqQab1Olw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxIKg7G8vxkeaMJ020cSTH9VMHIWUuX1eDN3v3NdO9o=;
 b=bwfjUQf4epPkRHlhMZCJDPc8d7rUptMQDj30aYoLc8v0DYZ6Jll8JvWF6Lq4sZzp65gXoJOAZ68ihYjthWFCELHV2mWA7z/MkplA3zQ5g3n2u/xV5HaipPdDMWkS6b5jTxbnwruDbMTNQ7juVhfl409+haKf/7hM8Thjt5PBaFr9/PAup0TR5R/hXFat3IVgM/XqWk6KO3MjE97QJ+CITfD1uSBNHEQ8HOgcFBRu866l6SRQI/dcEU3pouMFWvEgbtDUC5wsAy5VJJXAjPfZNtWOMIh7L/85OiQYWLGyKDIHmiIQjBz3ioiJgtJHldz60DgZwTr113i3jfXcyLptIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxIKg7G8vxkeaMJ020cSTH9VMHIWUuX1eDN3v3NdO9o=;
 b=b71BoPuMW2f5Kth4B5jH2YZm6ILD1F3wrOxShhFZDtjlMlEArc1trRJ1UroLMmjFMRUsLZ+QIe7il3XRP+0JQr8yMQF5obA3hmNMP7ZV+WvAHwHr/uaILcNh32Ca5C9MUf6BJBUIkiqShkbqwwlng+OeHe5xYfoWjYCCL7/ERc4=
Received: from DM6PR13CA0016.namprd13.prod.outlook.com (2603:10b6:5:bc::29) by
 SA1PR12MB7320.namprd12.prod.outlook.com (2603:10b6:806:2b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Sat, 18 Feb
 2023 00:56:36 +0000
Received: from CY4PEPF0000C96A.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::6d) by DM6PR13CA0016.outlook.office365.com
 (2603:10b6:5:bc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.14 via Frontend
 Transport; Sat, 18 Feb 2023 00:56:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96A.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Sat, 18 Feb 2023 00:56:35 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 18:56:35 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 18:56:34 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 17 Feb 2023 18:56:33 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v3 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Date:   Sat, 18 Feb 2023 00:56:20 +0000
Message-ID: <20230218005620.31221-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96A:EE_|SA1PR12MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: ef1eddca-543c-4524-f920-08db114afc38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usi4v++F72E2xtDQt2W7BMKK+g6CRjfYFPwUorcOyqnpdYllHGF8wr1KOLWwXUDC7RXzLcI0x+oWTuKqF/EMFgqUlubQAkZxY1bdH4s5eoYbN5/oVl8D7UCmdaz8ReqKJumTAFZoRwxs1BrVp27YF9Cp5XZiWrwGI53O+9IkIIXWTLMWxXZjF6rKEzpg70gJBrD+Vyvdbqz9dA2KORXsMut6r4RCmpLuwIFYKm/IscdE6BdJjxp3+utvVBElcuAXiZHtt8nfK90Le/E5E45AI7dyX2T45dVj48+ZM1H8qG2LRr7J35ZClngkjF9yrdPW6P7RNJwTYidBjJ3ks9foE/C7Nasaq2W/2dwcEIV0ZoXDGz829/xrcTfQd2Uz7+UKdVrD5g5MIoHg9Urb5NQHurANXIc5kjTbFIijhHIXDw5gYAKZKKFIt6D/wgAVjs1W6N8lHJYEtZwDIiKsz4Aq0VfRqD8HL2cYoxO2mzqRtERhvnIN7XKBfmsSsNa9ly6bvYOnZSN3mqyi0DScYFZ+DTLWQxyEfvvU3aByBmQbZB/bxFIUIo3gGwutdo2ucn+buEmJ4ZyYjQXfd/NQIVRhMb3rp9O/329+ZlR6zDNW1y3immkNL7yDc7cGrqvJOGq5xU4dQuWGuUrQxIjh7aMqYiMIqtddam+8GQ8XVCPZ/FOXUPNBwRO5B/7QFMM46gSqG49dOD+UNMTOCY91BgjYgDYe5GBXvr2a+VWdYu/S8Tg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(40480700001)(2876002)(2906002)(7416002)(36860700001)(81166007)(5660300002)(336012)(40460700003)(86362001)(36756003)(186003)(426003)(6666004)(47076005)(26005)(82310400005)(966005)(82740400003)(356005)(478600001)(70586007)(8936002)(41300700001)(70206006)(54906003)(4326008)(6636002)(316002)(2616005)(8676002)(83380400001)(110136005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2023 00:56:35.8807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1eddca-543c-4524-f920-08db114afc38
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7320
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Add an embarrassingly missed semicolon plus and embarrassingly missed
parenthesis breaking kernel building in ia64 configs.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index d2eb6712ba35..c829362ca99f 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
 				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
 		rtc_time64_to_tm(tstamp, &build_date);
 #else
-		memset(&build_date, 0, sizeof(build_date)
+		memset(&build_date, 0, sizeof(build_date));
 #endif
 		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
 
-- 
2.17.1

