Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3CA67CB4E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbjAZMxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbjAZMxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:53:43 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2061.outbound.protection.outlook.com [40.107.247.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D7B2B619
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMmlT12YokYtdWZUzB6mC9Z6hR7F1j9C5FvEhdK442RuNCGDcU7kbJwkPBbQBq3QdVRrVUQeM2E/KXGgxZmP1GZwcI6UjrXTnV2NI9FCvGxM3oPhfbE0WbicEmOIhCuczLQXEGNXAotCUPViCAA79Y/MLEDHkj0kHz7oXPwik1ZVFmTL7Gyj9VyAmgOp2qEZcEw1SFFYac4ERBvhXeEfCKhc2W5aB1bTsNwp0wGmvtECdSA47AeQ2zt1CfLlj4nJR53XhvVpJkVTUE1Zpewlv73sAarD7sDb43nYhwKy2rqw1xQcW0dsZ1GPH3ibGXnpOVC9zs7D33iOnRfp6MELFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtlPqUmBkWwnPvOXXr8NvMr6svEqGlwO0E3nP7YdIxM=;
 b=luRQFgKdtLzjc03kDv+ETq3xNkiEImjAOuKtfjqS/578Enu7zeYqY8pgiQAqeHLEXIbKlzllyzaTlc3YKIkaCj9jxQyHxI6R2UMwYduS/Jk6qUrxCIsikvj9EgmXBQeb1l6qLywYjKbkatUvgZNV1FfFe14uy1038QH3lCZ3DPBqf8Oq18FG4PVncazCvqOqS7jcB7Z/RGjLClgErFBXfwvwXQkvX5lfplbzgUevScW5BTw0yfBC2W08ovpChBfeyKKhsur++hb2bbg52B9/Bo/aId5Jm9xg2wXCvVVfGCHWDj6R12DItl8btVUN5al+9XcYXfbXgi8EGOzRVvm8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtlPqUmBkWwnPvOXXr8NvMr6svEqGlwO0E3nP7YdIxM=;
 b=jmT+VH6EfUxZf4fGQHC18oxzFYqygS/0qx5TOSU/E7IMjl0yYSaP5yDE9wUYkr0758NKdrgJcugry/aX1jnSbkHItcUZmjeSwEn7KdJ4PRfUdC3Q052i08ksQj7JVfvI0wJVPsHN0znrj+Nyl5sL1qDYc91ZnEtspdb8he34mYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 02/15] net: enetc: allow the enetc_reconfigure() callback to fail
