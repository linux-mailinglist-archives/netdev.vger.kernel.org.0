Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24E1601963
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiJQUYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJQUXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:49 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140085.outbound.protection.outlook.com [40.107.14.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20473FA1A;
        Mon, 17 Oct 2022 13:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxp1ewuhFZ2l7FGQE3hw5EF0veQd7NvcWioMUgkQHcjuihU1I47LeDhNXx+F4Kg8bmQF/lrZj2m/2Esoq7HVm7j/5TGBBW/Ue+CyOezfGGCJeWvUPSESIh8vNUh46+sAUDdVY5OZ4meaQPWJQV+CXxqBhn+OGg+Dgpch2tXauXwRRValWdhmqR2tAgNZEX5DzEBkuebLrp7jKUN6dzdSERak3hHjuw4f6whqcvoVmZ19n9QHGA7H2qVUgC+nf618isKh+wxSaMxPpOCZXBOBfnzeFH2KfvKIa07zW25F0eN0Pq92n+ZPvfWroSDdRq30JyYwLyVzqNH0ElY+6EvnXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8mr+E5E/bquLjHtd3y1fs2FBigd04YzSdV1VetNIuY=;
 b=TA3uaoVYHLTXdfGsuOyToUaa3seK0W5pwUHlLwSJsPy6H0qgnauAhna4Jxn9+pMc8qgUQbfyX8GVSQ7mQjkzUnRRXFO38QdH7pkzZX7fs+Mm4LzW81W9wnCkIfPLY9o+/aGyzV3VHF3voVI5TWJwOGgS2RA6FaIN8VxlXscEB9X0Fc9LwduD5cr2BUS9aggHuCE4ZyGYL9bSnaZkQ79mjsscLJSjGjSutn+nbGFGPw0Ecqs7vxDw469ftH4lGECmlhkU+fi49bCCJzUSBOZOz6djbsc7mLZErcflvmoHM5yRC88T2LMdpkkSC5rpvuGq2YWrXL1QWvViYNu6obkpQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8mr+E5E/bquLjHtd3y1fs2FBigd04YzSdV1VetNIuY=;
 b=Z8fl6nKEyhMX0e+PrxKe3MiRCWjmx9duO9ilnTQ21mBW6erz/r2tSsyBdqGq1jze1WRI9PqNWtc9+/6qac6gODLSoz+byfD6Qwn94DZ3pE8ENlU8DtEs+GVbQBIiDff2EbNbb+rpZeEtmiPLP6tK4DAOSjUnZVoGkK3F94pcRaaL/zAX7D/YUTiunyvkEgUhNYBDbAo0kcHKwM7cQeYmwLkXYehq+lIhgb0m06M9hT8saQJNoWbCouudTsm9Yl1qdlIU1yv3kkICN3qsKhgEYILmIoi1K2vTCDDDtO5X9jtdaOycOuW0zEN5qpk8kuPXPUGtTsOcSNfOGixWO69oeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7379.eurprd03.prod.outlook.com (2603:10a6:20b:268::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 20:23:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v7 10/10] arm64: dts: layerscape: Add nodes for QSGMII PCSs
Date:   Mon, 17 Oct 2022 16:22:41 -0400
Message-Id: <20221017202241.1741671-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AM9PR03MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: b498ea2e-3b6d-481e-9711-08dab07d7c2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1pcQrcsYwJWg5vkzFgnmGM7kWahJypU/CN9RbJYUhbJkygbGjKujpL+cIku+95w6QX8gCc2lG73qvMPVGZcALoJvDuvjIiDGFV5B5D8QXb1QdRCo/TSiBdhtsBn4BrS3HP3gZSPdDSxCQ8BwWvSyjxEJsbhDdFOw9Fc8hxsIQqATLdy3muJITwsT9BI4qe3eOXxWG022Rd4E+pcuM7M1DY/JZsbuppmzkhb1eUNQKVv1s4Q5OBptOrLvfHQLg0mf7+kKTipoF0fWfOSYKJ0RjjHfpQyH53nI9bqzVSb4mUt+31SC3PwSQNtckTYX4fkjRtSthQPP75HBm4zvHLuV04ssKfMjCdLpvfyMFthogoYieNjWQTZn5S2tTXz1uEjNxrnCwz7KzAcGLhSoJOFEJ0ZxiCFe8gYPaEOZNFfyJFJtnev6uEYC0hjYCLolPpBw3R0LAcWY3/6iGCudjseLRRV1MgMbiqymGFY4Z+3wSgb9SXgZ7FVcTy4nj3HtsvtGcZ6KCIDuDssaHMNX++ix9bPKYUR5/sAHy2l7ClS4C1aztUOvBeScN0BsiO25rkfYAuo2e+c/juxqwIJQNWX3gg8f8Vf0utHBYbziltGH69Ok4NxcrN15xbfPxn/WCGUThYKMl/eQk5F7n3iiOwsTrYxvKOt289IgCPZPqN/D2O5N9sIeVy4UuXjTVEBQyraSHd4aJW0anddJdd3SDiWQ2XaxO6u2D14M3le97jud89KyRp4/zh801JErGW+OsiYvexlcrCXczYQyFfQpQEKuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39850400004)(136003)(376002)(366004)(451199015)(36756003)(86362001)(38350700002)(38100700002)(478600001)(110136005)(1076003)(186003)(54906003)(316002)(66946007)(44832011)(5660300002)(7416002)(8936002)(2906002)(2616005)(66476007)(6486002)(4326008)(66556008)(8676002)(41300700001)(6506007)(6512007)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PfQyK5HJ5bS/28OFXJ+fd1mKEuQxJhpOvOxiTzZYZHkPCGm0AnsRSdOxbJF?=
 =?us-ascii?Q?XVrS3QKa4v2bco8mpgbpbWyQUYkUDSmB2AdT9jjCsatJ0KJBwNCu2o4Kj3Hr?=
 =?us-ascii?Q?K+UIlWcgE8Mx6O/iu8dcrsvju63Pd21HyliZjpI3zu6HIA01mpUnr3tlvOfI?=
 =?us-ascii?Q?bazrPpuJRlrI16C8UVKsGI01vV5Iz10I8aKPnQsnIKiofto7s1C0l0RDoQQc?=
 =?us-ascii?Q?2yaU3cqgCLLa9CpZIT64SsvOg9SgkitrYqvsIuVbIAu/PEpH/BzEgi9yQTvr?=
 =?us-ascii?Q?zeccsHGhntOqA1j1d372cIsTvMNtEznx7uFwiPkM6+jlOApRYE86y3+Zof7e?=
 =?us-ascii?Q?WqrgVfJiUx8Gx+rSvyrHuNVhsboxeOe/qCv+bGXJjmrswPsX2/nqtYs6IxxC?=
 =?us-ascii?Q?W47+C59RGtRRnkqa8rdcxNPZBP4OuGrMZwXQh8acXZ5hFShImkkMUPAtAIEE?=
 =?us-ascii?Q?ffqM7U5TkOiYzGjKhRV5/YI/PN6MYkYeX6eXkxY8rq0f5IzGIx+MFTiCkdsZ?=
 =?us-ascii?Q?BnUa9tpiEfTlxd+7IKi959Tzi+DUaRRL3eZltxVBeDpfJlp0fxqxa+T6UZvW?=
 =?us-ascii?Q?OC2nvZIFUEMlhP5NY+TYUWSoZzEJCp5pNkcz1qQY+Q0Gn20HqYAsU8GcE5bw?=
 =?us-ascii?Q?wUd0fKTFkMRbZcSVR13KoObI/6IIuGSIgSaN+yseLsp28ONr/gGEBeO0gClL?=
 =?us-ascii?Q?CgTsXOBQqKGRNUn3L4Q3P0ixIJzgKVnbX7OpaICINAs9Bp45VoUHoy6LnkZ6?=
 =?us-ascii?Q?oTGxtGx3NxM8NIxP/UCn7icOezTNRIBcCGtAl4HN6eCXdFbhnAm5ddgBZOSr?=
 =?us-ascii?Q?BHml+FXk4thBhUH8fgQod0pAx49XlER4kLctwqOjBSte98vMrsBYnPHPw00E?=
 =?us-ascii?Q?sOaRnFVFYsX118FODoMzdEfu1jaz2hXnguiTo6dJ1shHKikZXsymj4eZrUty?=
 =?us-ascii?Q?bMDhfhA3SBrq0s05NagW0ePcSCRJLJ4Xr0no2ZiHjbBHOonAYeI2jB3ZVjd1?=
 =?us-ascii?Q?JGMf8FIbe5TIuoB++sa6u4LLC0fWM4XGPgVwa74d+rTrwkA+3fm+qoMVrRHs?=
 =?us-ascii?Q?dZC9QnJu3cGLsEKco20o83rJa/gyX8mApXumRCQG70110dFX+0HlMUSelPgK?=
 =?us-ascii?Q?z6c6/vgkjVKWm6NPFlXZV8NBwhMAII1ijJCUzjjqiUqmNp0zK9XAfzHfAomV?=
 =?us-ascii?Q?vL1GE271mQxElMIGFDXDErP8TsQQpf3JAZHRHRTduYOQyV0DUjnRHURdQKNc?=
 =?us-ascii?Q?2ABO8OWLJ/B0ucWeu0ZKYmoO7tgXaYAHkKjVOqaTgrh7Fw/r/KI5bBoZYpbZ?=
 =?us-ascii?Q?zLkNI1DOzs5X6Kt+ce8VTSbC3YpOOZj+a6jEyU8kB/DgKtEDnijrx6g7zQOs?=
 =?us-ascii?Q?5L33oEvCxFfvb/BuyCSlhw1iMyHztIpZVmXite3Bc/j/khl5+p6nr08XnRVg?=
 =?us-ascii?Q?t61cYifKaKp1KUG1wMUgAnIUxJ+4ybEyzqFDM9ceZzY889KdS4DVjBuHmBeo?=
 =?us-ascii?Q?5q58GrdjGl3EztArq+uJ+nEPU/GfUPQihx5tgxDU4BiXg14kHJs9GWBULj/X?=
 =?us-ascii?Q?dSDUDediB2PMfm7ztLYV2elBx6mpzKo3Sl6fq7hO4+g8VYJUEF6I+4zQkFQv?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b498ea2e-3b6d-481e-9711-08dab07d7c2d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:42.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXTfFh0hva+l2xNDmNr/fOd/kn22VwVBOWlcF7eCwaNRgQdHAwy67GmuS+lQcbxcHNxI7TF2M9evE1M210BAAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7379
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
PCSs.  The exact mapping of QSGMII to MACs depends on the SoC.

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- Split this patch off from the previous one

Changes in v2:
- New

 .../boot/dts/freescale/fsl-ls1043-post.dtsi   | 24 ++++++++++++++++++
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   | 25 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index d237162a8744..5c4d7eef8b61 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -24,9 +24,12 @@ &fman0 {
 
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcs-handle-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
+		pcsphy-handle = <&pcsphy1>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet2: ethernet@e4000 {
@@ -36,11 +39,32 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
+
+	mdio@e1000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x3>;
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
index d6caaea57d90..4e3345093943 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,6 +23,8 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		pcsphy-handle = <&qsgmiib_pcs3>;
+		pcs-handle-names = "qsgmii";
 	};
 
 	enet1: ethernet@e2000 {
@@ -35,14 +37,37 @@ enet3: ethernet@e6000 {
 	};
 
 	enet4: ethernet@e8000 {
+		pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet5: ethernet@ea000 {
+		pcsphy-handle = <&pcsphy5>, <&pcsphy5>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	enet6: ethernet@f0000 {
 	};
 
 	enet7: ethernet@f2000 {
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs2>, <&pcsphy7>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@eb000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x1>;
+		};
+
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x2>;
+		};
+
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <0x3>;
+		};
 	};
 };
-- 
2.35.1.1320.gc452695387.dirty

