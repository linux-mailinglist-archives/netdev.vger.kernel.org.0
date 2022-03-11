Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E04D61E2
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346404AbiCKM41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348697AbiCKM4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:23 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8FF1C024C;
        Fri, 11 Mar 2022 04:55:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+A0VMAhoNYwVVEmAcdQ+ph4RdkRP293ek/cT/MBFWL078iReMrVbT5tpMd6EV0NVKrgq4r8wKfPdxcIVSdFWVG2A53J740tcp0LmGwaMYDbuqqq9MwIHei9n+TgyXuk0VGW9PB8diQQOj1tqqI38Gf10cmw77Elp4jicA0EgZ/abDGx3iFUm/E7Z3owVZYyztK/XCAJwVO4Ajl0sdtMBcM5p9Z/9iHKoUli1i2Op3MN2NgK/551j0EyOGF3+BSxmtCkujs67mDhL105K1w29ldn4OuO8daf0lr6zo1oe5nwe1xlSCNS3nJhg8DnNrDdLsh17tren1bv2OH+6vq12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfAVRkA3mpuAQOrYS5LYSDWfGAJAUdwu5PkMFLVWbYo=;
 b=lHr9eY6UvB+GxeO/JqE9GbEgmxwOpPOiWcacHYFw5zMTMgjAZY5l9luIujE3dfL099XzOld+XtWI2uPpP0nZy7Fkw6kHE7+KIzPbFrYVnZfIdvKkwT/S+Q041gqd5JAT1p+s5Ko8ffasnFSJM/VYVzKegVzqrtCtEtFjmZ2Zo1dK+bxkhzQve2nofNN688GqfRQS7TjTaDQNqSm5iVnyvJ0NzvIzi+Nq4/+Z9NEA6thMthUbtk8S7DrHwxzB/gDfkHJXzfW+ynyOyEAkh9QrkUC+MkCMT01M/s4mUtsjxj6Ppi3sWvvn8TFAV7ZfUiVf58N1NpGk5L9tduGGP9qRsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfAVRkA3mpuAQOrYS5LYSDWfGAJAUdwu5PkMFLVWbYo=;
 b=ZSWCn0rYOxaHY1/o2t0fxcN8m727DZegIZdb9RfHzDUWWKFzi3OY8JGHGzUqJDNOTAFjrYaGSIihEqyb6Ca7q3OxhPPch4x3ahpBhreJlBU60tD3NviiRlm0y9hVHmLaRqxT4+KDg/y5TlytRw4WABU08VmVwokJz9ldp5NhgVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB8880.eurprd04.prod.outlook.com (2603:10a6:102:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Fri, 11 Mar
 2022 12:55:08 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 8/8] arch: arm64: dts: lx2160a: describe the SerDes block #1
