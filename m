Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C084EDE8F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbiCaQRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbiCaQQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:16:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BAD1E8CEE;
        Thu, 31 Mar 2022 09:15:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h1so28775764edj.1;
        Thu, 31 Mar 2022 09:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OyWs2PSSxtF9m14bGEh5PR47UxvU/WKdZospW5gj6qg=;
        b=HTT6ZLTJNQ8qCXR9E/1BApriM3s3Ljwl5uB1+QOPCmD9psvoOhnTLZfFNEEkMRE6OU
         p3SuGyYZ79+jJfSMICnTyQJ76MyaIiW77LSb5huk41tSyKTdrBerHvsxIWjL+et2YCFq
         xApLDDwOvUYyY4LE0Pas47UHoEW5YAZJiuqdAFVBx79jPpUkLTIT0U1iy0h9i0iyd+tX
         wubws89HwyVj0KL7EXrLucBtfNlk5FGcEdzlD7J6VVXcKnk0n32wTpgSuNq4XxOqBJRO
         tdKEYh/+OfIg3K3jWAJnQ6hW4sMkPjDqVD6CRC/BmyDmJRlH5CCUtn92uj6Fu0K+0hIn
         bArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OyWs2PSSxtF9m14bGEh5PR47UxvU/WKdZospW5gj6qg=;
        b=RAjYHGbfjMi3YyFVGZvacl+Cya4fm1tyRHuOjAGBLb1wWtss6JLEc6vpXbi50MzCDh
         kNIwWIdEC5Ec+S3PKAi9PWGUI22h3mqs4LDoQA9Sde2ggIpYoGL4zUXRX2icZKkcdKO6
         kg7Y6oF1eGznz125f1ngE+5PsXubmc/FAFmGA/Dwo8E6giRfu1pQovtxJpNQg7f5WoDy
         mXWwzeSF2pcJ5eaa/XHF5v/7z/Hza2fXiOXhONanOoJgqmymwzdG8S73gsqqn3dzlwWj
         dAr1cksoot2Lml6kHMya+fOMHdZgRYVSzSkqhwVY0COLdc7xHJsGFZFUkLSzz+LRK7A2
         +hDQ==
X-Gm-Message-State: AOAM533x7kwqlIwcvFVrEqWDpZdMhsuyp2X4kqyB/a741UjpYXYccTgr
        kS21meAUfGOrfrOJTXvUqSOTYz2+sPw=
X-Google-Smtp-Source: ABdhPJxr5AqLCJaD0MU5j8UJPoZLzcNzluV9Kl5Rl3Z5NcPq3uGg2l6oeqnVXZHOO5GJumuHPLmwOQ==
X-Received: by 2002:a05:6402:5146:b0:415:fd95:6afa with SMTP id n6-20020a056402514600b00415fd956afamr17406575edd.200.1648743308450;
        Thu, 31 Mar 2022 09:15:08 -0700 (PDT)
Received: from debian.home (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906520400b006e0b798a0b8sm7600302ejm.94.2022.03.31.09.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 09:15:08 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     heiko@sntech.de
Cc:     robh+dt@kernel.org, krzk+dt@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] ARM: dts: rockchip: fix rk3036 emac node compatible string
Date:   Thu, 31 Mar 2022 18:14:58 +0200
Message-Id: <20220331161459.16499-2-jbx6244@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220331161459.16499-1-jbx6244@gmail.com>
References: <20220331161459.16499-1-jbx6244@gmail.com>
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

