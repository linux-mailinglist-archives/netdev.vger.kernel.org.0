Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6666264
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 01:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfGKXoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 19:44:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46467 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbfGKXoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 19:44:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id c73so3448835pfb.13
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 16:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tghsUW8vZE4uu9yXB3UzdXY9yotoHS+3md0iqX4wNrc=;
        b=CNNjweAsrPvkDGMoc+Bl+izOV7h5rnwQiW5+Qq/Rcn6ALDGWghfqH0nMSbAeMYrkM3
         /J4tlfNNWxLzUUkUKEp92qZboOdyapuZ2tNTxJAxNF/w1Fu6FzqjLGB2pNaL8BS+RrH5
         Dd+Ya7ZpvGKyq0zNFBJG83LhPAEugUpO1kKJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tghsUW8vZE4uu9yXB3UzdXY9yotoHS+3md0iqX4wNrc=;
        b=nd0PBprDoe8O6bIJ9yWIkIsMFxUo1Mi9GHvUeF59RwSAVrOK8LbztI6pe65QxqNP/A
         2anb+XZpS6Q2eeeM5OzAyvctQ73Jt7ExBMs2ZusSKA0xSY71E53qE2slkRrmOwm1jr/G
         1iOpbaF57tlVWZta4wLBNoP9IKVK6LRRLATNi6HU09APBjd1QdTqclT8iki2kjQqQ6oK
         dT7gPjaKy7nSVVtQTPfJ+p1/tlqUyYgWQEPoMv0QNqYaJLcSRavAnVGInD2UKw95fxRv
         uh1Vxz6Cbd+eggJrXusSJM76jWOPUcnBLslbXDCB7/6GmKDS00DaDFdqmCDh66AQ3UPx
         Pm4w==
X-Gm-Message-State: APjAAAXk8cF0P9eBzfrSL1ZoO6YPBgBETJ0Q5lRYtSOS2d7ff7KQ9wCE
        cyVH1sUKFBxHwUT9AH2ZhOo=
X-Google-Smtp-Source: APXvYqyOaV5WjXgkTT8tKpfQzhT/+VO/P+nGJFfag5j+wibGuibka3Txc0o6Ppycfqb6JVTltTTnQQ==
X-Received: by 2002:a63:89c7:: with SMTP id v190mr6903311pgd.299.1562888654760;
        Thu, 11 Jul 2019 16:44:14 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id t10sm6163450pjr.13.2019.07.11.16.44.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 16:44:13 -0700 (PDT)
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
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v1 0/6] Harden list_for_each_entry_rcu() and family
Date:   Thu, 11 Jul 2019 19:43:55 -0400
Message-Id: <20190711234401.220336-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This series aims to provide lockdep checking to RCU list macros.

RCU has a number of primitives for "consumption" of an RCU protected pointer.
Most of the time, these consumers make sure that such accesses are under a RCU
reader-section (such as rcu_dereference{,sched,bh} or under a lock, such as
with rcu_dereference_protected()).

However, there are other ways to consume RCU pointers, such as by
list_for_each_entry_rcu or hlist_for_each_enry_rcu. Unlike the rcu_dereference
family, these consumers do no lockdep checking at all. And with the growing
number of RCU list uses (1000+), it is possible for bugs to creep in and go
unnoticed which lockdep checks can catch.

Since RCU consolidation efforts last year, the different traditional RCU
flavors (preempt, bh, sched) are all consolidated. In other words, any of these
flavors can cause a reader section to occur and all of them must cease before
the reader section is considered to be unlocked. Thanks to this, we can
generically check if we are in an RCU reader. This is what patch 1 does. Note
that the list_for_each_entry_rcu and family are different from the
rcu_dereference family in that, there is no _bh or _sched version of this
macro. They are used under many different RCU reader flavors, and also SRCU.
Patch 1 adds a new internal function rcu_read_lock_any_held() which checks
if any reader section is active at all, when these macros are called. If no
reader section exists, then the optional fourth argument to
list_for_each_entry_rcu() can be a lockdep expression which is evaluated
(similar to how rcu_dereference_check() works). If no lockdep expression is
passed, and we are not in a reader, then a splat occurs. Just take off the
lockdep expression after applying the patches, by using the following diff and
see what happens:

+++ b/arch/x86/pci/mmconfig-shared.c
@@ -55,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
        struct pci_mmcfg_region *cfg;

        /* keep list sorted by segment and starting bus number */
-       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
+       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {


The optional argument trick to list_for_each_entry_rcu() can also be used in
the future to possibly remove rcu_dereference_{,bh,sched}_protected() API and
we can pass an optional lockdep expression to rcu_dereference() itself. Thus
eliminating 3 more RCU APIs.

Note that some list macro wrappers already do their own lockdep checking in the
caller side. These can be eliminated in favor of the built-in lockdep checking
in the list macro that this series adds. For example, workqueue code has a
assert_rcu_or_wq_mutex() function which is called in for_each_wq().  This
series replaces that in favor of the built-in check.

Also in the future, we can extend these checks to list_entry_rcu() and other
list macros as well, if needed.

Joel Fernandes (Google) (6):
rcu: Add support for consolidated-RCU reader checking
ipv4: add lockdep condition to fix for_each_entry
driver/core: Convert to use built-in RCU list checking
workqueue: Convert for_each_wq to use built-in list check
x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator
acpi: Use built-in RCU list checking for acpi_ioremaps list

arch/x86/pci/mmconfig-shared.c |  5 +++--
drivers/acpi/osl.c             |  6 ++++--
drivers/base/base.h            |  1 +
drivers/base/core.c            | 10 ++++++++++
drivers/base/power/runtime.c   | 15 ++++++++++-----
include/linux/rculist.h        | 29 ++++++++++++++++++++++++-----
include/linux/rcupdate.h       |  7 +++++++
kernel/rcu/Kconfig.debug       | 11 +++++++++++
kernel/rcu/update.c            | 26 ++++++++++++++++++++++++++
kernel/workqueue.c             |  5 ++---
net/ipv4/fib_frontend.c        |  3 ++-
11 files changed, 100 insertions(+), 18 deletions(-)

--
2.22.0.410.gd8fdbe21b5-goog

