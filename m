Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DCC3EBFF5
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbhHNCuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:50:54 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:65089
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236466AbhHNCus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki/MqjQoYF7MzZ1QWH3P/ylOVbKNYu2Xi7e0Bf43PVM8gNw2V3E5EteD5RqX07iuaBF16/yuSWYL0owlpoUCvCNzPwCDc+wKLxC/EGoCkYob/cFw6Jfqa1FJ2PpHF+hyfQc3ZsOXyOXTGZpNDKx8zYGt7yG2K5oU7A5pmsih7Iu9+9z/cH6Juf6YyQ7FNPPBoud/rvEHvwSTgA8DQ65W1kOEeXpSMLeh3T50THXzyK/cSRyglBwN69NWs+hSmu0ozUNF/XC7N7fpveX65a9QLOokEIOdq50Xv1EXTzK0RKWSu2SLvjqjwB3rgctAdUasU/B29ZRVgDbwd3atxVBFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KF75He6a8N0Raa7guRg/OpAyZ2Bgqj63MHIHIGxv0X0=;
 b=HJq1Z+ZgtoX8pfwjsfiKGPBPZbbsN7ck08AAcCqBVyeewCr3pehjaL7rl/wx7kxKI4D8gPZbM+LwaSlB8CM3PGYLzQCivXexAD/U0RhhPO+NEomPUgywRtXp+fwiwulm/tFCZXgzIzkd3uKwdO0dQvH8ygLVqIlwnVJahY177055cpQkCHhYq9J3nnulpG1k4xcLM4MQDNQAYDIv59/xWB/ddx/214NBQ9ZlI0ijljs8PQ2p5VqcnXHvQxUQkfQChLPueWyvpCDWKHtICbk0d0QuKdBFh72QAy/eo8s41+wHLYI7F7p3YTqgrTWYNKXVoqzLfmgd4pCjfqfpE1cmPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KF75He6a8N0Raa7guRg/OpAyZ2Bgqj63MHIHIGxv0X0=;
 b=f6rhiknmBZ3SS3JSXhRYZlGQJuWIgq6o8+bdbtgEalnvXKRBYTDQRBDJqq8NsAXnQ3cAyQLI4WvznxFY6v1EB/7eQp5dRbWJiAfZ/Wc5lp4Cfk+ndYmZ8uvC/tFb2T6SOpFgM8oxbihQbnLViWe5avUqtidY40rqzocjWSseBZA=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 00/10] add support for VSC75XX control over SPI
