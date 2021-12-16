Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A954F476B8F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhLPINH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbhLPINE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:13:04 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B32DC06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:04 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g19so23008128pfb.8
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1TchYC2sYvNDw2sG9vaLQfrSXPEIwDInNL253k++9l4=;
        b=bGBm2Wy/feTua+RHoRemV8rmgAZ2aW+ZytxgZkiBOjsEcETcoLCQP33QMVziyxSWpp
         AepkzMqupXFXnx0iY/qFCKB2ZTY3t/rrWpDO/K4I5JfVS/f3A1K8glTE+MnyDhE6aUlm
         gfC36BL3hN20M9kqNYnrdd/9sXRudOowNkPI1S5T5ST67zjrESE+wcckAi8TvdsdF/Yz
         vp+F2UnCXnUpeDtev6Ak7QafEUCkcW0tHvblYxplUxxfXCxP7/opgfN+ZypBj8mlBgMs
         hQwLQZE8RRb7GMjC4NQ+8goTPHCcyLF1/BJw/Uz3Yj3Xu+IQsEzJEByF0/SrRoodSRGV
         x/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1TchYC2sYvNDw2sG9vaLQfrSXPEIwDInNL253k++9l4=;
        b=vSGO0n/I6Fkd76sSRPpvXdc/OYgRguslJqL5VmmIbDYTes2GJ3wDDeqc1D5DE4AkKU
         1MKiiV4CdwprZRH0fTaCupyQqfdvzGi1/h6DFq9hytTSXX4cQv9PGBtLNjRsH9Hy1q9b
         nGkPt/kKdnNvaa3hFntb7SeI+lH0JLOBhwbzQrjRFaBpNP3mPZuCDQDoR4ixFdztvWwX
         kdIx/hIaJI9NQ8wAyvAU7PGj5JgoMa11GWgLYHYk6c79xveWzohxnVqeEzUpZh5VOT+P
         joPKBCb0mcNCHFCaZZI51acX8l1s9JYR5fFhaxCZbIEWDllvMkT8rDqmPF2Xw5dDrdwn
         Gglg==
X-Gm-Message-State: AOAM532Y6alGXdB1be4J5L7UHZrrY77Gg/soGlRoURe2cj1r9AComauQ
        Fj7iovTMSAD9ypzC6m7mp4Tj
X-Google-Smtp-Source: ABdhPJys1rR+Lt0muXfAPojG0n6xSytqNpvra5kWtXmE5nufJBcqoIjzfjNtN0rlljaH0GpF+myC3g==
X-Received: by 2002:a62:8c55:0:b0:49f:df22:c4ca with SMTP id m82-20020a628c55000000b0049fdf22c4camr12961488pfd.11.1639642383837;
        Thu, 16 Dec 2021 00:13:03 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:03 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 03/10] bus: mhi: core: Use macros for execution environment features
Date:   Thu, 16 Dec 2021 13:42:20 +0530
Message-Id: <20211216081227.237749-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

The implementation for execution environment specific functionality
is spread out. Use macros that help determine the paths to be taken.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1636409978-31847-1-git-send-email-quic_bbhatt@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/boot.c     | 2 +-
 drivers/bus/mhi/core/internal.h | 3 ++-
 drivers/bus/mhi/core/pm.c       | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/mhi/core/boot.c b/drivers/bus/mhi/core/boot.c
index 0a972620a403..74295d3cc662 100644
--- a/drivers/bus/mhi/core/boot.c
+++ b/drivers/bus/mhi/core/boot.c
@@ -417,7 +417,7 @@ void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl)
 	}
 
 	/* wait for ready on pass through or any other execution environment */
-	if (mhi_cntrl->ee != MHI_EE_EDL && mhi_cntrl->ee != MHI_EE_PBL)
+	if (!MHI_FW_LOAD_CAPABLE(mhi_cntrl->ee))
 		goto fw_load_ready_state;
 
 	fw_name = (mhi_cntrl->ee == MHI_EE_EDL) ?
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 3a732afaf73e..9d72b1d1e986 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -390,7 +390,8 @@ extern const char * const mhi_ee_str[MHI_EE_MAX];
 
 #define MHI_IN_PBL(ee) (ee == MHI_EE_PBL || ee == MHI_EE_PTHRU || \
 			ee == MHI_EE_EDL)
-
+#define MHI_POWER_UP_CAPABLE(ee) (MHI_IN_PBL(ee) || ee == MHI_EE_AMSS)
+#define MHI_FW_LOAD_CAPABLE(ee) (ee == MHI_EE_PBL || ee == MHI_EE_EDL)
 #define MHI_IN_MISSION_MODE(ee) (ee == MHI_EE_AMSS || ee == MHI_EE_WFW || \
 				 ee == MHI_EE_FP)
 
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index fb99e3727155..0bb8d77515e3 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1068,7 +1068,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	write_unlock_irq(&mhi_cntrl->pm_lock);
 
 	/* Confirm that the device is in valid exec env */
-	if (!MHI_IN_PBL(current_ee) && current_ee != MHI_EE_AMSS) {
+	if (!MHI_POWER_UP_CAPABLE(current_ee)) {
 		dev_err(dev, "%s is not a valid EE for power on\n",
 			TO_MHI_EXEC_STR(current_ee));
 		ret = -EIO;
-- 
2.25.1

