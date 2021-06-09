Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE543A208B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFIXM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFIXM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:12:27 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562B4C061574;
        Wed,  9 Jun 2021 16:10:20 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso5315796wmi.3;
        Wed, 09 Jun 2021 16:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PfozX53mqIuTOWhokMnsagdrlUUXn9Pvjxrq3cTYwNo=;
        b=HpzZu3FRw41etxBMDpD3F0ip0twtq1OU43K362uqWo1Hx68Az/GlYVQUNCjRDN/TRd
         lsIxjBsCHy2u6y4QdDo/4FElf9VIwc7la2HD4do5pF9pxJieCSc+GUK2bOsSnLn5JJs+
         PVcToGcwGpfZJ2KG1Vx8vSYhSe00T7mGFX1qo46rbJFwQt01hWgQRCccBENKKQ1HOzck
         2NwJ8BiK/pF/g8YM4is7q9IJnB2xJ3p3mSA4UrEREgnvgHkT4wvn5nKEA4VknXGy1DHU
         PxOpNVnyKjKooble35qu/jMgPeMa7rIZbmp3piriO6vZi832Yzlow5J+PljM1ljdzZeR
         ex8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PfozX53mqIuTOWhokMnsagdrlUUXn9Pvjxrq3cTYwNo=;
        b=PK04DJKtl+fLQP7UgqitcTfwdZdh82eJE5HhNCx/AJtNlZow6sN0SY4ae46iRCcE0q
         yVbATZO4K2alwoOlTmkX+6W6MtOBjYMzhso2Ssn1LlV3gFgOCPmhPZhbRvnXGBbJiXNE
         +6TZPjb6JmsS85LbS4SIxEdU4XmGk/Au7f5pMpgtIy3ohDv87yLsOpXMXGTaN0NSvm7s
         MqGGBmFjhlXEZImrbfC16wUURWYYoO6jo5rnu/7L3dicgyjh9NH7mq9eFu5V7HzTvTDY
         w3wLE2y+hHQ2Ef4Zr1IiQitmVknkd7DPlbAt/Xx0A5it9qt9kZsjM7B4726KpCn7bUwW
         FQIA==
X-Gm-Message-State: AOAM531tYyTgsN8BZpypDMG1MeIdBSbppQvpya9kx0/Y0lkmm5Vi7W+l
        BltjP3JJ/P19UO5kYNywY3BE+UUt4Tc=
X-Google-Smtp-Source: ABdhPJyjoIkw0I76bE7J5Ty+8KMNGSbrvux+nanyZyhIJAx8BRYOGTkTUfdMq84b41WCj5alfyDVxg==
X-Received: by 2002:a7b:c4da:: with SMTP id g26mr12286319wmk.64.1623280218702;
        Wed, 09 Jun 2021 16:10:18 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id q4sm2830147wma.32.2021.06.09.16.10.17
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 09 Jun 2021 16:10:18 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Matthew Hagan <mnhagan88@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH RESEND 2/2] dt-bindings: net: stmmac: add ahb reset to example
Date:   Thu, 10 Jun 2021 00:09:45 +0100
Message-Id: <20210609230946.1294326-3-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210609230946.1294326-1-mnhagan88@gmail.com>
References: <20210609230946.1294326-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ahb reset to the reset properties within the example GMAC node.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 Documentation/devicetree/bindings/net/ipq806x-dwmac.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ipq806x-dwmac.txt b/Documentation/devicetree/bindings/net/ipq806x-dwmac.txt
index 6d7ab4e524d4..ef5fd9f0b156 100644
--- a/Documentation/devicetree/bindings/net/ipq806x-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/ipq806x-dwmac.txt
@@ -30,6 +30,7 @@ Example:
 		clocks = <&gcc GMAC_CORE1_CLK>;
 		clock-names = "stmmaceth";
 
-		resets = <&gcc GMAC_CORE1_RESET>;
-		reset-names = "stmmaceth";
+		resets = <&gcc GMAC_CORE1_RESET>,
+			 <&gcc GMAC_AHB_RESET>;
+		reset-names = "stmmaceth", "ahb";
 	};
-- 
2.26.3

