Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B74618F6BD
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgCWOY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:24:28 -0400
Received: from mail-eopbgr40135.outbound.protection.outlook.com ([40.107.4.135]:20742
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbgCWOY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 10:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDlGNYpFxCEcd4tRN7MPPfE2iNVmMZo6GJt9mUCdt6rmPl8Hp0PRUij1icS8TOMZHmCcKZQxCP9HSuG6ZCjiaFx6ldnEJK71ZMfdZmObt4wyb14skLVSMxoljgr269EenR2xFTQVxTXFfG2hrK19RiXftT6HSfygdNHe+y1WrMGE4boIQgvWqUm8REGrZ5k9cLvYnAIUNUCYDZseDU5/s8p6dXqzj3+XJo8jBQgeL4qQGX6Gc9zI/Fe/KMzNyG1JQHdhjxkPCml8dGbvMQIoPqhD5npChw2eFkioLh8s3fbJzMyj9BDeb4cLh7FN/gNl4oaumPnGLKhlOqHwZWtMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oue/VMVWIr6wS33jM9j3d0ARHYYV19thfK7kyhVN3c=;
 b=MPnfZVi9tb3YXrAO+XbuR8+55dtqjSE7ubZQQ9jHh5QuUYHgkUPcytGcMOwUHjX2cMfjPlh5TzZOxqyvRZ2VZHi6NPxhWaybScwLtMbnkn+MCzBqCH0m+teRNN9pA/qcOnCX1H9u3sompg2Vvj20a+ShT4+TZvR8C15+Fg7yQkC+fBDV6Lvf7Z+R0tq+c8QzN3qMSOhdaV8rcqFzSzXcGxCDf+73vMNwLgXxXuHkwNDcDdpezGCK7jOXatT5vGPvcrvl+MzQz6Ah87SeVOGgw8f0ar5KV0DDbYRWOlH0jPyIIVkRp4dj3TV9dgnoIWRPuq3Mcxmhq7YO2UyTcq0FZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oue/VMVWIr6wS33jM9j3d0ARHYYV19thfK7kyhVN3c=;
 b=WYVXsY/EnEgy+BYdUqYZ+ZxMPuFJzBn0gW5hYrjDJOZI7Qws4YYDl+LNt9+pHUZZ5BAfabwJVM+Rkidv/AcuTd7Mh1Bc2G1dp9Gm98pIWBJMrIH9a6L8uLU4g4Ao43bQwhmU/jPlBFMFyPWByVCsUWM85FA2XG5xo3z7En7+LJ0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0384.EURP190.PROD.OUTLOOK.COM (10.165.197.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Mon, 23 Mar 2020 14:24:23 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 14:24:23 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH] selftests/net/forwarding: add Makefile to install tests
Date:   Mon, 23 Mar 2020 16:24:04 +0200
Message-Id: <20200323142404.28830-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0201CA0011.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::21) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0201CA0011.eurprd02.prod.outlook.com (2603:10a6:203:3d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Mon, 23 Mar 2020 14:24:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29a3ea7b-37c1-4f8a-6ded-08d7cf35e20c
X-MS-TrafficTypeDiagnostic: VI1P190MB0384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0384E8AEF48139E65FB0A05995F00@VI1P190MB0384.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39830400003)(376002)(346002)(136003)(366004)(396003)(199004)(956004)(6666004)(1076003)(66476007)(66556008)(36756003)(66946007)(5660300002)(508600001)(81156014)(8676002)(8936002)(81166006)(4326008)(86362001)(6506007)(44832011)(107886003)(2616005)(66574012)(2906002)(6512007)(16526019)(186003)(316002)(52116002)(26005)(6486002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0384;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adJ8qK0wfH9+fsFIQrXrHnVAnSZJjLp/hyAocqVl0ruN5/wRncWRp1b5FmkXejfJLz3oOcetYt9oQWLCOvTiEiNrGNtGv8hH1GpFF+6yH0PJ0h2DDQLwinDm/N39txxh9fN0SqRgI3bWxbu6L3gjyd4HpcYexrnVTNjhczec1XBA+cbkHeMGqB4TP9HM5R+jGAn0jVtEpkGPrh8JwsSPv2azmamt2zLoo7XX124QEbrbI8mZJfKrbgln9NA/8d0VFR0ICZwipsgHpm/ZFLugpY40Y63YECarubzGtlBIonXGhjwVwvbFcqMgN0tIFX4DruOO4syTqXP4dD/+oi4wqStGlgdgpJXHugcgkvN8EUy2PFfaT9pwu9/kQVauA1wld2CvLhZvYKgGAzQM7dJQeW3Ef4gZe+aAc1+oEhZrYo2U42fjKCSxe8y5s1W7MmuU
X-MS-Exchange-AntiSpam-MessageData: zy4Wp82SgBbKpy6vxZY8CuZpamN+Zy/3n9rh4yFBrlhhxut4Iee7n4Srfew1BNGTm1zyx22kMooxxEKS1aRC1KuDjliHt0eCThGpbRsjO4ul4UI/bzMykuQ1PZiUvM+GyZz9WZrLuuan70JFWUE3+w==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a3ea7b-37c1-4f8a-6ded-08d7cf35e20c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 14:24:23.1284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boJsFcITEkvPBjquKY5wixWrwjgbVmbK88prQLySzLl5six4A5UlS0zs3Vh7UMu810GL0AdRYeC2P2hPRFfpmoU9ajiyH0Sm2piiAVpFxwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing Makefile for net/forwarding tests and include it to
the targets list, otherwise forwarding tests are not installed
in case of cross-compilation.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 tools/testing/selftests/Makefile              |  1 +
 .../testing/selftests/net/forwarding/Makefile | 75 +++++++++++++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 tools/testing/selftests/net/forwarding/Makefile

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6ec503912bea..b93fa645ee54 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -33,6 +33,7 @@ TARGETS += memory-hotplug
 TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
+TARGETS += net/forwarding
 TARGETS += net/mptcp
 TARGETS += netfilter
 TARGETS += networking/timestamping
diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
new file mode 100644
index 000000000000..44616103508b
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -0,0 +1,75 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+
+TEST_PROGS = bridge_igmp.sh \
+	bridge_port_isolation.sh \
+	bridge_sticky_fdb.sh \
+	bridge_vlan_aware.sh \
+	bridge_vlan_unaware.sh \
+	devlink_lib.sh \
+	ethtool_lib.sh \
+	ethtool.sh \
+	fib_offload_lib.sh \
+	forwarding.config.sample \
+	gre_inner_v4_multipath.sh \
+	gre_inner_v6_multipath.sh \
+	gre_multipath.sh \
+	ip6gre_inner_v4_multipath.sh \
+	ip6gre_inner_v6_multipath.sh \
+	ipip_flat_gre_key.sh \
+	ipip_flat_gre_keys.sh \
+	ipip_flat_gre.sh \
+	ipip_hier_gre_key.sh \
+	ipip_hier_gre_keys.sh \
+	ipip_hier_gre.sh \
+	ipip_lib.sh \
+	lib.sh \
+	loopback.sh \
+	mirror_gre_bound.sh \
+	mirror_gre_bridge_1d.sh \
+	mirror_gre_bridge_1d_vlan.sh \
+	mirror_gre_bridge_1q_lag.sh \
+	mirror_gre_bridge_1q.sh \
+	mirror_gre_changes.sh \
+	mirror_gre_flower.sh \
+	mirror_gre_lag_lacp.sh \
+	mirror_gre_lib.sh \
+	mirror_gre_neigh.sh \
+	mirror_gre_nh.sh \
+	mirror_gre.sh \
+	mirror_gre_topo_lib.sh \
+	mirror_gre_vlan_bridge_1q.sh \
+	mirror_gre_vlan.sh \
+	mirror_lib.sh \
+	mirror_topo_lib.sh \
+	mirror_vlan.sh \
+	router_bridge.sh \
+	router_bridge_vlan.sh \
+	router_broadcast.sh \
+	router_mpath_nh.sh \
+	router_multicast.sh \
+	router_multipath.sh \
+	router.sh \
+	router_vid_1.sh \
+	sch_ets_core.sh \
+	sch_ets.sh \
+	sch_ets_tests.sh \
+	sch_tbf_core.sh \
+	sch_tbf_etsprio.sh \
+	sch_tbf_ets.sh \
+	sch_tbf_prio.sh \
+	sch_tbf_root.sh \
+	tc_actions.sh \
+	tc_chains.sh \
+	tc_common.sh \
+	tc_flower_router.sh \
+	tc_flower.sh \
+	tc_shblocks.sh \
+	tc_vlan_modify.sh \
+	vxlan_asymmetric.sh \
+	vxlan_bridge_1d_port_8472.sh \
+	vxlan_bridge_1d.sh \
+	vxlan_bridge_1q_port_8472.sh \
+	vxlan_bridge_1q.sh \
+	vxlan_symmetric.sh
+
+include ../../lib.mk
-- 
2.17.1

