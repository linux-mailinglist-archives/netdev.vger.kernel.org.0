Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C7B417D2D
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348622AbhIXVrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348656AbhIXVqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 17:46:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCFBC0613E7;
        Fri, 24 Sep 2021 14:45:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lp9-20020a17090b4a8900b0019ea2b54b61so1195704pjb.1;
        Fri, 24 Sep 2021 14:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vmXM0x+L2fy2oUFZKpqZIVda6KQ5BuS4MqABxpV0RLE=;
        b=Fd02+5DZCGdPajbQblz6RtZEdBpaT0RdsW23u2GXu0J+qSxYcUQpvLClMFfMU3Mejr
         liAyY4fcaNt9zqXY0Ten5whNspHlgozFxh+M28hvPsEtjWgzU4y17cqW6fDw5qKeENwe
         RVEcII3WbcKWV5WpIPEMY+PqrhRi2sNm4y1y76/t3Ob5qQXwjhmnXhKN5ohS0UIHyZto
         h4Y0LbskPUXgiZeddW5UwgivBqx0o88Gu4mrbilNmyr426+0zLndSYpI10m9xZcioFk/
         rMJRQAii8MpyZdNhn/5oEumlUE2Rugl1jnuZOM50l2NH3G2omWbxHVckVW9hbCRj/wNb
         sZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vmXM0x+L2fy2oUFZKpqZIVda6KQ5BuS4MqABxpV0RLE=;
        b=6iQP6F6QUDI4ZEngEGy6QcKdaPhKItyScaL96dC6Q/Yx+u7ATs+PtYYChVcxzHQO0l
         +pIc6I1HSZa126109uUKWVk7EXoEr2a6PaxCbV1MQuYH56f8etc7yyYVEs8Y5YwmglBm
         uFmf2Tis4lcSC673e0+J1JCFaVir15tSgxWsQXaOfCOw0pbOtq+JWJmQcfNQdaEFgJT8
         IVlgX6XGOAEW/reNHMD5DxxChX85IzxLE7IAXYtjPb83H4+EaSesfLv0yEA/28S4NeNB
         0F9uf9ZH3eqbJMkleX1Qm5Si+5LBO/cWQaTf2/oZ21V/CtS+fDc0stRQqfMvZd9EEpkd
         pkbw==
X-Gm-Message-State: AOAM533j/jstXEIYqFlGkI6u6o0p0tMGhwXbXAzL4hoZuAHBGxVKmZG3
        i37oq1tn5FGylQhLbNw//WOuTgrDt+dvPw==
X-Google-Smtp-Source: ABdhPJybXofQcKpz9+5yupOdPkX9X/mvHj3Fe0KKcW1PyI8x5z4ZraFHO7B4bQLBBOHzDvEhuHAA3w==
X-Received: by 2002:a17:902:c084:b0:13d:c6ef:7cf0 with SMTP id j4-20020a170902c08400b0013dc6ef7cf0mr10957762pld.4.1632519917109;
        Fri, 24 Sep 2021 14:45:17 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm9842029pfn.142.2021.09.24.14.45.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:45:16 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: [PATCH net-next 5/5] MAINTAINERS: ASP 2.0 Ethernet driver maintainers
Date:   Fri, 24 Sep 2021 14:44:51 -0700
Message-Id: <1632519891-26510-6-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f46153..3ba3ca8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3762,6 +3762,15 @@ F:	drivers/net/mdio/mdio-bcm-unimac.c
 F:	include/linux/platform_data/bcmgenet.h
 F:	include/linux/platform_data/mdio-bcm-unimac.h
 
+BROADCOM ASP 2.0 ETHERNET DRIVER
+M:	Justin Chen <justinpopo6@gmail.com>
+M:	Florian Fainelli <f.fainelli@gmail.com>
+L:	bcm-kernel-feedback-list@broadcom.com
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
+F:	drivers/net/ethernet/broadcom/asp2/
+
 BROADCOM IPROC ARM ARCHITECTURE
 M:	Ray Jui <rjui@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
-- 
2.7.4

