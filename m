Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3584E6D4227
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjDCKfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjDCKfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:04 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F7030C0;
        Mon,  3 Apr 2023 03:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yf/2dyxkOyn/S+4cG3C87CRMFoPG7Gw8SX/q7javzp6nJ3qMjFiRqQavnbHIIB90gk+XoV06q81zRI6jH/h6ckl+wYzI7gFGfYBweqfZbnc+ccLwsg4qwUZBi5gL4Y7VO7bKkw/TeC2Aq6WKKPrUVs3zFSC57BvMEx2TEiyRiMl4ydiLIv6Hzl4unMk/wLe+BCiD0e+EN1DGLqhLVQTD/AQPQbWrMOnei6tHkzepMxq5lw+tB9HTeuZGOOublSGHwGcKb/vhrHqdNEiUYB44uKHRU0bwiAT41Iajn8JauoyXnX1bbXjqYrZjw16cLBexH/pTIn2GE9mUzEd1HgoTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvzSie3aWoYHN/vBqu+xf4Et325hToTaMuTZofsfdvk=;
 b=Sz92Om1D0C43meAbsLctHrtzUhThL/hN9muBRwS+gdGQID1rmUUv6fC49tlCoOmh3ZwAMFzZgO1Pn6KI74uk5zaTmI2mdlYFkGh0GN3kD0cjpX5btWRDyIaiDuVMYNfnsWXc93YpY9V2epcpxAlTo3ivaXe/eKCcN0jMXr9Egwb5rEGGAPKFUEv18hBK4EkGRe/AQTLW61i2eioCAjKWE4r11Ae3AyKXHN7yMYmPbTunltG9OB2WHzwPd7jZ6fE0sMjgJ7pOJe2sKJqnc+yUe4nNejQGT8gcFE8dJiFEBopWTqc8u4HrSNyaPuWwmT+1rLQl0RclZ+l4iJShe2/saA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvzSie3aWoYHN/vBqu+xf4Et325hToTaMuTZofsfdvk=;
 b=Eil0GJ+R9fBly/QxFJpzn5RZ2DrrPtfqHoNKl2RIlwcUvuNlDYv4Q4cXx1e7X+HSJcwCitJUyNPc1LosL2dxM86A1VaAOsBiF9rszzn4JyuqE0fg7TQtNLr+0d0q1JoVGZdWJaNzJfBxQ7GL7pdbd++XlQQzJrnYHISVPwsHYuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 3/9] net/sched: mqprio: add extack to mqprio_parse_nlattr()
