Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833B337BD24
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhELMxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231388AbhELMw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B11D61175;
        Wed, 12 May 2021 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823902;
        bh=L+E/N8mtA2/+iSqhjhIyKk7M7RrC5qMfkQmRh4SXqOM=;
        h=From:To:Cc:Subject:Date:From;
        b=ucNSAhXYlF3Szz7W2irBTsvcIq33u1CrsW3ughaZJQqP+LrxpB0KjDChNaWylRCiA
         8uidMvIFPObFZ6akJiKIQ1n/loNfn6hx8yVucw2xWZ73EfgNRibzOSlugYBt51kwpz
         sdmRPA3LdwD45uYQTpj7XZoENUjgUxwJTlI1qlwGCNWZNWI+BkaJBNQJYsI68pIF0d
         fXOa2Wzs1nudr171bvqR7b67LC1CF/NPtlR0c90fFeyu9TgllD9P44UMzmzYncl5FJ
         KVeCETjMQ0hlqHZjf6TbTaK//D282G036gFoleiqqZjAOauHQnBlpoCUvLp2Ls+ug5
         bNkKFQYHSRskA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgoKy-0018go-1r; Wed, 12 May 2021 14:51:40 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Subject: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate symbols
Date:   Wed, 12 May 2021 14:50:04 +0200
Message-Id: <cover.1620823573.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contain basically a cleanup from all those years of converting
files to ReST.

During the conversion period, several tools like LaTeX, pandoc, DocBook
and some specially-written scripts were used in order to convert
existing documents.

Such conversion tools - plus some text editor like LibreOffice  or similar  - have
a set of rules that turns some typed ASCII characters into UTF-8 alternatives,
for instance converting commas into curly commas and adding non-breakable
spaces. All of those are meant to produce better results when the text is
displayed in HTML or PDF formats.

While it is perfectly fine to use UTF-8 characters in Linux, and specially at
the documentation,  it is better to  stick to the ASCII subset  on such
particular case,  due to a couple of reasons:

1. it makes life easier for tools like grep;
2. they easier to edit with the some commonly used text/source
   code editors.
    
Also, Sphinx already do such conversion automatically outside 
literal blocks, as described at:

       https://docutils.sourceforge.io/docs/user/smartquotes.html

In this series, the following UTF-8 symbols are replaced:

            - U+00a0 (' '): NO-BREAK SPACE
            - U+00ad ('­'): SOFT HYPHEN
            - U+00b4 ('´'): ACUTE ACCENT
            - U+00d7 ('×'): MULTIPLICATION SIGN
            - U+2010 ('‐'): HYPHEN
            - U+2018 ('‘'): LEFT SINGLE QUOTATION MARK
            - U+2019 ('’'): RIGHT SINGLE QUOTATION MARK
            - U+201c ('“'): LEFT DOUBLE QUOTATION MARK
            - U+201d ('”'): RIGHT DOUBLE QUOTATION MARK
            - U+2212 ('−'): MINUS SIGN
            - U+2217 ('∗'): ASTERISK OPERATOR
            - U+feff ('﻿'): ZERO WIDTH NO-BREAK SPACE (BOM)

---

v2:
- removed EM/EN DASH conversion from this patchset;
- removed a few fixes, as those were addressed on a separate series.
 
PS.:
   The first version of this series was posted with a different name:

	https://lore.kernel.org/lkml/cover.1620641727.git.mchehab+huawei@kernel.org/

   I also changed the patch texts, in order to better describe the patches goals.

