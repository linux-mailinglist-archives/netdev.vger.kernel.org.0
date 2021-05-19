Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9700388557
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 05:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353035AbhESDeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 23:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353015AbhESDeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 23:34:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA55C06175F;
        Tue, 18 May 2021 20:32:47 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t193so8474455pgb.4;
        Tue, 18 May 2021 20:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cU46aoQaP3zsCAzQqoMqrX6Zi5wdFXKEcbXbGkFJHJg=;
        b=Py2UV9AnBv1/ncNmbnmTRHpSvk0WbcHX9zQmnaASFi6ATMOgoSsXAsOAMjegTa3vBH
         rSzQrZOXF17nMS98S7SoQT8kLVR5p7G2AO3hetRK6dTeHVG39sNdYXxI+CtlWUkeYyr/
         Q3f0qNRvqK8fB91FNP1hi7W2H4kNHynfovvdtyyI5CgkZ+BYskpmwAL/wb7qHdZf2TQa
         6HNF5dHPDvIdhT5z2GKZzC3p+KVaulPugVp+nFtz9LJyHTwq6rZqiJ2gAqf/FXIGAE2L
         vlaiwOmWMFgS938CHSzTrmujuMoYlX46SOKpl88ba9j5NTuBIHSY3pa0mIZeiE2/R2Z0
         i5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cU46aoQaP3zsCAzQqoMqrX6Zi5wdFXKEcbXbGkFJHJg=;
        b=ptH8HihUzEHpZzAAhpZGEcWh0EQY7evNCXJBDr9DsEd2TKVu6vPBxh/7GOLlVam9MA
         dSvDseGBcRT+Jkb2Uz5M99aM46Rxux5JHgAxQln1qGb05jmMugWj3XU6uto92LTtF1cl
         MHcL95b9qtcFzOvGPr9nt76gGOsHFhzG4sJtvwWTJh9pepsPTDH8Pg1sC28LnT4OiSf8
         7ezajhhjOMzNtQJnP+qvWjmnsaz1noDJmJ+59q9rLZTEoXlc7KTSdtvWg/qkRpM0J+Ml
         l8awn5FBqX6XsqWT9QKtMhTfR9rSrfBJFrIeCyXLQO26eLWqWJXaoh401TaXYHJ5ybhD
         Z/Yw==
X-Gm-Message-State: AOAM530eehVmy3s1ZtQGELXez+Z7l6QREoCbJx4VgfOaAonsw5m5Am3s
        VG5ykwVbWOoK+iOLaqrOTWI=
X-Google-Smtp-Source: ABdhPJyg3qe/ZpL5oLW+mOEa0aXvCaTmjpc+MZIEIy7hvq34/CDsFAbCKFaESSa4EpddYj5LR1b8sQ==
X-Received: by 2002:aa7:88c8:0:b029:2de:7b37:7d23 with SMTP id k8-20020aa788c80000b02902de7b377d23mr5902108pff.59.1621395167152;
        Tue, 18 May 2021 20:32:47 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g13sm8244587pfr.75.2021.05.18.20.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 20:32:46 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH net-next v2 4/4] staging: mt7621-dts: enable MT7530 interrupt controller
Date:   Wed, 19 May 2021 11:32:02 +0800
Message-Id: <20210519033202.3245667-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033202.3245667-1-dqfext@gmail.com>
References: <20210519033202.3245667-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MT7530 interrupt controller in the MT7621 SoC.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
v1 -> v2:
No changes.

 drivers/staging/mt7621-dts/mt7621.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index f0c9ae757bcd..093a7f8091b5 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -437,6 +437,10 @@ switch0: switch0@0 {
 				mediatek,mcm;
 				resets = <&rstctrl 2>;
 				reset-names = "mcm";
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
 
 				ports {
 					#address-cells = <1>;
-- 
2.25.1

