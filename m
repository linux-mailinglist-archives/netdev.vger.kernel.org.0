Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBB2104DF
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 09:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgGAHWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 03:22:53 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:53909 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgGAHWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 03:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593588172; x=1625124172;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ASReo1CJm8170qaaG0UUzUeLV1c7HctXtdLcR5LMm/I=;
  b=lhRMXL/49QwyrzTl+tCF2VkPIh4cv9f2gtZLugO9+ZNCBbTbjGFkeSqZ
   0mhDpV3/t7qdPwtYrr+rWdvOdqcBXFm0QrIs23Ky5Iy6pQWfMJVDce0UK
   SQNj4Zbf72POdMX833JWXdaST0LMPH7vfuhnDBy7ung0id0szuqMUTuID
   7cJ9Q1r1kwQtQfkHWkm99Fehe5g0hWqy1XWes9xEo0zxbO1KcutUDs9wL
   8g0F8sDNFFLiorK8vTXfWjMkXaeI1gJlmg4dQjJeXnLW4siWYDug3A1Tm
   QTZdNCmxy6y4UoW529tbwQAfmRvFM6S1ge/FFpSbvXJw28Ai84Zk3E7Ye
   A==;
IronPort-SDR: dx6YWF45EaJUUid5tzRABJTT/zLGOxeI4WC1j94JuHpBZ+qFmmiXbqG0qY4gMaPetuuNqFMHLr
 L1VbaOZ7z9xXQ08pr2nmpE3B44zCHGHhH0C+iIoxArvw9WRZtpDrrkeb1b4E45NCE6NvOwRQS+
 ScjG909CpUxg7faRiAYSyLBEUMmVy1TscPtmAnox8Lmt5tLn8I/7s76dkz8dVSu/07dGtgLFt9
 BBOoLl0SMwIE5AGMWUh+QMPzvKDxmjUgHWhnj2xwacQImJPiQdSgtsxr51JiUxqSPWgvtPCAJV
 Gfo=
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="85776837"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 00:22:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 00:22:51 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 1 Jul 2020 00:22:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/3] bridge: mrp: Add support for getting the status
Date:   Wed, 1 Jul 2020 09:22:36 +0200
Message-ID: <20200701072239.520807-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the MRP netlink interface to allow the userspace
daemon to get the status of the MRP instances in the kernel.

v2:
  - fix sparse warnings

Horatiu Vultur (3):
  bridge: uapi: mrp: Extend MRP attributes to get the status
  bridge: mrp: Add br_mrp_fill_info
  bridge: Extend br_fill_ifinfo to return MPR status

 include/uapi/linux/if_bridge.h | 17 +++++++++
 include/uapi/linux/rtnetlink.h |  1 +
 net/bridge/br_mrp_netlink.c    | 64 ++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        | 29 ++++++++++++++-
 net/bridge/br_private.h        |  7 ++++
 5 files changed, 117 insertions(+), 1 deletion(-)

-- 
2.27.0

