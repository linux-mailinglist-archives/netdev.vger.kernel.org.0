Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4950E598544
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245637AbiHROF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245679AbiHROFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:05:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC9D6F542;
        Thu, 18 Aug 2022 07:05:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MP7fUAH66+hgueKKShMGw7OdyOYAPSKXOynJp8xWT18IGisGlhNJZKhppyfXJ550in6vhTpbltmp/dndSw0xaU1qlDbpYoJZub/h3E9iczCJ48cNeQ4Lo/ITpqNXONjkpUBJ5ISFqhPQN88ZNG85ofCcNHIyzYJ7H6xZKL77n+942bU1f5OKIzKtNmSnF/xD7zcYGAVtz2Z0B6id2bI/MKmVnWrdMqVkWgUahLohrZWS7LSIC4v5d52hnIXzSKS1Vpg5ZaV1XpQwv2YE4OTUq18aXh590E+yauXdAcuLbYIVyrtw7LqYKUbVQjzp2iXA65Fv4Ccml2XAFjALAGYNLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Y1MAcHTRnfs9Ui3VtanLTgL+zR0cv/sbGbPiFMBiRk=;
 b=bUks0rfyBWkcNaVnpBQqaxF/OrshZV2ErCJdhXFdxHzumGgNwJXGBSAsQRJm9EckAtHxjmHSlaQrYgdQl5pePjFhVilgLpSXZh1WoggB86FIm7spd0kBVn7uiCJ+tmybUEKKtq6xQ9W7xXIavb/mghUBBL9v8yCSXTLdjrrNVDATtjfvem3E3WjqnZ+qMq09kZSH1gOc0RZlrf8bepwuFXFBCJK1xnt7I2dwsMf4+nfML9xoiqpryvhdK+zW2UgoxIrVhcjFOSstXSe3beeYQtRSpQFc0kqv8BPkbFT62sprnHPka0IR+VosAYoKE7xeA/sh4xenoqs1RBlMAgkI/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y1MAcHTRnfs9Ui3VtanLTgL+zR0cv/sbGbPiFMBiRk=;
 b=Qb4GPV2vJ83xRTPkjYx4uPOo0AaIx0NQoEaWcSMfDDB1tWVMVUKbEey5CtwMOU31DGA2hfEr6HQ3FAZTFmvT8e7rvLcGbgoXJOlIVcDZeAdI/qUeOAkLv0sTJylr4XLghncHeXQv4Iy7qbiVY2rCEabSfO3yCWQJ752jWTOslwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3883.eurprd04.prod.outlook.com (2603:10a6:8:e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 14:05:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:05:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH devicetree 1/3] arm64: dts: ls1028a: move DSA CPU port property to the common SoC dtsi
