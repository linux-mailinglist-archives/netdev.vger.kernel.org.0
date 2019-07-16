Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733CC6A863
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbfGPMLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 08:11:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732581AbfGPMLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 08:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cmrXWeKZex18XPtqOqXe6bsYV64AO68iLYgMsiWQPIg=; b=QAAw/LhYE17kHpcrRzOCn1piW
        wDQhBm1yl/KZ+dj8rCQhgNieg+hhttiHCd56p5QhHz5ASeESwhg4e5NnaVU0xFvaS1lhK+pI34VAH
        U07mMZP9tRQ4deiPKcIy4WDiR29u2hCPogiZhF9Lz2jHXns+8RDa0pzAsZAsHJhW3j3YMjCZIm/+P
        LGpxBBG2lEGO3KMHIzygFcSKKg0GHttc1pRY0pbQBDBk7P+UYDrt1y6b2Q/bZPeVAySSZNi95nOXL
        A9MLC1Mv0VfRw8xgU7fIrVDbMile7MGuQFtM0dQbNTrXk9FcF/xI3aZ/c1Bhe5nAJD6JiU0T0som+
        3cGvhJxcQ==;
Received: from [189.27.46.152] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hnMIL-0004hz-Al; Tue, 16 Jul 2019 12:10:57 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hnMII-0000QW-KI; Tue, 16 Jul 2019 09:10:54 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        linuxppc-dev@lists.ozlabs.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, kvm@vger.kernel.org,
        linux-i2c@vger.kernel.org, rcu@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-input@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 00/14] pending doc patches for 5.3-rc
Date:   Tue, 16 Jul 2019 09:10:39 -0300
Message-Id: <cover.1563277838.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those are the pending documentation patches after my pull request
for this branch:

    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git tags/docs/v5.3-1

Patches 1 to 13 were already submitted, but got rebased. Patch 14
is a new fixup one.

Patches 1 and 2 weren't submitted before due to merge conflicts
that are now solved upstream;

