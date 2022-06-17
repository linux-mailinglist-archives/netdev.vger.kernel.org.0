Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD454FEBE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382563AbiFQUip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383403AbiFQUiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:38:12 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A5D5DA05;
        Fri, 17 Jun 2022 13:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCdCcIW6JZ8HUG6ixOxPJWBPK+JJ9ZAWJYxRfrpMJTm2OND0i3qma2p/wuWIrqgaLr3ESCZsmgwPqnzW7+F3FnKKNwNOKTiMDOANSYQgn1A/Ro0I0E/4lEMYqRIaonCpjQ5b6/mUKwRrGLnVJ4sC1q4KRjkLC8MJvYzJ8eW0jq5qIFlkZHOHzQBEnqD1UmYm0j5NVOnYeWvABe2zqzoRPuDLBEw5vGBn7vl0HSgNj7VkdBLgfKDAo4ZzJGI+3jPrlXEN2ltFuj1wRFQ9+k3jGi8/VYQh7kBLdGJWsHvv/G99MHHg20VivVjqIheuRM0UhM7AseyV3T2Eyoyoe+yQJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAIx3HP7EOd0nayom5zq0pgy/rKnCh/QSt36ISQA7jI=;
 b=HmqFsqGYa5nLxb5tvWbx510Bw4mCZDBxfgYA8urIBhBgg+va2c7YxryfCRDbYJNmA5xFcK8494giS4CmosrNHemh9jgni+MI4WiyrpYvWe2ag/9m7PkE19TNi65L1HbNQpVHCAiDvwuFCx2o6FsY5vWTL9eRu/Q6e7ZfXKI48H6xOlN6hP39sd1A1rGwlO8uNxIT2EraqHXNQUG+Iu6VNvttpYkBRNB1yqzqeTwzeAnMHIqH5/DcpyHDHVA/czAc8HfA5X1+mvPbQ83367SiHmpCHsZ8qvk32FIuwQa19uIV/zJYRioNQN26bs46kP8kRgJVpyxFrTmQyM/0cPxXBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAIx3HP7EOd0nayom5zq0pgy/rKnCh/QSt36ISQA7jI=;
 b=e3yyseMkex8QQPZpkB/qXRRcLaUfxW1dxvpVK9rKio3x5Kxa/AVmnaqxl8iF10RBFQzCzGcLioIJ3xbz8oDPzqPhg20EmNnNyspj/TJLQ9U2Azrvt07OTDD+g09/0HjXSe/NAswSUxmLxj8ujPkmqQREJ6G04UPkp+IozfrhEy3fpu5EAa76oE27VjjsLzUIjNUTiw5Z8VERVQuIXFVTQGm+x9Wv8t/UvACaWLlhodbW3KV/1JjRlTdQ0Jqu5GvIEJi7pNegH8XsULmkbOVEiyhgyrSWmMq1XPAx8GeNWmyYXT5/AqgBX97+MkmHAx+3lP8/wq9w5AdsR51uMJ9r0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:28 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next 27/28] arm64: dts: ls1046a: Add SerDes bindings
