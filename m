Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125BA587D70
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiHBNuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbiHBNug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:50:36 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2612250F;
        Tue,  2 Aug 2022 06:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/68eaU/GXboxtEoITwivodFAKWlcafB0n3nqgIBKn+em/wJ6lTYHoREQGasU25EH3a82P/SRz0DQsRy7MxsY4YQo0VDOKOAKVctrHSxatuXTXH4GPVcjoD2KKA28MjvKzXG4InAQNHYePNrZe06mo7L2wEYbV28ze/9UtnhmNzfXIAY8UGcfp+Z8AGhXkUyIruLPkqTfLGLSV9yxV7AEB+R21Z3TdFZyol68hSiQvqOVwe7s2xWinwuNr6jX0TP8qh5FUeQ6/qNFdPcd2iQ4U+sZYrgTn/KrwWcB++9ju1UMZqgBQuuDmjbvSb/L5K97GeNXgiNAewri1R8Vfg2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSXM4xD5r1LdQIQmg6JcnNAucqsplspvTsOeIB5A118=;
 b=TOqUm6jkDBParX6BVcrIhTPSuIkpq4LNn3UlPu6Yc/U3tDseYTNa9BPqwyPTIk1q1rvAFvIjxavo5XmfpeEs6yVfL/Rvgyl2PZ2nT9m0zd7gd2OFRvEmUicF0ttKR/tO3ClsM5PKPfQOqbWiv4Oo8O/y+jKqPPrJJEhNgpzNjHLKRnv7HGR2StuZA48lXXegFHD/Gv5pHzdYZrbk0nuYmbaq8TIj7Exuwabh/LRMY/VWfSofqsCHKr6sKMwA27RvG2JrFPHOlZ7AAnXO0EXDzJpFX7wuUrhCzfVaRuxffqdEJHin57KwUl9yzV3AuhqUGl6ptw0rJ6EBdvmKXID41g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSXM4xD5r1LdQIQmg6JcnNAucqsplspvTsOeIB5A118=;
 b=J/s2N73dgzYkewW0QslBvCCepehXtADjUgFdyfggB6pWgkdWiGiKP1mIkEa0nFsVjVgNZrKjVmxPppFVrzGInr6gcfGqQ2DKSvNhZXuY8irZ2QOp9sXRp2p4AdigZXMxeuyzV02VXi6TfhylMnXGzRcF1fNtrbve/zv2ZOl3pa8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9126.eurprd04.prod.outlook.com (2603:10a6:20b:449::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Tue, 2 Aug
 2022 13:50:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 13:50:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] arm64: dts: ls1028a-qds-65bb: don't use in-band autoneg for 2500base-x
