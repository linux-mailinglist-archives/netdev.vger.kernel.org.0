Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F14EE9321
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 23:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfJ2WsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 18:48:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44898 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfJ2WsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 18:48:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id q26so115223pfn.11
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 15:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pv78clQAJRrt/vNkXu1T8WarqpcDObEP2WwUIgdnLZs=;
        b=ci6hEZ73WrbwFVBJmJosRNhQiu5w2j81or+veKHEiNCvewZuG+6m/lNtMxHImkbgYb
         XCkIuCH+QBNB1oMnr7I+SkzIC6w0hwsOaRcoRpD/IxAMREoTtUA67AN+Bei8N41HstsB
         xr6Q2Fxs+DRovhjoGYdm/fy0Sh4h5Kd2PvytE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pv78clQAJRrt/vNkXu1T8WarqpcDObEP2WwUIgdnLZs=;
        b=hqgUzaPzMnOEWvUrVEds9OO+sWBbB667zI3yLoxDQfy5RzVdPCXNVGq+qlb8MX/TKA
         NrMdG+6eKzOm1bs2ZVa+jYPnhUSmXZx8XnXa1v3GAfCnak2u8AHLMfjqafKbyo18dnDw
         uul010wnJb8gqrzKrP4vXexYgMttuc9+ZNtTnOk5g3YynJhqT0s7/rfxhjc2XBzf1bkx
         34miavm4iaqJWtB/lR93sBKRut8XrfFpFut9Lw8vKHsBnVFoICtT9z2YjpuDshbenmC6
         02qqDmxXft5y4wxKtV+mKuSNKMX4R4luoDkMs6II5ZGUbHz54IBxrLaicAiyhqTeorlq
         Kj7Q==
X-Gm-Message-State: APjAAAVUgfBbaReZQ1QH1GU6t1mam5s7B6SqBTpKg49TpQjKHsBrZ2If
        dcLRhFrKSpQcTm4mwIXiNF9fbA==
X-Google-Smtp-Source: APXvYqw0TBf2QsIyQSWOBCeH12/hgS7y/+5UQcQakMNY6Jdl/svN0Qin+9SzxgPfdBcuq7KfrZXUPg==
X-Received: by 2002:a63:da04:: with SMTP id c4mr29416977pgh.172.1572389288993;
        Tue, 29 Oct 2019 15:48:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w6sm154463pfw.84.2019.10.29.15.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 15:48:05 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] treewide: Use sizeof_member() macro
Date:   Tue, 29 Oct 2019 15:47:56 -0700
Message-Id: <20191029224756.28618-4-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191029224756.28618-1-keescook@chromium.org>
References: <20191029224756.28618-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>

Replace all the occurrences of FIELD_SIZEOF() and sizeof_field() with
sizeof_member() except at places where these are defined. Later patches
will remove the unused definitions.

This patch is generated using following script:

EXCLUDE_FILES="include/linux/stddef.h|include/linux/kernel.h"

git grep -l -e "\bFIELD_SIZEOF\b" -e "\bsizeof_field\b" | while read file;
do

	if [[ "$file" =~ $EXCLUDE_FILES ]]; then
		continue
	fi
	sed -i  -e 's/\bFIELD_SIZEOF\b/sizeof_member/g' \
		-e 's/\bsizeof_field\b/sizeof_member/g' \
		$file;
done

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
Link: https://lore.kernel.org/r/20190924105839.110713-3-pankaj.laxminarayan.bharadiya@intel.com
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: David Miller <davem@davemloft.net> # for netdev
---
 Documentation/process/coding-style.rst        |   2 +-
 .../it_IT/process/coding-style.rst            |   2 +-
 .../zh_CN/process/coding-style.rst            |   2 +-
 arch/arc/kernel/unwind.c                      |   6 +-
 arch/arm64/include/asm/processor.h            |  10 +-
 .../cavium-octeon/executive/cvmx-bootmem.c    |   2 +-
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
 include/linux/kvm_host.h                      |   2 +-
 include/linux/phy_led_triggers.h              |   2 +-
 include/linux/slab.h                          |   2 +-
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
 virt/kvm/kvm_main.c                           |   2 +-
 134 files changed, 325 insertions(+), 325 deletions(-)

diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
index f4a2198187f9..146b3a2c661c 100644
--- a/Documentation/process/coding-style.rst
+++ b/Documentation/process/coding-style.rst
@@ -988,7 +988,7 @@ Similarly, if you need to calculate the size of some structure member, use
 
 .. code-block:: c
 
-	#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+	#define sizeof_member(t, f) (sizeof(((t*)0)->f))
 
 There are also min() and max() macros that do strict type checking if you
 need them.  Feel free to peruse that header file to see what else is already
diff --git a/Documentation/translations/it_IT/process/coding-style.rst b/Documentation/translations/it_IT/process/coding-style.rst
index 8995d2d19f20..64d27bb9fa4f 100644
--- a/Documentation/translations/it_IT/process/coding-style.rst
+++ b/Documentation/translations/it_IT/process/coding-style.rst
@@ -1005,7 +1005,7 @@ struttura, usate
 
 .. code-block:: c
 
-	#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+	#define sizeof_member(t, f) (sizeof(((t*)0)->f))
 
 Ci sono anche le macro min() e max() che, se vi serve, effettuano un controllo
 rigido sui tipi.  Sentitevi liberi di leggere attentamente questo file
diff --git a/Documentation/translations/zh_CN/process/coding-style.rst b/Documentation/translations/zh_CN/process/coding-style.rst
index 4f6237392e65..81c1c5ea8151 100644
--- a/Documentation/translations/zh_CN/process/coding-style.rst
+++ b/Documentation/translations/zh_CN/process/coding-style.rst
@@ -826,7 +826,7 @@ inline gcc 也可以自动使其内联。而且其他用户可能会要求移除
 
 .. code-block:: c
 
-	#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+	#define sizeof_member(t, f) (sizeof(((t*)0)->f))
 
 还有可以做严格的类型检查的 min() 和 max() 宏，如果你需要可以使用它们。你可以
 自己看看那个头文件里还定义了什么你可以拿来用的东西，如果有定义的话，你就不应
diff --git a/arch/arc/kernel/unwind.c b/arch/arc/kernel/unwind.c
index dc05a63516f5..7b33806a6e59 100644
--- a/arch/arc/kernel/unwind.c
+++ b/arch/arc/kernel/unwind.c
@@ -42,10 +42,10 @@ do {						\
 
 #define EXTRA_INFO(f) { \
 		BUILD_BUG_ON_ZERO(offsetof(struct unwind_frame_info, f) \
-				% FIELD_SIZEOF(struct unwind_frame_info, f)) \
+				% sizeof_member(struct unwind_frame_info, f)) \
 				+ offsetof(struct unwind_frame_info, f) \
-				/ FIELD_SIZEOF(struct unwind_frame_info, f), \
-				FIELD_SIZEOF(struct unwind_frame_info, f) \
+				/ sizeof_member(struct unwind_frame_info, f), \
+				sizeof_member(struct unwind_frame_info, f) \
 	}
 #define PTREGS_INFO(f) EXTRA_INFO(regs.f)
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 5623685c7d13..2d61a909984d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -152,13 +152,13 @@ static inline void arch_thread_struct_whitelist(unsigned long *offset,
 						unsigned long *size)
 {
 	/* Verify that there is no padding among the whitelisted fields: */
-	BUILD_BUG_ON(sizeof_field(struct thread_struct, uw) !=
-		     sizeof_field(struct thread_struct, uw.tp_value) +
-		     sizeof_field(struct thread_struct, uw.tp2_value) +
-		     sizeof_field(struct thread_struct, uw.fpsimd_state));
+	BUILD_BUG_ON(sizeof_member(struct thread_struct, uw) !=
+		     sizeof_member(struct thread_struct, uw.tp_value) +
+		     sizeof_member(struct thread_struct, uw.tp2_value) +
+		     sizeof_member(struct thread_struct, uw.fpsimd_state));
 
 	*offset = offsetof(struct thread_struct, uw);
-	*size = sizeof_field(struct thread_struct, uw);
+	*size = sizeof_member(struct thread_struct, uw);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
index 44b506a14666..c2cbb6ca29f9 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
@@ -58,7 +58,7 @@ static struct cvmx_bootmem_desc *cvmx_bootmem_desc;
 #define CVMX_BOOTMEM_NAMED_GET_FIELD(addr, field)			\
 	__cvmx_bootmem_desc_get(addr,					\
 		offsetof(struct cvmx_bootmem_named_block_desc, field),	\
-		FIELD_SIZEOF(struct cvmx_bootmem_named_block_desc, field))
+		sizeof_member(struct cvmx_bootmem_named_block_desc, field))
 
 /**
  * This function is the implementation of the get macros defined
diff --git a/arch/powerpc/net/bpf_jit32.h b/arch/powerpc/net/bpf_jit32.h
index 6e5a2a4faeab..53da40df22c9 100644
--- a/arch/powerpc/net/bpf_jit32.h
+++ b/arch/powerpc/net/bpf_jit32.h
@@ -97,12 +97,12 @@ DECLARE_LOAD_FUNC(sk_load_byte_msh);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_PPC64
 #define PPC_BPF_LOAD_CPU(r)		\
-	do { BUILD_BUG_ON(FIELD_SIZEOF(struct paca_struct, paca_index) != 2);	\
+	do { BUILD_BUG_ON(sizeof_member(struct paca_struct, paca_index) != 2);	\
 		PPC_LHZ_OFFS(r, 13, offsetof(struct paca_struct, paca_index));	\
 	} while (0)
 #else
 #define PPC_BPF_LOAD_CPU(r)     \
-	do { BUILD_BUG_ON(FIELD_SIZEOF(struct task_struct, cpu) != 4);		\
+	do { BUILD_BUG_ON(sizeof_member(struct task_struct, cpu) != 4);		\
 		PPC_LHZ_OFFS(r, 2, offsetof(struct task_struct, cpu));		\
 	} while(0)
 #endif
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index d57b46e0dd60..c8eeee1ba987 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -321,7 +321,7 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			ctx->seen |= SEEN_XREG | SEEN_MEM | (1<<(K & 0xf));
 			break;
 		case BPF_LD | BPF_W | BPF_LEN: /*	A = skb->len; */
-			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, len) != 4);
+			BUILD_BUG_ON(sizeof_member(struct sk_buff, len) != 4);
 			PPC_LWZ_OFFS(r_A, r_skb, offsetof(struct sk_buff, len));
 			break;
 		case BPF_LDX | BPF_W | BPF_ABS: /* A = *((u32 *)(seccomp_data + K)); */
@@ -333,16 +333,16 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 
 			/*** Ancillary info loads ***/
 		case BPF_ANC | SKF_AD_PROTOCOL: /* A = ntohs(skb->protocol); */
-			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff,
+			BUILD_BUG_ON(sizeof_member(struct sk_buff,
 						  protocol) != 2);
 			PPC_NTOHS_OFFS(r_A, r_skb, offsetof(struct sk_buff,
 							    protocol));
 			break;
 		case BPF_ANC | SKF_AD_IFINDEX:
 		case BPF_ANC | SKF_AD_HATYPE:
-			BUILD_BUG_ON(FIELD_SIZEOF(struct net_device,
+			BUILD_BUG_ON(sizeof_member(struct net_device,
 						ifindex) != 4);
-			BUILD_BUG_ON(FIELD_SIZEOF(struct net_device,
+			BUILD_BUG_ON(sizeof_member(struct net_device,
 						type) != 2);
 			PPC_LL_OFFS(r_scratch1, r_skb, offsetof(struct sk_buff,
 								dev));
@@ -365,17 +365,17 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 
 			break;
 		case BPF_ANC | SKF_AD_MARK:
-			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, mark) != 4);
+			BUILD_BUG_ON(sizeof_member(struct sk_buff, mark) != 4);
 			PPC_LWZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
 							  mark));
 			break;
 		case BPF_ANC | SKF_AD_RXHASH:
-			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, hash) != 4);
+			BUILD_BUG_ON(sizeof_member(struct sk_buff, hash) != 4);
 			PPC_LWZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
 							  hash));
 			break;
 		case BPF_ANC | SKF_AD_VLAN_TAG:
-			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, vlan_tci) != 2);
+			BUILD_BUG_ON(sizeof_member(struct sk_buff, vlan_tci) != 2);
 
 			PPC_LHZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
 							  vlan_tci));
@@ -388,7 +388,7 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 				PPC_ANDI(r_A, r_A, 1);
 			break;
 		case BPF_ANC | SKF_AD_QUEUE:
-			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff,
+			BUILD_BUG_ON(sizeof_member(struct sk_buff,
 						  queue_mapping) != 2);
 			PPC_LHZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
 							  queue_mapping));
