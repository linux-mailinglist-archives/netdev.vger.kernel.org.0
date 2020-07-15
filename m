Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BA72205B2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgGOHAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgGOHAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 03:00:31 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BECC061755;
        Wed, 15 Jul 2020 00:00:31 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x72so1684218pfc.6;
        Wed, 15 Jul 2020 00:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tLcbbH6RQ4c5Lr9zlq+KUv75jPKDDQ19OMIkZpQFbg=;
        b=hZ9A3V1z4i3XqDgld5h+MHjsd2g6cZ6LkAd/2FLdVm6cZvQV8hLyuFKmjQ0mloxcbA
         m4CbIJp50LH/fM9H/RWLLQYPJojRbT2mi6js2y5jEDFq74kg3bPlJWJGl3g+i6YN51AU
         7hW3olZqkFtCBNZgi5dUt2sVb7T4GoV0x5HAf4mklwM50PCridcHTjareE/l7nTLA7eS
         6vd6wim7EC/TmPYo5gusZG5A9yZxkj0kUrJNKUEgK1XGIoK4KYsbioL1LNSN8xUsrXQ+
         AAEmDTU9rAwv/6zl4yHyJ8/o3RpBrIb8ppEtzOD31okEBsPcss1b00R+Ppl5hEKNgEba
         cu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tLcbbH6RQ4c5Lr9zlq+KUv75jPKDDQ19OMIkZpQFbg=;
        b=n3oVk6kLvhI9NLxIP4sNujy4tbA/3uPXRgLvD9FKmGK4s7EydCrQfVjlLM3UoEsA1R
         KynHijEUMKSKi32srcqtZhOxRBWtP9JVSZPsJHGyABLD1Ya1jnvxvS7nP02G0c/GJTwS
         GJ6vBVyUj590GKJn4bT+G7feInZDBbF9EgnGr1tumccwxYw0h+3y0i8mGcNzVnmydkXL
         DKBVBJzN4kkT3C8Huullb0clAES2oEDelpY24pppasctyXnjnXOVJvWnJvNyS3IJI3Qw
         dkzx42wSDkTuxkvxthbXn0D/nYnwlv+k0kZZL1VLFQ15mVU7Vjq9nxrOyJOGwuSwAGmj
         CAXQ==
X-Gm-Message-State: AOAM533KVCsXyEeRp5d/Qn6lBjxPNhPWMlnQS4iYl0OVA7sOYBbTbY8B
        h5xDTE3yldWssQOon6cMJ0ZekcZk+Vg9lA==
X-Google-Smtp-Source: ABdhPJww18jqMkURXkuy3Y3PXzxeyzQ/Ts2YDz9OKt/2lcIYp4VW2qVfAdjmhV1XYddK0TDH2dETvw==
X-Received: by 2002:a63:100b:: with SMTP id f11mr6505902pgl.287.1594796430865;
        Wed, 15 Jul 2020 00:00:30 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm1020027pjl.30.2020.07.15.00.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 00:00:30 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Wed, 15 Jul 2020 15:00:01 +0800
Message-Id: <20200715070001.2048207-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c67c88ad35f8..9d4dbef3c943 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -253,6 +253,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
 };
 
 /* type of values returned from helper functions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c1efc9d08fd..d3551a19853a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3849,9 +3849,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		expected_type = SCALAR_VALUE;
 		if (type != expected_type)
 			goto err_type;
-	} else if (arg_type == ARG_CONST_MAP_PTR) {
+	} else if (arg_type == ARG_CONST_MAP_PTR ||
+		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
 		expected_type = CONST_PTR_TO_MAP;
-		if (type != expected_type)
+		if (register_is_null(reg) &&
+		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
+			/* final test in check_stack_boundary() */;
+		else if (type != expected_type)
 			goto err_type;
 	} else if (arg_type == ARG_PTR_TO_CTX ||
 		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
@@ -3957,7 +3961,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		return -EFAULT;
 	}
 
-	if (arg_type == ARG_CONST_MAP_PTR) {
+	if (arg_type == ARG_CONST_MAP_PTR ||
+	    (arg_type == ARG_CONST_MAP_PTR_OR_NULL && !register_is_null(reg))) {
 		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
 		meta->map_ptr = reg->map_ptr;
 	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
-- 
2.25.4

