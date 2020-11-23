Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8D2C034C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgKWK24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgKWK24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:28:56 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D7DC061A4D
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:28:56 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id t18so8652858plo.0
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=O0ThdxcJNO6zV2BphVWbiZgpVdrlhVR1MlXKPXk6EbI=;
        b=Ddt6tz3jFBvHqbvtkEjGa7L62ThxISp2m8mvGVC+V1ccsa8/1Ot5o77bK78xEnPc0J
         MH+t7qj5sfeU+eSLEx/bduYC1u6HCIpk1dzUPdVsFVLBc9GHQbjj6XWxYZNYEBYb8rPB
         Pn8qhkZviZe2uOs3RGXTL0Qn15Uj/YBzZyn6etVgszZjSwAelMmM5Y9cPXeWQLynyXgo
         mPeAQ/PyvMXJoMBd88T/Pd5Luhyg75lWegpDVhZuorfXkssRLWqEoYvkE0riB1N9K31U
         VNJuwlKXFyjWMKcvzzc5dscMTaq2nbpZeZEZAwjz+pQT+C8Gl/p1s528maryBgipn02N
         p4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O0ThdxcJNO6zV2BphVWbiZgpVdrlhVR1MlXKPXk6EbI=;
        b=CdV73Co2PCijEeVAqCeEho0wMWI1pH7fv9j4RXbnctwekCW1Nck9JARkTzl9heyQV+
         EA3kuCdPq2lWrSF2IMNZhoraZDhqZt8lVhKfpzm3seIpRJNT5QLWgl5BxRKPsKCVgrxy
         9pFSSm29jB4qDYuMYhADIRj1Rcqn16mnC4Rat6kOTauVg/hZXzgLbCUkKdl/0Yfy0UYi
         5e4jgJgOaodx6jI3DMVz4BDyB+Xb6N/oL/zhhCi4ecqzE5C+G6dDoOSeqgtcCvZgC7ho
         oBnk1OTU6Sml4N1/LnxF00JWtoaGuzIvd54KHphQdyVf4/AFKpPeJZkLdqZh4O7ggJqH
         x7dw==
X-Gm-Message-State: AOAM532RJYBn9lYHuiZUQs/h62hEFK5Ci0sAY0EIGu+J/EJbBdJmgPaT
        GRYGwKEp3+1wQLf0HtevFPH2dA==
X-Google-Smtp-Source: ABdhPJx5Okx2LQszu8quy1RjI/nmR2bxDLBqR3NRA4lVEd2Xmc3JlWdZObGlJnsZ/N141rt3QbbTLw==
X-Received: by 2002:a17:902:8ec4:b029:d7:eb0d:84c0 with SMTP id x4-20020a1709028ec4b02900d7eb0d84c0mr22751917plo.23.1606127335664;
        Mon, 23 Nov 2020 02:28:55 -0800 (PST)
Received: from localhost.localdomain ([49.207.198.226])
        by smtp.gmail.com with ESMTPSA id s18sm11907655pfc.5.2020.11.23.02.28.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Nov 2020 02:28:55 -0800 (PST)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>, Joel S <jo@jsfamily.in>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, phone-devel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ath10k: qmi: Skip host capability request for Xiaomi Poco F1
Date:   Mon, 23 Nov 2020 15:58:49 +0530
Message-Id: <1606127329-6942-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Workaround to get WiFi working on Xiaomi Poco F1 (sdm845)
phone. We get a non-fatal QMI_ERR_MALFORMED_MSG_V01 error
message in ath10k_qmi_host_cap_send_sync(), but we can still
bring up WiFi services successfully on AOSP if we ignore it.

We suspect either the host cap is not implemented or there
may be firmware specific issues. Firmware version is
QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1

qcom,snoc-host-cap-8bit-quirk didn't help. If I use this
quirk, then the host capability request does get accepted,
but we run into fatal "msa info req rejected" error and
WiFi interface doesn't come up.

Attempts are being made to debug the failure reasons but no
luck so far. Hence this device specific workaround instead
of checking for QMI_ERR_MALFORMED_MSG_V01 error message.
Tried ath10k/WCN3990/hw1.0/wlanmdsp.mbn from the upstream
linux-firmware project but it didn't help and neither did
building board-2.bin file from stock bdwlan* files.

This workaround will be removed once we have a viable fix.
Thanks to postmarketOS guys for catching this.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
We dropped this workaround last time in the favor of
a generic dts quirk to skip host cap check. But that
is under under discussion for a while now,
https://lkml.org/lkml/2020/9/25/1119, so resending
this short term workaround for the time being.

v2: ath10k-check complained about a too long line last
    time, so moved the comment to a new line.
    
 drivers/net/wireless/ath/ath10k/qmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index ae6b1f402adf..1c58b0ff1d29 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -653,7 +653,9 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
 
 	/* older FW didn't support this request, which is not fatal */
 	if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
-	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01) {
+	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01 &&
+	    /* Xiaomi Poco F1 workaround */
+	    !of_machine_is_compatible("xiaomi,beryllium")) {
 		ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);
 		ret = -EINVAL;
 		goto out;
-- 
2.7.4