Patch 3 fixes a series of random Documentation/* references that
are pointing to the wrong places.

Patch 4 fix a longstanding issue: every time a new book is added,
conf.py need changes, in order to allow generating a PDF file.
After the patch, conf.py will automatically recognize new books,
saving the trouble of keeping adding documents to it.

Patches 5 to 11 are due to fonts support when building translations.pdf.
The main focus is to add xeCJK support. While doing it, I discovered
some bugs at sphinx-pre-install script after running it with 7 different
distributions.

Patch 12 improves support for partial doc building. Currently, each
subdir needs to have its own conf.py, in order to support partial
doc build. After it, any Documentation subdir can be used to 
roduce html/pdf docs with:

	make SPHINXDIRS="foo bar" htmldocs
	(or pdfdocs, latexdocs, epubdocs, ...)

Patch 13 is a cleanup patch: it simply get rid of all those extra
conf.py files that  aren't needed anymore. The only extra config
file after it is this one:

	Documentation/media/conf_nitpick.py

With enables some extra optional Sphinx features.

Patch 14 adds Documentation/virtual to the main index.rst file
and add a new *.rst file that was orphaned there.

-

After this series, there's just one more patch meant to be applied
for 5.3, with is still waiting for some patches to be merged from
linux-next:

    https://git.linuxtv.org/mchehab/experimental.git/commit/?id=b1b5dc7d7bbfbbfdace2a248c6458301c6e34100


Mauro Carvalho Chehab (14):
  docs: powerpc: convert docs to ReST and rename to *.rst
  docs: power: add it to to the main documentation index
  docs: fix broken doc references due to renames
  docs: pdf: add all Documentation/*/index.rst to PDF output
  docs: conf.py: add CJK package needed by translations
  docs: conf.py: only use CJK if the font is available
  scripts/sphinx-pre-install: fix script for RHEL/CentOS
  scripts/sphinx-pre-install: don't use LaTeX with CentOS 7
  scripts/sphinx-pre-install: fix latexmk dependencies
  scripts/sphinx-pre-install: cleanup Gentoo checks
  scripts/sphinx-pre-install: seek for Noto CJK fonts for pdf output
  docs: load_config.py: avoid needing a conf.py just due to LaTeX docs
  docs: remove extra conf.py files
  docs: virtual: add it to the documentation body

 Documentation/PCI/pci-error-recovery.rst      |   5 +-
 Documentation/RCU/rculist_nulls.txt           |   2 +-
 Documentation/admin-guide/conf.py             |  10 --
 Documentation/conf.py                         |  30 +++-
 Documentation/core-api/conf.py                |  10 --
 Documentation/crypto/conf.py                  |  10 --
 Documentation/dev-tools/conf.py               |  10 --
 .../devicetree/bindings/arm/idle-states.txt   |   2 +-
 Documentation/doc-guide/conf.py               |  10 --
 Documentation/driver-api/80211/conf.py        |  10 --
 Documentation/driver-api/conf.py              |  10 --
 Documentation/driver-api/pm/conf.py           |  10 --
 Documentation/filesystems/conf.py             |  10 --
 Documentation/gpu/conf.py                     |  10 --
 Documentation/index.rst                       |   3 +
 Documentation/input/conf.py                   |  10 --
 Documentation/kernel-hacking/conf.py          |  10 --
 Documentation/locking/spinlocks.rst           |   4 +-
 Documentation/maintainer/conf.py              |  10 --
 Documentation/media/conf.py                   |  12 --
 Documentation/memory-barriers.txt             |   2 +-
 Documentation/networking/conf.py              |  10 --
 Documentation/power/index.rst                 |   2 +-
 .../{bootwrapper.txt => bootwrapper.rst}      |  28 +++-
 .../{cpu_families.txt => cpu_families.rst}    |  23 +--
 .../{cpu_features.txt => cpu_features.rst}    |   6 +-
 Documentation/powerpc/{cxl.txt => cxl.rst}    |  46 ++++--
 .../powerpc/{cxlflash.txt => cxlflash.rst}    |  10 +-
 .../{DAWR-POWER9.txt => dawr-power9.rst}      |  15 +-
 Documentation/powerpc/{dscr.txt => dscr.rst}  |  18 +-
 ...ecovery.txt => eeh-pci-error-recovery.rst} | 108 ++++++------
 ...ed-dump.txt => firmware-assisted-dump.rst} | 117 +++++++------
 Documentation/powerpc/{hvcs.txt => hvcs.rst}  | 108 ++++++------
 Documentation/powerpc/index.rst               |  34 ++++
 Documentation/powerpc/isa-versions.rst        |  15 +-
 .../powerpc/{mpc52xx.txt => mpc52xx.rst}      |  12 +-
 ...nv.txt => pci_iov_resource_on_powernv.rst} |  15 +-
 .../powerpc/{pmu-ebb.txt => pmu-ebb.rst}      |   1 +
 Documentation/powerpc/ptrace.rst              | 156 ++++++++++++++++++
 Documentation/powerpc/ptrace.txt              | 151 -----------------
 .../{qe_firmware.txt => qe_firmware.rst}      |  37 +++--
 .../{syscall64-abi.txt => syscall64-abi.rst}  |  29 ++--
 ...al_memory.txt => transactional_memory.rst} |  45 ++---
 Documentation/process/conf.py                 |  10 --
 Documentation/sh/conf.py                      |  10 --
 Documentation/sound/conf.py                   |  10 --
 Documentation/sphinx/load_config.py           |  27 ++-
 .../translations/ko_KR/memory-barriers.txt    |   2 +-
 Documentation/userspace-api/conf.py           |  10 --
 Documentation/virtual/kvm/index.rst           |   1 +
 Documentation/vm/conf.py                      |  10 --
 Documentation/watchdog/hpwdt.rst              |   2 +-
 Documentation/x86/conf.py                     |  10 --
 MAINTAINERS                                   |  14 +-
 arch/powerpc/kernel/exceptions-64s.S          |   2 +-
 drivers/gpu/drm/drm_modes.c                   |   2 +-
 drivers/i2c/busses/i2c-nvidia-gpu.c           |   2 +-
 drivers/scsi/hpsa.c                           |   4 +-
 drivers/soc/fsl/qe/qe.c                       |   2 +-
 drivers/tty/hvc/hvcs.c                        |   2 +-
 include/soc/fsl/qe/qe.h                       |   2 +-
 scripts/sphinx-pre-install                    | 118 ++++++++++---
 62 files changed, 738 insertions(+), 678 deletions(-)
 delete mode 100644 Documentation/admin-guide/conf.py
 delete mode 100644 Documentation/core-api/conf.py
 delete mode 100644 Documentation/crypto/conf.py
 delete mode 100644 Documentation/dev-tools/conf.py
 delete mode 100644 Documentation/doc-guide/conf.py
 delete mode 100644 Documentation/driver-api/80211/conf.py
 delete mode 100644 Documentation/driver-api/conf.py
 delete mode 100644 Documentation/driver-api/pm/conf.py
 delete mode 100644 Documentation/filesystems/conf.py
 delete mode 100644 Documentation/gpu/conf.py
 delete mode 100644 Documentation/input/conf.py
 delete mode 100644 Documentation/kernel-hacking/conf.py
 delete mode 100644 Documentation/maintainer/conf.py
 delete mode 100644 Documentation/media/conf.py
 delete mode 100644 Documentation/networking/conf.py
 rename Documentation/powerpc/{bootwrapper.txt => bootwrapper.rst} (93%)
 rename Documentation/powerpc/{cpu_families.txt => cpu_families.rst} (95%)
 rename Documentation/powerpc/{cpu_features.txt => cpu_features.rst} (97%)
 rename Documentation/powerpc/{cxl.txt => cxl.rst} (95%)
 rename Documentation/powerpc/{cxlflash.txt => cxlflash.rst} (98%)
 rename Documentation/powerpc/{DAWR-POWER9.txt => dawr-power9.rst} (95%)
 rename Documentation/powerpc/{dscr.txt => dscr.rst} (91%)
 rename Documentation/powerpc/{eeh-pci-error-recovery.txt => eeh-pci-error-recovery.rst} (82%)
 rename Documentation/powerpc/{firmware-assisted-dump.txt => firmware-assisted-dump.rst} (80%)
 rename Documentation/powerpc/{hvcs.txt => hvcs.rst} (91%)
 create mode 100644 Documentation/powerpc/index.rst
 rename Documentation/powerpc/{mpc52xx.txt => mpc52xx.rst} (91%)
 rename Documentation/powerpc/{pci_iov_resource_on_powernv.txt => pci_iov_resource_on_powernv.rst} (97%)
 rename Documentation/powerpc/{pmu-ebb.txt => pmu-ebb.rst} (99%)
 create mode 100644 Documentation/powerpc/ptrace.rst
 delete mode 100644 Documentation/powerpc/ptrace.txt
 rename Documentation/powerpc/{qe_firmware.txt => qe_firmware.rst} (95%)
 rename Documentation/powerpc/{syscall64-abi.txt => syscall64-abi.rst} (82%)
 rename Documentation/powerpc/{transactional_memory.txt => transactional_memory.rst} (93%)
 delete mode 100644 Documentation/process/conf.py
 delete mode 100644 Documentation/sh/conf.py
 delete mode 100644 Documentation/sound/conf.py
 delete mode 100644 Documentation/userspace-api/conf.py
 delete mode 100644 Documentation/vm/conf.py
 delete mode 100644 Documentation/x86/conf.py

-- 
2.21.0


