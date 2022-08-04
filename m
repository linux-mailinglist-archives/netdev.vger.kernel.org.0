Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C358A186
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiHDTt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbiHDTsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:48:52 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB886E2FE;
        Thu,  4 Aug 2022 12:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScXtUsp0TvagRSMwGsLyXlpkonkL9KCIYxumiNA8rof8x3m2dNq/p7aLiDZ+CDyhwb+2tHcH5iVrmTmic7fUCsf43MbkHWGMNwZd5BPZX3QKjnTm1kdk+tde3JHCt2D1Mb4s+7FvSjn7qeZRjZ30la+91Czgx2pfqxFKY49QzhZsIdfoVkTZWV7yJ3eIKa6wVG+GV95yLfgXbp88Uxu26j3irXLHCPIG5Lkno5XNDbS9qu/8rNxzbX9z4nJLbErqwaohiAw/E2XRttxVprbCJZMuo6QBCk3TEDY8ha61Jo1n0OqajRNaKkHTQd7KIbGCCwGFIDABTnPSchXZOtXKnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTwS8vnSscMG+rpUUE6RyREyfmZgs+7McUkaDIMNE2o=;
 b=ES2Kd9G1lvnK2qgiLwXxoow622jw23NpxYv/s8eCb84xBHi7KeWXyESR0a7JPXJygJxnm/RzJnNNcC9dRNkW1ga1Oy3+yWP+zntPwfWk7tVyOxa1TEyjchkNu5MBQHX9NRkqqAIRHZAmb+GyDIWSwyvOTgbj+gWzvhlFmxNZgu153DJtVQ45plFSU2feT6dwUYcDqszuC0gMt64t+KVsqiNfDtEpetPGLg13Xrl7zmWvR0qpSjxWMS9cNbJ9VCBcb+k/MoUrKeI5VMnafSEzgmGtYGdr254gWCRf3KTV+MwZ/Sbj2yCu0Lap1WW6pnWTD1HOUDrBFWi8OKKrywKMNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTwS8vnSscMG+rpUUE6RyREyfmZgs+7McUkaDIMNE2o=;
 b=OkZqXR72BxM/m9YYQElW3F1rzN2rG5YJyuRDLn4wvmL3aeH+RvQsRqupyOT5/6iKBY2JtDiWu4yMb4yQe77sHIpKH6z1XJdPiUI7HhgrDRi43jziRByaLERMqqqZBVOIugZSQOjdXi2bhBV5uRwPQtXiBBx78Lnlh67GLVD9cGWJj4mvULwJcampnjYyv4yHG2lmPFRq3PiPCDXZLjuSrD/9NySpXje3yf81om6n7nrJxszrzccltcQWZEWonTEV4cVrLa2C4nhdTrmQKeaTNtuQdE8lcvVZnRIVL/qOjKKuv4J5OY/LybCxvb6OpvqhS13gBH7Q/pYqHDkHriTEXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v4 7/8] powerpc: dts: qoriq: Add nodes for QSGMII PCSs
