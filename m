Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0D2585EEC
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiGaMl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbiGaMl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:41:27 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00075.outbound.protection.outlook.com [40.107.0.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE52DF0D
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 05:41:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGEeMaoTeA7DuQHQ09bPa3U8hmbdFN1PfuYsENQsofMuioXjkkDBPU4aYCZkxTAYelp9De8TiQueVv2Fs3tfyCb0Ac7FgsMGcPt+rQS0/t/6CTHHz6IJ+A/kfIob63lV3PrPPxadmaffX8i1lfNU5BKPtnJwlHmBMSny0LqIwOCg4K05sVU3jGuiPRvMzV4M2Bx82p0IiK+mcSUXisfGGM9DSHUBKu2VEIa815qlAsOWfFlmq2ppEtcpOZtRjvTZzngtGLcv8lJBeefvTs1CsDr/I4AYqs4HcETp2V9HiqXSaU3OfClAgi9avL4iNwyEX+ZYu7iFFXJvaDjwv+Mlbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTlFT4QbSRNmjm63+p8Id2ZsxqAr7UzwmY8Gm/ewemg=;
 b=jYCINShMBaf3Hc2dV/G4fH2g/49EyJGOnweaKnfhRfQbTfN4CZoGRlPm/dtl+1f4oWK+Aj4rNE7twcC6Cj4xoCJqINj1LULzmpMD16CvTC9SU5YS+i6C0BfPVm6XYh9dc0y16MI4Js1D0hww+YlObSX7bX86BXn0etq1SKYEDuIsa5Pxp/mSZxWzMF4LromraNSzhCfk7+kJ60ZaFd2c2F06LZBGT4k32iTRiZZ/IKrZM7L35MkQkqeCgbxZAPoyKwyi+/IEPwmvd4uEcKrb7x2JdVb3BPLH4U9dfr4PlTIeZLdewyHTqcAZyrxylSA/7l5Khr2gsuWqNvn+zyRZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTlFT4QbSRNmjm63+p8Id2ZsxqAr7UzwmY8Gm/ewemg=;
 b=j21OJvJo7TSy7WcFBKqi2rTfa3sxar0vrtv9t7YbYKpqax1cTnljiqCB5bAiETcG8n/rIOGL3mxe6V1OXOsBZg64tqFb6zdZx8bxprj3FOHgJO/safyj/bvVxREf0/jtylUp5DLetjBz6cIpfVVZ7lH2HqqrIK/n6QyXIJGdfBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6446.eurprd04.prod.outlook.com (2603:10a6:803:11f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sun, 31 Jul
 2022 12:41:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 12:41:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
Date:   Sun, 31 Jul 2022 15:41:05 +0300
Message-Id: <20220731124108.2810233-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0191.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9baf569-8ecc-4340-67a1-08da72f1f8f2
X-MS-TrafficTypeDiagnostic: VE1PR04MB6446:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMZSuQpORkRUaLw0jOYgvUz0Jpix58qI4BxgR3dxXn2YklADR9sR+IHEhFbg3xSjeb1v4fjg2aG7+minbIm+59okxIi4q9kZUONfZuENvS26Y2lvJfIEZdRnXG1LwuywHKDnXIjb1UV7Fw4lQUmgeGTpveBPR1XC+hmIL9+z5qs9cv/mvFopiEFlAE80nDZPmeq1I/1ZmN1T82vYfGEM5zpoqpbbxGG3DMXJTh0pq7/xRfQM5FM9+ox25GALWn+kbzK1Hfctxsk+lG7aoUvcNQWZBoZ0GxmgncCxuaidOkp+q3yT+GhcgJ2SFfz6wEoJPNIJvrmUAaRlnLuIfDhgFgmlN38ELU5Xe1KTcHxAVk0+i1thsTfy3XFmKerKqsWHU4c4n+2027jjjn2feaZTPfYTYmX96mOQtZYS/m4UY65Z7Ww42KE0znHRdQglRvU8JoUWKCkUgzWv7u2QzocHGsKf9oy0+ri65c2AI9odGlrIx8AMakfiazC9hLXj7cmZnZj7+zhYjZAJcLtSS0KHbVD80UOLPdr4Km05bsMm7u3EyOJ6YsisBl2WMhg3jTgGGhRzT1jxu6P8EJqs7ALWVnW/+a64ir7ZAKovkwPZ2uu8nP0G+g8BmOdhSCfNqecB+EJvLnEP/BTUETvHoZDMIeWQ86FzGapyNuxFowO+5Rr3/U5nu7a2bRaZc6DaDvxLDWQDOIfXK7gavrqM9LyMdjLdPVWGmeXqZVWOWDt3JlOPWhhCp0PNWRcfULl0ckjitcANLauqy7YNFnrCLiqk5/ydJTpJk3/LCYb0XQbfhwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39850400004)(346002)(376002)(316002)(7416002)(8676002)(4326008)(44832011)(66946007)(8936002)(36756003)(54906003)(6916009)(6486002)(5660300002)(66476007)(478600001)(66556008)(6512007)(6506007)(52116002)(186003)(38350700002)(2906002)(41300700001)(6666004)(26005)(2616005)(1076003)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EOoixFvf0DQ6hIymoK3YUoaHu6SSljg/bLMjhjSOG8og3qRHCuinEnCcit5S?=
 =?us-ascii?Q?9V8RO1EICSspY6mp7GfAjNFDoRlicrDo1C/k1EqmnECH2BOQg9tEItYYJs7c?=
 =?us-ascii?Q?9igIoE4pcl030O7ChQM5VL01r+tlMZ4kXdD1XGTmfaJXqvbrn2P1vEjF0W07?=
 =?us-ascii?Q?RU/Altj9489+nPYUc/YV1nuFL7BjcOZi5jJBwupyt6WVYLtp+mue/aXbkQcb?=
 =?us-ascii?Q?KJhhTfvYFnqTBeTUg1XJAMbN2XXRV2OnIRwKyyJth7xCExLh9q5OL+LRBowB?=
 =?us-ascii?Q?+Kn0ZDyYHWzKMhlIk6zEsz92/+SlsAt/L1PdzUJp/5cJIC0sOIXzh+3uZ6Hn?=
 =?us-ascii?Q?0GPVFwbBxEonz46NnXBZcsMSX9S2PvzuWEv2AmYGmKaAk88PQhnfmXqc4y3c?=
 =?us-ascii?Q?IIu+Xa+5m5mwJeUMPDp3A/114Yl9EEjLiz+7mwm/QM9b3quCWo8KDP5mWR1D?=
 =?us-ascii?Q?A6B2CiigA4w6OdEltfs7GS1xIJJbUaL9SqMLN2I2XuHN4NNVE7VlJc0I5QYK?=
 =?us-ascii?Q?6kQC6uLbtiuE+HLeWTR4X49ASKjEZT8Ilr9XsTjUBKhTJFmAi46vqzEMQ2kk?=
 =?us-ascii?Q?3Eao8xRBDlU3gVPdYjkurvEDZ81nU/zpY+Y8zB8n5cAkCY9VZ++zDTnyHERK?=
 =?us-ascii?Q?QRQaPiGCHjIM6CMiYhPkOErKGBOllRVYEykJ26Yi+GHlu9AuuAIwJSXTFtXL?=
 =?us-ascii?Q?yI/vq/oifOlcZCxzD9RVuk8I4BOP09Sf+aeAMCB9VR8pD/i+vCVnjr1/kf9Z?=
 =?us-ascii?Q?kTD+ARfZapDANCoRakikgdTOkqTasocJde2jwjZi7Ysccd/N4c4dYEHwf9J9?=
 =?us-ascii?Q?cIHkckAHRgk1GjdPRvUGJ+l8N/GVN4LWB2wXKgHMV5hGrZkzT6GczqT4f0nE?=
 =?us-ascii?Q?JuIGX+2mFpwtO/Nrs+6JkJdF9fwlxGJYXcjaklmOrgGASrMOcJKV/Zlb0JLT?=
 =?us-ascii?Q?EwDAswRZxu8OO154c0LrGLRcPnErcZ2rY5kbiu9T2ICLmVEDjAxnqVd+Ubtf?=
 =?us-ascii?Q?vZvr5Dy/UHnAwAWJFRHHb59s3L0BMOSjuJsWd1WQv6MQ6C9qcAUlm86JG1b9?=
 =?us-ascii?Q?6TQYs2bCeV72oUJWjQUlW92BTmL4MfETCtLjFGPmfixVg8JFumIwl+lmrYqG?=
 =?us-ascii?Q?cKMu23ChOOutwsJq8a0jRC5fkrQxFMs3K8irg9s1gIULt3aga39WpDufv5wH?=
 =?us-ascii?Q?Wc2Dl+qO46KF2AFkrryBwOEp+YGEI4W6kFTYGrhFiygHK3Aw08+x1P3pPwJG?=
 =?us-ascii?Q?eb9m85Qy5gDwvVHdE9tASGyc0MN8/rytdR8VNwzPseDF0C9+Kp2yy8KL2NhL?=
 =?us-ascii?Q?W9hzdhcGFWdfzEyPCyjrGlI4SanauAcw530dIjHngw7BByVcZig7K9RGIG00?=
 =?us-ascii?Q?RzEvxSeigYQOvkI6tw3izcbk5B8h2Qx+Dd5e9Tor4jxy4J8Uh5msZsXJgK0+?=
 =?us-ascii?Q?2mzGiKIfMJ9UL/fKwf4CbUuRAWrq7JHgK4Jfc4XziENAVjGi73PKdpsLDPYm?=
 =?us-ascii?Q?+bLIIdahDQR5Qv74+YJrBf6cvx9o7gmI+cTKI46bRNMlyEq/wZH8Mu7gvJDJ?=
 =?us-ascii?Q?8KRToxlijOyDEGSnskw3EpQwAKbey6whcJU61hhz3sGidvzq7/CoMB+qoANF?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9baf569-8ecc-4340-67a1-08da72f1f8f2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:41:21.7229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tK3zapqb+3fcF3lq4mmepbWXIm9Is7c91UsXSQiXT1aJ9uuNP52Xu7dm+ghFd2uRp6GyvzZ58QwlLI1rP7ZqQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bonding driver piggybacks on time stamps kept by the network stack
for the purpose of the netdev TX watchdog, and this is problematic
because it does not work with NETIF_F_LLTX devices.

It is hard to say why the driver looks at dev_trans_start() of the
slave->dev, considering that this is updated even by non-ARP/NS probes
sent by us, and even by traffic not sent by us at all (for example PTP
on physical slave devices). ARP monitoring in active-backup mode appears
to still work even if we track only the last TX time of actual ARP
probes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/bonding/bond_main.c | 35 +++++++++++++++++++--------------
 include/net/bonding.h           | 13 +++++++++++-
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6ba4c83fe5fc..0337cbd0d6da 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1974,6 +1974,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
 		new_slave->target_last_arp_rx[i] = new_slave->last_rx;
 
+	new_slave->last_tx = new_slave->last_rx;
+
 	if (bond->params.miimon && !bond->params.use_carrier) {
 		link_reporting = bond_check_dev_link(bond, slave_dev, 1);
 
@@ -2857,8 +2859,11 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 		return;
 	}
 
-	if (bond_handle_vlan(slave, tags, skb))
+	if (bond_handle_vlan(slave, tags, skb)) {
+		slave_update_last_tx(slave);
 		arp_xmit(skb);
+	}
+
 	return;
 }
 
