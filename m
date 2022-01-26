Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB449CF21
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiAZQFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiAZQFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:05:52 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53943C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:52 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id b14so378064ljb.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=zF3IX+ZoZuEP5wIGog8Vz1x7D6J5qbB47X1+HgTp1Ro=;
        b=ik07UYqRR/fgOvihUdeZBxy46SLo1jEawOHrQgsOSokIdvUBKoW6kiOuzx0XABMCUe
         J4N8p1M0AAwC8lJd1+zjHU2l40GZfC7g+27/fG94k2Y5JW25pb5tNAR5qZQqmWfBwOuD
         AXYTo9LpijDJbA1AJVPH6IyAvbeu/kWhPNQWgfuqJvSjvDcadThJogbuW3mpQVtM+eb1
         4C47YUdMicmJjfb+KW07ZoaMoa15Jxi37LiM8cB4QQQF1Zin/MwbZbkJr0RYSL0a0A13
         TVLUCAWqA12D+C2dfH+vDIfAm7WFhFrgAnd5bryepd88DLXU8a4M7JSJIHydQ1ebK2Jg
         knDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=zF3IX+ZoZuEP5wIGog8Vz1x7D6J5qbB47X1+HgTp1Ro=;
        b=EKvYc3FlKgXovv5JLwXQHK7Anvfe+VUg47SwCwDpea6RsQYBJIw+VaR/VwhYgcx2gG
         wRH70IskWkh965gnXHtvQgAcZv9be3mphDB0GbIt2m8cWdN6SyKMN9c0MwKVFkbqwNqP
         lloywXN2GZVLpqIx8q1fA5mKN7fpDFNnRweVaJzQQn9ZWffBxwTtvHKMBz5IfFFFd1Gi
         EIVESYmydbP6nDnnYCssOdK0jZGtOLERnbrjDFO/1a+rskRL9dIhgffDhwbB7/N4lsPu
         wGJaRd32lmZowXOPfp8JkN4VLt+eBNiCoI+xw87yloMIT2bBC4eaZhoTUaUKhnsGZLsk
         j4UA==
X-Gm-Message-State: AOAM530Y+PXxtZnFw2ClKZ5Hp59Noal3wy0Wc5388EtEKs6VxbyuYVaJ
        N6xGACDaKHN6xtq146WtAK0qTA==
X-Google-Smtp-Source: ABdhPJwRd7UsXBcQJGD1W7d+Jy7L1ysRcWJeJ1tVFL/lRHXd/asCPE1V2I18cUko0Sixa5mkyU/SLw==
X-Received: by 2002:a2e:9e87:: with SMTP id f7mr19181390ljk.160.1643213150617;
        Wed, 26 Jan 2022 08:05:50 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p6sm1869984lfa.241.2022.01.26.08.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:05:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/5] dt-bindings: net: xgmac_mdio: Remove unsupported "bus-frequency"
Date:   Wed, 26 Jan 2022 17:05:39 +0100
Message-Id: <20220126160544.1179489-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126160544.1179489-1-tobias@waldekranz.com>
References: <20220126160544.1179489-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This property has never been supported by the driver. The kernel has
settled on "clock-frequency" as the standard name for this binding, so
once that is supported we will document that instead.

Fixes: 7f93c9d90f4d ("power/fsl: add MDIO dt binding for FMan")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/net/fsl-fman.txt | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 020337f3c05f..cd5288fb4318 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -388,15 +388,6 @@ PROPERTIES
 		Value type: <prop-encoded-array>
 		Definition: A standard property.
 
-- bus-frequency
-		Usage: optional
-		Value type: <u32>
-		Definition: Specifies the external MDIO bus clock speed to
-		be used, if different from the standard 2.5 MHz.
-		This may be due to the standard speed being unsupported (e.g.
-		due to a hardware problem), or to advertise that all relevant
-		components in the system support a faster speed.
-
 - interrupts
 		Usage: required for external MDIO
 		Value type: <prop-encoded-array>
-- 
2.25.1

