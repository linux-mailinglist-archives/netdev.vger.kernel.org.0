Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FA52AAFE8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgKIDW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:22:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7614 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgKIDWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 22:22:24 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CTxBD0bRxzLvv2;
        Mon,  9 Nov 2020 11:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 11:22:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 00/11] net: hns3: updates for -next
Date:   Mon, 9 Nov 2020 11:22:28 +0800
Message-ID: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
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
#2 queries the maximum value of GL from the firmware instead of
   a fixed value in code.
#3 adds support for 1us unit GL(gap limiting, interrupt coalesce
   based on the gap time).
#4 renames gl_adapt_enable in struct hns3_enet_coalesce to fit
   its new usage.
#5 & #6 adds support for the dynamic interrupt moderation,
   and adds a control private flag in ethtool.
#7 adds wrapper function for state initialization.
#8 adds a check for the read-only private flag.
#9 & #10 adds support for EQ/CQ configuration, and adds a control
   private flag in ethtool.
#11 adds debugfs support for interrupt coalesce.

change log:
V2 - reorder #2 & #3 to fix compiler error.
     fix some checkpatch warnings in #10 & #11.

previous version:
V1: https://patchwork.ozlabs.org/project/netdev/cover/1604730681-32559-1-git-send-email-tanhuazhong@huawei.com/

Huazhong Tan (11):
  net: hns3: add support for configuring interrupt quantity limiting
  net: hns3: add support for querying maximum value of GL
  net: hns3: add support for 1us unit GL configuration
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
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 127 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 258 ++++++++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  31 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 185 ++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   8 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   8 +
 10 files changed, 607 insertions(+), 39 deletions(-)

-- 
2.7.4