diff --git a/arch/sparc/net/bpf_jit_comp_32.c b/arch/sparc/net/bpf_jit_comp_32.c
index 84cc8f7f83e9..7bacb27356f3 100644
--- a/arch/sparc/net/bpf_jit_comp_32.c
+++ b/arch/sparc/net/bpf_jit_comp_32.c
@@ -180,19 +180,19 @@ do {									\
 
 #define emit_loadptr(BASE, STRUCT, FIELD, DEST)				\
 do {	unsigned int _off = offsetof(STRUCT, FIELD);			\
-	BUILD_BUG_ON(FIELD_SIZEOF(STRUCT, FIELD) != sizeof(void *));	\
+	BUILD_BUG_ON(sizeof_member(STRUCT, FIELD) != sizeof(void *));	\
 	*prog++ = LDPTRI | RS1(BASE) | S13(_off) | RD(DEST);		\
 } while (0)
 
 #define emit_load32(BASE, STRUCT, FIELD, DEST)				\
 do {	unsigned int _off = offsetof(STRUCT, FIELD);			\
-	BUILD_BUG_ON(FIELD_SIZEOF(STRUCT, FIELD) != sizeof(u32));	\
+	BUILD_BUG_ON(sizeof_member(STRUCT, FIELD) != sizeof(u32));	\
 	*prog++ = LD32I | RS1(BASE) | S13(_off) | RD(DEST);		\
 } while (0)
 
 #define emit_load16(BASE, STRUCT, FIELD, DEST)				\
 do {	unsigned int _off = offsetof(STRUCT, FIELD);			\
-	BUILD_BUG_ON(FIELD_SIZEOF(STRUCT, FIELD) != sizeof(u16));	\
+	BUILD_BUG_ON(sizeof_member(STRUCT, FIELD) != sizeof(u16));	\
 	*prog++ = LD16I | RS1(BASE) | S13(_off) | RD(DEST);		\
 } while (0)
 
@@ -202,7 +202,7 @@ do {	unsigned int _off = offsetof(STRUCT, FIELD);			\
 } while (0)
 
 #define emit_load8(BASE, STRUCT, FIELD, DEST)				\
-do {	BUILD_BUG_ON(FIELD_SIZEOF(STRUCT, FIELD) != sizeof(u8));	\
+do {	BUILD_BUG_ON(sizeof_member(STRUCT, FIELD) != sizeof(u8));	\
 	__emit_load8(BASE, STRUCT, FIELD, DEST);			\
 } while (0)
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index e5cb67d67c03..023b0a28e13b 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -257,7 +257,7 @@ static void __init setup_xstate_features(void)
 	xstate_offsets[0] = 0;
 	xstate_sizes[0] = offsetof(struct fxregs_state, xmm_space);
 	xstate_offsets[1] = xstate_sizes[0];
-	xstate_sizes[1] = FIELD_SIZEOF(struct fxregs_state, xmm_space);
+	xstate_sizes[1] = sizeof_member(struct fxregs_state, xmm_space);
 
 	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
 		if (!xfeature_enabled(i))
diff --git a/block/blk-core.c b/block/blk-core.c
index d5e668ec751b..fd6b31d400e7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1790,9 +1790,9 @@ int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(REQ_OP_LAST >= (1 << REQ_OP_BITS));
 	BUILD_BUG_ON(REQ_OP_BITS + REQ_FLAG_BITS > 8 *
-			FIELD_SIZEOF(struct request, cmd_flags));
+			sizeof_member(struct request, cmd_flags));
 	BUILD_BUG_ON(REQ_OP_BITS + REQ_FLAG_BITS > 8 *
-			FIELD_SIZEOF(struct bio, bi_opf));
+			sizeof_member(struct bio, bi_opf));
 
 	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
 	kblockd_workqueue = alloc_workqueue("kblockd",
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 395a3ddd3707..d79d901afd28 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -435,10 +435,10 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 
 	BUILD_BUG_ON(offsetofend(struct adiantum_request_ctx, u) !=
 		     sizeof(struct adiantum_request_ctx));
-	subreq_size = max(FIELD_SIZEOF(struct adiantum_request_ctx,
+	subreq_size = max(sizeof_member(struct adiantum_request_ctx,
 				       u.hash_desc) +
 			  crypto_shash_descsize(hash),
-			  FIELD_SIZEOF(struct adiantum_request_ctx,
+			  sizeof_member(struct adiantum_request_ctx,
 				       u.streamcipher_req) +
 			  crypto_skcipher_reqsize(streamcipher));
 
diff --git a/crypto/essiv.c b/crypto/essiv.c
index a8befc8fb06e..fd5a87baafff 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -348,7 +348,7 @@ static int essiv_aead_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(aead))
 		return PTR_ERR(aead);
 
-	subreq_size = FIELD_SIZEOF(struct essiv_aead_request_ctx, aead_req) +
+	subreq_size = sizeof_member(struct essiv_aead_request_ctx, aead_req) +
 		      crypto_aead_reqsize(aead);
 
 	tctx->ivoffset = offsetof(struct essiv_aead_request_ctx, aead_req) +
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 8d3e778e988b..17d32fb72c9a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -670,7 +670,7 @@ device_initcall(efi_load_efivars);
 		{ name },				   \
 		{ prop },				   \
 		offsetof(struct efi_fdt_params, field),    \
-		FIELD_SIZEOF(struct efi_fdt_params, field) \
+		sizeof_member(struct efi_fdt_params, field) \
 	}
 
 struct params {
diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 6c79d16b381e..76c2db58adcd 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -1280,7 +1280,7 @@ int intel_vgpu_setup_submission(struct intel_vgpu *vgpu)
 						  sizeof(struct intel_vgpu_workload), 0,
 						  SLAB_HWCACHE_ALIGN,
 						  offsetof(struct intel_vgpu_workload, rb_tail),
-						  sizeof_field(struct intel_vgpu_workload, rb_tail),
+						  sizeof_member(struct intel_vgpu_workload, rb_tail),
 						  NULL);
 
 	if (!s->workloads) {
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 4edae89e8e3c..d5b396913875 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -148,7 +148,7 @@ static inline struct efa_ah *to_eah(struct ib_ah *ibah)
 }
 
 #define field_avail(x, fld, sz) (offsetof(typeof(x), fld) + \
-				 FIELD_SIZEOF(typeof(x), fld) <= (sz))
+				 sizeof_member(typeof(x), fld) <= (sz))
 
 #define is_reserved_cleared(reserved) \
 	!memchr_inv(reserved, 0, sizeof(reserved))
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 2395fd4233a7..a772955bd2ad 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -847,7 +847,7 @@ static const struct rhashtable_params sdma_rht_params = {
 	.nelem_hint = NR_CPUS_HINT,
 	.head_offset = offsetof(struct sdma_rht_node, node),
 	.key_offset = offsetof(struct sdma_rht_node, cpu_id),
-	.key_len = FIELD_SIZEOF(struct sdma_rht_node, cpu_id),
+	.key_len = sizeof_member(struct sdma_rht_node, cpu_id),
 	.max_size = NR_CPUS,
 	.min_size = 8,
 	.automatic_shrinking = true,
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index ae9582ddbc8f..95a0c0b73387 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -107,9 +107,9 @@ enum {
 	HFI1_HAS_GRH = (1 << 0),
 };
 
-#define LRH_16B_BYTES (FIELD_SIZEOF(struct hfi1_16b_header, lrh))
+#define LRH_16B_BYTES (sizeof_member(struct hfi1_16b_header, lrh))
 #define LRH_16B_DWORDS (LRH_16B_BYTES / sizeof(u32))
-#define LRH_9B_BYTES (FIELD_SIZEOF(struct ib_header, lrh))
+#define LRH_9B_BYTES (sizeof_member(struct ib_header, lrh))
 #define LRH_9B_DWORDS (LRH_9B_BYTES / sizeof(u32))
 
 /* 24Bits for qpn, upper 8Bits reserved */
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
index 62390e9e0023..0fcbfd259ba5 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
@@ -63,7 +63,7 @@ struct vnic_stats {
 	};
 };
 
