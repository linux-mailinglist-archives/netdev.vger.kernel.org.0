Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FB636E7D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfFFIWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:22:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41834 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726926AbfFFIWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:22:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 902BAE2A83E486A484FC;
        Thu,  6 Jun 2019 16:22:43 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 6 Jun 2019 16:22:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] net: hns3: some code optimizations & cleanups & bugfixes
Date:   Thu, 6 Jun 2019 16:20:55 +0800
Message-ID: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
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

[patch 1/12] logs more detail error info for ROCE RAS errors.

[patch 2/12] fixes a wrong size issue for mailbox responding.

[patch 3/12] makes HW GRO handing compliant with SW one.

[patch 4/12] refactors hns3_get_new_int_gl.

[patch 5/12] adds handling for VF's over_8bd_nfe_err.

[patch 6/12 - 12/12] adds some code optimizations and cleanups, to
make the code more readable and compliant with some static code
analysis tools, these modifications do not change the logic of
the code.

Jian Shen (1):
  net: hns3: small changes for magic numbers

Weihang Li (2):
  net: hns3: trigger VF reset if a VF has an over_8bd_nfe_err
  net: hns3: fix some coding style issues

Xiaofei Tan (1):
  net: hns3: log detail error info of ROCEE ECC and AXI errors

Yonglong Liu (1):
  net: hns3: Delete the redundant user nic codes

Yufeng Mo (3):
  net: hns3: use macros instead of magic numbers
  net: hns3: refactor PF/VF RSS hash key configuration
  net: hns3: some modifications to simplify and optimize code

Yunsheng Lin (3):
  net: hns3: make HW GRO handling compliant with SW GRO
  net: hns3: replace numa_node_id with numa_mem_id for buffer reusing
  net: hns3: refactor hns3_get_new_int_gl function

Zhongzhu Liu (1):
  net: hns3: fix wrong size of mailbox responding data

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  21 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   7 -
 drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c   |  12 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 199 ++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  43 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  24 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  19 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 181 +++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 391 +++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  26 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 140 ++++----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  85 ++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   3 +
 16 files changed, 682 insertions(+), 479 deletions(-)

-- 
2.7.4

