Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF5872548
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfGXDVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:21:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbfGXDVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:21:01 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9593E3AC6869A30AF5AD;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/11] net: hns3: some code optimizations & bugfixes & features
Date:   Wed, 24 Jul 2019 11:18:36 +0800
Message-ID: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes code optimizations, bugfixes and features for
the HNS3 ethernet controller driver.

[patch 1/11] checks reset status before setting channel.

[patch 2/11] adds a NULL pointer checking.

[patch 3/11] removes reset level upgrading when current reset fails.

[patch 4/11] fixes a bug related to IRQ vector number initialization.

[patch 5/11] fixes a GFP flags errors when holding spin_lock.

[patch 6/11] modifies firmware version format.

[patch 7/11] adds some print information.

[patch 8/11 - 9/11] adds two code optimizations about interrupt handler
and work task.

[patch 10/11] adds support for using order 1 pages with a 4K buffer.

[patch 11/11] adds a detection about the reason of IMP errors.

Guangbin Huang (1):
  net: hns3: add a check for get_reset_level

Huazhong Tan (1):
  net: hns3: remove upgrade reset level when reset fail

Jian Shen (1):
  net: hns3: add reset checking before set channels

Weihang Li (1):
  net: hns3: add support for handling IMP error

Yonglong Liu (2):
  net: hns3: fix mis-counting IRQ vector numbers issue
  net: hns3: adds debug messages to identify eth down cause

Yufeng Mo (2):
  net: hns3: change GFP flag during lock period
  net: hns3: modify firmware version display format

Yunsheng Lin (3):
  net: hns3: add interrupt affinity support for misc interrupt
  net: hns3: make hclge_service use delayed workqueue
  net: hns3: Add support for using order 1 pages with a 4K buffer

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  10 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  39 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  15 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  41 ++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  10 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  14 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  37 ++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 165 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  16 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  11 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  12 +-
 12 files changed, 298 insertions(+), 76 deletions(-)

-- 
2.7.4

