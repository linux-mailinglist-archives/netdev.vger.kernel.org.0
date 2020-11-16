Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4A62B3E79
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgKPIUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:20:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7245 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgKPIUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:20:50 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CZMT910cZzkYJF;
        Mon, 16 Nov 2020 16:20:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Nov 2020 16:20:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V4 net-next 0/4] net: hns3: updates for -next
Date:   Mon, 16 Nov 2020 16:20:50 +0800
Message-ID: <1605514854-11205-1-git-send-email-tanhuazhong@huawei.com>
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

change log:
V4 - remove #5~#10 from this series, which needs more discussion.
V3 - fix a typo error in #1 reported by Jakub Kicinski.
     rewrite #9 commit log.
     remove #11 from this series.
V2 - reorder #2 & #3 to fix compiler error.
     fix some checkpatch warnings in #10 & #11.

previous version:
V3: https://patchwork.ozlabs.org/project/netdev/cover/1605151998-12633-1-git-send-email-tanhuazhong@huawei.com/
V2: https://patchwork.ozlabs.org/project/netdev/cover/1604892159-19990-1-git-send-email-tanhuazhong@huawei.com/
V1: https://patchwork.ozlabs.org/project/netdev/cover/1604730681-32559-1-git-send-email-tanhuazhong@huawei.com/


Huazhong Tan (4):
  net: hns3: add support for configuring interrupt quantity limiting
  net: hns3: add support for querying maximum value of GL
  net: hns3: add support for 1us unit GL configuration
  net: hns3: rename gl_adapt_enable in struct hns3_enet_coalesce

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 99 ++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 17 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 71 +++++++++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  8 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  7 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  8 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  7 ++
 9 files changed, 182 insertions(+), 37 deletions(-)

-- 
2.7.4

