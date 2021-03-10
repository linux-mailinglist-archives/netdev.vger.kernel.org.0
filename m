Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE46334113
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhCJPEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:37 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:53206
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230260AbhCJPEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBROko2vTxHwmHktOthyG/sSaGZBy641f9ghMkWMTKky6huQCUYYqFsStzCBppJdXHhaton0FSfXh6IzF9wtKmw2wLvjsnm2qT5jRpVptmhjaNHycDJDgqIXAeixPQ6PsooV/jXnhYrAw5wtOOgVcszceHyaFiBO39wucUQXByZIXtHu/teFKYJYsyV6Dzn5juQoG68LtoL8uF+bfaeufHoKV5HM3S+/59FciF1WWSe1I5SPmvpJqJOJEVBn13/XbJ+BpreDxRhODEp4ja55O0v4yE4n+E9oLv+Ylhq0UnWhz0TG8m3RNsQQJzfl/5u/FqJ7hoxDP6s0zru/hB9tBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQdZiC82kGvokUMAbNrOkRn0coxutstZc70gjUjAaaM=;
 b=hLFfu7YA8daIVRRmkgrhry6594bJOHrQ0Js2bTeNQZR8uAd0WlNC4uC0vSxSlVUZlXPBDD0iPc8andtjF4sxsv5UDc+xOaj0Q4qnh9WDn0a8UYzBNwwf4YCdrCdYdPwyspG28yeKNHEww/fhQeDq1MMc8D4XWiSNgN4yXstlFjc/O45M0Gb+HqEK5i57gPLVix42LUU72MQpffs9wuG60umU+O8KbBAe8ntZvsSRNmIZWiF4LQBAYUV6Vr5EIUuXWLHtId6WMtm8ydhwj7gv5878NgPgJq+YaIOx6IvUlDd51zogHlq7jxxf3AZF/Cdoh8e7DIYUTIAdXHPIN8mAXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQdZiC82kGvokUMAbNrOkRn0coxutstZc70gjUjAaaM=;
 b=JMXl8rIGzztN485XokeOGwR5fXDY6+2m2s7iRMYAL5cQTD/7qHUGXOLn1XWGny+toRcGSD5yv/cC3IOlB0+qIYah1YJuIxGxnafDJRYNeaAF3PhTiEUdODcPewwBqwOe8v26W1L15TFIdPP6bgTNIwkAIUtXTp/rptCJuaJHEuh1bYDCzv6GGoFWY6MYZbOQ0HoIf6st/xmjif+zzGtDgcoEkNkGcGA3FnqAmwHGWMMPoBHD0SxwnW5qffNPiFXOuujiBMJv1gC+l03IopvaGz+g3UeojW/W6c/GNxP02gqMcsHBiMAwfbty1pEmz9/lYgbYvROIcOipOC+IJ1jYug==
Received: from DM5PR06CA0083.namprd06.prod.outlook.com (2603:10b6:3:4::21) by
 BY5PR12MB4274.namprd12.prod.outlook.com (2603:10b6:a03:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Wed, 10 Mar
 2021 15:04:08 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::20) by DM5PR06CA0083.outlook.office365.com
 (2603:10b6:3:4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 15:04:08 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:05 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 06/14] nexthop: Add data structures for resilient group notifications
Date:   Wed, 10 Mar 2021 16:02:57 +0100
Message-ID: <e4379e00764943a61983ccdfd6e1e90096e30ace.1615387786.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615387786.git.petrm@nvidia.com>
References: <cover.1615387786.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13279eb8-d48f-4cce-53bc-08d8e3d5c15a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4274:
X-Microsoft-Antispam-PRVS: <BY5PR12MB42741B051C8D2EA3872A8310D6919@BY5PR12MB4274.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: abqIqXuUmsN9NMWIzpcInFtM4VtqLSaWz2RDe9PKqCkaR12UR9iA0mZJ0wcuZCdtV5WFoZwkbet+m9JyVIXlK8snCdRuk95Fr9M9aPYI/71zRZ0NZ8EsmnlKM7M6JbqAFgxIVkq8bqBsPS1ygMDgwYd5fe+B6+n4KKTe+DW8VipBzlq20ZhHkPsNQBNCwJpQ+hzPwdboQPfiyUSTGNAb1hLfs13vqUGQpoij2VpW26fZIZzMJIZ1K9OK0nZnFmIMmVjciD8oNaWME/5qpyhVRm5o1p9bh0qAyl0BnnF1KD/DecsvstXMbGcUDN5z94auQ7aiAz3iubIaQwI8H/XJyx0aFQJXpFfITGJzPbAQvRQdo0EYXieZBE/PvRQENdJJA+Mri5F8Pe5jvJTF+NveXDqO0uqJ9QnILJ38/o+a0CMFm8ChS5zAXtQIEzPyf3id6/YYIANo13KTRF0g+gz3AF9rg36EhIMzhWLOUzxWUKzlUFOoDcv8OKQRZtYWJ/6k9cgo7YF2qxEa3cL6iJpZBrt/McpMoT5aIV6uwhippl0YevHrX05UJqBm4VbKiVhuKAJUZIr0khl0tUoqxXgYwr8J6TMBCmzI4/pD6kU8/2pVl6mISpg2SZe96gQIZoAuwO6kEKKXmfKp/tKwqBLx9OLyguTaOtMiIAuQ94v1CHNOompVXyTmMnbSXhBusLFy
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(36756003)(16526019)(82310400003)(186003)(6666004)(356005)(316002)(26005)(107886003)(83380400001)(70586007)(2906002)(4326008)(36906005)(54906003)(34020700004)(82740400003)(426003)(47076005)(8936002)(70206006)(478600001)(36860700001)(336012)(5660300002)(7636003)(8676002)(15650500001)(6916009)(86362001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:08.2517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13279eb8-d48f-4cce-53bc-08d8e3d5c15a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4274
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add data structures that will be used for in-kernel notifications about
addition / deletion of a resilient nexthop group and about changes to a
hash bucket within a resilient group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
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

