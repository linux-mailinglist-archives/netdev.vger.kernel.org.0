Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC3459A51E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349302AbiHSSDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349992AbiHSSCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6556C775
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leLTrNTf2jyQ8iohz472yMwrEYgpVhJcZFWbAuRC1LftIFq/mGZPOVpv3cPT+HVQO8ROCSZSQMrd9nywZ1piAO1fKBFkmNZ7i2ViP17hD4KNXYBSTG9uwKa3KJ2v4lu8PPh8SMqSV6y9icweXhlJF2jgy/f9MECl09+UWSDW2b9LvrrOPMnS1koC8c7QwmSZf4ld/nBwU63pqz3m97FubBEXQHN3bZjOU/YLfvpAivSe8ejt1AmZXnDEVJgtlNhJaHB5NS5VyL6Y4AMzGB+Oawl64vO30PyfQpQbf1InDswODMoRMtuiMxXNJRUGAsvuU+SpKXzD7sDf60UqVnN2Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvDJwk52VI0HJLiHARNEAQJ2uUenwFexjDBMdN1Lpos=;
 b=T0B3J55Vod2MGI1pWGH7bQRie5KlXwOmY45jN34por9+rHnhaI78MJkPvV+NZiaUkTJEHhD25Ko8z/FmauaoL9YTG6cU6FQvTzdvW+2fvkV+uoJMdFnYdbGgtIMIipvEohmCmEsTdROuf4fXWgs9vKpog2fQ8Gwc70D4iJCoRBkxtVAtxYqOYuzJ93PjG7usPpK1XLj7qQHNRdWfYfgadNm+Ee6ZCn8F8KhefBLK839uqg3CF7BYdAx8xDsiD95NZaVh1YX29BKQVQJrHN507MkYiqs6uUB09MlhvLR/sMtR1Vt6KQp3xS3+NcitqVCQIWscxdRsb1D4CQnZCFOuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvDJwk52VI0HJLiHARNEAQJ2uUenwFexjDBMdN1Lpos=;
 b=FgfyFyJQEwnwqRf4cl/IL6WWwi1EC4EDraMijy88/mSsyOdiA71+25Hkob+VI28/pNaOzGc2/QV5c4vCEHfQ3j7aEFN3wyoYdnDqZ+rAXaO536bftoSRl1WQDwG8ZRO2P+tp5mKQmfILRWa06VGEV3FiXVhbvtv6/Jw+w6k8rg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 6/9] net: dsa: all DSA masters must be down when changing the tagging protocol