Date:   Fri, 13 Aug 2021 19:49:53 -0700
Message-Id: <20210814025003.2449143-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 386603fb-a30b-4872-8d12-08d95ece3e60
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB2030CAE5F2F7083EF869ED82A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7Dh7YLXm8ppfym3bi80NbbLJr/QNF1GZhUwCz+F+78F4AjbrP2FIwQ7NhXIY7Ttw1ps2vfTQIm9E1a8jG72AXGxMvj7t/+BZ+ZK7ACP2uTACxXJjJANitqtL5Pg98wy2JwfMJOtmtml8ZimQ4EwyaXqBD0F6pLHt6reqCFfWljMuSSwz1IlL1mU8HsZrF28eG4T1Ru9CQphnQ9TVYJlEGRIut+7UFz+mzolYnLpZyi6NU02IsybJwcOJc+/M7nWIyokEPBtN+qQyRGr0rsizHnn7AJdPVtYGwz7ykx0Vm/sKQ9rT90h8925aMurF24glPbF0FNbjGqdLNAF+848dPZSrjVM4mY5sxFAHRf+5SV9dTrhmewNNIiSKHcIp36dJCPI1M+I64SJRY9qtupetWoSKF0xrMG6qOLy3pR4Ks6Y62odBTbCufw6UVRz63BpbWXc2z1EYzhwHMRm2lvMJEsL0mLeE3uzbpU6w5TzwoM3njucj7GBoUGWzE8yuzI1mn9XZl7wuTEh/Vo31Zn1KUz8/573p4UOeNRe3g4PCrC4oGI5Q7vN9cgB3dmoilMNcnkFvguzKMr8pEcWScwPrI2PqT5w5AVlxBPLjBiJ70J+cxPVPXw5MvzVOzz3BKWekRmpwTo2nMqIa07MyKC0bhZu7QHu9ETVeyhu4J5YraMzv7VV5yUzwX9Kzx/cvZxyJi7vYrZuso7jbeQqC7U1F8GhyZybvpdRwYHoXzrkZcU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IVrTfz+Jx7q0ClR7NeavQRor/dyLqRFUvAH+fEr+5UPfBjM2zojsLG8lOZBq?=
 =?us-ascii?Q?IfM8SVXEWQqMvAuiCuqNhF5BPgNXhAn4mONG/80XzGmovSIUXT9vFgomcTsb?=
 =?us-ascii?Q?SHnz/Xq03OTXZ19YijMWPbKFmnNjM+xSj/lSv2Hv4MAmG7ovcZ8JP80MIaxN?=
 =?us-ascii?Q?c+tzILG+UlcidCqtLpVdeBLREByWJfR+SMnUwuxq5ntRi6FqYb+IxYA8lK/M?=
 =?us-ascii?Q?wIm2vNMUdzArx/HHGyKVhYJ+ue4TpJvf8d/9aMNfJ1X8GxJ3Mra9QWPRD/Eu?=
 =?us-ascii?Q?TbYm2lDYdopnXTZWSKqxS5Nz0XohpESH3N2IFxWtestIQp4M/PTsgluTV5Hy?=
 =?us-ascii?Q?pRCM8P/ww3tmyqtuHDJCvYcZ6IA2LXPUG86cn/OTbFQ5x8cKjrEJK7dPVfJ6?=
 =?us-ascii?Q?QCzidPY/dh6fYt8uGh+HvDYKQV352beSjHeTtN/d+WvyfCXXpzlxj2ukf85I?=
 =?us-ascii?Q?ur2kggj6yVitrmtwV/NOhdcUpHe+o7vW8rbZph3xX+xZyuk1CnJKk7uhOYHY?=
 =?us-ascii?Q?l5wHq4UKhXFSQXeHXfI8OmE5bYdJx6CcHmBBiIBmc7JWrfWloxegWQlLQicn?=
 =?us-ascii?Q?6lMbe18FC6/0s0/4hj213vRbeOJ41wAqd4irDN0+hLHw016F131BpE3/aHti?=
 =?us-ascii?Q?AicYaVxYN09+jChswlu5FwU8FZuEdLOEqVNwrIjyv8igo8Jb30BNcIG7GSNn?=
 =?us-ascii?Q?u6cQdXrWmFT2aHI40sI3FqtuwmXFStUoIF9N9qGxlqKREy4OABu/9L6cg5nU?=
 =?us-ascii?Q?dblpVt5oIltqL7kH1Tj4I7TW5CRoZ1FddzTn9HJxlEAHaNnQgzgnlMtm4T9e?=
 =?us-ascii?Q?KDHMod/qXLCuKubpZjABn+Xemkviadu70QInFj7rSG3cOx19NWNPcfOmp/aF?=
 =?us-ascii?Q?/vm4Du8p1KNK6McTUM8OCIOglahZW0Iqgjhr687XGPW4I2H1y9YMYip93+R7?=
 =?us-ascii?Q?3jjHg9zWIHHu15JwU6Zq86mtkJvYxK2mPMoX2eILn4czpard/iJRwMZShJPz?=
 =?us-ascii?Q?kkDUp5BaXVYpeaqg7Ma7Ojqc1cY/rYY4eEvc0mDi8h20oF9F6CF69wlhq33D?=
 =?us-ascii?Q?kNRnOXhgF+STXX5ypqqLUNDd1Alrhng9xcK4oQWP2NVhXgK9IfhgwM/e7BJh?=
 =?us-ascii?Q?fWIu81GB2PW8Xms90bbePhar0RD9VaMbljih6I10z3JVN1lJ2Ae/q00nF7Y8?=
 =?us-ascii?Q?1aezbJY3NSErJGnpw1It3Hup88o6n/qEpZ29T6J3/fNYQolpzjSTL+q3f7rk?=
 =?us-ascii?Q?hH5LofZjiO3BGGUsh3wliGgRXZ6T+PNgiUljGyeDQZwIKgIwEm8d7e10/w0q?=
 =?us-ascii?Q?mCEAsCwC+OtyaTUOQMDxkOUx?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386603fb-a30b-4872-8d12-08d95ece3e60
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:15.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rl/dIr526dh5sliZ8LNSaPNo2cQtm49/o/VnOh26BIYLgL1UVwrxdaHMEABBC/naViI3lJHgnWEa24coS1mbNRsSchIiE0eU+V4Pk7TLcpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuration and control of the VSC7511, VSC7512, VSC7513, and
VSC7514 chips over a SPI interface. The intent is to control these chips from an
external CPU. The expectation is to have most of the features of the
net/ethernet/mscc/ocelot_vsc7514 driver.

RFC history:
v1 (accidentally named vN)
	Initial architecture. Not functional
	General concepts laid out

v2
	Near functional. No CPU port communication, but control over all
	external ports
	Cleaned up regmap implementation from v1

v3
	Functional
	Shared MDIO transactions routed through mdio-mscc-miim
	CPU / NPI port enabled by way of vsc7512_enable_npi_port /
	felix->info->enable_npi_port
	NPI port tagging functional - Requires a CPU port driver that supports
	frames of 1520 bytes. Verified with a patch to the cpsw driver



Colin Foster (10):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: mdio: mscc-miim: convert to a regmap implementation
  net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect
    mdio access
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions
  net: mscc: ocelot: felix: add ability to enable a CPU / NPI port
  net: dsa: ocelot: felix: add support for VSC75XX control over SPI
  docs: devicetree: add documentation for the VSC7512 SPI device

 .../devicetree/bindings/net/dsa/ocelot.txt    |   92 ++
 drivers/net/dsa/ocelot/Kconfig                |   14 +
 drivers/net/dsa/ocelot/Makefile               |    7 +
 drivers/net/dsa/ocelot/felix.c                |   11 +-
 drivers/net/dsa/ocelot/felix.h                |    5 +-
 drivers/net/dsa/ocelot/felix_mdio.c           |   52 +
 drivers/net/dsa/ocelot/felix_mdio.h           |   12 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   11 +-
 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c   | 1133 +++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  109 +-
 drivers/net/ethernet/mscc/Makefile            |    2 +
 drivers/net/ethernet/mscc/ocelot.c            |    8 +
 drivers/net/ethernet/mscc/ocelot_regs.c       |  309 +++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  323 +----
 drivers/net/ethernet/mscc/ocelot_wm.c         |   39 +
 drivers/net/mdio/mdio-mscc-miim.c             |  137 +-
 include/linux/mdio/mdio-mscc-miim.h           |   19 +
 include/soc/mscc/ocelot.h                     |   24 +
 include/soc/mscc/ocelot_regs.h                |   20 +
 19 files changed, 1857 insertions(+), 470 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_regs.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_wm.c
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h
 create mode 100644 include/soc/mscc/ocelot_regs.h

--
2.25.1

