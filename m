Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B605ADADE
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiIEVZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 17:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiIEVZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 17:25:45 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140087.outbound.protection.outlook.com [40.107.14.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C75432A89;
        Mon,  5 Sep 2022 14:25:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU5Pb7ofg/X0vBbsyoRMUioc4ASWA13GfIqRSe8LxRwtqU6r7NnA9/g335yQ+B/gxnFtyoVRsNTT5f0Cgrz2UQM5fmYVS8NXW0L4Z8QfjMhFpftYYtvMlw8IX838sqDaxzs1phcQfH/DZ5LtceVabb09hRhASz9SpdHd98JfkjBMm3vZpNn26+t7452/uKEQQfHa4yQd7JIceLSCT730B8YL4mZdDlKR4XMdme+9K/C1+/L4zuz5vrMkI3UPpJF9g8kMV8sa3RtcSTwGNsOY13oR6Bv07HQUdpUU20rebkfEKjlBLIdOZYebOfCGboAHqy+i4KvUx4qHjnBeET4xxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txUxmT44D2yEzSGyCrkjrRPchUYgcQ7NlSNL9uTQCcU=;
 b=CVM9raee4EsUsd9xaTv+/6dg0DzTV9NOZRcjdqJ8DPAMo6qU7BuBsQhLJgGFfy4fvj6uR3hTeDX936ZRIKobrXXwo+m+5rA9XNMVt2ii+P66tgyZmCuU9Q9akGUuNoUc3KDbh95HMCt9u7Yq0rEa9lym/QNk9LE9kaqxTWaaLjxSQ121xKR1MnCFjHkBJfFJudQ/SKUZlpJR82XK7mU39Wdav9CJq8/0frgXuL6P6IsFvDHAFlniQJunKO5f+ZsJ2dkl8yAh1J4oBrR5kyn19au6ToRTbE//Bkmf5Un2C3+iLgeau1NFY0g9uXu0az1Mk+r1LLN9vGWwR99fIdDKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txUxmT44D2yEzSGyCrkjrRPchUYgcQ7NlSNL9uTQCcU=;
 b=XgTu1CAnaw6o+uWkLP4P4z97YZGyawarNPEeRwyo5x1nxXx6C45yNKKpPxih71BmJKUJIQ9r6dyBXN6dILNhWLBzV9z3kYW5STlKJZrEf05BPsVQOK609weU7UB3iaevR7f4OVplCTuIaOobyTLM5Ytji/VZZ2mA/OobD4qw4R8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5020.eurprd04.prod.outlook.com (2603:10a6:10:21::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 21:25:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 21:25:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet aliases
Date:   Tue,  6 Sep 2022 00:24:58 +0300
Message-Id: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0036.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da8a36c0-a548-4d29-c9dc-08da8f851e27
X-MS-TrafficTypeDiagnostic: DB7PR04MB5020:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KlUZOSDDyCORyIfYm5X7q/mcH1uLBzjURghkjiZN3NtJjmyu5r8QlbQePYahQDPnTvGV9QgUx9hMiB8jl3qtREoO8FbaaPKyEiHmyGCJOVbp94X13UyKSt2Jb4/spgoWC6OMMvJOfta5qzYSLBYg4rJmN6vnpsFJzfrwMa4pQVSagKiGgvdFaG8cVXxHP9qy339pS7cmqBb3CBSXJYz8QrVjaCEsyayFgCQeNotdMWaiQQWD350dq0x+Wv6LUaSD3uKPJj2ivwiO17YrmXr6lpngDE3x4f105djR2oiQgtXwkQdGRIdwVo0Bq29LlQwC7mKMgJ6LeY9W/muWvGalzUck/QSSx+zP/lbWetV6gmQXOb2CZt9jypzPaynFE6rWswaKeX+mc3+dOPl3XiS3SI9IzIHhEp5Bz1hh812jR8w3dti2Ow1SoeUZ+ehe3yVK1Tu2Sd98435KtxqL+DORepzrANaBjx+U+1t9/9sHDJlLUI5z2fE9FkHrbDHfwDEmLdeLf5OCf0LXedYMlYbOYxck+uWq6S98/HxMgcw5shzh+9+RSegft4voGYGYdhrjKys6Ny+INE9/lEysaXlpvOR5Pl3iIS77zJ5QpQyries/3XjyVLaKsSwR0a+9qxa+9JQtDpyHjUTVm1PfoYODd+YS500cx9vYH296XjXzHdU7vrvFJEjRnNLwPCJAJ2b6J1NQksx3bDztnF4RxcmaroGuFl44azKEnQx1xvmvrsrQiePP+IepCluR6bo1pFJE3X+eZKY5hoZyvxOHxvSN32DvSzdpNvetTdLLBOsU1UAFA5dxxrTxNIIzruRPprSw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(26005)(316002)(6916009)(54906003)(66556008)(36756003)(44832011)(5660300002)(2906002)(8676002)(8936002)(66946007)(66476007)(4326008)(478600001)(41300700001)(6506007)(1076003)(2616005)(186003)(38350700002)(83380400001)(6512007)(6666004)(6486002)(86362001)(52116002)(38100700002)(414714003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dHO03HSZ8luKYW8KtA9SGufsZzE6WQEZvR8F+z0aT03jeDZUW5jJY6sRd8g0?=
 =?us-ascii?Q?Yr7HM++VvCgV81lbHSQPE2/dsjsCR6lifcM6Iae1fLhyuKgqw2VD5PVMihaX?=
 =?us-ascii?Q?I1n5acfuux/0ejBdJliX2AQW508aDDU5GZMSZBB9AFjQ0Krk1Ui48XPqDdcH?=
 =?us-ascii?Q?SWU2LXuouzOEZCI0PS49dk20VNfCD5ObhzkjNdhSOwo33vHVnXkinvreSaTQ?=
 =?us-ascii?Q?/viich7VsckbKSrRy14VaN/W3wUNK2MMheTxMZrXfMaPRScd56qlueH8asBv?=
 =?us-ascii?Q?voFU/NQr512wgC5V6n8UqHLDfA8TwSUfMSxEsfGdTMq40SIm9RCPH96h3JHG?=
 =?us-ascii?Q?fO8qwpJ3KMqWXgy+S6zHxekNjIIS5uwcDUP93NT4BjBjF+tP18BSstD0lx9k?=
 =?us-ascii?Q?zFo/lLIQp5nVFxAvc5ESi4N8yCrfcBECTYWgGq9aWaazPV/1qsfsmMr+x5kz?=
 =?us-ascii?Q?IAPPZRH9wRn7ffty7wVmyDlDONw1Wy/qhRjMeW1Reu092FRrlslKxxoCYuSL?=
 =?us-ascii?Q?SP+4NwaKHm/6gU6EfndkBKEiIK2CGrfLy0Od5kt1psQiVh/+seO+hdcSCWN0?=
 =?us-ascii?Q?q6/wS+LVLtnONHEt5DfnQvcfJcPX+I1bMAactF0uYxKIJ9SBS+lfHBP5+mhs?=
 =?us-ascii?Q?KLf6hQr4PuoLr9S58e68yR3hDugtUTjlSc3+MUba+UMnyQic+tyaiL+RGOUY?=
 =?us-ascii?Q?80TsrvxAu3TD89MaCXVGoCFrZ3aRFm2kAwO1LsxmLk7Nxvo46fxkfOABwxzS?=
 =?us-ascii?Q?KugVEfoLJFejQWCJxZybrhaDBkop0ecRo98PacJYx3ea+aJURLUmsJXnaPYs?=
 =?us-ascii?Q?dKFVKLY37LMNxh0j7YbS4vm3Y6gwIweKRAFjX2Grqj6yrhPGtpRfUioTxQP+?=
 =?us-ascii?Q?hQFqAYkRiQv8HnQenFE/FnYDz5p2BZI673a0Dn3QKgIzISZ83yugu3SgGYN/?=
 =?us-ascii?Q?zdwjtNyJdyNpFfKcvEjWEU2VfIXmM6tWGswHr1fvqw3LJuite9knIWSEwMh5?=
 =?us-ascii?Q?NVRK5S26vIP5qwNGShx1u/ZaMe4fY9++y6KNN32+HJMmmL4IPb9XGDF9lBQR?=
 =?us-ascii?Q?MjY7duUpc28UJSgUmMnqv6mk24nYlPrlkJtttzWxsN0RTbocVTFVJtlPLdeW?=
 =?us-ascii?Q?N7WA0rMx5YH3E7Jy20hr4gO0TNmtUvCbnZXIJT8N+kaSUpypYYlW8XPmGv2L?=
 =?us-ascii?Q?OYh096hZfc3Ou8YjgGdyrT9cEXWW/BLjqm9oiXYnn57Rj4XiiNC7mpkR5F27?=
 =?us-ascii?Q?aj6bvC2YaLCEqxxNEtcK/C5ZLh22AS/oKBc6XM7/qIIW4MhEdTV1IxEu2fyf?=
 =?us-ascii?Q?QUs0H4uIUrXxMVk3XGYH7RnAtSIXdhYEJHqLayi0ppWejdJgwRmrzv2jDCvr?=
 =?us-ascii?Q?ODnGSvbCVEgagQE7ElQFq/k+v9Q3Lpz4kBSjcptN59mqTu43Ty+nX034bk++?=
 =?us-ascii?Q?ThLy7Kzc+TpKhta/B54jGoQ0PJE+ZoXah+c+AxkIZaOdn6XF0VwQBShB7Amb?=
 =?us-ascii?Q?qw3It5FqctsD8678HfL6j+kFU67bXFcW7elTO+CiHJJL6w2f5UgY6eVMtJ91?=
 =?us-ascii?Q?AV4Bw2+d9pxA8sKxobf+mcd7I+Yr0McXScx4M6aPhEAamYBsuQUNHQnlpGhA?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8a36c0-a548-4d29-c9dc-08da8f851e27
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 21:25:12.7567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/h/eyVSsdOIGngHw1HLzEbAE+gOTxoKRvZ/ITMH1moTbYXCc8V+Hw9KjdxArUCtHHdOA6yM/K5algSxojCZtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5020
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit "arm64: dts: ls1028a: enable swp5 and eno3 for all boards" which
Shawn declared as applied, but for which I can't find a sha1sum, has
enabled a new Ethernet port on the LS1028A-RDB (&enetc_port3), but
U-Boot, which passes a MAC address to Linux' device tree through the
/aliases node, fails to do this for this newly enabled port.

Fix that by adding more ethernet aliases in the only
backwards-compatible way possible: at the end of the current list.

And since it is possible to very easily convert either swp4 or swp5 to
DSA user ports now (which have a MAC address of their own), using these
U-Boot commands:

=> fdt addr $fdt_addr_r
=> fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet

it would be good if those DSA user ports (swp4, swp5) gained a valid MAC
address from U-Boot as well. In order for that to work properly,
provision two more ethernet aliases for &mscc_felix_port{4,5} as well.

The resulting ordering is slightly unusual, but to me looks more natural
than eno0, eno2, swp0, swp1, swp2, swp3, eno3, swp4, swp5.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index e33725c60169..ecd2c1ea177f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -29,6 +29,9 @@ aliases {
 		ethernet3 = &mscc_felix_port1;
 		ethernet4 = &mscc_felix_port2;
 		ethernet5 = &mscc_felix_port3;
+		ethernet6 = &mscc_felix_port4;
+		ethernet7 = &mscc_felix_port5;
+		ethernet8 = &enetc_port3;
 	};
 
 	chosen {
-- 
2.34.1

