Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF7C43E7C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389780AbfFMPuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:50:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18148 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731697AbfFMJOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2BA4637CEE9BEDF3DC44;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: some code optimizations & cleanups & bugfixes
Date:   Thu, 13 Jun 2019 17:12:20 +0800
Message-ID: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes code optimizations, cleanups and bugfixes for
the HNS3 ethernet controller driver.

[patch 1/12 - 6/12] adds some code optimizations and bugfixes about RAS
and MSI-X HW error.

[patch 7/12] fixes a loading issue.

[patch 8/12 - 11/12] adds some bugfixes.

[patch 12/12] adds some cleanups, which does not change the logic of code.

Peng Li (1):
  net: hns3: clear restting state when initializing HW device

Shiju Jose (4):
  net: hns3: delay setting of reset level for hw errors until slot_reset
    is called
  net: hns3: fix avoid unnecessary resetting for the H/W errors which do
    not require reset
  net: hns3: process H/W errors occurred before HNS dev initialization
  net: hns3: add recovery for the H/W errors occurred before the HNS dev
    initialization

Weihang Li (3):
  net: hns3: some changes of MSI-X bits in PPU(RCB)
  net: hns3: extract handling of mpf/pf msi-x errors into functions
  net: hns3: some variable modification

Yonglong Liu (1):
  net: hns3: free irq when exit from abnormal branch

Yunsheng Lin (3):
  net: hns3: fix for dereferencing before null checking
  net: hns3: fix for skb leak when doing selftest
  net: hns3: delay ring buffer clearing during reset

 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  47 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  16 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 523 ++++++++++++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 115 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  15 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  20 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  11 +-
 15 files changed, 476 insertions(+), 308 deletions(-)

-- 
2.7.4

