Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D633938CFEF
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhEUVck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:32:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38140 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhEUVcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:32:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 2E27E4F6BE12A;
        Fri, 21 May 2021 14:31:15 -0700 (PDT)
Date:   Fri, 21 May 2021 14:31:14 -0700 (PDT)
Message-Id: <20210521.143114.1063478082804784831.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, dledford@redhat.com, jgg@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        shiraz.saleem@intel.com, david.m.ertman@intel.com
Subject: Re: [PATCH net-next v1 0/6][pull request] iwl-next Intel Wired LAN
 Driver Updates 2021-05-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
References: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 21 May 2021 14:31:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Fri, 21 May 2021 11:21:59 -0700

> This pull request is targeting net-next and rdma-next branches.
> These patches have been reviewed by netdev and rdma mailing lists[1].
> 
> This series adds RDMA support to the ice driver for E810 devices and
> converts the i40e driver to use the auxiliary bus infrastructure
> for X722 devices. The PCI netdev drivers register auxiliary RDMA devices
> that will bind to auxiliary drivers registered by the new irdma module.
> 
> [1] https://lore.kernel.org/netdev/20210520143809.819-1-shiraz.saleem@intel.com/
> ---
> Changes from last review (v6):
> - Removed unnecessary checks in i40e_client_device_register() and
> i40e_client_device_unregister()
> - Simplified the i40e_client_device_register() API
> 
> The following are changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:
>   Linux 5.13-rc1
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next

There is a lot of extra stuff in this pull, please clean that up.

Thank you.

[davem@localhost net-next]$ git pull --no-ff git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next
remote: Enumerating objects: 1726, done.        
remote: Counting objects: 100% (914/914), done.        
remote: Compressing objects: 100% (188/188), done.        
remote: Total 516 (delta 431), reused 403 (delta 326), pack-reused 0        
Receiving objects: 100% (516/516), 102.69 KiB | 2.39 MiB/s, done.
Resolving deltas: 100% (431/431), completed with 160 local objects.
From git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux
 * branch                      iwl-next   -> FETCH_HEAD
Auto-merging MAINTAINERS
hint: Waiting for your editor to close the file...
Merge made by the 'recursive' strategy.
 Documentation/scheduler/sched-domains.rst                 |   2 +-
 MAINTAINERS                                               |   1 +
 Makefile                                                  |   4 +-
 arch/x86/events/amd/iommu.c                               |  47 +++++++------
 arch/x86/include/asm/bug.h                                |   9 ---
 arch/x86/include/asm/idtentry.h                           |  15 ++++
 arch/x86/include/asm/msr.h                                |   4 --
 arch/x86/include/asm/page_64.h                            |  33 +++++++++
 arch/x86/include/asm/page_64_types.h                      |  23 +-----
 arch/x86/kernel/cpu/common.c                              |   4 +-
 arch/x86/kernel/cpu/resctrl/monitor.c                     |   2 +-
 arch/x86/kernel/nmi.c                                     |  10 +++
 arch/x86/kernel/smpboot.c                                 |   3 -
 arch/x86/kvm/svm/svm.c                                    |  39 +----------
 arch/x86/kvm/vmx/vmx.c                                    |  55 +++------------
 arch/x86/kvm/x86.c                                        |   9 +++
 arch/x86/kvm/x86.h                                        |  45 ++++++++++++
 block/bio.c                                               |  13 +---
 block/blk-settings.c                                      |   5 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                |  28 ++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c               | 184 ++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                   |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c                   |  19 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                    |   6 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h                    |   1 +
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c                     |  13 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                     |   4 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         |  68 ++++++++++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |   2 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                        |  10 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c           |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   |   4 +-
 drivers/gpu/drm/i915/gvt/handlers.c                       |   6 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                  |  10 ---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c                 |  16 -----
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.h                 |   6 --
 drivers/gpu/drm/radeon/radeon_atombios.c                  |  26 ++++---
 drivers/net/ethernet/intel/Kconfig                        |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h                    |   2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c             | 130 ++++++++++++++++++++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_main.c               |   1 +
 drivers/net/ethernet/intel/ice/Makefile                   |   1 +
 drivers/net/ethernet/intel/ice/ice.h                      |  44 ++++++++++--
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h           |  33 +++++++++
 drivers/net/ethernet/intel/ice/ice_common.c               | 217 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h               |   9 +++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c              |  19 +++++
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h           |   3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c                  | 339 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h              |  14 ++++
 drivers/net/ethernet/intel/ice/ice_lag.c                  |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c                  |  11 +++
 drivers/net/ethernet/intel/ice/ice_lib.h                  |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c                 | 142 +++++++++++++++++++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_sched.c                |  69 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.c               |  27 ++++++++
 drivers/net/ethernet/intel/ice/ice_switch.h               |   4 ++
 drivers/net/ethernet/intel/ice/ice_type.h                 |   4 ++
 drivers/video/fbdev/core/fbmem.c                          |   2 +-
 fs/cifs/fs_context.c                                      |   3 +
 fs/cifs/sess.c                                            |   6 ++
 fs/cifs/smb2pdu.c                                         |   5 ++
 include/linux/bio.h                                       |   4 +-
 include/linux/blkdev.h                                    |   2 -
 include/linux/context_tracking.h                          |  92 +++++-------------------
 include/linux/kvm_host.h                                  |  45 ++++++++++++
 include/linux/net/intel/i40e_client.h                     |  10 +++
 include/linux/net/intel/iidc.h                            | 100 ++++++++++++++++++++++++++
 include/linux/smp.h                                       |   2 +-
 include/linux/vtime.h                                     | 108 +++++++++++++++++++----------
 kernel/futex.c                                            |  82 +++++++++++-----------
 kernel/locking/qrwlock.c                                  |   6 +-
 kernel/sched/core.c                                       |   2 +-
 kernel/sched/fair.c                                       |  12 +++-
 kernel/sched/psi.c                                        |  36 +++++++---
 kernel/smp.c                                              |  26 +++----
 kernel/up.c                                               |   2 +-
 77 files changed, 1867 insertions(+), 487 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 include/linux/net/intel/iidc.h
