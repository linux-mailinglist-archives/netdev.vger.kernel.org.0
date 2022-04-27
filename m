Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336375125A9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiD0Wxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiD0Wxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:44 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777658A306;
        Wed, 27 Apr 2022 15:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bd3LEemhVeb7HF/IIMNoiSMnSaTUMrH2fhcorDNVPOw=; b=reO22ihKOd/dWO6JG74IZyl/Fc
        ZRgGILhVwwQGIlc0vj0pe06pAIL0f1YnsjmZwa63b3ABCQ9Dxtfk7lOpgjSlBlW3mvUPOXpeDqCPF
        Rai8aA64fPaaS3uA4lyDgYZD5XuD0ZsHxLRl7fSfIQRGLMJx5CN6hSSRnLDC2sMLyPhnDWIKyd1uN
        dkM7kUYrK18mk3Ol/CnE0I+ZYy1cZnsseboaTczRU6buuvnTvUyLu0/yD31d9xZSykLYiRZ87DJrn
        1QwYj7LfEwisoBpfk6PfijWzaR37ghlKX+i9oyA2xcheBwMVt8x9sPCGngmKdbeGAFrivKg5AfP0H
        0Qh1iRoA==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqTd-0001ws-8P; Thu, 28 Apr 2022 00:49:41 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alex Elder <elder@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Evan Green <evgreen@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        James Morse <james.morse@arm.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Julius Werner <jwerner@chromium.org>,
        Justin Chen <justinpopo6@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Leo Yan <leo.yan@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Richard Henderson <rth@twiddle.net>,
        Richard Weinberger <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Scott Branden <scott.branden@broadcom.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sebastian Reichel <sre@kernel.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 00/30] The panic notifiers refactor
Date:   Wed, 27 Apr 2022 19:48:54 -0300
Message-Id: <20220427224924.592546-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey folks, this is an attempt to improve/refactor the dated panic notifiers
infrastructure. This is strongly based in a suggestion made by Pter Mladek [0]
some time ago, and it's finally ready. Below I'll detail the patch ordering,
testing made, etc.
First, a bit about the reason behind this.

The panic notifiers list is an infrastructure that allows callbacks to execute
during panic time. Happens that anybody can add functions there, no ordering
is enforced (by default) and the decision to execute or not such notifiers
before kdump may lead to high risk of failure in crash scenarios - default is
not to execute any of them. There is a parameter acting as a switch for that.
But some architectures require some notifiers, so..it's messy.

The suggestion from Petr came after a patch submission to add a notifiers
filter, allowing the notifiers selection by function name, which was welcomed
by some people, but not by Petr, which claimed the code should indeed have a
refactor - and it made a lot of sense, his suggestion makes code more clear
and reliable.

So, this series might be split in 3 portions:

Part 1: the first 18 patches are mostly fixes (one or two might be considered
improvements), mostly replacing spinlocks/mutexes with safer alternatives for
atomic contexts, like spin_trylock, etc. We also focused on commenting
everything that is possible and clean-up code.

Part 2, the core: patches 19-25 are the main refactor, which splits the panic
notifiers list in three, introduce the concept of panic notifier level and
clean-up and highly comment the code, effectively leading to a more reliable
and clear, yet highly customizable panic path.

Part 3: The remaining 5 patches are fixes that _require the main refactor_
patches, they don't make sense without the core changes - but again, these are
small fixes and not part of the main goal of refactoring the panic code.

I've tried my best to make the patches the more "bisectable" as possible, so
they tend to be self-contained and easy to backport (specially patches from
part 1). Notice that the series is *based on 5.18-rc4* - usually a refactor
like this would be based on linux-next, but since we have many fixes in the
series, I kept it based on mainline tree. Of course I could change that in a
subsequent iteration, if desired.

Since this touches multiple architectures and drivers, it's very difficult to
test it really (by executing all touched code). So, my tests split in two
approaches: build tests and real tests, that involves panic triggering with
and without kdump, changing panic notifiers level, etc.

