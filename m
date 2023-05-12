Return-Path: <netdev+bounces-2108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4D57004A1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CE35280A62
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C198BE71;
	Fri, 12 May 2023 10:03:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91540D507
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:03:38 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA6F11603
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:03:16 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QHkkL0DTWzLncM;
	Fri, 12 May 2023 17:59:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 18:01:56 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lanhao@huawei.com>, <huangguangbin2@huawei.com>,
	<simon.horman@corigine.com>, <shaojijie@huawei.com>, <chenhao418@huawei.com>,
	<shenjian15@huawei.com>, <liuyonglong@huawei.com>, <wangjie125@huawei.com>,
	<yuanjilin@cdjrlc.com>, <cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>,
	<tanhuazhong@huawei.com>
Subject: [PATCH net 0/4] net: hns3: There are some bugfixes for the HNS3 ethernet driver
Date: Fri, 12 May 2023 18:00:10 +0800
Message-ID: <20230512100014.2522-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are some bugfixes for the HNS3 ethernet driver.
Patch#1 fix output information incomplete for dumping tx queue info
 with debugfs.
Patch#2 fix sending pfc frames after reset issue.
Patch#3 fix reset delay time to avoid configuration timeout.
Patch#4 fix reset timeout when enable full VF.

Jie Wang (2):
  net: hns3: fix output information incomplete for dumping tx queue info
    with debugfs
  net: hns3: fix reset delay time to avoid configuration timeout

Jijie Shao (2):
  net: hns3: fix sending pfc frames after reset issue
  net: hns3: fix reset timeout when enable full VF

 .../hns3/hns3_common/hclge_comm_cmd.c         | 25 ++++++++++++++++---
 .../hns3/hns3_common/hclge_comm_cmd.h         |  8 +++++-
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 +-
 .../ethernet/hisilicon/hns3/hns3_debugfs.h    |  1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 15 ++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  4 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  5 ++++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  5 +++-
 8 files changed, 50 insertions(+), 15 deletions(-)

-- 
2.30.0


