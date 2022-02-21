Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0C4BEA2B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiBUSFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiBUSDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:07 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2D3BD1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNPrHWud0xlCiAE7nF+dX9T+JUwDfmcDEvTvfLdwOk+UzkKkQO8aWqzatVA4IitlLMlZkEDyCfIAZFxcPUacSMtNbLvB20LBYdZRpyvu6BS0PJj7NUYpCmY+KQet7YHdQVRbucuhjbgrXTqRjdxw1yT+WS7E4FHPVYVDRwlRJcuxhsULYdZLaFY4fTcCfwuVG4O9T85oi+GdzLqYsuWu8jWfOsDvDItIdkrCgUlS3Lf03UKssj1AoyIOqGNVb/H1chBL4g6Qpt1QGzrtIWlleCV6juAcnwdVLcENAdYMNjrKJ9EBt48Mx4YbaR7/sH203uoSjNhLUhGSmXruhkeI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uCCbG/hadvcgDs/flkbdaih4KXIix6EXsPb7VG6Wwc=;
 b=YhohYFT3mmfm/kKTeVFW5e0qUQV5cZbi6S17C28BjExIHND3reCgPUHZzDhiEp8FiNNquFHO0py9eShX7lk2jMTtD93rGb0N9QKCDRs+GQiJT6UiOD26Go6GcHaviSwg7oELD2KkZ+n4ln64F5SWe75zTDU13mTMV+N+c2e13EQfPL3317s+Owa+wPYLDzVmDdZRdMN1mf0idNmK+Dm0cRG06ijpGe3p17SDOG6GQ2dKcaOpwYK4Uw+F7MywJLhNmiVHoa5hb1IU8hYcsAe7khkoVOH5z0vNmY4EdQLKzr2IxMghXy1Z4Spxn6AsqA+YD2QyDnb0Z9kW2VgGV+jq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uCCbG/hadvcgDs/flkbdaih4KXIix6EXsPb7VG6Wwc=;
 b=JpUhG63UdcWMZgLxe7k/OxS/FxMgy70Q4RTrsGWyWWQfHDBe/nKd2Np3rIe9REgpXSRIyXRCnjCzZqI7Ej8ibg7DmpgWHPJZSFpzErFU1dSH+z3VaWAqERf4wKE/1oW1/HHdnN5SnJtp/2uV1ENrnnstW47Ea9TLD/f5x7chlqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 09/11] net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
