Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A326665665E
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 02:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiL0BHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 20:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiL0BHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 20:07:39 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E622AF1
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 17:07:38 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id g13so17761738lfv.7
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 17:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKjUuVwKy7MrjSAEHNMOGQAaYSQbj1BNhWoLDICHVlY=;
        b=F1hB1XenSCpaNpl/jTtpeCOe4pi+v3igAKxQAAtlGbvxzEei8fVTUlGmDKS9hC1xV6
         i5dksdDk80it6tVrB/yQ70ivkSCYipiBAjLnJMIp6h3s8OsHsImXkMzYUpccjsQYL11n
         R/NzNnes0vD6kULTRdSVE689dddLM06FQaWp1pQR9+nPr96mEjkKrG0d9VL8OHADYa+Y
         aWsff39+3rA/r2c8u6LR95f2/HGNqEpCtjz5VoIH/6IRIsccgzE5WrX94W6jk+R3mwN5
         +kVPPE5x7ndVwI/DspxTxv5snfWdhbNFA6Iaad67AKQ/LfxTwnThywr0q1YFacfS/eBR
         Ai4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKjUuVwKy7MrjSAEHNMOGQAaYSQbj1BNhWoLDICHVlY=;
        b=cxmX4KhRGG6nhbYQXyNSwzIQVcx0j/UfC67k9e+olFj+iwHn46qcjL5a6WjgJP62qw
         Ox/6DL/C8IqlJSmEQwLuIAUpuu/oyFPORdC9mQlF2Mq5iCsZ0ut9CuG6EufhjA848w04
         m3wm/ElkCdV5hauMIQ03OGOwlTqz/l/rqCv0w3NJGsS96zCZcVaKhSVUEcEkVMZ4jNjv
         UhLITS/ZaMXiAQMPY51ShxlqSxR1+s8Ih3pnD2rVk9hWGq93cGND6udLafXItkD7f+y/
         R0dcfw2bd268H5JE5gzkbbzKGSRQY0O+NqOQTFGQ//C0ZVAGahLf02nh5rRcD8WExs4v
         xXaQ==
X-Gm-Message-State: AFqh2kpR8JQATVaBLATx2EKXIz3j7Owye0mI62Gcs28TyPHAFdL51klg
        yX+VO9u7M1T7sjWQuv5w8pW1uw==
X-Google-Smtp-Source: AMrXdXteJKt3/ZtkyRWyMI+gfdzgFIxwpJbdwzmrYHW8w7ULsNIcLqRCc9x25aiHc4L5LjSoN7FHrQ==
X-Received: by 2002:a05:6512:3ba1:b0:4b5:8fbf:7dd6 with SMTP id g33-20020a0565123ba100b004b58fbf7dd6mr9788635lfv.61.1672103257296;
        Mon, 26 Dec 2022 17:07:37 -0800 (PST)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id l14-20020a2e99ce000000b00277159d7f2esm1392098ljj.104.2022.12.26.17.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 17:07:37 -0800 (PST)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        chris.packham@alliedtelesis.co.nz, netdev@vger.kernel.org,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [net PATCH 2/2] dt-bindings: net: marvell,orion-mdio: Fix examples
Date:   Tue, 27 Dec 2022 02:05:23 +0100
Message-Id: <20221227010523.59328-3-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221227010523.59328-1-mig@semihalf.com>
References: <20221227010523.59328-1-mig@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in marvell-orion-mdio.txt deleted in 'commit 0781434af811f
("dt-bindings: net: orion-mdio: Convert to JSON schema")' if
'interrupts' property is present, width of 'reg' should be 0x84.
Otherwise, width of 'reg' should be 0x4. Fix 'examples:' and extend it
by second example from marvell-orion-mdio.txt.

Signed-off-by: Michał Grzelak <mig@semihalf.com>
---
 .../devicetree/bindings/net/marvell,orion-mdio.yaml  | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
index 2b2b3f8709fc..d260794e92c5 100644
--- a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
@@ -47,9 +47,10 @@ unevaluatedProperties: false
 
 examples:
   - |
+    // MDIO binding with interrupt
     mdio@d0072004 {
       compatible = "marvell,orion-mdio";
-      reg = <0xd0072004 0x4>;
+      reg = <0xd0072004 0x84>;
       #address-cells = <1>;
       #size-cells = <0>;
       interrupts = <30>;
@@ -62,3 +63,12 @@ examples:
         reg = <1>;
       };
     };
+
+  - |
+    // MDIO binding without interrupt
+    mdio@d0072004 {
+      compatible = "marvell,orion-mdio";
+      reg = <0xd0072004 0x4>;
+      #address-cells = <1>;
+      #size-cells = <0>;
+    };
-- 
2.34.1

