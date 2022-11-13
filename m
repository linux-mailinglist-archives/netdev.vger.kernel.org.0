Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9799B6271CE
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiKMSrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiKMSrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:47:46 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382461180A;
        Sun, 13 Nov 2022 10:47:39 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f7so14370363edc.6;
        Sun, 13 Nov 2022 10:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pVDig1RRKsZiaPOKlAeQRhmQ8lXaiXxKccYF0IZ+PBk=;
        b=k5kLPtjxsguN5R8wefRr6oX7rk0Qfkth/BbCL1XwrqGgQR0iQ6wCHMAyo2fdVd6CFa
         S03Clzz1Pbulp09EcMnqUIzSKs53AXz9bEHigDsw7E3CPnU3G+Uk3dKXsbJDlg/u3D3W
         bdRuRQyH815QHPAEEBCD5nqnuJFr4azzjj9z03zcvuynRhoVQTlc+0WoNLbRzCk4q3FQ
         xf7VfjpEuQ29i9t2qzeYsed/prPLAUOJg9zs0kXSgskaWwfs/JOSOHSGWZatO9YoSvUI
         YAXv+FXfgrnen88fV8f/p0Yeyko+UupjTec+xis6iXRRMMl5hlOzpde7TfMcuvN5OnB1
         1WRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVDig1RRKsZiaPOKlAeQRhmQ8lXaiXxKccYF0IZ+PBk=;
        b=VbElGyU29Cw2pqA199WPJKHN9hCHM4EKqFkm9q3WRDkwWr1TXS7EyhGyDvdXgxNdAa
         Y4orrhBhGjYqxI+c+fttS8DrGNxYPS+0Vy/jIWO+bEixL20GuzTNb5MpE+91Ni8Fa2E4
         uISGtV9StDVQVuwdaINn3DiRzGNNjalNwtGhsOsy0YH9BKsYGm8iG6ayGp+qFDy63fHb
         y1D4F8p1e+0UDatfXGyb9NBTmaOFb6JZl7UUlBTecagVu/ws9Y7oqGZ9k5BhO3sMF5Zk
         R1Gd+sUmKKeg8mNT3rdbpezEcKg2KcCx3uSHZMsNHPzWuu3LTq88+Lbm+4f9cXCPU/2x
         rm8w==
X-Gm-Message-State: ANoB5pkWbWPEFKWGyuJNCt4612sVSLawNaqOBVZzrNjVIx9eVr4ZzOz2
        vQnoqh/QRYDQuLvLDozORrs=
X-Google-Smtp-Source: AA0mqf5kySzMP+W7wXHErU8epLpNPKZx5FZo07Zl8CqTzEeHygv5MweEvgDnzCIQD42Wgh5VZ1WEqQ==
X-Received: by 2002:a05:6402:6c8:b0:467:205b:723d with SMTP id n8-20020a05640206c800b00467205b723dmr9150411edy.69.1668365257789;
        Sun, 13 Nov 2022 10:47:37 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id a2-20020aa7d742000000b004623028c594sm3760050eds.49.2022.11.13.10.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 10:47:37 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 5/5] arm64: dts: qcom: ipq8074: add SoC specific compatible to MDIO
Date:   Sun, 13 Nov 2022 19:47:27 +0100
Message-Id: <20221113184727.44923-5-robimarko@gmail.com>
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

Add the newly documented SoC compatible to MDIO in order to be able to
validate clocks for it.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index a0481c671faf..583871c29586 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -331,7 +331,7 @@ pcie_phy1: phy@8e200 {
 		};
 
 		mdio: mdio@90000 {
-			compatible = "qcom,ipq4019-mdio";
+			compatible = "qcom,ipq8074-mdio", "qcom,ipq4019-mdio";
 			reg = <0x00090000 0x64>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.38.1

