Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3F76EAC72
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjDUOLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjDUOLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:11:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6051258E
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:11:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-94ef8b88a5bso233882666b.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1682086303; x=1684678303;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cSsyRwQja94Kgy9jcokEVnB8iKeKI+at5CFxMQlo/L4=;
        b=q8qy3FoqPSsA/RN+2+v5yIedAWtpj7AHuYl+bfkx9lZ3zHQfQhRt0daG4luOvxgRfy
         4DY8MX9eq1AWSCdNNd9yN/3UFmvFpY9xooTIv2VGgdBR2mK6ezVaKCJ+DO6rgcz41RLT
         bRRrmwQGZP6pN/uJu6lpqDCrHGG6y6Qw9o34AK632nyOXegPO3NAGdwzEaXr4PC3YJDF
         d1Y4GrutiNWZpYpVNo3twFD61FLCYM08BpaRAYy4ZJK9V4CsMvLjnYyqCaxX+0AIPGzW
         uT6fh/mQrLgAnO52CZfMAOK1zTkT3OdmL1pFAV7bIACDkh1t8GL4u1VgylhvCc2dCRqt
         esdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682086303; x=1684678303;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSsyRwQja94Kgy9jcokEVnB8iKeKI+at5CFxMQlo/L4=;
        b=BjngsbAMFwgd4LkJDkXiSZg73efKTEQ4imavuhEAaFMphe6PsRlB5qWA1t9H9070vc
         ozmWLbepxbCGXW5SF9Wn5s2KdaC0JZmLMS/gPHdsuz6Q1n6t2CHQeIQv9O05Ri3NiR+3
         3yOeGvDADD1pfxO7ToYyJ9oDk81lvUXFI5lt1dzkTxk08oZ8t9i8SxaUkuQY8xjnrr9s
         F2iXl/DOsw20HumMLSQFY2UWpxRheqyMz14kJkvAxne9cBLsEp1zePW7+qNtSPzqVKCN
         3IQhSv4dPfy+L4GurwtebZwMRYmKdDWlDuU/72FdJLnSLS3uk0qizSrfXiTapUzqjX21
         Humw==
X-Gm-Message-State: AAQBX9dnl2zn0NMePzX0gs6Hn2QTTxk5BDQZhW236UhgMBnhfvGq8OLE
        jjXNLFXJFBGL4jT/dk4I1tjt5Q==
X-Google-Smtp-Source: AKy350aVXLK8qDUZkbgBxYRB6iJJzmdgdfeP666DXcqpI/eSDdzw12TjBLkAqiJRu5crdOTinAi0/A==
X-Received: by 2002:a17:907:874b:b0:94f:2a13:4df8 with SMTP id qo11-20020a170907874b00b0094f2a134df8mr2734432ejc.36.1682086302723;
        Fri, 21 Apr 2023 07:11:42 -0700 (PDT)
Received: from [172.16.220.31] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id mb20-20020a170906eb1400b0094f432f2429sm2104299ejb.109.2023.04.21.07.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:11:42 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Fri, 21 Apr 2023 16:11:38 +0200
Subject: [PATCH RFC 1/4] dt-bindings: net: qualcomm: Add WCN3988
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230421-fp4-bluetooth-v1-1-0430e3a7e0a2@fairphone.com>
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the compatible for the Bluetooth part of the Qualcomm WCN3988
chipset.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
index 68f78b90d23a..7a53e05ae50d 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
@@ -18,6 +18,7 @@ properties:
     enum:
       - qcom,qca6174-bt
       - qcom,qca9377-bt
+      - qcom,wcn3988-bt
       - qcom,wcn3990-bt
       - qcom,wcn3991-bt
       - qcom,wcn3998-bt
@@ -106,6 +107,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,wcn3988-bt
               - qcom,wcn3990-bt
               - qcom,wcn3991-bt
               - qcom,wcn3998-bt

-- 
2.40.0

