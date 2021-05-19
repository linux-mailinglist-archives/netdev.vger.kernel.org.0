Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42376388E65
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353477AbhESMzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:55:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3599 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhESMzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:55:19 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlXnB2pvbzmXW4
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 20:51:42 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 20:53:58 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 20:53:58 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Karsten Keil <isdn@linux-pingi.de>, netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] mISDN: Mark local variable 'incomplete' as __maybe_unused in dsp_pipeline_build()
Date:   Wed, 19 May 2021 20:53:52 +0800
Message-ID: <20210519125352.7991-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC reports the following warning with W=1:

drivers/isdn/mISDN/dsp_pipeline.c:221:6: warning:
 variable 'incomplete' set but not used [-Wunused-but-set-variable]
  221 |  int incomplete = 0, found = 0;
      |      ^~~~~~~~~~

This variable is used only when macro PIPELINE_DEBUG is defined.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/isdn/mISDN/dsp_pipeline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 40588692cec7..6a31f6879da8 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -218,7 +218,7 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
 
 int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 {
-	int incomplete = 0, found = 0;
+	int __maybe_unused incomplete = 0, found = 0;
 	char *dup, *tok, *name, *args;
 	struct dsp_element_entry *entry, *n;
 	struct dsp_pipeline_entry *pipeline_entry;
-- 
2.25.1


