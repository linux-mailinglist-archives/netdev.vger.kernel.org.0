Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C874D92E5
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344520AbiCODZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiCODZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:25:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974B435862
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:24:10 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHdyB02gMzfYq0;
        Tue, 15 Mar 2022 11:22:41 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:24:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:24:08 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <tanhuazhong@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RFC ethtool 1/2] ethtool: add has_input in struct cmdline_info to record cmdline params
Date:   Tue, 15 Mar 2022 11:18:33 +0800
Message-ID: <20220315031834.56676-2-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220315031834.56676-1-wangjie125@huawei.com>
References: <20220315031834.56676-1-wangjie125@huawei.com>
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

In driver feature configuration scene, ethtool need to record the config
combination. So this patch add has_input to mark the features to be
configured.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 5d718a2..e2b4e17 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -111,6 +111,8 @@ struct cmdline_info {
 	 * For anything else, points to int and is set if the option is
 	 * seen. */
 	void *seen_val;
+	/* indicate current input has this item */
+	u32 has_input;
 };
 
 struct feature_def {
@@ -244,6 +246,7 @@ static void parse_generic_cmdline(struct cmd_context *ctx,
 			if (!strcmp(info[idx].name, argp[i])) {
 				found = 1;
 				*changed = 1;
+				info[idx].has_input = 1;
 				if (info[idx].type != CMDL_FLAG &&
 				    info[idx].seen_val)
 					*(int *)info[idx].seen_val = 1;
-- 
2.33.0