Date:   Thu, 26 Jan 2023 14:52:55 +0200
Message-Id: <20230126125308.1199404-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 90a052bf-c3b5-4b17-091c-08daff9c5711
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XmdsffoXqMJxozHnodHe5qb2QBHToqSeMIj1loATfKudTsEYcnYq8EiiT7Fra51W7kwrx6MVZ586gsKBooAp7txy4AeDPwPCVpjKa5hF6mXPkc4NGXKH8n0Ig6EMF/nGEuMT/PdoC6SeV/110bZ1tGCLDNWOOIZQiArdqEJ8t/PranPwzmmXOTjz8kTN2NReYs/BK1prA27ZY7Ei+DA8zoMKu7kgmFyAEljdAvFwcex1DBCXCNb3sU4vJhuZKZyUVMmNOiVMa4udVp06hBKBSLVAPnJ8I+uRRd5Gmp6nNizJ1htzcEoCcuKdbjtZ3EUeA+Tuqv2GT/2MCX2DysfwoMl6pmWE5p3PU7QdrsGH9+wXtO2XrvrEhYjL1CiC/0mMuCRTZjXYLoHsWgCGv8V/erTYfyCurDgZWuttzE9EcrH5dtUPYTZGVpR+SVUpePIyRRraX6Jn+JOm3ysVFqaUxClKboL9H9c2fVJD75kzE0OzMTLoEDffpoI/eJMOHhCNOLOn/cTYIYhutJdlWYK//1jLe/eCwvlxhTG48m8391gT0HNP6Y3FmYPx0PaCFChYiN9I2Q8ZRO0ckbxa7cSav4szYLzQJgjwUz21GpjfvPKU+BoVjL58zX2266mzI0+X0ht0KhxJs66F8nC8wCfjnSU1JIt7Rouko5uN1JI3ifZfCjpQ3f0A3O8rP/OUjS5fIDpS45N7bvitfKjXbdl+oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?STYcBg+c5rgy+QiJExdDXUJdTRECqbaR+0tetYzKRrB08/QWUKsSlMy2slnk?=
 =?us-ascii?Q?oLC3Z/pKBZaS7Qbg8oH2dGz7m1RbSiTXu+aMktbkmuEHp2K1Etfaae1K7Nvb?=
 =?us-ascii?Q?FMSN7uwdC4yAhUMuo+gP1myo1Gjys/A13cSdtSVJel8acpezEnL/JZG+vx7O?=
 =?us-ascii?Q?CotksifVAoNkFNyY7WQxgw6LysoVsXm0hLRFv6FzpSeQQJmeEE5mVkQYoZGs?=
 =?us-ascii?Q?d7cCcIwR7gPvqJnWpLwP9sQTNdK3HDHaJr1mRqCqnFfOueCFOXss/6MXi43W?=
 =?us-ascii?Q?AIXFVzbdFFiu49sZQ76RSlNvPq0Jxavp8jeUkckbv5mOnkh4jmQrNdr5lS58?=
 =?us-ascii?Q?iutmaBewT96liXFJg3JZNE+ngJlKUCPM8RJe5mGUWr1mxHUcCGxeEqWLFm4B?=
 =?us-ascii?Q?SDtNyRWyvEweZB0tSCkmZowB+2rUcFKx1i9OzDUzn1BsScW39qr+7G6QinIk?=
 =?us-ascii?Q?DSr2U3BHswCdCOUFiE1DXZUS3/FykFY3CFIwKmOnuQLx9+xiUicyo0bnsDsC?=
 =?us-ascii?Q?fve9q4Y0r0jKWLncjxc2NiSN12kcgh1KLK8peR/nldBZa5D13I0klXestq+n?=
 =?us-ascii?Q?z8hEW0+qVvApxpFYWV9ZHRLsDalkLVuqqn3raC1zWLstdASzL57gYa2QTCsf?=
 =?us-ascii?Q?E+xDeYDxu19+d2H0FnO/vs/DtsiEewJVfwya7LOQT/nAr9I0PjhfHefbf3/W?=
 =?us-ascii?Q?ST1ooCo3KIw27Q/9RWfqIytDvPL7yiw878ABgkedmrZ3G6k4G4uAXc7FYNeo?=
 =?us-ascii?Q?toXgDtSLUiE/o1EbxgelHz0MYOGb9z/fCjcdTR5J9msVFb4XQKoMXpMQ30bn?=
 =?us-ascii?Q?FQ+dgqXaGKuRg+Ve9qj9dEs5k0QsXRimzFbOAjIWY52bx48rFtD+5wZ0dToe?=
 =?us-ascii?Q?gGYDayupPgABkuqMdQQBK5R3lZGzkS8tb+YesuRk5n3LmdbVtPmCZlHBUBjl?=
 =?us-ascii?Q?kXn9N4C3S9NGdaUODz/xMTbHWYs6kLK1XcJfqUcOK/rKNJjKIzSib/NUmSFX?=
 =?us-ascii?Q?ZZt1a5ELPIrianZ/oLJr+DD0Qdg1gttUrJCH7UQJIiY5nhBl2YXrH70lbBmD?=
 =?us-ascii?Q?4LWhnTQN3EVx0GxvEiEGm/v9wv/IN4JrGUhm723PiTbyVnRWWsXZ0pzlg1l2?=
 =?us-ascii?Q?xzp0GlynL+1PeXRuHNrW8fBV3h+Aw82SqBjExibFd/DlonVpyi/+lsZgJbqi?=
 =?us-ascii?Q?67T8IMBf4yip3aL/Z3MgPKXF9b4Rqk5R9y8CNgi5CyJIV74kbx84ds9tMPKv?=
 =?us-ascii?Q?0hHu6ofYRQXUNmUn07ZEKSfRK2Q824WRpHd4E2IoW0kzsvbU2NIrcuQP6g9C?=
 =?us-ascii?Q?bvEtdcTR3S3DSdQ+IWr9J51VNzK0Kqyz5abDmzXJmJe3r7kPAgEdea+kYZus?=
 =?us-ascii?Q?9zihX0DuD9B5ErzdGWAjfX9ZOuMUgKCsJlw8L8NttOsQ8BP83Qe5sNfQ7M3s?=
 =?us-ascii?Q?gUmRHZLqJFKBaC7dff3UG6SxGuwaWHKgXVsUiPcFP9pu16VGma/bkkjM85+x?=
 =?us-ascii?Q?mBjxawLthzA66uMGC8OwsM5S7YT1zjfudbuC61qlytUhQAioceg8987RRO2N?=
 =?us-ascii?Q?8RicG3r2I/KGwbeiFCdkZ7bFXbPPJp6YQvbx0Y3Rw+4eqqM8i1IjAtSz/V/V?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a052bf-c3b5-4b17-091c-08daff9c5711
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:36.9405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BHLrwSKaUyaiCiOJLWojXJU5CgixKmkE8NDrMPNeZVDCL6skMxDSsS0iALnfGHA9d03+0uRlqN9SL5U6UgnFbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_reconfigure() was modified in commit c33bfaf91c4c ("net: enetc:
set up XDP program under enetc_reconfigure()") to take an optional
callback that runs while the netdev is down, but this callback currently
cannot fail.

Code up the error handling so that the interface is restarted with the
old resources if the callback fails.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3a80f259b17e..5d7eeb1b5a23 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2574,8 +2574,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	 * without reconfiguration.
 	 */
 	if (!netif_running(priv->ndev)) {
-		if (cb)
-			cb(priv, ctx);
+		if (cb) {
+			err = cb(priv, ctx);
+			if (err)
+				return err;
+		}
 
 		return 0;
 	}
@@ -2596,8 +2599,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	enetc_free_rxtx_rings(priv);
 
 	/* Interface is down, run optional callback now */
-	if (cb)
-		cb(priv, ctx);
+	if (cb) {
+		err = cb(priv, ctx);
+		if (err)
+			goto out_restart;
+	}
 
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2606,6 +2612,10 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 
 	return 0;
 
+out_restart:
+	enetc_setup_bdrs(priv, extended);
+	enetc_start(priv->ndev);
+	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 out_free_tx_res:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 out:
-- 
2.34.1

