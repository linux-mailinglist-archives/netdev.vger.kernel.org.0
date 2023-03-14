Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60446B92EF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjCNMNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjCNMN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:13:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E540F366A1;
        Tue, 14 Mar 2023 05:12:48 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EAlCe4030805;
        Tue, 14 Mar 2023 12:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=mPi3LbgQuSNYexgoT3hcnbR4oQlZpn8EZ58m3tFgNsU=;
 b=K7W+DE/oObKFXxJzypRN+jpOB49GGCtJ3WJEvnFdNyijVBC7rGx80PKEr1mhm1xnDTC5
 fZSxEi6D/KhodMHecdpWn4BTYX3Nra+S4xdvgHhL1M+ruv4SFnMVLiDuILgxMoYjlz/l
 HVy3R5yjJy5ocqHv92TNYPHjMA7UcIlBWjrVWmgl/o2m7qZ2vyi0hS60m5IruHsgTPBA
 axv0nPhrHh7W5OqARzSlojIw0eR6f0k1/HRF0KRr/T1ueYkmP/+tL6CHysXv3ivnankj
 vWkImdKZna3PDDcNpebGxTcybcbdvT7HWEWruZ0nilgOhCa27iNOtV3Wb2+05/4oyAIZ 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3paqftj4xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 12:12:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32ECCLZP009325;
        Tue, 14 Mar 2023 12:12:21 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3paqftj4wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 12:12:21 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E9I2SS019091;
        Tue, 14 Mar 2023 12:12:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3p8h96kru9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 12:12:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32ECCHRL24904420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 12:12:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE682007C;
        Tue, 14 Mar 2023 12:12:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDBE42007A;
        Tue, 14 Mar 2023 12:12:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 12:12:16 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH v3 00/38] Kconfig: Introduce HAS_IOPORT config option
Date:   Tue, 14 Mar 2023 13:11:38 +0100
Message-Id: <20230314121216.413434-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NpNJ26LxVNFi9mX-gt0mikwNUv5Ciqfn
X-Proofpoint-GUID: 2zSpA9rfjwQ1RiokepIA4tCq0vfAZ5G5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_04,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Kernel Hackers,

Some platforms such as s390 do not support PCI I/O spaces. On such platforms
I/O space accessors like inb()/outb() are stubs that can never actually work.
The way these stubs are implemented in asm-generic/io.h leads to compiler
warnings because any use will be a NULL pointer access on these platforms. In
a previous patch we tried handling this with a run-time warning on access. This
approach however was rejected by Linus[0] with the argument that this really
should be a compile-time check and, though a much more invasive change, we
believe that is indeed the right approach.

