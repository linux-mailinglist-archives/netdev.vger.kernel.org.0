Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C715E42B1EF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhJMBSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhJMBSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F15C061570;
        Tue, 12 Oct 2021 18:16:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i20so3097175edj.10;
        Tue, 12 Oct 2021 18:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vuCloQf4zkp+Q+tehI2QaaOLbGg4OF1X2bYcV2C3N6U=;
        b=dCKJLy/LU47YcQy8pulLVK45ntOALo4qp/yOTSVJYrYkkv9hY5wK0va8HL6j5QsQ1B
         IYpYB3oWOCX8+osbE/AAEbDs0ZMBLTsJTGgH8f1O5nsVWYV2CNtdV5C6HXXxYlGsr5eQ
         SEhAe9ZAg2RcBA5HhaHRenNlaXmew69Lqh6h3AuqDP3latBJFQjr79ee0iyT2HeGC6Rh
         u4c/lG/HvhGos9VAkkZrvAfiqS64cNQUGol/FkHGEPIMn9ow+I2iEi7sMASexZ9h3cOZ
         wtmZ1c1R0MEOTTh6IrlDr484TLnwSC4UB/n7Q+rFykJwhCa8z1+y+qZSb3lr5lMpS6D3
         k5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vuCloQf4zkp+Q+tehI2QaaOLbGg4OF1X2bYcV2C3N6U=;
        b=uBcEKJe51/nDXde08DZyyuRn7y5Ri5jZBToKaxOAnRiOL3NMsHZD8GluH+yQi3T/4t
         fKha9DdVRvJDpY50B7WqD1eaXEG5WrLXgCS2ygvgKX0OlCdMTRhXexx2fqxLmO7/cuVy
         R+kkfRDIUA7WeyzJTVdlv7coHsyr90fHC7IY+ikNLthM2IeJrACPrXpz2+QYlbQpI6tu
         edEDKtR1m2WI+zD5QwsB90SGFPv1XIyFPh0qHm1RRX2s7h+cZDvdBl0wfNwWijJWvLwN
         nF+Y6A/ZWoGIqTDAzID+EPm2JdS+YiSVqXZk8bD9g2gFe86HPsM/KVLyJsKcfW73UbeG
         c2iw==
X-Gm-Message-State: AOAM530YYZ0dGrX9JBC2Ha69rPSkCtLSIxkyp2ipRreT3n3tnyzQhkVz
        OQEW0EG5V7/iDuPepYuREgeTfbIG8Oc=
X-Google-Smtp-Source: ABdhPJxOEKWLFrWFNYyeZcw0LTt0uKrXcM8/Dj5soFthTXA2nk7K8nIXlOA8Q6U0aKOmLqGrSRm7YQ==
X-Received: by 2002:a05:6402:410:: with SMTP id q16mr5108098edv.286.1634087787458;
        Tue, 12 Oct 2021 18:16:27 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v6 02/16] dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
Date:   Wed, 13 Oct 2021 03:16:08 +0200
Message-Id: <20211013011622.10537-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and descriptions of additional PORT0_PAD_CTRL properties.
qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
phase to failling edge.

Co-developed-by: Matthew Hagan <mnhagan88@gmail.com>
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

