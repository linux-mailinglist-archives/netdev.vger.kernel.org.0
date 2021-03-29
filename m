Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40EE34C25A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhC2D7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15028 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhC2D6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zJH2l5hzNqyJ;
        Mon, 29 Mar 2021 11:55:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/9] net: hns3: misc updates for -next
Date:   Mon, 29 Mar 2021 11:57:44 +0800
Message-ID: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series include some updates for the HNS3 ethernet driver.

#1 & #2 fix two bugs in commit fc4243b8de8b ("net: hns3: refactor
   flow director configuration").
#3 modifies a potential overflow risk.
#4 remove the rss_size limitation when updating rss size.
#5 optimizes the resetting of tqp.
#6 & #7 add updates for the IO path.
#8 expands the tc config command.
#9 adds a new stats.

Guangbin Huang (1):
  net: hns3: remediate a potential overflow risk of bd_num_list

Guojia Liao (1):
  net: hns3: expand the tc config command

Jian Shen (3):
  net: hns3: fix missing rule state assignment
  net: hns3: fix use-after-free issue for hclge_add_fd_entry_common()
  net: hns3: remove the rss_size limitation by vector num

Yufeng Mo (1):
  net: hns3: optimize the process of queue reset

Yunsheng Lin (3):
  net: hns3: add handling for xmit skb with recursive fraglist
  net: hns3: add tx send size handling for tso skb
  net: hns3: add stats logging when skb padding fails

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 153 +++++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 219 ++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  26 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   9 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  62 ++++--
 11 files changed, 321 insertions(+), 179 deletions(-)

-- 
2.7.4

