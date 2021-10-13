Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7442B1F6
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhJMBSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbhJMBSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A31DC061570;
        Tue, 12 Oct 2021 18:16:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w19so3261939edd.2;
        Tue, 12 Oct 2021 18:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=IlrOeAQYGgoHhEZ6jiELf4f0QeHQ9o91dYaDJ0pCZBDqngnPQE9TJ7TvancT6erMvY
         k7I3Kqvzo0ojdcFHjD06Jpk8xoxmpttVOW/tVyMtZ+QgvU2CedgDffbIa4JYkKuprXKD
         1rKWJ4OFkx9kTV2KASHqHYON9lyP7tpVSwYeE59j6Xb0XZergfqBKmT6J55KJrk2M8vp
         +cLWAJTXZBZ7kh9w9uK0tlSK7bzISf8zzu2n6HPrMtbteHuvjNAMjT7Ec7wgBSFOZsey
         6PmoW3ZS6SwiMyVA50AcmVUK+xN1/Agt8FbPz16dSAI0vzU2oY5bnafBhKx60iSkYovv
         SDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=6W8NjH6fgGE8QDQZgJHQK/ncmBoiI4InXKWZoolcx55OS2Q4rpR62bwsik0UeWCjk2
         mkyJdEcPRsGUaLDMDfyv+bhMJOr6KyeSB/hqQHUvGSfKqd1gVrFrJRGbXD+h/h0tPopp
         WuTpXDwwl/vGAx7m9tgrW46u8Q/BkGRalPnwgZgn68YHNxt2EZntZFhlleuc2QwLZ/Hq
         I5t82vqdG3qG3YrABo9gD6MCpCYhhnjx9wZfYfycj/Fg0fjyLBRBL6NjyeXKC4Nwb6H9
         jqDZMIQBRM25YorWbUtZTj3qpzgaSedB8qgSS4ft9tC5cILB2gB4KHsGJ0t54nSyrmYP
         o5YQ==
X-Gm-Message-State: AOAM5327RcIozh+EVrXE5SshP5gPX7hred2Qy0JKFIffTgbTbfTQzALs
        ni9iCWvjFU7BnWVOvuliw/E=
X-Google-Smtp-Source: ABdhPJzHOm9B18r2wcs5jIFap8chgTLo2rccoQlK3DyW/yJ/YDCBN3T7/+SVFY1HGn3nVesXI2sLdA==
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr5136353edu.144.1634087790543;
        Tue, 12 Oct 2021 18:16:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:30 -0700 (PDT)
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
Subject: [net-next PATCH v6 04/16] dt-bindings: net: dsa: qca8k: Document support for CPU port 6
Date:   Wed, 13 Oct 2021 03:16:10 +0200
Message-Id: <20211013011622.10537-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
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

