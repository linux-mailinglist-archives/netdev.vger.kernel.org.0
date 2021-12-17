Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D72D479522
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhLQTzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:55:50 -0500
Received: from mail-am6eur05on2094.outbound.protection.outlook.com ([40.107.22.94]:58721
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240644AbhLQTzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:55:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2svMZmnrvhdQu9Cqfjn9Br8PX8+iMjRcqZJo3bSCjaX2LMWgIrT5Xhrt1KOGESP4Rbk0IEQKCh4l8fkovMyDZmKAcAEw7ZpIXtpSLDtfA0I4CdWv92DmHLmW2f/zEb7HwJJkuacCOK/IT6diGNeHzduFhfOA/Z5kfmwMvPSjmG2ApHn/jpYjGZeGODYMAj6vl4O7PyvPKR+Xlprnorvbwi96vTa0hSGC+DJ0LmmH7biv4wCEqyQCo106BNKMSP+Enbv2uiX+7mzysxS+7ZcROY9LXMQn3UcMHCj04Sq3HV43pbnZG8VHGk/u3GjR1ULeLomN0zRVs4McKqSdh/QOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZKAAh1B8mM4kuQeA42kaL+daCmqbHwe3GpsjyCArUo=;
 b=T2J1+lUnNNX8E4xVbF9mM/G3I1B6X1p3IGjCnLJ2zt/l5n/rMx6i+fhfvDd/UVjVrgIe1n4zWH815ENl6g/hVCceagnRchnhPLavOviOHAc1REsEdG7kOlUKVFty4xr8HadMreMGG8PDDE0kXTLXKxwpOWRxkbu3/blzZhGLm2+yEZZiLVTOAbrT/odGknYvVIvE0+xqAsizZu/ES22TW5Dc8EkV9h9wEtMNx85uzqCacLGwLSyMSiQvPTcJdGXZAxPIClP2m97wXB13yiGO181KXOCCOCE0mIhc8O9i4a8xZqiGb1v3bX9pm+UVda726BXbxSgi+j1QanzlYkEaxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZKAAh1B8mM4kuQeA42kaL+daCmqbHwe3GpsjyCArUo=;
 b=d6orT4Qj+L8rIzn1fCCUwwY6Wfr6NnHIUH9KO0KDD5KrDoK66YSqNtdxou6Aj1dKvjlB+uh49eAFxTrzbJbC16wWlbjlzkG4eHqxHojcHln46yB+Bm0k7D3juQQDm+4oPaM10UYiwzqcfDj3FPrSeAAMTl1+tTLycQJ1UjRNmYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:55:47 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:55:47 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: marvell: prestera: Add prestera router infra
Date:   Fri, 17 Dec 2021 21:54:35 +0200
Message-Id: <20211217195440.29838-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0793a6a3-f39b-4185-c26e-08d9c1973803
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1058407E2D71B28DA76F34A393789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U1xbXYOlrxpFuNXwLXDumMjmWVoOg3gVaYhiBYu0bNfJR32yJD+VKMMWyC1THsNOtmihnTA0q3tJzj4aU8Gr4ohiraL21D6CkFCt294XBo15MfuGcGdorIjmLDZAf/uUGwuLaNk/x+QKmzVkl3IfQvnXAT/duE1ot8lx3Xf5HRSwZEbxc8J0r+6sSX52pM/rA/3dDFTLibyJf+LCkNAUwzIlO+bs+WfTk5z8pK6hGgWhz6mEZn1CUnouI0jdN0BLYhOfEFzZEKx8vw7xBhej9kOqMHP7PS50saoXRycEpfb0oB9W36LvbXsCbpaaRkS40cw8M0aZsz4UFlcqn0w9FXXJq67kRV6lTgfQ4G3BSGqcm01o3qSjkDEtytIxVxsnAB0mY/en2gZkYEuAHTFMgOV/vA8bJ0rHfn7gCbhhpQ6bN8YvVTfd+m/6vscBbHmsE0JQlRUzHuaswXonsayh6fWiaJ1jM1DVRNBwQXidH6DHpgpLRewsYsFK/dWddwe/+Wq2PIMXpch3ccAY3q22DuEcLI2JH2MXvzunziHNY92f57emkzv7x6l0fy5jpJC2qS3zTj2JlnD9ZvOegYTi0ir+1spdjX/zsS48VllQFNMmzBsB3nDGEno9Mkvyd50VDnCGRW+k6whADMG6UTkvgMw/jDF89HYO3W9bjzDJgY6pN2tVzowmgbMI0Kf8dKf32k3fQGMhxeiLCX0Q+q0r+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(6666004)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B4kdfjcEgj18rRUQNVvB/84iqYoKji0yHISQvjV39mwvBZrXMEwk452QYKeq?=
 =?us-ascii?Q?IK9VHZzu3VFWbY3lZFBpWD1x5Lk0nkQXePkdXY8rVcZZjnwiUL3yziWp/PUI?=
 =?us-ascii?Q?9j9qxvk0P7NGaKBcIGubC2RfTLbUR6dSupVpj1y4NNZh+kyaPtTNZga70aNL?=
 =?us-ascii?Q?tZCRmxVp5RHguo0CAQuAYsfkLuxRheu2RL9Trv7cAHcGIuR9bXrtRuo0Y0kP?=
 =?us-ascii?Q?uwyhrOgdSk697WrvJjMaICJ5mijM8mUneY4Z12cQTxHcDC+FgLPKxPcUbvbq?=
 =?us-ascii?Q?B7lsdR3fW2EXRhJZFEJOGWtdYRwRIG8SHOZ/RA3IEWGX7do8kUdl8fXmdh7X?=
 =?us-ascii?Q?YXi7TRrnXYyOwaS+lMvclHoeDrJ1XYG1wImm1F/nPVBnw0DqXZnyoKyDhyDk?=
 =?us-ascii?Q?/Up13ACB9xJPeb61znV/EOXQ2MiAV9pyj2Orm5o1EYvEwtQXXXB+vn/nnqZ1?=
 =?us-ascii?Q?iOeyx54At8VUPEzxtBsUjVKy3Ge1TstJmrKO9KTD8do5OMHs8KQBWK8d0C4O?=
 =?us-ascii?Q?q2297eXpZuzMcRWWTrwi4+s1tIjwEw+tYgK4RalqsnVhfDd7LpFL1cO8WFz2?=
 =?us-ascii?Q?VNccjzYzkRACJ5A82rFSKM5LgxqtV73PMFZzLsIHfDhA508W1VOyS53s+XZm?=
 =?us-ascii?Q?8kIAumIcg3lsjmuUujzJtOO/mfxOEyD3WvZP1rYWA9BWSD0gfeWZfP1KytNc?=
 =?us-ascii?Q?730V54rqxCRIOeXeTr+Fu+WqVHxxVXbyeglcQUBDo8RkycUH7yLv3iNnnf51?=
 =?us-ascii?Q?JG4f+axXGdDrG1nUGYU7GpOQ6Mvs5ENJsQhaEIqPpxtolTol9Fr9rJJon2LN?=
 =?us-ascii?Q?0ARr7SRd+ZTSvDoXiXTxcRq8YkK1QviPcyTlPIjj3hSiZCAWw1cGsvdN1Jky?=
 =?us-ascii?Q?fbunVt2TOI6f4SW+XBhjYbpmk/lnUJ8SAcOiOaMmWaAx0kf89Ub5NYUlYfti?=
 =?us-ascii?Q?q9zWprbWETPJmWulyZtKPw4AelWEZ9DtAUfLc7zwgJCfTziriYxQJuL96Bmh?=
 =?us-ascii?Q?Rh7fMcykrBAUnrmQ5jfdsjY99q7RTZb9cozRQB0MHJ6/ymQk2V6XNSx7GwID?=
 =?us-ascii?Q?wW0G/ZdwhHGCpfv1HturvQEULoG6yhp3DDWdw7ITnZ4gKDqVDzjqc5TWczrZ?=
 =?us-ascii?Q?MAPWMzZQSoWbM2xFygsoRqMpqa3rgKjz7tBpoGHB5gYRkwGLLdYg1vbxTliq?=
 =?us-ascii?Q?rmKB1fT3HJGerWvipudl0Z8v+5Ryld/EGz1LbZJYd4WJazpy+SDtur5msi/6?=
 =?us-ascii?Q?PPsQGq2RS8VrtJU6dbI8SuOsrz/ymTiAwK1PeTRVnTsXgN6/C96Si+1Jla9p?=
 =?us-ascii?Q?5bTnghfXB24GaMYXzlZZUNiRtw4vH+7kzaNRie+mMXusQmej3HVaGaMHNrY7?=
 =?us-ascii?Q?DqjovghdsLiuhiZI74sGxw7qRvvbFDlbfU+mMzpfqI1ysbHltnHF0tP+EXR2?=
 =?us-ascii?Q?I8Q1rEv0r7oIInL7hDqNUBsIAk1gHx4cJ9tfd83mP/G9mjZvQOtXwxbKdgP7?=
 =?us-ascii?Q?z6J5ImnVophOTvC0id+ayZBBqXKP7l8ZLfV/mBGGxYPTTTVYmKuxva7BBPdG?=
 =?us-ascii?Q?eVp/VuwC715Mjrwzr956UP6OiQdj1QQIhP5fXxc6aDFvO6RFJ6SKru3lDRII?=
 =?us-ascii?Q?S6WTxEE6Cb5MElilLg0qx1m1dcW7uN3oW5Q9obOVe8zE6fLUjeC4KwZB95HA?=
 =?us-ascii?Q?NmXDxQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0793a6a3-f39b-4185-c26e-08d9c1973803
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:55:47.4614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHUAJ+krj9jrWObQFEQwzENY6trq+ulx0ZQcE04bmXjUqprxLLjNtBsRn3iqRHafAM0P7SxQK+OnSgNdjrOuGaXC1KNHQr0BR06gXLJud7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
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
---
 .../net/ethernet/marvell/prestera/Makefile    |  3 +-
 .../net/ethernet/marvell/prestera/prestera.h  | 11 ++++++++
 .../ethernet/marvell/prestera/prestera_main.c |  6 ++++
 .../marvell/prestera/prestera_router.c        | 28 +++++++++++++++++++
 4 files changed, 47 insertions(+), 1 deletion(-)
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
index 636caf492531..7160da678457 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -270,12 +270,20 @@ struct prestera_switch {
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
+	struct list_head vr_list;
+	struct list_head rif_entry_list;
+	bool aborted;
+};
+
 struct prestera_rxtx_params {
 	bool use_sdma;
 	u32 map_addr;
@@ -303,6 +311,9 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 
 int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes);
 
+int prestera_router_init(struct prestera_switch *sw);
+void prestera_router_fini(struct prestera_switch *sw);
+
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
 int prestera_port_cfg_mac_read(struct prestera_port *port,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a0dbad5cb88d..242904fcd866 100644
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

