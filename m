Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A57E58D55
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfF0VrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:47:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33957 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0VrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:47:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id k11so4153158wrl.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+kF5Sz8LYhWIcCtfXYvVERBphEMiNMUMDiMT9ihX0F8=;
        b=LJ8crc1j0qxP2xhDLMd75FHJh3nOX4dzWlyc14cYrFKxOglMusqWEZ5OrI2grSMjh5
         1R74TDBKQu5ldYM25GIwG7STzs8qWJuWD1dS2fZjImXwe5Tbui+UYHwdmKInk1I8kMOB
         abaXzKYV/GoKK/RVW9PU9ixaJc8TYJadAnqXEn0tB3+Q3T4+4KnanN2Zm+B8Ghc8c36l
         pyILfGs8WHBnHQJa7w9NdPLZUUS80D2mccyaZOdjWon6Lyvm+aXln3jPZFkOp37mCtv6
         F4ivwG76TyzCY5V4f5LWSHol6H0IdIayGR5Ruul0ji7AJIZ5kHRcXEgszQwFmIWMy3sq
         1vhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+kF5Sz8LYhWIcCtfXYvVERBphEMiNMUMDiMT9ihX0F8=;
        b=cD14Ae0qCHZwBmC82ebm8p8oJKUnZhp5PiVzw4NcK1HsnWdh3sKXwWKUX9MfDFg3W6
         y1GAU+DfNmnOh5w8KwPjSTGXbieRkBkZDeUb9mRDOEhdaYg1oNnqLXH1LBYMUWgsEvlr
         bd+VVZtooifNZrm6kdLC7OLuxFD0HFSNmWyy8BYYQShGpXqk2DUcGW2H//STctOcCo9w
         0tske6yIigq363biaHkaHyJdJRl+BpzVZv5mBEH4qG8UCpPL4SA1F5cbff5EV0l7LVKi
         lzb2XMxDPeQACnYCoqNj6KaUgHjmX/mAamP60aKn1U+IP0v6fJXU+rvmT838132dgfjV
         CSNw==
X-Gm-Message-State: APjAAAUtrtqDqmsdHfAiD0njg6Gfu/HuxLiJ+K2KC+XRhYhQvCTlMv8P
        FHzfF3ck/GPIaqVmDQc/lMtqUhlc
X-Google-Smtp-Source: APXvYqwyjSAnu1+yowbWBVdbcUw3kk+p5HXJ8F9QaUg5DJv3BY7vZA28EirE8pQG1mAqg3DeUi1oXg==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr5177965wrn.142.1561672024939;
        Thu, 27 Jun 2019 14:47:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id v18sm286923wrs.80.2019.06.27.14.47.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:47:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2 net-next 3/3] net: dsa: sja1105: Mark in-band AN modes not supported for PHYLINK
Date:   Fri, 28 Jun 2019 00:46:37 +0300
Message-Id: <20190627214637.22366-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627214637.22366-1-olteanv@gmail.com>
References: <20190627214637.22366-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need a better way to signal this, perhaps in phylink_validate, but
for now just print this error message as guidance for other people
looking at this driver's code while trying to rework PHYLINK.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b366b8e100f8..32bf3a7cc3b6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -806,6 +806,11 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 	if (sja1105_phy_mode_mismatch(priv, port, state->interface))
 		return;
 
+	if (link_an_mode == MLO_AN_INBAND) {
+		dev_err(ds->dev, "In-band AN not supported!\n");
+		return;
+	}
+
 	sja1105_adjust_port_config(priv, port, state->speed);
 }
 
-- 
2.17.1

