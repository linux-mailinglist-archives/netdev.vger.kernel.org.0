Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D99194059
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCZNvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:51:43 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:22720
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgCZNvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:51:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDxjYoIYQOy4/Qvu2fZ+cJB5PNiQnljAKO0434jHQFczg9B44FF9MoZpnPLZsDYFbxqK6yo+yCL29mp7v+LT3yJk3xY/HuYpUau6YxbO+KLktPed+amw6k6WCAaRfo/V26tddDBGgmNki/SZsz8G2yHVv/psBpwl2W/fy8k20PSuuro++IM8AGYLnPrXeAlazC8LkZNdJt7N/vhZMLiMMajRPhNAV993PfLLva5ln9l8L026XRrn9wXaBDhMITmdt4OzMIM9pgczt/snPrLFSOkKYqfESOMx3cN7b7FcSRsgJhW6HOHyq24cWb5nBSLuGm9STjebV5yrgN2ffUYsVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrTq9Yp0Vr84R3itlLApLh2RYVGalnHO2a9DEBiPYlM=;
 b=aKglg9ockS/+v4lN2wWq/w2B4Q3GTW6qY09L1e9OwtaBU5lOqO8UCYcXPvMUHcyl8VNLpLwLyMZ0zGl31FsEyz1vbkyln6bEZ7kokqkZKbpKiSnfwCWTwTmf9pgI24ROaptUJIIoa9lOVqV/kniNnElvXhgt9j6ngfA5Bj3oc4J7W8X/94OyrvfS+q9gUMYw0FsqsR7PNTidqnfea2dRMUMR6ksioy7cH9EuioZvN3/VPwck8j862z4RdWVC5VRs1wiWlwCm6LoPE0+nG6Ot8/WOWBYOXDgeLVHjNIlH88F1wpgqVTm4MpjoReMH6Eow6ioW7GeyXRLbNrICji9Lwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrTq9Yp0Vr84R3itlLApLh2RYVGalnHO2a9DEBiPYlM=;
 b=BB7p54JkPNDhkw6YRMPMn3EstkxK5IKWrhePskta5Z84Iijvc3bvAtNvp8DBx2rhYYyg1Qt0nO7tT+agaF4Gvr0lfOtiNEpx2xPJ26ghxK2BJjbd6sNHThxdfgpHyHmWDv+8i/pbfJ/ckbm9rvnD04/kkm71Cfzzi2ruHwfM0+o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:51:39 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:51:38 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 0/9] net: ethernet backplane support
Date:   Thu, 26 Mar 2020 15:51:13 +0200
Message-Id: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:51:36 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f35bf054-b53d-48db-30c3-08d7d18cce10
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4272FE0D77DDAB596D8CEC58FBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVC7SW6FOFFIGv6oRu0PKvyrf9DAjjtQ6UAAShgjQN0ILDSBvmQA5x6SnIUsz5jsOf/cnzJZUt+lZCvmvICSPzRgOe85X5xdyKJ1ZluboBWNKVcUYEUrT479g/Njcb/YAassWszaHdnQvzNTV32wIWpRgvo9MXjDoUaKcHjVeh0+lt/Om526BdCoPE33tCrubTSgY32fs0LoUGMGDQT3+zBWDlN9GYGbn1UV4biX+9tJROXct5ZAewMLANKuzF4Vo1NN/2AXY/grdU6mfT9H4lpz2hci/jWAZfQ0LyY/I9ai0Cv/1NhRWGI42+XZlnwUcTUrNBtvdA6XxeBV6S/ZdPs88RM/GyN761xmfx+bQwSiu4yCLZriVsafugImzYLedo7iTnb3Dxz649jI2KUGfU6dPlZb2Xdx2frHCiFAkGku254QXcczUz74562715Ex
X-MS-Exchange-AntiSpam-MessageData: nmQ026oDHXPe54vcVUKhRA4AwgyL0U6S5NLN72tUp5fGlOXzLVuhsKnfiaWepHwF6yCEL/UQUuyM/LIHrPB/BYkCvIWVOjJjGz/4VtrNPj/lhBtVq6am5v0IaAsTRoY+dUaWIMOLLl2Cc16jcQwK/w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35bf054-b53d-48db-30c3-08d7d18cce10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:51:38.0587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2azIrS+XuceWJ9W2f1iUjb1CHU3KNwOKW/rJCJS7+yyvnglqT78FMnlkTYC05psU2VkK+a78pvOz6/2CEG81+kFKAiS2haCBusoIByPzhRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Ethernet Backplane KR generic driver using link training
(ieee802.3ap/ba standards), equalization algorithms (bee, fixed) and
enable qoriq family of devices

