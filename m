Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79256D4228
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjDCKfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjDCKfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:03 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1963F2D51;
        Mon,  3 Apr 2023 03:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1dCZOu9J1FOVcwu4gcigmtVNTc3+mefEZayuSTsUCJFZuGOBhWGNyQpNOV967CeSjw7HNJkOdIdxTa1AYll1yY5Ft9NC5ZqZBZZOpAX6baau3g9xMClbn3auSfmNZwrcf+SMkRAxH0mCZfmmin1wASMRZ0dTdY+ivdCpKk+zLwyl6C8LZIjW62DGVvmx468jki7M04eF6DozxRiooQDzE4BmlWrZvTv+/TwRPRClpvahRDWTZPURZyf9Uos0Ovhwd5ig5LQJlxEENIzApbx7ysMYnz7ePWahAC5iVLfR3u0s1kaasMyVleeMKfJ2VufncYw2j1+OwFsuL8C/4Q0cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHR+Em53mXNFOhp8OKYBi4y9+SSYpR64IKXLzh5xz/s=;
 b=nfS/+31GrpZlL09WXFrQ4pRuCgQ9Z+D+WjorO9yqCM/RRdGi70Qskea0obKDq/t2Nq8fg3ZGEMmBmtIkEku6Ifl1sFAq6ZIwV2fjTdtPBYAuMU4ZALFEiZ5qwfPSjH5i4QHx3E7xtKYSiYSOsgbAbQhVoQElt/V6fOlrLkqKZ83SIzlgWQGW4NbnV+PZEflMQBWy+M0kn0ztQ6/h1kIhZfQ6sxXuYczs3592N+qMetuXTLbJ7oY9JRNB5RGTUpP5OmGyXAjVMrTqJCXU3+f0jXbgRElJt3y3jvRiibn0nBkWjavQQFbLjN7HJDMLlAL/Qpof/m64AHIw/VfXvOOWJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHR+Em53mXNFOhp8OKYBi4y9+SSYpR64IKXLzh5xz/s=;
 b=Mcs70Uyp+HY8Fg0SZxLNAGBvoCbmQgDhOI1NdhPHmT3tY4UJv1RDbExD2oNpUK3GtCpnR3CR/oOkRXWcO6gQ3xHNmAsKDSJ1BFhVHP0P6LtVztYU6vVlmdvIG/+DotGyr6rFoScShf/6E6WTvP1QLgKB06GiZXxG5zMpJ/7mJbc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:00 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:00 +0000
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
Subject: [PATCH v4 net-next 2/9] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
Date:   Mon,  3 Apr 2023 13:34:33 +0300
Message-Id: <20230403103440.2895683-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 62ac9251-de2d-402e-d08a-08db342f1378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m6QxJh1n3B3CpQGNEyUCFtvSsRBs5ID1IsOg1n8t354F375VAgUvN4/KlpS1NofcgHGLMprQfOp4Gqa4M24Db+bCrOs5YNi8ms5lIsGzd2Yjy6jrC5CE3xdCVqT2j227D0OHCFe/6vJKAyFM1ELvMrsn2tIe0Y/N8ngO/uO3VjCZKAl4IDP42g6t+TONq94mwvh52JDGoDIFdW11vDJY2VJZYbkRatD842yT5M7RNelu29EBtt9Oexz7TYRoNZ7Je2C8RP3tYEq+1cNMHkUkiijJxa1P3gxj6rczJs871BstLWFLOwXh58oqNulEPZbrWE3qzAK56mQ4J4rx71sncLJjQhR5yDE6mm44rbghCrjIWZxZw8EXP9T20ggHky3nI+R/5DwMkHPsdehenxRdO021egvoZGlbMVEN1iOOX92dMFqfyJi1ipcwZdhyCLMtQQWq1ESyg723pj6ShyyIauYpCbJ2BEaVeNyoftSyeOz6isrXeBPgw0Ww92nMj5s2qPjP0vaiJbkLMUJreWa7kKJgGDmpVZ4jsYPuXuYKZd/umDfc2iU/9d5lNiCOlFa0lIcXto69Ce+qfmTzP7VGFSCcMcKdBSYfFAWLwOlq/wWN/9WchD5KkfncnnlHLLcB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X/a8CJ2aIYr1uk9HYZ4wqe9lJvcfhRaD0m3srcmJ0UOnxZra3oLqOpAAkpn+?=
 =?us-ascii?Q?lwQ5gaSyeR15C0/YSi6UnPhBB38ly7QoVsEQ3GmjZ+KXQytH0OwwnGblThR0?=
 =?us-ascii?Q?m1XcyCwKYCrJ9EK01NV3hQZHlzs1b+mVJ1TLSDkEjRb4JzyFybgammPtJRSn?=
 =?us-ascii?Q?irN/EUzkVAdi4An3J4xSuX4J893ezSu3sZHTv2emSCfg3h5ktAc/1mzdFKBu?=
 =?us-ascii?Q?MsEfC7sL3o5nPSfgbHA+hs9/Fp9HgH/9Ks34fRj0EmV4h+tzYL97BUHbUwys?=
 =?us-ascii?Q?V2UckdRztFBx25hxXCcrN6y6k2WtE9B0B/1IMdBFzSzyjoBkvMYbxqVWNUsh?=
 =?us-ascii?Q?AJKShz9Rmr58GKghaVo1YPBc8AU8bv890UZpJqahZwHvpFYQt2dsjmNboNY2?=
 =?us-ascii?Q?jVLCV5F2sWH2YOEjcVQu9kt4AqR2hqEAWYwV/Ri0X04WaSoUdp9yn3dIXPjz?=
 =?us-ascii?Q?43dt7b4pFtwX+ZBlc8C4jyN0mzWNichvrYJQzrQZvyPR6XiIh/mg3oGg/ZXV?=
 =?us-ascii?Q?qbTmvK2QYOCTdR6IqZv5dWlW7forhQdCH7IYAxss9rrgIqdq7LhjUDoM5jEU?=
 =?us-ascii?Q?uVLJrt8OmG6nqwlFc0+c4tYfAg81TJgEawdknvGAgb+LUTwK/CuHbMlUnq3C?=
 =?us-ascii?Q?1algSZHbzusTHrDvNW/3Luw2JW4qmD9KpTQKirzZPpcNvLLasqTiQC+8a2Nn?=
 =?us-ascii?Q?Q9BjQBA5fqZ6lSDU7VoPG1MVzuBj1jn3YvPtCP6/rvuuDX4r4pnMsYw5PDLD?=
 =?us-ascii?Q?aPSk2+t7Fxm3C0Ots/vQ5izeSCn7gcOAJamkXbFGlyfSZgXL8UAhpxGOQJ9a?=
 =?us-ascii?Q?A0RWoN/WZHwY4cGJbNemm9ZrOsQWT+4QQRWlMVNFZ672PluwlNni5LVEy7SQ?=
 =?us-ascii?Q?jeRzK3FWmevuTJcHb5AeVX/mf/DUsAL132ga5esfvm0DWeyox/4h+yZRkrgg?=
 =?us-ascii?Q?KoNvDhH1ZJgVMrSfdI9SPI2cugdK3LVpdjCbnjPcfHBVT39WKldf3eUbO+Uv?=
 =?us-ascii?Q?4qUhTyMp6lxHkUZxnNvy6Cq5Ps1rVfFniWbF0SHdXpK2wuKRTY80A9g8lXSL?=
 =?us-ascii?Q?EoVjMikqvMvngZK5ilRuZ5vK0+2Kje5Av+MJUT9qvnvZwsfWsdL7TCBMkOaE?=
 =?us-ascii?Q?zQkzDkUll7kyV3OWwFQyUsdzCNwJd+WVJNltGc36Wd9Ioy6OHqw7jpGOrH5S?=
 =?us-ascii?Q?uZygmmpxflMCDn5MIZVcdep5NRjcfnQRhRIglaYK0csrq8EjCHtb/pvNGQuA?=
 =?us-ascii?Q?iBxPauF7DTqxY5u5EgDnftTDVpO0N2DzURXq37hvDtFnJdJT58+FB77M+eVz?=
 =?us-ascii?Q?NbjwgVAD8cuMEJdbQnZggLo6m9f9oMCqTe9gNQTAF/MPpKfNbMlcqvZ2jrua?=
 =?us-ascii?Q?BotKkFWirUHtFbfmr6qNp3m/1lCy0XuiPclqhk5c8z6/qF7SFtIJKaF1JoLg?=
 =?us-ascii?Q?6c5XtBf+cL9DYQPLE2vdOp7KGPq+kKyn7Tmjz0Svo5eldwvimFfHYFQ8GpQb?=
 =?us-ascii?Q?dGWvZhQDDu0ie+01xmbZpOvaymMVqDvqRnZ4ocX0LWSuTgEFC10TTBWbqJif?=
 =?us-ascii?Q?jSgRh8ATwS0f//MYIZDLSZm7vqelY7kix96+KI+N85zXw2+aGfJ6VR/iBjGr?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ac9251-de2d-402e-d08a-08db342f1378
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:00.0723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKO+++QoEc2rnRXLpWL+F645q/2o5ESE5cjMe0cKqt8lEOR+jJN5a91f6IYci78GBfT7pigpc3FcdSwct0dD0A==
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

