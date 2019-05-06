Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059B91439A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfEFCvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:51:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbfEFCuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B43B446E591771F1389F;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/12] cleanup & optimizations & bugfixes for HNS3 driver
Date:   Mon, 6 May 2019 10:48:40 +0800
Message-ID: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains some cleanup related to hns3_enet_ring
struct and tx bd filling process, optimizations related
to rx page reusing, barrier using and tso handling process,
bugfixes related to tunnel type handling and error handling for
desc filling.

Yunsheng Lin (12):
  net: hns3: unify maybe_stop_tx for TSO and non-TSO case
  net: hns3: use napi_schedule_irqoff in hard interrupts handlers
  net: hns3: add counter for times RX pages gets allocated
  net: hns3: add linearizing checking for TSO case
  net: hns3: fix for tunnel type handling in hns3_rx_checksum
  net: hns3: refactor BD filling for l2l3l4 info
  net: hns3: combine len and checksum handling for inner and outer
    header.
  net: hns3: fix error handling for desc filling
  net: hns3: optimize the barrier using when cleaning TX BD
  net: hns3: unify the page reusing for page size 4K and 64K
  net: hns3: some cleanup for struct hns3_enet_ring
  net: hns3: use devm_kcalloc when allocating desc_cb

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 499 ++++++++++-----------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  17 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +
 3 files changed, 230 insertions(+), 288 deletions(-)

-- 
2.7.4

