Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025176C1ACD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjCTQBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbjCTQAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:00:22 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D173E098;
        Mon, 20 Mar 2023 08:50:38 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id t17-20020a05600c451100b003edc906aeeaso1726006wmo.1;
        Mon, 20 Mar 2023 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679327429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4WowCy7T0H+njmwrpybA4xHuDLSu+Hwz5aLcZi6Vxww=;
        b=kd+30FD1OD+jrXvzXKpCPBrsvUQpndE/ohh32I8bnf+Mq7tGL/fzCno/sNvQOggJkv
         iOMXTik9K10LefkzWNufRbIkV/cNEQPnN6fqNArPUAHv6NcS14H6dB92u2S/lkmjxj79
         QQk1y2Lg4QfKCGQXZOuHlFdyuJ/QioX+xSK+jKuBz0N0NQS/duwsmVglMrhS20da/17Q
         sc6tZowjzzXxNNgZp5mWheJB1civrE+Mp4180YEUenqg7Qz1tUypZxh/9q/3RmdNwK+4
         B2muT45W0/mePyY3mpy05nqmRW2l+B9ssXW0fMBFMLnd+6/qYk60WtS9ZWlNBKr4MWOp
         QJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4WowCy7T0H+njmwrpybA4xHuDLSu+Hwz5aLcZi6Vxww=;
        b=RlVGCuDkb4raTUiJX4WibUqKbsm9TCM8tJ7lA0FTozyx7MbFHA+5ewd5O7tvQ3Kqj6
         WSvh7MMWifXTqM80r9qVhAFM3zT8dj1J2KF/KPz3L7bU+QYYCZRAbwevIn+pvP8NO2Ur
         zMcPNr3BsAs6Zi7IMSe7iJyd1ogNyNW11krY+Iw4cdP7GInULxLU5MLmS/L9VD0liCQN
         YereUJk7YOUcyecy+3niOiWqJsHCuiAfu1zMgoIFcCKR6GnmdRBQU1fix36sBD4DfdoJ
         eGJun/b3f34L0wo36FTWU8+hfBFXa860UUwaQVVUNGzoqBOvoGUISeE6AeOqpPYKI10u
         41Iw==
X-Gm-Message-State: AO0yUKWf/Q3ebQiFtsN4zh5dOkOmKdWQ8fu2t5qcdDF16zun6g9gpq7Q
        NfP+TxopIX5HDx7/ekF6zcc=
X-Google-Smtp-Source: AK7set86QvkM5ncFkafXcXRdyFB+9Y3Qn8kU8UkN8z/voSwFKxjgAJVrAN0Fwh5YpjFVr7Z8M3QrDw==
X-Received: by 2002:a05:600c:40c:b0:3ed:358e:c1ec with SMTP id q12-20020a05600c040c00b003ed358ec1ecmr80342wmb.0.1679327429411;
        Mon, 20 Mar 2023 08:50:29 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c020300b003eddefd8792sm4812333wmi.14.2023.03.20.08.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:50:29 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 1/4] dt-bindings: net: dsa: b53: add more 63xx SoCs
Date:   Mon, 20 Mar 2023 16:50:21 +0100
Message-Id: <20230320155024.164523-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230320155024.164523-1-noltari@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 5bef4128d175..57e0ef93b134 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -57,8 +57,11 @@ properties:
       - items:
           - enum:
               - brcm,bcm3384-switch
+              - brcm,bcm6318-switch
               - brcm,bcm6328-switch
+              - brcm,bcm6362-switch
               - brcm,bcm6368-switch
+              - brcm,bcm63268-switch
           - const: brcm,bcm63xx-switch
 
 required:
-- 
2.30.2

