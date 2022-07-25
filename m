Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF525580210
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiGYPjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiGYPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:39:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A61DA45;
        Mon, 25 Jul 2022 08:38:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isNLBmceXF8+Yf01ojsuQStqkxjyaSnkr+YnWGXuAUJHWfJeyyc3ZdjTxCjNVaAPh0BGRybDWDIw6Go6rQB8MWF7b3N4doq1NwBXJc+9rTc6+w71UfD7vllwOfSoPj+3HPoK23IdzwUvhK6N7SIEkIEsl93O7XfGEeXzC4kqonxT4pIOXHFkzfFFzWwo9DbbQycOuqWFxWV7UHdosPvfAypjqOS5sbwmlVoJB8KpWODv6GwnjhXniA5KW4C9uopbuRV/m6JMAcjEZfnTb3+Eeo794rafoUyioWmOptBOdRFY/ID3P0kKBJ8V/1NgARsBS/N7KyReb4vawTVP4YTN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwcVv6qYs1lhzCEg7MlzfZrCEGooCwHiaH1jKl+Fqps=;
 b=H+3VLqvnxCrbC75mM5AIH4Ui11kuB/YbqP6S6j8sol8k16dG9KsO9ToCOWYGxLujHICqjIMEqchCqSuXywnGxVRCEFSTUQWNoONz5zfaWfHExdTQ2kZFiZMo0rFYuz1KFpxesl14P0a4YA+inVxeJlpfHea+o4bNcLVMPJj1zX3CfoZUsxfCWXZxFpisyftmoCqg8ezw19q41RWcisfRFjsSfSBZD5wry5dzFid4PqFw0FEljpItj96EXYegubADQl29D3qZwi7n6lVkzea+z0lbPG8eDgfgUexXGDxyRd4mojMANN4DeNhMu2JVxqIhAGS7UHPzmUUzfCSWq+CMsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwcVv6qYs1lhzCEg7MlzfZrCEGooCwHiaH1jKl+Fqps=;
 b=XHS5oHbkhei6IKdC4e3le6hCnPOKnNZnyJ8muj/ONsY/WRxs1cGVg6KhGzxw9JIGLkAtDK5i4vAcVaNOY32iFZfNdTsnMzL3CEkhrbuUDHLzzvipyDnup0w5heH3bWEr/dq5CDqX+OhwCir3Hw1pUX8wheXwJVNyQ11PehU2zXIR8FaUTf+c+CRiJLeK3GII7ogFCvPHiwoHgMUfnRxN4SRmEpUn/MzgytkoJTma+1JddwvHcjvjGQm8oQ3gs9wFsVVeJQ+r+BP4ihoaJSYthg4CQT0HkaU9+6uH+Hvkp0/aQ3ROHjoVQkWdJlNVTyRxwVIMPQ0xMcDc76EuuKVjmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6464.eurprd03.prod.outlook.com (2603:10a6:800:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:37:58 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v3 10/11] net: phy: aquantia: Add some additional phy interfaces
