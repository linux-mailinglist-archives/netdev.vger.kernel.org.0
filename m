Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE01C27DC06
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgI2W26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:58 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDkYhFR1uhLTHiyaZX+F8GcMQfM7M3Y96b7ItySwfDd1T6kEE5vryoaZdH+ujyPrRf6fHGUoWUVmRO0tgtfPHCDeMQULcsKydzKUeToZoKyNrwEl4auOeJgd+TRQkAcnYX3kwqu/cXi93SlWtbRBZnrBygv2pW3bJhrdDFC3Urwr9P18QzHC3ZjzgMdQTnWUZk4r5kFgHO6xRLjRNkjnk76iW88iBs4Xhl3n9+Sde8TkNcpSVPdy0rClbp0tCzitq8B+FLHkYUW8X/ZOjLYAwqmfT7XvwlicmhlTBhtRrCidEX9Bb8Ri8PP8D1RSsJM6En2TWoitj9m49fzjahpahw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKsdYghPYCO504n7DSpV0l6VtciBqgiOFVHOiETRAxE=;
 b=ZJE6qEh9NnKXsUp/A4gFbRI/5/vsNctkSZd7ImWBdmsVY1OOgfXDnsDjYS4zpKuh1pwmU6kZ12yrN5CnGh+pkVr9cU9jkmegznMosehE08zXClDDZLHlJ9VH0+PtUjvbAD8S8TSC8UNBIFG2hPIJ2b0wWvn7d4ZaAGssL8qztZCmw0aRk74GNl895S+yWi0Ozs081Tlx7cQe1hwj04UhA02klnlCJLSAkBGvYceCO4Od1opTczYiGQZAFAIqnWXbw2bPryN3BLc9+qIkByd8pDr5GZMwglIg2Sdc7zcalnWgSabe5qUSbJs8vKWV5ys4kjITtoXrZBtV2+bKxQ5/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKsdYghPYCO504n7DSpV0l6VtciBqgiOFVHOiETRAxE=;
 b=SeS6tswsawqM6W8o+JPentC8D4TsbgSJTZcb4DINcGJnPI+JePDLpum0d3zYyGEESTI4lxccH4ahtFDKDK90nFIbEZ412BVlSCaWndWrgi4Nk1A6O9QTKFDx5Z1liIBqsRnk/RJI6K9E8wpualahOjGVZQzhhiyd9p0CzAZmOOY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 11/13] net: mscc: ocelot: rename variable 'cnt' in vcap_data_offset_get()
Date:   Wed, 30 Sep 2020 01:27:31 +0300
Message-Id: <20200929222733.770926-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 229af6a9-239a-45e1-8416-08d864c6f40c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797EE4BF91239E058730BBFE0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LMCAKJzk7NwJlvDvBEYG+FwL4hnyMX2ZmQfGeyQB6wCmbymy1fJVSOVa8edWJrizfFMVj2HD0MLymMGQUrGkvNw+RUCWh0J6DV5g/dNJ5UB4E6Vy1+9y9H0byW75AxjRlurK5v7V1kbkkWtJpndxTvUZZGAekJ0VC9btnD8EhRQXy96330gfmS+pz9mPODfYP2Zi/w9BL8zp1tm5eMmCter5jRKbL8E4Nmqnw+irJneMtx9P35q4P+kg2E1DLFIyNQfV5jJOmlrG15U6XKQSz2rHhMB5ObO6Mz081xLKuF/fU4RYn9sOFV0XgPDSbgrTULPQ/cioY7S8W9M9SAfqEy3s9Huk+k0nQ0qbSW5G7+KW6yji+l9ccjwP0VuO5pWz4R+VjOPbB3WGjVFoxwtKy7jcMDbpWPpXwUf4133C3C2Mtb5UQBoUrBNiqE+Bwoas
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1s3mcDwhlp9W26YxQHIaOtEW3p/lQVhMZHoRb0DPPBT3BRHugytdVR7Mm0qbRpIrHakGaVTunra0WUr17FoFde5Q1UVxkCvBxxilSIKkvgq1ZvWZqThr+IrYmobhMUfZ1VH0oC8Lu9BZf9O4KmlUUhwlg7sqy50/9g/wTWRt0+kTvsovB8FW4NJ2jIRHLniGtzURh3Q1JAzMceoKRzoqn6Jlu6QyqPYtlkkxEADdC/PHXVU1NNHG8sOJsxVhGuV6Zq+9DSqsrcWyd3E8f0B1UP1uDpWGIKev7PE58pkXYDF/2xivPvr240FJHQ8J5gdoTKRczzj52gOqv++58BdrOHc1ZWyp4bLZ+atBEVqcZeD/aP2+HlKdlj2fZmmhtPlKCaajEGUiDbbM8Qg32vITnQzRmE+IryRYhkcPSSsh1URRYpG/txrsbPa4jT2FVSUbYZTGyRT4NBvDQfl0kGpBr/yFitw3XO2znFazcSUaTKWijJlZBDE5upta3G6AOcTueM9qOB/RWekrUYKqVUWVeGbtj5B7Grk5qODyZ8RSHQflw+RpPm1iHxP/f7UMi7DmLz0+F94kAzedEpRGpkAY10dNO4n5Jqy5T5VIO9trkjfJVtVrUNyCqYEDQcXbTEEn7c+ciZ7pdISkuWiddbje+Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 229af6a9-239a-45e1-8416-08d864c6f40c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:13.5777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPYo5XJHyMPSaRsAvSP3aqx+lSZJgT/qEVn2PZ1nIFk15XhFcYezojX16ls5VrPtsGc93RZa45qkVMSaYpaSow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'cnt' variable is actually used for 2 purposes, to hold the number
of sub-words per VCAP entry, and the number of sub-words per VCAP
action.

