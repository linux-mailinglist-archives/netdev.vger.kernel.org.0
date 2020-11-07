Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDA2AA2CB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 07:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgKGGbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 01:31:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7418 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgKGGbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 01:31:12 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CSnSz1tvqz73KP;
        Sat,  7 Nov 2020 14:30:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sat, 7 Nov 2020 14:30:56 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/11] net: hns3: updates for -next
Date:   Sat, 7 Nov 2020 14:31:10 +0800
Message-ID: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several updates relating to the interrupt coalesce for
the HNS3 ethernet driver.

#1 adds support for QL(quantity limiting, interrupt coalesce
   based on the frame quantity).
#2 adds support for 1us unit GL(gap limiting, interrupt coalesce
   based on the gap time).
#3 queries the maximum value of GL from the firmware instead of
   a fixed value in code.
#4 renames gl_adapt_enable in struct hns3_enet_coalesce to fit
   its new usage.
#5 & #6 adds support for the dynamic interrupt moderation,
   and adds a control private flag in ethtool.
#7 adds wrapper function for state initialization.
#8 adds a check for the read-only private flag.
#9 & #10 adds support for EQ/CQ configuration, and adds a control
   private flag in ethtool.
#11 adds debugfs support for interrupt coalesce.

Huazhong Tan (11):
  net: hns3: add support for configuring interrupt quantity limiting
  net: hns3: add support for 1us unit GL configuration
  net: hns3: add support for querying maximum value of GL
  net: hns3: rename gl_adapt_enable in struct hns3_enet_coalesce
  net: hns3: add support for dynamic interrupt moderation
  net: hns3: add ethtool priv-flag for DIM
  net: hns3: add hns3_state_init() to do state initialization
  net: hns3: add a check for ethtool priv-flag interface
  net: hns3: add support for EQ/CQ mode configuration
  net: hns3: add ethtool priv-flag for EQ/CQ
  net: hns3: add debugfs support for interrupt coalesce

 drivers/net/ethernet/hisilicon/Kconfig             |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  12 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 125 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 258 ++++++++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  31 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 184 ++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   8 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   8 +
 10 files changed, 604 insertions(+), 39 deletions(-)

-- 
2.7.4

