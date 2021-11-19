Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11EF456E59
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbhKSLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbhKSLkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 06:40:15 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED24FC061574;
        Fri, 19 Nov 2021 03:37:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id i5so17695058wrb.2;
        Fri, 19 Nov 2021 03:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hkN8e1ZLr/E9Obb/Epqq8vU9VMvAAyNISm7vrsSj8AY=;
        b=QZM2oo/jcKnn1pIsVjCBj4s61xO6pH1xn3fhVvIkc9Zc7nVHxw0ivlgoIB4gMKk3IX
         9ZmCyBDIPo2eTppCriswlijccXP7jQQSDn4f6DKhyBZZgzka2RLazLQLKBdSriJQj1uH
         rES6NRRr+sWYkBGKzd15Kz8SYdrq1zsKsV95gEPbCPf1hKMurYqcqG8H6zEgSHLHPN27
         PHJ38q84mGq+O91VewzX/BBrEHnPUfv8SJyPHUFWa/XVmEuyK3KIVw6VNNWCzZm7cgeY
         4pGdAAuyR2B7wAgeoVFsydye/uN+adAy7si/LEXgLPjQyQgSgu2nVqUfavI9O4hwLI02
         bT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hkN8e1ZLr/E9Obb/Epqq8vU9VMvAAyNISm7vrsSj8AY=;
        b=qcarcX4C4cfRpzpMpgM/cddNvuzF4ij03pgXrsXkb65MH0qzTBKbVEoEItK7TbY5/W
         EuT4Fuo4ioZTpgfMzQTT5pjsxCTJ+rCccngejPIvTrVHF7+t+/MTMnm/ed3UE9A8yelo
         4xxtdnsT/X4dhhHfoHZwplPZZiWdmp/VkVLZXHPBwH/AVU0Y2TBm0iApJGw1Ex2XJvfy
         NvDDutr8P2F52TPYCJKCSb+6imHYMejXtyy/hNuxJp0rxtVCiKL7xwd7FCvGfCv6b5Eb
         xxDzMK5xYTDmcXMkl7huwmpvfJHsmBqZ3MkzBUadNWQgFwNxbPX3gGK00rMQuDLIGJgo
         LDtA==
X-Gm-Message-State: AOAM530umMAgRlAuYk11vrQxkZkovbIK30bC9RDNRfAbpO3XnKQYo0U/
        mXsQzgnzuPZl9YoVIbZ4e+kZzkvTaywFGQ==
X-Google-Smtp-Source: ABdhPJyZK0aQB+BJa7bQw9zJSpEyGYZOfMsUEbOsTPd4Rlvu1SA7AI+CGW1aYtaSFDUtCWz87QKo5A==
X-Received: by 2002:a05:6000:156a:: with SMTP id 10mr6503928wrz.87.1637321832427;
        Fri, 19 Nov 2021 03:37:12 -0800 (PST)
Received: from ady1.alejandro-colomar.es ([170.253.36.171])
        by smtp.googlemail.com with ESMTPSA id f15sm3361260wmg.30.2021.11.19.03.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 03:37:11 -0800 (PST)
