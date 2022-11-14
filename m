Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3392F6289A8
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbiKNTro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKNTrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:47:42 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF74FCE7;
        Mon, 14 Nov 2022 11:47:39 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so30840502ejb.13;
        Mon, 14 Nov 2022 11:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/LnaIV3U3L1Vcder467gHAKaNxirMboVJ91pDlJdic4=;
        b=lJvTjJLTtd/oxgIiHPXWEuWj7ci0WEvQ6mLmICO9su8tkvzS0a7c8sVXSo1+T1uHf/
         myXfSh/rA7BZDLPpM5995JEfLMTHrhlX/5GoETS4T9uislF0quBtlmYAcWc78lmSbTM0
         v1KmS/TbyQ7QGHbfOZv47EQhyAMUs2Vj7Lv25s60UBYW8mV8daY6v/DFCsSBDANBXlnV
         4772kD6J6uGrmBxI/GA8GbyV4nN9cxJU1jFTsk5cOl8/fxb4SFvZ3b7nK1Y1ZwhEY/KH
         LaXc+aEX0SkhTpnRv9ie4CS7MoBcV1wLWoN/N8sLpNHM5HtdDE5uYv4T/5EN+neDtHif
         NsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LnaIV3U3L1Vcder467gHAKaNxirMboVJ91pDlJdic4=;
        b=WT8cC4FJfam7V4/Fbh42T/4Hds8Gi85xH324a9MK/jmyDQTVorRNWtEQUPUcwhzZYs
         LCp2VEPm2jdyDRcTZ1q4P0vhxqamPtUhfNcjMdVPLq0ggZTyNtZJhIqviVKtrAaqj2Lk
         V1eCfV78GvrfiquFZRWQXBX2qeaJZdJxaIn2oYCrJvyxO66pTzt947tRCric4zJTfshc
         hVB/F9GILt+8js/ZDwe3t7auAyQbbA0j3yNj6LcZpIODz5pi0Z9HtD8uqFIyYgWgCLKD
         pkSn4dHy8XqTC+F7A0Ve5UB0VsFJ5zvRh4O1bde+YzXCbO5tD+Jakbg7t13nQreNTPu5
         VICw==
X-Gm-Message-State: ANoB5plAMxcH8agdz5vtd3X33YWTVBbU0el7G7bZATFPopEdBuesjpJy
        GzVpg2gS1WuLae8hCjTjg4tHUcbkxjnkKA==
X-Google-Smtp-Source: AA0mqf5FZjSrUDepXVEOx6V99CvpcdxgNMty0UVgjAd5Q+z2sHkdmvaAtt1eZ13LiiekiczGygmO7g==
X-Received: by 2002:a17:906:3a12:b0:781:b7f2:bce9 with SMTP id z18-20020a1709063a1200b00781b7f2bce9mr11662177eje.269.1668455257826;
        Mon, 14 Nov 2022 11:47:37 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b007a62215eb4esm4666405ejk.16.2022.11.14.11.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:47:36 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH v2 1/5] dt-bindings: net: ipq4019-mdio: document IPQ6018 compatible
Date:   Mon, 14 Nov 2022 20:47:30 +0100
Message-Id: <20221114194734.3287854-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document IPQ6018 compatible that is already being used in the DTS along
with the fallback IPQ4019 compatible as driver itself only gets probed
on IPQ4019 and IPQ5018 compatibles.

This is also required in order to specify which platform require clock to
be defined and validate it in schema.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
Changes in v2:
* Drop items from IPQ4019 and IPQ5018 compatible enum
---
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml   | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index ad8b2b41c140..1ba8de982bd1 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -14,9 +14,15 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - qcom,ipq4019-mdio
-      - qcom,ipq5018-mdio
+    oneOf:
+      - enum:
+          - qcom,ipq4019-mdio
+          - qcom,ipq5018-mdio
+
+      - items:
+          - enum:
+              - qcom,ipq6018-mdio
+          - const: qcom,ipq4019-mdio
 
   "#address-cells":
     const: 1
-- 
2.38.1

