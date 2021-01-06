Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE602EC5BF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhAFVc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbhAFVcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 16:32:55 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC320C061757;
        Wed,  6 Jan 2021 13:32:14 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id h22so9951183lfu.2;
        Wed, 06 Jan 2021 13:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxQVW7PQ5S5o2lJGdzNoJm9D05fMsgmKVvz50QNBlkw=;
        b=CHVZOkWyRWRjOVhGD9hMNYvPgdv5m5DgzDop9/oN0+B5p6RzvXeJiv3zBUdhRbUBF9
         JrS+KrcmSaRQUU0JVB9q5fgXeUdT3CCi6Srh1bXismuotPoOV0xr8/wCm62nRC5Et9I6
         hzzjfkuruekBBn8hBLXOy60ovryzHLuxV9pWTkr4lYZ6PWBYOTtp/oSx7MSeOe329KrC
         t1xtq649vxeCCwF/C8RksCV9U4MWZxwYeFPdlrkHGH+RvL2xNImIqWxNNXmA+OAMc/fl
         64tMFLGhxOlsk7FPlAAmowkzkdUcnnOFaZ3fFbR51q/z1u7jrfR+OcdhR7WdW2/KnYGb
         1Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxQVW7PQ5S5o2lJGdzNoJm9D05fMsgmKVvz50QNBlkw=;
        b=F+TKWxrMdLqGbMoHE+OgR/7zm9oyUq751M7FJMrWfg7O/yCKjAX5f5UgjYXaaoxn33
         mBpVa9611VQfyOjL314uRnnAsxOnAzbxt6jis+LhRO7BDv9h6xZQUQm5PbA8+t3vQfdp
         vxkVAIdBL21gOjMF3mFWv41nHvpcXpQmPCLr5hLSmTo9BDJ/6lJFR3fV7wwavThY7CP3
         7+HAMahO0UxjXEbZdYNyIwaKlwsQzbFDNnetQaJ0K8LxL11FcVKXIKMC+37C33ZucN3v
         5twOh2S+TkEX6RF75/S8TBpD9eP5FWo2OATy7miOOSuduWsY+kcuIbEf09zA1WHd6lyl
         NCaw==
X-Gm-Message-State: AOAM533kK1VN7KqGaTHwLD7j+AOwPla4edSFOGjYS1IjxAni7Cv2/GYL
        vea/ePVX1WxrIiWrwXDnkho=
X-Google-Smtp-Source: ABdhPJzqpQCfBfMWHjLSEHXOWjxaefdAjPyeXKqK8cqZjSj4pXrWfofAE7WarEFgZQ9B//szBXMvOQ==
X-Received: by 2002:ac2:4886:: with SMTP id x6mr2544764lfc.76.1609968733482;
        Wed, 06 Jan 2021 13:32:13 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d21sm623436lfe.19.2021.01.06.13.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 13:32:12 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 2/3] dt-bindings: net: dsa: sf2: add BCM4908 switch binding
Date:   Wed,  6 Jan 2021 22:32:01 +0100
Message-Id: <20210106213202.17459-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106213202.17459-1-zajec5@gmail.com>
References: <20210106213202.17459-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 family SoCs have integrated Starfighter 2 switch.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index 9de69243cf79..d730fe5a4355 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     items:
       - enum:
+          - brcm,bcm4908-switch
           - brcm,bcm7278-switch-v4.0
           - brcm,bcm7278-switch-v4.8
           - brcm,bcm7445-switch-v4.0
-- 
2.26.2

