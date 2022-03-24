Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1972F4E5F5A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 08:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346282AbiCXH2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 03:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiCXH2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 03:28:19 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB7F98F69;
        Thu, 24 Mar 2022 00:26:47 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y10so4549141edv.7;
        Thu, 24 Mar 2022 00:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RGlQx4CxjF1nCN0guf3PMbVa/RgRQOhqLOG6ni1+cM=;
        b=A/lJCWaUbqsaVApVQnOKRJiAYg9Mepcwaq3bvPjMUeAtMx49ngGCVZ8/0G6w1gr3J8
         uTJsWo1ZHou77RqIQimPP/zhYaq9GmQOiaK1cXXnTRSPdofOdh0jIWKjIG7KWUPvpco5
         W/SuLdshg74qWxCZrJzGGru7qVYSmnNwBEKv8EfTrlHS7z/iF/RY/4Sil1S4Ugg43gn0
         KllDRkEuhW+G5DZFNnek8LJSzxvnwtAm07Y/ACxLi9nBNVg1QWH/fx+WGrWkX9VxzLzY
         WxIQh0rQ9JtRXlENZOlwmhjka27VwRSay5+4Em2lt8xzGUtwMlK6knFF9q26MLVh9Ozf
         0toA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RGlQx4CxjF1nCN0guf3PMbVa/RgRQOhqLOG6ni1+cM=;
        b=TSF0cGIRzvGw/wCt/remsZDIvjfOgiuZrAzumPK6sOKEiTqghMUryy3wup/fRsqpaZ
         0rmdEYHQw/QOnK3JhujuWmP8SiBze261096r/KsWL2LSD1VwOduc0vay3xF2afqcaE6Q
         cT2ZK/VqlSrWcgFg067Uby0iNTZruPARSAv1hh9f2AMgnlalWVZTI0jDonGK+GpuZZdg
         PWGrxchFpKXJcHDoiL+EoFABxT6bxHu56Vax7aeHWVBmMc43F/8G/pSWHLQA6ISh5qFF
         z2X1V4LsYzWpWT8pY5gOTNKL6FLVKaQ7GAJXZwoZwA36iFYoVHomFWggUp0cvr29ADHq
         bSZA==
X-Gm-Message-State: AOAM532ZURJCfy+QDicAaRhJmOauS9RFvsDlvEx62jHc4xPM1Xw1jIVG
        zxJMawH4R/x8I7TZKKzL2jSSiTadDHB5aqc5
X-Google-Smtp-Source: ABdhPJzdLBI5C5EiJLzFCWFHL8mAm7Yurvvi3TtSwAi9KMVulRl0fdlsPHZsreddiE1WQkwsR35/kg==
X-Received: by 2002:a05:6402:909:b0:416:6f3c:5c1d with SMTP id g9-20020a056402090900b004166f3c5c1dmr5094760edz.108.1648106805772;
        Thu, 24 Mar 2022 00:26:45 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id v5-20020a50c405000000b004161123bf7asm991942edf.67.2022.03.24.00.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:26:45 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] taprio: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:26:07 +0100
Message-Id: <20220324072607.63594-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 net/sched/sch_cbs.c    | 11 +++++------
 net/sched/sch_taprio.c | 11 +++++------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 459cc240eda9..4ea93a5d46cf 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -333,9 +333,8 @@ static int cbs_dev_notifier(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct cbs_sched_data *q;
+	struct cbs_sched_data *q = NULL, *iter;
 	struct net_device *qdev;
-	bool found = false;
 
 	ASSERT_RTNL();
 
@@ -343,16 +342,16 @@ static int cbs_dev_notifier(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 
 	spin_lock(&cbs_list_lock);
-	list_for_each_entry(q, &cbs_list, cbs_list) {
-		qdev = qdisc_dev(q->qdisc);
+	list_for_each_entry(iter, &cbs_list, cbs_list) {
+		qdev = qdisc_dev(iter->qdisc);
 		if (qdev == dev) {
-			found = true;
+			q = iter;
 			break;
 		}
 	}
 	spin_unlock(&cbs_list_lock);
 
-	if (found)
+	if (q)
 		cbs_set_port_rate(dev, q);
 
 	return NOTIFY_DONE;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 377f896bdedc..9403ae4bf107 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1096,9 +1096,8 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 			       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct taprio_sched *q = NULL, *iter;
 	struct net_device *qdev;
-	struct taprio_sched *q;
-	bool found = false;
 
 	ASSERT_RTNL();
 
@@ -1106,16 +1105,16 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 
 	spin_lock(&taprio_list_lock);
-	list_for_each_entry(q, &taprio_list, taprio_list) {
-		qdev = qdisc_dev(q->root);
+	list_for_each_entry(iter, &taprio_list, taprio_list) {
+		qdev = qdisc_dev(iter->root);
 		if (qdev == dev) {
-			found = true;
+			q = iter;
 			break;
 		}
 	}
 	spin_unlock(&taprio_list_lock);
 
-	if (found)
+	if (q)
 		taprio_set_picos_per_byte(dev, q);
 
 	return NOTIFY_DONE;

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

