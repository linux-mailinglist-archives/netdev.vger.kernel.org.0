Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299662CF2D2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgLDRKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:10:49 -0500
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:7598
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388544AbgLDRKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:10:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxLtHfSBRrJSGPcjmFq9LuXe4evGFF/jHhl9cG70tTpoywS8rO0LidWsAMOTCIfiiNopCUo2uVJUMUTiunWWmUDdfDcvOGW7+MIYJPwRe9pDGzczk0yweQ54xhLiRDFpnoX0KZIcwWeXKvFl21Uzw+XQAAvRKz7XXJGweyA8oGCOqiIRb9+p7vroVrHa9u5dS1OT/W5KZLWr0JUEhraPJcRRjv8BL5bKY5gb9XZbWIIKqFX4Oe/hYlTMfJxz5uasaxqw8z5ofUmvxPqBWTD81XZEfNFr9qnD75wEcP8ZVjSj/CLJjs3ewlAe8d/FvAGjn0JtrVxnphG3uRFE/6gRoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzsADw+6e0jMmgnY/Wtvd6fWnRodbQeeOAml8RW+DNg=;
 b=fDRnfHBIDihb71TeHCEYSXAhE3C+v+DZyq6eWzJDeUHAhyzkzt0jJp4GbHipSrCOG+sjiLNUYkP2PAZAY+xkj5L7M7S7zmRAOdAQki3HHiJdrAgvmc/Wu9s4FgcJjFdNjxHXiwMdeV5K4Amn86BSR3F00SDZ7tKqC89NLv/3QIMicj73SuD2vI2HCL6V1SvSAwozC6V1daHD58cvDLUx0d//kML+1M1RvbxRn8cVqDcpfpdTg+lXqkiQgDyXaOiI2L/4u5A0oUaEBYJ7WJhxled306uMwZ2nxuDPCuYtssem5EXNN1BMqBTe2uQuJUdRfIrRWktFR5wiYcZMhDZbIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzsADw+6e0jMmgnY/Wtvd6fWnRodbQeeOAml8RW+DNg=;
 b=WMuYMKlK21gkuVqpar5di3+YnmwRW6FmUmmAPgERGddcIRcZS4um4hhIwxk0LWQfbz8Tn0a/MErXxtQ0uQEonLDB+4ufbxgiGbTOA+gA2AIF7uJdQz6jR0B2JVlzToFHOuoVhZTMJJdznguScB5DLiM6LFg17Q8BVPfaxSKwVro=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 17:09:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 17:09:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net] net: mscc: ocelot: install MAC addresses in .ndo_set_rx_mode from process context
