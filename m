Return-Path: <netdev+bounces-11457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB0D73329F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75DED281794
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D311ACAF;
	Fri, 16 Jun 2023 13:54:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0349A19E4D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:02 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4819430DE;
	Fri, 16 Jun 2023 06:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iy6BTKFlvN7Olzi4tm7TNBGYfv7DSyyesTz4PLnAWG6kk6qW6a4MPTkE4rsj6Zj6n9oR2lUlkAZdvdLvdR2Dq7FzG8iARWmqCoUEzi1CziTp5Dt2YwXQNywZyasuVkhhjMxcwPHHV4GY2W6EnzK1prlztzrdBYgZxhKs2LDVDnq283xiTZ9KqlfinMcuS3UEKQPsP9wuIs7xlyLm4kVtJinrwWGAylO7WizVHEueg7yY/Tt1slvAyRQpi8rnpi5Gic6TUt+gNLyD5Lg7OuEyifiwvfJDlOquEmGh7VfAIkjRzNpXaZWoafmb6KWSl4tnyjJsZ1iLn0Wz9QU5WFRTug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiDA3CpDczLzwzVraR5BrIV+k8SJqJNjJ7/cAvP9qug=;
 b=h+xrsZdTq8aJ6ma2Clx76TWPOOvoDS7EEnKgpB4tMh+iLnTth+a05Oz/zWlMWTfqQJ82OxzjEwGQJTns4+//GY+P+sch5agbZw1NezM6XWjlnd13mOy31Bnr5vKo/QjcByBV+Xfj2hdMaPAQlhVOdfGmQ1FErY5FtpTbHXZAAI8wAMNJE7hnmWDHe/hKWrGGs+34REsXKotSeSnGmZRJs4xqqtILY0InmNW5Wf08U1U82k5XLzMF4tispsS/mGfTQO87KZtDc6NXEgw4vRbj2S0Ox/nMlVG5ZlkVfdt3aGX2HXYZnR7Lx+Sk8GpkE1kUf7kf/u/hfcmJoXONC7Ez9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiDA3CpDczLzwzVraR5BrIV+k8SJqJNjJ7/cAvP9qug=;
 b=Ad0u+YOcctA9mQe9Oy/DxXKg5JLckfmW1ez3FOxvOlBuen5vk3C9ec9WxmQpH43MwOkNTcb1RTQLT0+Z4gziDDPEwQtIfIoR2D6quNeDYLvTuxbCIERmJX5nSDN/WaOM2fL2t0yyy4bqIrjlmJWy0OKFA9HlMsL7fxQW6qSuuak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:53:58 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:53:58 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 04/14] net: phy: nxp-c45-tja11xx: add *_reg_field functions
