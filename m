Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33194313742
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhBHPWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:22:32 -0500
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:34240
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233588AbhBHPRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtCkWlsBK/dkbnf9Vq6JdOLzEEvdd1UDf5pJLkv3xFgi+oQclnb3bGyuKBnXgSgea2b4on/GPffxnBsecFYwgr/s0cIRRI+eK0SrOwYRbbj5uD24i0X3ZzUH4CgvxuTqhQxX1ggyFG9OCjf8HG10NQbztZeFM+xyLVsUGWYx1uX4J+zbbwDDmj6hX026of9lACzTv+Kz8a6lrAhvhTx8R++xWX5LXcHIZSGLitPwt1Bo4l75AHmT4X0xfuxCxi1hIxZ43GrURsBh+0e2biIbcSAINqtjFvvUSVxOvwaDHzApvxVNZ7WmksOi4EBUAkzMk7qJdErf6PDb735HYpPGWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL0qBZPAdiA2FFpa8M03X3CM7yKo4+kkGIejxoTd1uk=;
 b=FadVCjCvY1Vdzm34ln7E/+MvEMkb8TeuxjVmCr6iIrR1PwIcTb3+6oJbp+mzSJF8qSY/oLixPhF45Ekv/sau9cPeHd5OZjwLgZmaDEFYPMhmsY1iBFxKOYPNdScLM28kWoMmUVuOde3kIyWItAYRk4RwqQZIFk6SqxLKhQjGS8mg2CmNKoB5o89W+CrUY9wJaNsBEV1RXXUVieeL2qiiayg1RHEAbrtjUxzSDKUFbII0dveKDAD5mRmhZXHWiknNOQ1ley+DAIurX2/UTIE6gzwTFBwARX1pGu52XunGxqN27t/ZYQXi5q+FUDRFfGYq+INiIZ0tCbwvQKDMHkQjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL0qBZPAdiA2FFpa8M03X3CM7yKo4+kkGIejxoTd1uk=;
 b=JjSGfFaA7OFbkqEbha0Hrz0eSmjIIB11X6A48HZaRYBuyt8WTNLV7pUPxub3++1KTH3GHNP6qvIyCCCGckKYxJXi3lOaFUExh3WoBJul0FAmKlGG6YmVEdf22tsQJFHuMZnjc3XgbQVeA9RiEKNMxgH1Z4eeBkysjfr9qIBgK54=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:20 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:20 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v5 09/15] ACPI: utils: Introduce acpi_get_local_address()