-#define VNIC_STAT(m)            { FIELD_SIZEOF(struct opa_vnic_stats, m),   \
+#define VNIC_STAT(m)            { sizeof_member(struct opa_vnic_stats, m),   \
 				  offsetof(struct opa_vnic_stats, m) }
 
 static struct vnic_stats vnic_gstrings_stats[] = {
diff --git a/drivers/input/keyboard/applespi.c b/drivers/input/keyboard/applespi.c
index d38398526965..06f652db62a3 100644
--- a/drivers/input/keyboard/applespi.c
+++ b/drivers/input/keyboard/applespi.c
@@ -1127,7 +1127,7 @@ applespi_handle_keyboard_event(struct applespi_data *applespi,
 	int i;
 
 	compiletime_assert(ARRAY_SIZE(applespi_controlcodes) ==
-			   sizeof_field(struct keyboard_protocol, modifiers) * 8,
+			   sizeof_member(struct keyboard_protocol, modifiers) * 8,
 			   "applespi_controlcodes has wrong number of entries");
 
 	/* check for rollover overflow, which is signalled by all keys == 1 */
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 18a4064a61a8..51e070a9c5e6 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1360,7 +1360,7 @@ int ppl_init_log(struct r5conf *conf)
 		return -EINVAL;
 	}
 
-	max_disks = FIELD_SIZEOF(struct ppl_log, disk_flush_bitmap) *
+	max_disks = sizeof_member(struct ppl_log, disk_flush_bitmap) *
 		BITS_PER_BYTE;
 	if (conf->raid_disks > max_disks) {
 		pr_warn("md/raid:%s PPL doesn't support over %d disks in the array\n",
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 97d660606d98..80af109171ef 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -753,7 +753,7 @@ static const struct preview_update update_attrs[] = {
 		preview_config_luma_enhancement,
 		preview_enable_luma_enhancement,
 		offsetof(struct prev_params, luma),
-		FIELD_SIZEOF(struct prev_params, luma),
+		sizeof_member(struct prev_params, luma),
 		offsetof(struct omap3isp_prev_update_config, luma),
 	}, /* OMAP3ISP_PREV_INVALAW */ {
 		NULL,
@@ -762,55 +762,55 @@ static const struct preview_update update_attrs[] = {
 		preview_config_hmed,
 		preview_enable_hmed,
 		offsetof(struct prev_params, hmed),
-		FIELD_SIZEOF(struct prev_params, hmed),
+		sizeof_member(struct prev_params, hmed),
 		offsetof(struct omap3isp_prev_update_config, hmed),
 	}, /* OMAP3ISP_PREV_CFA */ {
 		preview_config_cfa,
 		NULL,
 		offsetof(struct prev_params, cfa),
-		FIELD_SIZEOF(struct prev_params, cfa),
+		sizeof_member(struct prev_params, cfa),
 		offsetof(struct omap3isp_prev_update_config, cfa),
 	}, /* OMAP3ISP_PREV_CHROMA_SUPP */ {
 		preview_config_chroma_suppression,
 		preview_enable_chroma_suppression,
 		offsetof(struct prev_params, csup),
-		FIELD_SIZEOF(struct prev_params, csup),
+		sizeof_member(struct prev_params, csup),
 		offsetof(struct omap3isp_prev_update_config, csup),
 	}, /* OMAP3ISP_PREV_WB */ {
 		preview_config_whitebalance,
 		NULL,
 		offsetof(struct prev_params, wbal),
-		FIELD_SIZEOF(struct prev_params, wbal),
+		sizeof_member(struct prev_params, wbal),
 		offsetof(struct omap3isp_prev_update_config, wbal),
 	}, /* OMAP3ISP_PREV_BLKADJ */ {
 		preview_config_blkadj,
 		NULL,
 		offsetof(struct prev_params, blkadj),
-		FIELD_SIZEOF(struct prev_params, blkadj),
+		sizeof_member(struct prev_params, blkadj),
 		offsetof(struct omap3isp_prev_update_config, blkadj),
 	}, /* OMAP3ISP_PREV_RGB2RGB */ {
 		preview_config_rgb_blending,
 		NULL,
 		offsetof(struct prev_params, rgb2rgb),
-		FIELD_SIZEOF(struct prev_params, rgb2rgb),
+		sizeof_member(struct prev_params, rgb2rgb),
 		offsetof(struct omap3isp_prev_update_config, rgb2rgb),
 	}, /* OMAP3ISP_PREV_COLOR_CONV */ {
 		preview_config_csc,
 		NULL,
 		offsetof(struct prev_params, csc),
-		FIELD_SIZEOF(struct prev_params, csc),
+		sizeof_member(struct prev_params, csc),
 		offsetof(struct omap3isp_prev_update_config, csc),
 	}, /* OMAP3ISP_PREV_YC_LIMIT */ {
 		preview_config_yc_range,
 		NULL,
 		offsetof(struct prev_params, yclimit),
-		FIELD_SIZEOF(struct prev_params, yclimit),
+		sizeof_member(struct prev_params, yclimit),
 		offsetof(struct omap3isp_prev_update_config, yclimit),
 	}, /* OMAP3ISP_PREV_DEFECT_COR */ {
 		preview_config_dcor,
 		preview_enable_dcor,
 		offsetof(struct prev_params, dcor),
-		FIELD_SIZEOF(struct prev_params, dcor),
+		sizeof_member(struct prev_params, dcor),
 		offsetof(struct omap3isp_prev_update_config, dcor),
 	}, /* Previously OMAP3ISP_PREV_GAMMABYPASS, not used anymore */ {
 		NULL,
@@ -828,13 +828,13 @@ static const struct preview_update update_attrs[] = {
 		preview_config_noisefilter,
 		preview_enable_noisefilter,
 		offsetof(struct prev_params, nf),
-		FIELD_SIZEOF(struct prev_params, nf),
+		sizeof_member(struct prev_params, nf),
 		offsetof(struct omap3isp_prev_update_config, nf),
 	}, /* OMAP3ISP_PREV_GAMMA */ {
 		preview_config_gammacorrn,
 		preview_enable_gammacorrn,
 		offsetof(struct prev_params, gamma),
-		FIELD_SIZEOF(struct prev_params, gamma),
+		sizeof_member(struct prev_params, gamma),
 		offsetof(struct omap3isp_prev_update_config, gamma),
 	}, /* OMAP3ISP_PREV_CONTRAST */ {
 		preview_config_contrast,
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index a880f10e3e70..6a757dadb5f1 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -129,13 +129,13 @@ struct xgbe_stats {
 
 #define XGMAC_MMC_STAT(_string, _var)				\
 	{ _string,						\
-	  FIELD_SIZEOF(struct xgbe_mmc_stats, _var),		\
+	  sizeof_member(struct xgbe_mmc_stats, _var),		\
 	  offsetof(struct xgbe_prv_data, mmc_stats._var),	\
 	}
 
 #define XGMAC_EXT_STAT(_string, _var)				\
 	{ _string,						\
-	  FIELD_SIZEOF(struct xgbe_ext_stats, _var),		\
+	  sizeof_member(struct xgbe_ext_stats, _var),		\
 	  offsetof(struct xgbe_prv_data, ext_stats._var),	\
 	}
 
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
index 0cc2338d8d2a..d3df9e7e35be 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
@@ -205,11 +205,11 @@ static int __cvmx_bootmem_check_version(struct octeon_device *oct,
 	major_version = (u32)__cvmx_bootmem_desc_get(
 			oct, oct->bootmem_desc_addr,
 			offsetof(struct cvmx_bootmem_desc, major_version),
-			FIELD_SIZEOF(struct cvmx_bootmem_desc, major_version));
+			sizeof_member(struct cvmx_bootmem_desc, major_version));
 	minor_version = (u32)__cvmx_bootmem_desc_get(
 			oct, oct->bootmem_desc_addr,
 			offsetof(struct cvmx_bootmem_desc, minor_version),
-			FIELD_SIZEOF(struct cvmx_bootmem_desc, minor_version));
+			sizeof_member(struct cvmx_bootmem_desc, minor_version));
 
 	dev_dbg(&oct->pci_dev->dev, "%s: major_version=%d\n", __func__,
 		major_version);
@@ -237,13 +237,13 @@ static const struct cvmx_bootmem_named_block_desc
 				oct, named_addr,
 				offsetof(struct cvmx_bootmem_named_block_desc,
 					 base_addr),
-				FIELD_SIZEOF(
+				sizeof_member(
 					struct cvmx_bootmem_named_block_desc,
 					base_addr));
 		desc->size = __cvmx_bootmem_desc_get(oct, named_addr,
 				offsetof(struct cvmx_bootmem_named_block_desc,
 					 size),
-				FIELD_SIZEOF(
+				sizeof_member(
 					struct cvmx_bootmem_named_block_desc,
 					size));
 
@@ -268,20 +268,20 @@ static u64 cvmx_bootmem_phy_named_block_find(struct octeon_device *oct,
 					oct, oct->bootmem_desc_addr,
 					offsetof(struct cvmx_bootmem_desc,
 						 named_block_array_addr),
-					FIELD_SIZEOF(struct cvmx_bootmem_desc,
+					sizeof_member(struct cvmx_bootmem_desc,
 						     named_block_array_addr));
 		u32 num_blocks = (u32)__cvmx_bootmem_desc_get(
 					oct, oct->bootmem_desc_addr,
 					offsetof(struct cvmx_bootmem_desc,
 						 nb_num_blocks),
-					FIELD_SIZEOF(struct cvmx_bootmem_desc,
+					sizeof_member(struct cvmx_bootmem_desc,
 						     nb_num_blocks));
 
 		u32 name_length = (u32)__cvmx_bootmem_desc_get(
 					oct, oct->bootmem_desc_addr,
 					offsetof(struct cvmx_bootmem_desc,
 						 named_block_name_len),
-					FIELD_SIZEOF(struct cvmx_bootmem_desc,
+					sizeof_member(struct cvmx_bootmem_desc,
 						     named_block_name_len));
 
 		u64 named_addr = named_block_array_addr;
@@ -292,7 +292,7 @@ static u64 cvmx_bootmem_phy_named_block_find(struct octeon_device *oct,
 					 offsetof(
 					struct cvmx_bootmem_named_block_desc,
 					size),
-					 FIELD_SIZEOF(
+					 sizeof_member(
 					struct cvmx_bootmem_named_block_desc,
 					size));
 
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 5bb5abf99588..1e476b39eb0a 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -23,7 +23,7 @@ struct be_ethtool_stat {
 };
 
 enum {DRVSTAT_TX, DRVSTAT_RX, DRVSTAT};
-#define FIELDINFO(_struct, field) FIELD_SIZEOF(_struct, field), \
+#define FIELDINFO(_struct, field) sizeof_member(_struct, field), \
 					offsetof(_struct, field)
 #define DRVSTAT_TX_INFO(field)	#field, DRVSTAT_TX,\
 					FIELDINFO(struct be_tx_stats, field)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fd7f94372ff0..491acfe19e2a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9798,7 +9798,7 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 		return ret;
 	}
 
-	data_len_per_desc = FIELD_SIZEOF(struct hclge_desc, data);
+	data_len_per_desc = sizeof_member(struct hclge_desc, data);
 	*len = 0;
 	for (i = 0; i < dfx_reg_type_num; i++) {
 		bd_num = bd_num_list[i];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 9f0e35f27789..a0f08f94b12b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -564,7 +564,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	}
 
 	memcpy(kinfo->prio_tc, hdev->tm_info.prio_tc,
-	       FIELD_SIZEOF(struct hnae3_knic_private_info, prio_tc));
+	       sizeof_member(struct hnae3_knic_private_info, prio_tc));
 }
 
 static void hclge_tm_vport_info_update(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 60ec48fe4144..61145678ee1c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -450,7 +450,7 @@ static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
 
 #define HINIC_FUNC_STAT(_stat_item) {	\
 	.name = #_stat_item, \
-	.size = FIELD_SIZEOF(struct hinic_vport_stats, _stat_item), \
+	.size = sizeof_member(struct hinic_vport_stats, _stat_item), \
 	.offset = offsetof(struct hinic_vport_stats, _stat_item) \
 }
 
@@ -477,7 +477,7 @@ static struct hinic_stats hinic_function_stats[] = {
 
 #define HINIC_PORT_STAT(_stat_item) { \
 	.name = #_stat_item, \
-	.size = FIELD_SIZEOF(struct hinic_phy_port_stats, _stat_item), \
+	.size = sizeof_member(struct hinic_phy_port_stats, _stat_item), \
 	.offset = offsetof(struct hinic_phy_port_stats, _stat_item) \
 }
 
@@ -571,7 +571,7 @@ static struct hinic_stats hinic_port_stats[] = {
 
 #define HINIC_TXQ_STAT(_stat_item) { \
 	.name = "txq%d_"#_stat_item, \
-	.size = FIELD_SIZEOF(struct hinic_txq_stats, _stat_item), \
+	.size = sizeof_member(struct hinic_txq_stats, _stat_item), \
 	.offset = offsetof(struct hinic_txq_stats, _stat_item) \
 }
 
@@ -586,7 +586,7 @@ static struct hinic_stats hinic_tx_queue_stats[] = {
 
 #define HINIC_RXQ_STAT(_stat_item) { \
 	.name = "rxq%d_"#_stat_item, \
-	.size = FIELD_SIZEOF(struct hinic_rxq_stats, _stat_item), \
+	.size = sizeof_member(struct hinic_rxq_stats, _stat_item), \
 	.offset = offsetof(struct hinic_rxq_stats, _stat_item) \
 }
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index c681d2d28107..30d54afad073 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -18,7 +18,7 @@ struct fm10k_stats {
 
 #define FM10K_STAT_FIELDS(_type, _name, _stat) { \
 	.stat_string = _name, \
-	.sizeof_stat = FIELD_SIZEOF(_type, _stat), \
+	.sizeof_stat = sizeof_member(_type, _stat), \
 	.stat_offset = offsetof(_type, _stat) \
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 41e1240acaea..8b0c60d754e1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -43,7 +43,7 @@ struct i40e_stats {
  */
 #define I40E_STAT(_type, _name, _stat) { \
 	.stat_string = _name, \
-	.sizeof_stat = FIELD_SIZEOF(_type, _stat), \
+	.sizeof_stat = sizeof_member(_type, _stat), \
 	.stat_offset = offsetof(_type, _stat) \
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
index be24d42280d8..e1fb95679c75 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
@@ -659,7 +659,7 @@ i40e_status i40e_shutdown_lan_hmc(struct i40e_hw *hw)
 
 #define I40E_HMC_STORE(_struct, _ele)		\
 	offsetof(struct _struct, _ele),		\
-	FIELD_SIZEOF(struct _struct, _ele)
+	sizeof_member(struct _struct, _ele)
 
 struct i40e_context_ele {
 	u16 offset;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index dad3eec8ccd8..8f0b462b8dca 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -42,7 +42,7 @@ struct iavf_stats {
  */
 #define IAVF_STAT(_type, _name, _stat) { \
 	.stat_string = _name, \
-	.sizeof_stat = FIELD_SIZEOF(_type, _stat), \
+	.sizeof_stat = sizeof_member(_type, _stat), \
 	.stat_offset = offsetof(_type, _stat) \
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 7e23034df955..cde113e7de41 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -15,7 +15,7 @@ struct ice_stats {
 
 #define ICE_STAT(_type, _name, _stat) { \
 	.stat_string = _name, \
-	.sizeof_stat = FIELD_SIZEOF(_type, _stat), \
+	.sizeof_stat = sizeof_member(_type, _stat), \
 	.stat_offset = offsetof(_type, _stat) \
 }
 
@@ -36,10 +36,10 @@ static int ice_q_stats_len(struct net_device *netdev)
 #define ICE_VSI_STATS_LEN	ARRAY_SIZE(ice_gstrings_vsi_stats)
 
 #define ICE_PFC_STATS_LEN ( \
-		(FIELD_SIZEOF(struct ice_pf, stats.priority_xoff_rx) + \
-		 FIELD_SIZEOF(struct ice_pf, stats.priority_xon_rx) + \
-		 FIELD_SIZEOF(struct ice_pf, stats.priority_xoff_tx) + \
-		 FIELD_SIZEOF(struct ice_pf, stats.priority_xon_tx)) \
+		(sizeof_member(struct ice_pf, stats.priority_xoff_rx) + \
+		 sizeof_member(struct ice_pf, stats.priority_xon_rx) + \
+		 sizeof_member(struct ice_pf, stats.priority_xoff_tx) + \
+		 sizeof_member(struct ice_pf, stats.priority_xon_tx)) \
 		 / sizeof(u64))
 #define ICE_ALL_STATS_LEN(n)	(ICE_PF_STATS_LEN + ICE_PFC_STATS_LEN + \
 				 ICE_VSI_STATS_LEN + ice_q_stats_len(n))
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 2aac8f13daeb..b5867b42ca2f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -302,7 +302,7 @@ struct ice_ctx_ele {
 
 #define ICE_CTX_STORE(_struct, _ele, _width, _lsb) {	\
 	.offset = offsetof(struct _struct, _ele),	\
-	.size_of = FIELD_SIZEOF(struct _struct, _ele),	\
+	.size_of = sizeof_member(struct _struct, _ele),	\
 	.width = _width,				\
 	.lsb = _lsb,					\
 }
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 3182b059bf55..a98c224e24a4 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -26,7 +26,7 @@ struct igb_stats {
 
 #define IGB_STAT(_name, _stat) { \
 	.stat_string = _name, \
-	.sizeof_stat = FIELD_SIZEOF(struct igb_adapter, _stat), \
+	.sizeof_stat = sizeof_member(struct igb_adapter, _stat), \
 	.stat_offset = offsetof(struct igb_adapter, _stat) \
 }
 static const struct igb_stats igb_gstrings_stats[] = {
@@ -76,7 +76,7 @@ static const struct igb_stats igb_gstrings_stats[] = {
 
 #define IGB_NETDEV_STAT(_net_stat) { \
 	.stat_string = __stringify(_net_stat), \
-	.sizeof_stat = FIELD_SIZEOF(struct rtnl_link_stats64, _net_stat), \
+	.sizeof_stat = sizeof_member(struct rtnl_link_stats64, _net_stat), \
 	.stat_offset = offsetof(struct rtnl_link_stats64, _net_stat) \
 }
 static const struct igb_stats igb_gstrings_net_stats[] = {
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index ac98f1d96892..58a30aaf299a 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -16,7 +16,7 @@ struct igc_stats {
 
 #define IGC_STAT(_name, _stat) { \
 	.stat_string = _name, \
-	.sizeof_stat = FIELD_SIZEOF(struct igc_adapter, _stat), \
+	.sizeof_stat = sizeof_member(struct igc_adapter, _stat), \
 	.stat_offset = offsetof(struct igc_adapter, _stat) \
 }
 
@@ -67,7 +67,7 @@ static const struct igc_stats igc_gstrings_stats[] = {
 
 #define IGC_NETDEV_STAT(_net_stat) { \
 	.stat_string = __stringify(_net_stat), \
-	.sizeof_stat = FIELD_SIZEOF(struct rtnl_link_stats64, _net_stat), \
+	.sizeof_stat = sizeof_member(struct rtnl_link_stats64, _net_stat), \
 	.stat_offset = offsetof(struct rtnl_link_stats64, _net_stat) \
 }
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
index c8c93ac436d4..cbdc7146bb94 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
@@ -19,10 +19,10 @@ struct ixgb_stats {
 };
 
 #define IXGB_STAT(m)		IXGB_STATS, \
-				FIELD_SIZEOF(struct ixgb_adapter, m), \
+				sizeof_member(struct ixgb_adapter, m), \
 				offsetof(struct ixgb_adapter, m)
 #define IXGB_NETDEV_STAT(m)	NETDEV_STATS, \
-				FIELD_SIZEOF(struct net_device, m), \
+				sizeof_member(struct net_device, m), \
 				offsetof(struct net_device, m)
 
 static struct ixgb_stats ixgb_gstrings_stats[] = {
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 54459b69c948..3dc0eac0aa9e 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -31,14 +31,14 @@ struct ixgbe_stats {
 #define IXGBEVF_STAT(_name, _stat) { \
 	.stat_string = _name, \
 	.type = IXGBEVF_STATS, \
-	.sizeof_stat = FIELD_SIZEOF(struct ixgbevf_adapter, _stat), \
+	.sizeof_stat = sizeof_member(struct ixgbevf_adapter, _stat), \
 	.stat_offset = offsetof(struct ixgbevf_adapter, _stat) \
 }
 
 #define IXGBEVF_NETDEV_STAT(_net_stat) { \
 	.stat_string = #_net_stat, \
 	.type = NETDEV_STATS, \
-	.sizeof_stat = FIELD_SIZEOF(struct net_device_stats, _net_stat), \
+	.sizeof_stat = sizeof_member(struct net_device_stats, _net_stat), \
 	.stat_offset = offsetof(struct net_device_stats, _net_stat) \
 }
 
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 82ea55ae5053..6d3b7032f842 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1432,11 +1432,11 @@ struct mv643xx_eth_stats {
 };
 
 #define SSTAT(m)						\
-	{ #m, FIELD_SIZEOF(struct net_device_stats, m),		\
+	{ #m, sizeof_member(struct net_device_stats, m),		\
 	  offsetof(struct net_device, stats.m), -1 }
 
 #define MIBSTAT(m)						\
-	{ #m, FIELD_SIZEOF(struct mib_counters, m),		\
+	{ #m, sizeof_member(struct mib_counters, m),		\
 	  -1, offsetof(struct mv643xx_eth_private, mib_counters.m) }
 
 static const struct mv643xx_eth_stats mv643xx_eth_stats[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index d8313e2ee600..f421699d745b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -611,7 +611,7 @@ static u32 ptys_get_active_port(struct mlx4_ptys_reg *ptys_reg)
 }
 
 #define MLX4_LINK_MODES_SZ \
-	(FIELD_SIZEOF(struct mlx4_ptys_reg, eth_proto_cap) * 8)
+	(sizeof_member(struct mlx4_ptys_reg, eth_proto_cap) * 8)
 
 enum ethtool_report {
 	SUPPORTED = 0,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index c76da309506b..9d27b368ba94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -87,10 +87,10 @@ static const struct rhashtable_params rhash_sa = {
 	 * value is not constant during the lifetime
 	 * of the key object.
 	 */
-	.key_len = FIELD_SIZEOF(struct mlx5_fpga_ipsec_sa_ctx, hw_sa) -
-		   FIELD_SIZEOF(struct mlx5_ifc_fpga_ipsec_sa_v1, cmd),
+	.key_len = sizeof_member(struct mlx5_fpga_ipsec_sa_ctx, hw_sa) -
+		   sizeof_member(struct mlx5_ifc_fpga_ipsec_sa_v1, cmd),
 	.key_offset = offsetof(struct mlx5_fpga_ipsec_sa_ctx, hw_sa) +
-		      FIELD_SIZEOF(struct mlx5_ifc_fpga_ipsec_sa_v1, cmd),
+		      sizeof_member(struct mlx5_ifc_fpga_ipsec_sa_v1, cmd),
 	.head_offset = offsetof(struct mlx5_fpga_ipsec_sa_ctx, hash),
 	.automatic_shrinking = true,
 	.min_size = 1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3bbb49354829..82e6972f68b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -209,7 +209,7 @@ enum fs_i_lock_class {
 };
 
 static const struct rhashtable_params rhash_fte = {
-	.key_len = FIELD_SIZEOF(struct fs_fte, val),
+	.key_len = sizeof_member(struct fs_fte, val),
 	.key_offset = offsetof(struct fs_fte, val),
 	.head_offset = offsetof(struct fs_fte, hash),
 	.automatic_shrinking = true,
@@ -217,7 +217,7 @@ static const struct rhashtable_params rhash_fte = {
 };
 
 static const struct rhashtable_params rhash_fg = {
-	.key_len = FIELD_SIZEOF(struct mlx5_flow_group, mask),
+	.key_len = sizeof_member(struct mlx5_flow_group, mask),
 	.key_offset = offsetof(struct mlx5_flow_group, mask),
 	.head_offset = offsetof(struct mlx5_flow_group, hash),
 	.automatic_shrinking = true,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 8df3cb21baa6..cc4a65d38847 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -49,13 +49,13 @@ struct mlxsw_sp_fid_8021d {
 };
 
 static const struct rhashtable_params mlxsw_sp_fid_ht_params = {
-	.key_len = sizeof_field(struct mlxsw_sp_fid, fid_index),
+	.key_len = sizeof_member(struct mlxsw_sp_fid, fid_index),
 	.key_offset = offsetof(struct mlxsw_sp_fid, fid_index),
 	.head_offset = offsetof(struct mlxsw_sp_fid, ht_node),
 };
 
 static const struct rhashtable_params mlxsw_sp_fid_vni_ht_params = {
-	.key_len = sizeof_field(struct mlxsw_sp_fid, vni),
+	.key_len = sizeof_member(struct mlxsw_sp_fid, vni),
 	.key_offset = offsetof(struct mlxsw_sp_fid, vni),
 	.head_offset = offsetof(struct mlxsw_sp_fid, vni_ht_node),
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index ec2ff3d7f41c..ac64d004c126 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -53,7 +53,7 @@ struct mlxsw_sp1_ptp_unmatched {
 };
 
 static const struct rhashtable_params mlxsw_sp1_ptp_unmatched_ht_params = {
-	.key_len = sizeof_field(struct mlxsw_sp1_ptp_unmatched, key),
+	.key_len = sizeof_member(struct mlxsw_sp1_ptp_unmatched, key),
 	.key_offset = offsetof(struct mlxsw_sp1_ptp_unmatched, key),
 	.head_offset = offsetof(struct mlxsw_sp1_ptp_unmatched, ht_node),
 };
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index 5afcb3c4c2ef..276af07a2841 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -2652,17 +2652,17 @@ static int mem_ldx_skb(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 	switch (meta->insn.off) {
 	case offsetof(struct __sk_buff, len):
-		if (size != FIELD_SIZEOF(struct __sk_buff, len))
+		if (size != sizeof_member(struct __sk_buff, len))
 			return -EOPNOTSUPP;
 		wrp_mov(nfp_prog, dst, plen_reg(nfp_prog));
 		break;
 	case offsetof(struct __sk_buff, data):
-		if (size != FIELD_SIZEOF(struct __sk_buff, data))
+		if (size != sizeof_member(struct __sk_buff, data))
 			return -EOPNOTSUPP;
 		wrp_mov(nfp_prog, dst, pptr_reg(nfp_prog));
 		break;
 	case offsetof(struct __sk_buff, data_end):
-		if (size != FIELD_SIZEOF(struct __sk_buff, data_end))
+		if (size != sizeof_member(struct __sk_buff, data_end))
 			return -EOPNOTSUPP;
 		emit_alu(nfp_prog, dst,
 			 plen_reg(nfp_prog), ALU_OP_ADD, pptr_reg(nfp_prog));
@@ -2683,12 +2683,12 @@ static int mem_ldx_xdp(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 	switch (meta->insn.off) {
 	case offsetof(struct xdp_md, data):
-		if (size != FIELD_SIZEOF(struct xdp_md, data))
+		if (size != sizeof_member(struct xdp_md, data))
 			return -EOPNOTSUPP;
 		wrp_mov(nfp_prog, dst, pptr_reg(nfp_prog));
 		break;
 	case offsetof(struct xdp_md, data_end):
-		if (size != FIELD_SIZEOF(struct xdp_md, data_end))
+		if (size != sizeof_member(struct xdp_md, data_end))
 			return -EOPNOTSUPP;
 		emit_alu(nfp_prog, dst,
 			 plen_reg(nfp_prog), ALU_OP_ADD, pptr_reg(nfp_prog));
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 8f732771d3fa..8c73449bd160 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -15,7 +15,7 @@
 
 const struct rhashtable_params nfp_bpf_maps_neutral_params = {
 	.nelem_hint		= 4,
-	.key_len		= FIELD_SIZEOF(struct bpf_map, id),
+	.key_len		= sizeof_member(struct bpf_map, id),
 	.key_offset		= offsetof(struct nfp_bpf_neutral_map, map_id),
 	.head_offset		= offsetof(struct nfp_bpf_neutral_map, l),
 	.automatic_shrinking	= true,
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 88fab6a82acf..496a08fd6077 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -376,7 +376,7 @@ nfp_bpf_map_alloc(struct nfp_app_bpf *bpf, struct bpf_offloaded_map *offmap)
 	}
 
 	use_map_size = DIV_ROUND_UP(offmap->map.value_size, 4) *
-		       FIELD_SIZEOF(struct nfp_bpf_map, use_map[0]);
+		       sizeof_member(struct nfp_bpf_map, use_map[0]);
 
 	nfp_map = kzalloc(sizeof(*nfp_map) + use_map_size, GFP_USER);
 	if (!nfp_map)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 31d94592a7c0..72dfc07cbcde 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -24,7 +24,7 @@ struct nfp_app;
 #define NFP_FL_STAT_ID_MU_NUM		GENMASK(31, 22)
 #define NFP_FL_STAT_ID_STAT		GENMASK(21, 0)
 
-#define NFP_FL_STATS_ELEM_RS		FIELD_SIZEOF(struct nfp_fl_stats_id, \
+#define NFP_FL_STATS_ELEM_RS		sizeof_member(struct nfp_fl_stats_id, \
 						     init_unalloc)
 #define NFP_FLOWER_MASK_ENTRY_RS	256
 #define NFP_FLOWER_MASK_ELEMENT_RS	1
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 1a3008e33182..31e6d4644aa3 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -20,7 +20,7 @@ struct pch_gbe_stats {
 #define PCH_GBE_STAT(m)						\
 {								\
 	.string = #m,						\
-	.size = FIELD_SIZEOF(struct pch_gbe_hw_stats, m),	\
+	.size = sizeof_member(struct pch_gbe_hw_stats, m),	\
 	.offset = offsetof(struct pch_gbe_hw_stats, m),		\
 }
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index c303a92d5b06..452baf374c9c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -464,7 +464,7 @@ struct qede_fastpath {
 	struct qede_tx_queue	*txq;
 	struct qede_tx_queue	*xdp_tx;
 
-#define VEC_NAME_SIZE  (FIELD_SIZEOF(struct net_device, name) + 8)
+#define VEC_NAME_SIZE  (sizeof_member(struct net_device, name) + 8)
 	char	name[VEC_NAME_SIZE];
 };
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index a4cd6f2cfb86..e317f7b3a9cf 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -20,7 +20,7 @@ struct qlcnic_stats {
 	int stat_offset;
 };
 
-#define QLC_SIZEOF(m) FIELD_SIZEOF(struct qlcnic_adapter, m)
+#define QLC_SIZEOF(m) sizeof_member(struct qlcnic_adapter, m)
 #define QLC_OFF(m) offsetof(struct qlcnic_adapter, m)
 static const u32 qlcnic_fw_dump_level[] = {
 	0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 0775b9464b4e..52aeda83c7e3 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -30,7 +30,7 @@ struct sxgbe_stats {
 #define SXGBE_STAT(m)						\
 {								\
 	#m,							\
-	FIELD_SIZEOF(struct sxgbe_extra_stats, m),		\
+	sizeof_member(struct sxgbe_extra_stats, m),		\
 	offsetof(struct sxgbe_priv_data, xstats.m)		\
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1a768837ca72..fb025709d572 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -34,7 +34,7 @@ struct stmmac_stats {
 };
 
 #define STMMAC_STAT(m)	\
-	{ #m, FIELD_SIZEOF(struct stmmac_extra_stats, m),	\
+	{ #m, sizeof_member(struct stmmac_extra_stats, m),	\
 	offsetof(struct stmmac_priv, xstats.m)}
 
 static const struct stmmac_stats stmmac_gstrings_stats[] = {
@@ -163,7 +163,7 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 
 /* HW MAC Management counters (if supported) */
 #define STMMAC_MMC_STAT(m)	\
-	{ #m, FIELD_SIZEOF(struct stmmac_counters, m),	\
+	{ #m, sizeof_member(struct stmmac_counters, m),	\
 	offsetof(struct stmmac_priv, mmc.m)}
 
 static const struct stmmac_stats stmmac_mmc[] = {
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 31248a6cc642..4e380bc92f33 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -73,13 +73,13 @@ enum {
 };
 
 #define CPSW_STAT(m)		CPSW_STATS,				\
-				FIELD_SIZEOF(struct cpsw_hw_stats, m), \
+				sizeof_member(struct cpsw_hw_stats, m), \
 				offsetof(struct cpsw_hw_stats, m)
 #define CPDMA_RX_STAT(m)	CPDMA_RX_STATS,				   \
-				FIELD_SIZEOF(struct cpdma_chan_stats, m), \
+				sizeof_member(struct cpdma_chan_stats, m), \
 				offsetof(struct cpdma_chan_stats, m)
 #define CPDMA_TX_STAT(m)	CPDMA_TX_STATS,				   \
-				FIELD_SIZEOF(struct cpdma_chan_stats, m), \
+				sizeof_member(struct cpdma_chan_stats, m), \
 				offsetof(struct cpdma_chan_stats, m)
 
 static const struct cpsw_stats cpsw_gstrings_stats[] = {
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 2c1fac33136c..452597f7f5ae 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -783,28 +783,28 @@ struct netcp_ethtool_stat {
 #define GBE_STATSA_INFO(field)						\
 {									\
 	"GBE_A:"#field, GBE_STATSA_MODULE,				\
-	FIELD_SIZEOF(struct gbe_hw_stats, field),			\
+	sizeof_member(struct gbe_hw_stats, field),			\
 	offsetof(struct gbe_hw_stats, field)				\
 }
 
 #define GBE_STATSB_INFO(field)						\
 {									\
 	"GBE_B:"#field, GBE_STATSB_MODULE,				\
-	FIELD_SIZEOF(struct gbe_hw_stats, field),			\
+	sizeof_member(struct gbe_hw_stats, field),			\
 	offsetof(struct gbe_hw_stats, field)				\
 }
 
 #define GBE_STATSC_INFO(field)						\
 {									\
 	"GBE_C:"#field, GBE_STATSC_MODULE,				\
-	FIELD_SIZEOF(struct gbe_hw_stats, field),			\
+	sizeof_member(struct gbe_hw_stats, field),			\
 	offsetof(struct gbe_hw_stats, field)				\
 }
 
 #define GBE_STATSD_INFO(field)						\
 {									\
 	"GBE_D:"#field, GBE_STATSD_MODULE,				\
-	FIELD_SIZEOF(struct gbe_hw_stats, field),			\
+	sizeof_member(struct gbe_hw_stats, field),			\
 	offsetof(struct gbe_hw_stats, field)				\
 }
 
@@ -957,7 +957,7 @@ static const struct netcp_ethtool_stat gbe13_et_stats[] = {
 #define GBENU_STATS_HOST(field)					\
 {								\
 	"GBE_HOST:"#field, GBENU_STATS0_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
@@ -967,56 +967,56 @@ static const struct netcp_ethtool_stat gbe13_et_stats[] = {
 #define GBENU_STATS_P1(field)					\
 {								\
 	"GBE_P1:"#field, GBENU_STATS1_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P2(field)					\
 {								\
 	"GBE_P2:"#field, GBENU_STATS2_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P3(field)					\
 {								\
 	"GBE_P3:"#field, GBENU_STATS3_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P4(field)					\
 {								\
 	"GBE_P4:"#field, GBENU_STATS4_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P5(field)					\
 {								\
 	"GBE_P5:"#field, GBENU_STATS5_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P6(field)					\
 {								\
 	"GBE_P6:"#field, GBENU_STATS6_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P7(field)					\
 {								\
 	"GBE_P7:"#field, GBENU_STATS7_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
 #define GBENU_STATS_P8(field)					\
 {								\
 	"GBE_P8:"#field, GBENU_STATS8_MODULE,			\
-	FIELD_SIZEOF(struct gbenu_hw_stats, field),		\
+	sizeof_member(struct gbenu_hw_stats, field),		\
 	offsetof(struct gbenu_hw_stats, field)			\
 }
 
@@ -1607,21 +1607,21 @@ static const struct netcp_ethtool_stat gbenu_et_stats[] = {
 #define XGBE_STATS0_INFO(field)				\
 {							\
 	"GBE_0:"#field, XGBE_STATS0_MODULE,		\
-	FIELD_SIZEOF(struct xgbe_hw_stats, field),	\
+	sizeof_member(struct xgbe_hw_stats, field),	\
 	offsetof(struct xgbe_hw_stats, field)		\
 }
 
 #define XGBE_STATS1_INFO(field)				\
 {							\
 	"GBE_1:"#field, XGBE_STATS1_MODULE,		\
-	FIELD_SIZEOF(struct xgbe_hw_stats, field),	\
+	sizeof_member(struct xgbe_hw_stats, field),	\
 	offsetof(struct xgbe_hw_stats, field)		\
 }
 
 #define XGBE_STATS2_INFO(field)				\
 {							\
 	"GBE_2:"#field, XGBE_STATS2_MODULE,		\
-	FIELD_SIZEOF(struct xgbe_hw_stats, field),	\
+	sizeof_member(struct xgbe_hw_stats, field),	\
 	offsetof(struct xgbe_hw_stats, field)		\
 }
 
diff --git a/drivers/net/fjes/fjes_ethtool.c b/drivers/net/fjes/fjes_ethtool.c
index 09f3604cfbf8..85589877dd49 100644
--- a/drivers/net/fjes/fjes_ethtool.c
+++ b/drivers/net/fjes/fjes_ethtool.c
@@ -21,7 +21,7 @@ struct fjes_stats {
 
 #define FJES_STAT(name, stat) { \
 	.stat_string = name, \
-	.sizeof_stat = FIELD_SIZEOF(struct fjes_adapter, stat), \
+	.sizeof_stat = sizeof_member(struct fjes_adapter, stat), \
 	.stat_offset = offsetof(struct fjes_adapter, stat) \
 }
 
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 3ab24fdccd3b..60551a58739e 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1154,7 +1154,7 @@ static void geneve_setup(struct net_device *dev)
 
 static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
 	[IFLA_GENEVE_ID]		= { .type = NLA_U32 },
-	[IFLA_GENEVE_REMOTE]		= { .len = FIELD_SIZEOF(struct iphdr, daddr) },
+	[IFLA_GENEVE_REMOTE]		= { .len = sizeof_member(struct iphdr, daddr) },
 	[IFLA_GENEVE_REMOTE6]		= { .len = sizeof(struct in6_addr) },
 	[IFLA_GENEVE_TTL]		= { .type = NLA_U8 },
 	[IFLA_GENEVE_TOS]		= { .type = NLA_U8 },
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 39dddcd8b3cb..6102264d9978 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -571,7 +571,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 
 	/* Use the skb control buffer for building up the packet */
 	BUILD_BUG_ON(sizeof(struct hv_netvsc_packet) >
-			FIELD_SIZEOF(struct sk_buff, cb));
+			sizeof_member(struct sk_buff, cb));
 	packet = (struct hv_netvsc_packet *)skb->cb;
 
 	packet->q_idx = skb_get_queue_mapping(skb);
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 34c1eaba536c..cb0215429adb 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -865,7 +865,7 @@ static struct sk_buff *sierra_net_tx_fixup(struct usbnet *dev,
 	u16 len;
 	bool need_tail;
 
-	BUILD_BUG_ON(FIELD_SIZEOF(struct usbnet, data)
+	BUILD_BUG_ON(sizeof_member(struct usbnet, data)
 				< sizeof(struct cdc_state));
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dde05e2fdc3e..217ea0126f93 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -2177,7 +2177,7 @@ static int __init usbnet_init(void)
 {
 	/* Compiler should optimize this out. */
 	BUILD_BUG_ON(
-		FIELD_SIZEOF(struct sk_buff, cb) < sizeof(struct skb_data));
+		sizeof_member(struct sk_buff, cb) < sizeof(struct skb_data));
 
 	eth_random_addr(node_id);
 	return 0;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc957f7d..27bfde225a73 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3070,10 +3070,10 @@ static void vxlan_raw_setup(struct net_device *dev)
 
 static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_ID]		= { .type = NLA_U32 },
-	[IFLA_VXLAN_GROUP]	= { .len = FIELD_SIZEOF(struct iphdr, daddr) },
+	[IFLA_VXLAN_GROUP]	= { .len = sizeof_member(struct iphdr, daddr) },
 	[IFLA_VXLAN_GROUP6]	= { .len = sizeof(struct in6_addr) },
 	[IFLA_VXLAN_LINK]	= { .type = NLA_U32 },
-	[IFLA_VXLAN_LOCAL]	= { .len = FIELD_SIZEOF(struct iphdr, saddr) },
+	[IFLA_VXLAN_LOCAL]	= { .len = sizeof_member(struct iphdr, saddr) },
 	[IFLA_VXLAN_LOCAL6]	= { .len = sizeof(struct in6_addr) },
 	[IFLA_VXLAN_TOS]	= { .type = NLA_U8 },
 	[IFLA_VXLAN_TTL]	= { .type = NLA_U8 },
diff --git a/drivers/net/wireless/marvell/libertas/debugfs.c b/drivers/net/wireless/marvell/libertas/debugfs.c
index fe14814af300..b6504798a248 100644
--- a/drivers/net/wireless/marvell/libertas/debugfs.c
+++ b/drivers/net/wireless/marvell/libertas/debugfs.c
@@ -774,7 +774,7 @@ void lbs_debugfs_remove_one(struct lbs_private *priv)
 
 #ifdef PROC_DEBUG
 
-#define item_size(n)	(FIELD_SIZEOF(struct lbs_private, n))
+#define item_size(n)	(sizeof_member(struct lbs_private, n))
 #define item_addr(n)	(offsetof(struct lbs_private, n))
 
 
diff --git a/drivers/net/wireless/marvell/mwifiex/util.h b/drivers/net/wireless/marvell/mwifiex/util.h
index c386992abcdb..98012a13517b 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.h
+++ b/drivers/net/wireless/marvell/mwifiex/util.h
@@ -36,11 +36,11 @@ struct mwifiex_cb {
 };
 
 /* size/addr for mwifiex_debug_info */
-#define item_size(n)		(FIELD_SIZEOF(struct mwifiex_debug_info, n))
+#define item_size(n)		(sizeof_member(struct mwifiex_debug_info, n))
 #define item_addr(n)		(offsetof(struct mwifiex_debug_info, n))
 
 /* size/addr for struct mwifiex_adapter */
-#define adapter_item_size(n)	(FIELD_SIZEOF(struct mwifiex_adapter, n))
+#define adapter_item_size(n)	(sizeof_member(struct mwifiex_adapter, n))
 #define adapter_item_addr(n)	(offsetof(struct mwifiex_adapter, n))
 
 struct mwifiex_debug_data {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index dda274351c21..5c6642b2415a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4715,7 +4715,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "qdioest");
 
-	qib_param_field = kzalloc(FIELD_SIZEOF(struct qib, parm), GFP_KERNEL);
+	qib_param_field = kzalloc(sizeof_member(struct qib, parm), GFP_KERNEL);
 	if (!qib_param_field) {
 		rc =  -ENOMEM;
 		goto out_free_nothing;
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 6420b58cf42b..62aebf5cf4ef 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -435,7 +435,7 @@ struct qeth_ipacmd_setassparms {
 	} data;
 } __attribute__ ((packed));
 
-#define SETASS_DATA_SIZEOF(field) FIELD_SIZEOF(struct qeth_ipacmd_setassparms,\
+#define SETASS_DATA_SIZEOF(field) sizeof_member(struct qeth_ipacmd_setassparms,\
 					       data.field)
 
 /* SETRTG IPA Command:    ****************************************************/
@@ -549,7 +549,7 @@ struct qeth_ipacmd_setadpparms {
 	} data;
 } __attribute__ ((packed));
 
-#define SETADP_DATA_SIZEOF(field) FIELD_SIZEOF(struct qeth_ipacmd_setadpparms,\
+#define SETADP_DATA_SIZEOF(field) sizeof_member(struct qeth_ipacmd_setadpparms,\
 					       data.field)
 
 /* CREATE_ADDR IPA Command:    ***********************************************/
@@ -662,7 +662,7 @@ struct qeth_ipacmd_vnicc {
 	} data;
 };
 
-#define VNICC_DATA_SIZEOF(field)	FIELD_SIZEOF(struct qeth_ipacmd_vnicc,\
+#define VNICC_DATA_SIZEOF(field)	sizeof_member(struct qeth_ipacmd_vnicc,\
 						     data.field)
 
 /* SETBRIDGEPORT IPA Command:	 *********************************************/
@@ -743,7 +743,7 @@ struct qeth_ipacmd_setbridgeport {
 	} data;
 } __packed;
 
-#define SBP_DATA_SIZEOF(field)	FIELD_SIZEOF(struct qeth_ipacmd_setbridgeport,\
+#define SBP_DATA_SIZEOF(field)	sizeof_member(struct qeth_ipacmd_setbridgeport,\
 					     data.field)
 
 /* ADDRESS_CHANGE_NOTIFICATION adapter-initiated "command" *******************/
@@ -804,7 +804,7 @@ struct qeth_ipa_cmd {
 	} data;
 } __attribute__ ((packed));
 
-#define IPA_DATA_SIZEOF(field)	FIELD_SIZEOF(struct qeth_ipa_cmd, data.field)
+#define IPA_DATA_SIZEOF(field)	sizeof_member(struct qeth_ipa_cmd, data.field)
 
 /*
  * special command for ARP processing.
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 0ed3f806ace5..f30fe29b5701 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -535,7 +535,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
 		char *sp = get_name_reply->data;
-		int data_size = FIELD_SIZEOF(struct aac_get_name_resp, data);
+		int data_size = sizeof_member(struct aac_get_name_resp, data);
 
 		sp[data_size - 1] = '\0';
 		while (*sp == ' ')
@@ -574,7 +574,7 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
-	data_size = FIELD_SIZEOF(struct aac_get_name_resp, data);
+	data_size = sizeof_member(struct aac_get_name_resp, data);
 
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 063dccc18f70..32e4436b959c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1300,7 +1300,7 @@ struct be_cmd_get_port_name {
 
 /* Returns the number of items in the field array. */
 #define BE_NUMBER_OF_FIELD(_type_, _field_)	\
-	(FIELD_SIZEOF(_type_, _field_)/sizeof((((_type_ *)0)->_field_[0])))\
+	(sizeof_member(_type_, _field_)/sizeof((((_type_ *)0)->_field_[0])))\
 
 /**
  * Different types of iSCSI completions to host driver for both initiator
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 3e17af8aedeb..cf261e1ae9d4 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2774,7 +2774,7 @@ static int __init libcxgbi_init_module(void)
 {
 	pr_info("%s", version);
 
-	BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, cb) <
+	BUILD_BUG_ON(sizeof_member(struct sk_buff, cb) <
 		     sizeof(struct cxgbi_skb_cb));
 	return 0;
 }
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ea5409bebf57..fafa4c1c2fea 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8634,11 +8634,11 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
 		data.delete_operational_queue.queue_id) != 12);
 	BUILD_BUG_ON(sizeof(struct pqi_general_admin_request) != 64);
-	BUILD_BUG_ON(FIELD_SIZEOF(struct pqi_general_admin_request,
+	BUILD_BUG_ON(sizeof_member(struct pqi_general_admin_request,
 		data.create_operational_iq) != 64 - 11);
-	BUILD_BUG_ON(FIELD_SIZEOF(struct pqi_general_admin_request,
+	BUILD_BUG_ON(sizeof_member(struct pqi_general_admin_request,
 		data.create_operational_oq) != 64 - 11);
-	BUILD_BUG_ON(FIELD_SIZEOF(struct pqi_general_admin_request,
+	BUILD_BUG_ON(sizeof_member(struct pqi_general_admin_request,
 		data.delete_operational_queue) != 64 - 11);
 
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index a6886cc5654c..0c3f8eb34094 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -41,7 +41,7 @@ struct ql_stats {
 	int stat_offset;
 };
 
-#define QL_SIZEOF(m) FIELD_SIZEOF(struct ql_adapter, m)
+#define QL_SIZEOF(m) sizeof_member(struct ql_adapter, m)
 #define QL_OFF(m) offsetof(struct ql_adapter, m)
 
 static const struct ql_stats ql_gstrings_stats[] = {
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index e877b917c15f..c10606653971 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -708,7 +708,7 @@ static int __init cxgbit_init(void)
 	pr_info("%s dcb enabled.\n", DRV_NAME);
 	register_dcbevent_notifier(&cxgbit_dcbevent_nb);
 #endif
-	BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, cb) <
+	BUILD_BUG_ON(sizeof_member(struct sk_buff, cb) <
 		     sizeof(union cxgbit_skb_cb));
 	return 0;
 }
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index dbea28495e1d..6a459ac79548 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -1275,7 +1275,7 @@ EXPORT_SYMBOL_GPL(usbatm_usb_disconnect);
 
 static int __init usbatm_usb_init(void)
 {
-	if (sizeof(struct usbatm_control) > FIELD_SIZEOF(struct sk_buff, cb)) {
+	if (sizeof(struct usbatm_control) > sizeof_member(struct sk_buff, cb)) {
 		printk(KERN_ERR "%s unusable with this kernel!\n", usbatm_driver_name);
 		return -EIO;
 	}
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 59d9d512dcda..2539ea40e94c 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3519,7 +3519,7 @@ static void ffs_free_inst(struct usb_function_instance *f)
 
 static int ffs_set_inst_name(struct usb_function_instance *fi, const char *name)
 {
-	if (strlen(name) >= FIELD_SIZEOF(struct ffs_dev, name))
+	if (strlen(name) >= sizeof_member(struct ffs_dev, name))
 		return -ENAMETOOLONG;
 	return ffs_name_dev(to_f_fs_opts(fi)->dev, name);
 }
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 64cdf4d8e424..e1afe224f703 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -438,7 +438,7 @@ befs_init_inodecache(void)
 					SLAB_ACCOUNT),
 				offsetof(struct befs_inode_info,
 					i_data.symlink),
-				sizeof_field(struct befs_inode_info,
+				sizeof_member(struct befs_inode_info,
 					i_data.symlink),
 				init_once);
 	if (befs_inode_cachep == NULL)
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index c34fa7c61b43..58e8b4b167d6 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -149,7 +149,7 @@ static struct key *search_fscrypt_keyring(struct key *keyring,
 }
 
 #define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE	\
-	(CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
+	(CONST_STRLEN("fscrypt-") + sizeof_member(struct super_block, s_id))
 
 #define FSCRYPT_MK_DESCRIPTION_SIZE	(2 * FSCRYPT_KEY_IDENTIFIER_SIZE + 1)
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 30c630d73f0f..2435eda5e2d6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -219,7 +219,7 @@ static int __init init_inodecache(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
 					SLAB_ACCOUNT),
 				offsetof(struct ext2_inode_info, i_data),
-				sizeof_field(struct ext2_inode_info, i_data),
+				sizeof_member(struct ext2_inode_info, i_data),
 				init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dd654e53ba3d..2318e5fe3fd4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1151,7 +1151,7 @@ static int __init init_inodecache(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
 					SLAB_ACCOUNT),
 				offsetof(struct ext4_inode_info, i_data),
-				sizeof_field(struct ext4_inode_info, i_data),
+				sizeof_member(struct ext4_inode_info, i_data),
 				init_once);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 578a5062706e..92e07838d185 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -331,7 +331,7 @@ vxfs_init(void)
 			sizeof(struct vxfs_inode_info), 0,
 			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
 			offsetof(struct vxfs_inode_info, vii_immed.vi_immed),
-			sizeof_field(struct vxfs_inode_info,
+			sizeof_member(struct vxfs_inode_info,
 				vii_immed.vi_immed),
 			NULL);
 	if (!vxfs_inode_cachep)
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 6af3f131e468..13f67ae37257 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -215,7 +215,7 @@ static void virtio_fs_free_devs(struct virtio_fs *fs)
 /* Read filesystem name from virtio config into fs->tag (must kfree()). */
 static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
 {
-	char tag_buf[sizeof_field(struct virtio_fs_config, tag)];
+	char tag_buf[sizeof_member(struct virtio_fs_config, tag)];
 	char *end;
 	size_t len;
 
diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index ee5efdc35cc1..d31b4b799c0c 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -646,7 +646,7 @@ int orangefs_inode_cache_initialize(void)
 					ORANGEFS_CACHE_CREATE_FLAGS,
 					offsetof(struct orangefs_inode_s,
 						link_target),
-					sizeof_field(struct orangefs_inode_s,
+					sizeof_member(struct orangefs_inode_s,
 						link_target),
 					orangefs_inode_cache_ctor);
 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 1da0be667409..20ef34b40e28 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1474,7 +1474,7 @@ static int __init init_inodecache(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
 					SLAB_ACCOUNT),
 				offsetof(struct ufs_inode_info, i_u1.i_symlink),
-				sizeof_field(struct ufs_inode_info,
+				sizeof_member(struct ufs_inode_info,
 					i_u1.i_symlink),
 				init_once);
 	if (ufs_inode_cachep == NULL)
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index eabc6ac19906..54dc6d1708ad 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -315,7 +315,7 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 	if (arg.block_size != PAGE_SIZE)
 		return -EINVAL;
 
-	if (arg.salt_size > FIELD_SIZEOF(struct fsverity_descriptor, salt))
+	if (arg.salt_size > sizeof_member(struct fsverity_descriptor, salt))
 		return -EMSGSIZE;
 
 	if (arg.sig_size > FS_VERITY_MAX_SIGNATURE_SIZE)
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 2ce57645f3cd..fa2d921d7a22 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -417,7 +417,7 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 
 #define BPF_FIELD_SIZEOF(type, field)				\
 	({							\
-		const int __size = bytes_to_bpf_size(FIELD_SIZEOF(type, field)); \
+		const int __size = bytes_to_bpf_size(sizeof_member(type, field)); \
 		BUILD_BUG_ON(__size < 0);			\
 		__size;						\
 	})
@@ -493,7 +493,7 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 
 #define bpf_target_off(TYPE, MEMBER, SIZE, PTR_SIZE)				\
 	({									\
-		BUILD_BUG_ON(FIELD_SIZEOF(TYPE, MEMBER) != (SIZE));		\
+		BUILD_BUG_ON(sizeof_member(TYPE, MEMBER) != (SIZE));		\
 		*(PTR_SIZE) = (SIZE);						\
 		offsetof(TYPE, MEMBER);						\
 	})
@@ -602,7 +602,7 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
 {
 	struct bpf_skb_data_end *cb = (struct bpf_skb_data_end *)skb->cb;
 
-	BUILD_BUG_ON(sizeof(*cb) > FIELD_SIZEOF(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(*cb) > sizeof_member(struct sk_buff, cb));
 	cb->data_meta = skb->data - skb_metadata_len(skb);
 	cb->data_end  = skb->data + skb_headlen(skb);
 }
@@ -640,9 +640,9 @@ static inline u8 *bpf_skb_cb(struct sk_buff *skb)
 	 * attached to sockets, we need to clear the bpf_skb_cb() area
 	 * to not leak previous contents to user space.
 	 */
-	BUILD_BUG_ON(FIELD_SIZEOF(struct __sk_buff, cb) != BPF_SKB_CB_LEN);
-	BUILD_BUG_ON(FIELD_SIZEOF(struct __sk_buff, cb) !=
-		     FIELD_SIZEOF(struct qdisc_skb_cb, data));
+	BUILD_BUG_ON(sizeof_member(struct __sk_buff, cb) != BPF_SKB_CB_LEN);
+	BUILD_BUG_ON(sizeof_member(struct __sk_buff, cb) !=
+		     sizeof_member(struct qdisc_skb_cb, data));
 
 	return qdisc_skb_cb(skb)->data;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..ebbf4f1a221a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -149,7 +149,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
-	BUILD_BUG_ON((unsigned)(nr) >= (FIELD_SIZEOF(struct kvm_vcpu, requests) * 8) - KVM_REQUEST_ARCH_BASE); \
+	BUILD_BUG_ON((unsigned)(nr) >= (sizeof_member(struct kvm_vcpu, requests) * 8) - KVM_REQUEST_ARCH_BASE); \
 	(unsigned)(((nr) + KVM_REQUEST_ARCH_BASE) | (flags)); \
 })
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
diff --git a/include/linux/phy_led_triggers.h b/include/linux/phy_led_triggers.h
index 3d507a8a6989..a44f9a68336d 100644
--- a/include/linux/phy_led_triggers.h
+++ b/include/linux/phy_led_triggers.h
@@ -14,7 +14,7 @@ struct phy_device;
 #define PHY_LED_TRIGGER_SPEED_SUFFIX_SIZE	11
 
 #define PHY_LINK_LED_TRIGGER_NAME_SIZE (MII_BUS_ID_SIZE + \
-				       FIELD_SIZEOF(struct mdio_device, addr)+\
+				       sizeof_member(struct mdio_device, addr)+\
 				       PHY_LED_TRIGGER_SPEED_SUFFIX_SIZE)
 
 struct phy_led_trigger {
diff --git a/include/linux/slab.h b/include/linux/slab.h
index ab2b98ad76e1..2afb630bce2a 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -179,7 +179,7 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *, struct mem_cgroup *);
 			sizeof(struct __struct),			\
 			__alignof__(struct __struct), (__flags),	\
 			offsetof(struct __struct, __field),		\
-			sizeof_field(struct __struct, __field), NULL)
+			sizeof_member(struct __struct, __field), NULL)
 
 /*
  * Common kmalloc functions provided by all allocators
diff --git a/include/net/garp.h b/include/net/garp.h
index c41833bd4590..4436a7ebe2b9 100644
--- a/include/net/garp.h
+++ b/include/net/garp.h
@@ -37,7 +37,7 @@ struct garp_skb_cb {
 static inline struct garp_skb_cb *garp_cb(struct sk_buff *skb)
 {
 	BUILD_BUG_ON(sizeof(struct garp_skb_cb) >
-		     FIELD_SIZEOF(struct sk_buff, cb));
+		     sizeof_member(struct sk_buff, cb));
 	return (struct garp_skb_cb *)skb->cb;
 }
 
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index af645604f328..a564e9e39382 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -33,8 +33,8 @@
 /* Used to memset ipv4 address padding. */
 #define IP_TUNNEL_KEY_IPV4_PAD	offsetofend(struct ip_tunnel_key, u.ipv4.dst)
 #define IP_TUNNEL_KEY_IPV4_PAD_LEN				\
-	(FIELD_SIZEOF(struct ip_tunnel_key, u) -		\
-	 FIELD_SIZEOF(struct ip_tunnel_key, u.ipv4))
+	(sizeof_member(struct ip_tunnel_key, u) -		\
+	 sizeof_member(struct ip_tunnel_key, u.ipv4))
 
 struct ip_tunnel_key {
 	__be64			tun_id;
@@ -63,7 +63,7 @@ struct ip_tunnel_key {
 
 /* Maximum tunnel options length. */
 #define IP_TUNNEL_OPTS_MAX					\
-	GENMASK((FIELD_SIZEOF(struct ip_tunnel_info,		\
+	GENMASK((sizeof_member(struct ip_tunnel_info,		\
 			      options_len) * BITS_PER_BYTE) - 1, 0)
 
 struct ip_tunnel_info {
diff --git a/include/net/mrp.h b/include/net/mrp.h
index ef58b4a07190..b40a292433eb 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -39,7 +39,7 @@ struct mrp_skb_cb {
 static inline struct mrp_skb_cb *mrp_cb(struct sk_buff *skb)
 {
 	BUILD_BUG_ON(sizeof(struct mrp_skb_cb) >
-		     FIELD_SIZEOF(struct sk_buff, cb));
+		     sizeof_member(struct sk_buff, cb));
 	return (struct mrp_skb_cb *)skb->cb;
 }
 
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 44b5a00a9c64..56936f83e912 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -81,7 +81,7 @@ struct nf_conn_help {
 };
 
 #define NF_CT_HELPER_BUILD_BUG_ON(structsize) \
-	BUILD_BUG_ON((structsize) > FIELD_SIZEOF(struct nf_conn_help, data))
+	BUILD_BUG_ON((structsize) > sizeof_member(struct nf_conn_help, data))
 
 struct nf_conntrack_helper *__nf_conntrack_helper_find(const char *name,
 						       u16 l3num, u8 protonum);
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 7281895fa6d9..286ea751fe3a 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -41,7 +41,7 @@ struct nft_immediate_expr {
  */
 static inline u32 nft_cmp_fast_mask(unsigned int len)
 {
-	return cpu_to_le32(~0U >> (FIELD_SIZEOF(struct nft_cmp_fast_expr,
+	return cpu_to_le32(~0U >> (sizeof_member(struct nft_cmp_fast_expr,
 						data) * BITS_PER_BYTE - len));
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 2c53f1a1d905..6a5a386410ff 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2290,7 +2290,7 @@ struct sock_skb_cb {
  * using skb->cb[] would keep using it directly and utilize its
  * alignement guarantee.
  */
-#define SOCK_SKB_CB_OFFSET ((FIELD_SIZEOF(struct sk_buff, cb) - \
+#define SOCK_SKB_CB_OFFSET ((sizeof_member(struct sk_buff, cb) - \
 			    sizeof(struct sock_skb_cb)))
 
 #define SOCK_SKB_CB(__skb) ((struct sock_skb_cb *)((__skb)->cb + \
diff --git a/ipc/util.c b/ipc/util.c
index d126d156efc6..6888015057c6 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -100,7 +100,7 @@ device_initcall(ipc_init);
 static const struct rhashtable_params ipc_kht_params = {
 	.head_offset		= offsetof(struct kern_ipc_perm, khtnode),
 	.key_offset		= offsetof(struct kern_ipc_perm, key),
-	.key_len		= FIELD_SIZEOF(struct kern_ipc_perm, key),
+	.key_len		= sizeof_member(struct kern_ipc_perm, key),
 	.automatic_shrinking	= true,
 };
 
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ddd8addcdb5c..3ff6df3ab022 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1341,7 +1341,7 @@ static u32 sysctl_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(
 			BPF_SIZE(si->code), si->dst_reg, si->src_reg,
 			bpf_target_off(struct bpf_sysctl_kern, write,
-				       FIELD_SIZEOF(struct bpf_sysctl_kern,
+				       sizeof_member(struct bpf_sysctl_kern,
 						    write),
 				       target_size));
 		break;
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index addd6fdceec8..ea4117fabdec 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -357,7 +357,7 @@ static int cgroup_storage_check_btf(const struct bpf_map *map,
 	 * The first field must be a 64 bit integer at 0 offset.
 	 */
 	m = (struct btf_member *)(key_type + 1);
-	size = FIELD_SIZEOF(struct bpf_cgroup_storage_key, cgroup_inode_id);
+	size = sizeof_member(struct bpf_cgroup_storage_key, cgroup_inode_id);
 	if (!btf_member_is_reg_int(btf, key_type, m, 0, size))
 		return -EINVAL;
 
@@ -366,7 +366,7 @@ static int cgroup_storage_check_btf(const struct bpf_map *map,
 	 */
 	m++;
 	offset = offsetof(struct bpf_cgroup_storage_key, attach_type);
-	size = FIELD_SIZEOF(struct bpf_cgroup_storage_key, attach_type);
+	size = sizeof_member(struct bpf_cgroup_storage_key, attach_type);
 	if (!btf_member_is_reg_int(btf, key_type, m, offset, size))
 		return -EINVAL;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 1f6c45f6a734..1b45b28d4bf5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2688,7 +2688,7 @@ void __init proc_caches_init(void)
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			offsetof(struct mm_struct, saved_auxv),
-			sizeof_field(struct mm_struct, saved_auxv),
+			sizeof_member(struct mm_struct, saved_auxv),
 			NULL);
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
 	mmap_init();
diff --git a/kernel/signal.c b/kernel/signal.c
index c4da1ef56fdf..52628a975705 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4548,11 +4548,11 @@ static inline void siginfo_buildtime_checks(void)
 	BUILD_BUG_ON(offsetof(struct siginfo, si_pid) !=
 		     offsetof(struct siginfo, si_addr));
 	if (sizeof(int) == sizeof(void __user *)) {
-		BUILD_BUG_ON(sizeof_field(struct siginfo, si_pid) !=
+		BUILD_BUG_ON(sizeof_member(struct siginfo, si_pid) !=
 			     sizeof(void __user *));
 	} else {
-		BUILD_BUG_ON((sizeof_field(struct siginfo, si_pid) +
-			      sizeof_field(struct siginfo, si_uid)) !=
+		BUILD_BUG_ON((sizeof_member(struct siginfo, si_pid) +
+			      sizeof_member(struct siginfo, si_uid)) !=
 			     sizeof(void __user *));
 		BUILD_BUG_ON(offsetofend(struct siginfo, si_pid) !=
 			     offsetof(struct siginfo, si_uid));
@@ -4560,10 +4560,10 @@ static inline void siginfo_buildtime_checks(void)
 #ifdef CONFIG_COMPAT
 	BUILD_BUG_ON(offsetof(struct compat_siginfo, si_pid) !=
 		     offsetof(struct compat_siginfo, si_addr));
-	BUILD_BUG_ON(sizeof_field(struct compat_siginfo, si_pid) !=
+	BUILD_BUG_ON(sizeof_member(struct compat_siginfo, si_pid) !=
 		     sizeof(compat_uptr_t));
-	BUILD_BUG_ON(sizeof_field(struct compat_siginfo, si_pid) !=
-		     sizeof_field(struct siginfo, si_pid));
+	BUILD_BUG_ON(sizeof_member(struct compat_siginfo, si_pid) !=
+		     sizeof_member(struct siginfo, si_pid));
 #endif
 }
 
diff --git a/kernel/utsname.c b/kernel/utsname.c
index f0e491193009..11a1a531a803 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -174,6 +174,6 @@ void __init uts_ns_init(void)
 			"uts_namespace", sizeof(struct uts_namespace), 0,
 			SLAB_PANIC|SLAB_ACCOUNT,
 			offsetof(struct uts_namespace, name),
-			sizeof_field(struct uts_namespace, name),
+			sizeof_member(struct uts_namespace, name),
 			NULL);
 }
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 2cfdfbfbb2ed..54aafe27cc4a 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -523,7 +523,7 @@ int mrp_request_join(const struct net_device *dev,
 	struct mrp_attr *attr;
 
 	if (sizeof(struct mrp_skb_cb) + len >
-	    FIELD_SIZEOF(struct sk_buff, cb))
+	    sizeof_member(struct sk_buff, cb))
 		return -ENOMEM;
 
 	spin_lock_bh(&app->lock);
@@ -548,7 +548,7 @@ void mrp_request_leave(const struct net_device *dev,
 	struct mrp_attr *attr;
 
 	if (sizeof(struct mrp_skb_cb) + len >
-	    FIELD_SIZEOF(struct sk_buff, cb))
+	    sizeof_member(struct sk_buff, cb))
 		return;
 
 	spin_lock_bh(&app->lock);
@@ -692,7 +692,7 @@ static int mrp_pdu_parse_vecattr(struct mrp_applicant *app,
 	 * advance to the next event in its Vector.
 	 */
 	if (sizeof(struct mrp_skb_cb) + mrp_cb(skb)->mh->attrlen >
-	    FIELD_SIZEOF(struct sk_buff, cb))
+	    sizeof_member(struct sk_buff, cb))
 		return -1;
 	if (skb_copy_bits(skb, *offset, mrp_cb(skb)->attrvalue,
 			  mrp_cb(skb)->mh->attrlen) < 0)
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 4a89177def64..49cce458e7a9 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -548,7 +548,7 @@ static void batadv_recv_handler_init(void)
 	BUILD_BUG_ON(sizeof(struct batadv_tvlv_tt_change) != 12);
 	BUILD_BUG_ON(sizeof(struct batadv_tvlv_roam_adv) != 8);
 
-	i = FIELD_SIZEOF(struct sk_buff, cb);
+	i = sizeof_member(struct sk_buff, cb);
 	BUILD_BUG_ON(sizeof(struct batadv_skb_cb) > i);
 
 	/* broadcast packet */
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 8a8f9e5f264f..b9380b6ed0f8 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -312,7 +312,7 @@ static int __init br_init(void)
 {
 	int err;
 
-	BUILD_BUG_ON(sizeof(struct br_input_skb_cb) > FIELD_SIZEOF(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(struct br_input_skb_cb) > sizeof_member(struct sk_buff, cb));
 
 	err = stp_proto_register(&br_stp_proto);
 	if (err < 0) {
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 13ea920600ae..0dbd93bb1939 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1033,7 +1033,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
 		.owner = THIS_MODULE,
 		.obj_size = sizeof(struct caifsock),
 		.useroffset = offsetof(struct caifsock, conn_req.param),
-		.usersize = sizeof_field(struct caifsock, conn_req.param)
+		.usersize = sizeof_member(struct caifsock, conn_req.param)
 	};
 
 	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..c434e94167ca 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9622,7 +9622,7 @@ static struct hlist_head * __net_init netdev_create_hash(void)
 static int __net_init netdev_init(struct net *net)
 {
 	BUILD_BUG_ON(GRO_HASH_BUCKETS >
-		     8 * FIELD_SIZEOF(struct napi_struct, gro_bitmask));
+		     8 * sizeof_member(struct napi_struct, gro_bitmask));
 
 	if (net != &init_net)
 		INIT_LIST_HEAD(&net->dev_base_head);
diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce3..284f60695ba9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -274,7 +274,7 @@ static u32 convert_skb_access(int skb_field, int dst_reg, int src_reg,
 
 	switch (skb_field) {
 	case SKF_AD_MARK:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, mark) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, mark) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_W, dst_reg, src_reg,
 				      offsetof(struct sk_buff, mark));
@@ -289,14 +289,14 @@ static u32 convert_skb_access(int skb_field, int dst_reg, int src_reg,
 		break;
 
 	case SKF_AD_QUEUE:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, queue_mapping) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, queue_mapping) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_H, dst_reg, src_reg,
 				      offsetof(struct sk_buff, queue_mapping));
 		break;
 
 	case SKF_AD_VLAN_TAG:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, vlan_tci) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, vlan_tci) != 2);
 
 		/* dst_reg = *(u16 *) (src_reg + offsetof(vlan_tci)) */
 		*insn++ = BPF_LDX_MEM(BPF_H, dst_reg, src_reg,
@@ -322,7 +322,7 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
 
 	switch (fp->k) {
 	case SKF_AD_OFF + SKF_AD_PROTOCOL:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, protocol) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, protocol) != 2);
 
 		/* A = *(u16 *) (CTX + offsetof(protocol)) */
 		*insn++ = BPF_LDX_MEM(BPF_H, BPF_REG_A, BPF_REG_CTX,
@@ -338,8 +338,8 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
 
 	case SKF_AD_OFF + SKF_AD_IFINDEX:
 	case SKF_AD_OFF + SKF_AD_HATYPE:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct net_device, ifindex) != 4);
-		BUILD_BUG_ON(FIELD_SIZEOF(struct net_device, type) != 2);
+		BUILD_BUG_ON(sizeof_member(struct net_device, ifindex) != 4);
+		BUILD_BUG_ON(sizeof_member(struct net_device, type) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, dev),
 				      BPF_REG_TMP, BPF_REG_CTX,
@@ -361,7 +361,7 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
 		break;
 
 	case SKF_AD_OFF + SKF_AD_RXHASH:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, hash) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, hash) != 4);
 
 		*insn = BPF_LDX_MEM(BPF_W, BPF_REG_A, BPF_REG_CTX,
 				    offsetof(struct sk_buff, hash));
@@ -385,7 +385,7 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
 		break;
 
 	case SKF_AD_OFF + SKF_AD_VLAN_TPID:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, vlan_proto) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, vlan_proto) != 2);
 
 		/* A = *(u16 *) (CTX + offsetof(vlan_proto)) */
 		*insn++ = BPF_LDX_MEM(BPF_H, BPF_REG_A, BPF_REG_CTX,
@@ -5574,8 +5574,8 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 
 #define BPF_TCP_SOCK_GET_COMMON(FIELD)					\
 	do {								\
-		BUILD_BUG_ON(FIELD_SIZEOF(struct tcp_sock, FIELD) >	\
-			     FIELD_SIZEOF(struct bpf_tcp_sock, FIELD));	\
+		BUILD_BUG_ON(sizeof_member(struct tcp_sock, FIELD) >	\
+			     sizeof_member(struct bpf_tcp_sock, FIELD));	\
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct tcp_sock, FIELD),\
 				      si->dst_reg, si->src_reg,		\
 				      offsetof(struct tcp_sock, FIELD)); \
@@ -5583,9 +5583,9 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 
 #define BPF_INET_SOCK_GET_COMMON(FIELD)					\
 	do {								\
-		BUILD_BUG_ON(FIELD_SIZEOF(struct inet_connection_sock,	\
+		BUILD_BUG_ON(sizeof_member(struct inet_connection_sock,	\
 					  FIELD) >			\
-			     FIELD_SIZEOF(struct bpf_tcp_sock, FIELD));	\
+			     sizeof_member(struct bpf_tcp_sock, FIELD));	\
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			\
 					struct inet_connection_sock,	\
 					FIELD),				\
@@ -5600,7 +5600,7 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 
 	switch (si->off) {
 	case offsetof(struct bpf_tcp_sock, rtt_min):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct tcp_sock, rtt_min) !=
+		BUILD_BUG_ON(sizeof_member(struct tcp_sock, rtt_min) !=
 			     sizeof(struct minmax));
 		BUILD_BUG_ON(sizeof(struct minmax) <
 			     sizeof(struct minmax_sample));
@@ -5765,8 +5765,8 @@ u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 
 #define BPF_XDP_SOCK_GET(FIELD)						\
 	do {								\
-		BUILD_BUG_ON(FIELD_SIZEOF(struct xdp_sock, FIELD) >	\
-			     FIELD_SIZEOF(struct bpf_xdp_sock, FIELD));	\
+		BUILD_BUG_ON(sizeof_member(struct xdp_sock, FIELD) >	\
+			     sizeof_member(struct bpf_xdp_sock, FIELD));	\
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_sock, FIELD),\
 				      si->dst_reg, si->src_reg,		\
 				      offsetof(struct xdp_sock, FIELD)); \
@@ -7329,7 +7329,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 
 	case offsetof(struct __sk_buff, cb[0]) ...
 	     offsetofend(struct __sk_buff, cb[4]) - 1:
-		BUILD_BUG_ON(FIELD_SIZEOF(struct qdisc_skb_cb, data) < 20);
+		BUILD_BUG_ON(sizeof_member(struct qdisc_skb_cb, data) < 20);
 		BUILD_BUG_ON((offsetof(struct sk_buff, cb) +
 			      offsetof(struct qdisc_skb_cb, data)) %
 			     sizeof(__u64));
@@ -7348,7 +7348,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, tc_classid):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct qdisc_skb_cb, tc_classid) != 2);
+		BUILD_BUG_ON(sizeof_member(struct qdisc_skb_cb, tc_classid) != 2);
 
 		off  = si->off;
 		off -= offsetof(struct __sk_buff, tc_classid);
@@ -7419,7 +7419,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 #endif
 		break;
 	case offsetof(struct __sk_buff, family):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_family) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_family) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
 				      si->dst_reg, si->src_reg,
@@ -7430,7 +7430,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 						     2, target_size));
 		break;
 	case offsetof(struct __sk_buff, remote_ip4):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_daddr) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_daddr) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
 				      si->dst_reg, si->src_reg,
@@ -7441,7 +7441,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 						     4, target_size));
 		break;
 	case offsetof(struct __sk_buff, local_ip4):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_rcv_saddr) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
@@ -7455,7 +7455,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct __sk_buff, remote_ip6[0]) ...
 	     offsetof(struct __sk_buff, remote_ip6[3]):
 #if IS_ENABLED(CONFIG_IPV6)
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_v6_daddr.s6_addr32[0]) != 4);
 
 		off = si->off;
@@ -7475,7 +7475,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct __sk_buff, local_ip6[0]) ...
 	     offsetof(struct __sk_buff, local_ip6[3]):
 #if IS_ENABLED(CONFIG_IPV6)
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_v6_rcv_saddr.s6_addr32[0]) != 4);
 
 		off = si->off;
@@ -7494,7 +7494,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, remote_port):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_dport) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_dport) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
 				      si->dst_reg, si->src_reg,
@@ -7509,7 +7509,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, local_port):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_num) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_num) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
 				      si->dst_reg, si->src_reg,
@@ -7520,7 +7520,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, tstamp):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, tstamp) != 8);
+		BUILD_BUG_ON(sizeof_member(struct sk_buff, tstamp) != 8);
 
 		if (type == BPF_WRITE)
 			*insn++ = BPF_STX_MEM(BPF_DW,
@@ -7558,7 +7558,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 						     target_size));
 		break;
 	case offsetof(struct __sk_buff, wire_len):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct qdisc_skb_cb, pkt_len) != 4);
+		BUILD_BUG_ON(sizeof_member(struct qdisc_skb_cb, pkt_len) != 4);
 
 		off = si->off;
 		off -= offsetof(struct __sk_buff, wire_len);
@@ -7588,7 +7588,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 
 	switch (si->off) {
 	case offsetof(struct bpf_sock, bound_dev_if):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock, sk_bound_dev_if) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sock, sk_bound_dev_if) != 4);
 
 		if (type == BPF_WRITE)
 			*insn++ = BPF_STX_MEM(BPF_W, si->dst_reg, si->src_reg,
@@ -7599,7 +7599,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock, mark):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock, sk_mark) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sock, sk_mark) != 4);
 
 		if (type == BPF_WRITE)
 			*insn++ = BPF_STX_MEM(BPF_W, si->dst_reg, si->src_reg,
@@ -7610,7 +7610,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock, priority):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock, sk_priority) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sock, sk_priority) != 4);
 
 		if (type == BPF_WRITE)
 			*insn++ = BPF_STX_MEM(BPF_W, si->dst_reg, si->src_reg,
@@ -7626,7 +7626,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 			si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common,
 				       skc_family,
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_family),
 				       target_size));
 		break;
