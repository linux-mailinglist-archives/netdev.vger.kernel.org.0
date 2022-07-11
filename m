Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4025707E4
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiGKQFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiGKQFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:05:45 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBEB5B06D;
        Mon, 11 Jul 2022 09:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCV/x9M6giHnd0kKuELnOCkEqnBHIuC99ug2wTz15+aU67EWOQNxSRs5vxKa3WlZ0Iioje7rSy/I2a74bdYzh8POgk2ewyx3Aw2uEUQuiv+Q8GwZRbWkcvUs44ZF6C0RDvHABLxxmQtGq9EDPaJLKSTGP8DrwWRkALdVjKrlW8egEwUX+3K7E1PaSfs/Li2JFkYuge4t2HoRgXVXVUn1YcnAqicYtGi0WyOAaJjwFFCRRn/yAOnNF3KphIzqXht8DN0pBDPB7WuILYcChCXfXXRacg/qPRXOQqrC/MdkAvzlv+HjemvmVUXB7zgEUj3lO1qDSHg9U6Gzq2AKBjbiwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iBtrq30T0RrOjtlRzniyo8IvI8c8OArbpgHc2d4xGU=;
 b=ZTTHBL3LAprK0Dpv1BG8Jt078dBp5BUWWqjbeAbtGCJBIPTnGhLqF4ZN65Ng1i88QQZMp3Wc3Mf85ysdi2aWcXKq8uSoQjk6gNdrQ7c0LEQIplemu1kiftyGLuR3CWn32LygAc67SH5hXDIU6ewcrE66jp8cD08QX+VptBmT++jbfL9yBVDEo57gNSmfM4VU/d0vMGj6I7DqBNxa3hL6zzSzRfrqJRug04ZNnXE/TLgD5m6rrZ0Eq8JKWuWyCxHWerz0WXRwhUzg+8hxinTH7ZtJ2U14arpnWZfHEqAN28t/OOLZMKEtGWBKcz0HWaY0DvDQH0vT9CuUF2maJdOOnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iBtrq30T0RrOjtlRzniyo8IvI8c8OArbpgHc2d4xGU=;
 b=nQ8TXwzxxXxrBCduQgp0fQ8LaxEbFPdw9+WH4xekZhUMu6kqMauoA0Q1Q3CfY3/91ovRnq5nXASBrLSUiaInufZyn2KRS5gIHPSLmhVGo/YyMrh8pJnG2TLgCUMzXKXdBSu3gyNH/EOJuc4oASIjyXr2HYqkCCR1KmpiCqUvtualWFjZY5c8hR0o2vKOr9iNMXDIVagVOC+1bSxNYsLCOoi0KNRBVttUFkJAzpAPCoPbj29cjiKcHJXU82m+GGL0cbvFkljb4+4lpsDsc0zgNvazbKVrJZitZ13+Ez7Xn5dnmOZLuH5e3d+lcurfvOXE9tFlP8isL5ZtvTmgX564qQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [RFC PATCH net-next 2/9] dt-bindings: net: Expand pcs-handle to an array
