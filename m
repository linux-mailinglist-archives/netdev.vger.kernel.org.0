Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA4F673A7
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfGLRAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:00:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41807 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfGLRAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:00:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so5020636pls.8
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4R73ECcFsgEJ+nDrVGaF7lXHe3UNCLl3CB9t/q9lNT4=;
        b=QUdJPbnULiAaQGPSi2mqi0K5L8ZUkC7IX+RSaHrjNxvLiFWoKFYBoo/oGR4kaJ+If5
         H+hJo/HgYMGa2Q0AVqNqfSZ4wCuzsyweIdbuCBwCruxs20caVT8lckLIacvRNFQKWd4U
         5aEnPHEBflrCxzDnwhzGkmd+pAsgTBSfog6z8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4R73ECcFsgEJ+nDrVGaF7lXHe3UNCLl3CB9t/q9lNT4=;
        b=chCPhrMm9B1wzmqGMzA2+ZTJlKsodjCmi8+DjVIugebrjdk3LLkb+K1kRgU9UvUJuO
         tN8+jdJuZGmeoIp3dkhbTCAWcyRsg222+mMGTfDyx0QxYzOHwgsmJvpR+5eJStY3uTXo
         jpmjLdA/xfd6sQz4fnq9cFNjv60tfpEictWHh07Mx9mJZGdoqMlfScFn/P0uBVA7KUbj
         XceejdUKTuUzvAkNzhzE+WhZ/uhNxZVeug/nPL0SD8QPzVN1+XYQrrBeWBb6T/N5FUfW
         h5W3JQWL2QRPpZLXT50iVi6mmLXW8O/YbWrdTczi0fAzr/FpfirZ/tasgRBAyB2iMJ8h
         bd8A==
X-Gm-Message-State: APjAAAV6gIqwlgecYno3V0slMP+QfLeGX7jwr1OtVcEOVt8gb+nXVqTn
        HYRID1/WiEWSIyClCdPDJ+0=
X-Google-Smtp-Source: APXvYqy/IfEk1KCS4o5ZDngZgPwSlK051hwLHg+0U99vqOwQGBX28IMyNjvCo8ritYeQERfyu/T2Kw==
X-Received: by 2002:a17:902:296a:: with SMTP id g97mr12356829plb.115.1562950833539;
        Fri, 12 Jul 2019 10:00:33 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id a15sm7127385pgw.3.2019.07.12.10.00.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 10:00:32 -0700 (PDT)
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
Subject: [PATCH v2 0/9] Harden list_for_each_entry_rcu() and family
Date:   Fri, 12 Jul 2019 13:00:15 -0400
Message-Id: <20190712170024.111093-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This series aims to provide lockdep checking to RCU list macros for additional
kernel hardening.

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

Please note that I have kept this option default-disabled under a new config:
CONFIG_PROVE_RCU_LIST. This is so that until all users are converted to pass
the optional argument, we should keep the check disabled. There are about a
1000 or so users and it is not possible to pass in the optional lockdep
expression in a single series since it is done on a case-by-case basis. I did
convert a few users in this series itself.



v1->v2: Have assert_rcu_or_wq_mutex deleted (Daniel Jordan)
	Simplify rcu_read_lock_any_held()   (Peter Zijlstra)
	Simplified rcu-sync logic	    (Oleg Nesterov)
	Updated documentation and rculist comments.
	Added GregKH ack.

RFC->v1: 
	Simplify list checking macro (Rasmus Villemoes)

Joel Fernandes (Google) (9):
rcu/update: Remove useless check for debug_locks
rcu: Add support for consolidated-RCU reader checking
rcu/sync: Remove custom check for reader-section
ipv4: add lockdep condition to fix for_each_entry
driver/core: Convert to use built-in RCU list checking
workqueue: Convert for_each_wq to use built-in list check
x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator
acpi: Use built-in RCU list checking for acpi_ioremaps list
doc: Update documentation about list_for_each_entry_rcu

Documentation/RCU/lockdep.txt   | 15 +++++++++++----
Documentation/RCU/whatisRCU.txt |  9 ++++++++-
arch/x86/pci/mmconfig-shared.c  |  5 +++--
drivers/acpi/osl.c              |  6 ++++--
drivers/base/base.h             |  1 +
drivers/base/core.c             | 10 ++++++++++
drivers/base/power/runtime.c    | 15 ++++++++++-----
include/linux/rcu_sync.h        |  5 ++---
include/linux/rculist.h         | 28 +++++++++++++++++++++++-----
include/linux/rcupdate.h        |  7 +++++++
kernel/rcu/Kconfig.debug        | 11 +++++++++++
kernel/rcu/sync.c               | 22 ----------------------
kernel/rcu/update.c             | 20 +++++++++++++++-----
kernel/workqueue.c              | 10 ++--------
net/ipv4/fib_frontend.c         |  3 ++-
15 files changed, 109 insertions(+), 58 deletions(-)

--
2.22.0.510.g264f2c817a-goog