From:   Alejandro Colomar <alx.manpages@gmail.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Alejandro Colomar <alx.manpages@gmail.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 02/17] Use memberof(T, m) instead of explicit NULL dereference
Date:   Fri, 19 Nov 2021 12:36:30 +0100
Message-Id: <20211119113644.1600-3-alx.manpages@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119113644.1600-1-alx.manpages@gmail.com>
References: <20211119113644.1600-1-alx.manpages@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Minyard <cminyard@mvista.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John S. Gruber <JohnSGruber@gmail.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Somnath Kotur <somnath.kotur@broadcom.com>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: <intel-gfx@lists.freedesktop.org>
Cc: <linux-acpi@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: <linux-btrfs@vger.kernel.org>
Cc: <linux-scsi@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <virtualization@lists.linux-foundation.org>
---
 arch/x86/include/asm/bootparam_utils.h  |  3 ++-
 arch/x86/kernel/signal_compat.c         |  5 +++--
 drivers/gpu/drm/i915/i915_utils.h       |  5 ++---
 drivers/gpu/drm/i915/intel_runtime_pm.h |  2 +-
 drivers/net/ethernet/emulex/benet/be.h  |  7 ++++---
 drivers/net/ethernet/i825xx/ether1.c    |  7 +++++--
 drivers/scsi/be2iscsi/be.h              |  7 ++++---
 drivers/scsi/be2iscsi/be_cmds.h         |  5 ++++-
 fs/btrfs/ctree.h                        |  5 +++--
 include/acpi/actypes.h                  |  4 +++-
 include/linux/container_of.h            |  6 +++---
 include/linux/virtio_config.h           | 14 +++++++-------
 12 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 981fe923a59f..71b28b5fb088 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_BOOTPARAM_UTILS_H
 
 #include <asm/bootparam.h>
+#include <linux/container_of.h>
 
 /*
  * This file is included from multiple environments.  Do not
@@ -19,7 +20,7 @@
  * private magic, so it is better to leave it unchanged.
  */
 
-#define sizeof_mbr(type, member) ({ sizeof(((type *)0)->member); })
+#define sizeof_mbr(type, member) ({ sizeof(memberof(type, member)); })
 
 #define BOOT_PARAM_PRESERVE(struct_member)				\
 	{								\
diff --git a/arch/x86/kernel/signal_compat.c b/arch/x86/kernel/signal_compat.c
index b52407c56000..28420a7df056 100644
--- a/arch/x86/kernel/signal_compat.c
+++ b/arch/x86/kernel/signal_compat.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/compat.h>
+#include <linux/container_of.h>
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
 
@@ -69,8 +70,8 @@ static inline void signal_compat_build_tests(void)
 	 * structure stays within the padding size (checked
 	 * above).
 	 */
-#define CHECK_CSI_SIZE(name, size) BUILD_BUG_ON(size != sizeof(((compat_siginfo_t *)0)->_sifields.name))
-#define CHECK_SI_SIZE(name, size) BUILD_BUG_ON(size != sizeof(((siginfo_t *)0)->_sifields.name))
+#define CHECK_CSI_SIZE(name, size) BUILD_BUG_ON(size != sizeof(memberof(compat_siginfo_t ,_sifields.name)))
+#define CHECK_SI_SIZE(name, size)  BUILD_BUG_ON(size != sizeof(memberof(siginfo_t, _sifields.name)))
 
 	CHECK_CSI_OFFSET(_kill);
 	CHECK_CSI_SIZE  (_kill, 2*sizeof(int));
diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 7a5925072466..2e3ec28f4f1b 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -25,6 +25,7 @@
 #ifndef __I915_UTILS_H
 #define __I915_UTILS_H
 
+#include <linux/container_of.h>
 #include <linux/list.h>
 #include <linux/overflow.h>
 #include <linux/sched.h>
@@ -192,8 +193,6 @@ __check_struct_size(size_t base, size_t arr, size_t count, size_t *size)
 #define page_pack_bits(ptr, bits) ptr_pack_bits(ptr, bits, PAGE_SHIFT)
 #define page_unpack_bits(ptr, bits) ptr_unpack_bits(ptr, bits, PAGE_SHIFT)
 
-#define struct_member(T, member) (((T *)0)->member)
-
 #define ptr_offset(ptr, member) offsetof(typeof(*(ptr)), member)
 
 #define fetch_and_zero(ptr) ({						\
@@ -215,7 +214,7 @@ static __always_inline ptrdiff_t ptrdiff(const void *a, const void *b)
  */
 #define container_of_user(ptr, type, member) ({				\
 	void __user *__mptr = (void __user *)(ptr);			\
-	BUILD_BUG_ON_MSG(!__same_type(*(ptr), struct_member(type, member)) && \
+	BUILD_BUG_ON_MSG(!__same_type(*(ptr), memberof(type, member)) && \
 			 !__same_type(*(ptr), void),			\
 			 "pointer type mismatch in container_of()");	\
 	((type __user *)(__mptr - offsetof(type, member))); })
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.h b/drivers/gpu/drm/i915/intel_runtime_pm.h
index 47a85fab4130..6cb04bef62ad 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.h
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.h
@@ -73,7 +73,7 @@ struct intel_runtime_pm {
 };
 
 #define BITS_PER_WAKEREF	\
