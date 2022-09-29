Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE875EFD35
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiI2Smj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiI2Smg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:42:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC45F14A7BF;
        Thu, 29 Sep 2022 11:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664476953; x=1696012953;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XcFyeGyj+/KZjiaV4KJsJEm4D8dAIds+Oq3niZxyoSA=;
  b=BqDNgoWpgQD25aWX2uO1crlu3SB1MAdZaw8Pj9DlGqb0+J8QdyNXsk5c
   CI93gHrYYzJBciSL81Jmbpb/e8umuVyKEw02qwZHXlbeVbYUbIBrtlfxi
   vihG3/csEdKJIA6iKYRIRmOpMCt/y4iwoxW2AIhQoTlgZsRG0Lqqlc6jX
   XQzvo8APZ5BjBOMjL0k3UlYxN9dWpOx5jgXhbUVxS0aicrNG2wKKJ1dWN
   J0NWhoG/19op9W7t+2lENRmy3whg9B0UCdmTKL+hUQuQ3UZc8BpO6c2kq
   blZpZgSOHhDA+Gc7ivNc4cKpBJ/TToBrLWqAYpIi4kTKiU9dZXvL2qiRk
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="193094656"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Sep 2022 11:42:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 29 Sep 2022 11:42:28 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 29 Sep 2022 11:42:24 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v2 0/6] Add new PCP and APPTRUST attributes to dcbnl
Date:   Thu, 29 Sep 2022 20:52:01 +0200
Message-ID: <20220929185207.2183473-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds new extension attributes to dcbnl, for PCP queue
classification and per-selector trust and trust order. Additionally, the
microchip sparx5 driver has been dcb-enabled to make use of the new
attributes to offload PCP, DSCP and Default prio to the switch, and
implement trust order of selectors.

For pre-RFC discussion see:
https://lore.kernel.org/netdev/Yv9VO1DYAxNduw6A@DEN-LT-70577/

For RFC series see:
https://lore.kernel.org/netdev/20220915095757.2861822-1-daniel.machon@microchip.com/

In summary: there currently exist no convenient way to offload per-port
PCP-based queue classification to hardware. Similarly, there is no way
to indicate the notion of trust for APP table selectors. This patch
series addresses both topics.

PCP based queue classification:
  - 8021Q standardizes the Priority Code Point table (see 6.9.3 of IEEE
    Std 802.1Q-2018).  This patch series makes it possible, to offload
    the PCP classification to said table.  The new PCP selector is not a
    standard part of the APP managed object, therefore it is
    encapsulated in a new non-std extension attribute.

Selector trust:
  - ASIC's often has the notion of trust DSCP and trust PCP. The new
    attribute makes it possible to specify a trust order of app
    selectors, which drivers can then react on.

DCB-enable sparx5 driver:
 - Now supports offloading of DSCP, PCP and default priority. Only one
   mapping of protocol:priority is allowed. Consecutive mappings of the
   same protocol to some new priority, will overwrite the previous. This
   is to keep a consistent view of the app table and the hardware.
 - Now supports dscp and pcp trust, by use of the introduced
   dcbnl_set/getapptrust ops. Sparx5 supports trust orders: [], [dscp],
   [pcp] and [dscp, pcp]. For now, only DSCP and PCP selectors are
   supported by the driver, everything else is bounced.

Patch #1 introduces a new PCP selector to the APP object, which makes it
possible to encode PCP and DEI in the app triplet and offload it to the
PCP table of the ASIC.

Patch #2 Introduces the new extension attributes
DCB_ATTR_DCB_APP_TRUST_TABLE and DCB_ATTR_DCB_APP_TRUST. Trusted
selectors are passed in the nested DCB_ATTR_DCB_APP_TRUST_TABLE
attribute, and assembled into an array of selectors:

  u8 selectors[256];

where lower indexes has higher precedence.  In the array, selectors are
stored consecutively, starting from index zero. With a maximum number of
256 unique selectors, the list has the same maximum size.

Patch #3 Sets up the dcbnl ops hook, and adds support for offloading pcp
app entries, to the PCP table of the switch.

Patch #4 Makes use of the dcbnl_set/getapptrust ops, to set a per-port
trust order.

Patch #5 Adds support for offloading dscp app entries to the DSCP table
of the switch.

Patch #6 Adds support for offloading default prio app entries to the
switch.

================================================================================

RFC v1:
https://lore.kernel.org/netdev/20220908120442.3069771-1-daniel.machon@microchip.com/

RFC v1 -> RFC v2:
  - Added new nested attribute type DCB_ATTR_DCB_APP_TRUST_TABLE.
  - Renamed attributes from DCB_ATTR_IEEE_* to DCB_ATTR_DCB_*.
  - Renamed ieee_set/getapptrust to dcbnl_set/getapptrust.
  - Added -EOPNOTSUPP if dcbnl_setapptrust is not set.
  - Added sanitization of selector array, before passing to driver.

RFC v2 -> (non-RFC) v1
 - Added additional check for selector validity.
 - Fixed a few style errors.
 - using nla_start_nest() instead of nla_start_nest_no_flag().
 - Moved DCB_ATTR_DCB_APP_TRUST into new enum.
 - Added new DCB_ATTR_DCB_APP extension attribute, for non-std selector
   values.
 - Added support for offloading dscp, pcp and default prio in the sparx5
   driver.
 - Added support for per-selector trust and trust order in the sparx5
   driver.

v1 -> v2
  - Fixed compiler and kdoc warning

Daniel Machon (6):
  net: dcb: add new pcp selector to app object
  net: dcb: add new apptrust attribute
  net: microchip: sparx5: add support for offloading pcp table
  net: microchip: sparx5: add support for apptrust
  net: microchip: sparx5: add support for offloading dscp table
  net: microchip: sparx5: add support for offloading default prio

 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 287 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |   4 +
 .../microchip/sparx5/sparx5_main_regs.h       | 127 +++++++-
 .../ethernet/microchip/sparx5/sparx5_netdev.c |   1 +
 .../ethernet/microchip/sparx5/sparx5_port.c   |  99 ++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  33 ++
 .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
 include/net/dcbnl.h                           |   4 +
 include/uapi/linux/dcbnl.h                    |  15 +
 net/dcb/dcbnl.c                               | 126 +++++++-
 11 files changed, 691 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c

--
2.34.1