Date:   Fri, 19 Aug 2022 20:48:17 +0300
Message-Id: <20220819174820.3585002-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 932bd53c-6ceb-42a6-f7dc-08da820b0c1b
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCYN9AaymEev9ynCFT+rojVHxGL35917WzNTwSYQ93GeeX4wp92vmmYrKBN0LNQFOxQfQybdN6nWZX4hsh515PlIEZpdhxAWsBxCMDz4phWimB9YwowVcWcDlHAvawKOsqsO4F7Xc6DAYtt5nzWV4T6trq5gI9ugK8Zz8lY3w9QxAMOLwCROUtmCciGm8dK0khbk82Vk7JsjAkk8WKmIUF8/pwsnjJwYO7wOE6zBrAkOPKoidQb/Huw+Dt8GmW2HZDcupewojhTHCGcLqXEjceu8+jvQ4Mwx/8wIcWpQd4TDu+jvFPktg1GJgxKoajb3yo+TGrrAxRjgMrr3EkIYSvmSqEOfeK+RxlfULID4zdJWctcVw8mS/BSkQ2enScn/67BwlSLqCaX3djJxTiv9Ek82ZJIuS4IbJx0QvOsydhG5pcHacg510wtK6BzqKgReqgAGsAAPSUiJ/cX3cLVs2063oicg1AGxdhlvdfEec0hywb0SU13f6evxCKElaTcrKD4+cdc2ZR0iOB8UL2Pyc1AD/gyEIuahutQWuy/6XJpiaCRqTAR+nMoKWAdBgNp46rPKL80itRCdxEFG6Yg//ISgfiEtcz1bh93Bm3aqRTB8jub2p9hV246iwJIGkoNyTZRXana+es1NpDIcQWl6Sy1+2CrGvxiGeDObsgmc5KJH7irANEHeW9Qn4Un35hD5ScXZDOxXQTUhZSoU8XT4ECtjnevVpq9XJ8rDE1RhcczrbchmocTvidOuwzr1WY0Zy8wkCSwGSBMEeKXxtd/lRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DHTi6uWImou7AhwvJF4fLMUVAh2//ro6dVxvxvQS0oT9+bmjFUsaTHnHsdtl?=
 =?us-ascii?Q?PdrYC7OmVsZdnKnE13TyD8vnswMWpzK3Zd7hCT+W3XhZ3+6/qwL0YfbNaKZ6?=
 =?us-ascii?Q?YtUYNNF8vKmiG/6bmJL5QLBlJQ0e8rWj9cfjmDz2tfaUMenzbiBqsvbd3Uv1?=
 =?us-ascii?Q?uNVtI2pUkELEoLr7hQKi67sqJi7ZQZzUravZOdhy6UXcnC7BdsQfJfS3qPVO?=
 =?us-ascii?Q?NTmV8bn/ePOVd3q45jggiO/JhWc3KggYRttCfJFrWFpkvotiGOu1c8DB5r3y?=
 =?us-ascii?Q?ZAZPIW5pj409czMF7AvVgQdHgC0t2z1y7LafRDCImOEX3OGwdaDX6+Z1iCXE?=
 =?us-ascii?Q?//xrNld61EYthDNTrguxXX+3pZIkDF70mLcjeAAVft5vq5r/OHj1eJpS82G4?=
 =?us-ascii?Q?KE8fQDCyBp1FNtKBYA2LrEbd82KApScdfeHM3+1qJT5PpAz/6dDW05LSXejp?=
 =?us-ascii?Q?LQ6G3t8WcazNFN01fUz3uTVwfXxn7JmjbDBDe+FFUKtX00dcPgFPUmuqphgw?=
 =?us-ascii?Q?WRGxr/2o1Gm07QeeF+S10X30hgTXzCIvh+ZFFXkrl8jPaJuRCwupPbe0A5Lo?=
 =?us-ascii?Q?txaHhXUk1tRtA+XF2MIHGQ26w4EPPxaooPPfdihqj5HRrW2WPyuyCk8IfNi+?=
 =?us-ascii?Q?XUazY3G8oqWNj18OUPm0L+0f9wrgnka8nJ+4oTNT0n0FQXB7kPAM6bUj93CQ?=
 =?us-ascii?Q?34wyaRZOc6L/rBAjYIwq39ZVpiZUO79iedMAzk0Q/XoW63WpG9JnfE5VJTCh?=
 =?us-ascii?Q?rIBwGCtPOSqXe6A6ZFEJ0MCXdo477GeY34jJS9DnHZ+nUsQ16WUHel9rgWOY?=
 =?us-ascii?Q?yDJT56RnTSF7a5gJPY0Ox4uQJWimXIRci4TL+N7kyD+JCBpTWIrpTWHG+/3Q?=
 =?us-ascii?Q?Atnu+qtwaKUAlyLrDYh5A7UDfQd0Zo7Qh8KD5PVfzp8arNTJjhfyyCGSjhZr?=
 =?us-ascii?Q?GWBkZd08feb1U1FL7TrPvl8Fw8AqHSbpgzNhZyN6+AiuLpFORUGfNNgRSfmv?=
 =?us-ascii?Q?1M6GjcqclDL4XtLXXTqysyw/F+NsxeOPG0nbWj/KMCbNbiQPRMmx8H0l7anl?=
 =?us-ascii?Q?vjSgr3UvTcYmpTRzPH2y0SqPMlAtfUgRSy8V2P7vCxi0DhqoPK6Rrx4MAk5G?=
 =?us-ascii?Q?uCJFVOZDeVhWSSm5NIYahBL0s/uQVtnI0wS+WEcJRgMs8iGRdZcnETGtkjg8?=
 =?us-ascii?Q?uWuBYeFVuQHdim2DM8rvyVw7yuN/vW4oHC3lWsGL27ejCeFXLrAKy+7sRwPO?=
 =?us-ascii?Q?tXx63KKglA+lKmMC/Rv9jDUXgoXs4izxlCd5I3zRK1gv13JmcUavha+yFgfG?=
 =?us-ascii?Q?DZI0moO+IoUbF//jTutUkhnikLnU6AyvR/qrVshl36d7R8ULern9DF2IDbT6?=
 =?us-ascii?Q?7MVa6sRhRyXBD8ZOsmR2rLyVmm8bjIqW41BZR+R8i72bKZtlOhPJttPUGc8L?=
 =?us-ascii?Q?YxLuaLmN05UTCD899rlqvfW1XWnwBDKf315w9UF/XpTaJxtevv4Aa6eMnzqe?=
 =?us-ascii?Q?eCN7YNEhiF1lzRlF32RHNZ3AFmYQhvUXex06S8HXFPmEjc8AaN6CyUYQUbwx?=
 =?us-ascii?Q?9Oynb4UGvPskrtwtKXv0jsSWXAIAkOTqicQ5v4wAaTmqhmbFxIPwh7spWGN/?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932bd53c-6ceb-42a6-f7dc-08da820b0c1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:38.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mE6zTSu0JRGqJ1o0UR7AI7feL4AdqNvqpTHny0BuXzYZzc5qtAmcNtsz7G91rwGCsQXMsdXj8t37h2spHANJyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fact that the tagging protocol is set and queried from the
/sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
the single CPU port days which isn't aging very well now that DSA can
have more than a single CPU port. This is because the tagging protocol
is a switch property, yet in the presence of multiple CPU ports it can
be queried and set from multiple sysfs files, all of which are handled
by the same implementation.

The current logic ensures that the net device whose sysfs file we're
changing the tagging protocol through must be down. That net device is
the DSA master, and this is fine for single DSA master / CPU port setups.

But exactly because the tagging protocol is per switch [ tree, in fact ]
and not per DSA master, this isn't fine any longer with multiple CPU
ports, and we must iterate through the tree and find all DSA masters,
and make sure that all of them are down.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v3: none

 net/dsa/dsa2.c     | 10 +++-------
 net/dsa/dsa_priv.h |  1 -
 net/dsa/master.c   |  2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..b2fe62bfe8dd 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1238,7 +1238,6 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
  * they would have formed disjoint trees (different "dsa,member" values).
  */
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops)
 {
@@ -1254,14 +1253,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
 	 * restriction, there needs to be another mutex which serializes this.
 	 */
-	if (master->flags & IFF_UP)
-		goto out_unlock;
-
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_port_is_user(dp))
-			continue;
+		if (dsa_port_is_cpu(dp) && (dp->master->flags & IFF_UP))
+			goto out_unlock;
 
-		if (dp->slave->flags & IFF_UP)
+		if (dsa_port_is_user(dp) && (dp->slave->flags & IFF_UP))
 			goto out_unlock;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..cc1cc866dc42 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -545,7 +545,6 @@ struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
 void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2851e44c4cf0..32c0a00a8b92 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -307,7 +307,7 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 		 */
 		goto out;
 
-	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, new_tag_ops,
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, new_tag_ops,
 					old_tag_ops);
 	if (err) {
 		/* On failure the old tagger is restored, so we don't need the
-- 
2.34.1