Date:   Thu, 18 Aug 2022 17:05:17 +0300
Message-Id: <20220818140519.2767771-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21635f09-d9b4-401d-6153-08da8122ba3e
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkbSvBA/PwXT/nYd0DhbNhgj6pYKxNz7svITJwEnJj0INo9X9sfUH5WgOKgzJK6NH5yZf525AvO4rwIJYkEWWFJJ7pUa49DVw4hKVnBKpzNvGnbHJagnVsBtT/tuGgNoBoLngEpdArGrPOhKB/G/Zdg4ZhyRjbX7drKl0lNVSDmBjDohnoPUpHCnB6UaUuyb9JoA1HIHcHV78+wpvDTwaQXhONsAuo75SlJkidgs+iwzu7MqfdN1SSz6MlF2oHgoAUxlzGmB62sK7a4/3wVgJmeUfmEPzzgAbwWlh7K3GlP23WdHmoubZEZh+mpfY1cP8WdIVxnxaGUGaHg4NLyimVkpb6fgrwcCk6WiGDkjWru2NQ3gWbLBgerWyfbS50PczKPkKkt80MVRWuy0N1yNAcXDEXxLq5IF6M6d5pSt7o75/71JYsyJ/90PjzbmZ1VSaZVzG2UNrc3dhK5ZABxW5XVFKx7jJfiqbERX+X8Z5fDHjGux+8D60V9z+WXfVPHkR/Ro6dJCTqih87em45wtYjokWpACt/2IddJWkxCLX261jOIJzTS0uGq90buUSopMyAHVikiqIKnBkD88+mMtSANrDyU8MmqB9YOd9TeqaxD77rfQNcVaM1VGZ0SxxvBa5QzKoAnxEJAuLYk4AH+c+XjD3ttMvbLQcF1r9XuBXsO8dF7gGXqKJmtjoM9HcER2uQOSHvEkb/GF6qubnLEO23pl2s4WZSBISISE3Pf6wnXdAhJsZHfuVo5+FkQkzgAT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(66476007)(66946007)(5660300002)(44832011)(8936002)(4326008)(8676002)(6916009)(54906003)(86362001)(316002)(38100700002)(38350700002)(66556008)(2906002)(36756003)(478600001)(6666004)(6486002)(41300700001)(83380400001)(26005)(52116002)(6512007)(6506007)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iJ24JeqOqT66yPPAcv38+T7mJqfJA4sDKThWGMVSNz2K+DyXf0fUKhkc5F/P?=
 =?us-ascii?Q?c0odYLOd99lI7SnyLfzgcTCp2NS6ioE9zgcocTLko3M1X8m2PZtfsrTt004a?=
 =?us-ascii?Q?y3oOSkMV57xyXuLDwPq7uR34SLdMF7xT2/BWRcmgGFitTEntw1xAyUUYcc4p?=
 =?us-ascii?Q?/2xiOSSpPsiGoiEQBZnU8qJLY1yfOJiBCVX4PrRPlnKtJNpekbwo0ZTUoGvE?=
 =?us-ascii?Q?plXRI2l7NP0qxgRcS6u3bQ1FToBr8H3O89x4dDYrFgZSDJWj7dO3s2uhokD0?=
 =?us-ascii?Q?jVfZVqD1wVDwvE7nRk0ZcR5vaCkN/3pQPlDnHnz8fJmJuUVFhhyCYUE+WG/F?=
 =?us-ascii?Q?PyIvvgXo2tz0RqmZPZ4XaWaCCnFXu1Wr4atZzhRHI8wZGADvKaFqnT3DuUhx?=
 =?us-ascii?Q?D1qsVGFA1iyFSuHHQ2ealvpuzw5DtzO6XJM56PC7GtzHpg7MnyFoOdn8kYUh?=
 =?us-ascii?Q?PlO4n3obxhhqlyGeTvLf4nNpRvgeiezxZud1fPGQ0ERailjgN+HdVyL9QprO?=
 =?us-ascii?Q?MNvgsYUZB113ZMV/RA0pi8wc3vzbACHEobAYjNZdBOeEnUwOGuSHOZ+cZwKj?=
 =?us-ascii?Q?9rSGwqJqXqGuo67mz+xM2X+zWOfiWcqwztsPW2EKK2mmMLh5+6lb9DpVuOXu?=
 =?us-ascii?Q?NU6THquNA066G+D/eExL1XOADur5G1uRVkI/fJ486cZfpg+rQdeSgJIKur7H?=
 =?us-ascii?Q?ymbZVIgtdwTTOz6iy/kn+Xm0sMOoYbxhsHyH7yL0m3On1oeUyNdlPBBwbAG4?=
 =?us-ascii?Q?8q6gKgp3MMOPxwx2Hr2Xr/kYmxhe68V4zkTzVXRbnT8atK407mNQdVzus4pU?=
 =?us-ascii?Q?VRCOC56/9KACHOBwKgfQheJpss+gGKAGv9fNSYi5iSptlDvRftYJxoX9zRd/?=
 =?us-ascii?Q?sNM1xmWECKXEFxwbEH3l3o8VQOk1FC+ZxOyuVF67Cn2qL74oqrvU2JkjVcj+?=
 =?us-ascii?Q?JksVYSe5BL3kaJg3fBcsyxRgNFooD1WFVU2ZKz5J3sDgWg1fech0LiKBu++W?=
 =?us-ascii?Q?IaMXBcE2mi4R3St6/1fsIF6R32EeZiLrq1oiKWVaimvEyubOs90m+V1vah9B?=
 =?us-ascii?Q?ptMailt+/3sh1174K/4LLIirUvPoXFIX4gGxHIBPfC+/RBNZtYGfkYHke55Z?=
 =?us-ascii?Q?4kFuNu2W13za0pep2jkdJFZwcdo74BwmaUHB+oeJgQDvlGA6Er+v7onZI33i?=
 =?us-ascii?Q?jEEXnXKNZc09Jdg6Z7rB/A2W+PGqZsnBorjEwbUgsaCyiOJQRYlJTSbLX5cC?=
 =?us-ascii?Q?zjl45HJ7gCf3S4gSc/1691/x8jugLGL7G/nLSqIO4pP29sZLiXJDqouHUfT2?=
 =?us-ascii?Q?t5FEcBMtnL8mu2OsvjYiW2qc6hjNnurTTSJei7o8ARa/kIYvv3KnLVj8XggM?=
 =?us-ascii?Q?EciZ+9x6C5TmhZBFqo/idBF+xzEw1tKzX5hgfnG6PBCZ8ouULQYLVPhJn6sL?=
 =?us-ascii?Q?75MTzL1rntKR9D9mM9mna1JvNZJRV7eV4rzXiMaPBmNhMZzWfbh8eP2mY6B3?=
 =?us-ascii?Q?R+ThTadCZVh/aiHb+xAyAHnIKklBmwSPFrGyhlBS8qY/VZwnkoQMYnCqs0FZ?=
 =?us-ascii?Q?Fago+UOZnB97mtqOb56gca0tVdUr+Osug8ok1KC/SATuVi/jie9KngodMaau?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21635f09-d9b4-401d-6153-08da8122ba3e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 14:05:38.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5XRUJPqKURkZ4paP9SANqOIpl827yKtjOllHpmH4EFsm4TCXW+nzGeJ/hbmxhaEVaMcQjQ6asYaqJF0N/5d5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the CPU port 4 of the switch is hardwired inside the SoC to go to
the enetc port 2, this shouldn't be something that the board files need
to set (but whether that CPU port is used or not is another discussion).

So move the DSA "ethernet" property to the common dtsi.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts     | 1 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts  | 1 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts                | 1 -
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                   | 1 +
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
index 6b575efd84a7..52ef2e8e5492 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
@@ -104,7 +104,6 @@ &mscc_felix_port3 {
 };
 
 &mscc_felix_port4 {
-	ethernet = <&enetc_port2>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index 330e34f933a3..37c20cb6c152 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -60,6 +60,5 @@ &mscc_felix_port1 {
 };
 
 &mscc_felix_port4 {
-	ethernet = <&enetc_port2>;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index e0cd1516d05b..7285bdcf2302 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -278,7 +278,6 @@ &mscc_felix_port3 {
 };
 
 &mscc_felix_port4 {
-	ethernet = <&enetc_port2>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 5627dd7734f3..3da105119d82 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1157,6 +1157,7 @@ mscc_felix_port4: port@4 {
 						reg = <4>;
 						phy-mode = "internal";
 						status = "disabled";
+						ethernet = <&enetc_port2>;
 
 						fixed-link {
 							speed = <2500>;
-- 
2.34.1

