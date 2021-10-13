Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973AB42CE95
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhJMWli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhJMWlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:36 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0157C061570;
        Wed, 13 Oct 2021 15:39:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d3so16250065edp.3;
        Wed, 13 Oct 2021 15:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=WWpQUJdVRaIoPuhaN5z8MWelbUL4kXBKIXKrp2dJt/lTRFG5ZZAcZhQmEBD7MgnT9k
         WRSwG0KdialhZ39fSfrA/wFzFxYc22FYqWE2kU/g1Ty6D30GK8eu3gl2239pzxV4E0Sh
         PBhIV+rprqEeNZ3KXznq0WnM/7kUy/OYkFtZNleWp0Pb+JZ/Jst19OZKxyymz+qKsiVe
         zj/7zCFzRuuT2Vy1jq+XkI4wqC0SkoV9WwK7BDqA82jYFAOvPmD48Joep3ZDHJRIcYiN
         ElZfZsmxEYzfLChwRRrFZNHM5XQLo2Mn2AOLPMihnwNlLl2rN9K5KulQTnsTGRverVkA
         u4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=zKvZ3mfaJJVPBqOa9mh4pF1NjqkqP+xhPddqjdXbHhaoHbls9YB/ZCam7zZN02WCHh
         rB0PDVUymjbgW6BDEVoWp78eUYFbn684MEXF8VxJm7aOIDe20Y9N+TlezuW4kg2HGTJl
         BAgR307vYSVM7seS+3ThSjK/2XqMAXWyDSVgkjXkr/0n9zGwmsAxu6kgvd7p8lpozNM7
         meeuoIbTNcsmRPl1bE/Lz2zS0gXdE9Ku9NYMQJm9SaR01TVAx7mpFmQyTKXxVbFjs1ZI
         gAOaDGPXFW7Yj1Soq3qVeosmozxf4e884HnEb3XgC6T41HZecLOq4yMhvvnobtp/k970
         dyeQ==
X-Gm-Message-State: AOAM5321z2MfYotL2vXoNPRD20h1r2HKe8MzkaR/7HgQbb550NSW6QwF
        uIVdlype/iOAIvLLrXCWDCY=
X-Google-Smtp-Source: ABdhPJxnE08ge+KeBvJEuMGnd90UrH2MDkhE0FEBBby0JVUir3xryCYmmjGNjhv4pvdiB/SMOTo+Lw==
X-Received: by 2002:a17:906:9b46:: with SMTP id ep6mr2290997ejc.226.1634164770355;
        Wed, 13 Oct 2021 15:39:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:30 -0700 (PDT)
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
Subject: [net-next PATCH v7 04/16] dt-bindings: net: dsa: qca8k: Document support for CPU port 6
Date:   Thu, 14 Oct 2021 00:39:09 +0200
Message-Id: <20211013223921.4380-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch now support CPU port to be set 6 instead of be hardcoded to
0. Document support for it and describe logic selection.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index cc214e655442..aeb206556f54 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -29,7 +29,11 @@ the mdio MASTER is used as communication.
 Don't use mixed external and internal mdio-bus configurations, as this is
 not supported by the hardware.
 
-The CPU port of this switch is always port 0.
+This switch support 2 CPU port. Normally and advised configuration is with
+CPU port set to port 0. It is also possible to set the CPU port to port 6
+if the device requires it. The driver will configure the switch to the defined
+port. With both CPU port declared the first CPU port is selected as primary
+and the secondary CPU ignored.
 
 A CPU port node has the following optional node:
 
-- 
2.32.0

