Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC551569E63
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiGGJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiGGJPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:15:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FF92B1A3;
        Thu,  7 Jul 2022 02:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IB549eSvVuK3aqhFmNWJkucVpSc/m5WMNX39eEbF9Uko+VmjTcKnRxGH2oPvV+C1U9x8vpiXkQLkwR2LbTv4/3VMgzBfsxibNdeAiweY85HW75FKYsHxwyeRg+0rDGm8A0jmHQ/VJ1MJsXHuHkaqgmNFJD16ELwZHthEzSG2mIEd7RvzoeZQn7gtwYsVaWGbS8vLbiZINouLpRnpkV4J/cwiHLQ2BqLUdv46zIW9uX/ivfG9r5OWpAA+G+ULzsWvisfZ327Vj7DXxvHdLXlw3csBBGgu72Yg8cDcYYT8Rr7ji7JuAAVsqkg9W9zRngqelVyEmTlHhD3vVMjWuTx+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fz7xSAaLDwy7p1eKxzZrTsN0/tSFIHwQ0lkt9bAGT2g=;
 b=fSxNP38VOcY9sLBqQcD+eTlVswiTIZEJgefzfViQQZ9ETriGobONYKN/2eDJCKBuWJ5sFRUd4SVWvXX3DNtyL3oM5IKYOK7hg75ThXR7h3lruXRrq94m0GJcXcIJijXvE3/WJDjqKaLSAFtjOXrzRprB/VW4PAyrE88TCMk2733pO/RmiU0jpjjgGNVBosvlX/ZeZaE3+oE/xIf5gUEgk23RnateWDBob/tXNAR8gUHuStVErH74/yTK3YfmKwXnMH9aCU2HwowLu+FioVDAJrpgXD7VUo9/JbPyHJyFRLklukFuR73Z2fROUzirdi07mHqmGYQm2I+O+EyDCWDaQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fz7xSAaLDwy7p1eKxzZrTsN0/tSFIHwQ0lkt9bAGT2g=;
 b=NjtcxjbSvl+NKveo+5f9qr8Y213NwtoFRxiVHQsY+36MA4nHhn7+gCfPJhOu7eGnkBET5Yi9iNrqfyfQwg8/aWecxD1ralSAEVBXn0dx2QQXcrYvKkAJ0EexMbyeJRzIZcGiEmMJRpexmDiv2wl7qFwd0T6PpL2G8cyYXQaSHIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by HE1PR0402MB3595.eurprd04.prod.outlook.com (2603:10a6:7:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 09:15:10 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 7 Jul 2022
 09:15:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 3/4] arch: arm64: dts: lx2160a-clearfog-itx: rename the sfp GPIO properties
