Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176C15B4B19
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiIKBIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiIKBIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:08:24 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088F94DB7C;
        Sat, 10 Sep 2022 18:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgvyJeJLcw5lfI+tY7RfeOmJQ8OCnYxXbH97NGt9E/My0CXAeHhkEHkDVsLVr8SAHZfYL+CgfPISRF8ohiYGcJcS7jK/hNIW5VDH9vWrfhsFr6H/N8exESD0I3tlhu34TFg2DNemkcdQUhmuWGb/+Xb2DyGl6aY++LYsZXYa7M2iGhwDZLlbwW2oII4MpXVvkUXJhcpK3JUAz82TsiTgrEK6B8Qy360eU6cBTqoXm+B8FWfE7EHVUJWXCmuLOr5LZJVpNW1+6zclUP6OGIFSfYgxuOuT9/TuAtHLUd3G4Z6VpVEr+oNdRZPt1eR4M9Bfvrb2EN1Baio/xr1jUDj9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koEEbsSQH5moAwVpw1Mw+jlZOvL+LtehoPvBuAEddTc=;
 b=RDzhSs+ritseX+1/iKqNct4PGnLq5fHIlvS97+ktcD29IZaCivsOV7C4V1IN7FCoDYRStxmETplhd6iYaqvQNmGJE4/7xMZDNFixFvoUuj1+DKsyOQ2pk/9K1nhe4VOLNGnZo1EO7TjxZ1LaR2t9ujAhUw5JC14dIonl/dtX9/YzUhFUvkhzUIG/SB8rMEXPPNuA07Fga/hXASlMsPsGON2eywVO9+QS5YILcyLt+ZrSzJbZ3Ox2di3g+64w+crBQPZRrJbvVfQwji7wMDouUyxVqL0s6HHVGNu2L1GnMx+kaHp1s0BsOZsrNH1naI2cHg3GdFXQFaQh8MTwxIb+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koEEbsSQH5moAwVpw1Mw+jlZOvL+LtehoPvBuAEddTc=;
 b=hGWziCAuGxfBEghgtXAHf3NJQEwcG4BGkbM2Uc+DLcxaYuDu7/k/hb+U3+zJTLkncOl7PX3J7gWIQDcOzhB2qeivc7jhE6ssIp/S68dwyasLQftiKybNV1Knt3rirZP4DEtUP1UIB0/SoHasOrT3YRsvKCZ2XtFKTVfpmYBtzXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:54 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 04/10] net: dsa: don't keep track of admin/oper state on LAG DSA masters
