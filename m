Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1B45520D8
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiFTP1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242523AbiFTP1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:27:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A1C2FB
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caswboHwZ8SYJXSOBhZG6V386MID2tcD4VLUfhE+4t9uUrnpcZW5aqZ/gR8XYMTr69za9fM/+HnFuAzkslPQLuQRJf2DUKTtomrXySAEbkXpq2RUDamHrsgKav0p/+AGz6CcIBrosnD2+IL4MHBebTOpy4AyWjSblqKVxKTkkfNqZMoLzftF1rWJbYM3mez2onM8Cys0K7TMUUeLS2AV38rdKfXBsO9URT1SmwnoRqlrmIKfxnmIGetSlCSOv5iskHwNXwRvt+/zYSCnSKDgEHkAvSfQbsBPBXec4ar4qmdS38sw1B04QIYcPN3zaZK0N3MglfEDsa10ZT4/RCFFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Hg0xx6yGg4OXL36NOoXNuIoVqtntLEa4fCW+vC2sRY=;
 b=BAZSa5dHgkzXZiFX6dw5BG/AOT5yIgAzz74PbS1mh3qSixm+QkWUxzCs7oIxenPHKCLkdrk9IFJX5IbJKLef7jV7UDJnpX2JZqlMm17XIU7w4sNIY8uTuUunLtNSQWuCLJz7hstM8pDkPJ4TJGo47cGiYS5ofnKLBsPmAS6pFqckdv/EWc3tinibrXSZWRtrCxB2De3d7Emdjo32SsqVay1HMXxpamm0pRMUV1NyUy3RPb2tZsDbRA6ibVtMO3fZwwZ+8szrn++OD7r6vqmO/xKmpMtP+RBSO+VLXDRqV+O2Y9etmcgafyvksPO+JTyBLIaj//VTRo3pG+sFDBodLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hg0xx6yGg4OXL36NOoXNuIoVqtntLEa4fCW+vC2sRY=;
 b=e8RihOSWqK8zNCgFB3W+n5FHA5A5LPpG7wPTXzpcnHYzbJjvnFpCx4cJNPf0AN5Tatad9PGHLr2bcp9fYKWnckKX64xmWUWG9EzIW+zLUAAR2zpV+cZL48HaB3v/wzndsfaQRST/WQU4DGCiors0CZ3P9GbABqtb1kfD4pih98niguywiUKsF7nEciVRLMu1f4rK2JtC/rruZxZICWkLKcRqNJoIq5u55U1zv6KPP/YC1mVQnMZswDLIvO4oIDJ5HTEsyjv5z6BQUb8I5mGBwIStS12pcKE5iv1Ejb6LU6rm2U+yWBDjBzHFl9Z0SfMoAQUVsEcvn6uTQCCrbOxQvA==
Received: from BN6PR14CA0042.namprd14.prod.outlook.com (2603:10b6:404:13f::28)
 by SN6PR12MB2783.namprd12.prod.outlook.com (2603:10b6:805:78::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Mon, 20 Jun
 2022 15:27:41 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::ac) by BN6PR14CA0042.outlook.office365.com
 (2603:10b6:404:13f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Mon, 20 Jun 2022 15:27:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:27:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:27:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:27:40 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:27:38 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 5/5] Documentation: devlink rate objects limit_type
