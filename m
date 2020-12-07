Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29BD2D1050
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLGMQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:16:53 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:29293 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLGMQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343413; x=1638879413;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=q6qR+M14sEQGT5M/G/pwCC67yLfxNrDN5aaMrQcZb60=;
  b=voN4BSh/9Vfmj1+y+/Zqz3eat8TJclt24CU87ydtFoLTzue2D1fN22EE
   csZJfKBJ5dGc53sdV9+LyFhDFfWlPeCpWuGFZZ5NLjBXB3si7GqyQ5/bR
   6ClQNVGwGGS6f7ukc4SM2+bQ2xD3vPsjug0GAtfVIDNTLXKJBI6XAkABK
   +QpIxHiQh1s3mIXi5djEf20xTxBxtPluk9embVVuy/VUxSvUJhdnCE/lg
   snFbsuNnycUr/AwjAeVGIWTPGx9gH9X8D+1YvwxgD0ldle9T3a3SJOyLZ
   rEAY6bJBAsS3KMuLE3+VMWPLsoZVuGRxynctT5iWVSTVYNFcj545/z4lP
   w==;
IronPort-SDR: R+zNuVLp06ABWbW733aDqxBUVgaZ6DsrsjDsEp8uW8mSj0fzQLGiT1QXOz9wkAiAJ5I3IE8ALo
 6fXIPkG53nWvWzSbJmYxxm3fBRxVsrdSSSqzmXHYuI9ddYsM8t1XUrCr4YJUOGdCOl/cpsQws+
 qk5T+ln4OAyhphXM1ycOdGLDDatvJd5+oPv2WsoFFmDB3iOY0gUzqWOhEUVOlEZqEWi4VOwhNN
 86BYQWnoSrnZk28DN5VpAu64yuhAhQojrSb/ZmtkqGDGxsSBFagKmnhrchJRpooLjJbtK/Prxv
 NlQ=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="101191972"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:15:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:15:46 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:15:37 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 0/8] net: macb: add support for sama7g5
Date:   Mon, 7 Dec 2020 14:15:25 +0200
Message-ID: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
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
 drivers/net/ethernet/cadence/macb_main.c       | 158 +++++++++++++++++--------
 3 files changed, 122 insertions(+), 49 deletions(-)

-- 
2.7.4

