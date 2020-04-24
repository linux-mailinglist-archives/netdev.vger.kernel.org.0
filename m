Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5D31B75BD
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgDXMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:46:47 -0400
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:39617
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbgDXMqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:46:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyFHVjYKtF0cdUH7YQy2O5Ubg3XvuqsAWXIHv2pCf2EZIUPHEzZs3le0jfDJX3sA5ZqnP500c6GX9FOuY3/+Sj+HljPWlqy5pG1AEjW36G2ch3fg0HLQv3o0Fz2Eu0lBy0DeMwovpnwX242BF+xkdQMkOhiFQn8iUhb2qMsaktOSFBtLHWr8bVKrWzClFgC39uWzO8uPO4B/Ociai+FWDLrS7ujS6Yg9IBXyb8qjTsx6jhfjiN8oh+ZAuQ/g2tpZjzuHX5T5clpBshmlVIjmmwP4I3LywaR/YVV6IkxjpmepED9E4icIsgkfK7qrL9eRVzzMZ+BfEywy+hJono2bzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxBhtAnOUjXz48wuuCVoAQNYpc260BlSWY+ckCA3nK8=;
 b=fmFxRbnRZZrKknbEDmNmINhxx677Cnt/JLAiyMyB2vwcsdC7oXHvOxuqMQW+A4w3jLezkXrjUWb99cMYHEdt4e0l4hhdjicJHJ+pa/t9UHeoyWm3HQaXeTWUdbxSU7fNKzML00RMbR04u2Ax6bYrOnXehqQhq34FMwyyvsvtZrgfM1VnS4SBp5FnaQtVNv1LyCjGFcs9KBHedK4q4Gwq94vr3O6g0/NfoEhM19u9iYdcVzf9tY41xxPBRC53f7H9ONwQAmpGOYXdqDTGs3Ulfve61GpEZAFvsuoNDoR5WiJybdfbcWfJdhFdBis4nG1u/xIHLCvxkOPeKO0XmQEL2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxBhtAnOUjXz48wuuCVoAQNYpc260BlSWY+ckCA3nK8=;
 b=i1GO+S1B26NLjPAho+dKH6P99D7Zb5MaOVu8UlVB7Own4uAyoJqxma6Kl/yPOslKbr+9BsfNjch+yxQ9nz2JnRfOLeI/ChyEQJf0FLhFC2hy4Qg2Xs0MLrJcUmnjNsaYev4uleJYQcL9SesdRMTY9XCasTTO7sWee/XEFoFG/7o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:42 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:42 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 0/9] net: ethernet backplane support
Date:   Fri, 24 Apr 2020 15:46:22 +0300
Message-Id: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:41 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 849c06ee-1c3f-4c79-38e7-08d7e84d8a04
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB593729C978F9D68CF8353C8AFBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtn2usOwOgpblqw36uCKZ3unFfQODIbV/vlrx5xVb5VkBuFqoznRQJyK468XTJPHU+thSPfINoWLX3encLTmvWbLY32+Gk6L6vO9GDlphwBNGJ8k/A6KHpP28X1SpsZvY47RbiiXICc8EcBNypdWa8ee+OmSL7wfeUQoKAVZ7qqhAtBQU2tIcqMLqlp0k2QXoQyqnPUI1CwGwe+8BwkbZh2ZBih5a/d21jsdSGPYBs+eQTFPQB403gpXERYYZfq5+doVuoX4Hhqi7xXAQaM8+i350fYFRPvx7JysJI471YZqYQbXx/u30ux7tVgKHHCWeixA3xYHOXdz2XVfEAUHrCHa0NVag/TWyQnOO6Ine8k3HB0sT6JdXum55w4HMlFm65BB3YuB0oiZUN61td+cBs49NgMg1ynyWQPxgZNzcUtwLPD5Q/g1zbMHTSYzBfQY
X-MS-Exchange-AntiSpam-MessageData: 8hyedlJM/SrHBS89ujfLgs6d6likavdYBGFkJ4QyTsiDfSf5vu79XiVpBEMyQtxZRLdiO0oXhD7GHNy0enQ9wtodGL4jn50d12gJ1Q/gK9KY9Hi8JWmxpT0SyTlfueFjOuKJZaM5Had+KjRoR4V5RQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849c06ee-1c3f-4c79-38e7-08d7e84d8a04
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:42.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSxyvVsq8mvkNV2rl3sXyC/rBYUHcWasdJ1CloRLUT6T/V1Ya+zoj9GCzKa7DC1R0oo8onCD/IwHQ+jsdgbeCgLuXSK/UgoQJTvK8rIV02Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Ethernet Backplane KR generic driver using link training
(ieee802.3ap/ba standards), equalization algorithms (bee, fixed) and
enable qoriq family of devices.
This driver is dependent on uboot Backplane KR support:
patchwork.ozlabs.org/project/uboot/list/?series=164627&state=*

