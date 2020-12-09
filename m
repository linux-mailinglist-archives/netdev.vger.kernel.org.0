Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7790C2D42DC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgLINFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:06 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25093 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgLINFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519104; x=1639055104;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=3VEArB5XibEoHcgKryL5dGKaMkyVbmz94yJ+wDtew58=;
  b=Z2Awfb7Yr77RkVoykWAbkT7MsMjRxakOxyCC9l5d7HJ8GDgG3Dv9slwH
   QlI3Z9zT0uz/P2vtJxUmOPWqlyKkh92dheEEYd6uw4KQlEVM15qpN0YoL
   kxnAJWDiVkceaC8vJcNp2C761ddtNVCpdCQ6QzNdgnDkSyF34NqteBERl
   VYD81NUkLFa81FnAcR3OrLZIwHKdpdTo+JMAsTjyCnKLs2yKPr5nt7D4h
   +ht3G+mq4tSHSCitBVQl47HQ6aEIS/hKOJYAQ17jolELfKWmfbpTFDdH9
   wDrKlMzq6S9Wy5IRSA4Qtn6YJGOZTwlatvaKiFIws+EhIlxCoBA6z6ECh
   g==;
IronPort-SDR: Wb3mz58QsGLlyO+n8Tfn+3uH/qd/+27a1Wmk46njoyUg7qfNEHTuQExbcDBADE08JOAVYc1Fdh
 I5zunxGPGffVEd1DJR+u1iJRTwXNg2X1C9z26KUrhkMxVANvWwg2esPGkATW2RkiNb9luuK8eZ
 lqyxYjtvXohowwBHWcCyQgba9raXLYhzt1Jns/MMjDc7d+KSIh73AY3Tyq8TxSmQ034k4+rxWf
 YGNFefzji9rMOaIiJfbsaAPwkyymMjL4BSvyXbTnuRdPsqCIMjIXjb1zPL6YiieDFUGnCEYkTA
 2Go=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="96475062"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:03:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:03:47 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:03:41 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 0/8] net: macb: add support for sama7g5
Date:   Wed, 9 Dec 2020 15:03:31 +0200
Message-ID: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for SAMA7G5 Ethernet interfaces: one 10/100Mbps
and one 1Gbps interfaces.

Along with it I also included a fix to disable clocks for SiFive FU540-C000
on failure path of fu540_c000_clk_init().

Thank you,
Claudiu Beznea

Changed in v3:
- use clk_bulk_disable_unprepare in patch 3/8
- corrected clang compilation warning in patch 3/8
- revert changes in macb_clk_init() in patch 3/8

Changes in v2:
- introduced patch "net: macb: add function to disable all macb clocks" and
  update patch "net: macb: unprepare clocks in case of failure" accordingly
- collected tags

Claudiu Beznea (8):
  net: macb: add userio bits as platform configuration
  net: macb: add capability to not set the clock rate
  net: macb: add function to disable all macb clocks
  net: macb: unprepare clocks in case of failure
  dt-bindings: add documentation for sama7g5 ethernet interface
  dt-bindings: add documentation for sama7g5 gigabit ethernet interface
  net: macb: add support for sama7g5 gem interface
  net: macb: add support for sama7g5 emac interface

 Documentation/devicetree/bindings/net/macb.txt |   2 +
 drivers/net/ethernet/cadence/macb.h            |  11 ++
 drivers/net/ethernet/cadence/macb_main.c       | 134 ++++++++++++++++++-------
 3 files changed, 111 insertions(+), 36 deletions(-)

-- 
2.7.4

