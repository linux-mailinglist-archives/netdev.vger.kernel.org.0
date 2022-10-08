Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90EB5F86C7
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJHSwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiJHSwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2873F302;
        Sat,  8 Oct 2022 11:52:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQC9r7RYKWlnLP6XZbylQ0nAJ/acr22fCQPnkSTr9lqrT31vHpI2WWM5ir2rtfrXDgIdEYjfdyB6tTndBpFo60UGrSBualhRItmaOSG+xqYZNRLAWzEjlA0BuHtujZM6eZ4XVIr7fJBuMBOdYPQxmEz2+V/inCnE9iINiHG8wU89maHreOQvwRXSeLxifhMMUeYX9eSGUD/R+JG2z6dxKnv0I+AFw5NXzpbt3e0+zpNXDoNm/LbzvuH2bCcCweOiPMT8Hf4UVNwwjbV8SA/Yf9bahWs3QsaTwBdW479/2TAxucrb4pPD04i/iS9+llvJ5vrbg+/gxaq8CmAEUG8ucQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3d+FLbNrn8RGuDmWYHFguf51gD+VqsWmcCGQ6IyEdU=;
 b=hj2KLEKmjCTGUJs/1YdzgzuarmgtrbzpTfou3w7OlGXrh9RQmutDG4JMpTmI/ZXB3yKt2vMBT3YXxrv/WIXOEScxBzyhGBO9W2QFI8GIZ5q2Q/ZDca8I5KoMW/Vb+3yAfHK/dMEXSQj/qAYSXK/6pN1LXP/vkAUadbKhPZ4MNXrhQ7Nj/NQZSN9+OgKnsjArnlInIT84uwWbnJwTHLqalHZ+Cc5iBu2pHtzXdbnltoJIiKGBMUA072Z7kYVgNpgBHNHIw3Fn1hSeazXaxgS26/lCnFP2uCbqDnMg3OTDVIYtGliBO7hNe7tFEOVbB+DdWm/JDGT0OPXrtnmCoSGpBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3d+FLbNrn8RGuDmWYHFguf51gD+VqsWmcCGQ6IyEdU=;
 b=qSPBzVVkITGqt6fY4hr1oE47AppQ5BZa1LMIMLBiV3rtRDw6p/PU6TLyRJ7FMd4ragGB0mJbzqwaD+DWNPpR8+tgVHJswhSLYb7ti6WQCRbUVry6t25NIydwJr6FOd1HMcwoHd0q375DVfK/LmaMSMAQTJKtkcSTZ/MCsBlY+ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:03 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 00/17] add support for the the vsc7512 internal copper phys
