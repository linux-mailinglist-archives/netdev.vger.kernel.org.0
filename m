Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBAF427E47
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhJJB6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhJJB6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:13 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCABC061762;
        Sat,  9 Oct 2021 18:56:15 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z20so51776423edc.13;
        Sat, 09 Oct 2021 18:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSbsp53GPbC1UoykdeP64z97Nxwqf8jxKnT8asaP0f0=;
        b=SEhdXWZXR3Zg3cEXLMOvSnbzmzQTu3N0gyrtXKF5hJKVM3qRKrRU1oC3HXBj11rn+n
         AuMo3Xs7vTsldM0/nXVHKI7D/zZnTRMlS+vitrzdbGgit9I/jSepZ9lKTep87q3yaC7x
         RYJBWlG8D1vAsJO7a7f/SQZtB/pSMaD31oPrXCO0dgL1TRkcMCBnGkpblMuZ6JtNzreZ
         jMiXgk2bLKDzIfMGX50ejWFWbRCQ3UPQxLlpE4mc+ollpof5BhLRZmyUo3+QJ3OXIqLk
         XZpzXxeQsZGITOj7cPrLlbUKmti6GjU/12wzhL2vvZK789rH+EQ0KV4YOSDEV2QD5ZnA
         nKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSbsp53GPbC1UoykdeP64z97Nxwqf8jxKnT8asaP0f0=;
        b=c/sQ2pwtr1o5PLopy/X7ie7KDTerqUiRrwirbLoHzN3ACkBMycknSi5mUaFjPpqCF0
         b6FZfKVEgiHsHaBl6Ih+mb3DQeccElxisd4cRZj/oYTYvD+zbHtvDgH6O2LezzHNqPkT
         YIyTXQ03joscnVc0n/PPpw8Ducnz5x2NhcZ1vkGkQEwEjDw1cly87aLlepvTt1Ctl1hF
         yLk4migX5q82fGgSZDUZvxz7fpJYirFoDA8CDaJR4gDpfzow+VkLw3nikp/YmQ3m5M7V
         Il5M4CGIDhSwDzI/xbp558/ZzHqrY0gvj+tQKnWHnm6nTbHeRNguSSFSdl5Iv9PYAJmt
         yTFA==
X-Gm-Message-State: AOAM5302UKgMuCY5WCdOgwQESs2rRaZi0E86Agzr7zv5v5UM33e3R28h
        sLhAZl7v6UP6k+rO04J3jn8=
X-Google-Smtp-Source: ABdhPJwHxxuDwlcqRFhDbQ+FIiqvpX/NAY++0ZP2I64W/55E77aW0rVB7hmYedr+wdJUxICtadWOYQ==
X-Received: by 2002:a50:d8c7:: with SMTP id y7mr28332740edj.133.1633830972894;
        Sat, 09 Oct 2021 18:56:12 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:12 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v3 03/13] dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
Date:   Sun, 10 Oct 2021 03:55:53 +0200
Message-Id: <20211010015603.24483-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and descriptions of additional PORT0_PAD_CTRL properties.
qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
phase to failling edge.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 8c73f67c43ca..cc214e655442 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -37,6 +37,10 @@ A CPU port node has the following optional node:
                           managed entity. See
                           Documentation/devicetree/bindings/net/fixed-link.txt
                           for details.
+- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
+                                Mostly used in qca8327 with CPU port 0 set to
+                                sgmii.
+- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