This patch series aims to do exactly that by introducing a HAS_IOPORT config
option akin to the existing HAS_IOMEM. When this is unset inb()/outb() and
friends may not be defined. This is also the same approach originally planned by
Uwe Kleine-König as mentioned in commit ce816fa88cca ("Kconfig: rename
HAS_IOPORT to HAS_IOPORT_MAP").

This series builds heavily on an original patch for demonstating the concept by
Arnd Bergmann[1] and incoporates feedback of previous RFC versions [2] and [3].

This version is based on v6.3-rc1 and is also available on my kernel.org tree
in the has_ioport_v3 branch with the PGP signed tag has_ioport_v3_signed:

https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git

Thanks,
Niklas Schnelle

Changes from RFC v2:
- Rebased on v6.3-rc1
- Fixed a NULL pointer dereference in set_io_from_upio() due to accidentially
  expanded #ifdef CONFIG_SERIAL_8250_RT288X (kernel test robot)
- Dropped "ACPI: add dependency on HAS_IOPORT" (Bjorn Helgaas)
- Reworded commit message and moved ifdefs for "PCI/sysfs: Make I/O resource
  depend on HAS_IOPORT" (Bjorn Helgaas)
- Instead of complete removal inb() etc. are marked with __compiletime_error()
  when HAS_IOPORT is unset allowing for better error reporting (Ahmad Fatoum)
- Removed HAS_IOPORT dependency from PCMCIA as I/O port use is optional in at
  least PC Card. Instead added HAS_IOPORT on a per driver basis. (Bjorn
  Helgaas)
- Made uhci_has_pci_registers() constant 0 if HAS_IOPORT is not defined (Alan
  Stern)

Changes from RFC v1:
- Completely dropped the LEGACY_PCI option and replaced its dependencies with
  HAS_IOPORT as appropriate
- In the usb subsystem patch I incorporated the feedback from v1 by Alan Stern:
  - Used a local macro to nop in*()/out*() in the helpers
  - Removed an unnecessary further restriction on CONFIG_USB_UHCI_HCD
- Added a few more subsystems including wireless, ptp, and, mISDN that I had
  previously missed due to a blanket !S390.
- Removed blanket !S390 dependencies where they are added due to the I/O port
  problem
- In the sound system SND_OPL3_LIB needed to use "depends on" instead of
  "select" because of its added HAS_IOPORT dependency
- In the drm subsystem the bochs driver gets #ifdefs instead of a blanket
  dependency because its MMIO capable device variant should work without
  HAS_IOPORT.

[0] https://lore.kernel.org/lkml/CAHk-=wg80je=K7madF4e7WrRNp37e3qh6y10Svhdc7O8SZ_-8g@mail.gmail.com/
[1] https://lore.kernel.org/lkml/CAK8P3a0MNbx-iuzW_-=0ab6-TTZzwV-PT_6gAC1Gp5PgYyHcrA@mail.gmail.com/
[2] https://yhbt.net/lore/all/20211227164317.4146918-1-schnelle@linux.ibm.com/
[3] https://lore.kernel.org/all/20220429135108.2781579-1-schnelle@linux.ibm.com/

Niklas Schnelle (38):
  Kconfig: introduce HAS_IOPORT option and select it as necessary
  ata: add HAS_IOPORT dependencies
  char: impi, tpm: depend on HAS_IOPORT
  comedi: add HAS_IOPORT dependencies
  counter: add HAS_IOPORT dependencies
  /dev/port: don't compile file operations without CONFIG_DEVPORT
  drm: handle HAS_IOPORT dependencies
  firmware: dmi-sysfs: handle HAS_IOPORT=n
  gpio: add HAS_IOPORT dependencies
  hwmon: add HAS_IOPORT dependencies
  i2c: add HAS_IOPORT dependencies
  iio: ad7606: Kconfig: add HAS_IOPORT dependencies
  Input: add HAS_IOPORT dependencies
  Input: gameport: add ISA and HAS_IOPORT dependencies
  leds: add HAS_IOPORT dependencies
  media: add HAS_IOPORT dependencies
  misc: add HAS_IOPORT dependencies
  mISDN: add HAS_IOPORT dependencies
  mpt fusion: add HAS_IOPORT dependencies
  net: handle HAS_IOPORT dependencies
  parport: PC style parport depends on HAS_IOPORT
  PCI: Make quirk using inw() depend on HAS_IOPORT
  PCI/sysfs: Make I/O resource depend on HAS_IOPORT
  pcmcia: add HAS_IOPORT dependencies
  platform: add HAS_IOPORT dependencies
  pnp: add HAS_IOPORT dependencies
  power: add HAS_IOPORT dependencies
  rtc: add HAS_IOPORT dependencies
  scsi: add HAS_IOPORT dependencies
  sound: add HAS_IOPORT dependencies
  speakup: add HAS_IOPORT dependency for SPEAKUP_SERIALIO
  staging: add HAS_IOPORT dependencies
  tty: serial: handle HAS_IOPORT dependencies
  usb: handle HAS_IOPORT dependencies
  video: handle HAS_IOPORT dependencies
  watchdog: add HAS_IOPORT dependencies
  wireless: add HAS_IOPORT dependencies
  asm-generic/io.h: drop inb() etc for HAS_IOPORT=n

 arch/alpha/Kconfig                           |   1 +
 arch/arm/Kconfig                             |   1 +
 arch/arm64/Kconfig                           |   1 +
 arch/ia64/Kconfig                            |   1 +
 arch/m68k/Kconfig                            |   1 +
 arch/microblaze/Kconfig                      |   1 +
 arch/mips/Kconfig                            |   2 +
 arch/parisc/Kconfig                          |   2 +
 arch/powerpc/Kconfig                         |   2 +-
 arch/riscv/Kconfig                           |   1 +
 arch/sh/Kconfig                              |   1 +
 arch/sparc/Kconfig                           |   1 +
 arch/um/Kconfig                              |   1 +
 arch/x86/Kconfig                             |   2 +
 drivers/accessibility/speakup/Kconfig        |   1 +
 drivers/ata/Kconfig                          |   1 +
 drivers/bus/Kconfig                          |   2 +-
 drivers/char/Kconfig                         |   3 +-
 drivers/char/ipmi/Makefile                   |  11 +-
 drivers/char/ipmi/ipmi_si_intf.c             |   3 +-
 drivers/char/ipmi/ipmi_si_pci.c              |   3 +
 drivers/char/mem.c                           |   6 +-
 drivers/char/pcmcia/Kconfig                  |   8 +-
 drivers/char/tpm/Kconfig                     |   1 +
 drivers/char/tpm/tpm_infineon.c              |  14 ++-
 drivers/char/tpm/tpm_tis_core.c              |  19 ++-
 drivers/comedi/Kconfig                       | 103 +++++++++------
 drivers/counter/Kconfig                      |   1 +
 drivers/eisa/Kconfig                         |   1 +
 drivers/firmware/dmi-sysfs.c                 |   4 +
 drivers/gpio/Kconfig                         |   2 +-
 drivers/gpu/drm/qxl/Kconfig                  |   1 +
 drivers/gpu/drm/tiny/bochs.c                 |  19 +++
 drivers/gpu/drm/tiny/cirrus.c                |   2 +
 drivers/hwmon/Kconfig                        |  21 +++-
 drivers/i2c/busses/Kconfig                   |  31 ++---
 drivers/iio/adc/Kconfig                      |   2 +-
 drivers/input/gameport/Kconfig               |   4 +-
 drivers/input/serio/Kconfig                  |   2 +
 drivers/input/touchscreen/Kconfig            |   1 +
 drivers/isdn/Kconfig                         |   1 -
 drivers/isdn/hardware/mISDN/Kconfig          |  12 +-
 drivers/leds/Kconfig                         |   2 +-
 drivers/media/pci/dm1105/Kconfig             |   2 +-
 drivers/media/radio/Kconfig                  |  14 ++-
 drivers/media/rc/Kconfig                     |   6 +
 drivers/message/fusion/Kconfig               |   2 +-
 drivers/misc/altera-stapl/Makefile           |   3 +-
 drivers/misc/altera-stapl/altera.c           |   6 +-
 drivers/net/Kconfig                          |   2 +-
 drivers/net/arcnet/Kconfig                   |   2 +-
 drivers/net/can/cc770/Kconfig                |   1 +
 drivers/net/can/sja1000/Kconfig              |   1 +
 drivers/net/ethernet/3com/Kconfig            |   4 +-
 drivers/net/ethernet/8390/Kconfig            |   6 +-
 drivers/net/ethernet/amd/Kconfig             |   4 +-
 drivers/net/ethernet/fujitsu/Kconfig         |   2 +-
 drivers/net/ethernet/intel/Kconfig           |   2 +-
 drivers/net/ethernet/sis/Kconfig             |   4 +-
 drivers/net/ethernet/smsc/Kconfig            |   2 +-
 drivers/net/ethernet/ti/Kconfig              |   2 +-
 drivers/net/ethernet/via/Kconfig             |   1 +
 drivers/net/ethernet/xircom/Kconfig          |   2 +-
 drivers/net/fddi/Kconfig                     |   2 +-
 drivers/net/fddi/defxx.c                     |   2 +-
 drivers/net/hamradio/Kconfig                 |   6 +-
 drivers/net/wan/Kconfig                      |   2 +-
 drivers/net/wireless/atmel/Kconfig           |   2 +-
 drivers/net/wireless/intersil/hostap/Kconfig |   2 +-
 drivers/parport/Kconfig                      |   4 +-
 drivers/pci/pci-sysfs.c                      |   4 +
 drivers/pci/quirks.c                         |   2 +
 drivers/pcmcia/Kconfig                       |   5 +-
 drivers/platform/chrome/Kconfig              |   1 +
 drivers/platform/chrome/wilco_ec/Kconfig     |   1 +
 drivers/pnp/isapnp/Kconfig                   |   2 +-
 drivers/power/reset/Kconfig                  |   1 +
 drivers/rtc/Kconfig                          |   4 +-
 drivers/scsi/Kconfig                         |  25 ++--
 drivers/scsi/aic7xxx/Kconfig.aic79xx         |   2 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx         |   2 +-
 drivers/scsi/aic94xx/Kconfig                 |   2 +-
 drivers/scsi/megaraid/Kconfig.megaraid       |   6 +-
 drivers/scsi/mvsas/Kconfig                   |   2 +-
 drivers/scsi/pcmcia/Kconfig                  |   6 +-
 drivers/scsi/qla2xxx/Kconfig                 |   2 +-
 drivers/staging/sm750fb/Kconfig              |   2 +-
 drivers/staging/vt6655/Kconfig               |   2 +-
 drivers/tty/Kconfig                          |   2 +-
 drivers/tty/serial/8250/8250_early.c         |   4 +
 drivers/tty/serial/8250/8250_pci.c           |  14 +++
 drivers/tty/serial/8250/8250_port.c          |  44 +++++--
 drivers/tty/serial/8250/Kconfig              |   5 +-
 drivers/tty/serial/Kconfig                   |   2 +-
 drivers/usb/core/hcd-pci.c                   |   2 +
 drivers/usb/host/Kconfig                     |   4 +-
 drivers/usb/host/pci-quirks.c                | 125 ++++++++++---------
 drivers/usb/host/pci-quirks.h                |  31 +++--
 drivers/usb/host/uhci-hcd.c                  |   2 +-
 drivers/usb/host/uhci-hcd.h                  |  36 ++++--
 drivers/video/console/Kconfig                |   1 +
 drivers/video/fbdev/Kconfig                  |  25 ++--
 drivers/watchdog/Kconfig                     |   6 +-
 include/asm-generic/io.h                     |  60 +++++++++
 include/linux/gameport.h                     |   9 +-
 include/linux/parport.h                      |   2 +-
 include/video/vga.h                          |   8 ++
 lib/Kconfig                                  |   4 +
 lib/Kconfig.kgdb                             |   3 +-
 net/ax25/Kconfig                             |   2 +-
 sound/drivers/Kconfig                        |   3 +
 sound/isa/Kconfig                            |  31 ++++-
 sound/pci/Kconfig                            |  45 +++++--
 sound/pcmcia/Kconfig                         |   2 +
 114 files changed, 649 insertions(+), 281 deletions(-)


base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.37.2

