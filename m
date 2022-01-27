Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034A049E8C8
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiA0RV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:21:27 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:40513
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232577AbiA0RV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 12:21:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9kZaGNOACzS6bG1EsmioGcyEfv7BRmWip/dtXbRV32z30v8a3BGVlr9LK8IPqzxSIsPT4AwAsLt6ZS4wZalfDVIu/3iYa7O3b5m+85msORCfgjO9PQAsG/SyksFRdAIkQgR/jYoYg6lWNcpM1t0vRPiiT2EaUeqXzzX7n12Zv5GeXTXasdNuOZDQUIAOq8OhoI6ypIWRdhAZnlvcXy3eNjagiZ926/3jn6+ZFJs6jQwWTHuq2PV2f3mzFAKsaloDLmGGuRiBcEtHXI1LRqi7L5Ggw+GYHuQjslERm/xlv+vZnCeChRcdzo9GcEqFaApl2O+PpE2Bpl5tOiOgl4Sag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfCB9PoroEl4PZ7kbSOLFRKM97po4ITJMcrwVkq0ZMo=;
 b=aQWRmCeVT5gHrs5bNPSWtSDNS29BkWHmq4BTCmFcF8QYWHqCENeuoQ+I8JqcKDGKa4pBC/hNwkbWKpPWXRBRUBKX4UZOOUtBCpK8obEOUoOxt2dTQ5vJfLEnVmy0ViH8WcOJew9ifw5E6dB2H5pwgD1eJdK5J9DXv0ARx0wczqjVWxrnHUHkoXOWPCdxYINynzy20aIisJFEpxKvQ97eDWtU3HPvPManh6vXuAfTIBwRWWi70OiWdp57kDlhhkDhqB3chdSQhv78wZsjRC+O9iax/6HWScnlWDewQ7qsfGvNH/xsQ7PDsmap8udeI6QGAdkHMZIZSdEM5Bldabv3Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfCB9PoroEl4PZ7kbSOLFRKM97po4ITJMcrwVkq0ZMo=;
 b=CkN7K/FdPQGhGW1JSd+RYnsWy+z3nJSE2ANypOeGpUj8KMGofT0P9SDo5sF4zujZS3fM49+Xki+mxYrCUadFx+WKUfbe3YuSrP+BwZ/MUfCrYxgiOQtn/xi0jnRXIXhgI8pWvbaHZY5vL5XShmdTS+TfCbia9H9N4oHvWPOyfrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9017.eurprd04.prod.outlook.com (2603:10a6:10:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 17:21:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 17:21:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] mfd: simple-mfd-i2c: add compatible string for LS1028A-QDS FPGA
