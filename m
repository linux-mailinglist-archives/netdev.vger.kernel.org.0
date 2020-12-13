Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615662D8C96
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 11:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391120AbgLMJ7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 04:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgLMJ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 04:59:31 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6923C0613CF;
        Sun, 13 Dec 2020 01:59:06 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id c12so9959234pgm.4;
        Sun, 13 Dec 2020 01:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GcYqAxa7HBVYr8n7CS85HqGq6N68fJds4hOplQbYKsg=;
        b=Vjwbz522pakplgONpLFHWgfZJ59AIzMmlDXrek+QZE2K98kDQhZJ8z7RTr2JX8/CK7
         fT4tUtVu6QJnK6dbgZ7ObF2g9H8NJWaYl9RN3DcfnkeYlawKKW/rPTe0WVOAh6DNyDPu
         ylOb0FowlyYviFan12yM2LVYVzZWn5t+d0CYRqoQ0AaKe8KWtom+TxDV+eufaOFhYzsR
         BlPLU8Hr8VAIMaE+mcEQheCA3dbb/Jv/P9QL8maQAs2x1DQpFi5VBM+e834LTAjiCEYM
         MHR5Uk7EoDPCuSwJKxTkAPGSTdfotKpoe05b0AwYjqEfGNzWNlF9NrFdc//xWayFBD7K
         oM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GcYqAxa7HBVYr8n7CS85HqGq6N68fJds4hOplQbYKsg=;
        b=CjnzJn8RnK/8lNB9LI6EOb0Akg2eG/w1BRQy49so+Y0AG1W64/XSvfDzgvlfuumACA
         ZmSV0L6c4YZNEybNSd+lXd79fXkgN4OXo9mrrBb9Qe2nBljd+nFBEmE+RbUwKfFrNPfo
         Z/fLpT2HWMmMDgOjqcrt00r6ATRcGYr2a/tj+GnxVxTZ8BBehFpuzBZppeZZ22WEIovR
         Q6DO4wlCYWeFu2IGxRfKl2BQxnK10bPnoXT8lqi34a3Pm6+O3EqccgDldASGyHHyVcum
         07gBGfvJ27fvPHoSH33Peofw79F/xYkX4kIaHQhpUFjHcOkaVzl0RTpaeL5s7+jYdTte
         /4aQ==
X-Gm-Message-State: AOAM531n2vvi64OZlv/5kDgoSjQZZERfoxLhtpeG+hf27H0INjB58XHg
        VDC84DdsEPk4k4U24kA0U+E=
X-Google-Smtp-Source: ABdhPJwE2chr88YKB9xmTS0NpoFNPDDbiETaYCL/vy1IZd/FodrArloKAP4/O04GMCErdBIgDvjECQ==
X-Received: by 2002:a63:6f4c:: with SMTP id k73mr19049038pgc.319.1607853546046;
        Sun, 13 Dec 2020 01:59:06 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id w73sm15805958pfd.203.2020.12.13.01.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 01:59:04 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] nfc: s3fwrn5: Release the nfc firmware
Date:   Sun, 13 Dec 2020 18:58:50 +0900
Message-Id: <20201213095850.28169-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

add the code to release the nfc firmware when the firmware image size is
wrong.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/firmware.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 4b5352e2b915..b70737b3070e 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -293,8 +293,10 @@ int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info)
 	if (ret < 0)
 		return ret;
 
-	if (fw->fw->size < S3FWRN5_FW_IMAGE_HEADER_SIZE)
+	if (fw->fw->size < S3FWRN5_FW_IMAGE_HEADER_SIZE) {
+		release_firmware(fw->fw);
 		return -EINVAL;
+	}
 
 	memcpy(fw->date, fw->fw->data + 0x00, 12);
 	fw->date[12] = '\0';
-- 
2.17.1

