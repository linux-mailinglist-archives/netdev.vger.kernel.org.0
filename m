Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83702912F1
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438647AbgJQQKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 12:10:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438660AbgJQQJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 12:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602950987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=PcObn7U1uXJZxW99CZjaXSkG6ko9pf2ze/ufhCTWJEY=;
        b=IahXQr9nyMS2vZSKThHMOKu2Wqidl9f86nLB4geMQWvrK1AJE+FTiyp1BJccfqvrjT9e3n
        1ow48R6BRWsh8zEbXimoLoRr7NsmuHmXTE3/XfAlhXUunsqucU/pudCFqA7zqll4qv01Qp
        zvFv0oRjazTp4relxUG4pBmXjKt9jrw=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-zY3fmG7mMsulAa6rRzEH-Q-1; Sat, 17 Oct 2020 12:09:41 -0400
X-MC-Unique: zY3fmG7mMsulAa6rRzEH-Q-1
Received: by mail-ot1-f72.google.com with SMTP id l8so2521520ots.22
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 09:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PcObn7U1uXJZxW99CZjaXSkG6ko9pf2ze/ufhCTWJEY=;
        b=I/eYli3Q5LIBCNmHPD0YCLLQxM0jv2T2+J3zbYQ/a9yf+kqYu8JpqD2Hk0ZQvBygXQ
         Lo5hsQYabnQ16KQ5HUZgKNX5HSq74C+VWdrD9+rAo/LBxdSGwRuNaUqa0on10vXqZg0I
         5sXtRWhoQedpsqPfh/zIuVZ1Dml8kSrGYvJaK0lzGbFbVjOqzlIbT22KRtQ3jVhad4u5
         ly/vmZqq/nPSWc2Iktp8poAJC1NYgsKP6yj/6Ew69yKDjeuU0HNMy0p7MeJ6Wo3rqs2N
         PI53nP7mpmllYfhW5R0uMd+TyZvhNEU4PWIQ2CLtrbyNSHhkNSoAXOg8xzQXwnAQOQz7
         Tb6g==
X-Gm-Message-State: AOAM532ZmnG+oEZyv+PIRFi91K9ZFfRC7k/yuYwLVkxIPlBXocVzh8Hx
        Yd9BO0+fr31V2b3rtZ5wSoHA5TXKtELR158cw1sq2qutDBB6UPLIrrb2WBEf+1V+4YsJYOqt2EI
        8t9xf3OZOov79ouRa
X-Received: by 2002:aca:cc01:: with SMTP id c1mr6215351oig.128.1602950978329;
        Sat, 17 Oct 2020 09:09:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPVzYK6gQsv5rjCfQ+MiyXlzTmsz5jTt6tATUCcXIJGoCXwjQmkLM2KtSlBhQxb9aFkWsozg==
X-Received: by 2002:aca:cc01:: with SMTP id c1mr6215304oig.128.1602950977353;
        Sat, 17 Oct 2020 09:09:37 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id o2sm1980029oia.42.2020.10.17.09.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 09:09:36 -0700 (PDT)
From:   trix@redhat.com
To:     linux-kernel@vger.kernel.org
Cc:     linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-power@fi.rohmeurope.com, linux-gpio@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, linux-iio@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-nfc@lists.01.org,
        linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, patches@opensource.cirrus.com,
        storagedev@microchip.com, devel@driverdev.osuosl.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        linux-watchdog@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        bpf@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        alsa-devel@alsa-project.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [RFC] treewide: cleanup unreachable breaks
Date:   Sat, 17 Oct 2020 09:09:28 -0700
Message-Id: <20201017160928.12698-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This is a upcoming change to clean up a new warning treewide.
I am wondering if the change could be one mega patch (see below) or
normal patch per file about 100 patches or somewhere half way by collecting
early acks.

clang has a number of useful, new warnings see
https://clang.llvm.org/docs/DiagnosticsReference.html

This change cleans up -Wunreachable-code-break
https://clang.llvm.org/docs/DiagnosticsReference.html#wunreachable-code-break
for 266 of 485 warnings in this week's linux-next, allyesconfig on x86_64.

The method of fixing was to look for warnings where the preceding statement
was a simple statement and by inspection made the subsequent break unneeded.
In order of frequency these look like

return and break

 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
 		return 1;
-		break;

goto and break

 	default:
 		operation = 0; /* make gcc happy */
 		goto fail_response;
-		break;

break and break
 		case COLOR_SPACE_SRGB:
 			/* by pass */
 			REG_SET(OUTPUT_CSC_CONTROL, 0,
 				OUTPUT_CSC_GRPH_MODE, 0);
 			break;
-			break;

The exception to the simple statement, is a switch case with a block
and the end of block is a return

 			struct obj_buffer *buff = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"size=%u\naddr=0x%X\n", buff->size,
 					buff->addr);
 		}
-		break;

Not considered obvious and excluded, breaks after
multi level switches
complicated if-else if-else blocks
panic() or similar calls

And there is an odd addition of a 'fallthrough' in drivers/tty/nozomi.c

Tom

---

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 1c08cb9eb9f6..16ce86aed8e2 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1809,15 +1809,13 @@ static int __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
 		return 1;
-		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
 		return 1;
-		break;
 	default:
 		return 0;
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 3f6b137ef4e6..3d4a48336084 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -213,11 +213,10 @@ static unsigned int __verify_patch_size(u8 family, u32 sh_psize, size_t buf_size
 		max_size = F14H_MPB_MAX_SIZE;
 		break;
 	default:
 		WARN(1, "%s: WTF family: 0x%x\n", __func__, family);
 		return 0;
-		break;
 	}
 
 	if (sh_psize > min_t(u32, buf_size, max_size))
 		return 0;
 
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 838b719ec7ce..d5411a166685 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -102,11 +102,10 @@ acpi_extract_package(union acpi_object *package,
 				printk(KERN_WARNING PREFIX "Invalid package element"
 					      " [%d]: got number, expecting"
 					      " [%c]\n",
 					      i, format_string[i]);
 				return AE_BAD_DATA;
-				break;
 			}
 			break;
 
 		case ACPI_TYPE_STRING:
 		case ACPI_TYPE_BUFFER:
@@ -127,11 +126,10 @@ acpi_extract_package(union acpi_object *package,
 				printk(KERN_WARNING PREFIX "Invalid package element"
 					      " [%d] got string/buffer,"
 					      " expecting [%c]\n",
 					      i, format_string[i]);
 				return AE_BAD_DATA;
-				break;
 			}
 			break;
 		case ACPI_TYPE_LOCAL_REFERENCE:
 			switch (format_string[i]) {
 			case 'R':
@@ -142,22 +140,20 @@ acpi_extract_package(union acpi_object *package,
 				printk(KERN_WARNING PREFIX "Invalid package element"
 					      " [%d] got reference,"
 					      " expecting [%c]\n",
 					      i, format_string[i]);
 				return AE_BAD_DATA;
-				break;
 			}
 			break;
 
 		case ACPI_TYPE_PACKAGE:
 		default:
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "Found unsupported element at index=%d\n",
 					  i));
 			/* TBD: handle nested packages... */
 			return AE_SUPPORT;
-			break;
 		}
 	}
 
 	/*
 	 * Validate output buffer.
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 205a06752ca9..c7ac49042cee 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -361,11 +361,10 @@ static pm_callback_t pm_op(const struct dev_pm_ops *ops, pm_message_t state)
 	case PM_EVENT_HIBERNATE:
 		return ops->poweroff;
 	case PM_EVENT_THAW:
 	case PM_EVENT_RECOVER:
 		return ops->thaw;
-		break;
 	case PM_EVENT_RESTORE:
 		return ops->restore;
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 	}
 
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index adfc9352351d..f769fbd1b4c4 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1267,11 +1267,10 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 		operation_flags = REQ_PREFLUSH;
 		break;
 	default:
 		operation = 0; /* make gcc happy */
 		goto fail_response;
-		break;
 	}
 
 	/* Check that the number of segments is sane. */
 	nseg = req->operation == BLKIF_OP_INDIRECT ?
 	       req->u.indirect.nr_segments : req->u.rw.nr_segments;
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index f7b1c004a12b..3dd1d5abb298 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -488,11 +488,10 @@ static long ipmi_ioctl(struct file   *file,
 			rv = -EFAULT;
 			break;
 		}
 
 		return ipmi_set_my_address(priv->user, val.channel, val.value);
-		break;
 	}
 
 	case IPMICTL_GET_MY_CHANNEL_ADDRESS_CMD:
 	{
 		struct ipmi_channel_lun_address_set val;
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 0ec73917d8dd..862c2fd933c7 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -620,11 +620,10 @@ static int lp_do_ioctl(unsigned int minor, unsigned int cmd,
 		case LPWAIT:
 			LP_WAIT(minor) = arg;
 			break;
 		case LPSETIRQ:
 			return -EINVAL;
-			break;
 		case LPGETIRQ:
 			if (copy_to_user(argp, &LP_IRQ(minor),
 					sizeof(int)))
 				return -EFAULT;
 			break;
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index e43c876a9223..11272d605ecd 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -401,11 +401,10 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 		}
 			break;
 	
 		default:
 			return -ENOTTY;
-			break;
 	} /* switch */
 
 	PRINTK_2(TRACE_MWAVE, "mwavedd::mwave_ioctl, exit retval %x\n", retval);
 
 	return retval;
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 75ccf41a7cb9..0eb6f54e3b66 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -457,11 +457,10 @@ static int atmel_sha_init(struct ahash_request *req)
 		ctx->flags |= SHA_FLAGS_SHA512;
 		ctx->block_size = SHA512_BLOCK_SIZE;
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	ctx->bufcnt = 0;
 	ctx->digcnt[0] = 0;
 	ctx->digcnt[1] = 0;
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index fcc08bbf6945..386a3a4cf279 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2459,38 +2459,30 @@ static int map_err_sym_to_channel(int err_sym, int sym_size)
 	if (sym_size == 4)
 		switch (err_sym) {
 		case 0x20:
 		case 0x21:
 			return 0;
-			break;
 		case 0x22:
 		case 0x23:
 			return 1;
-			break;
 		default:
 			return err_sym >> 4;
-			break;
 		}
 	/* x8 symbols */
 	else
 		switch (err_sym) {
 		/* imaginary bits not in a DIMM */
 		case 0x10:
 			WARN(1, KERN_ERR "Invalid error symbol: 0x%x\n",
 					  err_sym);
 			return -1;
-			break;
-
 		case 0x11:
 			return 0;
-			break;
 		case 0x12:
 			return 1;
-			break;
 		default:
 			return err_sym >> 3;
-			break;
 		}
 	return -1;
 }
 
 static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
