Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C254218CAAE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgCTJtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:49:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35047 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgCTJtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:49:25 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jFEH3-0000vL-DT; Fri, 20 Mar 2020 10:49:05 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     tglx@linutronix.de
Cc:     arnd@arndb.de, balbi@kernel.org, bhelgaas@google.com,
        bigeasy@linutronix.de, dave@stgolabs.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Michal Simek <monstr@monstr.eu>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH 5/5] microblaze: Remove mm.h from asm/uaccess.h
Date:   Fri, 20 Mar 2020 10:48:56 +0100
Message-Id: <20200320094856.3453859-6-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200320094856.3453859-1-bigeasy@linutronix.de>
References: <20200318204408.010461877@linutronix.de>
 <20200320094856.3453859-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The defconfig compiles without linux/mm.h. With mm.h included the
include chain leands to:
|   CC      kernel/locking/percpu-rwsem.o
| In file included from include/linux/huge_mm.h:8,
|                  from include/linux/mm.h:567,
|                  from arch/microblaze/include/asm/uaccess.h:,
|                  from include/linux/uaccess.h:11,
|                  from include/linux/sched/task.h:11,
|                  from include/linux/sched/signal.h:9,
|                  from include/linux/rcuwait.h:6,
|                  from include/linux/percpu-rwsem.h:8,
|                  from kernel/locking/percpu-rwsem.c:6:
| include/linux/fs.h:1422:29: error: array type has incomplete element type=
 'struct percpu_rw_semaphore'
|  1422 |  struct percpu_rw_semaphore rw_sem[SB_FREEZE_LEVELS];

once rcuwait.h includes linux/sched/signal.h.

Remove the linux/mm.h include.

Cc: Michal Simek <monstr@monstr.eu>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/microblaze/include/asm/uaccess.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/includ=
e/asm/uaccess.h
index a1f206b90753a..4916d5fbea5e3 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -12,7 +12,6 @@
 #define _ASM_MICROBLAZE_UACCESS_H
=20
 #include <linux/kernel.h>
-#include <linux/mm.h>
=20
 #include <asm/mmu.h>
 #include <asm/page.h>
--=20
2.26.0.rc2

