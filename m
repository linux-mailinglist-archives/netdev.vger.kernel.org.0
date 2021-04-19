Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD10363A80
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhDSE2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:28:42 -0400
Received: from mail-eopbgr00070.outbound.protection.outlook.com ([40.107.0.70]:20778
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229473AbhDSE2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 00:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXXFwOY/rlNT4p1jhFUOhJky1xHuIRZMvCNVXNXrAOe4VFd3C3+56vlIolGhArdM2oszwNHr60xkueVbPqLDkXlPtO7kp9Uod7t7hJo8O7MNm929TuplsYs43/BS0sjFkse7wkWGGjQGLxLNlww6ZlC2859uLtPsLg8c/gvAzh7gomSiFBYVCUsRe1CsmbgJqZGtUJrf9pKcSbcR2XtDKEXXAOXlSSCgw1UoiLmxXaRxNk1SftuJ/ziNCnAIGV/JuEdIccNy9SFp932Q1fr5JTYBIfNoEgHhWW896fBUbtn/VznVdRY+m9vuG8IWNa5dWHtNCaSPMXRvFMt3DM43Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPjdrYOfp1UGz4OaxgoFghdIEDabpUoX/M2zEl/L2GY=;
 b=J3gWvKaSKbDJMRJQ9VFy53FwmUMTBmWOT8zD5CXi884MhO0okDwCIq91uOpLVGtFqy8Of+5a1gKcnSjmnSYkjWbnAHnzW5svMg19IZROae+u+qpgRKsmoPV1hxhVhMUwGVqR4509mFdz0M9Ms4ApNnVmm2m45rQEKP4aZjRRBPITwgGQAstqz8AvbxaUqchKQxz/QVfQdTHTyDq/BqfWQALLXw+VBlEg4EZU7Bhrl95qBm9Tnwu0nlruiQo58gzWxVakkLhqdst3y6DoGkWa1dcyYTsbU5T0fx6OoDODEWRBRo0aHXpPVxLLMzIdWabeJJMimsH2Jpr2t5Mco9QOsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPjdrYOfp1UGz4OaxgoFghdIEDabpUoX/M2zEl/L2GY=;
 b=in0oSw8cbm2R56qHe2FTITXGEzl0j2h7bMXFrrB9ze9a4RZtLB99HPQ4dZzR9r2M+cuLty/4dI3+kgpeHBkb6uCfwkczOiHdvFAN4scpU8Uq84Tlr3bSWlzHEjew7i6SJvsidHLYcHIKBQLDc6Zfpj/TArstYrk3+SHiHjHzZkk=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AS8PR04MB7912.eurprd04.prod.outlook.com (2603:10a6:20b:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 04:28:06 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 04:28:06 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
        geert+renesas@glider.be, mturquette@baylibre.com, sboyd@kernel.org,
        vkoul@kernel.org, peter.ujfalusi@gmail.com, a.hajda@samsung.com,
        narmstrong@baylibre.com, robert.foss@linaro.org, airlied@linux.ie,
        daniel@ffwll.ch, khilman@baylibre.com, tomba@kernel.org,
        jyri.sarha@iki.fi, joro@8bytes.org, will@kernel.org,
        mchehab@kernel.org, ulf.hansson@linaro.org,
        adrian.hunter@intel.com, kishon@ti.com, kuba@kernel.org,
        linus.walleij@linaro.org, Roy.Pledge@nxp.com, leoyang.li@nxp.com,
        ssantosh@kernel.org, matthias.bgg@gmail.com, edubezval@gmail.com,
        j-keerthy@ti.com, balbi@kernel.org, linux@prisktech.co.nz,
        stern@rowland.harvard.edu, wim@linux-watchdog.org,
        linux@roeck-us.net
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-clk@vger.kernel.org, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-staging@lists.linux.dev,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [RFC v1 PATCH 1/3] drivers: soc: add support for soc_device_match returning -EPROBE_DEFER
Date:   Mon, 19 Apr 2021 12:27:20 +0800
Message-Id: <20210419042722.27554-2-alice.guo@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210419042722.27554-1-alice.guo@oss.nxp.com>
References: <20210419042722.27554-1-alice.guo@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: AM0PR02CA0207.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::14) To AM6PR04MB6053.eurprd04.prod.outlook.com
 (2603:10a6:20b:b9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nxf55104-OptiPlex-7060.ap.freescale.net (119.31.174.71) by AM0PR02CA0207.eurprd02.prod.outlook.com (2603:10a6:20b:28f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Mon, 19 Apr 2021 04:27:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7904f4b3-4df0-4958-4548-08d902eb873e
X-MS-TrafficTypeDiagnostic: AS8PR04MB7912:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR04MB7912B462F7DFBBA52CF9E75EA3499@AS8PR04MB7912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4S/VmwrXlIPA7UsMJE49KbJ7lfySyO+ISp3bix+pefUoOZNcOEN1uTXPCQTqfE9mrlFI0/8DiZ4ET5uThZEcVv1FxSJkEJezj4ch8iXMLpXNp38f7aP1YAHz+cXyur4/8vvk6YGUK5/0YCS6j7ghB/w4iAi0V/PbkajRKrZBkmjvqoCXiVC1PmI/gf4pQdQNpp9Q2pV8d06KMxUcNJSUc4wg1V8xp9qeyUw8Oq8EyhaF1BgdHpNVRabdGJZZivZENV7EMUApW2K4Bd+63zFBgCLLNIIzgAZmH4LiAxEP2LnsGO8R5p9AAf1KvLglMcIo81mgUtFOaP3Fx35c9/tcdACtoHfN8SI41EDbOfn/9b1LR1nSs3IWT+/wvtXgf3YxYaDx2vf7k/xoc2xeY/seV0RlOgRGCj90uBpKa1h+3ObuYjJeEES/AuaJKrTppM8OgdB+x64Q8U4c915bRGMcPYbjqrLIygPU12awepsPxxxT7RWgeP63+p3QaI8BQmHVCfadsI8hTL+pnY9tefHu8OhBLYJEcvrDfRgeSMfmZFKOuFqfAEGQtvm5ZpNW5TJqXqNZvMJKLm0K/+fVhmjuE0dP8fCFXV1lkKBx67aC4ScwHHCAM+K2zUgo4/SGqUYVLKFmf5sH0ZSDkJkIW0yVw/olW7wGr9qCnuIx1sYHJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(1076003)(66946007)(7406005)(478600001)(52116002)(66556008)(66476007)(2906002)(7366002)(7416002)(8936002)(921005)(8676002)(4326008)(5660300002)(16526019)(26005)(38100700002)(956004)(2616005)(38350700002)(6486002)(6666004)(6506007)(6512007)(186003)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FLRt8FkFd13bd5f5A/n0HQoRwBhHItKKYXkrFrGd7bHA3Jcd91EI0madXuB2?=
 =?us-ascii?Q?1PMEuwfZLvhoWiLiUY4IUwkUW5PIpldX5eWKOeQi6L4kKWCsdNL9Rmm7RlQB?=
 =?us-ascii?Q?h7wDAamBMqRQfYSxrVb0nEmNPxPiQlXhM81mgtjxI46jXT8oMsWmzUOUf6bS?=
 =?us-ascii?Q?/6SaZrKu5EUP8jkwouY+nWMuZmClL3g9oQDdO1yBOcXt+pSp7s2YKYXipiTw?=
 =?us-ascii?Q?cAxrguqlIeUE73pSdw0tfM/6vly8sDmT+B0byfAD7GUF1CMdTe9MEGb3MO7l?=
 =?us-ascii?Q?txpjt20pFz0mks53ymXxhnEM92SZtkjWZ38EZcx93ll3d5uVjo+yGcamAu6+?=
 =?us-ascii?Q?wLEQyPkh9jjnX/a45ytzfj20m3f4JDYAJob0rUxSAebcG5prgiABK9+CCcRq?=
 =?us-ascii?Q?4DGT5KUofBRUEHMV/dqwq+ZHNXJVFgb5PNzDuyoC2939+POlN7v4H2OUhEL7?=
 =?us-ascii?Q?GxkQWoJC7AnjfZPu9pgAWiMzXhhYFKk99JasVHdJLqZBe+OLGjjG0b1IvPre?=
 =?us-ascii?Q?fURFpobMv33uzajO6pgnCj/oEIOm87x8oci2wGF0cd3vCkxIGlSH5+rCEVzz?=
 =?us-ascii?Q?zGz9nHZdJlCY8ei+pU4dzXM+g6HRl4RCx+tl51dbREtn8QoRjonYjbzq9oJa?=
 =?us-ascii?Q?39fEfzZf+u7aWuhQouHvA2GyvOhm6GF64rI+iANHepIl6H1W9wNiky06Rzq8?=
 =?us-ascii?Q?B0bDyMl0pO4j7oam3us4Vhp+EUFroVn011cFnaymhcCP+ObevVGMlr1iBNRw?=
 =?us-ascii?Q?Pc5df6jvi/EBzi3sh/LQirjlNcfPtTm82khNYAsHGQ2D3FLcxhHOVmfaifW4?=
 =?us-ascii?Q?1aTKaB6rt/1igwegzJW89yn5U+VIO8+Wuoez/TC2vOa/T5I/jspnGbYD+hJV?=
 =?us-ascii?Q?QDeBelluz2Uoq7aNfh+83nDg8JX48QJbJlOc/tFcxQAHYVxPGqkkWINBTRok?=
 =?us-ascii?Q?bIlhzaiaXWp8ggL9OTXF8mhVgeGPmzIGdIchwPvUN+pFSRXowd4kCvdxfXck?=
 =?us-ascii?Q?6jSvRNVEVpMgr9QPk8kTggdWUBfuzMLjJAwNqiajnBxPyFn9cJJJkmDE81FL?=
 =?us-ascii?Q?V/zg2lIdD2t02akg8nTjWFAs+YEYEGc0JbfLje3gdztd/VQ7wnBz43BAZMQL?=
 =?us-ascii?Q?8vneYWRumLzgalV3nBTtcQSL2qmVOfSmfRaZLZctNmfR20OVL//3lDP/y+RW?=
 =?us-ascii?Q?jtFs6I9Gd4piFHjXr30es5pN0MEfDJ9LvQETu1fghRJX70i0J1Q5oJ0Hvq6F?=
 =?us-ascii?Q?3DvKGF6PwFM8YIrQUXClV2SYYrua/1QHj2DxgQ+DPMU6ejxwLV7J13cz6+9L?=
 =?us-ascii?Q?lVxOIdHh8VibaKbsfhrwbr57?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7904f4b3-4df0-4958-4548-08d902eb873e
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 04:28:06.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKXHsn0zDIGxtWfE80zFu615kRdQOFWRb/mRUDPRDxSlzjTfBVvrqCPq4FC2odaf3TelCkg96r2AsvbDZ5jWUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Guo <alice.guo@nxp.com>

In i.MX8M boards, the registration of SoC device is later than caam
driver which needs it. Caam driver needs soc_device_match to provide
-EPROBE_DEFER when no SoC device is registered and no
early_soc_dev_attr.

Signed-off-by: Alice Guo <alice.guo@nxp.com>
---
 drivers/base/soc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 0af5363a582c..12a22f9cf5c8 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -110,6 +110,7 @@ static void soc_release(struct device *dev)
 }
 
 static struct soc_device_attribute *early_soc_dev_attr;
+static bool soc_dev_attr_init_done = false;
 
 struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
 {
@@ -157,6 +158,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
 		return ERR_PTR(ret);
 	}
 
+	soc_dev_attr_init_done = true;
 	return soc_dev;
 
 out3:
@@ -246,6 +248,9 @@ const struct soc_device_attribute *soc_device_match(
 	if (!matches)
 		return NULL;
 
+	if (!soc_dev_attr_init_done && !early_soc_dev_attr)
+		return ERR_PTR(-EPROBE_DEFER);
+
 	while (!ret) {
 		if (!(matches->machine || matches->family ||
 		      matches->revision || matches->soc_id))
-- 
2.17.1