diff --git a/drivers/gpio/gpio-bd70528.c b/drivers/gpio/gpio-bd70528.c
index 45b3da8da336..931e5765fe92 100644
--- a/drivers/gpio/gpio-bd70528.c
+++ b/drivers/gpio/gpio-bd70528.c
@@ -69,21 +69,18 @@ static int bd70528_gpio_set_config(struct gpio_chip *chip, unsigned int offset,
 	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
 		return regmap_update_bits(bdgpio->chip.regmap,
 					  GPIO_OUT_REG(offset),
 					  BD70528_GPIO_DRIVE_MASK,
 					  BD70528_GPIO_OPEN_DRAIN);
-		break;
 	case PIN_CONFIG_DRIVE_PUSH_PULL:
 		return regmap_update_bits(bdgpio->chip.regmap,
 					  GPIO_OUT_REG(offset),
 					  BD70528_GPIO_DRIVE_MASK,
 					  BD70528_GPIO_PUSH_PULL);
-		break;
 	case PIN_CONFIG_INPUT_DEBOUNCE:
 		return bd70528_set_debounce(bdgpio, offset,
 					    pinconf_to_config_argument(config));
-		break;
 	default:
 		break;
 	}
 	return -ENOTSUPP;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
index 2a32b66959ba..130a0a0c8332 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -1328,11 +1328,10 @@ static bool configure_graphics_mode(
 		case COLOR_SPACE_SRGB:
 			/* by pass */
 			REG_SET(OUTPUT_CSC_CONTROL, 0,
 				OUTPUT_CSC_GRPH_MODE, 0);
 			break;
-			break;
 		case COLOR_SPACE_SRGB_LIMITED:
 			/* TV RGB */
 			REG_SET(OUTPUT_CSC_CONTROL, 0,
 				OUTPUT_CSC_GRPH_MODE, 1);
 			break;
diff --git a/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c b/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c
index d741787f75dc..42c7d157da32 100644
--- a/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce100/dce100_resource.c
@@ -416,29 +416,22 @@ static int map_transmitter_id_to_phy_instance(
 	enum transmitter transmitter)
 {
 	switch (transmitter) {
 	case TRANSMITTER_UNIPHY_A:
 		return 0;
-	break;
 	case TRANSMITTER_UNIPHY_B:
 		return 1;
-	break;
 	case TRANSMITTER_UNIPHY_C:
 		return 2;
-	break;
 	case TRANSMITTER_UNIPHY_D:
 		return 3;
-	break;
 	case TRANSMITTER_UNIPHY_E:
 		return 4;
-	break;
 	case TRANSMITTER_UNIPHY_F:
 		return 5;
-	break;
 	case TRANSMITTER_UNIPHY_G:
 		return 6;
-	break;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_resource.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_resource.c
index 2bbfa2e176a9..382581c4a674 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_resource.c
@@ -469,29 +469,22 @@ static int map_transmitter_id_to_phy_instance(
 	enum transmitter transmitter)
 {
 	switch (transmitter) {
 	case TRANSMITTER_UNIPHY_A:
 		return 0;
-	break;
 	case TRANSMITTER_UNIPHY_B:
 		return 1;
-	break;
 	case TRANSMITTER_UNIPHY_C:
 		return 2;
-	break;
 	case TRANSMITTER_UNIPHY_D:
 		return 3;
-	break;
 	case TRANSMITTER_UNIPHY_E:
 		return 4;
-	break;
 	case TRANSMITTER_UNIPHY_F:
 		return 5;
-	break;
 	case TRANSMITTER_UNIPHY_G:
 		return 6;
-	break;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
index b622b4b1dac3..7b4b2304bbff 100644
--- a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
@@ -444,29 +444,22 @@ static int map_transmitter_id_to_phy_instance(
 	enum transmitter transmitter)
 {
 	switch (transmitter) {
 	case TRANSMITTER_UNIPHY_A:
 		return 0;
-	break;
 	case TRANSMITTER_UNIPHY_B:
 		return 1;
-	break;
 	case TRANSMITTER_UNIPHY_C:
 		return 2;
-	break;
 	case TRANSMITTER_UNIPHY_D:
 		return 3;
-	break;
 	case TRANSMITTER_UNIPHY_E:
 		return 4;
-	break;
 	case TRANSMITTER_UNIPHY_F:
 		return 5;
-	break;
 	case TRANSMITTER_UNIPHY_G:
 		return 6;
-	break;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
index 16fe7344702f..3d782b7c86cb 100644
--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -381,29 +381,22 @@ static int map_transmitter_id_to_phy_instance(
 	enum transmitter transmitter)
 {
 	switch (transmitter) {
 	case TRANSMITTER_UNIPHY_A:
 		return 0;
-	break;
 	case TRANSMITTER_UNIPHY_B:
 		return 1;
-	break;
 	case TRANSMITTER_UNIPHY_C:
 		return 2;
-	break;
 	case TRANSMITTER_UNIPHY_D:
 		return 3;
-	break;
 	case TRANSMITTER_UNIPHY_E:
 		return 4;
-	break;
 	case TRANSMITTER_UNIPHY_F:
 		return 5;
-	break;
 	case TRANSMITTER_UNIPHY_G:
 		return 6;
-	break;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index 5a5a9cb77acb..e9dd78c484d6 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -451,29 +451,22 @@ static int map_transmitter_id_to_phy_instance(
 	enum transmitter transmitter)
 {
 	switch (transmitter) {
 	case TRANSMITTER_UNIPHY_A:
 		return 0;
-	break;
 	case TRANSMITTER_UNIPHY_B:
 		return 1;
-	break;
 	case TRANSMITTER_UNIPHY_C:
 		return 2;
-	break;
 	case TRANSMITTER_UNIPHY_D:
 		return 3;
-	break;
 	case TRANSMITTER_UNIPHY_E:
 		return 4;
-	break;
 	case TRANSMITTER_UNIPHY_F:
 		return 5;
-	break;
 	case TRANSMITTER_UNIPHY_G:
 		return 6;
-	break;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
index 0eae8cd35f9a..9dbf658162cd 100644
--- a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
@@ -456,29 +456,22 @@ static int map_transmitter_id_to_phy_instance(
 	enum transmitter transmitter)
 {
 	switch (transmitter) {
 	case TRANSMITTER_UNIPHY_A:
 		return 0;
-	break;
 	case TRANSMITTER_UNIPHY_B:
 		return 1;
-	break;
 	case TRANSMITTER_UNIPHY_C:
 		return 2;
-	break;
 	case TRANSMITTER_UNIPHY_D:
 		return 3;
-	break;
 	case TRANSMITTER_UNIPHY_E:
 		return 4;
-	break;
 	case TRANSMITTER_UNIPHY_F:
 		return 5;
-	break;
 	case TRANSMITTER_UNIPHY_G:
 		return 6;
-	break;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 38672f9e5c4f..bbe4e60dfd08 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -792,25 +792,20 @@ static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 	case G200_AGP:
 		return mgag200_g200_set_plls(mdev, clock);
 	case G200_SE_A:
 	case G200_SE_B:
 		return mga_g200se_set_plls(mdev, clock);
-		break;
 	case G200_WB:
 	case G200_EW3:
 		return mga_g200wb_set_plls(mdev, clock);
-		break;
 	case G200_EV:
 		return mga_g200ev_set_plls(mdev, clock);
-		break;
 	case G200_EH:
 	case G200_EH3:
 		return mga_g200eh_set_plls(mdev, clock);
-		break;
 	case G200_ER:
 		return mga_g200er_set_plls(mdev, clock);
-		break;
 	}
 
 	misc = RREG8(MGA_MISC_IN);
 	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
 	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/pll.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/pll.c
index 350f10a3de37..2ec84b8a3b3a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/pll.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/pll.c
@@ -121,11 +121,10 @@ pll_map(struct nvkm_bios *bios)
 	case NV_10:
 	case NV_11:
 	case NV_20:
 	case NV_30:
 		return nv04_pll_mapping;
-		break;
 	case NV_40:
 		return nv40_pll_mapping;
 	case NV_50:
 		if (device->chipset == 0x50)
 			return nv50_pll_mapping;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/mcp77.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/mcp77.c
index efa50274df97..4884eb4a9221 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/mcp77.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/mcp77.c
@@ -138,21 +138,18 @@ mcp77_clk_read(struct nvkm_clk *base, enum nv_clk_src src)
 		case 0x00000030: return read_pll(clk, 0x004020) >> P;
 		}
 		break;
 	case nv_clk_src_mem:
 		return 0;
-		break;
 	case nv_clk_src_vdec:
 		P = (read_div(clk) & 0x00000700) >> 8;
 
 		switch (mast & 0x00400000) {
 		case 0x00400000:
 			return nvkm_clk_read(&clk->base, nv_clk_src_core) >> P;
-			break;
 		default:
 			return 500000 >> P;
-			break;
 		}
 		break;
 	default:
 		break;
 	}
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv50.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv50.c
index 2ccb4b6be153..7b1eb44ff3da 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv50.c
@@ -169,11 +169,10 @@ nv50_ram_timing_read(struct nv50_ram *ram, u32 *timing)
 	case NVKM_RAM_TYPE_GDDR3:
 		T(CWL) = ((timing[2] & 0xff000000) >> 24) + 1;
 		break;
 	default:
 		return -ENOSYS;
-		break;
 	}
 
 	T(WR) = ((timing[1] >> 24) & 0xff) - 1 - T(CWL);
 
 	return 0;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/top/gk104.c b/drivers/gpu/drm/nouveau/nvkm/subdev/top/gk104.c
index e01746ce9fc4..1156634533f9 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/top/gk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/top/gk104.c
@@ -88,11 +88,10 @@ gk104_top_oneinit(struct nvkm_top *top)
 		case 0x0000000e: B_(NVENC ); break;
 		case 0x0000000f: A_(NVENC1); break;
 		case 0x00000010: B_(NVDEC ); break;
 		case 0x00000013: B_(CE    ); break;
 		case 0x00000014: C_(GSP   ); break;
-			break;
 		default:
 			break;
 		}
 
 		nvkm_debug(subdev, "%02x.%d (%8s): addr %06x fault %2d "
diff --git a/drivers/gpu/drm/qxl/qxl_ioctl.c b/drivers/gpu/drm/qxl/qxl_ioctl.c
index 5cea6eea72ab..2072ddc9549c 100644
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -158,11 +158,10 @@ static int qxl_process_single_command(struct qxl_device *qdev,
 	case QXL_CMD_SURFACE:
 	case QXL_CMD_CURSOR:
 	default:
 		DRM_DEBUG("Only draw commands in execbuffers\n");
 		return -EINVAL;
-		break;
 	}
 
 	if (cmd->command_size > PAGE_SIZE - sizeof(union qxl_release_info))
 		return -EINVAL;
 
diff --git a/drivers/iio/adc/meson_saradc.c b/drivers/iio/adc/meson_saradc.c
index e03988698755..66dc452d643a 100644
--- a/drivers/iio/adc/meson_saradc.c
+++ b/drivers/iio/adc/meson_saradc.c
@@ -591,17 +591,15 @@ static int meson_sar_adc_iio_info_read_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		return meson_sar_adc_get_sample(indio_dev, chan, NO_AVERAGING,
 						ONE_SAMPLE, val);
-		break;
 
 	case IIO_CHAN_INFO_AVERAGE_RAW:
 		return meson_sar_adc_get_sample(indio_dev, chan,
 						MEAN_AVERAGING, EIGHT_SAMPLES,
 						val);
-		break;
 
 	case IIO_CHAN_INFO_SCALE:
 		if (chan->type == IIO_VOLTAGE) {
 			ret = regulator_get_voltage(priv->vref);
 			if (ret < 0) {
diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index 222ebb26f013..431076dc0d2c 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -484,11 +484,10 @@ static int bmi160_write_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_SCALE:
 		return bmi160_set_scale(data,
 					bmi160_to_sensor(chan->type), val2);
-		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		return bmi160_set_odr(data, bmi160_to_sensor(chan->type),
 				      val, val2);
 	default:
 		return -EINVAL;
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index d480a514c983..3940714e4397 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -542,11 +542,10 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 		mr1 |= MR1_RxRTS_CONTROL_OFF;
 		mr2 |= MR2_TxRTS_CONTROL_ON | MR2_CTS_ENABLE_TX_OFF;
 		break;
 	default:
 		return;
-		break;
 	}
 
 	baud = tty_get_baud_rate(tty);
 	tty_termios_encode_baud_rate(&tty->termios, baud, baud);
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 237b9d04c076..37b32d9b398d 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2323,11 +2323,10 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 		/* No parameters */
 		break;
 
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	/* Write command */
 	rc = drxj_dap_write_reg16(dev_addr, SIO_HI_RA_RAM_CMD__A, cmd->cmd, 0);
 	if (rc != 0) {
@@ -3592,11 +3591,10 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 				goto rw_error;
 			}
 			break;
 		default:
 			return -EINVAL;
-			break;
 		}		/* switch ( uio_cfg->mode ) */
 		break;
       /*====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: GPIO UIO-3 */
@@ -3616,11 +3614,10 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 				goto rw_error;
 			}
 			break;
 		default:
 			return -EINVAL;
-			break;
 		}		/* switch ( uio_cfg->mode ) */
 		break;
       /*====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
@@ -3640,11 +3637,10 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 			ext_attr->uio_irqn_mode = uio_cfg->mode;
 			break;
 		case DRX_UIO_MODE_FIRMWARE0:
 		default:
 			return -EINVAL;
-			break;
 		}		/* switch ( uio_cfg->mode ) */
 		break;
       /*====================================================================*/
 	default:
 		return -EINVAL;
@@ -10951,11 +10947,10 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 		}
 		break;
 	default:
 		ext_attr->standard = DRX_STANDARD_UNKNOWN;
 		return -EINVAL;
-		break;
 	}
 
 	return 0;
 rw_error:
 	/* Don't know what the standard is now ... try again */
@@ -11072,11 +11067,10 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 		sio_cc_pwd_mode = SIO_CC_PWD_MODE_LEVEL_OSC;
 		break;
 	default:
 		/* Unknow sleep mode */
 		return -EINVAL;
-		break;
 	}
 
 	/* Check if device needs to be powered up */
 	if ((common_attr->current_power_mode != DRX_POWER_UP)) {
 		rc = power_up_device(demod);
@@ -11894,11 +11888,10 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 			}
 			break;
 		}
 		default:
 			return -EINVAL;
-			break;
 
 		}
 		mc_data += mc_block_nr_bytes;
 	}
 
diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 45f982863904..a7eb81df88c2 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -1620,11 +1620,10 @@ static int CorrectSysClockDeviation(struct drxd_state *state)
 		case 6000000:
 			bandwidth = DRXD_BANDWIDTH_6MHZ_IN_HZ;
 			break;
 		default:
 			return -1;
-			break;
 		}
 
 		/* Compute new sysclock value
 		   sysClockFreq = (((incr + 2^23)*bandwidth)/2^21)/1000 */
 		incr += (1 << 23);
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 35b83b1dd82c..200b6dbc75f8 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -166,11 +166,10 @@ static int nxt200x_writereg_multibyte (struct nxt200x_state* state, u8 reg, u8*
 			len2 = ((attr << 4) | 0x10) | len;
 			buf = 0x80;
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	/* set multi register length */
 	nxt200x_writebytes(state, 0x34, &len2, 1);
 
@@ -188,11 +187,10 @@ static int nxt200x_writereg_multibyte (struct nxt200x_state* state, u8 reg, u8*
 			if (buf == 0)
 				return 0;
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	pr_warn("Error writing multireg register 0x%02X\n", reg);
 
 	return 0;
@@ -214,11 +212,10 @@ static int nxt200x_readreg_multibyte (struct nxt200x_state* state, u8 reg, u8* d
 			nxt200x_writebytes(state, 0x34, &len2, 1);
 
 			/* read the actual data */
 			nxt200x_readbytes(state, reg, data, len);
 			return 0;
-			break;
 		case NXT2004:
 			/* probably not right, but gives correct values */
 			attr = 0x02;
 			if (reg & 0x80) {
 				attr = attr << 1;
@@ -237,14 +234,12 @@ static int nxt200x_readreg_multibyte (struct nxt200x_state* state, u8 reg, u8* d
 			/* read the actual data */
 			for(i = 0; i < len; i++) {
 				nxt200x_readbytes(state, 0x36 + i, &data[i], 1);
 			}
 			return 0;
-			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 }
 
 static void nxt200x_microcontroller_stop (struct nxt200x_state* state)
 {
@@ -372,11 +367,10 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 			}
 			pr_warn("timeout error writing to tuner\n");
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 	return 0;
 }
 
 static void nxt200x_agc_reset(struct nxt200x_state* state)
@@ -553,11 +547,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 			if (state->config->set_ts_params)
 				state->config->set_ts_params(fe, 0);
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	if (fe->ops.tuner_ops.calc_regs) {
 		/* get tuning information */
 		fe->ops.tuner_ops.calc_regs(fe, buf, 5);
@@ -578,11 +571,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case VSB_8:
 			buf[0] = 0x70;
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 	nxt200x_writebytes(state, 0x42, buf, 1);
 
 	/* configure sdm */
 	switch (state->demod_chip) {
@@ -592,11 +584,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case NXT2004:
 			buf[0] = 0x07;
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 	nxt200x_writebytes(state, 0x57, buf, 1);
 
 	/* write sdm1 input */
 	buf[0] = 0x10;
@@ -608,11 +599,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case NXT2004:
 			nxt200x_writebytes(state, 0x58, buf, 2);
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	/* write sdmx input */
 	switch (p->modulation) {
 		case QAM_64:
@@ -624,11 +614,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case VSB_8:
 				buf[0] = 0x60;
 				break;
 		default:
 				return -EINVAL;
-				break;
 	}
 	buf[1] = 0x00;
 	switch (state->demod_chip) {
 		case NXT2002:
 			nxt200x_writereg_multibyte(state, 0x5C, buf, 2);
@@ -636,11 +625,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case NXT2004:
 			nxt200x_writebytes(state, 0x5C, buf, 2);
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	/* write adc power lpf fc */
 	buf[0] = 0x05;
 	nxt200x_writebytes(state, 0x43, buf, 1);
@@ -662,11 +650,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case NXT2004:
 			nxt200x_writebytes(state, 0x4B, buf, 2);
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	/* write kg1 */
 	buf[0] = 0x00;
 	nxt200x_writebytes(state, 0x4D, buf, 1);
@@ -718,11 +705,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 		case VSB_8:
 				buf[0] = 0x00;
 				break;
 		default:
 				return -EINVAL;
-				break;
 	}
 	nxt200x_writebytes(state, 0x30, buf, 1);
 
 	/* write agc control reg */
 	buf[0] = 0x00;
@@ -740,11 +726,10 @@ static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 			nxt200x_writebytes(state, 0x49, buf, 2);
 			nxt200x_writebytes(state, 0x4B, buf, 2);
 			break;
 		default:
 			return -EINVAL;
-			break;
 	}
 
 	/* write agc control reg */
 	buf[0] = 0x04;
 	nxt200x_writebytes(state, 0x41, buf, 1);
@@ -1112,11 +1097,10 @@ static int nxt200x_init(struct dvb_frontend* fe)
 			case NXT2004:
 				ret = nxt2004_init(fe);
 				break;
 			default:
 				return -EINVAL;
-				break;
 		}
 		state->initialised = 1;
 	}
 	return ret;
 }
diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index a116eff417f2..e31eb2c5cc4c 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -462,14 +462,12 @@ static int si21xx_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage volt)
 	val = (0x80 | si21_readreg(state, LNB_CTRL_REG_1));
 
 	switch (volt) {
 	case SEC_VOLTAGE_18:
 		return si21_writereg(state, LNB_CTRL_REG_1, val | 0x40);
-		break;
 	case SEC_VOLTAGE_13:
 		return si21_writereg(state, LNB_CTRL_REG_1, (val & ~0x40));
-		break;
 	default:
 		return -EINVAL;
 	}
 }
 
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 2240d214dfac..d105431a2e2d 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1847,11 +1847,10 @@ static int mt2063_init(struct dvb_frontend *fe)
 		def = MT2063B0_defaults;
 		break;
 
 	default:
 		return -ENODEV;
