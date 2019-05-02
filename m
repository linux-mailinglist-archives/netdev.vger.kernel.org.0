Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63CA11699
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEBJlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:41:07 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:8818 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBJlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 05:41:07 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,421,1549954800"; 
   d="scan'208";a="31734059"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 May 2019 02:41:05 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch05.mchp-main.com
 (10.10.76.106) with Microsoft SMTP Server id 14.3.352.0; Thu, 2 May 2019
 02:40:55 -0700
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul Burton" <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/3] Add hw offload of TC police on MSCC ocelot
Date:   Thu, 2 May 2019 11:40:26 +0200
Message-ID: <20190502094029.22526-1-joergen.andreasen@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series enables hardware offload of ingress port policing
on the MSCC ocelot board.

Joergen Andreasen (3):
  net/sched: act_police: move police parameters into separate header
    file
  net: mscc: ocelot: Implement port policers via tc command
  MIPS: generic: Add police related options to ocelot_defconfig

 arch/mips/configs/generic/board-ocelot.config |   7 +
 drivers/net/ethernet/mscc/Makefile            |   2 +-
 drivers/net/ethernet/mscc/ocelot.c            |   6 +-
 drivers/net/ethernet/mscc/ocelot.h            |   3 +
 drivers/net/ethernet/mscc/ocelot_police.c     | 289 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.h     |  16 +
 drivers/net/ethernet/mscc/ocelot_tc.c         | 151 +++++++++
 drivers/net/ethernet/mscc/ocelot_tc.h         |  19 ++
 include/net/tc_act/tc_police.h                |  41 +++
 net/sched/act_police.c                        |  27 +-
 10 files changed, 532 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_police.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_police.h
 create mode 100644 drivers/net/ethernet/mscc/ocelot_tc.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_tc.h
 create mode 100644 include/net/tc_act/tc_police.h

-- 
2.17.1

