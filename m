Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B43DF726
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfJUUvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37520 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730401AbfJUUvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id g50so9168027qtb.4;
        Mon, 21 Oct 2019 13:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FU9q/M/H1+HIalxOSW7oUGNiFmwEDh7wdw0zUnuQf6c=;
        b=bh6yL6yKPXrI7Jan+I9Z7PafBdxH1e0xoVB+UbpteQ9GWIYCxJQvZvKF4L5GA/uIvU
         ptoN/buJNowAi3W6XguCUO+VpbZT1Qp8NqFoV+0RNPg7JtsCLbxtz9YGxTx2w9p86mlG
         lNkWW1KKckBpg9O4/E1s8Oa1fbUCJleUxpKhwkECVYhcIQsm4B787nIWyMgGSB5HJFxc
         PgFlMS/nRowiNUonVWtRJOeCOTLAnesyAhB4RGmgv9FGGVh/NMxpyT0JaQsqC7W3fQ4W
         QqJHnL0XJSxy+6vPTjf951/F1KfgCZoB7maxG22MWANbFF216RDfsr+AbfkfwfhAMONk
         7HaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FU9q/M/H1+HIalxOSW7oUGNiFmwEDh7wdw0zUnuQf6c=;
        b=W7OJxmVzL9DjJg+89PFfvsaXhY0g8NBfJeZg3jH8gDGGDRmr8ckpKFp69ThCz1eVWh
         0q0r0/ASSWCBw17aINY/JfLjWXGaXe6MQpKINFCyvtQYwlNXXeKv1cBk77X4q1EP7pdq
         w7hXERHZqe/XNwkp8KGoM/Qg2lCUy8uiCBdBJQo6gu8L5P5WZGN6maZfpKLs+WbY/Dcg
         amV7CS48c9WpasWlmtpiuPsC3PjfyJQjdrbZgF1sRozavTpG1FkR20/GMO/uSH5UB3Uk
         ptvIpz1lEyQco6jWfwQiFwiwh+DW50w5NBk6yNz645oEX7b/e3PKtelQ1BGi3ijj8Wmd
         QomQ==
X-Gm-Message-State: APjAAAVe6tifZY+U+MYP3acHhEi7FwGle3GGAo92egdL9xn8BnGjaF7q
        KsYJBSxJ2Aq4hujujNc6d6ui/gDT
X-Google-Smtp-Source: APXvYqz5vWmIQL78V3Tcr3ubqdVHzfWK14aJmD5KeZiWh9I+Kv7VWztmsjHiTdX4ZDVm7+rqsqrFoQ==
X-Received: by 2002:ac8:6793:: with SMTP id b19mr25115688qtp.99.1571691100437;
        Mon, 21 Oct 2019 13:51:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c204sm8739893qkb.90.2019.10.21.13.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:39 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 03/16] net: dsa: use ports list in dsa_to_port
Date:   Mon, 21 Oct 2019 16:51:17 -0400
Message-Id: <20191021205130.304149-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of accessing the dsa_switch array
of ports in the dsa_to_port helper.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6ff6dfcdc61d..d2b7ee28f3fd 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -285,7 +285,14 @@ struct dsa_switch {
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 {
-	return &ds->ports[p];
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp = NULL;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds == ds && dp->index == p)
+			break;
+
+	return dp;
 }
 
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
-- 
2.23.0

