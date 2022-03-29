Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32214EAA79
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 11:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbiC2J0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 05:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiC2J0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 05:26:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAFE69280
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 02:24:58 -0700 (PDT)
Received: from kwepemi100017.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KSPHp2cFyzfYxK;
        Tue, 29 Mar 2022 17:23:18 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100017.china.huawei.com (7.221.188.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 29 Mar 2022 17:24:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 29 Mar 2022 17:24:55 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: [RFCv3 PATCH net-next 0/2] net-next: ethool: add support to get/set tx push by ethtool -G/g
Date:   Tue, 29 Mar 2022 17:19:11 +0800
Message-ID: <20220329091913.17869-1-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches add tx push in ring parms and adapt the set and get APIs 
of ring params

The former discussion please see [1].
[1]:https://lore.kernel.org/netdev/20220315032108.57228-1-wangjie125@huawei.com/
[2]:https://lore.kernel.org/netdev/20220326085102.14111-1-wangjie125@huawei.com/

ChangeLog:

V2->V3
1.Add tx push documentation in Documentation/networking/ethtool-netlink.rst
2.Use u8 to store tx push in struct kernel_ethtool_ringparam
3.Add ETHTOOL_RING_USE_TX_PUSH to reject setting for unsupported driver
4.Use NLA_POLICY_MAX(NLA_U8, 1) to limit the tx push value

V1->V2
extend tx push param in ringparam, suggested by Jakub Kicinski.

Jie Wang (2):
  net-next: ethtool: extend ringparam set/get APIs for tx_push
  net-next: hn3: add tx push support in hns3 ring param process

 Documentation/networking/ethtool-netlink.rst  |  2 ++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 ++++++++++++++++++-
 include/linux/ethtool.h                       |  3 ++
 include/uapi/linux/ethtool_netlink.h          |  1 +
 net/ethtool/netlink.h                         |  2 +-
 net/ethtool/rings.c                           | 18 ++++++++--
 6 files changed, 55 insertions(+), 4 deletions(-)

-- 
2.33.0

