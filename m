Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746AE5982A0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244466AbiHRLz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbiHRLzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:38 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB5B0888;
        Thu, 18 Aug 2022 04:55:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhsVvFnRHcFMtiGX19FgdAFZOx21F5a2qOiFrGRO40C42E/JVo4VVXQn13O9ho5eviQuIzycc2r1dLRT1hH5kSdxSWPJnL9pZAxqcanz1qFoovnufL+F4+CcnSIGFDyvMM1fPJWpnuYSnl4vgUgrlq0EYtJLTb5thhoYYA4CkkX04YgTt53JED6RqSmljXMBZwAtItjnWJm2dSuxzfFCr86HlvysJZYqM1oZtgBg7Xx4VzjATm0UjjsaP5yIXrBD5GX0ejTihjctO68uAW2LqujMUoVtcllnuJAlqjnmYRspsaRBz7Wpi/rd5DkKYmpgz2Zjr1LljK2ISaH3tsWXdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etDjHL0RUesLtuuilHSEWtiiMKwuRyazgzjOV4yR2mw=;
 b=TOYrCg7yt0+OSQC6MbwRvpatdYoP8NMWMxVzULF4sMp9dYNNJVcFsCTOV9pGpPXCr22WAhqIU5Isfk5w3y/GysR3bNnz9c7HhmtdbogowX31Hmt4UIC0LqzuNXrYKMN2yIiPwlQdhb+VRXaoxcqfGjRfA/OTYTi5azL9Gpe6CV2aqq1GdxU3h8KGj4FE/mGfWiT4xGJiC9NTRjhigLCHkfoNRzkGLXvvwUYw374+t+eXWqHBDQGVM/Bl1qTDvXBuMaOeNcNtMcpD4fbSE0xyzAdh3xs1RoAgLc0g8VKTsS93NsMQTnFNCbCLEeOVZQhryRO2HK1ln/VDd3EtpTEV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etDjHL0RUesLtuuilHSEWtiiMKwuRyazgzjOV4yR2mw=;
 b=nUN4UIP4JF/pwXVp8RqKUF+bXK0hENuft0a35ogx5SkkzcuIJ2I3g32jQnZ/HB4Nrwrom8hYkI+0eae64nBZc0n+6bKiXmkNC/W58RWDlL7QSxjABsI6BzjYoyMLCN/kcr45c+1hc01tN7w8OIw/pra6hYNqiddni9ZDNomPd9E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v4 net-next 00/10] Validate OF nodes for DSA shared ports
