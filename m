Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBB76CA714
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjC0OMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjC0OMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:12:03 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A12155AE;
        Mon, 27 Mar 2023 07:11:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d17so8931102wrb.11;
        Mon, 27 Mar 2023 07:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kRx8/9Oo8Ezq1aHd7HdN9nepqFDv6AoXlmRIJbikFuk=;
        b=PfKUtNWq3gqDlyLY18gk5tD5VBGNVZa+wUwyTRsZxYlEu9lLSZcjnS+L87V4NFXjXZ
         auk4OEqDxDvCkNtiD8JSfLEUfddHaKdkyH4Kw1gcNZUDHmgg8YywEyQCr6FxYPcE5CoR
         SzEI7CfGV/U5MwIkXMCaaGrnvNFR3vnw5mDtQPDY+R6r8RWUQ5JBlBy19WtY1nKTrFHX
         ArFTcsyl7jrG3T//YctjNW+axo0FABK5GsMWPYI22/tlDafaBQKAWMLt4ig6qQr9+E2s
         4BYh6UjHI4nFrDIyzUmZI281rUxkLbhOokfgDy/q9sRnldN8wa9y7oEKm3/0QnzxOLVu
         Z18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRx8/9Oo8Ezq1aHd7HdN9nepqFDv6AoXlmRIJbikFuk=;
        b=JaD0Bfe8TJwA1J+Oq3AVv0aEJPl8edt2jsxliCFNuiURCa3vXFYpiu8OvnCuNQo/XL
         BmvtLC4lTRay/VZs7BeO0J6CQluxB5tYdiWXYJhexf8z2b+FGFliHyZ2yiyukHHOtRLd
         WXCLUEB1BqCduD3RZAwmvmsV30v+v48YBojqQ+LudrLhKvFfESTn5m4lS6i3NAaLvZrF
         Yxe73jvVaGyC/bs9KIJphdxE/dB0G599pPq24BI26fkiLCcueHSX7ui3ADMnh7sClF7v
         nwRoUm8xYwA0zAYJMSsWElPOBqHaT4k9qkixC81BSpSvNnRsZIQPEPmtVIl8Ltd4Ai5s
         1tpw==
X-Gm-Message-State: AAQBX9do8VEpFkak3YUxZyiKAQGZPFqOfkVDj5hdvhqlsWObZACKAEr/
        t7TBW3fmIurIJyAWJPhojFQ=
X-Google-Smtp-Source: AKy350akHSgr93UvRjPgL/gvA9wUZIwcKGkWpcRe9ctOuZ5MGxTQvboX+44eNVzJxp6F8KtXUQBvlw==
X-Received: by 2002:adf:f9cc:0:b0:2ce:a777:90c4 with SMTP id w12-20020adff9cc000000b002cea77790c4mr8409285wrr.31.1679926276396;
        Mon, 27 Mar 2023 07:11:16 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:16 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 11/16] dt-bindings: net: ethernet-controller: Document support for LEDs node
Date:   Mon, 27 Mar 2023 16:10:26 +0200
Message-Id: <20230327141031.11904-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for LEDs node in ethernet-controller.
Ethernet Controller may support different LEDs that can be configured
for different operation like blinking on traffic event or port link.

Also add some Documentation to describe the difference of these nodes
compared to PHY LEDs, since ethernet-controller LEDs are controllable
by the ethernet controller regs and the possible intergated PHY doesn't
have control on them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/ethernet-controller.yaml   | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..e2558787531b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -222,6 +222,16 @@ properties:
         required:
           - speed
 
+  leds:
+    description:
+      Describes the LEDs associated by Ethernet Controller.
+      These LEDs are not integrated in the PHY and PHY doesn't have any
+      control on them. Ethernet Controller regs are used to control
+      these defined LEDs.
+
+    allOf:
+      - $ref: /schemas/leds/leds-ethernet.yaml#
+
 dependencies:
   pcs-handle-names: [pcs-handle]
 
-- 
2.39.2

