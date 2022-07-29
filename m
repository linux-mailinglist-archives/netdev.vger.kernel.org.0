Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9297B5850C4
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbiG2NVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiG2NVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:21:37 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52DE61B21
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:21:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qa8VmdlZ7IevWMDXce72sevO1PXDTLvQtclszgFtjM4vml2rq+ESx9ez70rCau8EbpJcp1JhDUPSFTBqrb+X2MTbrd/7usYi1iqfv2YGQ9I20Aks2F2+d2nRzmBnepvjbUbeHQo2uwLmaN4WblIBsMeJKCzvFuhnv+qf1W+oFh5ikJrPDqvY7D8VKlEZM8JM8NAcsh8CFYWEjAQDwYZDeIQdsQ33zpPWdIViGpegC/jIYooDVZIW4va2ltLrK69FbLa/wCmtqEOxFbznxOUDsewRoD2diLzT+Mq9WZZvbLEW395gRU3QV42Y34KYcJpT+ma6P4N2fmqk6FaqITOJeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjU/d3lf1cu0/jtc1pOOKsld7lZvQrA8kujNSe6UAMw=;
 b=bHfUyKpiO5goh678S2bCSrBYSOt+IBUrAvcodA3Y7YHimuvsh+wdeEfcAjgOtvJEqlPOgYTwYykrX8JWAa2S/xuZuAjBU+2c8CRIwW62OaQQHxc7m3LlM68cT3gcvSXsJ/+5p76kJoR89hrK9jmgk5/MjidKqpgnQRWSxPhabApuuA6h0IvN2aVXFbXj3zY39zH8hXAAVrQsbBemqDeGDCzDvlW5Jvw6KoI6jqHxa6MLrD0COrIllXKcVCtat2ynqrSH9P5H/c+969gmFQPIJR1tuhGhux7qeXakjT7X70Akx1I0yMqk59Ae2i0/VXfR3nK2C03DHTNQ36kC5Ln14w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjU/d3lf1cu0/jtc1pOOKsld7lZvQrA8kujNSe6UAMw=;
 b=WOvL7IoBpsf277fETbXQOLH23JPGysi4cc8+WbueJq6YcunvIgIVGUSudRGswH3egJJPfZ233FYDshxgoRaLKST/NqsIptiJxK092ZowmcLwIhZ/TJA6ls58Zzpi81/MW6uPzFjfBcWADs1/6233fx+IqixzLjbogTxw9hXavu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7497.eurprd04.prod.outlook.com (2603:10a6:10:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 13:21:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 13:21:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Marcin Wojtas <mw@semihalf.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v2 net-next 0/4] Validate OF nodes for DSA shared ports
