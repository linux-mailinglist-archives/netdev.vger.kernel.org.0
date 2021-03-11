Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A826337BAB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhCKSEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:42 -0500
Received: from mail-co1nam11on2045.outbound.protection.outlook.com ([40.107.220.45]:34785
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229944AbhCKSE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrnTrPL1DEdjzVZMToPgBSviCoY0Xex8230H4Z4HkWmNGhEZJkka7hNNVL2OTTYlQxC+uxUfbDsuE6q4BRtw7YJ9SxPTdcraC7JuzxVUKEV5KL2s/nLGHYcF6J2AO2zc6xRG4uAxUv3xbm/0eVh6+1qq7hZ2k1279kB/WufDBc14zqfagHomNDBu92Hlk3LJATVWZQicrzmLOFwnF+hNl8O2YPQIXNw501q6j2gAwsbiRQ6nhHUrOFBywtNoxNZf08uqF/+Kb2LGYRGFfEL1ZUZrmF8UOzJZnjJ4WQ4D2oXZJATI9fBjORvTBhTMaaV1a2kbf90k5XqIfQwx/X1XWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcr5Rmawi5SAH5AH1CEvdJL1hBgcM8TnNmO4h5CMyZs=;
 b=mfjt5NKRvuW1FY9WZ3T/k1s/r3BFPLHXssS0KSZar38nKaUAm65qYy5UVTYiIOL8mjTaoSSFZYTiarFUL/3QiCqNpHKIqYUweKymWuPuifQLnlF1L8KLz4Um2CKdYr5ZqBMPi0+9hJoDMQXnv1btv/vUW7gDs8HDE68jRUyTMlT+xdh5O4AoWwGx3AynF9G94om8BuRGol+bWMF4NAGkkKtvf1YbmLi9TFLwv7epASlRg9+TvQmPjWvw23e2A7UZK1d4Ej1GiaEvhP/4Gc4HCOQYPewFwrEGqYazERu6gXikmMQU/RBHjYhv6hYhSdibk9r2Fy7NQ+bvgr0XhgNcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcr5Rmawi5SAH5AH1CEvdJL1hBgcM8TnNmO4h5CMyZs=;
 b=alLKwQtsFIxifo/qZ8oCe/yXWAwJyke/NdHV2LICFiHE9uLCFyc3xDPbPcDFiP2Hxq1iJVUVRJkzQqFUzDv99TlvUv09ipZzkrJ7qTXTlQxPViA3yEqlOYMSBt/2HaTPCroxiEeEvCj1ptyKVwPxANIv+dTzJk2EyWdR2EzXw7QgEpmh8PlQ/bs1tzIWPKlg9Tx/5bs2QGg0RRatz53ZaTEt78viWFFaPGoCFC4ozrKI3wsoxgHmtjURFI5zwUInbZJZFYnRUQ33WuLBnBTgr9l75oMTYOyd6RexjEAXwobBoIVjrSfkFaVD9Q8e/eufksvuS/X166ffYQ0I3qOZMQ==
Received: from BN6PR13CA0028.namprd13.prod.outlook.com (2603:10b6:404:13e::14)
 by SN6PR12MB4720.namprd12.prod.outlook.com (2603:10b6:805:e6::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:04:13 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::4) by BN6PR13CA0028.outlook.office365.com
 (2603:10b6:404:13e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:13 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:09 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 06/14] nexthop: Add data structures for resilient group notifications
Date:   Thu, 11 Mar 2021 19:03:17 +0100
Message-ID: <30f98ce4f780d167a45454f09fb4b0111b449f7e.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
References: <cover.1615485052.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3352acdc-e62e-4c7d-d930-08d8e4b81430
X-MS-TrafficTypeDiagnostic: SN6PR12MB4720:
X-Microsoft-Antispam-PRVS: <SN6PR12MB472066C88F83AC8584840194D6909@SN6PR12MB4720.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JUrByedGIgdxyYGstVGGkW5dyTKziI8LDfGb4C8fC8L1gTxEgHcwy3Rr9XPrdwsvhAAVct+OpZQhviV8BrYBWUWkMKExU/N7MWsSt2bQDC/wqQszLkkjuUPCtzyIWwD6oYezFuLp02fxZsdhs1qJ6LJLX5NEE4xA0jJdyQ0U8tYTMcDAV5ZVRLtSaSSaPiRhljFBdmeHsr+MVtIU7VluN/R09AzcyAefj+WmiDdB3wjYkY+18k1gNKHquZ/VAsGVYQHPc/hAJUir1SW3Tf4j9O2k3L1U7NC0XXH8f7emkymdrJwNV6iTHncgxpJ0bFMVdIu+JBX1GOz5TgXF7OH5Ehwp8leW6C1EUAD7xc6ewV95r1foLK2/tO7PalpK5ulCfRxlZbqSvc3VrbqMgg/7drs/Iuv5WJyMg9k4+QOzqISakuU7SL7nv4Wn6b2J+W0JWdYT1cLrlXwL7X5kepX9bCb4Y3sb9Ii11aY7PNNUvftYR7XGEDc/gEgY8LatRx0hWXB+BLnTl+iGKir6BVO0j0ZGE9x4R22grYj44NqbBi4y9DwZRwRCPMWhmtmxQmSik3NhVYJ5FMrtLF0MhPaZBSTCpYl1GXy95JA90upldO68iHnMFPkiJgNiiw4FAKSjZ273coLgzjkguIQbnvNOBuNTkLtHqq8bNggGnejI1nBAEh1JEOoGDtu9AN9kcOg
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(26005)(356005)(83380400001)(8676002)(86362001)(47076005)(36860700001)(186003)(336012)(4326008)(107886003)(8936002)(82740400003)(426003)(16526019)(36756003)(2616005)(6916009)(70586007)(70206006)(7636003)(2906002)(5660300002)(36906005)(15650500001)(34020700004)(6666004)(82310400003)(478600001)(316002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:13.5137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3352acdc-e62e-4c7d-d930-08d8e4b81430
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4720
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add data structures that will be used for in-kernel notifications about
addition / deletion of a resilient nexthop group and about changes to a
hash bucket within a resilient group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 include/net/nexthop.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index b78505c9031e..fd3c0debe8bf 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -155,11 +155,15 @@ struct nexthop {
 enum nexthop_event_type {
 	NEXTHOP_EVENT_DEL,
 	NEXTHOP_EVENT_REPLACE,
+	NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE,
+	NEXTHOP_EVENT_BUCKET_REPLACE,
 };
 
 enum nh_notifier_info_type {
 	NH_NOTIFIER_INFO_TYPE_SINGLE,
 	NH_NOTIFIER_INFO_TYPE_GRP,
+	NH_NOTIFIER_INFO_TYPE_RES_TABLE,
+	NH_NOTIFIER_INFO_TYPE_RES_BUCKET,
 };
 
 struct nh_notifier_single_info {
@@ -186,6 +190,19 @@ struct nh_notifier_grp_info {
 	struct nh_notifier_grp_entry_info nh_entries[];
 };
 
+struct nh_notifier_res_bucket_info {
+	u16 bucket_index;
+	unsigned int idle_timer_ms;
+	bool force;
+	struct nh_notifier_single_info old_nh;
+	struct nh_notifier_single_info new_nh;
+};
+
+struct nh_notifier_res_table_info {
+	u16 num_nh_buckets;
+	struct nh_notifier_single_info nhs[];
+};
+
 struct nh_notifier_info {
 	struct net *net;
 	struct netlink_ext_ack *extack;
@@ -194,6 +211,8 @@ struct nh_notifier_info {
 	union {
 		struct nh_notifier_single_info *nh;
 		struct nh_notifier_grp_info *nh_grp;
+		struct nh_notifier_res_table_info *nh_res_table;
+		struct nh_notifier_res_bucket_info *nh_res_bucket;
 	};
 };
 
-- 
2.26.2