@@ -3047,8 +3052,7 @@ static int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 			    curr_active_slave->last_link_up))
 		bond_validate_arp(bond, slave, tip, sip);
 	else if (curr_arp_slave && (arp->ar_op == htons(ARPOP_REPLY)) &&
-		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
+		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_arp(bond, slave, sip, tip);
 
 out_unlock:
@@ -3076,8 +3080,10 @@ static void bond_ns_send(struct slave *slave, const struct in6_addr *daddr,
 	}
 
 	addrconf_addr_solict_mult(daddr, &mcaddr);
-	if (bond_handle_vlan(slave, tags, skb))
+	if (bond_handle_vlan(slave, tags, skb)) {
+		slave_update_last_tx(slave);
 		ndisc_send_skb(skb, &mcaddr, saddr);
+	}
 }
 
 static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
@@ -3219,8 +3225,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 			    curr_active_slave->last_link_up))
 		bond_validate_ns(bond, slave, saddr, daddr);
 	else if (curr_arp_slave &&
-		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
+		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_ns(bond, slave, saddr, daddr);
 
 out:
@@ -3308,12 +3313,12 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 	 *       so it can wait
 	 */
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		unsigned long trans_start = dev_trans_start(slave->dev);
+		unsigned long last_tx = slave_last_tx(slave);
 
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		if (slave->link != BOND_LINK_UP) {
-			if (bond_time_in_interval(bond, trans_start, 1) &&
+			if (bond_time_in_interval(bond, last_tx, 1) &&
 			    bond_time_in_interval(bond, slave->last_rx, 1)) {
 
 				bond_propose_link_state(slave, BOND_LINK_UP);
@@ -3338,7 +3343,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			 * when the source ip is 0, so don't take the link down
 			 * if we don't know our ip yet
 			 */
-			if (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+			if (!bond_time_in_interval(bond, last_tx, bond->params.missed_max) ||
 			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_max)) {
 
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
@@ -3404,7 +3409,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
  */
 static int bond_ab_arp_inspect(struct bonding *bond)
 {
-	unsigned long trans_start, last_rx;
+	unsigned long last_tx, last_rx;
 	struct list_head *iter;
 	struct slave *slave;
 	int commit = 0;
@@ -3455,9 +3460,9 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		 * - (more than missed_max*delta since receive AND
 		 *    the bond has an IP address)
 		 */
-		trans_start = dev_trans_start(slave->dev);
+		last_tx = slave_last_tx(slave);
 		if (bond_is_active_slave(slave) &&
-		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+		    (!bond_time_in_interval(bond, last_tx, bond->params.missed_max) ||
 		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
 			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
@@ -3474,8 +3479,8 @@ static int bond_ab_arp_inspect(struct bonding *bond)
  */
 static void bond_ab_arp_commit(struct bonding *bond)
 {
-	unsigned long trans_start;
 	struct list_head *iter;
+	unsigned long last_tx;
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
@@ -3484,10 +3489,10 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		case BOND_LINK_UP:
-			trans_start = dev_trans_start(slave->dev);
+			last_tx = slave_last_tx(slave);
 			if (rtnl_dereference(bond->curr_active_slave) != slave ||
 			    (!rtnl_dereference(bond->curr_active_slave) &&
-			     bond_time_in_interval(bond, trans_start, 1))) {
+			     bond_time_in_interval(bond, last_tx, 1))) {
 				struct slave *current_arp_slave;
 
 				current_arp_slave = rtnl_dereference(bond->current_arp_slave);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index cb904d356e31..3b816ae8b1f3 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -161,8 +161,9 @@ struct slave {
 	struct net_device *dev; /* first - useful for panic debug */
 	struct bonding *bond; /* our master */
 	int    delay;
-	/* all three in jiffies */
+	/* all 4 in jiffies */
 	unsigned long last_link_up;
+	unsigned long last_tx;
 	unsigned long last_rx;
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
 	s8     link;		/* one of BOND_LINK_XXXX */
@@ -539,6 +540,16 @@ static inline unsigned long slave_last_rx(struct bonding *bond,
 	return slave->last_rx;
 }
 
+static inline void slave_update_last_tx(struct slave *slave)
+{
+	WRITE_ONCE(slave->last_tx, jiffies);
+}
+
+static inline unsigned long slave_last_tx(struct slave *slave)
+{
+	return READ_ONCE(slave->last_tx);
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static inline netdev_tx_t bond_netpoll_send_skb(const struct slave *slave,
 					 struct sk_buff *skb)
-- 
2.34.1

