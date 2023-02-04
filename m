Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD41768AA60
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbjBDNxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjBDNxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:36 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1685019F21
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfDmCTd1xfNDmQHsSuxvBWx5O0RCvNu+Dsiq30IQX4Fvg0+zJxBJn6xh44pRqzbCb2G424xk3m+AMwGM+RelsgDGnl2FVz/jsZ0oI37EQiFd5grsPYTimIS21auz0n/7zVXzentJgU7m8nt/7Iw4OtHPSxHXXSZbXBoj+eZRuIDlVuRWIvmVt1J4BVnXA7gg1fuLAJDqNp1E7VwD3NsLm+1pxgFGajS398n6e0Vu//xe1Uy3afCTcXyLwNCGAByvAEvJ0frN5QchTr1K+HLAJSqiJ5cdbaSw8he3ifu12MgUMkrFLBAw+EFIZfprjHMCXijU+ZiVH85Ck7VUcJL8OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqNc7yQrRO/QSkpmYvhOla8lr8eFwxdEii0A69t/cqQ=;
 b=Rt107ytTHfal4iva0Emm+FLBQ+cB5Jvq6ZMf7w+mcLhZJqNAqUEnAywTISyXGaa3onDfx7BNKI0xxx57W8BzaQhrJ/DtUtGIYeMmilJGkKWKGCrT6paXRlttHuHKpi7VJHfFeAm0vrAx0caHZA3GWeOCHUm5XDZoc+ssNaEtJToX7Zru54jLJOW0tzM9nn7pf2wc4WzNuT0fC4Bg5RhlJwTvJ9PoPerOfiEORQQU3E8QyPyLxIQMJ1tY+3+FEvKU6m7AbPsgH4rYByRZUuWoTLl6jGwIXL8jncuSbwrrpSm3FOkR9PPPYQ2EWz9KVFK5ZxmqiNsM5C9P+JC36iDdZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqNc7yQrRO/QSkpmYvhOla8lr8eFwxdEii0A69t/cqQ=;
 b=IwAk5N9ToE7Z1E+wsOl40QwssVAnBm8YmJphP8J5KTCIwOE3jgYVeKwno1/nne0Hs8dCXc/qI4xGCGOX6woA1aAuo9wMxhaY1C20L5RKwhyQ9ZqhEJSYaxtLSLwb84mrIc4/bpXVRhTp8V4gr706PXXJIFrNuEi1v0lz7EXNc9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 04/13] net/sched: mqprio: allow reverse TC:TXQ mappings
