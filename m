Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7B2312033
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 22:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBFVvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 16:51:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23345 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBFVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 16:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612648262; x=1644184262;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yLgapeK5FwV5IDNMOCWuPlVIbCFeQL0vs9X/eGhKGDw=;
  b=z269lwac423+Uyj44KgCP/I9CqTow3ZXg4cOa5a4afBhwKOqF1M8OD1Z
   HPbpeoRi4dRz33ovMemhPK6qKoTxu3HiIwCi8WhSaRpe3uNbHTNKFrnaj
   wFh4n4SL/JV8qr3ov3MPQPcZ1neUpyYPQHERQkVKPlJ8fahFitAOqWKnB
   Lr697zRxbvfrXu1Eu2tv58f+2DbRx/sxTtyrAWIZze6mggEf7NZ4HnAV2
   kw6XyR/B+KGSMYUPBOYL/AOkVJqedzC9rwdjt8bFRkLK0VuBZgsey3JEn
   jcXScfylUlwOwloRsJ010O14p+cAWyGkkqAbZDLurM3RKMzttgREcDNPX
   g==;
IronPort-SDR: YmJ/oDt3+SBNYBAY6gWeJNWLicpAhR7vZUZflDiYzRewKDMrtz2XW+aLleG+9xkL9276Sg8g6e
 asul7v0x3QbSUdF8q2R1P33Qgn0Un0r+2NY40MI2XnM+uXjtNYyQR95WVAPGoV+HPWJtAeSR0G
 g9W/9aTncmRKBqp1LjPLCfUsEcRvhC5VrS66CX2aSbEeE6Vi3MhM4IuC1CK6hkk6KqzSSVUjFJ
 tgfSQ9QTi6fYFRzwL9sUmSJkmAIQAAanGBvqzGbMWfTZbPzj0VDuzZevfzJPA64IlVzGwYRuKX
 37w=
X-IronPort-AV: E=Sophos;i="5.81,158,1610434800"; 
   d="scan'208";a="102871012"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2021 14:49:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 6 Feb 2021 14:49:43 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 6 Feb 2021 14:49:41 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 0/2] bridge: mrp: Fix br_mrp_port_switchdev_set_state
Date:   Sat, 6 Feb 2021 22:47:32 +0100
Message-ID: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion here[1], there was a problem with the function
br_mrp_port_switchdev_set_state. The problem was that it was called
both with BR_STATE* and BR_MRP_PORT_STATE* types. This patch series
fixes this issue and removes SWITCHDEV_ATTR_ID_MRP_PORT_STAT because
is not used anymore.

[1] https://www.spinics.net/lists/netdev/msg714816.html

Horatiu Vultur (2):
  bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state
  switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT

 include/net/switchdev.h       | 2 --
 net/bridge/br_mrp.c           | 9 ++++++---
 net/bridge/br_mrp_switchdev.c | 7 +++----
 net/bridge/br_private_mrp.h   | 3 +--
 4 files changed, 10 insertions(+), 11 deletions(-)

-- 
2.27.0

