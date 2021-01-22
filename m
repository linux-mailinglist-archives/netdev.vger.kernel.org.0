Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AED3007C8
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbhAVPth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:49:37 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:13634
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728807AbhAVPrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:47:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ac12epOOdEHMg+dpLOUBNhWVZ0QqdE8/r6s1g7itrUZTWRxWHqyES4Xf6expjV1hPXW4oODH8AojC5GjkYTb/XtecbIhg7B9QpXnsMH9YCztrjq2iA/k48zUHm6HTnYLpzyhVnrP/gkPaz9MP1xSKmBeBfu9QY4o0TxAhpVZ+16DDETYvpeUWP2llfF0n31vrg02nxp1TRnBB4XWXSN/nCR90kGCmcM1izy1JeOmlvNGRtwLWMfZ/ut045uJxBnCzWLHFxPDM57LZOB7QUGwt1qJjSXPuFwkBtzKqPF4Sb5WqHmIa9ULNBT887MyqtLlVRMgOT9sKlXUUcRXLJaRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7/kAEER/OsTllnLifBkVu7Njodnkbk6ftA91/uO56w=;
 b=JihrcUcVKfCmp8IHFxYEH7YYrXXEu0pDRiYTdpdv+eqJOh4zch/jJnGkE9vXVNWp7JHTYRiiIE9l8DEGuP/la5ip7v0MPFyY3Oyj/cm11JSj0ZhbVrz5ntaWZDY2a2Nh8QhzNChnkGFSxIoMVNYsVaFCOnhn+8JdckLCtH4a9jNHNqLd0yOOPEw/bL8Ud/VQCIyE7N5ygBHcYGzxrQCOThZvUbF5SipwxOQgp/qRDcgBKNYYXnTwqXTSIqCyZMwcZHP9vQLPU+x6as5AVkv6e0LAh3MdSqH7Ae7PJMOLCVl+RGQKDeEG3jGM9nluSzvxEvUq8Mr3He2ciPUClihmiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7/kAEER/OsTllnLifBkVu7Njodnkbk6ftA91/uO56w=;
 b=MRx7jmOplbhLKzoZL96T8pTg72SloWOmgc+FvnAj08DriQtUMKKYADvim8c7HY5owXE5dhuvGTS0+htSugL6jgYTfpPNUmFZUTV5jSClV/NStpz3BBmX3+h/sGtSOhDe+IG7mZ5ktjV1uKZQjOdIwbmB3n82YfDF4E+7ZD99kT4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:48 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:48 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [net-next PATCH v4 09/15] device property: Introduce fwnode_get_id()
