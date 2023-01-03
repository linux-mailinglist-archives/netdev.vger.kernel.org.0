Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039A965C921
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbjACWGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbjACWFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:05:52 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2043.outbound.protection.outlook.com [40.107.249.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E25E56;
        Tue,  3 Jan 2023 14:05:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXExqV9ZK7GXMaz6cV5AzhPZPMJTrlDobL/3xyz+2RxuXJEAccc3ch3BOKztxhrBoIH9ATLcDKvWda9r/XeF+PVYxkZpKt/5A2V7jdbJ2krVkVXtyhFROHqbQ8qZ2U25M6vdfbar3Ng3nGaSi5JlbdW5XCM+zmHQoVWJ3kIdcZ6dh7hX9ubURAlvODWoZpqyY4m0Z8woQ+yMCZjRwnTUefhF+Pwwc3vrsdQsuFEXKW0Chs6iSwJWGLdn8OvpjSPogpj0M3XRl/dBOO2PuBY+mO8vqwBuk/50QXgcGNWtK+lwx1MXViMopcf8Q+qaHBWUpRMqjm1WD+1pyw32g6LyiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zKgX8iVwdqeQnqD84zbln0DK5aLv2Bsa8x25J6fqyo=;
 b=KZcWRcT4rBcs+AXPzUa1ldJrB/z+UCgC4UYc6LQUe2dfETNKJ0+1MIWufyMZS8fLEN9UofcqSvvrXwJUVssfqSeQiSRHmR+A29Qs/kRn0NtHqdzsxhTwFV4u6+bvq77v3AG1Zv5Tgpyk6ZuJ6WPKWMjwsR+hqV7DeqAXw7shqTT2keP4uAWdxofOZsdbibpa4uHmrcDBjQ5ImoYQOtatgzocPf7SbLaDafLeRzgTAkoMyaYXfhJSVwr0oWFrnh0D3roTMPEe6iuC1wtHfBjLzb82C1rGOcqRrGIYCfrEznUAlcFt6dR2zx94j9pc1LsYNkZB/RxA1xbp8hVKZ5Sgmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zKgX8iVwdqeQnqD84zbln0DK5aLv2Bsa8x25J6fqyo=;
 b=e6/NIjP611c+QT22uFNgA35Ppgtr8lSX0bSH8KlbILOofau6q2gOP5fBIzv/0dD5Js282XyTt93U5BBUc0HU0etPVA5cnbregF7VUdAMkbb7e6lf3b56yTlXypZy583DSxhzMTTcpl2AXF+cXZ6E1tqUVnn+vf8YmLKFaMyNCDmqw7aVM7vbKYzOU0A3URRCnHzYBmRRaBcoEjn9RbvtvxQdJPj+pvQ2wA2nIAEaLmij2tzOi6ABSK2WOEsZVQsXD7RGrhLmteudgBLPrRmIyFhHGvoVQNSHo1y8qvtFQP9WLPy1Tw7q5rAkuxhL0ZqRitU0DumKpWNq4KwLSwXb5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB9900.eurprd03.prod.outlook.com (2603:10a6:800:1c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 22:05:48 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 22:05:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 3/4] net: mdio: Update speed register bits
Date:   Tue,  3 Jan 2023 17:05:10 -0500
Message-Id: <20230103220511.3378316-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20230103220511.3378316-1-sean.anderson@seco.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::7) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|VI1PR03MB9900:EE_
X-MS-Office365-Filtering-Correlation-Id: 861581e5-4a8f-4700-1ff5-08daedd6ab57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0qArlKtDjXRE48RWKcHNM+DdiWWi8xplS6Ud8mfBJfGylKDSpCUSN38ADilBYnmz5bZf8BDFC/vm5MSTsdOHg1vthOHVv2ZXdegniftWY5rBUq69sHO9mxmv6rdU50EH2i5ACsEBZhNQCi0UIn8NQbK/DLBjYqiVHLTJvTrhwV/FTsuHhfCkn6YV8wUmfwRU7jwbaITQCfhDrlHGxQeW+ozQgVUJdJvYQsxFtBy/Kv42fCUWOvJGRZfbqQmB6G/I3OF0qJc/DEBXpmQSpUKrSyGqQBUZ9ZgqpWuc3pUe85UnrzkMwNP0V5nhGE6tFBQE91+IXLrjlocQ7F/cz8ovbZjM21Wry7eSanyyXNgkBhRGGqlhsMaenrgRxDa2CYo8Eg9rStFa/DLf3lXh0vC/tgNcBaWSIXVSYVQFa3dZxRkE8cFs0nFLq6tFB9umCryvB4Cd7kKdE7upLLSwNqYBmm7JnP4fEI3u45hiu1MSQ45BviGlpozkCIZoJLScAJpc9c8wxGIMSRZgD7W+zdeQHL7deHOgjQ3Aw+SVXxze17rfu3YwQMGed6F15QTClxDTpJxuS0MRWyU+2A2h/FNfrtcMPKBmXsPwl2gFRntA25fssdqkHLfF1lPY4XhXCyJjEq2pAbaLttRXpjyFl34e2PGMxiDk+5TlCF4/cmtMs01n9ecNjr4aJoB1rRU/nniPv7RZIbE+UQJgCwzjqsF/wQy/38tAJuIWXqvtyaOXIM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199015)(110136005)(54906003)(26005)(186003)(52116002)(107886003)(6666004)(1076003)(2616005)(66476007)(6486002)(66556008)(66946007)(6512007)(478600001)(4326008)(83380400001)(8936002)(8676002)(5660300002)(7416002)(41300700001)(44832011)(2906002)(316002)(15650500001)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ES14v2kWbLK8ud1aD2UJU3oA9nD/t11PAIfKaC6+IF0MG2NX6XXsbyR+9XvI?=
 =?us-ascii?Q?aFd6jreVGlFny1wrtlui49cH1cRFa/tns9xNaJ09CFjXpr2IjzvSVxTCnTBv?=
 =?us-ascii?Q?o0ElTjeKo8l3VNCAGkfxpuNQU0fmN7/ts2IXC0umqWTPt6GNF3LjtFQulAFt?=
 =?us-ascii?Q?bDyerCSn61yC84fUKY3yha4N2GI3YaLdEjA5NaRfse934IrNx1ee3qCeIZsC?=
 =?us-ascii?Q?RZuoBPq8HAWNI0+9/fYvWl0lSTvQN6YO3e8qo92rPtFvspa/CtWAislIiGDV?=
 =?us-ascii?Q?JEUTmOg/lKFq2Z0hwsajfJY6eHUcUGUmvrlLLGKdjYveDY/oUJTg2q8S5P80?=
 =?us-ascii?Q?XjW2jpBgCwgEwN+i4PfnLJTleRjoHRYEtjvRyxTWtQUWe4dKunbhEunbITJY?=
 =?us-ascii?Q?uq+z9IHD+cPKWhTahBJwyAJYbQ0kK8jl6YTfEJ2tRwS9liw6wCAifBz3uvLd?=
 =?us-ascii?Q?4N3xaDIQ+GRd+LMrD9AvQV6l1X2s/v1lpAkWhAr234BtDp4OT50RpPOeK46C?=
 =?us-ascii?Q?F/yxAWsgeHQ81mFQZ41s5eCt7cDpfCfjt5WOJWOiCxpkXDO9FvzUoEGgG1l5?=
 =?us-ascii?Q?yUlZRQD1gbus2XH6DCBn/6ET3WZ6zh+lRqkMQjUKvDSv7TwrvMPZADmQkp6w?=
 =?us-ascii?Q?Tyr5vXRhUNK25aPyauHuUc1kSOiuzvS/CBMXQVpQDajCy81HqaZyFelO04di?=
 =?us-ascii?Q?Ky+Y2EeJrbux16L71lJg/F77AlNVjbjyBGFjPxA7hcmYEvKfYMLyCxwNAHJ5?=
 =?us-ascii?Q?q+1c1pdtetXtp4MvZkg92pvr4Atj2+otTNwLkf88o3SN5dAvgMGjdIiGU3q0?=
 =?us-ascii?Q?YlizQ/h5sawRXsvybO3wx1UmA8gc9WJuKOikyPtWi7qSfdDKwwwWNIgdKvar?=
 =?us-ascii?Q?cHznct7Fr73jXyn73FOYD/7sbWErNGj8nM8QR2UGQGLRoFFkR8Ap9ZlO8Sxp?=
 =?us-ascii?Q?/Muc0L/JeOjJAD8FVLzTzDClsxLT9kuIwu6ZTQ7Do6c2oV1q+qfyoJGKA0C2?=
 =?us-ascii?Q?72Uis//T/LzHcLCmNV6PkkFO40LUDZvIRXX4aCIorkqonQSMbQlbHlNjKLi7?=
 =?us-ascii?Q?dbV+3I+rlF0gdf1wC3su7ozwccrFZHYYxD5Sbqo/tkTILbCtqq/TixQiSiI1?=
 =?us-ascii?Q?+oVCdckU9lMOYfr/rYlUAGnQqTS0pdRSsJ0GPiFeDS3jeUtby8JLSmoCkE6E?=
 =?us-ascii?Q?fDKZXQnCc8HUTc6eJ94pmb+eSxUN1xJay+c/g3L6JqakdRks81uV6NZgfRYa?=
 =?us-ascii?Q?Hayau8HfoIzBbUHGPBM7c5FRe/44BjnPLI6CH1/sbgTV1lB2fWAaR9qgsOAM?=
 =?us-ascii?Q?TQNje/nQMq1wOjpVSue4ePtKgocsRmcz5Ge1r25ESBTgHGR3tjtH/m+DbiqI?=
 =?us-ascii?Q?iCdryKz8FW/OI/tiLXpYg8hShttbbecZZoY2r5YOfCd2uJ9eWC6ut4gJIthp?=
 =?us-ascii?Q?RCe1FkKLZUPdDB4kJBPEE2zSrXalzdnt4L8Nj5dlwhBiRUGxRH4+jwahNev0?=
 =?us-ascii?Q?ubnklyy8S8kz0I/AlIKUr1YzpVZJUqVGy1lTwm4ZaVApCxFV8UoXz6y87OCR?=
 =?us-ascii?Q?/twO6NAm9dNPwWbw8jKFf2UTov5YNTw6wGnY1J7gvyJvBHxutEvO0Hmqy+6H?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861581e5-4a8f-4700-1ff5-08daedd6ab57
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:05:48.0838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+oq4lgIjNfk/hejg1Dq3oHDwXABETIj+U3a8fAYmWnUQk30I3sXDnPITK2HQzwWt7+F8K08IXHUQNN39LF+5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB9900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the speed register bits to the 2018 revision of 802.3.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v5:
- Add missing PMA/PMD speed bits