Date:   Thu,  7 Jul 2022 12:14:36 +0300
Message-Id: <20220707091437.446458-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707091437.446458-1-ioana.ciornei@nxp.com>
References: <20220707091437.446458-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0125.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63c9c809-2f5b-4b58-bab0-08da5ff930c9
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3595:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B4mNBq5sNrLZZps1Ur0JgE2b58Qmnwo6DZaSyG4c7zaHhXMSxyqgfzcTzJ7sRW7ILmCDNsnJ6H4+MefANKusbi2N1uw3iHQbN87rc/DORrGDioHZBqu7P0Fk9J25o9cLvgbU0me1/pBfuz5vQsvGhQK+CxAHaXw+6B5+j9uZdwdr5leg59I9KIMHVAL1LDmHZiBf7nEREdosOH+EprO1wxkCbVuhlctAy/B1A7sV2tYGndJrBl1Zt43YbT0mYgvgifu81SVQ1eqMVaz0EjQds5rsoa3vFkWEJO+TXT/LKJeF7GjD9hmd05h5Shq2AemOgL7reNO1Dt9BxZhAzxWPcD2igecZ3Ds3twxL2molE4QqdoaCxPfvwxHBMiw60efqTEuXp3XWKZKFDzDal8qvkFnp5pWt1F4xTGvAka2j4Qml2nHlDv5SF0pbs6lJWGlBDRe5BFsm6C1x1CDpB2niMwJJomcOqEvXTj4Za+t/hfBLQ0LHtGcWdPvs/OhrKBHbUxu0TptPpXO5i7bdoe7sLdLB7cY2vYpWiL+z+aD0Dmz9ULLm8qkbhabWVIntkiKW6EJ9FYYLg49rxaKDqQm+IlCL4P3ONguK8/6OLKux3rVjLHO/TI77CpstUxtyBRd0Vu04IqZ+m62yvZDUET75jMj51K/yyfllnFIksni/EbDFn/FL4wICfISIsZ1c0woPB7UgPiOkvYmfmix1QZyskX9nAH3cAbtG3dfRKQZxsRMyu2yGRHGKKF850uvp5dyrJPtc1ne9OxLyNh51zCFhbHq8s5stDmbsYTc8b8ozEmFJXDOYtPJoOhZVDG1hIwWZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(316002)(83380400001)(186003)(26005)(36756003)(6512007)(66556008)(66476007)(6506007)(5660300002)(86362001)(2906002)(8676002)(4326008)(66946007)(1076003)(38350700002)(38100700002)(478600001)(6666004)(6486002)(44832011)(41300700001)(2616005)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3f1MfzsbfcpNsT2Myi9ZDlsttYRH6Un8yNmxG1V4LTHl8qLicvmxjikQIY8G?=
 =?us-ascii?Q?X4xjQ6pgvIk1tpNG15vlV7wW8QvbpsmMSfaRLQrg2uv99oFfY71bCKmOKpzX?=
 =?us-ascii?Q?y9kHW2jl+9iw+q90EU9aRwg9YjX2AzzE/gZimmheSxWKlQmCPMyFD+n5au+z?=
 =?us-ascii?Q?RWuXEGXNWEHCPeDJfehyDQbCcmJ2/4XfO7mtfEAXR+Ts3rHGmQpJ4zV/Sb4I?=
 =?us-ascii?Q?gUwq3t9l83OANOZCBfvX6HXICd3KRJ5N2vlQyL+qmv8QM5q6r77d21stk2bU?=
 =?us-ascii?Q?EK0nyQvqinvoeUKpeY3AasZbZ2bHsspIf2ryN0QJjOQPs8g+L7V8U1svktsI?=
 =?us-ascii?Q?whIJw21s43Rcz+btGmepX0auE5Cl60o2s2cEa+vcVUAuPHGNJo1K7lPR6b+S?=
 =?us-ascii?Q?2Jsf7wFG44QxDoKSW9iXoISyI3Vwi+aZy3l58hH7xnsSSwxp7aJbG8JDFPht?=
 =?us-ascii?Q?vZPyRi4z/c6xYKFBEBcqZM2IQl8tS4xl5tdexDFUMg5pgGntCeiuNs1vHQuV?=
 =?us-ascii?Q?9lAcUOgzn1EtT32ShG5GuvqJ4QepNWXDKlDPPZA1wFaTd9tniiKp/zg4Yq7O?=
 =?us-ascii?Q?2Y7Uhyuaulpx6LkhXXju+JAp7MRD3iYumc1fEEYLXJCTrNw5aaEcmIdEIyHf?=
 =?us-ascii?Q?aKvSzgLHo+bMRuTIH5KCsV6Bd801hQ0T+SHdUYyHQzVit5FObKHMV43rK8O/?=
 =?us-ascii?Q?xGedD/63Hzs0Qx+/VSQW+OL5M2ys7OGemTNkT0u8Oa3wtUDAqk3Bu4Pt/F2m?=
 =?us-ascii?Q?0HpBUDYF738qJtpsWNL/9doZGK+eEneTLRm8s68fayYuPwk+9akYxuOtONGF?=
 =?us-ascii?Q?4Ohd3McujHafij5Gw2ozH+jPBrWSMLkqQCqRizkEKDly87nfbsCK0vS3EsaQ?=
 =?us-ascii?Q?Wiq+9fDpomLbTQZrYVdzB59uDYQsmOW+gYhX/FYLMpoLns7NsSOq4XI2JeI4?=
 =?us-ascii?Q?o5kxdSrF3pRqTL95M6h7I3bKKuaXtw1tYKeM1psD9TU01NVknvbE2ZOCdgm4?=
 =?us-ascii?Q?nVFMioOgHXLJ1ewPAA80trWDEEONfyuPPyQP75uDZY6Bwp521Yma/sMXGR14?=
 =?us-ascii?Q?Lg7zlQZY0SEVM4pZItzWB5AOSW2W4zJpoOUJqclA9gXPxogl0ta+C6L5Qjca?=
 =?us-ascii?Q?gPayeCL4t1dn31mGiz07nVIA+DZjTxZc427nfqMTNSWDcIWe6EYH7OZzhWQP?=
 =?us-ascii?Q?2F/MW9TPVvQvFWtk/7tEwBOhmY6jNqyX3/iqw5MvbSCr0dVxQu98aPmyLDDd?=
 =?us-ascii?Q?VMjoQoA5rTH3qqMJFtDfR9f8z30xntgvcJqDtfRmmPglQeCUDcb0ofwzfb67?=
 =?us-ascii?Q?b+ZfNGelurZd/ffueGmkTmWcj/Qx1wxGBXlBvc6JKsZsODQlsXT4kz1By/Qb?=
 =?us-ascii?Q?+jik4/TintiCo2JurJiBKhEz5ZOOy5fI0c94eb4i2/HmGlTHhdowu4H6hyhL?=
 =?us-ascii?Q?JFvYlCE2H3LuhgJ584AkiiKqBT8gSuGHxf08uMcTKBVNk1Bi9qYwDmcAgf+u?=
 =?us-ascii?Q?aBVNDxEjl8gJvT7wINAh+cn33OdHup38V0tRGa4zxW+SwIOkdA9xEbbQh/o4?=
 =?us-ascii?Q?oRFSpa8M7r2isTd8q20nU9cR9tU/Gjy7KtL/NJhn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c9c809-2f5b-4b58-bab0-08da5ff930c9
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 09:15:09.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNULcfNkgNBqMSp7L+f2Kd3b+AAb1t1wCTexgno8N4T77DdxRw/SlS3VePAMN2wZe8uqQ4THDxk4HnWJeerceA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3595
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the 'mod-def0-gpio' property to 'mod-def0-gpios' so that we use
the preferred -gpios suffix. Also, with this change the dtb_check will
not complain when trying to verify the DTS against the sff,sfp.yaml
binding.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch
Changes in v3:
 - none

 .../boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi      | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 41702e7386e3..a7dcbecc1f41 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -34,28 +34,28 @@ key {
 	sfp0: sfp-0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp0_i2c>;
-		mod-def0-gpio = <&gpio2 0 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 0 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 
 	sfp1: sfp-1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp1_i2c>;
-		mod-def0-gpio = <&gpio2 9 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 9 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 
 	sfp2: sfp-2 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp2_i2c>;
-		mod-def0-gpio = <&gpio2 10 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 
 	sfp3: sfp-3 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp3_i2c>;
-		mod-def0-gpio = <&gpio2 11 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 11 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 };
-- 
2.34.1

