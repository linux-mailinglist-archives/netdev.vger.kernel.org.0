Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA84A95CC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 10:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiBDJOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 04:14:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24409 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiBDJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 04:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643966043; x=1675502043;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p7lXd//bOK0ZwhoE3WL0tbdbFrSrXNGPG3c/ox5G2ds=;
  b=rkN6u9JmZ9A1sdo0/dfZF+95iHrEwvya9/8j+H2QshEBpGCijtun9Nz6
   bXKjp/qQExkWt7QMchCNRwWCd+V3YulbYItRYk0wcD4vDecsW29wwBu22
   L/dy77XNby2YsaLbNzWrdce2sXNSnqBHqH1/cf7/3kmXV8BlOpCfa5yJn
   slzMo99VtqhXuYhJALtYst/aC3xwzGYYyHqDUVS4XdE3xq/+4p2JmF8Bj
   uIMz9vYGP+OUreQqiSLIyDdjYCWUOZ0o2Pj+1mReymHb7XUgtJCDzBnjX
   Oyo/C9YARleoYRIJ+hmD5q3lzEJYStGPMfgkxRGVBCzfYeabUiyOkhp8W
   A==;
IronPort-SDR: y2LObx+SPh+hMhRzg1RZ7nCFjwBr9bkZBcXr+wEyMc8zOidN2hWPGIXikVTPAvvfmoloxpbAho
 vU8hfJtCbmhnjgsdnZJzndhC6VAK4vPSNmSba/pOU2XqnYW1QwkIA2tTnqQyaWbKnZdJ2svbwu
 yAF4iS8/z/31GlBqjBx3yyUd/0EHajUg4KAGMhB425mlBEFmhe1FZf+l/QlYJUaXFfqlj+E9PF
 UAWcW8hVBcDlElpryqJhjajA86AfTyvo+ftQr3YPz/Y+TQcHOyF9ZH9dFR0+9BKfNUqnhMrYcX
 Z3GRU6KCmKCU3zbFKNG0n+rQ
X-IronPort-AV: E=Sophos;i="5.88,342,1635231600"; 
   d="scan'208";a="151947597"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 02:14:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 02:14:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 02:14:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/3] net: lan966x: add support for mcast snooping
Date:   Fri, 4 Feb 2022 10:14:49 +0100
Message-ID: <20220204091452.403706-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the switchdev callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
to allow to enable/disable multicast snooping.

Horatiu Vultur (3):
  net: lan966x: Update the PGID used by IPV6 data frames
  net: lan966x: Implement the callback
    SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
  net: lan966x: Update mdb when enabling/disabling mcast_snooping

 .../ethernet/microchip/lan966x/lan966x_main.c | 41 ++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
 .../ethernet/microchip/lan966x/lan966x_mdb.c  | 45 ++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 18 ++++++
 .../microchip/lan966x/lan966x_switchdev.c     | 61 +++++++++++++++++++
 5 files changed, 166 insertions(+), 2 deletions(-)

-- 
2.33.0

