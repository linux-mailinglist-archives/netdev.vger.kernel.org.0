Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E8279052
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgIYS3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIYS3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:29:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829D2C0613D4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:29:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so2512529pgj.3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:author;
        bh=Rhv9HZEtrEL141zSMGw1g065/LfSYNOus3HpsgDc4Os=;
        b=HVUBpvOg+s0a1z2RzoKEIEFlCJWP5rVxDKxRmwxMKnABEXn383FnVD5FLFSLg4M3yY
         DiJztuPhznDB7e0NReBuNguMYtpthbjZWDgz321egNY6GGLm0jEyz48oTlgao0R0tQDO
         21XRe3aF8XrGRVp5TH1ENC7Cl346shsAgl/ySE4HlZOISGRz8JWlooVQQBcsRwJzbILi
         HH7HWhjb1BTRHpFtmSJZ/YBhEQiPHWyV8FSc2DBvNXW5lXG8sMVhBHmAzw1WZAHXK/a2
         Y0ezbxZxbV5PzAIcLN12G8u+Lc+veBcqtiAJR9ZuPeIyRnnZ1wy7vecPxyT7XU7hkI/p
         WbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:author;
        bh=Rhv9HZEtrEL141zSMGw1g065/LfSYNOus3HpsgDc4Os=;
        b=hkF8n35kzNr3mBDL/O6thOTuUhVL6vK/DJj688gK5Hyh3g2FKeOJmNyCDOo89mEvbp
         Y411CD/w9hWbLyV/9AXA3VJJYDaX1kVt0WMDPqwMXGgwKIMRKZ+yf6aEEGIDOz9ocbXx
         /YmU+T2cYIOqVdjVq2aW6CB+jDbxCU304uo/04QsgM5ExjgjECQ5tenflh5XVAm+B2ZT
         i1++hbL60/ena6SBAf1GfeBN64+HZst9hSlELaeKzuGQmdkQgl6HyT3pXe0pZe+wN9Mj
         7wZ6ecEje3ONYXzY3mCciiT8gDGZh6W4CB2pKA/ffG+RtaWO9ojbJ8qHQZ/PkML0C/xU
         NcPg==
X-Gm-Message-State: AOAM533WjTE0Rp7zpugZ5kwaoQCJLO8+rmt23/xw5E/KT+5VFTutC45s
        HisTAnIpGhe0qyEfq7oFACyovf+0n2o8Rg==
X-Google-Smtp-Source: ABdhPJyT6RQYB9DC4di8a/7z5wXawdsq8FSxpEdIKmdSgymgn9ER5Udfvz37BcVVx/UkrRoJ02vI2g==
X-Received: by 2002:a17:902:c404:b029:d2:564a:e41d with SMTP id k4-20020a170902c404b02900d2564ae41dmr681548plk.23.1601058589772;
        Fri, 25 Sep 2020 11:29:49 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:6803:60dd:c56a:3b96:e0d6:72b4])
        by smtp.gmail.com with ESMTPSA id f4sm2806762pgk.19.2020.09.25.11.29.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Sep 2020 11:29:48 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap QMI requests
Date:   Fri, 25 Sep 2020 23:59:41 +0530
Message-Id: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
Author: Amit Pundir <amit.pundir@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are firmware versions which do not support host capability
QMI request. We suspect either the host cap is not implemented or
there may be firmware specific issues, but apparently there seem
to be a generation of firmware that has this particular behavior.

For example, firmware build on Xiaomi Poco F1 (sdm845) phone:
"QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1"

If we do not skip the host cap QMI request on Poco F1, then we
get a QMI_ERR_MALFORMED_MSG_V01 error message in the
ath10k_qmi_host_cap_send_sync(). But this error message is not
fatal to the firmware nor to the ath10k driver and we can still
bring up the WiFi services successfully if we just ignore it.

Hence introducing this DeviceTree quirk to skip host capability
QMI request for the firmware versions which do not support this
feature.

Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 .../devicetree/bindings/net/wireless/qcom,ath10k.txt        |  5 +++++
 drivers/net/wireless/ath/ath10k/qmi.c                       | 13 ++++++++++---
 drivers/net/wireless/ath/ath10k/snoc.c                      |  3 +++
 drivers/net/wireless/ath/ath10k/snoc.h                      |  1 +
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 65ee68efd574..135c7ecd4487 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -86,6 +86,11 @@ Optional properties:
 	Value type: <empty>
 	Definition: Quirk specifying that the firmware expects the 8bit version
 		    of the host capability QMI request
+- qcom,snoc-host-cap-skip-quirk:
+	Usage: Optional
+	Value type: <empty>
+	Definition: Quirk specifying that the firmware wants to skip the host
+		    capability QMI request
 - qcom,xo-cal-data: xo cal offset to be configured in xo trim register.
 
 - qcom,msa-fixed-perm: Boolean context flag to disable SCM call for statically
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 5468a41e928e..5adff7695e18 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -770,6 +770,7 @@ ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
 {
 	struct ath10k *ar = qmi->ar;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	int ret;
 
 	ret = ath10k_qmi_ind_register_send_sync_msg(qmi);
@@ -781,9 +782,15 @@ static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
 		return;
 	}
 
-	ret = ath10k_qmi_host_cap_send_sync(qmi);
-	if (ret)
-		return;
+	/*
+	 * Skip the host capability request for the firmware versions which
+	 * do not support this feature.
+	 */
+	if (!test_bit(ATH10K_SNOC_FLAG_SKIP_HOST_CAP_QUIRK, &ar_snoc->flags)) {
+		ret = ath10k_qmi_host_cap_send_sync(qmi);
+		if (ret)
+			return;
+	}
 
 	ret = ath10k_qmi_msa_mem_info_send_sync_msg(qmi);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 354d49b1cd45..4efbf1339c80 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1281,6 +1281,9 @@ static void ath10k_snoc_quirks_init(struct ath10k *ar)
 
 	if (of_property_read_bool(dev->of_node, "qcom,snoc-host-cap-8bit-quirk"))
 		set_bit(ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK, &ar_snoc->flags);
+
+	if (of_property_read_bool(dev->of_node, "qcom,snoc-host-cap-skip-quirk"))
+		set_bit(ATH10K_SNOC_FLAG_SKIP_HOST_CAP_QUIRK, &ar_snoc->flags);
 }
 
 int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index a3dd06f6ac62..2a0045f0af7e 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -47,6 +47,7 @@ enum ath10k_snoc_flags {
 	ATH10K_SNOC_FLAG_UNREGISTERING,
 	ATH10K_SNOC_FLAG_RECOVERY,
 	ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK,
+	ATH10K_SNOC_FLAG_SKIP_HOST_CAP_QUIRK,
 };
 
 struct clk_bulk_data;
-- 
2.7.4

