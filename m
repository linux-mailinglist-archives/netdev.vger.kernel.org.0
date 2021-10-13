Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3958142CEAD
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhJMWlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhJMWll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE0C061570;
        Wed, 13 Oct 2021 15:39:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p13so16702476edw.0;
        Wed, 13 Oct 2021 15:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rMP3P5zozCXV/t6fvCx4z79ja0Mg8ZMQVvb40Sw+2ds=;
        b=HCniQKhNadMKS9Qh2VfcdzSDpM8bhqvz7gPWzyVynluZqoqDgqc6mR6ai1Z7GDLRct
         uXCp5TGOtXj5U9FAAgVfIcMOM+7XhX6dyTSstD9UVUBONfNraMNgZhre5ssL1FlU/9h3
         Bqqwy9FdM4E0XE/qxCF+TrubchrgeqxmKcS0VwJ3G+cBnNEbBU2at+ggXxHJ/JrB2a2g
         ZoEzo8MHqdiPrnXfPdCJCdJamqmHUkUgpjQurbA+07cAXmQPhCKSqtaAT01NZTwxRGUQ
         8cL/+qALIRHPtQkKUA5p0dPjOpY5xzK6fUjKR8wrLz1SuVz5H7uiG9lBVPHghu9dep7N
         xI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMP3P5zozCXV/t6fvCx4z79ja0Mg8ZMQVvb40Sw+2ds=;
        b=TEqrItz3rRr0AGYqp7mk+OtY4qLotWf/Q73BkPzWCljuneIz+c6/BJPC08YkmBaPjd
         inS4YB1xQSppbftK3NdVoNdvnHxB38h2cM82mPXoZ1qwRVunAftry5In5T9L1eGUBd3j
         HqMQzcl8KIuT1MEtzaXGZ1K1ge30puX0i/4Mq0LSzDud+W6D3StciFr0z/BukTD7Si6q
         Ra3D+Z1Mmhdz4mfGn3OXkr2c02oXVXr2O6qf2MIFDF3q9/hFtfkAg1ijOCtXgUwK9gEi
         fUtrzr1ohwe7xDmQ/4VxRY2DxMBOqZpr40ryR0wS19LMZXhxSO44VwS2aULxWv3t3yqp
         xL2w==
X-Gm-Message-State: AOAM532kpk8TLG36WJgsGRVC4zPdM5s1toJpx6jRizrYWDogfY/YovpM
        EmHbkZctKT91reZnD3dg/e8=
X-Google-Smtp-Source: ABdhPJzlhplAawllZ951CVFUGz91PxA8GDYNiszmwekcJ4QQLvy7nRDbX1y+qhJ/excn/fG4J1bTew==
X-Received: by 2002:a17:907:f83:: with SMTP id kb3mr2393669ejc.453.1634164776313;
        Wed, 13 Oct 2021 15:39:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:36 -0700 (PDT)
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
Subject: [net-next PATCH v7 09/16] dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
Date:   Thu, 14 Oct 2021 00:39:14 +0200
Message-Id: <20211013223921.4380-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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

