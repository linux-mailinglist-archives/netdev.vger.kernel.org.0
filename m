Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6452E0B1E
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgLVNrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:47:23 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:47333
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727517AbgLVNrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:47:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRaxL1Hz0Xt52j0quh3+F38nO7Tg/Q0XK290Ad6xgYRWcw5AaOSQ1kDJb/Dga2J0XNnQ4FnvJqYsDZOZ+5adQ5qFVK7cP6rvpmIkMqfMh+KQ0bdy2GrQys0zSgRG8XmHIvQ9G6wUEERjNnD/59L8vOBsXsmA/9RloUrr0UtXp4qtmFsCIpNjBW7Pnebj3m+T6pdZtItnl/CLpR0a3c5eHD6tEyxDZq0LQ/v2RiIZ4Cqr1h0G0ZOMxRiH5l9w2QvhAtDHV4FOt1/eti2vrW99U/QPmf8LmH45fCMS3s2GoMbV9tfr2uE0pcryoVEWrjTqEeopoif/VV3mR6yarGMJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9GoTYAED/6zErOrVNHFuPnM2HNE/y9ihmE4PJZeU0A=;
 b=AS7XIeeT/M1sxOgKrU5xhKvVak2sc0L8uwuC6SBGtpONraWZ9MkB2MqZuGSldPJSWf1Hrb41VsylTzy4BoYzYvHrRf+ukBbZkSZYvVrhzMkPA9drj/CD3pigqVySjlSKANkcBIrQIYvFXkM3YMv+BVIUj++cr4KJEJzMoiduCVrkcRcOGqE8iSD/02nFakbgE2dTHmcc8yCvRqFlnq7bPOXehtw92labRP9WEfL/gesBZGYl6McocmvEZXkn2XkHzR3O4GXZg0798m0n5Hin0iYKC10xoo+VxiSZU43GQx5rdstWp3dmYaC2GnftJPghrzyI87lzytfSp0L5veFUCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9GoTYAED/6zErOrVNHFuPnM2HNE/y9ihmE4PJZeU0A=;
 b=VJ1CNprjH8/c/vjA6m9bMHsWrrMf0MTLxWaJSsqU/E2YtevmZ+MZRiX2dvzKt61Wf1xrfOrNzUQy6oZDK+UOUALXOKO71y1YywONsxZ9t47Bup8UiYnzzu3fqmvPaA6GKM77efntXIOUBgchiDie72KK8iPxAsnQOmOpKSwrnbI=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:05 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 14/15] net: dsa: felix: use promisc on master for PTP with tag_8021q
