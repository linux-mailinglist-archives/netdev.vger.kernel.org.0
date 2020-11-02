Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8CA2A2929
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgKBLZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgKBLZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:25:01 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F5DC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:25:01 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k10so12799218wrw.13
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gRH/26yT2dAaI3IpvhAVivatnrNzkpcErFlaxyXb8UQ=;
        b=ltQ789qFyVUG0DnMpeIBcHyp11aLEjc0FGrAhnTv1HyvyDlz68ox27lpz56pRgP5dr
         GN24aKpcLw9GxLT5KfWn5X3E+MFEN5tC3rcIHc0HNIDR4+EfpVmTtLbhllceTVp63poY
         Dqra9dlmKW2qmU58r9knHxsIC3Y94KZYdfy5KdOpIj5y9x/a9Aa1kAEcKLlteVa+vaSC
         3NsmBenF7kWNadUuFK5ZCy5lkzBA4qf/aM6Y4LfQaCsQ5OwkFKgjsvwPFYxro/5B+K+5
         N+KcSjtJgHhF470t1KKy6b4S/WpsuH0o2UnpNtg/kZXZufZehfcd5F4dTCqKfuEzlAua
         XiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gRH/26yT2dAaI3IpvhAVivatnrNzkpcErFlaxyXb8UQ=;
        b=E/VahJ/YQh+UBTVjJpw0NO9SGDvdqEZz0c5aCtF7MSdcboFWZgHGLVZ6kNLexHX1mo
         sGIp45Q/3NowDHJdIwTUzWTF4xZXj2dKOu4P1ay3OE2xJxpdtzpZ9R6UEK9uOwxnZF75
         JBNfEayrPpoWzmloN5BO2yIkczzs5IWItnMgheqp7iGh6N1d/JksCvJ+3cGLzShtZOne
         1XGnCj+pWy+1sMD1G6/1TLsvvH6fGa3r1DI3D/BoFwi6PaUOOIxmFCtbJ8Xd8b8r+CbD
         ahR9YVhXKYkCgHhU/yIWyDAAQROpmDrZo+fQnV6whteAv8/YHzKnK5a+ZMGK9VEgFk6h
         c/2Q==
X-Gm-Message-State: AOAM530YVsSptEtANom6NI6Z31kqiw4bzvE/Tfmt6mADPALzgMvrzW1O
        Ddt4cw6x3l/lPuc8G4Q9u/f9aA==
X-Google-Smtp-Source: ABdhPJzXpYDQKVrtg+Ibi/ww9VFD58hlRbz6tBWOvtJTh5DP25hJe/aSaadr6oJQGj9TbU7z1I80bw==
X-Received: by 2002:a5d:534d:: with SMTP id t13mr18886940wrv.69.1604316299868;
        Mon, 02 Nov 2020 03:24:59 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:59 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 31/41] mwifiex: pcie: Remove a couple of unchecked 'ret's
Date:   Mon,  2 Nov 2020 11:24:00 +0000
Message-Id: <20201102112410.1049272-32-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/marvell/mwifiex/pcie.c: In function ‘mwifiex_pcie_remove’:
 drivers/net/wireless/marvell/mwifiex/pcie.c:432:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/marvell/mwifiex/pcie.c: In function ‘mwifiex_cleanup_pcie’:
 drivers/net/wireless/marvell/mwifiex/pcie.c:3142:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6a10ff0377a24..67e0247ebaa65 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -429,7 +429,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	struct mwifiex_private *priv;
 	const struct mwifiex_pcie_card_reg *reg;
 	u32 fw_status;
-	int ret;
 
 	card = pci_get_drvdata(pdev);
 
@@ -441,7 +440,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 
 	reg = card->pcie.reg;
 	if (reg)
-		ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
+		mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
 	else
 		fw_status = -1;
 
@@ -3139,12 +3138,11 @@ static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	int ret;
 	u32 fw_status;
 
 	cancel_work_sync(&card->work);
 
-	ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
+	mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
 	if (fw_status == FIRMWARE_READY_PCIE) {
 		mwifiex_dbg(adapter, INFO,
 			    "Clearing driver ready signature\n");
-- 
2.25.1

