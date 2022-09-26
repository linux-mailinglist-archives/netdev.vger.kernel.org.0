Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D655EB0CB
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIZTEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiIZTDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:51 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE9B915EF;
        Mon, 26 Sep 2022 12:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffVWhfnbARfKljeNn8njaMzIXyY0ULSPJznK//KyIvI64bNPoQ3GAE8BZbU3wGR5cuxPc5ZZd/OFcnUQ9osUFo00NwrAxpt+DvCLJlb4/IWLPFPjn5gBZhM7BbNzJmm6B16CD5hvkmHhGVnScUBZf+7IKwe6kuY4COyuvT0ZvFk/EWjdl8fkMkq7dz49sBKSk/zvy5f6/knQE4FO2xyH7k4RI1jsmsa4HLVRAoAQV5FcBdH93a1abm7QJtppyXjRmPDGeWjMG8ivH651TlpwEnWpox5offTL/dn3T521fygMLuj1i5nM03WlLCuMhYKesbLJGVGUwlFhP4so46xH4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LpBZZ/E0MzZ0ssr0uah78Z2jasHTDuQGEPDYfnFsYI=;
 b=mqKsvPwpx4EFwqXjZhjf5PQM6F8J6nMh6EKoNF4d2R6wnDDwH4NsC1QHCDqmxtR/wmSP0tUl+znfFzosJOQQR12Mpdpz88pFZbsVV+TsH22qq7GTlYHVHjkOeQH986gPMuzbbVihS04UxxB6jeGVc7ILV0QvRNeRXz2UreMcCWQoGHMQVhWUAs7mKcDhxSxdW6kmvw98rsxDNtbK1G3AXjW3T4D/SJbubA5eQX4Fl0ahcT157TEJH8LCTpXwHr16QjakWuRzuJcWtpDFCpDyJQaumltBVOuz2QbOddI/Xeo2/j/eGeXLbcHN7drWM6VDeHit6THq8QhiyYq6u4op/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LpBZZ/E0MzZ0ssr0uah78Z2jasHTDuQGEPDYfnFsYI=;
 b=U/39Etz0XdVA2ihuswX48NJUUR2xehfQv/Wi5mf/OjKTxdnH/NBno195HzZcKWEasrFhg328BPYf7FvHuiW50Wp2H8sGN4mw0WSaD7eLH3U0LYnSdKr6MYa0LTFS+piQn3LkfT24dTTPFyfJzdwDwF9f4AS+7kVzPXZM/3/ZTLUgKbp9sTK1OCsmhroRBhylO2U9KW/yFyRUhFEVuqz5WyZklJH4nTuJ9TspjYnfl0SMzDIl1LB9Tdleg2iKdo2Ewdu1F8UQOMXuIlrW3QJlsrJayOWjdMuxM89HJswXRLQMrGTM5ureKwQWxhG09o/9m3wgF33Fut8VY4k+6sdZ0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:45 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:45 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 8/9] powerpc: dts: qoriq: Add nodes for QSGMII PCSs
