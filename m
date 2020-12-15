Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F052DB1CA
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgLOQqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:46:53 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:62181
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730497AbgLOQqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1XZr97BhJ7iDVUYjU14/zz0p39SUnDiu93krkPPH77kcUrxzhj9UtzDYMHvgInZP5heIbzqj7n4BqTOHsMg98CEF7zFqaety8RHwiN7o08w0jAcNbiTCgr3DOf1IYAfiB7936hWFSL92zEmBRVT7rklm1kZMdFN8Y0job+GV0cgvXrXzXH7jrSsS8tD5BM2lSXR6r6rAOfMXfxvLC3vjpvNBpLxEhyedc3bNf4mr6BuG3QG/SQiyRbj5QoXOu4B/win4QWBGc9Wj2dcDCMFEkqvZhtaG+B945b2uGqDzHyFwk3jxGfoEp0Y21Hmur3SsM4tLcv8yNiJR0jQrnioRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQ6HcTkyHQIVmKPxdbmZEPyIPAR9U5iBIGkWl+KATAY=;
 b=JZDbecoHcPpXUSrcctU4pDCp0FjV+q818W3Z+yf8anbYeLdKZJ1YPSH6R733etxBEPL26218RYJteyBPiq0medaGtOW2ypSFX6A/GmF46hVSecLLxYTWjYVA8v5GxyGLAthvTzHa0TAkHwnaUYMXxujKsFqeQbm+76heFClz2jbXPvXN0dFC9CfJVsswZxpnXmEU0aWWj44xlpwHtcc8wb72+lZrogLknWAeKqxLmkPwNXOIkVgD8JyjS8uDL9O6GavFOmZNWEkdAjESOGo9/SvwkjxNBgryzdENwJKDTagQcoMsIsLlfAZth6pHz2NHzrIRWBfNCRhCtbgmWC4YRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQ6HcTkyHQIVmKPxdbmZEPyIPAR9U5iBIGkWl+KATAY=;
 b=eoW+gR0BSl31BLZVP0Angf5y0a7kJeXknNW03ef0Fwg8YGTPIM0adwPGfT6GEzzvMjQQKNq3ENV/HL3DseCD68EhDt8JRu3M3qszRiruWN52eLyPCvE6ikGnRW06KgzEmzWY1b+kgfDVD/Hd/nlwg9Xy2jcW7VK3bxL9QtTFJO8=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:56 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:56 +0000
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
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [net-next PATCH v2 10/14] device property: Introduce fwnode_get_id()
Date:   Tue, 15 Dec 2020 22:13:11 +0530
Message-Id: <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee438216-99bc-43c5-9476-08d8a118c122
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963116866A6DBEFB446ECF4D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEaygabXVpukKNM0fKAbtAS/7ALZyJ/63v6Tt+HwJfN4Vkr2Y3gs1LS/BlGO3LUGDjC3SXi5ZgOl8HcJvIEgqkvlaF2G5OXeK830AlecsX3l0jStNcWvsCfn7Upy24kGEZTV7PMYvTSw4yYr5UnhS3WqWofbj33LXbWlvz1AvykKFRrw9Qv3S76Gn3lQZsGp+IIGjsWj78VcByO+qz+W53Vs+x0uo+8dMoPhmg6elKrhFLVO6iSDfWRTMcR29g7V925A9la4hdz4J1yA/Oh5Rmi1OiSCMj3AMjlmtNQQJDboqJvqTQFyggRb8kNajrqNJcns/HN+rfzRVePn4tjbRtmioXXdcl84osrOrX4Go2ZognH4avqesbSraIaUatZv084XJCEBv3TBiTsw8rdx3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nvaxuruIKkFJkLwBEztILrPmnZFBneifyUiAis8Itpo2nESJwVzYmzvG8jF2?=
 =?us-ascii?Q?0nViSUCbkhggJ5xHig+v+yNEsB7SXqdcHrd5X3XvRgOb9mfKVu3N30cii8sF?=
 =?us-ascii?Q?nL7IWfeLgIajTC1pQPVgKLy/A+XOp2EFfRarAEiJ58JbW83ShxyUJxJL7l8B?=
 =?us-ascii?Q?kH6cSyu4RWJJdQicnqLlXpt7BF0AZLaIoOYdEN/+QC7PsTBn+WZ1bgBmCmRq?=
 =?us-ascii?Q?yHuXnt9FuqpWID45oLr+fgIcfVRAoLpUvY+JTvhwVOeg3x6hNHw0Bjp5jTGy?=
 =?us-ascii?Q?TfOzR9hApWd3/DfO4bvZvqCxF76hc5yVvTjp1vhUvwXlf18AJ8dC1mBK7ZyX?=
 =?us-ascii?Q?E3L7zzEQWnYZ3rRnVaYznolxSGOR0VAfwpLg3XbVQSUvc+sjaxykjRUZNj/2?=
 =?us-ascii?Q?uTIQy/w6f804+DmpljYOUquGK+yqbRCm/rc82bixbtfPDblnnELFa1kv8KF+?=
 =?us-ascii?Q?liqhmbXThx2E6zbUtmRBEQl0s4gbUbogdQwJGLXrFvqLgiUR9CoDIsTJNDJU?=
 =?us-ascii?Q?MyGGFcvPUvU26RCrE5cFPLEbW7CvJH7A/A0okjNlmAVKxOlwjm3lZYrWG0L3?=
 =?us-ascii?Q?Rf/mG22ZyYn9Af/igdyvk/AG2m5SGrWMRvldsBpDkA78t8MwGeZTDFM1CNwh?=
 =?us-ascii?Q?zZcUQNqlHEKfPXmLcMbwZGoCvUMSX8X8xfYei0n0stJZwI9obs/hNsYKT6Ui?=
 =?us-ascii?Q?mUNHASjuIpLYauzGRyBncP8Ai62HZg07IxDJxlOC6fqh8P09N5T/HZBgltKH?=
 =?us-ascii?Q?q0mpbmCC7A43BTyCqXAXYoHou6EoZgRLpDZ+m+OOyZQWzNtpnu4rr8OyT9/7?=
 =?us-ascii?Q?dX/mvGPxPeJeI+tV2MFKMfkk+/2CFhgW9mnR+EJtQkqHU6viJ1ewcx2kzxl7?=
 =?us-ascii?Q?UWaeu/SPKqihifovjUwGry/BTU/wX+7UYW8AF9tqkEgQ6STA6NNdER4Norte?=
 =?us-ascii?Q?ceChNNJNfJ2X8uDiyMCpKb8cf7iRs//TnBmun1D6YoJSFRk3We8ug4gXVdPz?=
 =?us-ascii?Q?A2Eq?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:56.3791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: ee438216-99bc-43c5-9476-08d8a118c122
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1XyKmVQ9iIqoN/woLbC/EdI4Vz4OQJ+/6cMlBFeFaWgW8G/K2iyIm5prQIuWJqPhoDhMHuc362EYYCr8oAH8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using fwnode_get_id(), get the reg property value for DT node
and get the _ADR object value for ACPI node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/base/property.c  | 26 ++++++++++++++++++++++++++
 include/linux/property.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 4c43d30145c6..1c50e17ae879 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -580,6 +580,32 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
 	return fwnode_call_ptr_op(fwnode, get_name_prefix);
 }
 
+/**
+ * fwnode_get_id - Get the id of a fwnode.
+ * @fwnode: firmware node
+ * @id: id of the fwnode
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
+{
+	unsigned long long adr;
+	acpi_status status;
+
+	if (is_of_node(fwnode)) {
+		return of_property_read_u32(to_of_node(fwnode), "reg", id);
+	} else if (is_acpi_node(fwnode)) {
+		status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
+					       METHOD_NAME__ADR, NULL, &adr);
+		if (ACPI_FAILURE(status))
+			return -ENODATA;
+		*id = (u32)adr;
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(fwnode_get_id);
+
 /**
  * fwnode_get_parent - Return parent firwmare node
  * @fwnode: Firmware whose parent is retrieved
diff --git a/include/linux/property.h b/include/linux/property.h
index 2d4542629d80..92d405cf2b07 100644
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