Changes in v3:
- New

 include/uapi/linux/mdio.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 14b779a8577b..67a005ff8a76 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -147,16 +147,32 @@
 #define MDIO_SPEED_10G			0x0001	/* 10G capable */
 
 /* PMA/PMD Speed register. */
+#define MDIO_PMA_SPEED_10G		MDIO_SPEED_10G
 #define MDIO_PMA_SPEED_2B		0x0002	/* 2BASE-TL capable */
 #define MDIO_PMA_SPEED_10P		0x0004	/* 10PASS-TS capable */
 #define MDIO_PMA_SPEED_1000		0x0010	/* 1000M capable */
 #define MDIO_PMA_SPEED_100		0x0020	/* 100M capable */
 #define MDIO_PMA_SPEED_10		0x0040	/* 10M capable */
+#define MDIO_PMA_SPEED_10G1G		0x0080	/* 10G/1G capable */
+#define MDIO_PMA_SPEED_40G		0x0100	/* 40G capable */
+#define MDIO_PMA_SPEED_100G		0x0200	/* 100G capable */
+#define MDIO_PMA_SPEED_10GP		0x0400	/* 10GPASS-XR capable */
+#define MDIO_PMA_SPEED_25G		0x0800	/* 25G capable */
+#define MDIO_PMA_SPEED_200G		0x1000	/* 200G capable */
+#define MDIO_PMA_SPEED_2_5G		0x2000	/* 2.5G capable */
+#define MDIO_PMA_SPEED_5G		0x4000	/* 5G capable */
+#define MDIO_PMA_SPEED_400G		0x8000	/* 400G capable */
 
 /* PCS et al. Speed register. */
+#define MDIO_PCS_SPEED_10G		MDIO_SPEED_10G
 #define MDIO_PCS_SPEED_10P2B		0x0002	/* 10PASS-TS/2BASE-TL capable */
+#define MDIO_PCS_SPEED_40G		0x0004  /* 450G capable */
+#define MDIO_PCS_SPEED_100G		0x0008  /* 100G capable */
+#define MDIO_PCS_SPEED_25G		0x0010  /* 25G capable */
 #define MDIO_PCS_SPEED_2_5G		0x0040	/* 2.5G capable */
 #define MDIO_PCS_SPEED_5G		0x0080	/* 5G capable */
+#define MDIO_PCS_SPEED_200G		0x0100  /* 200G capable */
+#define MDIO_PCS_SPEED_400G		0x0200  /* 400G capable */
 
 /* Device present registers. */
 #define MDIO_DEVS_PRESENT(devad)	(1 << (devad))
-- 
2.35.1.1320.gc452695387.dirty

