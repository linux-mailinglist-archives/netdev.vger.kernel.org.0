Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3306E9F7E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjDTW4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjDTW4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:23 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2070.outbound.protection.outlook.com [40.107.14.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A046196;
        Thu, 20 Apr 2023 15:56:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A45W4X6H05vlFst4oWKrYZUTguwqd/Wq62k4R9+Y1ZLFprTD+7+jpvM+a2xpGjzJHO6pudDigFdfKS0urhkV+2nZQ6WJdasifF94d4ulFhJX8xDTQAJLe9LmwlMwNh195dKG7Pd/SyPfuCzsPDrSL4Tz7iv9dpjxUszx3NaFDYMEe4PjNO1CidzkaepRkgXUBxwYbHNmVQWh8zw6Vk/k91OWqyC1uP9HCfGHqW/uJkUYllsjVm5e+E0NKAUR7EYq9l3kX2Tw58Ww1NRm+SMv0OToa5YCVsZO7I3STxCFBGiP/V7T9CaG7TwUICjereaS5thfL8pTyHjs6cd8tZ0tLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0t9cQiyv9+2haPB/Rp5vs/Y5Bt5Q7jRQTlXdtGEWms=;
 b=h8Urt9erexpEyeFXRLfbI2dFGDAXa0KxsLW/dLLYFz26wRrwAsRV97IdieGLJCLbAVYF4bxn/9x88QgedZLXLgtX9JzeCTrKYbPoWQS0/QJi9/elw8qnT4XkJ6nf2CHsKpr5M9cnJvqbD/+TNo++Ae0PNo7ZOLyg3fSRgqM0eZqXgph0saxurt93+TuJMSwlA0xvOvkVb0NwJJmZlFfMIPnG3MaocZNbLkFR3qT0XkIuyt62gXXzedAXC8wW8Meg6bDpJja6M8mD6MvhgCc2whGBZ/N9tLjVMrcj9U3sJQCv2OrEv0Rhba+WSICDvpeWcJyqzxFMwSvDOv8rQpgfxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0t9cQiyv9+2haPB/Rp5vs/Y5Bt5Q7jRQTlXdtGEWms=;
 b=U4orHWsDJHen7pcmx+A+SGKCW0gnJ1E959Sh/H05nMa4efxejpn9ms7pYVU7H2lQNY3vTtW2v0H3045VnJHkDxq5Eub5OYtqF+lL+SbWLtKuvwKblbFksOQUMXY14CvG/AC2y3pym9NqRAI+hOgoNTeGpu7dJZqhqZ/bkpi6uE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:16 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 6/9] net: dsa: tag_sja1105: don't rely on skb_mac_header() in TX paths
