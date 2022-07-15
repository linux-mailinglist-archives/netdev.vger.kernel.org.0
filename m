Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0AA576957
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiGOWBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiGOWA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:00:59 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F07785B7;
        Fri, 15 Jul 2022 15:00:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJBLXH+IHgUDvHAHFuongdKV0j09zXHTBQKQsqD3tnJlHfxzB7SgNHGpdKly5ct/wzri328a7O3MBNwz8x9v28NwlOIMPivGg3H0MJyJtFUJ7SHX2GHr+Up0zNdAYYwZusBy/JZ/C477srURtZVzxAZu1EB0Bo4WQpHIhkG67xvG51U99CItQE6mS6hGKb8RJrHWKxRjrMRljCiK44Nsq+jJ/c1joBe4FekkhYTG5jyjPhTNX1UzeCPf0Atiakuh/OH1PRI3/gGXqxSxAzBCAEIy2DB3qyFfuGmxSFSWp/5FVqij9PuZfnNOEY7bzj/orLMDx0Evlibh+VvthbAqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXQ9opzBr06BLL1ikcEru/1VsrmTN+Awo+3ub4RTHmY=;
 b=LwMwvJIfr2M7Lnbya9nhNIID0HJfkWX3O8wKG++WO6mJgBTPGaL+BPHKOeZqOlRrTS5msFjgGiKcG6cfiKuMS1f9B3tQf1KTL1wqJFGCzsgM5ihv2gXHIFvNsQmwMtTbltBmqKWORacOLCVejwFDnGbD9Fb27lu0Uu1J3VrL+q5jztUGwavGCtXF7AgxqRR2Pd2pv0Cp7HKNaVDPA142gMZVWHuKhWEd1QJ5ECiQY77bM36dwjdzVqIXRnoE/cducvg+Ov2jiGWW7a9vuiklFQfCuA7cdtHFqdVdGypPtyrWSAqmaRTH1ETp5ENB2FEicb54aRrgBeyBS4OGBRz5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXQ9opzBr06BLL1ikcEru/1VsrmTN+Awo+3ub4RTHmY=;
 b=lHjGeCT/Rfvo64xmLR8BHZVNqTp14jo+h5M2rlPXt8LgNBfuw97mgfeQI/TwvMXgNcj2HW7ETVCNvETpak6X7cNFnEbYcHJx/fRIsYVsks4FFIgtOFCOjuhrU9BvQFWeh6ZTAzRD6JpwyMz2B0lyfBDfgfSPKfDj0cfKoVMTAAsPMr6k9xQKa1wGfQIx2i+PbtLKiYJKKCieEa3HsDDR96YvG0p5pT9cbDd6L9chJWaqyGQW7qDW10xYa0lwciqQvnRGAo6VxsYa9ZyDlslHVjI06wHvDglUxisnsSL2hi4XDJHlvjMVlsI3/KVZnIGNV/+HfKb/P5H12O4a6n93Sw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:22 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:22 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v3 05/47] net: phy: Add 1000BASE-KX interface mode
