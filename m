Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2E8336A4D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCKDBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCKDB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:01:28 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBC8C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 19:01:28 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q130so2640142oif.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 19:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QqqDh8TjAj6Dh4tKZDOB+6W75csEvzru/rNrT/f/Ss8=;
        b=bNZM1RADqOaCC+PuqDSHxYmb9ooYFyvowkAs3dNtSIyW5pufeK8qGMgZUDgG3e4Sa/
         N3OBo14YcFCBe+RATbsSnMQQB7cYDg0TSsnBUk1czYXZzZ/vsH6OwrH9wed7ablPXqKq
         y0yX3/0yOrlS7gpoYFJ0jMPB1PTxDfUSLWPghIEarPr7huDMYaxGY2Desf4hlsBO8fzM
         nmAGXQQTETL3UjeHHKiitlVnbDpwm6xh8xPo6NXveWNAWWO35vI+xA9inFUjPbn+fev0
         rWsZPKq8y92BjUUBnZRTB9X6qLQbZ5YNCprkiUKfpF6sJcbtUHMowNqeLC3cf1Iz43nq
         nYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QqqDh8TjAj6Dh4tKZDOB+6W75csEvzru/rNrT/f/Ss8=;
        b=BKfoQPW2qIeNReRnPMldbpPQRtKLFjL9P0AizKVkoqYlp2D/7jkv3R9cDJDTar4aXk
         JJQIuF64DAcoVGEnkyE+jG4h93+DspNnyEfYImYjD0AoPdY/Yjqh2PrhIAnOYIrApc6+
         ktjAbJ7XbiYEOaLAflzjxJT4HoR0srvN4FEfxrP1GPGeMaV8OFvWkbt7HyF9eHbj7dQy
         sKqn5LHtgHH1MxChtJPs9BnMlkwzCBUhO7n9FUKF1bpC2TMeUjtRQupi/HiFedzkzpzS
         fe0OI/8YwV0BgKIROQGdtq2TXzU0578hymDOr5mK12vweLVXss4njVEZDFpUYZBNzpfX
         Cmfw==
X-Gm-Message-State: AOAM533Bu6zPt7IJ6/3F0MMfa50iKuQSFj8ENeYgimtAzU/8FtJA2Oqg
        N1J41qehP16damnSEV/0DcsZ6ONdUR4=
X-Google-Smtp-Source: ABdhPJzg38t4AEV7boqguoCI9/DdviFaHmToc0Q9MXdINs3P4B6OxFk5SMThYHpIoBZhVCxvmIHiTQ==
X-Received: by 2002:aca:4c52:: with SMTP id z79mr4795354oia.125.1615431687784;
        Wed, 10 Mar 2021 19:01:27 -0800 (PST)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id v2sm364569ota.59.2021.03.10.19.01.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Mar 2021 19:01:27 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org, alexanderduyck@fb.com
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2] net: sock: simplify tw proto registration
Date:   Thu, 11 Mar 2021 10:57:36 +0800
Message-Id: <20210311025736.77235-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Introduce the new function tw_prot_init (inspired by
req_prot_init) to simplify "proto_register" function.

tw_prot_cleanup will take care of a partially initialized
timewait_sock_ops.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/core/sock.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0ed98f20448a..cc31b601ae10 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3440,6 +3440,32 @@ static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
 	twsk_prot->twsk_slab = NULL;
 }
 
+static int tw_prot_init(const struct proto *prot)
+{
+	struct timewait_sock_ops *twsk_prot = prot->twsk_prot;
+
+	if (!twsk_prot)
+		return 0;
+
+	twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s",
+					      prot->name);
+	if (!twsk_prot->twsk_slab_name)
+		return -ENOMEM;
+
+	twsk_prot->twsk_slab =
+		kmem_cache_create(twsk_prot->twsk_slab_name,
+				  twsk_prot->twsk_obj_size, 0,
+				  SLAB_ACCOUNT | prot->slab_flags,
+				  NULL);
+	if (!twsk_prot->twsk_slab) {
+		pr_crit("%s: Can't create timewait sock SLAB cache!\n",
+			prot->name);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static void req_prot_cleanup(struct request_sock_ops *rsk_prot)
 {
 	if (!rsk_prot)
@@ -3496,22 +3522,8 @@ int proto_register(struct proto *prot, int alloc_slab)
 		if (req_prot_init(prot))
 			goto out_free_request_sock_slab;
 
-		if (prot->twsk_prot != NULL) {
-			prot->twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s", prot->name);
-
-			if (prot->twsk_prot->twsk_slab_name == NULL)
-				goto out_free_request_sock_slab;
-
-			prot->twsk_prot->twsk_slab =
-				kmem_cache_create(prot->twsk_prot->twsk_slab_name,
-						  prot->twsk_prot->twsk_obj_size,
-						  0,
-						  SLAB_ACCOUNT |
-						  prot->slab_flags,
-						  NULL);
-			if (prot->twsk_prot->twsk_slab == NULL)
-				goto out_free_timewait_sock_slab;
-		}
+		if (tw_prot_init(prot))
+			goto out_free_timewait_sock_slab;
 	}
 
 	mutex_lock(&proto_list_mutex);
-- 
2.27.0

