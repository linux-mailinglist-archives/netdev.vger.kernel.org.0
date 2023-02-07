Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD3968D42C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjBGK3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjBGK3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:29:44 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2312BF26
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:29:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gdcok6T3KT5uFrR/FA1NeFf9/8kjWK7ZcLXjQOOUZ7sdbBc8koHcuUeZgJMXj2dxQVF7XRNXRfFod+CJo8F/ZxHldd8yF3e0oUAgHeaSJlCAixSJnXJi1m4bDE3twTG8VpOCIqhS6byUeadxCdMRRse+CEP3gtvKr7dkMvJa8iFWqWnYljxJsXAlIVlL/RAhlNfyyDjlbmZ4y2KI45JS5XalBS9CWccJfFOQ/rLlLwO9wbYQGilO5ihCJRYG1n5YLEis6LG35yQaubp0RZnijzuQLD2VOCGnDk3s911GDLnsyZivg0xiSVSER1Q2E8Ty+cGadx16GxEZGIjzKryJ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/E2TWuZDenTW+goRPqjvbKrLA0/HMqS+81v+NSws2Rw=;
 b=hb1Q1XUOsYOzuvJr3G9yb5LUGXXsrQJ5D2hOa/35v/UaFTYGAn0xm3Ut473c03CUpcWSVKYACL11XeqgAVrmsj0t9yuFRbujjAYB5EqLdocRKKCshYwBl48gB2BM2MDMmb3fPmwV4qHXFAPn0iMmpjCsN2can4ORbI69geVAnDMqxLWfiHyWgcKaeZ6Gbyq7uiJfbl4Gx8BtMVWIH84nERskKhcOfybA3K3liirpL+3Jp6DaaNENiYNDMlax8u81WL8xI/Ol1elLs0GvKfyAsJ0LDtiuFm/EM//NqFeymR3tF3Q7g3iWboB91PqOGsXwdR0qhGGMBiQ/pkpB0SdwYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E2TWuZDenTW+goRPqjvbKrLA0/HMqS+81v+NSws2Rw=;
 b=EUMyfSIR+usgN+8MsbYYADBteJ7ji3UIgETyYoVYLAeaHiTawYAnWiP9zpdx3kzEPrffDawCcIW4deya0ZINESxCjySCH2br40eS2aLO5fd4bVkbro46HxyjFV67fEfaN/NVGo/vHNwUKbCF2QTmL7GU+xoEWfCW1ixA45zrQfPUqlQZN94/bXLi95XrYrBFOcp8jYUlKSAlOjK7sTpsMICFtR2tyt+PheqHqNYVtnZuFoeUPkUKua94lq65/4brH4FbIEPpzgzDI5TZVkhQsy/WNV+a7L8lSXmaZDcxS26yK+iAMthK/NGeBDd6VnjWr82YdTgsd+ob/pRxnnWlYg==
Received: from DS7PR03CA0152.namprd03.prod.outlook.com (2603:10b6:5:3b2::7) by
 IA1PR12MB6556.namprd12.prod.outlook.com (2603:10b6:208:3a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 10:29:29 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::b8) by DS7PR03CA0152.outlook.office365.com
 (2603:10b6:5:3b2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Tue, 7 Feb 2023 10:29:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 10:29:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:15 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:13 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 3/3] man: man8: bridge: Describe mcast_max_groups
