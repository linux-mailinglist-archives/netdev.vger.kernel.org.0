Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC48C479DC8
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhLRVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:29 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234654AbhLRVuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W71ZG+iohx2qg0GCshLURugF+q2HQas2fEVRmg/GEjBc2TbktfAIXh00pZDv2IeUjEA2Xm6z+V2ziaK1AnNNOy3YPU5i4+bvikJEk6tPh6gkJLkxqsCK3aa3IktBCoaG5MQEu7ytfD9AxOzO+YukyoSlrPJe7e1wd6+sZbcrO8y2aq84c6ntge0w1/erDj4jFZGh4fhDrMUQBi8ikg6SRuFl4MSLVral8ySeNRf+XOpYAqgORkpCHVXpcf/uDeDAgxwRLeLVqtCKWFXv9RvrQoddym8iacSmdQ49A0Zvomet/kRDCqRItno2Yg/zADCi1q5nU/Xwmy957BH2L985Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAAoDYcWfXLcdu37KHRVrKKICtYnve9pE/vZnt5JYug=;
 b=WWXQs9etMqVbMjCgv+Vqmgu4CBIbHAl6ynhyCuVwUlO50UR/B4y3I9j2uphP50sOwzG3hpGgwQAEr+747WxhoPvUCbyUzAbdoYXlPBaEZv/uI3AnYPb55OuSL1MW0VuOUhpCRWC2sWJ+/H+BZsq2eQciWTW8ymhzuPo/Jk7GUYPqcEqC1TEQXt3+qMrp9Li6XwHP+Pv1ZeORVvzkAMppJJ9QVnyavdjrYzKDOGE3MP5Da9y4u99BGU53V89DA6rFrphjyIdrbKDOg4Q+s0iXxSuXDOP1QN7u3v5IEg6LsJQzMFMiZnUMvuWR4RKLLWTKUj8dYvOVoOznRFZdEj5ojw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAAoDYcWfXLcdu37KHRVrKKICtYnve9pE/vZnt5JYug=;
 b=hLAjVcaL+s7o33fLcw27SsrbNBZl+nu0x4pa7uLECDd3xMfv98EsBXQbrUl11h2qxXzSPkJ4vyn2XkRVPToUo7Br1M4XiljzunC97HyWGWP2BZmmTrT/WcCha8mZhTajXH6D3fstKg1AXs5OHvAHQRpJhNL4x6mZwcF4cEQlue4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:14 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 11/13] mfd: ocelot-core: add control for the external mdio interface
