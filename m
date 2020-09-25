Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B031279420
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgIYWZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgIYWZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:03 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A68C0613D5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so218788pjb.0
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jmTFoZ5nOIect56+iNWMt+NdDBec3iDrAHMLNIdLP7U=;
        b=LnyaJYB4PM74e71DGuPy+9I3RH6KMsZW2pdlfN9D6esb+S7mgAi2fgOcaZxPP/JA0P
         OBzyYQwJao3B05JwZAeDFVO9ruIY/o7SBvdeQZpGdDPtal55otdYPzzm56svp5lVTZCs
         fem1OEr+AVQ7z8KPsBKGzfIe4hLIXlUfJJbPToNzfMPcpT3AC35kFfvYKHQ+1yBhm18j
         UjRBSATASzURXGJW9zhY1Od0XsgAH3d78v/eFkDhK22u+VXqcdUhv38kUFJoz5TUC92/
         0EazYU9tQR8B8RnH6oWrsAF4w6gaAhaRS9hxzD44MVErn2pwNLQlWpFQauy+qAC1VFAu
         a6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jmTFoZ5nOIect56+iNWMt+NdDBec3iDrAHMLNIdLP7U=;
        b=KLLhSm3yjRw9Rir8eZtsHNtZ96yuVlzAnVFzVKraOzYNFJzZc7x/wCrt8isEfyNDeJ
         /DrYBvbHhblU5RcHvjDuZsCO3+Uj4/Rz6DHD0flkn9utaSpXVFiu7zTd/JTbQHxZXYgj
         DT52K+XgDvq0Wkem8xRKnFcfEdHDXJ12xTj0zvWLSKr5KOqnH4Ii2dYvXVAVbLu8LsBw
         L42YzHM5QdrSmleXtfYCWFaID57XSq6KW2qeZdxiLt/jVzwc28QrMlqAXnYm1TTe2GSO
         JvjrYtFJvogz8PUl0QhrwERpfdSsvyF55CH5QwFcOycXi+wcHhrTMdpL6Y1yYwHetKMr
         ioKA==
X-Gm-Message-State: AOAM5321tRtHKP5HbVr3xdwN7RUexXA+xPjGimRP6h2wqLOQ7SbPHwUL
        akUHHzzevFOug2f3MGd3093j74W6uKWzWevv
X-Google-Smtp-Source: ABdhPJx3tp2IZEa0Sl+fF7JkL3zQp5nvzOMmU2LTVIO/uOQqnW4EKxQ+cmb4olmdbwsjUEy0yRRnbw==
X-Received: by 2002:a17:90a:14a4:: with SMTP id k33mr608162pja.236.1601072702847;
        Fri, 25 Sep 2020 15:25:02 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:01 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v3 4/9] drivers/net/ethernet: rid ethernet of no-prototype warnings
Date:   Fri, 25 Sep 2020 15:24:40 -0700
Message-Id: <20200925222445.74531-5-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The W=1 builds showed a few files exporting functions
(non-static) that were not prototyped. What actually happened is
that there were prototypes, but the include file was forgotten in
the implementation file.

Add the include file and remove the warnings.

Fixed Warnings:
drivers/net/ethernet/cavium/liquidio/cn68xx_device.c:124:5: warning: no previous prototype for ‘lio_setup_cn68xx_octeon_device’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:159:1: warning: no previous prototype for ‘octeon_pci_read_core_mem’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:168:1: warning: no previous prototype for ‘octeon_pci_write_core_mem’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:176:5: warning: no previous prototype for ‘octeon_read_device_mem64’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:185:5: warning: no previous prototype for ‘octeon_read_device_mem32’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:194:6: warning: no previous prototype for ‘octeon_write_device_mem32’ [-Wmissing-prototypes]
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c:453:6: warning: no previous prototype for ‘hclge_dcb_ops_set’ [-Wmissing-prototypes]

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v3: add warnings detail
v2: first non-rfc version

Full list of warnings:
drivers/net/ethernet/cavium/liquidio/cn68xx_device.c:124:5: warning: no previous prototype for ‘lio_setup_cn68xx_octeon_device’ [-Wmissing-prototypes]
  124 | int lio_setup_cn68xx_octeon_device(struct octeon_device *oct)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:159:1: warning: no previous prototype for ‘octeon_pci_read_core_mem’ [-Wmissing-prototypes]
  159 | octeon_pci_read_core_mem(struct octeon_device *oct,
      | ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:168:1: warning: no previous prototype for ‘octeon_pci_write_core_mem’ [-Wmissing-prototypes]
  168 | octeon_pci_write_core_mem(struct octeon_device *oct,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:176:5: warning: no previous prototype for ‘octeon_read_device_mem64’ [-Wmissing-prototypes]
  176 | u64 octeon_read_device_mem64(struct octeon_device *oct, u64 coreaddr)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:185:5: warning: no previous prototype for ‘octeon_read_device_mem32’ [-Wmissing-prototypes]
  185 | u32 octeon_read_device_mem32(struct octeon_device *oct, u64 coreaddr)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:194:6: warning: no previous prototype for ‘octeon_write_device_mem32’ [-Wmissing-prototypes]
  194 | void octeon_write_device_mem32(struct octeon_device *oct, u64 coreaddr,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c:453:6: warning: no previous prototype for ‘hclge_dcb_ops_set’ [-Wmissing-prototypes]
  453 | void hclge_dcb_ops_set(struct hclge_dev *hdev)
      |      ^~~~~~~~~~~~~~~~~
---
 drivers/net/ethernet/cavium/liquidio/cn68xx_device.c   | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
index cd5d5d6e7e5e..2a6d1cadac9e 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
@@ -25,6 +25,7 @@
 #include "octeon_main.h"
 #include "cn66xx_regs.h"
 #include "cn66xx_device.h"
+#include "cn68xx_device.h"
 #include "cn68xx_regs.h"
 #include "cn68xx_device.h"
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index f990f6915226..3606240025a8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -4,6 +4,7 @@
 #include "hclge_main.h"
 #include "hclge_dcb.h"
 #include "hclge_tm.h"
+#include "hclge_dcb.h"
 #include "hnae3.h"
 
 #define BW_PERCENT	100
-- 
2.25.4

