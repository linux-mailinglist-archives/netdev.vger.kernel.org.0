Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44CF4C9F9
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbfFTIyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbfFTIyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:37 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5F8C5D6DFD9356DF54EB;
        Thu, 20 Jun 2019 16:54:28 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/11] net: hns3: some code optimizations & bugfixes
Date:   Thu, 20 Jun 2019 16:52:34 +0800
Message-ID: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes code optimizations and bugfixes for
the HNS3 ethernet controller driver.

[patch 1/11] fixes a selftest issue when doing autoneg.

[patch 2/11 - 3-11] adds two code optimizations about VLAN issue.

[patch 4/11] restores the MAC autoneg state after reset.

[patch 5/11 - 8/11] adds some code optimizations and bugfixes about
HW errors handling.

[patch 9/11 - 11/11] fixes some issues related to driver loading and
unloading.

Huazhong Tan (2):
  net: hns3: fix race conditions between reset and module loading &
    unloading
  net: hns3: fixes wrong place enabling ROCE HW error when loading

Jian Shen (4):
  net: hns3: fix selftest fail issue for fibre port with autoneg on
  net: hns3: remove VF VLAN filter entry inexistent warning print
  net: hns3: sync VLAN filter entries when kill VLAN ID failed
  net: hns3: restore the MAC autoneg state after reset

Weihang Li (5):
  net: hns3: code optimizaition of hclge_handle_hw_ras_error()
  net: hns3: modify handling of out of memory in hclge_err.c
  net: hns3: remove override_pci_need_reset
  net: hns3: add check to number of buffer descriptors
  net: hns3: add exception handling when enable NIC HW error interrupts

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  10 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 117 +++++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   5 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 166 +++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  50 ++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   3 +
 9 files changed, 279 insertions(+), 80 deletions(-)

-- 
2.7.4

