Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6B8320FEC
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 05:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBVEBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 23:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBVEBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 23:01:03 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF0EC061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:00:23 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id l16so1806155oti.12
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5jIWv0u/h+FrMMOIfXvwXHSiJidvB2uvWg+IEoiJkE=;
        b=M58Px5orX5sa0ekAkac9dTSAS3FDni8kEtoAECfPlUVtOCzAajbxV0DUD8Mw7NiotU
         vDu0/B4I+LsI/uPyS2OskP0RTzpbJeXOenfk9j2lqDBjd+aJeSW4R1C1WLd7ZCZcZjC0
         uKsSX2euKpZnvsgasRRc5L0oLEKprEMjbSiPsavzL0XgRnZR4SNvF4qPfWef+0jwoSig
         69LIXMfmYT83RfVsBGMuybzGeR1+j+3dLMxKlGea+4VSjPrhrq5KgQfgDFgOFlGMKFiV
         AeEMnQ0L6Gb8X/vmc1UBzQd5Zl19QeTRWVDjNYDUPuUrz8BeWT+g3TDST9gGbYXn7osa
         bnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5jIWv0u/h+FrMMOIfXvwXHSiJidvB2uvWg+IEoiJkE=;
        b=M4eAYHYtto3eWufW9fJso2culXZ/qX2/5Rj4IwEc1Pmt9/7IXahOCoNyM8PcZqswGB
         KJeM8Jkm8GxTDXCoKklKWtvNlyTA9wXbE0pb3Bu9s4qeL57X1eJjWioJUkZQmzd8bX7u
         0p9mbH0ffXlM96peWhdxdpc+VQU3qdRMgZg2ZrBIR+KqVAvkosra9TfJOd45iQ9CJdmz
         OoVnEAc0MQlh98q4nkCEvX28bOihmDwBNSj2hUdzbsSQlMBnNmzM4h0WdByJym6FJcmx
         DbGp92Z1K6ggSOcmf7m0PCXmdVGQ47YLStWOQSiYuEIxhSjufSDeDgtlJLKP5WIQMbsM
         IfjQ==
X-Gm-Message-State: AOAM533D3Qj8p1pBuXSJk4yRMcGfFAfbmoc4uMem+xHEU2E8AHlddcJo
        T+kszHScYyue6rXFVTXpK2ixrz9vSqDgJYWe
X-Google-Smtp-Source: ABdhPJzeYek00EABJJvfObC0rnsof0j4x0xOEp9BTT0GPsxltcyoiuXo9Te9HDLWRN9E1tfkHB7Nbg==
X-Received: by 2002:a9d:8b2:: with SMTP id 47mr7876942otf.24.1613966422518;
        Sun, 21 Feb 2021 20:00:22 -0800 (PST)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id t2sm3518066otj.47.2021.02.21.20.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 20:00:22 -0800 (PST)
From:   Tom Seewald <tseewald@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tseewald@gmail.com, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Garzik <jeff@garzik.org>,
        Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH net 2/2] igb: Fix duplicate include guard
Date:   Sun, 21 Feb 2021 22:00:05 -0600
Message-Id: <20210222040005.20126-2-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222040005.20126-1-tseewald@gmail.com>
References: <20210222040005.20126-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The include guard "_E1000_HW_H_" is used by two separate header files in
two different drivers (e1000/e1000_hw.h and igb/e1000_hw.h). Using the
same include guard macro in more than one header file may cause
unexpected behavior from the compiler. Fix this by renaming the
duplicate guard in the igb driver.

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/net/ethernet/intel/igb/e1000_hw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_hw.h b/drivers/net/ethernet/intel/igb/e1000_hw.h
index 5d87957b2627..44111f65afc7 100644
--- a/drivers/net/ethernet/intel/igb/e1000_hw.h
+++ b/drivers/net/ethernet/intel/igb/e1000_hw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2007 - 2018 Intel Corporation. */
 
-#ifndef _E1000_HW_H_
-#define _E1000_HW_H_
+#ifndef _E1000_IGB_HW_H_
+#define _E1000_IGB_HW_H_
 
 #include <linux/types.h>
 #include <linux/delay.h>
@@ -551,4 +551,4 @@ s32 igb_write_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value);
 
 void igb_read_pci_cfg(struct e1000_hw *hw, u32 reg, u16 *value);
 void igb_write_pci_cfg(struct e1000_hw *hw, u32 reg, u16 *value);
-#endif /* _E1000_HW_H_ */
+#endif /* _E1000_IGB_HW_H_ */
-- 
2.20.1

