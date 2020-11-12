Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0C02AFF10
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgKLFdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbgKLEux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:50:53 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665AAC0617A6;
        Wed, 11 Nov 2020 20:50:51 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id w11so2150876pll.8;
        Wed, 11 Nov 2020 20:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uqi5SmFeacH0e1NTAAchTyTLbhiC4KKjnBGY2RO3cPg=;
        b=g6wbI6f1iAZoNRVs3X9fFCbppPuY9jroWGJMB+KAix8kmBvWj2+swEm9ZDOoxlxBMR
         862uB3jqVVnBG5nlX9MsdpxGmkAUvKVG9GjPAm3Klc4tMc9wRilLP5bGR1K7/GSJIg23
         zfNiqjMM4+kYnNmvg61snpQbqfNIe52rT+qVDTJXN1+mZWlsIIyqt8MhJw1RCShZFce7
         aTkP1yiOlbFvzN9lvoK2uavdh9otEGu2XFk3L4oa12ZPXkuEhAdmVXQOoaK49LsPXARA
         a6RFEpp11c1XgMIS8Uh/DyScWSyn3waHuT7m6HGSmaZ99YlsA7aFCeBD9QmnRdRpxYWR
         VoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uqi5SmFeacH0e1NTAAchTyTLbhiC4KKjnBGY2RO3cPg=;
        b=p78X63XFLikHdMPRe1tiL0f6L5MN++sW6AbGC8YuMm75fzfAXZj5xiy//Fe7C1TDv/
         x4C2rC8TbOF7IT3TkMeokUyFw+CMVsbLbhsXHb+psJfm4B2lodgsP8vqf8NPaoDP3em5
         qN2QNr4fWSDLlmL7f95Kk54tEU7DZsL6ExZpo7lmSChwFPBTrtTvhdyC3sCq0h4FJuCF
         IQtVZQR6sS5vor1aAg49T+iBxRuDKjTT5YDvZbTbfoZ4PisNU96e/AL4Nlt1XJ3WnpiM
         WwCUB0oFr9OMaUuUUhYdWzxgWeKj9wbtTcuhphkhpaBlB0wPdPWdFfKaZ77BIGedmnT2
         wLMg==
X-Gm-Message-State: AOAM532vCEAbOov+oOJ6HFXgjDlvDNEgVXOh/6C8gc1Bd4MvvyYbeiON
        JzWX51Tf5KEX0xBZIiuq5YM=
X-Google-Smtp-Source: ABdhPJzX3Wk+CjiK3j44F23MWb2WHdQhpOnkm7zo6QbcQP65qEl3hYVXNO+jKiwHZ18O+M4aD5En4A==
X-Received: by 2002:a17:902:b192:b029:d7:ca4a:4ec1 with SMTP id s18-20020a170902b192b02900d7ca4a4ec1mr22426101plr.76.1605156650963;
        Wed, 11 Nov 2020 20:50:50 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:50:50 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH v2 02/10] dt-bindings: net: dsa: Document sfp and managed properties
Date:   Wed, 11 Nov 2020 20:50:12 -0800
Message-Id: <20201112045020.9766-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'sfp' and 'managed' properties are commonly used to describe
Ethernet switch ports connecting to SFP/SFF cages, describe these two
properties as valid that we inherit from ethernet-controller.yaml.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 5f8f5177938a..8e044631bcf7 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -78,6 +78,10 @@ patternProperties:
 
           mac-address: true
 
+          sfp: true
+
+          managed: true
+
         required:
           - reg
 
-- 
2.25.1