@@ -7653,7 +7653,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(
 			BPF_SIZE(si->code), si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common, skc_rcv_saddr,
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_rcv_saddr),
 				       target_size));
 		break;
@@ -7662,7 +7662,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(
 			BPF_SIZE(si->code), si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common, skc_daddr,
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_daddr),
 				       target_size));
 		break;
@@ -7676,7 +7676,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 			bpf_target_off(
 				struct sock_common,
 				skc_v6_rcv_saddr.s6_addr32[0],
-				FIELD_SIZEOF(struct sock_common,
+				sizeof_member(struct sock_common,
 					     skc_v6_rcv_saddr.s6_addr32[0]),
 				target_size) + off);
 #else
@@ -7693,7 +7693,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 			BPF_SIZE(si->code), si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common,
 				       skc_v6_daddr.s6_addr32[0],
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_v6_daddr.s6_addr32[0]),
 				       target_size) + off);
 #else
@@ -7707,7 +7707,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 			BPF_FIELD_SIZEOF(struct sock_common, skc_num),
 			si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common, skc_num,
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_num),
 				       target_size));
 		break;
@@ -7717,7 +7717,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 			BPF_FIELD_SIZEOF(struct sock_common, skc_dport),
 			si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common, skc_dport,
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_dport),
 				       target_size));
 		break;