Date:   Mon,  8 Feb 2021 20:42:38 +0530
Message-Id: <20210208151244.16338-10-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bd6d8fe-2214-40b9-66f6-08d8cc443555
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64354421AC4FADD3233E74B2D28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdYfx0wIbD67ZPd5CGgToNiPmqtR5Uy4PFvtESaGarJR6Ys4GHel7s4DYoVnnizJ4eESoQ2R8vZWYjlZx4t5yPiF9yf9FCKHp4IUz/16YqD4/kNYpJtpmnOmL7yY5NZyInFVesM4Oh2jWiTL2/HzgGNNwoH87B+9xAR+DLj1/ByO6/4Z68ORESyT+WPibO7HmWCyur7mPMJCWqlEUQgVgNiJPpEhZj/Q9Mx+5eyNf0OsiHFD2ZH8FIYyxF7scCgNjr1i+KG9la8zcTFBmJp5f3mSFIg3VTE+MWHm9fPr4gmphQLA5IYZwpqKnb12bMXMvNh9pqqThjGd8xgr3w8hhGwSjuvE2X9sknAAqayARdgTLMCYsNc79bc76r3QkT6JqjKfcv8Gt3ILEbBfuR/TCBNe7OQAS2Bkw79slPw9MYuQ+aHmHxVRkvpCxkpcg4raEMv8atPvptfbc7r7aGL6+wveKwkzf8W5gFmElc0E0Bhf0whH2ao6MZNPm32Z2SAewFqhzVl6A3ybp1QvYyC6hPF5DSsod1M8nIivWEUa7lEdoPIkZJ8Xo2BTRq7S9QYZLpt9+7drWDFnzT0yPOqNbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dsmiHnJByy+QqX1b3Qj7ZlstgurKIHbJ/JGoVDahH9zUK5OijF6gnTdYpa8G?=
 =?us-ascii?Q?wCnut4smwfM+BuMFfuy5N8+pSxuTgEaWyFMkQVjCyebXFQI//W2yaBRgfLQH?=
 =?us-ascii?Q?Ti3mX2GTfhPQ3T9R3mLHsOprmcpKpxohs64kx2Bu4naqfhBCphk65JExQV5q?=
 =?us-ascii?Q?v3kJrpNC/Zmv+/WS6p+/aHEdAwztHrj2qZ0dm8xd7Y1/wlhqZjxP8Rn+kvoc?=
 =?us-ascii?Q?fww84p6VSy8Pe2ZMkJlNMErXzsqrB0YTb8Svcerg7YND9o9gp7iuRud5/jrE?=
 =?us-ascii?Q?nMi8oZmYSMkB7pjxSZnSL+PUV5/PBAPI7J4gHjKdCcJSCgHvyknsgZS8nNsm?=
 =?us-ascii?Q?oy53E9HlyOVPzriLLKxQq/IeJIN7UtbUI334SgEpG3jXaltDXaF6/yGFKdiO?=
 =?us-ascii?Q?V0TYd6RDAdttiqv50BZV8NeZKA358I+OFMeVIEe4OXSWxLVYIcuZ9LpU30Cz?=
 =?us-ascii?Q?Z/jxu2t6YZOS80+WgaxDalTuNhT7e98wGs0JxeOE0Kn3mWxRcK6Ey1vDrCZJ?=
 =?us-ascii?Q?kyzaGQC31IgKI+TS2sP/3qCWEl7VZFxTMATltGrQRQFmx0A3cvtEpycGlyc/?=
 =?us-ascii?Q?JO5aVTF7i1WbJQwTt8LF+CcGDTOppBZuvSODzcyF0QKoiT7SlFBIs4i3gtJW?=
 =?us-ascii?Q?69jYKnWFtr83uqp1iyY0yyhX6wCqxsALP9LDvjvIx4NNhxZ+ZVXPkCTiK+BF?=
 =?us-ascii?Q?e50Fv70pzdnkHILZyzyYJVqZrdwi9yGSS6nOLeZ/j+FaEws5/AuSwkNAkDPJ?=
 =?us-ascii?Q?2crDdx+XdidhjQtO4/MNboSzSoUvw4TDqhlA76Es0yAiuJ8YOxHRYvDRSkc/?=
 =?us-ascii?Q?6FRy173Wp0Nx4fbvng4Ras8lzjpcqqB7Cz0fY70V8e+KSDX+QGolQ7GGzmY6?=
 =?us-ascii?Q?cUlprXkdQlzK0VFfXFjjLCeRiVFSbGibDGks8BVyJqyoQB9k1Fv4EMAetih6?=
 =?us-ascii?Q?RWalHoWNTiJd/GGpRukmm7RlfD8WuCIJn9Cnsb1ij2iQlINzV0rkFO/iLSWh?=
 =?us-ascii?Q?/nid/8jLHRo8nnchySXbfoRvVkxJTSNYCILbylEIM/cBWiIhwcHTC85s25+O?=
 =?us-ascii?Q?HykQxNC7n3d+xH51rM3HORfC9pl0gqezc863o7T9vGsVFM1LyhXi/w0yiKSH?=
 =?us-ascii?Q?+phbAm5uWR6duNcMm04u9nsjbqD1asHyc5IDsNKysNbTLm+o+6p/qw4GX8Zy?=
 =?us-ascii?Q?dR0ceOZ0uPn86XUyLRBdlt25ZSXwAJ9qiBjpylGWaVUSiLAFWBZeM52FFc7+?=
 =?us-ascii?Q?u26dgtHBnMv4nKvnLx7M9ezTztwMp7TNNLbhZ1Ui92p8BbGlsQRDWo6q1AHv?=
 =?us-ascii?Q?Wg4TbdgBqXWY0QFvjpooNcbG?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd6d8fe-2214-40b9-66f6-08d8cc443555
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:19.9985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5skC722HaIAA6MF4royhG78ERK118GjrONnFEuXLMevBNdlORAGYq9EFDbTP8FTpa7HC3MgaYVmwlkv7+dkFhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a wrapper around the _ADR evaluation.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5:
- Replace fwnode_get_id() with acpi_get_local_address()

Changes in v4:
- Improve code structure to handle all cases

Changes in v3:
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation

Changes in v2: None

 drivers/acpi/utils.c | 14 ++++++++++++++
 include/linux/acpi.h |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index d5411a166685..0d3a2b111c0f 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -296,6 +296,20 @@ acpi_evaluate_integer(acpi_handle handle,
 
 EXPORT_SYMBOL(acpi_evaluate_integer);
 
+int acpi_get_local_address(acpi_handle handle, u32 *addr)
+{
+	unsigned long long adr;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return -ENODATA;
+
+	*addr = (u32)adr;
+	return 0;
+}
+EXPORT_SYMBOL(acpi_get_local_address);
+
 acpi_status
 acpi_evaluate_reference(acpi_handle handle,
 			acpi_string pathname,
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 053bf05fb1f7..4e5ce2b4a69d 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -699,6 +699,8 @@ static inline u64 acpi_arch_get_root_pointer(void)
 }
 #endif
 
+int acpi_get_local_address(acpi_handle handle, u32 *addr);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -946,6 +948,11 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
 	return NULL;
 }
 
+static inline int acpi_get_local_address(acpi_handle handle, u32 *addr)
+{
+	return -ENODEV;
+}
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
-- 
2.17.1

