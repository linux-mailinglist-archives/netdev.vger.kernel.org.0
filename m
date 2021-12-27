Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666864804F9
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhL0Vx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:53:59 -0500
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:62808
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233669AbhL0Vxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:53:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVxKp0mAar6OKyH9z0bjdvhTJDzMnAeVOWwAEsnTDZ2il5BLbnDcWX5PKwZqCYp9kl7wN1WRxnnwZKiFQ1qmmJwtZ1AIfB0pC/wnAivV3e0LdLKLUwMsHHVdZUK5X3jLls5X3aQ8LNQYQhWIuXsrtF8E2GQ1Rm9TNVpVqjESH0WjmaxnRk9PRP5KQd/w2egEUvzTlh5f7OGw2/pRIOabESe/0V0MjOFf0y5YymxGDanyg7Jc/EJdJx0XpqhMy+XsqoPQ95TvR0Wm4da72nBHBQF2ZEYlsA1OoRvCLz/p4WTslQYODjSUmkYGOpu16kgfQ7bYRqsiXfCQPYgefQ+6AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZ1mcCDMWzGdssOsPDeFkspBpTPAu44q2rh1aKT7jxM=;
 b=Sgys6F2FW2OBJX9oivFLzcHLR/O4KIhzA56ui/oKg05XYn5G+7Rvvt4wjHHU24z4v0XQvKqICS9VnIOvwuM9SH3MFte0YSGn8JhgMIOgnebHXDWTvmBGNBezg7QyNfOldhEE+ai2Q5YHkcFzYEyU4UvsHM73mo+K36VJNrYe1HAtOAnP5cYhGbwR8WCXcm0JyovDsG0gRbFMnK53MsLr47z2Tit+bA7Z3rhcLaSypz9GN6k5fGuryVf1DXgZ8U8zwpY00jQnGVGVWPFfQxxj6QnEgQJ8YouHiktzUtLRGQ/3SAoQ/pQmfjQQcYVja3G91dnE2B7+NPajeriTcZHwng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZ1mcCDMWzGdssOsPDeFkspBpTPAu44q2rh1aKT7jxM=;
 b=vSlraRJQIjmSOn4v2o61RcbDul/w0Rrzv4BFR9X42z7G0UU1woUX9IH0Escfz/uTZWdSZDkMBe+4suiTVw2JkDYbJ84vDEMZykZDt8OKa1Zc1sA0GzcV/OZUJx4mKzpA8v4s0xQ0ofzxfuxHLPl2DrdXN4BI4c6H4Thbkdfi3bY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:53:53 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:53:53 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] net: marvell: prestera: Add prestera router infra
