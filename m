Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E98649407
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiLKL7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiLKL7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:59:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B36108A
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:59:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mq9yHNMbQfOE6HKL2uYMuwZzsOT9KnLSSa6NZyKwLYPMvC2OPCDz5aLgTl0UuFuCHtOKtWOi18umd1g3plhaPCj9BJOw9lHUPw5lSxLW0ZgJACu5l1o4/91YP3reg60Y6gQFf4+Wt4RKaOStZBMZBsVHnxID1HMGgi+n/FXoJBeozz2dO/oknqIVKMbQ07TLdiAyCMi26OahE4NkbQu4mFqhBbXNaq+RH+ab5/n1V6RMc4tbFeGzyEPjdy1AgB+y7uItJe+nfd3K3n4k3MhowMVcwE9i02sWTB7gmcsgnwhH/qAgqWzc0y866qhdonzh3wWdZzTzqAD7n5ZCXBtezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pkl/idYh1Rcsn+POh/CCQoNtyUDUZRT4pjNfyOOsLjw=;
 b=G3Sax+Lr0Wn5f/n6XKpiky/ihoNV/pratVSZubJzKG7/vhYvkXmdkknqXaOB8MjPalndos28DsBlE+TewrDQ68lCQ1jECYOvQQloAaSIs4YXcq5x/J717QlHcYPz4C9pJZ9Dg+SHppSJ7jpRU7zmJb49G2EWppzpjaTfemA1Pak/zat+dMGr3HhimkIa0BqkP/MAltpuW9ygEfNmIRdxGrFn7maWNIU9LA4eMbUz3bfUQPPSlLiv5B5GU4hV4BTj4GC6rEVVlJXf3747SZma/7aB1PYTIbW0Gzd6wVR8J6f7TR5sa77yC4KdL7PYzhMF/s2oxJh7iVob1Zprib+1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pkl/idYh1Rcsn+POh/CCQoNtyUDUZRT4pjNfyOOsLjw=;
 b=C09KHaWLFFxdHqfI+4oy2vynWT/OmthnMP9fzgGAEYwZxdw384E/aimajNfRBsRHiTHzNxQIMgCjOie2hkcwBP7j3nxPeMVI02ZGltiZ6gdiWz5nbcRjbvnDb9xJRSfsBNOlECiaZXsn0mx9L6I+mYQhPVPAsd09obwv7iVw0EqkaGgZjKai8X/11P5fx9mfL44Xx+J9qMwQoPuUegiXCM98ks9kZQTpc8usMepdptFMpJ9kXqF6USz19ZTeSi+/7VGdy6r8HQd94lSGmZZwXRA211Kgc+PAn+HPVE7s5FDQAfGMV+RchsnC5j57cfFPtFlWI/pzIk8nS/daPT81/A==
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by BY5PR12MB4902.namprd12.prod.outlook.com (2603:10b6:a03:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 11:59:02 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::25) by BN0PR04CA0045.outlook.office365.com
 (2603:10b6:408:e8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Sun, 11 Dec 2022 11:59:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.20 via Frontend Transport; Sun, 11 Dec 2022 11:59:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 11 Dec
 2022 03:59:01 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 11 Dec 2022 03:58:59 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, <jiri@nvidia.com>
Subject: [PATCH iproute2-next 1/4] devlink: Add uapi changes for roce and migratable port function attrs
Date:   Sun, 11 Dec 2022 13:58:46 +0200
Message-ID: <20221211115849.510284-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211115849.510284-1-shayd@nvidia.com>
References: <20221211115849.510284-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|BY5PR12MB4902:EE_
X-MS-Office365-Filtering-Correlation-Id: af09a586-80ef-4858-cb64-08dadb6f185e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1Ph13Nk6KVlaztpozT+6em66k9E8hvQxlqKqjOQIBG8Gd8kva6oaUoZeWlJrsGFQQTw2iZijPdolNeSTSDXtVPAdQ7NlK4NrhfNmXT0H5H6id1BM4vgDGcyWCN/MbePN5ErMYRqaOe2FoxX7lJyAiHvI4/qoPbNABuh9wFJhJVBW5kNGbHY33e+YIFTYI+dqJslTuxFgsY7FXggquz2hlhN85AiU0djQ3kw3/I3a2R9QsdEDF/tu8VPXf3zaOxQN31HM0mQkWNWBNuRUCARqJYzMk5vrZjynFtFPHVTklCTbbqw+sIjXECaDvnoVuC9HEcZOHm5TS9Pv21I1K2Vu23/dyHW1zsyaFGd70Bp/wflxWVz1UexWjPTPKEqlTFzL4wTIoCJ84nAd1tGnfd7Tcyv1oCS0Vr0DHus5jf8TmdB/INzPOkXByEPsTUYGQ8y3uHGSmJNUN/tRnnYJpTOKo20i1nwhQ2UjRHpvwsfLR+8MfG+ER5XQMMEjDGV8gXRga9pEg18AjbptM9dV7sqbLYIXYAz80eTk3FyKNgBZQ6sQxcBsnBtcVvLYTqIFlyjqdn9sdF2zFyWjg3PAPedVmK/ARhrz+uG7Pluth6e6GWBdFuf+ZL1DXD0ArjvKCeQK2fMX6mwfXKZ0lkwBXMBTEDKDPmN4JfU7NejWvbyXVKObwYy4igbyb9CkzoQRkmYhX3pECNtzrpgVcn/qFpyTyOpiaKNDEfqd5agi7HBSQLd/HjaEbrgO1/F9scwKi4a
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39850400004)(451199015)(46966006)(36840700001)(2616005)(36756003)(86362001)(2906002)(16526019)(1076003)(336012)(6636002)(426003)(356005)(110136005)(47076005)(6666004)(966005)(478600001)(7636003)(26005)(82740400003)(82310400005)(186003)(41300700001)(5660300002)(8936002)(40480700001)(70586007)(8676002)(70206006)(316002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 11:59:02.0877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af09a586-80ef-4858-cb64-08dadb6f185e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4902
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updating UAPI according to the changes merged to net-next.
https://lore.kernel.org/netdev/20221206185119.380138-1-shayd@nvidia.com/

Signed-off-by: Shay Drory <shayd@nvidia.com>
---
 include/uapi/linux/devlink.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 7538d93f..ae96e481 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -658,11 +658,24 @@ enum devlink_resource_unit {
 	DEVLINK_RESOURCE_UNIT_ENTRY,
 };
 
+enum devlink_port_fn_attr_cap {
+	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
+	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT,
+
+	/* Add new caps above */
+	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
+};
+
+#define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
+#define DEVLINK_PORT_FN_CAP_MIGRATABLE \
+	_BITUL(DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT)
+
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
+	DEVLINK_PORT_FN_ATTR_CAPS,      /* bitfield32 */
 
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
-- 
2.38.1

