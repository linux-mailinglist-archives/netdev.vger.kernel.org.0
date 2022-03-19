Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E02A4DE688
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 07:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiCSGji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 02:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiCSGjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 02:39:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC55011799A;
        Fri, 18 Mar 2022 23:38:15 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 6so6557655pgg.0;
        Fri, 18 Mar 2022 23:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=GluDFdkBChva+jocW0SyMC3tuY/V24Q5GrrZHXeHqjY=;
        b=dmAgLaV5v+UuQJZPxFMQ60+gTHVvTTCy2dgtlPo4NB7pESgqWaVIJ1nS/GZNpIMC4O
         AAOrFBszlsetcmeL56Aqclu0KX52L933H53WWY9Boj5qUKKL4zwOmKdoQjebrf0lVRn2
         qJl6crIW1HXl6bJV5EHazVyqI9/Qx79Lp0sAECmFGpFB/xWCRm+c+WwJwvo8mYJjoGSu
         WkE9jfl6lCEMQY48LECZqwMSFHNJYMadfXOebfC0aM915NZUnQvTKajLzqETWsjBECnq
         KCnNVjKrrJkNzoOoWXA7y9vvwqyNI+rL1cAL1yilms1isfyrmOWsZWfGPDWvnRUaevql
         ctMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GluDFdkBChva+jocW0SyMC3tuY/V24Q5GrrZHXeHqjY=;
        b=G9fZrpkCcrCNPoDv0w+M1/3E04yp6PaGbg7Sg8JmvIUErSxL4RCaI4n80nwFB49IAp
         IZ8QucywUWZ1CLInF+Jv5RMy2d2PQowXRi5iRRB9qvjPV/AMUnTwLYMumDaKRD02zpNA
         zUO9g28ExnAPlrV8AC5HEVASmC9GuvKeDerlUcZ3AC33/ymmdjcAVgvJgFVKP6MiEGv3
         fdVHBTAzRTj7VmVdyDDIq/qFw6Iy/GH4eUaWzr7W5LmdKkSL2Th/wFRE1c7looDIOEOf
         Tl5UqWi2ntUNU9vhWcApL4DXlM7B05EauDkP359O2ni5hOU4EqGMG54QU9f3LPZ8t558
         LLHA==
X-Gm-Message-State: AOAM531FzqHDS3GW3Tkwet++a0acJe7Pma5fg0acqZjGmde+lSYykNos
        hMpbUI6b6DWfgfu/KlxZv5+b9XJiqyOCrg==
X-Google-Smtp-Source: ABdhPJxTVUrwj7oiSzs5uZYRcAMYaWGrhVuHFFsfiRjruylgzxUIJJI4LzGmBZ/71q2kw/PbVrObWg==
X-Received: by 2002:aa7:8256:0:b0:4e0:78ad:eb81 with SMTP id e22-20020aa78256000000b004e078adeb81mr14187464pfn.30.1647671895288;
        Fri, 18 Mar 2022 23:38:15 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id y16-20020a637d10000000b00381268f2c6fsm9139077pgc.4.2022.03.18.23.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 23:38:14 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     pizza@shaftnet.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH] cw1200: remove an unneeded NULL check on list iterator
Date:   Sat, 19 Mar 2022 14:38:00 +0800
Message-Id: <20220319063800.28791-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The list iterator 'item' is always non-NULL so it doesn't need to be
checked. Thus just remove the unnecessary NULL check. Also remove the
unnecessary initializer because the list iterator is always initialized.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/wireless/st/cw1200/queue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
index 12952b1c29df..05392598e273 100644
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -90,7 +90,7 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 			      bool unlock)
 {
 	struct cw1200_queue_stats *stats = queue->stats;
-	struct cw1200_queue_item *item = NULL, *tmp;
+	struct cw1200_queue_item *item, *tmp;
 	bool wakeup_stats = false;
 
 	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
@@ -117,7 +117,7 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 			queue->overfull = false;
 			if (unlock)
 				__cw1200_queue_unlock(queue);
-		} else if (item) {
+		} else {
 			unsigned long tmo = item->queue_timestamp + queue->ttl;
 			mod_timer(&queue->gc, tmo);
 			cw1200_pm_stay_awake(&stats->priv->pm_state,
-- 
2.17.1

