Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149EF4B7699
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242113AbiBORCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242107AbiBORCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:47 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE8111ACED
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HN2LKPb2KBmdRWNujQ3bJIhPcpxnB7E9FU6uUYFXXnN43g9OSyh3qLew9ZKsUl/Hf9BnlRTcDuZSU6XyhRAUQIc08l/J7uDc+837HofVKth4/ZYU3IdVbD9KUMmpWjQTCtsuISWmUt0g/+23pPgfQ97QVo5O2YAUdZVjk379HdqY1W8MWZiNPld+e/bFg2F9pHRv5702cp6F2SwslgoqADF7tph8cdj2IYcl/682m3/uZ/GFKHD5W71SPjdiW2U08anj0EyuJwqHeN+d0PxNHMDKwWpdiSRb0n1QTuZmvZ4j+hhCtTAqglbpUfdarX1ZqyxUJm3Aqjd5da1nP/6kvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAEBc23QHL5AurerQ9DQ9tQskKNvfZuZx+NnglEJRjw=;
 b=ltGPQ9oEfaovSM7DY7ZvloyQSkzJ54uiF3DcLJkZaXmvGOi2VYLkS2aE6VAI2zidv6bLrl06cSIZ0MYFdRnhFNxvHqRS88MigXkTSN4EtwZ/FVmpbkyBCeR+4aoISu4DNrOYpGA1ph6/7aXF4Acw228ViKA7Fd5c7qRWzM2S6JW/aK9++p+ApItJtXB/NZNN2fbGD2MjisCB8o35IaFl43TX5BvgywaCS/iOMvOxLPZwsvmWIAqeWdXCprkpHeIlbsPtf/srXiaDxB9Kchllwtia288OF43Y1y2xMxTTtJyhH3dnuXAGiKfHdLAWrF9+61Tc8/KvZQGC0HWMNeuD3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAEBc23QHL5AurerQ9DQ9tQskKNvfZuZx+NnglEJRjw=;
 b=L7Wfv/LyLtauD+7Un/pZjnC5aKavQrhQIF2vZgigS9RoMIRVqVJ7GsLqIT/oVqv8GEkkzvA45dIfYrWToFSnV4orl3c858+SPT7CbJV70VFnV6lZH1HErfBQvHJ/ock04Mc2MjeQbWnfpaAAlng63DkHmsz2zSMEm9Wm/etS5dY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 08/11] net: switchdev: rename switchdev_lower_dev_find to switchdev_lower_dev_find_rcu