In commit 4e8b86c06269 ("mqprio: Introduce new hardware offload mode and
shaper in mqprio"), the TCA_OPTIONS format of mqprio was extended to
contain a fixed portion (of size NLA_ALIGN(sizeof struct tc_mqprio_qopt))
and a variable portion of other nlattrs (in the TCA_MQPRIO_* type space)
following immediately afterwards.

In commit feb2cf3dcfb9 ("net/sched: mqprio: refactor nlattr parsing to a
separate function"), we've moved the nlattr handling to a smaller
function, but yet, a small parse_attr() still remains, and the larger
mqprio_parse_nlattr() still does not have access to the beginning, and
the length, of the TCA_OPTIONS region containing these other nlattrs.

In a future change, the mqprio qdisc will need to iterate through this
nlattr region to discover other attributes, so eliminate parse_attr()
and add 2 variables in mqprio_parse_nlattr() which hold the beginning
and the length of the nlattr range.

We avoid the need to memset when nlattr_opt_len has insufficient length
by pre-initializing the table "tb".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v4: none

 net/sched/sch_mqprio.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 48ed87b91086..94093971da5e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -146,32 +146,26 @@ static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
 	[TCA_MQPRIO_MAX_RATE64]	= { .type = NLA_NESTED },
 };
 
-static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
-		      const struct nla_policy *policy, int len)
-{
-	int nested_len = nla_len(nla) - NLA_ALIGN(len);
-
-	if (nested_len >= nla_attr_size(0))
-		return nla_parse_deprecated(tb, maxtype,
-					    nla_data(nla) + NLA_ALIGN(len),
-					    nested_len, policy, NULL);
-
-	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
-	return 0;
-}
-
+/* Parse the other netlink attributes that represent the payload of
+ * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
+ */
 static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 			       struct nlattr *opt)
 {
+	struct nlattr *nlattr_opt = nla_data(opt) + NLA_ALIGN(sizeof(*qopt));
+	int nlattr_opt_len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	struct mqprio_sched *priv = qdisc_priv(sch);
-	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
+	struct nlattr *tb[TCA_MQPRIO_MAX + 1] = {};
 	struct nlattr *attr;
 	int i, rem, err;
 
-	err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
-			 sizeof(*qopt));
-	if (err < 0)
-		return err;
+	if (nlattr_opt_len >= nla_attr_size(0)) {
+		err = nla_parse_deprecated(tb, TCA_MQPRIO_MAX, nlattr_opt,
+					   nlattr_opt_len, mqprio_policy,
+					   NULL);
+		if (err < 0)
+			return err;
+	}
 
 	if (!qopt->hw)
 		return -EINVAL;
-- 
2.34.1