Date:   Tue, 7 Feb 2023 11:27:50 +0100
Message-ID: <310c3a1370e5cf0b134b291ec042bc7bdf221e68.1675765297.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT029:EE_|IA1PR12MB6556:EE_
X-MS-Office365-Filtering-Correlation-Id: ca815140-f508-46ab-6dbb-08db08f631dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6w18KesZTP0rlIkA8+fSfTsdx9wIdF/C3L1hGNbOPJcjwFD+3QYhX7tDDyz8r5WJal+cEfvn2hGibnQLhrqPjADIlLQ+ONwggwQ+JlBOZoLTpJRpT0X2SoU4Jvw9OzEnTKByqbTOU/uE2OQWruXJPIJvHcb0PpbCAoUtARMmSN4cBImOIixmeRNuO6u8jP5OynqlepSSmK5YTBq70LVG7YrQijCFzw6FBCiIHa8+b9kwvfotp8jA9Up15/ckuRFw1vnioY4GfW3ESy3aX/PcdSOKsSytzJK7BeIXYEc77/TCtbUj+mk2ruvQOveiTu7ZzVYhCkXp7Kk8TQVDDc/uarhosEtdQjJuIl07X4rQqGVh9tmHuXEMYTubH47aGLxJ3FpdEClzrNdpdReXujlrwEXoY3GOHFHqsVnMLwwcQIOlf9c77ulfYlCY9oeDXktODXVxEHKep2E7WarZQVT4RVv+78CfGs09Fp81fDBBuWjTknhzjFye2M3bJydyZHwaCS/p3bGPvQgzjgFMAGVTJ1L1oyRrgRPbb7GYEjrcIdF7knyhoX6UydjsLUWcJv5dxkFnvAOTSTLM/wsAALatbD6yAMkI3skapINmutROEzeVOX3o7uDvS0o0qirorYt/EnqsTpvm+SG2qgdsvR/H+kKhDepFMJrwtZRkHXdao+kKTUwTtVUL3/K8RaKKgTbTJrQ0MoGUojDadQEF+rL9A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(82740400003)(41300700001)(478600001)(2906002)(26005)(186003)(16526019)(8936002)(70206006)(8676002)(4326008)(6666004)(70586007)(107886003)(110136005)(316002)(5660300002)(66574015)(82310400005)(86362001)(356005)(7636003)(54906003)(36756003)(40480700001)(40460700003)(47076005)(83380400001)(426003)(336012)(36860700001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:29:29.3066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca815140-f508-46ab-6dbb-08db08f631dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6556
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for per-port and port-port-vlan option mcast_max_groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    - Mention that the default value is 0.

 man/man8/bridge.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index f73e538a3536..abc0417b2057 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -47,6 +47,8 @@ bridge \- show / manipulate bridge addresses and devices
 .BR hwmode " { " vepa " | " veb " } ] [ "
 .BR bcast_flood " { " on " | " off " } ] [ "
 .BR mcast_flood " { " on " | " off " } ] [ "
+.BR mcast_max_groups
+.IR MAX_GROUPS " ] ["
 .BR mcast_router
 .IR MULTICAST_ROUTER " ] ["
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
@@ -169,6 +171,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " [ "
 .B state
 .IR STP_STATE " ] [ "
+.B mcast_max_groups
+.IR MAX_GROUPS " ] [ "
 .B mcast_router
 .IR MULTICAST_ROUTER " ]"
 
@@ -517,6 +521,15 @@ By default this flag is on.
 Controls whether multicast traffic for which there is no MDB entry will be
 flooded towards this given port. By default this flag is on.
 
+.TP
+.BI mcast_max_groups " MAX_GROUPS "
+Sets the maximum number of MDB entries that can be registered for a given
+port. Attempts to register more MDB entries at the port than this limit
+allows will be rejected, whether they are done through netlink (e.g. the
+\fBbridge\fR tool), or IGMP or MLD membership reports. Setting a limit to 0
+has the effect of disabling the limit. The default value is 0. See also the
+\fBip link\fR option \fBmcast_hash_max\fR.
+
 .TP
 .BI mcast_router " MULTICAST_ROUTER "
 This flag is almost the same as the per-VLAN flag, see below, except its
@@ -1107,6 +1120,15 @@ is used during the STP election process. In this state, the vlan will only proce
 STP BPDUs.
 .sp
 
+.TP
+.BI mcast_max_groups " MAX_GROUPS "
+Sets the maximum number of MDB entries that can be registered for a given
+VLAN on a given port. A VLAN-specific equivalent of the per-port option of
+the same name, see above for details.
+
+Note that this option is only available when \fBip link\fR option
+\fBmcast_vlan_snooping\fR is enabled.
+
 .TP
 .BI mcast_router " MULTICAST_ROUTER "
 configure this vlan and interface's multicast router mode, note that only modes
-- 
2.39.0

