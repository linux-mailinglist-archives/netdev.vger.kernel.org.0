Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED9659A4D1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350525AbiHSSCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349825AbiHSSCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:05 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6184D166
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0rPzAnzla9kQe5g1h5obrdZxqQDNruJhWnLzyg3M6I1VFndyzLodL4A85So8irGJYkwBDVxshBwTJqqF9cFiFSA2CBaiDKWyTOdAqDrYSiq+Ke1iC+BV326M8m05oT27nY5vr+g9MRAUUC3G3kfu3OIaKauHTA9dBk1VFJzhCFn8ESLaOO8ians6sS+linPwaxKalTOyqSR0WDqegvDin8ciOJGLSjFB1tEN2//9YwNltOOZAQsBKnu0vtloh0GoBXuH/sAYo8mCPHFcsXq1bBZGlNwj65RyKpO/y+XJ4ft1PCuPu/JGrPf05pJa+8daNb2KE2cgSfusIRzJb95tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kt0w5qRtSmIbRwMcTIzBsR4NX5JOD+QHCYUTvGUdrMA=;
 b=YpbY/ycHyoHvYzp4e3R1YKmmoJfCc+7KOd53/suhxTUDXB4zTkU1msnZgaURF1j16CaIB4KTw5yqXzOAULkhue2v4QJWfmODB8iTHZdcUlnF2gTLC0ku8dxTOuyXRODkLhxfINQmJqdcUlE5BQe4Q6YIHCcCF7mWUnX0Ot1GKuBUeSe1Vtq1Zmk3y/ShjNwHCY6fssOEwRb85l6IkBuHeDYXwWln37AyYbWyI80LMMHSnCC5gvN8KzuYUuu0biz9RyapttofulHc3zlayVFn7y3jhKDQll+humYcGQ1OrpwBSO55rN92aDHN88hSh3GE6a9Z5cuaQUWIyLg5/HY5bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt0w5qRtSmIbRwMcTIzBsR4NX5JOD+QHCYUTvGUdrMA=;
 b=AqYqZlk15j2NpaVQy2JuZCUlsQDx3fMf31waeXBPxzQT2OBlVg0BB1QfdMZcxb1MZWcpny4rnxrkXymqw0nIIEZTW4r4JNlAtKVYrAXdoHjQT1KaTvrJKDvWRyl9ghaNXZQ0b2/TFqWWKRc8nEV7oQA9rtn6G0V0lu07UmGbuAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:33 +0000
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
Subject: [PATCH v3 net-next 2/9] net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_prechangeupper
Date:   Fri, 19 Aug 2022 20:48:13 +0300
Message-Id: <20220819174820.3585002-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d6db3609-fc6c-40f4-2da1-08da820b08d7
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUMJO+dR5kfkllKJlYeNA9USkGJzJB0hoU7X5XrdeDL7FSiB5SRHAcUBiZcQ2RBPi0f4g3SXt1HF4fNKjwVF2RBu+kX0X5HSlN0RGyja+JaAMy8GsFXDNNMMDeX8m4d1AXq14vluNY00Jok+dZ//LjnGxsG2abv4vqWEJGq7E3kAbhFsq027OE/9qTqpp6r+TQJh6DcbUUSraGqkw2yF/5f8aq6pyzM7He+3WObbu7JnaognYbVuVDay9rePYozd5NYzNkmWWayrJ/u3Y2W/WKzYL/5PlYR03HtvjB4ktbwrxHyY+ThRYSRkgjt8VIorqkj3i3SqU2rsVf6bF0WYslUzVK6XMVw4YFT9fXtS1V8CGZiRVXVuITGtwsOnvE8RtCufW4fRuzDTdvVpXmmKsf8b06garzRAUwJw152VDkuuepNMeH2rn8dGVSKP569fBWZPqQyr4JWnRoh+PbLiMnMLo9dbQUqXW9BfBJhpww0pouXJA8SEioLdEw9LW1Ht18CwaW+UQp94klOfHaKwc23LUuaDCbw38feGDbcMsjxv0mN+DYcME+tmPVLr+b/FhBvQdSxuJzqZ45OPHytJP3W5jl4eEs5wMKTpkr+cbQ3sVleXb4iwCu69VOk3tQ7Olic9K6WBqUqWNkvJcOymCLoMvyutvCm2lgKq7jlR4m+jELf/4eeUKFm2OT8npZUVJzuWCqyDwmeZvOSc8AD2BVE5Mi8eHSv2GbKIc9cxh2u4C2GVEkpHMt0amqdI1Q64Gh9e7e3Z6JLSteOQdpsUOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nD9+PTwHZUXQIv+71/iPKDXSw2JD6Rc9Z5PcVOphXosghXVJRkBP01TS7mAg?=
 =?us-ascii?Q?AdBZcfNfKVeZ2FPyALU1ed/WFqWUkGY4LMhwWZNT+H8nKD4jl38B12rje5Tp?=
 =?us-ascii?Q?HM4xf9kHRnNnVpfVbTVVdYDBAGQa08MM08SE1gAFNZL6lRAkDsI0oh8nK4PQ?=
 =?us-ascii?Q?HDfEieQkTOCSLFqphvaz2ZYroLQEKcjdys5xOeRysfD7Rplgz05w4YWHOykl?=
 =?us-ascii?Q?4NjWxmeUoh8GgQxIIYa3g5CuOsXq8Gx5KhHENjcP2rJiGHy5ISvzhtzV2jQi?=
 =?us-ascii?Q?54BQc69MlIPSdcE8HdEQg3vgPNBYHynYYQongnDBLyP0MKVBVOoW2CCEjy5x?=
 =?us-ascii?Q?qXNqKL1hnCNZ6CJntMFH5z/rbBhmhey9JOjzGveJ93Zljtuoae0CSzRZzVBm?=
 =?us-ascii?Q?6+u3QLUcFs51R+fCwxhIyDUA+++nWDaXgxrSG/Z36q6zp90nagUEdAW2vWmi?=
 =?us-ascii?Q?Eu74JkLq68avuhGe0X6oCrzO5k4Jtq6TQjNZFJPpYH5ZMH6HQdKGm2p/MM+a?=
 =?us-ascii?Q?E8TA5DonotmmfBm9AE0JqwMCmDm+dL5pJ0ctpE7mQ+B0sxKOvLWe4jxLtrvH?=
 =?us-ascii?Q?5gyGTW051r+thPvApUaBz2r7ttO6uC2ojbU7z90fCjeevpwa9jT8O8feB8GD?=
 =?us-ascii?Q?SACwABgoX3cBxMx6RqPtZ+hPBaXZlJR/ExbMUYczLRKMvD5zqLvqzMfE7SrA?=
 =?us-ascii?Q?m93F58A/78LsVTiZ2uAK1cysAM0/8ZdoVJOJE8lw1g2J60l1xuzp3RJhIeFY?=
 =?us-ascii?Q?HSChAstZ7VpU+iZYxfdt8OApoG+JF5BhRGqQJ9zBx8n+dE8UwP2cxX8cmY6o?=
 =?us-ascii?Q?COoYoP4DfFyZQ4cvUQr0t8FJsvwbY93I0xVpr+y7qIJrLGHfEwdzUyxzdyqu?=
 =?us-ascii?Q?GQV9b30kbrRzyTGlknGnkKsYfZ+kbbpeOUQjsgyti2ijGJTZvEY2hDROC1pz?=
 =?us-ascii?Q?cov8gEtoJo6MtjExs3cvipDrOkZyuYDoryI5l/CC63UE403Y3qWwD02vd6D/?=
 =?us-ascii?Q?dYtOQv1Nf19wdeLqfjYZAAWPn5GDFfH8DmnW3juvUmyVllK1qAubvqqLoePm?=
 =?us-ascii?Q?RHCSon0aEOWs9DQjdKHCj21QWwOO8V68r80VGbLZRA8hhkoGhaahmthUQpBK?=
 =?us-ascii?Q?Ly7wdeSVp0pDqpWTqi+P2Nodk/GntW6ryi3Chk1fiorb9LCSvUfQsgahvynP?=
 =?us-ascii?Q?yUJ+tXnU0dbPmL3fq4gsQPTGmJp7iBWeob3GECPsk5IeuzQqLZzBUwgzHTnN?=
 =?us-ascii?Q?FDbwJ18A3G62Nj0PBBsqAFy75puuLBwmEWQ29HjweI7DDlMRzU6ZnHlTnq7C?=
 =?us-ascii?Q?ixYHk+HbHfeniDkCT+4HaZn4Zx5fjbAkyxLpy7LV9An27gbeJV493PmKuScG?=
 =?us-ascii?Q?1qkeH93Df1MZGWh9g8Axc5fkbTcWvLxHKQTczqMWLUz0eq9QmV55mTHlhT+r?=
 =?us-ascii?Q?IRDRM55ZonwfbCxTBg0jRKjSbsmrZWyS+fGqECWY2qMc0rtBev5j6JQ5468X?=
 =?us-ascii?Q?VTV+/kGFvqgkgDabqol2E8YO51ZPcLJwTYiLFBOiwaRkEije/uCWD1hh5ocG?=
 =?us-ascii?Q?4xEfs31FrbMrM/0TTGbuEJ5xOEcK2k5ToixxdfHh24A3aeYCMo4ftPjDKsAG?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6db3609-fc6c-40f4-2da1-08da820b08d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:33.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Z9UO/xy9RG3dFHpxO4pCAOMJ3+ZI5RUxlX2/AHFKA5i8mWF31jbtji6fQHETJ7sL7mEEwO7vdSPvteG3A30CA==
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

dsa_slave_prechangeupper_sanity_check() is supposed to enforce some
adjacency restrictions, and calls ds->ops->port_prechangeupper if the
driver implements it.

We convert the error code from the port_prechangeupper() call to a
notifier code, and 0 is converted to NOTIFY_OK, but the caller of
dsa_slave_prechangeupper_sanity_check() stops at any notifier code
different from NOTIFY_DONE.

Avoid this by converting back the notifier code to an error code, so
that both NOTIFY_OK and NOTIFY_DONE will be seen as 0. This allows more
parallel sanity check functions to be added.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v3: none

 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2f0400a696fc..008bbe1c0285 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2710,7 +2710,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		int err;
 
 		err = dsa_slave_prechangeupper_sanity_check(dev, info);
-		if (err != NOTIFY_DONE)
+		if (notifier_to_errno(err))
 			return err;
 
 		err = dsa_slave_prechangeupper(dev, ptr);
-- 
2.34.1