Date: Fri, 16 Jun 2023 16:53:13 +0300
Message-Id: <20230616135323.98215-5-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 5352f88d-50ef-4c3d-617b-08db6e7121d1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	saXtXsPpW5QbRV7WFE/NklhpwfKhSmgxneHPVh/q4fb4qob1zPaIAxjmXT7BPkaSNw+JNLPGQhLYSt9BqVczXtW0w25x6a+5qijb1mL44oxIj75ecLszszPnZGXWKDuvdggmUfUJ2tJzMaM1OvBPTu7wGO620+wpeTCDSdzCjV+9o2/wNe5CP5TzW7HHCqoPEoNFBncvfnhTd6mIaTcW1+CQ/jhFn1GDKo5+jiElvxAgN4eIHQ10oXuWCvxGAmG8/7w6UIw6ikrZY+DReXkHDbRv9sTVQ8A8h/S4U/wmnYDNprV3yP4sNXF1UaBPXPVxiI9VNGIgWhJ63hY3TLtpEcq7CBhsI7/OloMfc55eXJ5kFysw0QiD+OjHx7JJ91+eeJHP3uGSXOwTDiy7RjifOPCqnlOf2MoRXhlcTqQEe9RwYWoi/o0zMXR3KEbUaivi0Rse1nc8x3o9gQl8xZJWslUpPfrvZepch5/YXMeKApSN2lgalogV/fLNcQUDfv8N0yF31hpLAAYZLfQZJAVceTGC30FdHKxpoSz16z0YsGBewjTA0tV9uMGAffgzK1qkJrR4065rhd2VJgONKcr77HAz42d+p6vGFzUEmyXoY36QcW0/6wB8M3gImbOS0faA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2hyPy2U8BllvgILvp8DZPwrmXU8j8Y7OUQy87AUIocpY5CU8B8yAPL1Zg0mZ?=
 =?us-ascii?Q?PINJ+vpcgeo5vK8wy5Hr+VOHYXlgjQ3GcMjA2D6bFDQX1+9fo8uS6gSIfvtR?=
 =?us-ascii?Q?ISl2PrnyWSH40x7gnyG72HBrzFXMLf4Wjlb9uud7LgbCcYEK4EQu4xeBxbi1?=
 =?us-ascii?Q?bCr22RmfBaeQCgcZOhWrCqSmPSAoe5ZMzl5IUokEnH5l4fzxcMq864xKYtmK?=
 =?us-ascii?Q?BEaD8mgDSf02qZHuykNUe92diXjDhKc+THcIewnjVhAbTUZiTp4S6xPo0lIb?=
 =?us-ascii?Q?Ns2E8z/PVhx8mCO0Zxl7YtHzqcOSiCWFyj2Q12i9h+EWSgihJeVy5kPDm70x?=
 =?us-ascii?Q?V7J3pVYaqQOEdN6jGBh2yZ7V4TCGUP9TA7x9eMv3gzWVviO5yOUJPLokw39V?=
 =?us-ascii?Q?lP+XHggiTJMGKD0HDrq9DsTUXLsk28E6XteblTRRiPecZ2bIYNervMrZR7H9?=
 =?us-ascii?Q?9cVz5HWrhupVi6fhxiVjIFeAYaNWteVrW2l1h+X20LTD2ACMQlL1JShGrCg5?=
 =?us-ascii?Q?Uby89xDlrJ2OFS2V7oUnVTi0R+nShVOwgj57mJTvsCNl7e+wcK0r7YuI7TuR?=
 =?us-ascii?Q?UzWQkEo8dMehvxllyH4LFTmw13jehMOR2XhiICk/02sgJ0y37A2U7kG2q9mM?=
 =?us-ascii?Q?rzkvV6DXXtfqoRJmSg1Ta44BMnAXhb7Emq0ZUVbY5nJWI0EDdZUEeX048VKM?=
 =?us-ascii?Q?rXBMKLI2V4X0rvVm+RDuz/RqMZEYeAG9SW6obd0BcPAXl2hu1BDpRAkem+Jq?=
 =?us-ascii?Q?ta4DwxqBTy0kKviZFoj0N0DgnU+rGVArQCU7stEPEu2cIMT6d//oZpGV726E?=
 =?us-ascii?Q?r5ZzphLv5C4+0Q7Ajx16UNf+yk06HhunTWdtZjN/wVAbXc6MycnXUgAUTknD?=
 =?us-ascii?Q?PYmAkPHtosXOvV/DxZKcrBQa/kk9Xnpr+pNjv3yWclI3iTkmV2zKMViYNTpr?=
 =?us-ascii?Q?+18I3CEul/LRDSxZoEEXK2Pv6tTFoXooIgpGpNKN726p8MsjzO3Uc5W9curh?=
 =?us-ascii?Q?D8VoMdqe/r9qV5WMOCUDHWoNl1efECcJllaxDzc4zdAqWWV9Dn5D5yuQNVG3?=
 =?us-ascii?Q?dxUBIqxQwjccsEzefGirO1KRhtuVcma+80QVvIPSFEwKaRc4w/wm7IRzc12k?=
 =?us-ascii?Q?8tFOtARRCvReeI1RKVR+S9G+Inny9qhK2bBbAbRziAMQ24rboNVxiDQxV3TV?=
 =?us-ascii?Q?i1nm5LRlqIVTq+nGjLM6hZIguSgjspmn/FRDerP9ZPPlOc3/u9TMpisKINx3?=
 =?us-ascii?Q?ROKgUt5Wnd8eslQ4HnULiA6Ax8bOnd18PJa6YttFeBnPTa1o21nP69L9fM6H?=
 =?us-ascii?Q?jpuZ6kr3e3IQU0sTQoQEtaIuee//ESHHf+bHaG42WIgDJumu42qbAjQn/wiW?=
 =?us-ascii?Q?y/oCxPebwzQ8947KUkEbEq8k6OguydHPx+ye9NJqsrLgYtPLPMIK1Z6pd+PT?=
 =?us-ascii?Q?6IifsdLwG6PLla5JW1KktBj9J0ADnDsBNqLsjpgs5g4iDywqwdCGIkLrHesG?=
 =?us-ascii?Q?WfIMcTxP05Vs/RTNgP3OIM8mY7ZHIOA06NwGgIZ9e9zkIi1sLk+8pzuZ+0lt?=
 =?us-ascii?Q?LfMeUPsACQRCFY9mmk2Y7RKgQQJuKAVkygvEhvYcfruVi/lYwqBwfiqnDPwj?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5352f88d-50ef-4c3d-617b-08db6e7121d1
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:53:58.2594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQWUfKRNP7XT6LJItUyfRIep23mkmjsGseukTNcQQpYtZnCji9ANuovRgleh15kLffZ45peERzvjXp9QGl2fXwDrcQwRy+SW01hwWF9Jwag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Between TJA1120 and TJA1103 the hardware was improved, but some register
addresses were changed and some bit fields were moved from one register
to another.

