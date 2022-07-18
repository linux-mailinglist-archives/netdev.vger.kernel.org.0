Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F855577AEE
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiGRG2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiGRG2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:28:24 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80051.outbound.protection.outlook.com [40.107.8.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5242120BA;
        Sun, 17 Jul 2022 23:28:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CP3NbRej4vT7Gl/QGdltV0Ep4fvon1sS6TOrlOOKGJhGtU0o/ziGdb8HAYz1BS6HiLAShq/oyNArkcpHK1GumaWSFlV4DLLxXPImxVyc3JOPrJx199dGOmZDNLQao3++ylhPgOcgbjJ6BPySsH0qGnqg7fOXg3cGTbNYzZvg+NajGlrd80ppt18/DhOgMC3oWsKxM1vkxasV0djN40F2YfI3ZBuR5DEX2+0uV1l5l2I80Fc0HusF7lhdLdz9g4+JZ368ksy105lQ9gAv1iIUWigAKUfdJqAeIy2iAZewaZwmpXVOKZIgIsDhlSY+D1WACdb28iUzVQ8mgvjAEtmU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWodQCwtmR6m39POvQspnIAjFrg0jKRrIc/hOC9Ql/E=;
 b=AKnjN98muBQVYZ/FecbcgHWvQ5qfCASuMVlYfbKtqg2tUW5XANsCMMo75QIEC2Lbjr9+flKH/h2p6k+S96CQI1YXfdEjepL3pdG63uXAoMvLRnJgBWzRf1J3mOehoYNbk0t0jAH8PZ9qAZPPvSyYqlc+T5IoDGgFsDnuhmsEBqXv0ZKlFdP38ycIWXl+YePGJlZt8mWiUEvzcSkTQ6MRp1TXOdRnaLaaVblOMdi1giJvCZymKmVDRxPwuaTa7A7PBLWk2jSfc1TnVphSqOxtp48u3IV2FpcLB/VLvJnKQRqG8xDDAGocqchT4ti2TBzwQ9GRbC+fblk7UD/rZ7F50A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWodQCwtmR6m39POvQspnIAjFrg0jKRrIc/hOC9Ql/E=;
 b=GnJvHeioQTVXAEzBLcRFVJ3cfeCSD9y/PT0z+/ukuB8F4cVuN5FEv55AO53oQ2AgL6pysmroZjlW7Z0/ELYHC4A3UDJj1L1L2H+DuBCTdx0a8iFdujTTMaRo9SNUZaaq8IwFx4fwE+q48rmKOPtgjMQbO7TNsAV+zD/0NbY4do0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AS8PR04MB7704.eurprd04.prod.outlook.com (2603:10a6:20b:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 06:28:21 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 06:28:21 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V3 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Date:   Tue, 19 Jul 2022 00:22:55 +1000
Message-Id: <20220718142257.556248-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718142257.556248-1-wei.fang@nxp.com>
References: <20220718142257.556248-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KL1PR01CA0118.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::34) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7d72ba7-c2b2-4311-dfe2-08da6886b5e6
X-MS-TrafficTypeDiagnostic: AS8PR04MB7704:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pd3d0Rzfcl8rhI2n56ENDq1vC4QV7KrmzDRWAARn0kvOltleOiJkMf2gUhBjR20qSs75iJDp7uggZbanVIetsnYetQsUbwvbkaebqijAO6p3g4qhBbLvJgaWhYBG1V+8EexAne6U17nOtsD4KJqieeJFR6AL1+fb33LiDDYNg90HrwK58YIn0izGctCDh7uSwyPIB56ymHs+dvIQQPmK8G65TdGTahDLGSVST+y9ImPuRDe4S8P7Tx8ZDiSwZyGP9kdtKXy1l4cVCY9/dfrJSHcEEmv29hr1W4oNGJ5JwmKvd+VeabTKp+4dzME1szqAkWG/LHMKCLtcTsPDZDz8p/OjTh8MPWuUDNnkK+SMsDmtqyGZyFkBsbVFmloRjiT5iE3A1dLdVz16+pC2GOutvJbDskgwg85uWi5sJxDlbBg404guTWVL9QfNGNI69JIIHkjrrc6VMTPnEk7+GOhsbwSJIn7rXVuDaCggr24T+a7xmLeJ5bIOJjzRniprIJrHuhXsh1qpbyCtHy8Ppy6a/EyTU5r29D4K42ei4yFZFADPIaVs1YNctgqRvsGMMTOk/XePwd5DKKyHz5I4gZRxQkT20snlv2Lo9XYfq2qMUC8hFLDLvgLFDDkPDrDCq3IKNg3mgVE4C/SiY6kqaaj4MbilvuY515SqM+jmRv4aT05bzhLeAwcI1p5OEUnGFe4pRfcgw/4k+kFwlQVd4z4lYbVZ3T4kkb66Y0qVoHqO2KvgRsuQKr5FMtlBWLyU+xloYehy7mX/JV9G7dwvu3S8gt5OG8IKM5kervXUipZNOZJGM5r/wEXZz4B6sdwRB0H5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(6512007)(4744005)(9686003)(186003)(26005)(41300700001)(6666004)(2906002)(86362001)(52116002)(6506007)(478600001)(1076003)(6486002)(7416002)(2616005)(5660300002)(8936002)(38100700002)(38350700002)(316002)(36756003)(66476007)(66556008)(66946007)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5dlDuicB05sA+XAnyotoz19Ky7MRhDNMUAx4LukekM9iGqoldaYLEfEWUYkr?=
 =?us-ascii?Q?OGlErUjqqzeadD3bwDj4Ppr+15cEA3dztkMhFOhHEciSvT+0HUcdFgp6Nq1c?=
 =?us-ascii?Q?1ZDTiyIb+U05dqUUw1mOy2ptfefRFb4r7GVz6Tut1FgkLCgKPTrtBy3++rft?=
 =?us-ascii?Q?rqQgvMyx5Qw5ZIGMxIKWi8mAZ8yEUOS2wv9oE1/kP8SHCTZi04TtXoJGJYDJ?=
 =?us-ascii?Q?Q9s7tNkE2F3AC5N2jT89SlpRUJ1aZEbP4JQexgM8Bb4jKijhEyzVb14h031t?=
 =?us-ascii?Q?HekPuUURTo+JKtAHzQDQPiehU8sfj5Cz3ioDdDFA6utA2FZVBhLn57xqcdzJ?=
 =?us-ascii?Q?D+ncvaJcMKpGjfCVR3kQzSDQWecrFbdQpxImxtOOPJ2+Vj07wvnulYz0sEvV?=
 =?us-ascii?Q?QtDMK8K0/S4xtyhWjN8kBNHZf4pYjf+4rtqn2NP3GGyps1KG+hs03FCIYntd?=
 =?us-ascii?Q?eh4lv7SO4ah3fJQ8hwMzjDo0+QW4dFkgmHKSbn9IW+YRXKXgyXCweVMxiQN5?=
 =?us-ascii?Q?EUwlfIOmmHooE0IcpK2/m0nQWlDx8CbrfYUQS4xibWv/KATqc+bbfKxi0MIR?=
 =?us-ascii?Q?+xfLhUZCdbPLoALWfqOIwvEOb4IEhABNp3bSq7EbBJ5TXZnr7yRsWiTCC44F?=
 =?us-ascii?Q?AyS1QGOHw1vO/T53zWjzPOP8upYqB5DjM7vrlyqHdwydgzM8YOXzmZ3IsiBu?=
 =?us-ascii?Q?LgkIOUxG8nIxByCEWLxZekWq0Lca36Z8I06qozE5KPOjI/KSMV8z/ZId9itk?=
 =?us-ascii?Q?C9cnAVj5QJwAkc+hmgi5CaCVft617O/SyBjrB3QPjPEarE4QqYw9Ae3CkVmY?=
 =?us-ascii?Q?4MvdRkIIGJigRbYPbsA++uCa260vuCfrjqfdOKzpH/S6cQu+Wxnvf0jC5PfU?=
 =?us-ascii?Q?I1DqsZVwiOCOor8tT8aypOB4CwYURiRoVvLuOGyvV7pzhKbM89vyDJagKLU1?=
 =?us-ascii?Q?xORhMpWVnL/+INBTVAkppa/2XGUVVd1mtFialsJaG7rR+3efVcUBlQjgN+AJ?=
 =?us-ascii?Q?9IFVZTa+pHZ4vRE12Nd50A/P7K9nz5uy5f2p1h9jtJzIw91uCTK88Rq4DRVa?=
 =?us-ascii?Q?hENlMjkAZTNt7w9iRE8mLZPkgE/HCAQUTBCjfRMkcD2I6RCgmhmxOAR3sHh8?=
 =?us-ascii?Q?DcMAbCixvs5MSKwhdpCt/KjrDdAPCEv2YxZSjs6KPfxf2tSqbA/aYnIAEosG?=
 =?us-ascii?Q?KIoJexmJ+dzab7lKLVFAKt+9BEsgMtHqDA1BIMpjW8HWr+nhqeoE0BWafgMK?=
 =?us-ascii?Q?VqtqKKPQsNgUzDsUnKXUmQXGrKuC87JuHJRXn4EPDEt3pGj/n/BiATMoE0JY?=
 =?us-ascii?Q?CFIz6sriJWqHI0Fp2zYfd2KfVTGn+t+BgsODkzS9TCWWMbqG3DVNvd0E4/W3?=
 =?us-ascii?Q?XNdsxUbo+i93q7yBWaJMXeu2ybRFI7wKR5mupgV7EOPELIFxIOw89cif9Bqv?=
 =?us-ascii?Q?LmToyWzEBoD5aFqHGx03Ak1JvtjCSRBZbkgJbg1gA+875fIOVhTRh+CJ0UQT?=
 =?us-ascii?Q?NZk6zfif51xx97Y1EO3m4HAAbsCBd0T0OgiWT9F1X6O3uX7V4b2kh8TKXWwY?=
 =?us-ascii?Q?oAIF2BVzKyD4Yck1B8bEkiWW+/TCWDOODTeeTLCB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7d72ba7-c2b2-4311-dfe2-08da6886b5e6
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 06:28:21.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67CdMOmwpFpOFuKASNR/jCwZwnxaTGeuv170QDIbpw96ak8zFb6hzJ6D5t45bed9cjiixArselwo77UKtTWvDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7704
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add fsl,imx8ulp-fec for i.MX8ULP platform.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Add fsl,imx6q-fec
V3 change:
No change.
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..4d2454ade3b6 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,11 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8ulp-fec
+          - const: fsl,imx6ul-fec
+          - const: fsl,imx6q-fec
 
   reg:
     maxItems: 1
-- 
2.25.1