Date:   Sun, 11 Sep 2022 04:07:00 +0300
Message-Id: <20220911010706.2137967-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 0019a628-da68-4b85-fa32-08da93920e38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mcroubz0iLETtrDhCbtFcsdu7d/lgUV0oRg+MHsBYUSbeRRKKrrpw9o7jpAakQAafdCJepwvZub/XjUBcr9rq/uo+luPL3udt/ia325/hh+bMC+VCuZ5GFAdA+JRog/HGXB7aA1T2zGRZfMDHYbkqdzubY/m2P8qsmzzW7KTEsONPpUvvTjAJfzPODzbwYdRTh3s6kPS9bnVfwV2JZxkMRD9AVZbajksbRBjT/NOsRu3mbuqxABxV3NJ+8a9396mRxREh4o0siBWk11V7QkwoY90WUHkyhVisxLZJYejYyvRM3lmbq+urEp93OYJzmHOL8WfEF2871Q+NBI8FYwPNECySxsQsQ5YNMTeSzaULjvHeZOomJV4SdtxlWbX+6DB+xvMjOoR+Q8gSIuYIoZlATzvRZVfChBodI5NpV317Hox17gYXZ6GkKxmnWfem0joYaAnVM8P4BSqN6ozDqZsAsnlCUj5xgMP4Nmb3mQjmkOp4180I6NZ07OakxzFFZ7kSh0qjzzgK0BkI9CUzJpKV+iMxOTUUGCfLwM0jbwKe1/XsFAAAnyDBKxWbTEt04uUnYwzYvNJCriCGv8tDi9Ridqa5RP0/Dzg8KQu+WfuKFPvk/kGVdH2XWtgBkmDoIkBXyN64jP1I7FtpL4K2o6ncoc4DcedmmhvGos621HXCGxiA8AaMpY0+GMW5rN0w+EQTQW07jrhxdY+Ls16WzBmcL79lXb4Xq97KAW9jMHMiG8hZRZRtzx6XaNezBPToQWVaPd+9ZO55a80aK1sFFJJoHzJ6LJSsjyKBU31gNvUPW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(966005)(26005)(6512007)(86362001)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CmUMlPjnFos/TChckEk2jgb9iGaip0aqYKdJ2AjLLACpL5n6DM2oHcV66Qti?=
 =?us-ascii?Q?jeupFyz223EMTnJY9i/3VAyOdkSr0nzeQLuCXOf24gM6K06v/h3bbEeYdSCm?=
 =?us-ascii?Q?/FhoftTWl6OrrnFuHOTW8SgzZHJCshmRH3bGE7MeHrvhro1aCeJxxHJbvbIb?=
 =?us-ascii?Q?+zsmjSlSojEbGDcn9/V8PCC6rfkb+mQMDt5rEifT1Z3cKxInlRKwba2Ws78T?=
 =?us-ascii?Q?rcYmxYtzZfv3jSWVzTQ64DrkH876z+64GhJ3+lWq5biUmxeKaAy3Z6fr8RLu?=
 =?us-ascii?Q?qH5bSxeuAY11yMhhklEPYkCxYZyenVK2UJoUgsmh1Qup7DD78ZgLOISKp+QL?=
 =?us-ascii?Q?UTBjQk6CzV70ZpTgllcuaFNEkQvwyaKEI9xY76UY+hDGBrvLXgjOrA0KJQ5n?=
 =?us-ascii?Q?6biN0dDOkH/WeEYPxULzKJSw3PnCyAkOP5s6KCqjedWObP2OTCQC1FREJd/E?=
 =?us-ascii?Q?YnmexLskbzePZ/AFpkjfY4NR40EJxxu/vlhez5FKelpE65M65FwBxRL5ZUJH?=
 =?us-ascii?Q?Nx7dw6w0nVV/Au/rPKhGW9LikYw8IJpbpINH9d7UDr5RPpVEmt+jp/eIuff8?=
 =?us-ascii?Q?5S+fgvPZVj2Me2/WjQB9LLV0RTE4Eo2quAmIdQscFN1CxiAEHPxyViiYLEz5?=
 =?us-ascii?Q?qxxE8Jo9U7BkcCI8t+XOiwSaVWt9Zj8aMqCfT5yIewRE4ZBJ2Ms+vm3NfhKZ?=
 =?us-ascii?Q?M/JEGneAN7DeAqq71ahp/QFP/t8nrcZmiDo7hwC+dQLCanbRNcq8NsTTgSyg?=
 =?us-ascii?Q?BdgQpuKba+0AZpEZ8J6llGGrddTgd5YlYY6jqP2az6G/xYbxucFpolfZ8Q4p?=
 =?us-ascii?Q?nCPtc+Mp5PH6GRAnAPYqZ+uW9plmZoWAwzWcoSYGsym1i1QRPY2znHxZcZB6?=
 =?us-ascii?Q?L4JoB/4L5u6+QRTxDlkDG7i32gOGefSVKnwn97BgZe+q2xcL9uK691jRUxT4?=
 =?us-ascii?Q?DfZGDNFo4i/EOULc5//3raeS6ihIbbYxrqgouj0aIQM3vM1KW/8o/FfViur5?=
 =?us-ascii?Q?RNUwzRFO1sQGsDj+GqnQG0XiJoUHeYZjwrLVQrouMP/fhCOcABLeCDP3CuvZ?=
 =?us-ascii?Q?v38VbVu5jG63XyQU2jSDcbPfEB/62/Zv9tZ8UzEDqqwAfGeoslDfQxnPfosC?=
 =?us-ascii?Q?HlJWrhnQKw51pt2SxqEbereWg1hW5KQG5q+QWNzXRjfR/V/eAtf0Gm/n/rQM?=
 =?us-ascii?Q?//6DzL/ONXMfGIoflgZBLGIh0Zypte/iydAUqqmHWChDFC7eK18zXfKeGAmm?=
 =?us-ascii?Q?wuwForMk00KsRnrLr5LnFtFxUxrVb9OPuY+Ea/Sa7bSPwcV/dWafKHBM3CaQ?=
 =?us-ascii?Q?G2p/Rffd3eXBDot8fWHuwsqG5h2JM15jHGwV1iTY6sHwI43MHSkhgacjm+xe?=
 =?us-ascii?Q?8okBL/w9Hs/Tb9Gx6bz1pmJeBbSlQFzNyLBa5O37ZosY9bmXcRNzIazlLf7K?=
 =?us-ascii?Q?y71kb3pwPpUW/iXuqeUdM/yWzkW7WKccye+8yvTq7Q9kRNFzV2HaKUJB0zqc?=
 =?us-ascii?Q?I1rCqhYaRA6vk/gBpVFJIVB+Hn9DJ5ChlLdSdcKrW1bEV6/nWimJRDFPUh7c?=
 =?us-ascii?Q?A9w1fbBE5KAtnYormNB0xX+Xev4SOySjM4MUezkx8mEm32n4KGZlYOBxY2ad?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0019a628-da68-4b85-fa32-08da93920e38
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:54.0719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wi9dqOHu6IK3xgUvSLvhgG50WENW8zqnZwpQwP63vqwUtoOU+gL/cBZ3TM+adXFm1jhd4EIfByhSUYBowr6JhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We store information about the DSA master's state in
cpu_dp->master_admin_up and cpu_dp->master_oper_up, and this assumes a
bijective association between a CPU port and a DSA master.

