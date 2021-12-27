Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15424804FE
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhL0VyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:54:04 -0500
Received: from mail-eopbgr80137.outbound.protection.outlook.com ([40.107.8.137]:34369
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233715AbhL0VyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:54:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ja8m9ZQQlEWanU5tooD7ZsSv7f/eNXhGcisMUctPrF5564pzqMCEIxwuKFuxt0Qo0zGrf4PgzgXhy+L++vKpLLUQzr1ehHb4AoEdiG6/ArJH+WaDKMwvf4CTovwrytEeYPMKT+aZkaay1q1AW+/VG+dRoQajf0JvyTtKW9Bq8i73dx7g+d6NIJ2QqK18H6evqZ9rr4HhgicRERdetqfwLKOrh/wYmHq+9FO8ZSVrCEg9mNGfDqD2eHNpxB5wHqCDbwLDkFzoZafUMoul1Erj1O79oXFOipJ16mjxEb6VFFRJyoOeQVOnNc/pt5FZkMErWrRbgACZF+eNWYQRXSqHQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBbdncmUHbymw88OmZgwElhDNuTJRO+Y/c3l39Pfs/M=;
 b=XjkEcop+hq4zgOJ6yV7a511y1nbGB0Z9Nu80lUEh9/v0CBm6jNg8Pl61Sbmxa3AiiY+ljqTBUZ0qHBxY41SjIza4v9xguTU/hq0b8kafgwzxlemNDQ+wcYrVwYJGsWA3tyPFMkx4fSytMakL7UBWndiQcibogf+/hyufFW4mKPNBvF6qn2ZkmFSCvncghQAONVhGdXkHszvkzW6ISJX64VoLvdXxDWVDJFdQsCDqLaDL10TuW1bHxHYSvDjeJg5WzTRMfWCFsSM7uOo142PfYGxdbE9KIsngGoxGuCX4AQS2AE+WVA3HQqk5q+pmyycql0ej8RRuMA8YbCOcqkRfaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBbdncmUHbymw88OmZgwElhDNuTJRO+Y/c3l39Pfs/M=;
 b=Pm0Jh8YeuqcwATW6ZWAggEiFol7EDgzS56Rc7nDdGX0uO7XOKQxXhJRFCbelH8eNSV6Scr0q+HSNQ/+GZcsS50AQcbFH6IQpKQKHWxFHGVgtw24JeergZfNapHT/COwFhyii6Fr6zERMoUhWf1+q1EQLw8Pis15/COTQkMq7cuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:54:01 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:54:01 +0000
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
Subject: [PATCH net-next v2 6/6] net: marvell: prestera: Implement initial inetaddr notifiers
Date:   Mon, 27 Dec 2021 23:52:31 +0200
Message-Id: <20211227215233.31220-7-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e468fd-aa78-4d32-57d1-08d9c9836464
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB01454C73047513001A24600493429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6TJvGPyFCVzIXFr3Q/ZuTHJAPfAdjISXoFuAKKzDKa8dxgD6HfCgUqfkS1arYlm0nWEtFSeQtt3Xhbcc+ViqTxdYFhqUU/+S8iYoArOutSyck06jjwMWVDRjyo1/kGcEHoc6MpO4k23p4X4XE6RsPp54mGJnSwkbRB3+5JcQytTgK8qaeT1tWgDfiL9roMvT3hPx2YdTcGXpkFKQ+uzy22f2BPsXK9/NlDk8rMmLJnOil1E/5dXgXKgJCNxFvp5z4nRp1n7eH8aFA2B557B2DIGcL8lfshzPSqn/10Sb88m2aCDqrBLJrVUwcXH0M2/XISfbnjfcn7Etwk9Y+81I4ELZkEweVo1vYjpcfK+2BM4qXNHk4pdd7WiBLrdP7lU3Bn3BpLTwkcCGDsjKK/+3kyuxtJ/Jj1kGyOIBOWoeVdxCC7zS6e1LukqxNzPJ6uUboBGMGmnSGOp+rmcWF2EIw1guqQ+l8V2WcKSaU2Cp2p3R2cKmuqUONPLTqtf4quvdGaHaD/TmagN9sV4ZQXdqpHaoj7Hywvu5YUUL8NWJxlEn8gfW3ZMaBbMoqe5crr6wA1MNLnUW3JqzdLB8E9xIZrzwksrIn/fOvQeZJwEFm4pQIff7ol6CocxeKgOfXCuQxmISkJ5BxwYQfCeXzuAFsSsb8Rx2x9FScR3ioSHmLGAQRIJbAQuP3RTdgESgmkfry3F8A82fz45G5Dm7I52dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n/3vSEk35TzyZegN/l02xNj81p4Vi6hpo89UU5GQxD8ceMj5ou7xIFjAgUW7?=
 =?us-ascii?Q?AU7mUQUdowo1kdHS3PGpel0N3OUcRTmXltN+Z1V8mW3I/bJI01pT9kadUpCR?=
 =?us-ascii?Q?HAHSwOSjsMH6LrG6Xx6ilQXcuqf8ED65ML8axS12Yt/HxIuMQT8nM8Zlw5Yb?=
 =?us-ascii?Q?MVPl2E5oUXd/phN/y7HvVV5E3KmD1Nx5ySM6dJHEVJFH9I4xELOprmnMAxgF?=
 =?us-ascii?Q?PolTw1XhZlr4Fh9RPb5MWHdOxMCZeDetf+7g8La1WbZ63DDUeB5OSa0Co5M3?=
 =?us-ascii?Q?1IWlS2ahbkzK2AmqujyzkntVxHb7c7RWiqBg/AYwyVXfxho5TCEYnoUBh+a5?=
 =?us-ascii?Q?IhSGrPmkYj1tnjNyNRllS4/DqAo0FBGt+NkoXls06/YrURZ/j1/SNS1/kC0n?=
 =?us-ascii?Q?0COIN5E3Yg0/7oBmx046dk541eYLes3qlYPzbE+7WpQ+7mEUBm3uA3JalpNl?=
 =?us-ascii?Q?tcFw1dpujsg/ptDQPnmg/U4QdXb3TLQBVEmQUwsdSPJPUWCljLdCg46nf1uA?=
 =?us-ascii?Q?9Elg+KZU1zQPc5A1GzV/UJbBT8fSaYxXL75Fbnpoaq7tDLzARKOfn6Sa8rRG?=
 =?us-ascii?Q?j+TxhU7F9ktNezbZBY/JKbvV9CHoeGahVeqHUFC+gOrOE3TQNA8De4KuSkVF?=
 =?us-ascii?Q?YFzYyHWounUmtfe7Jpg4h0AlRHdBFtOw3k0OQunRGRDs1PZdhLJZmLPLlfK8?=
 =?us-ascii?Q?f/WJdBXDQ37aGXSP8lmxvsVvzpNrz1aJyje5NuJ7w351bEasIwtBEMeEj/+H?=
 =?us-ascii?Q?3EodhqfxZ4IrKCBeegmIbDg7UB0C94oJ6khr2j+gyen1shj7BEPhzgLhtlKP?=
 =?us-ascii?Q?Dj/Hy05BSJJvQZhPRP2Tae7PMHD6x737+oxrA4spwtC8uPq6xEuxVvVe5oWn?=
 =?us-ascii?Q?nIt9RNWyBG0QhZMRnsJ8IRAGWtsGuK+UEh3MSLOTd8dbYswSTLymQEqaVkdW?=
 =?us-ascii?Q?k7J1YN2oiCZyoit1DU+6E8x7IlCpDbhy2v9kY86C5HbQN1yrZIq9dh3W6jeL?=
 =?us-ascii?Q?ykSu1LRjNY2dnYkpp5yah/X+iDxRSIIm4EapkHTPnfkwWDW5lO+JexPrmRvM?=
 =?us-ascii?Q?yqK1ImfuDCVsdi430jGhAGRFzeMy27T2PeyhGHGS2FkdwxtNfTRImBYsI3YI?=
 =?us-ascii?Q?cfKjoYxOjDFY+CHdIO3TtPU99tYMGN9EB+ONsfl3WlRl6DGvndnOhUrTjLKu?=
 =?us-ascii?Q?bEoF+8v2kjtqwC3OPJIC2+ahssZvqdPTEKdWKY0GPc1fpmUDBuQOAuheO/Z/?=
 =?us-ascii?Q?uWBkQR9WNWD0W6kQUBu65PtCIr6pIZ5/arwk9j8v99CqcNeL+MVLpK5lwpBn?=
 =?us-ascii?Q?GxKwjJJLFjeSUJ3DMdxKpkvlLCMoW7rCxOlytx49meQPjweyqbMRgB83Bd3o?=
 =?us-ascii?Q?f6BYyd+n34gJkAczZbx2GW3qg809KyWSDfF0jk+hjxDnxNs7hJr4g/9QZggn?=
 =?us-ascii?Q?O2MueD5L65Yt4YnCTPX7iIXs/SdUHyBc1eTW1PDtrV6jveMSk0W5bb5dB2/5?=
 =?us-ascii?Q?uasF4LRQ++w1oHzPlYgNw3Dqj66oSGM+nenvImWR7eIq8HJc8B5WMebnCzkW?=
 =?us-ascii?Q?p6TB7RZhU255O8Chau1QDmrreKP48+k57JFCTGvETiWU/leyRGFBYVE84TRV?=
 =?us-ascii?Q?1ixLTMJ5N1s+3raMRrwl/ZyVLilbv7SDyiXQgR5FAaZNunxWqHbi15DQO/Rg?=
 =?us-ascii?Q?rUIphQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e468fd-aa78-4d32-57d1-08d9c9836464
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:54:01.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0rICxF1KjX3XGaLzM+gXBme/RgwQoVcsNiZq/C+iIFnfB/siMmWOaQEzzhOzhCUWgCOaOVqZHQTA09FGmPE6eVluyJoBTSVSG58q6v6wJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
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
v1-->v2
* Remove useless assigment in prestera_fix_tb_id
---
 .../marvell/prestera/prestera_router.c        | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 0eb5f5e00e4e..483f0ba45ce0 100644
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
+		tb_id = RT_TABLE_MAIN;
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

