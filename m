Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32FB203847
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgFVNim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:38:42 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:12207
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728335AbgFVNil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:38:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5GVfX57SwnP2pdNaf+o0bdVvAEeR+T/iR6B7JYKpfwZ/M2UwU2hU/bvPtBT3cvFsq5McUNaK+t3MDZAM6xAvRwR+VZ3QzbmbkljSxWc6l2gEV32uCUsfUtCke1/7EIZoiT7T9MPQb0OXi+iobY8yXFdz1mBGqbccgUc6CH1TdPL86uR5KXMql99AkU+xphehR3DcxKmFQw1Iyhe/eTPCapz4DOU8GLAJ0rb6uzwpaptv0RT/W2ye3nske5gQHF21s5gJCYgVridVp+SuJfB6tD//w7/wkonJk9cktPxweZCPvyzBzgaHnwUZS815M47IzUz9haHXZVH6Zy6rMzoDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNFw7vmsU9mpTnzHIzSjb1FYBYxAoTfeCfNOOUlGRaw=;
 b=iJTXIq5ZrWlo693Tx9StOXenHc3HkZqNm7ES448Jm72NkqHV2AI+Ztc8oAH+o7WAhE6ie91baxHZb+Bf7qysfKknohf0/XqnIKdWB7Z5/xtEOQWM9V+OUvmPLNkjy44qytHCcmKuJtnHMmrzV0C0XkOAqtRaYVEjTzEOiaXSSD+RnWwNrjE53B7h55gwMx3+C82WAz6ufb7AAOOKrfYmnyQbJcMD0RCyFVZYU8nC5GoB7Z6cyb3F/oFRCipMMCQBNvQYkuodFBElU9W25yQUGS/kM3f/JRFry//gc1aYep01A3DqgTUjvHVxlzvfxPK3hB/eBTgK3bo3Ps9g6uxm2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNFw7vmsU9mpTnzHIzSjb1FYBYxAoTfeCfNOOUlGRaw=;
 b=dyANFxY1UwkHn/hbBhRPbyxFM8owatLbbBsiTgaBzMbvcqRNTJxXFT9/Ifpp7q8HoZrGOJHdpsEpkqwmXk7dAvsGuj4Vpy3O6FTbStAhd3qTaspgyYpvOYlsSq2wAUPCbxlCHae/cb8F1DwA7HLPoVt6dfmk4hI4JIky6SoT0vs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:38:37 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:38:37 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 0/7] net: ethernet backplane support on DPAA1
Date:   Mon, 22 Jun 2020 16:38:13 +0300
Message-Id: <1592833093-31783-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0013.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::23) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR10CA0013.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 13:38:36 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d80b0a1a-3219-4ba2-c32e-08d816b1912f
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5075230B4634B0924C9CBAA4FB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6x/w1IWam4L8lN03M0hiO893q+TosBgteA2GVoE2lcpD1OmJQTT0dTcKkWtgCJZWByWP6GzWidhd/O4/IwUOZV/wGaoiX6otpVRqnfufp5PTlg16oM2R4h3DrZgntjzfxvf3ZTYkEfCNQDhujGQ8QxCvS60ZXq3DCaxQiuej0eK/VzuK/kjqWs9U/EivdyZoL67eQqBFgMkiZ+lBFYtP5YF9GFKISb4XKBd326rCYQB5iHWmR6rfPJ6SBKq42Ba/xBd6OVm/MeSxZynX0An6OW0VCXmKxQIdB+RChlNdeX51jNc1TNcJh4svyLQyWRX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: geXCrSGhwzHAMrpWiPp088GpYfcCl9Cd5rOIEuvE+69M0Vq8QwQjYZL/WQK/9snRfU2oytUHstdvetYaTHXA1UJycth7usOCuNaX72PgDmZx219zFiHDFZnSrlb8GizpMCKGslQX5jJIzx1yBxIFeOZg0MyYqmvzSK6G2S8jNJLgj07gljx8lvsQhsgogtkozkIuhTBNwdojlaMnhKZcyLB9a5X/6G77ScUuagQvBLjuJl7wmnNNe85MKZiTyV+Y8eOosA7OzCPSlbBxuxc/RdkE934s5HXQJlWHar2Pq6PJFvpmYfLqI0wW6LbBK7u9aNiFiuRtFN/5X4+06sR4V7ZRPmWN8xsHOpjpMiV7zN1nYaA/CHFSNuDRZUeZ8rGJ41KtnTEnUNQYx/ljwFBX86loAtGtvnNHi0NM6M/YhzTpF2i9BuXdm8O6JJUsUxRd9DYtfFVucYs7/Eu7A+7sNehCFDBFK60CCLTWHYcMXRg=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80b0a1a-3219-4ba2-c32e-08d816b1912f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:38:37.5173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VdVYUTjGcDnTwxnh8yn7X5hN9+QGmy22+axLZ+xyKhjUOj8AUfn/3n34213UxYuUUJ8/UzrjXxluBQgj1rIK+emIWpQGbaxcWXlWPHA5OY=
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