Florinel Iordache (9):
  doc: net: add backplane documentation
  dt-bindings: net: add backplane dt bindings
  net: phy: add support for kr phy connection type
  net: fman: add kr support for dpaa1 mac
  net: dpaa2: add kr support for dpaa2 mac
  net: phy: add backplane kr driver support
  net: phy: enable qoriq backplane support
  net: phy: add bee algorithm for kr training
  arm64: dts: add serdes and mdio description

 .../bindings/net/ethernet-controller.yaml          |    3 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      |   53 +
 Documentation/devicetree/bindings/net/serdes.yaml  |   90 ++
 Documentation/networking/backplane.rst             |  165 ++
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   33 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |   97 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |  160 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |  128 +-
 .../boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi    |    5 +-
 .../boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi    |    5 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |   10 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   10 +-
 drivers/net/phy/Kconfig                            |    2 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/backplane/Kconfig                  |   40 +
 drivers/net/phy/backplane/Makefile                 |   12 +
 drivers/net/phy/backplane/backplane.c              | 1538 +++++++++++++++++++
 drivers/net/phy/backplane/backplane.h              |  262 ++++
 drivers/net/phy/backplane/eq_bee.c                 | 1078 +++++++++++++
 drivers/net/phy/backplane/eq_fixed.c               |   83 +
 drivers/net/phy/backplane/equalization.h           |  282 ++++
 drivers/net/phy/backplane/link_training.c          | 1604 ++++++++++++++++++++
 drivers/net/phy/backplane/link_training.h          |   34 +
 drivers/net/phy/backplane/qoriq_backplane.c        |  442 ++++++
 drivers/net/phy/backplane/qoriq_backplane.h        |   33 +
 drivers/net/phy/backplane/qoriq_serdes_10g.c       |  470 ++++++
 drivers/net/phy/backplane/qoriq_serdes_28g.c       |  533 +++++++
 drivers/net/phy/phylink.c                          |   15 +-
 include/linux/phy.h                                |    6 +-
 29 files changed, 7176 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/serdes.yaml
 create mode 100644 Documentation/networking/backplane.rst
 create mode 100644 drivers/net/phy/backplane/Kconfig
 create mode 100644 drivers/net/phy/backplane/Makefile
 create mode 100644 drivers/net/phy/backplane/backplane.c
 create mode 100644 drivers/net/phy/backplane/backplane.h
 create mode 100644 drivers/net/phy/backplane/eq_bee.c
 create mode 100644 drivers/net/phy/backplane/eq_fixed.c
 create mode 100644 drivers/net/phy/backplane/equalization.h
 create mode 100644 drivers/net/phy/backplane/link_training.c
 create mode 100644 drivers/net/phy/backplane/link_training.h
 create mode 100644 drivers/net/phy/backplane/qoriq_backplane.c
 create mode 100644 drivers/net/phy/backplane/qoriq_backplane.h
 create mode 100644 drivers/net/phy/backplane/qoriq_serdes_10g.c
 create mode 100644 drivers/net/phy/backplane/qoriq_serdes_28g.c

-- 
1.9.1