Date:   Thu, 27 Jan 2022 19:21:03 +0200
Message-Id: <20220127172105.4085950-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be3f9428-7dee-43fb-2688-08d9e1b97151
X-MS-TrafficTypeDiagnostic: DU2PR04MB9017:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB90175FD606530D197C6482DCE0219@DU2PR04MB9017.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/oB8j6odIub4txP+t30oV2iLwAv1TSezMSUPhTI5PChA7lfK3Yv04tHB3lA1AjcXcPFgf0gG7ANFqKPPnlXtLehW8Dh888GUVLFJ6pm/JQYvebxOqKirFmAMp59RzJNC2fuewRjJ/TsS3GTSc3bjIA/byIIzOxptXaGnDgjeaoFcM9cX1mXqH2RyAYO2nsjJgpTT6i1vsptr4TPgoZi2MEFbKkeXu0oHqTwsXrHNpdRfAQOiz643rQbvSDlo7aMIHnRVtdsjkD5nWfpFjQ2fQabb4Fnjn5+uBmKJLJzROPuh2Q83h6E/r0j/UCBrCSBhVklEB+RxHRsRPrxrTesVWLyXJKRBKWRGwONUNjMkZITtJwxQFUs09lK/00HyLCwnUAYAGi0QLpa4xeu4VYj9WsQZnbpyblz440kLURT78r3HGHr7xjI5uknXjnxw8+2e6fiHCyvYyDERuroaebrplutA9+aIzBc+7uVyLhj0CwoSD3rRFiHFgk+FGcheJ+faJxVGiUf2dPV6lFDIi/ZdL9iQBPN/j5E5C4T7xFGjKJqneO4HCfv932z1NADDn5mJ/2WjNmsHVTcEJrna2fCl31caCHwIxoNYPeU0N3rI8yoDaazV4OtXOsksma5AELifW6YfBjnG4Vmgn3ZAi1tgaNmRRinDDeBjV6WgKerH/XEmpPm+ZQ94rUlpM6cvOgFhzRCZ/eHb+KFG7X/YoXjfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4744005)(38100700002)(6512007)(38350700002)(52116002)(186003)(66556008)(66946007)(1076003)(2616005)(6666004)(6506007)(26005)(66476007)(54906003)(44832011)(7416002)(4326008)(8936002)(5660300002)(8676002)(316002)(6486002)(110136005)(36756003)(508600001)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kePOo8KSB7xt739KkYmOLrFvgKbARVNiR9c/rF1rdX7JZLU2S0ZmDjPQqCe5?=
 =?us-ascii?Q?gTq5duKWeb9lJ4sH9pzjIFTjetCZbSu9UOT2QIuUWIz/4QS4LGmPbVB5jfrH?=
 =?us-ascii?Q?lyJM78lHHRtDzsrUP4jKlFcTuNIwSnBFLk2P+QAJhvAIO/T8hpR7sD/JXzEP?=
 =?us-ascii?Q?0LEaSSNrRn+wbIqqEbRyT7kDWLneuLH6EXcFze81VJLMhEahj80vpuo4a/1+?=
 =?us-ascii?Q?6O+iAdDKkCEXJQFyWh9hKx5G5drbJF24Xp8wfZ2QEa53IdK7DSt2Af9Kqp6F?=
 =?us-ascii?Q?GcPtO3/hkm0OEcxKCv7PsOwLLkVRxo6eXkXNPwgeGWt2iOvaYGmlroyQj9Ch?=
 =?us-ascii?Q?EfwigYOIdtQKbslAxqn3ela7Jy5Nod24IcmfYsPjzn5IkkJeJjVdKcZwSvjk?=
 =?us-ascii?Q?carc9uFjzAH9tTGwHBIrnTKAG+NtziiQp4JkHCLZ1rFp1ps4zf6MeYZeDS+t?=
 =?us-ascii?Q?2H0HIqpqbNllAqyzKp3mfG5iTZxarl/wwXwHt/tQirBaeJ+7gGL+A6XqBgoY?=
 =?us-ascii?Q?w4Rjw97iY1BKCw5AnfsDjkj/bqoaD+TspfACzjnJ61faMPWDb2qwJF8B/u6A?=
 =?us-ascii?Q?QZRMoBLokb99yK8jrp5LgUhbritVXdwahcQ/Yqo+YjtmrWA9ELwOxbe1Mv+4?=
 =?us-ascii?Q?IUKYVPNj1tq3WpcGUzYte7mKgjoxSFOu8dr5qQyS+P1T3VIzMmpmfNo61tdn?=
 =?us-ascii?Q?5ICy3RwYVaqcwOjf6UAlDA0EjaZCsTZd/M158OiUTh2pn5xjfYLYY0CQK3KX?=
 =?us-ascii?Q?snJf7kQEmBdD73U4R3qjq0ZE2q11vacrOpIFRCtNiIkrBAjp/BzNhLS4KBwn?=
 =?us-ascii?Q?SKt3Xp9Exc4kfMsQcGOuMgacH4NWjxhj5cuB78ibyHyN6Tsx9yBaXe5TgRIn?=
 =?us-ascii?Q?hBi/dUzVBcqatKwAzjKxX63eQiKmUPmzECyQwSJeP+e6OmQpgQWae3qba8+A?=
 =?us-ascii?Q?J3UC5tAbPFdi72Vef0bg+D15BhPwd4MNt84fU2dIhI/ZOsGnWsiDFrmWot31?=
 =?us-ascii?Q?lFhkNcZqx3JYAnz9Qs1xCVOZWwM+i+e8TZovLPbMxD5NIw9Vh4U9+l2wIttk?=
 =?us-ascii?Q?1egyLqkTQkr8jdhIYJjEWG7Jd5bY9dMkxkCMO2kqgPMg5tsC6u7qpGIKw3wa?=
 =?us-ascii?Q?CYiFjUM34a6BB/BzzUDoiFoFsOjXhxoteZ4siAVHcc+8pnbZr+btmi8FOhkH?=
 =?us-ascii?Q?FX3UAcOVRVa8/JPa9HNZQ0KHY6pU+//ihPVYmbXsBYIvrMu0hAA59dbjMw6+?=
 =?us-ascii?Q?pq8OgheJzDTwyZnBywIc7dDxK2KPposx22FpxCf1fl9mJrzcChU3Ul4TIWpw?=
 =?us-ascii?Q?TVg15KGf7WywJmPEhC29jznTltspyAf0VNrGMXailptvyU7hjAPWyLQbpGjx?=
 =?us-ascii?Q?7OzY8eVRpxWAejCvaFn69Wab+ju/kTsaRFJ+pK9SEqR/hNJ1gGTlMLG8SXFu?=
 =?us-ascii?Q?a/pTuIqaDS0nvScuolVNDoYJrxvU//ZsPbXdqkaLW3TrbfgyTzOPap6P/m5f?=
 =?us-ascii?Q?CJG19cf9PDb7SRflqvebA45SDEM9M7+oFdJFGsVZtHFbCanT1dw6EXsLNbnh?=
 =?us-ascii?Q?+GFy0QuEJPh19YIIe6mvbEGBxKqCzXrRXaN19tcYX/LaFmzaD8WsQJQfMRDK?=
 =?us-ascii?Q?tkWXDYh6OY+fgVM4RU/5Nh4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3f9428-7dee-43fb-2688-08d9e1b97151
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 17:21:23.8166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uHAHckIGO7trWIjm56/ZrCIVCjGaRUeoBy0QsEZggcM4ZLsN7sxqwd9lhiDsYi+cMkCz2QthI7OMHv+YNjDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Michael mentions in the description of commit 3abee4579484 ("mfd: Add
simple regmap based I2C driver"), "If a device wants to use this as its
MFD core driver, it has to add an individual compatible string."

The QIXIS FPGA on the LS1028A-QDS boards has a similar purpose to the
Kontron SL28 CPLD: it deals with board power-on reset timing, muxing,
etc.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/mfd/simple-mfd-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 51536691ad9d..fee709fed97a 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -63,6 +63,7 @@ static int simple_mfd_i2c_probe(struct i2c_client *i2c)
 }
 
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
+	{ .compatible = "fsl,ls1028a-qds-qixis-i2c" },
 	{ .compatible = "kontron,sl28cpld" },
 	{}
 };
-- 
2.25.1