-	BITS_PER_TYPE(struct_member(struct intel_runtime_pm, wakeref_count))
+	BITS_PER_TYPE(memberof(struct intel_runtime_pm, wakeref_count))
 #define INTEL_RPM_WAKELOCK_SHIFT	(BITS_PER_WAKEREF / 2)
 #define INTEL_RPM_WAKELOCK_BIAS		(1 << INTEL_RPM_WAKELOCK_SHIFT)
 #define INTEL_RPM_RAW_WAKEREF_MASK	(INTEL_RPM_WAKELOCK_BIAS - 1)
diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index 8689d4a51fe5..dc790bae2451 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -14,6 +14,7 @@
 #ifndef BE_H
 #define BE_H
 
+#include <linux/container_of.h>
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
@@ -824,7 +825,7 @@ extern const struct ethtool_ops be_ethtool_ops;
 
 /* Returns bit offset within a DWORD of a bitfield */
 #define AMAP_BIT_OFFSET(_struct, field)  				\
-		(((size_t)&(((_struct *)0)->field))%32)
+		(((size_t)&(memberof(_struct, field)))%32)
 
 /* Returns the bit mask of the field that is NOT shifted into location. */
 static inline u32 amap_mask(u32 bitsize)
@@ -843,7 +844,7 @@ amap_set(void *ptr, u32 dw_offset, u32 mask, u32 offset, u32 value)
 #define AMAP_SET_BITS(_struct, field, ptr, val)				\
 		amap_set(ptr,						\
 			offsetof(_struct, field)/32,			\
-			amap_mask(sizeof(((_struct *)0)->field)),	\
+			amap_mask(sizeof(memberof(_struct, field))),	\
 			AMAP_BIT_OFFSET(_struct, field),		\
 			val)
 
@@ -856,7 +857,7 @@ static inline u32 amap_get(void *ptr, u32 dw_offset, u32 mask, u32 offset)
 #define AMAP_GET_BITS(_struct, field, ptr)				\
 		amap_get(ptr,						\
 			offsetof(_struct, field)/32,			\
-			amap_mask(sizeof(((_struct *)0)->field)),	\
+			amap_mask(sizeof(memberof(_struct, field))),	\
 			AMAP_BIT_OFFSET(_struct, field))
 
 #define GET_RX_COMPL_V0_BITS(field, ptr)				\
diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index c612ef526d16..4dece3476d31 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -28,6 +28,7 @@
  * 1.07	RMK	13/05/2000	Updated for 2.3.99-pre8
  */
 
+#include <linux/containerof.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -80,8 +81,10 @@ static char version[] = "ether1 ethernet driver (c) 2000 Russell King v1.07\n";
 #define DISABLEIRQS 1
 #define NORMALIRQS  0
 
-#define ether1_readw(dev, addr, type, offset, svflgs) ether1_inw_p (dev, addr + (int)(&((type *)0)->offset), svflgs)
-#define ether1_writew(dev, val, addr, type, offset, svflgs) ether1_outw_p (dev, val, addr + (int)(&((type *)0)->offset), svflgs)
+#define ether1_readw(dev, addr, type, offset, svflgs) \
+	ether1_inw_p(dev, addr + (int)(&(memberof(type, offset))), svflgs)
+#define ether1_writew(dev, val, addr, type, offset, svflgs) \
+	ether1_outw_p(dev, val, addr + (int)(&(memberof(type, offset))), svflgs)
 
 static inline unsigned short
 ether1_inw_p (struct net_device *dev, int addr, int svflgs)
diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 4c58a02590c7..6830e07fd37a 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -10,6 +10,7 @@
 #ifndef BEISCSI_H
 #define BEISCSI_H
 
+#include <linux/container_of.h>
 #include <linux/pci.h>
 #include <linux/if_vlan.h>
 #include <linux/irq_poll.h>
@@ -153,7 +154,7 @@ struct be_ctrl_info {
 
 /* Returns bit offset within a DWORD of a bitfield */
 #define AMAP_BIT_OFFSET(_struct, field)					\
-		(((size_t)&(((_struct *)0)->field))%32)
+		(((size_t)&(memberof(_struct, field)))%32)
 
 /* Returns the bit mask of the field that is NOT shifted into location. */
 static inline u32 amap_mask(u32 bitsize)
@@ -172,7 +173,7 @@ static inline void amap_set(void *ptr, u32 dw_offset, u32 mask,
 #define AMAP_SET_BITS(_struct, field, ptr, val)				\
 		amap_set(ptr,						\
 			offsetof(_struct, field)/32,			\
-			amap_mask(sizeof(((_struct *)0)->field)),	\
+			amap_mask(sizeof(memberof(_struct, field))),	\
 			AMAP_BIT_OFFSET(_struct, field),		\
 			val)
 
@@ -185,7 +186,7 @@ static inline u32 amap_get(void *ptr, u32 dw_offset, u32 mask, u32 offset)
 #define AMAP_GET_BITS(_struct, field, ptr)				\
 		amap_get(ptr,						\
 			offsetof(_struct, field)/32,			\
-			amap_mask(sizeof(((_struct *)0)->field)),	\
+			amap_mask(sizeof(memberof(_struct, field))),	\
 			AMAP_BIT_OFFSET(_struct, field))
 
 #define be_dws_cpu_to_le(wrb, len) swap_dws(wrb, len)
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 5f9f0b18ddf3..bb6ee43769d5 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -10,6 +10,9 @@
 #ifndef BEISCSI_CMDS_H
 #define BEISCSI_CMDS_H
 
+
+#include <linux/container_of.h>
+
 /**
  * The driver sends configuration and managements command requests to the
  * firmware in the BE. These requests are communicated to the processor
@@ -1300,7 +1303,7 @@ struct be_cmd_get_port_name {
 
 /* Returns the number of items in the field array. */
 #define BE_NUMBER_OF_FIELD(_type_, _field_)	\
-	(sizeof_field(_type_, _field_)/sizeof((((_type_ *)0)->_field_[0])))\
+	(sizeof_field(_type_, _field_) / sizeof(memberof(_type_, _field_[0])))
 
 /**
  * Different types of iSCSI completions to host driver for both initiator
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7553e9dc5f93..442b6f937b22 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -6,6 +6,7 @@
 #ifndef BTRFS_CTREE_H
 #define BTRFS_CTREE_H
 
+#include <linux/container_of.h>
 #include <linux/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/highmem.h>
@@ -1575,13 +1576,13 @@ static inline void put_unaligned_le8(u8 val, void *p)
 	read_extent_buffer(eb, (char *)(result),			\
 			   ((unsigned long)(ptr)) +			\
 			    offsetof(type, member),			\
-			   sizeof(((type *)0)->member)))
+			   sizeof(memberof(type, member))))
 
 #define write_eb_member(eb, ptr, type, member, result) (\
 	write_extent_buffer(eb, (char *)(result),			\
 			   ((unsigned long)(ptr)) +			\
 			    offsetof(type, member),			\
-			   sizeof(((type *)0)->member)))
+			   sizeof(memberof(type, member))))
 
 #define DECLARE_BTRFS_SETGET_BITS(bits)					\
 u##bits btrfs_get_token_##bits(struct btrfs_map_token *token,		\
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index ff8b3c913f21..c3b0eccb3377 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -10,6 +10,8 @@
 #ifndef __ACTYPES_H__
 #define __ACTYPES_H__
 
+#include <linux/container_of.h>
+
 /* acpisrc:struct_defs -- for acpisrc conversion */
 
 /*
@@ -508,7 +510,7 @@ typedef u64 acpi_integer;
 
 #define ACPI_TO_POINTER(i)              ACPI_CAST_PTR (void, (acpi_size) (i))
 #define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) 0)
-#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
+#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(memberof(d, f)), (void *) 0)
 #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
 #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
 
diff --git a/include/linux/container_of.h b/include/linux/container_of.h
index 199c78a3bf29..227418cb8c99 100644
--- a/include/linux/container_of.h
+++ b/include/linux/container_of.h
@@ -8,7 +8,7 @@
 
 #define memberof(T, m)   (((T *) NULL)->m)
 
-#define typeof_member(T, m)	typeof(((T*)0)->m)
+#define typeof_member(T, m)	typeof(memberof(T, m))
 
 /**
  * container_of - cast a member of a structure out to the containing structure
@@ -19,7 +19,7 @@
  */
 #define container_of(ptr, type, member) ({				\
 	void *__mptr = (void *)(ptr);					\
-	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
+	static_assert(__same_type(*(ptr), memberof(type, member)) ||	\
 		      __same_type(*(ptr), void),			\
 		      "pointer type mismatch in container_of()");	\
 	((type *)(__mptr - offsetof(type, member))); })
