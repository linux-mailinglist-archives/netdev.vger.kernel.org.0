Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC8C30AE7
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfEaI4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:56:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37042 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfEaI4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 25606FF226291FBFBF71;
        Fri, 31 May 2019 16:56:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] code optimizations & bugfixes for HNS3 driver
Date:   Fri, 31 May 2019 16:54:46 +0800
Message-ID: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
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

[patch 1/12] removes the redundant core reset type

[patch 2/12 - 3/12] fixes two VLAN related issues

[patch 4/12] fixes a TM issue

[patch 5/12 - 12/12] includes some patches related to RAS & MSI-X error

Huazhong Tan (1):
  net: hns3: remove redundant core reset

Jian Shen (2):
  net: hns3: don't configure new VLAN ID into VF VLAN table when it's
    full
  net: hns3: fix VLAN filter restore issue after reset

Shiju Jose (2):
  net: hns3: delay setting of reset level for HW errors until slot_reset
    is called
  net: hns3: fix avoid unnecessary resetting for the H/W errors which do
    not require reset

Weihang Li (6):
  net: hns3: add a check to pointer in error_detected and slot_reset
  net: hns3: set ops to null when unregister ad_dev
  net: hns3: add handling of two bits in MAC tunnel interrupts
  net: hns3: remove setting bit of reset_requests when handling mac
    tunnel interrupts
  net: hns3: add opcode about query and clear RAS & MSI-X to special
    opcode
  net: hns3: delay and separate enabling of NIC and ROCE HW errors

Yunsheng Lin (1):
  net: hns3: set the port shaper according to MAC speed

 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  10 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  55 +---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 351 ++++++++-------------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 137 +++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  12 +-
 12 files changed, 268 insertions(+), 320 deletions(-)

-- 
2.7.4

