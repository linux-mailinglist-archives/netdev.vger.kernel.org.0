Return-Path: <netdev+bounces-10101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C79272C3FC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E684281136
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D281991F;
	Mon, 12 Jun 2023 12:26:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FB919910
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:26:32 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF7418C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:26:30 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QfrWW1Lt9zTkxp;
	Mon, 12 Jun 2023 20:25:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 20:26:27 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <lanhao@huawei.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<simon.horman@corigine.com>, <wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>,
	<cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>
Subject: [PATCH net-next v2 0/4] net: hns3: There are some cleanup for the HNS3 ethernet driver
Date: Mon, 12 Jun 2023 20:23:54 +0800
Message-ID: <20230612122358.10586-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are some cleanup for the HNS3 ethernet driver.

Hao Chen (2):
  net: hns3: fix hns3 driver header file not self-contained issue
  net: hns3: fix strncpy() not using dest-buf length as length issue

Jian Shen (1):
  net: hns3: refine the tcam key convert handle

Peiyang Wang (1):
  net: hns3: clear hns unused parameter alarm

 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  4 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 +-
 .../hns3/hns3_common/hclge_comm_rss.c         |  3 +-
 .../hns3/hns3_common/hclge_comm_rss.h         |  3 +-
 .../hns3/hns3_common/hclge_comm_tqp_stats.h   |  2 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 36 ++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  3 ++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  7 ++-
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++--
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 47 ++++++++-----------
 .../hisilicon/hns3/hns3pf/hclge_main.h        | 11 ++---
 .../hisilicon/hns3/hns3pf/hclge_ptp.h         |  5 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 14 ++----
 14 files changed, 96 insertions(+), 73 deletions(-)

-- 
2.30.0