-		break;
 	}
 
 	while (status >= 0 && *def) {
 		u8 reg = *def++;
 		u8 val = *def++;
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9903e9660a38..3078fac34e51 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -471,11 +471,10 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 			req_idx = pa & 0x0000FFFF;
 			mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 			mpt_free_msg_frame(ioc, mf);
 			mb();
 			return;
-			break;
 		}
 		mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
 		break;
 	case MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET:
 		cb_idx = mpt_get_cb_idx(MPTSTM_DRIVER);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index a97eb5d47705..686e8b6a4c55 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1375,11 +1375,10 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		dev->dev_state = MEI_DEV_POWER_DOWN;
 		dev_info(dev->dev, "hbm: stop response: resetting.\n");
 		/* force the reset */
 		return -EPROTO;
-		break;
 
 	case CLIENT_DISCONNECT_REQ_CMD:
 		dev_dbg(dev->dev, "hbm: disconnect request: message received\n");
 
 		disconnect_req = (struct hbm_client_connect_request *)mei_msg;
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index b40f46a43fc6..323035d4f2d0 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -879,21 +879,19 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
 		loff_t offs;
 
 		if (copy_from_user(&offs, argp, sizeof(loff_t)))
 			return -EFAULT;
 		return mtd_block_isbad(mtd, offs);
