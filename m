Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EEC26F9F0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgIRKJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgIRKJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:09:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAE0C06174A;
        Fri, 18 Sep 2020 03:09:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z18so3152025pfg.0;
        Fri, 18 Sep 2020 03:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jfiDb6EK2PWCc1frSb4SNgzqiudKskJfy+Zs8z1Exug=;
        b=Z/5t6+BnQKWJoly+aFc/ZL+dCBVtjw0MAhMPGqCNzrRoqgD5Vk7xpih4VZXmM7wZMb
         b0ReS7iCm6yuIYN1xtcVRqo5bVQM1LfTnw8EVsrEfXdEf1mn7wHGHmKAsmCaLxZMV759
         ytKHpHMGemGIslOUA0zWvYllHXnB4fi5o3Z4YE4mHdCOZRT9EQyx2WAtku/euE9ffjj6
         SI6bKXW0x4qwLBbwemg2l23vhWu0QAjFD8cKnVOhyOsvO5RFVUkL0Q6/lw6BrejJrzcC
         oPtbwTwBebdKifjc/CKx/PEgpWef9/28JucOCmkmkHPPpjfYmXntk6UPJzWs0J3Yo8l/
         y+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jfiDb6EK2PWCc1frSb4SNgzqiudKskJfy+Zs8z1Exug=;
        b=A/nwQ1cmvRK8aSpK3CvcUhnPyU6VQootU+F1VndzQNnx6+cfop23fP2DAxxUsoC89d
         5TjOtaHrOSljh/+NrhYieo7wFwyGrjvgG4E/N9/ar95lbtEskwAa1iMHs00UJADq/egi
         R5GQ/q+oh6XVpgfT63abZc0nQFsRCO9VVzwmQTRQ/iswO6kbjts6e9K/GRojuwyt7nAU
         FHWHT1+MgEt9r0eFu/8dO25PR8W+WJriiJe2pSHnUiq3XmLSK5DMcH8AtFrEdomo9NK4
         o31RyX5FeFNUxsU92uogZSl3DbBvUAhEk5dmLadOiVjf5ITL1G3Lhmpz2vuOVjl10Ope
         CZ+g==
X-Gm-Message-State: AOAM533ZKB6togyXxAZLYnzTw2y8+LM6rXd/qiitdMjdaFNphZQipAVW
        wCHnGY2ZE2pEXqJy/z5UJCDa2MpqGS6Ba6VD
X-Google-Smtp-Source: ABdhPJwq7uaSg+QaFBWeZITPMzsbINQmVKeNRLp8aYabN/pPhmwwJn5KgIZfCaNL24cf1zGYdrNrAw==
X-Received: by 2002:a62:2985:0:b029:142:2501:34d6 with SMTP id p127-20020a6229850000b0290142250134d6mr15016980pfp.47.1600423791540;
        Fri, 18 Sep 2020 03:09:51 -0700 (PDT)
Received: from localhost.localdomain ([47.242.91.183])
        by smtp.gmail.com with ESMTPSA id l21sm2434434pjq.54.2020.09.18.03.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:09:51 -0700 (PDT)
From:   Herrington <hankinsea@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     leonro@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com
Subject: [PATCH v3] ptp: mark symbols static where possible
Date:   Fri, 18 Sep 2020 18:09:43 +0800
Message-Id: <20200918100943.1740-1-hankinsea@gmail.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We get 1 warning when building kernel with W=1:
drivers/ptp/ptp_pch.c:182:5: warning: no previous prototype for ‘pch_ch_control_read’ [-Wmissing-prototypes]
 u32 pch_ch_control_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:193:6: warning: no previous prototype for ‘pch_ch_control_write’ [-Wmissing-prototypes]
 void pch_ch_control_write(struct pci_dev *pdev, u32 val)
drivers/ptp/ptp_pch.c:201:5: warning: no previous prototype for ‘pch_ch_event_read’ [-Wmissing-prototypes]
 u32 pch_ch_event_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:212:6: warning: no previous prototype for ‘pch_ch_event_write’ [-Wmissing-prototypes]
 void pch_ch_event_write(struct pci_dev *pdev, u32 val)
drivers/ptp/ptp_pch.c:220:5: warning: no previous prototype for ‘pch_src_uuid_lo_read’ [-Wmissing-prototypes]
 u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:231:5: warning: no previous prototype for ‘pch_src_uuid_hi_read’ [-Wmissing-prototypes]
 u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:242:5: warning: no previous prototype for ‘pch_rx_snap_read’ [-Wmissing-prototypes]
 u64 pch_rx_snap_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:259:5: warning: no previous prototype for ‘pch_tx_snap_read’ [-Wmissing-prototypes]
 u64 pch_tx_snap_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:300:5: warning: no previous prototype for ‘pch_set_station_address’ [-Wmissing-prototypes]
 int pch_set_station_address(u8 *addr, struct pci_dev *pdev)

Signed-off-by: Herrington <hankinsea@gmail.com>
---
 drivers/ptp/ptp_pch.c            | 11 -----------
 include/linux/ptp_clock_kernel.h |  9 +++++++++
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index ce10ecd41ba0..f7ff7230623e 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -179,17 +179,6 @@ static inline void pch_block_reset(struct pch_dev *chip)
 	iowrite32(val, (&chip->regs->control));
 }
 
-u32 pch_ch_control_read(struct pci_dev *pdev)
-{
-	struct pch_dev *chip = pci_get_drvdata(pdev);
-	u32 val;
-
-	val = ioread32(&chip->regs->ch_control);
-
-	return val;
-}
-EXPORT_SYMBOL(pch_ch_control_read);
-
 void pch_ch_control_write(struct pci_dev *pdev, u32 val)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index d3e8ba5c7125..5db4b8891b22 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -307,4 +307,13 @@ static inline void ptp_read_system_postts(struct ptp_system_timestamp *sts)
 		ktime_get_real_ts64(&sts->post_ts);
 }
 
+void pch_ch_control_write(struct pci_dev *pdev, u32 val);
+u32 pch_ch_event_read(struct pci_dev *pdev);
+void pch_ch_event_write(struct pci_dev *pdev, u32 val);
+u32 pch_src_uuid_lo_read(struct pci_dev *pdev);
+u32 pch_src_uuid_hi_read(struct pci_dev *pdev);
+u64 pch_rx_snap_read(struct pci_dev *pdev);
+u64 pch_tx_snap_read(struct pci_dev *pdev);
+int pch_set_station_address(u8 *addr, struct pci_dev *pdev);
+
 #endif
-- 
2.18.1

