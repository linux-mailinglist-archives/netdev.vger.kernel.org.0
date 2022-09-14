Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED65B8BE0
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiINPdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiINPd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2081.outbound.protection.outlook.com [40.107.22.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0BF4CA28;
        Wed, 14 Sep 2022 08:33:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lgd4MhsVG3Niv39W7gBrZ/sQ7JppvVPgtQzG1Ifyhym5wzhIb/ZA+4hi7ye81oMebSB0yNUqhxKkY/p+qUxezqvPTB+cDj5r4SrGJymHIq4ECrJAwUmIlSQPJr0xiMEgBeLpd6magO4CbKH7EeEYqFFX7lzPlOVSwVAjWdQxPdnfekaUlMKYvqKJjgx3Sez21ElKYTg7NA+xfOAoU1kIAcZRNpuQlUTzXSjnWFylW8lBRCUcpby0BuE+UkAaAR1c6ORHYTd8FkSWhWrzsD5E/bcjjzIp8LichfvpG0Sy2uxSeUsjUtUwhmxFH8mBlOfKDx3CDfvE+GpItV8tvNxLMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5+VtOqX+XGLZL2ynn/k/BcYJSS7PHKoAvPzcr0u+Z8=;
 b=fvNeg2i3xR2flwTO/rxYe7lmsHrSLg5weLPj/F6i7R4K9ATnQ55qlid2kKBqRkL8m6Nhs7Y7qqHMMv6yFpiL+/Ctq0aG7qjIw2lFxzT107TDRxjN5HppJ2hxLtV6S7wqQd29Ll80rLuJTTI6y9zKV0wvKydDIZwmvLz01TG73Qe9hK5cB46fcNKE3ByCgGIC820QdKmm6v5RY07OFoanEMQ2+zerB66tJ7wDqAob80RNHVJujOK6BGm3XdO0mR6D/o2Ad1gfkOYitHmAlmYwN665iHiuCC2g3xgpr6/Q4nprGS+Kp6W9SYWFlXUn9tkjsAOh2L5TmCoqA2Yt227WNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5+VtOqX+XGLZL2ynn/k/BcYJSS7PHKoAvPzcr0u+Z8=;
 b=VavxdbA5RCVP7r44F494ZzQreIAw4Ax4k39RHxdNeXWQ1Ctj8mZs50FQWyNTYsJp7w0GLJlQ9KtYz28XUq4hl7YGKoNgzSjkasABP+/S36BQsd6QZSQYLbJvsRYCOAY7L5eUgqWoo004KTrdLS7ry2AsPFTK343KNwOszt0sEk0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/13] net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in taprio_enqueue
