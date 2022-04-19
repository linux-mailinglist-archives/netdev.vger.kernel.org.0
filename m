Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46CE506A1D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351383AbiDSLZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351262AbiDSLYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:52 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5372DA88;
        Tue, 19 Apr 2022 04:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlEfGWavIgcMG4J/74OLr3fTJsyH6DwMLCsmBOgGUpYBm4zOAY5s2vfiiWRHZJEmwPo4vT5wHerOMdQNylQk9Sa3nGPo8VMC2rnvtRVZuUSHvsDDNNVCYalqWEefyBV6RBnCZTbvZLWFYuFmDJwZV5DhR/UYEuAoKmi/XxZLRd/eb5NzP7Bi/pXzBfE6vzExKXumR6z5e1Lj/CSz+Hqo8VCt0g4lkznePjnJHKSKlvvidIFvEXB1p++fcvuLkRO3nK5iXwuUHt8IBItl0Zq3Mebqv7F7hs1/WBoO13jGrvSNpF+JR1U9fq6H5VENXizjXSWiirgAoV7GgPa64fP51A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+18qStte9ANpkU+tGwk8EzdSrZUUEuecfGlwwZF+2Q=;
 b=e4XCybhg0B2GyimlFRU+um4MjO7dlvjqW3hnMpZa2EWJuZ47xCiR4enLchs0/gu1fncKZH7b2XLT6qcpn702vcfMmMqSEogRDHc/EppN2e2akJlVExJlKhtLSymB5W6RTGyQ5f+rVZ2Bar/YMRNu82VRLfqWTwju16efXoyZlPWHTduKRhk1ShQOMeh7/87rOqu0WKDSPAwWsd0jjd6UGsHhGEnYNSHCwaIoeXTygq5mIX6Wx5QXEDRsfTTHOlVNA0W+hglB/Kjhd2vt7DrqCd0D4NEfYPbwDQadfdGUic9QMDSE8CVnCE9JMi3VA00PIaIZCq851QytU076s01TJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+18qStte9ANpkU+tGwk8EzdSrZUUEuecfGlwwZF+2Q=;
 b=gDzSQG1+U4SeSJhWocb13AfxuR38/DuBcqUdWeJFUFet4qEbhsFDLTQUzj3wC4+5FW9MtPu3nsWz3k2k/wCw96MF1VaO8FBnrq+h0hCMff+9xeauhDOFgzKEDtZgmjmIn2yM98IbxEv4j3KCv7fvpgpqBKtvnUwkQom51U0YPRk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:26 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:26 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 10/13] dt-bindings: net: fec: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:20:53 +0300
