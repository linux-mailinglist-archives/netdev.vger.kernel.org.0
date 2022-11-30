Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C310263D6B2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiK3N3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3N3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:29:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9754054B20;
        Wed, 30 Nov 2022 05:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669814982; x=1701350982;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=igkyneSahWQojHBUvpkTErM6kbG4iiuA7DeLIJI446k=;
  b=zvMXXAz82H1pMHIFyYnIoichxT8+cH3MGNYn1W4RhjZ+2R8oSnv0W/rV
   /L01wlY55rwdbkXz/ks6/VU0rFutHt3nNhCffFN7SPBHqTb38gzxes6bc
   2NKq+aiQGGVq344keHTX39oHgxj8IJSC1km09D3BEuuVfLtSQfsT2aDqy
   0zSEgfcXsKFzZyro/bZAUkjczpGdKVNlDLLEUyQNTkFvXAxEPvOIAOt1C
   7qyVIGGXpiW5z+DUOInM1045A+9AKt7K0AvS1fwPGUA02LOixxlkNDbfa
   bOeeQq126dUUXBScU97U6mq9tz3KwiMBiAWwYIvShLWxcDluwMgj724nE
   w==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191136735"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 06:29:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 06:29:41 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 06:29:37 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC Patch net-next 0/5] add ethtool categorized statistics
Date:   Wed, 30 Nov 2022 18:58:57 +0530
Message-ID: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
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
- add categorized ethtool statistics for Microchip KSZ series 
switches, support "eth-mac", "eth-phy", "eth-ctrl", "rmon" 
parameters with ethtool statistics command. mib parameter index 
are same for all KSZ family switches except KSZ8830. So, functions 
can be re-used across all KSZ Families (except KSZ8830) and LAN937x 
series. Create separate functions for KSZ8830 with their mib 
parameters.
- Remove num_alus member from ksz_chip_data structure since it is 
unused.

Changes tested on LAN937x Series and KSZ9477.

Rakesh Sankaranarayanan (5):
  net: dsa: microchip: add rmon grouping for ethtool statistics
  net: dsa: microchip: add eth ctrl grouping for ethtool statistics
  net: dsa: microchip: add eth mac grouping for ethtool statistics
  net: dsa: microchip: add eth phy grouping for ethtool statistics
  net: dsa: microchip: remove num_alus variable

 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz_common.c  |  70 +++--
 drivers/net/dsa/microchip/ksz_common.h  |  10 +-
 drivers/net/dsa/microchip/ksz_ethtool.c | 344 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  31 +++
 5 files changed, 439 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.h

-- 
2.34.1

