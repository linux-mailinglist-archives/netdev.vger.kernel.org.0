Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5A465475
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352159AbhLASBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbhLASAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:22 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DC0C06174A;
        Wed,  1 Dec 2021 09:57:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b11so18291120pld.12;
        Wed, 01 Dec 2021 09:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=01hLkNW6U3CPpS68qnrfuu+pdGd+j2RGBLQC7jYPJ7E=;
        b=LGFmv6hvr4XYmTujm0fajcm1lO45kdBhoHNt2JqP/aw3ZvnY6U59KycxvJxbRP9jdA
         RDRNyNydD4be81R+3/h1ihoPmxmQLXgzTIRg7zxVhROjFJNE5AYCneblWvKjRFa/p2Dj
         pqAmax9lMNCUscMTPwX8H4mXwj556+f4PPfqOV4R2ZfZIDs589XWVEB4VCpS/Wa2bYLr
         qE1tsFeZubdvN14tGvjoyi4/C7hm8gcLpsaZFwhSaOer3M4/ZXqkB6LNP5a7jLFkG6h6
         M6dV96v3dGLHBX6mSSHLqjXSt7UHrCRysLXhwXP/x1/08R21YbEdGpJfY7WIDUVnxIL3
         y2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=01hLkNW6U3CPpS68qnrfuu+pdGd+j2RGBLQC7jYPJ7E=;
        b=Ym6bmWVAeOjU/Mj2MBJurGHbRZPsOq97dHUM84QEha/NNKkSTZlqBWVRbj/Wg4eaYn
         hKAUdIJSCg0C0GtmsC9ccwspis84yPQJFoeK2Rugcaes5ObNO4knYV7J4r65JPgzdeRj
         b9HoekbTrIO1Tuj0LEo/4AVcWvOLSc8oRfX+y75QwZnp1xpyg/0W+NxTNq0BG03m/kDo
         nzqziDYodO4C3X2vP1U5MdPrPuO+WvqKKA0wpKO/yU7PpZXE9yl/i18UyLf+Pca8FktM
         ocgbXwfv9z3cXUFSjGLNkiv7GVnJOZwCfRPiaqwsA9wCfeHMgx0lbHDndwOmvPvqY8II
         YVrA==
X-Gm-Message-State: AOAM532XsxBA4jmhpXT0TTa+cN5hVtmNkL7fEr3FxtqhV/GxP0y26JW7
        hE4HqU9iXmwUzhdXmxf6ACk18SAK8Nc=
X-Google-Smtp-Source: ABdhPJxwejBZAQbi2Bm8sAB1y0DrRWCAn7pPr7nzDhzzY7gu8JIeoa7SjaOXvXEPZxeHjG1Qjx2I1w==
X-Received: by 2002:a17:90b:4acd:: with SMTP id mh13mr9504069pjb.230.1638381421139;
        Wed, 01 Dec 2021 09:57:01 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:00 -0800 (PST)
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
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH net-next v2 1/9] dt-bindings: net: Document 2500Mbits/sec fixed link
Date:   Wed,  1 Dec 2021 09:56:44 -0800
Message-Id: <20211201175652.4722-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are Device Trees with a fixed link rate of 2.5Gbits/sec, add this
value to the supported enumeration of speeds for a fixed link.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index b0933a8c295a..ff4909e1fdda 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -178,7 +178,7 @@ properties:
                   Duplex configuration. 0 for half duplex or 1 for
                   full duplex
 
-              - enum: [10, 100, 1000]
+              - enum: [10, 100, 1000, 2500]
                 description:
                   Link speed in Mbits/sec.
 
-- 
2.25.1

