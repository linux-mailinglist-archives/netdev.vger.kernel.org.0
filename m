Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEA9130D83
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 07:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgAFG0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 01:26:01 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:44081 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgAFG0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 01:26:01 -0500
Received: by mail-pf1-f181.google.com with SMTP id 195so25627792pfw.11
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 22:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=evzD0JK8LSn0ZimlzI9kK570jZJqixSLv6BagHOwVBY=;
        b=NKdUNnZTSI9nymd83D47gfZpXWe0OOhfLyoruQtT/TMSayYi32ZuRc7G6doc5Ls/sX
         NTQ1A8In7Jl31DVwmbpH2ODw1YUy9qw5TeCv9rqPDUqTQ+48vrIM6q2OA4fEIIrO8KYF
         5g3o4E9Lsdo+pktOokLErqtxctb2jO6OrcE6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=evzD0JK8LSn0ZimlzI9kK570jZJqixSLv6BagHOwVBY=;
        b=qP2MqnnkycJ1s6BF6nKiGY9EIdgI1dfUIinFRqpmq6OYb0r0zu3LvxPMfJH2v9HMkm
         /mYwE1XYTf3tFAZrZlIWnRK1clgohOeREhzWHvelK873HIG4DerF9z+BoT/zQN1WLxNQ
         oVsiCKY9FDIRqxo9v4Z+/jOwDtzOHOt9bq1dOfkqWixTVeecOSXpciARL6pdaBTxKnmc
         sKDfLL3WKlhCrhNfJlx2+O3wOFVlqjW+RKDcl0FbZ9E1TzfQShtoW06rpUVKVAwMfFEC
         ooN3GeHY8ndvIf84MzpGjr0lM/OPbKh6XPMvqHAnxTVx9dnkDOm/ZjeEoqn4X7TV7pgJ
         FSsg==
X-Gm-Message-State: APjAAAXeFSCDpXFYiHpVdIEEI+lrTuKMeRE2SdklQbrRKyWKIEGePx25
        x45E3jHiTgSEvdZQhSYVWJz9Jw==
X-Google-Smtp-Source: APXvYqyejuh87pzgwbSyfPS008rp+nddy4t59iTYRlyINoAQuexuQLkOxbUHjDxUEazEW7m0lfLpIA==
X-Received: by 2002:a63:cd16:: with SMTP id i22mr113351949pgg.239.1578291960493;
        Sun, 05 Jan 2020 22:26:00 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o16sm70704250pgl.58.2020.01.05.22.25.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 05 Jan 2020 22:25:59 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>
Cc:     vikram.prakash@broadcom.com, vasundhara-v.volam@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH v1] firmware: tee_bnxt: Fix multiple call to tee_client_close_context
Date:   Mon,  6 Jan 2020 11:54:02 +0530
Message-Id: <1578291843-27613-1-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix calling multiple tee_client_close_context in case of shm allocation
fails.

Fixes: 246880958ac9 (“firmware: broadcom: add OP-TEE based BNXT f/w manager”)
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/firmware/broadcom/tee_bnxt_fw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index 5b7ef89..ed10da5 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -215,7 +215,6 @@ static int tee_bnxt_fw_probe(struct device *dev)
 	fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
 				    TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
 	if (IS_ERR(fw_shm_pool)) {
-		tee_client_close_context(pvt_data.ctx);
 		dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
 		err = PTR_ERR(fw_shm_pool);
 		goto out_sess;
-- 
2.7.4

