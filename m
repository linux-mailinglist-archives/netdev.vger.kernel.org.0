Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45891D344A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfJJXYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:24:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34578 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbfJJXYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:24:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id k7so3555737pll.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4ymsMWUKjsfu+PilHh/VtCB3GZ18GaexNV/wXgi9CUM=;
        b=B+1tW3BHySKkjmXwFUERkvOLc6riWPNRELJG99rOftqNS+5/mQCg2TK0js8nNOy41r
         wjsj6IIHvSfgUVbXfK/AQ5pGrEDB8hRum/aJAtloDY9bR/1ZFaSx5IksqHrxqn47Yh2R
         uM5z0HLzlSCkej6nYVc8KQC3AZ5kfnyk/LPu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4ymsMWUKjsfu+PilHh/VtCB3GZ18GaexNV/wXgi9CUM=;
        b=coLjaJCKYYzzW2WXavvIvhg7npwIGOTuOcpOcy/OKRXgn//6ESbFHnHbGuwYVK8PSC
         FMS+8KAPYPfjbPZGSl2af1Qqetjo47I2RjmGperFe80M1tBgNu//GrnYeysMF2whFNJ7
         EhcN+VzrQOAKpd7P+ocpIUNizPXtUUDeUmC6xcm40/ZQJjZK+Q80JKBHbcI7i1MafcXL
         Ir3DWjX8ZZk5zLlqOPhSSAUhBzdfkA8MiKjRkRt6qoVeLRgrtVJjZNr6kyzG1UjTBGBl
         atMiayGd6R2XqdYs1Eph1whYv9VAEnOgm7SkQh5HhdcL4FKKq08v47NbOzyMyqSkNWzu
         SDTA==
X-Gm-Message-State: APjAAAVjKiN8CwjGSs2iqrA+dcd56AReBIUuL5dl4OI0w+liOmLKEBOJ
        tsIgloRqr6GlynvN7YTboEf62A==
X-Google-Smtp-Source: APXvYqwp5KMCh2xXa60IgJi7yoB+WBtu8e4iW6OJxojl3gECBo4jyO8TfaWFHI5ULpYec514KB3T4A==
X-Received: by 2002:a17:902:6b06:: with SMTP id o6mr12297370plk.154.1570749841445;
        Thu, 10 Oct 2019 16:24:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w7sm5220879pjn.1.2019.10.10.16.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:23:58 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/4] treewide: Use sizeof_member() macro
Date:   Thu, 10 Oct 2019 16:23:41 -0700
Message-Id: <20191010232345.26594-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the tree I'll be carrying for the v5.5 merge window to replace
the various struct member sizeof macros with sizeof_member(). The CC list
was insane, so I trimmed it to the major areas that get touched. Dave,
I converted your "no objection"[1] into an Acked-by; please yell if this
is not desired.

Also note that the MIPS patch has been sent separately since it didn't
NEED to depend on this series.

Thanks!

-Kees

[1] https://lore.kernel.org/lkml/20191002.132121.402975401040540710.davem@davemloft.net

v2: rearrange further, make sure Dave Miller is okay with changes
v1: https://lore.kernel.org/lkml/201909261026.6E3381876C@keescook