-		break;
 	}
 
 	case MEMSETBADBLOCK:
 	{
 		loff_t offs;
 
 		if (copy_from_user(&offs, argp, sizeof(loff_t)))
 			return -EFAULT;
 		return mtd_block_markbad(mtd, offs);
-		break;
 	}
 
 	case OTPSELECT:
 	{
 		int mode;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index c3f49543ff26..9c215f7c5f81 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -73,15 +73,15 @@ static const struct can_bittiming_const mcp251xfd_data_bittiming_const = {
 
 static const char *__mcp251xfd_get_model_str(enum mcp251xfd_model model)
 {
 	switch (model) {
 	case MCP251XFD_MODEL_MCP2517FD:
-		return "MCP2517FD"; break;
+		return "MCP2517FD";
 	case MCP251XFD_MODEL_MCP2518FD:
-		return "MCP2518FD"; break;
+		return "MCP2518FD";
 	case MCP251XFD_MODEL_MCP251XFD:
-		return "MCP251xFD"; break;
+		return "MCP251xFD";
 	}
 
 	return "<unknown>";
 }
 
@@ -93,25 +93,25 @@ mcp251xfd_get_model_str(const struct mcp251xfd_priv *priv)
 
 static const char *mcp251xfd_get_mode_str(const u8 mode)
 {
 	switch (mode) {
 	case MCP251XFD_REG_CON_MODE_MIXED:
-		return "Mixed (CAN FD/CAN 2.0)"; break;
+		return "Mixed (CAN FD/CAN 2.0)";
 	case MCP251XFD_REG_CON_MODE_SLEEP:
-		return "Sleep"; break;
+		return "Sleep";
 	case MCP251XFD_REG_CON_MODE_INT_LOOPBACK:
-		return "Internal Loopback"; break;
+		return "Internal Loopback";
 	case MCP251XFD_REG_CON_MODE_LISTENONLY:
-		return "Listen Only"; break;
+		return "Listen Only";
 	case MCP251XFD_REG_CON_MODE_CONFIG:
-		return "Configuration"; break;
+		return "Configuration";
 	case MCP251XFD_REG_CON_MODE_EXT_LOOPBACK:
-		return "External Loopback"; break;
+		return "External Loopback";
 	case MCP251XFD_REG_CON_MODE_CAN2_0:
-		return "CAN 2.0"; break;
+		return "CAN 2.0";
 	case MCP251XFD_REG_CON_MODE_RESTRICTED:
-		return "Restricted Operation"; break;
+		return "Restricted Operation";
 	}
 
 	return "<unknown>";
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 0f865daeb36d..bf5e0e9bd0e2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1161,11 +1161,10 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 			break;
 
 		default:
 			err = -1;
 			goto err_exit;
-		break;
 		}
 		if (!(self->aq_nic_cfg.aq_hw_caps->link_speed_msk & rate)) {
 			err = -1;
 			goto err_exit;
 		}
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index a4dd52bba2c3..1a9803f2073e 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -432,11 +432,10 @@ static int enic_grxclsrule(struct enic *enic, struct ethtool_rxnfc *cmd)
 	case IPPROTO_UDP:
 		fsp->flow_type = UDP_V4_FLOW;
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	fsp->h_u.tcp_ip4_spec.ip4src = flow_get_u32_src(&n->keys);
 	fsp->m_u.tcp_ip4_spec.ip4src = (__u32)~0;
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
index de563cfd294d..4b93ba149ec5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
@@ -348,11 +348,10 @@ static s32 ixgbe_calc_eeprom_checksum_X540(struct ixgbe_hw *hw)
 			continue;
 
 		if (ixgbe_read_eerd_generic(hw, pointer, &length)) {
 			hw_dbg(hw, "EEPROM read failed\n");
 			return IXGBE_ERR_EEPROM;
-			break;
 		}
 
 		/* Skip pointer section if length is invalid. */
 		if (length == 0xFFFF || length == 0 ||
 		    (pointer + length) >= hw->eeprom.word_size)
diff --git a/drivers/net/wan/lmc/lmc_proto.c b/drivers/net/wan/lmc/lmc_proto.c
index e8b0b902b424..4e9cc83b615a 100644
--- a/drivers/net/wan/lmc/lmc_proto.c
+++ b/drivers/net/wan/lmc/lmc_proto.c
@@ -87,21 +87,17 @@ void lmc_proto_close(lmc_softc_t *sc)
 __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
 {
     switch(sc->if_type){
     case LMC_PPP:
 	    return hdlc_type_trans(skb, sc->lmc_device);
-	    break;
     case LMC_NET:
         return htons(ETH_P_802_2);
-        break;
     case LMC_RAW: /* Packet type for skbuff kind of useless */
         return htons(ETH_P_802_2);
-        break;
     default:
         printk(KERN_WARNING "%s: No protocol set for this interface, assuming 802.2 (which is wrong!!)\n", sc->name);
         return htons(ETH_P_802_2);
-        break;
     }
 }
 
 void lmc_proto_netif(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
 {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 5c1af2021883..9c4e6cf2137a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3876,11 +3876,10 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		atomic_inc(&htt->num_mpdus_ready);
 
 		return ath10k_htt_rx_proc_rx_frag_ind(htt,
 						      &resp->rx_frag_ind,
 						      skb);
-		break;
 	}
 	case HTT_T2H_MSG_TYPE_TEST:
 		break;
 	case HTT_T2H_MSG_TYPE_STATS_CONF:
 		trace_ath10k_htt_stats(ar, skb->data, skb->len);
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index f3906dbe5495..89c7c4e25169 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -92,11 +92,10 @@ int ath6kl_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 		ath6kl_wmi_test_cmd(ar->wmi, buf, buf_len);
 
 		return 0;
 
-		break;
 	case ATH6KL_TM_CMD_RX_REPORT:
 	default:
 		return -EOPNOTSUPP;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6609ce122e6e..b66eeb577272 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2306,11 +2306,10 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 		break;
 	default:
 		ath_dbg(ath9k_hw_common(ah), BEACON,
 			"%s: unsupported opmode: %d\n", __func__, ah->opmode);
 		return;
-		break;
 	}
 
 	REG_WRITE(ah, AR_BEACON_PERIOD, beacon_period);
 	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, beacon_period);
 	REG_WRITE(ah, AR_SWBA_PERIOD, beacon_period);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index cbdebefb854a..8698ca4d30de 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1200,17 +1200,15 @@ static int iwl_mvm_mac_ctx_send(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
 						force_assoc_off,
 						bssid_override);
-		break;
 	case NL80211_IFTYPE_AP:
 		if (!vif->p2p)
 			return iwl_mvm_mac_ctxt_cmd_ap(mvm, vif, action);
 		else
 			return iwl_mvm_mac_ctxt_cmd_go(mvm, vif, action);
-		break;
 	case NL80211_IFTYPE_MONITOR:
 		return iwl_mvm_mac_ctxt_cmd_listener(mvm, vif, action);
 	case NL80211_IFTYPE_P2P_DEVICE:
 		return iwl_mvm_mac_ctxt_cmd_p2p_device(mvm, vif, action);
 	case NL80211_IFTYPE_ADHOC:
diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 5bd35c147e19..3ca9d26df174 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -868,11 +868,10 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 				err = -ENOMSG;
 				goto err;
 			} else {
 				goto good_eeprom;
 			}
-			break;
 		default:
 			break;
 		}
 
 		crc16 = crc_ccitt(crc16, (u8 *)entry, (entry_len + 1) * 2);
diff --git a/drivers/net/wireless/intersil/prism54/oid_mgt.c b/drivers/net/wireless/intersil/prism54/oid_mgt.c
index 9fd307ca4b6d..7b251ae90a68 100644
--- a/drivers/net/wireless/intersil/prism54/oid_mgt.c
+++ b/drivers/net/wireless/intersil/prism54/oid_mgt.c
@@ -785,21 +785,19 @@ mgt_response_to_str(enum oid_num_t n, union oid_res_t *r, char *str)
 			struct obj_buffer *buff = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"size=%u\naddr=0x%X\n", buff->size,
 					buff->addr);
 		}
-		break;
 	case OID_TYPE_BSS:{
 			struct obj_bss *bss = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"age=%u\nchannel=%u\n"
 					"capinfo=0x%X\nrates=0x%X\n"
 					"basic_rates=0x%X\n", bss->age,
 					bss->channel, bss->capinfo,
 					bss->rates, bss->basic_rates);
 		}
-		break;
 	case OID_TYPE_BSSLIST:{
 			struct obj_bsslist *list = r->ptr;
 			int i, k;
 			k = scnprintf(str, PRIV_STR_SIZE, "nr=%u\n", list->nr);
 			for (i = 0; i < list->nr; i++)
@@ -812,53 +810,47 @@ mgt_response_to_str(enum oid_num_t n, union oid_res_t *r, char *str)
 					      list->bsslist[i].capinfo,
 					      list->bsslist[i].rates,
 					      list->bsslist[i].basic_rates);
 			return k;
 		}
-		break;
 	case OID_TYPE_FREQUENCIES:{
 			struct obj_frequencies *freq = r->ptr;
 			int i, t;
 			printk("nr : %u\n", freq->nr);
 			t = scnprintf(str, PRIV_STR_SIZE, "nr=%u\n", freq->nr);
 			for (i = 0; i < freq->nr; i++)
 				t += scnprintf(str + t, PRIV_STR_SIZE - t,
 					      "mhz[%u]=%u\n", i, freq->mhz[i]);
 			return t;
 		}
-		break;
 	case OID_TYPE_MLME:{
 			struct obj_mlme *mlme = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"id=0x%X\nstate=0x%X\ncode=0x%X\n",
 					mlme->id, mlme->state, mlme->code);
 		}
-		break;
 	case OID_TYPE_MLMEEX:{
 			struct obj_mlmeex *mlme = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"id=0x%X\nstate=0x%X\n"
 					"code=0x%X\nsize=0x%X\n", mlme->id,
 					mlme->state, mlme->code, mlme->size);
 		}
-		break;
 	case OID_TYPE_ATTACH:{
 			struct obj_attachment *attach = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"id=%d\nsize=%d\n",
 					attach->id,
 					attach->size);
 		}
-		break;
 	case OID_TYPE_SSID:{
 			struct obj_ssid *ssid = r->ptr;
 			return scnprintf(str, PRIV_STR_SIZE,
 					"length=%u\noctets=%.*s\n",
 					ssid->length, ssid->length,
 					ssid->octets);
 		}
