Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777C653CD50
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbiFCQfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 12:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343680AbiFCQfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:35:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27BA2D1D8;
        Fri,  3 Jun 2022 09:35:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z7so10850664edm.13;
        Fri, 03 Jun 2022 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OyWs2PSSxtF9m14bGEh5PR47UxvU/WKdZospW5gj6qg=;
        b=NYJAcTRebySOX6VXOcR1b629TpydpneKhjZyajgtjblANJD7wbf4AY+x9jW1EpBVUt
         lGOsmDwCx48Nm8a9wXvYpnX8+hLedbSJ8fXTSe7HGhlMfTsa64RrT0bLJuD7TKd/MJGQ
         YF8m7vHMBQoywDepTbmkq67XnDKXZdO2pJL/FUSBzrdJvbZMJ3kxgJmzUHUQ3eqkPwsc
         fTt/EfgtdEypT2/Tg8AcYKkKsoCnnwuVXVnjV7J67onIy+82V/nk1Yz+WxA3KpWpq7eg
         Rator4qTI9TrZPIEfG94s0UNhvj9mnUvXlgwzgRZ1UJ71EF5/HpQQ9eFL28mRmy9My1o
         X0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OyWs2PSSxtF9m14bGEh5PR47UxvU/WKdZospW5gj6qg=;
        b=gV0O3hugn+l1PaYR5jZkHOj8biK6X+Qy4oxDRgNnrEkCNrL2vnObUJkMm0PnXtNbzG
         MHfCK1QZ1f9pC3HJkTWNsz6f9ekyQvwGOtHOfbbF2RdtjgRnZDn/7fdSrKR8svhqs0RI
         yU36u+zmL/d0vk2wMluPJ2WEUefXyDHaMT4sIwy8srNT96bKMZrNCbgUsX0LN7Y70X+/
         l/quIe4e98U8PoXin0CGzMEn9VogP2/1uWKNajT2s92ZoYgJ59GFZJ6WsbAQd5PCPiJO
         SAXl9kI5CAzaenyhfAEQ3rdiXV+M8vEgIl02vRCqWAU9w1bALrbXRlIOkMVWlI11lWcq
         V64g==
X-Gm-Message-State: AOAM532KYlSktKLTyyX3AOJYCP1203/Y7bYgNggi6yKQnCmGs6LkfoCL
        J3P7BFw4ijTrPrbPTy0NSjA=
X-Google-Smtp-Source: ABdhPJx22AJ4k2j6daZDoLSGFOkcXakF4VCwMPxXRdpFi8edJyvcMoWFNFK1GK2IrDo0a/2huS8CNQ==
X-Received: by 2002:aa7:d895:0:b0:42e:985:40f7 with SMTP id u21-20020aa7d895000000b0042e098540f7mr10936583edq.351.1654274147400;
        Fri, 03 Jun 2022 09:35:47 -0700 (PDT)
Received: from debian.home (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id n13-20020a056402060d00b0042dd630eb2csm4106189edv.96.2022.06.03.09.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 09:35:47 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     heiko@sntech.de
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ARM: dts: rockchip: fix rk3036 emac node compatible string
Date:   Fri,  3 Jun 2022 18:35:38 +0200
Message-Id: <20220603163539.537-2-jbx6244@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220603163539.537-1-jbx6244@gmail.com>
References: <20220603163539.537-1-jbx6244@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux kernel has no logic to decide which driver to probe first.
To prevent race conditions remove the rk3036 emac node
fall back compatible string.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
---
 arch/arm/boot/dts/rk3036.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 9b0f04975..e240b89b0 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -225,7 +225,7 @@
 	};
 
 	emac: ethernet@10200000 {
-		compatible = "rockchip,rk3036-emac", "snps,arc-emac";
+		compatible = "rockchip,rk3036-emac";
 		reg = <0x10200000 0x4000>;
 		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
-- 
2.20.1

