Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92FB2ACBD7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgKJDba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbgKJDbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:24 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BBCC0613CF;
        Mon,  9 Nov 2020 19:31:24 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id y7so10110638pfq.11;
        Mon, 09 Nov 2020 19:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NsF3gS+5kE+wsopx0LcLGA88YljSJFxzkqOqrbAnyIc=;
        b=JQv1gmofkr2Ke/sr3nVvyroNt1tShovWfuH4ZSp8jhd++pCpRuC1SNHHoUZSqrWuMG
         lKQ74eLarJXuJnnXlTKXR6zHlTTPaBC1AMDotzrDjmsDtugkBfLGrw18fuSRmnrXIQHx
         Rwq7N/E3cjgUeE/LTHkA75230c2TSsYcZaguz7T7ltawoPKtxcgLnP5gMmsKdyniVxvY
         s9BIXIf05Dshs9m551EXl5Zn+DtM9rrJ9u+I1u5wtiKytsMj0cL5xNJt03/BxdJvLef+
         KcdCH9Vj8RjL4aCuZVLylE5cWZHXUIRp+sOE1FHcRherN/Th7SREZ4rjMqA/7tB/Fll/
         4hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NsF3gS+5kE+wsopx0LcLGA88YljSJFxzkqOqrbAnyIc=;
        b=OK8mY4ls81dDVIygDxc+QBc3w5aTIM4vlWNPzCWnhFUaN2GsYJXcsgLiEhWhljXTx0
         uuadlBZ8XjlMX26vCqoRtizyEZgmeXP2yLJfRBLMt8eF2BQzz2cYs2qb0kQ+imuVw+j6
         KfLQR6DzkEB7Lv5/g5pJEZoJnRBHy7eB7umju9CZxcEsDxbvpsTXvCyv9xN9aREtrVDV
         GK63bbcIyo7lSoGtucmCSlMJ4/2zVl9zBUntrRdny5Q7or2olqMViCoX9JLefhVfFZjF
         wrI/rUW9mjh1VTQ+FgIXYLmeg/Xd7xrgxOvsEPo/sivgG1LNObwms0/y7+Ac4Rs7judY
         K6MQ==
X-Gm-Message-State: AOAM5303Aso+5Mu8kpBwAf2iMp7mU/xUFZ+0lDrlo8y4t0fvRbPpESR+
        EMDBSQ5d/JP6kK8kOMVEolpZ5V9lnFE=
X-Google-Smtp-Source: ABdhPJzrU15Y04E56lG9CLrcywCMRwJKxpwodv5BpENHlgnm1sbHi7GyCIp7oqPPO2OstzJ0XSIZKQ==
X-Received: by 2002:a17:90a:170b:: with SMTP id z11mr2655319pjd.83.1604979083073;
        Mon, 09 Nov 2020 19:31:23 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:22 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 01/10] dt-bindings: net: dsa: Extend switch nodes pattern
Date:   Mon,  9 Nov 2020 19:31:04 -0800
Message-Id: <20201110033113.31090-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon discussion with Kurt, Rob and Vladimir it appears that we should be
allowing ethernet-switch as a node name, update dsa.yaml accordingly.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index a765ceba28c6..5f8f5177938a 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -20,7 +20,7 @@ select: false
 
 properties:
   $nodename:
-    pattern: "^switch(@.*)?$"
+    pattern: "^(ethernet-)?switch(@.*)?$"
 
   dsa,member:
     minItems: 2
-- 
2.25.1