Date:   Mon, 27 Dec 2021 23:52:28 +0200
Message-Id: <20211227215233.31220-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ec3fcc-35db-4656-68e5-08d9c9835fcf
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0145008067CB0B50DA517D8C93429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+XmKIfKKhaR3KSorRneMMBUPaIb984xMJ+jWV7FVKjl4XUBMi+iasqK9bnIIW7tX9X5ZR/x/OC5irzO+j1fUTa8hTGBYtZiojyHEDFR4ZHYJfOGOpPLSW7ltoFxsu2NiTiOMHYeUFrlKLHzh2RCENwvZFsmvhzI730SoqZHm/YmgT0vv1rqX+JWwlUf04Pd0jxOk6/lSVa3SJJSpbaxqMuJ6w52wpQl3NsZvFEKkEDcv2zZJ4hbdWqzJXcCwrY/JwKsiQYDQfo4wP0Yl0a54ip+NgL/CkK3+lG6+Q24rBR1JK+Yuuw3bqqKQfDXf26CCiPBF4Nrw7OvR1cZctb9n6tRVtDsehRmNGD1FKbh/YSUzHbJZb56pm6yjKWcOZVB8DjMndyhKO7E2qedUqR9SBwjo+tha15oi72rlywbhtNkwgIjpJbciS9TyLNZLl3C5Ln4dW/5XNLn4BK2nlJ0mkznw1oom9GWmy0fK5Nmo/EBjSZb/IE78lSb1vkPL35PPWDVM1MI7xrh0XbGmLPzMn6NfRgJiydhL8w8BNsn0oPqHkkrOIok2XluSYgAMPT2BxnM4ABpN7kP8w2cz3URKscT6kODJBRWSCsXJa0699EwcMFhBZ9A5u41a7CGQy3Y1mYIj4cAOC1JXfx/TmZj6GF5UMM2qm9GDNbG4npVynaGdCkAhjprgASISHudxHHdvxb4lJJWVmjEnVb26xs5Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VCi6fM1xdBzykh5kB0X0cy47VUXjQbbFoh/3VUynP9vo44SMD+I+X6q4QkR/?=
 =?us-ascii?Q?QWV9mQkDHfgXGJVQqDVCU1Bta5T6IU/v02RnPun4Qx7CTcik971nQ3FPhYYY?=
 =?us-ascii?Q?yIZpoot+8xYRxahkePLhxvq8t60ffKvGMVo3s264X1jBQH1o0RJ6lWMkgea9?=
 =?us-ascii?Q?wPBvvI1bzJvDWgCiVprfqZ1ZtgUi/GdKAJeXgMByaGAWo5fOYcwWZihFEOxi?=
 =?us-ascii?Q?fSt6n8ml+QlgExfGUk62XciWzc3BAvi0FY+AswKMAuB6qDwQC4OTkFZpFObz?=
 =?us-ascii?Q?4w405vHCsQO747peiZ4w7qXxoirrt0Dljkbvcn2ltozEnjEjSo8MEKe3TV9C?=
 =?us-ascii?Q?JGG0837WbaKgUHHf1HVOf33Se/wHbbWa1estwTTYtB4madPRIlMkZsvJUDB8?=
 =?us-ascii?Q?laocDqeOKwWjv9oO3CJDi3aHJWYCUqyQY5apQv/sDGG7SxITVQ4r1qW9DJaG?=
 =?us-ascii?Q?1qIqcD+KvahEW7l4/NbzvgjFjzp4baulyojPmjDIlaTn6MycgjnqAXZxH5JK?=
 =?us-ascii?Q?Hx6M/OQFs3vFWJbHw32+n5UsZJW0ccdKImVblI18/RcUY0y9BghoAhEqRF04?=
 =?us-ascii?Q?su5/lZ5XLhvQ6C/+fhkKHOxxcpREy05m8dFecm0LCLEG9XoQJuNA3cDDFhSC?=
 =?us-ascii?Q?EHRNCo3vZcw6uBExBm3LC5saYlSQuZbVqMwKf/TzPYaf1FSV9V6TxknpsbbL?=
 =?us-ascii?Q?J6aEKNJurwbJ7FkeTdTlDdONrhhUOkmL7l3irBATEHz0kQxpIuau7qNWfwtP?=
 =?us-ascii?Q?PQDMghep+0XtIgY7rdbwbpwLWthSv+D/Q5+I+zHORKgB0oKQXtgG/7WcHipB?=
 =?us-ascii?Q?s+VnWHf/SejqhG92F0p+7q/18FgMt9gHoaGpUDmeH72FqsDs3ZxcbiBpcJTm?=
 =?us-ascii?Q?E3RAmHl6ngqbZ8fSx5U1GCy8fx74ht6xdVnRsbb+KXRjdv2iAG69IDBF5w/+?=
 =?us-ascii?Q?muuxFfJxiG1296wc//d8MgrDxK/wEIg6jszcyBKBn3rpkpF5rWqzs0bTzmeV?=
 =?us-ascii?Q?+N5rRvjIffDgAHiKSav2DVj47uhmNJob7vdxoJX2RSTsWTjXiaHBgUnjwu9r?=
 =?us-ascii?Q?aH5tH1zRzK33R0NbRsOIgklL1oZTWBuSGVsaZAvS1AdzlbDF1afAFI8UcI1w?=
 =?us-ascii?Q?bKzN7QSvJTTEUqnHvBOTf5jP+YIzBaPakL2zyYQhG+JTdh4tPxdeDBR342lD?=
 =?us-ascii?Q?pGoYD9j2ZdmUaHYTdjH0Q7p5n22GYVzEPVerWfzyii1X4zDZl/uxMZqGQYUc?=
 =?us-ascii?Q?kDLNtPdxXKMb4Hnb4vILwJ7snffZx2SsaR+pHsUcJ+UqwdPwxSoSEAbUO8TO?=
 =?us-ascii?Q?PhVhLliJSc9S2jmFjeR2WRvuD8+lMrWcZetSDIb/OV2DAA7N5aK7rFJ4E9dQ?=
 =?us-ascii?Q?lby/93CMMy2wQEqbkg6JQCloizpAOH6USgHvs/1Q/CQY2vNlTz/XIFcSWziA?=
 =?us-ascii?Q?fMRM3BPru8VQmxsgIkm70DqlPkOYiRe82S52pmVVpmYMrrD2u4Dabs6kYjOw?=
 =?us-ascii?Q?ESrqKGfKbyPBtWTVqveVBehup0bQCBSsyT1NydJpmC+PO0GHvaY3LGRqsHQl?=
 =?us-ascii?Q?H2WwghO6n8IGsp51hXmAat4KlH+k+aB+JOeiKxnHK35Lxxjcot4AgIA2xsJZ?=
 =?us-ascii?Q?bt49USpSiN6pjvRmZpgCnOmYa+EjNnE12Idv75AjrUSYKezZ1LaB3DIzCAnM?=
 =?us-ascii?Q?ydZ0Uw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ec3fcc-35db-4656-68e5-08d9c9835fcf
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:53:53.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: useLh25c8Fl+7w3W7snGCZD+tIfo7PF427NFc49ulnvumTiMt6QHP6Hg6ax6urz3HhLoqNRvmX8C0doXemys0yrc+1jqYcs8RP8GE9rbgpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
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
v1-->v2
* No changes
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