@@ -34,7 +34,7 @@
  */
 #define container_of_safe(ptr, type, member) ({				\
 	void *__mptr = (void *)(ptr);					\
-	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
+	static_assert(__same_type(*(ptr), memberof(type, member)) ||	\
 		      __same_type(*(ptr), void),			\
 		      "pointer type mismatch in container_of_safe()");	\
 	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 4d107ad31149..a1e656c0d94a 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -328,12 +328,12 @@ static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
 		)
 
 #define __virtio_native_type(structname, member) \
-	typeof(virtio_to_cpu(NULL, ((structname*)0)->member))
+	typeof(virtio_to_cpu(NULL, memberof(structname, member)))
 
 /* Config space accessors. */
 #define virtio_cread(vdev, structname, member, ptr)			\
 	do {								\
-		typeof(((structname*)0)->member) virtio_cread_v;	\
+		typeof(memberof(structname, member)) virtio_cread_v;	\
 									\
 		might_sleep();						\
 		/* Sanity check: must match the member's type */	\
@@ -362,8 +362,8 @@ static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
 /* Config space accessors. */
 #define virtio_cwrite(vdev, structname, member, ptr)			\
 	do {								\
-		typeof(((structname*)0)->member) virtio_cwrite_v =	\
-			cpu_to_virtio(vdev, *(ptr), ((structname*)0)->member); \
+		typeof(memberof(structname, member)) virtio_cwrite_v =	\
+			cpu_to_virtio(vdev, *(ptr), memberof(structname, member)); \
 									\
 		might_sleep();						\
 		/* Sanity check: must match the member's type */	\
@@ -397,7 +397,7 @@ static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
 /* LE (e.g. modern) Config space accessors. */
 #define virtio_cread_le(vdev, structname, member, ptr)			\
 	do {								\
-		typeof(((structname*)0)->member) virtio_cread_v;	\
+		typeof(memberof(structname, member)) virtio_cread_v;	\
 									\
 		might_sleep();						\
 		/* Sanity check: must match the member's type */	\
@@ -425,8 +425,8 @@ static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
 
 #define virtio_cwrite_le(vdev, structname, member, ptr)			\
 	do {								\
-		typeof(((structname*)0)->member) virtio_cwrite_v =	\
-			virtio_cpu_to_le(*(ptr), ((structname*)0)->member); \
+		typeof(memberof(structname, member)) virtio_cwrite_v =	\
+			virtio_cpu_to_le(*(ptr), memberof(structname, member)); \
 									\
 		might_sleep();						\
 		/* Sanity check: must match the member's type */	\
-- 
2.33.1

