Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C1234379E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 04:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCVDwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 23:52:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14839 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVDvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 23:51:48 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F3gVh2KH4z92CR;
        Mon, 22 Mar 2021 11:49:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 11:51:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/7] net: hns3: refactor and new features for flow director
Date:   Mon, 22 Mar 2021 11:51:55 +0800
Message-ID: <1616385122-48198-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactor some functions and add some new features for
flow director.

patch 1~3: refactor large functions
patch 4, 7: add traffic class and user-def field support for ethtool
patch 5: refactor flow director configuration
patch 6: clean up for hns3_del_all_fd_entries()

change log:
V1->V2: modifies patch 5 as Jakub suggested, keep configuring
	ethtool/tc flower rules synchronously while aRFS
	asynchronously.
	changes the usecnt of user-def rule checking in patch 7.
	removes previous patches 8 and 9 from this series, since
	there are issues that need further discussion.

previous version:
V1: https://patchwork.kernel.org/project/netdevbpf/cover/1615811031-55209-1-git-send-email-tanhuazhong@huawei.com/

Jian Shen (7):
  net: hns3: refactor out hclge_add_fd_entry()
  net: hns3: refactor out hclge_fd_get_tuple()
  net: hns3: refactor for function hclge_fd_convert_tuple
  net: hns3: add support for traffic class tuple support for flow
    director by ethtool
  net: hns3: refactor flow director configuration
  net: hns3: refine for hns3_del_all_fd_entries()
  net: hns3: add support for user-def data of flow director

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    2 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   10 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   14 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 1316 +++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   58 +
 5 files changed, 936 insertions(+), 464 deletions(-)

-- 
2.7.4

