Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F41B6B48
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgDXCY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2883 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725982AbgDXCY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 94F5A3606B598A880B2C;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/8] net: hns3: refactor for MAC table
Date:   Fri, 24 Apr 2020 10:23:05 +0800
Message-ID: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactors the MAC table management, configure
the MAC address asynchronously, instead of synchronously.
Base on this change, it also refines the handle of promisc
mode and filter table entries restoring after reset.

Jian Shen (8):
  net: hns3: refine for unicast MAC VLAN space management
  net: hns3: remove unnecessary parameter 'is_alloc' in
    hclge_set_umv_space()
  net: hns3: replace num_req_vfs with num_alloc_vport in
    hclge_reset_umv_space()
  net: hns3: refactor the MAC address configure
  net: hns3: add support for dumping UC and MC MAC list
  net: hns3: refactor the promisc mode setting
  net: hns3: use mutex vport_lock instead of mutex umv_lock
  net: hns3: optimize the filter table entries handling when resetting

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   5 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 152 +---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  10 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  51 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 867 ++++++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  33 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  70 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 368 ++++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  26 +
 12 files changed, 1166 insertions(+), 428 deletions(-)

-- 
2.7.4