Date:   Tue,  2 Aug 2022 16:50:06 +0300
Message-Id: <20220802135006.4184820-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9223d023-0af3-4256-9dc6-08da748df786
X-MS-TrafficTypeDiagnostic: AS8PR04MB9126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YrLkWHF06SEZkJM5sJhbSiit83j3hd0nTGP0t1r9NOWo/CzP6lserunolctWr4+icCI23gXoV60TC9nB8o39stXEpmPrabfX39UKk6cXPL8piSWu7CNkJvyr9JJOcYbMd82TCKABxS3U2zg9k+NDCKBidHUVIAQdPNg8kY8Kh6/kSTDVgBScgbtrBkKxPIcJcS/VTgi+rxoqttyt3JKrT/ii4iUIGTOTY/eFV0tF/7LIoxKvLPmcGN164EOypaUpKOgEX5SuyEp6+NoM1KEDezFPkNfeLaAI0vmW8EAntLDuJBimRGlANz1/3EdoQqLe76/WnMf+Q9HXfCkUrfcJadvm7Rt02J39RS2d1nz4xt+2VqEl9ihgFwg/xh1bu1joX1yZGPvZI8TfinQb7M/PGkD5fGPZ8ymgEDtoIupDVV4sW06dsSX1weC67r3quT0N3X91iG/e1rBGAesUnbWUXTIHPl9UE14UPP0HdzFVV+WEmmdHxBEp/hUzL0b28drQriGx2MX9sb0Qykpw+10juV3vFDW56/CMJ3BGh+3JvPw1lFy3ZgRHu1ap8V9hhbVLuv3ljUtVeNtCjGiYl7A7LbC0qR1jFdCsLFIFm8XtzTbdR/rRtDUVr+Cj9X3a5zXcj7gSpszJttwDG4hx7fMKxbThaDqezyYoI8P/1sW0zTywx9Hp2biVhqM6fa2mSYtxi0YIdQmVCElwtbj5aFnJFPEYqPXGJ5a3Y1s+ARa4pdl8Nrrd5CjCDKK0BgLUhuHzdA3FpM/qQhPuL8iItGA5I1FikGIbxYxjxCpObxc5bWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(6666004)(316002)(83380400001)(2906002)(41300700001)(8936002)(86362001)(66556008)(66946007)(66476007)(478600001)(4326008)(8676002)(5660300002)(6486002)(38350700002)(44832011)(4744005)(6506007)(2616005)(1076003)(36756003)(186003)(26005)(6916009)(54906003)(6512007)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RdHqeKKHeZdFfERp8H7JdkWsm+/9CfkU0JNGB9ks2DvIBxwquu5ykiAXjTgJ?=
 =?us-ascii?Q?QAaBY0nMm+K77dkIYoPQFef0bwn1h+SMRmcJGriXjnpVTzKR1l0KQjFTHxRE?=
 =?us-ascii?Q?Bo+avnw/yD7O67mCqam+gp8G5kj8kHm/nM63Tr1H4JhY+SpZXDbG/gMb82HU?=
 =?us-ascii?Q?Ng3qN7UtybQPy0MaUksHvPHvucNVQqFXMG7lndadoJlZ+B2uYl8RQdXTaA9K?=
 =?us-ascii?Q?Ivv8E0wmGRdw3hQV9IIJU2Eze1jO40Va5Jre1tl4pE7SLnmoxTVyReep8sG0?=
 =?us-ascii?Q?SE2/txKxY7ZU+rkXhk8Yyeltww8EhTdnwG7SzYJuGYdRL+DfPPaDzVnsUpRQ?=
 =?us-ascii?Q?kYNt6t5I+onB+gcEIPAIDlL5lRmN9QxODH2YRm8vXq3rzYHZdTu5Jl86E4Gk?=
 =?us-ascii?Q?yJkR6mT9++4BpewrO7R1j3yMknMGUHPcYGhNsgYdlEj2C0owFVZNdxRYH73g?=
 =?us-ascii?Q?8kuRnrBxhRPEGrqPzNZLEF9CdBt4JhP19ZknYmZPUyR2Wvls9mxs1sz71KJj?=
 =?us-ascii?Q?88BpqxAFl8TPbm8ko311Je4J8Jc1PJCiIlQoncakp53o4FIgGu3sgAYq9ob1?=
 =?us-ascii?Q?txXdnAAB7ETHmbNFtn7CMTZ3xDzzhBciouwVUki9bRGz0svhsvPM6glgqrNk?=
 =?us-ascii?Q?BJ3yJPqH6Q7tEbkSGyDhSoCZJ7PH5CB0HcT+cAeCeBjjojM4XDjhWOMLv3d9?=
 =?us-ascii?Q?RMjYNwIEDDhy71hTdr2tpXd5UZUFN708QfYe37DGSZTIa5nGyHU9gzHXKAqk?=
 =?us-ascii?Q?u41CulA3bmRcvjgS+2zpK2/ln4701jfGVxpeTJiq68Dx/QTJ1V6xsw+/SIPm?=
 =?us-ascii?Q?Fz1KC4rIp+B0m8nEPQDD0xw7RfPCI7lHXOKybWVwLpj+bYH3IhTDshaZQdFe?=
 =?us-ascii?Q?Rqcc3ATs3vFH69RAWCmsIgu7GJiKqzxQI2SEN0vCR2Igcf4177ulAjaVz5Ry?=
 =?us-ascii?Q?AlKQeswObRfOiXt56nOMTimlYEcw8INdX+d1dCyxTQaL9v9bZLzAPP07rl1q?=
 =?us-ascii?Q?/145SQIIGL8yIQ2A+P5tAkF0P8FtEvubuatdHFFFUVUyFvjUEzOkKVWp1gkE?=
 =?us-ascii?Q?qy+dn9UlNWZX/vwlbZqP2ciipaxY6y6U1HUUIPUeNAFRvRNe7STOrv6lSIMs?=
 =?us-ascii?Q?uZJQ6SYVEjX2Xj2meQlthZRzeS6oZ9wKxzv4BaQ/YvvWsEkUjc+2l55kWzxa?=
 =?us-ascii?Q?9pQB2b0Z/Kx080JR3u3WdxmMXT9BIKDj3zmD8zafUTlj0rt+KrQtnNVik0m9?=
 =?us-ascii?Q?sIpQXnbvjuMhyfv23zgizyTVMZqHVRKNdHUlAcRDQnfZQCWGFgK44hdQf3DD?=
 =?us-ascii?Q?aKMdE31b8VrxjGlrAjGO4MsWYqIJBB1tzrmbzubuHbT7opXzFGqcYh7W/cSZ?=
 =?us-ascii?Q?PA+mkc+8ZrcpRtVcxpCqqyuhxOdAr9zqJb4bPJXxbQZ6eOP9/QeufbhMsBH2?=
 =?us-ascii?Q?1k5oy0TFUItIxCzb/1SVIobCdC73Xr+jfnZDOGX5YyqNbHIYpuHzIN4ptEIx?=
 =?us-ascii?Q?ZkZJhu03TznmYRX2zsJ1g6RMxdexPXdPT13XXjAufy0PETEAV7jyOW/UKcTq?=
 =?us-ascii?Q?xt+znQCnYimbSrdOfb37hkjqZJ7fNDCV5LL/NrC9ztNNgg/jSgi+bA58tgPV?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9223d023-0af3-4256-9dc6-08da748df786
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 13:50:32.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vo6BOfGFfUyrumRFUAsS6NNu9sCsrBVdM8/Pg/5mEVVq8eU/6W3y+FT/AQjbzl6v9hR7DpBhuqOikzF88eCZcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lynx PCS integrated with ENETC port 0 does not support in-band
autoneg for the 2500base-x SERDES protocol, and prints errors from its
phylink methods. Furthermore, the AQR112 card used for these boards does
not expect in-band autoneg either. So delete the extraneous property.

Fixes: e426d63e752b ("arm64: dts: ls1028a-qds: add overlays for various serdes protocols")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts
index 40d34c8384a5..b949cac03742 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts
@@ -25,7 +25,6 @@ slot1_sgmii: ethernet-phy@2 {
 &enetc_port0 {
 	phy-handle = <&slot1_sgmii>;
 	phy-mode = "2500base-x";
-	managed = "in-band-status";
 	status = "okay";
 };
 
-- 
2.34.1