Date:   Sat, 18 Dec 2021 13:49:52 -0800
Message-Id: <20211218214954.109755-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf24ac2-9b20-4edc-40bb-08d9c2705f41
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB563399195FD64FBEE7C5DA80A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yfb7QW+X4cCrgJ5qdfNpb+bG1fm2R8YiIjxrnaskb2Gcy2A7pj/uEt/vzFbt9HZtOF84bLnJmeqm8IugVUNX53f8nMZC2cX+aY5WiYU8qvowazEY/SKtBh5JFtlTfwX9qQgad2ocnNyWgdmOTrA4fJRhhRqhtiqWFl1srrV4w9krdY3sXd9Xhew8IGahx3I7UbkeM01dNBivihWMrbrbDzZ4zBaqRKy4EXAThVU+0yNLnY/D3itcMZa8PzGFpTa3nHPDRnBMDNtUdB/X8dwZy0VRuxSM3NBfZkBD0J7OZG3MZ3GQYeeMEP3i8wNUWZySY1GE0O5USGLyEeu9G+KdX1Q7DYO+uqZMSl8QaBQe+5mYvuW3EAuYfuQ9nCyCMMS4PGP/T1oxvuVTWxtpxd/ErxpDv8o0yqt12bYbF0HSwx+bBEqxAews0EgG/Mx5aent4LLCQMRmehqs/9UuaL1NXU0o5vMpccdiIWPggHbA9FMOmt0aX2bbaWBMt0kNB3hkHbHSKeSudawgIQ+Xl1yq3OiT7R1mliuGHCukNMUNf06p24vpGY54onVGdUzxO63+aEHRaI56jbEs53i0qzw59yMD3wb98+NBEDJZSL06N8wytsFFtH+dkNisWzfC8YlN+amJBI4RUnJU942l2+lj1cfEPNwCSzWVJRcjcTa1keQpGWgWgwaM3IF5wETqCF9eykPPaBKbufJbfDOeVhpxTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(4744005)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4OXC8EQjtLcMv6MAfWbF3HtU7RPdDNuxCa9vGdUmQAee3JGUKBPaz4SR/3D2?=
 =?us-ascii?Q?/s8krr7H1nCjv1sk2x3+stwRvHNjPxT9pg7SLsEDN+je1EPuUlO+bIOtwDoZ?=
 =?us-ascii?Q?M3m2i1MmpKl6rhXDvYx2Lc4TSSBizF03LdsuLwJ6Ye7BdjIAlGyAXnEBdgwu?=
 =?us-ascii?Q?RSboqk0hPat7Nw1Mrki5/bXJp2e06ep6jLXbLTs4wktclcNEhBfwcis/pgbK?=
 =?us-ascii?Q?L399NyJucwgAAgKaJRVs2VUNix/C17Q3ldDOdNm4mr2dVc9AOuldIRGCeU2j?=
 =?us-ascii?Q?9v2fmkDSomQQ56FxyAOeaYBS1eYAFbsYG/HyyKmEXE+uLyZfGK28cruS2fBP?=
 =?us-ascii?Q?0lXXWCb97rbEyexatPWrMXfVovCttn8G2/SjTC7ONS28yumxNxQfXqkLzTT0?=
 =?us-ascii?Q?NrGfDZ03nlZMXN7PAIH/wCC1XfT6vIPAMhW77xolsTpWDT31AuUU46tZWD46?=
 =?us-ascii?Q?XGGuo1mEg7/d80UKuhXTgnn097PINMR2OOvQoiV6uZ5ekw1/VjSHtv4E/JhS?=
 =?us-ascii?Q?gafKqZnruQdY5CGgVymC+869qOULbZ8vvjsg0H/Gw9E8JzaTNqNIwXP5nfC2?=
 =?us-ascii?Q?WQxxU4GoI3QzVChQSwbHmV6tYWcjSQ3fdnoiBoRcMv75LixVDH/ncM1VxEuJ?=
 =?us-ascii?Q?nr8r0SB25ISOPiC0zx1nUjSvoUgb8O5WgyRZOh0kCDn2hCA2hjoQ0fSVsmgV?=
 =?us-ascii?Q?BsvfsMoIICdW+bLjmFlpZUsY5IngHOExuZw3SZYZ1RNPbgA/y/FHQwCuUarI?=
 =?us-ascii?Q?VlamRccNvpyXwt4D9xU8cVWMFZEzlkBm1wNSmohCumSeaO+EX5eLbSutwDtd?=
 =?us-ascii?Q?vbzd61a3rbzMXz/HkgZ2se9nzaRTXPXH0+bz1iCf9ufdi0X9Xqtd7T1EYoFl?=
 =?us-ascii?Q?4O75uLeLCdivhDOrCXbknoysoLze1Wzwu+BQMSKErpjo4vKxlxM7FDUiQyOe?=
 =?us-ascii?Q?ae91N53r2dpUFV+mLTzALM/YPnlCiyvteXf6RoVEhHGOHpv5E2XQLZN2F37J?=
 =?us-ascii?Q?R0jq7sXrwATPyahMGMPOujwXF9grR+yAVFWaiBvtn5G5s682u9WUkETYYRdA?=
 =?us-ascii?Q?fDoqWggjRAYO6NngECnero7pQyxiZAcX3zXfDdbX4N1apn1HMmyvXn1I+YuB?=
 =?us-ascii?Q?OaPhmLOLR9zAgJghnYJEY6H6Fld/YVLnkGdmjLXiUd+acN3tABa05sZ6J+kz?=
 =?us-ascii?Q?PNgDQmHsPO/qGWYKPh7a2wRHf2BV+MmdFky1AfBzVtWpVoaAlQXNuXufL/Nu?=
 =?us-ascii?Q?sD2SZ4613nc+XU/b7d21+GQ2OMRHrZdRhypAsioc+yYE0hJgPqnpb/i1cR9F?=
 =?us-ascii?Q?JvJ08/AYX1Tb10TQ1zLligUgaTxQb1tUxc/0L4qNxXIYk5O8oRPg+P5/f34h?=
 =?us-ascii?Q?0kpYPzYkjlkZSNx5n+AKxoKLUfflq7qM70oeVWt0IIYQ1IJN0YzLMTVBkrlY?=
 =?us-ascii?Q?731diXGydrwy78A+k4r6mPbygbePB7plNBu0Uu8FuvtNGkH6ypQiRn59Hdrz?=
 =?us-ascii?Q?97TkU6amoctYJcWrf4yByBsQtsCHeGHkDJLKDI4k0pihTS1rTYvD3/sz55Q8?=
 =?us-ascii?Q?DD1RjC8RB0C12PllHVxhWT9d+PuUK7t4oosRIvRx73+SOoByOfzAN+b+ppUo?=
 =?us-ascii?Q?k7MG49MQh+V5DUohn/0FrGtK6ug5v3lWk/cJpbJYk80pMzEiqdwHmKQoRG7A?=
 =?us-ascii?Q?eIeJWEzymLHP3zdSbOK7jhsGyP8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf24ac2-9b20-4edc-40bb-08d9c2705f41
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:14.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYJb51E4ighQkRH8mfMPOJEtgc03xOPGesoypuZNeiEImUSprS0R5oDdCJOmz2YAaW8XNvz1dNV4kdggnlm3I0SFKGvEFe+5tphxCHV0ZW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the mscc-miim-mdio driver as a child of the ocelot MFD.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 52aa7b824d02..c67e433f467c 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -104,7 +104,22 @@ struct regmap *ocelot_mfd_get_regmap_from_resource(struct device *dev,
 }
 EXPORT_SYMBOL(ocelot_mfd_get_regmap_from_resource);
 
+static const struct resource vsc7512_miim1_resources[] = {
+	{
+		.start = 0x710700c0,
+		.end = 0x710700e3,
+		.name = "gcb_miim1",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
 static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.resources = vsc7512_miim1_resources,
+	},
 	{
 		.name = "ocelot-ext-switch",
 		.of_compatible = "mscc,vsc7512-ext-switch",
-- 
2.25.1