Build tests (using cross-compilers): alpha, arm, arm64, mips (sgi 22 and 32),
parisc, s390, sparc, um, x86_64 (couldn't get a functional xtensa cross
compiler).

Real/full tests: x86_64 (Hyper-V and QEMU guests) + PowerPC (pseries guest).

Here is the link with the .config files used: https://people.igalia.com/gpiccoli/panic_notifiers_configs/
(tried my best to build all the affected code).

Finally, a bit about my CCing strategy: I've included everybody present in the
original thread [0] plus some maintainers and other interested parties as CC
in the full series. But the patches have individual CC lists, for people that
are definitely related to them but might not care much for the whole series;
nevertheless, _everybody_ mentioned at least once in some patch is CCed in this
cover-letter. Hopefully I didn't forget to include anybody - all the mailing
lists were CCed in the whole series. Apologies in advance if (a) you received
emails you didn't want to or, (b) I forgot to include you but it was something
considered interesting by you.

Thanks in advance for reviews / comments / suggestions!
Cheers,

Guilherme

[0] https://lore.kernel.org/lkml/YfPxvzSzDLjO5ldp@alley/

Guilherme G. Piccoli (30):
  x86/crash,reboot: Avoid re-disabling VMX in all CPUs on crash/restart
  ARM: kexec: Disable IRQs/FIQs also on crash CPUs shutdown path
  notifier: Add panic notifiers info and purge trailing whitespaces
  firmware: google: Convert regular spinlock into trylock on panic path
  misc/pvpanic: Convert regular spinlock into trylock on panic path
  soc: bcm: brcmstb: Document panic notifier action and remove useless header
  mips: ip22: Reword PANICED to PANICKED and remove useless header
  powerpc/setup: Refactor/untangle panic notifiers
  coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier
  alpha: Clean-up the panic notifier code
  um: Improve panic notifiers consistency and ordering
  parisc: Replace regular spinlock with spin_trylock on panic path
  s390/consoles: Improve panic notifiers reliability
  panic: Properly identify the panic event to the notifiers' callbacks
  bus: brcmstb_gisb: Clean-up panic/die notifiers
  drivers/hv/vmbus, video/hyperv_fb: Untangle and refactor Hyper-V panic notifiers
  tracing: Improve panic/die notifiers
  notifier: Show function names on notifier routines if DEBUG_NOTIFIERS is set
  panic: Add the panic hypervisor notifier list
  panic: Add the panic informational notifier list
  panic: Introduce the panic pre-reboot notifier list
  panic: Introduce the panic post-reboot notifier list
  printk: kmsg_dump: Introduce helper to inform number of dumpers
  panic: Refactor the panic path
  panic, printk: Add console flush parameter and convert panic_print to a notifier
  Drivers: hv: Do not force all panic notifiers to execute before kdump
  powerpc: Do not force all panic notifiers to execute before kdump
  panic: Unexport crash_kexec_post_notifiers
  powerpc: ps3, pseries: Avoid duplicate call to kmsg_dump() on panic
  um: Avoid duplicate call to kmsg_dump()

 .../admin-guide/kernel-parameters.txt         |  54 ++-
 Documentation/admin-guide/sysctl/kernel.rst   |   5 +-
 arch/alpha/kernel/setup.c                     |  40 +--
 arch/arm/kernel/machine_kexec.c               |   3 +
 arch/arm64/kernel/setup.c                     |   2 +-
 arch/mips/kernel/relocate.c                   |   2 +-
 arch/mips/sgi-ip22/ip22-reset.c               |  13 +-
 arch/mips/sgi-ip32/ip32-reset.c               |   3 +-
 arch/parisc/include/asm/pdc.h                 |   1 +
 arch/parisc/kernel/firmware.c                 |  27 +-
 arch/parisc/kernel/pdc_chassis.c              |   3 +-
 arch/powerpc/include/asm/bug.h                |   2 +-
 arch/powerpc/kernel/fadump.c                  |   8 -
 arch/powerpc/kernel/setup-common.c            |  76 ++--
 arch/powerpc/kernel/traps.c                   |   6 +-
 arch/powerpc/platforms/powernv/opal.c         |   2 +-
 arch/powerpc/platforms/ps3/setup.c            |   2 +-
 arch/powerpc/platforms/pseries/setup.c        |   2 +-
 arch/s390/kernel/ipl.c                        |   4 +-
 arch/s390/kernel/setup.c                      |  19 +-
 arch/sparc/kernel/setup_32.c                  |  27 +-
 arch/sparc/kernel/setup_64.c                  |  29 +-
 arch/sparc/kernel/sstate.c                    |   3 +-
 arch/um/drivers/mconsole_kern.c               |  10 +-
 arch/um/kernel/um_arch.c                      |  11 +-
 arch/x86/include/asm/cpu.h                    |   1 +
 arch/x86/kernel/crash.c                       |   8 +-
 arch/x86/kernel/reboot.c                      |  14 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/xen/enlighten.c                      |   2 +-
 arch/xtensa/platforms/iss/setup.c             |   4 +-
 drivers/bus/brcmstb_gisb.c                    |  28 +-
 drivers/char/ipmi/ipmi_msghandler.c           |  12 +-
 drivers/edac/altera_edac.c                    |   3 +-
 drivers/firmware/google/gsmi.c                |  10 +-
 drivers/hv/hv_common.c                        |  12 -
 drivers/hv/vmbus_drv.c                        | 113 +++---
 .../hwtracing/coresight/coresight-cpu-debug.c |  11 +-
 drivers/leds/trigger/ledtrig-activity.c       |   4 +-
 drivers/leds/trigger/ledtrig-heartbeat.c      |   4 +-
 drivers/leds/trigger/ledtrig-panic.c          |   3 +-
 drivers/misc/bcm-vk/bcm_vk_dev.c              |   6 +-
 drivers/misc/ibmasm/heartbeat.c               |  16 +-
 drivers/misc/pvpanic/pvpanic.c                |  14 +-
 drivers/net/ipa/ipa_smp2p.c                   |   5 +-
 drivers/parisc/power.c                        |  21 +-
 drivers/power/reset/ltc2952-poweroff.c        |   4 +-
 drivers/remoteproc/remoteproc_core.c          |   6 +-
 drivers/s390/char/con3215.c                   |  38 +-
 drivers/s390/char/con3270.c                   |  36 +-
 drivers/s390/char/raw3270.c                   |  18 +
 drivers/s390/char/raw3270.h                   |   1 +
 drivers/s390/char/sclp_con.c                  |  30 +-
 drivers/s390/char/sclp_vt220.c                |  44 +--
 drivers/s390/char/zcore.c                     |   5 +-
 drivers/soc/bcm/brcmstb/pm/pm-arm.c           |  18 +-
 drivers/soc/tegra/ari-tegra186.c              |   3 +-
 drivers/staging/olpc_dcon/olpc_dcon.c         |   6 +-
 drivers/video/fbdev/hyperv_fb.c               |  12 +-
 include/linux/console.h                       |   2 +
 include/linux/kmsg_dump.h                     |   7 +
 include/linux/notifier.h                      |   8 +-
 include/linux/panic.h                         |   3 -
 include/linux/panic_notifier.h                |  12 +-
 include/linux/printk.h                        |   1 +
 kernel/hung_task.c                            |   3 +-
 kernel/kexec_core.c                           |   8 +-
 kernel/notifier.c                             |  48 ++-
 kernel/panic.c                                | 335 +++++++++++-------
 kernel/printk/printk.c                        |  76 ++++
 kernel/rcu/tree.c                             |   1 -
 kernel/rcu/tree_stall.h                       |   3 +-
 kernel/trace/trace.c                          |  59 +--
 .../selftests/pstore/pstore_crash_test        |   5 +-
 74 files changed, 953 insertions(+), 486 deletions(-)

-- 
2.36.0