Message-Id: <20220419112056.1808009-11-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf19c051-b498-40df-cc9e-08da21f6be2d
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB7538CFEEED231761FFF3DC72F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsAabkClBOPFFlkU71P2hJohu1Wiob5/z2KPvX0TX9L0dDd/CmI1wmw0GQ4VEcws2cG8enWvHooA1L6tn9mQBHLaVEXRTlzyip93AJJt24ceX4dmDX0OtKjuktl8Bcqa1u0XGnwmjv/dCdCbBjZ+I2IGS8NJOhqKw3dqcfKp8bZnNRyV3R5jJpkr0rrpdJ1ZlyvzigZmW1zg/GvU3dTdFlfX5NLo6OXJLP3dJ6V30KX87J9AR02l/ry1Iu7iUGxdCPoa54XOLInbW2XLLNjFIKmAkaRn1vQ45wLzDxBYgxOSdYu9THj2uiE6q9/rb6VCvzp/EJskO1G3eptCCzZZcVzsOsbIbkoarjgxMf1a7tF0YNFHjTruoQhpSAht88UV4w8MDDkFkgYhSLHHfMz6B8ATnI6pj8+U3TZLYYhiO2Ri4UqScnxEWD5eOtlXtWkdH7TwUQUuWV46EgIKjfKjcrzPVQu8xtJuW5YueIGFyoh5cNacKC/fBkkkrASp9Ur3HYNOuGhnHSHN8zErYHKRWODkDU4wx539VxLxhg8qbGSG43uSh6XjKPzYba6s570mNNP3MyDw1n4EtSDMAJl+OLeeZBpV/Tmji4LRGxGHgQN3RH31SmQfXlaDOSBaTaHmaTtFAdUfG0s6/v7UKyGwxoEwoBkxWISYM6dQknY2epxqdUiqyARkkh1fmio8K+KjnZhw3K60310iNoGJQzEq/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(4744005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FtESsBtOUw+G9YsToPYABYriWXoQ2T4Vpk60NsW2JR4Gvi1kC4E064XzXbWu?=
 =?us-ascii?Q?9hVBc9kNh4bwq7xgnT5WguHejkxAOdysc/LUDm/+s/1LngYBLgx70LwwSN8S?=
 =?us-ascii?Q?hR2ymV4NzMXYgcXq/ujg4dedY+t4EkPty2oc5H256m4eeWynLOKIKEAZYciu?=
 =?us-ascii?Q?wFPMUUuubvO5gnyXyDxiqZe7jMBSKytAc3pUf+Y5551QahN5ZgmWs4BHVwQb?=
 =?us-ascii?Q?MDSmzl2R3bFTrepGEWK7kzVkjPSb08z3Q1Trpbf+PKaoTdVUrbbBHBGP9+uu?=
 =?us-ascii?Q?YqaWI4qHzI0I2z05aGmleA3kZOTkhf+1VlPrZCd8+Sa4844jRzaCeTetflyl?=
 =?us-ascii?Q?y7BiUwu0Ondqc8rmfq5mqRMW8h5YZYJlF4BRY7iOQLdwJPnBX1lz/LgVUnHC?=
 =?us-ascii?Q?d3f6mwT99gKCAuju0RNBD/kRcKHLTjZ3vjMteH4P3vVYELuvsdLEvWE+sqYA?=
 =?us-ascii?Q?yKDjGAc5K+JnK+3Z6pp7lE75GWmrn9gP1u7tSGKiOXT+bO9WJ0VodiTM/9Kn?=
 =?us-ascii?Q?fDc4ECfjDUeUKVBbkgbWObXLFsKKXGpyVfA++4/h21xDfBepVmyVzIElnGhS?=
 =?us-ascii?Q?YAxm4WZ2VfEnBcg7M7bf+jcWu5Ebo028XcofMKcGJovbwH4a5XplYkhOjTtx?=
 =?us-ascii?Q?7kN/dzwyWXEfn2o8H07msz5Tj5WWG84+6URRARpv95Uc39scRzH3zCAGBqAS?=
 =?us-ascii?Q?pBvfpxg7rFGzJxWcWNVJWw+okQqJ6hN0PySENRPb9DMbi2VsF7taSO4mmF/o?=
 =?us-ascii?Q?7iGnTL8WqTQtiH7GhLqv+cnF/K+tsAGxGMbQ+Q3yp2aYR+fTycoyGIWCNgrf?=
 =?us-ascii?Q?Z8fqiLHAYNZfXjbxuSlTUgz/NagrvOzGleizO8bUx0D2he+eaj5Hq1Zq9TBI?=
 =?us-ascii?Q?b0LXmc+Uclw4w6JQIyx/HVvu7bCM2PK5hbdrD4wZhNfCwPmefi/NaDrNj6WR?=
 =?us-ascii?Q?/uyPB+mTDfGF1WjxucHauf64TB5x8j2s8S4DbO1apChAV3IE7/NUFPrt493L?=
 =?us-ascii?Q?XL28EEbgEIqzkaoSiarVwQrLcvU/b1FULRvGNyGcDAqViXTOkTAUn6FLJNmH?=
 =?us-ascii?Q?UxEvFn824O0aQGbg+bJDNs8ib+7TOB+wbiZppSiia0SR8rC8HvUEJiBXZAhz?=
 =?us-ascii?Q?lJUS5eIjvyNrmypomQ8DFITMcw3zTHrRayXJeR3/zXLiaLNtHaXNj0cU8n8y?=
 =?us-ascii?Q?TlPeN9GCjyTNq2wxwPcb0v88y+GqxlOD1UymiuQRRpH56kfMRGi4gXfDy+LJ?=
 =?us-ascii?Q?SXy6I+19V6/LAXmt5j1Lbmo6/zT/gbUUOvPRkkkKQwAuDF4ObrMqf069c/I/?=
 =?us-ascii?Q?cVeO7rFAJTyUqchNTFAyGCi4R9T+oUbfcE3mZt7ahjV9pXERwpj7QG6XE7vw?=
 =?us-ascii?Q?g5xHgidvEg2ZxdqoGipPQphOZS1wsj1v/NdRTQ7n9OC05T0aWGC/ZXCnb99k?=
 =?us-ascii?Q?WhSmpzKm0pFhTtamQQVrw0YQ93JJiMxbQclPdqW3nMun6QvzeKdxJos7E9hZ?=
 =?us-ascii?Q?h/9ML1kFIR+Tk1EiNKhhvg1rN+Tdxj0BstKE3XybuG+Z2wlSUcrgwiiDW1mU?=
 =?us-ascii?Q?qjNRP/Bt5sZMXfWvj1/0zyXsjNAFhk3pz+ZK50EJf3HBaJVVIzbz755JUTqf?=
 =?us-ascii?Q?4nSU0DCUYDTwKXiwt70h2LOHGyoOxn/VkhIMUfE1/Y6GAWalmANO2iwIUZrP?=
 =?us-ascii?Q?s7WVH1o78bfimExZYbeszN4GpX1C/MnJR0J1kL0DYTmHl1gOResvYyWxyHWr?=
 =?us-ascii?Q?sDfbieYURw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf19c051-b498-40df-cc9e-08da21f6be2d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:26.4252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TpmXWXn4s4VmOJbn5xN/zOP6zptdeo3hgmkI+pbcMKwFwfaI6XClvUwMEw4fKH8NyFOJwINpOe/p+0w7wQLXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the i.MX8DXL compatible string for FEC. It also uses
"fsl,imx8qm-fec".

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..92654823f3dd 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,10 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8dxl-fec
+          - const: fsl,imx8qm-fec
 
   reg:
     maxItems: 1
-- 
2.34.1

