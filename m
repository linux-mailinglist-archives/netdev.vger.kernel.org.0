Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B94C68D42E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjBGK35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjBGK3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:29:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF5B2823E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:29:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hvd4eYBq0HKkXeYsWGlD1KGzrJ663ttVaCAVf97U32/y2cTghb0UrzHbEEXpZRn5e2HfLcf8J7cOk27iA7C70UeveC+uwLpKfieEeMFla1M2bfdjLNgsUGhKCDLy78HoObgLXH3lexEhpnAGWeSB5GbRn4APRGYSd0aih5ymR00ZscNYkDz2EdZr6hrWbQdVJegVwyR6FpVxfjf1hA7t9q95lUN+njbvc+UvvR8Z9gd2800yhW0yDd60js33wAFNQQ+cHJc0xrzdv/YXdMK3SCzW8v1zSmtztAkWkGzYRnKB5vyb/CmOWSGcufWuo4q+l/XuIjFE36v4ukNc43N5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sycdtrdtE6Jds7xxXHQuf5xuybQO8LXQsAcmWWcam80=;
 b=fkQUk/r6W5+zLW3N3VdHF1oZ4T4TplsKdmONjOqDXNSWSIIvcutU4nfOKPWiiZ83YWnuCBLN8rbuMSIA6RPFQraT8Pqy1BBs8fNlrMs+6VETMcR9FRVHzcMbbC6AJd+Vbp7ZWLVZUWIjNTXOwaWK5+lrOJpwloq7p+e0HgHVHPKQKYRGH+LM4NiPLYmNrfSRrgj7TFm3jEs6GfCeAYeXE9d7yB50sz6vDf2vpCG/c1AfOLH1HoJ+HVkvFuhWFA8uI3w+zdSQPEfAab4iy8cvajFthnWb26eFQHzvI8dL56VVb92EeFYU5jW4XC7marAjTpkzNymdp8Q44E3dXlY6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sycdtrdtE6Jds7xxXHQuf5xuybQO8LXQsAcmWWcam80=;
 b=rjDNLFH6RFow5Dpy70g3yufCZpkGjda+lek52sMEGwUPdkdo7i2icnuTh9zPPsSJznDwOQwgaOE2ppLu12IQQUgLwBzdMZlzZfCK3wilwNIOdcQkY4aq/dyB6SG8UUB61o2iC5iR3O0R9r8AECMIlT2Btp6bi6pelZlKQTeX/Zeaad8fEsykHZfyI5w5Icec1Qiz9naNwF1vOEEt7bx67N5n6M29rAhUNMtILwMGyYJVXIefavLEi94KWFUbhvF/gTl/jVoVFJkW7UwHqvpEBAThUejx2VGN7OlfHeljsliBH5BxhFnkY2BY0rWniajFofRtNQOWi6Jp6g7xUJ0axQ==
Received: from MW4PR04CA0325.namprd04.prod.outlook.com (2603:10b6:303:82::30)
 by BN9PR12MB5098.namprd12.prod.outlook.com (2603:10b6:408:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 10:29:28 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::14) by MW4PR04CA0325.outlook.office365.com
 (2603:10b6:303:82::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Tue, 7 Feb 2023 10:29:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 10:29:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:11 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:09 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 1/3] uapi: Update if_bridge, if_link
Date:   Tue, 7 Feb 2023 11:27:48 +0100
Message-ID: <82b5a04f69bd4fd4b6cea9d8d418fc321d506913.1675765297.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675765297.git.petrm@nvidia.com>
References: <cover.1675765297.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT024:EE_|BN9PR12MB5098:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c0c0825-6cfb-4d66-6021-08db08f6307a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+uW1Fo+KMKyoQylRkyiL7Q37s/xTSx90hqxQVSLXyaxRHHLKdHsZHY20EDpAlYPZ8qemOqZekg/ZM3gJ8pQ/LuGW5jPUPX7C+f/QJ4mSEeFm8631zDMlFfve7Q45s6mbha1UywTvA9FezFXoii92DJujlKQYsSNAo6SbejfpbdAtu5l2kR/WCGnx4JXPR3ePQl4HJAERpjJCl5KG42tTx1j7OgtTOtjGkXyQxK2LS2cS7uhRIP4OQ2lqDxG3e76elRdMyvQM8X0sTL88UamU1vX2eVnE6Ux5bR+JSf9jUVGhEPqEk8+d/8NuGEQd04GYSF7SHetbS0w6KwEhcw/bRExwezStkEpsq3fB2pTXjEamYNg9MnA4qsHkKWq2df2Mkg9E2gX2avR1x9Vd+XLM4Wn9yXMOGoT26NRS/48PO8kk7Tb5eZi/Bv8ljWgZZj2Np2c2oKaEpGYTNQpWkUsAtj2za2ziSkgG+U8HgrxgYTkl83MRoTlJKZcmB1CLVYnyRzCo87VNI6Lw/VKAYMeRO31qSgWKhYzK+quqtuhcOJrhHqluVajCby8aAnRkfvQd//GUxyGmUPBbtXDW7D24XbJFeBJF4mlm3bR0Bp49OwlG5Pj+AHMiJYWIgZ0cEHMfocoRhyjVlcjcNXfFT6jEMKSZ59w16RzTBqA+UmWHSFYgwQV3jFCDXrjI26o1g2Yqc0hcFV0chXWAfn8BgNLkQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199018)(36840700001)(40470700004)(46966006)(2906002)(36756003)(82310400005)(47076005)(426003)(83380400001)(66574015)(336012)(6666004)(107886003)(26005)(186003)(16526019)(40460700003)(478600001)(2616005)(70206006)(70586007)(4326008)(8676002)(5660300002)(86362001)(41300700001)(8936002)(40480700001)(316002)(110136005)(54906003)(36860700001)(356005)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:29:27.0423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0c0825-6cfb-4d66-6021-08db08f6307a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5098
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 2 ++
 include/uapi/linux/if_link.h   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4a887cf43774..921b212d9cd0 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -523,6 +523,8 @@ enum {
 	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
 	BRIDGE_VLANDB_ENTRY_STATS,
 	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
+	BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
+	BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 147ad0a39d3b..d61bd32deedb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -374,6 +374,9 @@ enum {
 
 	IFLA_DEVLINK_PORT,
 
+	IFLA_GSO_IPV4_MAX_SIZE,
+	IFLA_GRO_IPV4_MAX_SIZE,
+
 	__IFLA_MAX
 };
 
@@ -562,6 +565,8 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
 	IFLA_BRPORT_MAB,
+	IFLA_BRPORT_MCAST_N_GROUPS,
+	IFLA_BRPORT_MCAST_MAX_GROUPS,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
-- 
2.39.0

