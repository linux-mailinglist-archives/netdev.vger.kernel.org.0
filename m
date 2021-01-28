Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA3130753A
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhA1Lwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:52:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11527 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhA1Lwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:52:50 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DRJhG2mMpzjFJY;
        Thu, 28 Jan 2021 19:50:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 19:52:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/2] net: hns3: updates for -next
Date:   Thu, 28 Jan 2021 19:51:34 +0800
Message-ID: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds dump tm info of nodes, priority and qset in debugfs.
Three debugfs files tm_nodes, tm_priority and tm_qset are created in
new tm directory, and use cat command to dump their info, for examples:

$ cat tm_nodes
       BASE_ID  MAX_NUM
PG         0         8
PRI        0         8
QSET       0         8
QUEUE      0      1024

$ cat tm_priority
ID    MODE  DWRR  C_IR_B  C_IR_U  C_IR_S  C_BS_B  C_BS_S  C_FLAG  C_RATE(Mbps)  P_IR_B  P_IR_U  P_IR_S  P_BS_B  P_BS_S  P_FLAG  P_RATE(Mbps)
0000  dwrr  100     0       0       0       5      20       0          0        150       7       0       5      20       0          0
0001    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0
0002    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0
0003    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0
0004    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0
0005    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0
0006    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0
0007    sp    0     0       0       0       0       0       0          0          0       0       0       0       0       0          0

$ cat tm_qset
ID    MAP_PRI  LINK_VLD  MODE  DWRR
0000     0        1      dwrr  100
0001     0        0        sp    0
0002     0        0        sp    0
0003     0        0        sp    0
0004     0        0        sp    0
0005     0        0        sp    0
0006     0        0        sp    0

change log:
V2: add readonly files for dump all nodes, priority and qset info
    suggested by Jakub Kicinski.

previous version:
V1: https://patchwork.kernel.org/project/netdevbpf/patch/1610694569-43099-1-git-send-email-tanhuazhong@huawei.com/

Guangbin Huang (2):
  net: hns3: add interfaces to query information of tm priority/qset
  net: hns3: add debugfs support for tm nodes, priority and qset info

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  55 +++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 153 +++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 186 +++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  48 +++++-
 8 files changed, 452 insertions(+), 2 deletions(-)

-- 
2.7.4