To integrate more PHYs in the same driver with the same register fields,
but these register fields located in different registers at
different offsets, I introduced the nxp_c45_reg_field structure.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 78 +++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index e39f0b46e934..a1dc888000b4 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -194,6 +194,21 @@ struct nxp_c45_skb_cb {
 	unsigned int type;
 };
 
+#define NXP_C45_REG_FIELD(_reg, _devad, _offset, _size)	\
+	((struct nxp_c45_reg_field) {			\
+		.reg = _reg,				\
+		.devad =  _devad,			\
+		.offset = _offset,			\
+		.size = _size,				\
+	})
+
+struct nxp_c45_reg_field {
+	u16 reg;
+	u8 devad;
+	u8 offset;
+	u8 size;
+};
+
 struct nxp_c45_hwts {
 	u32	nsec;
 	u32	sec;
@@ -228,6 +243,69 @@ struct nxp_c45_phy_stats {
 	u16		mask;
 };
 
+static int nxp_c45_read_reg_field(struct phy_device *phydev,
+				  const struct nxp_c45_reg_field *reg_field)
+{
+	u16 mask;
+	int ret;
+
+	if (reg_field->size == 0) {
+		phydev_warn(phydev, "Trying to read a reg field of size 0.");
+		return -EINVAL;
+	}
+
+	ret = phy_read_mmd(phydev, reg_field->devad, reg_field->reg);
+	if (ret < 0)
+		return ret;
+
+	mask = reg_field->size == 1 ? BIT(reg_field->offset) :
+		GENMASK(reg_field->offset + reg_field->size - 1,
+			reg_field->offset);
+	ret &= mask;
+	ret >>= reg_field->offset;
+
+	return ret;
+}
+
+static int nxp_c45_write_reg_field(struct phy_device *phydev,
+				   const struct nxp_c45_reg_field *reg_field,
+				   u16 val)
+{
+	u16 mask;
+	u16 set;
+
+	if (reg_field->size == 0) {
+		phydev_warn(phydev, "Trying to write a reg field of size 0.");
+		return -EINVAL;
+	}
+
+	mask = reg_field->size == 1 ? BIT(reg_field->offset) :
+		GENMASK(reg_field->offset + reg_field->size - 1,
+			reg_field->offset);
+	set = val << reg_field->offset;
+
+	return phy_modify_mmd_changed(phydev, reg_field->devad,
+				      reg_field->reg, mask, set);
+}
+
+static int nxp_c45_set_reg_field(struct phy_device *phydev,
+				 const struct nxp_c45_reg_field *reg_field)
+{
+	if (reg_field->size != 1)
+		return -EINVAL;
+
+	return nxp_c45_write_reg_field(phydev, reg_field, 1);
+}
+
+static int nxp_c45_clear_reg_field(struct phy_device *phydev,
+				   const struct nxp_c45_reg_field *reg_field)
+{
+	if (reg_field->size != 1)
+		return -EINVAL;
+
+	return nxp_c45_write_reg_field(phydev, reg_field, 0);
+}
+
 static bool nxp_c45_poll_txts(struct phy_device *phydev)
 {
 	return phydev->irq <= 0;
-- 
2.34.1


