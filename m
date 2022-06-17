Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2254FEF9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357706AbiFQUfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356365AbiFQUeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:17 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988D35C860;
        Fri, 17 Jun 2022 13:34:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzDyYzEELwRv0EWYZiJrlyadKXEulsiRIDk33Vf03iI5P+kR7BiQ48SOPvbAn9Q4IRVWYjhvW7VhE12GDQXoKW98Ld8rGXUAEI1WtZIYB5YZEZeA6QafguFBQtRV8J2QtUNpXrfG5sDof68JAcYL2y1bn1K25y6pMs3XxuaGS0GxasijN+GtdpPhVkPej5J363511cX0F0Qe8KhdYeTs60JJQgaRtmplxyhlHmGTLWYEUWDUHFRw6fdsLP/s3i4IjgPIKZ/tTy27PnfR949MYRTHkpX6hWBVlTaFZ5Gh3GVx0bS3RprJtq0xca8dlSvRj17X0n4hxm6x1QOMS7WDag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4mcloslbW42z+e8XXI0Uo5WJtgDwnMYv1dVra17378=;
 b=kfB9CzLhUAMlpHJoak91yzkbiLgPWWmu9kT38ymewT3rGNibqhHtca5v0D72s+TMn1h2E6JLp50vS0hv8SRE8Q9BBxusFKVfZUarY/lELsF2aB4xI13TyEQPVTqxi1swtOprL7PB6m1BKil18OFGsy6592ImeJdvnhDBKdBlamMdSOVVHGYVxkLA1eRLl9+SuSHETNQWiiIDLwNW338QPXE5Vgha6sXqQVMAYhLizfjLn8QR+GirzfmMlwvTvzKGevoHDzxpoj7KQj0jQQ3UpLbXndt2hcInB7RiKWgRYIrI8XNUTHCIXO5KfJCTffotw/iYTav1Z8TZnPSPadcgEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4mcloslbW42z+e8XXI0Uo5WJtgDwnMYv1dVra17378=;
 b=GCdE6/g7rPqq/qoAOuLXnWw+N3Gzy+n0szr/Cy4GhYSliWzS3NM9yNZrDWL/Lw9oPRg9gz+pLFAuyysM2LMVNkKzPILwiOBFza+QDrcJK7aoEI39rlNfTKYWq9wqLGdv2N3hkSLOp2x6WIrRdzTLkQw9/VISFZHlVzzfsZ0TcSt+2Z/oD6NHeFTWlSqqwEjbmF6ka2scwaYYwwWSsp7ocoqygY+4MGlTF89eRdcT179ZejphH7CSEOTixzE90StZ7WdTlc6D2xgvYz6kPyrEmcwjvs29WKedJq3dGWXkVtO65CNecnkSOyIygLPz0CZiJD7G5GixhKhsI54bB1EJkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:00 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:00 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 13/28] net: fman: memac: Use params instead of priv for max_speed