Date:   Fri, 15 Jul 2022 17:59:12 -0400
Message-Id: <20220715215954.1449214-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d275da1-effc-44db-07ca-08da66ad6a36
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AyIxQWHQjNJWqn683cGZreAdiM5rsEzmGNAZCNdkQ//AKuenEwV4ennpbS2ipeGhUDQEb4bMcoaYo+DCMJWWe022eITKmWm89AWxnQ9+f2r/seBdeQlsWf+caPhU2wfIfGxHFN5X8EQWvSqU6hVNrLC/kA3haRCdO+DkbBB2XuecVWO34Cz07yQ4qdsYkNoaJ2xKsnb6/uZVf3p97WT44k4o+bhmlnbvtH3vz0L9EsSSLjpE/uu1Hn1it0AxWsBARQaks+PzJZEbNLZl9Os0v01A/IDL4QC5AXEa4AnRrJTL1UIEdCgvnKamaAQUoxtf/Xp1hdPnYwwEEOTt10QtrdRVEHzcuvxdBgsROao4SxJJzgMCMe6Ha8+t153zBKnN990IkVAlsacrHQEF5HCO8AjPEoJ4Z9KcVL4FlxKxIj64gksLj8DWFjoBe4yQUNwNqMJVgyXhj/R7Vxn5oNLQupn5UcB3d/u8JHFyXnh+qZiqng2kiNHxgPOSvxaGFbv8MzobVFiv4DTU5ga2NGzVwQfzUai8m2fFs911MTKcll1XNkUEgZ3bAVgphLNv3nyVQgfaxhix6uPgFqFkq/f5unXOBIGN70ljvBoGs0UFEq5CMP8WbrWyggcscK3F2ZjpCKAGvhdKiTEjBEKvrGaJqMxOKhfk+W0DO5PBwtpspqjv10DdRr7Folnld41iqCJVI1LCnXQuupkPexXrpn7mJq72x6jb6OcjOBeRpZHa04jfKRAEcwX4h4wnnW0K9WDbnU+aOCjIyf7/C7/celJ9YfwkLJa5tZKrGqVQAlDYk6Qt42Mi8FZiQhoDfCHPEhOy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(38350700002)(2616005)(1076003)(186003)(7416002)(36756003)(110136005)(38100700002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hLcB2g7OULU7Pyd13R3JavXXJQ24naiY9weqkUXpWe2FoyZlWoAqNoOUVmke?=
 =?us-ascii?Q?34XO2EwALeObuHRd2UomSF8IR0cHJf4Gi7q0ycNhfmdhB4fGjuQe+77WKEwB?=
 =?us-ascii?Q?qL3Gqzq5AUbFRlLArP4KRF4S+0NlxfB/ugRffN6WXKifB+Ccx751doP2j2Pm?=
 =?us-ascii?Q?BHfK51B26j5ppyuJJo4XvOuooZdMUro8RmiJ06uO0han9YqoHgKkSGTx8c3M?=
 =?us-ascii?Q?BnIpgc9sKGb2pNEhEkW/n9HAwNRB2mU2YJ07xDvRUbSDUgHbCf/jbMG4DBZv?=
 =?us-ascii?Q?wthAnYIpv0xPssz/n7AxjZ1UprsfYZ4wQPrd4njjZY88lVJEF/K5aeYmMukq?=
 =?us-ascii?Q?MtiKB7iRa9b8NdemXm1ahjGQ6TApPs7jtv2dfGqE9GwFqPlqrRsulYVGtm4x?=
 =?us-ascii?Q?chGEhOCjfaA+kcf9BeX151deaYCHlIGHZa7Q86NaA4X7yEYG7SPX6L0xFDkW?=
 =?us-ascii?Q?DZA3YaZLy3BUjptJ9dDEVRiGlZvpS0DIPOv5JXmuZSV2jOhDua4K+Fwg/wYi?=
 =?us-ascii?Q?c+9EQq/fF+J6kpbxQCjlqXmAV0RIhEmBf163bIc/TMtT7naHDq6JTFaYNuT2?=
 =?us-ascii?Q?tFyz8P2bd2DLOKWzqsZ3NNr+DHpaIkJardx3jfGDueOzsxTHIu7Un0NnUroY?=
 =?us-ascii?Q?+nMDp2+VrV57m9Zvp0hrotZDzwfq5tZ/1M4nB3hEzUP+sEU6kdXkXLhrDVid?=
 =?us-ascii?Q?AvVJiEpHH9Ak75ScAkqtTIsHUxR7vzO8CBf3XKdgMIjcZl4WsiYAUxOr6uPP?=
 =?us-ascii?Q?gShOKFSArfGJlHPybUS52bZYFU8ITy6KhOieVvOds95S2AUS+rSSMXjtpPJc?=
 =?us-ascii?Q?WpiiM2gb12aB0fWJMBnNQurKuKoLJptzHhdN3l4/pXbOyTN8LItqX4Mh4M1F?=
 =?us-ascii?Q?VJldFG/SbgLhN48irtU4NzXN1cXXPuBc8KErINi4vc3OxjZL80/on3Mruqka?=
 =?us-ascii?Q?8T1L8uINZXHiskDyZ+mFEs6YQ+ilfatasTfqaa2k2PY5rGc59LGPeIbeLKZV?=
 =?us-ascii?Q?EsXnPPluV+lnUVsGSL5shQdWNouOLFCSo3/Hpnjkd0G+eVDMZuMpWPNCfZzY?=
 =?us-ascii?Q?FoOH7l9Qzo5iTFHca/wTM7sd92iIaqVSNtkWMr4RsXoaKvyAnEo1JCIrGKCr?=
 =?us-ascii?Q?Rts8I+FD58v9Qea4s5iBVZ2tqhtfnMmohvpphShNC1meSH5n1JsjuOSdthg4?=
 =?us-ascii?Q?2qCjxScsnqXMN2XA0S5R1OzkVwOVi9VNMgsRHw8IlfzRKl3L0y/1JgixiIng?=
 =?us-ascii?Q?C9UWQl1/3+ef1fhCCgVWwuH8TkpY4SWkgo5ekmhhtH3uzQgmygL0/HQau5ti?=
 =?us-ascii?Q?i+s+UhzbRfV0Q3R0uIHuIDmH/WQyOCfNfK+7hqsG4cyqm6M0ojWV9Py9UPx9?=
 =?us-ascii?Q?EFncO++hThliZRyGB99n/+loqCLtUItqGu/jl+HrlHqSZc8ORyaKh+J1uh71?=
 =?us-ascii?Q?lR3DXIbtUMgjW1Jd+d/5x/0RXgLjgYG4LTk78geiLa+K46Bk3pGSxsTLAII3?=
 =?us-ascii?Q?WncnzPXS01v9xF+YX3Ph+dYi3iX16Wt6Sn5lCDOCMWojT0Bm1js8+wFiPnP2?=
 =?us-ascii?Q?F2eGOlsplrsjp+nggmRIwiRDrKSyOYZyYRXda7cw2iVLXX8qmtXWgphNKJb8?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d275da1-effc-44db-07ca-08da66ad6a36
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:22.5053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0zObRK9R6IQpJwkNrHa/c+m7XEBeHdtzeAZZJHcDhj4WRudDmwK/bb1Bepv+9vW7Zqe/qhXD5c+kYAbsvGwUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
operation is supported.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/phylink.c | 1 +
 include/linux/phy.h       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..b08716fe22c1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -344,6 +344,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		caps |= MAC_1000HD;
 		fallthrough;
+	case PHY_INTERFACE_MODE_1000BASEKX:
 	case PHY_INTERFACE_MODE_TRGMII:
 		caps |= MAC_1000FD;
 		break;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..81ce76c3e799 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -115,6 +115,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_25GBASER: 25G BaseR
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
+ * @PHY_INTERFACE_MODE_1000BASEKX: 1000Base-KX - with Clause 73 AN
  * @PHY_INTERFACE_MODE_MAX: Book keeping
  *
  * Describes the interface between the MAC and PHY.
@@ -152,6 +153,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_1000BASEKX,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -249,6 +251,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "trgmii";
 	case PHY_INTERFACE_MODE_1000BASEX:
 		return "1000base-x";
+	case PHY_INTERFACE_MODE_1000BASEKX:
+		return "1000base-kx";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
 	case PHY_INTERFACE_MODE_5GBASER:
-- 
2.35.1.1320.gc452695387.dirty

