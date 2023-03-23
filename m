Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2146C7160
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCWTyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjCWTyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:54:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB9812067
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 12:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679601283; x=1711137283;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=59AeoYWKu3WBzRu11WGPkb0OXyggVBDKdJlRPPT6Xjw=;
  b=duZpH3iytPOFMccGyCkNhk+VKGgNhslN1buUqq3Ne9gfwNLAW3w8Pdxk
   zvJVbKFIpxdE9LEO24b038Uk8VDbuGoV9C/OpSgjOIqflFKs+waOyk3H2
   LWABvBxCa04KbxI54DFTTCS+XiakFMRcHhEWbGZ2scYfWqczdvZFKqtkF
   dP/dw+5cv+m6F4tGUEbqkW7L3I6E0WbO9F5rl0BgJZAe3gPlcO1KcpX8S
   jBM7UpFiEnK9J/q1B//Vx4JGgo8TkxTjFG88zQUw5/5m4ppjg/ivDnAJv
   Ay/yiD8SVLYEZBxcWkJo2U6CzyYLZsXoHJSaMj9roFKhfFO9mf3Qd80Yo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="319995154"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="319995154"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 12:54:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="1011973965"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="1011973965"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 12:54:43 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ethtool-next v1] ethtool: remove ixgb support
Date:   Thu, 23 Mar 2023 12:54:24 -0700
Message-Id: <20230323195424.1623401-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ixgb driver is no longer in use so just remove the associated code.
The product was discontinued in 2010.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Makefile.am |   2 +-
 ethtool.c   |   2 -
 internal.h  |   2 -
 ixgb.c      | 147 ----------------------------------------------------
 4 files changed, 1 insertion(+), 152 deletions(-)
 delete mode 100644 ixgb.c

diff --git a/Makefile.am b/Makefile.am
index c83cb18173db..5f220bf8bf2e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,7 @@ ethtool_SOURCES = ethtool.c uapi/linux/ethtool.h internal.h \
 if ETHTOOL_ENABLE_PRETTY_DUMP
 ethtool_SOURCES += \
 		  amd8111e.c de2104x.c dsa.c e100.c e1000.c et131x.c igb.c	\
-		  fec.c fec_8xx.c fsl_enetc.c ibm_emac.c ixgb.c ixgbe.c \
+		  fec.c fec_8xx.c fsl_enetc.c ibm_emac.c ixgbe.c \
 		  natsemi.c pcnet32.c realtek.c tg3.c marvell.c vioc.c \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
diff --git a/ethtool.c b/ethtool.c
index 6022a6ecabc0..171482b71584 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -11,7 +11,6 @@
  * ETHTOOL_PHYS_ID support by Chris Leech <christopher.leech@intel.com>
  * e1000 support by Scott Feldman <scott.feldman@intel.com>
  * e100 support by Wen Tao <wen-hwa.tao@intel.com>
- * ixgb support by Nicholas Nunley <Nicholas.d.nunley@intel.com>
  * amd8111e support by Reeja John <reeja.john@amd.com>
  * long arguments by Andi Kleen.
  * SMSC LAN911x support by Steve Glendinning <steve.glendinning@smsc.com>
