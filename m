Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88F8368A85
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 03:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbhDWBsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWBsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:30 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79961C06174A;
        Thu, 22 Apr 2021 18:47:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mh2so50046224ejb.8;
        Thu, 22 Apr 2021 18:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CIfIzGZkRa2NlAensBq+Zlw+3TjmXuG3tgcd/3/lGKI=;
        b=JlzwpJ/Euj/7X4ge1iIjjqTYcQtDI/+3MVVk07wfdtsaFUA3jY7YWGwy2mVYl2Bjm3
         DbiHAwpYXEYGqU95IImGCYvc0P2zkXhZea62Dqzrpkb0xdPpM/7o8aO95qv3tT0xxNiN
         APg1dLzLFj/mmwgFwpWr6sdvnBMnZLuRzLLExj/4BPVCB9oJW7Azh30uSPtCLNkCi9c/
         M7A9DuULoLyPTtsbhNHRkRQBP3iiibweQoVnqjpWbaZRgKbd5RtjDa+9wPCzqOkVxptX
         NxQQCRRLI21dihb0nXfVqfwDeLnKLo1jTSKhusiHnunDTZJG7t9wvWBwTSjNaTKGGOUW
         RApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CIfIzGZkRa2NlAensBq+Zlw+3TjmXuG3tgcd/3/lGKI=;
        b=rc26KG8yc5mDkAACRLMH3EXNPe96vPjO39I+XqKrS89M6ak4YoSf74w0EAd53zz1dk
         RFNThvHpnTwqozOyn2kRYmtfl3CiWQhT6qFQOmrI1YFQiYrTi13hhCJb01ULZXzixOgU
         H5em50Xbxm5YZnKFHGhFBlDTXS7kZbll3f/Fx8A/nC/QqqCZn9ElozMFhkdhKoNiWxCV
         0VK2g91TRADY4CthR1V6EiNJQMurQP8qk1xVRl505UPaJ4B6qG+SUiyaw6rWa7j0Ud37
         bLqUCFEia8cGnYS6P56sF2n3DVeqMwPuTySHR92s8QIbslcSEvNLwSpqJnwoM1LON3T5
         Kzkg==
X-Gm-Message-State: AOAM532a7GOzbOPFRL/FFSz1vD1+edWTqlI0kzSAPvy2GzYcZ3YItmW5
        94lnRUhPuSgg8FXj3qRF5Hg=
X-Google-Smtp-Source: ABdhPJykHko9F5h7yYMHgNh8UDMMTP4nnC63v1uuhQt6Umv3TSULWgGJti3xdS5HYf/LOCkccj3BNQ==
X-Received: by 2002:a17:906:138c:: with SMTP id f12mr1611358ejc.180.1619142473184;
        Thu, 22 Apr 2021 18:47:53 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:47:52 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] drivers: net: dsa: qca8k: handle error with set_page
Date:   Fri, 23 Apr 2021 03:47:27 +0200
Message-Id: <20210423014741.11858-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Better handle function qca8k_set_page. The original code requires a
deleay of 5us and set the current page only if the bus write has not
failed.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cdaf9f85a2cb..a6d35b825c0e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -133,9 +133,12 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	if (page == qca8k_current_page)
 		return;
 
-	if (bus->write(bus, 0x18, 0, page) < 0)
+	if (bus->write(bus, 0x18, 0, page)) {
 		dev_err_ratelimited(&bus->dev,
 				    "failed to set qca8k page\n");
+		return;
+	}
+
 	qca8k_current_page = page;
 }
 
-- 
2.30.2

