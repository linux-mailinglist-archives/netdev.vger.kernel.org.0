Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75026C7A08
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCXIlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCXIlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:41:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917772597B;
        Fri, 24 Mar 2023 01:41:44 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h8so4841065ede.8;
        Fri, 24 Mar 2023 01:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679647303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WU50z4VKSDp0eMNK4Kny9eBvj2EctECAi0vFDyFfzBc=;
        b=HXsaSM4J8DYADoSbVZw7gIsDdZ6C+0vkAskijdsn+xETr9cfRfkygo5zlgkLbUHlYb
         U1sV5tU91kr25MyBb38QqIF1cnTKKvJl29uPUUAv6i/XSUbkT1N20fSKBz1ha/H01NIx
         BuOEmmKQu71LZPuAND8ge2CUDB4P4SXkBwuQMg1nhUHGmM+BM+VKUJAZQEU8VMJeNlMf
         +U58uFcS3vOJ7uI5UcPgG/dD3PQn4kOmfCam3xbSwzTBiGnIocwi/1fPt+e5luwFoHta
         sA6f2iNnPEU0Cg1/GJPlGRVL5sboxej9dySIMaBLC0CG2xibtEjKC3sTjUIQl0RVTxDv
         Ziyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WU50z4VKSDp0eMNK4Kny9eBvj2EctECAi0vFDyFfzBc=;
        b=RC3fWJAWPK18kdMfjzz3IOHkLz29ujmpTCSb47O2AkJTOQOBpOSN52zMw5/odjsjR+
         vrMf2rpPj74XZklMr/bt4MGyUX325k5X549PlYwLC/I1RBO2d3MPvHjJS4W5SG3ViwTx
         j3Muv/bvNd9PJZ6Jr9KVNSiSVXQ6vvUB4eHF1dgqPaOI43MYcHVt1aorqPUg3uUxr+UM
         5y2pD4jUG6YaKEYd+jpD73ujluDIZu5drJdyh3q+PE7tieqadRTrgFKPztDTIc4M01cN
         ybV7tjZi3V7MZxtONifQp+DNLqWaULEK2qi62tiX7yA57iAWKtov5I/JlnB+7zAjMx5F
         gGfw==
X-Gm-Message-State: AAQBX9cs1SKzcg2kMZD4UMvy4cYEpHau08MyRWEE75v+YrCV1dkvGxTO
        LgQNIVnc3VlYQZ0C2uk+9mU=
X-Google-Smtp-Source: AKy350aUAnWcan0P7DwVnvozgtNtBvavgQhN+IepWj/6qBTktKrmyJ6sVrrf+XSl4rWsQy1NE12piA==
X-Received: by 2002:aa7:d806:0:b0:4ac:b69a:2f06 with SMTP id v6-20020aa7d806000000b004acb69a2f06mr2362488edq.0.1679647302925;
        Fri, 24 Mar 2023 01:41:42 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id z21-20020a50cd15000000b004acbda55f6bsm10323728edi.27.2023.03.24.01.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 01:41:42 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 1/2] dt-bindings: net: dsa: b53: add BCM53134 support
Date:   Fri, 24 Mar 2023 09:41:37 +0100
Message-Id: <20230324084138.664285-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230324084138.664285-1-noltari@gmail.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230324084138.664285-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM53134 are B53 switches connected by MDIO.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 v2: no changes

 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 57e0ef93b134..4c78c546343f 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -19,6 +19,7 @@ properties:
       - const: brcm,bcm53115
       - const: brcm,bcm53125
       - const: brcm,bcm53128
+      - const: brcm,bcm53134
       - const: brcm,bcm5365
       - const: brcm,bcm5395
       - const: brcm,bcm5389
-- 
2.30.2

