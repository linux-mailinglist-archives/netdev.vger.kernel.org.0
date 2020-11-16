Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC0E2B40C5
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgKPKTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgKPKSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 05:18:32 -0500
Received: from mail.kernel.org (ip5f5ad5de.dynamic.kabel-deutschland.de [95.90.213.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C48B2467D;
        Mon, 16 Nov 2020 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605521909;
        bh=hrYDFejIWKc2Sc1kJcaDxBLFYaPls+fhDdb9MsI3AZg=;
        h=From:To:Cc:Subject:Date:From;
        b=nOYrZpl4mWNo4VChMm50rhlZZFPHrNl2Md99UAjXUoT1Rv4ai6qEtKNY48QQHHDZ9
         HHi0C1trk4izVD71hsF3fVqJ+98gWWf5nNLgENrcQfgxQXQZ2k1Gs3wz9z2aw/LySR
         l+js1iuF3inRwlmH2DVzaLCAfu7AYgHEXvSB+IiI=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kebab-00FwDo-Pf; Mon, 16 Nov 2020 11:18:25 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Ben Segall <bsegall@google.com>,
        Colin Cross <ccross@android.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Jan Kara <jack@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Maxime Ripard <mripard@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Mike Rapoport <rppt@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Gong <richard.gong@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Reichel <sre@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Will Drewry <wad@chromium.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-ext4@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v4 00/27]Fix several bad kernel-doc markups
Date:   Mon, 16 Nov 2020 11:17:56 +0100
Message-Id: <cover.1605521731.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel-doc has always be limited to a probably bad documented
rule:

The kernel-doc markups should appear *imediatelly before* the
function or data structure that it documents.

On other words, if a C file would contain something like this:

	/**
	 * foo - function foo
	 * @args: foo args
	 */
	static inline void bar(int args);

	/**
	 * bar - function bar
	 * @args: foo args
	 */
	static inline void foo(void *args);


The output (in ReST format) will be:

	.. c:function:: void bar (int args)

	   function foo

	**Parameters**

	``int args``
	  foo args


	.. c:function:: void foo (void *args)

	   function bar

	**Parameters**

	``void *args``
	  foo args

Which is clearly a wrong result.  Before this changeset, 
not even a warning is produced on such cases.

As placing such markups just before the documented
data is a common practice, on most cases this is fine.

However, as patches touch things, identifiers may be
renamed, and people may forget to update the kernel-doc
markups to follow such changes.

This has been happening for quite a while, as there are
lots of files with kernel-doc problems.

This series address those issues and add a file at the
end that will enforce that the identifier will match the
kernel-doc markup, avoiding this problem from
keep happening as time goes by.

This series is based on current upstream tree.

@maintainers: feel free to pick the patches and
apply them directly on your trees, as all patches on 
this series are independent from the other ones.

--

v4:

  - Patches got rebased and got some acks.

Mauro Carvalho Chehab (27):
  net: phy: fix kernel-doc markups
  net: datagram: fix some kernel-doc markups
  net: core: fix some kernel-doc markups
  s390: fix kernel-doc markups
  drm: fix some kernel-doc markups
  HSI: fix a kernel-doc markup
  IB: fix kernel-doc markups
  parport: fix a kernel-doc markup
  rapidio: fix kernel-doc a markup
  video: fix some kernel-doc markups
  fs: fix kernel-doc markups
  jbd2: fix kernel-doc markups
  pstore/zone: fix a kernel-doc markup
  completion: fix kernel-doc markups
  firmware: stratix10-svc: fix kernel-doc markups
  connector: fix a kernel-doc markup
  lib/crc7: fix a kernel-doc markup
  hrtimer: fix kernel-doc markups
  genirq: fix kernel-doc markups
  list: fix a typo at the kernel-doc markup
  memblock: fix kernel-doc markups
  w1: fix a kernel-doc markup
  resource: fix kernel-doc markups
  shed: fix kernel-doc markup
  mm: fix kernel-doc markups
  selftests: kselftest_harness.h: partially fix kernel-doc markups
  scripts: kernel-doc: validate kernel-doc markup with the actual names

 arch/s390/include/asm/ccwdev.h                |  2 +-
 arch/s390/include/asm/cio.h                   |  2 +-
 drivers/gpu/drm/drm_atomic_state_helper.c     |  2 +-
 drivers/gpu/drm/drm_connector.c               |  3 +-
 drivers/gpu/drm/drm_dp_helper.c               |  2 +-
 drivers/gpu/drm/drm_framebuffer.c             |  2 +-
 drivers/gpu/drm/drm_gem.c                     |  4 +-
 drivers/gpu/drm/drm_gem_vram_helper.c         |  2 +-
 drivers/gpu/drm/drm_mode_object.c             |  2 +-
 drivers/gpu/drm/drm_modes.c                   |  4 +-
 drivers/gpu/drm/drm_scdc_helper.c             |  2 +-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |  2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c         |  2 +-
 drivers/gpu/drm/i915/i915_perf.c              |  8 ++-
 drivers/gpu/drm/scheduler/sched_main.c        |  2 +-
 drivers/gpu/drm/v3d/v3d_sched.c               |  2 +-
 drivers/gpu/drm/vc4/vc4_bo.c                  |  2 +-
 drivers/hsi/hsi_core.c                        |  2 +-
 drivers/infiniband/core/cm.c                  |  5 +-
 drivers/infiniband/core/cq.c                  |  4 +-
 drivers/infiniband/core/iwpm_util.h           |  2 +-
 drivers/infiniband/core/sa_query.c            |  3 +-
 drivers/infiniband/core/verbs.c               |  4 +-
 drivers/infiniband/sw/rdmavt/ah.c             |  2 +-
 drivers/infiniband/sw/rdmavt/mcast.c          | 12 ++--
 drivers/infiniband/sw/rdmavt/qp.c             |  8 +--
 drivers/infiniband/ulp/iser/iscsi_iser.c      |  2 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_encap.h  |  2 +-
 .../ulp/opa_vnic/opa_vnic_vema_iface.c        |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h         |  2 +-
 drivers/net/phy/mdio_bus.c                    |  2 +-
 drivers/net/phy/phy-c45.c                     |  2 +-
 drivers/net/phy/phy.c                         |  2 +-
 drivers/net/phy/phy_device.c                  |  2 +-
 drivers/net/phy/phylink.c                     |  2 +-
 drivers/parport/share.c                       |  2 +-
 drivers/rapidio/rio.c                         |  2 +-
 drivers/video/fbdev/core/fbcmap.c             |  2 +-
 drivers/video/hdmi.c                          |  3 +-
 fs/dcache.c                                   | 72 +++++++++----------
 fs/inode.c                                    |  4 +-
 fs/jbd2/journal.c                             | 34 ++++-----
 fs/jbd2/transaction.c                         | 31 ++++----
 fs/pstore/zone.c                              |  2 +-
 fs/seq_file.c                                 |  5 +-
 fs/super.c                                    | 12 ++--
 include/drm/drm_atomic_helper.h               |  4 +-
 include/drm/drm_connector.h                   |  2 +-
 include/drm/drm_device.h                      |  2 +-
 include/drm/drm_dsc.h                         |  3 +-
 include/drm/drm_gem_vram_helper.h             |  8 +--
 include/linux/completion.h                    | 10 ++-
 include/linux/connector.h                     |  2 +-
 .../firmware/intel/stratix10-svc-client.h     | 10 +--
 include/linux/hrtimer.h                       |  6 +-
 include/linux/jbd2.h                          |  2 +-
 include/linux/list.h                          |  2 +-
 include/linux/memblock.h                      |  4 +-
 include/linux/netdevice.h                     | 11 ++-
 include/linux/parport.h                       | 31 ++++++++
 include/linux/w1.h                            |  2 +-
 include/rdma/ib_verbs.h                       | 11 +++
 kernel/irq/chip.c                             |  2 +-
 kernel/irq/generic-chip.c                     |  2 +-
 kernel/resource.c                             | 24 ++++---
 kernel/sched/core.c                           | 16 ++---
 kernel/sched/fair.c                           |  2 +-
 kernel/time/hrtimer.c                         |  2 +-
 lib/crc7.c                                    |  2 +-
 mm/gup.c                                      | 24 ++++---
 mm/page_alloc.c                               | 16 ++---
 mm/truncate.c                                 | 10 ++-
 net/core/datagram.c                           |  2 +-
 net/core/dev.c                                |  4 +-
 net/core/skbuff.c                             |  2 +-
 net/ethernet/eth.c                            |  6 +-
 net/sunrpc/rpc_pipe.c                         |  3 +-
 scripts/kernel-doc                            | 62 +++++++++++-----
 tools/testing/selftests/kselftest_harness.h   | 22 +++---
 79 files changed, 350 insertions(+), 235 deletions(-)

-- 
2.28.0