Date:   Mon,  3 Apr 2023 13:34:34 +0300
Message-Id: <20230403103440.2895683-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9292:EE_
X-MS-Office365-Filtering-Correlation-Id: 94a5e21a-1a9c-45f9-5de8-08db342f148d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4aEywu5ol0sOeD/ew5WZyJ0Y/9DSfsDB31++3NGGK6xgE/3bF0uOs8dfgcvHjsD08o0Y3ZO+lBTRG9ZxytebVKGiuvb6qQ3Q9EJd0h4iYz9OPQcmivnl0F9x1Gy7ukjVpG8oFFeHBd1TGKC8kUQnpDRBDqcqPU2Jq2pJ9749TQiilYEjqyLgFHxVBrR7HK7pbc+bDJBZDkahs3sF5+ghbUXCxcQk96HtjLrCKIXRBszfNYFNMcl69A04RP3sf62UMVnp6j0tnMw5S0J+cgvsqKHUU5UPCNYH3+QIJ7JOJvW0nCcAa0iBbrpf59OEKwdJUL/mj13+yKGPnqFkfNwikdfs39kd5KzZGw60zOoebh88q1fUPd3Kh+xTc7ApeKCBTbydput9yrRGElwYX9fBH80Keynr/ncCrgv6lJ1Vbhsj3ydhSdnQUg/W86xB9pB2y/5QyDdgr7mFwVznpC3rmiGulXyrtU0v5N9fKktROee5tKAH+NxECtbTZ0DMGI3tRCM4aHofXVhwj8j/C4ILjFtRsUZMcTbTmEWP6m9HqEQX/pTURdavAH6rV8ipyPm/mLmHMpMt3hciyxMoe3Dj2i8Jw0bIrKWwy1EC40jjy5zP9IC1iz9YCDrlmLHzMRL8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IyQDSRtLsb/0IIj7tOKIF6EC/yG87gNVH5XVXtVXF+He9ZY16v5gZOCC9Vbe?=
 =?us-ascii?Q?JzPzyWCDLbJEs9hjOmyOMq1MQGrut+BHvCjeKHmVbZbhuo6YmnOSfEeu+53v?=
 =?us-ascii?Q?FFCDTQcHh9OdmAunk22ftzRM2X8p1lsH9TG2CNri91NgYhzfry6iOUpGFSiT?=
 =?us-ascii?Q?JIOG52ftrlrPveTfwCAg06ZskDyUvB4fmFnJMz8lqpTJWMc+dHL75YGn5dYi?=
 =?us-ascii?Q?uYeXImnF8o0sQNYiyuTIZdVEBl9xWeuh+aRfJmfno68549Aibn5Wx2FJ0Htd?=
 =?us-ascii?Q?KCWlvTR154z1dw0UhHFlO78icPPJCq+tbRGUnZplZ2MJcOnFUyJmAPPP0Yu5?=
 =?us-ascii?Q?aoHyJN4jKhKyDIgPGVmdaiyAtZRAkRIKlf9qLoeEPqWTZnYwpNKBPlE7M2U1?=
 =?us-ascii?Q?g78UCpVZJLxql9WnN8//+bKWXAzeNo5H+WUrFZ2GtW86vut7f97wAsGOsBSZ?=
 =?us-ascii?Q?tjEpjB3/zeAtHmWdXztYBmT7GaXO90Y7DwEYWgwvS8ThftV1LWC3e2u3Zf3T?=
 =?us-ascii?Q?nsGJCFMpFpxJaG1T3SpQUd1RXpzNNAZJFDwdtJgxIcxr0lKaT/jZno6BAj/P?=
 =?us-ascii?Q?deIYODndmDJHfGXt7lpDk3+sM0XIpp2jp7GNg4BKn6L0rU7hjOYDz61t7gzF?=
 =?us-ascii?Q?gcLnqVPBfa7AE34nq+SuyxY7wuwKKE2n+CpRs9XJKX+RaDlk1HGjdE/XQ0zk?=
 =?us-ascii?Q?rTTo9iqJ2roUQ3FJDvlcV3o0pvVvE68MRqXN6RK9rDwfYEJyn9A1ludDa/yN?=
 =?us-ascii?Q?idp7oGnriw4OHInNrT8PG0XmXJujtc1CAFPno/jed/d+NqyKx5brFpswCiyC?=
 =?us-ascii?Q?xRegcmPQb6/XQiF0oqIqPHu0t4MAuTqg47obzMRAoyOxhTcJz3rHgZXlph01?=
 =?us-ascii?Q?2aMLjwRJUA9hvVdIDs5tS28PQEClE+WAI/wC6MVuLeaMggoIHHfO22X1/kO5?=
 =?us-ascii?Q?0FPfmv/z/OjMPIpLOBpbYxw6G21er97w9nxLFuRH+o1xMBEPOiu5nlrEXlkD?=
 =?us-ascii?Q?WoYDTlayZPpqX/MeLN1qS/fcKhChIbsnVtFJyD4ZZueR0KfmofyD7vNT9VYR?=
 =?us-ascii?Q?WgdQj2cifkZCC4c4kpRDTSBpdRZ7/0PSAV7/NcDhEzKnhFH4lqfS6UnQScng?=
 =?us-ascii?Q?YqkF+exmDOJJSOWEFftMGc673b/+3TPCFZOIJ4BvYs6cuAcoYlTqL3ifE60m?=
 =?us-ascii?Q?A7UH6xCQ03nO/NNg+xjL7VDZpuBHILuUuFJv4tLlzDkgGqmQZlycL0va9Zdd?=
 =?us-ascii?Q?AvQfEHqtok2J/gr3DyfTYDOnzc2zIVgZ1GLaZL4hEX6ux4UQeiTH33mgc0U9?=
 =?us-ascii?Q?vh8n5y/5pUdemsZZGml8FzQKUiFhdb1qJimty0AZHRvuBVoxv8w2QwCYa+H5?=
 =?us-ascii?Q?jOvz9Z32VJLzSoGKn4/t8YtV6me3WX6askeP8A3jfe7sJ7c54NP2fdK/ksD8?=
 =?us-ascii?Q?uguXae5av/ZBLV5lD6JbJuDPkVaaw1cARAV61ScGOFaHt4Q8yR2uPg1IYi0q?=
 =?us-ascii?Q?6o17ET7QKcsa6XwBNaG7VEWFdJEKYYozkb2PakNzq4NcCkbEabP+HMsYWB+t?=
 =?us-ascii?Q?5hLsmQBMTrjlgUEabm3e1Tu3BcafwMy9NDKD8Uh2VYa2gU/Hf7f6sD0LNRJg?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a5e21a-1a9c-45f9-5de8-08db342f148d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:01.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TB4azNzzguMTLWmZY322CTnzHWk1kwtcsE767PXfe0lcL2Mx3PtnioNV6132oOweJvA7+obB7Q3TNrSbA1TJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink attribute parsing in mqprio is a minesweeper game, with many
