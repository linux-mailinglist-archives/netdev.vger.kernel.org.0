Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0117D338270
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhCLAch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhCLAcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:32:16 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43251C061762
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:32:16 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id x28so2742621otr.6
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=isIJ1maemEvfOxt679u3GZk6zqUs0JdaNZTH1YsiYK4=;
        b=YICE8gIFE1rd8aHBxZPzOdPTUNe8SYeUQZ6INqHnhetQONW09v0FLQoJdKUMAf0sGF
         udcFpqMrGNrEWO2RSaH0CEBu+0gOVtC18AlxHX9ePsqZRbJnjM051fbT1IdvnhT7sX+P
         yp20Qt2f5FawiBFXzcHbdiyWDruxP0ZDvuV8hjHP9kDyYOsbtzaYRAWgTIkpURE8Kan+
         nqVW0A4ZoMPP8FtwoMmu60CnhN4SgfYePTLNMvdNPi3oojFyU3M7Nim6LDfuBbrdOosO
         idr9b8VzcYCw/iuEEqge96JiR6nOcJVAaPpfb7+pmDwTwYS4+D2aXERIrvu6xdMNenao
         hZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=isIJ1maemEvfOxt679u3GZk6zqUs0JdaNZTH1YsiYK4=;
        b=nPDA3sE1phx+yEaFOaMXgWAREzCdtK32BwehypAbX7H1Xzg/tbXS7HCwnFuixoTVQ5
         7V/ZxpJxjJJVU3YagOmOlJIwGg66sAePFz3hPcjVDEW6lUM8EWRvoFEuXKYcauqQkN2B
         POzwaet6ZcXzRS+gwh/ZbMwLcykZcpjVmZF7GmapYIumR5w9+wGJJeiLA43/SIo7Ocey
         jcj5cqopR6tQXInv/WFgV6mob4k5AG1W4tlP8VVwC+rDzaQIrIBbplisMlPzAUZAkg+m
         Zeh1tE20jckRN3MRW1RGx0+L7TPDDc5jfMg6oue48dnQu80OSMH8BWODaZ/W2z3YLIe3
         RVaA==
X-Gm-Message-State: AOAM531rCtLK4CshpFomcv5ovvzeD+REU37Y/hMDZOBF1irvKySdAGVs
        bNVPAsybl44WiuPcu1fkJr/VhA==
X-Google-Smtp-Source: ABdhPJw6wYPH6HVdOaZ7Utjo3z2uqPRCd3muxY5zNCJbEJqOuv/ktIC4UeHTldx+mXF50YGuIPm1+g==
X-Received: by 2002:a05:6830:1647:: with SMTP id h7mr872436otr.341.1615509135652;
        Thu, 11 Mar 2021 16:32:15 -0800 (PST)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id l190sm670835oig.39.2021.03.11.16.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 16:32:15 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/5] dt-bindings: soc: qcom: wcnss: Add firmware-name property
Date:   Thu, 11 Mar 2021 16:33:14 -0800
Message-Id: <20210312003318.3273536-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WCNSS needs firmware which differs between platforms, and possibly
boards. Add a new property "firmware-name" to allow the DT to specify
the platform/board specific path to this firmware file.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.txt
index 042a2e4159bd..1382b64e1381 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.txt
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.txt
@@ -24,6 +24,13 @@ block and a BT, WiFi and FM radio block, all using SMD as command channels.
 		    "qcom,riva",
 		    "qcom,pronto"
 
+- firmware-name:
+	Usage: optional
+	Value type: <string>
+	Definition: specifies the relative firmware image path for the WLAN NV
+		    blob. Defaults to "wlan/prima/WCNSS_qcom_wlan_nv.bin" if
+		    not specified.
+
 = SUBNODES
 The subnodes of the wcnss node are optional and describe the individual blocks in
 the WCNSS.
-- 
2.29.2

