Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80958776E1
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 07:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfG0FsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 01:48:16 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41274 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbfG0FsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 01:48:16 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C3D0A54AAEFEF7364EF7;
        Sat, 27 Jul 2019 13:48:13 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 27 Jul 2019 13:48:07 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V3 net-next 00/10] net: hns3: some code optimizations & bugfixes & features
Date:   Sat, 27 Jul 2019 13:46:02 +0800
Message-ID: <1564206372-42467-1-git-send-email-tanhuazhong@huawei.com>
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

[patch 1/10] checks reset status before setting channel.

[patch 2/10] adds a NULL pointer checking.

[patch 3/10] removes reset level upgrading when current reset fails.

[patch 4/10] fixes a GFP flags errors when holding spin_lock.

[patch 5/10] modifies firmware version format.

[patch 6/10] adds some print information which is off by default.

[patch 7/10 - 8/10] adds two code optimizations about interrupt handler
and work task.

[patch 9/10] adds support for using order 1 pages with a 4K buffer.

[patch 10/10] modifies messages prints with dev_info() instead of
pr_info().

Change log:
V2->V3: fixes comments from Saeed Mahameed and Joe Perches.
V1->V2: fixes comments from Saeed Mahameed and
	removes previous [patch 4/11] and [patch 11/11]
	which needs further discussion, and adds a new
	patch [11/11] suggested by Saeed Mahameed.


Guangbin Huang (1):
  net: hns3: add a check for get_reset_level

Huazhong Tan (2):
  net: hns3: remove upgrade reset level when reset fail
  net: hns3: use dev_info() instead of pr_info()

Jian Shen (1):
  net: hns3: add reset checking before set channels

Yonglong Liu (1):
  net: hns3: add debug messages to identify eth down cause

Yufeng Mo (2):
  net: hns3: change GFP flag during lock period
  net: hns3: modify firmware version display format

Yunsheng Lin (3):
  net: hns3: make hclge_service use delayed workqueue
  net: hns3: add interrupt affinity support for misc interrupt
  net: hns3: Add support for using order 1 pages with a 4K buffer

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   9 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  33 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  15 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  34 +++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  10 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  11 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 135 ++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  10 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 10 files changed, 195 insertions(+), 72 deletions(-)

-- 
2.7.4

