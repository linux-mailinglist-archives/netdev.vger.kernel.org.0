Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D28D338263
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhCLAcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhCLAcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:32:19 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10592C061763
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:32:19 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id n12-20020a4ad12c0000b02901b63e7bc1b4so1132835oor.5
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6wVekdiQ/YA8nS7fIn/RALJfKdTTK3aVMvAOi2iip9U=;
        b=pQemKSOE2hWkcq5S0NsPmn6nU08qCVCXLnEJAtAtWJVAePAKnrQyWP9/amyIGzQ+Fc
         lQrm5qOh0SQC/I5AgFw6fS36FUwIevc62X/V6SMIkPC+yX8PdjEvIhTyA+u3WFppiYNq
         pUl56X1em620q7eaTmMrb1TC9swVGLqukK04XKHGrGzJbRCUm7jV+NfbuaZHHQrMscXQ
         VD7Fi9B+lDo+N3rsPL47gWwqqKN/ihGkrR4Zv0/UuYGXzTi3ayyKWM1naKrt0eu5y277
         iueFGHixkgH+lEJE2c8FEvt3AecU8dGDBAkviowSiVbkzJ0byYMR6keTva6DmHkbnEgU
         pKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wVekdiQ/YA8nS7fIn/RALJfKdTTK3aVMvAOi2iip9U=;
        b=W8TGAhZTRXheUJzb71OvKXO8id41R+ya3jxQh/J4/KiP2WybTh8jgZK7VYJVsKtCr5
         VU+I7bQT7uNt7QvQFYLOpGGMdluTeAUQSCf1PyQju989n3UKGtD1CoYo1sNYWPqUa5Xw
         YjH3ke+KrBZ5mW5gQz9vPRVH/aNsIOQBGpZaUg6v3JThvuZR5ARdcu6Rwx32aQU9btos
         Es4OuYR1Mqol92tpS2kvlGjlFk5+Uty5o54jIQnQmcDqUkuJuuoElPn8Gvf8/9kw4wC5
         CijW+9LUu/RaOJbjmwJcXdaMZcYvKlhnFJ9r2SD08RFJUSq6VUfgFm/LyRpbmW4vhYiX
         fKJA==
X-Gm-Message-State: AOAM531qzHNXUquBSuonpyGWIEoiKErNZ+oaHS+FoG+e/JLcXMCp0tfT
        64QuyRIqcC/dd03SHB0+LV9wWA==
X-Google-Smtp-Source: ABdhPJz1080lUBbniInnevnVB5hPiBvUGGcsqjokAVA002Q1OJ7/tfAjDImT8qm+F5JURaa+IyZLiw==
X-Received: by 2002:a4a:96b3:: with SMTP id s48mr1254406ooi.11.1615509138437;
        Thu, 11 Mar 2021 16:32:18 -0800 (PST)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id l190sm670835oig.39.2021.03.11.16.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 16:32:18 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/5] soc: qcom: wcnss_ctrl: Allow reading firmware-name from DT
Date:   Thu, 11 Mar 2021 16:33:17 -0800
Message-Id: <20210312003318.3273536-5-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WLAN NV firmware blob differs between platforms, and possibly
devices, so add support in the wcnss_ctrl driver for reading the path of
this file from DT in order to allow these files to live in a generic
file system (or linux-firmware).

The new property is optional and the code falls back to the old filename
if the property isn't specified.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/soc/qcom/wcnss_ctrl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/wcnss_ctrl.c b/drivers/soc/qcom/wcnss_ctrl.c
index 358526b9de06..2a06d631e415 100644
--- a/drivers/soc/qcom/wcnss_ctrl.c
+++ b/drivers/soc/qcom/wcnss_ctrl.c
@@ -200,6 +200,7 @@ static int wcnss_download_nv(struct wcnss_ctrl *wcnss, bool *expect_cbc)
 	struct wcnss_download_nv_req *req;
 	const struct firmware *fw;
 	struct device *dev = wcnss->dev;
+	const char *nvbin = NVBIN_FILE;
 	const void *data;
 	ssize_t left;
 	int ret;
@@ -208,10 +209,13 @@ static int wcnss_download_nv(struct wcnss_ctrl *wcnss, bool *expect_cbc)
 	if (!req)
 		return -ENOMEM;
 
-	ret = request_firmware(&fw, NVBIN_FILE, dev);
+	ret = of_property_read_string(dev->of_node, "firmware-name", &nvbin);
+	if (ret < 0 && ret != -EINVAL)
+		goto free_req;
+
+	ret = request_firmware(&fw, nvbin, dev);
 	if (ret < 0) {
-		dev_err(dev, "Failed to load nv file %s: %d\n",
-			NVBIN_FILE, ret);
+		dev_err(dev, "Failed to load nv file %s: %d\n", nvbin, ret);
 		goto free_req;
 	}
 
-- 
2.29.2

