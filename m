Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C15336C2E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCKGWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:40 -0500
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:26654
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231411AbhCKGWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:22:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEyfsaXU79bMt4oRGr4cLlUfaqnQ3m7YPoIjRa8vQeTf6eVwqzgU5GHSeg5PdF/LkdEilRcT35Vm99HIFJ09sWXUkgUz8DbM697kePzxt4slEr5g7S9jfvv1rp52GU6FhE42Lq5k6JO5us4ei/zIvCiIZez7MqHAteXM0wHAfBtqpjt7/svtYxmD4XWBv+6HJNNg382q4GFhJ+1ZCTdpLwEBTwGA9nxIOuPU7lpSrJqAtRc+D7uwqw8uwnSenKDDZEAb7+JOCST7bHKM0tW/5tCLjHbGy5dW4ilHusovdvRmeP1ct6vMSHVKHhfcERMS+NP9vhqQq9VtGk3NKjVDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGE+dQqB5Q0ju9wYpoV22UwnpMHoGA6jS7hGPYK8h1M=;
 b=fMO9gU3R7ZQcwvagJgeQ4zR4Ludu/kADEiZ2e4TKT6zMAwgUBKE1cnlxwiKcleMm5yAm3w7Gwf6bdLqJl4zUZ4dWEp8FCgc/a9rTBjz5XoaVZkviE7RuuTvqWMsnvC4RP8Bz+H++lgRVkAH8E2mV6Bllct7fO455B8W04AWfpNid4DaxkglzHwtlJDGxZTGUq3ayxW/TUJxnXSJ43erWqb7QmUTsQMZ4Ha1yJUAI6gwHVmlAjpWhdhp1UrTT3UEKLZ9xZ+VlFuZWpi0kr0uL1SmG7jmSuKAeoB67DeTR3EaROhOFwJ0Mzb1X0TQ9qJ+Gi91aDk6uL2XV7PiK3RD2LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGE+dQqB5Q0ju9wYpoV22UwnpMHoGA6jS7hGPYK8h1M=;
 b=IWcXQwGnbbwipfwfeFhL5mIeSPN0xGVSAGu6Snwv+jlCz3zDaKqzO05gzCsNuG+sHmCrL6BPmw8cVkMt4F8FFx19vnmjjpBcR+XJUz8wAjGf36lSAYsgEojc5FJrLjGrwWfSL1bxElKmt4V3roRYrSQ/kJY7zoRYD6eyNKgBHtI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:13 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:13 +0000
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
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v7 10/16] ACPI: utils: Introduce acpi_get_local_address()
Date:   Thu, 11 Mar 2021 11:50:05 +0530
Message-Id: <20210311062011.8054-11-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:22:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1db04771-33ab-4492-b892-08d8e4560265
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611594C6E7D799A44D17AF0D2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixRDScbMZyl6pE8Me1soFOWpT/YTOZbP0M9vObAQUD1NePmlLRceOb2Wz8jP+6y0bOjyfawFoy0oclpNkuBQ/IIrrx/cUzPH/mKfjDf4oR1JyDa9eZuSzUtHEOtvZ7VPELqv+uURT8HYux4nK5l3eyKcpUzv2v3eXqi1MV9abQg1va2+0T+SnzAzoJbgHbccM4/Nx7Ntz/JlXk+4VsKVZ9PZcOOZ5CffzKeMSWVOyfYi2+IdjHXXW3oMEVR9iyixfBoOOEjo0YLPP8vTv+DOT+FkNi7RzbJT+DxNlSVFan4nVARCpPqsbxKU8qsN7AbGXCMVYmYDVGE7Rl/w0FR6iKFlphvVuXJ8/T6q0r7uGuaJ18/30ukiDAmKee775aCVWHGareXPJXXTHdQm7dZ6WXLYZFghW7KgoY+UM/CP6H0EqjO4DyekYsWBESvMzn1xlDdSVoYFV4v9cTev9SIRROeORt5egx1RvzrRcuh/3OTNB+dP09OIowaW8J/dCaonxuMgDy7Qq8AmhXUG8E5JeMHnTxKITyAUvImYKdreRe4Puh+XExJLumDh+C6T1U9LO/PWN3WdiXo2sCJ39LcEGlyQHXws/XwlTjKnsy1HfNk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zH/cVp4fgyENpxD5aKgbY7AEE2URUo4rxwwrjKlZiPNmyju+FSTcRnHqNvpr?=
 =?us-ascii?Q?stVM8xDI1ckDEAzLFyymP+NX9QXbQtkjn24+ZCAq8lcpmjd7ut98BsMNFiUY?=
 =?us-ascii?Q?lkaRuR//qrQag5KNhluHU7/zg2QzlymNfbYAm+proeSuyPEeT+mZj6pvLK7A?=
 =?us-ascii?Q?8SMAQt0MEJRaNiXDjsFLQxZNVdrwkzRtr4pSubtONV3vy8Z7OLyjnG1wuxbk?=
 =?us-ascii?Q?KUJiQvHPG/5lx0xqdVXOl1ce1F49ckwEIVJsrFUgbpb4uZOmXvmKdTT0aMJk?=
 =?us-ascii?Q?72TcUKPCQZdLW6Z8yHBQm+94KQ3hbYWn7aSPY90myBBsAgEGESCLC8GJNxsc?=
 =?us-ascii?Q?QwzZtrlqT9Qr79jMb1B2PFStikjGK9xGbrP0O/+heb2Drijz7Rrr9lHmljxc?=
 =?us-ascii?Q?lTA3l1OAbh7AZdtt2bPBKZaAHzuafDqJiDFs9v3HmUzlgboQo+Q71QWszHU9?=
 =?us-ascii?Q?IOC8O2CcEF7IOi5OPbVS6rqdE5XP7QhQeKNOk3P401GYJxfYczlkHohHuLpJ?=
 =?us-ascii?Q?eO36aFYhMLS9MccBD6W+Tjxhjk6oG4sYBT+qdq6v1Zg8nVL69LMPsEH/qlrD?=
 =?us-ascii?Q?bz+4dBuSqR4+KtA7ddtLNdnq8BlZNmvtjtj6Go34H3hfhzv8lF1X7wuIfVh1?=
 =?us-ascii?Q?hMawcSeP7mUWzLfUMP6q6yayzMrEL8vRomIuLjoUQl4nq/lVDa6IzPA1shD6?=
 =?us-ascii?Q?sCiNQNBFeX3VfCNnDF0BrZBSSut1NIVA4X9gCCFWTaxUAKTV0OQpeAszf0PM?=
 =?us-ascii?Q?N/xj42rgklgZwDEFCIt5hfXIvU64qZ96aaN+U4iQoRCsgyt1OtETAG+qcv6M?=
 =?us-ascii?Q?i7br0Db+qJTvDrtUcwpArilA1oQl9RSaNWGdWHBpnS5gI0AWLc2vd0c2zlkY?=
 =?us-ascii?Q?9qZMeZFx5tTLPepkwc8eNcdqBlH20BB156brxKdyQaju5yPqX5Z7J2BjLfwK?=
 =?us-ascii?Q?3TU3yXzhfLpocL052v8AYGUdFaMzZcifziOMnajdFrBWA2962yaSdg5XUSLH?=
 =?us-ascii?Q?YFHlf9N9iU302relaDQO+oCbXi50Ziwubg90t4nFsYZ7SHFXiOD+G6BXFu4S?=
 =?us-ascii?Q?CXy/0ZLu9fkoJqUM8ao47mJYErpj95BgCJ0zAyj4ke7rx/srnfp/NU+PGJPB?=
 =?us-ascii?Q?vzILLfEEvvYU/1lQyZTn45UrLrDnyK5ThRwr3c2Fh9Rq0KNNxvSzXmwTUAiX?=
 =?us-ascii?Q?EPnTodGZojKjtkP/6M/9czykjDfQXKaPnSZwfIWTeZpKmtRy8rBlI4YrI9Wt?=
 =?us-ascii?Q?pXosJ6VQI2b8gyvqgrkO5jHxbyzWWbWiPBoOo8LCs9jDFCh+I9gMOz/1vK73?=
 =?us-ascii?Q?lZ8XA6qHrwd0ZK50/e1cw+5p?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db04771-33ab-4492-b892-08d8e4560265
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:13.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B80SY+ffe7Ybdv6zvslsO9ODpRrsKM00aSuaz8uGnxj0Snkak7sH5vORe1zcdGhDedmyOk0CG6OGSFO2dsypQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a wrapper around the _ADR evaluation.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
Changes in v6: None
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
index 682edd913b3b..41fe380a09a7 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -277,6 +277,20 @@ acpi_evaluate_integer(acpi_handle handle,
 
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
index fcdaab723916..700f9fc303ab 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -706,6 +706,8 @@ static inline u64 acpi_arch_get_root_pointer(void)
 }
 #endif
 
+int acpi_get_local_address(acpi_handle handle, u32 *addr);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -953,6 +955,11 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
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

