Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D81479537
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbhLQT6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:58:00 -0500
Received: from mail-db8eur05on2124.outbound.protection.outlook.com ([40.107.20.124]:40672
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240760AbhLQT4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:56:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvBLlWaQzpeHGf3VuWb6wYuiOf+eXHNJw3XmejCSEVpA+mfgdnCURXRy74Xab6ixE21WPvYeuzrnYoUZHymbUhcFjoPtqmgfhsAHr8gDAGqqRZuMAB2IZpF1r5AeDoi2vj/K/TJQTBIW+jZquWoarRxpgVuskWp7IL1XyXHebu48WzaKyGtsDXDhEc+iSss4S4t1HQ2WIjrT35EGUnP2otlEt6fcrhpnW5UXt3snTk9taXcUirfqBzU9hq1ltbBpjhSfz94GOibjk04r9W0Gnq3L5onXtth+3f4SjWVvhMP8mXYnT8zcSPrAgMS7tW3+yGUbmZgQFemfQGSrv7KkJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94QR/xzhz51BKUqJeVrxBYK9WHfBWavpF9S3ev+ZzsM=;
 b=kFjizY6VaiswJD4sKqrRE2ucYXlxI5qqdgNRbbYhvy+WvMznjmN5q7/54depXNh9ob0UDzWp+1F3RL4owd41LP2lncJ/7QAYv3TH2KDCqZDXc35SnwCN5ypVZggolr0pcKpCawguMm4QAAdua7gIwIuWA44EjMINiCbplDLU06eZwNAWjRW6vka/tFpPKo5kLSc8iMlc7RlyzQum64ObYTJxwK0sZX5vOV9SWHA1wHugPZ0P0tYxVXNm4s6IweMTymkz20kWubk82hJtIBmIY76zA7LBkIO0fgLPAwj37AB/rxKN9/UC0HxSM0HzRhc1yATym85tlbl+UdlELVXm+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94QR/xzhz51BKUqJeVrxBYK9WHfBWavpF9S3ev+ZzsM=;
 b=cYcoObDvVIXY0/xDLeaMo9E2LXqKtYpZdTWvfpnrbAe1oW1JVX9IMxojhfcktI0vXv7C/Ue9FJE6V6qlfOw5V3HvwUDb79H5O8C95MG+s0obREQ91SJI+bBsWi53aJrGokpPl97NSzSBgRUtiSo0HAHuK0ZdXJWg9gFiW3eakHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:55:59 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:55:59 +0000
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
Subject: [PATCH net-next 6/6] net: marvell: prestera: Implement initial inetaddr notifiers
Date:   Fri, 17 Dec 2021 21:54:38 +0200
Message-Id: <20211217195440.29838-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eccbed4b-6133-40ec-6dad-08d9c1973f5c
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1058E3B9057EA96DBB0EB4EE93789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mfwY6XcWWYB6OVdT1PssETklUG96EnLG8N133clBlhz0YQ/XeNs/5B3Vp92IwkgcA51D3ywk8yMgEa7d/VNkd2EGNpgS+n9N9VQLWVmTgqzf6xD6Rw4mvkbvx8iQvalyutSeop8a//f4iDkEh7dGL15K9v0omfaBGTd1hFmZSb+hF3djTi5WZUPzWPsaD/j6XhMHEUIXrv8cIcau8vdw7eiqvMASs7uQ9Es0WmbdlCt/tsmdWlWPGBzu+NKq0xYAS2Km5L2AgcJhUkMjLsDXnEEnAZl2gkrSH97PZJT20JDxAmxGFgc2dq0NWxgC3wwwOVwzvQcH0AvMA3Qe/BTlNGnXoyHxKASnNWVdcGy8LDpgOLwM3yjilQRbtlMARLmTmxB+4SoFbV6HXlLvIdLMyKPAAVvSLVnxyWBrfmCEYd08Uheztw+qWDMjJNbqjGpQJLGWS5YypdAAcf3UGN8b75Mf5xCW5cDk+Ib7Dyhx7QXIVJQwDuFIssPOlZlO8ON7kK2b0thQcuw5msVjk81Hw7KM1sDhWMKRrYhsdMQp0lL3nx2c/UhKWBPF7FZSItsZranlNS0XeAmEObkn0N26P5uAZJe9RbKkCkjzTNpukUKNOtIvVViZA6VhfZupA58XYf+JgMdAypzwI5fGqzDSCjdxzz0TLBs6G21XPjtcH05UaNibBbiECex3PBy0BvKctj4Y+YT+s/punmbTG3dK3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39840400004)(136003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(6666004)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JyH+yzGEdvu1PI5dvfJOCWQxm9tIU2EDj+JPEXCoYE8VNVphFgrt+ELFSkw2?=
 =?us-ascii?Q?2Tq+10QA1qfrE3XByJhfxC8//0ILSfpJTlMTaYCpGAt49gGaeqXhdQGkMvNu?=
 =?us-ascii?Q?B9HK3QWSnTaxrHb+oT6Mi3coE9dMHAn2M/yA+h2iIZYm6Ei6SecpyPaqRGz+?=
 =?us-ascii?Q?zOB3M+7k0VK2j5JNOPdGxg26bwljBeeilNZDJt5cBSrl11zaE3Hf+5WhgsYv?=
 =?us-ascii?Q?lMZT517jDUrdTBKsLnUdGYhBSz5ujYUPuBpRsAwfXi/2YPkHQy7W0jFZlPpY?=
 =?us-ascii?Q?pDi31Q7ez6207gA18gCFqwIchXLbl13r6Pf8RawHmrQxstWRJRmO9J6eMzXO?=
 =?us-ascii?Q?UjMV//GSafHkxJ+9m08EwHTpDpgK5uELs//l6NLUKi5JsfdK/zcj1wAwm1an?=
 =?us-ascii?Q?GC+LgN8gP0qLf0NpksEnyAR9Gb1NNmhOGW8AxCLnPMYGDq8wz3LnMxoPBiT/?=
 =?us-ascii?Q?KL9Rk7oK+hDP5eZFJoOIwoq5tG/S4GIVWMfWaQRXsua1U1NkKvph4qH0yEi4?=
 =?us-ascii?Q?j8DpT1C9FdECpS/bIh/VwaFhhA0pvgvk6uKRp8vuM1mwmY27zkyUuU7+YB9U?=
 =?us-ascii?Q?3JlbjcyNZCBQjjdNYM31XDapHTY6dmFDZK1mEkEv3r63Vt1UEWLAvE41UnQd?=
 =?us-ascii?Q?Wxk/T+VB7z2WVJE9bI6EHRH5eAg7ctXvwx1ZeUpzVEyZH9aHPnU3Z4l1wETh?=
 =?us-ascii?Q?50D3Qu8Q0YV08zC/HgqMjceY004qDsOWr1RCTO00gSqv2eJ7sORvYXqfLhJZ?=
 =?us-ascii?Q?1p/6R+warp4UELCrfcs5HRBb//Xra6BowYBpTNzLFIdnKHxc5Uca2nHjBQyq?=
 =?us-ascii?Q?S7Q+PNp/9swTQm8X1bL3DiEpnM08A9M9fEVKY+zZltAOQl277VSrvMKIzHXs?=
 =?us-ascii?Q?WIftKrxmfMGYJLT7F4JtRuJcJNq8qlLGxBX/FymE/f1ff+0P7JSEZd6Ao7q1?=
 =?us-ascii?Q?rCYGI7n0wUcOVxYsi4Vy9WGB4pbSlRPNiQg2PPaZzWbizOwJSZf7ThwxomHh?=
 =?us-ascii?Q?l4qmgWQ0ncEmO5jjhKaCCSr0VD4mHYWWKDZdxNdUxuGyAHGbVKi8saHSyuQS?=
 =?us-ascii?Q?ragYqxAsFdB444GNNlMXOmlfcHAYxan/DQ6k1xXqD5ejbDvmGs06q4+Lq6m7?=
 =?us-ascii?Q?ORxgdwFvvYZiy9lSWI/meJMNrfor0NwnqNDtfHuikQ5BNccqN1NowoNKZKvc?=
 =?us-ascii?Q?OubzYOmhQMCDnqcPdlQP7eQBOiB1O/df8fQXQ40vQwJ7oPWTrsJ3WwMBjZeJ?=
 =?us-ascii?Q?NlT41EUez3Z7RZxKTIvxhY/xwkfmqMolyXEU0htomnEy85XhNLDxWPOfLOP7?=
 =?us-ascii?Q?/4ugMKP65ixuihuTCOOhGlL//N9T7ijkt0B8pPG2MsFx76fdzWySpbN1zqp/?=
 =?us-ascii?Q?VSPusJlllboxDwAH/gX1Esu5Ia1HUL2e9icBVL2M5sYTQDMsbXZVUJH81xCv?=
 =?us-ascii?Q?/3h84PyVws6m1frueviejLtFFzQrgec4z21OAevMcupnIadviZVoRaJIjuq7?=
 =?us-ascii?Q?B++r2YG71kRJ1L7TLF6ZpOZlcl5Ffk9xHoe/xi43pV6W6uMRuRVPxlsD7y2O?=
 =?us-ascii?Q?PLf0eJ1YEXYsh77dBg8MwD2tBkiciYV6biPOxPyl413dQ7zhivJ8TVYiKN29?=
 =?us-ascii?Q?cWs5dauQ4hWZ1rWw3RSfCsKlb94Z4gNk5wPvNw+MEb9M3NSrhRizQRruLaXI?=
 =?us-ascii?Q?lulHuw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: eccbed4b-6133-40ec-6dad-08d9c1973f5c
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:55:59.7661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5vWoCGNMIbkZ4MUBVKDgCyUz1wIj52nlhmjZuTI6ZLVu4ok29lYJQcB926rsRvrRZr+SnULfs5O89pWtbYEIW4uTGOYwROdSRYBWwA8ssM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add inetaddr notifiers to support add/del IPv4 address on switchdev
port. We create TRAP on first address, added on port and delete TRAP,
when last address removed.
Currently, driver supports only regular port to became routed.
Other port type support will be added later

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 33aba94efafd..ca9fcec3ef69 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -4,16 +4,31 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/inetdevice.h>
+#include <net/switchdev.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+/* This util to be used, to convert kernel rules for default vr in hw_vr */
+static u32 prestera_fix_tb_id(u32 tb_id)
+{
+	if (tb_id == RT_TABLE_UNSPEC ||
+	    tb_id == RT_TABLE_LOCAL ||
+	    tb_id == RT_TABLE_DEFAULT)
+		return tb_id = RT_TABLE_MAIN;
+
+	return tb_id;
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(port_dev);
 	int err;
+	struct prestera_rif_entry *re;
+	struct prestera_rif_entry_key re_key = {};
+	u32 kern_tb_id;
 
 	err = prestera_is_valid_mac_addr(port, port_dev->dev_addr);
 	if (err) {
@@ -21,9 +36,34 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 		return err;
 	}
 
+	kern_tb_id = l3mdev_fib_table(port_dev);
+	re_key.iface.type = PRESTERA_IF_PORT_E;
+	re_key.iface.dev_port.hw_dev_num  = port->dev_id;
+	re_key.iface.dev_port.port_num  = port->hw_id;
+	re = prestera_rif_entry_find(port->sw, &re_key);
+
 	switch (event) {
 	case NETDEV_UP:
+		if (re) {
+			NL_SET_ERR_MSG_MOD(extack, "rif_entry already exist");
+			return -EEXIST;
+		}
+		re = prestera_rif_entry_create(port->sw, &re_key,
+					       prestera_fix_tb_id(kern_tb_id),
+					       port_dev->dev_addr);
+		if (!re) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't create rif_entry");
+			return -EINVAL;
+		}
+		dev_hold(port_dev);
+		break;
 	case NETDEV_DOWN:
+		if (!re) {
+			NL_SET_ERR_MSG_MOD(extack, "rif_entry not exist");
+			return -EEXIST;
+		}
+		prestera_rif_entry_destroy(port->sw, re);
+		dev_put(port_dev);
 		break;
 	}
 
-- 
2.17.1

