Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D19A39CA48
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFERnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhFERnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:43:46 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76FDC061766;
        Sat,  5 Jun 2021 10:41:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e11so2310888wrg.3;
        Sat, 05 Jun 2021 10:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zDrH59vPVGwHTPRMUG66pWvn8DwNgjhaTZ8+7bVvWks=;
        b=hvBFg06ltlfMtFlCvnLQq1j7N9UIN3KeE7n8H53Qw+eQ4bR4Rsl7HVWxa5tn2hy5/H
         nrFs87Ymz7vSIjN+IghhgpGNbKzkVzdb1KznXrQmiVeDyShc25SMLdgEo4qBaVsW/8IT
         jTiRTL2zjzHQp6fEXT3wmZ1xeKvdG86xBPzPQ9n0PbxCWfxmh5VKXha5vUXzukrqwpZU
         15wtQ1wpcc3EO7MHAmJA7TaXLdDKEvRqdy/a9njJSAti+tj3ncVCQrv+w1gmh06WhnEI
         em7TI/c863zZiU5bXf5Yjg9L0LbqU/ksjsO0LtIo4jfECxYxJX/k4PIlZnAGuxmFz+xT
         +ckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zDrH59vPVGwHTPRMUG66pWvn8DwNgjhaTZ8+7bVvWks=;
        b=KsXasaXgTi1aFGG0n1WkTCSRnMXfNoIqZ4EANFCoWymyGKay5BItuOqfRLxhCqHxse
         dY0KFg3SCQ9xqPLC2onOWaI0xljBK5W5rOHklcpwjDU5uL1XVxuF0KTr+5dcEOqZqBfa
         NNWfyVnS7xTK6FpHc5Zh7HhYgg0RNwOl7PWHqEXGuruMaBufCuhPesmLBJE0Ss4PLwcq
         /Onzst6aNCnMy1lHE5iTpLUSLf37girm12R5DVPvqT2/Q8VXa/eiIPeBd9+X7p2dHixu
         GCrDuyz0dudZyOmaFSduEdnGWGhSRj8+u3a31juj9rgDr1sG/JV+GVfmnfKrhU/FBkPz
         cB2Q==
X-Gm-Message-State: AOAM5334+KoURJdwh32yBpLE6HEYvE5ZtLsOBtbPLxE5QHHJ4dxqpxot
        xCk3unPNcMd/Wn91bVWlXg4=
X-Google-Smtp-Source: ABdhPJx3BUcRirbykVkDF5f4joc8UrtKp3p0OEUvd2smzOzw0Qw6oI6yfoY4Mg2YdD8+Vsjqe9+fYQ==
X-Received: by 2002:a5d:538c:: with SMTP id d12mr9251525wrv.116.1622914916430;
        Sat, 05 Jun 2021 10:41:56 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id t4sm10352505wru.53.2021.06.05.10.41.55
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 05 Jun 2021 10:41:56 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] dt-bindings: net: stmmac: add ahb reset to example
Date:   Sat,  5 Jun 2021 18:35:39 +0100
Message-Id: <20210605173546.4102455-3-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210605173546.4102455-1-mnhagan88@gmail.com>
References: <20210605173546.4102455-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ahb reset to the reset properties within the example gmac node.

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

