Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3784870DA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345657AbiAGDCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:02:35 -0500
Received: from mail-am6eur05on2110.outbound.protection.outlook.com ([40.107.22.110]:37720
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345635AbiAGDCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVcp5b77xkPaar9YDK8E9caVv2SiQ9rjwHRqa4c0Nq9pbFV2Pyn9UX2f9qaBkEr3Yd+GTrpZkhdfFAldjCPPCO0K7HHU80HO9zueCOusUeuJ1w8YuwYIYiqzVGfDTYzznPA/aKVXTDEFetHw+Uw2BLjvIyavyc4nleokVzidKdhzqQvJ/8A4f7xqv4gYoqCEmognICRlBsfQ3lGWrKmAXzSxDXOvwM6PC0n0oidUZAZuxyA+INdqrxvob4V086ZONYYJJDFh1QJJ1f2rj0MqnR0+wIRUupa+DxQavcr6gvArF0Wi99dWgyjFlsGug968xLGcTYHDh2gbDD+RkbJWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CjvkobL7LHnYf4Dehc8fMRe5/1MBb5kiOE82WlLesI=;
 b=G7Z5PH9H0ClYHyRTBrYPFmTp0eKw6SYdYJVeeJvoKY2PxFkHPlOzZ5OvTvoL+w35uP5W98A06CrEHs19tz7CchKBXdhLMIGh62Ih6hlJzS+188xFTSDDo9Skim6EUPOa5lEhQKk5o0ieUchzip3HipeeRYBpRzO6ycSGwveD23tyQ6DBDDsEAXPefEj9IovH2jLjCtFwEvioq2lXDk9OAiz4E/wZ5/07JLxig+JeHzCPcOqNvloobYsaQvGgkQbn5JHEPxPSWkdYbf9UBUGWwyKekTdPdp57nif+h8OvW1ZHv+5cG+XxcWc9mznxVqSthMF9GUs6Bb05/mOLLwE0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CjvkobL7LHnYf4Dehc8fMRe5/1MBb5kiOE82WlLesI=;
 b=NXX4sRQHbyPN1o51fw2xKOMZQN0RJFjNy/f4pKieRFPJuYDakNzB3wect3UDPdfL1E5+Qi6SHnfkku5R+fBZbYRZDJwRB6LlWx/2WectnsLLih4xZMv3Cnbyhv98GDbTGGPE5N6hDZW+yoaaKk8/URZGCFKQa15TQNvjaOW1TIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1316.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:31 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:31 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/6] net: marvell: prestera: Add prestera router infra
