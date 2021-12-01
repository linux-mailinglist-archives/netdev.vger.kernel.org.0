Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B4A4645B5
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346550AbhLAEQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346533AbhLAEP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:15:57 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1906AC061574;
        Tue, 30 Nov 2021 20:12:37 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id r130so23025625pfc.1;
        Tue, 30 Nov 2021 20:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8eVTKgQ71scTCdgvnAxinAjRWpK2tMB1hMCFM8SGqY=;
        b=QdiAYp+97KXoewPidJZ/CPoptc+O5S04qu4lfywjTeVcO6quxgTwr4NeRF5tyrCKOh
         aL5Hts6+fQhN6Y3dIdC1+D0lUj6IsbGyAxoDyvtosNYoqf/+YvULN94IQIGm8EBIJhja
         6Ua8GmOGgYjCSBgdqgH1lKmdwV6JcP5fcTPGbYWU6Zd9hXIRkZx5A+p0msyUTMKLwuNc
         0abJA24r0KX4ddVMiV5LZOKDwBoY87N2xC+54Nvytr6o8QZ8ajwZXgKvGfwBXwST8LZ7
         tPbQLBMLA9J7mFMGSkg2Shc5mPpf9Z8jP8k79taMAhedBCWIJA5eppA52dop5KdbCuqO
         UJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8eVTKgQ71scTCdgvnAxinAjRWpK2tMB1hMCFM8SGqY=;
        b=JgrRT69svyh9rgilOrETzbtCj4kPFrp6qKTuA1282XTrO2lzybhYjC2/e0c1/Xn+30
         MbxHx0lx+N3YLz4DE8mo2gCyK7OhSfuXn5XkUO7X4wI12wof1cK3wF54HHzKoN0kI4Pv
         xDFQYEXQz8tYwT3B1GjKGC+6xLIcu/9LAtpUcCSgAfFARXSOPPWxnCpAah6JASGMKL0e
         jTnyB/YZsL0ifpw/CqNoEMBUdB0ksw30In7jjRk7brZ4NTEakRKVCor1i9ydUSIe1rX4
         MRTs/RJd96h686WqJFujUwke81EiJe3Hn5humzHmyYWHGZPowwKpP1Z8Ho9ETwxUh/gp
         nnBQ==
X-Gm-Message-State: AOAM533Pag8HPSRcNWSqS0yQFOqgKSG9WJGMnqcNZuL88yLwEXOLsQMx
        BzZdmZDOZ5eEIYhEgb11c+SfRCrj30w=
X-Google-Smtp-Source: ABdhPJyCEyg78fsDQ4KPjxXMj3FgSjwpzhxdII+VMQ4ikaksZUeq/cGuryfwn/8rilQJn2KwlbBQAQ==
X-Received: by 2002:a63:d00e:: with SMTP id z14mr2789546pgf.300.1638331956280;
        Tue, 30 Nov 2021 20:12:36 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH net-next 2/7] dt-bindings: net: brcm,unimac-mdio: Update maintainers for binding
Date:   Tue, 30 Nov 2021 20:12:23 -0800
Message-Id: <20211201041228.32444-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Doug and myself as maintainers since this binding is used by the
GENET Ethernet controller for its internal MDIO controller.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
index cda52f98340f..0be426ee1e44 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -7,6 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Broadcom UniMAC MDIO bus controller
 
 maintainers:
+  - Doug Berger <opendmb@gmail.com>
+  - Florian Fainelli <f.fainelli@gmail.com>
   - Rafał Miłecki <rafal@milecki.pl>
 
 allOf:
-- 
2.25.1