Pankaj Bharadiya (4):
  MIPS: OCTEON: Replace SIZEOF_FIELD() macro
  linux/stddef.h: Add sizeof_member() macro
  treewide: Use sizeof_member() macro
  include: Remove FIELD_SIZEOF() and sizeof_field() macros

 Documentation/process/coding-style.rst        |   2 +-
 .../it_IT/process/coding-style.rst            |   2 +-
 .../zh_CN/process/coding-style.rst            |   2 +-
 arch/arc/kernel/unwind.c                      |   6 +-
 arch/arm64/include/asm/processor.h            |  10 +-
 .../cavium-octeon/executive/cvmx-bootmem.c    |   9 +-
 arch/powerpc/net/bpf_jit32.h                  |   4 +-
 arch/powerpc/net/bpf_jit_comp.c               |  16 +-
 arch/sparc/net/bpf_jit_comp_32.c              |   8 +-
 arch/x86/kernel/fpu/xstate.c                  |   2 +-
 block/blk-core.c                              |   4 +-
 crypto/adiantum.c                             |   4 +-
 crypto/essiv.c                                |   2 +-
 drivers/firmware/efi/efi.c                    |   2 +-
 drivers/gpu/drm/i915/gvt/scheduler.c          |   2 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c             |   2 +-
 drivers/infiniband/hw/hfi1/verbs.h            |   4 +-
 .../ulp/opa_vnic/opa_vnic_ethtool.c           |   2 +-
 drivers/input/keyboard/applespi.c             |   2 +-
 drivers/md/raid5-ppl.c                        |   2 +-
 drivers/media/platform/omap3isp/isppreview.c  |  24 +--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  |   4 +-
 .../ethernet/cavium/liquidio/octeon_console.c |  16 +-
 .../net/ethernet/emulex/benet/be_ethtool.c    |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |   2 +-
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |   8 +-
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |   2 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   2 +-
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |   2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  10 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   4 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   4 +-
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |   4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   4 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c  |  10 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c |   2 +-
 .../net/ethernet/netronome/nfp/bpf/offload.c  |   2 +-
 .../net/ethernet/netronome/nfp/flower/main.h  |   2 +-
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   2 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   |   2 +-
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    |   2 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   4 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c        |   6 +-
 drivers/net/ethernet/ti/netcp_ethss.c         |  32 ++--
 drivers/net/fjes/fjes_ethtool.c               |   2 +-
 drivers/net/geneve.c                          |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |   2 +-
 drivers/net/usb/sierra_net.c                  |   2 +-
 drivers/net/usb/usbnet.c                      |   2 +-
 drivers/net/vxlan.c                           |   4 +-
 .../net/wireless/marvell/libertas/debugfs.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/util.h   |   4 +-
 drivers/s390/net/qeth_core_main.c             |   2 +-
 drivers/s390/net/qeth_core_mpc.h              |  10 +-
 drivers/scsi/aacraid/aachba.c                 |   4 +-
 drivers/scsi/be2iscsi/be_cmds.h               |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                 |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |   6 +-
 drivers/staging/qlge/qlge_ethtool.c           |   2 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c     |   2 +-
 drivers/usb/atm/usbatm.c                      |   2 +-
 drivers/usb/gadget/function/f_fs.c            |   2 +-
 fs/befs/linuxvfs.c                            |   2 +-
 fs/crypto/keyring.c                           |   2 +-
 fs/ext2/super.c                               |   2 +-
 fs/ext4/super.c                               |   2 +-
 fs/freevxfs/vxfs_super.c                      |   2 +-
 fs/fuse/virtio_fs.c                           |   2 +-
 fs/orangefs/super.c                           |   2 +-
 fs/ufs/super.c                                |   2 +-
 fs/verity/enable.c                            |   2 +-
 include/linux/filter.h                        |  12 +-
 include/linux/kernel.h                        |   9 --
 include/linux/kvm_host.h                      |   2 +-
 include/linux/phy_led_triggers.h              |   2 +-
 include/linux/slab.h                          |   2 +-
 include/linux/stddef.h                        |  13 +-
 include/net/garp.h                            |   2 +-
 include/net/ip_tunnels.h                      |   6 +-
 include/net/mrp.h                             |   2 +-
 include/net/netfilter/nf_conntrack_helper.h   |   2 +-
 include/net/netfilter/nf_tables_core.h        |   2 +-
 include/net/sock.h                            |   2 +-
 ipc/util.c                                    |   2 +-
 kernel/bpf/cgroup.c                           |   2 +-
 kernel/bpf/local_storage.c                    |   4 +-
 kernel/fork.c                                 |   2 +-
 kernel/signal.c                               |  12 +-
 kernel/utsname.c                              |   2 +-
 net/802/mrp.c                                 |   6 +-
 net/batman-adv/main.c                         |   2 +-
 net/bpf/test_run.c                            |   6 +-
 net/bridge/br.c                               |   2 +-
 net/caif/caif_socket.c                        |   2 +-
 net/core/dev.c                                |   2 +-
 net/core/filter.c                             | 140 +++++++++---------
 net/core/flow_dissector.c                     |  10 +-
 net/core/skbuff.c                             |   2 +-
 net/core/xdp.c                                |   4 +-
 net/dccp/proto.c                              |   2 +-
 net/ipv4/ip_gre.c                             |   4 +-
 net/ipv4/ip_vti.c                             |   4 +-
 net/ipv4/raw.c                                |   2 +-
 net/ipv4/tcp.c                                |   2 +-
 net/ipv6/ip6_gre.c                            |   4 +-
 net/ipv6/raw.c                                |   2 +-
 net/iucv/af_iucv.c                            |   2 +-
 net/netfilter/nf_tables_api.c                 |   4 +-
 net/netfilter/nfnetlink_cthelper.c            |   2 +-
 net/netfilter/nft_ct.c                        |  12 +-
 net/netfilter/nft_masq.c                      |   2 +-
 net/netfilter/nft_nat.c                       |   6 +-
 net/netfilter/nft_redir.c                     |   2 +-
 net/netfilter/nft_tproxy.c                    |   4 +-
 net/netfilter/xt_RATEEST.c                    |   2 +-
 net/netlink/af_netlink.c                      |   2 +-
 net/openvswitch/datapath.c                    |   2 +-
 net/openvswitch/flow.h                        |   4 +-
 net/rxrpc/af_rxrpc.c                          |   2 +-
 net/sched/act_ct.c                            |   4 +-
 net/sched/cls_flower.c                        |   2 +-
 net/sctp/socket.c                             |   4 +-
 net/unix/af_unix.c                            |   2 +-
 security/integrity/ima/ima_policy.c           |   4 +-
 sound/soc/codecs/hdmi-codec.c                 |   2 +-
 tools/testing/selftests/bpf/bpf_util.h        |   6 +-
 virt/kvm/kvm_main.c                           |   2 +-
 138 files changed, 339 insertions(+), 352 deletions(-)

-- 
2.17.1

