Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB94604A53
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJSPDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiJSPCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:02:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8F9161FD4;
        Wed, 19 Oct 2022 07:57:25 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666191362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zkI+7kE11pEfvJZCSjIsOIHfnjIhjBs6goKb/AUL2D4=;
        b=YYO7v04TmKSkEL8SQfYf9FANh400BpV31ZQR/trpNhqYtbMsqHy7XZuAyWZcYguh+KTZKz
        uMkqVYF2Idk8ssJy6cSwkhJih5dltGrVFm3Z7MoL7Nhtw4GkmZEKblfArE1vVoKGDs5p81
        WHY9OAlLqzr8G07YBDVNtY0AT4QClPosfQAXC7SCLUuMtHyHR5c2LCkNDByg36nTiuRcRN
        AVWPIk+/COT66KSdFzs7sxleUpL2onRYs8JoVdAMBeDCEkOf8Yvmkp92DVD8xjN57OewPI
        lAF6m3iPq5588431gmChW8+srrThoCLrEllt8f0GsYtka8ApK0mxiWi8JG1KQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666191362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zkI+7kE11pEfvJZCSjIsOIHfnjIhjBs6goKb/AUL2D4=;
        b=taXn8qnVlav1KthfUzD2BUf7770pohYL/ecGjx8VGuNp3NOcr/dyz4UXH5Ok4L9J1BRVse
        cqmXXqp/T3jlr9Bg==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-um@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>,
        linux-efi@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        linuxppc-dev@lists.ozlabs.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-usb@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Helge Deller <deller@gmx.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>, Tom Rix <trix@redhat.com>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH printk v2 00/38] reduce console_lock scope
Date:   Wed, 19 Oct 2022 17:01:22 +0206
Message-Id: <20221019145600.1282823-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,INVALID_DATE_TZ_ABSURD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is v2 of a series to prepare for threaded/atomic
printing. It is a rework of patches 6-12 of the v1 [0]. From
the v1, patches 1-5 are already mainline and a rework of
patches >12 will be posted in a later series.

This series focuses on reducing the scope of the BKL
console_lock. It achieves this by switching to SRCU and a
dedicated mutex for console list iteration and modification,
respectively. The console_lock will no longer offer this
protection and is completely removed from
(un)register_console() and console_stop/start() code.

All users of the console_lock for list iteration have been
modified. For the call sites where the console_lock is still
needed (because of other reasons), I added comments to explain
exactly why the console_lock was needed.

The base commit for this series is from Paul McKenney's RCU tree
and provides an NMI-safe SRCU implementation [1]. Without the
NMI-safe SRCU implementation, this series is not less safe than
mainline. But we will need the NMI-safe SRCU implementation for
atomic consoles anyway, so we might as well get it in
now. Especially since it _does_ increase the reliability for
mainline in the panic path.

Changes since v2:

general:

- introduce console_is_enabled() to document safe data race on
  console->flags

- switch all "console->flags & CON_ENABLED" code sites to
  console_is_enabled()

- add "for_each_console_srcu" to .clang-format

- cleanup/clarify comments relating to console_lock
  coverage/usage

um:

- kmsg_dumper: use srcu instead of console_lock for list
  iteration

kgdb/kdb:

- configure_kgdboc: keep console_lock for console->device()
  synchronization, use srcu for list iteration

- kgdboc_earlycon_pre_exp_handler: use srcu instead of
  documenting unsafety for list iteration

- kgdboc_earlycon_init: use console_list_lock instead of
  console_lock to lock list

- kdb_msg_write: use srcu instead of documenting unsafety for
  list iteration

tty:

- show_cons_active: keep console_lock for console->device()
  synchronization

fbdev:

- xen-fbfront: xenfb_probe: use srcu instead of console_lock
  for list iteration, introduce console_force_preferred() to
  safely implement hack

proc/consoles:

- show_console_dev: keep console_lock for console->device()
  synchronization

- c_next: use hlist_entry_safe() instead of
  hlist_for_each_entry_continue()

printk:

- remove console_lock from console_stop/start() and
  (un)register_console()

- introduce console_srcu_read_(un)lock() to wrap scru read
  (un)lock

- rename cons_first() macro to console_first()

- for_each_console: add lockdep check instead of introducing
  new for_each_registered_console()