-		break;
 	case OID_TYPE_KEY:{
 			struct obj_key *key = r->ptr;
 			int t, i;
 			t = scnprintf(str, PRIV_STR_SIZE,
 				     "type=0x%X\nlength=0x%X\nkey=0x",
@@ -867,11 +859,10 @@ mgt_response_to_str(enum oid_num_t n, union oid_res_t *r, char *str)
 				t += scnprintf(str + t, PRIV_STR_SIZE - t,
 					      "%02X:", key->key[i]);
 			t += scnprintf(str + t, PRIV_STR_SIZE - t, "\n");
 			return t;
 		}
-		break;
 	case OID_TYPE_RAW:
 	case OID_TYPE_ADDR:{
 			unsigned char *buff = r->ptr;
 			int t, i;
 			t = scnprintf(str, PRIV_STR_SIZE, "hex data=");
@@ -879,11 +870,10 @@ mgt_response_to_str(enum oid_num_t n, union oid_res_t *r, char *str)
 				t += scnprintf(str + t, PRIV_STR_SIZE - t,
 					      "%02X:", buff[i]);
 			t += scnprintf(str + t, PRIV_STR_SIZE - t, "\n");
 			return t;
 		}
-		break;
 	default:
 		BUG();
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 63f9ea21962f..bd9160b166c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1224,11 +1224,10 @@ static int _rtl88ee_set_media_status(struct ieee80211_hw *hw,
 			"Set Network type to AP!\n");
 		break;
 	default:
 		pr_err("Network type %d not support!\n", type);
 		return 1;
-		break;
 	}
 
 	/* MSR_INFRA == Link in infrastructure network;
 	 * MSR_ADHOC == Link in ad hoc network;
 	 * Therefore, check link state is necessary.
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index a36dc6e726d2..f8a1de6e9849 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1130,11 +1130,10 @@ static int _rtl8723e_set_media_status(struct ieee80211_hw *hw,
 			"Set Network type to AP!\n");
 		break;
 	default:
 		pr_err("Network type %d not support!\n", type);
 		return 1;
-		break;
 	}
 
 	/* MSR_INFRA == Link in infrastructure network;
 	 * MSR_ADHOC == Link in ad hoc network;
 	 * Therefore, check link state is necessary.
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index f41a7643b9c4..225b8cd44f23 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -2083,16 +2083,14 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	switch (rfpath) {
 	case RF90_PATH_A:
 		return __rtl8821ae_phy_config_with_headerfile(hw,
 				radioa_array_table_a, radioa_arraylen_a,
 				_rtl8821ae_config_rf_radio_a);
-		break;
 	case RF90_PATH_B:
 		return __rtl8821ae_phy_config_with_headerfile(hw,
 				radioa_array_table_b, radioa_arraylen_b,
 				_rtl8821ae_config_rf_radio_b);
-		break;
 	case RF90_PATH_C:
 	case RF90_PATH_D:
 		pr_err("switch case %#x not processed\n", rfpath);
 		break;
 	}
@@ -2114,11 +2112,10 @@ bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	switch (rfpath) {
 	case RF90_PATH_A:
 		return __rtl8821ae_phy_config_with_headerfile(hw,
 			radioa_array_table, radioa_arraylen,
 			_rtl8821ae_config_rf_radio_a);
-		break;
 
 	case RF90_PATH_B:
 	case RF90_PATH_C:
 	case RF90_PATH_D:
 		pr_err("switch case %#x not processed\n", rfpath);
diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index 2ce17932a073..6ca0d2f56b18 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -792,11 +792,10 @@ static int st21nfca_hci_im_transceive(struct nfc_hci_dev *hdev,
 		return nfc_hci_send_cmd_async(hdev, target->hci_reader_gate,
 					      ST21NFCA_WR_XCHG_DATA, skb->data,
 					      skb->len,
 					      st21nfca_hci_data_exchange_cb,
 					      info);
-		break;
 	default:
 		return 1;
 	}
 }
 
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 3bd97c73f983..c70f62fe321e 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1380,11 +1380,10 @@ static int trf7970a_is_iso15693_write_or_lock(u8 cmd)
 	case ISO15693_CMD_WRITE_AFI:
 	case ISO15693_CMD_LOCK_AFI:
 	case ISO15693_CMD_WRITE_DSFID:
 	case ISO15693_CMD_LOCK_DSFID:
 		return 1;
-		break;
 	default:
 		return 0;
 	}
 }
 
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 5a7c80053c62..2f250874b1a4 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -200,11 +200,10 @@ ssize_t nd_namespace_store(struct device *dev,
 		}
 		break;
 	default:
 		len = -EBUSY;
 		goto out_attach;
-		break;
 	}
 
 	if (__nvdimm_namespace_capacity(ndns) < SZ_16M) {
 		dev_dbg(dev, "%s too small to host\n", name);
 		len = -ENXIO;
diff --git a/drivers/pci/controller/pci-v3-semi.c b/drivers/pci/controller/pci-v3-semi.c
index 1f54334f09f7..154a5398633c 100644
--- a/drivers/pci/controller/pci-v3-semi.c
+++ b/drivers/pci/controller/pci-v3-semi.c
@@ -656,11 +656,10 @@ static int v3_get_dma_range_config(struct v3_pci *v3,
 		val |= V3_LB_BASE_ADR_SIZE_2GB;
 		break;
 	default:
 		dev_err(v3->dev, "illegal dma memory chunk size\n");
 		return -EINVAL;
-		break;
 	}
 	val |= V3_PCI_MAP_M_REG_EN | V3_PCI_MAP_M_ENABLE;
 	*pci_map = val;
 
 	dev_dbg(dev,
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
index 5e24838a582f..2223ead5bd72 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
@@ -106,23 +106,18 @@ struct s3c24xx_eint_domain_data {
 static int s3c24xx_eint_get_trigger(unsigned int type)
 {
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
 		return EINT_EDGE_RISING;
-		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		return EINT_EDGE_FALLING;
-		break;
 	case IRQ_TYPE_EDGE_BOTH:
 		return EINT_EDGE_BOTH;
-		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 		return EINT_LEVEL_HIGH;
-		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		return EINT_LEVEL_LOW;
-		break;
 	default:
 		return -EINVAL;
 	}
 }
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 49f4b73be513..1c2084c74a57 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -790,11 +790,10 @@ static acpi_status AMW0_set_u32(u32 value, u32 cap)
 		if (value > max_brightness)
 			return AE_BAD_PARAMETER;
 		switch (quirks->brightness) {
 		default:
 			return ec_write(0x83, value);
-			break;
 		}
 	default:
 		return AE_ERROR;
 	}
 
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index e5a1b5533408..704813374922 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -2465,26 +2465,23 @@ static int __sony_nc_gfx_switch_status_get(void)
 	case 0x0146:
 		/* 1: discrete GFX (speed)
 		 * 0: integrated GFX (stamina)
 		 */
 		return result & 0x1 ? SPEED : STAMINA;
-		break;
 	case 0x015B:
 		/* 0: discrete GFX (speed)
 		 * 1: integrated GFX (stamina)
 		 */
 		return result & 0x1 ? STAMINA : SPEED;
-		break;
 	case 0x0128:
 		/* it's a more elaborated bitmask, for now:
 		 * 2: integrated GFX (stamina)
 		 * 0: discrete GFX (speed)
 		 */
 		dprintk("GFX Status: 0x%x\n", result);
 		return result & 0x80 ? AUTO :
 			result & 0x02 ? STAMINA : SPEED;
-		break;
 	}
 	return -EINVAL;
 }
 
 static ssize_t sony_nc_gfx_switch_status_show(struct device *dev,
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index d88f388a3450..44e802f9f1b4 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -1258,17 +1258,14 @@ acpi_wmi_ec_space_handler(u32 function, acpi_physical_address address,
 	}
 
 	switch (result) {
 	case -EINVAL:
 		return AE_BAD_PARAMETER;
-		break;
 	case -ENODEV:
 		return AE_NOT_FOUND;
-		break;
 	case -ETIME:
 		return AE_TIME;
-		break;
 	default:
 		return AE_OK;
 	}
 }
 
diff --git a/drivers/power/supply/wm831x_power.c b/drivers/power/supply/wm831x_power.c
index 18b33f14dfee..4cd2dd870039 100644
--- a/drivers/power/supply/wm831x_power.c
+++ b/drivers/power/supply/wm831x_power.c
@@ -666,11 +666,10 @@ static int wm831x_power_probe(struct platform_device *pdev)
 	default:
 		dev_err(&pdev->dev, "Failed to find USB phy: %d\n", ret);
 		fallthrough;
 	case -EPROBE_DEFER:
 		goto err_bat_irq;
-		break;
 	}
 
 	return ret;
 
 err_bat_irq:
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index f923ed019d4a..ed034192b3c3 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -267,11 +267,10 @@ static void asd_task_tasklet_complete(struct asd_ascb *ascb,
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case TA_I_T_NEXUS_LOSS:
 		opcode = dl->status_block[0];
 		goto Again;
-		break;
 	case TF_INV_CONN_HANDLE:
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEVICE_UNKNOWN;
 		break;
 	case TF_REQUESTED_N_PENDING:
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 96d6e384b2b2..0d4928567265 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1242,22 +1242,18 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
 	case BE_DEVICE_ID1:
 	case OC_DEVICE_ID1:
 	case OC_DEVICE_ID2:
 		return snprintf(buf, PAGE_SIZE,
 				"Obsolete/Unsupported BE2 Adapter Family\n");
-		break;
 	case BE_DEVICE_ID2:
 	case OC_DEVICE_ID3:
 		return snprintf(buf, PAGE_SIZE, "BE3-R Adapter Family\n");
-		break;
 	case OC_SKH_ID1:
 		return snprintf(buf, PAGE_SIZE, "Skyhawk-R Adapter Family\n");
-		break;
 	default:
 		return snprintf(buf, PAGE_SIZE,
 				"Unknown Adapter Family: 0x%x\n", dev_id);
-		break;
 	}
 }
 
 /**
  * beiscsi_phys_port()- Display Physical Port Identifier
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 08992095ce7a..b37b0a9ec12d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -768,11 +768,10 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 				if (rc)
 					goto skip_rec;
 			} else
 				printk(KERN_ERR PFX "SRR in progress\n");
 			goto ret_err_rqe;
-			break;
 		default:
 			break;
 		}
 
 skip_rec:
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0f9274960dc6..a4be6f439c47 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1892,11 +1892,10 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 			fcoe_interface_remove(fcoe);
 		fcoe_interface_cleanup(fcoe);
 		mutex_unlock(&fcoe_config_mutex);
 		fcoe_ctlr_device_delete(fcoe_ctlr_to_ctlr_dev(ctlr));
 		goto out;
-		break;
 	case NETDEV_FEAT_CHANGE:
 		fcoe_netdev_features_change(lport, netdev);
 		break;
 	default:
 		FCOE_NETDEV_DBG(netdev, "Unknown event %ld "
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 83ce4f11a589..45136e3a4efc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7440,11 +7440,10 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 				break;
 			default:	/* reserved in PCI 2.2 */
 				dev_warn(&pdev->dev,
 				       "base address is invalid\n");
 				return -1;
