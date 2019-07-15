Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE984693BD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404436AbfGOOhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:37:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39986 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404383AbfGOOhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 10:37:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so7809564pgj.7
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peLCyvMnb6GAqXrVywa8AT70STEJ77uX6TkkVXJzQ/M=;
        b=QjihkdzO56EyWdL1UBrowr4J0diPIpjeawlNo5eUXRlutEI+PMdDLg/2ovhGCm9dB1
         am3dJfpAJ98Tx9IokTbTDJI/QLnhNHnLoi+VI/95oP5fp/RwwQCZGPG9aCEKUlUpO/1N
         atHPVJ+wXVzYcfg26NNOs6IX7iznL6Gp2AAwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peLCyvMnb6GAqXrVywa8AT70STEJ77uX6TkkVXJzQ/M=;
        b=HnQ0ihqEVz/wBsg3xNF7xSx/1w/UXjC5zgi9EFZ0zSgzpHFLD4LuMIDsbJB7ESUE2N
         VlsQjFlUiIkgPG5apYAanyXxPYSZjA1J/nrdegbTXJUIaNtrUJQSJ3GZVcGG0EqlSJ85
         7hVrkXj198m3Mvg/eLpc+Kd7oGBa5WUXU/2AuwupwpvFfptFaszmzcea9oMbf+/G3y4F
         kBrRiX9HpJ67OaC2FjmDP7KQ4Y9b4Xm/XDmIF6F+Yy1R4MGEzF/gM0V86qUiXzuNtPMd
         p+ZOLXHhu8vHjtY92IuMMYnZIAQ1oC5nMnPZK8N7AGc+Thfcx+elZwaI5x0uvPNMKjte
         2WBQ==
X-Gm-Message-State: APjAAAWy0xRYv4BwjfTT/yXZ7KzVkdW07JtCE6+0CLqyew5gvqI0tnGI
        ceeFGL0QR32MLwjhNpk2/TI=
X-Google-Smtp-Source: APXvYqzmK9tD8rYXtIru39NtpVyI6dVamC0JOl/Vm3L4KkimM24dL0CBqeO9C1zAEuPYG8wK9FgMFA==
X-Received: by 2002:a65:6281:: with SMTP id f1mr25763664pgv.400.1563201437978;
        Mon, 15 Jul 2019 07:37:17 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id s66sm18381852pfs.8.2019.07.15.07.37.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 07:37:17 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH 1/9] rcu/update: Remove useless check for debug_locks (v1)
Date:   Mon, 15 Jul 2019 10:36:57 -0400
Message-Id: <20190715143705.117908-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rcu_read_lock_sched_held(), debug_locks can never be true at the
point we check it because we already check debug_locks in
debug_lockdep_rcu_enabled() in the beginning. Remove the check.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/rcu/update.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 61df2bf08563..9dd5aeef6e70 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -93,17 +93,13 @@ module_param(rcu_normal_after_boot, int, 0);
  */
 int rcu_read_lock_sched_held(void)
 {
-	int lockdep_opinion = 0;
-
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
 	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
-	if (debug_locks)
-		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || !preemptible();
+	return lock_is_held(&rcu_sched_lock_map) || !preemptible();
 }
 EXPORT_SYMBOL(rcu_read_lock_sched_held);
 #endif
-- 
2.22.0.510.g264f2c817a-goog

