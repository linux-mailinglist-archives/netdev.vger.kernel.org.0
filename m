Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B82576AB0
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiGOX1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiGOX1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:27:23 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6550D95B27
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:26:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFaeS8MR7zHu11vFXfpkuCv/OlSETZAOjkmROMD3ntsYDyagEhigpw2+5Elsvk0bPIMu25fBspOTL+avolkunTM+s403jwpbare8egQqyzL1LG05W3IWnBlhiWuQP99gatSPySo2ma49crCi1iOci0MMSC+21lH/QDA9vuubAkcJwUJ/f8qcD3cDaXu7plcFZAD6Z5w5OmR+PS5F9tpqC3mDsfDmo5RUaM4u9AweY4sMGx1PPoOaM6fHQQTUoBDveofdIdacWjT112lzcaLUo6YGwK0OSXzwCyD5kDbOTUZYaKhTLi+WdOOJSjP0BS/Cskx6iitkdY2zB/HelFLFHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV6kGXxdfBdgL42nF/HH1aZFxuJJBAbh8SL35l/+o5g=;
 b=k5RFBvA8+QcAw+A+upmF+cclu4oobvXpPeRU7PAVwSiGCYPzBEKgYjQuKwC9Xwo/xdF7VHUwlJTL4ij2CUb9MFuEBA2DEML/dp8/dlpSMrjYdIHKjRJ2TrgudD1gT59UaFoZ9RB6U/uCWP+F8trp2QMelmPR//DJ/uB9CqyayvHIjvQejrXkL4rvh2FdJpYeV9RzZ1kHzG8YVEoi3QiBjpBje3MCM2R4+aP/8++G9aCLpexI/MWtqkAMCIflSWzg21zgGJUWJFKIbJWkYamzn6UaCQm84qerakSwjPTbe/uYmHrEA1oE6kt92cQOvZ+bCoAsmERfPMvvsbXIFhB8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV6kGXxdfBdgL42nF/HH1aZFxuJJBAbh8SL35l/+o5g=;
 b=Q5owLgWpb/3P77fHkbV6gjQk+XVx8XA9YtWK4oCf6DTlNmkzTmd3IpV3+dJ9NmkvLp+jKp7DuuFT2n+2NmKBW9wZEtgFfDEv7iKfoCdGlIDmsibZYhO3Or9q7p5WSZBLBkyWYbxbPoz1rZS/6738ua2hdKOCinSPRH6ChqEAWXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8707.eurprd04.prod.outlook.com (2603:10a6:20b:42a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 15 Jul
 2022 23:26:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 23:26:50 +0000
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
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating trans_start manually
Date:   Sat, 16 Jul 2022 02:26:41 +0300
Message-Id: <20220715232641.952532-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0109.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e02fe347-2a66-4186-89e1-08da66b97e37
X-MS-TrafficTypeDiagnostic: AS8PR04MB8707:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kW14HJ3JE5/pR8LEZdUtT9kCJuzaIgdplsnousQN67mp6YoOUw2SILXy+dRLvPh43wC7dxRa2Fwu0kTY2jfCmb5xbz5cFDNQScMf1ksbGxWO7EuwLjRtiXi7FgudnDsmNxmHct+oksOQw3BFw5s6L5PQMhMM+Q2VvWbf59Cn+sHeRsSfaRsaNs7Dhn3YeCGKw2DsMECxfBFUErPtdWkyuMdhZX/aoKER5WfaIeRQ27p1F4M6Rt8tAblJc6K6E/rR7eA+H354uw+5JW7+w4ukmrVA6zGxHOSD+EAQwVa2qb/3e9U4YU+GY6ky5V9n58gErLr/yG/4C2EN6+xcs3tOXigCNVVkhfXvXHWTP3hZ9iL0AonhxE73XP/chN4LW3DeL+6b+snKVA2PVZRp5iINAJwVDLnTtbDTbg9q76hDkco0PMZJuCGF+AjvIHqe51KmMSCkBijR3B7xHR6m2pl2XGA0aARn8D+l01OeCbig7ksB2b6JupRbaUd7mlQkJ/c5/W01R1fqsGvdLE0a9GlO/yNxRsTw9R3WMGB/sIf5s9cxMSJaSrTHX3rBAKuRXvwmN/JvOj5szv92qVAT/6xNUA1rcrVxIuDxNbjVV/pUdwB2L2BroGgWm9XBZOZzFSLxkV6jo0JpxHtYNK2/MLqqx6ZAMq5rR3osNOAoQ40oK/aXENczEa7fIcYGqzwXjJxQQ7OK/X/2En3XNyNwdgi7q5iB2IIyZN8QY6eEsrBFo2M0U+Iahk7oqXwKiTVAdhZsOJrYY6ZUbaZxQJyIOCoQdz/THMNlOh83d90AO9AGdMrmNmUY8AdYpvE9qmBIpcio
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(186003)(6666004)(41300700001)(2906002)(6512007)(26005)(1076003)(6506007)(2616005)(38100700002)(38350700002)(86362001)(52116002)(83380400001)(8936002)(8676002)(316002)(54906003)(4326008)(6916009)(5660300002)(7416002)(66476007)(66556008)(66946007)(36756003)(44832011)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fAGpTUnhOERt6hETRmF/YZia1/pj6CPPVoEYjToEwevWlVob/7Hvr3wnCJRc?=
 =?us-ascii?Q?WJmPmIv94W4fI3Y/KUXN9d+LPBRwQtvEcK0r4FdLZh4TDA2MTUfhmiBFfMO5?=
 =?us-ascii?Q?LuKSyPpp7gzCRlXR1P+gfDRkiO0F45tqWHDuI4/T8FaNWOBQHhpawZ2nI55Q?=
 =?us-ascii?Q?l58EO+ywM35QUdUzx5ZaMfQFm/mBM0ad3H+ExwtoY77xPJOo6axDkPKgW0+A?=
 =?us-ascii?Q?2NmqfKcp0CFCdVNtn/f3vYylF4OevTIEJPWe5h618QW9jXdv6VTJH29MNhXm?=
 =?us-ascii?Q?Vd7SaixP3Mk8jS8EMFbdxUYBRMqrysYUYrVxmysmlIWyDX43Kfq6511Fr3FK?=
 =?us-ascii?Q?OhnkxIXQf6Xd7uvOyWsOU8cBh+igNuk37QqQ8fU0h1NYFiZfXR4iCF8iBBJg?=
 =?us-ascii?Q?1znp/IYyBsZWoQWyVyqONxYkpDhEjIUvrZ56OsJO2kBy7RZuy6C/Cgp3p46/?=
 =?us-ascii?Q?YV6rWpb46eH86GEwecqXv/vC4qmBluyf0Dk887sFBKiJVZ2bCvVuz1nHBq3A?=
 =?us-ascii?Q?IoZTowKoqlVSkPCriyL2JsYaSB9tbVN193bGM9TZ/kSibWnrk5yzr+lfnOdS?=
 =?us-ascii?Q?Gs6cMVnpN2N0EzOR0aNBFDXnUCdr4f7Sd7OeyK23c+YyiHTJaWTDBOtwatgV?=
 =?us-ascii?Q?ArzVEIXkjH9AvjtZq+WIR2b1oIGJp7u6ugrMqlQYkltjPNI7XaWnZM50ObIu?=
 =?us-ascii?Q?1mh4kvXH5kJ6pPtB6BVABU6wJHoqjnccbmfHUCLUdNcrpZ57LJOpqKIXA0sV?=
 =?us-ascii?Q?MbZBHBmTpuNOLTI4j3DGvnIQcV9656UgZkUwHiXjrOQmq4TiocidG7puRwuC?=
 =?us-ascii?Q?PDUivOo6ghvR33o9et/9ys6vC4iNkk/+Py8m9gxwamJeyzqys9BgMo+aXdnf?=
 =?us-ascii?Q?3KUWKDMHj4WVeLmoQSGVAYzXnZntuQyJbYv3UgnAzacd8HVxkjZz/eRdbo9C?=
 =?us-ascii?Q?qfHvwXGRj4GfOt5xPj6o2WywSVLML6qcGqCkbdttfJRXaV+E8Ar8yvTmUKir?=
 =?us-ascii?Q?IkTW4i/Cgdm8Bs54AmNuJhEs+fPhoU6viRarr4VnYPQXUkfbONBSI/2h86X3?=
 =?us-ascii?Q?FdD4P5JOPl12go7mBL/hc7XClQts3D/XoeQUd1SKKx5Whm38lA7Ex5kFAoUK?=
 =?us-ascii?Q?kRAmN+IJj7yUwggVP/XaulzKNOMAxtZGcP6QrPDFOWYfjE+ktnH+md92dlPk?=
 =?us-ascii?Q?9BYROKt4CSOU3tgGH3oUWj5kdKe6/kixHvLkBbzo0JvugmT9CTjtJkBHF4uh?=
 =?us-ascii?Q?coQvEUou8imsIphrrL8HnVjfDhVhDikvgrmo80fQtnhbUU5O8cBiZ84+TlLd?=
 =?us-ascii?Q?Z15sjxeD21TCIKeFMlFVf5t1flBTDtkOxOEQhk0W/ijT4iSn1dvPj/m94nyf?=
 =?us-ascii?Q?7oZxqlbPfvsN/zGH9sxPq/aXIW15kRN243Tzj5au+giY3/K1hFetFwJ7IxsY?=
 =?us-ascii?Q?UAbHvAqg+5eR7dyb81ERp9AiIIETK0WLVvsia+ma1aSw+fsWlN2OCq+B3X+z?=
 =?us-ascii?Q?1YrstghQnE56+oklRPLvpXGA3DZavwDhLWIfEEMzhgDp6bpqG1fTnW9BpCqZ?=
 =?us-ascii?Q?y8jwo65W1xFwISAKKQjGqH1oXaKPzHKG8OabX4/c9JVesnUs3ZZ5DW0tzDmu?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02fe347-2a66-4186-89e1-08da66b97e37
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 23:26:50.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61lghcOQN57miUKtsayuW+3OjzJuDpTkchleagQd18p7KRR/p0x0rLyfAW+TWQu7gostu2zqQoC4qYA1whk6Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8707
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/networking/bonding.rst points out that for ARP monitoring
to work, dev_trans_start() must be able to verify the latest trans_start
update of any slave_dev TX queue. However, with NETIF_F_LLTX,
netdev_start_xmit() -> txq_trans_update() fails to do anything, because
the TX queue hasn't been locked.

Fix this by manually updating the current TX queue's trans_start for
each packet sent.

Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for slave ports")
Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..c1b5c549698d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -746,12 +746,17 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
 {
+	struct netdev_queue *q = netdev_get_tx_queue(dev, skb->queue_mapping);
+
 	/* SKB for netpoll still need to be mangled with the protocol-specific
 	 * tag to be successfully transmitted
 	 */
 	if (unlikely(netpoll_tx_running(dev)))
 		return dsa_slave_netpoll_send_skb(dev, skb);
 
+	/* NETIF_F_LLTX requires us to update q->trans_start manually */
+	WRITE_ONCE(q->trans_start, jiffies);
+
 	/* Queue the SKB for transmission on the parent interface, but
 	 * do not modify its EtherType
 	 */
-- 
2.34.1

