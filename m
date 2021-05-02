Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B62370FA0
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhEBXIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbhEBXIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:21 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BDFC06138B;
        Sun,  2 May 2021 16:07:28 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u21so5161121ejo.13;
        Sun, 02 May 2021 16:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7yfjEimD/alqFUQxL7Bgq063b16AI+9B8ShVavcH1Hc=;
        b=a/6UaBMkhmwiJFHf9X2E+gio3vBrU0dgkO7yn5mR0pzNV292ogvloz6b0A1qLraHFC
         N9OpSE6t46kH/sL0Xq+9kEcCvMYUsqbGugVWB5Sm6D5I/o36Az9X8s4xhqZ64+27Hws4
         ruR9T+jnVbudvZaRpSROT7pkwY5Rfs/FY9Jt/YvmsrOZo9CSOmrPBDupnwdOoGtk6/9O
         DLeuy9pdJ+fmahhYQAXqn+GI4/Rmu7J2bV4le815GG1csnv78hOBQwGFPGYLVvwB2DYc
         4VVPIXjJ5CVUEKehUvpS6ioBVmNAYVEMXNQqJMIVz8hWN8nPV0RaIMWpQhyUzbj47wxH
         BMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7yfjEimD/alqFUQxL7Bgq063b16AI+9B8ShVavcH1Hc=;
        b=NErPumd71vJfbeo7qObN9JKz7S43OrfUxwcmAqOY3A8u0IGnr7ZBVz6/kBmyW0v7E4
         7/JO6AZvs37bnk443zZPrP2d4mWVZuneHycKkjt8lNjPKHBUn6Js8gom9cCJhUDqO9XY
         VETqR6Pms/0VF//9HtHwP3ay8he8x7Mxt3l/yiTvpNNrCBdqF0ZUf2rx8M0bsD9rbIag
         LOA8mNCmpBfKJuqjWiqcwWEJgwRil4R38KZGuZQ4XT6TZrSF0DZqsysXeRYefdSGmyQg
         RtDZivJQpF7FD4hX7aTT3RNdWnUC0l+rQiT1NWH3wWFN9yCGsNQ+dshMksgSVoNR648u
         oXRg==
X-Gm-Message-State: AOAM533b41TlDjssVwpNfD4ucP+XQ6jRXwGsyoaPJ1xEyqz/Qf+U46YM
        HBuLs2RDGWhYtgQEdu45GVY=
X-Google-Smtp-Source: ABdhPJzKDAb9QoWIQGTn4G7vYMOskmFuwspJ9SACsUqiY9upYUUWHkHftEdyHUU2WBgwIJ/lfSf4aA==
X-Received: by 2002:a17:906:a403:: with SMTP id l3mr14474769ejz.251.1619996847562;
        Sun, 02 May 2021 16:07:27 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 13/17] net: dsa: qca8k: enlarge mdio delay and timeout
Date:   Mon,  3 May 2021 01:07:05 +0200
Message-Id: <20210502230710.30676-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enlarge set page delay to QDSK source
- Enlarge mdio MASTER timeout busy wait

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9a1b28bcaff0..7f72504f003a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -140,6 +140,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	}
 
 	qca8k_current_page = page;
+	usleep_range(1000, 2000);
 	return 0;
 }
 
@@ -625,7 +626,7 @@ qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	timeout = jiffies + msecs_to_jiffies(20);
+	timeout = jiffies + msecs_to_jiffies(2000);
 
 	/* loop until the busy flag has cleared */
 	do {
-- 
2.30.2