Date:   Mon, 21 Feb 2022 19:53:54 +0200
Message-Id: <20220221175356.1688982-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9457aaa-4518-4d09-fe8b-08d9f5632c50
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB369342F392591F9A629C5F5FE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Sbzp72hRljoVsrKHl4A61eYLKMo8cy9+7uc+pI24y95tiDma5heyJoXKypW1hlQ42x8RQeijRDdvPDcU9D85aYrq0+txLRTJKx4kyFX/HSQEc2KrvbqbTPLDzyb4Jz6mprpdxew7Dyw5eA1mNP3Z1krxUr3/VnBkJbGQExQaIZ/Fpj5vF9McUW1JfS+dyp5pzuz7WsBSwGeMINkGuBrgRdazA5ybjmtvBksC8a4o+dsOOwHdyuuu4MV6Uo26uiI5xhwC6P/6MaG3BUZxs9mVkpg8Xvv05MjXoqhsjcYFiUdHt6S4mBfUsqCrkFoBzRri2N09p+kTzxJQpMXNqShmuz6TfHHrCiA7A5NH+sszB6cEkrwEND+G+cI+02cSftKSjA8PVoIZI0xcyFqCRiSKBttJ9Gx9dGCnlNWtsGD0fGfIbMatQ+N9PF/qGIrPBwpFs7sOwdQsAtobFY6OLeUFUFD/StZgIcib2x3Dnec1BUYTqvbqv0JWWtZcaA5/xqXxE7My9lPAqq+2ZdlHbl7SuJ22tGc/xySj/5o2NGhiviwaeCfLpFKJFodfDXzJVVA7G8V40Eg6b7Q+K3ezeiiykD2QbhdOADwX1RLIpwJMvXP7xfyTeMWnCEZaFk9zId/RTz7ic5z58zXPYNmHoQeJRKx+MtohQu/EY1aGtr6POLwr8KHTWPDAhHl52enVgkJnvbBrC0SmCSRRtG81evYNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?umChYO+pAN5q1n21qsOSU/n8Yv/0rwiFwSu5hCckcWISG03GIi9IFyjAqtPS?=
 =?us-ascii?Q?8QmAOg9kDrJlkF0ZPUjT2BYsFrM4pAkpGnYxgZDmgKNYe0cajd3MTrDWP1gI?=
 =?us-ascii?Q?x2XGHke1LDrVZzZDKE9GWS28KenY0MqwWV/ZYd0ZXNrsVz9TVfqcPHSXFuAs?=
 =?us-ascii?Q?VVfUgpvONy7nmHvIsK2WU1dc5IkIkR51oLArx88oy4iWDSxHckNT05f8psJX?=
 =?us-ascii?Q?AizLyTmTs0cZLjcKsyR5RSPORA50ZA3tp1LZapv58gietLCMdEo9AeJqSK4k?=
 =?us-ascii?Q?rjRESdgbg/l7c5uGTavKNvIhvdqf1X0btZNDArcyflx/zAaXs61gQar5/NH2?=
 =?us-ascii?Q?kUbisSB/BGsNDyopK3iFadlxRIVtnuQ1IZ/+3q9TzFGBiA5Jd//I7/42nJBO?=
 =?us-ascii?Q?jVdscocYaEK1LDOBS4OlKUIeh595MP+FdfpYlPTL4cMVSOuR8TxMSs9xhA/p?=
 =?us-ascii?Q?DJ1j5n9fp311KlPoH3QwZohiBmyHunpl+5W8kih6ZhRf0ONTZ60GiMU2PMff?=
 =?us-ascii?Q?+FGJFnT8L8BrYagOAjZ5kSTGe24bZThlNXqVeGEDKUZjfXJjvh5jR2gMbkjy?=
 =?us-ascii?Q?QyO5Cm6hxgRV1YJx2QLIsAXO6JDjdkvx0VeX+rz4qaAXlntt9H5ISr4woC7q?=
 =?us-ascii?Q?qHwQUVB+Gn1y7eP/QlY4mWx3hCj4vsEDTjfM5WcXVopIVjZMWMHlzfL1ADil?=
 =?us-ascii?Q?DoRDYP1ZMlb5xR9MvZIK2wxBN6FDFkD6H0ZFhJXsD+gmHwIljRU52LHse92Q?=
 =?us-ascii?Q?lBLVSa/cufrzACKnoMtOsmIXm1xtJQBNL4EtZqlLYlVGXaR+6YN/vzsPVzdh?=
 =?us-ascii?Q?sqBzzuuyz8XqcGiNrsYovbbJIFHQR8Dlq4wNEaMDJQ4D1zztLI3/U+GycujF?=
 =?us-ascii?Q?arv4FYLU7H1cfRLFXg8UWKwS8Q3eDC9W+m59ESz9GvfXoTJOonMyqNQE9bAp?=
 =?us-ascii?Q?SmWWJdMiQH6buvkBBNGTphPSZ1xyhKkDl+K8HWK4FOhFgjYd8ddsXjqKRpun?=
 =?us-ascii?Q?IY62boPZocwXp6Hj/DrkmR9FvZq2BylECi9GkgELKiYVMxUixBuIOMsTE2CH?=
 =?us-ascii?Q?3lTYJNicTF4obRDdWkpR5zlWOeNj5TmMm9BnasXw6NrSssA06udNK2Wm16HR?=
 =?us-ascii?Q?MR+tz5WtTBvJq/GkEdVODFNg8l0QMV7o+OzgChDHMcRzrkYkBXl6U7Sdwq8z?=
 =?us-ascii?Q?s4SCY2ineJoDrvsdKy7Ji8SV/H7U0UE9YeRQN6XvLxydY4OnDPOH9Tl6526U?=
 =?us-ascii?Q?5aNEA++luQR1q96a2d+PZ6sPtcx4jQ0pSZZOQ6koNHkgTh61CbpAxGqIgRCX?=
 =?us-ascii?Q?m+0QL8QmsPjqmWA385JgDWto/20SD5hi9E/qOSDTPs7RcK0OHm5u+nTtbsnG?=
 =?us-ascii?Q?k+wO2zH7ZziODFg/V2U/GjzJxoom0HSH6zGW51QszJWGqL2jM9h1j8ISt4Mk?=
 =?us-ascii?Q?UtpKcMviRtgPw2kpvOjmePDR6qwaBQ7YGhSK4rC8A961iyMxWXR3bseBZogp?=
 =?us-ascii?Q?/QnRzGsVcFeCsx/mR0+F3c0010C7h/v9q6lZKENW9OszUjAh6aWHGZCldwBM?=
 =?us-ascii?Q?0ukcFNiLXQ+x5/cT6l0QDc+N9dzKTFoVC0pbTqZcYIvH5HZBjWy+56VjSCt/?=
 =?us-ascii?Q?vW8+cnahoKryzCOgyMONe54=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9457aaa-4518-4d09-fe8b-08d9f5632c50
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:14.5114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaMIPrrd7/fSOnQpbhr9MqpgXxjyaI7P+tlPWpq7+S0YRPDtrJwf8DG5xppYVUpOlLlTSbQT7Sz/mUK4ItkXEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switchdev_handle_fdb_event_to_device() replicates a FDB event
emitted for the bridge or for a LAG port and DSA offloads that, we
should notify back to switchdev that the FDB entry on the original
device is what was offloaded, not on the DSA slave devices that the
event is replicated on.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none

 net/dsa/dsa_priv.h | 1 +
 net/dsa/slave.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f35b7a1496e1..f2364c5adc04 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -120,6 +120,7 @@ struct dsa_notifier_master_state_info {
 
 struct dsa_switchdev_event_work {
 	struct net_device *dev;
+	struct net_device *orig_dev;
 	struct work_struct work;
 	unsigned long event;
 	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7eb972691ce9..4aeb3e092dd6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2378,7 +2378,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 switchdev_work->dev, &info.info, NULL);
+				 switchdev_work->orig_dev, &info.info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
@@ -2495,6 +2495,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
+	switchdev_work->orig_dev = orig_dev;
 
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
-- 
2.25.1