Date:   Fri,  7 Jan 2022 05:01:33 +0200
Message-Id: <20220107030139.8486-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d0fdfc0-4268-49aa-424b-08d9d18a2587
X-MS-TrafficTypeDiagnostic: AM9P190MB1316:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1316814A216C95DE7A74CF30934D9@AM9P190MB1316.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySvMM3aD9esqocp+WK4wEsNt58qSu3yyEOHQwi6h4TUuR0ewv251wDuxgKEYxVRg6cXuvT34J2BukCRuHM5wqmKlg1/oRLVbp7CcwEJdyafUWdrID3+ulhLhw7ULTTdis1IgCF/Cnt0ZwfP9buGklnrPLfjMeE3jZOg0jr+JN/V4ysTBa3uJLSE6HCshCWN+Els/mBtJ7QLJ2F23TTeblGMtn6TWKV8+ZUN4Td8MDiEPr7G7I43Mi6maOLp+SpuVlhJrzyAsuhpIDBAWVWxlb1GXaeWslg+Iu1Aphj6DceBQ/86U7vvpfbqeGVF2W7oispAG6AUNPkTQBsMyclPRyZX/WpttDsnAhm5bDrBhM7wtukTFjlqZQ1pVkq2z6L4oL7RjqytjV9bjoK5tWf443PNhnq0jNYR32Y+KjJL1EU4YDB48yjWuMB054lW5iLkHXWubAglySwpG+rtso9zxaz67Jl2xdNfWf9EVI2F5N2FZJrlmVqf9Hd3VgA2qF4UF/BJkqC725vtWJSyY3BDyPufvl1+Ww0iOifxwN9GQJZi20fiekAWkL06LIsjunwgJ5AVfw3I3HkF8+0neeSxQk8C5RIqdrX/O+LjZufWcehQplyEXmPIurPhUqYzxF+C9Eel0qb+lv4lSCjTpPK+I/UaOl0q+6HUbTro8u7EPTjN7Kb6v8xnf4AComXaXmXf4VDsAqpk4Ri5Rfzc/zhCPQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39830400003)(38350700002)(38100700002)(52116002)(508600001)(316002)(66946007)(66476007)(66556008)(2616005)(6512007)(186003)(6506007)(26005)(4326008)(44832011)(2906002)(5660300002)(6486002)(8676002)(36756003)(8936002)(54906003)(86362001)(66574015)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AORyynYFn7LaDJ/SN889aN3q2mPBUzAKqENKd9QomMvcprU8NFU7/L51KWcl?=
 =?us-ascii?Q?5CDchrconAccF4l1MYWO3JDs2QB+YSkAcoO6HqadxM/rEIvZf6seIqcQfmGv?=
 =?us-ascii?Q?GVkEBjqu2VCw67/fj6HPMiqo0fbSucSKL9m+2+mT2Xv5/l2Xwb5TOVPcUYNB?=
 =?us-ascii?Q?o6dRaJOZPVKswiv9RNpZRrDnc37UhDXX2gttIAY/EDjLYiJUINzLf7zYqTP2?=
 =?us-ascii?Q?he9jmFTevSHZ5bfWcBG1AHSuAoKrGRvBInn1dUgpqYGMZeC0qHRBLkaPMH1l?=
 =?us-ascii?Q?nUHHbQR6zjuWGWA1QHlihSor2SV8r0ZxtHa+UQCGZjKkTwhAYCKzoa8XRpzp?=
 =?us-ascii?Q?75+n5FUBgWO6H7ibUk+Qk7A0HLsHbdHa13i+hgpnSrcnsNQYCKz/HQ/9eUkV?=
 =?us-ascii?Q?cAkucT2Wo9vNbufCjx8jGYpBG/9lr+3J6Ne2km4TSZNAuzdajMAb0hlAmqzz?=
 =?us-ascii?Q?uG1ti6DHihVODc+B0hR/EUIlL8CdMZu6pR+q+XJr1nM4ESyKC3XkAPAiOnBU?=
 =?us-ascii?Q?yeALL3HiCRJGuLOQwhJ80nqEkY13hP/OwwGM5gxoGgxMlfH4xG4B0LwlvHH0?=
 =?us-ascii?Q?etYF3WniQNs+fpRjmlRhe5ZhGYFzaq/ZfH2uoxddFqOLd1OzezzboQooijuN?=
 =?us-ascii?Q?Os/EO7xrg0+S+2eDSSA44yD+1Sh/ixNhYeXb7xECrjxNyBbALVKvYiJdiRC3?=
 =?us-ascii?Q?BGwiamwgaP9lIf+BYoKJ/4syWcFR9NdjQy4L48GfThtSpAaFwVX1UBiQdMMk?=
 =?us-ascii?Q?AeEZis9q7DZG8FWSdQwQcvm+GnQBkBwHxV9MYNj45JzSzzQjRb96DUrcKDzW?=
 =?us-ascii?Q?2WfPuwNYXI33iwzl07fZ2I+rnycd5L9R7Zn2tJAax0a4s4DuN8EKdOnjRqJc?=
 =?us-ascii?Q?hqbwVxvu0tuj41PNH1gKgjS8R0xRY2ubntgVFrfKZftpRE08kEgUht3eRMBv?=
 =?us-ascii?Q?AD3WUmj0llP2L1ZQQv6x3Ohaj2urApj3VS+OLG2MPYfoEUDucctGENR8xS7x?=
 =?us-ascii?Q?7ePzd3gGQREYKzp9V7Cf6gX5ZR+66M3TgNxMXjCfXOdEFfGTzgFtVbnDQu46?=
 =?us-ascii?Q?4mmfj2PsenrYcL60gX/5dEeKqLgBV1sivJSfJccfo4HOrO1C3gLsuU8oCcnt?=
 =?us-ascii?Q?MQxylWZJ8OAkZ1nGm+cpvTQZwLGF4SYIaybVZSRL3Y2ayMoS4Nr5GahOV7C1?=
 =?us-ascii?Q?6ZWMDo2mwGUUYPpsy5eT3H/iyBgoRbd+5IadZc3kRB3N5qImqPZfA/CPSbHA?=
 =?us-ascii?Q?rYSlgkU4CaQSe8srUiTlBQzXl8MVuLWV+v8+vKNv8izAdf06uE9ga7TaBzsg?=
 =?us-ascii?Q?Cex9P8it0LurP8l34s81IntFCtQHYSi3ZKWfYYTzmh+4Bsdx4FeM5P+Giufd?=
 =?us-ascii?Q?IwyCUenACbR5sEYhBRePi6TVlShSXG2rZR2mZ3A16LoX6OZjBwWE4by+OfEF?=
 =?us-ascii?Q?R71f10LKw2oDAV8lmUgr9N6pjhvWmuD+2/eEg4B1Ey4gsj5BpYJey65p8WyH?=
 =?us-ascii?Q?O1/sjtVXDo3htqst/0fz6sOZBqTF7Q4ojwpCRqo0A/c4jWG2pOji2n5QKRMU?=
 =?us-ascii?Q?Ayv0CVgLhSP+7AZE3ZXeVO5Qr7+xVDjt7+vUOLxMdQstlfni81BTpHCFLHbi?=
 =?us-ascii?Q?pP0QpxmaVGb3TRw5JgPZ2t2bq961A2gyUCbp55qVZmQG6MppCcG7I81AQCUr?=
 =?us-ascii?Q?d6NZtg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0fdfc0-4268-49aa-424b-08d9d18a2587
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:31.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrfJ7nBlLGDD9XzEhYEcreoiWs7tRWxeY0AsUGxgCavSRAGj9KFrhLjE8UqkvhIt7/wbEziheHh4uGFXGkNeO8DqzBzsQAmPlrtAcEOk0s0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add prestera_router.c, which contains code to subscribe/unsubscribe on
kernel notifiers for router. This handle kernel notifications,
parse structures to make key to manipulate prestera_router_hw's objects.

