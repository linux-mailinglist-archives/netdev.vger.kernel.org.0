Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04D920AD35
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgFZHeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:34:13 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:32566 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFZHeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 03:34:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593156852; x=1624692852;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h3hNjRKGmfssGibJLg47pILaq4IrAogvkfO1FL2evKQ=;
  b=jcObcqJPQVWgWm6xSRiWQoi/Loi8FvQ9w0PGUhFQmw7QLY9rTqIzt1Lb
   eX2jN/YGaXSEAnhpYCak1+7qiF/qzyjUkzQQjiH0ortzC1/akFWgK46Gh
   tCSgOnngN+x3go6z3bBKlTmOMAJO3E9KnyyId1p3+LwItA1owFd365S/a
   sfZwQWte+WsobBHRwkGO46tCrnaOhRLeGUo7W1p5hpnyaHG+UxFZFpZrB
   RfpLHgRy0tZDg7vaX45ayPbmMhCn8qpVayzVZ1pjxpQiKK50wkniTdN65
   y2nk8xZRxgAhgJKnAdczbItYUONaKfsaBTfJXyth4g9N4JmyvWCNzA+dq
   A==;
IronPort-SDR: TDBgDjv8T6BH6sQX/6BrzOD161tQRQKChNa++FRk3xaqZKi+FiGcB09fB2RtuvyG0I/AIcw0A/
 nnXVjt3nGspLR4BK2JzRY7dqMOYW8DRCsD4z/lB0J7s1wOBIR7/BSIqjDGClw0dm0YefAliVAC
 CPA2GD9rvFzFP97AgxqNmcjYNRyDBrySsY0Fn4T00hRNb/28P/jdi/gkUl5DZwNC1KhGxuS0fc
 s7S3Univ4k120WOPEizjCTmMOdyEHWWOnKp2s4g0bc4IPAlYEnS/gLF3/9X4DfpTTC+h7/WMED
 /5w=
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="80986529"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2020 00:34:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 00:34:10 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 26 Jun 2020 00:34:08 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/2] bridge: mrp: Extend MRP netlink interface with IFLA_BRIDGE_MRP_CLEAR
Date:   Fri, 26 Jun 2020 09:33:47 +0200
Message-ID: <20200626073349.3495526-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends MRP netlink interface with IFLA_BRIDGE_MRP_CLEAR.
To allow the userspace to clear all MRP instances when is started. The
second patch in the series fix different sparse warnings.

v3:
  - add the second patch to fix sparse warnings

v2:
  - use list_for_each_entry_safe instead of list_for_each_entry_rcu
    when deleting mrp instances

Horatiu Vultur (2):
  bridge: mrp: Extend MRP netlink interface with IFLA_BRIDGE_MRP_CLEAR
  bridge: mrp: Fix endian conversion and some other warnings

 include/uapi/linux/if_bridge.h |  8 ++++++++
 net/bridge/br_mrp.c            | 17 ++++++++++++++++-
 net/bridge/br_mrp_netlink.c    | 26 ++++++++++++++++++++++++++
 net/bridge/br_private.h        |  2 +-
 net/bridge/br_private_mrp.h    |  3 ++-
 5 files changed, 53 insertions(+), 3 deletions(-)

-- 
2.26.2

