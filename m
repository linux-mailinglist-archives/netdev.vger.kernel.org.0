Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8FE197572
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgC3HR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:17:29 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:55440
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729373AbgC3HR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:17:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8SQqOEAfNwf3SpxM92HtgM+Ec2bBKgrO34wkn+8G3se6/Oue1nlow8k3w+arhCOSR5Zp+YEPQ1dgWzCi6RnmdoyKI7eXPBYVvSWQyGbz6bD+0vSmWsLZp1u/t7OHOP+EVvNJ3ebhnv428yZwEwzZG+GW1/mk/cSAqfQ5sOlWWXzA2MNxCy6CxjyItiB/XtdwBCjDDUI02U8NayYvHzf+UyxXFNTt9HGNrMGZ/SMUYO5cqu/UQxuXDSX5yqKHRyXUHMYx7TufVzAAxorOVMTJIBXwpa2TPZZ0mcvTtmna1FnMxZB5CVfvXpGAgyl554i4RcdK33eog7Rfets4DqsVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUkOYmJcVDmfb5Jby64t2SlL5H9/rS1fgISYgzUBLCA=;
 b=GuU0b7/CsEGciJIUeHqriyqGuZYxLE0hVpLy7I1ZYt8QNV8zDkqb85KR9GENMIMGn19PAlTgKYALutltLbgfhZHcRbyD7wXu74GohlkMh+wOVGq32wti6tzWqiTUcCiPi8bF0oLft4+TYEy7L1G6YW8C5aVqpNtfcDJdS0NRTrnfMGldlOR4ZUhXs4vKnEQWcPse241gOSCaOwq55Xvuy8jOaKha6uMT4qAPIdSLVcz1TPYpqM689TOKf1YaNycbKTyUZVH0+aNhaAIbx77nngcJHoc8NZNtZdepENGZvWJQ6qi3vrDzRQKrrci9bR066Qj7ifdG9aBeZ8NV1NMnxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUkOYmJcVDmfb5Jby64t2SlL5H9/rS1fgISYgzUBLCA=;
 b=p/3d+dAVPt8KMRPzKH2ihx6N9IzsuYa8VcODCuIxRv4cChcgaI0tfkpdrxsbL9ifsjGedqF2TQ7BaoSb9j0qgOSRlaPN7GxwHa8iCEAcOe79BuY8KJH53GbW6YzcxrwNBMqEJlqt5yE8GUEhkI1dmer+ynTGLSwCzE8ip4VGQeQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4989.eurprd05.prod.outlook.com (20.177.52.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 07:17:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:17:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [net-next 2/4] net/mlx5: E-Switch: Move eswitch chains to a new directory
Date:   Mon, 30 Mar 2020 00:16:53 -0700
Message-Id: <20200330071655.169823-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330071655.169823-1-saeedm@mellanox.com>
References: <20200330071655.169823-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 07:17:21 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06cc80e7-56e7-492b-7d35-08d7d47a647e
X-MS-TrafficTypeDiagnostic: VI1PR05MB4989:|VI1PR05MB4989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB49895C122AA9A64AF0CC39E2BECB0@VI1PR05MB4989.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(5660300002)(6512007)(8676002)(107886003)(478600001)(81156014)(66476007)(86362001)(66556008)(4326008)(6486002)(66946007)(6506007)(16526019)(6666004)(54906003)(52116002)(1076003)(8936002)(81166006)(186003)(26005)(2906002)(316002)(956004)(2616005)(36756003)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLx5KLRUT2gsmhlqrJywohqTRpQ9XVloa6uVES+x+g4H/hLV1uF5X7xmPsvSmbQigLDbjSfsJxqD/+Us6fkP2yQ1tiz8kuJ8C5qnTsMhwwRNRegSAowADyfk3DYgLG1EQPbBoEZauoHvnMY+kc8yJFZou1lOIGMLtr2iDn72QrNtFaCm+Zv/raThqtoI2fAV/l9nGpy7l0T/voT35N+XFACIj2he3ElVsdhsS7bSup3E7uTr/humEnSkgPqAyVuXSV2GSSrEcpWfLJhQwzgBB7knD+Hf9OZ15bKolj6yf72VL2X+WiEwTPhvrLcC7FnRZ1zgP/JLj8rLUTXXNIFVzh8nfsoAYiNbPmqvo+iOLumCggUoYWBoAXxO8/kvm+3i3Huk2RvsYKDlxS7IgJw85g5P3Cu1TFt9/evCMYlA4r9EIFWjoT1P4c4QmPFtim8sVLHZsoXeQc6B+1Aopzbtvxx9jgOc3DJ9V/dB3TKoa+i/8z2RrLFFFX1Gt7p4dpCw
X-MS-Exchange-AntiSpam-MessageData: pyCA6d7fOASTZdMfKEcCkxft1GA9LKOqZ2RzIN/nek1MofHDyYaMU8hKlvMhjoh1/HQyZx2Ye89sduLNKGbqdSPqT5OiXZa1hDYulgRfZelEdZxg9/HWs++DucdbAK4xIiKTmAmHwdB5/dwzMf0qpw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cc80e7-56e7-492b-7d35-08d7d47a647e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 07:17:23.5103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/YL7xEUSvUqnNLKSSNe5R1L2H+aozYrJ6eoXviV9qAt55c3GJy3AWde2QiyE8VP3fug1sFnm0IRFi/RpspplA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eswitch_offloads_chains.{c,h} were just introduced this kernel release
cycle, eswitch is in high development demand right now and many
features are planned to be added to it. eswitch deserves its own
directory and here we move these new files to there, in preparation for
upcoming eswitch features and new files.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile                | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c              | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                 | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/Makefile            | 2 ++
 .../mlx5/core/{eswitch_offloads_chains.c => esw/chains.c}       | 2 +-
 .../mlx5/core/{eswitch_offloads_chains.h => esw/chains.h}       | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c      | 2 +-
 8 files changed, 10 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/Makefile
 rename drivers/net/ethernet/mellanox/mlx5/core/{eswitch_offloads_chains.c => esw/chains.c} (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{eswitch_offloads_chains.h => esw/chains.h} (98%)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 7408ae380d23..6d32915000fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -43,7 +43,7 @@ mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 # Core extra
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
-				      ecpf.o rdma.o eswitch_offloads_chains.o
+				      ecpf.o rdma.o esw/chains.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) += lib/clock.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a22ad6b90847..f4b28eb9d943 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -13,11 +13,11 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <linux/workqueue.h>
 
+#include "esw/chains.h"
 #include "en/tc_ct.h"
 #include "en.h"
 #include "en_tc.h"
 #include "en_rep.h"
-#include "eswitch_offloads_chains.h"
 
 #define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen * 8)
 #define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index d7fa89276ea3..559453b4c6b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -41,7 +41,7 @@
 #include <net/ipv6_stubs.h>
 
 #include "eswitch.h"
-#include "eswitch_offloads_chains.h"
+#include "esw/chains.h"
 #include "en.h"
 #include "en_rep.h"
 #include "en_tc.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 901b5fa5568f..6474e0a01a54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -51,7 +51,7 @@
 #include "en_rep.h"
 #include "en_tc.h"
 #include "eswitch.h"
-#include "eswitch_offloads_chains.h"
+#include "esw/chains.h"
 #include "fs_core.h"
 #include "en/port.h"
 #include "en/tc_tun.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/esw/Makefile
new file mode 100644
index 000000000000..c78512eed8d7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
similarity index 99%
rename from drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
rename to drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
index 184cea62254f..029001040737 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
@@ -5,7 +5,7 @@
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/fs.h>
 
-#include "eswitch_offloads_chains.h"
+#include "esw/chains.h"
 #include "en/mapping.h"
 #include "mlx5_core.h"
 #include "fs_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
similarity index 98%
rename from drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
rename to drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
index f3b9ae6798f3..f8c4239846ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
@@ -4,6 +4,8 @@
 #ifndef __ML5_ESW_CHAINS_H__
 #define __ML5_ESW_CHAINS_H__
 
+#include "eswitch.h"
+
 bool
 mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw);
 bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 612bc7d1cdcd..f171eb2234b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -37,7 +37,7 @@
 #include <linux/mlx5/fs.h>
 #include "mlx5_core.h"
 #include "eswitch.h"
-#include "eswitch_offloads_chains.h"
+#include "esw/chains.h"
 #include "rdma.h"
 #include "en.h"
 #include "fs_core.h"
-- 
2.25.1