Also prestera_router is container for router's objects database.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Change-Id: I89e11722c1a1d41f07f98e57b6413cec165a70bf
---
 .../net/ethernet/marvell/prestera/Makefile    |  3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |  8 ++++++
 .../ethernet/marvell/prestera/prestera_main.c |  7 +++++
 .../marvell/prestera/prestera_router.c        | 28 +++++++++++++++++++
 4 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router.c

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 48dbcb2baf8f..ec69fc564a9f 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
 			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
-			   prestera_flower.o prestera_span.o prestera_counter.o
+			   prestera_flower.o prestera_span.o prestera_counter.o \
+			   prestera_router.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 636caf492531..412b45ec2b30 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -270,12 +270,17 @@ struct prestera_switch {
 	u32 mtu_min;
 	u32 mtu_max;
 	u8 id;
+	struct prestera_router *router;
 	struct prestera_lag *lags;
 	struct prestera_counter *counter;
 	u8 lag_member_max;
 	u8 lag_max;
 };
 
+struct prestera_router {
+	struct prestera_switch *sw;
+};
+
 struct prestera_rxtx_params {
 	bool use_sdma;
 	u32 map_addr;
@@ -303,6 +308,9 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 
 int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes);
 
+int prestera_router_init(struct prestera_switch *sw);
+void prestera_router_fini(struct prestera_switch *sw);
+
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
 int prestera_port_cfg_mac_read(struct prestera_port *port,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a0dbad5cb88d..7acf920bfb62 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -893,6 +893,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		return err;
 
+	err = prestera_router_init(sw);
+	if (err)
+		goto err_router_init;
+
 	err = prestera_switchdev_init(sw);
 	if (err)
 		goto err_swdev_register;
@@ -949,6 +953,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 err_rxtx_register:
 	prestera_switchdev_fini(sw);
 err_swdev_register:
+	prestera_router_fini(sw);
+err_router_init:
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
 
@@ -967,6 +973,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_switchdev_fini(sw);
+	prestera_router_fini(sw);
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
new file mode 100644
index 000000000000..f3980d10eb29
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#include "prestera.h"
+
+int prestera_router_init(struct prestera_switch *sw)
+{
+	struct prestera_router *router;
+
+	router = kzalloc(sizeof(*sw->router), GFP_KERNEL);
+	if (!router)
+		return -ENOMEM;
+
+	sw->router = router;
+	router->sw = sw;
+
+	return 0;
+}
+
+void prestera_router_fini(struct prestera_switch *sw)
+{
+	kfree(sw->router);
+	sw->router = NULL;
+}
+
-- 
2.17.1

