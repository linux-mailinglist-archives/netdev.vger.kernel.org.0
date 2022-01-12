Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A1748BF86
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351423AbiALIIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351416AbiALIH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:07:59 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3A9C06173F;
        Wed, 12 Jan 2022 00:07:58 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id y10so2189243qtw.1;
        Wed, 12 Jan 2022 00:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o7CnV6Plc3m49ljVBNe22o8ETLLt2AJm3GJl7I66i/s=;
        b=O0yqbYatJJD8z/BiYzKVWgBzyr0pid5wIkdk1dyFYcP8ifFxYZR/XAeGt9UJFPJVG/
         0Btvo2y946ODVnYhxa5/nYlFTwYtasRmEM/XUQWCC6m/H9Xz85fhuejprChRaOTVNmUR
         ub7zZZHGN7J6azT4mDuBMRaAAimgoBXyOca4RvASW8mJKgtIkgX/Si3eH7AVVuZ+XJgU
         OlQz+/MYTA452bFxlWh+gr89cUGQEG5jv9KxRPOC8f4L+W5kwFEFf9/x3zVmgF1SS2FF
         qQsVnMtREDbuE0/TREWW+6qa78luB75F1kSjs4ETmUTELgv2ODLxviVu0lcdsvZyOcs/
         1RTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o7CnV6Plc3m49ljVBNe22o8ETLLt2AJm3GJl7I66i/s=;
        b=LBeXJ1sAYjZzp4Kl4R+KRaFA/n3PDMv/PQ18nWTfnMCS3FS2+APeJ2n7ReB9sqseA/
         Vl10O45WVKEZawJup5vFL2Zpv2Hqn60r+IP4Ubcq6gGqVcbiWgcgRlwzt9POVdqUDhEi
         fR/zXvKzjysnsWgPlD+uHtwORy1OpazUXT6MtoupP+I4urB5cUlBvOqRlqTW+bwltJzT
         cmn2VkAy1WS+pfoRj0p1udEfGEq9zTqKNArZP8s3gxfAJ8SkorezGrB/qqi0TGVRplz+
         5bU1M3PGenH+ioFgxSganiq+uq2Wy/JoTyC5Vc1u4Bwg1ohpHHvsBsULjxZ0Fvth5EY0
         RDMw==
X-Gm-Message-State: AOAM532NCbKFkjRjNbD4eQst4y1OV3TU1Lcw19j04MHAWlNB+vOAYppq
        bpFCB66gz7tF/9L0ULr6gdI=
X-Google-Smtp-Source: ABdhPJxmhU3/AkiZvPhIrkQ3K6bpl665AMfd0sAPJivqMASvyC/sRCf6fmUVzCtxKyrhtrUtOrJHlg==
X-Received: by 2002:a05:622a:1013:: with SMTP id d19mr6769175qte.151.1641974877992;
        Wed, 12 Jan 2022 00:07:57 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c17sm7736543qkl.90.2022.01.12.00.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 00:07:57 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] wireless/ath/ath9k: remove redundant status variable
Date:   Wed, 12 Jan 2022 08:07:51 +0000
Message-Id: <20220112080751.667316-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value directly instead of taking this in another redundant
variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index e6b3cd49ea18..efb7889142d4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -670,8 +670,6 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 
 int ath9k_hw_eeprom_init(struct ath_hw *ah)
 {
-	int status;
-
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ah->eep_ops = &eep_ar9300_ops;
 	else if (AR_SREV_9287(ah)) {
@@ -685,7 +683,5 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah)
 	if (!ah->eep_ops->fill_eeprom(ah))
 		return -EIO;
 
-	status = ah->eep_ops->check_eeprom(ah);
-
-	return status;
+	return ah->eep_ops->check_eeprom(ah);
 }
-- 
2.25.1

