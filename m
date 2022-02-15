Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8904B77DB
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbiBORkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:40:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiBORkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E384A3C4;
        Tue, 15 Feb 2022 09:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 960056160E;
        Tue, 15 Feb 2022 17:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6721C340EB;
        Tue, 15 Feb 2022 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644946809;
        bh=DMett6vVXSj8wlqJaPBVitbC+1b/pFrWBdbwXSCqmvY=;
        h=Date:From:To:Subject:From;
        b=YHAhsK9b4ceo93O7cGMZkhAJtHRB9CQ+4MLg6VhoAXIqUZPNOt2f2z/RHYaJLxO76
         o1sCxEuNmr5hKqcrqdfi+pE1eKIsCJw9V851Cjnm9cHc2sRZx45hzEu6vQLDXrkmcu
         xKf2+PXhFhb8dbpeFBN+6vQWXHxPvhHISBgL9Fxux6eGzM+9JCAXaTGT3/3xrwLv7i
         m8KqkuUbReSbhvZRqSxYfdGT/EXjyAq6yFXtOj0CnyhrPV5rigOkg2Pp92zsFyGVAh
         1grvtuR4WfTMHEo/CBi7F8KvXPKqUpdwIOcsL3Pbwr2lQCgLUtbCpkZ3x6BdjDlhc3
         zFo6AQd/J/DOQ==
Date:   Tue, 15 Feb 2022 11:47:43 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        linux-crypto@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-staging@lists.linux.dev,
        linux-rpi-kernel@lists.infradead.org, sparmaintainer@unisys.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
        greybus-dev@lists.linaro.org, linux-i3c@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] treewide: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220215174743.GA878920@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

This code was transformed with the help of Coccinelle:
(next-20220214$ spatch --jobs $(getconf _NPROCESSORS_ONLN) --sp-file script.cocci --include-headers --dir . > output.patch)

@@
identifier S, member, array;
type T1, T2;
@@

struct S {
  ...
  T1 member;
  T2 array[
- 0
  ];
};

UAPI and wireless changes were intentionally excluded from this patch
and will be sent out separately.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Hi all,

I'm expecting to carry this patch in my tree, so it'd be great to
get some Acks. And given the size of the patch, I'm only sending
this to mailing lists.

Thanks!

 arch/alpha/include/asm/hwrpb.h                |  2 +-
 arch/ia64/include/asm/sal.h                   |  2 +-
 arch/s390/include/asm/ccwgroup.h              |  2 +-
 arch/s390/include/asm/chsc.h                  |  2 +-
 arch/s390/include/asm/eadm.h                  |  2 +-
 arch/s390/include/asm/fcx.h                   |  4 ++--
 arch/s390/include/asm/idals.h                 |  2 +-
 arch/s390/include/asm/sclp.h                  |  2 +-
 arch/s390/include/asm/sysinfo.h               |  6 +++---
 arch/sh/include/asm/thread_info.h             |  2 +-
 arch/sparc/include/asm/vio.h                  | 10 +++++-----
 arch/um/include/shared/net_kern.h             |  2 +-
 arch/x86/include/asm/microcode_amd.h          |  2 +-
 arch/x86/include/asm/microcode_intel.h        |  4 ++--
 arch/x86/include/asm/pci.h                    |  2 +-
 arch/x86/include/asm/pci_x86.h                |  2 +-
 arch/xtensa/include/asm/bootparam.h           |  2 +-
 drivers/crypto/caam/pdb.h                     |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_ads.c    |  2 +-
 drivers/gpu/drm/nouveau/include/nvfw/hs.h     |  2 +-
 .../hwtracing/coresight/coresight-config.h    |  2 +-
 drivers/misc/bcm-vk/bcm_vk.h                  |  2 +-
 .../misc/habanalabs/include/common/cpucp_if.h |  6 +++---
 .../habanalabs/include/gaudi/gaudi_packets.h  |  4 ++--
 .../habanalabs/include/goya/goya_packets.h    |  4 ++--
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  2 +-
 drivers/net/ethernet/i825xx/sun3_82586.h      |  2 +-
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  6 +++---
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h |  2 +-
 drivers/net/ethernet/ti/davinci_mdio.c        |  2 +-
 drivers/scsi/dpt/dpti_i2o.h                   |  2 +-
 drivers/scsi/elx/libefc_sli/sli4.h            | 20 +++++++++----------
 drivers/scsi/mpi3mr/mpi3mr.h                  |  2 +-
 drivers/scsi/qla2xxx/qla_bsg.h                |  4 ++--
 drivers/scsi/qla2xxx/qla_def.h                |  2 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h           |  4 ++--
 drivers/scsi/qla2xxx/qla_fw.h                 |  2 +-
 drivers/scsi/qla4xxx/ql4_fw.h                 |  2 +-
 drivers/staging/r8188eu/include/ieee80211.h   |  6 +++---
 drivers/staging/r8188eu/include/rtw_cmd.h     | 10 +++++-----
 drivers/staging/rtl8712/rtl871x_cmd.h         |  8 ++++----
 drivers/staging/rtl8723bs/include/ieee80211.h |  2 +-
 drivers/staging/rtl8723bs/include/rtw_cmd.h   |  2 +-
 .../include/linux/raspberrypi/vchiq.h         |  2 +-
 drivers/visorbus/vbuschannel.h                |  2 +-
 fs/cifs/ntlmssp.h                             |  2 +-
 fs/ext4/fast_commit.h                         |  4 ++--
 fs/ksmbd/ksmbd_netlink.h                      |  2 +-
 fs/ksmbd/ntlmssp.h                            |  6 +++---
 fs/ksmbd/smb2pdu.h                            |  8 ++++----
 fs/ksmbd/transport_rdma.c                     |  2 +-
 fs/ksmbd/xattr.h                              |  2 +-
 fs/xfs/scrub/attr.h                           |  2 +-
 include/acpi/actbl2.h                         |  2 +-
 include/asm-generic/tlb.h                     |  4 ++--
 include/linux/greybus/greybus_manifest.h      |  4 ++--
 include/linux/greybus/hd.h                    |  2 +-
 include/linux/greybus/module.h                |  2 +-
 include/linux/i3c/ccc.h                       |  6 +++---
 include/linux/mlx5/mlx5_ifc_fpga.h            |  2 +-
 include/linux/platform_data/brcmfmac.h        |  2 +-
 .../linux/platform_data/cros_ec_commands.h    |  2 +-
 include/net/bluetooth/mgmt.h                  |  2 +-
 include/net/ioam6.h                           |  2 +-
 include/sound/sof/channel_map.h               |  4 ++--
 scripts/dtc/libfdt/fdt.h                      |  4 ++--
 sound/soc/intel/atom/sst-mfld-dsp.h           |  4 ++--
 sound/soc/intel/skylake/skl-topology.h        |  2 +-
 tools/lib/perf/include/perf/event.h           |  2 +-
 69 files changed, 116 insertions(+), 116 deletions(-)

