Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F61E4327A3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhJRTco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:32:44 -0400
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:51809
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232946AbhJRTcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:32:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIMJfeyvdihYbobmsAcCzioPZ35NV3DKpUgrSnJcX1lUrZr68mf2spGWaaqwVRln2bdyn2f6e45bfMzdKXMPiH24ufWuozKoHDWoKs7ECREtCTiuMwuDC9T2dYeHhe9b4bKqlka6K0+RrEbWQpTRnWXGbf/saBQpUvzTAOOW6IQSaQk3dbfK48ATB2SKRBlBT2mbbW/OlxeUi6Myph5xXGt0XDHYIz6qYQ86YOS0oR64wBcnl8en/eh/G5/xk2smR6G3ONIYKkNgGIxMl/5ZWXwj+icZICIjG0SjNBKpLDjOViqMK/SpZ1atT9q6fMyHvfthyWsGxT524e+y25h99Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDqs9Cs57D/Wmia/mkHv47Hpprr5xhGPnot65kokYcE=;
 b=YmcUznA6vKezZ4XMIDi22bsT2YwuU7Y2CjXsnnmZ2qcl9bzTmkAXkKiFEA2mHaSYcnXVJzJ3kkYLGnYteHXktpNl6z9t7dfnL6GWHuLEih8YWsJ4xW8gn6BWiUBDzoa21rZc0ivQfA3OMdrNqPxCRFvAjq46W5KdT8RWbSvc1Kt+Fw5gJIdI1ioW2jQ1oW3xCTskueAxZs9Y6B7PFP84rt2BH67rJrOT00dYl7SzoyTG0rosOKj4BI96sFs8y4Quox6uzGjtkfBi5cbpuMQHtWSQURu2vzbvnOH/g6oQ2CzHXCpY5wUhkSkKo48TsAOdhGKfqLdXJ6hEN/9SNXCeDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDqs9Cs57D/Wmia/mkHv47Hpprr5xhGPnot65kokYcE=;
 b=gvRgizhvZqykEqv3QhsrQtW8qo3BCdP11pgt4i6QA+mEraSQqr7/kcQKcsJc4hekNmm3HbNYh94G7cZ7idmWFiZM9NHBHewA1YFZSfxCvHso37WJfAs2EqigaPUb3jZfOdyoNHJWbmdqkq3ri8dGG4TiAjkBLlF99H52WhZCP0Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4430.eurprd04.prod.outlook.com (2603:10a6:803:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 19:30:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 19:30:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 1/4] dt-bindings: net: dsa: sja1105: fix example so all ports have a phy-handle of fixed-link
