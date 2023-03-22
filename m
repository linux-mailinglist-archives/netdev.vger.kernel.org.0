Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB106C5A99
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjCVXjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCVXiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:38:52 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F4828EB1;
        Wed, 22 Mar 2023 16:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NO7ST1lKfcHN7fq+fRGa3MM0UL3GkdLVVD8jfRZaPnWIdzT+0qJBxAkbLYkhKs/zU+yoAI5cSO5g2q/MMzq5RJqWiz+DHb6U93ce5J/oKmaP0rjeqDGFEDJQL6IUsFV1VqI5/Ub/HcmVfu1rXyMPHPUG1Lo0XFr+DyL/XlB+Sr2pb/y5boPXeBCwvJ9slVdVKq2uYwpwCyI4roIyI/ftJy/QfzALOrz5YRkBLLDq3zoCB3mwPrpimNlNlMq5D8SZ39+OKdMOw/wtKxPpKGSFOHI96uy8CYGd6drPi7zCefoU5qfi0ttNC8ateTRCqoGiaKxNBvwCmLvF7NTDK4ZC7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQC9E1mKKbfbWTDhyi3o27SFOVt3LJpkRfuGkf7z2b4=;
 b=PscF8wONmE4VhsdWkZK5/tSDlEZZk0I7tZrgYOmIm0U3qq5Auo3hLQdRau/fpfzTPuIrYIF0RL7DpvILs1ZLW3Scvv4hiZTUH3fay8kMRo8geUF+B4ovvNVGrwmHb19DGsNOrkUwoTlJycUyDqlh6br7rQDR5fM2aKwRxswaYVdHD1I33cxAr3EKMLycKOmqpe4A+HpGjEjqWYz9cDZDj8WuLAdcl0dHcK+OzadbU3QbLsQpjgVDeHqxcanMJDNBLDetdtF1oX/1ZALe/F4s+NmmGh8XCRXW4T1HgVUhrpfzA2Ib5tDtlGzoTTaEKpFzaSwbcoLsFPiZ30w5hybn5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQC9E1mKKbfbWTDhyi3o27SFOVt3LJpkRfuGkf7z2b4=;
 b=ms14ngxnwWQctn0yNdgFI1HILUcEpxAya6OO4Mvz4Qoty9bIzQkckbCAWZp0JxG8eIAHzeR18HGo4nRmQPOks9hTJa8JAs79V6PPrkUzPKU1Ar7BIcyLNDqdzR0NCjjCZJUMsgMfrTQEKt+AnaW82CtNQTpNZLQJ1AFoB4vSW5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:39 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/9] net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit
Date:   Thu, 23 Mar 2023 01:38:18 +0200
Message-Id: <20230322233823.1806736-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ea8d63-45ff-4571-1735-08db2b2e9024
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hoNJSISGJO4SDc6puM3sQezirHFF5V5D104GAe4/n61CwErYLX6LKrUHPzdzqMaynukYKU3eovtAqe6K6AUY0Qbd5ippKDj6Rfm9MoyB8pwCsnQ4iAnjiEis34jvnm3qBk5rZfcnCavttjQrBa7Jfgdj8UArK7SB4hI9A3zy/sF4qb+i5HqUBSUzNBo3f72sm/QuwYIkmHx1mV1vUkS0+Akv3QAnMeSt07UrGRAL3kdxYQ4j8U2dY/svSyBEocKhNlcU27PHIwTFIwqOhJ5UoIVXeZxFHgRx3dKzdTDNAl+5teWypmOd2RZdqFT7igtU6gNoDKHs+3P2pO/5b3CemBXEK6MVV7njZMu4UDPLaPXij+XH6/FhQKKyaldzPeMeFpBv9P1QSuqmWbyE7zry+Zt8CbR1kHPoDbHs3iTWUIe+EzjJTxJOe5CuNWAcjGBtfnAXDnu8PjT5sqkVDIxdK83CRphqzIRX6J+SA0/shrgw4VVvTqMt0uLHgbyiIppywGi8amC6TiK7zFy61gFgI/bK/5K+i2pEGWhTDA6YAf7K9j/QHFXcbNIQRwt9jte+fvEh0059ZYT02sHI8w32yp3Si1t61ZpImfdWZ9ucfQHTOzFYm57kEv9W3CHpMiql5pym+pWUFCIWdS7TCxT5kKh54tRedDghyoOTtiU9Vl8shz1ues2VuSjo8Kf7Vm0sHZp2QLe+xHdJLHz2c3H6bH4l7/Pej77+RvLOTAsbircg4/Gpg9El3UsinPZlYCP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(4744005)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ui1QyEv+Ene/tmOgOlofC2syhIIG2d3QJFLPrqYRqMbayDf7pQUcqDKXzI0G?=
 =?us-ascii?Q?tTTqQe05q3wqrg+fH5WeLkIIlYYdmH34yiw0pFsJh6SninBS/MkFSNxetKPy?=
 =?us-ascii?Q?HRmFwnELP3aQ8rcCPucH3U2BlXzEN4Zsu4z0xvZbJfF5r9VIKuxz1/J1ZVrp?=
 =?us-ascii?Q?EVwK994opFrCRDKCJaeuJ4HN6kDEjxCKpHQkID2a9W+9Xs5i7T2Ph3HNuXTK?=
 =?us-ascii?Q?KEhaLvR0dFtcC/JRvSi2vfTWaZ7qklil+NQiMnADyjQAe4dNScTjp2+YIGbx?=
 =?us-ascii?Q?faPD461Q5llt+H4CIyx+58NjhPUifiKemgOXMA05Ft/Xb062SeIorJKXuRUW?=
 =?us-ascii?Q?+94yTToqOKR2HIGdltV0G1tZuQhi3+hb89AgU7Nw8AlfDNrdmVb887FFj2kg?=
 =?us-ascii?Q?JJdP+2uoqWRJIHRSlEF4DSJgtF6CTH1BrAIBNqN8xZkclqRUb/ohdDwCFrrJ?=
 =?us-ascii?Q?qtEL1qERb/xqIJ+BVRrH0B0ssTtKBgWEX+fiGc2MmoCwy7eXERcaRcL5VviX?=
 =?us-ascii?Q?vPcVGxtIu+lsDGNMVIAdVxXe+wahfL08ezi9QREs9GIdNzXd+Qj9IMT2mZIN?=
 =?us-ascii?Q?zBslzl73BryBIEXed0eyitJ369Sq9F3LAPsugx2jvIiIiQy6IYjPlbn+EOtE?=
 =?us-ascii?Q?JoT4H794FaGTiROW0/7+Pw+HQpOMYcrDgv8CJTEa7JGqR7yIqkQY/ppqKn7m?=
 =?us-ascii?Q?LHl4oDUecLH+8QtaU0dJ0AYoM54MZCe2e96YQWHou0LTBUJV3lcpNFbEZv9+?=
 =?us-ascii?Q?SxY85woJbhJwlWhOyOYHnss98sLFEuQljICFx23+94vBo24wm1yk/6wEcxh4?=
 =?us-ascii?Q?6h/VcJIpsKsXT0NpBeese5Kh5+R2CL16Iu+k/D36cnRDiyWpF3P1MulRtNC9?=
 =?us-ascii?Q?gIXXTY3KkOaIj6G8uI3NDCpyPCslEUEvDYIF06atQaZJ4e27nm3nzal/QIF1?=
 =?us-ascii?Q?hN/B5oO3i4hfiCngQPlEI/TjKENA3YOycnZ7KPC+8Yy881FW8XeyL/8S0/NY?=
 =?us-ascii?Q?B4Co1WRz0KpozAqClJ7e8+JcoStodbuBDg1oMLguNDAstqEFViz1XCEMvrkT?=
 =?us-ascii?Q?vM5aS80JvPsxwzOS+Pf7Vqulxm/7HWsCvuT7jVd2bpXFacA7pB8pyYTWBSqI?=
 =?us-ascii?Q?huJRadH+/Xygis12uj8qdew3mQ7HPRNSpcGLLYGWHTfBu/XYkXRJoUFUTEUr?=
 =?us-ascii?Q?+ihPrmmfcNdS6r/R6etNb+0elS90iZMuIziDXdErsq4SqxmG3Dts+5MsTlnH?=
 =?us-ascii?Q?mW1g+OkVv/ii7Ziyi5cyNA6DYbK/GpMVrrkOOMToXcgOxiMAX7mC3ByZFIOT?=
 =?us-ascii?Q?Lofize4oE6EH1EH/6jTMZrw/vIR3FDwbPtafZLOVg0ANRnSZ4xtiaEwuEymG?=
 =?us-ascii?Q?Pre6vic+nWNZm1q/6Y5wtKNT/p4EYVhKO0QvCfBs4Z1Jfct+zbHWSOzxnSgh?=
 =?us-ascii?Q?l6Ft1yhxbxH34YzK0O957PFQBrkc8hj9KF35xDowkVvmlhJ5DXlxn1HpPO1r?=
 =?us-ascii?Q?GeADmY+7G4F0nibKOcF3/AkqzlbxdzliULl3VBZfvStc5Wmc/9e/syO+KqRL?=
 =?us-ascii?Q?3SjPRh91+wt41cPghcrnw8M3TDNIGo05wcvanJ0Y0hvkXRzQKgstrHn0jytG?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ea8d63-45ff-4571-1735-08db2b2e9024
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:39.1393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niNLUr0SKpQTQe1dAQbWe/FtGaEmWuPAuzKK8km9esvbao4u0C7xB4QDZDsULbHgLHfI2+CAEGhF6/IaqguyXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
---
 net/dsa/tag_ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 28ebecafdd24..73ee09de1a3a 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -26,7 +26,7 @@ static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 		return;
 	}
 
-	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	hdr = skb_vlan_eth_hdr(skb);
 	br_vlan_get_proto(br, &proto);
 
 	if (ntohs(hdr->h_vlan_proto) == proto) {
-- 
2.34.1

