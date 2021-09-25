Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE92418243
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245665AbhIYN1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245633AbhIYN1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 09:27:14 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2BBC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:39 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y26so13532843lfa.11
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k04RTdRCY30lSM9g5jnyDip9cxAIKlIITWf3Cit+LsE=;
        b=ruK58Zs3GW0TXGXcuD6HBerLFVCWybbZjClbhrD3/Ybfpzm4J8XFVhozMR2VzO3uzG
         CeMQetz+eCArXouX69lZ0envKzNZSI8rfU+uNC02Nx5DwFlJsrCBe6awJUr+VMHMC9lZ
         SpqsxbkR28ycW6Jvp4JGGz9xqGjaY3TtKOy2gIKpnbAyBlgv2I7rwYs9yekoAZ+soC7C
         LS5pVsZPF6DTAMfX47wHuv0MWxNSDT6RAVULAaLCF7Jdkr1H7RRjFIPhzFTinvBG+ZFW
         73kJtujAi6SibismDS/QdvOxjDfFrsIpoP8NgcRSCbdEZlJFDabEbMDpmUQi10SRe2qs
         pWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k04RTdRCY30lSM9g5jnyDip9cxAIKlIITWf3Cit+LsE=;
        b=S4kwAFx9HxCYxRYpsNorAcBvX5YUik+2opuZn6a0g/IvBmamg1RgEzJLWoBRR8ykbY
         ubjeaEV1r8n8jMhv7fEhZ79wk1QWgfZZ2gvU8NJ8jraVLcP50f+MFCNsWGTocGX37acr
         QyQP30r3Cbq8MmsBrsSOrVn78+w8vk8eX1VCQU9CW7qUdcUoozGyevDy/sAU6931WTcS
         lZE0/7b7Qh93Dm9wFmy6fZ68NUeps61VUk134mbubc3MYCghQaeMvki9WxklSQOVMGgY
         65KqS285ISqWy9/O5vRJWkSKOfaBoDIM3i+05PqqE81vmhIsFxHLq/GEkqFKypBXmSbX
         Y+lQ==
X-Gm-Message-State: AOAM531tJMyN4QPws4p/id0iNQHFK9gqH7rNTU42u6khlYN/Y4bYEyVl
        YkvTOVdvTAcX69w/Zz2YOwvNwA==
X-Google-Smtp-Source: ABdhPJxcLoHWp4S0ULgMlmM0zy9o2DqKAmTeTfs1y0g/dfK0ac2cJ8DzVFdc1Zyq1CDaADZhWmMN/A==
X-Received: by 2002:a2e:9f4f:: with SMTP id v15mr17125288ljk.468.1632576337977;
        Sat, 25 Sep 2021 06:25:37 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y25sm199590ljj.23.2021.09.25.06.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:25:37 -0700 (PDT)
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
Subject: [PATCH net-next 6/6 v6] net: dsa: rtl8366: Drop and depromote pointless prints
Date:   Sat, 25 Sep 2021 15:23:11 +0200
Message-Id: <20210925132311.2040272-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925132311.2040272-1-linus.walleij@linaro.org>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need a message for every VLAN association, dbg
is fine. The message about adding the DSA or CPU
port to a VLAN is directly misleading, this is perfectly
fine.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Collect Florians review tag.
ChangeLog v1->v4:
- New patch to deal with confusing messages and too talkative
  DSA bridge.
---
 drivers/net/dsa/rtl8366.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index f815cd16ad48..bb6189aedcd4 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -318,12 +318,9 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		return ret;
 	}
 
-	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
-		 vlan->vid, port, untagged ? "untagged" : "tagged",
-		 pvid ? " PVID" : "no PVID");
-
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
-		dev_err(smi->dev, "port is DSA or CPU port\n");
+	dev_dbg(smi->dev, "add VLAN %d on port %d, %s, %s\n",
+		vlan->vid, port, untagged ? "untagged" : "tagged",
+		pvid ? " PVID" : "no PVID");
 
 	member |= BIT(port);
 
@@ -356,7 +353,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 	struct realtek_smi *smi = ds->priv;
 	int ret, i;
 
-	dev_info(smi->dev, "del VLAN %04x on port %d\n", vlan->vid, port);
+	dev_dbg(smi->dev, "del VLAN %d on port %d\n", vlan->vid, port);
 
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		struct rtl8366_vlan_mc vlanmc;
-- 
2.31.1

