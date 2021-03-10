Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E597333410C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhCJPED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhCJPD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:03:58 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on0626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E31C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:03:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6S463IsIltKFSyIPKdGzvzrEmfO1IuVkPNnAqqp6u23AcU1fQ/PAqElHYLj9jjxi/Zn4y2OXUAzJ1HhoKcoiK2bb6wUhNOlWVRMQu5JV4HRsXbYw/VVlmRYJYYRZ4lZAOs6VuoBHlXLhQf7u8wfpviNXz5BVcvJTPFt00RK99jVtgw8K7jbvwmiSVBF6bo+GlnnCYFTSNac8x2qEYfWoMHcy32yJT8EULzU/IuAvlhmigSNIf+CqzbUSoUBmS08wQ4YOjiZ3+leDS7xaOqgLqye/ht+BE42V0KksojHow5WzP+LTOgwXVoPtffQ7jwkIh2LPnKdyWYvK0KhfVS08g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opYJkslD4RvhtsLlGMTDCBZZjjy8d1/FxuUaTAululY=;
 b=M4r//YqPR8ZvUI/PQhtU3KZt1URHyACDUnw5daCSiM5dWb1VtcKZMBQuikd8aSmz7hToxzegBjwt0Nns4ZUATxhA1oDYclqqUwOPBU9Tx3RWqdOLDPizOG4gljoQ06OF56pYetLNE1u6qWf3blVdhfFCcLEgc8svuCNPKin2CCYX8m/2xKmLCWvpeXQ7N5Pr66hXsjpv1xi/32XEK9XgCq0Usw3qAAB/tXz85GPBpZukVrKKM41tNm0N9WxOsFR2K88jUT8gsIy8Swwh+lOcfNCEJUOqhuM8p/p/W5wbXRl/OYQRRX1ke6FWvvDYpTI3Z8MmlcfpYFhgW+7/DSSfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opYJkslD4RvhtsLlGMTDCBZZjjy8d1/FxuUaTAululY=;
 b=izcssWGEterGh43sbB1nfgy3bb0EYIM4KHBlUCmzZaEWHtyJON3chOjdu/DjZhATur1mcD7Ni1ZNCRHjlBH0aYc84rSWB6sIQ7V/8EOVGwiyvrgIXZ5aceht8DPN7pACj3umVq5Ttx3IVmLwHRbVl0HKaFFiJWHwJTuROwmGTAPJ0Qa8J29cFQk0BZNzr4MMeU3YVlkuMGABSK+p1FIKYxId2dVfexuqIiX3AbECZJdiuCeTX8fbLtr2m+crQTRJCW+wmgKuLShF2AS9Bugv/vAo3iQD+/72qaGnIZI43Uag8Ukw8bVJf+B3aKZes2TWhWOxUi1A5uvxu+/w4gSuwA==
Received: from DM6PR07CA0088.namprd07.prod.outlook.com (2603:10b6:5:337::21)
 by BYAPR12MB2822.namprd12.prod.outlook.com (2603:10b6:a03:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Wed, 10 Mar
 2021 15:03:54 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::f) by DM6PR07CA0088.outlook.office365.com
 (2603:10b6:5:337::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:03:53 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:03:51 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 01/14] nexthop: Pass nh_config to replace_nexthop()
