Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EBA69A992
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBQLBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjBQLBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:01:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4ED3028D;
        Fri, 17 Feb 2023 03:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676631707; x=1708167707;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+stRTbY/L8meiP8dwWYv6r3u8FQGcbCZds6zDh2+IuY=;
  b=YuuPJbRa6VyP3rsYbCSJlN090WLQ0X9ZkOhx3JBmeS3Py7NKkLi1Ziiz
   LgAHGVaSrHKVWVYOCoZmzCP62XBxS3Xuyc6l2bF0IdJAdzjZ3Ag/H0+x1
   L9pkf+lBDOaMM9dN9cAnrd8/BTn6I0v4mXvocJ1317kNBnZlujqBIWtnw
   Inshnjyd7nmNISTx4B10oHEJTi9CaywF2Uk6VMhllcDDixmzVr87/qhgp
   TJguX8B1nUByzFE7D6p7otk+1gZs7Xk8pDFTd46flcm19E+mxHQM3GwBf
   om6lAmIJjrR5fNaYSThsfT+zJA0v+Ze12lts/7pSDdfvHzcPAJYwj8U2E
   g==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="197482795"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 04:01:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:01:41 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:01:37 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v2 net-next 0/5] add ethtool categorized statistics
Date:   Fri, 17 Feb 2023 16:32:06 +0530
Message-ID: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch series contain following changes:
- add categorized ethtool statistics for Microchip KSZ series switches,
  support "eth-mac",  "eth-phy", "eth-ctrl", "rmon" parameters with
  ethtool statistics command. mib parameter index are same for all
  KSZ family switches except KSZ8830. So, functions can be re-used
  across all KSZ Families (except KSZ8830) and LAN937x series. Create
  separate functions for KSZ8830 with their mib parameters.
- Remove num_alus member from ksz_chip_data structure since it is unused

v2
- updated all constants as capital
- removed counters that are not supported in hardware
- updated the FramesTransmittedOK and OctetsTransmittedOK counters as
  per standards

v1
- Initial submission

Rakesh Sankaranarayanan (5):
  net: dsa: microchip: add rmon grouping for ethtool statistics
  net: dsa: microchip: add eth ctrl grouping for ethtool statistics
  net: dsa: microchip: add eth mac grouping for ethtool statistics
  net: dsa: microchip: add eth phy grouping for ethtool statistics
  net: dsa: microchip: remove num_alus_variable

 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz_common.c  |  70 +++--
 drivers/net/dsa/microchip/ksz_common.h  |  10 +-
 drivers/net/dsa/microchip/ksz_ethtool.c | 348 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  31 +++
 5 files changed, 443 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.h

-- 
2.34.1