v2 changes:
* phy.rst and ABI/testing/sysfs-class-net-phydev updates with new PHY
interface values according to Florian Fainelli feedback
* dt bindings updates according to Rob Herring feedback: fixed errors
occurred when running 'make dt_binding_check'
* bpdev log changes according to feedback from Joe Perches: use %pV
instead of an intermediate buffer and refactoring
* reverse christmas tree updates according to David Miller feedback
* use pr_info_once function in probe to display qoriq backplane driver
version according to Joe's feedback
* introduce helper function dt_serdes_type in qoriq backplane according
to Joe's feedback
* use standard linux defines to access AN control/status registers and
not indirect with internal variables according to Andrew's feedback
* dt bindings link training updates: pre-cursor, main-cursor, post-cursor
* change display format for tx equalization using C() standard notation
* add priv pointer in backplane_device and lane as device specific private
extension to be used by upper layer backplane drivers
* backplane refactoring: split backplane_phy_info struct in
backplane_device and backplane_driver, add backplane specific ops and
move amp_red as qoriq specific param
* lane refactoring: split kr_lane_info struct in lane_device and lane_kr
in order to separate lane kr specific data by generic device lane data,
lane kr parameters unification, extension params for custom device
specific
* equalization refactoring: replace eq_setup_info/equalizer_info with
equalizer_driver/equalizer_device data structures

Feedback not addressed yet:
* general solution for PCS representation: still working to find a
generic suitable solution, exploring alternatives, perhaps this
should be addressed in phy generic layer

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

 Documentation/ABI/testing/sysfs-class-net-phydev   |    2 +-
 .../bindings/net/ethernet-controller.yaml          |    3 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      |   50 +
 .../devicetree/bindings/net/serdes-lane.yaml       |   51 +
 Documentation/devicetree/bindings/net/serdes.yaml  |   44 +
 Documentation/networking/backplane.rst             |  165 ++
 Documentation/networking/phy.rst                   |   15 +-
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
 drivers/net/phy/backplane/backplane.c              | 1626 ++++++++++++++++++++
 drivers/net/phy/backplane/backplane.h              |  293 ++++
 drivers/net/phy/backplane/eq_bee.c                 | 1076 +++++++++++++
 drivers/net/phy/backplane/eq_fixed.c               |   83 +
 drivers/net/phy/backplane/equalization.h           |  283 ++++
 drivers/net/phy/backplane/link_training.c          | 1529 ++++++++++++++++++
 drivers/net/phy/backplane/link_training.h          |   32 +
 drivers/net/phy/backplane/qoriq_backplane.c        |  501 ++++++
 drivers/net/phy/backplane/qoriq_backplane.h        |   46 +
 drivers/net/phy/backplane/qoriq_serdes_10g.c       |  486 ++++++
 drivers/net/phy/backplane/qoriq_serdes_28g.c       |  547 +++++++
 drivers/net/phy/phylink.c                          |   15 +-
 include/linux/phy.h                                |    6 +-
 32 files changed, 7334 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/serdes-lane.yaml
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

