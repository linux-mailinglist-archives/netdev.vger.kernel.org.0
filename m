Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05112553409
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350953AbiFUNxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiFUNxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:53:47 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA8112776;
        Tue, 21 Jun 2022 06:53:44 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id fu3so27668993ejc.7;
        Tue, 21 Jun 2022 06:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roHXTUL4tKXVN//IvEXVUmOPrGKI2A3Q1fTOEiNxRiE=;
        b=P5XX+bTiGw5qp8eSMfarTWvbuYZdIdE/DXb5iSZ8X4x/m9/szH6t40nyGlna8U8T7E
         e9zqDZ2c7I5374q+h+4xdhLKoMxCMXy3CAWe5PUGt+/SxouSYiYMbhXYZaCNnxA5CkCY
         wi99hSVxmqCBzZLtZw2muvN23Rdb1KEyGYIJIvFZH7iVLeIhtRqfGWXyMoDw5YUHH5oD
         reUW+m5SeNYHj1VmO1rijqrQE5gJ5MsjHrO4BSn/hsJsuqzPkXFLkIx1iAHJVbD2a3GB
         GbnykMSfI7VYnn1KOuERBdm+67sGyC/kkCevOwELffMJ8DnRu1lw4miR8viQYylwXpR9
         Vb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roHXTUL4tKXVN//IvEXVUmOPrGKI2A3Q1fTOEiNxRiE=;
        b=xWDStEErAEr85ZTnrCOrejctAQYVpp497pS4S5+B/88t4c3an1h6v/fjkhHwyBJj8N
         l8A7iCW0AYGI1Qy7c8NgCPp4Sh4lihoeHz9qeWQbFoDsytwLHlMI51/6TS9DhHJLKCNf
         E6ZOL0FkPcC/3UCAYUCMYr4r4X5WS9wAnEfLfwWvaQQjx2/ZiBfsHwFqFMx/nt5TLV2S
         e+wrDCfXMAfo+UtyB+mG7h0nCowBumPNIRmPNTqa9HiDJeNAo1JOBH+7F8TGs3JXaAW5
         m8OfWqFSlJuRZkbebZ5P1Bs53IsRgEdur9l8zhihBCiRNxdPVNRYinW4UvrGzQRI7KLF
         R9aw==
X-Gm-Message-State: AJIora9GQHmLYcp6zR0VSUX58nEXPVQsg7+irzGd8yO/Tyh13+0azhnt
        9KWHsXL5IqEK80i9P2cL60XWfeKLOiYvOQ==
X-Google-Smtp-Source: AGRyM1sczfnqeoBRL2JVbKBxe9KgCynS8OEYJM73QMnSa2Iy5BIRI4fRPUdc2rdfo7pOMxyFAXFyuw==
X-Received: by 2002:a17:906:c7c8:b0:70c:a62c:d0e8 with SMTP id dc8-20020a170906c7c800b0070ca62cd0e8mr25422461ejb.545.1655819623364;
        Tue, 21 Jun 2022 06:53:43 -0700 (PDT)
Received: from fedora.robimarko.hr (dh207-99-158.xnet.hr. [88.207.99.158])
        by smtp.googlemail.com with ESMTPSA id fy11-20020a1709069f0b00b007104b37aab7sm7325408ejc.106.2022.06.21.06.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 06:53:42 -0700 (PDT)
From:   Robert Marko <robimarko@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry for board ID
Date:   Tue, 21 Jun 2022 15:53:38 +0200
Message-Id: <20220621135339.1269409-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.36.1
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

So, to provide the correct qmi-board-id add a new DT property that allows
the qmi-board-id to be overridden from DTS in cases where its not set.
This is what vendors have been doing in the stock firmwares that were
shipped on boards I have.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath11k.yaml     | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index a677b056f112..fe6aafdab9d4 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -41,6 +41,14 @@ properties:
         * reg
         * reg-names
 
+  qcom,ath11k-board-id:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Board ID to override the one returned by the firmware or the default
+      0xff if it was not set by the vendor at all.
+      It is used along the ath11k-calibration-variant to mach the correct
+      calibration data from board-2.bin.
+
   qcom,ath11k-calibration-variant:
     $ref: /schemas/types.yaml#/definitions/string
     description:
-- 
2.36.1