-				break;
 			}
 		}
 		if (offset == pci_bar_addr - PCI_BASE_ADDRESS_0)
 			return i + 1;
 	}
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 6a2561f26e38..db4c7a7ff4dd 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -756,11 +756,10 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 		scsi_set_resid(scp,
 			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memcpy(scp->sense_buffer, &req->sg_list, SCSI_SENSE_BUFFERSIZE);
 		goto skip_resid;
-		break;
 
 	default:
 		scp->result = DRIVER_INVALID << 24 | DID_ABORT << 16;
 		break;
 	}
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0aa58d117cc..e451102b9a29 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9485,11 +9485,10 @@ static pci_ers_result_t ipr_pci_error_detected(struct pci_dev *pdev,
 		ipr_pci_frozen(pdev);
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_perm_failure:
 		ipr_pci_perm_failure(pdev);
 		return PCI_ERS_RESULT_DISCONNECT;
-		break;
 	default:
 		break;
 	}
 	return PCI_ERS_RESULT_NEED_RESET;
 }
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 7041e2e3ab48..1b87d9080ebe 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -751,11 +751,10 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 		       sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 		       break;
 		default:
 			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
-			break;
 		}
 		return SCI_SUCCESS;
 	case SCI_PHY_SUB_AWAIT_IAF_UF:
 		switch (scu_get_event_code(event_code)) {
 		case SCU_EVENT_SAS_PHY_DETECTED:
@@ -956,11 +955,10 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
 		default:
 			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE_INVALID_STATE;
-			break;
 		}
 		return SCI_SUCCESS;
 	default:
 		dev_dbg(sciphy_to_dev(iphy), "%s: in wrong state: %s\n",
 			__func__, phy_state_name(state));
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index c9a327b13e5c..325081ac6553 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3339,11 +3339,10 @@ lpfc_idiag_pcicfg_read(struct file *file, char __user *buf, size_t nbytes,
 		len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 				"%03x: %08x\n", where, u32val);
 		break;
 	case LPFC_PCI_CFG_BROWSE: /* browse all */
 		goto pcicfg_browse;
-		break;
 	default:
 		/* illegal count */
 		len = 0;
 		break;
 	}
@@ -4379,11 +4378,11 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 					goto pass_check;
 				}
 			}
 		}
 		goto error_out;
-		break;
+
 	case LPFC_IDIAG_CQ:
 		/* MBX complete queue */
 		if (phba->sli4_hba.mbx_cq &&
 		    phba->sli4_hba.mbx_cq->queue_id == queid) {
 			/* Sanity check */
@@ -4431,11 +4430,11 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 					goto pass_check;
 				}
 			}
 		}
 		goto error_out;
-		break;
+
 	case LPFC_IDIAG_MQ:
 		/* MBX work queue */
 		if (phba->sli4_hba.mbx_wq &&
 		    phba->sli4_hba.mbx_wq->queue_id == queid) {
 			/* Sanity check */
@@ -4445,11 +4444,11 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 				goto error_out;
 			idiag.ptr_private = phba->sli4_hba.mbx_wq;
 			goto pass_check;
 		}
 		goto error_out;
-		break;
+
 	case LPFC_IDIAG_WQ:
 		/* ELS work queue */
 		if (phba->sli4_hba.els_wq &&
 		    phba->sli4_hba.els_wq->queue_id == queid) {
 			/* Sanity check */
@@ -4485,13 +4484,12 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 					idiag.ptr_private = qp;
 					goto pass_check;
 				}
 			}
 		}
-
 		goto error_out;
-		break;
+
 	case LPFC_IDIAG_RQ:
 		/* HDR queue */
 		if (phba->sli4_hba.hdr_rq &&
 		    phba->sli4_hba.hdr_rq->queue_id == queid) {
 			/* Sanity check */
@@ -4512,14 +4510,12 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 				goto error_out;
 			idiag.ptr_private = phba->sli4_hba.dat_rq;
 			goto pass_check;
 		}
 		goto error_out;
-		break;
 	default:
 		goto error_out;
-		break;
 	}
 
 pass_check:
 
 	if (idiag.cmd.opcode == LPFC_IDIAG_CMD_QUEACC_RD) {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ca25e54bb782..b6090357e8a5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7194,11 +7194,10 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"1431 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
-		break;
 	}
 	return 0;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 983eeb0e3d07..c3b02dab6e5c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4282,11 +4282,10 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"1418 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
-		break;
 	}
 	phba->lpfc_rampdown_queue_depth = lpfc_rampdown_queue_depth;
 	phba->lpfc_scsi_cmd_iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e158cd77d387..0f18f1ba8a28 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9187,11 +9187,10 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"1420 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
-		break;
 	}
 	return 0;
 }
 
 /**
@@ -10070,11 +10069,10 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2014 Invalid command 0x%x\n",
 				iocbq->iocb.ulpCommand);
 		return IOCB_ERROR;
-		break;
 	}
 
 	if (iocbq->iocb_flag & LPFC_IO_DIF_PASS)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
 	else if (iocbq->iocb_flag & LPFC_IO_DIF_STRIP)
@@ -10232,11 +10230,10 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"1419 Invalid HBA PCI-device group: 0x%x\n",
 				dev_grp);
 		return -ENODEV;
-		break;
 	}
 	phba->lpfc_get_iocb_from_iocbq = lpfc_get_iocb_from_iocbq;
 	return 0;
 }
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 0354898d7cac..2f7a52bd653a 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2294,11 +2294,10 @@ static int mvumi_cfg_hw_reg(struct mvumi_hba *mhba)
 		regs->int_drbl_int_mask     = 0x3FFFFFFF;
 		regs->int_mu = regs->int_dl_cpu2pciea | regs->int_comaout;
 		break;
 	default:
 		return -1;
-		break;
 	}
 
 	return 0;
 }
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index bc5a623519e7..bb3b3884f968 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1100,12 +1100,10 @@ static irqreturn_t nspintr(int irq, void *dev_id)
 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN);
 		udelay(1);
 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN | AUTODIRECTION | ACKENB);
 		return IRQ_HANDLED;
 
-		break;
-
 	case PH_RESELECT:
 		//nsp_dbg(NSP_DEBUG_INTR, "phase reselect");
 		// *sync_neg = SYNC_NOT_YET;
 		if ((phase & BUSMON_PHASE_MASK) != BUSPHASE_MESSAGE_IN) {
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 07afd0d8a8f3..40af7f1524ce 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4028,11 +4028,10 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 
 			/* if our portname is higher then initiate N2N login */
 
 			set_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags);
 			return;
-			break;
 		case TOPO_FL:
 			ha->current_topology = ISP_CFG_FL;
 			break;
 		case TOPO_F:
 			ha->current_topology = ISP_CFG_F;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e2e5356a997d..43f7624508a9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2844,11 +2844,10 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		fileno = blkno = at_sm = 0;
 		break;
 	case MTNOP:
 		DEBC_printk(STp, "No op on tape.\n");
 		return 0;	/* Should do something ? */
-		break;
 	case MTRETEN:
 		cmd[0] = START_STOP;
 		if (STp->immediate) {
 			cmd[1] = 1;	/* Don't wait for completion */
 			timeout = STp->device->request_queue->rq_timeout;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a9fe092a4906..255a2d48d421 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4594,11 +4594,10 @@ static void sym_int_sir(struct sym_hcb *np)
 				sym_print_addr(cp->cmd,
 					"M_REJECT received (%x:%x).\n",
 					scr_to_cpu(np->lastmsg), np->msgout[0]);
 			}
 			goto out_clrack;
-			break;
 		default:
 			goto out_reject;
 		}
 		break;
 	/*
diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index ddee04c8248d..eab7a048ca7a 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -6284,11 +6284,10 @@ allocate_delay_frames(struct ia_css_pipe *pipe) {
 	case IA_CSS_PIPE_ID_CAPTURE: {
 		struct ia_css_capture_settings *mycs_capture = &pipe->pipe_settings.capture;
 		(void)mycs_capture;
 		return err;
 	}
-	break;
 	case IA_CSS_PIPE_ID_VIDEO: {
 		struct ia_css_video_settings *mycs_video = &pipe->pipe_settings.video;
 
 		ref_info = mycs_video->video_binary.internal_frame_info;
 		/*The ref frame expects
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index 1deb74112ad4..672248be7bf3 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -569,12 +569,10 @@ static int start_stop_unit(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	case LOAD_MEDIUM:
 		if (check_card_ready(chip, lun))
 			return TRANSPORT_GOOD;
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		return TRANSPORT_FAILED;
-
-		break;
 	}
 
 	return TRANSPORT_ERROR;
 }
 
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index fd0ea4dbcb91..7c7d3858e6ca 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -355,12 +355,10 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			 *	to userspace as they are
 			 */
 			return vme_master_set(image[minor].resource,
 				master.enable, master.vme_addr, master.size,
 				master.aspace, master.cycle, master.dwidth);
