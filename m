Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7058E279F28
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgI0HPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14302 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbgI0HPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:38 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 41D1C35968E9FAA0CA37;
        Sun, 27 Sep 2020 15:15:36 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/10] net: hns3: updates for -next
Date:   Sun, 27 Sep 2020 15:12:38 +0800
Message-ID: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To facilitate code maintenance and compatibility, #1 and #2 add
device version to replace pci revision, #3 to #9 adds support for
querying device capabilities and specifications, then the driver
can use these query results to implement corresponding features
(some features will be implemented later).

And #10 is a minor cleanup since too many parameters for
hclge_shaper_para_calc().

Guangbin Huang (9):
  net: hns3: add device version to replace pci revision
  net: hns3: delete redundant PCI revision judgement
  net: hns3: add support to query device capability
  net: hns3: use capability flag to indicate FEC
  net: hns3: use capabilities queried from firmware
  net: hns3: add debugfs to dump device capabilities
  net: hns3: add support to query device specifications
  net: hns3: replace the macro of max tm rate with the queried
    specification
  net: hns3: add a check for device specifications queried from firmware

Huazhong Tan (1):
  net: hns3: add a structure for IR shaper's parameter in
    hclge_shaper_para_calc()

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  81 +++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  24 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  20 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  30 ++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  65 +++++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  36 ++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  14 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 117 +++++++++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 101 ++++++++++--------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   8 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  62 ++++++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  34 +++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  94 +++++++++++++++--
 13 files changed, 548 insertions(+), 138 deletions(-)

-- 
2.7.4

