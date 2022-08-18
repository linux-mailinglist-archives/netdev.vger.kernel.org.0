Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB33B598915
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344868AbiHRQkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344861AbiHRQks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:40:48 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50055.outbound.protection.outlook.com [40.107.5.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E26BFC64;
        Thu, 18 Aug 2022 09:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoDYKw563oTqusbonX3ksW+UP7Gqp11Q9/eC/T6ZFCpMiRXgz7J1YOdJc9owOEAZOo15AkOZpWl1yM60v2DH5mWM7pkmMeyqgZ/+LmZlTFZvG79xbM23xNXirUiT7cG51Uy7trTgnt1BD5dJXfDm+Rz9IGvi9To/3b2+5Gaof2tVtj8oZdxpbXaL43N448ULCqJgNohn+qGO6z3VyAhp248wt42siKKXFftG4b32Ca9BGfW12Yg+atLKpzTqmivFVRA/nm1+SE0jqNjPBTzoIr/VhQqOn7wKMsF90SuXFWjX6099vM0gkuRk2rNrnMjWd4qi4vFTyIYGReHUSzqW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZI0k6vsIJYqSjDMj+D1YVKPgRT9z2KAVW1GKIBPipN4=;
 b=bPlW/caQEpvC99h8EqHnrffCshweFTLj4lb1x1sTPV1I0mn1UEBLe6o2rlYAHblmR8qZmL2ogNKJs1M7Qzpj4ezFqBkn3s83LwngQYgZ02IEtqnJxUOrkplHQ7kgch6fmAjMpv4woFj0ugkLOfX6bm0IzxN7nqYp+15SQfjm0YJ0xE7bxHqqW1I4SSu/d84LaWLlpfiGvzo3R5kUIey5rjYHz33FaG6vEjS26+mIZReCxLD3TWrJnXICQToOgO3aMnfZh/CDYAV5Huxa/qOaJfUz3i3Uf6NMh6ZEOt5E7EzHPAqfoGoOfC+VlPO2CU4a64TI3ajaXBcnr2RRtdnX2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZI0k6vsIJYqSjDMj+D1YVKPgRT9z2KAVW1GKIBPipN4=;
 b=PG2FGXN9srl6ji3iGQS24pqq3waibYjw0aRHTZlz7BGkBwZ01cuM5xoZ+8j4d9QlnMuwRL1OfdW6AVmTvs4qxLxNwFBhaBKkHx+f2hyyznfSVg21NxNKP5Ttck/j+micGz0/PGhMJIWvGC7j1wxN+XspcNxDISLkBMF0Em54XOI+irUiaZUSDbKRQOCpQs026+SITCE2IiwfiiOSikxIRcnLWkbZSCpMdfoiz8XsCGWDzCWuxK8FrW/Q/R0OkKX4eSoed3eMbr6juqkBtR23wRfKVV7zjGz98vHzlEgbE+QnJ9QSqXQyvdbWt5Xu8GE7Y8sFM9I5Ea8pUl0dGBiRhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PR2PR03MB5355.eurprd03.prod.outlook.com (2603:10a6:101:20::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:40:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:40:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net] net: dpaa: Fix <1G ethernet on LS1046ARDB
Date:   Thu, 18 Aug 2022 12:40:29 -0400
Message-Id: <20220818164029.2063293-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:610:77::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56a0d0aa-8bcd-414b-e1f6-08da81386476
X-MS-TrafficTypeDiagnostic: PR2PR03MB5355:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2IZ+J9zalH8aHWZBSnkUbz3IbHQeZaZ58BpY5gTu2NMrgn/2zHpFieYPpPaGUI+XeETDHB4zyswGh+YLmp4vzU8q6Tnlg2cbxBEFYryGT0BNwYx0P53yEOn4KzPmKMMLVhUY7xeA9+00L7bTI/xXsLm2GPyep/URWW9rDek/CQ946q6ffKWfDbMyCSAduOV0FvmTGs9SUGr/ImO8wieV++fNJ2855npO8ua3kdlhJvfU8UGGZgADHMstSqrvnmgJwRrl0h0QcNxVzlOK0jTkDxJ/DfKISCBt8kUyiYtP+pIxNhc/5atybDlHPDCg7lwKJP/FrCwUVKyXdE5rCKi2qbu8sUDs1udPnAz7HjXZK9qDvWEzeCQCyx5/Ir3S+fCYYlhmXCkb7I6na1AUYdxV27IGY1xJZbqxMasDzD6kiCqg3M98Ysl5SfkYJ7+S0Svtf7o4Lpo/a/6PRWwHB9oaaiiz8BJcaCeVSxP4//XP1ib7Fr189TMYNfPaaGaQLesYpopntp9d3DUmjmJYSUurci8LkCQh/gHhY4m/4JoItEgZfH88sHn9FS7HzFk+uLYoxLnrIXRZqOsR2SMA/gwVxodXpduU68B/vj2Jng6Shwfh24mg7KMrzv+tuG6yaNCdB5aLX87Pk7t7CutcXdZc/VGA7pNJm/4uwgmBWuI00rQ9w0ZBgVppn6vV8MYqNM9PClq8wBAri/TkonVQDjK0ClyV/P3xY3WnHDokw1j/FmxnKqtFQkCCjPvhmahz7xmtwNuWFcHGtboa1fYSiv3O1TRcHzheuxzYMpmqnVKn/4k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(136003)(39850400004)(366004)(7416002)(83380400001)(41300700001)(6512007)(6506007)(107886003)(6666004)(2906002)(5660300002)(52116002)(44832011)(26005)(186003)(6486002)(2616005)(8936002)(966005)(1076003)(86362001)(54906003)(110136005)(478600001)(38100700002)(38350700002)(316002)(36756003)(8676002)(66556008)(4326008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ADm3ZksGuxiuZDXPrI1KrgXzClQ7ja+Ac2zuSMW8ogrZSvyRk8t0Pj8XXpJP?=
 =?us-ascii?Q?X+zDfzkXFi+1HF8TkF9ENA6uk/203ZGXcF7zop337iBEKnncskcKOfav7v5j?=
 =?us-ascii?Q?NdY+OwoovZLBaDJWwjynvM6C7tBS/p8nM/CfpS0SPl3LQNamUMCVF5tsm6YI?=
 =?us-ascii?Q?3jWGFcaRErPq/gQ9q3KP8rFaJSfXCxhMhhuiCjCipzOuSomjN2t+V7oaEUXK?=
 =?us-ascii?Q?9rHtYwaU6QWgrbS661I72b4uFUEr66302nIyjvE80ThV8D4fmHZqQWnZ7BrV?=
 =?us-ascii?Q?r6/5dzfJYy1kQjPbkFqmNqJKyR9HfXPg9w3kgsnJUO9qFgFB0xiSRBrc7Ds2?=
 =?us-ascii?Q?yxqtGxVEpgZBNL16dWWIA82B04Dop4A0B4ezN4FCLofol/HZ2RfzhzjXH15s?=
 =?us-ascii?Q?UPSmjlM2wgMd1ajVA5J4UXGBtR833/TX3zuSaUFV8pvfouPwL3beRaNNkXiD?=
 =?us-ascii?Q?NfguZQAUxwO+vCoNmjLdbZ5jCSlBaLqmw+w3R0NUyAh4qKH8mgbrySgz8hpR?=
 =?us-ascii?Q?5hWQOojknbd3jJLwTO3TfjAgGxGDMdFTwlinbbYLlvNyn0kO8isetZxRUFJk?=
 =?us-ascii?Q?lH64s0xpYPjCc2vJVmlTvs76afaMNQignLQHCxi72azrdz9JoUw4titmXGcU?=
 =?us-ascii?Q?5Td0Sk83BAQVUWEUsc0aZ6ypv9dK7MmivRtBwmO1dkKdV4PMI246j0tOfpMD?=
 =?us-ascii?Q?Jq4tivipCYpew4nBaphLJ2ls4NZy2FS6S2D0ov89eFwimhKVlSTb2d3aeITD?=
 =?us-ascii?Q?FMNGXUz3eU3csjc3jEwY4DZ7/77K14lT6fQ/f88Soh6BX+pWZ1ZCcuC34r0f?=
 =?us-ascii?Q?Ua1Ybe6/oTmGpmtdbHRz/ucdO+0CKtuM2ujNxrvfs1eHgdxx9ZXVlIbk9T+l?=
 =?us-ascii?Q?fcV63OVw0mYUz+tCS4HC60nvOZHBqW7yYSHpzECE39LU1TfJl2U6fPDo0v0a?=
 =?us-ascii?Q?NgboNjY7Pjn45TjfuyAwaL9laCphWmKWFNNp760Kg6j2i3/8V1L9fXATCA4a?=
 =?us-ascii?Q?oUe/B7B0ZH+p3jxfQ1bw1C9OuE/hawP+j0+4I//CaXo/leTKf98UaSF3cPFY?=
 =?us-ascii?Q?rpNRzg5A/ouhOLSw2f4JRrepKw6Pjss8xh4LTZz3nxiKVOwqgWmqGV4c4lIf?=
 =?us-ascii?Q?hPsntwQ0i3DilaX11n0YmaIsZ9Uz8Vpg4gDU1JIYfzd4zCK+8NrzgcmqNJ4c?=
 =?us-ascii?Q?f4WjE/WLvJSjmroB2QCKSAuO8hUL6SJuCtLqckqNyCBRn1ZXwCdarR8TErfM?=
 =?us-ascii?Q?ir2lI2FRuj1Uj+r4P/nmGO9LJZvKuSRNXfW3QJ1AijKLfY2I4RwshcpX5rvV?=
 =?us-ascii?Q?6brPmMD9yyZlkYLyrtc1FIYcZs5LKwzI/tgEyi7HcJToiW0zsDE2R6qVpaeb?=
 =?us-ascii?Q?ezn/sG8eJuzY5MeD4a4RZOwrNo/Jj1G4i4XVXpevV91Uhq5vDU+SKWFggYKQ?=
 =?us-ascii?Q?AdeWdAen+AImS7/RaogTMO/NDRPHoFE07oDpDqRVVXBaMZOCdSi9WVWp5dZa?=
 =?us-ascii?Q?IE6lDbIf52/UeZ6Wq1/zkuhcWQAB/fEYJGRyLt55lUdPGYlF6yaVCxt9/ULQ?=
 =?us-ascii?Q?jkgdbf/PK3MI+cWV/M+KXSy7X8d+iR2WrHWBbqVqA80oYTLrqP1jLaioYGhG?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a0d0aa-8bcd-414b-e1f6-08da81386476
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:40:43.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cKF1SS5zr+GHhKSdBjgYQzmIvY95Cw9WOaQoCTCfPv3CIwa0FyJP2iTCPIUo9UMbJa/QzAjg/s3/tR5hWnIbcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR03MB5355
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in commit 73a21fa817f0 ("dpaa_eth: support all modes with
rate adapting PHYs"), we must add a workaround for Aquantia phys with
in-tree support in order to keep 1G support working. Update this
workaround for the AQR113C phy found on revision C LS1046ARDB boards.

Fixes: 12cf1b89a668 ("net: phy: Add support for AQR113C EPHY")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---
This commit was split off from [1], as it is a bugfix and should go on
net/master.

[1] https://lore.kernel.org/netdev/20220725153730.2604096-1-sean.anderson@seco.com/

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 45634579adb6..a770bab4d1ed 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2886,6 +2886,7 @@ static void dpaa_adjust_link(struct net_device *net_dev)
 
 /* The Aquantia PHYs are capable of performing rate adaptation */
 #define PHY_VEND_AQUANTIA	0x03a1b400
+#define PHY_VEND_AQUANTIA2	0x31c31c00
 
 static int dpaa_phy_init(struct net_device *net_dev)
 {
@@ -2893,6 +2894,7 @@ static int dpaa_phy_init(struct net_device *net_dev)
 	struct mac_device *mac_dev;
 	struct phy_device *phy_dev;
 	struct dpaa_priv *priv;
+	u32 phy_vendor;
 
 	priv = netdev_priv(net_dev);
 	mac_dev = priv->mac_dev;
@@ -2905,9 +2907,11 @@ static int dpaa_phy_init(struct net_device *net_dev)
 		return -ENODEV;
 	}
 
+	phy_vendor = phy_dev->drv->phy_id & GENMASK(31, 10);
 	/* Unless the PHY is capable of rate adaptation */
 	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
-	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
+	    (phy_vendor != PHY_VEND_AQUANTIA &&
+	     phy_vendor != PHY_VEND_AQUANTIA2)) {
 		/* remove any features not supported by the controller */
 		ethtool_convert_legacy_u32_to_link_mode(mask,
 							mac_dev->if_support);
-- 
2.35.1.1320.gc452695387.dirty