However, when we have CPU ports in a LAG (and DSA masters in a LAG too),
the way in which we set up things is that the physical DSA masters still
have dev->dsa_ptr pointing to our cpu_dp, but the bonding/team device
itself also has its dev->dsa_ptr pointing towards one of the CPU port
structures (the first one).

So logically speaking, that first cpu_dp can't keep track of both the
physical master's admin/oper state, and of the bonding master's state.

This isn't even needed; the reason why we keep track of the DSA master's
state is to know when it is available for Ethernet-based register access.
For that use case, we don't even need LAG; we just need to decide upon
one of the physical DSA masters (if there is more than 1 available) and
use that.

This change suppresses dsa_tree_master_{admin,oper}_state_change() calls
on LAG DSA masters (which will be supported in a future change), to
allow the tracking of just physical DSA masters.

Link: https://lore.kernel.org/netdev/628cc94d.1c69fb81.15b0d.422d@mx.google.com/
Suggested-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/dsa/dsa2.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 44207d848722..2b324db8ea88 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1336,6 +1336,12 @@ void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
 	struct dsa_port *cpu_dp = master->dsa_ptr;
 	bool notify = false;
 
+	/* Don't keep track of admin state on LAG DSA masters,
+	 * but rather just of physical DSA masters
+	 */
+	if (netif_is_lag_master(master))
+		return;
+
 	if ((dsa_port_master_is_operational(cpu_dp)) !=
 	    (up && cpu_dp->master_oper_up))
 		notify = true;
@@ -1353,6 +1359,12 @@ void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
 	struct dsa_port *cpu_dp = master->dsa_ptr;
 	bool notify = false;
 
+	/* Don't keep track of oper state on LAG DSA masters,
+	 * but rather just of physical DSA masters
+	 */
+	if (netif_is_lag_master(master))
+		return;
+
 	if ((dsa_port_master_is_operational(cpu_dp)) !=
 	    (cpu_dp->master_admin_up && up))
 		notify = true;
-- 
2.34.1

