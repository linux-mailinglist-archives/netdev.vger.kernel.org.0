Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF002514F5F
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378407AbiD2Pab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356247AbiD2Pa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:30:27 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B255D4C92;
        Fri, 29 Apr 2022 08:27:09 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEmwoR019342;
        Fri, 29 Apr 2022 11:26:41 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3fprv535t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:41 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 23TFQdYA024080
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 Apr 2022 11:26:39 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 29 Apr
 2022 11:26:38 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 29 Apr 2022 11:26:38 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 23TFQEce028122;
        Fri, 29 Apr 2022 11:26:20 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v7 0/7] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Fri, 29 Apr 2022 18:34:30 +0300
Message-ID: <20220429153437.80087-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: 7aHfmSGKdAuEkqB2SsDASE8KW8oxkQQm
X-Proofpoint-ORIG-GUID: 7aHfmSGKdAuEkqB2SsDASE8KW8oxkQQm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=763 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290083
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
industrial Ethernet applications and is compliant with the IEEE 802.3cg
Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.

The ADIN1100 uses Auto-Negotiation capability in accordance
with IEEE 802.3 Clause 98, providing a mechanism for
exchanging information between PHYs to allow link partners to
agree to a common mode of operation.

The concluded operating mode is the transmit amplitude mode and
master/slave preference common across the two devices.

Both device and LP advertise their ability and request for
increased transmit at:
- BASE-T1 autonegotiation advertisement register [47:32]\
Clause 45.2.7.21 of Standard 802.3
- BIT(13) - 10BASE-T1L High Level Transmit Operating Mode Ability
- BIT(12) - 10BASE-T1L High Level Transmit Operating Mode Request

For 2.4 Vpp (high level transmit) operation, both devices need
to have the High Level Transmit Operating Mode Ability bit set,
and only one of them needs to have the High Level Transmit
Operating Mode Request bit set. Otherwise 1.0 Vpp transmit level
will be used.

Settings for eth1:
	Supported ports: [ TP	 MII ]
	Supported link modes:   10baseT1L/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT1L/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT1L/Full
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 10Mb/s
	Duplex: Full
	Auto-negotiation: on
	master-slave cfg: preferred slave
	master-slave status: slave
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: external
	MDI-X: Unknown
	Link detected: yes
	SQI: 7/7

1. Add basic support for ADIN1100.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

1. Added 10baset-T1L link modes.

2. Added 10-BasetT1L registers.

3. Added Base-T1 auto-negotiation registers. For Base-T1 these
registers decide master/slave status and TX voltage of the
device and link partner.

4. Added 10BASE-T1L support in phy-c45.c. Now genphy functions will call
Base-T1 functions where registers don't match, like the auto-negotiation ones.

5. Convert MSE to SQI using a predefined table and allow user access
through ethtool.

6. DT bindings for the 2.4 Vpp transmit mode.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

Alexandru Tachici (6):
  ethtool: Add 10base-T1L link mode entry
  net: phy: Add 10-BaseT1L registers
  net: phy: Add BaseT1 auto-negotiation registers
  net: phy: Add 10BASE-T1L support in phy-c45
  net: phy: adin1100: Add SQI support
  dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp

Changelog V6 -> V7:
	- added kdoc for pma_extable in struct phy_device
	- updated drivers/net/phy/phylink.c::phylink_caps_to_linkmodes()

 .../devicetree/bindings/net/ethernet-phy.yaml |   9 +
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin1100.c                    | 292 ++++++++++++++++++
 drivers/net/phy/phy-c45.c                     | 257 ++++++++++++++-
 drivers/net/phy/phy-core.c                    |   3 +-
 drivers/net/phy/phy_device.c                  |   4 +-
 drivers/net/phy/phylink.c                     |   4 +-
 include/linux/mdio.h                          |  70 +++++
 include/linux/phy.h                           |   5 +-
 include/uapi/linux/ethtool.h                  |   1 +
 include/uapi/linux/mdio.h                     |  75 +++++
 net/ethtool/common.c                          |   3 +
 13 files changed, 722 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/phy/adin1100.c

-- 
2.25.1

