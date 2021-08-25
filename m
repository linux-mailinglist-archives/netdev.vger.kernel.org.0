Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801463F6FC3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhHYGpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:45:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8768 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239085AbhHYGpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:45:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gvc0F3zBgzYsVx;
        Wed, 25 Aug 2021 14:44:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/5] ethtool: add support to set/get tx spare buf size and rx buf len
Date:   Wed, 25 Aug 2021 14:40:50 +0800
Message-ID: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support to set/get tx spare buf size and rx buf len via
ethtool and hns3 driver implements them.

Tx spare buf size is used for tx copybreak feature which for small size
packet or frag. Use ethtool --get-tunable command to get it, and ethtool
--set-tunable command to set it, examples are as follow:

1. set tx spare buf size to 102400:
$ ethtool --set-tunable eth1 tx-buf-size 102400

2. get tx spare buf size:
$ ethtool --get-tunable eth1 tx-buf-size
tx-buf-size: 102400

Rx buf len is buffer length of each rx BD. Use ethtool -g command to get
it, and ethtool -G command to set it, examples are as follow:

1. set rx buf len to 4096
$ ethtool -G eth1 rx-buf-len 4096

2. get rx buf len
$ ethtool -g eth1
...
RX Buf Len:     4096


Hao Chen (5):
  ethtool: add support to set/get tx spare buf size
  net: hns3: add support to set/get tx spare buf via ethtool for hns3
    driver
  ethtool: add support to set/get rx buf len
  net: hns3: add support to set/get rx buf len via ethtool for hns3
    driver
  net: hns3: remove the way to set tx spare buf via module parameter

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 11 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 98 ++++++++++++++++++++--
 include/uapi/linux/ethtool.h                       |  3 +
 include/uapi/linux/ethtool_netlink.h               |  1 +
 net/ethtool/ioctl.c                                |  1 +
 net/ethtool/netlink.h                              |  2 +-
 net/ethtool/rings.c                                | 11 ++-
 8 files changed, 112 insertions(+), 17 deletions(-)

-- 
2.8.1