Date:   Mon, 20 Jun 2022 18:26:47 +0300
Message-ID: <20220620152647.2498927-6-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e4f69b-26c7-4b0a-75f2-08da52d16a71
X-MS-TrafficTypeDiagnostic: SN6PR12MB2783:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2783A080F7731F4FF1F902A3D5B09@SN6PR12MB2783.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+T3Z7+f1c3YRVTdqDseQnPNKvW3dTxkpMyoKsQP71U4u7zYvcXQV8PPh9FtTWJZAmQ7ufVmRAsKY4ClHdD20DT3rRPJw+Lhw55LtMOvAO3ZGgtXYZTyF6UaQHPz0NX6SmyKaTc21/0eB4DO13DZqBXHilanSR/Hm+ja/7cvajl0SNUx13yP4yEPKQEhbIqn7XqXcGl17Io/efOxMFvMmsfsyIwZJkDGEQKw3vLGmcYweJ8SbE/BNGPR9XGUaBJMnuqYK5wAzxlMSKOxJJgosBwIn07Uy0sP8miqRL+BDFkvtwQBFmK1Xs4FFKnQKAwunMRB1AK9YqxIVWhkO34xsctED8DRFxMqGOOJX+//cz+w8smr3P4PY9cJAdk3KWbkN6hzJlGIHcDr4l0l6HorJOJnGOQlsA/UTtg0FjWhROqReladKi+vtCrIr4JZ3OmBJ4+yMcNDF0tnhsQ6SHx9bDKFx1sSKhoTXuVjvK10XzHX4CwMf91LAW85LugeMlLkyHQvcNLO2Vy5lpw+fapb/lE4n2gEhYH3awFTyoWf8A2aRB1tAhRcvtknXTVWPcBJMuAgDMYObXufD01DwQMbVjeRxRmURGJz+NoMzI+r0JBJDhWbouOBvFjIzKlpiOYRh04JgVl2aIZdIEStPX29dLcbzo2TjJmJSUvvKNv+zGe6ABe5s2L+FS6kdV4WA/KuFIZDlle9VG2Y44QtmqI0gVOHIAxqa1UJiXONmNDQwjlbXrckh9O6shzJNEcgWAFA
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(36840700001)(40470700004)(46966006)(336012)(426003)(70206006)(47076005)(4326008)(8676002)(6666004)(186003)(1076003)(54906003)(40480700001)(41300700001)(70586007)(36756003)(26005)(2616005)(107886003)(83380400001)(6916009)(7696005)(36860700001)(8936002)(478600001)(5660300002)(86362001)(82310400005)(40460700003)(2906002)(316002)(81166007)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:27:41.2091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e4f69b-26c7-4b0a-75f2-08da52d16a71
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2783
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink rate limit_type attribute information in devlink port
documentation.
Add devlink rate 'limit_type police' attributes in netdevsim devlink
documentation.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       | 44 +++++++++++++++++--
 .../networking/devlink/netdevsim.rst          |  3 +-
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 7627b1da01f2..c2cd97a4ec4f 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -184,20 +184,58 @@ This is done through rate objects, which can be one of the two types:
 
 API allows to configure following rate object's parameters:
 
+``limit_type``
+  Type of rate limiting performed by a rate object. Supported types are
+  ``shaping`` and ``police``. Shaping type is a form of back pressure mechanism
+  that can delay traffic until there is a capacity, available at the lower
+  level, to process it. Police type is a simple packet counting and immediate
+  dropping of those packets that exceed the threshold. Some of the parameters
+  may be specific only to one of the limit types.
+
 ``tx_share``
   Minimum TX rate value shared among all other rate objects, or rate objects
-  that parts of the parent group, if it is a part of the same group.
+  that parts of the parent group, if it is a part of the same group. Specific to
+  ``shaping`` limit type.
 
 ``tx_max``
   Maximum TX rate value.
 
+``tx_burst``
+  Size of a bucket that's used to buffer spikes when traffic exceeds ``tx_max``
+  limit. Specific to ``police`` limit type.
+
+``rx_max``
+  Maximum RX rate value.
+
+``rx_burst``
+  Size of a bucket that's used to buffer spikes when traffic exceeds ``rx_max``
+  limit. Specific to ``police`` limit type.
+
+``tx_pkts``
+  Maximum TX rate in packets per second.
+
+``tx_pkts_burst``
+  Size of a bucket that's used to buffer spikes when traffic exceeds ``tx_pkts``
+  limit. Specific to ``police`` limit type.
+
+``rx_pkts``
+  Maximum RX rate in packets per second.
+
+``rx_pkts_burst``
+  Size of a bucket that's used to buffer spikes when traffic exceeds ``rx_pkts``
+  limit. Specific to ``police`` limit type.
+
 ``parent``
   Parent node name. Parent node rate limits are considered as additional limits
   to all node children limits. ``tx_max`` is an upper limit for children.
-  ``tx_share`` is a total bandwidth distributed among children.
+  ``tx_share`` is a total bandwidth distributed among children. It's important
+  that ``limit_type`` of a child object and the parent node should match. In
+  other words, it's only possible to group rate objects of the same
+  ``limit_type``.
 
 Driver implementations are allowed to support both or either rate object types
-and setting methods of their parameters.
+and setting methods of their parameters. The same holds for limit types, a
+driver implementation may support all or only some of them.
 
 Terms and Definitions
 =====================
diff --git a/Documentation/networking/devlink/netdevsim.rst b/Documentation/networking/devlink/netdevsim.rst
index 8a292fb5aaea..32d3171ff281 100644
--- a/Documentation/networking/devlink/netdevsim.rst
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -64,7 +64,8 @@ The ``netdevsim`` driver supports rate objects management, which includes:
 
 - registerging/unregistering leaf rate objects per VF devlink port;
 - creation/deletion node rate objects;
-- setting tx_share and tx_max rate values for any rate object type;
+- setting limit_type, tx_share, tx_max, tx_burst, rx_max, rx_burst, tx_pkts,
+  tx_pkts_burst, rx_pkts and rx_pkts_burst rate values for any rate object type;
 - setting parent node for any rate object type.
 
 Rate nodes and it's parameters are exposed in ``netdevsim`` debugfs in RO mode.
-- 
2.36.1