- console_list_lock: add warning if in read-side critical
  section

- release srcu read lock on handover

- console_flush_all: use srcu instead of relying on console
  lock for list iteration

- console_unblank: use srcu instead of relying on console_lock
  for list iteration

- console_flush_on_panic: use srcu for list iteration and
  document console->seq race

- device: keep console_lock for console->device()
  synchronization, usr srcu for list iteration

- register_console: split list adding logic into the 3 distinct
  scenarios

- register_console: set initial sequence number before adding
  to list

- unregister_console: fix ENODEV return value if the console is
  not registered

- console_stop: synchronize srcu

- printk_late_init: use _safe variant of iteration

- __pr_flush: use srcu instead of relying on console_lock for
  list iteration

John Ogness

[0] https://lore.kernel.org/r/20220924000454.3319186-1-john.ogness@linutronix.de
[1] https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/log/?h=srcunmisafe.2022.10.18b

John Ogness (37):
  printk: Convert console_drivers list to hlist
  printk: Prepare for SRCU console list protection
  printk: introduce console_is_enabled() wrapper
  printk: use console_is_enabled()
  tty: nfcon: use console_is_enabled()
  um: kmsg_dump: use console_is_enabled()
  efi: earlycon: use console_is_enabled()
  netconsole: use console_is_enabled()
  tty: hvc: use console_is_enabled()
  tty: serial: earlycon: use console_is_enabled()
  tty: serial: kgdboc: use console_is_enabled()
  tty: serial: pic32_uart: use console_is_enabled()
  tty: serial: samsung_tty: use console_is_enabled()
  tty: serial: serial_core: use console_is_enabled()
  tty: serial: xilinx_uartps: use console_is_enabled()
  tty: tty_io: use console_is_enabled()
  usb: early: xhci-dbc: use console_is_enabled()
  kdb: kdb_io: use console_is_enabled()
  um: kmsg_dumper: use srcu console list iterator
  serial: kgdboc: use srcu console list iterator
  serial: kgdboc: document console_lock usage
  tty: tty_io: document console_lock usage
  xen: fbfront: use srcu console list iterator
  proc: consoles: document console_lock usage
  kdb: use srcu console list iterator
  printk: console_flush_all: use srcu console list iterator
  printk: console_unblank: use srcu console list iterator
  printk: console_flush_on_panic: use srcu console list iterator
  printk: console_device: use srcu console list iterator
  printk: register_console: use srcu console list iterator
  printk: __pr_flush: use srcu console list iterator
  printk: introduce console_list_lock
  serial: kgdboc: use console_list_lock instead of console_lock
  tty: tty_io: use console_list_lock for list synchronization
  proc: consoles: use console_list_lock for list iteration
  printk: relieve console_lock of list synchronization duties
  printk, xen: fbfront: create/use safe function for forcing preferred

Thomas Gleixner (1):
  serial: kgdboc: Lock console list in probe function

 .clang-format                      |   1 +
 arch/m68k/emu/nfcon.c              |   4 +-
 arch/um/kernel/kmsg_dump.c         |  15 +-
 drivers/firmware/efi/earlycon.c    |   4 +-
 drivers/net/netconsole.c           |   4 +-
 drivers/tty/hvc/hvc_console.c      |   2 +-
 drivers/tty/serial/earlycon.c      |   4 +-
 drivers/tty/serial/kgdboc.c        |  37 ++-
 drivers/tty/serial/pic32_uart.c    |   2 +-
 drivers/tty/serial/samsung_tty.c   |   2 +-
 drivers/tty/serial/serial_core.c   |   2 +-
 drivers/tty/serial/xilinx_uartps.c |   2 +-
 drivers/tty/tty_io.c               |  18 +-
 drivers/usb/early/xhci-dbc.c       |   2 +-
 drivers/video/fbdev/xen-fbfront.c  |  16 +-
 fs/proc/consoles.c                 |  20 +-
 include/linux/console.h            |  75 +++++-
 include/linux/serial_core.h        |   2 +-
 kernel/debug/kdb/kdb_io.c          |   7 +-
 kernel/printk/printk.c             | 373 +++++++++++++++++++++--------
 20 files changed, 438 insertions(+), 154 deletions(-)


base-commit: c2d158a284abd63d727dad7402a2eed650dd4233
-- 
2.30.2

