Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24874298D9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhJKV2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:41 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235262AbhJKV2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxqtBxGAv2VY/o236mf6cbJC0KhIwzhGPEuQff18k2RPXoFLYoynyA4o2e2Duiu1lWCp3klpxeyUm5HJ4LsFo+Q0X1/z+aBzSklpbBA/bo3cu+528K+yGZTCADXQ3L1A2eCCFJiTsyKARfZP8prVKu++dtx4frLxzoL/QPBM501Ywc5YffRAK0lfEaF2rCpr9z0yW5nDVtHIy5DEZOaWX1DdOsGOD9ZnFfEa2gpDdUwideurxlxheoUEwjT+h5vkHKyrKS9HuEci+mBloC5jU6gITgPvZ4TMWje9uImHnORGaBxH4l/QjsIMTdcgdT/oTPzKIL8Q2Ng0lW8Yc1r4Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwM4AH+IEj/9QiA/GBAmeKewURmAyta5b4JXCGor13U=;
 b=byNr2g6giOr1bgv946A72KT13ZvvfS+JjZLZpqRDL9zoS1emCYRCSF9m9eOHszBDq9pFYuwevWo3S2bqU+irVWlqvDO0vL37d9UwosKGIksIdtKNzzXwUCX26LTMb86puXAtFFnE5X6BOvV3O5CWuJ3T+6Lc3iU++lJ9WyGqOUS5BtNN04qGLSb1awiwEtmKIZgJKiz6Gxn71uw3VPvnOOgBCI7fmMVTMKCRmg1daCC3HG4JxHIhyXmGbaDAhRV8HdM1uerZ/8Lhrk0p8P15hg40IIcWbIPaDozF4IwG1a+bKcYrZG1kf31Anvt2z89DyKlQN17ZKesmspdTl6KvWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwM4AH+IEj/9QiA/GBAmeKewURmAyta5b4JXCGor13U=;
 b=ZEtunk9htVUTJO+2gjECAFZcwCB7bCqoTipynEfDPcF2F//R4lhbA1Cpm5CC8wxXUm/Jlnl0H8zw46x63bgMp/o8VufreDUCJ73DM0ndKrBo25TQG/OoQDwdqTIMw9s25zUNnIDL2PpaQekxifpI1qGfW3S/lSh4hnGtFVLJEHA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 04/10] net: mscc: ocelot: deny TX timestamping of non-PTP packets
