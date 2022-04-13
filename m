Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7D4FF4B8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiDMKh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiDMKhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:18 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BA3255AA;
        Wed, 13 Apr 2022 03:34:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1vgakoqOOZOJchXfWJHlIczGBRE38Bz2+TfMeTNT5M4G8BsJPssYqmOaemv13ceDbUG4ut4kU0E829y13pDuGif4L/G86olawVQOi44sHL8LjA0y9ReOkEO073Y5EVUwoNt9N9NmwbHJjbZ0Q8SG7pOwt+orTO2+ZN98c+uLQMWWnyP54rWTfB6BtgAOOrBGZJxxnGkyhdjtLwxyzkMnjqpJkodd+32iCSYKJDWE08HI9yKk2Muou7OCvrV5kqGGE8PPnlke0wfV8QkfwTIPLc5txoFZDYQDJQkxsqqN4qA40Brhi55tMKLAsGzJ7V2UqSSORZuxbQaomh8E7MoTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85UFeRB/zGVi6eE47DWbgwvrQqugErgznrE2LXvLdKw=;
 b=NlX3Zso+X0uIN3Ylg80RWIYWLaVtDteVYNZQ0KZ+TVDGVbKgCExnIhZJ2/EQfYtPts9qRWSY5d2JuQpnk47+S7QJ2nj9KyFKzQNQwRPeVcx1pgOhVAckg/1/vvTIASOV7pir6a3ah1CbTr/CI2iYEIIBCail7U0P68nM109lZQOX6aaX9NyxlV5MyBMmoOg2UWhHHVOq8eHV043//096yyeC9GjvvCpxyEsU1FhTACbJLGchRTI3CcbevuTNUnqXJ9PNmOEPozky4lEo2FXxipfNAqzd1JUL4bcMbWhZdTyWiFI7SyRFZD+Huqi+IcX9wiCDe8aKf99ioyfYpnI8fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85UFeRB/zGVi6eE47DWbgwvrQqugErgznrE2LXvLdKw=;
 b=RSKfyVn3K8JLVboMgcmflb5JAYCSWdtYviI9YbozEXlf0Ar/nRkUXC7joEy/KDGbIFTTpGke9H/Fp74lT0cwB1ma2eD7yQGSZVLKWbhxUp1+pL/hF3ZcXjdTcfVpPzB+97MFKSJO2W2mpxk6EMzoPgROduEO4WVAsc2MqgZtNgk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:46 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:46 +0000
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
Subject: [PATCH v6 07/13] dt-bindings: fsl: scu: Add i.MX8DXL ocotp and scu-pd binding
Date:   Wed, 13 Apr 2022 13:33:50 +0300
Message-Id: <20220413103356.3433637-8-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c70fbd65-d29c-47fe-7e0e-08da1d393ad8
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8691480D84E2520C623799FEF6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6zXj3891UQY64SFO97tmDLgANv6N2PvkvBWlxd7fuV4z9WQuoRrO/97CM95b/jcc34d3bBqfQFvsmn5xGr19OUrZC1nGbI4W8oX7IrUkN6qQNSK5dwp2YtKLy5ITzZ0KV5UsDDGgWBiuRGu4Rkjl1Y5oNAbUapbPCXkOGyhez4E4Yy/eCvuD0hIZ9P5OcVmaHlPtkg2Xb8alWmLceaybnqe5QNFu571htZ71aKsxTm4hFny2YheTr8hfXZeZBg86aD5HxwK4S7Sr6EweTupgGeJ+U0L5LaHwp7Oy41xe2aN+7huAsZdKKA8Gi6tmB6pj79Z4kGOmYm0RwO2Q0RFJfibJazp4WzG6h5gIqw7cAbPHoTJZy3BvSdzI01iJvrhPxDorX3FZtYX2XVK8lu8DqWC+dsquACwy9ejzc2PNIyYbgjr44o5EFvI1byMgPYCVLOc3pcNDUK0xErRANylxOJqST+WRQq6VUsu2VmfIzpimot9apqg+bbQO99EJwZy/4la7BjpuQGfQuqmn3hwwZeoehMwYyAde6VXgrpzwFx46DGRguk6/b2NQvG0Szq8K3cKMmWhlnpXQ9eLd5+mIx6P6/pPCxv8IX2n/F8PRAeWD7e/UG4zitrvyHY3/BtCNM2/BydN6A0FUJb9sfUebLg6hxy17XUu1Zr9zA39+f7eq5McJbQCoShH0Yf1ynmKp7kzuxdQ3wG/tBEG0rHYZyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(6666004)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3JMfTEKdSNsnVyoFhYka60nr84wKexH+2vDw7rCJsdQ8XSOYYqffs06bSgmd?=
 =?us-ascii?Q?gv02FL/LDw+26shBXMVgi+yZ+N2ErP5M42XKAf7NYoUN9xBN/8CNJ16EIZlX?=
 =?us-ascii?Q?i3SoRtO/UWT+NKHlDEfZ9EX8B8DZ5TwNhJ1YNQKvn90nyYEdQrhGTEVbURga?=
 =?us-ascii?Q?AKvqtJ8a+fCXXPGYFaaJc+GxY0Nzaf/Ru0ytuER8yWYqX6ufLZ16E46FA3y+?=
 =?us-ascii?Q?w4gDZwKuH82Ui9L2Bw8gjCgS7g0SqTRNXQGxIgOJXldemL8XmS1lqOjkGR52?=
 =?us-ascii?Q?xvzqj32Ru7jAS229ORYXopnHZyEAVjzn2NHFLtLaALk/clAXgNYBBBiJqwsw?=
 =?us-ascii?Q?HQ23Qe9+jlOaQvqftrKRdeiRwAhFErihT84IB2jax7GAHEv3TS2SuowSZLMR?=
 =?us-ascii?Q?4xFhW4Vvojr7bSw94FzZVYZuRzTXqR2ZSbF4i4S34q2EmWHyOVQcdI1nAxfA?=
 =?us-ascii?Q?WvW/dSuZeqWBOcsTKrzNyj8UwrvndYn/smDbTA6sq90iOgTnNyA+uKdl+XC6?=
 =?us-ascii?Q?CszWBi16HGQGMEpA2MLorQHnnhn2k7ErahfMOvce5LWANyI42r0UPOYlPnew?=
 =?us-ascii?Q?0p2QPGYFBE/lFgBFPanfpgNtOxReELfreL7OryXTlr5S2zt9Jpg6eXZDIW6P?=
 =?us-ascii?Q?T6/FK84FOxGd48vvXNTFJxuu69WH4/yL0ZPqcR16E/MCPzyL1xopKxpfKVUR?=
 =?us-ascii?Q?YjHHVrF4TmDi/PPopg0U7H2kTyJpxF8Ng0iA3scw9S8stFeZPjyWGElq8rWp?=
 =?us-ascii?Q?A8SYFkQibEi96yH7hhfbS5cdMmcivABDQXndpFlWpK5n6dWhMvmJiJWNvww9?=
 =?us-ascii?Q?gPYKOyzLtcqAqy/HLrrfpGUsupg2NzQdjD/Rzx8BxieKrpEtUA9tsdrpl4H3?=
 =?us-ascii?Q?I7PlLXvg9axu1T+JFDRVPeZbwxUPoN01iP438mKLe25IUj75Dennc1ZaEaSv?=
 =?us-ascii?Q?WtMu0kJ8rpRaauqI3NW7+8Kh5w5uP003uuqL9U+khL9AMgX6XGezgSEItHm2?=
 =?us-ascii?Q?eDCKYmrfKGd5pRA3fz1LGmSKOK98foWqts/hxCPsChK7y4kKNkonu+aT8SVO?=
 =?us-ascii?Q?mDJuTaZ7Qrh6jh2mFa2b4I+2SizLaZWQECwzd8F/VGU6qLOB3z2N/8q6fS5R?=
 =?us-ascii?Q?Ul3wK5JqCdY9fLtZpFzTAxi4FsGQnpGMTL4Zysg1snF3td/huMboGg1V0kjR?=
 =?us-ascii?Q?hEAIbfNowyc2h9GY9z0q69yn8EI08PfE3LxXSgjBpYQI70SdQvObUUjZb5xa?=
 =?us-ascii?Q?oSkyq83z0TGAwUlKt1g3gjR/ebttIT/cTMmZQ4vocGUkRxpjCX8pW6qOGKt3?=
 =?us-ascii?Q?13BdZZcBJWJwuSRXz/UsAvJVoD7nL/TeVquVucEueHxwrOu+UjX5AvQ0hcxK?=
 =?us-ascii?Q?KB0Len/eFrZHidxyqQ2Amn/moIp/Gp7o+h4+arn8G7eMXst8Pi5HTzL/ugG3?=
 =?us-ascii?Q?pJEcXQTXjJ5vVLH05jGfqQM2uRaH2fQDi9m4h026+uIhRKwMQ0rHX5naTVW6?=
 =?us-ascii?Q?GXBcvmdjRkEhM33uMqmoecRb1PaZKHpW2oMRUr0jGfLEXuJuavilfSGyDLEP?=
 =?us-ascii?Q?jTew6jTzpg7GBkqiUqm7xPnpobRMVkRXlIDfbiKpR4wSjD7D6CCOR4+Ma88F?=
 =?us-ascii?Q?dGlgECVTtXPhL63rYwm8OkVlaiNfQDC6v5wLRrW/dniPKtol6egEZkhmzES5?=
 =?us-ascii?Q?DOZLbuVgTAEa65PPaPZF6Ua9KCMtdbC9KdhZQRK92m7UexTCRkHu1ELkvNRl?=
 =?us-ascii?Q?UVnJ0T6idA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c70fbd65-d29c-47fe-7e0e-08da1d393ad8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:46.6766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2gTs/4YGvuuote4JkOQy74LREcdPcLQ6cQWQg83vC8RrkBtXJPhXk3eLh+0t83saPZfgEl+Rp2zC4YIqI351Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL ocotp and scu-pd compatibles to the SCU bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>

dt-bindings: fsl: scu: Add i.MX8DXL scu-pd binding

Add i.MX8DXL scu-pd compatible to the SCU bindings documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
index a87ec15e28d2..27a2d9c45b0b 100644
--- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
@@ -70,6 +70,7 @@ domain binding[2].
 
 Required properties:
 - compatible:		Should be one of:
+			  "fsl,imx8dxl-scu-pd",
 			  "fsl,imx8qm-scu-pd",
 			  "fsl,imx8qxp-scu-pd"
 			followed by "fsl,scu-pd"
@@ -142,7 +143,8 @@ OCOTP bindings based on SCU Message Protocol
 Required properties:
 - compatible:		Should be one of:
 			"fsl,imx8qm-scu-ocotp",
-			"fsl,imx8qxp-scu-ocotp".
+			"fsl,imx8qxp-scu-ocotp",
+			"fsl,imx8dxl-scu-ocotp".
 - #address-cells:	Must be 1. Contains byte index
 - #size-cells:		Must be 1. Contains byte length
 
-- 
2.34.1