Date:   Fri, 17 Jun 2022 16:32:57 -0400
Message-Id: <20220617203312.3799646-14-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a58dcb9-4d0c-4fc1-3143-08da50a0b5eb
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838777FBB18FCED956B9A1396AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GCgKw+03vAaWjpEsm36Am7Ae1L7dPd5PdMtUoaGMdts54B4vdNKmb8xuhj0276EPtrdQ0nHlv9O0O3lUwgYzvd9Q/kqUjkQaZQNcGkSMk0JxS2w73Hwye+AkinTzJbfKzUyiGc8pOTh+VYyS1mP7nLgt6/YAYbLiY1tVbMVO5eJ93N2hP+HFHne4IMQtcZDKq0w4zRdhmNrRg++SZp4IyQoX6x36aLJfYZBsWb02PTRoTZm700SjyOvcJyu6xMJZN3aMGlVViia8O6Hd8J54G4NqcSkcGMxjEfly8Is998WMPMuawpO2XYGFR4RmCa7QHFz0Xgk/gMn/FjL14Dme1hN5YRPInA6dA5oWkBhvxZoQZvNVXFHkTHKIQNcWq+DyES2N2kGfSTH8y3a1DCC+bGpzSs6goR5wozTl4cD/iYjOdTNVRQP1tzKQDPuVtDUNcxAAyJAkwo0+6RPeW+eHQavMHwHgRGmLYusk/CGemn8X/1WmBaLc7KvYID0l+DSz4ET9mxiGU5lhvSdLTaZ1SSXPYyLrqA9ZlKSVNnKadFBu391pLBmDbambTuC4uSDfCpqp9ZhkLD0q4v3uMylfypRZJSKa5RFT9FXm7qg3/pGWTTt/38L74ZZeaNimn+ihLUS/EI//GctyP3IwQokz7V3fdlrnReHA4P0aIXE2EfZ9yKqh5kF+nZHxbvk92jAp2d9qAOEcahp3lcN/ZpwlrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(4744005)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0SjfS20Q5gL2RygVKaUDNzLymm/2j1rBbBDwiNaE7e/tsnx3pcKJHbaMMWRP?=
 =?us-ascii?Q?Kovc4gHSkjC9RRQ7HcW0ZZrZdZyiEbc4NBT82qoZOKQ8LW/tk5YvIQsJikEd?=
 =?us-ascii?Q?G/j5wtt+x6IPi/U8H4mZdd6b8WJoqpMPMU+lkhjK1IHuwsxxbaEnTkvk89/Z?=
 =?us-ascii?Q?/4GcbtNoAN3Zb6hkddLY31uXRT+p72xjySy8Mh9HzwpdpzAT0RXoN4KN8DCi?=
 =?us-ascii?Q?upFtFR1tjoyzNsApcD/MXjG9qrJUxlHdNzeruS7iM3Im7ZFvTo4/LnLA2RHM?=
 =?us-ascii?Q?4sSBMOnw7+hMVVVvLjYCOQICYTabZTrHoJsmooevFFg9RJTb2xPoABRJMlAs?=
 =?us-ascii?Q?RHXrm8b7z5JxuiYedayvB414lDvUsUaXT2+agey+O3cCwU9UqhKgX0DwpGVy?=
 =?us-ascii?Q?QqlUb1SUrwtNf/Jk3xl9V/XDV4Nm6f3pje+1kuo21BQi7HyXx/5F03soqvjF?=
 =?us-ascii?Q?EQH5l8i56cN2LlJn5H2WrsS7iEPdysNyw9bzLMAEwSUw/HNOGFIq30yLvNVT?=
 =?us-ascii?Q?wgwEvMlOL9Q//kU9HtaK4BwH5oXxiLdi7AJRQByNvr3AEykl4ZmGpYGNJgja?=
 =?us-ascii?Q?1jGt+hysQJ6y7/kCT2flk0CSJSDKlEWJuI1iVOvYs7/FvtLTYI44v6VMC4YC?=
 =?us-ascii?Q?ecGCU3Gnp9Lrt3XvRErXTxiUdaMykBo93A/ajNuVpbQGjCS/ibZYrtf2Rh8p?=
 =?us-ascii?Q?DnqCwodf9u3FFsrUGh+ZGqVQutpL2pHQFsrZo96UbYtATRaZbhoC2/vZ/ZBN?=
 =?us-ascii?Q?fpt40fHuDgYCX4MDkhQaN6CP9OKa0+z55BGS13eL0qsaqtIYQWQ7PbaK/7w4?=
 =?us-ascii?Q?Ga/rTTrTI8I8ix7bYR6n1P4wPV6hNErs+i0D4a4ZSaS24xLzoRWrp9epiSaG?=
 =?us-ascii?Q?c5snsRTko0kWBxX4f3u2A1hml2bWB1xWFolvhNFBPmVzJ3GlwSf7nRe7h6ER?=
 =?us-ascii?Q?krZXzROW7YfL7IUt7y6+uHyeVkhZ2krB7wtQ0Kmw2ZWctXWyuEDp9gxGNKSJ?=
 =?us-ascii?Q?rmgIBM2mqEkp98OIrCh0oO955+LNACKJkd1ZpjLo3LhciGVzZjW52j7i5gpc?=
 =?us-ascii?Q?tvAk7geIls4rxA80KB5BFG4lspl6rUj+gVCSeav/X5hQibiHkfGeefiguhAA?=
 =?us-ascii?Q?dI0pwYhLGf14Mlf+1ILJ1BUK0FpAcgA5dfgnRpmPmgGemBZymvFNxgNFd0N1?=
 =?us-ascii?Q?0WEsemi18baCh7pV1T5+pfShUZ8E3gbTlmnDOd6zxZgLjDErvThWbLGCuw3u?=
 =?us-ascii?Q?OFkZGlTTvAtDCXmGjhRShfAsGeCH5mAqBBvn7dDt2PG/nVtt7dMDVGgHZPI7?=
 =?us-ascii?Q?4ZvLnISR/vfpql6vf3FJMaGIUaRo8bCNEhbaXxhaNB4pBwtC+rX3qLUM1NON?=
 =?us-ascii?Q?Z9/YwnVsgxnQkTVRXK2zGmB8/3Jy5JNWDahSVKo7yZ4nrTtCwAFZ9cB7Kf7r?=
 =?us-ascii?Q?zyWGEulXVR3V9OrbijhKDJBiDP6S9PR3WCCnoVnMbLIFiGgki0xO7YTpf4LD?=
 =?us-ascii?Q?8AMbO+P8lZkz+ewlQ3356PcEKrdfF/TZf6RB680klzvPytNHfBtSRGDghi4d?=
 =?us-ascii?Q?9zqvcRP1ZjLJyyLxce29a8Mfuw6IDmR9aXuWq5R+MhGqQ8dCUUjtVWaoAXgm?=
 =?us-ascii?Q?DX+CzVD9rj8+zo8/Ec1/sGyAaIpSeWzffxXfpYy2iLTf0PKEs2uITMQzSjb4?=
 =?us-ascii?Q?ItFbthfc/E8uVwrT4VUgBHtH0OHDrp0YoRkA0gGo6rCDFvlI0jwHLogfmYWb?=
 =?us-ascii?Q?KlpJomt6w/f6DdePWVi8Qe2XpOlDP9Y=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a58dcb9-4d0c-4fc1-3143-08da50a0b5eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:00.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKosuC86nijy3eGdYRtzeyh3vaw9NohczBobiQ47157LOztmBiea3BfiHyrIWkYN+rGeQmJejg9N9uNGqqwbJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option is present in params, so use it instead of the fman private
version.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/fman/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index ac26861ea2e0..b3f947f071ee 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -420,7 +420,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
-	if (priv->max_speed == SPEED_10000)
+	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
 
 	mac_dev->fman_mac = memac_config(&params);
-- 
2.35.1.1320.gc452695387.dirty

