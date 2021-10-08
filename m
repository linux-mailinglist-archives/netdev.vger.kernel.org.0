Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F70242613B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243214AbhJHAZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbhJHAZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983B8C06177A;
        Thu,  7 Oct 2021 17:23:14 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d3so2212155edp.3;
        Thu, 07 Oct 2021 17:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cozOyCbiYy46BBhzKGlOVWlnDh/0DjbGklicp+9nK7w=;
        b=SHxLIPHYu1Pp3b9ZN8Kinyc8ucxsrcI4Jsd/cSI2HXBLOgLsGWI+laKzjANQZgDf1R
         D24HKa9QidHPXBzRloJ0t2vtod/MyYRa/5Nqjv3/qAr3uK0qKkItbAW1WZX+Uo+gJmsm
         L32uxuhOFQ6Dd+TVCBUQq6nhqjU9RiEQMXhljRhDsWm0wvsyXJUOFKjd2V6Tpk2gb7Tr
         no9/n1n3f4fOkQq27H0QXD7PNjHvRNc47kVabBwlQeyZ79xdfuwA/Dn2Q7jWSEV0+bFd
         tPdwlommUh7gzF1reGX4YpUnd+FYhhtTxZmjya6pN9KP6bACN5L7vdycpT4hUUzak2ui
         oUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cozOyCbiYy46BBhzKGlOVWlnDh/0DjbGklicp+9nK7w=;
        b=ChPdYw4n6v695jbkLmQ0QktdeB1jq/6eLn8eX7HbMQIxJnlH+R+8OVcXOsGq7NI/aX
         j4SC7Zeb2mYSDz+3qmNgJTkzn82utuR+vsVWu7e+MTmudOtULjzeCl5aGYh7FrBZFgip
         QsNyZZ/4FoSK49My/I6yPe0JV1e+YqP29rLfaJ8w3l21SkzWGrPaJdjwteqsXHaO4gaF
         CpFcEQL0lUReBiPKW8CPCBlloFX/6YQ/3pKZAPaZwwt62A+2fqhXccLJq65wJV+5wPx4
         Mv2EUTKavHIZch9zmZLUTMPjBWi7750G5gjieU0/hAhPts1CthnwD6glnqPRBbp3g9aC
         QM9g==
X-Gm-Message-State: AOAM5329yaJQ4HR8zrhMAWS1hjb9biBI1kO6UjQY9V6/aZqPH7NswQ0n
        PBg64a9WWLgf/NJ/NiAfzNVoKqYzn+w=
X-Google-Smtp-Source: ABdhPJxdBMA+7EIzcvaQzXUoyf4n3KuRxn+v4zvIeiwDT0jPt4+qEq+Dx64p5T394nEK8uMu+qwXgw==
X-Received: by 2002:a50:dacf:: with SMTP id s15mr10211164edj.385.1633652593066;
        Thu, 07 Oct 2021 17:23:13 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:12 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 13/15] dt-bindings: net: dsa: qca8k: document open drain binding
Date:   Fri,  8 Oct 2021 02:22:23 +0200
Message-Id: <20211008002225.2426-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new binding qca,power_on_sel used to enable Power-on-strapping
select reg and qca,led_open_drain to set led to open drain mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index b9cccb657373..9fb4db65907e 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,17 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
+                           drain or eeprom presence. This is needed for broken
+                           device that have wrong configuration or when the oem
+                           decided to not use pin strapping and fallback to sw
+                           regs.
+- qca,led-open-drain: Set leds to open-drain mode. This require the
+                      qca,ignore-power-on-sel to be set or the driver will fail
+                      to probe. This is needed if the oem doesn't use pin
+                      strapping to set this mode and prefer to set it using sw
+                      regs. The pin strapping related to led open drain mode is
+                      the pin B68 for QCA832x and B49 for QCA833x
 - qca,mac6-exchange: Internally swap MAC0 with MAC6.
 - qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
                                 Mostly used in qca8327 with CPU port 0 set to
-- 
2.32.0

