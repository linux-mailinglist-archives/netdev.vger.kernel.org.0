Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB25F86E5
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJHSxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJHSwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AAC3F32C;
        Sat,  8 Oct 2022 11:52:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqDuPi+1dATZGwOi+9qGG+1FoS7q/fSEap0NXOKWgqJh37r7b+VKnRIuer2vygKUhPbgIlQT4Mds9YAGRDDtoVnAzee5LzrTJomYyiy5YgzMZgZ0i4x01STgqOMLCHi1GxAQKABz5I3zA63qnWy5xiwpZKXljBFtisrPuwfQ58hu0UgbDo/lNZGy2Bug8f1Ey7OnLqEsnXiX9PpgCPGRhWebuvmZmVJQ5Lm8YJ04kkeaYiZ3OGZOgx+jvXAdDIWPXuuzn+b58/ihY8toRbBx3Ha4oei8vgB9iL8qrLZe2yjFLzd0tcPGvL4c8HqRyy8Oh/tqJYAQwM7ls/PLfD2cBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zyYV5u/Nm8BrvODZoTnkVIm6v96W6ineNJjBrd6Els=;
 b=A/Ka8PTcHMdsJGdC6ccG+htaahU0QHLMfJQCngXvRVTScyBcFN4fhQxslKCxTOV+AH5ShbSAoQYs5PMpvg8X46DBhuOlnCq5L1yUI/l3I9YcVRb+nKsJvB2XYa+nBFnFGCa2KSq7HTSCgFeHKAZenuruU69NmEtK9wAZXoDOUZ1XWbWj9DZ8H3XPv17cApNVFqYTNvZ9zB0MgGC53IRJ40jpG9hlBRVZhLXirUUPmKKgvTyUZZ+N4jalLPZ4fhXM8kRORpmA/C1nshoOszXI1WrUdN/Ml2XIxBoSc4YcI5LFu1i+/WLjN97McxyPC3mHJwJszrLxeja8Jlj1/Iysiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zyYV5u/Nm8BrvODZoTnkVIm6v96W6ineNJjBrd6Els=;
 b=gB/AZ/9/qLIkGGWWiNGiiERUYtkRBMVgL9CYmxNQ4qsWppNTtBnj6k75Rl3meKm1Jc/l1CmZFKpPZkjEFfPCJ+0wCo3Jf60m/uyPOWS5xl9fVT4COotwMxiooZKsFb4Y6MoitbJYRgrO4ziQajvgYEphUGO6EiXsazjvA3yEguE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:10 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 12/17] mfd: ocelot: add shared resource names for switch functionality