Date:   Sat,  4 Feb 2023 15:52:58 +0200
Message-Id: <20230204135307.1036988-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: df161e7e-f200-49bf-2cac-08db06b732e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z39NTU+Bu9FUsxVj+japfAQQDr5LrvewnDkzroZVVKO5viT2ajehJGFb+8bVcyaPBto7GFOkX6KcIH/oqCOdoZt+nvZVLDs0063PnGjuYW4C/9F2wJpp4oeMUKKWSJELrZ3WS0JhCTiz0IltaScQSyjrJuoidZCJ06ddha/99qFA28xxYmQd2tXDBMQTgPe/yGv/9CUt5Fe6KKpVHU/jYXy8nz3lo9PDUuUkQEVpEr5fd+llV+rRHjB4eL1gp5kXp6W59y+koEtLn50sHxqd8LzvlVznmwOj4hmagSS3LA118iBc5xeLXB5BNFl/57gJoBNYPW232YBaLkhBYQ/h5ev2aukp+/x2POqq2VaF5MJN7zzI39VLE0yCSl2kIs5WxD8Lphl9u1h82qmu4ZdOHRFRZi6jRCt7giOe7tbQ46Gb+F0Z9y5GWXkJI0EaFZWfIoMQ9sRe4wALKebJ75SGU8Z2uiFk1TP+tvz7BNOsJny/Mh56HE+R+kfNfoGfYavLe5T5Jbh/1CJU7Xujv7P+v1Ld2sZ+ZKXNuTRV2HvWCzviuhXxVCp0OJzmWp1jcikzDNW1SI4dmcyAI9PMQK16LkOHR7Gk8NRZOOVWFdSd+u71f8E/tctxRnVWmKt97i8l/tQnVnHcTUKLX2wNv60F9VvAzAI5afkmsb6rFCq5pY1wyEqgRDA9jM1yXK0BxiNpVAHxNWNxbLaN/qch/5uhF7pvp9xB3j8GcG44/+jhBTTFxXttkJg6UBD3eJfBQqpiDRgCyIGRnNJZJV15VkT8Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(966005)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pa4HUAsScXq9vU/ggdBdt0tejwA58o78BLbiUDgWnzmbzBxqKbGEBgkLEXl3?=
 =?us-ascii?Q?+sE41bIuVSU93RM+ivFaqG6IiT8LlPzUnxb7BLuubdirMYv6RwhVU9fGtT37?=
 =?us-ascii?Q?ec2S/kzhF2VrOod/6sm23hntNvpxZsoxx+1d9ALE2+gO/00EmGOSDTa3ed7E?=
 =?us-ascii?Q?Wz6yGd1FD/Z9aO347GYh0jXutRCfbXAhFfGR2jNbVFwfiich02eMh0LvQoM6?=
 =?us-ascii?Q?gtARJYUKXC+/H0IXN2YR/y7wli/y6HiWItSdoRH3neN6m1iFc+HIK505T3Cp?=
 =?us-ascii?Q?5PGuU8chudTWwVqIktrGuk8mSKbc5Is8lD0MQicALGcj/oA5EMibDBvj3s/h?=
 =?us-ascii?Q?Cb5mQZfhNhBY3vs4C373vy2XJ6+LGE1Zrk7JBKPufluf4YOSoUKqUpXhRV50?=
 =?us-ascii?Q?gdGsxGLDmlILmhtcxI+JuwsyEvKCwgnS2Y60ECbP5BjjkiJn49ehR8gmFuKc?=
 =?us-ascii?Q?4OQcCV8HnQOisLMXEM4SNKxAJVwsZEqZzLukM8Az+ki/k782Lepo+iTRPCBW?=
 =?us-ascii?Q?LpmxxJc9y/VtyrBmvEw5U5JLrxAQPiXwaU+z7Rgbu8U2psScsbJvbn4EMpcR?=
 =?us-ascii?Q?H/iDoU1DWPHtDWIK+7Zu18MFUbft9S35cB2ts0MTwnuRR3GyashvcgAWV8NC?=
 =?us-ascii?Q?tvmMemsLZ7B3lPl17m8TmNOum3uh+Rk7Oc0ly84F87yGri8gwl0g4/IDpBSF?=
 =?us-ascii?Q?+qISHReC6B6LWiIPIqXfjz4+JyD7mbmBDL/6zaXZ2qKRvL5Hn+5gm26RzPoB?=
 =?us-ascii?Q?k4SAnPMu8DKmfYi76jk/ahHr9WL/PcYlpABSbzHHzzvIpRfKBczX61RT6CBg?=
 =?us-ascii?Q?0djwhXAlTpzNNkaRzWh70rW0f9pwTYMtVgDsmlV9wTUeCjrwn92QVu57Uw+A?=
 =?us-ascii?Q?UccgzARHobHLQHGhU/OfPXNjrGHboovk1LZcaoySP7Z2p7BktFEDVTwQ4gWG?=
 =?us-ascii?Q?ULCYOkkFVUwLlgDRmjU1VaBm6Sr5GMnJeSW2WMC/8CBZCRUv6H0/Gr+HETYT?=
 =?us-ascii?Q?62bHPu5FkkRvANmiRUWAbsxbgN5dAYcc0gVGuxETsVjTiqk0KUl7JJxrssR4?=
 =?us-ascii?Q?pNkFtNnoQOwPmQvFKr1OueOlvdWVq6tMGstA3LOQ8I0EcIFm2FkoE7NHDECz?=
 =?us-ascii?Q?GWlSR/3Nhp0phpTzuQdumzV8+7G2u9SzwEH0GSUyTqCmzaC2JeoYv85GNmwQ?=
 =?us-ascii?Q?mi7ZszZOmW+j9in5RZF8R2OBtMC3Iho9gYk7vkYnVusr6bExXZpHiSjsg56M?=
 =?us-ascii?Q?tCI73vBd3sNfAis9YnPV6pu8m5Mbny09hTdgRlUOOvnx5zVaEtXhT40Jw5ak?=
 =?us-ascii?Q?T2M8VCjUJKn0zoC7WT/olv/G2O1pxYBcT06l51X26bQ46tsDhrog29tQciDp?=
 =?us-ascii?Q?0c3QWtmpUudz8tBJv2gOqfZ2k1VTfPqnL+jFT370XSmqHnIALHemsgRsvFKH?=
 =?us-ascii?Q?C6vYIlmUYGlE6Hbk/YWnsKfKR3njWgV5lxemSpe+FWGs5QEVx2h5/qiRHS2d?=
 =?us-ascii?Q?5qHc+pBrOXKI2g22PnH2M2nGbVC53qTHL1tjNr/IZF3kN+wsPjVl+Hdls8vQ?=
 =?us-ascii?Q?5l+QtaGSDbuJG7zdjUxGKJR0kFE60W6TjWolbk3TSpzKOUdNAf8wcVtBTdEz?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df161e7e-f200-49bf-2cac-08db06b732e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:30.9040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+PKlXb7UgfmNSUOVSa4U5Zr0yiuhZgLZuxxCRO3PFAndhnkkR3SPCPCLU1eL7ouN0Bk3osUicqYqJGs3kAj8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By imposing that the last TXQ of TC i is smaller than the first TXQ of
