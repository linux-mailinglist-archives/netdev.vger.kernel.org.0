Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1975ABA88
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiIBWAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiIBV6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86E3F8ECD;
        Fri,  2 Sep 2022 14:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExVy7nEZp6FWtE4i8VI/2O01ZlEfEuN6oOx1lE2/mkJXjKDtlClug5lfQY3c95WoiWlzLdgbkXas2tsWzj58OM2t1+Do/HjCMLL3NQ/OVo6PnHA4aXlQ0UBeUYgl9z6n7dN91yXUULwIPXVoVZyYGvn05PwBr/+5ZLTFchItVJqkv8rF2Emye+NsME9A6et3XBqGlJJf5I1iI4RLf230R8rtJJc7quvHlKuymQ0r+uaY3rlmlMPh/byH7vSOkDJScNzzGtxjG69cyKA19TULweax3drQgB8tz9VwHAN12RHSLLdyi5nwBmhXBjQP3Z6NK01Wkn/JnsKXxsg2q12C0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqJP1HjUKNiOj19I0PtTLzwe2FIfFYUs1TMZxj3zRTY=;
 b=jVv/sa4NCzHQ0zupqGdfc1xzdZjNM6SiJWE8gmf0N8GXyKGpiG2DaK8Z2axPrepfyQmv/0cKI8dDCVYCVA+FUiTaoJUVcLp1fP19/sNH7pzutxC2qdgasgFHYDLRwH80y5h1hUu04iBcp7+l68Iw0AoiDlijItZeGi+QfrA43yOvKIhbz58YeE3dlElak+ZERyH9RlYURW+NMiVpbp77yLW+vZHNH9Uz5RMQOlDp0Ir4ML/e02UcT+uDyD4/Lesw8w6WiL5GE59SPXH7K6lotyGJprX27G+zl3VLUUHDRR6iFuoShX7vzPjjUsYl0X3HWgy3xG/BhnR7fU7p86jIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqJP1HjUKNiOj19I0PtTLzwe2FIfFYUs1TMZxj3zRTY=;
 b=m/ToFdIwYu63JzdKmTQdFG2Xdh2nlA2b2FmWgzpSuKLuRAB80USmbQxHeM9WgoU+Cbj74RzVihk9sRs95bY5W+oyjBUL/a3CSQTOaPkTrHB3YdsBmPLHZ48cEGnn6o1FQfs/jvD6oes+szJVF23NnfdxkcBF/UBt4qkx9lwp7G1BJmfQqkg7WHQkpcw2nW80lrzEF0A9WUPSWGhjYRKreGACkuJ65pSfxN1zB2P4cCU437PbwGQKZTyFzRp0obrHw32swEGgAw12uHRMlhUa9wUn/PSGyQMFvOP01FGA9lEvQlexDq667ml+k4wW/0jVh1s8iE8rORsQvPSya9uExw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:11 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:11 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 11/14] net: dpaa: Use mac_dev variable in dpaa_netdev_init
