Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A307C33A7B1
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 20:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhCNToU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 15:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbhCNTnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 15:43:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C164C061574;
        Sun, 14 Mar 2021 12:43:51 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so1410857wma.0;
        Sun, 14 Mar 2021 12:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sZwayokeza50r+JZ/406W906zpF/PAEcZt2TCtDizn4=;
        b=qivqOWhHjy5ePOaGgVAlMt8HU2tt9CgqgMshvYwu5MH/fA2hIZQ7QR8Ypwcs3oWqJa
         szJf5p1cczM+zvTkP/MLm59hnqrov/+Ogl9kQBBQXAMPk/Uq4Lyv1Ng6T7XDyEqxRcd1
         guyPV902DYUePxGUuwSNo9NMuPeqJReNpbDlvKElUDlaENHxhBbTFsmKXdTScUC0VnjV
         wGVLIg0vQ4rjMHrwhrk0MEPRsQXP3GOABYKwAn1/a8NTEGcJ4UiByeKxJbTsAKlswaP0
         P2LOqWQxEwQ1nHnM0bH+bAt+6IA8DK2RtQgW/1B/dzU80duAr92fKy2cGzx6yMe8ohba
         MWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sZwayokeza50r+JZ/406W906zpF/PAEcZt2TCtDizn4=;
        b=bsxBce5zMvs0vMLTxR/5MVUL95WnppgRCe4M18+5UsY3ByQLUJuCSdZKlw88zdDhVi
         lTcBL6A2CRXm9ZMZdRncSbgjKYhXR6j8rF6m2/EqW6YuLKwnX16hPAYUFTAagkuQJRo4
         2h6xv7UAvyJFo5MrVsb+M7SFjmAg6unxSdt5CDlgxJh82aIvsquJucvmHD+dCSbVq9pa
         Wk5wnboEHiWvDeVSh/9IM8VaEbqIpEHnuPs1H0LK3Hr4JPLaOxHgpknT8EbjW97r3P8U
         ALoZfnubo2s/3iTCX0txacc1Je89PpDV37pikKY0phjOWFRlUagzl0lLI7mj5KbLcMya
         9seA==
X-Gm-Message-State: AOAM532HoaNZZp2ZEhDP0QjgaOkWQq47aSbTv+TaAnqp7VZlaJkNfPtj
        okb0LC6bwE76DCQA8OBzYDqgGsskHVcp1Q==
X-Google-Smtp-Source: ABdhPJwzbLtgq9RvmSPAkCvx8N3WccZ+V2MPDB1FczL6B0jAHejqqtA3Qr500ythKAwQAe+tIX0CCg==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr17543013wmc.179.1615751029604;
        Sun, 14 Mar 2021 12:43:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fc04:867f:ef73:99ed? (p200300ea8f1fbb00fc04867fef7399ed.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fc04:867f:ef73:99ed])
        by smtp.googlemail.com with ESMTPSA id s18sm18505144wrr.27.2021.03.14.12.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 12:43:49 -0700 (PDT)
Subject: [PATCH net-next 3/3] iwlwifi: use dma_set_mask_and_coherent
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <22e63925-1469-2839-e4d3-c10d8658ba82@gmail.com>
Message-ID: <26a13b6e-6fa8-6e34-1e08-37c9fd8e398f@gmail.com>
Date:   Sun, 14 Mar 2021 20:43:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <22e63925-1469-2839-e4d3-c10d8658ba82@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code by using dma_set_mask_and_coherent().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 1bf4c37fe..4fd391dda 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3440,15 +3440,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	addr_size = trans->txqs.tfd.addr_size;
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(addr_size));
-	if (!ret)
-		ret = pci_set_consistent_dma_mask(pdev,
-						  DMA_BIT_MASK(addr_size));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_size));
 	if (ret) {
-		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (!ret)
-			ret = pci_set_consistent_dma_mask(pdev,
-							  DMA_BIT_MASK(32));
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (ret) {
 			dev_err(&pdev->dev, "No suitable DMA available\n");
-- 
2.30.2


