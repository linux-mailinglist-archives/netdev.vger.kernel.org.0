Return-Path: <netdev+bounces-902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 849836FB4B9
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ACDF280CB7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599C35388;
	Mon,  8 May 2023 16:08:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46156525D
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:08:19 +0000 (UTC)
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E33B5243;
	Mon,  8 May 2023 09:08:18 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1929818d7faso32415023fac.0;
        Mon, 08 May 2023 09:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683562097; x=1686154097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1Sdn3cY34mbROpVOZmUz0voYYViR2D+rO4YXIzNRJw=;
        b=eg/BLvUR/R6QusB1qBcDlIKIz97DNjMmM3OOfHlPMz1tuyNvX7i6Y+u37hNz+uf5m1
         hRiSkYpV0a8C99cm7J98yFUQ0xjw0KCaoniBstHSNOKMwwQxrD1RscqOj4iI8vZcGerI
         5uzExLyjQ3dnCfGD5OTqnuR03O09kVIOKjODYwbooriUD6yeEMlZ8+dfWwEs92bWcQqI
         tbiOyT5XoC/WjuhyfMK6F52yQcA8q50dOOOdcm4qMlKnzjaX4a5iON1/Zcok+++ZiVi2
         3NsYYcjF6yhl4570C5u+Uvj5S77drfaNCStarSTugY+57/mTHn93T1XtNd5EDzVkUJe/
         fL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683562097; x=1686154097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1Sdn3cY34mbROpVOZmUz0voYYViR2D+rO4YXIzNRJw=;
        b=KpiSv8NXKHX5yrGUdaNIcQygYLZg4I2DIuuo6RCpQOJvpaFFJJuq6ttUipmJAmM799
         PuY1f2jO/z4UFEK3xZYQW/Ak/MGruPPQQnSuqsHrceQzinAo6yfKWOhvvS1M0n/uch1e
         6/bRtofVSf3aF4Ha9OwCDfiLill/DOmT2Yx82uvjagrtrIry8Ef4PzrA0hmk9oJI8Ex3
         FSU28AADb1db4NsxSpe+dLRK9O+TmOW5SnLvJk+yB1I6DB3eqgx/sOn84WRHcul66koU
         RvCEg8KliMJA6nQBhKHvwGMuHFUJNh9rH769G1cxlheEn6vigDcgPeHp5TckEoc13Zpj
         0G/w==
X-Gm-Message-State: AC+VfDyGgaN7wxjsBSImbikk2e1TOcz/cB/vgfYELIEdxRdiZr8EQdRc
	C5loUWZwSlHoSZe1tXgQ/Bxa7ZppBL7mOg==
X-Google-Smtp-Source: ACHHUZ5/eRTQpv8E/Y3Thhptmhz9PhabAPNQN0tpgRgv8byeyOTsb+fGYFuQyGJ68QzxXv1web228w==
X-Received: by 2002:aca:2b14:0:b0:38d:ec3f:3117 with SMTP id i20-20020aca2b14000000b0038dec3f3117mr4746310oik.25.1683562097322;
        Mon, 08 May 2023 09:08:17 -0700 (PDT)
Received: from localhost.localdomain ([76.244.6.13])
        by smtp.gmail.com with ESMTPSA id v206-20020aca61d7000000b0038c0a359e74sm136391oib.31.2023.05.08.09.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 09:08:16 -0700 (PDT)
From: Chris Morgan <macroalpha82@gmail.com>
To: devicetree@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
	netdev@vger.kernel.org,
	anarsoul@gmail.com,
	alistair@alistair23.me,
	heiko@sntech.de,
	conor+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	Chris Morgan <macromorgan@hotmail.com>
Subject: [PATCH 1/2] dt-bindings: net: realtek-bluetooth: Fix RTL8821CS binding
Date: Mon,  8 May 2023 11:08:10 -0500
Message-Id: <20230508160811.3568213-2-macroalpha82@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508160811.3568213-1-macroalpha82@gmail.com>
References: <20230508160811.3568213-1-macroalpha82@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Chris Morgan <macromorgan@hotmail.com>

Update the fallback string for the RTL8821CS from realtek,rtl8822cs-bt
to realtek,rtl8723bs-bt. The difference between these two strings is
that the 8822cs enables power saving features that the 8723bs does not,
and in testing the 8821cs seems to have issues with these power saving
modes enabled.

Fixes: 95ee3a93239e ("dt-bindings: net: realtek-bluetooth: Add RTL8821CS")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
---
 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 8cc2b9924680..506ea9b17668 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -27,7 +27,7 @@ properties:
       - items:
           - enum:
               - realtek,rtl8821cs-bt
-          - const: realtek,rtl8822cs-bt
+          - const: realtek,rtl8723bs-bt
 
   device-wake-gpios:
     maxItems: 1
-- 
2.34.1


