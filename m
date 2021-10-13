Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B1242B20B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhJMBSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbhJMBSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5CAC061749;
        Tue, 12 Oct 2021 18:16:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g10so3290483edj.1;
        Tue, 12 Oct 2021 18:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rMP3P5zozCXV/t6fvCx4z79ja0Mg8ZMQVvb40Sw+2ds=;
        b=B6vh0tqwuvE+wc6FPozQytAfFzAFRctIVP5zfyr3422SyhVtk6QhxrtPV9hmp6Cqwd
         MAlS/h5ZK4+jsuyCj3NN8gOj11Tdy35fXfDKgrSGr33AprQQ2798ehVO+rmVqM6uLdkj
         QkfMUZWW9EMLPRDiZaVw1KJwwVne5VrkiQYHkOzfj0mVNM3dCE51HADX68S8Qt84K42x
         KdjYl7oaAFbS22L+bMwjS8MBTomedf9SMMfLWsKyfo81w0qP8n6pm940gNHp2a5HeCRm
         JGEdTHW1c//kzGlb37CltDEsUH7ZyqoZy7vFrgMMxcWQHveVlVDBzsTDtfS8NFjZiYDG
         +eHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMP3P5zozCXV/t6fvCx4z79ja0Mg8ZMQVvb40Sw+2ds=;
        b=OaICE5OQtXFDr/khszS2axq8VLw2j2SVIUFq5iewlamIh7NrRB3HwXocIxQ8j++SrO
         3R/UzqYgKLUPmHZRr4+sItzZf1tXUvgWdt/v/Lq3mpwCLDZlfo9VGODacKodrw+NdrkC
         7x6PKkPP2RsxURRFXlsLjAI9tlXcGmGS+idJNpDtp4hySdLK+6J6abV/0HqZz3/FPp0y
         9QV/pmNnnoySD5IKZEDaJ6TEQiHL4rX+aAF8Z6Wpmfmq6mazHAAdqHw8i29JrhlgztbS
         j+PAYIXrVVBZ74U39gZeRRGoxvWqDG53ug0riZQB1+/hRaEqzZFUzNZm9xC59RAFzzGn
         j/WA==
X-Gm-Message-State: AOAM533Rwofv1JzByxWKrmDc2mSXlvkyrgUgkoOBFOf9/BiWfEo2m7V/
        9NSKyjXpXnWI0qusaF8clbd80i5GhUk=
X-Google-Smtp-Source: ABdhPJyiGTSAv93hcN5r8yVZwBGUEAXtJiHnLRKCB9rDKo2pb2bBId9+KphNCKQOmqguuLo1+emD3w==
X-Received: by 2002:a50:bb67:: with SMTP id y94mr4831980ede.308.1634087796737;
        Tue, 12 Oct 2021 18:16:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:36 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 09/16] dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
Date:   Wed, 13 Oct 2021 03:16:15 +0200
Message-Id: <20211013011622.10537-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new binding qca,ignore-power-on-sel used to ignore
power on strapping and use sw regs instead.
Document qca,led-open.drain to set led to open drain mode, the
qca,ignore-power-on-sel is mandatory with this enabled or an error will
be reported.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 05a8ddfb5483..9e6748ec13da 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,17 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
+                           drain or eeprom presence. This is needed for broken
+                           devices that have wrong configuration or when the oem
+                           decided to not use pin strapping and fallback to sw
+                           regs.
+- qca,led-open-drain: Set leds to open-drain mode. This requires the
+                      qca,ignore-power-on-sel to be set or the driver will fail
+                      to probe. This is needed if the oem doesn't use pin
+                      strapping to set this mode and prefers to set it using sw
+                      regs. The pin strapping related to led open drain mode is
+                      the pin B68 for QCA832x and B49 for QCA833x
 
 Subnodes:
 
-- 
2.32.0

