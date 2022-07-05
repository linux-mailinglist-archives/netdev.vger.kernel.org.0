Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD5B56690A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiGELWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiGELWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:22:35 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D685D15734;
        Tue,  5 Jul 2022 04:22:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VIS3q3D_1657020150;
Received: from localhost(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VIS3q3D_1657020150)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 19:22:31 +0800
From:   Qiao Ma <mqaio@linux.alibaba.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, gustavoars@kernel.org, cai.huoqing@linux.dev
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 0/2] net: hinic: fix bugs about dev_get_stats
Date:   Tue,  5 Jul 2022 19:22:21 +0800
Message-Id: <cover.1657019475.git.mqaio@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fixes 2 bugs of hinic driver:
- fix bug that ethtool get wrong stats because of hinic_{txq|rxq}_clean_stats() is called
- avoid kernel hung in hinic_get_stats64() 

See every patch for more information. 

Changes in v4:
- removed meaningless u64_stats_sync protection in hinic_{txq|rxq}_get_stats
- merged the third patch in v2 into first one

Changes in v3:
- fixes a compile warning reported by kernel test robot <lkp@intel.com>

Changes in v2:
- fixes another 2 bugs. (v1 is a single patch, see: https://lore.kernel.org/all/07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com/).
- to fix extra bugs, hinic_dev.tx_stats/rx_stats is removed, so there is no need to use spinlock or semaphore now. 

Qiao Ma (2):
  net: hinic: fix bug that ethtool get wrong stats
  net: hinic: avoid kernel hung in hinic_get_stats64()

 drivers/net/ethernet/huawei/hinic/hinic_dev.h  |  3 --
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 61 +++++++-------------------
 drivers/net/ethernet/huawei/hinic/hinic_rx.c   |  2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c   |  2 -
 4 files changed, 16 insertions(+), 52 deletions(-)

-- 
1.8.3.1

