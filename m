Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2A522D07
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbiEKHU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242747AbiEKHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:20:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5921C6CB2;
        Wed, 11 May 2022 00:20:24 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KymVj70bHzfbWP;
        Wed, 11 May 2022 15:19:09 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 11 May
 2022 15:20:22 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <m.chetan.kumar@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>, <loic.poulain@linaro.org>,
        <ryazanov.s.a@gmail.com>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: wwan: t7xx: Fix return type of t7xx_dl_add_timedout()
Date:   Wed, 11 May 2022 15:19:07 +0800
Message-ID: <20220511071907.29120-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t7xx_dl_add_timedout() now return int 'ret', but the return type
is bool. Change the return type to int for furthor errcode upstream.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wwan/t7xx/t7xx_dpmaif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
index c8bf6929af51..8ee15af1a1ce 100644
--- a/drivers/net/wwan/t7xx/t7xx_dpmaif.c
+++ b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
@@ -1043,7 +1043,7 @@ unsigned int t7xx_dpmaif_dl_dlq_pit_get_wr_idx(struct dpmaif_hw_info *hw_info,
 	return value & DPMAIF_DL_RD_WR_IDX_MSK;
 }
 
-static bool t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
+static int t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
 {
 	u32 value;
 	int ret;
-- 
2.17.1