Date:   Mon, 25 Jul 2022 11:37:28 -0400
Message-Id: <20220725153730.2604096-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2646fabe-d261-430e-cd42-08da6e53a6a2
X-MS-TrafficTypeDiagnostic: VI1PR03MB6464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nf1kFtYlW1hfzCwY9Dhz+LFcFhCu8OpDOGDItO4S53Dvf54BkOAyqC2O9Zi86H+KjpUC1iDKD5dOiYvhNNzAoJXYoeR6fzR+Ld/lWVZmL2h72OAMxeUhYo0LKQz+WgTf8ZhxvuORpeXeFz1ABWjj8t0jUJFjvtDPfj9d+5pMaLhDUHiak5Gd1pS/tJg/qaXPrdYZkcn5qEwAZeJV+0HZBXubLXd0TjBv8ko7TSbvQaL8loxQ6WRhbRy/kSXhqUhkFk95XckeJF19CWhvQHa7fBGgzYp6IpouAnPOMH3xTHY9JVgDg7SNmIkGNqm0+gwQnYjMcESRmWx0rNJvTUOGIJLok1pUd5Kns/i8yF+R2eNe50A7+PaJSqpm3hNc4uH8pt+883BpRKkQBHziQtGA9rNjjFbk3y/tC1taO5CsD3xCgEqnTWGPFIvdHjksRp7jW4LLUbikuMPYUZGV9swPKGrOp8vtWciIMAXoY6XOLam0WHfSt9BkrQ0SY2323MU7EmIMT3I3rBguAh3iJYCjJX1PTVf359eCDNBmXskwTAmRijuaN/Vtjunj+W15b4nlcvwJkMg87jtImVKQ5Tu18A+l4brn8saLKumur1o82oBXRYvfRyz6EOMDG6TH43zh0plhvzr4/Hca2bGUqCsnqDEAuuC3z0OUqUaf4PT/ULwumN7vqZhs6E3wMuQ1SndqQwnnpBTtvtX8AxpMhQO7KV3PNhlNTLwY1HcgrHucqqljNEZ5ARRx0YcQX1CnylqdELj+OiayW3bvei8wjH9CFYQKhZUpMMlmRIoCKFxF8W0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?epaJOBaZ3ozFeUwAqh2GZgQOooua9qwDlv52iwJ5J3C2MJYX9PwfCtO11+vZ?=
 =?us-ascii?Q?2W6JXnMJac+5R6ngRByfS9V/yxwqRZv4RtGnVR1vJQMBjXdAuo48qVA5ly7K?=
 =?us-ascii?Q?m96V2EuE65I9NbJ3ru39oJM0g3sZuK3F9yaFMj+W4vbIo1BFB3xlZErR5LHh?=
 =?us-ascii?Q?85zNfWkKh2f51nydWYjAd73rRS6rONRc+dxWy/cJQsWcKULFV0FO7YsRAbX2?=
 =?us-ascii?Q?F92aGYp/He5I2nLLpdGzlMNa78dQYst9LJYnpYKoV2TDO+YkccN0NKGEbjC+?=
 =?us-ascii?Q?ZAyf9btVoR0PwtHutLrcvuTer8otH6nSnf0Ldh3J1U6wXG7dflUVw+L08nx0?=
 =?us-ascii?Q?J8cyFeJTuWNuLqzKbykuPpbDFgzkkNSGhI/auHNs1/7Hf9owq1f6Ai3GLhRI?=
 =?us-ascii?Q?vosfEjn+34kyLo+UsQTFQ1amqDXVPe3RbKUaFjM3wnq1rfjgw/hpX45O2nly?=
 =?us-ascii?Q?0xjxXRb0UDiWrXNdoMUKz7DNA6K/L07uC50p2TOXUIcV4VIuUlCPvxi5o0iG?=
 =?us-ascii?Q?EXaJSreX27Q4pGevzr0W9J/qRmB/le6CsVZ1bAiMqGRwAnorDBGqBEWn/sjY?=
 =?us-ascii?Q?GYbBj642HB4Zzv8Pui/N27h7WYJDK8PkgVXWCEiXBHaNOJSJG8otXtYdO26L?=
 =?us-ascii?Q?CR19FFDW+ZgIn5rrZnIcPWA9u+u30N/bjMIdWOhmX4E8f3MWNusnkHgIAROb?=
 =?us-ascii?Q?SGD5ikKAimio19S7RjcSNF+vtEP9ANS+h9r2PiuCc5OMWO0YSvLOPMMVJbgh?=
 =?us-ascii?Q?WVnwFBN6T0HbO06ztbxUTpsscGzXoIosZQKXxutKlDiAM57quGUenDmIpS9e?=
 =?us-ascii?Q?k/gtGCsN5/vgZTPUZjGnSiu9hSwRtkm0wHi+r+CACErywofQ7cbaMfaVCUdF?=
 =?us-ascii?Q?nsWW7pxbx4rvn7qYKRUCCYVfR51mmJ/fd50cKW1pc+LQmIYG5RC+URbZnWo3?=
 =?us-ascii?Q?a9tOrMMu6COnhJUby+WG32I0IsRIWgQ+Pqoi+daFAkmM/87j1BrsGl3Kf4Cz?=
 =?us-ascii?Q?NTOBbYeUy7v8SDyOW7h7djo8Bxaw7crbk/y9TZIX4bPPJQg6y1RQIMdJ7Gwp?=
 =?us-ascii?Q?SoF7jZislkNqSDAgsmf4/MYc/7BhEIzeb5cKwTxXQNZw49RHRupN/Q0GM7tr?=
 =?us-ascii?Q?yxUfe+xQbtbTydjKtzclEvRo8OckJQpOaGBk0KqNMLNU4/rJKaftzjuJpDPr?=
 =?us-ascii?Q?V4vAxhAicXp/NXFmtr9mJy9rG2Aasz424o74raPIx/w7i0yWEPhNIXiA5oP2?=
 =?us-ascii?Q?NIlMleum8VHkib1ZMX8mQmtfjSa4doZ8WbiBXl6ydcjrM/VNICs3w+JReiY6?=
 =?us-ascii?Q?XQ472XbxNHZJfmrTmM2SIEg5jm2t+AVcfTr4D/ANe25D4LuanMPwYQOU+Tz/?=
 =?us-ascii?Q?7Nsb9EfiKVgxdaCvlF2DYrzwDAqxJ4LkFZEkKzeHkrCnAh8FewfcTh8ymP2k?=
 =?us-ascii?Q?EDaZ+CIj+S5Tidcvd82xElgmHyPpHE+05HtTORmLjel0OpUEFaxxay1/2Ozr?=
 =?us-ascii?Q?rCFP+pF+0YxWzcjaJG8ITVrLe0d3KfzeQVp/zEiYfNKhKg5UC+4jowrJwUzi?=
 =?us-ascii?Q?prIolfStqIr+rjTbwOb9E58c8EJLEVbLnQRIUgrNXiknFSjbpGUd4O5YVjus?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2646fabe-d261-430e-cd42-08da6e53a6a2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:58.3999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41HtMk5XSjV6nfTUr319/Dz1t1FhlNcf0cv4b0So068k7qIG/07kRJAS8bkqUYgniPFSz72ekMiOZ7sILU6x/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are documented in the AQR115 register reference. I haven't tested
them, but perhaps they'll be useful to someone.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Changes in v3:
- Move unused defines to next commit (where they will be used)

 drivers/net/phy/aquantia_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..b3a5db487e52 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -27,9 +27,12 @@
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR	0
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX	1
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI	2
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII	3
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI	4
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII	6
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI	7
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII	10
 
 #define MDIO_AN_VEND_PROV			0xc400
@@ -392,15 +395,24 @@ static int aqr107_read_status(struct phy_device *phydev)
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX:
+		phydev->interface = PHY_INTERFACE_MODE_1000BASEKX;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
 		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI:
+		phydev->interface = PHY_INTERFACE_MODE_XAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI:
+		phydev->interface = PHY_INTERFACE_MODE_RXAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII:
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 		break;
@@ -513,11 +525,14 @@ static int aqr107_config_init(struct phy_device *phydev)
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEKX &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
+	    phydev->interface != PHY_INTERFACE_MODE_RXAUI)
 		return -ENODEV;
 
 	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
-- 
2.35.1.1320.gc452695387.dirty

