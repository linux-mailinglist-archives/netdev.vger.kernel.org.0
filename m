Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BE6627759
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiKNIUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiKNIUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:20:46 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AC5B860
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:20:44 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N9j141yPzz15McK;
        Mon, 14 Nov 2022 16:20:24 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:20:43 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:20:42 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <lanhao@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        <liuyonglong@huawei.com>, <chenhao418@huawei.com>,
        <wangjie125@huawei.com>, <huangguangbin2@huawei.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <xiaojiantao1@h-partners.com>, <dvyukov@google.com>
Subject: [PATCH V2 net 0/3] net: hns3: This series bugfix for the HNS3 ethernet driver.
Date:   Mon, 14 Nov 2022 16:20:45 +0800
Message-ID: <20221114082048.49450-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some bugfix for the HNS3 ethernet driver.
Patch 1# fix incorrect hw rss hash type of rx packet.
Fixes: 796640778c26 ("net: hns3: support RXD advanced layout")
Fixes: 232fc64b6e62 ("net: hns3: Add HW RSS hash information to RX skb")
Fixes: ea4858670717 ("net: hns3: handle the BD info on the last BD of the packet")

Patch 2# fix return value check bug of rx copybreak.
Fixes: e74a726da2c4 ("net: hns3: refactor hns3_nic_reuse_page()")
Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")

Patch 3# net: hns3: fix setting incorrect phy link ksettings
 for firmware in resetting process
Fixes: f5f2b3e4dcc0 ("net: hns3: add support for imp-controlled PHYs")
Fixes: c5ef83cbb1e9 ("net: hns3: fix for phy_addr error in hclge_mac_mdio_config")
Fixes: 2312e050f42b ("net: hns3: Fix for deadlock problem occurring when unregistering ae_algo")

Guangbin Huang (1):
  net: hns3: fix setting incorrect phy link ksettings for firmware in
    resetting process

Jian Shen (1):
  net: hns3: fix incorrect hw rss hash type of rx packet

Jie Wang (1):
  net: hns3: fix return value check bug of rx copybreak

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 -
 .../hns3/hns3_common/hclge_comm_rss.c         |  20 ---
 .../hns3/hns3_common/hclge_comm_rss.h         |   2 -
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 167 ++++++++++--------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  11 +-
 6 files changed, 103 insertions(+), 99 deletions(-)

-- 
2.30.0