any TC j (j := i+1 .. n), mqprio imposes a strict ordering condition for
the TXQ indices (they must increase as TCs increase).

Claudiu points out that the complexity of the TXQ count validation is
too high for this logic, i.e. instead of iterating over j, it is
sufficient that the TXQ indices of TC i and i + 1 are ordered, and that
will eventually ensure global ordering.

This is true, however it doesn't appear to me that is what the code
really intended to do. Instead, based on the comments, it just wanted to
check for overlaps (and this isn't how one does that).

So the following mqprio configuration, which I had recommended to
Vinicius more than once for igb/igc (to account for the fact that on
this hardware, lower numbered TXQs have higher dequeue priority than
higher ones):

num_tc 4 map 0 1 2 3 queues 1@3 1@2 1@1 1@0

is in fact denied today by mqprio.

The full story is that in fact, it's only denied with "hw 0"; if
hardware offloading is requested, mqprio defers TXQ range overlap
validation to the device driver (a strange decision in itself).

This is most certainly a bug, but it's not one that has any merit for
being fixed on "stable" as far as I can tell. This is because mqprio
always rejected a configuration which was in fact valid, and this has
shaped the way in which mqprio configuration scripts got built for
various hardware (see igb/igc in the link below). Therefore, one could
consider it to be merely an improvement for mqprio to allow reverse
TC:TXQ mappings.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230130173145.475943-9-vladimir.oltean@nxp.com/#25188310
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230128010719.2182346-6-vladimir.oltean@nxp.com/#25186442
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6: none
v4->v5: patch is new

 net/sched/sch_mqprio.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 3579a64da06e..25ab215641a2 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,6 +27,14 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
+/* Returns true if the intervals [a, b) and [c, d) overlap. */
+static bool intervals_overlap(int a, int b, int c, int d)
+{
+	int left = max(a, c), right = min(b, d);
+
+	return left < right;
+}
+
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt)
 {
@@ -144,7 +152,10 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
+			if (intervals_overlap(qopt->offset[i], last,
+					      qopt->offset[j],
+					      qopt->offset[j] +
+					      qopt->count[j]))
 				return -EINVAL;
 		}
 	}
-- 
2.34.1

