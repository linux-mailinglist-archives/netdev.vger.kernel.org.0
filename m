Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EAF6DE35B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjDKSCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjDKSC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:29 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A345B86;
        Tue, 11 Apr 2023 11:02:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlnJX1Pddn6lroe/yNESAUEYOtwpMNRPuh3iTFrN5oxtPIGf5hbOR4cGyIc7XvK3C7nPaYL883uCBYRhvA8Vd7vjphPl+RUoJyQGaTg1NW5uv041NFXkkFY+LR1u2cemUj9hP6ap7rQ1ANbL35l5ZWwDtDatDJblnGXzC+2XiJNgYcnVel/NcT0bsMVHq89L3wMsiVOW0KdoyArKurrMS35I/5qd5t0IQd+T4DLHAcOEv+njpjRuolMj30XPuaNgMTKXlrwJb24r6Ik0rDOsweEfNgKak52iBrPKhm21bR9kzBxMfVz2w361QFSe2+KoeInpe/uD5d4QLgNuo0iZIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lAGmooedVC7J+3mmfkvE02wUN+57K6a6L3sSPi5grs=;
 b=SqgKw5c7kEDuw4nBMDyZNM9SphuOMxuwVo1qsuPjhHXchGDS9J8ZAFwcXebSzuAld+gRBPfKON5TWfita3SFb6nl6Hm1+tgmwTtb2s7t/pE/Hjd4VpNREviGLP/LKEtlKKJMiTxXluBE5y1Goc4ilML4zwv8vVfL3vwG7ENKPkNSnvdduoc/Oh0QTcK2Tx+a0ETH8QuKz+yO2QyQckMFmhYMUI7CnjrcAONLM7eyVwZ0hunyQ+fMuJDYWeAlMCBIzhhPlMehroKhxnEaEawrr1ZQ4/J8YG61ZoPuxkJyc/heuSRteIaNidXqkEvaY1H8YHA8jsyNtJAuV4AEh4OF3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lAGmooedVC7J+3mmfkvE02wUN+57K6a6L3sSPi5grs=;
 b=Eyn3c3n7M3PyrA3EN1loHPnaQVx6RUhp4mMmk5jD3iae5jO86cKrbHFmMSlHiIxIF+75vXEVW8a/erq0bDyvR7PzGvFwIO6vwl2vjWJ2YBzncKM6ER0SXMaHnJHIC8nXIercZ9G6W8tbnlXZgwwTS282KohL1WgDXqpay/0zQfQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:27 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:27 +0000
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
Subject: [PATCH v5 net-next 4/9] net/sched: mqprio: add an extack message to mqprio_parse_opt()
Date:   Tue, 11 Apr 2023 21:01:52 +0300
Message-Id: <20230411180157.1850527-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d81490-c833-4382-f807-08db3ab6e8e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ig41anPhV12x3SqvHrZfPlccNhy4Qly5skzgsRxVId32p7+u5GxsdLfRgp0LrGQ2PlkrG7qesqdFj66ho04qhRcIFJB6Z6/LZfNltKnZCcX5OV/sgXJzBaNYnox7MZOQ+i/T68r8on8sf3fYvuP5tiX4FHUNgOicoshWqzP3ZSsz5FKSncmQmyGTDvP4dunoRxAza78BG3Ht6zc7P1g1MfWmHMmfkFSTun3pdwKWnfIrRAaIXSmRzE92IDzs1fJCWa8awOkSQ38sXUaR4majlWXzBDrAm3r85hWk18b0rbn4uRRArIdtiklbGES3PglzGPo8h1iyFLb5guAsDGnlTIt0X/yWBQqekfDl3qkCVD6kKxeGaxmHxBUz2yT+Kt02Rwd4Zqh81DCnzMF+B/cf5GmNh65AZmkpKoYXaVcFFBdSuBDppbhdaj4w9byOSnnmeFNMFqHZd7W1ZozfGzotj1wwyWss4Sb5NO1bkUDc3+epG01IWbp/DKOEHWKIe4azUBu9FA70nQp9bvEwwZi87Zts4U8a+GHDvfiFM5LPaHbUmdyONg7ALp+B+pZvxzZLMopY6kB2pth4kQGgGFr4tpdy8SCUMCEfLtU7TATX97I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(966005)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZcQVDisoF1fmFkqtMRr5YtIEh1RzzPBauO1tmCz4wkDZouydwyfGq7l1JJA?=
 =?us-ascii?Q?m/ZWdaaczZN9HLrHjFjyiaK072XHeu5gPg2ExlByHPZQy1a5RIYL4z/0geNh?=
 =?us-ascii?Q?0J3ZtrTP2AUuhJlJw8jC3eyD4I4sn5Q7ReEFOUtBijEOU5Rgxd/OaUv/N237?=
 =?us-ascii?Q?zrmV1bQBZ03j6sZm4jIMQBWyJ+RiUXCGJnUTxedJlxyLj2JOpxK7nsBN0TG3?=
 =?us-ascii?Q?3CRKI8fDVYkMy1pkDessvqb1CJvbqGLDNZoo/hpC7ST0fFcXLG1WXr4UlX2C?=
 =?us-ascii?Q?6G+rtW9yDarmHPUcf2lj3G/tAwJ4olISLoK2zTGdEiNHRRUhFWCYkcuLn64r?=
 =?us-ascii?Q?ZhVpRUB/oV/j+R4UjcPvThOxk4lpT9+0dAUR3TQ6bD2bGh/+xowngODbd2R1?=
 =?us-ascii?Q?Slar+OrA48p0mlCfNdCP5PYXX2+gz5CWtp08DmnsV5Xidi79vP5M1S4vcV/Q?=
 =?us-ascii?Q?Lbwu0E0neL9TLL7bCQ/8w6E/s0Qjee/bM+l0z7a10clM1/ByPdv9WdQtWlZu?=
 =?us-ascii?Q?2VgK+rLHdsAU5lWWmefiV89oLxlLZzXlfiqw0FDNOghoGnvf3ntSs5eGU3Et?=
 =?us-ascii?Q?WOi3HlJvQVUXkvFnQOwiqAAQ1GULTgrLElRXr9l0qsLD+ahnf/sO/9PUat8n?=
 =?us-ascii?Q?WVT3QuGJlNWpb68riqSaHVl50wNPx8fRFApMk2VtldFpB/BcWAcV8HOjNQX7?=
 =?us-ascii?Q?XM2VdZ1Qai7/K3nX2A/6nDXGoA6O0JhAzKriY8eo2SJgrYopJ6lDiy4AtkMS?=
 =?us-ascii?Q?HJfqXU23S8U5Qk6Y8oqmJuaYEsNm6xzTUwsubLgHTTqS/Zfo6QFTa1HTHJp3?=
 =?us-ascii?Q?CjdKz0RwFjgi9ElFXGRtsMC5r3sZRn/0GA/X1+pxqdUl7V1x4sA+oLdVU2vS?=
 =?us-ascii?Q?oOgsc3OJnp8UzfK8tiagYgNQS5mw2NWm76ltrQtkB+HyayJukFC8WHxvNNsi?=
 =?us-ascii?Q?ny1iylU3Ltl+t7fajaunC5D7lusBggg4QjsMJ3NCJ8HyZYOfhnKx3eMS1lf1?=
 =?us-ascii?Q?GavvxvhxHu200g4yJik1X+8Hf3wlTxozO9Mzw7VC04Fy3P0wmwH0mPqzvMFP?=
 =?us-ascii?Q?XdgEPxyh6dNva3jU02m5DYg81OS1olqXIJ159MrnDFi42+M8DUuu0EM8pc++?=
 =?us-ascii?Q?cojRDnkkG6i8UCeWbXaxx/rGpjOABr7gmGhpjIx7Aw6qgH3rLdAnAMfQuaey?=
 =?us-ascii?Q?dJisMihGcn9BjKFRtY7PB0hqlck6/Gew+sEuPrMddlksZyv9/O7vL+/3tgtB?=
 =?us-ascii?Q?Ajn361Q9Na52LQFIg169rg1PGpTxoAca+ZaXTHxoEVRdNbZKM/pNK3n2l6Ol?=
 =?us-ascii?Q?Oc+e/rfxKa7mQszmDSmBQ3INL/k6QfbJqjqgoAvi2IO0suUaJ1ls+Mg2qrza?=
 =?us-ascii?Q?nUN7bPJ092JW9vIS5h/2FxMLIOTeODsHHiGCbtGRslzJZBUbydYI8GkH4j+p?=
 =?us-ascii?Q?IRWnETTZBAfa6kvd+Gzk7hdtc1jaB/6t5tnlfqC7XILDsyHM112/UrQwjW6M?=
 =?us-ascii?Q?ZRDsm1etO2bxgLoeTRozKIIcHynaqDpK7ThgOXUnuHthxES9qmFpP2XRluUU?=
 =?us-ascii?Q?4ztOjl86kCZ6w8+oVtonWv09TUgeqRx1qCGIpCwsxH2aiCygTe0E4fprFSUf?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d81490-c833-4382-f807-08db3ab6e8e6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:27.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxhCXOWfaZGeJdp6WPPEnJJKnJ6zAJz0d45mBkdHzqRNIIlhD4M2Y136mzEWPee0Ax6hAPmp/EPU3UlzlpENMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ferenc reports that a combination of poor iproute2 defaults and obscure
cases where the kernel returns -EINVAL make it difficult to understand
what is wrong with this command:

$ ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name veth1
$ tc qdisc add dev veth0 root mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
RTNETLINK answers: Invalid argument

Hopefully with this patch, the cause is clearer:

Error: Device does not support hardware offload.

The kernel was (and still is) rejecting this because iproute2 defaults
to "hw 1" if this command line option is not specified.

Link: https://lore.kernel.org/netdev/ede5e9a2f27bf83bfb86d3e8c4ca7b34093b99e2.camel@inf.elte.hu/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v3->v5: none
v2->v3: change link from patchwork to lore
v1->v2: slightly reword last paragraph of commit message

 net/sched/sch_mqprio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 8e8151ca8307..aae4d64dbf3f 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -133,8 +133,11 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	/* If ndo_setup_tc is not present then hardware doesn't support offload
 	 * and we should return an error.
 	 */
-	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
+	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support hardware offload");
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.34.1