@@ -7727,7 +7727,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 			BPF_FIELD_SIZEOF(struct sock_common, skc_state),
 			si->dst_reg, si->src_reg,
 			bpf_target_off(struct sock_common, skc_state,
-				       FIELD_SIZEOF(struct sock_common,
+				       sizeof_member(struct sock_common,
 						    skc_state),
 				       target_size));
 		break;
@@ -7822,7 +7822,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 				      si->src_reg, offsetof(S, F));	       \
 		*insn++ = BPF_LDX_MEM(					       \
 			SIZE, si->dst_reg, si->dst_reg,			       \
-			bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),	       \
+			bpf_target_off(NS, NF, sizeof_member(NS, NF),	       \
 				       target_size)			       \
 				+ OFF);					       \
 	} while (0)
@@ -7853,7 +7853,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,	       \
 				      si->dst_reg, offsetof(S, F));	       \
 		*insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,	       \
-			bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),	       \
+			bpf_target_off(NS, NF, sizeof_member(NS, NF),	       \
 				       target_size)			       \
 				+ OFF);					       \
 		*insn++ = BPF_LDX_MEM(BPF_DW, tmp_reg, si->dst_reg,	       \
@@ -7915,8 +7915,8 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
 		 */
 		BUILD_BUG_ON(offsetof(struct sockaddr_in, sin_port) !=
 			     offsetof(struct sockaddr_in6, sin6_port));
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sockaddr_in, sin_port) !=
-			     FIELD_SIZEOF(struct sockaddr_in6, sin6_port));
+		BUILD_BUG_ON(sizeof_member(struct sockaddr_in, sin_port) !=
+			     sizeof_member(struct sockaddr_in6, sin6_port));
 		SOCK_ADDR_LOAD_OR_STORE_NESTED_FIELD(struct bpf_sock_addr_kern,
 						     struct sockaddr_in6, uaddr,
 						     sin6_port, tmp_reg);
