Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF245E59E9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiIVECr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIVECX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:02:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A1CAD984;
        Wed, 21 Sep 2022 21:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldqxsPMmq5hnWDZ5OfLpO8HZA08YeVfr2wKmTtoXnepTRBox6ac8We+iVejo3ZOEDanzt+ryNQbg70AeIvvD1NewG9YAxsOdE8tzMkkubajg6CUnz3HmG/x/XcXIRjEnjXshD6G2Y9ZfB+psZZ2QYtaR8kt91SvfGTYPdp9KWwgwvIY+ho/XhTl9P3IQqUdXr5sCwqevGwVQYueQvyR5BWeFmF2r7lks0BaQMmEc+QPmFDV6Ei6LitXqWBLykrotzR90XQHSDJ75EyhImXOXlCfqI6CEkcrfAXdlULyWVFR1pu2bQeXl5352Uui6czyfi+D9zqLfeuGiSJePjZYKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBxdHaMV1L2lRGI6mAzHE9MKi2hjTWKBF/SkZEFqzH4=;
 b=M/l//kIVGEZj9zEql+rM2hjFcLSTauJdbUkP2EwAHhAoyxOs1c/zz3jVUxQmeIwZPVS5ovvuFX0gPjz/JTh7ZunxYDZaOC8j/nLtJbwcRsIC6bR88xAvBBosqw0sUFIkGLhmTOxj4y4agDYLo4lv+Ty46V7Wh5YixgFOdzsEr2UyjRfdK0CeV3YvwUd5dcxnRt3Xjo/eyEP5h9mCw5kNGCxmBrqNc8TfJsOeOIA0GktipmLGrTsJcwGN0sRU+JeD3wy2XSAhTInSOQZGk6FZGRmHv8kQTMmtRnphxd7mphhTx9x2jSsTJ9OVaN4o0gRmoFuAqdyOMYO4pEcgGBDJeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBxdHaMV1L2lRGI6mAzHE9MKi2hjTWKBF/SkZEFqzH4=;
 b=B7N2t4j1lH7K55/0RnDLGU+OuDCE+JzzoVRB5rDUodPoRkM+Ylh4UaOqVljVingZaT1zvCeZnc0GElH82hBxzcMqFWDeuqo5wCvGkSOILYTfw5riGv3AhW+J20r9v8ceV2lP/RS2DAmfcmFKE8SiMAz1jSLYdwrojFagC5PeBUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 04:01:35 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:34 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 10/14] mfd: ocelot: prepend resource size macros to be 32-bit