Date:   Fri,  4 Dec 2020 19:09:38 +0200
Message-Id: <20201204170938.1415582-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM3PR05CA0123.eurprd05.prod.outlook.com
 (2603:10a6:207:2::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM3PR05CA0123.eurprd05.prod.outlook.com (2603:10a6:207:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Fri, 4 Dec 2020 17:09:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b05626e-9aa3-422f-d807-08d898776c94
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB36161E0EE8ECF43BC4A50140E0F10@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: th6mBM5FwOqpq8xn83A1cLA+Va4pOt43JDXCmzEmip4CNWJxz77m6HhZG3+ooa0ZM36IMkPdCguPpvYnve1qQR/jo5yy0iWrtendI0f0LmSkZJ1gsVnOqSZi7wsHX6z7VxjUzP5uo6ozD3fSHuYxII/cFSQCvloTnurjbOPamIcSEeYUKuf6DcQrB90vP80leK2u679/4FyuLJhcwtVyrMfIOCWDoRDrhv2dPQiL4FiJgGWYbUJtuEM9rZ27wETr1YhfNSFC+SukHCad0e+leZgbN+X1qRViXE6decX3BcbRQJ3chJ2gma0YPXDjvanvYpOFXNJ5BbwclVkI5vU+MtJOEVT2kIxRlKFo22Hqlqg4sf77Zf+jhLzINY/EiBJVvALF2fITI3pJ3S6SiqDXqHetxQMtbxwp5KQaenl3jgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(26005)(478600001)(6506007)(6512007)(6666004)(186003)(16526019)(4326008)(52116002)(44832011)(36756003)(8936002)(2616005)(956004)(8676002)(1076003)(5660300002)(54906003)(110136005)(7416002)(69590400008)(83380400001)(316002)(66556008)(66476007)(66946007)(6486002)(86362001)(2906002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2RqNnNkeOD4+KuCxIU+0S4NCtlqQp0cDYACpWS9hQs44jt3jZeHTVqW+hSxi?=
 =?us-ascii?Q?HEPK05ooK3f8jQP+6Yy7KtMP98UietBAZ11QXLFJHQxW6wfMfF/5Mq+WPGh4?=
 =?us-ascii?Q?HF9xSodlxuyreChn4WJnAC1Gvj+FWWyfbCIOwPVF2l06oJbD7ZrnLmP82A12?=
 =?us-ascii?Q?VIr9Xiz8jpGRRyF4XMaDgJzuk4dKGGFMUsNL4+2bnoNcOhJ0I9to3H9pNNb+?=
 =?us-ascii?Q?yeovm53fiIXzDWlzEjvuwgjYRMn2Jms3ABhhM8p6BLzCZuts0icR35vlxB63?=
 =?us-ascii?Q?gYd5vyuzVXODMT9EO9i9nYYHN24tGTYXkX4Sj8OeJBQ6YL5V7w6cpNY7e4G0?=
 =?us-ascii?Q?OlWX34QWtu/bVFYnQ+kYdcF1D6ctKql6+TsV67Yk4hwBUuyDWdjDlTISTv+L?=
 =?us-ascii?Q?uC1da6k5CPjCHiBOB0Qy6pyioY7l37poa+4iyWVdW3VeQnVobxzPEAkoJKic?=
 =?us-ascii?Q?a6Hb8yN+NFiHQREtDPFK0r54fxww/T1iTeLx7WcgCjZyE1/EwfbXN2C3kdH4?=
 =?us-ascii?Q?xEfhGWy6txe4NofXSBSo/HmVHV+9oTvT3xjluH1aSvwcpKqzmey+SKK7KyHQ?=
 =?us-ascii?Q?+C50YRkp26Q20UEnTHJ5FbjVMic6zMmhaQQOUqnaWzlg7RVjaeUDCHbQGavf?=
 =?us-ascii?Q?DnpERxCk10ZorSR9Q2oQ0gcuhH053yH9znXfHSoL7npoKSlY1LuGU21+/qut?=
 =?us-ascii?Q?y8o+ifbwfgDqcx2xmiM7XCOyT+WtepvVZdjDc2wK/iQ1nPqEiXCNYHUAwwEw?=
 =?us-ascii?Q?MLkAs7+0YD2Q5fGrixD2CHLEFrDNLr/seLpswyWAoII1ceECtxxQdbJaTkCx?=
 =?us-ascii?Q?T1NT9bCx/MS7AH1q6TBl4IhoHjmpqn42Cd+YoEvYSFLiHa8Uqn7Y1C1ydeTO?=
 =?us-ascii?Q?+WkFpFPYkNyn7vFGWWNSUVAo3WwWJaw9Y0MrLRkp4xbqR9lj7EXYmyvO4p7W?=
 =?us-ascii?Q?fFYIjxSsP3hAXSC7hEqYFh/H+NhF4FHqzrhjTAU43wr90lCZ6zl/qEpP4xtw?=
 =?us-ascii?Q?bt5P?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b05626e-9aa3-422f-d807-08d898776c94
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 17:09:56.6407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTbu/6g0fZYQTEDDHV3rztSNg7A0wwNuSwTUBG2bEaahJJWsZQWn6/1cTQtEuUtMfcl5cDc4I2TEXRbQlRqt4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
a very nice ocelot_mact_wait_for_completion at the end. Introduced in
commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
wall time not attempts"), this function uses readx_poll_timeout which
triggers a lot of lockdep warnings and is also dangerous to use from
atomic context, leading to lockups and panics.

Steen Hegelund added a poll timeout of 100 ms for checking the MAC
table, a duration which is clearly absurd to poll in atomic context.
So we need to defer the MAC table access to process context, which we do
via a dynamically allocated workqueue which contains all there is to
know about the MAC table operation it has to do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 81 +++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c65ae6f75a16..2f536692d61e 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -414,13 +414,82 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+enum ocelot_action_type {
+	OCELOT_MACT_LEARN,
+	OCELOT_MACT_FORGET,
+};
+
+struct ocelot_mact_work_ctx {
+	struct work_struct work;
+	struct ocelot *ocelot;
+	enum ocelot_action_type type;
+	union {
+		/* OCELOT_MACT_LEARN */
+		struct {
+			int pgid;
+			enum macaccess_entry_type entry_type;
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
+		} learn;
+		/* OCELOT_MACT_FORGET */
+		struct {
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
+		} forget;
+	};
+};
+
+#define ocelot_work_to_ctx(x) \
+	container_of((x), struct ocelot_mact_work_ctx, work)
+
+static void ocelot_mact_work(struct work_struct *work)
+{
+	struct ocelot_mact_work_ctx *w = ocelot_work_to_ctx(work);
+	struct ocelot *ocelot = w->ocelot;
+
+	switch (w->type) {
+	case OCELOT_MACT_LEARN:
+		ocelot_mact_learn(ocelot, w->learn.pgid, w->learn.addr,
+				  w->learn.vid, w->learn.entry_type);
+		break;
+	case OCELOT_MACT_FORGET:
+		ocelot_mact_forget(ocelot, w->forget.addr, w->forget.vid);
+		break;
+	default:
+		break;
+	};
+
+	kfree(w);
+}
+
+static int ocelot_enqueue_mact_action(struct ocelot *ocelot,
+				      const struct ocelot_mact_work_ctx *ctx)
+{
+	struct ocelot_mact_work_ctx *w = kmalloc(sizeof(*w), GFP_ATOMIC);
+
+	if (!w)
+		return -ENOMEM;
+
+	memcpy(w, ctx, sizeof(*w));
+	w->ocelot = ocelot;
+	INIT_WORK(&w->work, ocelot_mact_work);
+	schedule_work(&w->work);
+
+	return 0;
+}
+
 static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_mact_work_ctx w;
+
+	ether_addr_copy(w.forget.addr, addr);
+	w.forget.vid = ocelot_port->pvid_vlan.vid;
+	w.type = OCELOT_MACT_FORGET;
 
-	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid_vlan.vid);
+	return ocelot_enqueue_mact_action(ocelot, &w);
 }
 
 static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
@@ -428,9 +497,15 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_mact_work_ctx w;
+
+	ether_addr_copy(w.learn.addr, addr);
+	w.learn.vid = ocelot_port->pvid_vlan.vid;
+	w.learn.pgid = PGID_CPU;
+	w.learn.entry_type = ENTRYTYPE_LOCKED;
+	w.type = OCELOT_MACT_LEARN;
 
-	return ocelot_mact_learn(ocelot, PGID_CPU, addr,
-				 ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+	return ocelot_enqueue_mact_action(ocelot, &w);
 }
 
 static void ocelot_set_rx_mode(struct net_device *dev)
-- 
2.25.1