-
-			break;
 		}
 		break;
 	case SLAVE_MINOR:
 		switch (cmd) {
 		case VME_GET_SLAVE:
@@ -396,12 +394,10 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			 */
 			return vme_slave_set(image[minor].resource,
 				slave.enable, slave.vme_addr, slave.size,
 				image[minor].pci_buf, slave.aspace,
 				slave.cycle);
-
-			break;
 		}
 		break;
 	}
 
 	return -EINVAL;
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index d42b854cb7df..861e95043191 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -412,15 +412,13 @@ static void read_mem32(u32 *buf, const void __iomem *mem_addr_start,
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (u16 *) buf;
 		*buf16 = __le16_to_cpu(readw(ptr));
 		goto out;
-		break;
 	case 4:	/* 4 bytes */
 		*(buf) = __le32_to_cpu(readl(ptr));
 		goto out;
-		break;
 	}
 
 	while (i < size_bytes) {
 		if (size_bytes - i == 2) {
 			/* Handle 2 bytes in the end */
@@ -458,19 +456,18 @@ static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
 		buf16 = (const u16 *)buf;
 		writew(__cpu_to_le16(*buf16), ptr);
 		return 2;
-		break;
 	case 1: /*
 		 * also needs to write 4 bytes in this case
 		 * so falling through..
 		 */
+		fallthrough;
 	case 4: /* 4 bytes */
 		writel(__cpu_to_le32(*buf), ptr);
 		return 4;
-		break;
 	}
 
 	while (i < size_bytes) {
 		if (size_bytes - i == 2) {
 			/* 2 bytes */
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 1731d9728865..09703079db7b 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -318,31 +318,26 @@ static void imx_uart_writel(struct imx_port *sport, u32 val, u32 offset)
 static u32 imx_uart_readl(struct imx_port *sport, u32 offset)
 {
 	switch (offset) {
 	case UCR1:
 		return sport->ucr1;
-		break;
 	case UCR2:
 		/*
 		 * UCR2_SRST is the only bit in the cached registers that might
 		 * differ from the value that was last written. As it only
 		 * automatically becomes one after being cleared, reread
 		 * conditionally.
 		 */
 		if (!(sport->ucr2 & UCR2_SRST))
 			sport->ucr2 = readl(sport->port.membase + offset);
 		return sport->ucr2;
-		break;
 	case UCR3:
 		return sport->ucr3;
-		break;
 	case UCR4:
 		return sport->ucr4;
-		break;
 	case UFCR:
 		return sport->ufcr;
-		break;
 	default:
 		return readl(sport->port.membase + offset);
 	}
 }
 
diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 1125f4715830..5204769834d1 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -509,27 +509,23 @@ static int hidg_setup(struct usb_function *f,
 		VDBG(cdev, "get_report\n");
 
 		/* send an empty report */
 		length = min_t(unsigned, length, hidg->report_length);
 		memset(req->buf, 0x0, length);
-
 		goto respond;
-		break;
 
 	case ((USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_GET_PROTOCOL):
 		VDBG(cdev, "get_protocol\n");
 		length = min_t(unsigned int, length, 1);
 		((u8 *) req->buf)[0] = hidg->protocol;
 		goto respond;
-		break;
 
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_REPORT):
 		VDBG(cdev, "set_report | wLength=%d\n", ctrl->wLength);
 		goto stall;
-		break;
 
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_PROTOCOL):
 		VDBG(cdev, "set_protocol\n");
 		if (value > HID_REPORT_PROTOCOL)
@@ -542,11 +538,10 @@ static int hidg_setup(struct usb_function *f,
 		if (hidg->bInterfaceSubClass == USB_INTERFACE_SUBCLASS_BOOT) {
 			hidg->protocol = value;
 			goto respond;
 		}
 		goto stall;
-		break;
 
 	case ((USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_INTERFACE) << 8
 		  | USB_REQ_GET_DESCRIPTOR):
 		switch (value >> 8) {
 		case HID_DT_HID:
@@ -560,33 +555,29 @@ static int hidg_setup(struct usb_function *f,
 
 			length = min_t(unsigned short, length,
 						   hidg_desc_copy.bLength);
 			memcpy(req->buf, &hidg_desc_copy, length);
 			goto respond;
-			break;
 		}
 		case HID_DT_REPORT:
 			VDBG(cdev, "USB_REQ_GET_DESCRIPTOR: REPORT\n");
 			length = min_t(unsigned short, length,
 						   hidg->report_desc_length);
 			memcpy(req->buf, hidg->report_desc, length);
 			goto respond;
-			break;
 
 		default:
 			VDBG(cdev, "Unknown descriptor request 0x%x\n",
 				 value >> 8);
 			goto stall;
-			break;
 		}
 		break;
 
 	default:
 		VDBG(cdev, "Unknown request 0x%x\n",
 			 ctrl->bRequest);
 		goto stall;
-		break;
 	}
 
 stall:
 	return -EOPNOTSUPP;
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fe405cd38dbc..b46ef45c4d25 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1142,11 +1142,10 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 		max_packets = MAX_PACKET(8);
 		break;
 	case USB_SPEED_WIRELESS:
 		xhci_dbg(xhci, "FIXME xHCI doesn't support wireless speeds\n");
 		return -EINVAL;
-		break;
 	default:
 		/* Speed was set earlier, this shouldn't happen. */
 		return -EINVAL;
 	}
 	/* Find the root hub port this device is under */
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 70ec29681526..efbd317f2f25 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -382,11 +382,10 @@ static ssize_t iowarrior_write(struct file *file,
 			goto exit;
 		}
 		retval = usb_set_report(dev->interface, 2, 0, buf, count);
 		kfree(buf);
 		goto exit;
-		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
 	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
 	case USB_DEVICE_ID_CODEMERCS_IOW28:
 	case USB_DEVICE_ID_CODEMERCS_IOW28L:
 	case USB_DEVICE_ID_CODEMERCS_IOW100:
@@ -452,18 +451,16 @@ static ssize_t iowarrior_write(struct file *file,
 		}
 		/* submit was ok */
 		retval = count;
 		usb_free_urb(int_out_urb);
 		goto exit;
-		break;
 	default:
 		/* what do we have here ? An unsupported Product-ID ? */
 		dev_err(&dev->interface->dev, "%s - not supported for product=0x%x\n",
 			__func__, dev->product_id);
 		retval = -EFAULT;
 		goto exit;
-		break;
 	}
 error:
 	usb_free_coherent(dev->udev, dev->report_size, buf,
 			  int_out_urb->transfer_dma);
 error_no_buffer:
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index b4ba79123d9d..f1201d4de297 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -848,11 +848,10 @@ static int iuu_uart_baud(struct usb_serial_port *port, u32 baud_base,
 		dataout[DataCount++] = 0x04;
 		break;
 	default:
 		kfree(dataout);
 		return IUU_INVALID_PARAMETER;
-		break;
 	}
 
 	switch (parity & 0xF0) {
 	case IUU_ONE_STOP_BIT:
 		dataout[DataCount - 1] |= IUU_ONE_STOP_BIT;
@@ -862,11 +861,10 @@ static int iuu_uart_baud(struct usb_serial_port *port, u32 baud_base,
 		dataout[DataCount - 1] |= IUU_TWO_STOP_BITS;
 		break;
 	default:
 		kfree(dataout);
 		return IUU_INVALID_PARAMETER;
-		break;
 	}
 
 	status = bulk_immediate(port, dataout, DataCount);
 	if (status != IUU_OPERATION_OK)
 		dev_dbg(&port->dev, "%s - uart_off error\n", __func__);
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index 3d5f7d0ff0f1..2b098b55c4cb 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -429,11 +429,10 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 		/* should never hit here -- filtered in usb.c */
 		usb_stor_dbg(us, "freecom unimplemented direction: %d\n",
 			     us->srb->sc_data_direction);
 		/* Return fail, SCSI seems to handle this better. */
 		return USB_STOR_TRANSPORT_FAILED;
-		break;
 	}
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 50ae26977a02..1227ea937059 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -504,11 +504,10 @@ static int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 		addr |= TSI148_LCSR_ITAT_AS_A64;
 		break;
 	default:
 		dev_err(tsi148_bridge->parent, "Invalid address space\n");
 		return -EINVAL;
-		break;
 	}
 
 	/* Convert 64-bit variables to 2x 32-bit variables */
 	reg_split(vme_base, &vme_base_high, &vme_base_low);
 
@@ -993,11 +992,10 @@ static int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	default:
 		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Invalid address space\n");
 		retval = -EINVAL;
 		goto err_aspace;
-		break;
 	}
 
 	temp_ctl &= ~(3<<4);
 	if (cycle & VME_SUPER)
 		temp_ctl |= TSI148_LCSR_OTAT_SUP;
@@ -1501,11 +1499,10 @@ static int tsi148_dma_set_vme_src_attributes(struct device *dev, __be32 *attr,
 		val |= TSI148_LCSR_DSAT_AMODE_USER4;
 		break;
 	default:
 		dev_err(dev, "Invalid address space\n");
 		return -EINVAL;
-		break;
 	}
 
 	if (cycle & VME_SUPER)
 		val |= TSI148_LCSR_DSAT_SUP;
 	if (cycle & VME_PROG)
@@ -1601,11 +1598,10 @@ static int tsi148_dma_set_vme_dest_attributes(struct device *dev, __be32 *attr,
 		val |= TSI148_LCSR_DDAT_AMODE_USER4;
 		break;
 	default:
 		dev_err(dev, "Invalid address space\n");
 		return -EINVAL;
-		break;
 	}
 
 	if (cycle & VME_SUPER)
 		val |= TSI148_LCSR_DDAT_SUP;
 	if (cycle & VME_PROG)
@@ -1699,11 +1695,10 @@ static int tsi148_dma_list_add(struct vme_dma_list *list,
 		break;
 	default:
 		dev_err(tsi148_bridge->parent, "Invalid source type\n");
 		retval = -EINVAL;
 		goto err_source;
-		break;
 	}
 
 	/* Assume last link - this will be over-written by adding another */
 	entry->descriptor.dnlau = cpu_to_be32(0);
 	entry->descriptor.dnlal = cpu_to_be32(TSI148_LCSR_DNLAL_LLA);
@@ -1736,11 +1731,10 @@ static int tsi148_dma_list_add(struct vme_dma_list *list,
 		break;
 	default:
 		dev_err(tsi148_bridge->parent, "Invalid destination type\n");
 		retval = -EINVAL;
 		goto err_dest;
-		break;
 	}
 
 	/* Fill out count */
 	entry->descriptor.dcnt = cpu_to_be32((u32)count);
 
@@ -1962,11 +1956,10 @@ static int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 		break;
 	default:
 		mutex_unlock(&lm->mtx);
 		dev_err(tsi148_bridge->parent, "Invalid address space\n");
 		return -EINVAL;
-		break;
 	}
 
 	if (cycle & VME_SUPER)
 		lm_ctl |= TSI148_LCSR_LMAT_SUPR ;
 	if (cycle & VME_USER)