Date:   Tue, 15 Feb 2022 19:02:15 +0200
Message-Id: <20220215170218.2032432-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ac6f5cd-8332-404f-ed3a-08d9f0a4f4b6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB53422366FDE55F55ECEACC9BE0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWb8vwmro9cxUIYRrJiBdXqgJTi5/gf8apWIIhnP4osLOVoaNpkIHZhWCWZznho+/w7OwZJMxOAv6QdfySzU9ME8YqbfHBBWomnXRa8MA08X1Tq9cvQIfrII5CN3C4f9Klgb3jnzhXb2qwY7vj7wtUZ2iIM9c3SRoWNRjHCqK5vK/Ey/wIL+13EEamQZfuDZOr4ruDyoMt/JCd3eN3go16Gy/aF7UfKa2ZOxcfr6jSUdy+pvrfUzLw1NJ8NVWvAe74Tywm+AYUxOdFWlmInTQf7UcS79IrmePKW9sAVc37rEgjlzJahTC2T1w+Q9e8TbpcYz2wBPdLbOMxsrsxn4lO03yissz7a24f10LtGqgw/6d6oWSXvYcuonBca488LFCuUGFx/NqlDUyWNTXAx57Ls2ytoK+EBxUjFgk7hRdnBXSRQUrQfFmC/ZpOCSqiMrpm9hIprLYvOazrK1AL2oCwqFCO+4tR/7maGGAtHiWjEA4tUnAAYPlSOi3P1shERbRspZZ/gpZicHYeHPslq5FYjkxLUeDg1REPQKwp6V1GXuu1DQQCIvYy0Pp6kFSVV8XULl7j0HB5kxgtO+5a6R81D7h4TMDXnoRt7wwTjdx7epddq4lL7ZUNfvdyKdOEifQkDtcv0pyX3EhK8K4jPMIdLXOk656Kkqva7ZNkty5wTeBWOlSR3NpT8TLCVm1vG10L4wInGmSJO58bneqsl50A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ltmwIHRDN54+cUHC1Z0cjIR6m2G3Rz21NiIXpuiPImWsIF/K2LkR2AItOEa5?=
 =?us-ascii?Q?bCjej5zSR+8dJ8hBdAQNqF7PRH+qMsPUt90I7yGOZpFt2v36LcHdAt49VBoM?=
 =?us-ascii?Q?YjaDGeph0ERhop2uHE2Wt4WsTRvaDXz9VJry4ltVUEH4HAwVHmfzeYFCsBtV?=
 =?us-ascii?Q?Sy3bhwIFyJn9qwoEzw1cx+E5Aw7MV9QH/SLhgUPwven9NrzvMMnbfHzsky9+?=
 =?us-ascii?Q?KasXQA29TuNtngCyF0EOjPEEiZU4qh6V51MZDeN/WmqSW0ZoDjWZQQvoNXTC?=
 =?us-ascii?Q?bprFuZEInJ/VFRkFCrrQMy6LGkAyMcAzttnst3BzK6tdWHbbw2fGpx0AgEeE?=
 =?us-ascii?Q?LuFTH/9wH4nexXmKrPdxG1iTY7PhPt2y3rgZ5MPmKpPZ1OQXUZzXh1tkYZna?=
 =?us-ascii?Q?/IcFZ96M7g95wpqY5rU/eo0TrDmBOpw6udF7Fa/huPJ8OlgynSJkO4Bztkd1?=
 =?us-ascii?Q?52Bc8db09XVyttUGJeCcikqIDqKdp/AbrFCgShZHBH50XjW2JjHsNEniDafg?=
 =?us-ascii?Q?3n7Lm8PO/bY3xZFL3bL3+iDlzGOvaTc/eYb6Ew1pP90+GgB2JiPheuo+NsiU?=
 =?us-ascii?Q?JSMgWLy/FHDX1WivRaFDp+PpFBQal1yMqV7/rqHDpMT6v1iGMpr44i+YlJX7?=
 =?us-ascii?Q?W4lT+AkjdFa4NnREF0nEgwjZtppyZ2Dm1rBlgwXf+jxx2NxXAi8E6Fo0JKQo?=
 =?us-ascii?Q?B+NBZey+WWsVGdFXTinh9o2TXjosX9ObD7WyW1Zo3f0JoaHrLdrGiIjVA22O?=
 =?us-ascii?Q?O6B8F24LUyfo6bnd8Vea5y6Pwk0hoH9u53LV9zn35aj0KCG5J8OLrqoUyVaZ?=
 =?us-ascii?Q?R3bVkaflMp1K95BcT6u1kiy7yo0NfrDtObiKyUofWopghKQSgD1X7mVspEkN?=
 =?us-ascii?Q?BwRRkk+LEEGT+16eaEHrc7/csxsh4+ChRTjfpBK6TuriWhDb9CgPD+8/z670?=
 =?us-ascii?Q?EeIvUl/dmSYdtzSoONdHchJuHRKauAs7hM5mTqjHOl0a2yvM52UJ2XV4MRqE?=
 =?us-ascii?Q?P/c3SlxplnwsFaTVcWxQVkEtzSdHuuyh5JLvkIDoiO1KYT8f1nWiT3kK4anS?=
 =?us-ascii?Q?YEMyU9p8/vNNw1dE9dV7wY2s9RlST8QvLt+HEhK3p+LLFsymAaFjuO0Qx0TQ?=
 =?us-ascii?Q?5Al5mSpk4b0qtZUR0tqiOkyXLOWpJ4T/NMQN+6zZVuSGgRlTEkCkPD7hCpZb?=
 =?us-ascii?Q?nXql13hzFbTK5XJf3xXyV8uZDnqndmD2uQXNkrPzaqoUiblT/+wz55MSfV61?=
 =?us-ascii?Q?NTZkA8jOblVQF1/elKlttJJ3+dX+P9Hp7OEBuxXJpFGyEqYAvZKWMmZkleVO?=
 =?us-ascii?Q?XvlW5JiduXcBQXjwPPARe/9gybfB1KViOxTBvWxcGIwF1XZRmhrVYo5eEUj8?=
 =?us-ascii?Q?WoqByp7BpxhxgDEAfNxxXDJM0KT0y76ZFpHOdsyTrRSLBA8ll+71qnSXA0K4?=
 =?us-ascii?Q?MZnGSbOLus8HCCT48XFhkjeAH69pckuKPwJajYlLTgiPtorIKCinGpzvjP3c?=
 =?us-ascii?Q?N3JrRcwn3FWdbcOedER5NgCjsECARdxrphG+m4/Yr3ihDblF/Je+d88ldPrW?=
 =?us-ascii?Q?SMqFET1960PmarNQO9HunWHKpZHiUX1PlPpQJpUMn1sVP5x6uHR/9Nabvp8n?=
 =?us-ascii?Q?xgCdCfbAOqK/ATeI+9aJ++Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac6f5cd-8332-404f-ed3a-08d9f0a4f4b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:32.1817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgWWJIOOnnucl92AgCed2wtHSr0mgsjsbpPm/yX8O3SkE1yQz57tQnHb1GdvTeSG7WcW/6mCVSSmMhfG4LTppQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

switchdev_lower_dev_find() assumes RCU read-side critical section
calling context, since it uses netdev_walk_all_lower_dev_rcu().

Rename it appropriately, in preparation of adding a similar iterator
that assumes writer-side rtnl_mutex protection.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new

 net/switchdev/switchdev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 12e6b4146bfb..d53f364870a5 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -409,10 +409,10 @@ static int switchdev_lower_dev_walk(struct net_device *lower_dev,
 }
 
 static struct net_device *
-switchdev_lower_dev_find(struct net_device *dev,
-			 bool (*check_cb)(const struct net_device *dev),
-			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
-						      const struct net_device *foreign_dev))
+switchdev_lower_dev_find_rcu(struct net_device *dev,
+			     bool (*check_cb)(const struct net_device *dev),
+			     bool (*foreign_dev_check_cb)(const struct net_device *dev,
+							  const struct net_device *foreign_dev))
 {
 	struct switchdev_nested_priv switchdev_priv = {
 		.check_cb = check_cb,
@@ -451,7 +451,7 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
 	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
 			goto maybe_bridged_with_us;
 
 		/* This is a LAG interface that we offload */
@@ -465,7 +465,7 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	 * towards a bridge device.
 	 */
 	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
 			return 0;
 
 		/* This is a bridge interface that we offload */
@@ -478,8 +478,8 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 			 * that we offload.
 			 */
 			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find(lower_dev, check_cb,
-						      foreign_dev_check_cb))
+			    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
+							  foreign_dev_check_cb))
 				continue;
 
 			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
@@ -501,7 +501,7 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
-	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+	if (!switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb))
 		return 0;
 
 	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
-- 
2.25.1