Date:   Mon, 11 Jul 2022 12:05:12 -0400
Message-Id: <20220711160519.741990-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7479ba74-9f66-4207-c319-08da6357350e
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNcdqs+K/4yPL3UCW8H8GoIpyNPEtTfmBxaIkAbZU4OT1IkJEXV6PRV6kVTGgCOttUt+8UcXP2XhqQkIC35gYGV7PpVlugkCh0lVXp0/1Ta8+8zvRQ/yw99SriONvI9HXyim3SRImbLw99oo4AyRjKI+zG+OFxssTlAGCXw5L+Sfulfef1zvWAx0gJCNQqG0P38/mvsF//cvpq6TTkbmlB4tbzAe1KSa+wdC5+BtoQvdcyHM/YrnchB51PXQf7Kq/n8J2nquYgeOhO8xyvNOdfduQx2NhGi7UD4ltFnbE+tvAEXUGaUmBdwWSMwgNjb1onSLJabXr5OHzC7Rrv2L2I9Yte2HMFx4hWD0BkopBIMzJ49V+RjwcUxZ1UJ9bl2RW1uhBj4eL0b67UvrXYjlxp5uZuzyfXHoB6WUdUqhXItgS9N5J8T8FLOSKIjFOAqGVOl4S2dgy05W00j6S/TToUyNhoLkTBDGOzeBSdRuzsynzrbp6ufF+87sdxju475IZ0Cc6qtY7A6Ikzi9UKlgBYUmu/VvnOjzwsnEH0E1S2oF2OrQIUFFCFH6UFU5qY33e9nWwhCJVpteysGJQll8xmEQJvCCDPeepPcG+1BXSj+RJoZycw9+ZB2dPBkQ7iM4Y/+6pDn++AX/s5sQ+/PSDmHKcRjs7mmdKh4qhnE44sHo20UJTRXDlq2+ywAr+Qr2QvVYDrCoMvKXq6vFMuahVGQCgiUezlKaEdo0TbQPat1tKyeYXALoxfNHBLnP1cyfDMCNeriSA4e9oGn47+XXxnBf8pQlQsgJ+TgG25j7jTrBprxc5dinnAe1xIK4WdD+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?enYfwUVt3iaE3E+b4ZjounqXC6cmIAIE3nc3ft1q+WQ6msdB8OlPkLs96ij3?=
 =?us-ascii?Q?+lal+omNdUog2/MHrN14HrqZzH9PtT+HIMhMIZ4rhfUmcac4lni3sNPW0DiJ?=
 =?us-ascii?Q?Be+KAeM1XEgQQtHnabGE/VoAVqHYqvrxLsnrPAL8VZzpsLx/6VnVk3m6wGRb?=
 =?us-ascii?Q?E295Ld9whjZ3km1IRPPOD7kA1LKd572KcqWHbfvuae27i95cRLNkDfgDXeIM?=
 =?us-ascii?Q?ppNFj1rUNg/QrzFf2StA2EyKLnmcVr3H+KdtVwgm4cTIzZ27Xdlbe/Dh8Iqs?=
 =?us-ascii?Q?G8c6FwsKgZHHwmHevxLvRJQNBskaVpobRNYOer4kl9yWWmfBKbrq1CX87wSi?=
 =?us-ascii?Q?IPaSxXoavJ4yQepGHyGL0bge6djBr70shrrp8x2COQaG2vIDHh78Ff49GYQg?=
 =?us-ascii?Q?d/tzaE6xbWA1wrWfGF1ATGjMOHy9hbKGeWrvbO4uv+hHsC46VL7hLm2NwcM+?=
 =?us-ascii?Q?+jddmDK7Rh7ebZC0RoJ3HonUOwKlrTj70x6jPHpaMnaI19Pw8mbAzIlMkmJm?=
 =?us-ascii?Q?D0QikzM8wZPB9hOYcWN36GwearLFt8x6IEJ3MS2xcntv593+JyowmXkA6fQv?=
 =?us-ascii?Q?uyR85Uj8ry0fl3/ykvnItnG20ycYTmTQAkGgEJJNfg6EkbkW5C17dFatq37U?=
 =?us-ascii?Q?AbpKIZ22uj0vG6Dcf5MU/RowQrwVagM2K1we32gJGJsyMXOIKZYz89v3PlHO?=
 =?us-ascii?Q?mgmnBHiCOWBw8SsZ+34h7rs1KhgPPnnuHM/AMBOgj//Z40/WMBXWln2n1TUT?=
 =?us-ascii?Q?8QaWx9DAR4CzSIZ4GIUHAhQ0Ym6Olzb43co+SLgmWd1RSU+bDxWpKoKK+RyS?=
 =?us-ascii?Q?7xF5Pc9tb/iHjEfzoskRUxsTmGnEhalxlAW5nDNLfVpz2V8Okih3sRHuLu5d?=
 =?us-ascii?Q?vfF61+tqbat/Pu+lSv8OmGMmgCED8X7DJ7DmPcSLPljL0G1jRB77/1Yt3NmG?=
 =?us-ascii?Q?KPGj+6kkuamWhUsiXTvEdfjKTzGotPVL1SSfkbOwfmrv5LMctWQ3G6Rma93Y?=
 =?us-ascii?Q?ugOYrgFb8kV6mgDPWGvRCjDCkp4BSk6qNl1KZL+IN46xVvclYwrDvfik7DPo?=
 =?us-ascii?Q?E42CS4XSkjfbDA+Lg2ayiAERwE8xltKJN28TdsJwzc2n2jSpWmjsWR62bAu7?=
 =?us-ascii?Q?++dWOO4FkVuLou9g1A8V36LfRg4FjJgkmSnNPbZlyqVfm8q5dZhlH4E0RAN3?=
 =?us-ascii?Q?yCNo/XePOGpkxSZDyubnF/sTNznc1GYyWQYG/X6IQMI9QJzLZnmT1jo72yJu?=
 =?us-ascii?Q?k8sySXl4C57T1crsfgbd+IoKVWrdq40Bd4dOHBrIFIQr1zuITBcRtp/h38XA?=
 =?us-ascii?Q?4en/Ty5RN+InbC0fVf+VSx+NzU1rakTYKuJtYVyRo+mhGl4Ibhf0c3ZuR0AR?=
 =?us-ascii?Q?Sfj7CdZC40iBwaJluKa0XY9GHRCXVaJmMDygBxc46gvlbjdooAE7lcaxkMhY?=
 =?us-ascii?Q?ub5g2TlXT4x+BBL6EQizkxOBFF8dL75rs/fF68s4H1SWe2syaMVp6jwDcmX0?=
 =?us-ascii?Q?hdevBZOaNzSpPlPmHd6q4poisa48X4lSL9fk1+xEr34V3VYi4ht7aeHjaKBZ?=
 =?us-ascii?Q?l0Gsq1ZI2j5YoxEwlzl/80I6tV+U0zx6aikEHYh6sO20yTsSRzhp7qKmK9dV?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7479ba74-9f66-4207-c319-08da6357350e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:43.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGGF4qSNEoCa22JE4L/kYf5OOuLgx6i5b/JnlGfJ+xKbxeKlsWD+NhV8tY0MRgBTfgZ9Iwg0DN2NH6FtW1ZjAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows multiple phandles to be specified for pcs-handle, such as
when multiple PCSs are present for a single MAC. To differentiate
between them, also add a pcs-names property.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../devicetree/bindings/net/ethernet-controller.yaml       | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4f15463611f8..c033e536f869 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -107,11 +107,16 @@ properties:
     $ref: "#/properties/phy-connection-type"
 
   pcs-handle:
-    $ref: /schemas/types.yaml#/definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       Specifies a reference to a node representing a PCS PHY device on a MDIO
       bus to link with an external PHY (phy-handle) if exists.
 
+  pcs-names:
+    $ref: /schemas/types.yaml#/definitions/string-array
+    description:
+      The name of each PCS in pcs-handle.
+
   phy-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-- 
2.35.1.1320.gc452695387.dirty