Date:   Fri, 29 Jul 2022 16:21:15 +0300
Message-Id: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95824756-e5a9-4a38-0482-08da716541d6
X-MS-TrafficTypeDiagnostic: DBBPR04MB7497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MicdA5IsgbemixLCrbC+8XOQ9F96364fQ7o7PX3yv6AkobkaHtMI9gchFnFUCKgU92ewlqaJa/6tEpMuPbR0gK3zozBYwNnALrBkzU+hTGhcSwAoKIzMgXASpN2op+iTO04I93+uK62KxX1vQkv8LSvU3doQdf1eA8lEw1g+fDvNrfkm0Sq+caAzMrmrUBXDpKiSqCU1FaILLDdW4jILbqJDSTeSaCYZyDFVKf18tNkgGCZNJCPJlFZqaNCTyoo9R1s2xe2EcN5uIoATP9lJml3mauTILxThK2/MK0TSoTEMMeZTKNJJI0XZeoicdafI+Lq/eccrcf5j2f3KOpt/WpofxBld/9RTlkVwjNuFmrMlsauBzbFz/fKAu5zgqHsQ6/kgE72TNfpZEb6Z1p3+gM6k7swOpSBmFtbDjydehpuDeZUeiyQ3Pe/eeoBDWZ8u9lWk0MdesQo5J3xib3trP4TvyG7mZy4BJHkpPsSqxEwRY0pdmXjZl5w9rcbPO5jcOx3LrXFiXsVmj1fJK7anLt0jhMQLv0Hf3gTGURCxEbi/TpiXqjvjEP2ChHATd6msm+gp6govXwMIgIDG3VzUfbDLlWzVnvc5wfu3tG1NmHEsj9ETWMqa+63NTprFONvOxdSsiqksknr7wRR9sSZeNVLJjR6Yy3086GYs1bUBmOsxVGGIz9F4gYCdazZ1fEEru0WC7Uuf7P5ybfIH/sCp3hNiDllrgFwS6E0fSe0I3n1eu8nxJzhcVLQ0+Zy7Zd2lEtjLVrVKChpqs57d4bZ/HKpZygE9BXHGEktll4iMJoeAJPgpBAp+ir5UK1LQUVbhNhK5Yhx+qtMyMGaFpqH0LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(1076003)(6486002)(2616005)(478600001)(52116002)(6512007)(6506007)(26005)(966005)(38350700002)(186003)(38100700002)(41300700001)(83380400001)(7406005)(66476007)(5660300002)(4326008)(66556008)(8936002)(66946007)(7416002)(36756003)(44832011)(6666004)(8676002)(15650500001)(54906003)(6916009)(316002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHk4bXJxQStmc2JJd0tWeDZxVmpUK3F5bjlOQ3M4c1c4d3Via0NTY3lkYjhB?=
 =?utf-8?B?UmlGRjBSOHcxSndzbVlEY2pOOTczUFNFVzJMVThzdzZMSHZNQUZwR1hnTURn?=
 =?utf-8?B?OWlIcTBCSTh4WE5SVTBSMmtiMXh6MnBwZUZNVHBIV21FTEJNM0Q2cDdzSmFk?=
 =?utf-8?B?bFFOYzRvVEVQa1JnNDQwaVFnRFJsc1huWFVNVkppaDJQRVlyWFVob205a09S?=
 =?utf-8?B?OUhuWFVXbFk1aWVJSXphdXBpNlR4V2dZU2NMa0JEMktRV2lUNmg0OW9MYyts?=
 =?utf-8?B?NHVNcjhLV3ZCS1FDZGxUc01adWNQQVowQkcwTjd2OURsRm5yM3JVbTZiYVBN?=
 =?utf-8?B?bWdPNnJISE9TWVdvZWZTQ3hnZnVKTkk5cFpYalR6MlFjMVJqWFpKSDhZYkVn?=
 =?utf-8?B?MHYwSFhWNXF6VlMxQUpVN0FSVmYyelpha2pjNFRzeGRpNnNwdHRSZDRuSDRh?=
 =?utf-8?B?U1RjK3JuQVpyL09rT1VLYU8zU0s4Umh1akZBRGFiUU1mS3haUzQreVBXRExo?=
 =?utf-8?B?S1hhRmdoWlBpVWg5QkN1ZVMyZGtvb0NydzdzQUJVNkYxNWtwZDlCYkVkWTBu?=
 =?utf-8?B?aUpSWGV4enpmNkRQU2tlMkUxQTJFTlkyZ0prSkJqT2o2enoxRHFSY08yVC8x?=
 =?utf-8?B?WGpBSUlLSFpGcnJFMTJ3RkEwL1VoSmZmS3BkbFFCWktQUnRadkFYTUlEQmNG?=
 =?utf-8?B?cHJWdE1GQjE1WjZ6bUltekYyWHlUQmRyYjEyd2ZGSVByV0xrSmRLbjhtZFQx?=
 =?utf-8?B?aUt6VU0vVFFHRnNwemxJRzZGeTM3SVk2K3o1T3Z1U25zRExGWmduaFppUFBn?=
 =?utf-8?B?b0JDdVpGMGJsSGdxdk1tWmhYeGs3ZmpmRTZiQ2FCM0ZZcGFOK0wvYWhRSlRj?=
 =?utf-8?B?K2ZGajFPb213RldoQ0VENG5mNmRCVElndTQ4T1pHcWFtcVc2cnA3UGVmWVFz?=
 =?utf-8?B?bHFPeVpVa3ZjSUgyU3F0SklpWjFiVG51T0dPenF1VEJuL3ZSYVF3OEh0VHcv?=
 =?utf-8?B?UFBFL2lvd3BsRExvc1p5Vm1adzVicEZzMU1DWEFZZWZMa1BFWXU1Ny81S21p?=
 =?utf-8?B?TWNUQkhiZHJpblFDc3N5aDFmbmRXQUJMSzhuOVBMRW5EbGlwL3Z1WVU3eUkw?=
 =?utf-8?B?TllNMzFtYVVwbXJBN2VURnYxL3ZSM0ZRMjJGeGlKNVNWQVZUTzRwSFBwSFVJ?=
 =?utf-8?B?bHNEeEw3UDlqTkxsNFVNOXE4aEF0ZjF2Y2pKNjhZazhyV3EvNnYrQ1RJZy9t?=
 =?utf-8?B?T0dRS0hyc2JNQ1NVOXFmaW5uVnVNbnl5SVVSQi8rdE5zSzA5cVJuRVV2VWV0?=
 =?utf-8?B?K1VjN2Z4NGxaeVJqM2RseHlZVUlIUWxqdHJybDZQS0pOUnJxT1Nobm9zbytV?=
 =?utf-8?B?dUxwQjZpYm44Z2Q0Sm8zU3RIZWRGZ3p1VklEaEtNMjNPSzN3VlV1Z0MwUmlo?=
 =?utf-8?B?cHdPOSswbmRQR0lMbzBWWS9aV01hVnpmLzlSeVBzcnFWZmZNdjh2OWw0b2E2?=
 =?utf-8?B?QTgxTEFDVmRwWUtsWVB1cFhmTGxrTzhudVd2RFNmbVIzYVFqN2ZSOVIzNEhY?=
 =?utf-8?B?WEtBb05XcGdSbkdrdzBSYi90eXViWmpRY3hTRmpCaTJFejdCMTFUQ2k3SmJs?=
 =?utf-8?B?emhSMTJJWDFxVnAxUFFrZjJKQlpxN1dpMS9xZGI2SzI2YmxqNEIrdXF4VnFl?=
 =?utf-8?B?aTlDQStuMklJWVVRMnNmUEdiMHFDNzFFZHdPYTl6cmVJcXUvWjlGSmFWWjEx?=
 =?utf-8?B?S28wKy9iSTNmdFpkbXNmUU8wWGsyeTVGdzc0MUpIdHEvTVpVYUZ4ZFJEYUxN?=
 =?utf-8?B?WVgyaE4xWUYydjlFdzBWMHlLeDd5OFBjWnNCZENWWjB3Uy9IZjRFbDd1UVcv?=
 =?utf-8?B?ZEtMVXMyTTU1elJLaFQ4RnREQTV4RXNaSlR2QlZFWmZqMlI5UkxUUTdPcGpN?=
 =?utf-8?B?SFNhZ2NqSk1NcFBIa1UyV3ozSzg0aTR4V0RTb0JhaWhrSUdlemJVWmZndVh2?=
 =?utf-8?B?UWlwaGFZWmdEYkVTS3JUc2lhN2pQVzJKczJaOGJySjhUTEtYcVNVQUkxM1Js?=
 =?utf-8?B?TnNIeVU1M2gyTFhwdk5FYktiN0owcndodHFiNFltcFZON1VQc2FtTEVVY2VT?=
 =?utf-8?B?ekdmNXk3cHJJR2xoMTJjUTA5OEZIWkVRdGJKRTY3bXV6NHJxdFlHcmVPNVdB?=
 =?utf-8?B?dEE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95824756-e5a9-4a38-0482-08da716541d6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 13:21:33.9026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2S5eL79kM4j+2YSuLrVLxV1F2Gc5sNoaFtfab2njn/+3srDPidOuGRKCv/9/HePpHdPQW33nYmxPt1Snc/2Wjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first set of measures taken so that more drivers can be
transitioned towards phylink on shared (CPU and DSA) ports some time in
the future. It consists of:

- introducing warnings for drivers that currently skip phylink due to
  incomplete DT descriptions.
- introducing warning for drivers that currently skip phylink due to
  using platform data (search for struct dsa_chip_data).
- closing the possibility for new(ish) drivers to skip phylink, by
  validating their DT descriptions.
- making the code paths used by shared ports more evident.
- preparing the code paths used by shared ports for further work to fake
  a link description where that is possible.

More details in patch 4/4. Patches 2 and 3 are DSA cleanups, and patch 1
is a dependency for patch 4.

v1 at
https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911-1-vladimir.oltean@nxp.com/

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>

Vladimir Oltean (4):
  of: base: export of_device_compatible_match() for use in modules
  net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform
    data
  net: dsa: rename dsa_port_link_{,un}register_of
  net: dsa: validate that DT nodes of shared ports have the properties
    they need

 drivers/of/base.c  |   1 +
 net/dsa/dsa2.c     |  36 ++++++---
 net/dsa/dsa_priv.h |   4 +-
 net/dsa/port.c     | 193 +++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 207 insertions(+), 27 deletions(-)

-- 
2.34.1