@@ -1134,7 +1133,6 @@ static const struct {
 	{ "e1000", e1000_dump_regs },
 	{ "e1000e", e1000_dump_regs },
 	{ "igb", igb_dump_regs },
-	{ "ixgb", ixgb_dump_regs },
 	{ "ixgbe", ixgbe_dump_regs },
 	{ "ixgbevf", ixgbevf_dump_regs },
 	{ "natsemi", natsemi_dump_regs },
diff --git a/internal.h b/internal.h
index 3923719c39d5..5336858b457e 100644
--- a/internal.h
+++ b/internal.h
@@ -332,8 +332,6 @@ int fec_8xx_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 int ibm_emac_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
 /* Intel(R) PRO/10GBe Gigabit Adapter Family */
-int ixgb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
-
 int ixgbe_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
 int ixgbevf_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
diff --git a/ixgb.c b/ixgb.c
deleted file mode 100644
index 8aec9a9d2258..000000000000
--- a/ixgb.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/* Copyright (c) 2006 Intel Corporation */
-#include <stdio.h>
-#include "internal.h"
-
-/* CTRL0 Bit Masks */
-#define IXGB_CTRL0_LRST           0x00000008
-#define IXGB_CTRL0_VME            0x40000000
-
-/* STATUS Bit Masks */
-#define IXGB_STATUS_LU            0x00000002
-#define IXGB_STATUS_BUS64         0x00001000
-#define IXGB_STATUS_PCIX_MODE     0x00002000
-#define IXGB_STATUS_PCIX_SPD_100  0x00004000
-#define IXGB_STATUS_PCIX_SPD_133  0x00008000
-
-/* RCTL Bit Masks */
-#define IXGB_RCTL_RXEN            0x00000002
-#define IXGB_RCTL_SBP             0x00000004
-#define IXGB_RCTL_UPE             0x00000008
-#define IXGB_RCTL_MPE             0x00000010
-#define IXGB_RCTL_RDMTS_MASK      0x00000300
-#define IXGB_RCTL_RDMTS_1_2       0x00000000
-#define IXGB_RCTL_RDMTS_1_4       0x00000100
-#define IXGB_RCTL_RDMTS_1_8       0x00000200
-#define IXGB_RCTL_BAM             0x00008000
-#define IXGB_RCTL_BSIZE_MASK      0x00030000
-#define IXGB_RCTL_BSIZE_4096      0x00010000
-#define IXGB_RCTL_BSIZE_8192      0x00020000
-#define IXGB_RCTL_BSIZE_16384     0x00030000
-#define IXGB_RCTL_VFE             0x00040000
-#define IXGB_RCTL_CFIEN           0x00080000
-
-/* TCTL Bit Masks */
-#define IXGB_TCTL_TXEN            0x00000002
-
-/* RAH Bit Masks */
-#define IXGB_RAH_ASEL_DEST        0x00000000
-#define IXGB_RAH_ASEL_SRC         0x00010000
-#define IXGB_RAH_AV               0x80000000
-
-int ixgb_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
-		   struct ethtool_regs *regs)
-{
-	u32 *regs_buff = (u32 *)regs->data;
-	u8 version = (u8)(regs->version >> 24);
-	u32 reg;
-
-	if (version != 1)
-		return -1;
-	fprintf(stdout, "MAC Registers\n");
-	fprintf(stdout, "-------------\n");
-
-	/* Device control register */
-	reg = regs_buff[0];
-	fprintf(stdout,
-		"0x00000: CTRL0 (Device control register) 0x%08X\n"
-		"      Link reset:                        %s\n"
-		"      VLAN mode:                         %s\n",
-		reg,
-		reg & IXGB_CTRL0_LRST   ? "reset"    : "normal",
-		reg & IXGB_CTRL0_VME    ? "enabled"  : "disabled");
-
-	/* Device status register */
-	reg = regs_buff[2];
-	fprintf(stdout,
-		"0x00010: STATUS (Device status register) 0x%08X\n"
-		"      Link up:                           %s\n"
-		"      Bus type:                          %s\n"
-		"      Bus speed:                         %s\n"
-		"      Bus width:                         %s\n",
-		reg,
-		(reg & IXGB_STATUS_LU)        ? "link config" : "no link config",
-		(reg & IXGB_STATUS_PCIX_MODE) ? "PCI-X" : "PCI",
-			((reg & IXGB_STATUS_PCIX_SPD_133) ? "133MHz" :
-			(reg & IXGB_STATUS_PCIX_SPD_100) ? "100MHz" :
-			"66MHz"),
-		(reg & IXGB_STATUS_BUS64) ? "64-bit" : "32-bit");
-	/* Receive control register */
-	reg = regs_buff[9];
-	fprintf(stdout,
-		"0x00100: RCTL (Receive control register) 0x%08X\n"
-		"      Receiver:                          %s\n"
-		"      Store bad packets:                 %s\n"
-		"      Unicast promiscuous:               %s\n"
-		"      Multicast promiscuous:             %s\n"
-		"      Descriptor minimum threshold size: %s\n"
-		"      Broadcast accept mode:             %s\n"
-		"      VLAN filter:                       %s\n"
-		"      Cononical form indicator:          %s\n",
-		reg,
-		reg & IXGB_RCTL_RXEN    ? "enabled"  : "disabled",
-		reg & IXGB_RCTL_SBP     ? "enabled"  : "disabled",
-		reg & IXGB_RCTL_UPE     ? "enabled"  : "disabled",
-		reg & IXGB_RCTL_MPE     ? "enabled"  : "disabled",
-		(reg & IXGB_RCTL_RDMTS_MASK) == IXGB_RCTL_RDMTS_1_2 ? "1/2" :
-		(reg & IXGB_RCTL_RDMTS_MASK) == IXGB_RCTL_RDMTS_1_4 ? "1/4" :
-		(reg & IXGB_RCTL_RDMTS_MASK) == IXGB_RCTL_RDMTS_1_8 ? "1/8" :
-		"reserved",
-		reg & IXGB_RCTL_BAM     ? "accept"   : "ignore",
-		reg & IXGB_RCTL_VFE     ? "enabled"  : "disabled",
-		reg & IXGB_RCTL_CFIEN   ? "enabled"  : "disabled");
-	fprintf(stdout,
-		"      Receive buffer size:               %s\n",
-		(reg & IXGB_RCTL_BSIZE_MASK) == IXGB_RCTL_BSIZE_16384 ? "16384" :
-		(reg & IXGB_RCTL_BSIZE_MASK) == IXGB_RCTL_BSIZE_8192 ? "8192" :
-		(reg & IXGB_RCTL_BSIZE_MASK) == IXGB_RCTL_BSIZE_4096 ? "4096" :
-		"2048");
-
-	/* Receive descriptor registers */
-	fprintf(stdout,
-		"0x00120: RDLEN (Receive desc length)     0x%08X\n",
-		regs_buff[14]);
-	fprintf(stdout,
-		"0x00128: RDH   (Receive desc head)       0x%08X\n",
-		regs_buff[15]);
-	fprintf(stdout,
-		"0x00130: RDT   (Receive desc tail)       0x%08X\n",
-		regs_buff[16]);
-	fprintf(stdout,
-		"0x00138: RDTR  (Receive delay timer)     0x%08X\n",
-		regs_buff[17]);
-
-	/* Transmit control register */
-	reg = regs_buff[53];
-	fprintf(stdout,
-		"0x00600: TCTL (Transmit ctrl register)   0x%08X\n"
-		"      Transmitter:                       %s\n",
-		reg,
-		reg & IXGB_TCTL_TXEN      ? "enabled"  : "disabled");
-
-	/* Transmit descriptor registers */
-	fprintf(stdout,
-		"0x00610: TDLEN (Transmit desc length)    0x%08X\n",
-		regs_buff[56]);
-	fprintf(stdout,
-		"0x00618: TDH   (Transmit desc head)      0x%08X\n",
-		regs_buff[57]);
-	fprintf(stdout,
-		"0x00620: TDT   (Transmit desc tail)      0x%08X\n",
-		regs_buff[58]);
-	fprintf(stdout,
-		"0x00628: TIDV  (Transmit delay timer)    0x%08X\n",
-		regs_buff[59]);
-
-	return 0;
-}
-
-- 
2.31.1