options having the possibility of being passed incorrectly and the user
being none the wiser.

Try to make errors less sour by giving user space some information
regarding what went wrong.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v4: none

 net/sched/sch_mqprio.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 94093971da5e..5a9261c38b95 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -150,7 +150,8 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
  * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
  */
 static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
-			       struct nlattr *opt)
+			       struct nlattr *opt,
+			       struct netlink_ext_ack *extack)
 {
 	struct nlattr *nlattr_opt = nla_data(opt) + NLA_ALIGN(sizeof(*qopt));
 	int nlattr_opt_len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -167,8 +168,11 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 			return err;
 	}
 
-	if (!qopt->hw)
+	if (!qopt->hw) {
+		NL_SET_ERR_MSG(extack,
+			       "mqprio TCA_OPTIONS can only contain netlink attributes in hardware mode");
 		return -EINVAL;
+	}
 
 	if (tb[TCA_MQPRIO_MODE]) {
 		priv->flags |= TC_MQPRIO_F_MODE;
@@ -181,13 +185,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 	}
 
 	if (tb[TCA_MQPRIO_MIN_RATE64]) {
-		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MIN_RATE64],
+					    "min_rate accepted only when shaper is in bw_rlimit mode");
 			return -EINVAL;
+		}
 		i = 0;
 		nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
 				    rem) {
-			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
+			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Attribute type expected to be TCA_MQPRIO_MIN_RATE64");
 				return -EINVAL;
+			}
 			if (i >= qopt->num_tc)
 				break;
 			priv->min_rate[i] = *(u64 *)nla_data(attr);
@@ -197,13 +207,19 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 	}
 
 	if (tb[TCA_MQPRIO_MAX_RATE64]) {
-		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_MAX_RATE64],
+					    "max_rate accepted only when shaper is in bw_rlimit mode");
 			return -EINVAL;
+		}
 		i = 0;
 		nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
 				    rem) {
-			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
+			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Attribute type expected to be TCA_MQPRIO_MAX_RATE64");
 				return -EINVAL;
+			}
 			if (i >= qopt->num_tc)
 				break;
 			priv->max_rate[i] = *(u64 *)nla_data(attr);
@@ -252,7 +268,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = mqprio_parse_nlattr(sch, qopt, opt);
+		err = mqprio_parse_nlattr(sch, qopt, opt, extack);
 		if (err)
 			return err;
 	}
-- 
2.34.1

