Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8F549CF28
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbiAZQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiAZQF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:05:59 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5468AC061749
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:59 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id n8so23509309lfq.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ShRv9pV2AiOoQ7kKf6pAT6HNznQzxV/dtMmDpxzFPcg=;
        b=x/mBXdR5xx1bnGxI0gToBwM8f+86VgfurgD7HrCzY4IDZ4GW3oJ07mtynE4A/KBMWU
         yghTqu/ixf5zAZ7Vd/eJhjVVfiJ83QudJ390VSd6J1bc7dN42gKpVaE+D/YUc6p0XYDl
         Xkn1GkZLQcbJdtv5FcCf4H/KNuubUTZDihhWet0x80YAQ57/ea2WlskuBHh9CN/aJyOb
         8oPol5kjPmoR+YC5uhW4ctY6hn1NOoQA0rOyVq8QJ8x1zse1Ih7XMLh59zO+mQwgOTVs
         AXREqT/Uzlevgvpp68Zzx0czl/GhwIR/XhM4RlxSlgmWfvohkht7fBTuP4/ojLlSsWbi
         xZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ShRv9pV2AiOoQ7kKf6pAT6HNznQzxV/dtMmDpxzFPcg=;
        b=IQYcZkrUycxfIpSgZEc9MZ7UmEnib8vtnGWsO9R+pl1ep9ha+CVZrulTR9CkuJuUK1
         LXP7p3nP2S40fmzA5dsByAa8MF9ogZYOcgNi+jKani9kCmk+W4nSzXJjfpVIZ/gMTo2i
         Rny24Rd9ZnlTwqIKImdQJSl9dVaeIQ+h+u7a1HN8gjCDjZPBeD2FczHamQIWvHhIT0bg
         RMYjD8aX9QN6BpacAzaeJWs0gy6MARrr62MCmqk4LgUK+sCOw7NZmONiF+FHdxbInbnb
         0RNjoLv4dOXVG3lVCO7rvLW/tmFguPIg9xNXQg/vR1wYMFKE71qOfoCrJUcg/9u9WIrO
         Pb9Q==
X-Gm-Message-State: AOAM5303VfeX/07RPNzqenRAeHAJfJsonjZqRCzEZHP73rInlG+KUaxa
        /MwoopJykt/7+n+W7kcbfpzVrQ==
X-Google-Smtp-Source: ABdhPJx0jRxATWymTrblnpnNQ0Bh0U6mtk54N2Aq+6epLPW62w5Iza5uwSyU0BFxEpANkmB47UhGdA==
X-Received: by 2002:a05:6512:130b:: with SMTP id x11mr20691710lfu.660.1643213157285;
        Wed, 26 Jan 2022 08:05:57 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p6sm1869984lfa.241.2022.01.26.08.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:05:56 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 5/5] dt-bindings: net: xgmac_mdio: Add "clock-frequency" and "suppress-preamble"
Date:   Wed, 26 Jan 2022 17:05:43 +0100
Message-Id: <20220126160544.1179489-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126160544.1179489-1-tobias@waldekranz.com>
References: <20220126160544.1179489-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver now supports the standard "clock-frequency" and
"suppress-preamble" properties, do document them in the binding
description.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../devicetree/bindings/net/fsl-fman.txt      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index cd5288fb4318..801efc7d6818 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -388,6 +388,25 @@ PROPERTIES
 		Value type: <prop-encoded-array>
 		Definition: A standard property.
 
+- clocks
+		Usage: optional
+		Value type: <phandle>
+		Definition: A reference to the input clock of the controller
+		from which the MDC frequency is derived.
+
+- clock-frequency
+		Usage: optional
+		Value type: <u32>
+		Definition: Specifies the external MDC frequency, in Hertz, to
+		be used. Requires that the input clock is specified in the
+		"clocks" property. See also: mdio.yaml.
+
+- suppress-preamble
+		Usage: optional
+		Value type: <boolean>
+		Definition: Disable generation of preamble bits. See also:
+		mdio.yaml.
+
 - interrupts
 		Usage: required for external MDIO
 		Value type: <prop-encoded-array>
-- 
2.25.1

