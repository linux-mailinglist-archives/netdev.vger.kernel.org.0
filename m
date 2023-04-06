Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB83A6D9377
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbjDFKAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbjDFKAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:00:11 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2078.outbound.protection.outlook.com [40.107.15.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9728983F0;
        Thu,  6 Apr 2023 02:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBmC0bSGPxOtM25m3+x8Lx3ptsKzvy4Ps+DkOfhenboIV+6p7Epl9UhSB/NcqZa3AJu8oLEhsDcjAwWMiibCUqsgcsi9yZFHctNYAXTJ1DLlNpnedrxZvCElc7aMbeDfaAmazvkGa+xa3cYBhok8xlaAvGMVjerzPIA5ILNTGN7oZVPdjqzNKonRk09FNCvlWBqpVcmhUqXbuKX1uR7Rh1mdfX0Y01sfNiIM4U2xl69G1uEC/WAn5hl7zd+pGgixRhTpcxVgAuZ59I5ue+fGKiuxF4MXtVkccX6BkIWZg5LCvDsHaKF2tCEsW2x+OGcYQSIFs2K6GWLePZzAxGYzJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNvpczeUJhO0+2pGzGINOoU+y8NN0LYqNu61h7HqIxg=;
 b=jZEv61TLYiRY4b00r2fhMqHBeXHWq9lpAq2JbnbQtxq6sMZSdkgklNtgV7ENW17ejEwivFiwbdJQkqKxCS7UV7ZcN5jR2kUoWqDADbnf08gQuE0QFwlCRD47M1CbjdlFhqZedULw6ZbxBJtYNJLtJMpkISRg6v9rn/y0OAnilcvsA3GP84I7Z+nL25FnJz02gQd9JUdNk4wM9nhetq7MvG7q6aUPC6cH/DMqAx3j/aaxyzkDJs8/9j762wajhHDbUKsJqfZAu8eQj82bK4cwZk3TGk0DDRuV9Nrm2/k5NXwFvmosUc1zJdnCCrxw72dFijUwrqXX8ttD3/jVdlwS6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNvpczeUJhO0+2pGzGINOoU+y8NN0LYqNu61h7HqIxg=;
 b=mZXvwoxwHEK2z5sZyxzJCi9t4lOsHkuZNN78ZPFSgl0GcbQCY8FV06TgjLR+f8uw8zNzeC+hXaCnjE31UaOEcbyLy8o+SH/GGnYoMD38hnbAsjSTAQ5MhhNkMvJamGAtLNVQezoookVR75f97pfvn5ovnWoCVC/fXmHPn1Ny0qE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DB8PR04MB6906.eurprd04.prod.outlook.com (2603:10a6:10:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 09:59:19 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%7]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 09:59:19 +0000
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
Date:   Thu,  6 Apr 2023 12:59:04 +0300
Message-Id: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0157.eurprd09.prod.outlook.com
 (2603:10a6:800:120::11) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DB8PR04MB6906:EE_
X-MS-Office365-Filtering-Correlation-Id: a93314ce-4abc-4dd1-c50a-08db368596ca
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07Ca5fwNElJGtVsJ7T5zoWecOCecUYYtGwX75pTTe3F9AaBKS62Tr0CAb4cZQPh2gh+zxnPSQ6ZddSBAoHMBjgLhVmP0lSFrNYI8VxRpYg+eRnodeqsYFjf7bbLwkviTblUoK/+J3nXbG5obyJBPBVvAq8KKkysOdNWGgk5Zm+yEP2g2+ftoKatvgdoc22BMHdYvAAkQ2M7813UAYIoCEuB1uX1rv9/BaFdVvwJIb6CEKZ0JbdZQHOn4+N0ID9Z1M7ixetghkPNF+DACx6obCJAwajVG1N9Zox6o3wzp1Q53AK3RFZN9/ZXD/EK5TqnuaneOlNA4qS5xNokZzJZCBGvHEid0meUxBzJwxe5xIUtLomqb67F03kO6RrIaJTf7PjAFZQbPIkhtfGibQJOv66zbL2rqCT0mKIpJ/MSBDbmeQhMCxt97E2GW5kVHDSor7Hw/BWTI8mP6I71+sqY6SmYibXYVe4t9fSuy2grcRJ8dXVzA0R8yfHx7SeTO0rJp7ReT4ZaKUMHkLHAF+7+tkPgffC1VPciyv3xBK+nO0MJ7GndyiWihgjIWmdCBN7ReZGn/SeksI43EutstuTG0qIHm9Mh5a2r5bWKNWAUIc1PgIkEFFaoulwJU+IZs9GD4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199021)(38350700002)(38100700002)(5660300002)(7416002)(2906002)(4326008)(8936002)(66476007)(41300700001)(66556008)(86362001)(8676002)(66946007)(6486002)(83380400001)(2616005)(6666004)(186003)(1076003)(6506007)(26005)(6512007)(52116002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLIPopLotMk3bSgWdVXH0A2GsXLpNMeJpAXZ2vpEA3t2D9TWLP6hfalY/buO?=
 =?us-ascii?Q?n1rICaqCct/93DF7dzHnyydJ3tRRoUbx9VDsA9KfeYuobgtckjHA7feAud4/?=
 =?us-ascii?Q?Oj5V4GboMUK3kCPdnxkkVwQLTVkLDwMFUdEnhfF7D5rEtbIA7nvzIYu8XD3G?=
 =?us-ascii?Q?W5MFhXlON+QD+asnoAJ3tbXhMDNOhQdzBQat5FqPwOD0RbndsHLQSVuJBoHg?=
 =?us-ascii?Q?4qmN9SDP3eIMZpPBt86qn0Tmsx9HI/aayawjyj3SFUHrV2iJamec012dpQlo?=
 =?us-ascii?Q?EARlgT0NUSM7qfCliDw5sfS0khwkmxxEyVsLSoALczQGGVpGR2MSv3C14lc7?=
 =?us-ascii?Q?cfECfAHf0TMiVpaSoqnPkUQJRC2TS7zX/LPNHZQXFV9D38GsTpAE4ikJ6hpo?=
 =?us-ascii?Q?4C9Gy4d2DZVj+wafAOTtNJJKuqa3DgdC1z9K7sfVxGY4ZbKMTYMCga0m/lbx?=
 =?us-ascii?Q?ZoZf0wNo/6WdwT8XJt2dEQONSqeroULso2inu4vxv0FU3WZnn79lx0MpIxxr?=
 =?us-ascii?Q?aPwk0AX4pGybMVWaoXgBWa4fC2l+b2IPsOrR4DNLzjaQTI58wEidEr8v9L70?=
 =?us-ascii?Q?GXU02o42riHRfI0QSR/bVVWA/0aO4zLa0L+TDbKOqxQ5uoNt2pxvTisnFU4N?=
 =?us-ascii?Q?pXiyiGvJvDfZwsAlbEIxjoMgMsQ9CIzzojT/Cuqs1EVHbY1CSMBQ6TY29eqW?=
 =?us-ascii?Q?PA2BuHx9s+TX8omxFoSjh3lZh5u8ZTNt1BuGvpv2IOOuAk17Do+faAech+eP?=
 =?us-ascii?Q?RlQ2BFoHTRVDwe95i+kNVG06whOSKqfAf28HkmoZkCZ1k/jBctW+LQ8JdTm9?=
 =?us-ascii?Q?d0MYwHSx3sD+qCYuA08Vh/HEdAdcEQ8eo/kPXTxzlIk145pdfcv51+Km+ydT?=
 =?us-ascii?Q?YoGdzhHvoiXQHRGtfnSlepEjT5fS0hARwYxGwKgKBjWkag5GCR5KBbnVjVUC?=
 =?us-ascii?Q?F6+N0pzaDjyLpMLNexnK4b4V6aETfEXqwiwMscIf7knwgH/WQep3NdBnVAA8?=
 =?us-ascii?Q?z7uaxCAmTz12q0EdUf5pM4W1MfTRjNA9RaQkYd0NRCY9Gy/h7c0Hqaoi/hrf?=
 =?us-ascii?Q?H3H0DA0UA914EeY83MtGINOGv2HTK90C7NIOZzQeZGjGgrbWpE99m8ZtYbA1?=
 =?us-ascii?Q?xnO225Az2V3nPaymU7ZT9a4aj0F6g1icnYTKiqKtwZ+1eIr74S0RNJIXy6oH?=
 =?us-ascii?Q?9hECnsXNM3BYLFUMcFwtySbEdapWuXcixUu68eSbvMQIQbeYToTQiGDclA25?=
 =?us-ascii?Q?FiqHzMqw+NFPJiyNGkhpeWs0060iLM2211er9D2C7hYAyq4m6gBAHi/TPDRk?=
 =?us-ascii?Q?qiHIoaYVyG4p8fEEFKLUm/12EBxOrE26FsIZruSNPzzUfN8Tzf0Nos+1XZQg?=
 =?us-ascii?Q?LYC3lkqYq8FRCGfjwZmYOsHdHe4qZep0dVt+B1nK8KM39xaeDimlHOgv3t1V?=
 =?us-ascii?Q?OrRRQR9npKRZunSH499BL6gzD9al8PQp+mrYaG/RdMjUb6YquKowB+JrgmvD?=
 =?us-ascii?Q?Es6kxINQQx9ZNUfflZ2D+CxZWwJ28payOCQPSSdla2D1PiWepfXcijwTPvHy?=
 =?us-ascii?Q?HkKfpTGqBvkwMi4xE5Jouo032cOs21i9qkkNeqtaItH9lDyYdZfjnGeNlkIh?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93314ce-4abc-4dd1-c50a-08db368596ca
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 09:59:19.3248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6yFHhry/++/QOk9NmffhWIobjXEi1fwL7oroLRQpUhHQ6Pohj9MH57Uyye+uyewM/W38ALpb2SoMFd/38z6n32xb+H6xGNYqhh4+TsNpRlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6906
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unregister PTP clock when the driver is removed.
Purge the RX and TX skb queues.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 5813b07242ce..27738d1ae9ea 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1337,6 +1337,17 @@ static int nxp_c45_probe(struct phy_device *phydev)
 	return ret;
 }
 
+static void nxp_c45_remove(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv = phydev->priv;
+
+	if (priv->ptp_clock)
+		ptp_clock_unregister(priv->ptp_clock);
+
+	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->rx_queue);
+}
+
 static struct phy_driver nxp_c45_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
@@ -1359,6 +1370,7 @@ static struct phy_driver nxp_c45_driver[] = {
 		.set_loopback		= genphy_c45_loopback,
 		.get_sqi		= nxp_c45_get_sqi,
 		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
 	},
 };
 
-- 
2.34.1