Date:   Wed, 10 Mar 2021 16:02:52 +0100
Message-ID: <0a2e419897d7081c273762b58433c8c359ccd98a.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a010c1af-6814-4a04-cd79-08d8e3d5b8b1
X-MS-TrafficTypeDiagnostic: BYAPR12MB2822:
X-Microsoft-Antispam-PRVS: <BYAPR12MB28227D724A7106C7F51B8BB9D6919@BYAPR12MB2822.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 27tayCjsJcuEkM4lcX7qPh3kJg1lxzXpGo1JF+qoaMpcQOKVQdkocgkyHYJ0K9Xm4CprHEUPqwZY08EH5aqrz4zTmkpQYiV/5y7DucMWn3UmLTsh/VWktj6l/6hLdwKQA6txRZXdCaOfJL+jOVIHFgMs7mM6VjpZ4FTfm9uyqXTbPtWLLGnW0xG3z+p9erpBu0uZ/L+s5AO12vqNSf3SrFIHDVgRUCcqgNHknUZBw0FJuuYRCkxqid/lxooR1Lajvpx/1i8/1Wk5+XJ2uEti1vZfK/Amchz+gsg+tj0TJWjiTmGpVEhZOfizGCZGRS1VfliX5czegJx35pXa7FKIcTQspzsJJJVSZfesbDd0AqORawaoinKmCoeAVh/Y2dSPi2v+hTt6mDK/DnKVoyHB8eQyLnxKR6qS46fTAg8gjCXFHzWCust6l3y+EDPrM+tKD+4zlOS2LD9LtcDNSINeoxwmSrKyaGiFXXzNpFZD7h0zg2Zaor/l43UMIDckMdHQKMXa/PflzJXB87lbP6GR+dangY71f1ROg0jDA44xDjWE0w2zgJy4hwgdEV8R9U+k/Bw/m4I8TyLh5zNKAMWCNn4lq7PjCETePPx9ja8zqcHQkmdpx/fAAkiSdLpVbOQIzcqk99IZ0UiXUnnBb78fQC3UXFaBTPWWSQDTT+z2Yru4Jrbk4zn0Dvtvcykq9UBf
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(4326008)(2906002)(8936002)(7636003)(83380400001)(478600001)(82740400003)(8676002)(186003)(26005)(36906005)(54906003)(16526019)(316002)(107886003)(6916009)(36756003)(86362001)(5660300002)(47076005)(2616005)(336012)(36860700001)(356005)(426003)(82310400003)(34020700004)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:03:53.8105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a010c1af-6814-4a04-cd79-08d8e3d5b8b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2822
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, replace assumes that the new group that is given is a
fully-formed object. But mpath groups really only have one attribute, and
that is the constituent next hop configuration. This may not be universally
true. From the usability perspective, it is desirable to allow the replace
operation to adjust just the constituent next hop configuration and leave
the group attributes as such intact.

But the object that keeps track of whether an attribute was or was not
given is the nh_config object, not the next hop or next-hop group. To allow
(selective) attribute updates during NH group replacement, propagate `cfg'
to replace_nexthop() and further to replace_nexthop_grp().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 743777bce179..f723dc97dcd3 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1107,7 +1107,7 @@ static void nh_rt_cache_flush(struct net *net, struct nexthop *nh)
 }
 
 static int replace_nexthop_grp(struct net *net, struct nexthop *old,
-			       struct nexthop *new,
+			       struct nexthop *new, const struct nh_config *cfg,
 			       struct netlink_ext_ack *extack)
 {
 	struct nh_group *oldg, *newg;
@@ -1276,7 +1276,8 @@ static void nexthop_replace_notify(struct net *net, struct nexthop *nh,
 }
 
 static int replace_nexthop(struct net *net, struct nexthop *old,
-			   struct nexthop *new, struct netlink_ext_ack *extack)
+			   struct nexthop *new, const struct nh_config *cfg,
+			   struct netlink_ext_ack *extack)
 {
 	bool new_is_reject = false;
 	struct nh_grp_entry *nhge;
@@ -1319,7 +1320,7 @@ static int replace_nexthop(struct net *net, struct nexthop *old,
 	}
 
 	if (old->is_group)
-		err = replace_nexthop_grp(net, old, new, extack);
+		err = replace_nexthop_grp(net, old, new, cfg, extack);
 	else
 		err = replace_nexthop_single(net, old, new, extack);
 
@@ -1361,7 +1362,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 		} else if (new_id > nh->id) {
 			pp = &next->rb_right;
 		} else if (replace) {
-			rc = replace_nexthop(net, nh, new_nh, extack);
+			rc = replace_nexthop(net, nh, new_nh, cfg, extack);
 			if (!rc) {
 				new_nh = nh; /* send notification with old nh */
 				replace_notify = 1;
-- 
2.26.2

