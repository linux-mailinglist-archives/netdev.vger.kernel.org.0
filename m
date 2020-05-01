Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF65B1C1FEA
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgEAVqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgEAVqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:46:32 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3881CC061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 14:46:32 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id b1so9087845qtt.1
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 14:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7feKFMGg4GPGIWvo5qLBoNVV6FQKy+Rod2p/i6GH6LU=;
        b=FoPvLdc2DRWZKrxVhNrrfD3gQQjINc9Mx91B7hF9oRDGkECJOhZGg7mYlYiBi/CxUm
         X38TPhcbJBAj8tQa2226QjwoC1B162RMPg5rynuh8S++MSmP773m1KhmhobndysMJIgI
         KGyefw2SGNpvrw9JCpJNU/zmsC03yAb8P3rkaQNRxh7L04EXPfMmFkmZ3dymoJrUTqWT
         zB0e0o/abeN90jQqred927YOzTWIzK2UZv2UXmaOHAaA1I1v9UGe4Lv5Q2w1yezH/WtT
         m56b47X/FOX4j63jA0IDHzc7CDKBPO+W2+7YCCEP0fX9gnYi11qfe5vIOkdtBRJo21W6
         Vd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7feKFMGg4GPGIWvo5qLBoNVV6FQKy+Rod2p/i6GH6LU=;
        b=DNS+Uv+4sQ1rAnQxBss9Adlb/EpjIplhjrNf4/lWTZVb+Ex6ha3Ntkmu1dGXd3rKlO
         FoCKT+caqgyNRL8hH4lH1ZRoZDyoKRcF3da/pxDpbzM4mdofx7ctAwb53G4yhstUMtU4
         LUNAv4JTJqkFmErceEhRLDJV/z8V66nijGzWRVaqwBYZB2dllkCQ692FGyS0YtktYNbq
         v2NQgwYIFHoJGQFYHuTF1FdI5QUx527tfwzJD167AJto+CD5/909wmiE7Li2ZmOSgJSl
         KM7vyNjLsZ0bsC5P5Lz8ob9sU+GBq0izhPV+oXRLVoH8zUffU7gMT3SrtcsxG78TGBOC
         GqHA==
X-Gm-Message-State: AGi0Pub5hTLDYI+KFsi2f4Uoymuofw57BqsN8Im/gJoPSGm+mTLvdGWu
        1iTyV0wTK2do4O1RnOiH5MMPkg==
X-Google-Smtp-Source: APiQypKFhQRa4VjEaoeR/o7gsskZE9XQbrTzrYQKw9zJNHa0WlH2UqhRXODOpcTtlPjqQZ1JgKGprg==
X-Received: by 2002:ac8:4818:: with SMTP id g24mr5998881qtq.377.1588369591468;
        Fri, 01 May 2020 14:46:31 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm3470982qti.47.2020.05.01.14.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 14:46:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] arm64: dts: sdm845: add IPA iommus property
Date:   Fri,  1 May 2020 16:46:22 -0500
Message-Id: <20200501214625.31539-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200501214625.31539-1-elder@linaro.org>
References: <20200501214625.31539-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an "iommus" property to the IPA node in "sdm845.dtsi".  It is
required because there are two regions of memory the IPA accesses
through an SMMU.  The next few patches define and map those regions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 8f926b5234d4..de6bb86c4968 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1761,6 +1761,8 @@
 
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sdm845-ipa";
+
+			iommus = <&apps_smmu 0x720 0x3>;
 			reg = <0 0x1e40000 0 0x7000>,
 			      <0 0x1e47000 0 0x2000>,
 			      <0 0x1e04000 0 0x2c000>;
-- 
2.20.1

