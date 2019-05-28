Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3B32C288
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfE1JEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:04:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727179AbfE1JEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:35 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9D46887CCD71EEB7D550;
        Tue, 28 May 2019 17:04:31 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] code optimizations & bugfixes for HNS3 driver
Date:   Tue, 28 May 2019 17:02:50 +0800
Message-ID: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes code optimizations and bugfixes for the HNS3
ethernet controller driver.

[patch 1/12] fixes a compile warning reported by kbuild test robot.

[patch 2/12] fixes HNS3_RXD_GRO_SIZE_M macro definition error.

[patch 3/12] adds a debugfs command to dump firmware information.

[patch 4/12 - 10/12] adds some code optimizaions and cleanups for
reset and driver unloading.

[patch 11/12 - 12/12] adds two bugfixes.

Huazhong Tan (9):
  net: hns3: use HCLGE_STATE_NIC_REGISTERED to indicate PF NIC client
    has registered
  net: hns3: use HCLGE_STATE_ROCE_REGISTERED to indicate PF ROCE client
    has registered
  net: hns3: use HCLGEVF_STATE_NIC_REGISTERED to indicate VF NIC client
    has registered
  net: hns3: modify hclge_init_client_instance()
  net: hns3: modify hclgevf_init_client_instance()
  net: hns3: add handshake with hardware while doing reset
  net: hns3: stop schedule reset service while unloading driver
  net: hns3: adjust hns3_uninit_phy()'s location in the
    hns3_client_uninit()
  net: hns3: fix a memory leak issue for
    hclge_map_unmap_ring_to_vf_vector

Jian Shen (1):
  net: hns3: fix compile warning without CONFIG_RFS_ACCEL

Yunsheng Lin (1):
  net: hns3: fix for HNS3_RXD_GRO_SIZE_M macro

Zhongzhu Liu (1):
  net: hns3: add support for dump firmware statistics by debugfs

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   8 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  57 +++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 110 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   2 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  95 ++++++++++++------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   2 +
 12 files changed, 213 insertions(+), 80 deletions(-)

-- 
2.7.4

