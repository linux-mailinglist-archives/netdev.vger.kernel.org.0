Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55F81DB18D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgETLZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgETLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:25:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEDCC08C5C3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so2794545wru.0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYamWCGpGqZL1TdMciPU3s1N0hd2ppZ++0/IfJ1caGY=;
        b=MlZFmJDyD2RZ0Ws/5qF1VLg+XZqBfCrw5K6YfU6++Rjm1khpRCp2qSfB3fktDPddjo
         SIh9uNo9u5rfZE1ob3KokCrgAMAhLPTcLIK8eKdJWkwBxUHcT1oeN6lBdchQAAZUmWUm
         iv3hO7QiHeYoeyE5g4oOcw7e2gZ50XZzRDFrUggoPsuCrmI/HD2umiHSiQWTwo4qZPZL
         padqQ0vvTzkXV/zWCUj6CeVwJa6DNj9juCzcolT0I3DdZXpZMhYPRXpBho3emdf0EZhL
         ofy9F8wr+8xgzSBC+TUvDDIzMq9i1jojRdCeCqEnCj1xBbsJ0A3OgTxz+jUdxV655lt0
         qvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYamWCGpGqZL1TdMciPU3s1N0hd2ppZ++0/IfJ1caGY=;
        b=X3wAUb93KI7wcJi3CPjxiR+4UrQyLdLh9Ywpw7ogfgvsJFiFu1RMQjUphgPEpG+efO
         eIaJbhXu0IjhDfisDy4dH740HhmvuYzYQGYfoZyWrdemjM09iuBk7K/Q4YZ4AtWvEZ4Q
         u1YvjmftJ81fGBFXnrskcxjdOJJmb90Vh7g7Ma6Tc/E/7pMjOYWTVQZ0nwHPvl0mBkhQ
         B+u7JLZgSusiiustbDUAzsFMyjakEtM18YleblQbM28lNkcN++cotd/7BLKBN7QWQWge
         mxMxsFggDCKB1EwYVkgxeoSa7MCcrxY+VSoWWKziS4K3qOFvAn/UNY35OZVZZsi7rhLL
         Dk+w==
X-Gm-Message-State: AOAM532CSGS3xn8uP3QlJRqLRIlQXCWvVj1t8ue756cqN3UlarG+n5jD
        WK5LD/PcUBbM+l9XK4t4lmmxBQ==
X-Google-Smtp-Source: ABdhPJzP2SU8b7Ejhx9OfVfAUXunYJXKq9PtL2lhB4iCfhl7vIH39xSNcZZZPhsOwqd7i2bPARRi6w==
X-Received: by 2002:a5d:61c3:: with SMTP id q3mr3723732wrv.405.1589973934414;
        Wed, 20 May 2020 04:25:34 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id v22sm2729265wml.21.2020.05.20.04.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:25:33 -0700 (PDT)
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
Subject: [PATCH v4 02/11] dt-bindings: add new compatible to mediatek,pericfg
Date:   Wed, 20 May 2020 13:25:14 +0200
Message-Id: <20200520112523.30995-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520112523.30995-1-brgl@bgdev.pl>
References: <20200520112523.30995-1-brgl@bgdev.pl>
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