Date:   Sat,  8 Oct 2022 11:51:35 -0700
Message-Id: <20221008185152.2411007-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 78543979-fae6-440b-d677-08daa95e307b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7Y57qdc1z7pTKiPuLv62H+dxS0o2SM7XiWZDMTb5ENjtLySLB81sK2nKEmEGji6dUUwXpCkBKJpm7HBeqh+eOJqghGjiw0C6qAw+/1g16ZhdDSjSwRFzzKPOGUWn2NQm3U34HS3btyhY9TdtiCICpgEVKiwmcWLf9yi6WBs8NCdXs6jphcKzBFgOFCiAnsUe9nwL/U9jLgAYg3J4y3YLcD2MY5Cv42WcRpJ2uFt75+RYFjCUIkoLK2fdKYNqws/JBFbvoHd6cyje8bICoxrAzSVhxtHAcyblS8K7NfRCmgGyog3SKLVNgQdTHX6z0LpiRc1AhKqIfBzEO4zucbGGt4Mi0rrJm3n+uiFi5EO94WEOTqCm/WLluOE4wWz4pixiQ1FKfRnJch5BEJ7/EetAkJxPYAEjnNjRm2ep8gTL5NxtFHLJkqUVwXqxhzAbaL8Tgjgaufdp6mvXsIjpVylbPfvHQY1UbsBWTMQXLoTCRWCtfLA/ABigz2NG7Edc6xBtMC2iu51P7TR+LZpW3jC0mh444Bl1JVQeVUB6PwJhhJmBrrdfa6omqusPQSy8Ltwatfrwg7DMWFG0FvV0l5CqOtbmKW9b137rSS9K3EV/SMeHAtGuSxrIwXqhsW72wNKexzrFq6I4KrchOkR7qTzvdA2EsOJWNZ6vBQ8rbltpprx8xvksFH9kII+yV11Qrgx00IrUpDf9GBN4n/xeLDBmYPpz1DxPQrqm0WbEtBDUYxDpzc88qU+bxttR8rQzd7DPD3aOZWkXoYURE5m2/K40xRFR76468j5w91GfCcri+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(966005)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xf6ZRcjZb5outfC8msPx6vhmWKU6vNq3m5nZgskkYaqrBXBFLQViFzgkQxVq?=
 =?us-ascii?Q?6C6t0QRcwOvTJWtNxqTYt/svA0iux5Jra/LM4IblUFBWi/s0x4H1rw0fi7bk?=
 =?us-ascii?Q?ARN1UqYmPpoqiFergL+3XnqwT4xZyMw8RO4b1sU76t268JvgNZ+4ZqdIRfFD?=
 =?us-ascii?Q?cdQV6HtpMdq5vI3Iw51K1wEAWDiGdnB7p11av2xAhFpF5+buDepiIazpPX/5?=
 =?us-ascii?Q?PKNaxioIMc7Arsd3QfVRrNX9rX768Fo7w5S9+reW8gAp8fkTi/Y6gT2GAlZ/?=
 =?us-ascii?Q?pScQEGegoLyLttSsqUJnPlkHY5NXh8euY32WDrCZtkpfbGhsWkv4N0rJoHrH?=
 =?us-ascii?Q?G7efDBOyukyZl2Ne7IP8SYREe3AmpBrYxfCgHY+TXcQg0L9RbxGQjQ/+aEbr?=
 =?us-ascii?Q?NcyKW+WfipuQozFo240EheViprfH/lVtdju3LZQyRSVo+K9zgGHMsyEKCXaJ?=
 =?us-ascii?Q?VyRy8tuE9szXRVl2OO2hgaaEg5BmvYmOrpHsuizhvmOmcN29++DBKKIQukUW?=
 =?us-ascii?Q?JXBUbRKlj621OXgyLWUnOYlOD4IweyW3n+5echab4sMDmD3OBdaUBPa7Y7ps?=
 =?us-ascii?Q?6Jkhgis7ALJaETRmMdV/6f54v4wF+43wHzfFdaEtfG7nVkb/IJis8W3M78m8?=
 =?us-ascii?Q?826q+gEhf9yObpPNtF+4HLa2zcNN4re3J2MHhknrcZeih5nSlqxamxMqxry3?=
 =?us-ascii?Q?Ppg8v/KVvTAfiOFQeXQv0k10zmUslJ7aj0kEa5lk8z062z+ZEUr6bbkhXWaP?=
 =?us-ascii?Q?htUFfiRxIyhIMexmEHxohketEq/rt4pxvCxpCGOV9tqD+V1o/QW6s1YqfVXB?=
 =?us-ascii?Q?/KKbr15e9l05dr/VGZZm/Dp7HQLAWQ6cKhBs3s54xyWFyi3R+H74kM069xUv?=
 =?us-ascii?Q?UQ/Ff1KfQHJIM5p5zZA2pHQLzAVj44VTdeJTE3vfoRj1ehcpSlJBG0bimfW1?=
 =?us-ascii?Q?dP1Pl6EsvhVzqKRq8iAgJXT9hZe1t0ikoqFiiSxVBPLfTRoigccaIvP3rkJD?=
 =?us-ascii?Q?s1TG3EAhbBI4SNSj8N2ZAQ23XuxAsSFDVNCNkXvLSxhfp0sB90rEbm/GVx0l?=
 =?us-ascii?Q?QlsdozwWTNLxed2spvFoahOnIvOpj5DtTPED67sDEp23soOMc1y1c+fIGCJ1?=
 =?us-ascii?Q?cCciFMAe2kSPxZTektsFSfDrMpvn2vP75nEuk7l41Pbp+l5JHPWKexXi5D9h?=
 =?us-ascii?Q?PGxkkmHbuNcSg8TI48qSx/Lm/70AUx2gm4y3r+M6kKi9PS/SlQLUmGDhaoWy?=
 =?us-ascii?Q?5DuSlv77DiPB9/ztIhEMFr5j/aTMbfW3b2jIFQnVtoe8tdeB9bkjJbIPmGgb?=
 =?us-ascii?Q?PGaebeVR09e6v0ROfqmRYeeDYAA7HhohIBDNSEr1PJ6IOowUcYSwmcFgG0uh?=
 =?us-ascii?Q?ZeI5GoxbfU6Pt9mvthBs14a13GnDmUOA0A6zRPg1YO+5sTXbGL4oFWat92o7?=
 =?us-ascii?Q?ZzjCo41IDx2W/NUkZkJoO3zWkJNwaD5fN+mPpld2/EtRYmTilgzJrRscFL+x?=
 =?us-ascii?Q?iityo4V6a0Xg/mOW02m69In+8vKCj7TDWyElqm2nDKreZrT2+7rIMp3O4V1H?=
 =?us-ascii?Q?43GvxbFWegPWBnxI5mR7gvtMo1Pt8F8YtcClz+dvRWKpUTOJ+CF68Khgf+n7?=
 =?us-ascii?Q?7+G8kX/pT00wrSFItg67OaI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78543979-fae6-440b-d677-08daa95e307b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:03.3507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljCVnqOhKjlSl7vZPUX9psk0nE6LdnuoAQ1nQlMLhybLacp4L3VeNgl1ymArdKNe+GpyiyiaWwNm2pJOrqoE4thazKUw0qdbQfP/pCqNuv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a continuation to add support for the VSC7512:
https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*

