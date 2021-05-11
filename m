Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739E037B05F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 22:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhEKU4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 16:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhEKU4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 16:56:00 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DCAC061574;
        Tue, 11 May 2021 13:54:53 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id u19-20020a0568302493b02902d61b0d29adso17923663ots.10;
        Tue, 11 May 2021 13:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bP2618JY2DE3yj2d7g93gwrbJJQkvioNaEQ1U9UncYI=;
        b=S/Q680UVMhXEh5mtozUsmjMmpQRedOJCMBczniCRFKgukQ4lSmnVPAcS0etdlvXizq
         GB3o0HeTJwPjXOSs0yG+E+8w/iRJ0bE8M/mENTueh+mifvYRSGyaEw34467ep2rdtK+V
         XpOUjMcUXFiqgnW8a7aqGP1DhfIiownQmBcsOpxJ/O8YuKxbAmRKTnIkoCzE4cJC9EpS
         F46hZZxeRaoNab8PCFfXcIlFPZNBW1J+0scKhKEVb83R333maTOXlyWQ1K3nDjKxoPYU
         uXx3QxGTqmwGDxn8aW6IavVapSi0NX2maQ2htNEbuJnFG1cp5Xr0tvNVq2DfuKG6CVaP
         1oBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=bP2618JY2DE3yj2d7g93gwrbJJQkvioNaEQ1U9UncYI=;
        b=sDrbB+Gvp7XRSdQOnQInEI1phJ6NemgqXYafdHN+ywdvX2agsI8tSkngIL5384kuMb
         YTlvIP5R6SjlmQa+3usgDPEiaZHIO9Fm8Ad1Xp4XLk6D/zYRW6/InU7I29mc7JnDXrC2
         a+y2Q1ZKIhVW5rf6AequU/dPfKChJnjg5PqwaXi5MykyYgH2m4XvnGEIrAqXkr6gGjHe
         MzYWLvrk6hGEczD0fpgwKgTfcfMMSb5EVRuOBvGp32o+8hlR3Ml7eu4kHPZsEFvT89yn
         eUee1sGbKu2XcRDz5FixyGp61jzjyQdVlWQq6eWIPgS6/eG33wblZibofngf42OtWcHC
         011Q==
X-Gm-Message-State: AOAM532Vpa9rNYNkEvUz7UlaZRz879QHUGqdK2fgDRHrCXMsqFSzNPU9
        1+cw0yDAxnDd6o/KN7oNHYgjPUdw9i0=
X-Google-Smtp-Source: ABdhPJwW3OReJrqrn6ICu6fJk++aFosn+n08kcHTvM7KgqDWqf2d5pHqYVvfczWQIa6f9pklZPmgrw==
X-Received: by 2002:a9d:6c81:: with SMTP id c1mr14037459otr.248.1620766493103;
        Tue, 11 May 2021 13:54:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q130sm3361498oif.40.2021.05.11.13.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 13:54:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net/sched: taprio: Drop unnecessary NULL check after container_of
Date:   Tue, 11 May 2021 13:54:49 -0700
Message-Id: <20210511205449.1676407-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu_head pointer passed to taprio_free_sched_cb is never NULL.
That means that the result of container_of() operations on it is also
never NULL, even though rcu_head is the first element of the structure
embedding it. On top of that, it is misleading to perform a NULL check
on the result of container_of() because the position of the contained
element could change, which would make the check invalid. Remove the
unnecessary NULL check.

This change was made automatically with the following Coccinelle script.

@@
type t;
identifier v;
statement s;
@@

<+...
(
  t v = container_of(...);
|
  v = container_of(...);
)
  ...
  when != v
- if (\( !v \| v == NULL \) ) s
...+>

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 net/sched/sch_taprio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5c91df52b8c2..71e8a7a84841 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -114,9 +114,6 @@ static void taprio_free_sched_cb(struct rcu_head *head)
 	struct sched_gate_list *sched = container_of(head, struct sched_gate_list, rcu);
 	struct sched_entry *entry, *n;
 
-	if (!sched)
-		return;
-
 	list_for_each_entry_safe(entry, n, &sched->entries, list) {
 		list_del(&entry->list);
 		kfree(entry);
-- 
2.25.1

