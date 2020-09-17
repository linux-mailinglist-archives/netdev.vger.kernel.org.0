Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E87226DDD7
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgIQOQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbgIQN6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 09:58:03 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B29AC061D7D
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 06:57:26 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i22so3441079eja.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 06:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pSSlZZ+MnV5QXAvkjR9T5/pkqeT/NfDS35+qV4B6bxY=;
        b=xq8SGYChd6ZN8Aq44erpoXz0/3kRxhpdkMZSIkX3gWUwUeuwEV9mufoEAg6FsmsgYq
         b/BoNG4lqJacAV7dqrjqKRFdm0JYRvcIDm0kaOvcRLiSYaZwwZhzZARUmeFM5Ncj0PIe
         FEZ+YyG+TZoI6qNYpC0RQTtWrWdXXaAkdumSMZL/thLRh47cV2UidgWozWiKGLDYtTRJ
         cwmRw+cvdyCwgqjKFcDZYbIrOgLXedc7Fwr0zy0CMPh4SmevtCdXJCwVHqmtovVkdBPK
         peVF8qy+yesHFf/OEdM5HjdRcRRh0RmBbXL0j1518Lz9iaqacBixwtENnOt9zmtaMsd5
         z8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pSSlZZ+MnV5QXAvkjR9T5/pkqeT/NfDS35+qV4B6bxY=;
        b=pQffCLuoOyUh4Nyp+S9JYlP6X+b97aq920lI10qX58FjVxZ8V/S4lrYgALG3KjHkdJ
         uuQ1v5K+SMdhZBopZt12PvNB8O6tEwWz4i4NrHZIxFlwdmSBzRXvG9y1Km8WzXvgWhwv
         VaMDiJt5PNYA1zquCfGit3QPl4SJk7xq/r8CLgfv4tbQr9es4mxgD1vZwwBe3eDTKSpK
         NCMxtb53YTOHDJh4gJ09j+9aEIrQUh5P1Y3B9/RbeLgKre1cx6prOf85d49Fx8qItHp1
         2xeaIDGUMEriGnVYTIds0WxvGSsZBiK+Bxi5M3BZDeEV4oir/OrlZ+B/OpUIm/5+ijR6
         HZeg==
X-Gm-Message-State: AOAM532GWuJD35wsB9pEXFz9wv7opIUcRFkJkKnnrUQmSKx/gPyuPrhf
        l6lZSKBeAjve554thsh1/qDYxQ==
X-Google-Smtp-Source: ABdhPJxRW0504JkwLHfAfome1NFDuXgAji9E1LroxFxjxRe9AN6YEk0vQMwnh2Wr1HJviGb5N+T+Bw==
X-Received: by 2002:a17:906:1b04:: with SMTP id o4mr32078527ejg.332.1600351042447;
        Thu, 17 Sep 2020 06:57:22 -0700 (PDT)
Received: from localhost.localdomain ([89.18.44.40])
        by smtp.gmail.com with ESMTPSA id k25sm3492ejk.3.2020.09.17.06.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 06:57:21 -0700 (PDT)
From:   Luka Oreskovic <luka.oreskovic@sartura.hr>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Luka Oreskovic <luka.oreskovic@sartura.hr>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH bpf-next] bpf: add support for other map types to bpf_map_lookup_and_delete_elem
Date:   Thu, 17 Sep 2020 15:57:00 +0200
Message-Id: <20200917135700.649909-1-luka.oreskovic@sartura.hr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this function already exists, it made sense to implement it for
map types other than stack and queue. This patch adds the necessary parts
from bpf_map_lookup_elem and bpf_map_delete_elem so it works as expected
for all map types.

Signed-off-by: Luka Oreskovic <luka.oreskovic@sartura.hr>
CC: Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>
CC: Luka Perkov <luka.perkov@sartura.hr>
---
 kernel/bpf/syscall.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2ce32cad5c8e..955de6ca8c45 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1475,6 +1475,9 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_MAP_LOOKUP_AND_DELETE_ELEM))
 		return -EINVAL;
 
+	if (attr->flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
 	f = fdget(ufd);
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
@@ -1485,13 +1488,19 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
+	if ((attr->flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map)) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
 	key = __bpf_copy_key(ukey, map->key_size);
 	if (IS_ERR(key)) {
 		err = PTR_ERR(key);
 		goto err_put;
 	}
 
-	value_size = map->value_size;
+	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
 	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
@@ -1502,7 +1511,24 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	    map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_pop_elem(map, value);
 	} else {
-		err = -ENOTSUPP;
+		err = bpf_map_copy_value(map, key, value, attr->flags);
+		if (err)
+			goto free_value;
+
+		if (bpf_map_is_dev_bound(map)) {
+			err = bpf_map_offload_delete_elem(map, key);
+		} else if (IS_FD_PROG_ARRAY(map) ||
+			   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+			/* These maps require sleepable context */
+			err = map->ops->map_delete_elem(map, key);
+		} else {
+			bpf_disable_instrumentation();
+			rcu_read_lock();
+			err = map->ops->map_delete_elem(map, key);
+			rcu_read_unlock();
+			bpf_enable_instrumentation();
+			maybe_wait_bpf_programs(map);
+		}
 	}
 
 	if (err)
-- 
2.26.2