Date:   Fri, 17 Jun 2022 16:33:11 -0400
Message-Id: <20220617203312.3799646-28-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2379cc6-1afe-40e4-8664-08da50a0c68f
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB683889AB7A507A61337109F196AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yn0CNCVNwgn6ZnNNvLKCG58e2BoGIipcSCHFG+r4NUjn/zaoS/XrO20uzQPhTew7NezUKuBJ9wU8jDpnspFTjN9aSkrqevYt43pDMz/UIL9+YG8xhYtQW+TBnqerzig1kLXUk3HYXDfb1iktgwg8kFc8GjTepagw1GVRP1NaAVHi8EwVKjmo+LdCQ9PIPtGPcQCpbEGM2zh9Aj5YiizhWyCL8mTD3WhljQ8oytY2dI6SGQbirQG1ZRlBl82tsdRu+DLsvBqlX7q7LtGFD7LWgmM5K9nZPMttguGkwJXd/j2Bui40Np8+Pa9okS13c2v/g5JoOkC/6hL08LdoeeKLBc+01lALZ86i1jV+fkUqLzlqjp92Bi/tI42DdvP7tUsT75F7Fde8LI7FpaG9kljWnkbwRGLdgO0Sdc+2Dv+N+suOQAZFBmzmeYCCDsHekD7T7Lgj8Iss4ID+zX5SlpVoe95Ip6dSh1rvXJpneg//muZ5/KD1OicQf3Pig9hTUH9ht9qa0skYZmMlDZOLu8RPX/IgOb4A6FVDonBCS0Ku9ZE/pchrvKh7VO04qtOeqFnLAjZ1JpFEtmtNJrpc4q+oggvkhKMBdZ9jiPE+EGzq4StSZ+SKrx6aU41EjkOndSKm1QriLM4RqyB5PX7cRZPnFYcW6/XHFgyniwRAR5OSOANT8Jw/yDCKwjRfA4+ltUUAB5iqP7/eGgE3R/5VCJZaQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(7416002)(4744005)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6lhX7MKoUnBLyn2pNjG8IAzCfo8Ow32JqqnRHF7Ujf9z6DCPvGi3BVbleKIi?=
 =?us-ascii?Q?GwZtjzMGhM8fVuuKUCgZxXtaH5oNLvfh5Fy/NPKy81aUnapUP5HtUWM1x9Jp?=
 =?us-ascii?Q?G9ZZa3mnK0lTdumTGaNSE1f8wHJdCnnhgDg8DT2AYL/X14g4XLgoMr2nVadV?=
 =?us-ascii?Q?JnCj6uXZRNrdYHv0u9lJfxiwtjYTvZ8YYFSPfe4Fp6JyTpPIA+Sc4VQkmEWY?=
 =?us-ascii?Q?LLFRrigz72aDiZLUHMjr5KZzwvx1nzWv2IA9ZjdY6eZP/s3cF0odwQ7oNGF2?=
 =?us-ascii?Q?g/U7h/VBBdA2wGQv0vG3Gb+kfLKz1Hr8JcXnxDUdbPT6lOl7hEpglL7cr7L+?=
 =?us-ascii?Q?K3GeHTYGPeJVEUnGGebJVvRZxz1PgLWDmoUZgsOS0xdyu7xr3W3jqJGVPEBu?=
 =?us-ascii?Q?py9hXlN0Zvm+ug5GuOy6Vd3/g6WS4H3EYFXwfgA+GLt8LJSwBbW/y6eRwz9z?=
 =?us-ascii?Q?llwEC0nTuPAf0wPNsgWsRJ3n8XjY6N7ERUl93ZbtjaLDJGmC2Ep/l3sxLMeW?=
 =?us-ascii?Q?mdH/Q/2pCcnhFppnA/GzInPMoFfCRIWLOZLr66sbI6undoW/nd1cvZ9shhF1?=
 =?us-ascii?Q?LHjy8O45KMr9qlJ0uJAX0BVPKARFlcFStQmPMna65wluvDCA9F/EqULfQIkG?=
 =?us-ascii?Q?CkvqRPzp7xQFhedhTaWW/SFZYnZiZ5eslsQPQtVObrEnmMS/WQnpWvi5lAQN?=
 =?us-ascii?Q?yY0SuVxXLX9SycQ6lCAPfQbckTb5e6PVXQHzIgJnZ9fUgItvEpfNY1kLxAh8?=
 =?us-ascii?Q?YZ0J5D9SMNM3ARPD92X+nKotIIdfWwE2GoJuMxt73Fc6dYVcy+YyZUT50eUO?=
 =?us-ascii?Q?yKq5EmJJcMKi6lZl/agBgrT92t91UfokEuVCT7ih/b6rft1j5g+Q3VqksOCt?=
 =?us-ascii?Q?hemTKTsyLBFAD7Ru8kKviwJyKwZgX9+ihBfGfHDnjvRNZ339BmcTv1gUSCIV?=
 =?us-ascii?Q?5W643xS1HqnFEKJ3dJjUT3r4FlbrKpMq9xE3d8Q7Iei9UWbJLW1YYqEeqFtJ?=
 =?us-ascii?Q?XY6lCkbvAgx4N1JIehE27wNIxdRLDFXaQe4xGseZZjSMu+lxLsltvnzA9rtL?=
 =?us-ascii?Q?2CTh7e3+uzBeinX6Z9duEtuSmyFMzYoS8Fm0xa1g20w49FcxbBpBEh4a53K3?=
 =?us-ascii?Q?9IVfAE8GYep8qhsgv1X48Lpq0EBnSh2pC7GiqlaW5bfjFKEVPBbabjVYfd8l?=
 =?us-ascii?Q?/r7LHuTuFNPfvhlSAuuY/4VfYUHqBn3wx7Y2JupQSkVa7g4TnCRf9zd/5D2O?=
 =?us-ascii?Q?YHXrXr4/jrzzso528vEpnMS3jJftbuT4mCJK7NgMsODwLlLqDimk5F6PbEBf?=
 =?us-ascii?Q?GdoJGS6SgHHEcBmMTOmXbNR/z0W8uLpCtiLW/TThvnz6g+uwO4AXest3gXKv?=
 =?us-ascii?Q?H+J5/MPxmlsqH43aB6tZ5DwPNlHOR9EAGh9+LmK39WF8wCrqnJIsBp/a8JrF?=
 =?us-ascii?Q?n/f+yu+zNVRQWvD8TjxNCw8EOGPSWF6zSAwugEYUe3piK2iUvSvGOhmsJEHj?=
 =?us-ascii?Q?AHLZl3OY27yg8nrPk1yfARfz/SQmz3tfl9uaO9wWuufArUKdIbWw1uzGcMKH?=
 =?us-ascii?Q?e30DTuETWDxjPN9jmMKO8iQv36Pw+z50a1E3uNKFs7NUTJ5ybyVugZZ5B4RG?=
 =?us-ascii?Q?/HxA7K+PNs2ZoIrCHzUhHx02g1Af/MjymIzWY54TTkvCfV8IngHUb88Ep5WD?=
 =?us-ascii?Q?wttozJAcohdX4IzHIGiL3dIJajS0ejJVbXsEWn/DFmhMiUbq9RBMyo2cNt0v?=
 =?us-ascii?Q?AWOUeWmXknQM3aZV4t+CAtAuZTFYpDM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2379cc6-1afe-40e4-8664-08da50a0c68f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:28.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+l4vyomyb/hKeBQZ6DCecGsAtMvCDMmu+YmTsk2eiJ9GEcNe2FOnHh9EhnwWhGLTUrD+G6mIXZ3Hz46y+oasg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bindings for the SerDes devices.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 0085e83adf65..de2cf36824fb 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -413,6 +413,18 @@ bportals: bman-portals@508000000 {
 			ranges = <0x0 0x5 0x08000000 0x8000000>;
 		};
 
+		serdes1: phy@1ea0000 {
+			#phy-cells = <2>;
+			compatible = "fsl,ls1046a-serdes-1";
+			reg = <0x0 0x1ea0000 0x0 0x2000>;
+		};
+
+		serdes2: phy@1eb0000 {
+			#phy-cells = <2>;
+			compatible = "fsl,ls1046a-serdes-2";
+			reg = <0x0 0x1eb0000 0x0 0x2000>;
+		};
+
 		dcfg: dcfg@1ee0000 {
 			compatible = "fsl,ls1046a-dcfg", "syscon";
 			reg = <0x0 0x1ee0000 0x0 0x1000>;
-- 
2.35.1.1320.gc452695387.dirty