Date:   Fri, 21 Apr 2023 01:55:58 +0300
Message-Id: <20230420225601.2358327-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: ef59bcb2-7054-40f1-4a96-08db41f272b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BtYZigeyuZHT5KDr5PRB7gCl7+e/iLpovsaGl3LeMzVcVrxwmEco0yBd2HhVPP+QW4oe+99fLuSE592Sju/Fq1lEJ/P+D9iwR4AcfXIHLlAMXTlVzQaaRxk+7l+hcgk/ZMolUr7ED1b5xH+QAfXP1UOZbLB2jAB73VInktiR9D0vjwNdhqdIYS3bfAgI7ycu6UP9M2e/z9/1NeZ360XftPXBSOTx0WEt1CRD1QFJfj2lmvEGX+rcjYnmwLTtfRCPqN3f9Lk1Y9i1N2koSrvLv735eu0sTmiep3dxtdRG3PNbF6YyrVmV3sjor3j+97BdVwIaswgxnbuZK+Vv6prEABUmpJxAPmPrVb5/MBwM1nrhrMyXrgvtHIstnnEE8zFl6QlliuT2ytdzo6m9UVasiSqsNriOJez75XcIY6oftxP8+3CFNZCrADTdh9zCEl027QPCWCBXzRWyqg2XMKM3P2l4Lgf1quT/h6KvQYp3ddCtOrrNk9f1dLTBsc9tL8dAhgxUDQUWYe2ehwR231aeoawoMNqmS0QdCXrRehzy3rkEMIRESYYLj25gk85PbSxSfgpI7v0f8Zu9w5x5IaBFgMJtQZoGqKQSMf9Q3yyNDUxMeENkvngfyujzqopAkMvr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZTEYxNjFY12egojz2UCm9Jx/r02oa4gy812gN4PHwqkvVsu4I4WQcuU4kY0I?=
 =?us-ascii?Q?IpJgCazThml2bYgqHBwL+7zX1zvu6zHa2I3f3EFDMC6XdeMryaXSh1FRJQi2?=
 =?us-ascii?Q?H2lQLMAdgAv6SviIapkNGzbs4FjqcJ3LiHcuS6C+iskCedWiaX0Q1X/3irxq?=
 =?us-ascii?Q?BRUN9OKKqugdvKFA6x6OcEaFoZ7WjZuBudKm9eNqURGeiFu6EhenyG7NJMqp?=
 =?us-ascii?Q?5C+p7ymw70TuSljGkis172zBJbiR0cpg6ARkCwBm4XGefw8BZ/gtBpRchCuG?=
 =?us-ascii?Q?V9W/2dkYDlJiX3OL/n/+MjkT1qtvCabhV5euuDqdM5WFPVkkUqgnX4hp9+qV?=
 =?us-ascii?Q?+nm2y3e9+CilLVHiKfz/ulvDxqnVnysQvsB82P+aff7ygSKyiDrzkh9C6SXn?=
 =?us-ascii?Q?OIe/JHIniQpZNlgoxlhDphZ80RqCXKuc7XneuTnJWL2CKVQ+TlVIUHtdcHqi?=
 =?us-ascii?Q?3rvzDV0TiTYwAqJ/zUVzKQbCx9l4zWoQMMCTn9DWYgwsz/5N5OtWJ3t88Thy?=
 =?us-ascii?Q?xkjl/L/xSIoA2PQgjcVuaTaqEYz3v59AHhHDxPA4+Eo2TK772WaJHyFgqnRE?=
 =?us-ascii?Q?XofWDJkeUNPIQNpewYHKlugTjniwQZMGi3zgU4He1qIPMCXGHeJvK3FyONMT?=
 =?us-ascii?Q?JgtaFnqOCZlFJGbHsyS58FS4XtVuILjpPR7mt1PS/zUXJVzideeW9zD1rBcf?=
 =?us-ascii?Q?IZuImqx7kBVzsr9Z0JXVIcrcNd3NOC533gGrJdDuG1jkGZAUoQt7YLe2ErL5?=
 =?us-ascii?Q?KWfkLi00kmBqm/hDUsKDnEINBUfJst8wjtb2YhZnEmWvRTK0iQgerobg+RrA?=
 =?us-ascii?Q?P1brcorvPpuW8h2e1oxRKEu2bXJS82NCg7ESFIbeNW0gtYwLPioximmkTgo0?=
 =?us-ascii?Q?+VTm7bOjNEjsbHX81yuczPoEI/u8zt5oEO6d61/XBEzwD0DgEQITZBFcxchQ?=
 =?us-ascii?Q?SpZ1nJsPJx+jA4UZ8QtIO7zgHoG+cPFpn8judCQVdOSRhb9SXd4fULD/tK7s?=
 =?us-ascii?Q?hw6ac2x/FR+LPOHHAXsh45dqPmFj9uTA9qmjBsZ6AKJlGErDr7KqdxkptXIy?=
 =?us-ascii?Q?0QKnpda9mdJEAbG8zCuCpLisTMgtME3L4TGvsH5eHhH+tsRW2J1mT++f52FU?=
 =?us-ascii?Q?hViEH7m7HfexdI/1ozNQAArOPxAqqJ1HtdY4GWSSi1Dxi0i/Cur2AfnP6JDV?=
 =?us-ascii?Q?WJovv+2xr0hlbMlDK2wVXp4yfozVYPMlSwdvdoDJ0NFfaCLmYY20inQHPuPA?=
 =?us-ascii?Q?OX5d1doC/2X51oYCk7b0jIx76Y/Ku+7N1ICdDJYe8Umk3owOAKrQ+ftDXlBq?=
 =?us-ascii?Q?LaXlW4PkrrrC6NDMV8RgY6LnmSzTuCpwliqGR3JYVwkpqvjgz4FfZvA+PjzT?=
 =?us-ascii?Q?0h0CBQY9B/9hq4aV5EIpPdtKgWb1P+YZIG+vdPKRcu6bWifqhCGOsiRbe+Z/?=
 =?us-ascii?Q?WGux7LaYC3A0X+vW2xbAeuIsq9LUdjSKSWd8baPZqzHBCMOM3cklk3rPugs5?=
 =?us-ascii?Q?blCSPlLghopAbra9oxjai2zHkah1sTdGy136g4URYZDdViY5B2c08o0Kyk1O?=
 =?us-ascii?Q?/rvaZE+NabDEW+5cbThbW6srSHjp+XJDbPWaYz2iRqZ6jojS8UjqXsIsTbYV?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef59bcb2-7054-40f1-4a96-08db41f272b4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:16.6735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R36w6X+fGlhtpxxktOB3Ap+z0p2ZBRVhRnRjC4kJqQIzOFrGUafgLq0pWMRvR1uq29d3cp2pJElwY7EAUvI7fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use
skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1c2ceba4771b..a7ca97b7ac9e 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -256,7 +256,7 @@ static struct sk_buff *sja1105_pvid_tag_control_pkt(struct dsa_port *dp,
 			return NULL;
 	}
 
-	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	hdr = skb_vlan_eth_hdr(skb);
 
 	/* If skb is already VLAN-tagged, leave that VLAN ID in place */
 	if (hdr->h_vlan_proto == xmit_tpid)
-- 
2.34.1

