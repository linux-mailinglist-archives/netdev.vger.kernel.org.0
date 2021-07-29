Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A873DA13A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhG2Kkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:40:42 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47726
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235445AbhG2Kkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:40 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 93B013F110
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555236;
        bh=Cw3WxWMdLZ5M5UUT98hz5uB4oSAZN8UMdeHX+1yibmU=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=f6P0ep9s8myPt1q5zKD6HSvg/Hmk+cNMuYa127/LjWDmke/nuikcV04a4q0Bx4OLo
         uDLZyWBXcV8ws4E1yWbUdg60dlBeiQxHF5nbqIU6svJLr5gGjz3u6KhX3FHtI2ygpK
         NPIpi92IVCduPvKZG6ZWDDtH/UbfOwlH3qI5YKJD6ZJubDtZwPnRB83wXfBLON2bWQ
         KGJrfH9IPiG3dJejbHRE02M5LD3nYtZFQwxaFSaCP3InK7Tb6uzW0YG4tiTBa7oCjI
         LXY54VSB1hiZwz1BPOb0F6Cm90N97xRpKX6vlElrc3ClPxBMhs+OAOQi1cdApeSOu1
         4vBZsVzHDpp9w==
Received: by mail-ed1-f69.google.com with SMTP id j22-20020a50ed160000b02903ab03a06e86so2728003eds.14
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cw3WxWMdLZ5M5UUT98hz5uB4oSAZN8UMdeHX+1yibmU=;
        b=Oige//M2U8/TBQ/uuBIp9d642srU6iv5Xm3jjjrxv373Q8eXYbiyFsZje+5S/3VYkF
         TITXs8Tabtwg13+cSP4Unnkp6ZfwwIZRQzq9tAJBmH1Dgxh+pu9z7HG/Myo5uOfh4dP9
         27vmbipqaHZDKFVytUe0jebvYiPkEM18SS7+KZlDWLUzRhIk5yeR4zetVQU2Uzsh44L6
         Vmjf9XtExOY2APT+hIkQ1/ICaS60X2ehKhHZk3izwIen/aFgfo87YEQoldtNdO+/hR7d
         dfS1XdCE4fAAsWS0VisgoCBr8uSlaxfsabexrbE07pzWJgfnqMcOzEQdRrKqbM4Hhxe7
         YHgg==
X-Gm-Message-State: AOAM532CEypzsJu95TivpOzrj4h9dA1Kp+4uoMx0PmFVoqdBcoI7K4s1
        cnmiIqrYrJ0svDQoPbiWWolVo24WezS7pnh6dhJIi9eqf19gO0zzVWxIf0Tj7nKSWmukoTgfK35
        HH/Owemd7nsGi1Cb7nvyw9HtZ2BmRTKolUA==
X-Received: by 2002:a17:907:1190:: with SMTP id uz16mr3961128ejb.543.1627555236309;
        Thu, 29 Jul 2021 03:40:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyelGCc7LxjALvK3umx0eo+PexaLLnBk1cGkBUbydBmcQuE3sbk2nmw8yhHldZtMsl1cgWHbw==
X-Received: by 2002:a17:907:1190:: with SMTP id uz16mr3961115ejb.543.1627555236127;
        Thu, 29 Jul 2021 03:40:36 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:35 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 02/12] nfc: mei_phy: constify buffer passed to mei_nfc_send()
Date:   Thu, 29 Jul 2021 12:40:12 +0200
Message-Id: <20210729104022.47761-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The buffer passed to mei_nfc_send() can be const for correctness and
safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/mei_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 41146bb99474..f9cca885beec 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -202,7 +202,7 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
 	return r;
 }
 
-static int mei_nfc_send(struct nfc_mei_phy *phy, u8 *buf, size_t length)
+static int mei_nfc_send(struct nfc_mei_phy *phy, const u8 *buf, size_t length)
 {
 	struct mei_nfc_hdr *hdr;
 	u8 *mei_buf;
-- 
2.27.0