Date:   Thu, 18 Aug 2022 14:54:50 +0300
Message-Id: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b87f59f0-c342-4223-6bdd-08da8110887d
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbUBmlKMAfmpOVbEss8kWYP9de+08KaFrNyBMAFUT9NoLcL7eHi6kHOCmmrbkEcvyoJuEuLCStrdahxuhw1MMflBjKPD4fksyH7hld9o/TZt3Ro06QWzF8lDhq7uH7UEa0dq1J2qs+rJVKxprX8PvmBLdTSAdyTzXe9T87qHtK7AefpfRYkpeBcJpyFiRzb1SoeAw969IXR1K/OjW06c85o0FO47vQKSxl1usExSVI8TISf/HHzt6yHSv/bre+sUVcU9x+e3hlayA0pe0U6yFJRifirHIVE6Rp+iHMHFIVYVsqeEKmn4hGGt1ywST1AjX/vlp02lCUCMsliP/IQcAinyePFf5+sLGy65p0Skh00NMQuNyJP2aCHQMnGg1rhfN9LFUvcM0Qsya29DhO4pnGG3AJAnnQmcz/tNk9+gMDx3vMDIcIkC3IS7zo7HZAW8vINM8689eX5hLqfasDrjalMzAkPMtmufgw5Is3hW7Qif2sbYKPm8meCl8bSPcB1Pa9em+8D0QW6/0YfAMf+lL6deDCrGO2mlDD3Qc6LBOVeSnDj17XbUhyPu1HZVAe+kQObPOcrGl7DiZPSFmHYUe6IG7SYRs1S4VaKB7ZjQMvZ94ffxReHdv6bCjyDVUcLThRpfI/Oc1zDbvDNIJ7wvC06W2CrNvZ0Jt3dgNB14Q24XPodkC3OOnS+KV10wzCUlWVPSR38QOxMKDVgP1u5rfAmx4DZArJxSOF1cLjgVsTjhZCD208onvzBDeeCVejcZUrV5/W0FELqtf3GXgYSvAxCvCMj7IJIY5ReXeDMTqrNtHIef/qRnqAC7N63cbpsYCrCu/UkTcWdI1zMiNUzwtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(966005)(186003)(6486002)(52116002)(83380400001)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1BnMzJlVUVtQkpRN3VUSVJoTVp0Q0pnTkNQekdZQUt2cDVndUNoYmxhZWZr?=
 =?utf-8?B?cDFCWkFUcXdSNlQwUUhQV0U2bzMwQU1ka2pkSXlsWTRHNENMbjM5YWZDMWJC?=
 =?utf-8?B?anpwYWpUM0l2cWEvTzNNbWZ4QVlHMmZpci9ZZDJqdlN4TkN6Tm5QbTE0dFJ0?=
 =?utf-8?B?NzBWR2Q1dld1cTNZU3RLQ1dVcDNNTWFXM3c3Rmg0dVU2RWFocWtGVXB2aXBX?=
 =?utf-8?B?V3pMSGZRcVMxSVBGNER1c2sweG5QOEZTK2JDZTRsZGw1cmVrZzBZeDNxL290?=
 =?utf-8?B?K2pUMG85NkMycGpvRmtVVFF1akhpT3BkaEZ5MU03MmJybmQ0SUlsTDd3dW5s?=
 =?utf-8?B?SWNFem5BSnROOU5PczVNby9rSlBSS0tjWVcyZmRoUWNMNFBPOTJGODg5Q0I3?=
 =?utf-8?B?R05jNFRhSmR6MGJJMVRZa0FVcjkxRVZHbzdNUStCbVZUa042clBKTUkwSDRr?=
 =?utf-8?B?aHhobGF4MGlCV244L2ZJYjFCaFUzMldsK3ErQjNxcFFnUVFIcUhGVEdwcSs2?=
 =?utf-8?B?S3E1YjhubVc0L2xXQngzd24wMk5zaTNPNlNzUDJtc3hETVZjb04zMFhIRjJl?=
 =?utf-8?B?TXFaMTZrcWQvYStiQXVqdkZEWlVacHRQTHYxNE11UXZtVUJuNXkxVHpSMDZM?=
 =?utf-8?B?N1o1SjFCYkVtdFhiUmFzSnRJc05jYnFFWVJtbE5tam00b2Y4WXhyQTl0Ympn?=
 =?utf-8?B?VjFYRmROSk1oQ0NIMzhMR3VZV1MzclBvRnNpOVR3cytXYjJNeHdmVzEwMkNi?=
 =?utf-8?B?S2ZrVThyOUl1Wm0xbVlkOWZXaEZ2cXltdnZ4Q1BFK294WnhzeTZVcEhxWEVB?=
 =?utf-8?B?TmF5K2JBSkEvUW4valEvNzVTNGZkQlZpRnQ4VjM5ZVRHMEVhcUFkOFRQM3Fv?=
 =?utf-8?B?RXhJQ2ZYbnlocXdJRmVqckczMEQ5UnVPOEtsaGpoSzBGcDMvUDV5V2RKR1dh?=
 =?utf-8?B?emhrUU94MS94dGl0d0xoVkhPbjlaWHdrNXdIcVRLdWFoeXB1cDRNMm1DcXNs?=
 =?utf-8?B?Yys5ZnkyWWlZbTNsZnR6YkYwcGFVejQvSEk2dUg1Q0pTc3ZZdDFCUGtFczMv?=
 =?utf-8?B?VEhYU3Vza08xZFNvSExOSzdkbnlQOGFjV3poN0lGUmQ5dUFrbndhQ0dFWVdq?=
 =?utf-8?B?a3ZjZUNJTVB4YjVFY0JDTkhZOC9DeFBmV1lJbmlOdWlkc2NZaTlOZHE5SUMr?=
 =?utf-8?B?SG94TW5WS1VtNURIY2RXQmFGUE13MUlzdXFwR1lJcnVBcEpNYWo3dm9SdHEx?=
 =?utf-8?B?ZXY3TWpYcDNDWFJudk9HbUpQZE9CV0pIcmUrN05ScitHYTZmMm96dHU3M1RS?=
 =?utf-8?B?UTVxdStRM1Vsdmk3WmNyN0MzL1daZ29hL1JDSGY1dmNhSmFoOG9RcENvTlgx?=
 =?utf-8?B?UG9qWG8ydy9PSFRrUkRleFI1aVErSTg2b20yclFVNGlxNFkzVTZWTENUemhT?=
 =?utf-8?B?RFZZZWpZSUxOd2ZHUkdkb0lhRXpNZytCaFFaMHFuaXhsYSt3Ry9Ddzg1Z2g2?=
 =?utf-8?B?TllnMjNUZCtsaWpGREtVZ29kRzYrS21SU2tWZkRYZGVJb3M0aWhnS0ZraWw3?=
 =?utf-8?B?bkI3aXo1R2k2aU5PVC9QRmJVNS9nRklETnhubTRmZTVnVmxJMXIwQmRydnJi?=
 =?utf-8?B?VjVGWWpNem1qd1VNK2xQWTBBTHNOakcxNURlSXZaR2F3aFlmYlRPcFlJTVJp?=
 =?utf-8?B?b2dXN2lJdlVLVDIxajU0WVFJdSt0akoyS2NLM3BHRGdFYjJyeGJYMlZlc1dT?=
 =?utf-8?B?LytZS0U0ODVwaCs3K2M1aEJ6VHFmMmh1R2YxS3NuQ2pCV0hRck5sZmtCcWk4?=
 =?utf-8?B?eVQySWlUTVFaSlNTRTZLYXM4blh5R3kyK3lWMjFhSXJmS1liUXlQVkhrR1VQ?=
 =?utf-8?B?d2RLZ01YYnUrVVlKcktlSG52b0oyOHBpWmY5bXo0K2p4S0VucWRmZkFVWjk2?=
 =?utf-8?B?cUNidk9EVXpvcVg1YzNqQnJHcUdpZUlpUEM5Z3BIWGJrT1hBcDcrVXlEUkdL?=
 =?utf-8?B?M1Rnb0R2ek1JeFdRaUMrOXhWTFZBTjVwRmltaTIyTU5KRmJzQWVHdGlKMlRO?=
 =?utf-8?B?UHdCT0dhM1VMQVpmUTNFd2tiVDlNWFpSV1B2TDlvRC8zTkhHSWlseERlN0Fx?=
 =?utf-8?B?UUtpWnJuWmc2UXIvbmZmV3lUZEQweEVjSi9zYWdqVnd3V3JqOTZMT3paYXVs?=
 =?utf-8?B?Z2c9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87f59f0-c342-4223-6bdd-08da8110887d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:23.7602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWEkZfhtSxAg8MrBcTMrRDeJvZY552DVLQpeYLN7x9ct65zArZUwnQ2U6ZctDN5hlRIh4abjnIeLOF1pL5bfHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first set of measures taken so that more drivers can be
