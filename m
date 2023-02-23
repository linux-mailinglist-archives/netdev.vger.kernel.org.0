Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA216A0346
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 08:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjBWH1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 02:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbjBWH12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 02:27:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10hn2202.outbound.protection.outlook.com [52.100.157.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5250C457F9
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 23:27:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6oVPGujI4Oa+QVxH6xs1rQSXpkAkgoET6wfFnEmm/a8lnSN0ikhVD5Pqftu3Seat5k75L1hqPyKux8UtHrxLVbav6T5rlzFELnGbXJiVKdgk6RfJtLjXKJ4is8KLHGalT3nlQ7rY5BDkQDij8B6MCz0qLR0Y1FgueeE7cR9WelYgTtfKnkhA9bkVdn+z4CxYj79l70H8ct9F19ZKj8OV+SaQSHKMVisfHwoZFo9wp6CDS+k9RyXPxXKHSFEeYli5YP57uvP8ECmGlCyMimzxvZBlvWVtMEVEfJ2ZNxUUuEZ5n3jP9lf2p98hNPcSxXADi3Q8UWZ87DHn0H9JWvOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69hDbuo7jOMfgABqCcuvZBVuZkwUujLWq0HJpld3Q44=;
 b=iDQbbA63unQPQ4w6dXNx9ch6VvHSZ4NYOtZaAnPB0aS7QPI43ncCNx4F/LAk8ITkSbt2MabhOdYAOw7VbOYYvWDCu1c3ZJWpgMUrS5BcXcOSSqtnpUE4N5zR9nHrTXRrbNHnxUhPfh1F+1kp7cOoG+caING5P5r6t1wc6k0q/lnTUVRVXKgonuPWxiETnHd5lcSo5FyhtPaeOphNZlitIc+UYOb++DHJyfHdhKN+TtSp3yo1h8nhTsOUNstYApucriatLmRipZV64zLrrrXnMQRj/kuZQmwqdR+xtWJw0ClPAhr1IAo3OiTTJsVUv8Fk1G0i9bsdpTNk8rvOFgbHrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69hDbuo7jOMfgABqCcuvZBVuZkwUujLWq0HJpld3Q44=;
 b=B3zMg02ACV70aPQCw7L0OV9rpRCi8ILymmdF40b7TPKgSh+5OCLtaudQotl1ga417i0dtFrHnyAP/i/irWc3EbyPX4q7HSOULtSgiQqvboo5jeBscZb9+KjxCZF6PsRHQDovQ/4rHGgsi53ID92ZL5Ro83mxtKzBBcf+R1j8RuCXjLxBEPXsgxePDCedh+jwsXZg7xi5AWfL93LQVaCYKjmunGCmSiFYdiVdsf3LGVhuQciq2FqupH29W614zUCqIzCeYkWgm5U/zjxuT14LLuHDA4DqMyp23gwBsS/C3sTS4Fm8SgUoza0P3mNmc3qj4C6qLGWNut8B25z9ElIfkw==
Received: from DS7PR05CA0016.namprd05.prod.outlook.com (2603:10b6:5:3b9::21)
 by CH2PR12MB5515.namprd12.prod.outlook.com (2603:10b6:610:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 07:27:23 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::41) by DS7PR05CA0016.outlook.office365.com
 (2603:10b6:5:3b9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7 via Frontend
 Transport; Thu, 23 Feb 2023 07:27:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.21 via Frontend Transport; Thu, 23 Feb 2023 07:27:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 22 Feb
 2023 23:27:14 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 22 Feb
 2023 23:27:13 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 22 Feb
 2023 23:27:11 -0800
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] netdev-genl: fix repeated typo oflloading -> offloading
Date:   Thu, 23 Feb 2023 09:26:56 +0200
Message-ID: <20230223072656.1525196-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT052:EE_|CH2PR12MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e1f9c6c-9a59-4fa2-1ddb-08db156f682e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4aoBgWyQyPgHRrx9oegsTPaAU64rCwr8YM7TLJSYDvb+RHU0dskdKxwC6aPl8SjkM5i1Bu+ZRhMJJyLGSaKhFC4WvZxVQHpG8hB/qLuwOzJi9tBm6hsnbYm4B626VLgk9HxPoArZYlgEHi7VTkepQ4YOFLl6IWowbYmTTvIvqQFHvQvFv/EvCcgzjWpRwuthJMACuX0kSp52/BlyI4r8/9FljeM+U5Bs/8KI8oShsGM5dw5Q6/Zr0KCxs7S6Q9UlyWoWkjgVyL/0ULcGlNvERh1jlSKwCSk44WGbolm7FTp8GXg3XkmX5X/3Zxm4k7BCbkefobTxGhNiVsomPzKD9oNKDa1eu3Cx0Sl4JboP+M2PO1BS3DBs84vEIbt1s9w5evQ5wzuBTSS0eQGcs4t0Kkigppy2rn07QoVX6X7J+r3gDhT0v3PcJF2+n90dIMOlwss2jhzr6AaGrpYNeXoD3ZDXZvqRJdsGMwWUz/GkdgV58O45h7Y8m13U+rXLLcwozY3QxCj52+ShfFhUZwcEP70WO+42X+PvPVJpVOT3ZOXG4hs5yOX5PuUPudv4UvdSBwa58G0FSkovBewgLyfP6QLCrzmSoQxxccm+MuXa4vIGhLM+OCJI8XHHbqDCnZI3niPNpyikABi9FsMlwV6/zofbj7bUyO/g8CoJkvIV21gbYdWZV8EJdaf7X9ExCzqHE0iYZWEEaAQAbguqZ4331o9Uc+lMWup2+0ZR/9JQC0Cak0fhS50MbqfCqvBPUpQ5VvWN6v/K939eLDGhZzEU+g==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(5400799012)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(70206006)(70586007)(83380400001)(54906003)(316002)(8676002)(8936002)(34020700004)(5660300002)(4326008)(6916009)(41300700001)(6666004)(107886003)(1076003)(2616005)(26005)(186003)(47076005)(426003)(478600001)(336012)(7696005)(356005)(40480700001)(82310400005)(36756003)(86362001)(2906002)(82740400003)(36860700001)(7636003)(12100799015);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 07:27:23.5056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1f9c6c-9a59-4fa2-1ddb-08db156f682e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5515
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a repeated copy/paste typo.

Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/netlink/specs/netdev.yaml | 2 +-
 include/uapi/linux/netdev.h             | 2 +-
 tools/include/uapi/linux/netdev.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index b4dcdae54ffd..cffef09729f1 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -28,7 +28,7 @@ definitions:
       -
         name: hw-offload
         doc:
-         This feature informs if netdev supports XDP hw oflloading.
+         This feature informs if netdev supports XDP hw offloading.
       -
         name: rx-sg
         doc:
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 9ee459872600..588391447bfb 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -19,7 +19,7 @@
  * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports AF_XDP
  *   in zero copy mode.
  * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports XDP hw
- *   oflloading.
+ *   offloading.
  * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-linear
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 9ee459872600..588391447bfb 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -19,7 +19,7 @@
  * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports AF_XDP
  *   in zero copy mode.
  * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports XDP hw
- *   oflloading.
+ *   offloading.
  * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-linear
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
-- 
2.34.1