Date:   Thu,  4 Aug 2022 15:47:04 -0400
Message-Id: <20220804194705.459670-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26d60558-db85-4280-6c22-08da76522e90
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9lO049dI5PAdbqjshz9Z+s2rbeUzzdLrutswKUxQ1riOAC0TsRJ4bWvhGV8VUMuAT/esF5tSG/QwtNpMZPY9QXqAjMBimTVHcqDc4oK/GOHRVDb90fjz+e/zYF5xGlPWNy/ACeGpOFjMiA1B5IR8scBdlSkZRZpWbeMcp0SqQvZg8Wdi26/m+2Ik6CPDv9uZAIN6TKPhSsH3KiBDpEEnw8oVm1OON2EkDie1DneQsccm3Fsuz2cYm4fkolzC8OAih3FKVMFh9SH4sQM4ZABNhvp+yetXEgAkSU0830/Furr9RQu5rCl/y5SFrk4aBhdyLlOAiCNgmWFBeCpOaAjGmMmO5OdoNIngZ+XWM2y3aBZ8pxz4EAv7ewm+KYOd9kQADSh+FP1Sarb7fuveOcVcdIF5K+m6FicPU0/7/G5fbPwzfJPNM3pLWP8MHdHTCAEuXQ4cfroV9XrLx9NUZc0Dl0Xcn7wEAUOvxqgeSqf5Z55UYnk4x3w2WWVg7TTw0P58J0NnPOcWWctrlxHKeufBEncehTK4D98qc0jO/jEoVyS0gHRd4OU+EXeMNVxj7DStcp/v8UVVgxJF1dJZSs+67QRhyBHs+NQFqXYPsbm01mgaDUANaJiIb8XYcIkTKhi8FRf+h+2lReMgLnvkvgX/9fRa2YeZi6yy/y87m9Il6uekC96bHzd/YexpnXjxR8O3Y/b0Lx63CI8qGbe/GfaZ0t9X/8DDg8t8AdvrwEqjeu1Mdj5JNHF/LSUfgqo0wgJMGGTQUItge6CRrmt903NXeE9qu1qaoExb080wjZMV4w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(30864003)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tupO4x0v4T+NHTL3cbeD8llrDrbgo+6zC+VGz4OEA7Ur+VyF4NEzZBsx816j?=
 =?us-ascii?Q?+1NW8fslRcuoZTBXxPK77hEgF0Z1DVAGkfGAkWlTaZZIta9T48bh9v2PWtet?=
 =?us-ascii?Q?IZqwbRL7HyAl69FjASFwyNUoJn7+V7bslN7Hutw7jwdGOujKxIG5ypz9ui36?=
 =?us-ascii?Q?NTg1paCkwRMPOD/zczGWsKDpsW9DJAmMg6yyA0w8+Y/xrwU2SemLmXATyT3t?=
 =?us-ascii?Q?Q+UrpCvka3vV7gVkqYf3pFmbWa3rx8hs+HFfW3ESkZ3Q1fpuOX2TWln77jD8?=
 =?us-ascii?Q?Qw/Hgj+MHjmqnb/wzlnti70BpzjEFDkLffn1Yfv5cMO+zZ2pLm0hyJMIXfFy?=
 =?us-ascii?Q?SxHJtfcNA7TO8dtQVWvcODJFh+M2ZdNLLcAMFhezy1hI2wUY4/WmQUDjn6jl?=
 =?us-ascii?Q?J0QowYMl/LF17tRI9Mjcr3D7KbnWjp2OTgonlCP2yaAoP3SIsd8tw9zQZBCp?=
 =?us-ascii?Q?Mg9VK6aQwDcHKApKdOQLR2MQi1wjbeUZsiPZdu2XErK+ZV82ZQRlBKRTF/V3?=
 =?us-ascii?Q?qy372rr5Mwt0dFNrTi3LfKu8eaahv3zDbFWmO4W9eM69FtdjvPQSU01p9ajh?=
 =?us-ascii?Q?parUJAdoEpEH6AJ5bVcSE2c99MvZ51MDe8t/nNOA23Vye+kYG2Mh3HeSupdm?=
 =?us-ascii?Q?8Htcx2NwVUZa/2JM3xUlBS1o2NoyMq8mGyhlRUrFb3T6vRLWtg5xHzUHNL2z?=
 =?us-ascii?Q?FCCmEOj3W6UjSHfKzlAgrSjqL61wpgn7OrIxxJHj8GXqzOHkl2gQUnKweWbv?=
 =?us-ascii?Q?Q8GfY8NE4+QmpCqAq6AlvygZ0vdA4PcHSSKgl8MGoO7IZpvA1r0pz8Loc/fw?=
 =?us-ascii?Q?TeMkkGESbqbHJEZyxT64SFzDqMmM9FeXW5JZmGPuKlMc7vq+zq2/LCzyznmD?=
 =?us-ascii?Q?Bk7vacAEI5ptL/l1ir3wM0MTng+/jWX0RaZ7GMIRGjRXaUKPl5krXdFbAv9y?=
 =?us-ascii?Q?15g+tf4pOtyZCk8GjCjyvbL++6ph2eLEAh/cprPfD2Agfk3eNegrPbTorUsG?=
 =?us-ascii?Q?fEQsamnQq/s1ogiH2qX4fSwFpkmABdlUpq1H1yMN2Bg6v+N748PXRqTQd+Af?=
 =?us-ascii?Q?9LQqNgQ8PZUGSqUn7DUaPRpa9ANoMEqw6Fs6miLQtOrbGXWIb3hWEurS45aY?=
 =?us-ascii?Q?mqgleq7o4XTS5lyDng7HOv1NLVGX1M4uH0IUz5J2OQaQEvfxRqdyQHOrkbgt?=
 =?us-ascii?Q?lxGF6gboREHajRfTqP25tGu3J0mxKnGJR2N3ki63Jn3Vhj7m3R/w1GsDFpOk?=
 =?us-ascii?Q?RRhJO+xwPfQ6vjhCxO3DIonpSRMcP62g6R4JGXXoLLfm6KwCjV9nBN4HNOWK?=
 =?us-ascii?Q?nnG8uD6YKI/0evTlYstFb26KRIunfKHj8RIggPakgVQx6w59HwJQYIT1aOBH?=
 =?us-ascii?Q?cnZlL+ExngNcRFqJ8kYRZjOfhwLMEPcMqBiA/qSYE1pQ7Q9ytfpRyeqQh4Hk?=
 =?us-ascii?Q?pT69YtpMEy0eXo3aqViT072oQ4k9jexFIwN8uIMayYLrmHG3fxfbllUXqGya?=
 =?us-ascii?Q?bDBQjA3xze1Miw7SIFhngvojynTn8z9K6PIzMW3yep4izcx5ZMOEIaOYMdhy?=
 =?us-ascii?Q?wbKgWXWc2fny6ExJqfWxpBZ4mDcM5IataGWPjgdgMEjOw5iEgZ8JSf3FpGFr?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d60558-db85-4280-6c22-08da76522e90
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:37.2271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9zjgswVNPmDzCX0wI7Ax42QIwgJQgbpfO4n8SX2g6Ur3KynSoIalguBXpJtFftgl/sOIkfuLHrQeMgHjYcrjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we actually read registers from QSGMII PCSs, it's important
that we have the correct address (instead of hoping that we're the MAC
with all the QSGMII PCSs on its bus). This adds nodes for the QSGMII
PCSs. They have the same addresses on all SoCs (e.g. if QSGMIIA is
present it's used for MACs 1 through 4).

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v4:
- Add XFI PCS for t208x MAC1/MAC2

Changes in v3:
- Add compatibles for QSGMII PCSs
- Split arm and powerpcs dts updates

Changes in v2:
- New

 .../boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     | 10 +++++++++-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      | 10 +++++++++-
 20 files changed, 131 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index baa0c503e741..7e70977f282a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -55,7 +55,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index 93095600e808..5f89f7c1761f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -52,7 +52,15 @@ ethernet@f0000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x10 &fman0_tx_0x30>;
-		pcsphy-handle = <&pcsphy6>;
+		pcsphy-handle = <&pcsphy6>, <&qsgmiib_pcs2>, <&pcsphy6>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index ff4bd38f0645..71eb75e82c2e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -55,7 +55,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 1fa38ed6f59e..fb7032ddb7fc 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -52,7 +52,15 @@ ethernet@f2000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x11 &fman0_tx_0x31>;
-		pcsphy-handle = <&pcsphy7>;
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs3>, <&pcsphy7>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@f3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
index 437dab3fc017..6b3609574b0f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -27,7 +27,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-handle-names = "sgmii", "xfi";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
index ad116b17850a..28ed1a85a436 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -27,7 +27,8 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&pcsphy1>;
+		pcs-handle-names = "sgmii", "xfi";
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index a8cc9780c0c4..1089d6861bfb 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -51,7 +51,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index 8b8bd70c9382..a95bbb4fc827 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -51,7 +51,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index 619c880b54d8..7d5af0147a25 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -51,7 +51,15 @@ ethernet@e4000 {
 		reg = <0xe4000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0a &fman0_tx_0x2a>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy2>;
+		pcsphy-handle = <&pcsphy2>, <&qsgmiia_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index d7ebb73a400d..61e5466ec854 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -51,7 +51,15 @@ ethernet@e6000 {
 		reg = <0xe6000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0b &fman0_tx_0x2b>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy3>;
+		pcsphy-handle = <&pcsphy3>, <&qsgmiia_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@e7000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index b151d696a069..3ba0cdafc069 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -51,7 +51,8 @@ ethernet@e8000 {
 		reg = <0xe8000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy4>;
+		pcsphy-handle = <&pcsphy4>, <&pcsphy4>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e9000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index adc0ae0013a3..51748de0a289 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -51,7 +51,15 @@ ethernet@ea000 {
 		reg = <0xea000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0d &fman0_tx_0x2d>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy5>;
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 435047e0e250..ee4f5170f632 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -52,7 +52,15 @@ ethernet@f0000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x10 &fman1_tx_0x30>;
-		pcsphy-handle = <&pcsphy14>;
+		pcsphy-handle = <&pcsphy14>, <&qsgmiid_pcs2>, <&pcsphy14>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index c098657cca0a..83d2e0ce8f7b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -52,7 +52,15 @@ ethernet@f2000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x11 &fman1_tx_0x31>;
-		pcsphy-handle = <&pcsphy15>;
+		pcsphy-handle = <&pcsphy15>, <&qsgmiid_pcs3>, <&pcsphy15>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@f3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 9d06824815f3..3132fc73f133 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -51,7 +51,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x08 &fman1_tx_0x28>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy8>;
+		pcsphy-handle = <&pcsphy8>, <&pcsphy8>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 70e947730c4b..75e904d96602 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -51,7 +51,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x09 &fman1_tx_0x29>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy9>;
+		pcsphy-handle = <&pcsphy9>, <&qsgmiic_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index ad96e6529595..69f2cc7b8f19 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -51,7 +51,15 @@ ethernet@e4000 {
 		reg = <0xe4000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0a &fman1_tx_0x2a>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy10>;
+		pcsphy-handle = <&pcsphy10>, <&qsgmiic_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index 034bc4b71f7a..b3aaf01d7da0 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -51,7 +51,15 @@ ethernet@e6000 {
 		reg = <0xe6000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0b &fman1_tx_0x2b>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy11>;
+		pcsphy-handle = <&pcsphy11>, <&qsgmiic_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@e7000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 93ca23d82b39..18e020432807 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -51,7 +51,8 @@ ethernet@e8000 {
 		reg = <0xe8000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0c &fman1_tx_0x2c>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy12>;
+		pcsphy-handle = <&pcsphy12>, <&pcsphy12>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e9000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 23b3117a2fd2..55f329d13f19 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -51,7 +51,15 @@ ethernet@ea000 {
 		reg = <0xea000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0d &fman1_tx_0x2d>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy13>;
+		pcsphy-handle = <&pcsphy13>, <&qsgmiid_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
-- 
2.35.1.1320.gc452695387.dirty

