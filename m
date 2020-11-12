Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6608D2AFF31
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKLFcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7490 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgKLDfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 22:35:15 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CWnHN4H1szhjjM;
        Thu, 12 Nov 2020 11:33:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Nov 2020 11:33:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V3 net-next 00/10] net: hns3: updates for -next
Date:   Thu, 12 Nov 2020 11:33:08 +0800
Message-ID: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
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

change log:
V3 - fix a typo error in #1 reported by Jakub Kicinski.
     rewrite #9 commit log.
     remove #11 from this series.
V2 - reorder #2 & #3 to fix compiler error.
     fix some checkpatch warnings in #10 & #11.

previous version:
V2: https://patchwork.ozlabs.org/project/netdev/cover/1604892159-19990-1-git-send-email-tanhuazhong@huawei.com/
V1: https://patchwork.ozlabs.org/project/netdev/cover/1604730681-32559-1-git-send-email-tanhuazhong@huawei.com/

Huazhong Tan (10):
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

 drivers/net/ethernet/hisilicon/Kconfig             |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  12 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 258 ++++++++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  31 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 185 ++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   8 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   8 +
 10 files changed, 481 insertions(+), 39 deletions(-)

-- 
2.7.4

