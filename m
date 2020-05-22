Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB8D1DE64E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgEVMI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgEVMH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:26 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E494C08C5C3
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g14so4279456wme.1
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYamWCGpGqZL1TdMciPU3s1N0hd2ppZ++0/IfJ1caGY=;
        b=z09pplDzbGu8zzHYZwmUG8WYuN5QnZoIThbQYmhBMWEdeanmgiQmeEaOJAAsMBH5co
         Vc9SJuMdt4nXdaLIqtA5xDnvUSVBnfcy8+HUHt+7XekAI9e36/NJH0qHuP3oPkZSLY28
         LxPlZYlsDw4W1ckHD0Es7lqGaXILSlhaTD2WhJ45RQCKFru6rVsyfbYXPtNE6rVrSQRh
         IE0Bnp/5oPPCepTQASBnHTtpJDXwfdNkKtDoTYs/yLZbblVMktuo8Y5utgxPeh07MRaN
         2JzjgOFu1d/xixp3xct7DO4Siv8YXryeMOIM+u9ZZWnonUMTeRGBc7bTnOhr9As4Kam8
         2eFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYamWCGpGqZL1TdMciPU3s1N0hd2ppZ++0/IfJ1caGY=;
        b=lcaCBpPcXET3UUChrZc9Jee8oN9YmrSrPCgypGubGoLnrAIYn+UDdW8WH+R+FSGbbt
         GekqJDuQJg7lXpI4QVdzsdaEpOMxt0Maij7rYSIaMIj1vM4F2zIon+IQqK3iO/oFAUb6
         2Y8WoqjRINuyVzCHQdO8gk/aRIntNaEWzsNIpoErKbZGWxTZiRqhWJMAGdOLZXQQ6lh5
         RwK+pdtBX5WHYefzO9kioC8HcGedlNfIDcJPRuy+v9RFa50u1xHGmlBaZTNbBeXSssvx
         8mKPLFVpxk++RiKpSyZquTfA19HNMu34w4j3GqUBiPeJoav+j/5uVSJLOGHkFounBd9y
         vHug==
X-Gm-Message-State: AOAM530+RbQ3iCwfyZfkmFxLIVMzIETU0MudwZ8IYh4PisOSqiIzwimH
        zmOEfzQYBXlMRlywTMWZyED+dw==
X-Google-Smtp-Source: ABdhPJw0hJl3cQP5flK/6nQax5Ceb2AK3ZRifZ2de+tpHbVYDyDSC0mU0F2KKkWDNbi4cMfQO0bWhg==
X-Received: by 2002:a1c:5402:: with SMTP id i2mr14046163wmb.185.1590149243221;
        Fri, 22 May 2020 05:07:23 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:22 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v5 02/11] dt-bindings: add new compatible to mediatek,pericfg
Date:   Fri, 22 May 2020 14:06:51 +0200
Message-Id: <20200522120700.838-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522120700.838-1-brgl@bgdev.pl>
References: <20200522120700.838-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The PERICFG controller is present on the MT8516 SoC. Add an appropriate
compatible variant.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml       | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
index 1340c6288024..55209a2baedc 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
@@ -25,6 +25,7 @@ properties:
           - mediatek,mt8135-pericfg
           - mediatek,mt8173-pericfg
           - mediatek,mt8183-pericfg
+          - mediatek,mt8516-pericfg
         - const: syscon
       - items:
         # Special case for mt7623 for backward compatibility
-- 
2.25.0

