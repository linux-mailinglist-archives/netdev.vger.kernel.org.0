Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C3D67F37F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjA1BIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjA1BID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:03 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8442022DC8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Opp5mtJykc5Paqzci0VSHdWAJ0Nis7BGGM1rLsyF8v4+wA2mgTecRtoEOk/0knXQ/HCoVVfcfq4eWTqArUbzvKpWRO5ODUnjgfyX8IPop2x+XlBu9zAOXyErw9cN2xrkcsgRW2RuTFRpxTOfCdD3f0vMQyTEjRa2xime9icLKmZNg/IfuILWJp4DtR/ojmkpdn7fHyR0n8s6Ahx86dnqZ62R8LuywR9tY4Hb82+sdSV+aJ3mZuHmhT8eq6sgYf0iWIv0BVSPi+5cHc5Ur70rFuHLfj5r9uwsNIyX0rahnmk8dz/+UJzXnIIBUCoJQQqivw29hzx8LDO9wSq1EPQJkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Vx7InEDr6Kk/5ZAnfT9QJL0YNtOWWBVJGVYNclJCqs=;
 b=dVN9ojLqhIaLkplVroWuaYEsAr3jWSzlx+Wu108GEROVoNSAi7Z+0CP4emS+pDSlBFFswIpw0PEhkm/UIEyh5PiQ+p8LB8+DSoR8VkH9Q4f2EMdGDuUjTMlV7Uc5/ZS/M6/HY2zvoMzk25TM19zGniZFr6is2TS7dz+CBwVMOKmTPuDyUTaHIsGhdfUtBVSArGHOeNAhq2g69wDnz3SXnagqkBgB7FcgmaAUoPocvvHj/VtCOn7wf/jNmlltLAtrRR05JU5khQHEHwYp15dx/qD8VR0uj12NxwkLHMn6DGfAUT2MWjHdX2Jb/CQjgCLeOY6kauLytNbDY9ryYDxDoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vx7InEDr6Kk/5ZAnfT9QJL0YNtOWWBVJGVYNclJCqs=;
 b=SMzzDn2ZGekIDPGZp2Reg67DVKDggqDJ/yBlLYyRk0kpSg8cXg++kz4fNFSlunivYykNJzB31KXGO+zix4Lfq/XBPyIgftoaSLwwnZHwHp6+NmCurRWNMkSFe9C6ZCt69A/KLSGhQCyULm2u6WspYS0Vvnq3ti6DgPAVGIzCheI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 11/15] net/sched: taprio: warn about missing size table
