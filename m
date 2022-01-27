Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6D749D6C5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiA0AeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:34:13 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:20917 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233891AbiA0AeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:34:12 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QIuxUc025804;
        Wed, 26 Jan 2022 19:33:54 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duc16g77h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:33:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akgCpLVqPzP1VSfPFvvW1glmrDeF5EZIQcKaBelZ5q550ZLjnM1LdyNlkgugyB2KjvP0EYGG6cj+ESgiOiJcQg5F20Af1lSX4AijjxDkmy8OKTm93hhhzONvzjSx3az4w642JtmHWPYl3V56oct/uP/Irj6MhEupJ3AsHExYBBLNXIgf5kULaFpa61S85Y/oPk9GTHPTHZGKugUsOh6gKWJ3uqGoKgvnITZGCY/4ayyj7Xf0Xa+8qSqKaFg+L15kT715XQYmcbbx1P7MbEACeaNLwljLmZXIjkHSR6Z+xL26vk7GEo70+Gm9vg2uJupTIRFxTxfjxn+psPe1kq7mQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaxCf9uH1I8QfcjMjqYWFIZLsMGApIUlcBMhyrjNly4=;
 b=S9FtUbrZ8gBlyvMvurV0gQ6DhkA8gjNae+aacB04U+Cxd4PC3xMtgNN41wEUhQX1s6HYiuHIfAmhCPf31o5hZY5WYFIXt0IDguVP7KbTsv3XPxHDYP+bBpo1e/GJM4P5rCZcUMQfrbPZdbiYvygbEbYgTi9RiMdvdufwiAtXCXIIHdnzhIP7U4rt/j9wFBesfBU9LfEmOOT9wFkanPKbGmygJlNtUtCr8lOLssfNEAdtRhLvrRaLWAG+MdCJk6WY3GVvHvLjDCt9ozHCf+zKSQCxJ1w6wFz7hQQ8qKUj6CsxPbT6e0deZHR/bKPRJhe04tW7tGkpn9Rws40hLj66cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaxCf9uH1I8QfcjMjqYWFIZLsMGApIUlcBMhyrjNly4=;
 b=2pcLAsXETgG4lXrGsGQhOpFY2rCcYvvIgtWcUCjGEhebsswkR8pJOAcmuA4SwwhmLNxHMqJnNGVUsB84GkDGvrPNy+/9e9psaO/xpxPrNKUz/0KvVDTRJNj6fvRw6B8Vllsq6Y7eQpgj7/XdGvapMVSDGW/d2eNQni/+48MeGtM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6084.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:33:53 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:33:53 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 1/2] net: dsa: microchip: Document property to disable reference clock