diff --git a/arch/alpha/include/asm/hwrpb.h b/arch/alpha/include/asm/hwrpb.h
index d8180e527a1e..fc76f36265ad 100644
--- a/arch/alpha/include/asm/hwrpb.h
+++ b/arch/alpha/include/asm/hwrpb.h
@@ -152,7 +152,7 @@ struct memdesc_struct {
 	unsigned long chksum;
 	unsigned long optional_pa;
 	unsigned long numclusters;
-	struct memclust_struct cluster[0];
+	struct memclust_struct cluster[];
 };
 
 struct dsr_struct {
diff --git a/arch/ia64/include/asm/sal.h b/arch/ia64/include/asm/sal.h
index 78f4f7b40435..22749a201e92 100644
--- a/arch/ia64/include/asm/sal.h
+++ b/arch/ia64/include/asm/sal.h
@@ -420,7 +420,7 @@ typedef struct sal_log_processor_info {
 	 * The rest of this structure consists of variable-length arrays, which can't be
 	 * expressed in C.
 	 */
-	sal_log_mod_error_info_t info[0];
+	sal_log_mod_error_info_t info[];
 	/*
 	 * This is what the rest looked like if C supported variable-length arrays:
 	 *
diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index aa995d91cd1d..11d2fb3de4f5 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -25,7 +25,7 @@ struct ccwgroup_device {
 	unsigned int count;
 	struct device	dev;
 	struct work_struct ungroup_work;
-	struct ccw_device *cdev[0];
+	struct ccw_device *cdev[];
 };
 
 /**
diff --git a/arch/s390/include/asm/chsc.h b/arch/s390/include/asm/chsc.h
index ae4d2549cd67..bb48ea380c0d 100644
--- a/arch/s390/include/asm/chsc.h
+++ b/arch/s390/include/asm/chsc.h
@@ -63,7 +63,7 @@ struct chsc_pnso_area {
 	struct chsc_header response;
 	u32:32;
 	struct chsc_pnso_naihdr naihdr;
-	struct chsc_pnso_naid_l2 entries[0];
+	struct chsc_pnso_naid_l2 entries[];
 } __packed __aligned(PAGE_SIZE);
 
 #endif /* _ASM_S390_CHSC_H */
diff --git a/arch/s390/include/asm/eadm.h b/arch/s390/include/asm/eadm.h
index 445fe4c8184a..06f795855af7 100644
--- a/arch/s390/include/asm/eadm.h
+++ b/arch/s390/include/asm/eadm.h
@@ -78,7 +78,7 @@ struct aob {
 
 struct aob_rq_header {
 	struct scm_device *scmdev;
-	char data[0];
+	char data[];
 };
 
 struct scm_device {
diff --git a/arch/s390/include/asm/fcx.h b/arch/s390/include/asm/fcx.h
index cff0749e9657..b8a028a36173 100644
--- a/arch/s390/include/asm/fcx.h
+++ b/arch/s390/include/asm/fcx.h
@@ -214,7 +214,7 @@ struct dcw_intrg_data {
 	u32 :32;
 	u64 time;
 	u64 prog_id;
-	u8  prog_data[0];
+	u8  prog_data[];
 } __attribute__ ((packed));
 
 #define DCW_FLAGS_CC		(1 << (7 - 1))
@@ -241,7 +241,7 @@ struct dcw {
 	u32 :8;
 	u32 cd_count:8;
 	u32 count;
-	u8 cd[0];
+	u8 cd[];
 } __attribute__ ((packed));
 
 #define TCCB_FORMAT_DEFAULT	0x7f
diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index 6fb7aced104a..40eae2c08d61 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -108,7 +108,7 @@ clear_normalized_cda(struct ccw1 * ccw)
 struct idal_buffer {
 	size_t size;
 	size_t page_order;
-	void *data[0];
+	void *data[];
 };
 
 /*
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index c68ea35de498..22b3213c6c9d 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -112,7 +112,7 @@ struct zpci_report_error_header {
 			 *	(OpenCrypto Successful Diagnostics Execution)
 			 */
 	u16 length;	/* Length of Subsequent Data (up to 4K – SCLP header */
-	u8 data[0];	/* Subsequent Data passed verbatim to SCLP ET 24 */
+	u8 data[];	/* Subsequent Data passed verbatim to SCLP ET 24 */
 } __packed;
 
 extern char *sclp_early_sccb;
diff --git a/arch/s390/include/asm/sysinfo.h b/arch/s390/include/asm/sysinfo.h
index fe7b3f8f0791..ab1c6316055c 100644
--- a/arch/s390/include/asm/sysinfo.h
+++ b/arch/s390/include/asm/sysinfo.h
@@ -67,12 +67,12 @@ struct sysinfo_1_2_2 {
 	unsigned short cpus_configured;
 	unsigned short cpus_standby;
 	unsigned short cpus_reserved;
-	unsigned short adjustment[0];
+	unsigned short adjustment[];
 };
 
 struct sysinfo_1_2_2_extension {
 	unsigned int alt_capability;
-	unsigned short alt_adjustment[0];
+	unsigned short alt_adjustment[];
 };
 
 struct sysinfo_2_2_1 {
@@ -181,7 +181,7 @@ struct sysinfo_15_1_x {
 	unsigned char reserved1;
 	unsigned char mnest;
 	unsigned char reserved2[4];
-	union topology_entry tle[0];
+	union topology_entry tle[];
 };
 
 int stsi(void *sysinfo, int fc, int sel1, int sel2);
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 598d0184ffea..3a2d50d61fc9 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -33,7 +33,7 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space */
 	unsigned long		previous_sp;	/* sp of previous stack in case
 						   of nested IRQ stacks */
-	__u8			supervisor_stack[0];
+	__u8			supervisor_stack[];
 };
 
 #endif
diff --git a/arch/sparc/include/asm/vio.h b/arch/sparc/include/asm/vio.h
index 8a1a83bbb6d5..2d7bdf665fd3 100644
--- a/arch/sparc/include/asm/vio.h
+++ b/arch/sparc/include/asm/vio.h
@@ -70,7 +70,7 @@ struct vio_dring_register {
 #define VIO_RX_DRING_DATA	0x0004
 	u16			resv;
 	u32			num_cookies;
-	struct ldc_trans_cookie	cookies[0];
+	struct ldc_trans_cookie	cookies[];
 };
 
 struct vio_dring_unregister {
@@ -161,7 +161,7 @@ struct vio_disk_desc {
 	u64			size;
 	u32			ncookies;
 	u32			resv2;
-	struct ldc_trans_cookie	cookies[0];
+	struct ldc_trans_cookie	cookies[];
 };
 
 #define VIO_DISK_VNAME_LEN	8
@@ -200,13 +200,13 @@ struct vio_disk_devid {
 	u16			resv;
 	u16			type;
 	u32			len;
-	char			id[0];
+	char			id[];
 };
 
 struct vio_disk_efi {
 	u64			lba;
 	u64			len;
-	char			data[0];
+	char			data[];
 };
 
 /* VIO net specific structures and defines */
@@ -246,7 +246,7 @@ struct vio_net_desc {
 	struct vio_dring_hdr	hdr;
 	u32			size;
 	u32			ncookies;
-	struct ldc_trans_cookie	cookies[0];
+	struct ldc_trans_cookie	cookies[];
 };
 
 struct vio_net_dext {
diff --git a/arch/um/include/shared/net_kern.h b/arch/um/include/shared/net_kern.h
index 441a8a309329..67b2e9a1f2e5 100644
--- a/arch/um/include/shared/net_kern.h
+++ b/arch/um/include/shared/net_kern.h
@@ -39,7 +39,7 @@ struct uml_net_private {
 
 	void (*add_address)(unsigned char *, unsigned char *, void *);
 	void (*delete_address)(unsigned char *, unsigned char *, void *);
-	char user[0];
+	char user[];
 };
 
 struct net_kern_info {
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 7063b5a43220..ac31f9140d07 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -38,7 +38,7 @@ struct microcode_header_amd {
 
 struct microcode_amd {
 	struct microcode_header_amd	hdr;
-	unsigned int			mpb[0];
+	unsigned int			mpb[];
 };
 
 #define PATCH_MAX_SIZE (3 * PAGE_SIZE)
diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index d85a07d7154f..4c92cea7e4b5 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -19,7 +19,7 @@ struct microcode_header_intel {
 
 struct microcode_intel {
 	struct microcode_header_intel hdr;
-	unsigned int            bits[0];
+	unsigned int            bits[];
 };
 
 /* microcode format is extended from prescott processors */
@@ -33,7 +33,7 @@ struct extended_sigtable {
 	unsigned int            count;
 	unsigned int            cksum;
 	unsigned int            reserved[3];
-	struct extended_signature sigs[0];
+	struct extended_signature sigs[];
 };
 
 #define DEFAULT_UCODE_DATASIZE	(2000)
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d2c76c8d8cfd..f3fd5928bcbb 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -135,7 +135,7 @@ struct pci_setup_rom {
 	unsigned long bus;
 	unsigned long device;
 	unsigned long function;
-	uint8_t romdata[0];
+	uint8_t romdata[];
 };
 
 #endif /* _ASM_X86_PCI_H */
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 490411dba438..3fb6fc596095 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -87,7 +87,7 @@ struct irq_routing_table {
 	u32 miniport_data;		/* Crap */
 	u8 rfu[11];
 	u8 checksum;			/* Modulo 256 checksum must give 0 */
-	struct irq_info slots[0];
+	struct irq_info slots[];
 } __attribute__((packed));
 
 extern unsigned int pcibios_irq_mask;
diff --git a/arch/xtensa/include/asm/bootparam.h b/arch/xtensa/include/asm/bootparam.h
index 892aab399ac8..6333bd1eb9d2 100644
--- a/arch/xtensa/include/asm/bootparam.h
+++ b/arch/xtensa/include/asm/bootparam.h
@@ -34,7 +34,7 @@
 typedef struct bp_tag {
 	unsigned short id;	/* tag id */
 	unsigned short size;	/* size of this record excluding the structure*/
-	unsigned long data[0];	/* data */
+	unsigned long data[];	/* data */
 } bp_tag_t;
 
 struct bp_meminfo {
diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 8ccc22075043..4b1bcf53f7ac 100644
--- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -144,7 +144,7 @@ struct ipsec_encap_pdb {
 	};
 	u32 spi;
 	u32 ip_hdr_len;
-	u32 ip_hdr[0];
+	u32 ip_hdr[];
 };
 
 /**
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_ads.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_ads.c
index 1a1edae67e4e..3acee0060e23 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_ads.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_ads.c
@@ -51,7 +51,7 @@ struct __guc_ads_blob {
 	struct guc_gt_system_info system_info;
 	struct guc_engine_usage engine_usage;
 	/* From here on, location is dynamic! Refer to above diagram. */
-	struct guc_mmio_reg regset[0];
+	struct guc_mmio_reg regset[];
 } __packed;
 
 static u32 guc_ads_regset_size(struct intel_guc *guc)
diff --git a/drivers/gpu/drm/nouveau/include/nvfw/hs.h b/drivers/gpu/drm/nouveau/include/nvfw/hs.h
index 64d0d32200c2..b53bbc4cd130 100644
--- a/drivers/gpu/drm/nouveau/include/nvfw/hs.h
+++ b/drivers/gpu/drm/nouveau/include/nvfw/hs.h
@@ -23,7 +23,7 @@ struct nvfw_hs_load_header {
 	u32 data_dma_base;
 	u32 data_size;
 	u32 num_apps;
-	u32 apps[0];
+	u32 apps[];
 };
 
 const struct nvfw_hs_load_header *
diff --git a/drivers/hwtracing/coresight/coresight-config.h b/drivers/hwtracing/coresight/coresight-config.h
index 9bd44b940add..2e1670523461 100644
--- a/drivers/hwtracing/coresight/coresight-config.h
+++ b/drivers/hwtracing/coresight/coresight-config.h
@@ -231,7 +231,7 @@ struct cscfg_config_csdev {
 	bool enabled;
 	struct list_head node;
 	int nr_feat;
-	struct cscfg_feature_csdev *feats_csdev[0];
+	struct cscfg_feature_csdev *feats_csdev[];
 };
 
 /**
diff --git a/drivers/misc/bcm-vk/bcm_vk.h b/drivers/misc/bcm-vk/bcm_vk.h
index a1338f375589..25d51222eedf 100644
--- a/drivers/misc/bcm-vk/bcm_vk.h
+++ b/drivers/misc/bcm-vk/bcm_vk.h
@@ -311,7 +311,7 @@ struct bcm_vk_peer_log {
 	u32 wr_idx;
 	u32 buf_size;
 	u32 mask;
-	char data[0];
+	char data[];
 };
 
 /* max buf size allowed */
diff --git a/drivers/misc/habanalabs/include/common/cpucp_if.h b/drivers/misc/habanalabs/include/common/cpucp_if.h
index 737c39f33f05..f9c4acc9bf5a 100644
--- a/drivers/misc/habanalabs/include/common/cpucp_if.h
+++ b/drivers/misc/habanalabs/include/common/cpucp_if.h
@@ -540,19 +540,19 @@ struct cpucp_packet {
 struct cpucp_unmask_irq_arr_packet {
 	struct cpucp_packet cpucp_pkt;
 	__le32 length;
-	__le32 irqs[0];
+	__le32 irqs[];
 };
 
 struct cpucp_nic_status_packet {
 	struct cpucp_packet cpucp_pkt;
 	__le32 length;
-	__le32 data[0];
+	__le32 data[];
 };
 
 struct cpucp_array_data_packet {
 	struct cpucp_packet cpucp_pkt;
 	__le32 length;
-	__le32 data[0];
+	__le32 data[];
 };
 
 enum cpucp_packet_rc {
diff --git a/drivers/misc/habanalabs/include/gaudi/gaudi_packets.h b/drivers/misc/habanalabs/include/gaudi/gaudi_packets.h
index 6e097ace2e96..66fc083a7c6a 100644
--- a/drivers/misc/habanalabs/include/gaudi/gaudi_packets.h
+++ b/drivers/misc/habanalabs/include/gaudi/gaudi_packets.h
@@ -54,7 +54,7 @@ struct gaudi_packet {
 	/* The rest of the packet data follows. Use the corresponding
 	 * packet_XXX struct to deference the data, based on packet type
 	 */
-	u8 contents[0];
+	u8 contents[];
 };
 
 struct packet_nop {
@@ -75,7 +75,7 @@ struct packet_wreg32 {
 struct packet_wreg_bulk {
 	__le32 size64;
 	__le32 ctl;
-	__le64 values[0]; /* data starts here */
+	__le64 values[]; /* data starts here */
 };
 
 #define GAUDI_PKT_LONG_CTL_OP_SHIFT		20
diff --git a/drivers/misc/habanalabs/include/goya/goya_packets.h b/drivers/misc/habanalabs/include/goya/goya_packets.h
index ef54bad20509..50ce5175b63a 100644
--- a/drivers/misc/habanalabs/include/goya/goya_packets.h
+++ b/drivers/misc/habanalabs/include/goya/goya_packets.h
@@ -62,7 +62,7 @@ struct goya_packet {
 	/* The rest of the packet data follows. Use the corresponding
 	 * packet_XXX struct to deference the data, based on packet type
 	 */
-	u8 contents[0];
+	u8 contents[];
 };
 
 struct packet_nop {
@@ -86,7 +86,7 @@ struct packet_wreg32 {
 struct packet_wreg_bulk {
 	__le32 size64;
 	__le32 ctl;
-	__le64 values[0]; /* data starts here */
+	__le64 values[]; /* data starts here */
 };
 
 struct packet_msg_long {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 1514e6a4a3ff..ce5b677e8c2f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -881,7 +881,7 @@ struct sgcl_data {
 	u32		bth;
 	u32		ct;
 	u32		cte;
-	struct sgce	sgcl[0];
+	struct sgce	sgcl[];
 };
 
 #define ENETC_CBDR_FMI_MR	BIT(0)
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.h b/drivers/net/ethernet/i825xx/sun3_82586.h
index 79aef681ac85..451cb3d26cb5 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.h
+++ b/drivers/net/ethernet/i825xx/sun3_82586.h
@@ -250,7 +250,7 @@ struct mcsetup_cmd_struct
   unsigned short cmd_cmd;
   unsigned short cmd_link;
   unsigned short mc_cnt;		/* number of bytes in the MC-List */
-  unsigned char  mc_list[0][6];  	/* pointer to 6 bytes entries */
+  unsigned char  mc_list[][6];  	/* pointer to 6 bytes entries */
 };
 
 /*
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 77fd39e2c8db..9b6e587e78b4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -455,7 +455,7 @@ struct npc_coalesced_kpu_prfl {
 	u8 name[NPC_NAME_LEN]; /* KPU Profile name */
 	u64 version; /* KPU firmware/profile version */
 	u8 num_prfl; /* No of NPC profiles. */
-	u16 prfl_sz[0];
+	u16 prfl_sz[];
 };
 
 struct npc_mcam_kex {
@@ -482,7 +482,7 @@ struct npc_kpu_fwdata {
 	 * struct npc_kpu_profile_cam[entries];
 	 * struct npc_kpu_profile_action[entries];
 	 */
-	u8	data[0];
+	u8	data[];
 } __packed;
 
 struct npc_lt_def {
@@ -572,7 +572,7 @@ struct npc_kpu_profile_fwdata {
 	 *  Custom KPU CAM and ACTION configuration entries.
 	 * struct npc_kpu_fwdata kpu[kpus];
 	 */
-	u8	data[0];
+	u8	data[];
 } __packed;
 
 struct rvu_npc_mcam_rule {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
index b70ee8200e15..6459dd3feb37 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
@@ -2470,6 +2470,6 @@ struct nvm_meta_bin_t {
 	u32 version;
 #define NVM_META_BIN_VERSION 1
 	u32 num_options;
-	u32 options[0];
+	u32 options[];
 };
 #endif
diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index a4efd5e35158..fce2626e34fa 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -70,7 +70,7 @@ struct davinci_mdio_regs {
 #define USERACCESS_DATA		(0xffff)
 
 		u32	physel;
-	}	user[0];
+	}	user[];
 };
 
 static const struct mdio_platform_data default_pdata = {
diff --git a/drivers/scsi/dpt/dpti_i2o.h b/drivers/scsi/dpt/dpti_i2o.h
index bf0daeeb50a9..e1fbbf55c09d 100644
--- a/drivers/scsi/dpt/dpti_i2o.h
+++ b/drivers/scsi/dpt/dpti_i2o.h
@@ -123,7 +123,7 @@ struct i2o_sys_tbl
 	u32	change_ind;
 	u32	reserved2;
 	u32	reserved3;
-	struct i2o_sys_tbl_entry iops[0];
+	struct i2o_sys_tbl_entry iops[];
 };
 
 /*
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index ee2a9e65a88d..38af166cc786 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -609,7 +609,7 @@ struct sli4_rqst_cmn_create_cq_v2 {
 	__le16			cqe_count;
 	__le16			rsvd30;
 	__le32			rsvd32;
-	struct sli4_dmaaddr	page_phys_addr[0];
+	struct sli4_dmaaddr	page_phys_addr[];
 };
 
 enum sli4_create_cqset_e {
@@ -634,7 +634,7 @@ struct sli4_rqst_cmn_create_cq_set_v0 {
 	__le16			num_cq_req;
 	__le16			dw6w1_flags;
 	__le16			eq_id[16];
-	struct sli4_dmaaddr	page_phys_addr[0];
+	struct sli4_dmaaddr	page_phys_addr[];
 };
 
 /* CQE count */
@@ -764,7 +764,7 @@ struct sli4_rqst_cmn_create_mq_ext {
 	__le32			dw7_val;
 	__le32			dw8_flags;
 	__le32			rsvd36;
-	struct sli4_dmaaddr	page_phys_addr[0];
+	struct sli4_dmaaddr	page_phys_addr[];
 };
 
 struct sli4_rsp_cmn_create_mq_ext {
@@ -802,7 +802,7 @@ struct sli4_rqst_cmn_create_cq_v0 {
 	__le32			dw6_flags;
 	__le32			rsvd28;
 	__le32			rsvd32;
-	struct sli4_dmaaddr	page_phys_addr[0];
+	struct sli4_dmaaddr	page_phys_addr[];
 };
 
 enum sli4_create_rq_e {
@@ -887,7 +887,7 @@ struct sli4_rqst_rq_create_v2 {
 	__le16			base_cq_id;
 	__le16			rsvd26;
 	__le32			rsvd42;
-	struct sli4_dmaaddr	page_phys_addr[0];
+	struct sli4_dmaaddr	page_phys_addr[];
 };
 
 struct sli4_rsp_rq_create_v2 {
@@ -3168,7 +3168,7 @@ struct sli4_rqst_cmn_read_object {
 	__le32			read_offset;
 	u8			object_name[104];
 	__le32			host_buffer_descriptor_count;
-	struct sli4_bde		host_buffer_descriptor[0];
+	struct sli4_bde		host_buffer_descriptor[];
 };
 
 #define RSP_COM_READ_OBJ_EOF		0x80000000
@@ -3191,7 +3191,7 @@ struct sli4_rqst_cmn_write_object {
 	__le32			write_offset;
 	u8			object_name[104];
 	__le32			host_buffer_descriptor_count;
-	struct sli4_bde		host_buffer_descriptor[0];
+	struct sli4_bde		host_buffer_descriptor[];
 };
 
 #define	RSP_CHANGE_STATUS		0xff
@@ -3217,7 +3217,7 @@ struct sli4_rqst_cmn_read_object_list {
 	__le32			read_offset;
 	u8			object_name[104];
 	__le32			host_buffer_descriptor_count;
-	struct sli4_bde		host_buffer_descriptor[0];
+	struct sli4_bde		host_buffer_descriptor[];
 };
 
 enum sli4_rqst_set_dump_flags {
@@ -3342,7 +3342,7 @@ struct sli4_rspource_descriptor_v1 {
 	u8		descriptor_type;
 	u8		descriptor_length;
 	__le16		rsvd16;
-	__le32		type_specific[0];
+	__le32		type_specific[];
 };
 
 enum sli4_pcie_desc_flags {
@@ -3474,7 +3474,7 @@ struct sli4_rqst_post_hdr_templates {
 	struct sli4_rqst_hdr	hdr;
 	__le16			rpi_offset;
 	__le16			page_count;
-	struct sli4_dmaaddr	page_descriptor[0];
+	struct sli4_dmaaddr	page_descriptor[];
 };
 
 #define SLI4_HDR_TEMPLATE_SIZE		64
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index fc4eaf6d1e47..fb7d8775c9f7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -878,7 +878,7 @@ struct mpi3mr_fwevt {
 	bool process_evt;
 	u32 evt_ctx;
 	struct kref ref_count;
-	char event_data[0] __aligned(4);
+	char event_data[] __aligned(4);
 };
 
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 0f8a4c7e52a2..6d2b0a7436c1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -157,7 +157,7 @@ struct qla84_msg_mgmt {
 	uint16_t rsrvd;
 	struct qla84_mgmt_param mgmtp;/* parameters for cmd */
 	uint32_t len; /* bytes in payload following this struct */
-	uint8_t payload[0]; /* payload for cmd */
+	uint8_t payload[]; /* payload for cmd */
 };
 
 struct qla_bsg_a84_mgmt {
@@ -216,7 +216,7 @@ struct qla_image_version {
 
 struct qla_image_version_list {
 	uint32_t count;
-	struct qla_image_version version[0];
+	struct qla_image_version version[];
 } __packed;
 
 struct qla_status_reg {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9ebf4a234d9a..b6434c72dee3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5410,7 +5410,7 @@ struct ql_vnd_stat_entry {
 struct ql_vnd_stats {
 	u64 entry_count; /* Num of entries */
 	u64 rservd;
-	struct ql_vnd_stat_entry entry[0]; /* Place holder of entries */
+	struct ql_vnd_stat_entry entry[]; /* Place holder of entries */
 } __packed;
 
 struct ql_vnd_host_stats_resp {
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 53026d82ebff..5a26c77157da 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -121,7 +121,7 @@ struct app_pinfo {
 struct app_pinfo_reply {
 	uint8_t		port_count;
 	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
-	struct app_pinfo ports[0];
+	struct app_pinfo ports[];
 } __packed;
 
 struct app_sinfo_req {
@@ -140,7 +140,7 @@ struct app_sinfo {
 
 struct app_stats_reply {
 	uint8_t		elem_count;
-	struct app_sinfo elem[0];
+	struct app_sinfo elem[];
 } __packed;
 
 struct qla_sa_update_frame {
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 073d06e88c58..0bb1d562f0bf 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1706,7 +1706,7 @@ struct qla_flt_header {
 	__le16	length;
 	__le16	checksum;
 	__le16	unused;
-	struct qla_flt_region region[0];
+	struct qla_flt_region region[];
 };
 
 #define FLT_REGION_SIZE		16
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 4e1764df0a73..860ec61b51b9 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -1028,7 +1028,7 @@ struct crash_record {
 
 	uint8_t out_RISC_reg_dump[256]; /* 80 -17F */
 	uint8_t in_RISC_reg_dump[256];	/*180 -27F */
-	uint8_t in_out_RISC_stack_dump[0];	/*280 - ??? */
+	uint8_t in_out_RISC_stack_dump[];	/*280 - ??? */
 };
 
 struct conn_event_log_entry {
diff --git a/drivers/staging/r8188eu/include/ieee80211.h b/drivers/staging/r8188eu/include/ieee80211.h
index 3a23d5299314..5e7de631b8ef 100644
--- a/drivers/staging/r8188eu/include/ieee80211.h
+++ b/drivers/staging/r8188eu/include/ieee80211.h
@@ -185,7 +185,7 @@ struct ieee_param {
 struct ieee_param_ex {
 	u32 cmd;
 	u8 sta_addr[ETH_ALEN];
-	u8 data[0];
+	u8 data[];
 };
 
 struct sta_data {
@@ -713,7 +713,7 @@ struct ieee80211_info_element_hdr {
 struct ieee80211_info_element {
 	u8 id;
 	u8 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /*
@@ -776,7 +776,7 @@ struct ieee80211_txb {
 	u16 reserved;
 	u16 frag_size;
 	u16 payload_size;
-	struct sk_buff *fragments[0];
+	struct sk_buff *fragments[];
 };
 
 /* SWEEP TABLE ENTRIES NUMBER*/
diff --git a/drivers/staging/r8188eu/include/rtw_cmd.h b/drivers/staging/r8188eu/include/rtw_cmd.h
index cf0945ae11c1..f8991a0493d0 100644
--- a/drivers/staging/r8188eu/include/rtw_cmd.h
+++ b/drivers/staging/r8188eu/include/rtw_cmd.h
@@ -73,7 +73,7 @@ struct c2h_evt_hdr {
 	u8 id:4;
 	u8 plen:4;
 	u8 seq;
-	u8 payload[0];
+	u8 payload[];
 };
 
 #define c2h_evt_exist(c2h_evt) ((c2h_evt)->id || (c2h_evt)->plen)
@@ -662,25 +662,25 @@ struct getcurtxpwrlevel_rspi {
 struct setprobereqextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct setassocreqextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct setproberspextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct setassocrspextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct addBaReq_parm {
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index ddd69c4ae208..95e9ea5b2d98 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -657,25 +657,25 @@ struct setra_parm {
 struct setprobereqextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct setassocreqextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct setproberspextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct setassocrspextraie_parm {
 	unsigned char e_id;
 	unsigned char ie_len;
-	unsigned char ie[0];
+	unsigned char ie[];
 };
 
 struct addBaReq_parm {
diff --git a/drivers/staging/rtl8723bs/include/ieee80211.h b/drivers/staging/rtl8723bs/include/ieee80211.h
index c11d7e2d2347..1e627dc0044d 100644
--- a/drivers/staging/rtl8723bs/include/ieee80211.h
+++ b/drivers/staging/rtl8723bs/include/ieee80211.h
@@ -204,7 +204,7 @@ struct ieee_param {
 struct ieee_param_ex {
 	u32 cmd;
 	u8 sta_addr[ETH_ALEN];
-	u8 data[0];
+	u8 data[];
 };
 
 struct sta_data {
diff --git a/drivers/staging/rtl8723bs/include/rtw_cmd.h b/drivers/staging/rtl8723bs/include/rtw_cmd.h
index 28d2d2732374..1bf030cbbbbe 100644
--- a/drivers/staging/rtl8723bs/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723bs/include/rtw_cmd.h
@@ -94,7 +94,7 @@ struct c2h_evt_hdr {
 	u8 id:4;
 	u8 plen:4;
 	u8 seq;
-	u8 payload[0];
+	u8 payload[];
 };
 
 struct c2h_evt_hdr_88xx {
diff --git a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
index 81db7fb76d6d..c93f2f3e87bb 100644
--- a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
+++ b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
@@ -45,7 +45,7 @@ struct vchiq_header {
 	/* Size of message data. */
 	unsigned int size;
 
-	char data[0];           /* message */
+	char data[];           /* message */
 };
 
 struct vchiq_element {
diff --git a/drivers/visorbus/vbuschannel.h b/drivers/visorbus/vbuschannel.h
index 4aaf6564eb9f..98711fb6d66e 100644
--- a/drivers/visorbus/vbuschannel.h
+++ b/drivers/visorbus/vbuschannel.h
@@ -89,7 +89,7 @@ struct visor_vbus_channel {
 	struct visor_vbus_headerinfo hdr_info;
 	struct visor_vbus_deviceinfo chp_info;
 	struct visor_vbus_deviceinfo bus_info;
-	struct visor_vbus_deviceinfo dev_info[0];
+	struct visor_vbus_deviceinfo dev_info[];
 } __packed;
 
 #endif
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 298458404252..55758b9ec877 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -107,7 +107,7 @@ struct negotiate_message {
 	SECURITY_BUFFER WorkstationName;	/* RFC 1001 and ASCII */
 	struct	ntlmssp_version Version;
 	/* SECURITY_BUFFER */
-	char DomainString[0];
+	char DomainString[];
 	/* followed by WorkstationString */
 } __packed;
 
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 083ad1cb705a..07e8b734c4fd 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -55,13 +55,13 @@ struct ext4_fc_del_range {
 struct ext4_fc_dentry_info {
 	__le32 fc_parent_ino;
 	__le32 fc_ino;
-	__u8 fc_dname[0];
+	__u8 fc_dname[];
 };
 
 /* Value structure for EXT4_FC_TAG_INODE and EXT4_FC_TAG_INODE_PARTIAL. */
 struct ext4_fc_inode {
 	__le32 fc_ino;
-	__u8 fc_raw_inode[0];
+	__u8 fc_raw_inode[];
 };
 
 /* Value structure for tag EXT4_FC_TAG_TAIL. */
diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index 71bfb7de4472..ebe6ca08467a 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -241,7 +241,7 @@ struct ksmbd_rpc_command {
 struct ksmbd_spnego_authen_request {
 	__u32	handle;
 	__u16	spnego_blob_len;	/* the length of spnego_blob */
-	__u8	spnego_blob[0];		/*
+	__u8	spnego_blob[];		/*
 					 * the GSS token from SecurityBuffer of
 					 * SMB2 SESSION SETUP request
 					 */
diff --git a/fs/ksmbd/ntlmssp.h b/fs/ksmbd/ntlmssp.h
index adaf4c0cbe8f..f13153c18b4e 100644
--- a/fs/ksmbd/ntlmssp.h
+++ b/fs/ksmbd/ntlmssp.h
@@ -95,7 +95,7 @@ struct security_buffer {
 struct target_info {
 	__le16 Type;
 	__le16 Length;
-	__u8 Content[0];
+	__u8 Content[];
 } __packed;
 
 struct negotiate_message {
@@ -108,7 +108,7 @@ struct negotiate_message {
 	 * struct security_buffer for version info not present since we
 	 * do not set the version is present flag
 	 */
-	char DomainString[0];
+	char DomainString[];
 	/* followed by WorkstationString */
 } __packed;
 
@@ -140,7 +140,7 @@ struct authenticate_message {
 	 * struct security_buffer for version info not present since we
 	 * do not set the version is present flag
 	 */
-	char UserString[0];
+	char UserString[];
 } __packed;
 
 struct ntlmv2_resp {
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 725b800c29c8..d49468426576 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -759,7 +759,7 @@ struct smb2_file_rename_info { /* encoding of request for level 10 */
 	__u8   Reserved[7];
 	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
 	__le32 FileNameLength;
-	char   FileName[0];     /* New name to be assigned */
+	char   FileName[];     /* New name to be assigned */
 } __packed; /* level 10 Set */
 
 struct smb2_file_link_info { /* encoding of request for level 11 */
@@ -768,7 +768,7 @@ struct smb2_file_link_info { /* encoding of request for level 11 */
 	__u8   Reserved[7];
 	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
 	__le32 FileNameLength;
-	char   FileName[0];     /* Name to be assigned to new link */
+	char   FileName[];     /* Name to be assigned to new link */
 } __packed; /* level 11 Set */
 
 /*
@@ -810,7 +810,7 @@ struct smb2_file_basic_info { /* data block encoding of response to level 18 */
 
 struct smb2_file_alt_name_info {
 	__le32 FileNameLength;
-	char FileName[0];
+	char FileName[];
 } __packed;
 
 struct smb2_file_stream_info {
@@ -818,7 +818,7 @@ struct smb2_file_stream_info {
 	__le32  StreamNameLength;
 	__le64 StreamSize;
 	__le64 StreamAllocationSize;
-	char   StreamName[0];
+	char   StreamName[];
 } __packed;
 
 struct smb2_file_eof_info { /* encoding of request for level 10 */
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 3c1ec1ac0b27..9976d39c6ed8 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -211,7 +211,7 @@ struct smb_direct_rdma_rw_msg {
 	struct completion	*completion;
 	struct rdma_rw_ctx	rw_ctx;
 	struct sg_table		sgt;
-	struct scatterlist	sg_list[0];
+	struct scatterlist	sg_list[];
 };
 
 static inline int get_buf_page_count(void *buf, int size)
diff --git a/fs/ksmbd/xattr.h b/fs/ksmbd/xattr.h
index 8857c01093d9..16499ca5c82d 100644
--- a/fs/ksmbd/xattr.h
+++ b/fs/ksmbd/xattr.h
@@ -76,7 +76,7 @@ struct xattr_acl_entry {
 struct xattr_smb_acl {
 	int count;
 	int next;
-	struct xattr_acl_entry entries[0];
+	struct xattr_acl_entry entries[];
 };
 
 /* 64bytes hash in xattr_ntacl is computed with sha256 */
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 1719e1c4da59..3590e10e3e62 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -24,7 +24,7 @@ struct xchk_xattr_buf {
 	 * space bitmap follows immediately after; and we have a third buffer
 	 * for storing intermediate bitmap results.
 	 */
-	uint8_t			buf[0];
+	uint8_t			buf[];
 };
 
 /* A place to store attribute values. */
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 16847c8d9d5f..9ee4d1b39125 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -2319,7 +2319,7 @@ struct acpi_table_rgrt {
 	u16 version;
 	u8 image_type;
 	u8 reserved;
-	u8 image[0];
+	u8 image[];
 };
 
 /* image_type values */
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 2c68a545ffa7..fd7feb5c7894 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -180,7 +180,7 @@ struct mmu_table_batch {
 	struct rcu_head		rcu;
 #endif
 	unsigned int		nr;
-	void			*tables[0];
+	void			*tables[];
 };
 
 #define MAX_TABLE_BATCH		\
@@ -227,7 +227,7 @@ struct mmu_gather_batch {
 	struct mmu_gather_batch	*next;
 	unsigned int		nr;
 	unsigned int		max;
-	struct page		*pages[0];
+	struct page		*pages[];
 };
 
 #define MAX_GATHER_BATCH	\
diff --git a/include/linux/greybus/greybus_manifest.h b/include/linux/greybus/greybus_manifest.h
index 6e62fe478712..bef9eb2093e9 100644
--- a/include/linux/greybus/greybus_manifest.h
+++ b/include/linux/greybus/greybus_manifest.h
@@ -100,7 +100,7 @@ enum {
 struct greybus_descriptor_string {
 	__u8	length;
 	__u8	id;
-	__u8	string[0];
+	__u8	string[];
 } __packed;
 
 /*
@@ -175,7 +175,7 @@ struct greybus_manifest_header {
 
 struct greybus_manifest {
 	struct greybus_manifest_header		header;
-	struct greybus_descriptor		descriptors[0];
+	struct greybus_descriptor		descriptors[];
 } __packed;
 
 #endif /* __GREYBUS_MANIFEST_H */
diff --git a/include/linux/greybus/hd.h b/include/linux/greybus/hd.h
index d3faf0c1a569..718e2857054e 100644
--- a/include/linux/greybus/hd.h
+++ b/include/linux/greybus/hd.h
@@ -58,7 +58,7 @@ struct gb_host_device {
 
 	struct gb_svc *svc;
 	/* Private data for the host driver */
-	unsigned long hd_priv[0] __aligned(sizeof(s64));
+	unsigned long hd_priv[] __aligned(sizeof(s64));
 };
 #define to_gb_host_device(d) container_of(d, struct gb_host_device, dev)
 
diff --git a/include/linux/greybus/module.h b/include/linux/greybus/module.h
index 47b839af145d..3efe2133acfd 100644
--- a/include/linux/greybus/module.h
+++ b/include/linux/greybus/module.h
@@ -23,7 +23,7 @@ struct gb_module {
 
 	bool disconnected;
 
-	struct gb_interface *interfaces[0];
+	struct gb_interface *interfaces[];
 };
 #define to_gb_module(d) container_of(d, struct gb_module, dev)
 
diff --git a/include/linux/i3c/ccc.h b/include/linux/i3c/ccc.h
index 73b0982cc519..ad59a4ae60d1 100644
--- a/include/linux/i3c/ccc.h
+++ b/include/linux/i3c/ccc.h
@@ -132,7 +132,7 @@ struct i3c_ccc_dev_desc {
 struct i3c_ccc_defslvs {
 	u8 count;
 	struct i3c_ccc_dev_desc master;
-	struct i3c_ccc_dev_desc slaves[0];
+	struct i3c_ccc_dev_desc slaves[];
 } __packed;
 
 /**
@@ -240,7 +240,7 @@ struct i3c_ccc_bridged_slave_desc {
  */
 struct i3c_ccc_setbrgtgt {
 	u8 count;
-	struct i3c_ccc_bridged_slave_desc bslaves[0];
+	struct i3c_ccc_bridged_slave_desc bslaves[];
 } __packed;
 
 /**
@@ -318,7 +318,7 @@ enum i3c_ccc_setxtime_subcmd {
  */
 struct i3c_ccc_setxtime {
 	u8 subcmd;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define I3C_CCC_GETXTIME_SYNC_MODE	BIT(0)
diff --git a/include/linux/mlx5/mlx5_ifc_fpga.h b/include/linux/mlx5/mlx5_ifc_fpga.h
index 07d77323f78a..cac4e94abd3a 100644
--- a/include/linux/mlx5/mlx5_ifc_fpga.h
+++ b/include/linux/mlx5/mlx5_ifc_fpga.h
@@ -185,7 +185,7 @@ struct mlx5_ifc_fpga_access_reg_bits {
 
 	u8         address[0x40];
 
-	u8         data[0][0x8];
+	u8         data[][0x8];
 };
 
 enum mlx5_ifc_fpga_qp_state {
diff --git a/include/linux/platform_data/brcmfmac.h b/include/linux/platform_data/brcmfmac.h
index 2b5676ff35be..f922a192fe58 100644
--- a/include/linux/platform_data/brcmfmac.h
+++ b/include/linux/platform_data/brcmfmac.h
@@ -178,7 +178,7 @@ struct brcmfmac_platform_data {
 	void	(*power_off)(void);
 	char	*fw_alternative_path;
 	int	device_count;
-	struct brcmfmac_pd_device devices[0];
+	struct brcmfmac_pd_device devices[];
 };
 
 
diff --git a/include/linux/platform_data/cros_ec_commands.h b/include/linux/platform_data/cros_ec_commands.h
index 271bd87bff0a..728735aed980 100644
--- a/include/linux/platform_data/cros_ec_commands.h
+++ b/include/linux/platform_data/cros_ec_commands.h
@@ -5644,7 +5644,7 @@ struct ec_response_typec_discovery {
 	uint8_t svid_count;	   /* Number of SVIDs partner sent */
 	uint16_t reserved;
 	uint32_t discovery_vdo[6]; /* Max VDOs allowed after VDM header is 6 */
-	struct svid_mode_info svids[0];
+	struct svid_mode_info svids[];
 } __ec_align1;
 
 /* USB Type-C commands for AP-controlled device policy. */
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 107b25deae68..9607ec289fd0 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -696,7 +696,7 @@ struct mgmt_cp_set_blocked_keys {
 #define MGMT_READ_CONTROLLER_CAP_SIZE	0
 struct mgmt_rp_read_controller_cap {
 	__le16   cap_len;
-	__u8     cap[0];
+	__u8     cap[];
 } __packed;
 
 #define MGMT_OP_READ_EXP_FEATURES_INFO	0x0049
diff --git a/include/net/ioam6.h b/include/net/ioam6.h
index 3f45ba37a2c6..781d2d8b2f29 100644
--- a/include/net/ioam6.h
+++ b/include/net/ioam6.h
@@ -35,7 +35,7 @@ struct ioam6_schema {
 	int len;
 	__be32 hdr;
 
-	u8 data[0];
+	u8 data[];
 };
 
 struct ioam6_pernet_data {
diff --git a/include/sound/sof/channel_map.h b/include/sound/sof/channel_map.h
index fd3a30fcf756..d363f0ca6979 100644
--- a/include/sound/sof/channel_map.h
+++ b/include/sound/sof/channel_map.h
@@ -39,7 +39,7 @@ struct sof_ipc_channel_map {
 	uint32_t ext_id;
 	uint32_t ch_mask;
 	uint32_t reserved;
-	int32_t ch_coeffs[0];
+	int32_t ch_coeffs[];
 } __packed;
 
 /**
@@ -55,7 +55,7 @@ struct sof_ipc_stream_map {
 	struct sof_ipc_cmd_hdr hdr;
 	uint32_t num_ch_map;
 	uint32_t reserved[3];
-	struct sof_ipc_channel_map ch_map[0];
+	struct sof_ipc_channel_map ch_map[];
 } __packed;
 
 #endif /* __IPC_CHANNEL_MAP_H__ */
diff --git a/scripts/dtc/libfdt/fdt.h b/scripts/dtc/libfdt/fdt.h
index f2e68807f277..0c91aa7f67b5 100644
--- a/scripts/dtc/libfdt/fdt.h
+++ b/scripts/dtc/libfdt/fdt.h
@@ -35,14 +35,14 @@ struct fdt_reserve_entry {
 
 struct fdt_node_header {
 	fdt32_t tag;
-	char name[0];
+	char name[];
 };
 
 struct fdt_property {
 	fdt32_t tag;
 	fdt32_t len;
 	fdt32_t nameoff;
-	char data[0];
+	char data[];
 };
 
 #endif /* !__ASSEMBLY */
diff --git a/sound/soc/intel/atom/sst-mfld-dsp.h b/sound/soc/intel/atom/sst-mfld-dsp.h
index 8d9e29b16e57..c8f0816edb53 100644
--- a/sound/soc/intel/atom/sst-mfld-dsp.h
+++ b/sound/soc/intel/atom/sst-mfld-dsp.h
@@ -427,7 +427,7 @@ struct snd_sst_drop_response {
 
 struct snd_sst_async_msg {
 	u32 msg_id; /* Async msg id */
-	u32 payload[0];
+	u32 payload[];
 };
 
 struct snd_sst_async_err_msg {
@@ -514,7 +514,7 @@ struct snd_sst_bytes_v2 {
 	u8 pipe_id;
 	u8 rsvd;
 	u16 len;
-	char bytes[0];
+	char bytes[];
 };
 
 #define MAX_VTSV_FILES 2
diff --git a/sound/soc/intel/skylake/skl-topology.h b/sound/soc/intel/skylake/skl-topology.h
index 22963634fbea..a5bccf2fcd88 100644
--- a/sound/soc/intel/skylake/skl-topology.h
+++ b/sound/soc/intel/skylake/skl-topology.h
@@ -164,7 +164,7 @@ struct skl_base_cfg_ext {
 	u8 reserved[8];
 	u32 priv_param_length;
 	/* Input pin formats followed by output ones. */
-	struct skl_pin_format pins_fmt[0];
+	struct skl_pin_format pins_fmt[];
 } __packed;
 
 struct skl_algo_cfg {
diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 75ee385fb078..e7758707cadd 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -240,7 +240,7 @@ struct id_index_entry {
 struct perf_record_id_index {
 	struct perf_event_header header;
 	__u64			 nr;
-	struct id_index_entry	 entries[0];
+	struct id_index_entry	 entries[];
 };
 
 struct perf_record_auxtrace_info {
-- 
2.27.0