Date:   Fri, 22 Jan 2021 21:12:54 +0530
Message-Id: <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5985425-b386-43c3-27cc-08d8beeca615
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443EBD577666C2B1997337AD2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMUznJIFRA5WjWLJevdcDTkp/jtUJ6s7eYxdy+R2oxNuiR+/bfzWEqwcL/5bsBplEIiEs4uPwGBaTUHAo5J8Ylz529rW6dNVowxB/gzAjpza61RaHUsa4NVZaPtt8l7L1qehXTpCsLLkU9Y8HouC9hSlKplpKCTp7SRJBa4K0yu52qvqfGD3mfl9+gF3MUpzVK5ZhLwRhOnrYPPbvC+E8I68i0qwQl4bKmxxGusus+VJZshhKBk7j/pOj7aaJOuzVrleltgDFTR1gmYPKJgjMCKOIlubBp8zQEMrFemRcy8bJrL+ftHpS/FOgqLj9/nvxjoyiVkJvNK+s87uO2KtbGMbUfM4lPKQcYgInEzHyLY/8aLak34TBlRiV0XhouIIYmx9OevXtDfa4D8MZiiZa9Oht7cHfqB29Mp2nyFMmCUPdvM0HUZnccJjw66bjFgCBMu3SB6Okx2jLw/MiKopYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5QCtMUEU7fL7FpzvJ3skWekZujaSzmzbJy1UJqZE++/bhvFmU4nlwHXV0iOa?=
 =?us-ascii?Q?JI64W/tR35FEDglz8curUJhkn4FUjhQihGG9osrmkstkmMXaR8OzwJxC//Ee?=
 =?us-ascii?Q?qxGTh0CayVW2geWjWBH/ELHuPrIS+q12AqVELsSj7fGJKiB8AxAfZUwFH3ds?=
 =?us-ascii?Q?VUqK2SccxnGWU+Z0UEHihQDlsiZP/l2HAGguHYNxV5RKM1cWVpMYp2T4UG+2?=
 =?us-ascii?Q?qeos/lJO9cPCdRGZe4d2nSd3D1dOASIO0zBSjG9D304sUbs4zZhjcLu0FabJ?=
 =?us-ascii?Q?BjtewRKSkZFIp0PGpgBUpvdynv9lLqLknBc4X0CIpn0BY5F/8P5HTyEfFRXU?=
 =?us-ascii?Q?/KnmiOk3wUv5bFNoAn2ZWqxG66i4K8tsllCZul5y6hHnnRu9DhHPU8u70GpD?=
 =?us-ascii?Q?cQahXK4Kx+1+tqTXuXQ/RPAOunWCcVnsmFSHzX71NPdQIsFARJnSCaCYicG+?=
 =?us-ascii?Q?OKZzOcKLeBJSTg7ooDjIPmaeHOQVpdhxl6YsI1ujWuGIFICxT50l+D3ze9/y?=
 =?us-ascii?Q?ULBVVPXi+9gLL7RzveaE3J0Gpb8/G+zDamv9qL/n7RD7inWinaecGLWncy0q?=
 =?us-ascii?Q?IrLoJKz2U8FiKRM034f1P284MFCOtd+21E4eI/nbYmn5Z6oDS3UxC7r+n2d3?=
 =?us-ascii?Q?qwWkHW7U6f+0JkMypVzmKqk1e58xPtTxz7ev3KG3YitZEYlQdi20EeeroVq/?=
 =?us-ascii?Q?WokD8rJGDgvrUi+EfVhhCjSRVCheeMKFCLiI/toxLQplGaO7btg344OhItjg?=
 =?us-ascii?Q?A8Vmrcv42hyxo5pBu6TmiC+6WfgXn5uJHdFdmwS9xwpUYo0Av12RqLrnMt5m?=
 =?us-ascii?Q?+bhc5YHxZjYgDpwhMyG6DCra8b5V55liCDOVEAClDfxSONcQ9KSLTtEKwThp?=
 =?us-ascii?Q?oTIdeH2bUwIP188hKlKRqiwnEGNzlvpGqzFGNy5C1wJadnLA7AaUlZbsz5an?=
 =?us-ascii?Q?6DGZ5ySploc46tMmKN0+ZaknDJ7piamIu1ShcL+KgZRcKWEUt9/xWGq1EbvV?=
 =?us-ascii?Q?AozvUA6nf6rTuJsPn2Nh9EZB91TrIpIRwvYiA67TalBHrulWi/v3y6S0pq/W?=
 =?us-ascii?Q?C5tXjs/U?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5985425-b386-43c3-27cc-08d8beeca615
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:48.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcEUeSpQNK+NVWnc0b+1hspfDQ9sB7e6ai/LhdIoJJbxncLGERK8dsMqQWTErvdaKnK9+uIVqW/tzFR8ygHTjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using fwnode_get_id(), get the reg property value for DT node
or get the _ADR object value for ACPI node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4:
- Improve code structure to handle all cases

Changes in v3:
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation

Changes in v2: None

 drivers/base/property.c  | 34 ++++++++++++++++++++++++++++++++++
 include/linux/property.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 35b95c6ac0c6..f0581bbf7a4b 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -580,6 +580,40 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
 	return fwnode_call_ptr_op(fwnode, get_name_prefix);
 }
 
+/**
+ * fwnode_get_id - Get the id of a fwnode.
+ * @fwnode: firmware node
+ * @id: id of the fwnode
+ *
+ * This function provides the id of a fwnode which can be either
+ * DT or ACPI node. For ACPI, "reg" property value, if present will
+ * be provided or else _ADR value will be provided.
+ * Returns 0 on success or a negative errno.
+ */
+int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
+{
+#ifdef CONFIG_ACPI
+	unsigned long long adr;
+	acpi_status status;
+#endif
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, "reg", id);
+	if (ret) {
+#ifdef CONFIG_ACPI
+		status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
+					       METHOD_NAME__ADR, NULL, &adr);
+		if (ACPI_FAILURE(status))
+			return -EINVAL;
+		*id = (u32)adr;
+#else
+		return ret;
+#endif
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fwnode_get_id);
+
 /**
  * fwnode_get_parent - Return parent firwmare node
  * @fwnode: Firmware whose parent is retrieved
diff --git a/include/linux/property.h b/include/linux/property.h
index 0a9001fe7aea..3f41475f010b 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -82,6 +82,7 @@ struct fwnode_handle *fwnode_find_reference(const struct fwnode_handle *fwnode,
 
 const char *fwnode_get_name(const struct fwnode_handle *fwnode);
 const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode);
+int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id);
 struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle *fwnode);
 struct fwnode_handle *fwnode_get_next_parent(
 	struct fwnode_handle *fwnode);
-- 
2.17.1

