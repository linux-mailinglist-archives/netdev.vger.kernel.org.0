Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DE354FE5E
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350274AbiFQUdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346993AbiFQUdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:33:41 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EA95A2E1;
        Fri, 17 Jun 2022 13:33:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvCX7sXoKjmsAsX1Q3urF8cZ6nmotqp2N1uHbUZuMIUR1LtWUpZ8tRbQOFhPz6plkRDbAxOo87+FOhG6oryKULC0evhInWpdL0f8WsH+T+MiqItdeIfM2Vsxq0ubdfIgSNy47a85sTb6kPW1BZWeG0bWoMsveiX53t3I6qKlqvf3/x2JCIDyJkN+q/N9BFf0Cgxr2/veU07vgx83KWsZ5bQLbtrECjn+obyF9Cbrnc13qTwyClPA9XB6+8YrjcMdKlZsfEzr7Y4w8mR3IOjgrn4QExmRqiAW0YFUPsfH2FeE+d+dfH0/QZwVH3A8+rDTn9aOFiMDmWdvuuJjl6vPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zyj/IJmSRlxLfh2wYMw1EwqZzLeNjYFdA+pV4NCu+/I=;
 b=JSZQNhNMKX+CXUsivSG238r+41YpEZNHr/o7RviY3aJY/iqyqvFlXNJH1ofCuVe0qGSASujO3am0fs0DoWguvlh2xZ2omCxyvLkH96S5fvpDn7JdxP+vGbhUs6l0scwiBQlx7hkGEQ1NDgOnwV9sJbTvVC3JLWnslHKpiQkXkHo70czsW7hs9x3pCEaQB+I07+TsGEFCZJhDB7dLDVIgF5QvRoTRFYRtwbEUJ/rkt8EkgWoxqrxh8YSiUORMX+XTbsrZrvkArBNTDRyxe52mxxEnQFjaokCsQgpUzSJ5U3RxIiN7B1hwvz6ohmemZGpEdTfgQ+ypGHtt52VcWYWbGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zyj/IJmSRlxLfh2wYMw1EwqZzLeNjYFdA+pV4NCu+/I=;
 b=wkSSndBuQ72Dinsg7lkAw5pR2AffpZ6GpeJWATWf8fpxuhRlYbw0X4P4/N/h2Rzvlmx8aXRokwp6yd8Z8dox7lO2WvpFrLDVEQALYdNP2YYfj82AYulgXnig5kORqhxw7/uzZSbZwh06xaJzcbqbjF4lGMJyuyVl/yt2uWeaYlr/Z5dWqNDBkt8XTvI6YvZ6dFXpTQBdpf3NVccl8FsnD7bwiMpwNhkwxVo5urRuszb5oEkZlv3gEV4zqKLAqWiwcRJTLip8tlpusFSxAwBcIJTwvuQ7T8xPOHO0DX7lYMY0tuRUZBwxp4wLC4CGXh3lEsIwHKlJg0nwxaF+aYh9/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:38 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:38 +0000
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
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next 02/28] dt-bindings: net: fman: Add additional interface properties
Date:   Fri, 17 Jun 2022 16:32:46 -0400
Message-Id: <20220617203312.3799646-3-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 460f1894-8877-4f75-597c-08da50a0a8bb
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438E568673A1AF272D63B9A96AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QcPa+Wtgd5cFCo7mSMQGgEh0zaJl32pCAy83Vww4Xwvz6xc16pAw7ooCf0dLb6WnaYQEg+r0Z++zY6zbCrxQpYFm7eDSrr+6qCZVOtRRgdOrfdQW9fw7begVfqdu8V2/l6v9PexpcPK9p5CeXcyR6mMrqO1f6ZrVInx+ZSYM8Kr42tJIh3H2wJcq5pQte+a1zqbc57U5xDVKdCTfzVgGIwp/RTp+mjk8emApKmF6EsLiaKmuOjkjO9g16z+qaX8DkHXUb2n11amRvI0jzZ7YwzrWuMSRdzjdj/dNlyPXjUIeNRPzjVuUyiadsTlqSpdffzX5yih2m5TVysP6T2wI4gxyK6o9ihlSYs1vz6lQHSBr6r+4D47vYxDig+7ZK7jOrccQPKheZorbU/dMpsTv5PEY3EaqJfI5pxCKUka/QDW6pdpzJ59nw9tptqAbilbMaYUckTg5Zh7pgqF4nW0Au7BUqWfB52BzD91F0kg19sSuEuk6ItRQl9O02ykbqSPJ59Jz78qAV6Es25cBaqqeBE2nSd4se4mi+eXR/9IGE75j0jXONaSJfP/zontBitabwYXye+SiwImHZzzrmL48XRd6U3YACCXAa2OWgnOHDxPuqVX4Ytv/Ewp8M581ft/iUNQM54PZEsFBmq6ux+0wZZ5x9ePTn+cCQk5zpp0J9UmfPAXEtSVY5D5ODiYvFYmIWXGYx6/hLeP47D9xOnoXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(6666004)(36756003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eA3YThmNpY6Xs2YWxLue1x4xsz/1PpcZbPzxmdX6PtJlPG33mqpbZG+pp0uJ?=
 =?us-ascii?Q?+a6glojD4t6PGygQcnhDQar0YdUIB8op4EttCmnRN6Zy1l4mZ9G9V8ulYfKn?=
 =?us-ascii?Q?89kDLKLc0xd+3rEb4vTegWUcSIjpQOckOvemJhMVbHSYIxC1zINGYtnpo3zn?=
 =?us-ascii?Q?zSnSsVRR3TQ59MIjwMDx0HYZSNVvIBj14aLgAuqQnwJeodSnh8XzlMX4sc6D?=
 =?us-ascii?Q?c5VV4rttWrJ6HfiI8Gl4PuL0XYStLFTBhfl+jGkXto6vCO5P2S3n6rpi9MBn?=
 =?us-ascii?Q?NZvqC7UNa90Vq9fM3gLUEnE+uXYeIUuPeu21sdor7Kh+qgX016E8twq0KsYJ?=
 =?us-ascii?Q?pRAa4jOwmmm7GKJL5xPYV51HTOSFYnox3Dmcq7zmMsyG1Enqze4PHz+9HUfM?=
 =?us-ascii?Q?8cIlG4vo8ZCwQA7ixAy8P4vEYmtqNuGsnwI43vpcBMkYln1KVFb3aPv7j9/G?=
 =?us-ascii?Q?9Kbi6wJfLxp+3oIdyDLoLjSQDZZ0bxMF6ip/du3IuniXmTgc8rtYi9rPsf/n?=
 =?us-ascii?Q?LbPMGzSp9x7CRC6Wqp1tY+ll+r1d6/Kg74m5kaU1nqkt0f/qiClQJQ5cMtjI?=
 =?us-ascii?Q?+9mUFCbX69gYP4l33ZS7+NIyIItceZn8zLQIsWqM4D/z9HQvjx7O1kLg5kTx?=
 =?us-ascii?Q?O0V835plupqTQpsD2YiW3FlnqLfjIpfLsOvQ28AKtd51H4DY9QqFUjT6ZAaF?=
 =?us-ascii?Q?3+E/MZrJMHW+nb1+tTjHr0b2uDcZ7MvBWvpAgZ7kU/5AzblUHDdH5TCfxbDQ?=
 =?us-ascii?Q?pqHxgCOgNuVEONMpQVpRzYKaRgd+BA6RdBiObdh24wqYmlnYSu/lg+3HFW5e?=
 =?us-ascii?Q?h7qT+/LTwvu94+aP01GFy30q4eEJxHF51ovVC29s7o32czYhrbN0qWSxsCh2?=
 =?us-ascii?Q?eYOGupx6mgiJQFecT5rpf3D74YtznjXk6eUfcgdzNGuzKc59KhJxz9UnlMrY?=
 =?us-ascii?Q?Byl2qu/bAym/vDsM6dxF7ylLlSpSKiri3cy0srPKAMVTEKtx1zOTGP2bc86r?=
 =?us-ascii?Q?Qr7ccGARqVTOkdUFLUzn3JlhbHphdE/yL4MlsYTe7c2nc43SevbBVIujze+8?=
 =?us-ascii?Q?Sd7Ggj407X04uCtE8D9Sta5xrYjs3UTIceXNK8zZWgW3rafVMnL1y7i6jQP4?=
 =?us-ascii?Q?5rO5axg4hSsKNd1+keK/T1ys/sZgzJjSfB6ROPE56KBvHMT1rQNt8MylM3yY?=
 =?us-ascii?Q?+kw6iw6GLLew1Yn+PduVEzXCeLZUuCfyPz11Yn0J9iryS9x7bL0tnQa2ZI0k?=
 =?us-ascii?Q?8rDKmnRxUiDEstsd/IISHIZlWV+yps6SR8sfSBchnwlTEhmgD7rzqKD39ZaI?=
 =?us-ascii?Q?KXYnXAwAs3tUGoFfkcbteY+yNaxCPbqivc4R5HccNIfmGUhXWS6PvZRpJ0E3?=
 =?us-ascii?Q?FdfC8ONLzkMns7y2BJtZ7T53jOmJM24P9168cmd3r3/Dia5HM3IuJIs/ZkhG?=
 =?us-ascii?Q?qT7oHgUdJOA9vr8EGsoQVoWaRQjZnAye6x95YX4u4yWexEf6zEiFmJEWs79P?=
 =?us-ascii?Q?Yd8Zlcy3OpEPPSSp9vjB5cupxbzhg5zg0NSTWOwRxHmQ1ukuNtF5LK0eLwrb?=
 =?us-ascii?Q?xxaBqdkZlu2va2xORSPFwnATIA1h+pAH9XCMmi9MLIohmKmePmChkCkF+tV7?=
 =?us-ascii?Q?o2V8aguYz8LdOPHc+Q2/iFiBrpfJc0nNzwsImCJ4F5FmPM6CHrcIvZHKebsY?=
 =?us-ascii?Q?uE3Iys3ngWJ44iBKjqjZRzy48c08j32NU/lF2AoMhrsRBpZGSWylqIFZP6Xx?=
 =?us-ascii?Q?a4ijhoAsGGFZdrs5ky2hKaulgB8rM7U=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 460f1894-8877-4f75-597c-08da50a0a8bb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:38.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0kanxtJ2z37DRnn9KblS5AoQhsztuoJw+VIWbQ/LhioLe1sRjKRpq5/oZ5OMcubhj+ovMxRrdN/S2PlImzrgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, MEMACs are configured almost completely based on the
phy-connection-type. That is, if the phy interface is RGMII, it assumed
that RGMII is supported. For some interfaces, it is assumed that the
RCW/bootloader has set up the SerDes properly. The actual link state is
never reported.

To address these shortcomings, the driver will need additional
information. First, it needs to know how to access the PCS/PMAs (in
order to configure them and get the link status). The SGMII PCS/PMA is
the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
addresses, but they are also not enabled at the same time by default.
Therefore, we can let the default address for the XFI PCS/PMA be the
same as for SGMII. This will allow for backwards-compatibility.

QSGMII, however, cannot work with the current binding. This is because
the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
moment this is worked around by having every MAC write to the PCS/PMA
addresses (without checking if they are present). This only works if
each MAC has the same configuration, and only if we don't need to know
the status. Because the QSGMII PCS/PMA will typically be located on a
different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
for the QSGMII PCS/PMA.

MEMACs (across all SoCs) support the following protocols:

- MII
- RGMII
- SGMII, 1000Base-X, and 1000Base-KX
- 2500Base-X (aka 2.5G SGMII)
- QSGMII
- 10GBase-R (aka XFI) and 10GBase-KR
- XAUI and HiGig

Each line documents a set of orthogonal protocols (e.g. XAUI is
supported if and only if HiGig is supported). Additionally,

- XAUI implies support for 10GBase-R
- 10GBase-R is supported if and only if RGMII is not supported
- 2500Base-X implies support for 1000Base-X
- MII implies support for RGMII

To switch between different protocols, we must reconfigure the SerDes.
This is done by using the standard phys property. We can also use it to
validate whether different protocols are supported (e.g. using
phy_validate). This will work for serial protocols, but not RGMII or
MII. Additionally, we still need to be compatible when there is no
SerDes.

While we can detect 10G support by examining the port speed (as set by
fsl,fman-10g-port), we cannot determine support for any of the other
protocols based on the existing binding. In fact, the binding works
against us in some respects, because pcsphy-handle is required even if
there is no possible PCS/PMA for that MAC. To allow for backwards-
compatibility, we use a boolean-style property for RGMII (instead of
presence/absence-style). When the property for RGMII is missing, we will
assume that it is supported. The exception is MII, since no existing
device trees use it (as far as I could tell).

Unfortunately, QSGMII support will be broken for old device trees. There
is nothing we can do about this because of the PCS/PMA situation (as
described above).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../devicetree/bindings/net/fsl-fman.txt      | 49 +++++++++++++++++--
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 801efc7d6818..25c7288e1db2 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -322,10 +322,50 @@ PROPERTIES
 		Value type: <phandle>
 		Definition: A phandle for 1EEE1588 timer.
 
+- phys
+		Usage optional for "fsl,fman-memac" MACs
+		Value type: <prop-encoded-array>
+		Definition: A phandle for the SerDes lanes which should be
+		used. This property is required if a pcsphy-handle is
+		specified.
+
+- phy-names
+		Usage optional for "fsl,fman-memac" MACs
+		Value type: <stringlist>
+		Definition: Should be "serdes". Must be present if phys is.
+
 - pcsphy-handle
+		Usage optional for "fsl,fman-memac" MACs
+		Value type: <prop-encoded-array>
+		Definition: An array of phandles for PCS/PMA devices. Without a
+		pcs-names property (see below) this should contain a phandle
+		referencing the SGMII PCS/PMA. This property may be absent if
+		no serial interfaces are supported.
+
+- pcs-names
+		Usage optional for "fsl,fman-memac" MACs
+		Value type: <stringlist>
+		Definition: The type of each PCS/PMA, corresponding to
+		pcsphy-handle. Each value may be one of
+		- "sgmii"
+		- "qsgmii"
+		- "xfi"
+		If "xfi" is absent, it will default to the value of "sgmii". If
+		this property is absent, the first phandle in pcsphy-handle
+		will be assumed to be "sgmii".
+
+- rgmii
 		Usage required for "fsl,fman-memac" MACs
-		Value type: <phandle>
-		Definition: A phandle for pcsphy.
+		Value type: <u32>
+		Definition: This property should be 1 if RGMII is supported and
+		0 otherwise.
+
+- mii
+		Usage optional for "fsl,fman-memac" MACs
+		Value type: <empty>
+		Definition: This property should be present if MII is
+		supported. rgmii must be enabled for this property to be
+		effective.
 
 - tbi-handle
 		Usage required for "fsl,fman-dtsec" MACs
@@ -446,8 +486,9 @@ For internal PHY device on internal mdio bus, a PHY node should be created.
 See the definition of the PHY node in booting-without-of.txt for an
 example of how to define a PHY (Internal PHY has no interrupt line).
 - For "fsl,fman-mdio" compatible internal mdio bus, the PHY is TBI PHY.
-- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY,
-  PCS PHY addr must be '0'.
+- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY.
+  The PCS PHY address should correspond to the value of the appropriate
+  MDEV_PORT.
 
 EXAMPLE
 
-- 
2.35.1.1320.gc452695387.dirty

