Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE4840974B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhIMPa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344470AbhIMPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:30:11 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28E4C112418
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:34:02 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id y6so17744536lje.2
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PoUTaRHlUiL74+HRLvOdLIuWeO3v+r2S12sV144Rdls=;
        b=JQITu67vzA1T6rpPa1teGVgEYyAt0f7qfgAeuETp1GBOBXjy48IAe3AOo5EA7l2c5Q
         okad5WokkFuCkXLiY6vaalV4ClWErJn6zagKt9riWMz+6/peAs0qB1Cbt/foYoJ3lVqQ
         XXj671zrIUEgb6O0IlpzOhLqyHfi3L4RgEJkpmwqw8+sqcfd1tF+GFPXW+1tSpptOLQ4
         BAAaSsnEWxy09NTQW7G5zJGMzhbw28NAvfrMdkmJiMYumVSLQBAt8WRbFEfTPsoRGcsl
         bg2ChLYWhO+oKEU6oUCk0usVY6Tjjyn7kri+NnT2SmSjyyej9KBunLgInytaHYMQVi8L
         Qvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PoUTaRHlUiL74+HRLvOdLIuWeO3v+r2S12sV144Rdls=;
        b=OX7BxlSMHr01FdedvC+/ruYqmjTVkW/0n082G9xS4HhGQKSiHW/JlThvC5+QBCgEPi
         SfEXjxtDpjk22iCQeuRX7sn4TaUBZzHpVs1JQ6k7Mw6/lvMS48CFVCunAwDvqT5Z1dDH
         MwJMlkUHUTETpeb1Ve8fKZrF50qHsUjeE6qmeGmFoYYZNbbcZBPgROQ49fNQRF7VhcGM
         XUIOq1Ltl5TXJomIvh2KaJY+JuGDauOTAPlCLQv3ykz5T/quvvkVuRGEYrzWoRuJG88y
         htFY7TxMTt9gYDEzqUXAogilFjNPJe0lKd/mriQ4kWHAU22kvT1wpTNpN8YQ1SM4bjKv
         n+Ew==
X-Gm-Message-State: AOAM532N9Ca1CVhiS3pY9JIR1orBONHjecd88Nc1OAkqXCcC2GSba6j4
        Rj544++cqz3gWP7PSnKJ1tkAZA==
X-Google-Smtp-Source: ABdhPJzHOzWtlChYwtBt368kg2XgIZ1EM8yPucqNZI/Up5A74W9PIfGgx/P/R+bX406XwCWhcjx2Ew==
X-Received: by 2002:a05:651c:225:: with SMTP id z5mr11100936ljn.409.1631543641025;
        Mon, 13 Sep 2021 07:34:01 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id e18sm992497ljo.105.2021.09.13.07.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:33:59 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
Date:   Mon, 13 Sep 2021 16:31:56 +0200
Message-Id: <20210913143156.1264570-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This drops the code setting bit 9 on egress frames on the
Realtek "type A" (RTL8366RB) frames.

This bit was set on ingress frames for unknown reason,
and was set on egress frames as the format of ingress
and egress frames was believed to be the same. As that
assumption turned out to be false, and since this bit
seems to have zero effect on the behaviour of the switch
let's drop this bit entirely.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/dsa/tag_rtl4_a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index f920487ae145..6d928ee3ef7a 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -54,7 +54,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	p = (__be16 *)tag;
 	*p = htons(RTL4_A_ETHERTYPE);
 
-	out = (RTL4_A_PROTOCOL_RTL8366RB << RTL4_A_PROTOCOL_SHIFT) | (2 << 8);
+	out = (RTL4_A_PROTOCOL_RTL8366RB << RTL4_A_PROTOCOL_SHIFT);
 	/* The lower bits indicate the port number */
 	out |= BIT(dp->index);
 
-- 
2.31.1

