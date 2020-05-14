Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D41B1D298B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgENIBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726076AbgENIAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:08 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926FAC05BD0D
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z72so21707152wmc.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYamWCGpGqZL1TdMciPU3s1N0hd2ppZ++0/IfJ1caGY=;
        b=P+q8w1goUvDD7gR6IchyV00vB3pVcrHK1pDbN1eYY/VOYjgNmBkbQGQCYfXXV+eFP6
         4nf1Uy7o9a0eFzUc8hHDpXmqBGjs705jAZsWOO2j2XQAD5HlSFiVxGUeeRognXurIqJe
         FPIsufHTJ4GuF9r/qJTFwlF/Fy+VxgGQq58XWZHFrz4MxV/et4oTsm0Oxzuw/HD9nc34
         8yEi+GIBBK+Y9nC12SRDgelejI8LlrfC6x25QcgYArrW4SBm3ZgFtZI/79b1TeNOtPUw
         LLPr2Q1C3Wtpg+JZ6L/7KyJwhrYoECFXR4fNhARaTt4abxJ9QBuZXWngiMdxSPFy1aIr
         7f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYamWCGpGqZL1TdMciPU3s1N0hd2ppZ++0/IfJ1caGY=;
        b=FVArP4r4/euH9ap9b3Wnl7hG6SiTgGPCZLA1v739UdZKHx4yTm5gMhoNsL/egsKHb8
         gJM/WAnPmVqaMykP8KUgGG++sN9yFANE/HkE9Opb1WwWo+/Y4PA+LnNP+AMPNxcy9U7t
         bnijJ6LKeTY547gizcYvictALN77OI/8acOrdyE0ePt54BbTLW9H/hKAneR8XOaG1Biq
         x8j8upKtiLt4jxe9q78eSUsDpZ39Zr7tytJgU7kQw6BkXyg8kfOJyV3XizIyI78Dzo51
         qgVHvT9yYes3YUQ3Kz2Y2u0t4OFJUYt+p9Rx0Tjzivc8VfCL2Yc5LEqj2MHvsSbaYOjB
         U9ug==
X-Gm-Message-State: AGi0PuaVVcYcJm2JoaLkVqsWdz3w7SGLg5+UJww+iH1M8d0J+eSusJn7
        NpAW/qAMuvCf0YPF/tkjOjSWvg==
X-Google-Smtp-Source: APiQypLkU2jxnKbFs8gBgz1ml8D56KMxK6JlEHw7o56nvtnY9O7hz8Oxa+M4tm30hkKVFqKw1ft9IQ==
X-Received: by 2002:a1c:f012:: with SMTP id a18mr45714052wmb.41.1589443207361;
        Thu, 14 May 2020 01:00:07 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:06 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v3 02/15] dt-bindings: add new compatible to mediatek,pericfg
Date:   Thu, 14 May 2020 09:59:29 +0200
Message-Id: <20200514075942.10136-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
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