@@ -7982,8 +7982,8 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 /* Helper macro for adding read access to tcp_sock or sock fields. */
 #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
 	do {								      \
-		BUILD_BUG_ON(FIELD_SIZEOF(OBJ, OBJ_FIELD) >		      \
-			     FIELD_SIZEOF(struct bpf_sock_ops, BPF_FIELD));   \
+		BUILD_BUG_ON(sizeof_member(OBJ, OBJ_FIELD) >		      \
+			     sizeof_member(struct bpf_sock_ops, BPF_FIELD));   \
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
 						struct bpf_sock_ops_kern,     \
 						is_fullsock),		      \
@@ -8016,8 +8016,8 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 #define SOCK_OPS_SET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
 	do {								      \
 		int reg = BPF_REG_9;					      \
-		BUILD_BUG_ON(FIELD_SIZEOF(OBJ, OBJ_FIELD) >		      \
-			     FIELD_SIZEOF(struct bpf_sock_ops, BPF_FIELD));   \
+		BUILD_BUG_ON(sizeof_member(OBJ, OBJ_FIELD) >		      \
+			     sizeof_member(struct bpf_sock_ops, BPF_FIELD));   \
 		if (si->dst_reg == reg || si->src_reg == reg)		      \
 			reg--;						      \
 		if (si->dst_reg == reg || si->src_reg == reg)		      \
@@ -8058,12 +8058,12 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 	switch (si->off) {
 	case offsetof(struct bpf_sock_ops, op) ...
 	     offsetof(struct bpf_sock_ops, replylong[3]):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct bpf_sock_ops, op) !=
-			     FIELD_SIZEOF(struct bpf_sock_ops_kern, op));
-		BUILD_BUG_ON(FIELD_SIZEOF(struct bpf_sock_ops, reply) !=
-			     FIELD_SIZEOF(struct bpf_sock_ops_kern, reply));
-		BUILD_BUG_ON(FIELD_SIZEOF(struct bpf_sock_ops, replylong) !=
-			     FIELD_SIZEOF(struct bpf_sock_ops_kern, replylong));
+		BUILD_BUG_ON(sizeof_member(struct bpf_sock_ops, op) !=
+			     sizeof_member(struct bpf_sock_ops_kern, op));
+		BUILD_BUG_ON(sizeof_member(struct bpf_sock_ops, reply) !=
+			     sizeof_member(struct bpf_sock_ops_kern, reply));
+		BUILD_BUG_ON(sizeof_member(struct bpf_sock_ops, replylong) !=
+			     sizeof_member(struct bpf_sock_ops_kern, replylong));
 		off = si->off;
 		off -= offsetof(struct bpf_sock_ops, op);
 		off += offsetof(struct bpf_sock_ops_kern, op);
