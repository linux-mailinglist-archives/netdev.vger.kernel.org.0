Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD39D6900D9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBIHOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjBIHOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:14:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C9942DC2;
        Wed,  8 Feb 2023 23:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=hOwPtrFr9W1RAetj4yw8lS4WGxzVY9WeB5xiD+rtLZk=; b=YzYv5Lu+GhnsQWcrh/P3dNn99Y
        kFFn/VTStVzrVt7izdrqqcFl3XXWJTiUSU7zkMNSHLZccvHB/fdFfsSF2G3d9l6tM8mZkGWrqFoL+
        zV70haeTAUkVk/rmntIAjBbeTETDQ9gynZkiS5FkcxD5ysQrDwctOiqgUEqy0Xc8jqVEGJ0uWfK0f
        t2HqZ/A6Oxx0EJl+SAADCmwyxjMuktOo75CIMUWNmk83r+Z+8eyEK1uwZEhembDTSx9i7ostc00tO
        /jouGLzfxYzc3+YcINRJIpim6ul86T5PcNwp2g7wUJajkYggQ+pjUyATSgrXOBG/P/NTAUzC9nrO4
        AJo7w9JQ==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQ189-000LPt-4s; Thu, 09 Feb 2023 07:14:05 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, keyrings@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        openrisc@lists.librecores.org,
        linux-arm-kernel@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org
Subject: [PATCH 00/24 v2] Documentation: correct lots of spelling errors (series 1)
Date:   Wed,  8 Feb 2023 23:13:36 -0800
Message-Id: <20230209071400.31476-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct many spelling errors in Documentation/ as reported by codespell.

Maintainers of specific kernel subsystems are only Cc-ed on their
respective patches, not the entire series.

These patches are based on linux-next-20230209.


 [PATCH 01/24] Documentation: arm: correct spelling
 [PATCH 02/24] Documentation: block: correct spelling
 [PATCH 03/24] Documentation: core-api: correct spelling
 [PATCH 04/24] Documentation: fault-injection: correct spelling
 [PATCH 05/24] Documentation: fb: correct spelling
 [PATCH 06/24] Documentation: features: correct spelling
 [PATCH 07/24] Documentation: input: correct spelling
 [PATCH 08/24] Documentation: isdn: correct spelling
 [PATCH 09/24] Documentation: livepatch: correct spelling
 [PATCH 10/24] Documentation: locking: correct spelling
 [PATCH 11/24] Documentation: mm: correct spelling
 [PATCH 12/24] Documentation: openrisc: correct spelling
 [PATCH 13/24] Documentation: PCI: correct spelling
 [PATCH 14/24] Documentation: powerpc: correct spelling
 [PATCH 15/24] Documentation: s390: correct spelling
 [PATCH 16/24] Documentation: scheduler: correct spelling
 [PATCH 17/24] Documentation: security: correct spelling
 [PATCH 18/24] Documentation: timers: correct spelling
 [PATCH 19/24] Documentation: tools/rtla: correct spelling
 [PATCH 20/24] Documentation: trace/rv: correct spelling
 [PATCH 21/24] Documentation: trace: correct spelling
 [PATCH 22/24] Documentation: w1: correct spelling
 [PATCH 23/24] Documentation: x86: correct spelling
 [PATCH 24/24] Documentation: xtensa: correct spelling


diffstat:
 Documentation/PCI/endpoint/pci-vntb-howto.rst                    |    2 +-
 Documentation/PCI/msi-howto.rst                                  |    2 +-
 Documentation/arm/arm.rst                                        |    2 +-
 Documentation/arm/ixp4xx.rst                                     |    4 ++--
 Documentation/arm/keystone/knav-qmss.rst                         |    2 +-
 Documentation/arm/stm32/stm32-dma-mdma-chaining.rst              |    6 +++---
 Documentation/arm/sunxi/clocks.rst                               |    2 +-
 Documentation/arm/swp_emulation.rst                              |    2 +-
 Documentation/arm/tcm.rst                                        |    2 +-
 Documentation/arm/vlocks.rst                                     |    2 +-
 Documentation/block/data-integrity.rst                           |    2 +-
 Documentation/core-api/packing.rst                               |    2 +-
 Documentation/core-api/padata.rst                                |    2 +-
 Documentation/fault-injection/fault-injection.rst                |    2 +-
 Documentation/fb/sm712fb.rst                                     |    2 +-
 Documentation/fb/sstfb.rst                                       |    2 +-
 Documentation/features/core/thread-info-in-task/arch-support.txt |    2 +-
 Documentation/input/devices/iforce-protocol.rst                  |    2 +-
 Documentation/input/multi-touch-protocol.rst                     |    2 +-
 Documentation/isdn/interface_capi.rst                            |    2 +-
 Documentation/isdn/m_isdn.rst                                    |    2 +-
 Documentation/livepatch/reliable-stacktrace.rst                  |    2 +-
 Documentation/locking/lockdep-design.rst                         |    4 ++--
 Documentation/locking/locktorture.rst                            |    2 +-
 Documentation/locking/locktypes.rst                              |    2 +-
 Documentation/locking/preempt-locking.rst                        |    2 +-
 Documentation/mm/hmm.rst                                         |    4 ++--
 Documentation/mm/hwpoison.rst                                    |    2 +-
 Documentation/openrisc/openrisc_port.rst                         |    4 ++--
 Documentation/power/suspend-and-interrupts.rst                   |    2 +-
 Documentation/powerpc/kasan.txt                                  |    2 +-
 Documentation/powerpc/papr_hcalls.rst                            |    2 +-
 Documentation/powerpc/qe_firmware.rst                            |    4 ++--
 Documentation/powerpc/vas-api.rst                                |    4 ++--
 Documentation/s390/pci.rst                                       |    4 ++--
 Documentation/s390/vfio-ccw.rst                                  |    2 +-
 Documentation/scheduler/sched-bwc.rst                            |    2 +-
 Documentation/scheduler/sched-energy.rst                         |    4 ++--
 Documentation/security/digsig.rst                                |    4 ++--
 Documentation/security/keys/core.rst                             |    2 +-
 Documentation/security/secrets/coco.rst                          |    2 +-
 Documentation/timers/hrtimers.rst                                |    2 +-
 Documentation/tools/rtla/rtla-timerlat-top.rst                   |    2 +-
 Documentation/trace/coresight/coresight-etm4x-reference.rst      |    2 +-
 Documentation/trace/events.rst                                   |    6 +++---
 Documentation/trace/fprobe.rst                                   |    2 +-
 Documentation/trace/ftrace-uses.rst                              |    2 +-
 Documentation/trace/hwlat_detector.rst                           |    2 +-
 Documentation/trace/rv/runtime-verification.rst                  |    2 +-
 Documentation/trace/uprobetracer.rst                             |    2 +-
 Documentation/w1/w1-netlink.rst                                  |    2 +-
 Documentation/x86/boot.rst                                       |    2 +-
 Documentation/x86/buslock.rst                                    |    2 +-
 Documentation/x86/mds.rst                                        |    2 +-
 Documentation/x86/resctrl.rst                                    |    2 +-
 Documentation/x86/sgx.rst                                        |    2 +-
 Documentation/xtensa/atomctl.rst                                 |    2 +-
 57 files changed, 70 insertions(+), 70 deletions(-)


Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Helge Deller <deller@gmx.de>
?Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>

Cc: coresight@lists.linaro.org
Cc: dri-devel@lists.freedesktop.org
Cc: keyrings@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-input@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-sgx@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: live-patching@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: openrisc@lists.librecores.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-xtensa@linux-xtensa.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: x86@kernel.org