Date:   Tue, 12 Oct 2021 00:26:10 +0300
Message-Id: <20211011212616.2160588-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 528e618c-f62a-4ec4-fdb5-08d98cfdcd63
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB67037D4C2B6BCF797315AC69E0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTAbOuV2SiLXe1smYQosPQtvpEwx/NJH1Nm1G0t8+TfwKrrqW6VYMCZQiu9PhItFtl1eWzys9d2zS4X87mL2nv8HbqnUVd6Snk/wM1h6bSQxwWXYLLn7O2K1mo8JhSKpGtqYxZx31+xuOVO0DnzU1R2A11qOHtYTKergs02jQSFc74Nm5i9zEO6R3AAlA81j1VdAXyCCiim9UJkirhbFhiHfziXLQCmyxNAPMCiBheqAP2ot6JUTtSFqreoSf5/TEMZQXAAT2i7/KR4PROKw93FS0A7qkYVRpJZ9yvAxg3B8IytvC9a36IFQT+7ovACeYVh0jTc+caB3L7+4y71ct9x0DTM1XaPGkAjCWEstQN1fDmDyRyPuWcYtZ28tB3X+CxO1Mej/uzS+NmrUWJ9VkDeFqD8Z9eMF6Fs66p0qcYc1hRHkvA+jOCExrEuCIQZxhR1yRb2ZYumRneaZWZxFNf/0yYx3bWdRKRP6iuLEauzq0jRGs6VASm35V59pX2cpXTLSio9vmJ9DC8ajPB+aEjUZugxwAgsltGBU44ItELOxDe84Xnsicc0dVgqJMOU1VI/f2dX6gdF3t1in//jVPb7OGjTGZw0KSINNpRPx7VpSaF5fOPpjzZOq2GrWdHghk7YVNbxyYJoW47Z6yqQiN9wVx0eaR8qr6zgh5yZzNOXzqOgkdqdnqm4yEs/ISG1ODvEFYAP2oZPLZGfestQkbNMwLZvQstLg6U8S242u7Fh56Jhi8p/cTvCp9j/ZX6Uessxw+CeQOCCf7aWiarflXWMj1qEWKbdyXF0GbK+oQAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(966005)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GUAXwAklHug8C9Ev2YRaXHLZxDwa1jMsUpI/4NPadJ77AMdim5sbxpduTDAP?=
 =?us-ascii?Q?rrAeF4wGdiJ/zQKCWLZA2onHpv7E9ycpDO/wLPyO8oqTGcBVTcDBuhvGIAAU?=
 =?us-ascii?Q?qmcPndDB1TOkhQNCBqYOTPB6yO10gyWPEe1lklxoXgrK4XoyKA6qt0KQW6FN?=
 =?us-ascii?Q?8BD0JX6Ji1k2z5FJl9sZ4CDki1g+B48NWNnSmYvVcOWkJ+YM7Blgh8t7vewe?=
 =?us-ascii?Q?cWufV6KumZG7Vr9/swAMpN3GGBwjkRV+VqD4IcUNGOxACS19O4VV6IcabSDF?=
 =?us-ascii?Q?c0vHbaaTY7lxJuCR807Misjg6yOjSnLBOq3KQNUC0dXft1EFfLnah5UyKp9B?=
 =?us-ascii?Q?yRhPgt/cDY2DrFFcRKkjEx5hk5l7BOE8iGNm3EkWQ5VPa4qLibWLr7SDeSaz?=
 =?us-ascii?Q?P6wb8UuaRCHhendFsJUaiZKGZ3u4CQNEqAn9ous7SiLUR5jVh5Lsfk17EEUQ?=
 =?us-ascii?Q?betJId/+wF12aHGUcikF5wYSEwzki6luHVQjWnC/jCoH41UIWatIixeOKexT?=
 =?us-ascii?Q?Lvms4/zg/2ohvYbw7W7RuQ5uEW59k12vsrAqwuGnkFC9vJrjUtf2rMYRS+Wa?=
 =?us-ascii?Q?aWxPUl7P5Qoxw/eXEdreCrsCf0SI3wWDVVB4Y8ZVFz0FwRqrpaJctXgjynD9?=
 =?us-ascii?Q?Y7VazM6PTQAG2QDSBsVpbBELtsZxDux7aME6gQnyAafvc7XHdnYXcgkputce?=
 =?us-ascii?Q?/Lyj/EZ79MxRqc+uzaTOuMtlzHJ+4rgB1dYIh4Vrtr/D2j0/N6LxoKCPESg8?=
 =?us-ascii?Q?A8HbNEsBIFwVRwcrerimeFfUlibQ9h0SYaHg5oBeF+PPG5KFWZMptxTmuMdU?=
 =?us-ascii?Q?VOmZDnwb53Dm103IDUTpzhZ7LcPOzJoYgaBrWLu9P2RuUZYU+jrqoTf6NYx3?=
 =?us-ascii?Q?1a+lSO1hXKaOBxbKvdP1Fm3RzDulvPY5FONlJmZLjEDxTfSvh9WoDsx0jgie?=
 =?us-ascii?Q?RnILxN4z2U9MXSm+TXNuCFJlWxjvl4KwUOlsgvTWpjP3J+uPLFpfm132iLMN?=
 =?us-ascii?Q?aYOx0I3ZWpM7WxVtbLva2Ro67+bLdsQiyaNpUlblvU8NB6y4Km21VBMu1Yea?=
 =?us-ascii?Q?UnNmnvdyeO+dYUfyq8tgZgyq57AFecb/TIXCJCL8z4h5X3+jIstKqf19Mu3v?=
 =?us-ascii?Q?vhiyjYp2GYn8CY/VuMlUTHvlFTlf0/R254xReK5v7hLlvG3K7XL8gLaHKIHz?=
 =?us-ascii?Q?t7/5hY70JWQ4yjRVvkOwzPPn+ITVLKmh8M53SdONc51Zk+hYRhxspYwP3Gem?=
 =?us-ascii?Q?Ynj7uAAtvtwCwKLak7iMcCWC8bpcCn8/G4BSF4nEO8GYvwRL4+K3RUhYVF2l?=
 =?us-ascii?Q?hYS9twTkZUVVYWJ4CdnOg8Yi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528e618c-f62a-4ec4-fdb5-08d98cfdcd63
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:35.1691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 059QvUJuUvdCXvA77110MHDAqPCaAIjhBt56Q3dWU1igVS2bVXcvGT0+pa3cxd2rZ1jrMGYJ9UZwWJeBCkklcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that Ocelot switches cannot timestamp non-PTP frames, I
tested this using the isochron program at:
https://github.com/vladimiroltean/tsn-scripts

with the result that the driver increments the ocelot_port->ts_id
counter as expected, puts it in the REW_OP, but the hardware seems to
not timestamp these packets at all, since no IRQ is emitted.

Therefore check whether we are sending PTP frames, and refuse to
populate REW_OP otherwise.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 190a5900615b..4a667df9b447 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -618,16 +618,12 @@ u32 ocelot_ptp_rew_op(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ocelot_ptp_rew_op);
 
-static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb)
+static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
+				       unsigned int ptp_class)
 {
 	struct ptp_header *hdr;
-	unsigned int ptp_class;
 	u8 msgtype, twostep;
 
-	ptp_class = ptp_classify_raw(skb);
-	if (ptp_class == PTP_CLASS_NONE)
-		return false;
-
 	hdr = ptp_parse_header(skb, ptp_class);
 	if (!hdr)
 		return false;
@@ -647,11 +643,16 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	unsigned int ptp_class;
 	int err;
 
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return -EINVAL;
+
 	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
 	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		if (ocelot_ptp_is_onestep_sync(skb)) {
+		if (ocelot_ptp_is_onestep_sync(skb, ptp_class)) {
 			OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 			return 0;
 		}
-- 
2.25.1

