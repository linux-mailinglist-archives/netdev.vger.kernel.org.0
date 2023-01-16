Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2966BB23
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjAPKEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjAPKEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:04:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B52317CE3;
        Mon, 16 Jan 2023 02:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673863452; x=1705399452;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ObUk/ErWwdiuLLirUnI45oZLL+6Qo6Vq10+HoqsAVkc=;
  b=JEJK2Y9pux2VCwYp6zvWwFuBnm14a8CfOlo/W2H7vwKeoEga2jQr3nH/
   mPp7H0zrJ2d6UTq9ZwUDqnh/oLOJAmYQzhhiEyZfSCxJ8jJ778Bgm9u4Q
   8irOFjvbH+TkhFki2tfkNetQVeBh+IQdlbZ3ge4Zt8hhnrkMddjlAdoV1
   dEwQ6o00zO5lS4VzWOLP4GVfb+4BcfUshm2udqK4tGftoE9yC5z2gFzRW
   Nt2rroET6laTpTSz+XfTRZfq6fbHMNfeL9FFPB3HW1Q9+880hQSs9AYaF
   AJ0q2ma4sCLl+0HA+fc4kdPZrwM5F2gIPDaCjfJxCV62i8WV8cF6ZMESj
   w==;
X-IronPort-AV: E=Sophos;i="5.97,220,1669100400"; 
   d="scan'208";a="132508113"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 03:04:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 03:04:09 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 03:04:04 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <arun.ramadoss@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>
Subject: [PATCH net 0/2] phy init update and alu table correction
Date:   Mon, 16 Jan 2023 15:34:58 +0530
Message-ID: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
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

This bug-fix patch series contains following changes,

- Update forward table map in ksz9477_fdb_del API.
- Invoke phy init sequence each time of mode update in
  lan87xx_config_aneg.
- Execute phy slave init command only if phydev is configured in slave
  mode.

Rakesh Sankaranarayanan (2):
  net: dsa: microchip: ksz9477: port map correction in ALU table entry
    register
  net: dsa: microchip: lan937x: run phy initialization during each link
    update

 drivers/net/dsa/microchip/ksz9477.c |  4 +-
 drivers/net/phy/microchip_t1.c      | 70 +++++++++++++++++++++++------
 2 files changed, 58 insertions(+), 16 deletions(-)

-- 
2.34.1

