Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF52846D765
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbhLHPzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:55:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:34728 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbhLHPy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:54:59 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1muzE5-000GnB-SM; Wed, 08 Dec 2021 16:51:26 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-12-08
Date:   Wed,  8 Dec 2021 16:51:25 +0100
Message-Id: <20211208155125.11826-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26377/Wed Dec  8 10:23:25 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 22 day(s) which contain
a total of 29 files changed, 659 insertions(+), 80 deletions(-).

The main changes are:

1) Fix an off-by-two error in packet range markings and also add a batch of
   new tests for coverage of these corner cases, from Maxim Mikityanskiy.

2) Fix a compilation issue on MIPS JIT for R10000 CPUs, from Johan Almbladh.

3) Fix two functional regressions and a build warning related to BTF kfunc
   for modules, from Kumar Kartikeya Dwivedi.

4) Fix outdated code and docs regarding BPF's migrate_disable() use on non-
   PREEMPT_RT kernels, from Sebastian Andrzej Siewior.

5) Add missing includes in order to be able to detangle cgroup vs bpf header
   dependencies, from Jakub Kicinski.

6) Fix regression in BPF sockmap tests caused by missing detachment of progs
   from sockets when they are removed from the map, from John Fastabend.

7) Fix a missing "no previous prototype" warning in x86 JIT caused by BPF
   dispatcher, from Björn Töpel.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Christoph Hellwig, Greg Kroah-Hartman, Jani Nikula, kernel test robot, 
Krzysztof Wilczyński, Lukas Bulwahn, Pavel Skripkin, Peter Chen, 
SeongJae Park, Song Liu, Vinicius Costa Gomes

----------------------------------------------------------------

The following changes since commit 3751c3d34cd5a750c86d1c8eaf217d8faf7f9325:

  net: stmmac: Fix signed/unsigned wreckage (2021-11-16 19:49:55 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to b560b21f71eb4ef9dfc7c8ec1d0e4d7f9aa54b51:

  bpf: Add selftests to cover packet access corner cases (2021-12-08 15:42:26 +0100)

----------------------------------------------------------------
Andrii Nakryiko (1):
      Merge branch 'Fixes for kfunc-mod regressions and warnings'

Björn Töpel (1):
      bpf, x86: Fix "no previous prototype" warning

Jakub Kicinski (1):
      treewide: Add missing includes masked by cgroup -> bpf dependency

Johan Almbladh (1):
      mips, bpf: Fix reference to non-existing Kconfig symbol

John Fastabend (2):
      bpf, sockmap: Attach map progs to psock early for feature probes
      bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap

Kumar Kartikeya Dwivedi (3):
      bpf: Make CONFIG_DEBUG_INFO_BTF depend upon CONFIG_BPF_SYSCALL
      bpf: Fix bpf_check_mod_kfunc_call for built-in modules
      tools/resolve_btfids: Skip unresolved symbol warning for empty BTF sets

Maxim Mikityanskiy (2):
      bpf: Fix the off-by-two error in range markings
      bpf: Add selftests to cover packet access corner cases

Sebastian Andrzej Siewior (2):
      Documentation/locking/locktypes: Update migrate_disable() bits.
      bpf: Make sure bpf_disable_instrumentation() is safe vs preemption.

 Documentation/locking/locktypes.rst                |   9 +-
 arch/mips/net/bpf_jit_comp.h                       |   2 +-
 block/fops.c                                       |   1 +
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   1 +
 drivers/gpu/drm/i915/gt/intel_gtt.c                |   1 +
 drivers/gpu/drm/i915/i915_request.c                |   1 +
 drivers/gpu/drm/lima/lima_device.c                 |   1 +
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   1 +
 drivers/gpu/drm/ttm/ttm_tt.c                       |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   2 +
 drivers/pci/controller/dwc/pci-exynos.c            |   1 +
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   1 +
 drivers/usb/cdns3/host.c                           |   1 +
 include/linux/bpf.h                                |  17 +-
 include/linux/btf.h                                |  14 +-
 include/linux/cacheinfo.h                          |   1 -
 include/linux/device/driver.h                      |   1 +
 include/linux/filter.h                             |   5 +-
 kernel/bpf/btf.c                                   |  11 +-
 kernel/bpf/verifier.c                              |   2 +-
 lib/Kconfig.debug                                  |   1 +
 mm/damon/vaddr.c                                   |   1 +
 mm/memory_hotplug.c                                |   1 +
 mm/swap_slots.c                                    |   1 +
 net/core/skmsg.c                                   |   5 +
 net/core/sock_map.c                                |  15 +-
 tools/bpf/resolve_btfids/main.c                    |   8 +-
 .../bpf/verifier/xdp_direct_packet_access.c        | 632 +++++++++++++++++++--
 29 files changed, 659 insertions(+), 80 deletions(-)
