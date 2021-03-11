Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67312337BAE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCKSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:44 -0500
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:25441
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229972AbhCKSE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpgT6ZSfHlBjE7H3yDpnfWyjpxMo5hblGTlONvZAACLe46TjKrcTpDmZwy3pfLfZbWhDZ+5p640ALPs0A2LIacaVYyWM8WQLNk8tU58Jd6vXjxcTTNQNebdooH8aHz1teFt5RMHKGcRPfMXaGCKfCoKl1mRmfANdP0cGMQRdApuHHmct7ZbBRCSk9MVkhQzCNur/W4HCI94FtJBd8ACWZ5wGtJdf4T40dOc+0twg8O7O9m5u4VG/A9Ytk3GY5uRwVxNce03Pqtf9Ama0j9NM07/oILjAqWnykAABtmerAPxyBnEe3J7gY/SITbhVmzyncrZhqoDwayiMoDeZcK0y0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhjHWRNrYFNGg7GSevSOjoVhibu2wRer0P/CHRCgIaU=;
 b=OEB8U5jHWJYubw0m1FfqEAyVJcAENTLMXDtmdjPeHIVKL/h0N3S9BGXlo2EhldpFYXP23zmchuxHDMdHnYhhSoQUpaRWWJm97p7430SIB5VIS7oNQ05ktxwXUd43iw0raz8FCh3No7GB5NV4M9f5tNRc3Q0xdsshjbLTajf1jOo9R3/y4ubJxOc8FfwmIOogbD4w21uVpFmoVIt3CR4PVqtwOvh6T45Bq4+nZON+Wvg8FsXlmbcfmsPgVx3BmLl3TBdyiFnqjBuJQFB9LBlBPgML3MGqHB8Uo+kxKVRTwOf2i5eo1wiX9LdlPGGbgMEM5nYAfx0sbrYZ6+AX9YNgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhjHWRNrYFNGg7GSevSOjoVhibu2wRer0P/CHRCgIaU=;
 b=Dec3MwmBcGcsM0RYyPTuvjLbWacm7tEm27UiWxpGcSNIfis+cY0QSDjcX2e7ije/zdHNQbTg2z3bP9ovHvZ2neK0ceLqAt1mHtloGGgj/aJPZMb3HZqV0WELq4Q5AZHL+Jm4GivhTEYKcGBW+5QNjWsQV5bM88kgZA9hPr+m9ToKbNBpYDolI8cnLaPzV2a4u5FJP9bWakaXI49IWmvqIgj2HRn21GyvO+ULHLdDB4zupvZ21rb7rwjl8VSWD0fZvCj1gYoCnnIepQXI3Z/W4qJXNLmF2VssngA6MpWLA9P3eeHD8upyJbRFX58JQq9/csBEXCmzFjQnRcBt6yqTfg==
Received: from BN6PR13CA0033.namprd13.prod.outlook.com (2603:10b6:404:13e::19)
 by BY5PR12MB4643.namprd12.prod.outlook.com (2603:10b6:a03:1ff::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18; Thu, 11 Mar
 2021 18:04:25 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::af) by BN6PR13CA0033.outlook.office365.com
 (2603:10b6:404:13e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:24 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:15 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 08/14] nexthop: Allow setting "offload" and "trap" indication of nexthop buckets
Date:   Thu, 11 Mar 2021 19:03:19 +0100
Message-ID: <b02a9c5e56f37fbb83b9443c1cff2bcdff216ad5.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: b4c641e3-7572-4f45-81d1-08d8e4b81aff
X-MS-TrafficTypeDiagnostic: BY5PR12MB4643:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4643BF0337879367B7EFB957D6909@BY5PR12MB4643.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 08lEaxaKiFq43PZPaP1OlCBgHyb0oXkBHKFMOBHeKChjf7PuYAColC0KL66r1yCUiGF1TNv7IoL0PlAGnSuNlXAoxkb2iySbvas0MkGwCMfL+ngZ6PiCRCSlp6iUpxUbnZwEv8sASb17kBKwIzqOjbPjfArnKncImh4bMC1SOU8ahzda7d+e0ZU3UiJM25i0H8irZIINY+LLh3WCtkBH9AgOvQ3Z2XardilzkF0v5rIxG4ODn+uMnC3k9nGUFYjUhC0U6F/ufaZT7iap7xCzIt6yPjJeXjvRTlp7jtkhnCxYEqi8bDT85s5VY7Yqw7bBPRFQsEiFJaor/ZO0SAQ7mQZASa1TVIrdUkREuAjOUhar5844eQOtV2orOnnzAF5ca1gVbNdjEW7H7naanaIF//zLsyZ9LS+ZYMUU6awAbAboAkrswOsMjwT+oebPPe3LLt6Z/k2J81yaPfCvGfRX+IzFf+rgSSjBd38skc5rz5B43ekUEzSMabADb4ZN+Tgwyfqi2Ub8rAnSaVo4UiKCbGo2qs9xBK6lwox578olEOSJ2bwuyD5wxNM980hrd6gUhQWE18ZEoIRNsSMm9z5DCAy2f5ciSEeBKQP+mmOzMNPmy2AK8SuNVKSekKDg7kXukswUdSG+ItOm9YKy5s3cCGjGuqW2Nu6rtXOzdA8f+sLhvxDBhuPgkRcifwQchZAE
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(34020700004)(5660300002)(82310400003)(4326008)(16526019)(47076005)(478600001)(2616005)(316002)(7636003)(336012)(8936002)(186003)(6916009)(83380400001)(2906002)(82740400003)(26005)(36906005)(426003)(36756003)(8676002)(70586007)(86362001)(356005)(36860700001)(54906003)(107886003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:24.9314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c641e3-7572-4f45-81d1-08d8e4b81aff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a function that can be called by device drivers to set "offload" or
"trap" indication on nexthop buckets following nexthop notifications and
other changes such as a neighbour becoming invalid.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 include/net/nexthop.h |  2 ++
 net/ipv4/nexthop.c    | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index fd3c0debe8bf..685f208d26b5 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -220,6 +220,8 @@ int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
 			      struct netlink_ext_ack *extack);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap);
+void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u16 bucket_index,
+				 bool offload, bool trap);
 
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8b06aafc2e9e..1fce4ff39390 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3072,6 +3072,40 @@ void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap)
 }
 EXPORT_SYMBOL(nexthop_set_hw_flags);
 
+void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u16 bucket_index,
+				 bool offload, bool trap)
+{
+	struct nh_res_table *res_table;
+	struct nh_res_bucket *bucket;
+	struct nexthop *nexthop;
+	struct nh_group *nhg;
+
+	rcu_read_lock();
+
+	nexthop = nexthop_find_by_id(net, id);
+	if (!nexthop || !nexthop->is_group)
+		goto out;
+
+	nhg = rcu_dereference(nexthop->nh_grp);
+	if (!nhg->resilient)
+		goto out;
+
+	if (bucket_index >= nhg->res_table->num_nh_buckets)
+		goto out;
+
+	res_table = rcu_dereference(nhg->res_table);
+	bucket = &res_table->nh_buckets[bucket_index];
+	bucket->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+	if (offload)
+		bucket->nh_flags |= RTNH_F_OFFLOAD;
+	if (trap)
+		bucket->nh_flags |= RTNH_F_TRAP;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_bucket_set_hw_flags);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.26.2

