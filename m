Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860B39CA4C
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhFERnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhFERns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:43:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591C2C061767;
        Sat,  5 Jun 2021 10:41:54 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a20so12572325wrc.0;
        Sat, 05 Jun 2021 10:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oah1BBk6Y8qhU47gnr9UeRS4FR5T5+vhU26zOHbYDd0=;
        b=eToU5pYflVrmUfM2RBvTfIowg9LsyFExJJ+ylXomzW+TNyNT/0z6vsHtO9bd2rioVG
         ysSQfyES5tqUtpOM+KgzhxdxkLFmPL5cWwcbGbR2SmLtDQ7HZKm8j+mJACSP/Wp06w30
         H4wDEfqAaT4n4lxcwR71wgRpyD7XLSTGnRikmhg7CAAqVdvraGiD60b72/CaL0n1/Rlf
         sMU8hlOd3Uf/uQcGdOJBrGGHq75+fZ41Lh1osZI5GcNiXoTaYhycCZD5R+vMMNYYnEoD
         oM4Fsn5Jo1mZ3Y79IkYg7oxTFv9qUxwDPeu7iuvVw037cC86qgN/6Gapr6nMwHsqj+Rx
         3FOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oah1BBk6Y8qhU47gnr9UeRS4FR5T5+vhU26zOHbYDd0=;
        b=GoaUlQi2hHNccHuDyJdrrnW4aHCL3hwKYfySW70PdvcAcgRZHwE6u2XjGz+MU7yhwq
         V+qHM6RwZGwirlwakhxu4hxTMVnWgfz5M2Y1dc8a6omTHQG04AhsQ7edcenDx5q0+rCW
         n9kLZnhz3ByGFjIavZJ/y20nJDL6cLDw25Fo8EGz7/lhEupmBnSess07cw/bvOnxx2jL
         OmkMpk30z6ow9/iLuJ+xbvXT6fmFECQ1bQHOrpCxb3zeGzGQChmSJCdMzxcKoupREyzF
         o5sDsfVr8wzcTW7AjvUczUuCxw9ZwqHBMinbSKmZpNcCdhj+8LhWw52M9dSwkHt3zOcf
         nPqw==
X-Gm-Message-State: AOAM5320gSM+FYESHTQc7aHudg+95LSWT+f8k2jv1RbGmPXwTz8uAFLb
        RZvaEuWtXCxQHCEN1if2Wes=
X-Google-Smtp-Source: ABdhPJwy4zHJqMZh4Mp1oF8UFr9fwyBd/rGqy5PapalODJQm8mXA7vcwbke+4HN4Nm9JX+K3IFKP2Q==
X-Received: by 2002:a5d:6dae:: with SMTP id u14mr9648108wrs.148.1622914908684;
        Sat, 05 Jun 2021 10:41:48 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id 89sm10987879wrq.14.2021.06.05.10.41.48
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 05 Jun 2021 10:41:48 -0700 (PDT)
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
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] ARM: dts: qcom: add ahb reset to ipq806x-gmac
Date:   Sat,  5 Jun 2021 18:35:38 +0100
Message-Id: <20210605173546.4102455-2-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210605173546.4102455-1-mnhagan88@gmail.com>
References: <20210605173546.4102455-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add GMAC_AHB_RESET to the resets property of each gmac node.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 arch/arm/boot/dts/qcom-ipq8064.dtsi | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 98995ead4413..1dbceaf3454b 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -643,8 +643,9 @@ gmac0: ethernet@37000000 {
 			clocks = <&gcc GMAC_CORE1_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE1_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE1_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
@@ -666,8 +667,9 @@ gmac1: ethernet@37200000 {
 			clocks = <&gcc GMAC_CORE2_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE2_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE2_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
@@ -689,8 +691,9 @@ gmac2: ethernet@37400000 {
 			clocks = <&gcc GMAC_CORE3_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE3_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE3_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
@@ -712,8 +715,9 @@ gmac3: ethernet@37600000 {
 			clocks = <&gcc GMAC_CORE4_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE4_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE4_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
-- 
2.26.3