That series added the framework and initial functionality for the
VSC7512 chip. Several of these patches grew during the initial
development of the framework, which is why v1 will include changelogs.
It was during v9 of that original MFD patch set that these were dropped.

With that out of the way, the VSC7512 is mainly a subset of the VSC7514
chip. The 7512 lacks an internal MIPS processor, but otherwise many of
the register definitions are identical. That is why several of these
patches are simply to expose common resources from
drivers/net/ethernet/mscc/*.

This patch only adds support for the first four ports (swp0-swp3). The
remaining ports require more significant changes to the felix driver,
and will be handled in the future.


*** Notes on V4
The patch set is growing long. My apologies. There isn't much that can
reasonably be broken out. Perhaps these could be standalone:

  net: dsa: felix: add functionality when not all ports are supported
  dt-bindings: mfd: ocelot: remove spi-max-frequency from required
    properties

And I'm not certain if these two patches should be combined, as they are
co-dependent:

  dt-bindings: mfd: ocelot: add ethernet-switch hardware support
  dt-bindings: net: dsa: ocelot: add ocelot-ext documentation

The only warning I know about is about the reg array being too long:
/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.example.dtb: soc@0: ethernet-switch@0:reg: [[1895890944, 65536], [1896022016, 65536], [1896349696, 256], [1896742912, 65536], [1897791488, 256], [1897857024, 256], [1897922560, 256], [1897988096, 256], [1898053632, 256], [1898119168, 256], [1898184704, 256], [1898250240, 256], [1898315776, 256], [1898381312, 256], [1898446848, 256], [1904214016, 524288], [1904738304, 65536], [1896087552, 65536], [1896153088, 65536], [1896218624, 65536]] is too long

Also I know there is still ongoing discussion regarding what the documentation
should reflect. I hope I'm not getting ahead of myself by submitting this
RFC at this time.
***


v4
    * Update documentation to include all ports / modes (patch 15)
    * Fix dt_bindings_check warnings (patch 13, 14, 15)
    * Utilize new "resource_names" reference (patch 9, 12, 16)
    * Drop unnecessary #undef REG patch in pinctl: ocelot
    * Utilize standard MFD resource addition (patch 17)
    * Utilize shared vsc7514_regmap (new patch 6)
    * Allow forward-compatibility on fully-defined device trees
      (patch 10,14)

v3
    * Fix allmodconfig build (patch 8)
    * Change documentation wording (patch 12)
    * Import module namespace (patch 13)
    * Fix array initializer (patch 13)

v2
    * Utilize common ocelot_reset routine (new patch 5, modified patch 13)
    * Change init_regmap() routine to be string-based (new patch 8)
    * Split patches where necessary (patches 9 and 14)
    * Add documentation (patch 12) and MAINTAINERS (patch 13)
    * Upgrade to PATCH status

v1 (from RFC v8 suggested above):
    * Utilize the MFD framework for creating regmaps, as well as
      dev_get_regmap() (patches 7 and 8 of this series)

Colin Foster (17):
  net: mscc: ocelot: expose ocelot wm functions
  net: mscc: ocelot: expose regfield definition to be used by other
    drivers
  net: mscc: ocelot: expose stats layout definition to be used by other
    drivers
  net: mscc: ocelot: expose vcap_props structure
  net: mscc: ocelot: expose ocelot_reset routine
  net: mscc: ocelot: expose vsc7514_regmap definition
  net: dsa: felix: add configurable device quirks
  net: dsa: felix: populate mac_capabilities for all ports
  net: dsa: felix: add support for MFD configurations
  net: dsa: felix: add functionality when not all ports are supported
  mfd: ocelot: prepend resource size macros to be 32-bit
  mfd: ocelot: add shared resource names for switch functionality
  dt-bindings: mfd: ocelot: remove spi-max-frequency from required
    properties
  dt-bindings: mfd: ocelot: add ethernet-switch hardware support
  dt-bindings: net: dsa: ocelot: add ocelot-ext documentation
  net: dsa: ocelot: add external ocelot switch control
  mfd: ocelot: add external ocelot switch control

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  |   9 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         | 112 ++++++++++
 MAINTAINERS                                   |   1 +
 drivers/mfd/ocelot-core.c                     |  68 +++++-
 drivers/net/dsa/ocelot/Kconfig                |  19 ++
 drivers/net/dsa/ocelot/Makefile               |   5 +
 drivers/net/dsa/ocelot/felix.c                |  28 ++-
 drivers/net/dsa/ocelot/felix.h                |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c           | 178 ++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   1 +
 drivers/net/ethernet/mscc/ocelot.c            |  48 ++++-
 drivers/net/ethernet/mscc/ocelot_devlink.c    |  31 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 196 +-----------------
 drivers/net/ethernet/mscc/vsc7514_regs.c      | 122 +++++++++++
 include/linux/mfd/ocelot.h                    |   9 +
 include/soc/mscc/ocelot.h                     |   6 +
 include/soc/mscc/vsc7514_regs.h               |   8 +
 18 files changed, 640 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