Date:   Mon, 26 Sep 2022 15:03:20 -0400
Message-Id: <20220926190322.2889342-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: 70015be1-7051-425a-acee-08da9ff1d614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vH1yo8QAHOs7m48Mochd8tDoElI3rXvLgWkDZQ/gmEQtbIw+ai/Um2fGZK3noTGor2x3yVkEk5PtBYBu9zGfDyCeWtRk2ISaW6r2cWNQqf7M0kF4ZB4/18Yx8dB4l2iIRHvaUKzne5rFXMVOnRaOqULl2J9z4EJrI8w/GNd3T72dRJ7ykZ49WWWtqZ6Qj8U+pruYPZI+CCFxfOEyrTZEq9zjJ0K9OFesnfvx4vvmHp0KWgw3ec5cCRXjuC+Wu4QNvn2WD5Dsik11EgQOdFrlcQc+CP5HXFHwKmE8W51UkhggOoQUlQRywZMK4TIT3/XKpVJS3YlLhMhOahbSyr6/ee07FLhHBZTAExxcW1R2Kn2oPyvLjBQ7o3SE5AGEKesy/1utJeKJ4Mazg9LkhEbnUvuGYL7oQJ0JvcQPc2wMaNC53VMgSKyp2Sb/ThyCI8jlyQNCe0bThNvyASOR71wfuYKTsYXOHno4h50cehT8CDUNl4uKF+lie48O7rE1D/19fxx5Bi6wUI2TMtYwBCddRyTQK+YW8zLPjGhoHD2ieXkdE8FwC+dSDosBHe9Z3nW2hO2caDLgsppIicmesZYHNSq5arqDNj88aHeNQMzrsUhvY3LbJ53ZFbi5zt+z4BvYo969XxGzswJMdmUiUm09d1ct8ADtpR+dP6CaH0UJNdepUpoYfLUgx9B7ZrU6GGbaiW11KyKLd5ah7xe7fbPAgTX/dNztrjnVw+yCf10g8so1VsWe+P7ZJ4JVxZtgxyRJHl9pYM94i7aVejtTiCgajg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(30864003)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xqDf4SG6d1oadaewe4FZNY9gyxJXxPuKdUHj3X6Kp95nPVMWZQLXKrIwkrQQ?=
 =?us-ascii?Q?12ZUIjgR0KiFaOsZQNo4lz3mbocp08z+ZucZ2RMRuUWIj1kmWLg9RcjKJ7UG?=
 =?us-ascii?Q?5vk+UBmKUFQ7W4b8fHlRvM6INg98RjHVsKqtojXKjCJuNvzBlFyaz5daEHWm?=
 =?us-ascii?Q?QqF9KKe7vG04dY39ExNKuWTEqkpZxK+93+Y0hlnlLEVC5FVarNWSRVFpUdp6?=
 =?us-ascii?Q?FbQb5rQaEqPS6X2lj9WeB/Z/8r3OJ0hXKpEor/Masghd3UTEqkuhP3yxK67R?=
 =?us-ascii?Q?O0lveqsTRQYCEf11rZQWKxm3rCl4iMm4baUlLuzrruQOR0zZlu5l6O4GjvrJ?=
 =?us-ascii?Q?3SckhKER3Nx5C2navHsi4/TuMrB5cWGYbPuYgE8LVjpm0QKhg0ORGoRLFrGd?=
 =?us-ascii?Q?7E46v1gKaRQqfyUBMo0KVAJQpKchqsdVDtE9+gH1RGcziYuNvqE7x+YeK9YO?=
 =?us-ascii?Q?G3s6tnQ3KEkTn4EvsNMxqVyK3N6UqoCJQ+UyOGM6RrT4pZC9BvW6pWmd6jG+?=
 =?us-ascii?Q?hhiVgybYbgvc1eW5FDPV7D7djajh0LV+C3Qt0DJGFK2YoqoeLjq38+dLpZbP?=
 =?us-ascii?Q?/DcjGRkhGPBe7eg5d/sG0guhIMFOhdXTnAo7gyNwGsPZP9+8/QcnxZbJmnwK?=
 =?us-ascii?Q?Ane2UOfMItLzkEhP6/NQHqPGeFlrQ2DsADX29/H+JNe7METCXz9b/AgFp1wB?=
 =?us-ascii?Q?A8rLCARCft4/bSZZTyshRmRM5lXWG4I1W3LXmLpXf/oLRgCSVMEgv58vygVq?=
 =?us-ascii?Q?aU1OfMrg5UoUuVGlgy38FJge5cbI4PbgxTYTePNeqbBiyRdr7MHInC3VcTlb?=
 =?us-ascii?Q?lq0lhH+hhZ5BOxzebwpIKb3xGhE8NW15ZpDkNpcczgzqTEQRZbuikUNMfJkF?=
 =?us-ascii?Q?BcDgQ6hmiNytIsRL9vBsUMMCo3WXKWvlX+0zpfRcvaJsYZAPgPw/Eqh9LSVA?=
 =?us-ascii?Q?wSk7l1ZU+iMgln1y/oF4VlhEQrz/DZ9MGtUVH3G3Jv4lVlVMp7iXdH9yR0hl?=
 =?us-ascii?Q?tq2CRLIBOuiLmITCGRS2ioClNgEqrdPMg6FMB1tyn3UWCOv4040l7bbL/Mfn?=
 =?us-ascii?Q?UuJKijTYOll3YjgE+Mv0o8s7FWVI7EcGwgTkp9n/yoVInVULOXsE3e5BsjXe?=
 =?us-ascii?Q?l9Y/i4RO8SFzOQEOOI3Q/4Uq18f7UMSModLWkc8NIFdFefIJvCmvSb7t6HG2?=
 =?us-ascii?Q?ndA8mEvIIbEbf6dMmPa2aVDL1rmZEXinSECPLBhgOwjWkIFTiYwqSYqCFlVv?=
 =?us-ascii?Q?xmJx9rJTrK8vcRhD/IaPbzd5x7MeQwBJT6X+QtwalAfnDk0KMEfXCmBbAm9I?=
 =?us-ascii?Q?TYEE35ouXR10vjx5B0ZZUO4OBRYhbZg2ObSZCiluLHxQBhY3rOiZSit2DPhk?=
 =?us-ascii?Q?ZpYETqy7k6DoqhXH/xjlhnvcjl2gp+Ecq2CaCQFu8AZqTT2TFUklYmBvt+aO?=
 =?us-ascii?Q?AoNehnudlFdxL5cPTGJITN/XSUBmVKgBGVxoLULS0nUrRLbZo+Xu+6b73vtt?=
 =?us-ascii?Q?WhnVySRWYLcVu9enrQ3jQFEEaK2y52cBhcxBootiesHK2+8KGbmyIaNFjMUN?=
 =?us-ascii?Q?G17+3L0KNNT+9aocNYyy2E4+Xls9lKKBSlz40wiVj2hq9rDywSblzbXt7uCD?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70015be1-7051-425a-acee-08da9ff1d614
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:45.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVz671TxFLUogaWPPF/BX0gEe5I4dKvM0K1kdbm+nDQy0Kmor2+GnjTwPDcVKIh4zU+2dEm+44W/ykSwOCXI8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
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

(no changes since v4)

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

