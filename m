Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A250C425846
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhJGQrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:47:43 -0400
Received: from mail-eopbgr60131.outbound.protection.outlook.com ([40.107.6.131]:13030
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233522AbhJGQrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:47:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tr3L9wiEySDXs/E5ue045Me+fkKHkCXnYkcGQgXjFoyS64e8QbCoYFiJLhTxQviapLN6Bec6Jwg7Lxd3wuZHPEDUebrpjAiXPgwP/NnNseQdcWCz4sEIxyhML5rUz24dvzR0v8uIasn7cMuNBSK3sfCOeGeJroqwNUU32t8NPc2CampH7yfa878xFKWcpiXLlxPJhvxHoaOpuyxbnQIXKAmJgmm2D04xppS65o0/ZM69BfSxWZbVoe3o+IlLdbk1+BeX12Wjl8ZymKAkRACU4ZHd4+L+scENH5o5XuoIa9vA5qzepAkYL7suPOwS+DIebjcGXt4J1BXIOrJy9coKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwG6ymB2R5VcB6j2G1xfqVCOQOv0QTOGcE0fGclZtZU=;
 b=IfRWXrn2uLv38iTsexrmihUkOj6f0xY7Q4vRgNNOmq80nrFGJDkdQdokdo56wfwe0f8/+7CM3QmIU8WwjjTVRMtBmYMh5wcIJAnAhdqvimC/fo2MTzwYIjfJOu7H14rwB0Se9h/mAhfUgleMDDpVOzDwf2eDPEJ49mDg1aHkhXBynqOyswka/vF+c0x2JGQuPnbxaFjlZp9YQ7bQQBa3lKeW6gwBfTZkw+xS11+NVQjM8a9Y4pTMTMRZ5L5B3hA4S9AtWoqDX8KmhuSj8+23/8SmYmzmgo/tF8sIl7GV2o8iqymPlu9N2l/0xkDk+CjwYWViTbUTuGt3TjOjgUIaYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwG6ymB2R5VcB6j2G1xfqVCOQOv0QTOGcE0fGclZtZU=;
 b=mq2AJ+/TgUTXmiIeGpd5HzqsYiC6LMnUHEKT4LEpVfEqc7HQkSzwsg5RXC4fLltxuAznbnlVvtuZ1fPwp3secnjWwB5JVb/5wqP46yQH2ogN/OJokIv4reVW+4NRHSZlrGTl0Msthl1p3oTYH5xMjIk9J7hrXg5gwQnvSvMpW0w=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=toradex.com;
Received: from HE1PR0501MB2602.eurprd05.prod.outlook.com (2603:10a6:3:6d::13)
 by HE1PR0501MB2172.eurprd05.prod.outlook.com (2603:10a6:3:26::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 16:45:44 +0000
Received: from HE1PR0501MB2602.eurprd05.prod.outlook.com
 ([fe80::8463:d3:5cb2:152c]) by HE1PR0501MB2602.eurprd05.prod.outlook.com
 ([fe80::8463:d3:5cb2:152c%4]) with mapi id 15.20.4566.022; Thu, 7 Oct 2021
 16:45:44 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     philippe.schenker@toradex.com,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: phy: micrel: ksz9131 led errata workaround
Date:   Thu,  7 Oct 2021 18:45:35 +0200
Message-Id: <20211007164535.657245-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV0P278CA0075.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2b::8) To HE1PR0501MB2602.eurprd05.prod.outlook.com
 (2603:10a6:3:6d::13)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GV0P278CA0075.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 16:45:44 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id 0EA9E10A3889; Thu,  7 Oct 2021 18:45:41 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 872313dc-17b4-4dd2-391a-08d989b1e7d1
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2172:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB21721D7AD58A435342FB24D0E2B19@HE1PR0501MB2172.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jem2m5fhizOYO+uU3oKl85QcNMIdWrwWHmJRcPGdyI7cAGXT2YIiOsgLjDYw/Xsfdu5dWq2F6Jsv+TrtPMr5BnI9KI532UslODU3kU9Yu9IJivTz+GuIEki+idE0tmnzOYfwcavspG0PDfO62Mlk1zYxcdOQ9Mx/cqaroGg51dkhChG7/f9/4EsfG55m4LHhjQgt3D/eOguBVRsrdyhlos2mCI1KyaV1nDuaWsLw5OcFGf2jVR89mRyZkbCLa2zfmDC1ISXHNknKyvsaZzbfnyurf19EQlX0j+OIhELSgjvxaXNOoVQdcxTg9ifD+NIxzACqPqgAYdYhy4UtSKPsWO9Enoqw4+nPA1iXuMp3xBIAZ1uuYEo1EOTgEenZ7m0Ay1BAeoQLJchK5XSsEIRND07HvRRFIMX7pnmEdj5A+Joj5XZIlUDMVupjgdVsZ6Z15OKVXwtwfWuolMWNKNANwuj7M+bwYcMVaUWOWmuwCYek1C/PfTiXW4h8VtfxzPZ0SlOMdG0lUH7h0lSspCf2nt0R2z/QVhwLyu61IxRZIW4KMINunJWpQnHe5CCTS2Sl4FEsJIb3ef4EkF30yu0sCiOIuHngAHL+CU/RYxo0qIMmL13eIyx7/AH4bhshA2KvVJJAKGKAZJFoSZU0yvS85ZoalLxZlAld037Gc2Ej6lYPFLAex7Agr5cX8eB0uPsT2CQ0MRYtrWy0Kt6XQ5Mjconh/N42rGyiKsxoBYmuqlz/0qYXe3TbRCkvkHHjAvxbjNvl8FxkIOGWNJETtdJFFTTK0roDrnOB9ECK+XaIHKg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2602.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39850400004)(396003)(136003)(8676002)(66946007)(66556008)(966005)(8936002)(186003)(66476007)(6266002)(26005)(5660300002)(36756003)(4326008)(44832011)(110136005)(52116002)(316002)(86362001)(38350700002)(2616005)(83380400001)(38100700002)(2906002)(1076003)(6666004)(508600001)(42186006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f5iZyCSbx3Ie0NFQ8OATq8k6UxlspPIS0zydTNE/4aUR+IXEdCm8yR5Tvx4m?=
 =?us-ascii?Q?vMsyBSzPTmm9HEswrDllv51dm/XfzVM+aI1pAHxuE5D/Sw77K7IPbG0hu98L?=
 =?us-ascii?Q?95kg4SLaSB4SPF3ABmcZFjS9dltAOItE3BX77c5cAgyjHYCe/ads/ITH34r6?=
 =?us-ascii?Q?kFa/Ke21A2069YS0fIbFMYWoOr7twEbQxzW0Ivkpg/v+svq2RDKzVTS7gAs9?=
 =?us-ascii?Q?rIGSdDs6Ju8BDYar7u0Wja6SHWXPTwHPAV4RyOC3xN8WI6WwaDu6sC/HS9QI?=
 =?us-ascii?Q?NnXmv2KRc9q3vNldZENwiz802PCc/texGOERBzAvSpHxuJ/hnWy3dN84rBV2?=
 =?us-ascii?Q?/oN+3ae7R2lzk4Lxx/wp9cCgEQzdzKpiBBC0ip5mCohollwghFPUX7VIsDRd?=
 =?us-ascii?Q?mhNDoZDskxgbhwUfH3IDvMsNkDDiqfIIabDwGQMCYq8prysuI7TyfMdmWZx2?=
 =?us-ascii?Q?uembR/5K/41tbzpmT7U0UJyXKdJOEaxZBn9+HBcnJq4vMNe9LHNX1rVXqM3Z?=
 =?us-ascii?Q?BWTmkmxgAj/wHXnALUXsPr/SKgP3Nhp5EXEcMhhOIO3Uh4dJ+Do74oHhazbY?=
 =?us-ascii?Q?fZFZlS5Iv23cRo6eIrC3kUQI67EiEnBqhJH1YMcUvErLgFBsqj63eeCh89AH?=
 =?us-ascii?Q?RMqckN4/tPbXYsU8mv+iRTmnPDPqA5e71zfkBQNwDUQaPViY9Jtcxc06xtTm?=
 =?us-ascii?Q?OxebgkXcTF/TBbyWBTV8xyiGDQ7SFBpglEpbJD+MTS2/8hpNYfp/DxPl4Ltz?=
 =?us-ascii?Q?dvutwlv1dLx2Rd1RNv1aW4xqDXzUu3o5FVI6CnIC75apGcS4xNLvFmmiOHXI?=
 =?us-ascii?Q?I4cGmC/Ho/bvjRXZ098A7atYKbLl07la0LbbS9FdUwQ0SMpbL1zj5lQ1/Jmt?=
 =?us-ascii?Q?/p8WlL2Tpaj2f/eW425mB9vbvNa86wxmf66Z96lgUOsYQyfASmcaAo4+svDH?=
 =?us-ascii?Q?2grqgrScnH+ZClvG+1dmjDPUWdHVf1YoVuCk43DCHXrAp+9+Y+EqzAWZngSo?=
 =?us-ascii?Q?/y3ynvOPJI/rTlAc297YouY2hsHR1lj3POlFvVcWf/w7CzQwWP95sn1fyeR8?=
 =?us-ascii?Q?XfnyRN1Lw3UWbJGfPXj9vj2Brxjw3RMbKbBN/9xkNyPaMGmqYrRsP7YpcKTb?=
 =?us-ascii?Q?wySusCNY0wrLW41u4bTg4nY2YCnN8IUzPGIJys24lyjgzD0/EcsvZfZz9IPw?=
 =?us-ascii?Q?Oz9v7hnM5K4TY5MAkz5r1tOeV6Su77QDeaY0vSOhTAYKlzXaa7WbfoEsI2r9?=
 =?us-ascii?Q?WQqn/g0Ku2txrQP/Nhn+Y+k1U+5EJOwFOwIXIVBdtmhT2I+EMimWlquk65PN?=
 =?us-ascii?Q?nlnGLtgOTPhSCIXwHXIYUemX?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872313dc-17b4-4dd2-391a-08d989b1e7d1
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0501MB2602.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 16:45:44.2410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOVqJfJ0pPdMSW8OJwsxr3wHYc2N77pM+gLBTyFfXYGUZeX62YJ0hRNcayYMbQRwGG9mpYVr5YSYSQc+INZ2W8vVK+9ocYSCL4NuWU+WW1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Micrel KSZ9131 PHY LED behavior is not correct when configured in
Individual Mode, LED1 (Activity LED) is in the ON state when there is
no-link.

Workaround this by setting bit 9 of register 0x1e after verifying that
the LED configuration is Individual Mode.

This issue is described in KSZ9131RNX Silicon Errata DS80000693B [*]
and according to that it will not be corrected in a future silicon
revision.

[*] https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9131RNX-Silicon-Errata-and-Data-Sheet-Clarification-80000863B.pdf

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
Changes v1 => v2:
 1. corrected errata URL in commit message
 2. check phy_read_mmd return value
---
 drivers/net/phy/micrel.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c330a5a9f665..b70f62efdbc3 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1003,6 +1003,26 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
 			      txcdll_val);
 }
 
+/* Silicon Errata DS80000693B
+ *
+ * When LEDs are configured in Individual Mode, LED1 is ON in a no-link
+ * condition. Workaround is to set register 0x1e, bit 9, this way LED1 behaves
+ * according to the datasheet (off if there is no link).
+ */
+static int ksz9131_led_errata(struct phy_device *phydev)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, 2, 0);
+	if (reg < 0)
+		return reg;
+
+	if (!(reg & BIT(4)))
+		return 0;
+
+	return phy_set_bits(phydev, 0x1e, BIT(9));
+}
+
 static int ksz9131_config_init(struct phy_device *phydev)
 {
 	struct device_node *of_node;
@@ -1058,6 +1078,10 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = ksz9131_led_errata(phydev);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
-- 
2.25.1