Date:   Fri, 11 Mar 2022 14:54:37 +0200
Message-Id: <20220311125437.3854483-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 146a4156-c426-48f0-5053-08da035e5f3e
X-MS-TrafficTypeDiagnostic: PAXPR04MB8880:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB888019A6DAB2218812643CE0E00C9@PAXPR04MB8880.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dUfq3rMWD+7dnhvghil4/ryuny6CVOYF0eCckeL32fyoRSCsWAD8UZTz+Ri3eh9OzcmlBFe3+DZFCC2PT7U+cjJHU7TdkM9AR5gPRrNCP7v3af/SZdqpeQYRtFvmUxwnPC06FHugYQ42fcZ5lqKXTE+ILmaA+hpiyjvY6BRB6BTGrLK+768lbukj5jNtdrTJ6sBBsj16Mj3BXxByCgDXuoIoafXPJ44egk95LS8YDZNXanhyASgBsdXM/PRowppIEypr38Tvv50Umdd79ayEMZIvdfR5mQt4gWePc207pczdL+Mf+pAj7bfM1PnDHl+7bBnht1jEd/C5KRlyW1D1zrX8/T5/nfoNTuJGdus2FsbqMLoV70+JUIrVDI98bB/rs10BlnATfiBU3EZrYOemNvUKKQMtEpFwgHTkYLZHw5tD3z5VW1e99wed7TRx95JI+N/YxcpjAIqejvQ0F9iFRP7mg0WWLlac5UvltCCtxxgIaHWiGXkh992DNC7jUp8lHZ7AxIq+qvSw6FgDEbAf/NRfWd2hakdWsoA9KdKw1NcM3brbEmbCi4OWPUuEJnQZjyZoKGfkKZ6osG3OCkKHQ55iN0z7KZGjbx9Z7aOyu8AHJSC8534LP5+QfbAonbwbHh89qjj2PYci5Bvxbtis9rn+R/2ZN9BSAkdQr5ZitjvsfLVqPJxxGmQrjBfLtuuBD35h41wipEZ0N0SbUEfjO9AdCP1gz9o7h4CD8MzLwQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(66946007)(2906002)(66476007)(4326008)(8676002)(66556008)(86362001)(6486002)(8936002)(7416002)(38100700002)(5660300002)(26005)(186003)(1076003)(2616005)(83380400001)(38350700002)(6506007)(6666004)(498600001)(6512007)(36756003)(52116002)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mkWwqyXU7HJIxXwQrdGN14xZ2f8a1AmIo9CnJRlpxKbOrTfVnOQbwdYGRU7G?=
 =?us-ascii?Q?uNam6lTKxCtLXR3Fz6yUXUbiBIMkhbCohkOTYCVwKgPEs4gcCYOu3ALWvfdp?=
 =?us-ascii?Q?Nvz2BqPnm64weB+xiw9+atXGOV0o/Yre7wsc0wTHrVFJwMirmypSEkbQOu1B?=
 =?us-ascii?Q?P79XBO4TtnEY41OGdwqMS0B7osVRZuW3kXIunusSUY4FMx9V0nrZ4ox1Zmvw?=
 =?us-ascii?Q?mqmDHOcBS1dDB4jgQQyznhwlgA+lVp+38CawqojLnllkv5K9CaA8XBb5y7It?=
 =?us-ascii?Q?480chys0bQUT3+iNChHkhtPHI63eRHQRYSNLAwxboEIVRCpZuSmCOXAxtfB8?=
 =?us-ascii?Q?Q6ENnCB1QyAPdFgZoOvq3VsnzEAW8Zu36G2KxToXSsng5j+3a44DPrPv4KCA?=
 =?us-ascii?Q?YqAORYKyQtZKzQJmUzTEScN1h9aciTerqN0jVmwBQIBM5AQt1csdM/Qxwux5?=
 =?us-ascii?Q?ShYo9IbOSDQFzo+gVGauqHF+/ggEdPUprnxTRCvmxPWqX+F03I+MZxQpGEbj?=
 =?us-ascii?Q?dkbrUaAXvkbRuk5gS7WI+VpolMWM7digN2ROqlqG4p7xdWATsmpO28S/6x6o?=
 =?us-ascii?Q?VG8BTLeuOM3HsWtIvfesLMt9mWJo2xGvkRrMo+TnHNEdifUyzGTE/T4MUR6P?=
 =?us-ascii?Q?adaaXcT8aBkPX0IIj71QJkDUyyISjdikMl3ulsVRHCEGKwEbvlnxczi/uRep?=
 =?us-ascii?Q?+O96Py3eIbUB0NxBdn79PvOyL4aoh11SpZsxrB3PTu8jqR8xuHzyl7mxi9eT?=
 =?us-ascii?Q?DStmXCLgM2ivfO4okvdOw4hREGH95+IIMFdCa+mCiFaol5GK+WazEUb3u4LG?=
 =?us-ascii?Q?htoJNmkRCLUdtHqY192j2bP+zf9Tf39QQ0y3V4hFkWn202Za5jLb0yYmabP/?=
 =?us-ascii?Q?+eAlTKqFkSxPIraUEig/2c5mwxsuLnp0bnAVN/dm8wEwh1ahNWVlrIpA0J9D?=
 =?us-ascii?Q?31N58CJx89TTlX+50L3WJLYZCKOgHX2qG5U76CgHGvtnDEqwQNg078V2PhUe?=
 =?us-ascii?Q?lwGeJqfpmRE2cCBsbiD6QMlT7agEe0znrLHYrks8ak9iKbq96DPSvVklaUIB?=
 =?us-ascii?Q?Tv5wKsyruqfzZklCqrfJ6elU/RquVl+P1VN/b3XFxnqbfkIxWqgkd2K5I1Xh?=
 =?us-ascii?Q?tkyrOfI9V0/aWYe6o4Ca7GDGXaeYR8qo9lgKGdMCAheZYz3TPe8yhp6FIX7Q?=
 =?us-ascii?Q?ZN59tJvREKUDLKa/lFFJGL+u4jwheu93c8IQ0QHA+9IrG4IOeNEgbFfVgZB1?=
 =?us-ascii?Q?GTtnT26l7F8DzQtky8sAky/vAPrd/K2pQT71DOKSnmRzrGS5Ac/mXKl29i9j?=
 =?us-ascii?Q?PuDaSRsn75d/ozDJ3rfnJz6uIAbsarD79hmnjbGZLskOmZvNQyKowWIhpimI?=
 =?us-ascii?Q?4sFdH1X12MySH7cmTMi94XBxv6FuxDMk1QZszjXTarm5bXTa/BCT7PrbdDce?=
 =?us-ascii?Q?DbHHoVjbLwE0JgvLeYgG83iLGcYohuAMtVEitC/F9O7SSW5KbmQrTA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146a4156-c426-48f0-5053-08da035e5f3e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:08.7480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 255FesW93Rjoh1jwQTDh+l8rIAjM9Fk0/mrkdeZeCND8Frgp9QT1i+yQEdO+nWzgsM0yy40YD/xidP2kZCCHpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the SerDes block #1 using the generic phys infrastructure. This
way, the ethernet nodes can each reference their serdes lanes
individually using the 'phys' dts property.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none
Changes in v4:
	- 8/8: remove the DT nodes for each lane and the lane id in the
	  phys phandle

 arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi | 4 ++++
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi              | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 17f8e733972a..41702e7386e3 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -63,21 +63,25 @@ sfp3: sfp-3 {
 &dpmac7 {
 	sfp = <&sfp0>;
 	managed = "in-band-status";
+	phys = <&serdes_1 3>;
 };
 
 &dpmac8 {
 	sfp = <&sfp1>;
 	managed = "in-band-status";
+	phys = <&serdes_1 2>;
 };
 
 &dpmac9 {
 	sfp = <&sfp2>;
 	managed = "in-band-status";
+	phys = <&serdes_1 1>;
 };
 
 &dpmac10 {
 	sfp = <&sfp3>;
 	managed = "in-band-status";
+	phys = <&serdes_1 0>;
 };
 
 &emdio2 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 7032505f5ef3..92a881302708 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -612,6 +612,12 @@ soc {
 		ranges;
 		dma-ranges = <0x0 0x0 0x0 0x0 0x10000 0x00000000>;
 
+		serdes_1: phy@1ea0000 {
+			compatible = "fsl,lynx-28g";
+			reg = <0x0 0x1ea0000 0x0 0x1e30>;
+			#phy-cells = <1>;
+		};
+
 		crypto: crypto@8000000 {
 			compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
 			fsl,sec-era = <10>;
-- 
2.33.1

