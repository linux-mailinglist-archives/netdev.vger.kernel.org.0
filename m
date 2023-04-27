Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCB96F0D6A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 22:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344311AbjD0Upu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 16:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbjD0Upt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 16:45:49 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A002AE56
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-94eff00bcdaso1671791266b.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1682628346; x=1685220346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hf8K+LPV3HpQoodPsHclIndfavzTHfh5H+b7Pu9+qX0=;
        b=lYQb9N0DXJFaYlcVpdVJTsWypegS4pxbOgWG4uYPWRv0tlbBFBKpgdjjuIJ7l89OKn
         MjxoNkkecvtACZfe3IMOjhngU6dFPvHM6Jb0dKqxdqG2fY33lE5vlStJ4DhOLLou9+Oc
         EFPe8U5O53BQC+dflc06JM2/KRewWS9Fgm8wY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682628346; x=1685220346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hf8K+LPV3HpQoodPsHclIndfavzTHfh5H+b7Pu9+qX0=;
        b=RwCZbUE2kzk60Y8jwp+t6P1DLZVGD06cel04z9GHJNDNAl+fiY0DUszpRFODei2BYo
         1eR6rhPvMjiZerOCWPlvNmx/ZMBf9x0onruHvoAXRaayoBnDHPeWpEgFbtra59+cI56y
         zkR/2hK1lbAU+GJdTb5uO/JWKF+rDBkkRUmnACaA8DdP2PzuA+AEbbCrb2RKNpWigdco
         s/BJtHg21HGEwQ7L89MymrFPSfXbP+6O+1uUbwGQ9uB3t2cgXiuW34kQwTs3sZlZ+nlq
         oDq9lNBSgkxSshPR+MZk+ITZ8bpgCUzHR0enB2UEgCrCa4PF7PdRlpYNmcyS4uzf2ec5
         Oy0g==
X-Gm-Message-State: AC+VfDysEzKIGfjG6vzDkIHP2g8Kj/v7O0Wgf11BotRYQZ7W2F+r832I
        UMvEBPIgEtNtf7voGF6Usd7sYQ==
X-Google-Smtp-Source: ACHHUZ7f+2fEQbl7Qy1ajgnJooRSCuUwsjTRMFmMCuy0tPNeKm5PO7GL8KTfujgsTrfBLu+ShkBDpA==
X-Received: by 2002:a17:906:9b86:b0:957:758e:df57 with SMTP id dd6-20020a1709069b8600b00957758edf57mr3360655ejc.65.1682628346138;
        Thu, 27 Apr 2023 13:45:46 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-5-99-194.retail.telecomitalia.it. [87.5.99.194])
        by smtp.gmail.com with ESMTPSA id s12-20020a170906bc4c00b00947ed087a2csm10171360ejv.154.2023.04.27.13.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 13:45:45 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH v2 1/5] dt-bindings: net: can: add "st,can-secondary" property
Date:   Thu, 27 Apr 2023 22:45:36 +0200
Message-Id: <20230427204540.3126234-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230427204540.3126234-1-dario.binacchi@amarulasolutions.com>
References: <20230427204540.3126234-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the stm32f7 Socs the can peripheral can be in single or dual
configuration. In the dual configuration, in turn, it can be in primary
or secondary mode. The addition of the 'st,can-secondary' property allows
you to specify this mode in the dual configuration.

CAN peripheral nodes in single configuration contain neither
"st,can-primary" nor "st,can-secondary".

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 .../bindings/net/can/st,stm32-bxcan.yaml      | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
index 769fa5c27b76..de1d4298893b 100644
--- a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
@@ -21,11 +21,22 @@ properties:
 
   st,can-primary:
     description:
-      Primary and secondary mode of the bxCAN peripheral is only relevant
-      if the chip has two CAN peripherals. In that case they share some
-      of the required logic.
+      Primary mode of the bxCAN peripheral is only relevant if the chip has
+      two CAN peripherals in dual CAN configuration. In that case they share
+      some of the required logic.
+      Not to be used if the peripheral is in single CAN configuration.
       To avoid misunderstandings, it should be noted that ST documentation
-      uses the terms master/slave instead of primary/secondary.
+      uses the terms master instead of primary.
+    type: boolean
+
+  st,can-secondary:
+    description:
+      Secondary mode of the bxCAN peripheral is only relevant if the chip
+      has two CAN peripherals in dual CAN configuration. In that case they
+      share some of the required logic.
+      Not to be used if the peripheral is in single CAN configuration.
+      To avoid misunderstandings, it should be noted that ST documentation
+      uses the terms slave instead of secondary.
     type: boolean
 
   reg:
-- 
2.32.0