Date:   Wed, 26 Jan 2022 18:33:17 -0600
Message-Id: <20220127003318.3633212-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127003318.3633212-1-robert.hancock@calian.com>
References: <20220127003318.3633212-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:610:cd::6) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f33a3056-2fe7-455e-1738-08d9e12cb1fe
X-MS-TrafficTypeDiagnostic: YT3PR01MB6084:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB6084AC57AA4EB1B1477E8942EC219@YT3PR01MB6084.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGgFQtWdhXxpwkUK+Pb1e6oNpGUQhlMWxtJjVXN6wkWLcc7lljUUp4onQsLbon9rW8SGESPVi86uC1W16ixangZ2aCtZ9BiQq4ULv9CxHOdQ4waUK/WuluEBe96EvC13/qDbWugDcO0+lwcqYBpGOIrZFjZKAuL4XqW1peK+0216wIY+X48lXUVhqEVOxB7RMuEWc3rNI8NfVPnYLtoOhm2QjhwbLzuifOCKQl8mUAzdaLOwmbjgrjQhFqW+TqDY3VfE2OaxshXjcZ3XImC1jL6+8D6ejUGcAcBO+JlNaQzIsTWSnnjLH+7c9PGgpvdcRsxNqEdCanimVm4ViVMFLBusu90pt3LoPgch2pH+1q7tUXBEkq1T4QpiGYfcRVwaH9jnj8N2wnB3zUppXWCNcIUwOMkG+aKDcyif58lu6rbu6+H9Aigatr7lWDYgL2INKjO1uBi21XqPmAIONjV8Az8zMD80QkkcrhOSg00debDKicQXWBe7N/pxUZvEFhKuVqvos5YHgLlqZn3dtakXyqofxXozOwCVx7AEPJXe+77ra+0v7r9bfTGNrsR+cBioFi9FW6pyBh8l4J7cKVt/dZiKV/Ksj2dY1bO0kObZO7zktfazo1mk5dmL4Dr5bQkc9vl+vUfBDViipqyyWOGXX7Vgla3+jFLf/6RnhJwwrLaAYFznctBWfe5Lj2GgINNY5PVIY8yw0n72S1KH/idDSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52116002)(38350700002)(38100700002)(44832011)(2906002)(7416002)(86362001)(6506007)(6512007)(5660300002)(6666004)(6486002)(66946007)(66476007)(316002)(26005)(36756003)(6916009)(8676002)(4326008)(54906003)(8936002)(66556008)(1076003)(2616005)(186003)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+RnHGPD9ZlcdtphKYgRSRe3Ollgum+tzqElheHUmRFn9gaZWe5KVpG56gsH?=
 =?us-ascii?Q?NdHZaH37zpvtxSRz9TbND6LnGCr5Tx6jM1IiDX4jc3mqBAgl4vzLnVD+g03G?=
 =?us-ascii?Q?ojjTINFq8TL+He1iRoh085oliBxwMLR6AaazYk5XLRbnMW4hQYUKjPIJEyRN?=
 =?us-ascii?Q?KadIZ0+iomLMBi4GncVLmtj1a6rjc9gruH/JxXHY2sK6fFWFjzK1izPo7FHp?=
 =?us-ascii?Q?Pde5R0Xca9E1tCvJH4205ikCyKmtfHMvdRgcL1/EHPr7BwVNQT7SejvfiGpm?=
 =?us-ascii?Q?6wsL92gEQnSdZb4JzVciSmopZ7zB4oxK2atJcTDbQAluayx+YRzoYPUaLfXu?=
 =?us-ascii?Q?J3mVl/qNw3mGDAYtQsSkQuBTrMen3xYjDxCl8V5dtlmlUthl7GTAuJqpGbTm?=
 =?us-ascii?Q?zLz9Ky4MSDAQN3Ck/fNik+qjJgSr065vuJTQOlQOCIZX7E0TnNuao4BYJATA?=
 =?us-ascii?Q?PmHvImfRg3QZOhj1Z+rloIwMcWcIOoYBHY5y9ig/r8T1kitUQbpISmMp7sTz?=
 =?us-ascii?Q?kbSVTahC4eETIAJvlCEPQ/B2vFn58Vf0xySAnhsHU71Yjf9QpLIfCtIfu5eV?=
 =?us-ascii?Q?nlwxNfqatLK1sf7Q99WxTx298zmOkdiRd57n/npuOgyeoRjabLJwXYcDf5vP?=
 =?us-ascii?Q?GSFVBjuzh3MptpW13NViUa7hVS92Ys8fXylOW+qICvDzdln5H4AKvY0ULbKG?=
 =?us-ascii?Q?caGudKTjNIhLB39OefMtB+FgAFy2XlDFCESfQAfnW9AaiSdvxhfUpT0qBwf1?=
 =?us-ascii?Q?syi/pNNIJIw7wMS50AhVhKkQ9aJldGRZ//HGWhQlfaYP4ynCG0VKUyCLFYZJ?=
 =?us-ascii?Q?TUwd2avgy0IS7ubRJ0SOmPf1XVfKflLLnTPMJdmvGHOBKbnYKcXYGN2XTx3E?=
 =?us-ascii?Q?MjjI3SHrt8SaPDSofZoC4k4X6vmIHE9PkzOjA7K//1u5wFmHdiGJt7acc2Xh?=
 =?us-ascii?Q?lROHnG1D+9WVJTtXToMR3GBquOvKEbGEwE0YBID9SwR0mxo270DV6djqDhKZ?=
 =?us-ascii?Q?cOOm00uww5YrqdC+JDl+oyTaP0eECCLqPWIodyRZzPTxqoNlRv7yXU7zB6G1?=
 =?us-ascii?Q?RJwc1HyLN68OXdFYC+9xFerj33/4hfpLKBKHUDu2l5CFOyXWyx+nY7cndKu1?=
 =?us-ascii?Q?WcIiJE09HEc1kfPd97sDI+KEda9wpzHs0px1RZwmB6uto/biZb6clXpt7UUK?=
 =?us-ascii?Q?97GcwSOGXAxIq5VRkLpUBccWr0okD1BrDdXyalBETM0WUJ2/Qssc/e19pxIf?=
 =?us-ascii?Q?l1A9SnEKf2Z0as2nWd9seEnJsnk6eLjbSDy6Chc5Es2aOPW+K4AqOnT8a1m4?=
 =?us-ascii?Q?kamlMA4fQw7PNoO9JgWlpWIOaeRJHo3s37rCUT4i+kT3CKK/uX9JajidyC3k?=
 =?us-ascii?Q?1xYJ2FyiyqLnXml9btnP556Rt8vOTsetiODsZr61x/sDn4IflQgM5WKH9ZpB?=
 =?us-ascii?Q?olbUm6bs/fQlOc4Ntm7erKTKL0oV9siDGkvLMkgTiTjp428yYNs2fW32SI47?=
 =?us-ascii?Q?+RA1QVbODtAV4ZpzPIVcKhYCu5EOxrj0b2fhvw3SObJnTGW8Po7Fjm5DDlji?=
 =?us-ascii?Q?/jFJFwoHO1L2i3iU0WMIXMnPnp0trqYOUwKx2lcS9NUHmK5JYzjPDHqwD2MY?=
 =?us-ascii?Q?xhp1YJiAE0fjnL/VhE27ybAJ+MvkLhuI3dkgzzvjjzaZaQQerwtj5O8Tw742?=
 =?us-ascii?Q?hBDCGUxZLLr83ik+NIUYujqXNcY=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33a3056-2fe7-455e-1738-08d9e12cb1fe
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:33:53.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+4Irt8mXKqmvoYzdf1I+b24ZYe3ddeFQ2g7BUFSY3xF/1p5hRhw6VH1PSZQDveXNi256ftvgnRvnX09GjSJ99iMjV0OvUQ6UPP4YpthRbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6084
X-Proofpoint-GUID: 3a59LMF847sjdTpjGAsLrJE2Tg7s-0vD
X-Proofpoint-ORIG-GUID: 3a59LMF847sjdTpjGAsLrJE2Tg7s-0vD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new microchip,synclko-disable property which can be
specified to disable the reference clock output from the device if not
required by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml          | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 84985f53bffd..184152087b60 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -42,6 +42,12 @@ properties:
     description:
       Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
 
+  microchip,synclko-disable:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set if the output SYNCLKO clock should be disabled. Do not mix with
+      microchip,synclko-125.
+
 required:
   - compatible
   - reg
-- 
2.31.1