Date:   Wed, 14 Sep 2022 18:32:51 +0300
Message-Id: <20220914153303.1792444-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 771ad24b-6240-4707-037c-08da966676dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRN6tYDLcaaFco1i2/jjx3B4/LEdzWP5sHyhL8S9v5/MIqMC5RXBUAsru7Kpk7AFGnrP7NAakPEwx/j4rr6Ximfma3Hj1Y0pZixINWvHg02tzo6+Or6wXNROCdJARuB8SX8mqfcDbOrvTOH68LXeRBYgy9hvWB+8/9OEjXoStEPko3x0U62O3BF3IcWTs5+h10UTXKQEMu+XVvSDwaoc45hUutxTTYlkDVEP7VRSRTguh69wUKkGpt8Hat0+8mdcnaDvNGNSPRXbEz3G5skGrDEVxH1D7PvWPv5bsyQAG5OL0hXM5qWJN7WvKvlOhWPcWc+c/qoivBUT1qTcWyxSoBlZ9XtyTk7Uj2o9NWVkCu9SsnuCzdZng+2S70JpwurE41NgITQZoXvU/FUkloGJw7MAfC3YeF0oPf6NZUuAhUYVau23uhTxloSu6KqbXRzyqMnFwZ0L1KxFMVUBhYzSBafPs7VDc+erwGl2Ki6mTcGBI4wbELa9KMvHgjeZlmv7IpcI6dkqln7AIWJogBeNLqkMIngp5ZHOJEkRznfZzojjBhQQdJWb9waF+F5zbpuSKcHzhblA6AuR80H01MObiQCG+lhnyP91SaCQP+N5rpu7dRKOsPoGOk78mtrkYotAPYdlq2QGzlvyXFhNbJgv0SHYvrIQbzoHz1PpppJydQjj4uCWd09gdPsqwJqvPf+Lx+oVmn1twlMUReoM7wY+FCDcUMSYOj86v2eS99RJWa6o52kJj7Vv54RYYAbgvYZmWUSPKHFduTnez14vcvpFJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?32rWqVyS6pNjiV4YCY80QBiPbIVfXhJdKVtweKZwnmQoyNM7J5ix8NXLZk6S?=
 =?us-ascii?Q?RVPJkvMSwL6jImdexU29lf8C/QLIN2Wk7ftJEXjre1lv2FBSuueWqB1OKdgK?=
 =?us-ascii?Q?d/IPxe7mlcLWNWrE1BBEsknWOA1UKpF2oir2vAADC2W+4Zseeb+C0hyRoVak?=
 =?us-ascii?Q?zK54z8pxc6PUAOIiL/0WCFAYww2dldA858FZf0NRpwQS+6QIMA2P5AcvlBAH?=
 =?us-ascii?Q?cioDOisco64TpQL8o9tN3JyOQQP8sReLWZGpuTTylTfjqBwqPR9wXRE1eo0E?=
 =?us-ascii?Q?VbHH78+ChjjVYnUXpnbeOs1MFHTZ62yAfdK98qcGvrasmpL0ZuayIxTT7HKR?=
 =?us-ascii?Q?o+LAuA3T9P+qxqHU7ILP61dJRrWZznGTImXpZ/9UaFmtr2DDV+abyemPp5t2?=
 =?us-ascii?Q?h0jcukcGKuAU8cf+xcYDT2PQ5mFsxEo9aEWK2wfz8hOCjJLV5y6/glxsmpHR?=
 =?us-ascii?Q?et4ZuCOR2C2m814ETDeNNe1gh8AdwrLuU4YRQhSopABlrC1LhMJ+smzjW3RW?=
 =?us-ascii?Q?Da9e799k+/kJTatoQEtlNBJul1z56ZyY70/D4KntwihHgCq8UarJTWyI5D5X?=
 =?us-ascii?Q?oeymJltYxbk/bLtJThuireR3eUS/bfnfzp1paimEehWmToIsDuONrUOVNSPL?=
 =?us-ascii?Q?pzIh2D53c2VoqS2jRhMCUtIyjFUJr8lMKUO273iHondUWlyCpi7ihihEgxks?=
 =?us-ascii?Q?dEW92LL1ykhoBwswpGdDUoObuJVV9/6N4QMBypeY5qNc9uuJ0b5uw75JEdT7?=
 =?us-ascii?Q?elpaV64dAYW74npx14djhOGYmWjcCrwXgIq0wW3OwOOj+eMSWdsPtw85tKtM?=
 =?us-ascii?Q?KsF2cJb2+5U9nge8QgpcIUb8Cr7yN3C/lEvbC0estDDXK/mUmkknteoG78oQ?=
 =?us-ascii?Q?wlHQsIGYliDIPypgEtkgwEGzKPZOtth2lZcmH/XzKVBWjkXKTG4KDGQN7KGD?=
 =?us-ascii?Q?glU84PjRmFnI7IFoLyNjmhdHdDbaDSq1oQAlzhQaPwAheBeFJvkOKWLzcZzJ?=
 =?us-ascii?Q?EBMmRIANTGS4Wf0WVNH3bU9iQMI58+1FwhNdoAFt7NE+tmN6Zm+T9yYw2BIf?=
 =?us-ascii?Q?BDm+m7btU0w3+oUlm4qBNCmmJ0CuC+yXmV3bjuSU3dWRqhHat8vu2DV+G91v?=
 =?us-ascii?Q?cjSPSux/lX6nRUNfowJ5Qdh+On+2m0DL1tWwyQMgt7cmKraL2603jUoeCce/?=
 =?us-ascii?Q?CLWcxkU8egG8hDXfP+BRlgDVkKr3ZSLxwomy1aI9ElUyfteGDcdpxhwMwGUS?=
 =?us-ascii?Q?lvMU6hbcPPHn2KUcB+zY7ntXe4fLWD9LQvOMpMAxosdBYuTWMvgxZ2f/7LEY?=
 =?us-ascii?Q?Ht3l1xsj0An7sSU4dCpd9nVMtwjigTqRsnzxGTkVorHKTMgN7a6nkLqEXAVB?=
 =?us-ascii?Q?EQZLGMHW1Fj7DuUPdylds1NhziQUWKCxXRj3Ch3rB7ddKgMK+TFHkKkA1HuG?=
 =?us-ascii?Q?6ULMZl46DcXyoqkbYrYS8eDAkvUGzXrIEb2/eBved6rT7AmGPI+Os0yeOPnp?=
 =?us-ascii?Q?yu/i7IPqjO7VK7zBS2NPCQ9N4XYE0jiQvygizr6cR3ZuN3PaxIa0DEsC6rwe?=
 =?us-ascii?Q?Rj5I9KxWYr8D5aowlpZoyucRydKroqNjs7ttatrifJwICyphqQDuFWsBecIh?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771ad24b-6240-4707-037c-08da966676dd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:25.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Fjds1iepYKwkCsVuIIQ2o+bukVsbgR3DTizxnnr/9mfXmfsSuAJhUmznn44RbR2YD0XrCNYEWfzq5s8/P5r6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 13511704f8d7 ("net: taprio offload: enforce qdisc to netdev
queue mapping"), __dev_queue_xmit() will select a txq->qdisc for the
full offload case of taprio which isn't the root taprio qdisc, so
qdisc enqueues will never pass through taprio_enqueue().

That commit already introduced one safety precaution check for
FULL_OFFLOAD_IS_ENABLED(); a second one is really not needed, so
simplify the conditional for entering into the GSO segmentation logic.
Also reword the comment a little, to appear more natural after the code
change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index fbf84404408f..a172c1eba995 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -455,10 +455,10 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	/* Large packets might not be transmitted when the transmission duration
 	 * exceeds any configured interval. Therefore, segment the skb into
-	 * smaller chunks. Skip it for the full offload case, as the driver
-	 * and/or the hardware is expected to handle this.
+	 * smaller chunks. Drivers with full offload are expected to handle
+	 * this in hardware.
 	 */
-	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+	if (skb_is_gso(skb)) {
 		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
 		netdev_features_t features = netif_skb_features(skb);
 		struct sk_buff *segs, *nskb;
-- 
2.34.1