@@ -8076,7 +8076,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, family):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_family) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_family) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 					      struct bpf_sock_ops_kern, sk),
@@ -8087,7 +8087,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, remote_ip4):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_daddr) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_daddr) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct bpf_sock_ops_kern, sk),
@@ -8098,7 +8098,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, local_ip4):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_rcv_saddr) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
@@ -8113,7 +8113,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_sock_ops, remote_ip6[0]) ...
 	     offsetof(struct bpf_sock_ops, remote_ip6[3]):
 #if IS_ENABLED(CONFIG_IPV6)
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_v6_daddr.s6_addr32[0]) != 4);
 
 		off = si->off;
@@ -8134,7 +8134,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_sock_ops, local_ip6[0]) ...
 	     offsetof(struct bpf_sock_ops, local_ip6[3]):
 #if IS_ENABLED(CONFIG_IPV6)
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_v6_rcv_saddr.s6_addr32[0]) != 4);
 
 		off = si->off;
@@ -8153,7 +8153,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, remote_port):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_dport) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_dport) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct bpf_sock_ops_kern, sk),
@@ -8167,7 +8167,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, local_port):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_num) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_num) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct bpf_sock_ops_kern, sk),
@@ -8187,7 +8187,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, state):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_state) != 1);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_state) != 1);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct bpf_sock_ops_kern, sk),
@@ -8198,7 +8198,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, rtt_min):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct tcp_sock, rtt_min) !=
+		BUILD_BUG_ON(sizeof_member(struct tcp_sock, rtt_min) !=
 			     sizeof(struct minmax));
 		BUILD_BUG_ON(sizeof(struct minmax) <
 			     sizeof(struct minmax_sample));
@@ -8209,7 +8209,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct bpf_sock_ops_kern, sk));
 		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
 				      offsetof(struct tcp_sock, rtt_min) +
-				      FIELD_SIZEOF(struct minmax_sample, t));
+				      sizeof_member(struct minmax_sample, t));
 		break;
 
 	case offsetof(struct bpf_sock_ops, bpf_sock_ops_cb_flags):
@@ -8351,7 +8351,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct sk_msg, data_end));
 		break;
 	case offsetof(struct sk_msg_md, family):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_family) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_family) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 					      struct sk_msg, sk),
@@ -8362,7 +8362,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct sk_msg_md, remote_ip4):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_daddr) != 4);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_daddr) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct sk_msg, sk),
@@ -8373,7 +8373,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct sk_msg_md, local_ip4):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_rcv_saddr) != 4);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
@@ -8388,7 +8388,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_msg_md, remote_ip6[0]) ...
 	     offsetof(struct sk_msg_md, remote_ip6[3]):
 #if IS_ENABLED(CONFIG_IPV6)
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_v6_daddr.s6_addr32[0]) != 4);
 
 		off = si->off;
@@ -8409,7 +8409,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_msg_md, local_ip6[0]) ...
 	     offsetof(struct sk_msg_md, local_ip6[3]):
 #if IS_ENABLED(CONFIG_IPV6)
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common,
+		BUILD_BUG_ON(sizeof_member(struct sock_common,
 					  skc_v6_rcv_saddr.s6_addr32[0]) != 4);
 
 		off = si->off;
