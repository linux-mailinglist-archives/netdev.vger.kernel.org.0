Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CB121DDED
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgGMQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbgGMQzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:55:13 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAE8C061755;
        Mon, 13 Jul 2020 09:55:13 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so14266940edb.11;
        Mon, 13 Jul 2020 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=236yoLO9rvFi7kFEaDT+jdNhQShh5zAyQTJD1cMNwbc=;
        b=qmI/dKkuGKWs1uJ/X+ORo2j9ZYWZLY//kGgOrJqvN0aGQHXouo9YDB4nmjhqfGS5HE
         w7TNx7OdD/HGeRKuN/8SUJOm/BYKXqm/oPoQDqXcvJrWQQCyGA2M16n9RvjaO+kfo7Mg
         vPGH++wf3L1TXs1DHBmVvhPRFmAFDdsoJZz6BPqAbYRpQDk9aHt20GC2FxkITx2TVBCA
         /2Y2Iz0OfTDCHMcXstLS1S96GW8SIkIfj0gVI9DD0VKL3DMNUdWO27amm2BoqL3uFH94
         RSyexOquu8pAfOIGi1x4GhBae9z3c/MauTBf+xMYA5e8tncOHKWz9HEGhtvQN9D/oJAv
         PCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=236yoLO9rvFi7kFEaDT+jdNhQShh5zAyQTJD1cMNwbc=;
        b=TxkC1ukwDOApE2S2zSNAlLVBssK1iMxDwsmR8n56YSVuuLmSR5EcJSVC5qJK+NIF3R
         udrW2SfNJLlvZrUkFThu496iGsyvyUBL4pOF542QNqj46Ct8/fstw3MzBRQqaZXH9B+9
         EOUVDbHh9ggUJjuqhOgCXYPCYkgLqTlMUDEBsiXdjaU9jifaCQ3khQa84Ofa1c4Lfy30
         hoyPSXHeBXm2DfSyatAWyXXpyhMhgPPcI3oEzhJ1Pb5wuashdAMFK95ttV6qr+P0kIWy
         qodRFTpgUZfhgVD4HAIasHW/N7pK93okn84ulTyRp7YeZtESnbvTjXgCjYuxhdE901gU
         wsUA==
X-Gm-Message-State: AOAM533MSAyoWMqgYIsN5fi/seFiB4/Qsmv2p/oqhV6N3w/NX3gWXyRn
        y2Tg7Yf/xC3CDjOFhK9Ttws=
X-Google-Smtp-Source: ABdhPJzS8bGidfvYhEBX+Vxk3kFa37roPQ//u7I4H6NbrGfX2t/Lv7uDWvR+9xa8wn77M37ExBUJqw==
X-Received: by 2002:a05:6402:b9b:: with SMTP id cf27mr368195edb.84.1594659312267;
        Mon, 13 Jul 2020 09:55:12 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id w3sm11838938edq.65.2020.07.13.09.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:55:11 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     skhan@linuxfoundation.org, linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Bolarinwa Olayemi Saheed <refactormyself@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 3/14 v3] ath9k: Check the return value of pcie_capability_read_*()
Date:   Mon, 13 Jul 2020 19:55:26 +0200
Message-Id: <20200713175529.29715-2-refactormyself@gmail.com>
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
 drivers/net/wireless/ath/ath9k/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index f3461b193c7a..cff9af3af38d 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -825,6 +825,7 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	struct pci_dev *parent;
 	u16 aspm;
+	int ret;
 
 	if (!ah->is_pciexpress)
 		return;
@@ -866,8 +867,8 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	if (AR_SREV_9462(ah))
 		pci_read_config_dword(pdev, 0x70c, &ah->config.aspm_l1_fix);
 
-	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
-	if (aspm & (PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1)) {
+	ret = pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
+	if (!ret && (aspm & (PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1))) {
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
 		ath9k_hw_configpcipowersave(ah, false);
-- 
2.18.2