Date:   Fri,  2 Sep 2022 17:57:33 -0400
Message-Id: <20220902215737.981341-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7637fdd6-8897-4dbe-c2d5-08da8d2e3a05
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7W8frS5KKDfntFb6kXWBaMjpzDFGQZvsQzwR+XwpW4j1kEGTnbw2kZdhgnt5JxOycY+xVcsr2V841SQnnSonCFVLclGOeBM5bPDafxCy4brmYvxoNSomk3/PnTnBhEm80PIE8xLu5FQeJ1+7HPDCVaSwuN7MokALzt+xlXy1uot5YZcj1NzpO6y2e4Ye4y7LeTJCySk1FLH9OVjcbq/+Mj29Y74yLjrIpY05nIoXRNuJIusCtdGERHAvrANMkDSpVMj1JiMJN8ubcgk8AeQOlojCxLWRtHjAsXUkZ5EdH9s+zYqMrne6Tk0ijpIwI3P8NhOmAqPP/eOJyAqyfvdFJ9tmBqdY/w83ad8pvY/UUcGZOsU7XnCfNMlK2bhugnYbHk5A6qFSTxhQ3Y2DY1idPvVJKqGvZrSbwgteiiq67iQVDkQhmWKMFS5qC+M3ir6TBa4Zel5jv70iZnDCGCy/DQVngmZasP0pEB9QNm7VD1JEtSP6hMOBnJJvEmMotMlV9Gy6LXBTGk0mxfB7l3VHpSkBBEI4QyY19WzUPMvOEAQIR06Iyuz6MLLdx3hMgNMuhc2+FzBdIumU1e7DYf8cXfreOWqG5BzaEiFl0Pg1TE6JKev4JAn8kdwvMt6pqWtZoW5lSvN9s4bn7pglQ4FFlHdpJy49bIvilWYHa701h2eXeTiosYmj0BI/n2odR0TVB2+L96Nd21IRvRG5gOJzJpNevh/gBbZf2iF5YeiXxbQv52c7A+8uAlkw4UTVdS5OeMzujK3QSTUJwMvpcBv6qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B30O6cme8wh9glCT3CZgZMgv7BuZu7gO+Y57x9qZJD8chVFJeYrWICXeQVnK?=
 =?us-ascii?Q?EMQMVZBjzhWig0rqCam/HKuy6VLvJbLLSBCvpQhujLr2JKs7Qns25FNEIDwq?=
 =?us-ascii?Q?hThHUCajz+iBBB5l+yRizTxJ23q0oo0uNYx8tuiYEYG3e0CVChNshD+zIFbk?=
 =?us-ascii?Q?25qShUZ7c0T7cbkLt+VcVTE7t2QwECNslxjpSTmiHezYY9TKLDd19Uhw2RYM?=
 =?us-ascii?Q?LxJW4lSkvUwSLm1vTRMDC39boECxeVJhuP7/rZN83L+BPB7qSWPLXeQLvoIZ?=
 =?us-ascii?Q?3KE9wRUn9Ieschn7hN1v2RZgNvnY4MqZSSDlO5PxXOOY7VhLLi7NSn9x/nYT?=
 =?us-ascii?Q?aB/hLz7X+3GYg1qWeRGa0n9qeSFMRddmDcOanNMdhv31pGmImjQGVNNJn5tg?=
 =?us-ascii?Q?7gb94lOim8RiRaEWbsmq379eBLmaYheMxubz412J83F7JPA4ryII1wCvTbKg?=
 =?us-ascii?Q?KI+MlLb2ac7wi435hjyWdjLfjpkhz3DslVCgAk1RqTHoaor/xvSV5V7EZMCQ?=
 =?us-ascii?Q?AtM0VYrLuMxuTb5VEiaX8MzCB7Yp5f3u1NU17ViIphjuQAWge8WGsvg66sG3?=
 =?us-ascii?Q?4mMMHChhnqNbcFmVhH+ic03TGIMCuhZ0Hf0EXK+UJt/diuXzrr4He2Si7NDy?=
 =?us-ascii?Q?WgDyHdptBXeboPunAZQtsSa1zpL1WCfw8I/pm9jUzV+Zj/U1AwInBeFZLxls?=
 =?us-ascii?Q?HcCYde0miskP84dmVewa3045kNb0XyDvFbR9x0TL33jTAR+VgI7TO391+BCl?=
 =?us-ascii?Q?gZMsO0v9/7B1tmiF0AnmFmj0kRhiNhftP5fmV7MnkE++7RQfUwXmGp/AcB0p?=
 =?us-ascii?Q?Pna+Q/gnWUIeRdwq/YjI0lo7Nf6QaLdHPF99wPEx+znYtGOgFEpLMugzVWQA?=
 =?us-ascii?Q?zrX9ZjQzGMY7kGnG4BlZiB1dCft+gfj/duL3zTHKZsJlr/obIjF1b59dRAuF?=
 =?us-ascii?Q?BxshFoCENSAgeIDpBcyvu54QNFGfpK7rp84/eQL7jdC9DJhVDhRhFhfOqzXI?=
 =?us-ascii?Q?++fTL05Io2HObeMBm6wKtx2gwHhZqYpuLByvZoBSqwWHq03O3U8qkkJfeMW5?=
 =?us-ascii?Q?T+8JEyz1XbwvGclvONUxr79Ugponamc+tTJ9Z/SHAP3YI9VPxplyVC6LyZhQ?=
 =?us-ascii?Q?SwsgbKtDgO2CNo9h4CZiNui/IMYN2qypMHQZN+CmDGmKFFV/iKxOk7gf/l5Y?=
 =?us-ascii?Q?gUWvz9MmOuKTJH3yHuQpTX0NjKTlamPeyu8qOcaxTuxT6Is39ERTXCRxfDvw?=
 =?us-ascii?Q?nBFU3k67KyDNspszPWSZ9GGBkJHen47hQOjgn5Kf0F+0oBPsukymLF/FRR7b?=
 =?us-ascii?Q?Hp5snc40ELgFgpbp3YflmKJOAfhJ9gdDvLGPbCA38jnTIZ73lMHVUsmgIRgH?=
 =?us-ascii?Q?Lcs3m/PYh5NaStVMyz3g2Zvfei/B0E4bpOcGaVqk5t3z/RZxI+12lBvY5C8U?=
 =?us-ascii?Q?4RK0cWVjok4q13/pWA4AtQ77b723FbX68g+wlfSilhgL5Kty6HpVNVjuzaK5?=
 =?us-ascii?Q?TwLqOKdUgIl2ZTInbb0KymtyEmrFXla8HRyuePFQCSu9mew723Zk8j/QPEeJ?=
 =?us-ascii?Q?XkcIk6jNc2zmX60ovONRKbxMGI1hhPYmE1JdQ6W6havjMglrOOyAfh5UaGej?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7637fdd6-8897-4dbe-c2d5-08da8d2e3a05
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:10.9689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMRb7fQiRw1u1LY4sLsJ42bHslO5HttgY/OpZHzvCA2OQhz7LBwKYBLb6QFeGnprq9VkAcjXfCjxI8HLYg4U2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several references to mac_dev in dpaa_netdev_init. Make things a
bit more concise by adding a local variable for it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v4)

Changes in v4:
- Use mac_dev for calling change_addr

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d378247a6d0c..7df3bf5a9c03 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
+	struct mac_device *mac_dev = priv->mac_dev;
 	struct dpaa_percpu_priv *percpu_priv;
 	const u8 *mac_addr;
 	int i, err;
@@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	}
 
 	net_dev->netdev_ops = dpaa_ops;
-	mac_addr = priv->mac_dev->addr;
+	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
@@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		eth_hw_addr_random(net_dev);
-		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
+		err = mac_dev->change_addr(mac_dev->fman_mac,
 			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
-- 
2.35.1.1320.gc452695387.dirty