diff --git a/drivers/vme/vme.c b/drivers/vme/vme.c
index b398293980b6..e1a940e43327 100644
--- a/drivers/vme/vme.c
+++ b/drivers/vme/vme.c
@@ -50,27 +50,22 @@ static struct vme_bridge *find_bridge(struct vme_resource *resource)
 	/* Get list to search */
 	switch (resource->type) {
 	case VME_MASTER:
 		return list_entry(resource->entry, struct vme_master_resource,
 			list)->parent;
-		break;
 	case VME_SLAVE:
 		return list_entry(resource->entry, struct vme_slave_resource,
 			list)->parent;
-		break;
 	case VME_DMA:
 		return list_entry(resource->entry, struct vme_dma_resource,
 			list)->parent;
-		break;
 	case VME_LM:
 		return list_entry(resource->entry, struct vme_lm_resource,
 			list)->parent;
-		break;
 	default:
 		printk(KERN_ERR "Unknown resource type\n");
 		return NULL;
-		break;
 	}
 }
 
 /**
  * vme_free_consistent - Allocate contiguous memory.
@@ -177,26 +172,22 @@ size_t vme_get_size(struct vme_resource *resource)
 			&aspace, &cycle, &dwidth);
 		if (retval)
 			return 0;
 
 		return size;
-		break;
 	case VME_SLAVE:
 		retval = vme_slave_get(resource, &enabled, &base, &size,
 			&buf_base, &aspace, &cycle);
 		if (retval)
 			return 0;
 
 		return size;
-		break;
 	case VME_DMA:
 		return 0;
-		break;
 	default:
 		printk(KERN_ERR "Unknown resource type\n");
 		return 0;
-		break;
 	}
 }
 EXPORT_SYMBOL(vme_get_size);
 
 int vme_check_window(u32 aspace, unsigned long long vme_base,
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 83418924e30a..0b699c783d57 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -148,12 +148,10 @@ static long geodewdt_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident,
 				    sizeof(ident)) ? -EFAULT : 0;
-		break;
-
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
 	case WDIOC_SETOPTIONS:
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 89e73a6f0d36..64f3a54a0f72 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -161,11 +161,10 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 			init_special_inode(inode, inode->i_mode, device);
 			break;
 		default:
 			pr_warn("unsupported inode mode %o\n", inode->i_mode);
 			goto read_inode_error;
-			break;
 	}
 
 	unlock_new_inode(inode);
 	return inode;
         
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 79a231719460..3bd8119bed5e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1196,11 +1196,10 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 			break;
 		default:
 			msglog(hdr, "bad magic\n");
 			ret = -EINVAL;
 			goto out;
-			break;
 	}
 
 	/* find a handler for it */
 	handler_status = 0;
 	nmh = o2net_handler_get(be16_to_cpu(hdr->msg_type),
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1110ecd7d1f3..8f50c9c19f1b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2911,11 +2911,10 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 {
 	switch (attach_type) {
 	case BPF_CGROUP_INET_INGRESS:
 	case BPF_CGROUP_INET_EGRESS:
 		return BPF_PROG_TYPE_CGROUP_SKB;
-		break;
 	case BPF_CGROUP_INET_SOCK_CREATE:
 	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
 		return BPF_PROG_TYPE_CGROUP_SOCK;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 3dd8c2e4314e..f400a6122b3c 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -179,11 +179,10 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 	case EVM_IMA_XATTR_DIGSIG:
 		sig = (typeof(sig))xattr_value;
 		if (sig->version != 2 || xattr_len <= sizeof(*sig))
 			return ima_hash_algo;
 		return sig->hash_algo;
-		break;
 	case IMA_XATTR_DIGEST_NG:
 		/* first byte contains algorithm id */
 		ret = xattr_value->data[0];
 		if (ret < HASH_ALGO__LAST)
 			return ret;
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index b9fe02e5f84f..eddc9477d42a 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -899,11 +899,10 @@ static int datablob_parse(char *datablob, struct trusted_key_payload *p,
 			return ret;
 		ret = Opt_update;
 		break;
 	case Opt_err:
 		return -EINVAL;
-		break;
 	}
 	return ret;
 }
 
 static struct trusted_key_options *trusted_options_alloc(void)
diff --git a/security/safesetid/lsm.c b/security/safesetid/lsm.c
index 8a176b6adbe5..1079c6d54784 100644
--- a/security/safesetid/lsm.c
+++ b/security/safesetid/lsm.c
@@ -123,11 +123,10 @@ static int safesetid_security_capable(const struct cred *cred,
 		 * set*uid() (e.g. setting up userns uid mappings).
 		 */
 		pr_warn("Operation requires CAP_SETUID, which is not available to UID %u for operations besides approved set*uid transitions\n",
 			__kuid_val(cred->uid));
 		return -EPERM;
-		break;
 	case CAP_SETGID:
 		/*
 		* If no policy applies to this task, allow the use of CAP_SETGID for
 		* other purposes.
 		*/
@@ -138,15 +137,13 @@ static int safesetid_security_capable(const struct cred *cred,
 		 * set*gid() (e.g. setting up userns gid mappings).
 		 */
 		pr_warn("Operation requires CAP_SETGID, which is not available to GID %u for operations besides approved set*gid transitions\n",
 			__kuid_val(cred->uid));
 		return -EPERM;
-		break;
 	default:
 		/* Error, the only capabilities were checking for is CAP_SETUID/GID */
 		return 0;
-		break;
 	}
 	return 0;
 }
 
 /*
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 869af8a32c98..4eabece4dcba 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -466,11 +466,10 @@ static int snd_rme32_capture_getrate(struct rme32 * rme32, int *is_adat)
 			return 44100;
 		case 7:
 			return 32000;
 		default:
 			return -1;
-			break;
 		} 
 	else
 		switch (n) {	/* supporting the CS8412 */
 		case 0:
 			return -1;
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 4a1f576dd9cf..3382c069fd3d 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -2284,11 +2284,10 @@ static int hdspm_get_wc_sample_rate(struct hdspm *hdspm)
 	switch (hdspm->io_type) {
 	case RayDAT:
 	case AIO:
 		status = hdspm_read(hdspm, HDSPM_RD_STATUS_1);
 		return (status >> 16) & 0xF;
-		break;
 	case AES32:
 		status = hdspm_read(hdspm, HDSPM_statusRegister);
 		return (status >> HDSPM_AES32_wcFreq_bit) & 0xF;
 	default:
 		break;
@@ -2310,11 +2309,10 @@ static int hdspm_get_tco_sample_rate(struct hdspm *hdspm)
 		switch (hdspm->io_type) {
 		case RayDAT:
 		case AIO:
 			status = hdspm_read(hdspm, HDSPM_RD_STATUS_1);
 			return (status >> 20) & 0xF;
-			break;
 		case AES32:
 			status = hdspm_read(hdspm, HDSPM_statusRegister);
 			return (status >> 1) & 0xF;
 		default:
 			break;
@@ -2336,11 +2334,10 @@ static int hdspm_get_sync_in_sample_rate(struct hdspm *hdspm)
 		switch (hdspm->io_type) {
 		case RayDAT:
 		case AIO:
 			status = hdspm_read(hdspm, HDSPM_RD_STATUS_2);
 			return (status >> 12) & 0xF;
-			break;
 		default:
 			break;
 		}
 	}
 
@@ -2356,11 +2353,10 @@ static int hdspm_get_aes_sample_rate(struct hdspm *hdspm, int index)
 
 	switch (hdspm->io_type) {
 	case AES32:
 		timecode = hdspm_read(hdspm, HDSPM_timecodeRegister);
 		return (timecode >> (4*index)) & 0xF;
-		break;
 	default:
 		break;
 	}
 	return 0;
 }
@@ -3843,22 +3839,20 @@ static int hdspm_wc_sync_check(struct hdspm *hdspm)
 				return 2;
 			else
 				return 1;
 		}
 		return 0;
-		break;
 
 	case MADI:
 		status2 = hdspm_read(hdspm, HDSPM_statusRegister2);
 		if (status2 & HDSPM_wcLock) {
 			if (status2 & HDSPM_wcSync)
 				return 2;
 			else
 				return 1;
 		}
 		return 0;
-		break;
 
 	case RayDAT:
 	case AIO:
 		status = hdspm_read(hdspm, HDSPM_statusRegister);
 
@@ -3866,12 +3860,10 @@ static int hdspm_wc_sync_check(struct hdspm *hdspm)
 			return 2;
 		else if (status & 0x1000000)
 			return 1;
 		return 0;
 
-		break;
-
 	case MADIface:
 		break;
 	}
 
 
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 7ab10028d9fa..012fbec5e6a7 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -730,38 +730,31 @@ static inline int rme9652_spdif_sample_rate(struct snd_rme9652 *s)
 	rate_bits = rme9652_read(s, RME9652_status_register) & RME9652_F;
 
 	switch (rme9652_decode_spdif_rate(rate_bits)) {
 	case 0x7:
 		return 32000;
-		break;
 
 	case 0x6:
 		return 44100;
-		break;
 
 	case 0x5:
 		return 48000;
-		break;
 
 	case 0x4:
 		return 88200;
-		break;
 
 	case 0x3:
 		return 96000;
-		break;
 
 	case 0x0:
 		return 64000;
-		break;
 
 	default:
 		dev_err(s->card->dev,
 			"%s: unknown S/PDIF input rate (bits = 0x%x)\n",
 			   s->card_name, rate_bits);
 		return 0;
-		break;
 	}
 }
 
 /*-----------------------------------------------------------------------------
   Control Interface
diff --git a/sound/soc/codecs/wcd-clsh-v2.c b/sound/soc/codecs/wcd-clsh-v2.c
index 1be82113c59a..817d8259758c 100644
--- a/sound/soc/codecs/wcd-clsh-v2.c
+++ b/sound/soc/codecs/wcd-clsh-v2.c
@@ -478,11 +478,10 @@ static int _wcd_clsh_ctrl_set_state(struct wcd_clsh_ctrl *ctrl, int req_state,
 		wcd_clsh_state_hph_l(ctrl, req_state, is_enable, mode);
 		break;
 	case WCD_CLSH_STATE_HPHR:
 		wcd_clsh_state_hph_r(ctrl, req_state, is_enable, mode);
 		break;
-		break;
 	case WCD_CLSH_STATE_LO:
 		wcd_clsh_state_lo(ctrl, req_state, is_enable, mode);
 		break;
 	default:
 		break;
diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
index c56b9329240f..d8ced4559bf2 100644
--- a/sound/soc/codecs/wl1273.c
+++ b/sound/soc/codecs/wl1273.c
@@ -309,11 +309,10 @@ static int wl1273_startup(struct snd_pcm_substream *substream,
 			return -EINVAL;
 		}
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	return 0;
 }
 
diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index bbe8d782e0af..b1ca64d2f7ea 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -500,11 +500,10 @@ static int skl_pcm_trigger(struct snd_pcm_substream *substream, int cmd,
 		 */
 		ret = skl_decoupled_trigger(substream, cmd);
 		if (ret < 0)
 			return ret;
 		return skl_run_pipe(skl, mconfig->pipe);
-		break;
 
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
 		/*
diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index a6b72ad53b43..2d85cc4c67fb 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -2383,11 +2383,10 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "No DMA controller found (%d)\n", ret);
 	case -EPROBE_DEFER:
 		goto err;
-		break;
 	}
 
 	if (ret) {
 		dev_err(&pdev->dev, "register PCM failed: %d\n", ret);
 		goto err;