Mauro Carvalho Chehab (40):
  docs: hwmon: Use ASCII subset instead of UTF-8 alternate symbols
  docs: admin-guide: Use ASCII subset instead of UTF-8 alternate symbols
  docs: admin-guide: media: ipu3.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: admin-guide: perf: imx-ddr.rst: Use ASCII subset instead of
    UTF-8 alternate symbols
  docs: admin-guide: pm: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: trace: coresight: coresight-etm4x-reference.rst: Use ASCII
    subset instead of UTF-8 alternate symbols
  docs: driver-api: ioctl.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: driver-api: thermal: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: driver-api: media: drivers: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: driver-api: firmware: other_interfaces.rst: Use ASCII subset
    instead of UTF-8 alternate symbols
  docs: fault-injection: nvme-fault-injection.rst: Use ASCII subset
    instead of UTF-8 alternate symbols
  docs: usb: Use ASCII subset instead of UTF-8 alternate symbols
  docs: process: code-of-conduct.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: userspace-api: media: fdl-appendix.rst: Use ASCII subset instead
    of UTF-8 alternate symbols
  docs: userspace-api: media: v4l: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: userspace-api: media: dvb: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: vm: zswap.rst: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: filesystems: f2fs.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: filesystems: ext4: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: kernel-hacking: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: hid: Use ASCII subset instead of UTF-8 alternate symbols
  docs: security: tpm: tpm_event_log.rst: Use ASCII subset instead of
    UTF-8 alternate symbols
  docs: security: keys: trusted-encrypted.rst: Use ASCII subset instead
    of UTF-8 alternate symbols
  docs: networking: scaling.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: networking: devlink: devlink-dpipe.rst: Use ASCII subset instead
    of UTF-8 alternate symbols
  docs: networking: device_drivers: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: x86: Use ASCII subset instead of UTF-8 alternate symbols
  docs: scheduler: sched-deadline.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: power: powercap: powercap.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: ABI: Use ASCII subset instead of UTF-8 alternate symbols
  docs: PCI: acpi-info.rst: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: gpu: Use ASCII subset instead of UTF-8 alternate symbols
  docs: sound: kernel-api: writing-an-alsa-driver.rst: Use ASCII subset
    instead of UTF-8 alternate symbols
  docs: arm64: arm-acpi.rst: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: infiniband: tag_matching.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: misc-devices: ibmvmc.rst: Use ASCII subset instead of UTF-8
    alternate symbols
  docs: firmware-guide: acpi: lpit.rst: Use ASCII subset instead of
    UTF-8 alternate symbols
  docs: firmware-guide: acpi: dsd: graph.rst: Use ASCII subset instead
    of UTF-8 alternate symbols
  docs: virt: kvm: api.rst: Use ASCII subset instead of UTF-8 alternate
    symbols
  docs: RCU: Use ASCII subset instead of UTF-8 alternate symbols

 ...sfs-class-chromeos-driver-cros-ec-lightbar |   2 +-
 .../ABI/testing/sysfs-devices-platform-ipmi   |   2 +-
 .../testing/sysfs-devices-platform-trackpoint |   2 +-
 Documentation/ABI/testing/sysfs-devices-soc   |   4 +-
 Documentation/PCI/acpi-info.rst               |  22 +-
 .../Data-Structures/Data-Structures.rst       |  52 ++--
 .../Expedited-Grace-Periods.rst               |  40 +--
 .../Tree-RCU-Memory-Ordering.rst              |  10 +-
 .../RCU/Design/Requirements/Requirements.rst  | 122 ++++-----
 Documentation/admin-guide/media/ipu3.rst      |   2 +-
 Documentation/admin-guide/perf/imx-ddr.rst    |   2 +-
 Documentation/admin-guide/pm/intel_idle.rst   |   4 +-
 Documentation/admin-guide/pm/intel_pstate.rst |   4 +-
 Documentation/admin-guide/ras.rst             |  86 +++---
 .../admin-guide/reporting-issues.rst          |   2 +-
 Documentation/arm64/arm-acpi.rst              |   8 +-
 .../driver-api/firmware/other_interfaces.rst  |   2 +-
 Documentation/driver-api/ioctl.rst            |   8 +-
 .../media/drivers/sh_mobile_ceu_camera.rst    |   8 +-
 .../driver-api/media/drivers/zoran.rst        |   2 +-
 .../driver-api/thermal/cpu-idle-cooling.rst   |  14 +-
 .../driver-api/thermal/intel_powerclamp.rst   |   6 +-
 .../thermal/x86_pkg_temperature_thermal.rst   |   2 +-
 .../fault-injection/nvme-fault-injection.rst  |   2 +-
 Documentation/filesystems/ext4/attributes.rst |  20 +-
 Documentation/filesystems/ext4/bigalloc.rst   |   6 +-
 Documentation/filesystems/ext4/blockgroup.rst |   8 +-
 Documentation/filesystems/ext4/blocks.rst     |   2 +-
 Documentation/filesystems/ext4/directory.rst  |  16 +-
 Documentation/filesystems/ext4/eainode.rst    |   2 +-
 Documentation/filesystems/ext4/inlinedata.rst |   6 +-
 Documentation/filesystems/ext4/inodes.rst     |   6 +-
 Documentation/filesystems/ext4/journal.rst    |   8 +-
 Documentation/filesystems/ext4/mmp.rst        |   2 +-
 .../filesystems/ext4/special_inodes.rst       |   4 +-
 Documentation/filesystems/ext4/super.rst      |  10 +-
 Documentation/filesystems/f2fs.rst            |   4 +-
 .../firmware-guide/acpi/dsd/graph.rst         |   2 +-
 Documentation/firmware-guide/acpi/lpit.rst    |   2 +-
 Documentation/gpu/i915.rst                    |   2 +-
 Documentation/gpu/komeda-kms.rst              |   2 +-
 Documentation/hid/hid-sensor.rst              |  70 ++---
 Documentation/hid/intel-ish-hid.rst           | 246 +++++++++---------
 Documentation/hwmon/ir36021.rst               |   2 +-
 Documentation/hwmon/ltc2992.rst               |   2 +-
 Documentation/hwmon/pm6764tr.rst              |   2 +-
 Documentation/infiniband/tag_matching.rst     |   4 +-
 Documentation/kernel-hacking/hacking.rst      |   2 +-
 Documentation/kernel-hacking/locking.rst      |   2 +-
 Documentation/misc-devices/ibmvmc.rst         |   8 +-
 .../device_drivers/ethernet/intel/i40e.rst    |   8 +-
 .../device_drivers/ethernet/intel/iavf.rst    |   4 +-
 .../device_drivers/ethernet/netronome/nfp.rst |  12 +-
 .../networking/devlink/devlink-dpipe.rst      |   2 +-
 Documentation/networking/scaling.rst          |  18 +-
 Documentation/power/powercap/powercap.rst     | 210 +++++++--------
 Documentation/process/code-of-conduct.rst     |   2 +-
 Documentation/scheduler/sched-deadline.rst    |   2 +-
 .../security/keys/trusted-encrypted.rst       |   4 +-
 Documentation/security/tpm/tpm_event_log.rst  |   2 +-
 .../kernel-api/writing-an-alsa-driver.rst     |  68 ++---
 .../coresight/coresight-etm4x-reference.rst   |  16 +-
 Documentation/usb/ehci.rst                    |   2 +-
 Documentation/usb/gadget_printer.rst          |   2 +-
 Documentation/usb/mass-storage.rst            |  36 +--
 .../media/dvb/audio-set-bypass-mode.rst       |   2 +-
 .../userspace-api/media/dvb/audio.rst         |   2 +-
 .../userspace-api/media/dvb/dmx-fopen.rst     |   2 +-
 .../userspace-api/media/dvb/dmx-fread.rst     |   2 +-
 .../media/dvb/dmx-set-filter.rst              |   2 +-
 .../userspace-api/media/dvb/intro.rst         |   6 +-
 .../userspace-api/media/dvb/video.rst         |   2 +-
 .../userspace-api/media/fdl-appendix.rst      |  64 ++---
 .../userspace-api/media/v4l/crop.rst          |  16 +-
 .../userspace-api/media/v4l/dev-decoder.rst   |   6 +-
 .../userspace-api/media/v4l/diff-v4l.rst      |   2 +-
 .../userspace-api/media/v4l/open.rst          |   2 +-
 .../media/v4l/vidioc-cropcap.rst              |   4 +-
 Documentation/virt/kvm/api.rst                |  28 +-
 Documentation/vm/zswap.rst                    |   4 +-
 Documentation/x86/resctrl.rst                 |   2 +-
 Documentation/x86/sgx.rst                     |   4 +-
 82 files changed, 693 insertions(+), 693 deletions(-)

-- 
2.30.2


