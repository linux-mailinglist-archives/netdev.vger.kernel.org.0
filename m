Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B916231E5AE
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhBRFfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBRFaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:30:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06A2C061756;
        Wed, 17 Feb 2021 21:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/hv8h9ywtSZRtIJjlCaLL4nHO8ljFbGGoCBvHskHq4i6yL01uEd2LxROfAXUcPkKsEWLyQt21VfoNLTusfOdBlBKwo1RJ6zwTqSqy6a14PpFVvO+2WoSPFbZE7jJFmgpRabOYMyghcl43hcqI9OwERr7cm+LXgeFRlb34NOxq42vnM4cOXnVHFEcloXkCYXbFPsmpfOZygm4jlP1z8wCG5U7hHC3mtZ/cVgtKBE3BlAiAYBzXHqymPJd8bQTTNJV6pcwRE1NA4fXHYJCQjlhE35SXVPXbarvRx3ly4SeDb0Y8qSfcqWFnN1r7rsc/Bn7dux+C7dJTxVRxa/kufC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VxMVISQ/LMSiAcmhaO1GSPoe7eKo42+tIOb5vDny4g=;
 b=hVUIkFqeo4kZhCqCrF3lsHax3HwE1ZSH3fJV5LvbBCAdlIElQrCLA8/FuDo+am5ZPvShM5XTmvYZAmxJBlADrrd3uk6XSasdKNhXMM/r6cXzJ1i0O4xAdgFLKUzRodq4cHkDbokpKua2rjahLOWX0zeniJ9jD3FlWgpG+Gnhy0JYZflr+PwrySazAB2NERaSBgnAky99K8bmXTH4FaOOxRnzLRj7RP8a8zYWvWeyX7crn1DZk8cemLp0eNkmsq4Yb8gs2Z5iS23zZczCE+MuCq2AxhbwMUXN0NrlryCt3rfhHA7Bylu9UnE1g4snmNK9H9S9ZBPIqZufeqrKCtSfOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VxMVISQ/LMSiAcmhaO1GSPoe7eKo42+tIOb5vDny4g=;
 b=ACjNiVQEC9mvzGV7JDWwUHXfmtO1PHkwpdPqGTvkQ8+4w4kPhzgGkXXeHigfHqUKvTLeJG2sA7a9BqHBiJEjGOJNFUNKfpAnRm7bCvoj1P4eDc4FeJSZwFq4/jTd/26skkITTZEvUJvT3J5VEOU3/BPTjQpOiP1iVii1rUts9J0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:28 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:28 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v6 09/15] ACPI: utils: Introduce acpi_get_local_address()