Date:   Sat, 28 Jan 2023 03:07:15 +0200
Message-Id: <20230128010719.2182346-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: b4451158-0dc3-4eda-6a7a-08db00cc1652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzJzGNmGBms1yS07pjVCMPqphgf938cT+sQvMqv5agQ/rHGiq0ehmemnrI+bHwZZCBj2y6jR4mzU6aTLuMJU2n+vUNImLGQzV0k1NPjDLoCGSfIx1ltELpMvhjMKz3Bcgux5RwoeZgSfKcvgUTMZCvOL2fu9xNaua5fEFgnLoRyQ7aJY9j+Yd9AVp1HnjQUdWM0ZPtDly0Eo0Uy0Kx1cq9dcn6/WCe4kVRNUqiksSpzMKhISKHNuQBYpaNssVBE4js6ODDvMptgD9MmIv1nyHEm/cTfRo45qrg2J83iZ3yBAp5zkJuMBAe8zGMcVXTe7a0kIaDMdbCqRHqxu0su/64lPQp+Vj6qdfSPnhptxINbP+bAZ9vJXjvREbzwvepDy3mjhjw4jqLrmFrSmSKts37WjPk4eQpGHTofLJYyP8K0I1n9DFC4mnIyHV1t41k5UlRVGrbXwYUQ/7ph9404LZl56klAYbYkbm8yfAns0IrQkL3zmxwvLXpmmMtDv6TvAeZeNoukg46wkmh01izMyn0xyC/faLmLGPZlvjVGnPBx81IsgnWgQ/ZgarM/p5dfmGGQ5AxZubAPnrT1cE5MR1fP7/4rYSIfgMaF6qWWDT6rCBsUpqW5kJjxxSyfn0tqy1ZgP1Nj5FsdEwEFNm2gIQ8QQskXnCdyW7AkojDi+6BZc5j2I6juHZIaeKF83rpak42EcsZS2IfqTzdjwKn3b5GsJNZyiS9X3zJ8f3HUxlCg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(966005)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3FnzMi6WZ+XbXimbeaM0gywwyWHxlPQasUdJXUcEd2456qE70gcn2NPo078b?=
 =?us-ascii?Q?Mwpy7Zm+BqOGsFK0N5zCcX5+I4+Cue76cWi00KeU5QUMGB0qgk6Xl0KB9jM1?=
 =?us-ascii?Q?qdSZTSLN1RwIgkR3nJqswH2ykywd3W0KaMXjrCR42ExqH9MAIMgB3XkzsDy7?=
 =?us-ascii?Q?yLBeUJvPQW5vZBqdgC+olHpE3eyGiGK1TppHVQYKAtG3SGJQwszQcbrxUdFj?=
 =?us-ascii?Q?JhYqz9W/DKiMOz3UnvVDSDqqSVX7eGDyE2bWfeY9m6zzfavjCVPiokj5M2I7?=
 =?us-ascii?Q?C51iZyYNM9NmERV9Ei4mW2+PeHvbZf+kLWDJHDKBhnNHIKPWXnE8UpeV197I?=
 =?us-ascii?Q?EABW2tbDfM7StJN4qrtro531n/bfLcX4hSBrp7VHk/xooNqsyMlEUdzP37Bq?=
 =?us-ascii?Q?qB1QDTANfuWUIl3VrJdRfHDQp8jYYIdNzGpqyYXcZxbpEaulPjl3IjeParpT?=
 =?us-ascii?Q?FQm+pSZUucFV7IIx4wLB6Ax+MfSsoEcmTJbfzsSchMjw08WhwTmqMXbShuEU?=
 =?us-ascii?Q?/Nv9d9touup8zq1qUB0M7ImfWcXprUwJ9hs4jtK+PYnvDVABZJqz+za06xnq?=
 =?us-ascii?Q?fT+oNMH7U8wqpGetaEkGUSOsSpEncJ4pIT+7Meu5tiUt2WbIIu4W9rTobKok?=
 =?us-ascii?Q?HOcsfS94dk0cFkcjh0ku1I/EyYCW99ovFTOzZOfyDRUJHxPnabf2XVnd7rsf?=
 =?us-ascii?Q?+oQBiUp046IZbImaGsWzuavO70B+saVTHdaoJro87N8ISWAi9kO4VwkuGXck?=
 =?us-ascii?Q?19kcIzgM7DI2H6N9sXp8MXns1xolmJwD/af6PT4ke/i+6zh5Fo2tLyERTDNt?=
 =?us-ascii?Q?lRnI4yNZMzQ5IhqGI3UGf09BfUQBW0vmYAXMFxHjf7nuPwrQd2EB42Vh/mxf?=
 =?us-ascii?Q?iqrB1dPJMYbYwukZ0ZRrxublkl5S5Co+RmR0oHIUq2jGzblgBlO4WRe9oA26?=
 =?us-ascii?Q?oArrFlFTCGfYACCaQ0qxS43NW/cxKR1cBqmbOzyMmqw/Vqev/G9OV17JedlW?=
 =?us-ascii?Q?MiKCh7hnI7jwr8S7EXxl2qsqHOs09pYBOZ3R+CVJ0rZ9KOlfE7vKkJpYfmBC?=
 =?us-ascii?Q?DyXSmFdXhiNsB1fnBn4XSjBMqcxHMnk0a2xxWy5PfQCSICyjLhBCN7NgWWiU?=
 =?us-ascii?Q?N8v9tjZTg4qK0+2Uq36nKWqzrgH2fqmhA+0/o06GH3KaKDBuaRnHLRr6oU27?=
 =?us-ascii?Q?wJBEUNJQpdf8sbWWRlAGW6mLZMASU10br+isKuAMDL2V9rwG1YVPhyhA42rm?=
 =?us-ascii?Q?eeUZbIHf+UzCr/YVk5b/Di970w+Hd3ok6JYvX8eUX7DYWTAyUtcVdjFeNpYD?=
 =?us-ascii?Q?y1jOY+bosOFRJLNrg1K7kQTDRo0lLEuSbQ8kEFLZd3Srz3a3fG/Q/91r/ysp?=
 =?us-ascii?Q?EvzeywbEZnqf7qO5SmnwMA5rS1KXjO5bVX8z7ZsszYTTZTtn9pBSwIMlp8qy?=
 =?us-ascii?Q?jn+t1QGxPVaukGwrVhiVrm0KHeF6MdOnm8galTOR9vdjghdeXdH90Q7x1UTz?=
 =?us-ascii?Q?nUrt8LBQcFAleXiavf1W5NHNBj5ukPAeZpY0DQ3TVChqK2UKrk/Rxh25z4dU?=
 =?us-ascii?Q?CA653vEYjE7+pwI6NX6AMSfIdj3+cpZpTsDd+wStibh4JtjyZ532JQw5rklQ?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4451158-0dc3-4eda-6a7a-08db00cc1652
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:55.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8wAfB3d6YkDpuv6AM3ENSTb+22xHeLKJTia0dI1cGh08ZbcVa9KiEHGJxzOFjbeuz7XHnMB/Rl8e1ohqirWQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius intended taprio to take the L1 overhead into account when
estimating packet transmission time through user input, specifically
through the qdisc size table (man tc-stab).

Something like this:

tc qdisc replace dev $eth root stab overhead 24 taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 \
	sched-entry S 0x7e 9000000 \
	sched-entry S 0x82 1000000 \
	max-sdu 0 0 0 0 0 0 0 200 \
	flags 0x0 clockid CLOCK_TAI

Without the overhead being specified, transmission times will be
underestimated and will cause late transmissions.

We can't make it mandatory, but we can warn the user with a netlink
extack.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220505160357.298794-1-vladimir.oltean@nxp.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8ec3c0e1f741..d50b2ffe32f6 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1671,6 +1671,7 @@ static int taprio_new_flags(const struct nlattr *attr, u32 old,
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
+	struct qdisc_size_table *stab = rtnl_dereference(sch->stab);
 	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] = { };
 	struct sched_gate_list *oper, *admin, *new_admin;
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1823,6 +1824,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	new_admin = NULL;
 	err = 0;
 
+	if (!stab)
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Size table not specified, frame length estimations may be inaccurate");
+
 unlock:
 	spin_unlock_bh(qdisc_lock(sch));
 
-- 
2.34.1

