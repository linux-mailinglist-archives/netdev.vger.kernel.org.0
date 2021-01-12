Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FB72F3207
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbhALNnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:32 -0500
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:33088
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387542AbhALNn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxIUEtaa0Tsh+cyPeEqLnzdXS2yTjct01pEVLDjlQQLDd1E+maRVtPFJ6VS/5G0CnaSoxNTHPqH1jgAYGqVMeKmcg9dRkaCyjGr6nQjIPf86JbvKeIw3VUbTGAswpRZi77B5gOOiUObap9sdh1UFeyRGzNQHbY3WIT5fACIZiywKMYxWzAMV3wbsPJs3dK1IT/yKpoBCKPP8b09Heu51ezBB9LNVdCImNO/xjHnimMSCbg9qFyWxSdOD1SBhvR2KHvFR4H4Z2cA6AbjcmMdTzGyRxEombukuNNZDsD5lkUy22JWP7NC5T7XS13IOevzJjletFMkHE8BTbaAcH4+cRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouGFRpLMuIbmZVMl5ZYy3uKZqeV45JbADIdapydMn1w=;
 b=PxFrTw6tl/Fe+CbTMFh8YGflIB7HPmxMagkLKU2yP6rMiojbEpcjvVB9jVdPuchHksrcxJfxXiOpQwCJ8WL3UTeFWDn73J2vvheagRtgaSxSgclTxWfuWxUD0jEm+4mVzKI3RMe2+B0o3dNGjHkPYiJPj2LoIsFCBTc1TmpMqUjSc8z3dkTBhWEkLqc+Ir78N+SPz7cR99AeqYuQugHeiC+qcBm5t94GIhntYb542FksvAekkM+9mw+mqoOKHQc7dF80sDwGJbUK+R46hpsmX2rnkxNtEBq39qAfVBC36acT1ZIvxIohu8KegHhT1HD6Q3Adqt1jJAG62mTXfG6DZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouGFRpLMuIbmZVMl5ZYy3uKZqeV45JbADIdapydMn1w=;
 b=OA7GpZSD7oBfKReg9dhM+9QWBXsufs32pthgegDoyiGsSPgRz8Ruo5BPIAIHm2antXX3y+OWiqAZGPVPoaRyR5QyUNnGTRK9CnKBOKCGxc8kVmQcimvlpdCslX6HFybEqrMslMADwp4cZlRiqy/SlyBCeIH9RDav0VlgyHiAq64=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6436.eurprd04.prod.outlook.com (2603:10a6:208:16b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 13:42:38 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:38 +0000
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
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Saravana Kannan <saravanak@google.com>
Subject: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
Date:   Tue, 12 Jan 2021 19:10:48 +0530
Message-Id: <20210112134054.342-10-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3a8946f-1c03-40b0-1095-08d8b6ffece7
X-MS-TrafficTypeDiagnostic: AM0PR04MB6436:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6436C969829AF3F8BA24E451D2AA0@AM0PR04MB6436.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gyrK0owDepij9K57ilP+mXejBPVRnnmZsc7YwkoNZ6M+pudQ3gPPubzRnh3PuLNvpzYb/w5fo38MWxcbDnP1PCY/g7wcUygtY2Z7WImPGz8r/UXc5ymH7I6wj7/SBOO8iTkcZhhYuBtqxNbfGvDTrBb16zRB/iTPllNdwKIGl0VjGvlAR+Npi6dpEDrPQMjFvW3omP33J1eGTkMuXGREj5Wrj/paEW0Kc3pWoX+Vt8wmPhpQKPr0rPWqNS/YQxjvWUROEbjGP3Nq1/gy0YK7Lb66QN55MTsgCPhFTfC17xxNQR5N4C6mUopfwZERCeM1yVxHd2G3Kik8YboOnDlBhVTZhXSvr+d09lgqQ01SBLQZ5bLaM350mBST2FjYgx4XG3Pk4CnpdGxVON8hrQRM4wHMnCAHpP/9vs5WhoYt3OLT75cs4zvYxEVEBMl4G57avHWBuHCOx3YoDZC+rc7gbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39850400004)(366004)(8676002)(956004)(83380400001)(921005)(6506007)(66556008)(478600001)(66476007)(66946007)(6486002)(8936002)(55236004)(26005)(2616005)(52116002)(16526019)(44832011)(4326008)(316002)(5660300002)(1076003)(54906003)(2906002)(186003)(6666004)(1006002)(86362001)(110136005)(6512007)(7416002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l28qWYgE38+sUJcGLODE7liYlQllDCn4sUB2nWEmSEsS8K8EpCyrb9sdnFRl?=
 =?us-ascii?Q?Uyclyo+O1Q0t7/eQ7XDdian4dgxCJm8rCWDlDtLlRflhWbrpTqG0JnuvsrW+?=
 =?us-ascii?Q?1yqnX46I7rAoZpPegdmk5eSxQiNDmWAZy4cpA5uvI7RrzEG7IJXgVZ1jft6N?=
 =?us-ascii?Q?YB80C+agkEJApgDCbmkT/VJ4e29aegP1hqTEoNHMXaIv0UVj3X2W4C9Ka1zN?=
 =?us-ascii?Q?0r3uJqOkgV4c/A9yGM+I940uakRpkWqD5larCI2aRJ5JfGOI+0RiEZ7aBx9y?=
 =?us-ascii?Q?TrASgkSkv6nas3ECeIWvae3VVtOn1qn2yEGSBNHkV4j2W7XSGnD3DgFQm9wB?=
 =?us-ascii?Q?167cxh+o+y0ZnyjhQtxZFOso+3nrfhDVx26C9NM1ZyXT2huKjg96H8Kzft1X?=
 =?us-ascii?Q?yQrJ720grahrxQURwKh4KyJZXL/eoFp4FPwnD3OU0HfnQBENuWstmiqytTal?=
 =?us-ascii?Q?Uwumc8kcRoEDFkzUq8ujT/3UvuKZ9sYiMMSP+kuxBvCNBRTMPvKUdQfG8CnF?=
 =?us-ascii?Q?4LqIiMh3zXtp3pSFqg5o0dVi8MtFeRocdLklbVa1DQj/POTeSPLz9OIP+GvL?=
 =?us-ascii?Q?a56VJhHAF/nMcFLVumHVPLHd+jZ/sdDSOS/qAvM190yLYtwVexFKaMr+VaoI?=
 =?us-ascii?Q?M0MOCWRASLbCvyD4090aF4e+bXRxeKsoh6VnRYTRkkDLvF2lWH5Dg6Wco6Jy?=
 =?us-ascii?Q?hnVNLSo3YKZhmZiAVsFoitGXYncCpGXpngOkpyG3ZGxBINH8DOGTU6QoTAHz?=
 =?us-ascii?Q?apYYg4/0Yo9KJSsTNr9dNcMs7kkMge7Z87RGpRo8VYVpKqG1+M4nhMuJ0ILt?=
 =?us-ascii?Q?jN5QQZcZbWc6sA9B7XQCAwSF0Muf0ThtCX7oNfkwZhxbBrukAeqG0KKULjNh?=
 =?us-ascii?Q?MEQy0qfERjJtmQa4L+IERg7ZIW7EtufdLKK4JCvPs2KS7RT/ODRbfDUr/OPq?=
 =?us-ascii?Q?b20IdpIP6egTSJagiKyxu+b81yUNLqIxeJivYHUkDhDPAiGfETB1oKzmoiHE?=
 =?us-ascii?Q?rjRz?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:37.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a8946f-1c03-40b0-1095-08d8b6ffece7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FbTZc7H8tilziRCeOzE9HTh1vfkWdhnfBiMuQbKAqBnD+YekZsTx5olsD7NXcmzIrCZ1aMRrrnTAC0KfQTCLZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using fwnode_get_id(), get the reg property value for DT node
or get the _ADR object value for ACPI node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3:
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation

Changes in v2: None

 drivers/base/property.c  | 33 +++++++++++++++++++++++++++++++++
 include/linux/property.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 35b95c6ac0c6..2d51108cb936 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -580,6 +580,39 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
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
+	if (!(ret && is_acpi_node(fwnode)))
+		return ret;
+
+#ifdef CONFIG_ACPI
+	status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
+				       METHOD_NAME__ADR, NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+	*id = (u32)adr;
+#endif
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

