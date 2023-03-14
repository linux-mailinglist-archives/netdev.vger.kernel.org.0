Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6EB6B9B1C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjCNQSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjCNQSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFCE9E305;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id x22so5274196wmj.3;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WgoBUd5mOfOzbUIgE9ennXfu8Bk6ZG8n46SEtwJM8yA=;
        b=bvY9KqcvkaLOBhSxbT82TpGiQgMgFeH7RsFtKi/a76dLxp0RM6C8/TigvQ6sDKAf9N
         neKgFywXoTNG/g9CistYrBxx4R/Zr3A5oJzinni2SudO/jr5h1dW3smkV1e8ytswgaxq
         ObDxc5dd5iGSwLfixP73ykkJ5tmh42hyzyqByhIDGkuTflAchuOB16E4BhqFW0vTD3TK
         GChwtkCvEzXq195/ICDuToGgMSZ2ndsALlbGIMPcjQ1txoaHQroaVUJK8zUqM6XKYoq6
         YXL/gofueztsS4TRYeIEfgoyKytKQ0zCPsWW+zd/BBL5T/zwVjPBiD6z+0Wex9wPU1r0
         CXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WgoBUd5mOfOzbUIgE9ennXfu8Bk6ZG8n46SEtwJM8yA=;
        b=38dLEEGuDlKUoOde/QErm1xItr5oVDizc8gVbLZtZpSgPdl2KMkwzB/+cw/Woa6MjI
         RnYR0LwR0otRK0LoxdlZ9b7IdTcbGPBsFFpI9AH7hVJCorRn9XPxoKZMPj4nuW9zOgF0
         nv24JpG/PD3MPiiubAsnl2Of9uqxFfDknFVv6mHRsiaBzhdRa6/0fTmRyGU9L7fZ0Y+H
         UE3o+qdIOYj+6CQQIv5R8biq12ytvw6AWUxgZczBY750PUpcUWT01V/3Kn00Up7DwnXR
         ds/8f9maJ9NymGe27ADmMz+l2V0kFqqiEuILxJIq5cHzN8w/27mqvDZbqw/JUL9ftra+
         g96g==
X-Gm-Message-State: AO0yUKVdvx9dtz3tNYhgmoRNpwfq7N01PBlKv1lxsUSAmh4QQKq3wVKE
        JNYaIz+3VVpb3SbT8mYRg3o=
X-Google-Smtp-Source: AK7set+yoNZIr/H4OgvWsKzTzS5uR0E4RDAJ6dOe4qFsaMtkSpkQ8GPos1cx9dpT7H64FfPrKCr/IQ==
X-Received: by 2002:a05:600c:4448:b0:3dc:1687:9ba2 with SMTP id v8-20020a05600c444800b003dc16879ba2mr14666001wmn.35.1678810653583;
        Tue, 14 Mar 2023 09:17:33 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:33 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v3 09/14] dt-bindings: net: dsa: dsa-port: Document support for LEDs node
Date:   Tue, 14 Mar 2023 11:15:11 +0100
Message-Id: <20230314101516.20427-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for LEDs node in dsa port.
Switch may support different LEDs that can be configured for different
operation like blinking on traffic event or port link.

Also add some Documentation to describe the difference of these nodes
compared to PHY LEDs, since dsa-port LEDs are controllable by the switch
regs and the possible intergated PHY doesn't have control on them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 480120469953..1bf4151e5155 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -59,6 +59,27 @@ properties:
       - rtl8_4t
       - seville
 
+  leds:
+    type: object
+    description:
+      Describes the LEDs associated by the Switch Port and controllable
+      in its MACs. These LEDs are not integrated in the PHY and PHY
+      doesn't have any control on them. Switch regs are used to control
+      these Switch Port LEDs.
+
+    properties:
+      '#address-cells':
+        const: 1
+
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      '^led(@[a-f0-9]+)?$':
+        $ref: /schemas/leds/common.yaml#
+
+    additionalProperties: false
+
 # CPU and DSA ports must have phylink-compatible link descriptions
 if:
   oneOf:
-- 
2.39.2

