Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7869C6E703F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjDSAKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjDSAKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:10:40 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F9C5B85;
        Tue, 18 Apr 2023 17:10:37 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id bb13so8163529qtb.11;
        Tue, 18 Apr 2023 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863036; x=1684455036;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UyEq/Tf7QLl6d9zXXGWl73RQz/CxSbYGosQOapTIRD0=;
        b=BH1v+IPmPbOUXgkeCbLN1FEEOG8L7DbpXaa4IdtDc4H6TO2Lca10KggzIwAdfHnmCp
         Eocn2M2Lfyi3QZuJjXa/dFdVW6omCj29iNF9dPmQiIVslt7FwduTSEUdGUw1npL3CLrf
         BwJT+jPH6JQAD6eNPL4fzqRQmXIu8mfEbbDwbL78H8T4J7WVoYJ2QHdJnxPusyi5tO50
         H0sHqEht4NlZ7NJgYh0HgX3Yv5o6+dIw0/3M7zhc5ml6qWV35SPrZkEpJINSaVqvbGZf
         UZYxT+JhC4tE0oRxPAJEsOcKMbrODHaquRV0pSpuzXPChKgMscNVNrFt+gG7dGfXuSjb
         1xSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863036; x=1684455036;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UyEq/Tf7QLl6d9zXXGWl73RQz/CxSbYGosQOapTIRD0=;
        b=Oj31BAro7WIRDkUlUzWK6mqpNcytgfo092066e9dRpFkdc2WnvLyI3fR3TzWQxjmHW
         BLwlA8wRY+kVKC99jKT54oHq3liqwzNSyW/S56yomDhD+JouNO/h/3kcrRL12RVNP/AP
         4BuWZrw7mepJ6jqcmCNT7ul71kHED1BGwQxO1NC7weahpSPfO5PbC3NOAaGI4ioggbpW
         slm3+IFxyrCKdxjo8OtpViD05BwNHQsUH7Xn68Ve1dH7YsGmDxR2svB7oPZRhykYWxsl
         rMpIkglLEyAvOKF3tSXsXLybbmfyJ/CORdMmxe+7m1AXxG/PSYEqBqkFIpld0OP0Yn70
         5qRA==
X-Gm-Message-State: AAQBX9daysp5AGY5bppO7q5lzrPF4rBEF0mvYkMVs+e5wppHI9+mEcFG
        nprkOAeCsIDZWQNLLEipKRJpD96LVu6oTg==
X-Google-Smtp-Source: AKy350bik89bg3Bh7J8Q8dUtjUHyetGtf2M9+Xo42hsDtxUodGDcOq+h/v/8FR0+uue+NbSiL3NveQ==
X-Received: by 2002:a05:622a:3cf:b0:3ec:47bb:9767 with SMTP id k15-20020a05622a03cf00b003ec47bb9767mr3211241qtx.20.1681863036044;
        Tue, 18 Apr 2023 17:10:36 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14-20020a37680e000000b0074d1b6a8187sm2639035qkc.130.2023.04.18.17.10.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:10:35 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH net-next 2/6] dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
Date:   Tue, 18 Apr 2023 17:10:14 -0700
Message-Id: <1681863018-28006-3-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justin.chen@broadcom.com>

The ASP 2.0 Ethernet controller uses a brcm unimac.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
index 0be426ee1e44..6684810fcbf0 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -22,6 +22,8 @@ properties:
       - brcm,genet-mdio-v3
       - brcm,genet-mdio-v4
       - brcm,genet-mdio-v5
+      - brcm,asp-v2.0-mdio
+      - brcm,asp-v2.1-mdio
       - brcm,unimac-mdio
 
   reg:
-- 
2.7.4