Date:   Mon, 18 Oct 2021 22:29:49 +0300
Message-Id: <20211018192952.2736913-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
References: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0160.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AS8PR04CA0160.eurprd04.prod.outlook.com (2603:10a6:20b:331::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 19:30:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29e42bed-209e-40b3-200b-08d9926dbdca
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4430B821C3438A6F03DC4851E0BC9@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P0hXQ4kSKGsf6fdOGwdy48PkN3KINQYIhyuf5tUIKMGNzwO24o4u44b08vMgpPjD4Q67btoHhF5d5VjZw6Vjl1uCAD5Ty3p9NDSYU9ohzq4nSonyW5vdYUIo9mH9IT0UCt56fvoWDJbeF4Z+/qDBZY884raWHd3aS1bSDZv6dsO/g7o8Kpm69VXQwBLsfkifhpg7UCFbpYTSeTYkPpoAQj7X4W8ujBYTEzF0QX+rrAKNpdpxWfb1M68jnUT2hMTteoPhtAfcrAsigdZfiBeP5PbvFUXpaMcqIzSiFjBvy2CfaeYhgA+IRzyEVHzXwfj1vho18oK1zGmJq7GvrOQ/VJa+ktLaZddDQY+Yk07aLZl69AoN3RZoev+cVG8IrowfEzE9QjMfPZRVz8ELQdYXt+pGRSmkJLECP92FrNSZM0IuU4ZeNc87OcY87uaeBm16UksNjHe90FP09nUg9yxUedoRK+OZYws0EN03/1OIEFql3Re0Ku7RppyRZXfsFmNuREKTPB3hn0i0S0beP3A/Qoztyj35YFuR+tWsOxdxIP2Gctcq88VgeHRP+Q+qPt9wYe/97o0DpnU9V2lqVAECQoCZD/SkYx5lLq17nt0x3Bisu5yBC9IR4KOjacnjSnmBoruKOMMdtDSeBrxqiUi8b7DoMmkiENIPEfus4grKlHcUc/eSBvvsxLrMTpqYevpYENL0FlBeTIwtHGctp1Z33w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(86362001)(5660300002)(4744005)(2616005)(66946007)(66476007)(38350700002)(38100700002)(956004)(186003)(6486002)(316002)(44832011)(66556008)(508600001)(36756003)(6506007)(1076003)(6666004)(52116002)(110136005)(4326008)(54906003)(8936002)(6512007)(2906002)(7416002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qRbiBQNz8rinPWIifmiWC9PK7CPOiin5iBxvNlqI+Qz28LWGn+41MdZBRL10?=
 =?us-ascii?Q?uxufxCo7o7FjWrQBvAPCwPDnso91koawuxGQzRfCVaToguzoVAoKtyaP86la?=
 =?us-ascii?Q?PbhQvMjZOxgATmN7MzOQCJYtWQeEODcm4gINrZB9iAX6YSCxp6y1j10MqcoP?=
 =?us-ascii?Q?mABz60qxsa7AS+IUADQK/JSphGVPtwsm8RMynl3c6yddJJPWy7T874lIJodZ?=
 =?us-ascii?Q?1J+21KLbmd1+IesL6dH5MSXMg/tyXjES2kmFnTsLO3XCgIlAwQoAHBOi9YN/?=
 =?us-ascii?Q?hK8NJjVKubVZadlgc4WAHJ1pphSEzIgXUi9a+ibX1LQxmQVebhYeiNYLYq32?=
 =?us-ascii?Q?shYQm/prLCXrogKVPzeVMsfFmyvHtvPgiaOT8IzEfirkdBIsT7iSF8NMX0Ie?=
 =?us-ascii?Q?0bUTpWTItg4iN+uFtVMky0NTkOJTi9ja1bvtMHiZC8fXUFZu4OesENx/RpTE?=
 =?us-ascii?Q?8L/lxtMn15A4hVenoLp7iuJgnXqfPoqMEIX0+sc5b3ANZZfDqYJzdeABSihn?=
 =?us-ascii?Q?IGxoiiNxapgQYrfUj/tDbJNHvTBxC1hkSnVclm7E6oiX55jEH0cPY1uROx69?=
 =?us-ascii?Q?8C4s5WWZmP/S6JEyapZbwZvDOEfjCl656+Sz2p6945DVnRLigXHE9n6mbimq?=
 =?us-ascii?Q?Ru0hflXeir6jFTNUYTNWhxg5OCnGyg09XDMO6Ip1zTjHmRrWJPg11nnbwcTr?=
 =?us-ascii?Q?EUFGP7muwOveawymur6XfpbzkFhlAarDGcgR1CmFER+P4Qwc4RYGKIOla4m3?=
 =?us-ascii?Q?tMs9hddw9SEODnXrXFhGjrmpEYH7pQiZ8S1ukpyi6rxTt8mBCo0KM/0PmYYK?=
 =?us-ascii?Q?TW18Djsyj6AK2JZhb1+jt+UMwA92bRa9DVhgcu8wi8mnyRtUwqM4+sSKTa+Y?=
 =?us-ascii?Q?PRCQ2C9a7J5c7AOkmNmxtxPuGaHJQUhiiUxAZroZAbpwNJp5nTeGuD2Xd4aC?=
 =?us-ascii?Q?uAkWbAyBgXsAxWhKu2vz6gC+l/kjRVa+Yt19/L/9tB2pk+tZ/um52r2Pz0dq?=
 =?us-ascii?Q?aXDaX1KBFm0NuQv6AJqsVsyoqptNGayTSMAobA6mM4zDgDPF6A2woFju2VTJ?=
 =?us-ascii?Q?z0721LqFP2jxwZmQLn/l9vFghuMBDsLI/pbLaG6WFMfndWGEyGvM5oc+tZex?=
 =?us-ascii?Q?9WKhRLXeChoq9gAEVadzCkXFOR2uPrJag7CrDSShVCi0Zu5QC/rInslmPAJ/?=
 =?us-ascii?Q?UF+vD4xGXTmT66Fpc3MAQNcC6I5MyIuHn3y2WVNH1D6IYFYJN/fUrR2o4umj?=
 =?us-ascii?Q?377JhmYykSiqZdrxcRVDcoBGqtbOGqQS47GILEv7KX7elYBfQG7XS5rhU74H?=
 =?us-ascii?Q?EFKL+aaCTU/AQil7erim0YME?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e42bed-209e-40b3-200b-08d9926dbdca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 19:30:28.4845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9LkRJg+1MNaUo5Bgjb2k0Xn3aE6SZqPJb6qVw2kn50QS94yd0sQTnrWmoFLU3UDJ4uwszi2xBpxVqo7W7b78w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All ports require either a phy-handle or a fixed-link, and port 3 in the
example didn't have one. Add it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index f978f8719d8e..f97a22772e6f 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -113,6 +113,7 @@ examples:
                             };
 
                             port@3 {
+                                    phy-handle = <&rgmii_phy4>;
                                     phy-mode = "rgmii-id";
                                     reg = <3>;
                             };
-- 
2.25.1

