Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBEE20381E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgFVNf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:35:56 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:36110
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728259AbgFVNf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:35:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfCjN4TDD/XUzW2iyYh2F2iPdAdAEOJKa3uqRZgm9I1IsnrqdZk2bb8EFuOq7WPiHNoiH3C5rv1cEmBFSQhz27FRcgNPskyWUB+73urEoZkLmZ4vs9zn/JC8GzGtXfTlxUGWFRa9pR5fuNu6lnnQfd7T5V8v6VgfPp7vR/Oi0EOO6gHGBxKmXCPMvRqeb/S3AEX1mlBfOHauKT21Gk5y2EZRV5/4ZOqNbs2t+hI4MlPH8akEuX7jvJRPg6Nbz9ox4OQ78V+QAobRgZ+jp1z59q7ULCKCtk96jOMY4gVtwDnLGWeTFAWDhaWZstLptC47UH4ISkO82VSqJkdDubUNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNFw7vmsU9mpTnzHIzSjb1FYBYxAoTfeCfNOOUlGRaw=;
 b=larxwxY5EKzwhCewZ34J55MiVIw0TCoLykkg5eyXPV+81y62CTbOwWgJU20bHQ1oNrdH97IKqYV92+MZW8C+Y4YVVNeG4UpNYexDVb2Co0QmLh5Wi/lLyE+TmHd/OVdgeCUi8Jo6ug9DrBK/H+g0jK1atRA65Fx7OS5gD/TyQ0TQkFJjBpcxThHdwTIrGmXRfNNeLd2XzAUqRa2kcsUWctzXqVE6aYtN4LyyPCfLTQlZmjl1Ey1HuUqA/EBa/FBId19MRZUK9wQ4j2MK04qKDk3i8cCLWwFLJbNTwPx9cuQXzXqQjfyE6w4KF3WZQj9dHAnFDegI7tvf6IvLWiLYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNFw7vmsU9mpTnzHIzSjb1FYBYxAoTfeCfNOOUlGRaw=;
 b=ocvBMkUS8vtLPXMOjUkLH+68QOdVnzyg7RQDv2DR7EAO/IgRe/WRPK7EPq/SrMg5EdjU5FboBO0mnEfXHmM54xKrEreiQCUkhLBuHJRF6GaIz1B5x/OReDJj/cHKGHH7mFVg9V+KrhqAauNJNrNooyRAIaPXZH6GlZKi018Sae4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:51 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:51 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 0/9] net: ethernet backplane support on DPAA1
Date:   Mon, 22 Jun 2020 16:35:17 +0300
Message-Id: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:50 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e4f10de-56f4-4010-13bb-08d816b12e46
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5075E5E344E684C5A49D86AAFB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3u5IBbcdPhx2Azm9bES/hjjegdyXxVWxwLLGpkf1gejS8HYHV089cSYmjJreH+AnujWYildEoNiz9Di4agetStPNCJcKzN4LgCcqOVL/E2qotWUmy7JYaB5RvfttoRbytly6aoIpMhQSIqvn9s4s0c8yKuk+NgiZ/J94DQXDgKTo3r4oOcgd87hwvGa0S0xDHonBMG4seYreHTikSsI1EOF6NufGq3apm7XfM8mkHfHe0nYDIQN4kVr4qrlnEQ64qvZzLPk//EVPUE2RxxiNGwvQcKuKdCCNX3mkNLHW0or0WkRwPvuiV1etxq36AkJ4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gK025rAsjUucR5AyLJq3t7m2K8Q60k2uhkZlfipkxVKtrkvR3eexsExxrHe1ez4cD/pvLSuSocuMX2uTux/meYUf5+Iaaj9nZmHkrFxEO3au/ztUaKiTUIS1ygM7I1eoij4lS1Trw2HHOn+6IQ+nKYeFoiRTLNVqmZ4Zi+Gm8ei+Un1HZf7geWVeEqxulWliA70Ly8utguTZFnWACGUzSwldbMxpg+NPp4NhDXSiOoPDsBU3n0jmw4BsauAxhl2gp86XO3A2p8lwOIFI2q5npIp1ah/5upW/KH96xX7E5iM7QAFDykelY7K+lHgPoKgfd+vPv+06HVLmLhaGjCvpSY2K8GPsLLKpKravSzkBpxBbiAjP1iAdMqxzQ6JwbR9RuMAPTki8DDtnkBMS/ptOnYmR40FahlmcEURGung0lCfBAksuCpRXXzzFa35b5CDQis9i6w8GJMHu58dtj6+wB58Y2rklqpBoCufrJyNoRj0=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4f10de-56f4-4010-13bb-08d816b12e46
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:51.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djvGXY5gTECc3nWS1htMHv7IGQAs+SuTYJot22+PfgIq5RX248VPCnqBoEw553+PgdFGkTzHOB2FCPfJNR4iIZ5/4VTCRmvROZLeCz0EHno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Ethernet Backplane KR driver only on DPAA1 devices.
Ethernet Backplane KR generic driver is using link training
(ieee802.3ap/ba standards), equalization algorithms (bee, fixed) and
enable qoriq family of devices.
This driver is dependent on uboot Backplane KR support:
patchwork.ozlabs.org/project/uboot/list/?series=164627&state=*

v3 changes:
* The entire DPAA2 support was removed as well as phylink changes.
This patchset contains only DPAA1 support for KR.
* DPAA2 support will be added after we find a suitable solution
for PCS representation.
* All the changes made in v2 that addressed all the feedback not
related to PCS representation, are kept in v3 as well.

Florinel Iordache (7):
  doc: net: add backplane documentation
  dt-bindings: net: add backplane dt bindings
  net: fman: add kr support for dpaa1 mac
  net: phy: add backplane kr driver support
  net: phy: enable qoriq backplane support
  net: phy: add bee algorithm for kr training
  arm64: dts: add serdes and mdio description

 .../bindings/net/ethernet-controller.yaml          |    7 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      |   50 +
 .../devicetree/bindings/net/serdes-lane.yaml       |   49 +
 Documentation/devicetree/bindings/net/serdes.yaml  |   42 +
 Documentation/networking/backplane.rst             |  159 ++
 Documentation/networking/phy.rst                   |    9 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   33 +-
 .../boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi    |    5 +-
 .../boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi    |    5 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   10 +-
 drivers/net/phy/Kconfig                            |    2 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/backplane/Kconfig                  |   40 +
 drivers/net/phy/backplane/Makefile                 |   12 +
 drivers/net/phy/backplane/backplane.c              | 1557 ++++++++++++++++++++
 drivers/net/phy/backplane/backplane.h              |  293 ++++
 drivers/net/phy/backplane/eq_bee.c                 | 1076 ++++++++++++++
 drivers/net/phy/backplane/eq_fixed.c               |   83 ++
 drivers/net/phy/backplane/equalization.h           |  275 ++++
 drivers/net/phy/backplane/link_training.c          | 1529 +++++++++++++++++++
 drivers/net/phy/backplane/link_training.h          |   32 +
 drivers/net/phy/backplane/qoriq_backplane.c        |  473 ++++++
 drivers/net/phy/backplane/qoriq_backplane.h        |   42 +
 drivers/net/phy/backplane/qoriq_serdes_10g.c       |  486 ++++++
 24 files changed, 6258 insertions(+), 12 deletions(-)
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

-- 
1.9.1

