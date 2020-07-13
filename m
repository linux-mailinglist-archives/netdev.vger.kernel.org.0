Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052C221DDF5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgGMQza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbgGMQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:55:15 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7B7C061755;
        Mon, 13 Jul 2020 09:55:14 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so14289441edb.3;
        Mon, 13 Jul 2020 09:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e583Pj41mbGa0akKyeW2rYwc3SOFBc4BRiRYVhykVn0=;
        b=NSPewnin+umq+Hpw1VWQZYiIMe8GpYsUXwfzptgWDWoPiRg5JdRkQnTxGPG5XIcKLi
         UUpNEzCE0J/2F+81HVw1NIlylHNjNmYp+qtI8ey59l45x6EqCxhfqzxJLFlE3ViR3tt4
         zBgFSTsenkoT784l1whYtML/oIG5HU9WWWJbol4bUzzLcgUnuK4xRLw49BMrPrYf1CkA
         Jn3hbTiIT1KUEph4CzyOnMiLetZlrOxRM6l/pkEpJA0NtPVqY/sMvCdJVyBd8cwBBf92
         GmQLYC2DxDBpG/6rydAcun+L5sogjQM9CykfTBM+Yux9ijI2LhF9iQWN1rXROIgt8JRC
         jKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e583Pj41mbGa0akKyeW2rYwc3SOFBc4BRiRYVhykVn0=;
        b=Y5T7XbmRbFhwcPiKkHZEXRJ5hFHruyYt9oNxePjN0BLA5s/rkQVkI7I/TdoXbK5UEz
         2Op5eeoGSecMFHbTq8LJDPY90kFj8MIO9hQs9tb6ngGSEe5+BVt21ys2tlDOXDd8CSpY
         nzSS8y30wQF1xtQ1euVsINiytnPxOkrZ7lWZdprawX5jasxmgvv8n0hBM0DDUV9K1t33
         4QHxRL0PvNPCd34GTA5OWIetD9Q91QwsFOSug24fVPNotiQgs4uxL2Ijyhcs246ftkKl
         xruh/U/PktLm8YkgQH9xN+sAh2+gCp09lW9HrX7SOfqDWfCKHroyAZ64dlzLydhSoTnD
         b17w==
X-Gm-Message-State: AOAM533dQ3qo8xg0uXSZJdQU5lRTWUkBGjlx13qHe/SLGlIZbHsWmbwz
        bIJ0joHUX7J56hR1MrEs6I4=
X-Google-Smtp-Source: ABdhPJzFuefoL/4Rxcgaj8jw3dS3fKhP7a3GskQbwngqBSIPoeJgKGthmRz4CpvHrLMQeri2oZC1DQ==
X-Received: by 2002:a05:6402:b86:: with SMTP id cf6mr358151edb.42.1594659313535;
        Mon, 13 Jul 2020 09:55:13 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id w3sm11838938edq.65.2020.07.13.09.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:55:13 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     skhan@linuxfoundation.org, linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Bolarinwa Olayemi Saheed <refactormyself@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4/14 v3] iwlegacy: Check the return value of pcie_capability_read_*()
Date:   Mon, 13 Jul 2020 19:55:27 +0200
Message-Id: <20200713175529.29715-3-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200713175529.29715-1-refactormyself@gmail.com>
References: <20200713175529.29715-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

On failure pcie_capability_read_dword() sets it's last parameter, val
to 0. However, with Patch 14/14, it is possible that val is set to ~0 on
failure. This would introduce a bug because (x & x) == (~0 & x).

This bug can be avoided without changing the function's behaviour if the
return value of pcie_capability_read_dword is checked to confirm success.

Check the return value of pcie_capability_read_dword() to ensure success.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 348c17ce72f5..f78e062df572 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4286,8 +4286,8 @@ il_apm_init(struct il_priv *il)
 	 *    power savings, even without L1.
 	 */
 	if (il->cfg->set_l0s) {
-		pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
-		if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
+		ret = pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
+		if (!ret && (lctl & PCI_EXP_LNKCTL_ASPM_L1)) {
 			/* L1-ASPM enabled; disable(!) L0S  */
 			il_set_bit(il, CSR_GIO_REG,
 				   CSR_GIO_REG_VAL_L0S_ENABLED);
-- 
2.18.2

