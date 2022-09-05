Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CE45ACD8C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbiIEITh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbiIEISU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:18:20 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1052131DDA;
        Mon,  5 Sep 2022 01:18:17 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MLhDl2Hq1zrS8S;
        Mon,  5 Sep 2022 16:16:23 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:12 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:12 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 0/5] net: hns3: updates for -next
Date:   Mon, 5 Sep 2022 16:15:34 +0800
Message-ID: <20220905081539.62131-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

Patches #1~#3 support configuring dscp map to tc.

Patch 4# supports querying FEC statistics by command "ethtool -I --show-fec eth0".

Patch 5# supports querying and setting Serdes lane number.

Guangbin Huang (3):
  net: hns3: add support config dscp map to tc
  net: hns3: support ndo_select_queue()
  net: hns3: debugfs add dump dscp map info

Hao Chen (1):
  net: hns3: add support to query and set lane number by ethtool

Hao Lan (1):
  net: hns3: add querying fec statistics

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  26 ++-
 .../hns3/hns3_common/hclge_comm_cmd.c         |   2 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   3 +
 .../net/ethernet/hisilicon/hns3/hns3_dcbnl.c  |  28 +++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  13 ++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  46 +++++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  33 +++-
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  21 +-
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 107 ++++++++++
 .../hisilicon/hns3/hns3pf/hclge_dcb.h         |   3 +
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  60 +++++-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 183 +++++++++++++++++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  29 ++-
 .../hisilicon/hns3/hns3pf/hclge_mdio.c        |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  50 ++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |   5 +
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |   2 +-
 17 files changed, 588 insertions(+), 25 deletions(-)

-- 
2.33.0

