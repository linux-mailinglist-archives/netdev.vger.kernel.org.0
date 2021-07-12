Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABE43C5CD5
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhGLNBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:01:18 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:58296 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233737AbhGLNBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:01:10 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CCpXMN014668;
        Mon, 12 Jul 2021 08:58:06 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 39r4982tua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:58:06 -0400
Received: from SCSQMBX11.ad.analog.com (SCSQMBX11.ad.analog.com [10.77.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 16CCw4jQ040615
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Jul 2021 08:58:05 -0400
Received: from SCSQMBX11.ad.analog.com (10.77.17.10) by
 SCSQMBX11.ad.analog.com (10.77.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 05:58:03 -0700
Received: from zeus.spd.analog.com (10.66.68.11) by scsqmbx11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 12 Jul 2021 05:58:03 -0700
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 16CCvx09018858;
        Mon, 12 Jul 2021 08:57:59 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH v2 0/7] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Mon, 12 Jul 2021 16:06:24 +0300
Message-ID: <20210712130631.38153-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: QCqkTfX_Nu-Y2LYv_YguK4XFUADAkWRk
X-Proofpoint-ORIG-GUID: QCqkTfX_Nu-Y2LYv_YguK4XFUADAkWRk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_07:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107120101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
industrial Ethernet applications and is compliant with the IEEE 802.3cg
Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.

Ethtool output:
        Settings for eth1:
        Supported ports: [ TP	 MII ]
        Supported link modes:   10baseT1L/Full
                                2400mv
                                1000mv
        Supported pause frame use: Transmit-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT1L/Full
                                2400mv
                                1000mv
        Advertised pause frame use: Transmit-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT1L/Full
                                             2400mv
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 10Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred master
        master-slave status: master
        Port: MII
        PHYAD: 0
        Transceiver: external
        Link detected: yes
SQI: 7/7

1. Add basic support for ADIN1100.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

1. Added 10baset-T1L link modes.

2. Added 10base-T1L voltage levels link modes. 1v is the default TX level.
2.4 V support depends on pin configuration and power supply.

3. Allow user to access error and frame counters through ethtool.

4. Allow user to set the master-slave configuration of ADIN1100.

5. Convert MSE to SQI using a predefined table and allow user access
through ethtool.

6. DT bindings for ADIN1100.

Alexandru Tachici (6):
  ethtool: Add 10base-T1L link mode entries
  ethtool: Add 10base-T1L voltage levels link mode entries
  net: phy: adin1100: Add ethtool get_stats support
  net: phy: adin1100: Add ethtool master-slave support
  net: phy: adin1100: Add SQI support
  dt-bindings: adin1100: Add binding for ADIN1100 Ethernet PHY

Changelog v1 -> v2:
  - Added ETHTOOL_LINK_MODE_10baseT1L_Full_BIT and ETHTOOL_LINK_MODE_10baseT1L_Half_BIT.
  Using only full duplex here as chip supports full duplex only
  - removed .match_phy_device
  - removed link partner advertising of modes not present in the kernel
  - enable/disable only the PCS loopback
  - replaced custom timeout implementations with phy_read_mmd_poll_timeout
  - added link modes for 1.0 V and 2.4 V TX levels
  - removed link change notify
  - check if 2.4v TX level is supported in adin_get_features call and set
  corresponding link mode

 .../devicetree/bindings/net/adi,adin1100.yaml |  45 ++
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin1100.c                    | 533 ++++++++++++++++++
 drivers/net/phy/phy-core.c                    |   4 +-
 include/uapi/linux/ethtool.h                  |   4 +
 net/ethtool/common.c                          |   6 +
 7 files changed, 599 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
 create mode 100644 drivers/net/phy/adin1100.c

--
2.25.1
