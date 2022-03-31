Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617444ED62D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiCaIvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiCaIvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:51:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1903C13CEA
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:49:22 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KTcPm43yHzgYFm;
        Thu, 31 Mar 2022 16:47:40 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 31 Mar 2022 16:49:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 16:49:19 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: [RFCv4 PATCH net-next 0/3] net-next: ethool: add support to get/set tx push by ethtool -G/g
Date:   Thu, 31 Mar 2022 16:43:39 +0800
Message-ID: <20220331084342.27043-1-wangjie125@huawei.com>
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

These two patches add tx push in ring params and adapt the set and get APIs 
of ring params

The former discussion please see [1].
[1]:https://lore.kernel.org/netdev/20220315032108.57228-1-wangjie125@huawei.com/
[2]:https://lore.kernel.org/netdev/20220326085102.14111-1-wangjie125@huawei.com/
[3]:https://lore.kernel.org/netdev/20220329091913.17869-1-wangjie125@huawei.com/

ChangeLog:

V3->V4
1,Put three request checks before rtnl_lock() in ethnl_set_rings
2,Add tx push feature description in Documentation/networking/ethtool-netlink.rst
3,Use netdev_dbg to track changes in hns3_set_tx_push

V2->V3
1.Add tx push documentation in Documentation/networking/ethtool-netlink.rst
2.Use u8 to store tx push in struct kernel_ethtool_ringparam
3.Add ETHTOOL_RING_USE_TX_PUSH to reject setting for unsupported driver
4.Use NLA_POLICY_MAX(NLA_U8, 1) to limit the tx push value

V1->V2
extend tx push param in ringparam, suggested by Jakub Kicinski.

Jie Wang (3):
  net-next: ethtool: extend ringparam set/get APIs for tx_push
  net-next: ethtool: move checks before rtnl_lock() in ethnl_set_rings
  net-next: hn3: add tx push support in hns3 ring param process

 Documentation/networking/ethtool-netlink.rst  | 10 ++++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 ++++++++++-
 include/linux/ethtool.h                       |  3 +
 include/uapi/linux/ethtool_netlink.h          |  1 +
 net/ethtool/netlink.h                         |  2 +-
 net/ethtool/rings.c                           | 56 ++++++++++++-------
 6 files changed, 83 insertions(+), 22 deletions(-)

-- 
2.33.0

