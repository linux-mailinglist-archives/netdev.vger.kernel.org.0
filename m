Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9765FF15A
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJNP3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJNP3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:29:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD32B1C8431;
        Fri, 14 Oct 2022 08:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665761354; x=1697297354;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y+jvU0ool7ikd1UH5iFyfXPR2vAzrz+slhkP53w+ofk=;
  b=1nXXx5Tyj8pOZRN8w+5x6Z5ArGVadfyDRX2NbxmJkcKuP2CundOZzcRT
   JwAQt2qUbzEsSUFmJpYgfaIrAxLeYJBsyhoGi6sw/U7bFogPOZylrLmkP
   WaZVjdg8FoNBU2aKIdeSiJRlJqJyeafMSqDu6fy5v30acMr8zzKBXlt8I
   YFNZuugi2I00rnrxy+ZfXNAu/aJghbi9OH8FZqs4hVctc3zmBcL9gX1wH
   Je0STBepyxb5UqZxUQVbHK4hRQsBPgApBHAwpRWHHu7KRlk5YAcgVGU/C
   RfR2RcbRmo38lpuK3Ai7lo47RvEAiKpgOew9H8CSEdqzwvwdmyUNSIyaz
   A==;
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="178786889"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2022 08:29:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 14 Oct 2022 08:29:12 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 14 Oct 2022 08:29:06 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support for LAN937x switch
Date:   Fri, 14 Oct 2022 20:58:51 +0530
Message-ID: <20221014152857.32645-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN937x switch has capable for supporting IEEE 1588 PTP protocol. This
patch series add gPTP profile support and tested using the ptp4l application.
LAN937x has the same PTP register set similar to KSZ9563, hence the
implementation has been made common for the ksz switches. But the testing is
done only for lan937x switch.

Arun Ramadoss (6):
  net: dsa: microchip: adding the posix clock support
  net: dsa: microchip: Initial hardware time stamping support
  net: dsa: microchip: Manipulating absolute time using ptp hw clock
  net: dsa: microchip: enable the ptp interrupt for timestamping
  net: dsa: microchip: Adding the ptp packet reception logic
  net: dsa: microchip: add the transmission tstamp logic

 drivers/net/dsa/microchip/Kconfig       |  10 +
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz_common.c  |  43 +-
 drivers/net/dsa/microchip/ksz_common.h  |  31 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 755 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |  84 +++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  68 +++
 include/linux/dsa/ksz_common.h          |  53 ++
 net/dsa/tag_ksz.c                       | 156 ++++-
 9 files changed, 1192 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
 create mode 100644 include/linux/dsa/ksz_common.h


base-commit: 66ae04368efbe20eb8951c9a76158f99ce672f25
-- 
2.36.1

