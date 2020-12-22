Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BBA2E0B12
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgLVNqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:15 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:47333
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727271AbgLVNqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC3U+3PyaLgLGYH6dV8Ue4PwbFSZUdZcPWC49P1lh8lRUhaLNcb4nfnzsM0hjM/BJqCs+357ribgpyEv95fFmMWM+RMPh7qOe3/C4VshUxdOZeGOYlICbRt0xjSLW+zoxA+/X7TUgOqketjZ+wr6pQJZBNCvSWBHed5F03Jn16mwuSZwpSKOhxl0PiDR+wiPIvmZ5wI1DvYoFYKpyVFKfszkX2YOp75w9kb4xJjgoRZ0wNKy7GfWpkmZo75jGsD5OuIAFB9LV7nWrxTi7L+rO2IhLHksSVklnLh+HGLCNTE6eXP5w9yzxOshGvBeTJ9+Gj2iLIvGEZKOK+9+J4ESyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9FOywM5i+U8D4LoluqhiCcmpfbuR+XsQF7kn/+eprs=;
 b=aA6oQiLck23YqGSPEut9uu0otW10g+GgXyDus8/+CQXw3Ocbx1WtSfLj0HPDHbMSuu/Rk6Vh/CAh7qR9a2y9DtYuMq5r4wo70jGJcJzJkLJxtMW7L7RJ1egLfjSUPoRWBLpUIwKQp1EJmerL8fcVUN0/YQruKW+5QP+v6JdKykDeqDlweVhlsDEOB5PxqEqX5izX1TJGPnHHQvFEqwSMm+v2IR4wmVF1GkGz842hXwxgJLk54vORdc4Et3MCsvbve49S7HdDiqvD6AHGdU9rg3nidw0oYCBYFgzEQ2Zeyxl7Qi98m+wyjjXVB4mWYI92YK7ldbGvzempBrdgIdScpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9FOywM5i+U8D4LoluqhiCcmpfbuR+XsQF7kn/+eprs=;
 b=QEdBT++WMkD1MH+jVcKkiRzdyhmS38Gj8sIDaww0ROqtvWvIHB/PjHD0kKr0gEGM71pRdhst1qWux7xwhn0BtQe+TA6JujJxAw9HnSNvoez7GADh9Cjcn6/qG5HtpmiyV4xA9U2ZbKp0R/uiW43Z+yLdbxgVUa5EYYj7yChDIeQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:58 +0000
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
Subject: [RFC PATCH v2 net-next 05/15] net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
Date:   Tue, 22 Dec 2020 15:44:29 +0200
Message-Id: <20201222134439.2478449-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6fd53968-f14c-4bf3-fd22-08d8a67fc5e5
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408D045AF63147FF3781DBAE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6AwkpbCQ0k0UI2ranLloGkPFxwM94cp8/J+WzfVJK4L4RLAxc7S7rDUowFhD0UOeo72Hbjibu4gUx1pNC4/9YaxqXy145hemxbsea262sAPsRBIty++AXJlj2aSQCbIybyadwxh/LWMcqQtZofLYuKejzL13gE9nM9UyXww7bpb3fcgeFjkAMQxb5Ddek/9PwcBscjJppj1MTOh+AqWAt9RsoTMPtpuI6wYygyXE6+Y/Cwl+s6DtpUw6e1VJ/ls6I7YgqWBDQO9VAvLzbcNuFWdQdAHRMHaDGFtQy2m2A0vQnuUG2uDPwYtrsFRnP0EjMdXKN/2e6wXWGQbSY29NHFitDTI/nSocAQ6XY3Vx7O2RUFX0lDsuFpxpmUjWDvQZTkfNueLntl8QgfrkbIQ6Tsh5F82ubhrpFvlyvLjUdTDFEn4gUS8goTmi6BDscow/awOOxfL0OSgI0zqfadjsjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?09/fX8PE0I+ED8KyhGrQI4t9rEXeUyfjnLXS2NYk8hkd6p1+cmWaNQXBUfbh?=
 =?us-ascii?Q?e5zOihRy4I7aq6UVzkAzUxNUgIW81NDsDMFpDrE/y0zHu9jIKIm7zQGqRRyd?=
 =?us-ascii?Q?LynjznE8+4+hwu3idJHSzlGMZLv+Hs1ZGRhX4i0w4LSca5+PXoDqcfteldcZ?=
 =?us-ascii?Q?kdR6f36gzuFwXZ/pUwRFr4oSHpm2sqWT1DbfHi/HFchsZqv+jFx+IDe3XF3W?=
 =?us-ascii?Q?HPxMs2GpBNU1/UlehqFwcCgrrpGo16rp4abO0hde4f1RjXIK9Gurb9YxHB3O?=
 =?us-ascii?Q?IaFqqSi5zr/3ci8yQrRPutPBD3QeeIK77UZrQcuc7Fqw6KfyVK2fVn1DUzjr?=
 =?us-ascii?Q?Qb8F3V7RjeWOMwa2+/4cUxZU/BrG09/OMfdx+qyDdJoFj/ur3b1QCgd9Z5+6?=
 =?us-ascii?Q?wyRw7AWc1qY99jxaFx7MVd5E46nAPmn3x+tVrRHnYsaN3XgS+9EDjExJxdJI?=
 =?us-ascii?Q?ZiqFDC7WA8xBnDU/TFHDk6VUAQdnGFzro+jQ2oWpjj8xqmFKLL+BMvLkcZAl?=
 =?us-ascii?Q?KuigmZJEYpzAbij5eU8VohKvBgZfRyFwfTvQ9lrqj5ij+bvyjtDnRQWdnhcv?=
 =?us-ascii?Q?gEr5MVO/3T+dibHK6jk8N5ziSiUCK7ytsyILbXaNNTzOJOKggf2230jo1K7A?=
 =?us-ascii?Q?Ei7vV7GCBlKV1jNhX0WXbs+uIn+hsuu6wqfKe3UecqazjoW+g0Q2nRWcIPQG?=
 =?us-ascii?Q?NnNZwUOxC4CmSPHUz3YegiuQAel2kKRw0tiULcmrldf8Po2bhlGlp5Lp3sDg?=
 =?us-ascii?Q?Dy7a7k79EQkbmZ4p5LQLXnlRzXjwWJsd6ZCsi+OHf3C60jJe/zkqn/R5roBc?=
 =?us-ascii?Q?FN/i8suMPu5vrBHTmKqU2B3VTYQoj/LzE1XFnrrp1PPbNcQh9oTOM/56eoOC?=
 =?us-ascii?Q?zBcZLSvpkyL2E4762U3IMgwsMRWAbBdXd/svvTFFdzbWW+XfTa+tcprvOCBs?=
 =?us-ascii?Q?rN+GlwrYrXFNTvOw/PqWmGYuu/k2BTYRmtSVplQEiNFLIEtBVV5rDJkEz0iU?=
 =?us-ascii?Q?43GE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:58.2367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd53968-f14c-4bf3-fd22-08d8a67fc5e5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJuuxLS9I0dac6tbfmfOjmwJ8AlFoxPwGdfcNbylG7jwi/f/yKYs3uWvKVtUbU0Hl3JaMhUzkdyKn/ELovyd/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the xtr (extraction) IRQ of the ocelot switch is not shared, then
if it fired, it means that some data must be present in the queues of
the CPU port module. So simplify the code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 1e7729421a82..00c6d9838970 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -605,10 +605,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 	int i = 0, grp = 0;
 	int err = 0;
 
-	if (!(ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)))
-		return IRQ_NONE;
-
-	do {
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct skb_shared_hwtstamps *shhwtstamps;
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
@@ -703,7 +700,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			netif_rx(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
-	} while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp));
+	}
 
 	if (err)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-- 
2.25.1

