Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6213B6929A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404128AbfGOOhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:37:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36213 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392137AbfGOOhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 10:37:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so8405180plt.3
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 07:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3/Yc3rMkHMZtDKtPxvXMbpuJtYxFK974gkQSASG7nfg=;
        b=Irsk1l+cCvhHrnLDCclN8wIYVEkPEbD9MdUbMAfJ0kSrDpX7chroJyo2YF46UzcBkM
         XJuVwKS6BKM9ZHR0du6EvejWG8y2q+OPRVvdrOulKML9bNBty7xmC4DwYF/BBFtQPuLu
         EwiuS9bOEcElBlknIAsc95qH+foz6NeembQns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3/Yc3rMkHMZtDKtPxvXMbpuJtYxFK974gkQSASG7nfg=;
        b=hdM7d98ep06TGyTsM5rIzYdmtOvdU5LNBMBjWii6HnfxzSZ6D37VtJhub+jGaX9Obh
         vsi5XjkhA8G5x5nlDrdAGoAO7jHu0kR9Lq/X+10LY5o6woqFceXgmlXn9ADUnE9TXcfT
         Zxn4jKJhpHzjcfhElN/we4YxRrrDa+Na5JEZGC5htfHHX9IXbbKjAlwVLjK1WejTSU+F
         m9JWjXTRPPJFnyxcdNQnk+Q9fDxiJTKVFM/vcBmJ3/tgza3KrGnCc0WFmRbIgiOPB1jO
         jV4pprcBnqD+5FjrXas56bUDNSu4rk7SFlPxX87Smv32FI/QNSggL+GG+Zo4EvjTkSrF
         skaA==
X-Gm-Message-State: APjAAAU0kRifIReYfdpwMjZK6mvGckMq1CFyFGjqF0GYjNIjaIKFY+p8
        /Q58W0C0JRBoHKtXBGbo/W0=
X-Google-Smtp-Source: APXvYqwiS/rB81iw9YBrF0TFJUziDe1TQrXSMZ4COSYLaJJSbdiihNhGfcJrAEF9RQGi29HbbCoEvQ==
X-Received: by 2002:a17:902:27e6:: with SMTP id i35mr28686773plg.190.1563201470637;
        Mon, 15 Jul 2019 07:37:50 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id s66sm18381852pfs.8.2019.07.15.07.37.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 07:37:49 -0700 (PDT)
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
Subject: [PATCH 9/9] doc: Update documentation about list_for_each_entry_rcu (v1)
Date:   Mon, 15 Jul 2019 10:37:05 -0400
Message-Id: <20190715143705.117908-10-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the documentation with information about
usage of lockdep with list_for_each_entry_rcu().

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 Documentation/RCU/lockdep.txt   | 15 +++++++++++----
 Documentation/RCU/whatisRCU.txt |  9 ++++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index da51d3068850..3d967df3a801 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -96,7 +96,14 @@ other flavors of rcu_dereference().  On the other hand, it is illegal
 to use rcu_dereference_protected() if either the RCU-protected pointer
 or the RCU-protected data that it points to can change concurrently.
 
-There are currently only "universal" versions of the rcu_assign_pointer()
-and RCU list-/tree-traversal primitives, which do not (yet) check for
-being in an RCU read-side critical section.  In the future, separate
-versions of these primitives might be created.
+Similar to rcu_dereference_protected, The RCU list and hlist traversal
+primitives also check for whether there are called from within a reader
+section. However, an optional lockdep expression can be passed to them as
+the last argument in case they are called under other non-RCU protection.
+
+For example, the workqueue for_each_pwq() macro is implemented as follows.
+It is safe to call for_each_pwq() outside a reader section but under protection
+of wq->mutex:
+#define for_each_pwq(pwq, wq)
+	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,
+				lock_is_held(&(wq->mutex).dep_map))
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 7e1a8721637a..00fe77ede1e2 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -290,7 +290,7 @@ rcu_dereference()
 	at any time, including immediately after the rcu_dereference().
 	And, again like rcu_assign_pointer(), rcu_dereference() is
 	typically used indirectly, via the _rcu list-manipulation
-	primitives, such as list_for_each_entry_rcu().
+	primitives, such as list_for_each_entry_rcu() [2].
 
 	[1] The variant rcu_dereference_protected() can be used outside
 	of an RCU read-side critical section as long as the usage is
@@ -305,6 +305,13 @@ rcu_dereference()
 	a lockdep splat is emitted.  See RCU/Design/Requirements/Requirements.html
 	and the API's code comments for more details and example usage.
 
+	[2] In case the list_for_each_entry_rcu() primitive is intended
+	to be used outside of an RCU reader section such as when
+	protected by a lock, then an additional lockdep expression can be
+	passed as the last argument to it so that RCU lockdep checking code
+	knows that the dereference of the list pointers are safe. If the
+	indicated protection is not provided, a lockdep splat is emitted.
+
 The following diagram shows how each API communicates among the
 reader, updater, and reclaimer.
 
-- 
2.22.0.510.g264f2c817a-goog

