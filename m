Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580EC389B42
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhETCQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:16:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3430 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhETCPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:15:51 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FltXD1mngzCtCZ;
        Thu, 20 May 2021 10:11:40 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:14:27 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:14:26 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] mISDN: Remove obsolete PIPELINE_DEBUG debugging information
Date:   Thu, 20 May 2021 10:14:11 +0800
Message-ID: <20210520021412.8100-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210520021412.8100-1-thunder.leizhen@huawei.com>
References: <20210520021412.8100-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Leon Romanovsky's tips:
The definition of macro PIPELINE_DEBUG is commented more than 10 years ago
and can be seen as a dead code that should be removed.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/isdn/mISDN/dsp_pipeline.c | 46 ++-----------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 40588692cec7..e11ca6bbc7f4 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -17,9 +17,6 @@
 #include "dsp.h"
 #include "dsp_hwec.h"
 
-/* uncomment for debugging */
-/*#define PIPELINE_DEBUG*/
-
 struct dsp_pipeline_entry {
 	struct mISDN_dsp_element *elem;
 	void                *p;
@@ -104,10 +101,6 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 		}
 	}
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: %s registered\n", __func__, elem->name);
-#endif
-
 	return 0;
 
 err2:
@@ -129,10 +122,6 @@ void mISDN_dsp_element_unregister(struct mISDN_dsp_element *elem)
 	list_for_each_entry_safe(entry, n, &dsp_elements, list)
 		if (entry->elem == elem) {
 			device_unregister(&entry->dev);
-#ifdef PIPELINE_DEBUG
-			printk(KERN_DEBUG "%s: %s unregistered\n",
-			       __func__, elem->name);
-#endif
 			return;
 		}
 	printk(KERN_ERR "%s: element %s not in list.\n", __func__, elem->name);
@@ -145,10 +134,6 @@ int dsp_pipeline_module_init(void)
 	if (IS_ERR(elements_class))
 		return PTR_ERR(elements_class);
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline module initialized\n", __func__);
-#endif
-
 	dsp_hwec_init();
 
 	return 0;
@@ -168,10 +153,6 @@ void dsp_pipeline_module_exit(void)
 		       __func__, entry->elem->name);
 		kfree(entry);
 	}
-
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline module exited\n", __func__);
-#endif
 }
 
 int dsp_pipeline_init(struct dsp_pipeline *pipeline)
@@ -181,10 +162,6 @@ int dsp_pipeline_init(struct dsp_pipeline *pipeline)
 
 	INIT_LIST_HEAD(&pipeline->list);
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline ready\n", __func__);
-#endif
-
 	return 0;
 }
 
@@ -210,15 +187,11 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
 		return;
 
 	_dsp_pipeline_destroy(pipeline);
-
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline destroyed\n", __func__);
-#endif
 }
 
 int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 {
-	int incomplete = 0, found = 0;
+	int found = 0;
 	char *dup, *tok, *name, *args;
 	struct dsp_element_entry *entry, *n;
 	struct dsp_pipeline_entry *pipeline_entry;
@@ -251,7 +224,6 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 					printk(KERN_ERR "%s: failed to add "
 					       "entry to pipeline: %s (out of "
 					       "memory)\n", __func__, elem->name);
-					incomplete = 1;
 					goto _out;
 				}
 				pipeline_entry->elem = elem;
@@ -268,20 +240,12 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 					if (pipeline_entry->p) {
 						list_add_tail(&pipeline_entry->
 							      list, &pipeline->list);
-#ifdef PIPELINE_DEBUG
-						printk(KERN_DEBUG "%s: created "
-						       "instance of %s%s%s\n",
-						       __func__, name, args ?
-						       " with args " : "", args ?
-						       args : "");
-#endif
 					} else {
 						printk(KERN_ERR "%s: failed "
 						       "to add entry to pipeline: "
 						       "%s (new() returned NULL)\n",
 						       __func__, elem->name);
 						kfree(pipeline_entry);
-						incomplete = 1;
 					}
 				}
 				found = 1;
@@ -290,11 +254,9 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 
 		if (found)
 			found = 0;
-		else {
+		else
 			printk(KERN_ERR "%s: element not found, skipping: "
 			       "%s\n", __func__, name);
-			incomplete = 1;
-		}
 	}
 
 _out:
@@ -303,10 +265,6 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 	else
 		pipeline->inuse = 0;
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline built%s: %s\n",
-	       __func__, incomplete ? " incomplete" : "", cfg);
-#endif
 	kfree(dup);
 	return 0;
 }
-- 
2.25.1


