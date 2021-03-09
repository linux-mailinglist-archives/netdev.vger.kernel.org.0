Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98314331D53
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 04:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIDOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 22:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhCIDOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 22:14:00 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604E1C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 19:14:00 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id e45so11461363ote.9
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 19:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8zBlcfBMfrwoU8pkM4UG3EF7SVwm37CG0qUTPxdQWiA=;
        b=Di65ETanHYgnIEmxpEBSuhvIL9IqQ9WTZb8gTjwnfioFmNruRfn6UzGrkH5sQMoNsH
         sG/Sxmn8AVwwodTCPhpywkasm/hD8dLIQi5iR2xUeomJORKDIAg9zOV3wtDiI35yt4/G
         Dy0wvsU1zgpI7ReiQzntdSiExYrnVcF78EB4exFjglKsPoR2w2jI15soyrgSGnf0aFkt
         5AxYIE46JE4romsW6IID+LXiRMpF/h8ByvzPpXoeH4ZctXJDHXt5YCO/k9rtbpzaTwvU
         xi79ZhLISrYa13KuztAU4m6FEe8NDxRtOvO0mN0sDOAxNl3ihSoMwMAVBP8Nd4iRnjbH
         oAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8zBlcfBMfrwoU8pkM4UG3EF7SVwm37CG0qUTPxdQWiA=;
        b=EQ7iqpfOhdzfpWZRIRzWVazrEDfNEcj7vgL0hOeR3YKAUV/wQ24ua5b35JlHcovffp
         pQ1kjuIBrJe2H+wDiStWDQdG1pambGqBAaBLA2xo6D/zOVjvIPitKLCcBaU1lZcScTtW
         UaA7wibfPi3R12sRdVtnIc6fdXAFMv9n2FAafPvEwNzs3kIcLBTYdh6MaFwPZwhOYDul
         2ziVbwYgzOcZyJoKmUuBkSDVm68UexNiUpwunAO5Ya6+bhQof4GrB3sFXV9AgOBJEyyq
         SXQamiSHzR6hQDI1Sw2ZOAIrR4eb5EaYJv1mM+VubWPUgk1djpWR5QULPfnDP4Tr7eKL
         ZYvg==
X-Gm-Message-State: AOAM533wXt7VUIzb9Pzuk7fQ8zbrpnd/m3lx8zAmPNx6gZtSGU226UKX
        zDHcdwsKHXqFY0/XzX28HL+6zhRgA6k=
X-Google-Smtp-Source: ABdhPJztZ4Epngv6Ovhsi+eNj1W8iAJ8Brw2M0jCib6n3s8GLe8VzawfmQgXXQgUTYO8vbJp2GrV4A==
X-Received: by 2002:a05:6830:1f55:: with SMTP id u21mr23607159oth.103.1615259639560;
        Mon, 08 Mar 2021 19:13:59 -0800 (PST)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id t19sm1185977otm.40.2021.03.08.19.13.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Mar 2021 19:13:59 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net: sock: simplify tw proto registration
Date:   Tue,  9 Mar 2021 11:10:28 +0800
Message-Id: <20210309031028.97385-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Introduce a new function twsk_prot_init, inspired by
req_prot_init, to simplify the "proto_register" function.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/sock.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0ed98f20448a..610de4295101 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3475,6 +3475,32 @@ static int req_prot_init(const struct proto *prot)
 	return 0;
 }
 
+static int twsk_prot_init(const struct proto *prot)
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
 int proto_register(struct proto *prot, int alloc_slab)
 {
 	int ret = -ENOBUFS;
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
+		if (twsk_prot_init(prot))
+			goto out_free_timewait_sock_slab;
 	}
 
 	mutex_lock(&proto_list_mutex);
-- 
2.27.0