Date:   Thu, 18 Feb 2021 10:56:48 +0530
Message-Id: <20210218052654.28995-10-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d50f793-05c5-45b4-2cf0-08d8d3ce05a8
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730B82EBF50EA48EB601BE2D2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TESp2T3F0MVkINs9U9Li/k9Fl7zQ7iIjhHZ4pNXEighiBDHkTlWwiB+lQsP5kHcWl2JF3sMuUkq8uO79Hb817iHLKFKbZZlWoB99bMnKLOitKMFA0XHNxVm+c/9osbqP6Ds+QDD044ygmSsjCThL84fA1vS7IJwoynDFRDMT8VOACJJJ/gbtq+0LmC0If0oID0hYileysWOq1eKWH8tva4N9d2rrqCbwZoH6DGJF1VBJhenoDzSHImZIJv7BiSwR4hmh4yqpbenp9xRC8wKPAq7sYbotHBfti8uFzObqseVGRakXxyuHhTytZm96wiXD3MDolM0tEK8e8JKt1oH6L4s7G5ksjMdD7RQc8Ga5dOhBF8ozxaCRpjeLrExR3e5B/U+S/lfnQIVm6/8LC5tccYxp1T7/KidXGczXW1jNRJMi4Dua4TBjcnfNnjcKodPaBDEaWisfxxFFnQD5StOGZZYrSrnqsFTU40pPwj92w2UcbT7+mfk1A8cHMsrSt3E42Ey1WHfglNvP7e1MkTXdumpI9CZYgWBHtTsHrQp2tQ+U+ggJY/XyqSPzvJtTuEA6y3iS+hD0K0fo+2PAaPpKXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GTw88VGF2dEYbYoW9EuanTRdDZDyAIJeJiELgChZrfnTPE0MvXz19cYSegxY?=
 =?us-ascii?Q?MhZnqYBbfo28Ier2vv+7KPEzCyIMT7Z8lJdyb7KmWgPskYlCxYOfNdimSR1J?=
 =?us-ascii?Q?VeEq5NVvjlk+MFfEHBON8QtLCpEiSMViK1WZATYgQzVBw1gN3mJGphcjMV30?=
 =?us-ascii?Q?lc0hDa4Dd0+IWfDJlkjtNYF2PpN73DudOxp+gvVBElcC61fpcCeA8p+0MNZv?=
 =?us-ascii?Q?cRbM27oxI2w18ejH6c6m6Gm1HmYM3EWesKuBAvtmb9XDn+rkDp46wwe2l/nX?=
 =?us-ascii?Q?5FegJrwXIk/nFDo84NOoH9DYaKjc5frf1c/YVkjCcpEkeffWVTcNoa/CCe1/?=
 =?us-ascii?Q?c6CEDZP6fDEV9ou7TPrV80S5outF1dyxJHr9CGdwkYYeSq7BOVrDM9GGswZ/?=
 =?us-ascii?Q?8/2i614/VMv9A+1/uQ3WakAJ1XqKiCHwBrbc59fVVovv57mzXCRmxvEI+OAN?=
 =?us-ascii?Q?p1pOM/YGhwidLdMfrAjtawbYMOASs7AFO/zJqn+4zLbMkyBrpqbPzKNSeDTf?=
 =?us-ascii?Q?EaRhxgqDpQVa6fr39aBvRuwjn6GSlRI+L25lTi1IRt7EAjD7BuXcDnIUW4s8?=
 =?us-ascii?Q?7PVAB7+Ffbcra9SS7HL0YJlFIF+78kir5MovprwnR+lzDAMenW121+ZnDhC6?=
 =?us-ascii?Q?phWuo8ul9N7xnMiPcRpLqIu0mSpgV1qJCTMCqQ7/WeGV//v355XmqkNB8Y/3?=
 =?us-ascii?Q?QKxCQGn8HHOfPkJNRNtpYxe9XNcrabJWo8DU8fMuNYVnyRLX0HTlqczCGcs5?=
 =?us-ascii?Q?XyaBGPZ6dPN0mFTutbN5WdC2Q71HZFYlWancATbUlxpooUKMnUso/oba9RHq?=
 =?us-ascii?Q?yaBRACJxKyZiAO7enW9mL/NbJhTPj3YBCnMUeN6ibQZLstdz9uo1GhXOxfUu?=
 =?us-ascii?Q?iJT9lITwUwRwx8vbMP1+1NtMSPIxjIzQYzP+F+p5SJj7dFxezwWHf5pjotLA?=
 =?us-ascii?Q?2YCfNpPqgn2Hk3VKPS+uM/T20IPZgn8gZBmMOpgAcn03ZHRhmRb20NrPkHJU?=
 =?us-ascii?Q?gLmhY6hXfHLGb3cbz2Bwnhhtn+NgA0ASr9O0Q8+P3ljkqElI8shyE7ifyf1t?=
 =?us-ascii?Q?04aYYrmL5Wv4W0JVWCKiEy7T0y54QKcAFM4v//bpLoycjqRgrijtCzEmXVv0?=
 =?us-ascii?Q?wE4rvlYQ1GY9l/ZsslSzNBpNMBCkZcvZ9bfgacR0VPSdl1TQXv1AHEuAoufI?=
 =?us-ascii?Q?9QIrroepM2nWk1324Gx8IjxHAJ69e03obIAtQRfDiCJ3ekBexsARZHDa/Loi?=
 =?us-ascii?Q?3/eBXqUTQ1EfJll+8J4Swynir8pXX+9fOZ1R8Tm2IcDGEQRqtfDP409OVMcZ?=
 =?us-ascii?Q?TR+W9jQEEyyB6SmwK4GplFIj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d50f793-05c5-45b4-2cf0-08d8d3ce05a8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:28.7494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rFrsesNzaNrFjSD3Ttz0DP82X3ExJfvXpb7cPKD8+gzWUQSEL9IV4Rv3JfoBl7DVkRSlvFSm85LsBi1Z4kkWpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a wrapper around the _ADR evaluation.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

