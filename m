Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCF86B7E92
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCMRAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjCMRAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B711164B26
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678726649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JepgEUi2Rsg9+d2hOOa0Co6HIDw3s31TfucmHUz975I=;
        b=IYlEOFvzrjhLPFzknIKs4a1TPxSiyX3vJYNuyePoavoXdq2jGXGnjYdV6jKao/fCrREaPc
        4ymAkQsvsYNH6OqFZMGJ1/cFtSfsXiATvVF28LLIL6y4QJOyhKfI2fmGF2hNUIUBFl6gbo
        LbyqXJ6BdpFo/wVhf2GE0EtH9mk2Obg=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-FIWd5dXmPFiF51-8IczDVA-1; Mon, 13 Mar 2023 12:57:28 -0400
X-MC-Unique: FIWd5dXmPFiF51-8IczDVA-1
Received: by mail-oo1-f70.google.com with SMTP id t18-20020a4a7452000000b00525456d55f7so3517822ooe.14
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JepgEUi2Rsg9+d2hOOa0Co6HIDw3s31TfucmHUz975I=;
        b=FT81T22CCDA1DJwK5jSV5guTQcsLiTgBJhQCikkcmX0rVXhIomffSfCZnc8lHrHZ4m
         SAQeiRsaboh3vclbbZG1vOnNNoCfVfPbnhNeUtaPSb125cnEc/jAnH+bmnz71zVNk9j4
         FHm/Z8n9RJQJ2R76+LZg0KIlxZsK+JS3JiiwhmEKpFMUcDlQJi3ANtiecIHVZoQT/lgo
         CDK8Iwxkj5g3XurFQ6IsKufIjBJApAMUqWQKEll6IkEyjB5oR0wPnFzwWUq2WZLIrgWd
         yK/qU8I9GzJK5aOSJpNHPpkBkGl8tkJK8p1pLBnecJZ2uixlBIYmqRWnj+sWZyJfCdJ3
         RmNQ==
X-Gm-Message-State: AO0yUKUvGeMa7iIVSRxr3j8ycizfy4zOMepp8XYZUmNcumOg9qRyAezg
        uzg89BdouAa4xoXfB79pwCQn7ibe7fDCb/Gj3+FSHgqbCFkDyQbh9n7xU2rozpPnSKCEvIe4X42
        X8f7hMES/yJoVUr+y
X-Received: by 2002:a05:6808:48:b0:384:4739:dddc with SMTP id v8-20020a056808004800b003844739dddcmr15869253oic.2.1678726647117;
        Mon, 13 Mar 2023 09:57:27 -0700 (PDT)
X-Google-Smtp-Source: AK7set9jUwB7abxbtJ/4rmMYbnk+9a7FIH+IPzgb4Vv0+dyO3yPMXdplK40mvcn5yoPEjWxNdNOikQ==
X-Received: by 2002:a05:6808:48:b0:384:4739:dddc with SMTP id v8-20020a056808004800b003844739dddcmr15869223oic.2.1678726646844;
        Mon, 13 Mar 2023 09:57:26 -0700 (PDT)
Received: from halaney-x13s.attlocal.net ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id o2-20020acad702000000b00384d3003fa3sm3365273oig.26.2023.03.13.09.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:57:26 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next 02/11] dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
Date:   Mon, 13 Mar 2023 11:56:11 -0500
Message-Id: <20230313165620.128463-3-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313165620.128463-1-ahalaney@redhat.com>
References: <20230313165620.128463-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add Qualcomm Ethernet ETHQOS compatible checks
in snps,dwmac YAML binding document.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

I picked this up from:
	https://lore.kernel.org/netdev/20220929060405.2445745-3-bhupesh.sharma@linaro.org/
No changes except the Reviewed-by collection.

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 52ce14a4bea7..3ca1239da448 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -65,6 +65,8 @@ properties:
         - ingenic,x2000-mac
         - loongson,ls2k-dwmac
         - loongson,ls7a-dwmac
+        - qcom,qcs404-ethqos
+        - qcom,sm8150-ethqos
         - renesas,r9a06g032-gmac
         - renesas,rzn1-gmac
         - rockchip,px30-gmac
@@ -625,6 +627,8 @@ allOf:
               - ingenic,x1600-mac
               - ingenic,x1830-mac
               - ingenic,x2000-mac
+              - qcom,qcs404-ethqos
+              - qcom,sm8150-ethqos
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
-- 
2.39.2

