Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B94410EB6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhITDMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhITDMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:12:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0436FC061798;
        Sun, 19 Sep 2021 20:09:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so7876400pjb.4;
        Sun, 19 Sep 2021 20:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nh3XAp4yGEAFhmmgYKLEpNxgx1mBq+le0G+MOLIox6Y=;
        b=RiWrRgv+VN1IBSUIUFpqImR8K+4kUQncOKSYTggIGooNriq9Yp/xFGgLpVKooswCcH
         bAlqZYCKgB5kQ1rYs9m/+nlaeJ+ghBBFn/wNszn/ROxhbnDWIca+uvboClkOWmEl+xTk
         utDm2RStAhU71zT9jJShWCZCfVhxlHpbOYXw1Kk2QMaDLWE0uvB2Mcit6xoai/dh7rBn
         pOnL9jk/oVrr7uy11e1LkQ3Z5QseRGkAaBhX6ZgMoRmVt1b68sbJeNLVIZB1gnVkyNs+
         VpTzNV/4s9h972DdAmhrTWzpnAjrefLj1zW9Hh12wgQKX9p5Qthl/sRc2O2ae8iSPGTr
         CEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nh3XAp4yGEAFhmmgYKLEpNxgx1mBq+le0G+MOLIox6Y=;
        b=b/mUmrkHdrqPj8jt+6bAJ0Ngf8InPl2DegSVLX7KSEsVIpxPcHfhFu6pwlm4z4qG5p
         VZYqpTWcifxRwXS6GsH2AAAjK8g3IqjToJQ64JXJ81qyOuAc1U69fd3h+UbYZ2xIe7Fb
         fRWYi9FkkbP5HOgS70OeqrJ0vbA6yCHB/8vsXiHoLUydKP+xO9t8P1jrqcSnpPVPlqg0
         F2AidL6+BUjMuqucGr9gBWcMyA2FtPmgF7npHQ9IPTQKjgOqD1JR+qOGfwTYcW3SVBwj
         V1fSkylc7+Ls2wCppleQj5+pJdnGNrlodEA6hGqIA6UqbI1R2Kam1SsY/mg3RbOHXGzh
         DmtQ==
X-Gm-Message-State: AOAM532CaI5W5YSduE3d2XXnbuyB3TZhe4XlCtLfwuoX4OUBKOPUoUzy
        KkZ2tqgyR7SnOY9CfWQtyxsgk1Km+MWXMa3Q
X-Google-Smtp-Source: ABdhPJyfvcG6K8PJI3HqPAwreapMX2Ch2WSIsJscI8py2BOTkMABKsI904Ajs6anf10LfRuH5fy/UQ==
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr35558089pjb.33.1632107395273;
        Sun, 19 Sep 2021 20:09:55 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:09:54 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        Vladimir Lypak <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 13/17] net: ipa: Add support for IPA v2.x in the driver's QMI interface
Date:   Mon, 20 Sep 2021 08:38:07 +0530
Message-Id: <20210920030811.57273-14-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On IPA v2.x, the modem doesn't send a DRIVER_INIT_COMPLETED, so we have
to rely on the uc's IPA_UC_RESPONSE_INIT_COMPLETED to know when its
ready. We add a function here that marks uc_ready = true. This function
is called by ipa_uc.c when IPA_UC_RESPONSE_INIT_COMPLETED is handled.

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
---
 drivers/net/ipa/ipa_qmi.c | 27 ++++++++++++++++++++++++++-
 drivers/net/ipa/ipa_qmi.h | 10 ++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 7e2fe701cc4d..876e2a004f70 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -68,6 +68,11 @@
  * - The INDICATION_REGISTER request and INIT_COMPLETE indication are
  *   optional for non-initial modem boots, and have no bearing on the
  *   determination of when things are "ready"
+ *
+ * Note that on IPA v2.x, the modem doesn't send a DRIVER_INIT_COMPLETE
+ * request. Thus, we rely on the uc's IPA_UC_RESPONSE_INIT_COMPLETED to know
+ * when the uc is ready. The rest of the process is the same on IPA v2.x and
+ * later IPA versions
  */
 
 #define IPA_HOST_SERVICE_SVC_ID		0x31
@@ -345,7 +350,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 			req.hdr_proc_ctx_tbl_info.start + mem->size - 1;
 	}
 
-	/* Nothing to report for the compression table (zip_tbl_info) */
+	mem = &ipa->mem[IPA_MEM_ZIP];
+	if (mem->size) {
+		req.zip_tbl_info_valid = 1;
+		req.zip_tbl_info.start = ipa->mem_offset + mem->offset;
+		req.zip_tbl_info.end = ipa->mem_offset + mem->size - 1;
+	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE_HASHED);
 	if (mem->size) {
@@ -525,6 +535,21 @@ int ipa_qmi_setup(struct ipa *ipa)
 	return ret;
 }
 
+/* With IPA v2 modem is not required to send DRIVER_INIT_COMPLETE request to AP.
+ * We start operation as soon as IPA_UC_RESPONSE_INIT_COMPLETED irq is triggered.
+ */
+void ipa_qmi_signal_uc_loaded(struct ipa *ipa)
+{
+	struct ipa_qmi *ipa_qmi = &ipa->qmi;
+
+	/* This is needed only on IPA 2.x */
+	if (ipa->version > IPA_VERSION_2_6L)
+		return;
+
+	ipa_qmi->uc_ready = true;
+	ipa_qmi_ready(ipa_qmi);
+}
+
 /* Tear down IPA QMI handles */
 void ipa_qmi_teardown(struct ipa *ipa)
 {
diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
index 856ef629ccc8..4962d88b0d22 100644
--- a/drivers/net/ipa/ipa_qmi.h
+++ b/drivers/net/ipa/ipa_qmi.h
@@ -55,6 +55,16 @@ struct ipa_qmi {
  */
 int ipa_qmi_setup(struct ipa *ipa);
 
+/**
+ * ipa_qmi_signal_uc_loaded() - Signal that the UC has been loaded
+ * @ipa:		IPA pointer
+ *
+ * This is called when the uc indicates that it is ready. This exists, because
+ * on IPA v2.x, the modem does not send a DRIVER_INIT_COMPLETED. Thus we have
+ * to rely on the uc's INIT_COMPLETED response to know if it was initialized
+ */
+void ipa_qmi_signal_uc_loaded(struct ipa *ipa);
+
 /**
  * ipa_qmi_teardown() - Tear down IPA QMI handles
  * @ipa:		IPA pointer
-- 
2.33.0

