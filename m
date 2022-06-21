Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DAA55340B
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351104AbiFUNxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiFUNxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:53:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4317A13D24;
        Tue, 21 Jun 2022 06:53:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id mf9so7349600ejb.0;
        Tue, 21 Jun 2022 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bnD9hK3prWl6/gYLDJgj48e9xi4+igUWjv8z3KjEBQ=;
        b=LowuFnu5EJgFHfzLAZhiUV7XOQNZYlScpKJ1ehzxo7KJUk/9pWR71H5EwqtpxEx3Fb
         YfUSnzxFnVD5ot3ZdEG/1igUSRaTi/xWfLb5fuEOpbNSFVuKIjJTVrwwTHeCLKoMRJiK
         KzxkPB4jtqUyMX0mNr0addwuL2bf1o/va3KQGfEucHbsrEipOW/Tu6qRQGWNAR36wPQ+
         0l4e/9P2t8Qt6/XCOfuMjO/QegqXx1ndv31XZaecmI15AW/LMCT7QJ6ogvgzx/NhjVmj
         ZQ5RnwLxa8kMBixDilmjmSKpGebk/zzlWsGhbtnErPIUxik2SZ6+HuZ2IUPl9ttXvmGG
         G9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bnD9hK3prWl6/gYLDJgj48e9xi4+igUWjv8z3KjEBQ=;
        b=RkBR2opaXSGus81rEpODpEcHKTIeVDYDt+IPvDrdNbp4F8ShJogD0qNlQvpX2XtL0v
         nzqyy2UZOZW24tWQacy1KHwasRnvxnBuXM2U/OOFjFKQ161+e+dt3IawS2jn4Ev7Vvzw
         7lz79CnAKRHbyT88LEVtUF0pK0nSKQdOyaZvoSSdwSEcb0qnudz2Yysxf0bkReVSFl1+
         cwKIX1/1YzJJcgDh4HtrZnrVWfhvRRlJwQqEwhKOHtJo0VbZMtIcgVw6QTmXRw1f4wJt
         Ri1sb+g0GOEXmqKXFq2KxSBGLCiqrFRcYsrgS1U1qqnCSVWLfNU4qtCunFgejAFAQR+b
         kk7w==
X-Gm-Message-State: AJIora+S1VKg35+dG9eCqXLpHXjcYXetOhSELTe2G51bDSR91togdERc
        bU0WnFATQmr1yRg5YAtcNdw=
X-Google-Smtp-Source: AGRyM1t1OnGmn/19PEpvpFJ5PtSkks3BLBi/GIwdyVDyqV8uzkzUJ+za1jeXY1Kw9XAFhVPac2/SNw==
X-Received: by 2002:a17:907:7b8a:b0:707:59d4:14a3 with SMTP id ne10-20020a1709077b8a00b0070759d414a3mr25833143ejc.51.1655819624627;
        Tue, 21 Jun 2022 06:53:44 -0700 (PDT)
Received: from fedora.robimarko.hr (dh207-99-158.xnet.hr. [88.207.99.158])
        by smtp.googlemail.com with ESMTPSA id fy11-20020a1709069f0b00b007104b37aab7sm7325408ejc.106.2022.06.21.06.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 06:53:44 -0700 (PDT)
From:   Robert Marko <robimarko@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 2/2] ath11k: search DT for qcom,ath11k-board-id
Date:   Tue, 21 Jun 2022 15:53:39 +0200
Message-Id: <20220621135339.1269409-2-robimarko@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621135339.1269409-1-robimarko@gmail.com>
References: <20220621135339.1269409-1-robimarko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
used for identifying the correct board data file.

This however is sometimes not enough as all of the IPQ8074 boards that I
have access to dont have the qmi-board-id properly fused and simply return
the default value of 0xFF.

So, to provide the correct qmi-board-id look for the qcom,ath11k-board-id
property and use that.
This is what vendors have been doing in the stock firmwares that were
shipped on boards I have.

It should be added to DTS like:
	wifi@c000000 {
        status = "okay";

        qcom,ath11k-board-id = <658>;
        qcom,ath11k-calibration-variant = "Edgecore-EAP102";
    };

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 00136601cb7d..9d27b4968d10 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2172,12 +2172,14 @@ static int ath11k_qmi_request_device_info(struct ath11k_base *ab)
 
 static int ath11k_qmi_request_target_cap(struct ath11k_base *ab)
 {
+	struct device *dev = ab->dev;
 	struct qmi_wlanfw_cap_req_msg_v01 req;
 	struct qmi_wlanfw_cap_resp_msg_v01 resp;
 	struct qmi_txn txn;
 	int ret = 0;
 	int r;
 	char *fw_build_id;
+	unsigned int board_id;
 	int fw_build_id_mask_len;
 
 	memset(&req, 0, sizeof(req));
@@ -2219,7 +2221,9 @@ static int ath11k_qmi_request_target_cap(struct ath11k_base *ab)
 		ab->qmi.target.chip_family = resp.chip_info.chip_family;
 	}
 
-	if (resp.board_info_valid)
+	if (!of_property_read_u32(dev->of_node, "qcom,ath11k-board-id", &board_id))
+		ab->qmi.target.board_id = board_id;
+	else if (resp.board_info_valid)
 		ab->qmi.target.board_id = resp.board_info.board_id;
 	else
 		ab->qmi.target.board_id = 0xFF;
-- 
2.36.1

