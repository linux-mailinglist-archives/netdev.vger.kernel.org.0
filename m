Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3109273E0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfEWBUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:41 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:5421
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioV1lblCmNc3mzMXxd3KsvRml3EvfkNndcHo/ZABV20=;
 b=eepDsPMtUMu6Gj/g5eDXrES8kERaw/z1JXow0tQsnJ2AvPaxC2qjnk+uIqDdkpGgUkr0CXyki1X4XUOA55bmAAFMKs1sqImGN0y5lCwA6XAq4MDVAm/oduqpljVyiqKmosxZADQWkUaqdiG4PpmWHNpVRfwhseGuhYBmNggcFRM=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:36 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:36 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC PATCH net-next 0/9] Decoupling PHYLINK from struct net_device
Thread-Topic: [RFC PATCH net-next 0/9] Decoupling PHYLINK from struct
 net_device
Thread-Index: AQHVEQW5LCnQ69vI+UqiQERNjlA4zw==
Date:   Thu, 23 May 2019 01:20:36 +0000
Message-ID: <20190523011958.14944-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P18901CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::19) To VI1PR0402MB2800.eurprd04.prod.outlook.com
 (2603:10a6:800:b8::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [5.12.225.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b26dded3-a4c9-4ce4-8102-08d6df1cdc0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <VI1PR0402MB3677FE95E950FB1F9595B7B0E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(6306002)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(5024004)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(966005)(68736007)(102836004)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(66476007)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I8SggYFIlgd6dbaUFqCfbMXCaatbmANoYPa1c1ozj02ctdy8Szjvd3+1KIVGkbJ5WKSkR89xAhTzA7L0xFmTqe5NHTPfuQty+zOMSGOJUuy1Q0O4DrXJNpuJI6YZEh26zHncHa7mgd6svIo9yRh1qOsHZptBn7sTvUYI0oJZ3SSY4E4R0utlDY0QjJbH2d4NZLxMhi7ICgnavY0Di5wwBYE8xUzqt+9gplAx7QVjOOrpMJDo1ETOkLbZ40f8BKzu6cPIG52gi498qs6ZwxmGZ8MgmnDwiBkczheO+19twdK0Ce08FnWVCNL0dZysfHWyJJdXSK0xWZk6QNd7BVGxTNscX3Y4yopEOU7p9ngdjwE6Zu3qP0NPHxEy5Zk031YnoAhCxfDOWBAMjrkKE28o/av0qkCg+BmVd8pwxFdVM70=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <650F3E46B749F3478ED5AC94056D72DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26dded3-a4c9-4ce4-8102-08d6df1cdc0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:36.6080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following two separate discussion threads in:
  https://www.spinics.net/lists/netdev/msg569087.html
and:
  https://www.spinics.net/lists/netdev/msg570450.html

PHYLINK was reworked in order to add a new "raw" interface, alongside
the one based on struct net_device. The raw interface works by passing
structures to the owner of the phylink instance through a blocking
notifier call.

The event API exposed by the new notifier mechanism is a 1:1 mapping to
the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.

PHYLIB (which PHYLINK uses) was reworked to the extent that it does not
crash when connecting to a PHY and the net_device pointer is NULL.

Lastly, DSA has been reworked in its way that it handles PHYs for ports
that lack a net_device (CPU and DSA ports).  For these, it was
previously using PHYLIB and is now using the PHYLINK raw API.

The implication of the above is that DSA drivers that used to rely on
the .adjust_link to configure their CPU/DSA ports as fixed-link are now
broken.  Full explanation is found in patch 8/9, and a sample fix for
the SJA1105 driver is found in 9/9.  The drivers below are affected:

* b53: Uses .adjust_link for fixed-links on CPU port, as well as
  .phylink_mac_config.
  Migration to 100% PHYLINK does not appear trivial.

* ksz9477: rtl8366rb: mt7530: vsc73xx: Uses .adjust_link exclusively.
  Either the devicetree bindings document or code checks/comments reveal
  that the adjust_link is used for handling a fixed-link.
  Migration to PHYLINK appears trivial.

* qca8k: lan9303: Uses .adjust_link to configure fixed-link ports (skips
  the rest).
  Migration to PHYLINK appears trivial.

The patchset was tested on the NXP LS1021A-TSN board having the
following Ethernet layout:
  https://lkml.org/lkml/2019/5/5/279
The CPU port was moved from the internal RGMII fixed-link (enet2 ->
switch port 4) to an external loopback Cat5 cable between the enet1 port
and the front-facing swp2 SJA1105 port. In this mode, both the master
and the CPU port have an attached PHY which detects link change events:

[   42.785627] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Down
[   43.025678] Broadcom BCM5464 mdio@2d24000:03: Link is Down
[   49.025793] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Up - 1Gbps/Fu=
ll - flow control off
[   49.266299] Broadcom BCM5464 mdio@2d24000:03: Link is Up - 1Gbps/Full - =
flow control off

Ioana Ciornei (7):
  net: phy: Guard against the presence of a netdev
  net: phy: Add phy_standalone sysfs entry
  net: phylink: Add phylink_mac_link_{up,down} wrapper functions
  net: phylink: Add phylink_create_raw
  net: phylink: Make fixed link notifier calls edge-triggered
  net: dsa: Move the phylink driver calls into port.c
  net: dsa: Use PHYLINK for the CPU/DSA ports

Vladimir Oltean (2):
  net: phy: Add phy_sysfs_create_links helper function
  net: dsa: sja1105: Fix broken fixed-link interfaces on user ports

 drivers/net/dsa/sja1105/sja1105_main.c |  11 +-
 drivers/net/phy/phy_device.c           |  88 +++++++---
 drivers/net/phy/phylink.c              | 224 ++++++++++++++++++++-----
 include/linux/phylink.h                |  21 +++
 include/net/dsa.h                      |   3 +
 net/dsa/dsa_priv.h                     |  19 +++
 net/dsa/port.c                         | 207 ++++++++++++++++-------
 net/dsa/slave.c                        |  49 +-----
 8 files changed, 441 insertions(+), 181 deletions(-)

--=20
2.21.0