Date:   Wed, 21 Sep 2022 21:00:58 -0700
Message-Id: <20220922040102.1554459-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f4163b7-4e9e-4a3e-32b2-08da9c4f23d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wOWvm2b8NYDS8ZkISb8j8f+pAB+XulpzUCT+QMkeaHeRR+4yuOcjqBiSPzhNlZTYo+0pjIh1UW8GONTyYkSq9W2ARcuVHBrEyhQIr8MF4gibybNSEMsNDJ/wTg0jVs4hVdPt1Gq0ObimR5KgtAa8R/NmR402fFxOaerpehcroy7/B1C5XiMBvyCgLbw05JRSSgxEpI2yIF6cueHRRUKcprhVlf5wv0amMMUtbzhWKyTMp3GSA+IDgSo+gz4X1Vepvn/4zJKyc9yZaZlcug8cXIIlj2g0J4lcoxa/+4qp/z/6X5wf3NbT6E1s/rt9ptNst8e497ThjCGPkRED99YL90Z8X9oWu+f1vD9oPuimny+AGgHnH11JvF2wsNMDZcvEbVc5c6t/RTTHrWXaOLQIjvIGxPWyVzMGaffqXJHHQGJfUMfQBREcMc2wa6A3cW69EIDvgGID3F4eSMBnUP7S+llybRq7gBm/FMprWXYZi7eUAuLr7auBzxiSrWhzH9PUteyjy/Ud8tWW5/t9mLCHlAVLZLA4ne1BnmH1lPOiqWQEDWioK8IsQ1Bc0Mig23C1H4M+sO2kO05lpT0XP9QkUPeTBTwz5tfC4dLBT9ooIfp/hp3En4qgSksCwQxyn8TBSX2nPJWm8+ZOmCdz/kdw2SOPFT+G1cDVu+ykE/vg2yo77w+M57LrzEllTKZvhK6/1Vjfp0KOpi8TPnYpibIeIba6Yh/+E9Z+rJxErnBhNOTXS6oZHvP4blHokoz6UaZ5h+XnReBBgyplKLwh/hTDWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39830400003)(451199015)(36756003)(6506007)(6666004)(52116002)(6512007)(26005)(86362001)(66476007)(66556008)(54906003)(4326008)(66946007)(41300700001)(8676002)(6486002)(38350700002)(38100700002)(83380400001)(2616005)(186003)(478600001)(1076003)(2906002)(316002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScR2F9SE4pFi6UYafZfVOwvsAMUxeXzlV88fTh/KUF/ds5JM0sAerMnuuFb3?=
 =?us-ascii?Q?UTAgVorOIoBM6wcyHHV/TDbaV75Nm2c8LM5SfB7k+22woDXCj4NoPgRTsRDf?=
 =?us-ascii?Q?L2MjM/x7yVNTVnHIy6RDlfzaPGHECK44YVev9zCvx8ifW9bdjY8sWSpbiNB5?=
 =?us-ascii?Q?HWj/CFdyej3HQwOlSUSkTzRihpJhg4+BNXSEfG7ZXpTNwg5bV3Ds3uGHmQPD?=
 =?us-ascii?Q?O5yDZM7lyfLN6jG0VAfIkyewDCdppqGlsedS7RbLvF7JgUdqMZsn5hW1bCck?=
 =?us-ascii?Q?VDSSQlhR+tAqhGKu0SkwLalBiAT6yoab5XWbSExCSMsugiCGnZpobT758Xxw?=
 =?us-ascii?Q?KMYCdIC9wKGOjbcwU+twdDg9IelERh6vXxCmdUvotJJf5W3uqZBP/StXjSxr?=
 =?us-ascii?Q?JB6ZwcMJ1J+a05s0UquopABI5ivUqMgsLQIAMA51awUCbQ/BQmAc2Z5kT8UF?=
 =?us-ascii?Q?Cf0RGTi6Huw8DQF+4sJ0IdNNkV62IXcSW/9wKnXxHtYH2Ze6aQ/56AWxf0NR?=
 =?us-ascii?Q?kzl43jqpf8t0wu+LkeyXskMaCeE0JR9J0NFhM8Q/FK3DZEl4OkAoBoRslz+J?=
 =?us-ascii?Q?5G9/igfTF3o/BhmdbJXeNDCkt7faBzeuyQHfLEiJnDTXsahHC3k1x7ZOK5Sf?=
 =?us-ascii?Q?C8SQaC6brMXiHfptHiqcJgwMLgNeLmmnwGoSAWnoSJFv5xosfyVIdi6oei2x?=
 =?us-ascii?Q?h685rjvIrnV+uyxnBw12wf5/lMsdaMRKBBvAHRwn/EsuWtNjdc5pY2xEsmiw?=
 =?us-ascii?Q?wh0xXdHshdgOpRktKTq2iFtG92jgKM/9+aIZ1uf63n3+7AvCe/M6ZbieLjVg?=
 =?us-ascii?Q?P5R9FNJBfxCG4drPY2d/5DUxyB8ySQLthwMDJFXwl0anvv3NqmrlZU3T4qKb?=
 =?us-ascii?Q?qDBdEeiNsEFwsC+IgVaaYmPnmp6RvzeP64oPlBoWLZPMLATlDq0AZT1yFiPZ?=
 =?us-ascii?Q?avyjJtwzcRksp1676cXG/lrDouLproNw7oIhSkXjvHgcZt8WELkHjJBuxq9I?=
 =?us-ascii?Q?eSuxBI6qy2mRdBsS8vs0Aw/yp73EFP2NscvRxuNMXLLSOOrxJqSJ7ddeMkFa?=
 =?us-ascii?Q?4P0OfxQFO83xwuA8FU7noHeQS3fDbGPQXaYMvM/3GdLbXnMo+X3ApQQwxEhx?=
 =?us-ascii?Q?mNX1Kcq6jWItYREUNWPCQTRASg34fl/Q/TTvXrIOkx7FCJA8qwIeUO31hnyn?=
 =?us-ascii?Q?zgMeT9LAnwE9TcMvLZ/LzY1Ag6Txx7gR5+sxrhxt69V3A/HkfbvwCbOpQAPZ?=
 =?us-ascii?Q?Y63dyiXOQP0E1fNJWCplfu3WyKYHHmLuXzZxcFWYiFokmvncPZEYJuhaM4TI?=
 =?us-ascii?Q?kEUdZUrdi0YDwXOrJWCAABC6u3NizbkoPHjsJ+kiUfZCfuKTLh3hGvgPh3k4?=
 =?us-ascii?Q?R4mOgBGIBSZDO1nFQTt0yay6oraWnKvuFvMznZdIyu3skXqLLFqrDpAChgrL?=
 =?us-ascii?Q?F60+RlygtFURSxAGYkMeB+oMB3VHEWJ3Ft2QZiSR7eyRk/HVeoeaS/RDFH8m?=
 =?us-ascii?Q?IwtO8DRtI9E4b9M6aTu1IgqNkVT79xcMrzYgXIFoI71zi68eXw6md1GSj4qb?=
 =?us-ascii?Q?jEeS5Szi2YIFJq7WTMGo/qgHsk5uDcv5X8A4kaBYZEl652OKfn10r756C45H?=
 =?us-ascii?Q?aG0WRQxpqyVplx1H320deYA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4163b7-4e9e-4a3e-32b2-08da9c4f23d5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:34.5901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UwODeQeTGGvoN6T1DncxkqQeRviD1VqJ+MmDBwgWyz/HPMJXxKq6X8xlQVaWJUBKwAepFxTX/NYA7DaDcxQ/pgecD1mrR2H0XqCaMuJ2l7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The *_RES_SIZE macros are initally <= 0x100. Future resource sizes will be
upwards of 0x200000 in size.

To keep things clean, fully align the RES_SIZE macros to 32-bit to do
nothing more than make the code more consistent.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch - broken out from a different one

---
 drivers/mfd/ocelot-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 1816d52c65c5..013e83173062 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -34,16 +34,16 @@
 
 #define VSC7512_MIIM0_RES_START		0x7107009c
 #define VSC7512_MIIM1_RES_START		0x710700c0
-#define VSC7512_MIIM_RES_SIZE		0x024
+#define VSC7512_MIIM_RES_SIZE		0x00000024
 
 #define VSC7512_PHY_RES_START		0x710700f0
-#define VSC7512_PHY_RES_SIZE		0x004
+#define VSC7512_PHY_RES_SIZE		0x00000004
 
 #define VSC7512_GPIO_RES_START		0x71070034
-#define VSC7512_GPIO_RES_SIZE		0x06c
+#define VSC7512_GPIO_RES_SIZE		0x0000006c
 
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
-#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+#define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
-- 
2.25.1