Date:   Sat,  8 Oct 2022 11:51:47 -0700
Message-Id: <20221008185152.2411007-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d1a924-8894-4c01-1e7a-08daa95e3484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXUIknj4h4piNdlMFhYq781ZAkEE5qPeIYsFLRALRmJEXwbAegkCRuQTKJjZ8TEJ2vS02LQqLcxfZaonXX6QnTt3K5cvHbiMz3IHi1DaklrLCTCuBRIi2xenfD39JmCIWpUne9/n0/eEyqiw8S7g5NFlJlt1UhmBGXeMvoetLBTuu3MdJDSsP92+vYHkOupJCHShmoVBtk8ticNjGe/JGe0xFtDB+W7Hf3QV1fSdtGgDHdWGmMzXUkBfT6b99/auoFxN/tcH8U30OqahUw2fGFeqJEyAFZTnPN4sN3qDYnPClfsOXgYsvtE0d8/0jGT99iTWp4bFVzOt35/HRbNF038Rx7SDQf8HORydHH71NjF/YmMkGWdMj5KYfjy2zXMU6ToeXA2ogrGhto59yXSVfc/vh0G33yT8quq4dA8eZl1XIqBgZuME37LAg1+qK7dVhz10wDyJmz5CkVT/6c/QIs4ELnw2+ToZxbhakG+av/QxavIQRmuR/Dw81QMuo0kOkTwIUIBmDYFiUBZlbcZvsugyKRIfmqsu6IFjon5wHjiaAf6tr59WC2UXwkzQKrXB2h1IQ6dpbIcL9wUQiLYUgAQmXtFO6FTA4PnOl6SqF2kP7uJfhWC4iZHrdzO2kf+Jj2tH+j1p6NCDirySHXqN6hYW5im1WZFwZA8JAa2b4dmMmLrOQpY6CPMBHvvTOp9yGAcT1EgvB+G5/Hu7k2PN1iXk8bd6Iayiq7E5JsR4Py0TlgYUqxP6GF//4FupZtYTCyCGunzL9X1qaReNrl94vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2rMSl/4d+4xMX7Ud51axhE9/u1P/YBTXfI380lkuVYeSH7JBDfsn87DN4kV?=
 =?us-ascii?Q?z7ZO1W1hJbd29r1aQq0BNqFHey71y7eDAQpXbLN1ndMxJxaE3M09MAFYpOMS?=
 =?us-ascii?Q?L1fexKrsyQP5buCfuY2jVDc+yxO8QJVrwXtrXrZescp37RjyEq0e2Jq1wytT?=
 =?us-ascii?Q?+wh0d6hWkx2Nwfq8Yb+rgICre9oQiqUdNacNjgPEwJbVUw2YuZJO+xTC+aSY?=
 =?us-ascii?Q?oWeY8OISi/09+m1esxFdyGlRtjMKAxKsot15gQvIoDwqcQ3kYngPDVZtiQm9?=
 =?us-ascii?Q?IWAtlF7OK0I6gbFP0xKK66xFsAZfl2W15+5jkunQaCrKhmFGFBW4GyF//zbC?=
 =?us-ascii?Q?cAQorVTZStY1nG00lRybhOHdwtFfEjuWvdVug630s52lcMykGCrYlsuN1mNi?=
 =?us-ascii?Q?37zBS+BG8xAR4/J+ez8h5A3WM1KdS2H0zh1LZ0CLsGTI1swE+Hg/haO1i9B8?=
 =?us-ascii?Q?eLm7lFo6fw/PpejZdLmZr4T7ltwTwJlxDEDN2hmBO1YZM8nRRRhWIlW54LnI?=
 =?us-ascii?Q?zDbj+JgC1In+oCFATpkhdyBf7L/uRQMqmmsgzgwB0bvdkYSlrRNXodTEIx9C?=
 =?us-ascii?Q?UM/xDFKo1R1ZgZCFoD2nw/6zl4krc/2vWzbL8TISY+nmTk/TVFzf5r2+jkP+?=
 =?us-ascii?Q?I9Fd0EV2Jy92OYaZe5ZZQLlliKVfqa/KX2y9Mvxo4svNSRQZen3zoZcnP+ki?=
 =?us-ascii?Q?zz3VmVaMwbitIDW9a0UIyWX660q0dLhX0rJcEgOwU2Uk4bLviYbajdnWmMGX?=
 =?us-ascii?Q?du1lgxrJIMc9xlDC9RHv7rbVSHac2ddmaoPlDP6wmnspjfpRxELjdjy7Lj27?=
 =?us-ascii?Q?ksFlaV8XblLYYt3JHUdOhpNfdh8QQ1tIeLCn9jZmcrcytPdYgw2C4TqrcGEV?=
 =?us-ascii?Q?Xh2Sv/WKU7OzAodQCxJZ8Flwj9Xtb1863yuUN4OX9nDh5rbYoF5Q5dlq6UaM?=
 =?us-ascii?Q?o4FUHbT/INZvkXFPhacTD1HU+86xpocgGz83HnrJuoicmc3s0+Ps3WODo8NM?=
 =?us-ascii?Q?nV/TxWRW561lRLAV3r2WORcWGOWUYWIvglphOIE8FgoHRxKRH0SXZOUDL60/?=
 =?us-ascii?Q?YjN/a4hiF/yFau3mMjKgjgBEmWK9p0YKIrztF+WgEQYmTizAf1AiBVnwxAKR?=
 =?us-ascii?Q?Ks23WAb7N+wLQ+7vuPS3yYgj8Fh9vSxd32vvhKfCSQ1HkdDQLVsWnkaNSkGT?=
 =?us-ascii?Q?oXDKQDk3hNTP68aZoQDHX2w1UfRTnn6U5VvNVY4ZCor1xDSyAZxrOMP5UH0x?=
 =?us-ascii?Q?T3kCZ0VEWbB9C+Q+l3Zmr4cofI7dEIzgH4byiNixYDbIMr4E0cJlqdBFuHby?=
 =?us-ascii?Q?hyUu85oGXYwT5g+qlj0aBGOO91ycDMZOKf4uvO42lWUltdQoW1s1rTUe9RId?=
 =?us-ascii?Q?9wH0VLZkxGSWrZv8cQlSYNHQhhdsAxOx+Q4z4iX8e+OuDjzFnwjBYaHh/kdN?=
 =?us-ascii?Q?67+oXOVeYHnZajdZiUBauYDKCzQPMKWfR2WiQHSPZtjt3i0ABut4eT2Mg3LY?=
 =?us-ascii?Q?n9tRzALU2IP6PgLXkaDat9CExrgbJYf8Nnc2rAToqhHKqyEii+hRCbQJA3jS?=
 =?us-ascii?Q?Fa90EwHcl5G5fJoyJ2H7qatyah+lNAZRdB3VUqmr+9b3DOAV2fyJLEoxFEFy?=
 =?us-ascii?Q?MOvNa1Fcms0kxLrXHJsBN+o=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d1a924-8894-4c01-1e7a-08daa95e3484
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:10.1158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+eBhdviUp3xvLSIzj6n0ttDeDIOBFwERoFTYFWJyPO1gllfvh4smSibmFFmgvRs9iQAqirq6XrwM+txEm07q7/ZJLMtiS2J5fNZCsyIZYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch portion of the Ocelot chip relies on several resources. Define
the resource names here, so they can be referenced by both the switch
driver and the MFD.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * New patch. Previous versions had entire structures shared,
      this only requires that the names be shared.

---
 include/linux/mfd/ocelot.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
index dd72073d2d4f..b80f2f5ff1d6 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -13,6 +13,15 @@
 
 struct resource;
 
+#define OCELOT_RES_NAME_ANA	"ana"
+#define OCELOT_RES_NAME_QS	"qs"
+#define OCELOT_RES_NAME_QSYS	"qsys"
+#define OCELOT_RES_NAME_REW	"rew"
+#define OCELOT_RES_NAME_SYS	"sys"
+#define OCELOT_RES_NAME_S0	"s0"
+#define OCELOT_RES_NAME_S1	"s1"
+#define OCELOT_RES_NAME_S2	"s2"
+
 static inline struct regmap *
 ocelot_regmap_from_resource_optional(struct platform_device *pdev,
 				     unsigned int index,
-- 
2.25.1