Date:   Tue, 22 Dec 2020 15:44:38 +0200
Message-Id: <20201222134439.2478449-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7347e165-680c-4cee-f19e-08d8a67fca3e
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB740884A2EC555DB5D7F5C302E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsVCod2Idobh02Jsony8sFS6hL4nXq+IirBzWO4PwI7athmnKOF8VTXrizhXi6nIbInslMhtNtNpasfaOQoipLkkyCr3466el+JaJZRCS3dMpcvMISiYJq0KKbKEBxCVa9ns5+KH34iGpiIAnV8GGKWBh2X/cp8d7rrLROBQsIIqQ6hmWIjXyNMxLwBMOqhHzWELEhmBqmLmytMnp/gJ5HW4/IFcltcXTflywx88C2IVNdrngFqNGS/rMnQBCYf7/tcX89dY3ISM4SCPsShGGZpTW+koITpwi6BO/8FvPcYPngSP74snjC7rmUOxJYCeBj9h08PuKfZNFNMhInijSiSzSzanuHMlm37IU5FJ+fVmKE2lY3n0jw9uUGHnbPyPSSXQNN0RRAll4LN8onXB58N4zHhfuG6UuwQBcxPCuaIblRAEMN0QbgePnMWf+ISu95gdrR26ezjoW9Fq2Fk6hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(4744005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LusBpAoqDHtYq8RKYjqmYN5axZeUtKvean9KxSDm4/Xq+NyOWvI9d3DNNCyg?=
 =?us-ascii?Q?79Spuro5GTCZRy7ZkoSGMD+aeWl9NUnSxDy3f5SWnDAbZ+Ez1mQsuuJYN0ti?=
 =?us-ascii?Q?NGD7LvTUWzwDEjygUnjQ1yFpZiFyj3CLzSCnpZzThPqSuw3BbmLtcqcgNfbS?=
 =?us-ascii?Q?Ba/cYz4ytmx9Uy+4PJuROn4fKmofsSrsII2ajeYehDtX9o13dtj26EZZX087?=
 =?us-ascii?Q?am+lPakHI90NCp4OZZqA68n8LJhjRbjbwL3K3fCY4V8qlcIIikQEwfFtmVby?=
 =?us-ascii?Q?pANbbn9KmFNTTpsn4NOcFT17a98ZDDEjRu9EGk5cu2qRgdy0CHTjyY7WS9vQ?=
 =?us-ascii?Q?iAp5a3vESCaBD8HGoQkuNk44uRcu0Kn1O26pUsII2xpoc3lIwa4M6AHbPfB6?=
 =?us-ascii?Q?YVcvEA94rm+GM2REtAIDjSjVbAcPiiSgNY9ucTDIWsHxvpyWvcuZMydTwXlX?=
 =?us-ascii?Q?N+p9xXd3rY/4w6K6GxIRJezn3l7WpToarIm/KZSJqr01XcD0aSRZv4wJN06i?=
 =?us-ascii?Q?wZp8CC/rAkOT+G9dd7TViR9ZyOtBh5XiomlLI47DU4FKpKXXVABnOYKhTDWP?=
 =?us-ascii?Q?EK9EexAHt2frteJzs3UOO650KGrN7Ec1ZhAYeaXYbAgl0tEJfbDFeQ7Q4CRF?=
 =?us-ascii?Q?Rm7KrLpXZXIrks0lopPglO5j7PtsjRurbCjsPuAqlK1FaNWs075/6pbdknLw?=
 =?us-ascii?Q?+oDmWCPhwpaHzNZkehY7/T3NBsSwVXyyX0Ds1GY6loqZ/vCoviu/ZNFdWC2F?=
 =?us-ascii?Q?mj6JVtlwDTxtATWJS1+ckvehCLnV6MtsJ9FW/tcbv+cWE4/Y1Ov/Vp4LsMwl?=
 =?us-ascii?Q?fkkAUu4Uqqv+Y1wOKRIl72BFylw/9AVpaq52YGPMSLqjYfR7Ls5jQbKHL08f?=
 =?us-ascii?Q?BN3oqVKHNCYITd5Yjl7qrGJcrPNX5F3816PF1GZqb9wP7TZsWS9z5ToCbHbK?=
 =?us-ascii?Q?O7MpBzyvbKmhjn0DT6x8a62yyVTe3Ps+Z6eZp7OgZm+pXLXony7HhEVtqVRm?=
 =?us-ascii?Q?HCbq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:05.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 7347e165-680c-4cee-f19e-08d8a67fca3e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sL1LeWYgjZKtFZ5qeh37FZpNMURFdh5OgyhQR+pxbAXJKZvmNMKuyswCnK6983paD1/Bm54w/cgZUdDIMCuBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is for the "no extraction IRQ" workaround, where the DSA master on
LS1028A (enetc) serves as a de-facto irqchip.

It needs to be promiscuous so that it will never drop a PTP frame (sent
to the 01-80-c2-00-00-0e multicast MAC address), otherwise the tagger
will get confused about which Ethernet PTP frame corresponds to which
PTP frame over the MMIO registers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 net/dsa/tag_ocelot_8021q.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index fa89c6a5bb7d..1b5102e74369 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -53,6 +53,7 @@ static struct dsa_device_ops ocelot_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= VLAN_HLEN,
+	.promisc_on_master	= true,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

