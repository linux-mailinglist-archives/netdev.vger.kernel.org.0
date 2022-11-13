Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AED56271CA
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiKMSrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbiKMSri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:47:38 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA614101E8;
        Sun, 13 Nov 2022 10:47:37 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a5so14345367edb.11;
        Sun, 13 Nov 2022 10:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMhpYyPey08UrRgT0dHRpZvgVs5y36GQ990A5ruvQkI=;
        b=SufgRicCgiDOPBIqahr9/qv6XCI0AGxHhMBCltHUEekcrTX/c1uyCF9WIgORRc6Ip/
         XRAS7b6cprhmW+iZnDJgEaXpwFNMWBRpe5y9VLsJtF5ajHRb3p6ZBJnmDV2b1ZOz0qDA
         dPjnQpoIa1QHQherL+D1CxeJHmptS6jdluzWdY26FCCTmHuFdk7VPt9QY5fAJ6I+3OV6
         H5tdTozS7aHfyf3cD3U0xYM4243pjppHWHhGsIe4orU2ud6TiAR45krRQRUVx4vcE/pW
         lISYNkrgyKngI35yANEsBV1Mou/Xc9gNdGgOtaX+E3xsZhKMpTqOKvZV3zotCflUSwjz
         s5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMhpYyPey08UrRgT0dHRpZvgVs5y36GQ990A5ruvQkI=;
        b=l4t0R0ZDZoc0pxJZF4mzeGEmgnE1YszhNTMtTcAaZs8QukK2T23qX94iK3EX5RHaQL
         vHm8TS5Nb6Wo9mJyaQKMQj+XO08R637NTZzBSMdYIBEtbcsaqGtdDLBc7FR9oEIZA5M7
         CY2xP8nPFDIDTZ1E69mT91o3VzFKoa2/6NHxJNYH4W+9+gMmEEr6o1Jqc81qJCSEiHlB
         stRNIksLCe+7/26dxxm/2XSKnHmsNl+XQYeMzQHFt+PeazpuKNanSg+R3QIgZ5Fz/PTV
         MWF2HzxAZ0fYX/2i2UAhXgE/J1PG6kF/YJBI2vrXmMfprD20+QAj53cpKim2POYFfT/f
         3Ogg==
X-Gm-Message-State: ANoB5pk1Iqa0rO+qp7D/IKVQj7HeZkr4qF6C7WMEuSmyMeNkWAM/aAY9
        mARM2bpQfDVdu5GkG8219U2FHbF4FCHN5Q==
X-Google-Smtp-Source: AA0mqf7BpnnvpWOgQpJ2U8fnXQxafN8bgUIMf04uY9hP5Ien3e1lISxtncyBvSPPp0AdHJYS6a34vg==
X-Received: by 2002:a05:6402:2b89:b0:45f:c7f2:297d with SMTP id fj9-20020a0564022b8900b0045fc7f2297dmr8983540edb.266.1668365256417;
        Sun, 13 Nov 2022 10:47:36 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id a2-20020aa7d742000000b004623028c594sm3760050eds.49.2022.11.13.10.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 10:47:35 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 4/5] dt-bindings: net: ipq4019-mdio: document required clock-names
Date:   Sun, 13 Nov 2022 19:47:26 +0100
Message-Id: <20221113184727.44923-4-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221113184727.44923-1-robimarko@gmail.com>
References: <20221113184727.44923-1-robimarko@gmail.com>
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

IPQ5018, IPQ6018 and IPQ8074 require clock-names to be set as driver is
requesting the clock based on it and not index, so document that and make
it required for the listed SoC-s.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index b34955b0b827..d233009b0d49 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -59,8 +59,12 @@ allOf:
         clocks:
           items:
             - description: MDIO clock source frequency fixed to 100MHZ
+        clock-names:
+          items:
+            - const: gcc_mdio_ahb_clk
       required:
         - clocks
+        - clock-names
 
 unevaluatedProperties: false
 
-- 
2.38.1