transitioned towards phylink on shared (CPU and DSA) ports some time in
the future. It consists of:

- expanding the DT schema for DSA and related drivers to clarify the new
  requirements.

- introducing warnings for drivers that currently skip phylink due to
  incomplete DT descriptions.

- introducing warning for drivers that currently skip phylink due to
  using platform data (search for struct dsa_chip_data).

- closing the possibility for new(ish) drivers to skip phylink, by
  validating their DT descriptions.

- making the code paths used by shared ports more evident.

- preparing the code paths used by shared ports for further work to fake
  a link description where that is possible.

More details in patch 10/10.

DT binding (patches 1-6) and kernel (7-10) are in principle separable,
but are submitted together since they're part of the same story.

Patches 8 and 9 are DSA cleanups, and patch 7 is a dependency for patch
10.

Submitting as RFC because it's RFC season, but I'd like to resend this
for proper inclusion as soon as possible once the merge window closes,
so ACKs/NACKs are welcome.

Change log in patches.

v1 at
https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911-1-vladimir.oltean@nxp.com/

v2 at
https://patchwork.kernel.org/project/netdevbpf/patch/20220729132119.1191227-5-vladimir.oltean@nxp.com/

v3 at
https://patchwork.kernel.org/project/netdevbpf/cover/20220806141059.2498226-1-vladimir.oltean@nxp.com/

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>

Vladimir Oltean (10):
  dt-bindings: net: dsa: xrs700x: add missing CPU port phy-mode to
    example
  dt-bindings: net: dsa: hellcreek: add missing CPU port
    phy-mode/fixed-link to example
  dt-bindings: net: dsa: b53: add missing CPU port phy-mode to example
  dt-bindings: net: dsa: microchip: add missing CPU port phy-mode to
    example
  dt-bindings: net: dsa: rzn1-a5psw: add missing CPU port phy-mode to
    example
  dt-bindings: net: dsa: make phylink bindings required for CPU/DSA
    ports
  of: base: export of_device_compatible_match() for use in modules
  net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform
    data
  net: dsa: rename dsa_port_link_{,un}register_of
  net: dsa: make phylink-related OF properties mandatory on DSA and CPU
    ports

 .../bindings/net/dsa/arrow,xrs700x.yaml       |   2 +
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |   2 +
 .../devicetree/bindings/net/dsa/dsa-port.yaml |  17 ++
 .../net/dsa/hirschmann,hellcreek.yaml         |   6 +
 .../bindings/net/dsa/microchip,ksz.yaml       |   4 +
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |   2 +
 drivers/of/base.c                             |   1 +
 net/dsa/dsa2.c                                |  36 +++-
 net/dsa/dsa_priv.h                            |   4 +-
 net/dsa/port.c                                | 190 ++++++++++++++++--
 10 files changed, 237 insertions(+), 27 deletions(-)

-- 
2.34.1