@@ -8428,7 +8428,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct sk_msg_md, remote_port):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_dport) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_dport) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct sk_msg, sk),
@@ -8442,7 +8442,7 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct sk_msg_md, local_port):
-		BUILD_BUG_ON(FIELD_SIZEOF(struct sock_common, skc_num) != 2);
+		BUILD_BUG_ON(sizeof_member(struct sock_common, skc_num) != 2);
 
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct sk_msg, sk),
@@ -8842,7 +8842,7 @@ sk_reuseport_is_valid_access(int off, int size,
 
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
-		if (size < FIELD_SIZEOF(struct sk_buff, protocol))
+		if (size < sizeof_member(struct sk_buff, protocol))
 			return false;
 		/* fall through */
 	case bpf_ctx_range(struct sk_reuseport_md, ip_protocol):
@@ -8860,7 +8860,7 @@ sk_reuseport_is_valid_access(int off, int size,
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_reuseport_kern, F), \
 			      si->dst_reg, si->src_reg,			\
 			      bpf_target_off(struct sk_reuseport_kern, F, \
-					     FIELD_SIZEOF(struct sk_reuseport_kern, F), \
+					     sizeof_member(struct sk_reuseport_kern, F), \
 					     target_size));		\
 	})
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 7c09d87d3269..3f5f61bc2bfa 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -523,8 +523,8 @@ __skb_flow_dissect_gre(const struct sk_buff *skb,
 	offset += sizeof(struct gre_base_hdr);
 
 	if (hdr->flags & GRE_CSUM)
-		offset += FIELD_SIZEOF(struct gre_full_hdr, csum) +
-			  FIELD_SIZEOF(struct gre_full_hdr, reserved1);
+		offset += sizeof_member(struct gre_full_hdr, csum) +
+			  sizeof_member(struct gre_full_hdr, reserved1);
 
 	if (hdr->flags & GRE_KEY) {
 		const __be32 *keyid;
@@ -546,11 +546,11 @@ __skb_flow_dissect_gre(const struct sk_buff *skb,
 			else
 				key_keyid->keyid = *keyid & GRE_PPTP_KEY_MASK;
 		}
-		offset += FIELD_SIZEOF(struct gre_full_hdr, key);
+		offset += sizeof_member(struct gre_full_hdr, key);
 	}
 
 	if (hdr->flags & GRE_SEQ)
-		offset += FIELD_SIZEOF(struct pptp_gre_header, seq);
+		offset += sizeof_member(struct pptp_gre_header, seq);
 
 	if (gre_ver == 0) {
 		if (*p_proto == htons(ETH_P_TEB)) {
@@ -577,7 +577,7 @@ __skb_flow_dissect_gre(const struct sk_buff *skb,
 		u8 *ppp_hdr;
 
 		if (hdr->flags & GRE_ACK)
-			offset += FIELD_SIZEOF(struct pptp_gre_header, ack);
+			offset += sizeof_member(struct pptp_gre_header, ack);
 
 		ppp_hdr = __skb_header_pointer(skb, *p_nhoff + offset,
 					       sizeof(_ppp_hdr),
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 529133611ea2..6054465875d8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4148,7 +4148,7 @@ void __init skb_init(void)
 					      0,
 					      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 					      offsetof(struct sk_buff, cb),
-					      sizeof_field(struct sk_buff, cb),
+					      sizeof_member(struct sk_buff, cb),
 					      NULL);
 	skbuff_fclone_cache = kmem_cache_create("skbuff_fclone_cache",
 						sizeof(struct sk_buff_fclones),
diff --git a/net/core/xdp.c b/net/core/xdp.c
index d7bf62ffbb5e..621d6148b07a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -36,7 +36,7 @@ static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
 	const u32 *k = data;
 	const u32 key = *k;
 
-	BUILD_BUG_ON(FIELD_SIZEOF(struct xdp_mem_allocator, mem.id)
+	BUILD_BUG_ON(sizeof_member(struct xdp_mem_allocator, mem.id)
 		     != sizeof(u32));
 
 	/* Use cyclic increasing ID as direct hash key */
@@ -56,7 +56,7 @@ static const struct rhashtable_params mem_id_rht_params = {
 	.nelem_hint = 64,
 	.head_offset = offsetof(struct xdp_mem_allocator, node),
 	.key_offset  = offsetof(struct xdp_mem_allocator, mem.id),
-	.key_len = FIELD_SIZEOF(struct xdp_mem_allocator, mem.id),
+	.key_len = sizeof_member(struct xdp_mem_allocator, mem.id),
 	.max_size = MEM_ID_MAX,
 	.min_size = 8,
 	.automatic_shrinking = true,
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 5bad08dc4316..7175a33090b5 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1132,7 +1132,7 @@ static int __init dccp_init(void)
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct dccp_skb_cb) >
-		     FIELD_SIZEOF(struct sk_buff, cb));
+		     sizeof_member(struct sk_buff, cb));
 	rc = percpu_counter_init(&dccp_orphan_count, 0, GFP_KERNEL);
 	if (rc)
 		goto out_fail;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 52690bb3e40f..9c9716f7ccdb 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1460,8 +1460,8 @@ static const struct nla_policy ipgre_policy[IFLA_GRE_MAX + 1] = {
 	[IFLA_GRE_OFLAGS]	= { .type = NLA_U16 },
 	[IFLA_GRE_IKEY]		= { .type = NLA_U32 },
 	[IFLA_GRE_OKEY]		= { .type = NLA_U32 },
-	[IFLA_GRE_LOCAL]	= { .len = FIELD_SIZEOF(struct iphdr, saddr) },
-	[IFLA_GRE_REMOTE]	= { .len = FIELD_SIZEOF(struct iphdr, daddr) },
+	[IFLA_GRE_LOCAL]	= { .len = sizeof_member(struct iphdr, saddr) },
+	[IFLA_GRE_REMOTE]	= { .len = sizeof_member(struct iphdr, daddr) },
 	[IFLA_GRE_TTL]		= { .type = NLA_U8 },
 	[IFLA_GRE_TOS]		= { .type = NLA_U8 },
 	[IFLA_GRE_PMTUDISC]	= { .type = NLA_U8 },
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index cfb025606793..560b00df2998 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -580,8 +580,8 @@ static const struct nla_policy vti_policy[IFLA_VTI_MAX + 1] = {
 	[IFLA_VTI_LINK]		= { .type = NLA_U32 },
 	[IFLA_VTI_IKEY]		= { .type = NLA_U32 },
 	[IFLA_VTI_OKEY]		= { .type = NLA_U32 },
-	[IFLA_VTI_LOCAL]	= { .len = FIELD_SIZEOF(struct iphdr, saddr) },
-	[IFLA_VTI_REMOTE]	= { .len = FIELD_SIZEOF(struct iphdr, daddr) },
+	[IFLA_VTI_LOCAL]	= { .len = sizeof_member(struct iphdr, saddr) },
+	[IFLA_VTI_REMOTE]	= { .len = sizeof_member(struct iphdr, daddr) },
 	[IFLA_VTI_FWMARK]	= { .type = NLA_U32 },
 };
 
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 3183413ebc6c..2bb21878de32 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -977,7 +977,7 @@ struct proto raw_prot = {
 	.unhash		   = raw_unhash_sk,
 	.obj_size	   = sizeof(struct raw_sock),
 	.useroffset	   = offsetof(struct raw_sock, filter),
-	.usersize	   = sizeof_field(struct raw_sock, filter),
+	.usersize	   = sizeof_member(struct raw_sock, filter),
 	.h.raw_hash	   = &raw_v4_hashinfo,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_raw_setsockopt,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f98a1882e537..7d23503a1d2d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3930,7 +3930,7 @@ void __init tcp_init(void)
 
 	BUILD_BUG_ON(TCP_MIN_SND_MSS <= MAX_TCP_OPTION_SPACE);
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) >
-		     FIELD_SIZEOF(struct sk_buff, cb));
+		     sizeof_member(struct sk_buff, cb));
 
 	percpu_counter_init(&tcp_sockets_allocated, 0, GFP_KERNEL);
 	percpu_counter_init(&tcp_orphan_count, 0, GFP_KERNEL);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d5779d6a6065..be1a8c823b2a 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2170,8 +2170,8 @@ static const struct nla_policy ip6gre_policy[IFLA_GRE_MAX + 1] = {
 	[IFLA_GRE_OFLAGS]      = { .type = NLA_U16 },
 	[IFLA_GRE_IKEY]        = { .type = NLA_U32 },
 	[IFLA_GRE_OKEY]        = { .type = NLA_U32 },
-	[IFLA_GRE_LOCAL]       = { .len = FIELD_SIZEOF(struct ipv6hdr, saddr) },
-	[IFLA_GRE_REMOTE]      = { .len = FIELD_SIZEOF(struct ipv6hdr, daddr) },
+	[IFLA_GRE_LOCAL]       = { .len = sizeof_member(struct ipv6hdr, saddr) },
+	[IFLA_GRE_REMOTE]      = { .len = sizeof_member(struct ipv6hdr, daddr) },
 	[IFLA_GRE_TTL]         = { .type = NLA_U8 },
 	[IFLA_GRE_ENCAP_LIMIT] = { .type = NLA_U8 },
 	[IFLA_GRE_FLOWINFO]    = { .type = NLA_U32 },
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index a77f6b7d3a7c..664b65139816 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1294,7 +1294,7 @@ struct proto rawv6_prot = {
 	.unhash		   = raw_unhash_sk,
 	.obj_size	   = sizeof(struct raw6_sock),
 	.useroffset	   = offsetof(struct raw6_sock, filter),
-	.usersize	   = sizeof_field(struct raw6_sock, filter),
+	.usersize	   = sizeof_member(struct raw6_sock, filter),
 	.h.raw_hash	   = &raw_v6_hashinfo,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_rawv6_setsockopt,
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index ebb62a4ebe30..32ebb21b31dd 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -50,7 +50,7 @@ static struct iucv_interface *pr_iucv;
 static const u8 iprm_shutdown[8] =
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
 
-#define TRGCLS_SIZE	FIELD_SIZEOF(struct iucv_message, class)
+#define TRGCLS_SIZE	sizeof_member(struct iucv_message, class)
 
 #define __iucv_sock_wait(sk, condition, timeo, ret)			\
 do {									\
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d481f9baca2f..ec252362d2ab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7321,7 +7321,7 @@ int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 		return -EINVAL;
 	if (len == 0)
 		return -EINVAL;
-	if (reg * NFT_REG32_SIZE + len > FIELD_SIZEOF(struct nft_regs, data))
+	if (reg * NFT_REG32_SIZE + len > sizeof_member(struct nft_regs, data))
 		return -ERANGE;
 
 	return 0;
@@ -7369,7 +7369,7 @@ int nft_validate_register_store(const struct nft_ctx *ctx,
 		if (len == 0)
 			return -EINVAL;
 		if (reg * NFT_REG32_SIZE + len >
-		    FIELD_SIZEOF(struct nft_regs, data))
+		    sizeof_member(struct nft_regs, data))
 			return -ERANGE;
 
 		if (data != NULL && type != NFT_DATA_VALUE)
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 7525063c25f5..0b6641c0ca19 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -236,7 +236,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	nla_strlcpy(helper->name,
 		    tb[NFCTH_NAME], NF_CT_HELPER_NAME_LEN);
 	size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
-	if (size > FIELD_SIZEOF(struct nf_conn_help, data)) {
+	if (size > sizeof_member(struct nf_conn_help, data)) {
 		ret = -ENOMEM;
 		goto err2;
 	}
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 46ca8bcca1bd..6f366f1153e9 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -440,12 +440,12 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 
 		switch (ctx->family) {
 		case NFPROTO_IPV4:
-			len = FIELD_SIZEOF(struct nf_conntrack_tuple,
+			len = sizeof_member(struct nf_conntrack_tuple,
 					   src.u3.ip);
 			break;
 		case NFPROTO_IPV6:
 		case NFPROTO_INET:
-			len = FIELD_SIZEOF(struct nf_conntrack_tuple,
+			len = sizeof_member(struct nf_conntrack_tuple,
 					   src.u3.ip6);
 			break;
 		default:
@@ -457,20 +457,20 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		if (tb[NFTA_CT_DIRECTION] == NULL)
 			return -EINVAL;
 
-		len = FIELD_SIZEOF(struct nf_conntrack_tuple, src.u3.ip);
+		len = sizeof_member(struct nf_conntrack_tuple, src.u3.ip);
 		break;
 	case NFT_CT_SRC_IP6:
 	case NFT_CT_DST_IP6:
 		if (tb[NFTA_CT_DIRECTION] == NULL)
 			return -EINVAL;
 
-		len = FIELD_SIZEOF(struct nf_conntrack_tuple, src.u3.ip6);
+		len = sizeof_member(struct nf_conntrack_tuple, src.u3.ip6);
 		break;
 	case NFT_CT_PROTO_SRC:
 	case NFT_CT_PROTO_DST:
 		if (tb[NFTA_CT_DIRECTION] == NULL)
 			return -EINVAL;
-		len = FIELD_SIZEOF(struct nf_conntrack_tuple, src.u.all);
+		len = sizeof_member(struct nf_conntrack_tuple, src.u.all);
 		break;
 	case NFT_CT_BYTES:
 	case NFT_CT_PKTS:
@@ -551,7 +551,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	case NFT_CT_MARK:
 		if (tb[NFTA_CT_DIRECTION])
 			return -EINVAL;
-		len = FIELD_SIZEOF(struct nf_conn, mark);
+		len = sizeof_member(struct nf_conn, mark);
 		break;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_LABELS
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 39dc94f2491e..7f8a8056e4ad 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -43,7 +43,7 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 			 const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
-	u32 plen = FIELD_SIZEOF(struct nf_nat_range, min_addr.all);
+	u32 plen = sizeof_member(struct nf_nat_range, min_addr.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index c3c93e95b46e..09c4a8d5c878 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -141,10 +141,10 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		alen = FIELD_SIZEOF(struct nf_nat_range, min_addr.ip);
+		alen = sizeof_member(struct nf_nat_range, min_addr.ip);
 		break;
 	case NFPROTO_IPV6:
-		alen = FIELD_SIZEOF(struct nf_nat_range, min_addr.ip6);
+		alen = sizeof_member(struct nf_nat_range, min_addr.ip6);
 		break;
 	default:
 		return -EAFNOSUPPORT;
@@ -171,7 +171,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		}
 	}
 
-	plen = FIELD_SIZEOF(struct nf_nat_range, min_addr.all);
+	plen = sizeof_member(struct nf_nat_range, min_addr.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		priv->sreg_proto_min =
 			nft_parse_register(tb[NFTA_NAT_REG_PROTO_MIN]);
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 43eeb1f609f1..4896c318ebb1 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -48,7 +48,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = FIELD_SIZEOF(struct nf_nat_range, min_addr.all);
+	plen = sizeof_member(struct nf_nat_range, min_addr.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		priv->sreg_proto_min =
 			nft_parse_register(tb[NFTA_REDIR_REG_PROTO_MIN]);
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f92a82c73880..1f72856fc571 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -218,14 +218,14 @@ static int nft_tproxy_init(const struct nft_ctx *ctx,
 
 	switch (priv->family) {
 	case NFPROTO_IPV4:
-		alen = FIELD_SIZEOF(union nf_inet_addr, in);
+		alen = sizeof_member(union nf_inet_addr, in);
 		err = nf_defrag_ipv4_enable(ctx->net);
 		if (err)
 			return err;
 		break;
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 	case NFPROTO_IPV6:
-		alen = FIELD_SIZEOF(union nf_inet_addr, in6);
+		alen = sizeof_member(union nf_inet_addr, in6);
 		err = nf_defrag_ipv6_enable(ctx->net);
 		if (err)
 			return err;
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 2236455b10a3..cd3748d057e0 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -30,7 +30,7 @@ static unsigned int jhash_rnd __read_mostly;
 
 static unsigned int xt_rateest_hash(const char *name)
 {
-	return jhash(name, FIELD_SIZEOF(struct xt_rateest, name), jhash_rnd) &
+	return jhash(name, sizeof_member(struct xt_rateest, name), jhash_rnd) &
 	       (RATEEST_HSIZE - 1);
 }
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 90b2ab9dd449..e1a32ff781a5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2755,7 +2755,7 @@ static int __init netlink_proto_init(void)
 	if (err != 0)
 		goto out;
 
-	BUILD_BUG_ON(sizeof(struct netlink_skb_parms) > FIELD_SIZEOF(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(struct netlink_skb_parms) > sizeof_member(struct sk_buff, cb));
 
 	nl_table = kcalloc(MAX_LINKS, sizeof(*nl_table), GFP_KERNEL);
 	if (!nl_table)
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index f30e406fbec5..4c412b2b27b4 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2449,7 +2449,7 @@ static int __init dp_init(void)
 {
 	int err;
 
-	BUILD_BUG_ON(sizeof(struct ovs_skb_cb) > FIELD_SIZEOF(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(struct ovs_skb_cb) > sizeof_member(struct sk_buff, cb));
 
 	pr_info("Open vSwitch switching datapath\n");
 
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index b830d5ff7af4..c9987cd5e03c 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -36,7 +36,7 @@ enum sw_flow_mac_proto {
  * matching for small options.
  */
 #define TUN_METADATA_OFFSET(opt_len) \
-	(FIELD_SIZEOF(struct sw_flow_key, tun_opts) - opt_len)
+	(sizeof_member(struct sw_flow_key, tun_opts) - opt_len)
 #define TUN_METADATA_OPTS(flow_key, opt_len) \
 	((void *)((flow_key)->tun_opts + TUN_METADATA_OFFSET(opt_len)))
 
@@ -51,7 +51,7 @@ struct vlan_head {
 
 #define OVS_SW_FLOW_KEY_METADATA_SIZE			\
 	(offsetof(struct sw_flow_key, recirc_id) +	\
-	FIELD_SIZEOF(struct sw_flow_key, recirc_id))
+	sizeof_member(struct sw_flow_key, recirc_id))
 
 struct ovs_key_nsh {
 	struct ovs_nsh_key_base base;
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index d72ddb67bb74..9f231e112765 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -972,7 +972,7 @@ static int __init af_rxrpc_init(void)
 	int ret = -1;
 	unsigned int tmp;
 
-	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > FIELD_SIZEOF(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > sizeof_member(struct sk_buff, cb));
 
 	get_random_bytes(&tmp, sizeof(tmp));
 	tmp &= 0x3fffffff;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index fcc46025e790..3ee22bbac3ff 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -312,7 +312,7 @@ static void tcf_ct_act_set_labels(struct nf_conn *ct,
 				  u32 *labels_m)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)
-	size_t labels_sz = FIELD_SIZEOF(struct tcf_ct_params, labels);
+	size_t labels_sz = sizeof_member(struct tcf_ct_params, labels);
 
 	if (!memchr_inv(labels_m, 0, labels_sz))
 		return;
@@ -929,7 +929,7 @@ static struct tc_action_ops act_ct_ops = {
 
 static __net_init int ct_init_net(struct net *net)
 {
-	unsigned int n_bits = FIELD_SIZEOF(struct tcf_ct_params, labels) * 8;
+	unsigned int n_bits = sizeof_member(struct tcf_ct_params, labels) * 8;
 	struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
 
 	if (nf_connlabels_get(net, n_bits - 1)) {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 74221e3351c3..4e8a3377ac4e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1285,7 +1285,7 @@ static int fl_init_mask_hashtable(struct fl_flow_mask *mask)
 }
 
 #define FL_KEY_MEMBER_OFFSET(member) offsetof(struct fl_flow_key, member)
-#define FL_KEY_MEMBER_SIZE(member) FIELD_SIZEOF(struct fl_flow_key, member)
+#define FL_KEY_MEMBER_SIZE(member) sizeof_member(struct fl_flow_key, member)
 
 #define FL_KEY_IS_MASKED(mask, member)						\
 	memchr_inv(((char *)mask) + FL_KEY_MEMBER_OFFSET(member),		\
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 939b8d2595bc..4c3105d96dce 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9505,7 +9505,7 @@ struct proto sctp_prot = {
 	.useroffset  =  offsetof(struct sctp_sock, subscribe),
 	.usersize    =  offsetof(struct sctp_sock, initmsg) -
 				offsetof(struct sctp_sock, subscribe) +
-				sizeof_field(struct sctp_sock, initmsg),
+				sizeof_member(struct sctp_sock, initmsg),
 	.sysctl_mem  =  sysctl_sctp_mem,
 	.sysctl_rmem =  sysctl_sctp_rmem,
 	.sysctl_wmem =  sysctl_sctp_wmem,
@@ -9547,7 +9547,7 @@ struct proto sctpv6_prot = {
 	.useroffset	= offsetof(struct sctp6_sock, sctp.subscribe),
 	.usersize	= offsetof(struct sctp6_sock, sctp.initmsg) -
 				offsetof(struct sctp6_sock, sctp.subscribe) +
-				sizeof_field(struct sctp6_sock, sctp.initmsg),
+				sizeof_member(struct sctp6_sock, sctp.initmsg),
 	.sysctl_mem	= sysctl_sctp_mem,
 	.sysctl_rmem	= sysctl_sctp_rmem,
 	.sysctl_wmem	= sysctl_sctp_wmem,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67e87db5877f..ee9b2d8684c3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2848,7 +2848,7 @@ static int __init af_unix_init(void)
 {
 	int rc = -1;
 
-	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > FIELD_SIZEOF(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_member(struct sk_buff, cb));
 
 	rc = proto_register(&unix_proto, 1);
 	if (rc != 0) {
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 5380aca2b351..18bf8e2d4f95 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -45,7 +45,7 @@
 #define DONT_HASH	0x0200
 
 #define INVALID_PCR(a) (((a) < 0) || \
-	(a) >= (FIELD_SIZEOF(struct integrity_iint_cache, measured_pcrs) * 8))
+	(a) >= (sizeof_member(struct integrity_iint_cache, measured_pcrs) * 8))
 
 int ima_policy_flag;
 static int temp_ima_appraise;
@@ -274,7 +274,7 @@ static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
 	 * lsm rules can change
 	 */
 	memcpy(nentry, entry, sizeof(*nentry));
-	memset(nentry->lsm, 0, FIELD_SIZEOF(struct ima_rule_entry, lsm));
+	memset(nentry->lsm, 0, sizeof_member(struct ima_rule_entry, lsm));
 
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		if (!entry->lsm[i].rule)
diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index b5fd8f08726e..c8b1ac22b2b2 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -292,7 +292,7 @@ static int hdmi_eld_ctl_info(struct snd_kcontrol *kcontrol,
 			     struct snd_ctl_elem_info *uinfo)
 {
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_BYTES;
-	uinfo->count = FIELD_SIZEOF(struct hdmi_codec_priv, eld);
+	uinfo->count = sizeof_member(struct hdmi_codec_priv, eld);
 
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd68fbe0a75d..777d3b125072 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4293,7 +4293,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		kmem_cache_create_usercopy("kvm_vcpu", vcpu_size, vcpu_align,
 					   SLAB_ACCOUNT,
 					   offsetof(struct kvm_vcpu, arch),
-					   sizeof_field(struct kvm_vcpu, arch),
+					   sizeof_member(struct kvm_vcpu, arch),
 					   NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
-- 
2.17.1

