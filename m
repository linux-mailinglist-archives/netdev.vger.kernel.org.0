Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D3409766
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242253AbhIMPfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbhIMPf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:28 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82D6C028BEC
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:40 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id s10so21623203lfr.11
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rl1GbWjgXVNoK+lm+llrr8EUhw0/WxVcLR5JyBH74Jo=;
        b=fvBbLhTmvrjsv6008yISDXLZ8bxvuq5Z1YRK4b1wu4yXmtYLvjZ9CGr56IRUKVrmIx
         mMtElrRHZm3wGcUpt2R4A3VF5h2XPGB1g5B6BmWI5cYnuITAfKcJWFjTcBFmAPFW7f2b
         CwOKS4ePguXVXeQQ5tynnbWphorBjrAEIjK2puk+y1LaN7adH1pyF+aWQ7jwRaQhddSG
         zEMt8E7W1CN7ffpdZ58+Oc3RisSTL2UlUsSvcg84m5pBeZn6wAOT/GooLEWC3RgG+l1G
         /ZwH6ufgsO7DsYGYvrKOfIGF7cuA8qSU7zk2BMCi2uDonxxeYJSp6XvK3/xjw39MMAay
         aa7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rl1GbWjgXVNoK+lm+llrr8EUhw0/WxVcLR5JyBH74Jo=;
        b=kaGKjiRT7n4P0FbAf8NAKYUxbSY7r5q9Oy+fhdhPf9SJZqk7nwF73Li4ZQKyg+Eyf2
         qob4pWiNXqFnjRnM3Cxt2r8gXoaPqx4PXAW/Xlc83lpMpRAAr3GymQqpfe6cq8CfW0J2
         s7hZG+7prcObAbLuEcxEAyVkk+Uazxyx7R9oCfuV6brugBCCRvsSfFKGcxj3azknW9Y2
         8JllMHeUugIWlkBKy0Z8Dw4GSkF7TYk1TL6zNp/Wh+K1QNg/RKmy9zfGbgi57ysgY4C9
         4TY8oT9O0FytJ6LO4vf4qaiOstwr0vlxgZs2VjjJLr85hnvlY4wkixXh7UX4HnRaNlsv
         7BKA==
X-Gm-Message-State: AOAM5321HeIpE8MzslxAPMrP59c6Vt6fNL+1ZDHE/6cl3LlRwK7hXXTx
        Y/k7sNs/RJ7xcIlmCvYIIBG5LQ==
X-Google-Smtp-Source: ABdhPJzLwuGLabZO/8BJ2sTxI0M0rFUN7MJoZOprsVOV89AFGDQBgaAhglv7057Zv8Ar6xzXMQH5xQ==
X-Received: by 2002:ac2:599b:: with SMTP id w27mr9224290lfn.0.1631544337834;
        Mon, 13 Sep 2021 07:45:37 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:37 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 4/8] net: dsa: rtl8366rb: Always treat VLAN 0 as untagged
Date:   Mon, 13 Sep 2021 16:42:56 +0200
Message-Id: <20210913144300.1265143-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913144300.1265143-1-linus.walleij@linaro.org>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN 0 shall always be treated as untagged, as per example
from other drivers (I guess from the spec).

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v4:
- New patch after noting that other drivers always sets VLAN 0
  as untagged.
---
 drivers/net/dsa/rtl8366.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 0672dd56c698..fae14c448fe4 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -308,6 +308,11 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		return -EINVAL;
 	}
 
+	/* Note that VLAN 0 shall always be treated as untagged */
+	if (vlan->vid == 0)
+		untagged = true;
+
+
 	/* Enable VLAN in the hardware
 	 * FIXME: what's with this 4k business?
 	 * Just rtl8366_enable_vlan() seems inconclusive.
-- 
2.31.1