In fact, I'm pretty sure these 2 numbers can never be different from one
another. By hardware definition, the entry (key) TCAM rows are divided
into the same number of sub-words as its associated action RAM rows.
But nonetheless, let's at least rename the variables such that
observations like this one are easier to make in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1c732e3687d8..9e1b023f2d00 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -174,7 +174,8 @@ static void vcap_cache2action(struct ocelot *ocelot,
 static void vcap_data_offset_get(const struct vcap_props *vcap,
 				 struct vcap_data *data, int ix)
 {
-	int i, col, offset, num_entries_per_row, cnt, base;
+	int num_subwords_per_entry, num_subwords_per_action;
+	int i, col, offset, num_entries_per_row, base;
 	u32 width = vcap->tg_width;
 
 	switch (data->tg_sw) {
@@ -192,11 +193,12 @@ static void vcap_data_offset_get(const struct vcap_props *vcap,
 	}
 
 	col = (ix % num_entries_per_row);
-	cnt = (vcap->sw_count / num_entries_per_row);
-	base = (vcap->sw_count - col * cnt - cnt);
+	num_subwords_per_entry = (vcap->sw_count / num_entries_per_row);
+	base = (vcap->sw_count - col * num_subwords_per_entry -
+		num_subwords_per_entry);
 	data->tg_value = 0;
 	data->tg_mask = 0;
-	for (i = 0; i < cnt; i++) {
+	for (i = 0; i < num_subwords_per_entry; i++) {
 		offset = ((base + i) * width);
 		data->tg_value |= (data->tg_sw << offset);
 		data->tg_mask |= GENMASK(offset + width - 1, offset);
@@ -205,12 +207,14 @@ static void vcap_data_offset_get(const struct vcap_props *vcap,
 	/* Calculate key/action/counter offsets */
 	col = (num_entries_per_row - col - 1);
 	data->key_offset = (base * vcap->entry_width) / vcap->sw_count;
-	data->counter_offset = (cnt * col * vcap->counter_width);
+	data->counter_offset = (num_subwords_per_entry * col *
+				vcap->counter_width);
 	i = data->type;
 	width = vcap->action_table[i].width;
-	cnt = vcap->action_table[i].count;
-	data->action_offset = (((cnt * col * width) / num_entries_per_row) +
-			      vcap->action_type_width);
+	num_subwords_per_action = vcap->action_table[i].count;
+	data->action_offset = ((num_subwords_per_action * col * width) /
+				num_entries_per_row);
+	data->action_offset += vcap->action_type_width;
 }
 
 static void vcap_data_set(u32 *data, u32 offset, u32 len, u32 value)
-- 
2.25.1

