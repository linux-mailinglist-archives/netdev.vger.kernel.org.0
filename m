Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A31AD8935
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfJPHUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726977AbfJPHUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:05 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 718CEDB1DC527F38EA0F;
        Wed, 16 Oct 2019 15:20:03 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:19:57 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: add some bugfixes and optimizations
Date:   Wed, 16 Oct 2019 15:16:59 +0800
Message-ID: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes some bugfixes and code optimizations
for the HNS3 ethernet controller driver.

[patch 01/12] removes unused and unnecessary structures.

[patch 02/12] fixes a TX queue not restarted problem.

[patch 03/12] fixes a use-after-free issue.

[patch 04/12] fixes a mis-counting IRQ number issue.

[patch 05/12] fixes VF VLAN table entries inconsistent issue.

[patch 06/12] uses a ETH_ALEN u8 array to replace two mac_addr_*
field in struct hclge_mac_mgr_tbl_entry_cmd.

[patch 07/12] optimizes the barrier used in the IO path.

[patch 08/12] introduces macro ring_to_netdev() to get netdevive
from struct hns3_enet_ring variable.

[patch 09/12] adds a minor cleanup for hns3_handle_rx_bd().

[patch 10/12] fixes a VF ID issue for setting VF VLAN.

[patch 11/12] removes linear data allocating for fraglist SKB.

[patch 12/12] clears hardware error when resetting.

Guojia Liao (1):
  net: hns3: optimized MAC address in management table.

Jian Shen (3):
  net: hns3: fix VF VLAN table entries inconsistent issue
  net: hns3: fix VF id issue for setting VF VLAN
  net: hns3: log and clear hardware error after reset complete

Yonglong Liu (1):
  net: hns3: fix mis-counting IRQ vector numbers issue

Yunsheng Lin (7):
  net: hns3: remove struct hns3_nic_ring_data in hns3_enet module
  net: hns3: fix TX queue not restarted problem
  net: hns3: fix a use after freed problem in hns3_nic_maybe_stop_tx()
  net: hns3: minor optimization for barrier in IO path
  net: hns3: introduce ring_to_netdev() in enet module
  net: hns3: minor cleanup for hns3_handle_rx_bd()
  net: hns3: do not allocate linear data for fraglist skb

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  24 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 255 +++++++++------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  20 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  33 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  49 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  11 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  32 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 13 files changed, 212 insertions(+), 222 deletions(-)

-- 
2.7.4

