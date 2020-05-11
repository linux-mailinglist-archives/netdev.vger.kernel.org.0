Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37C21CE951
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgEKXr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKXrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:47:25 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FF5C061A0C;
        Mon, 11 May 2020 16:47:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id a4so5297851pgc.0;
        Mon, 11 May 2020 16:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HCTXvjvCph24DEkMzpVFI7z1KfM5XrIGnv5g1ieUcQA=;
        b=q7crp00oViKdMXl3r+hhT9Xw+KFTIcVZz8jv6k9kmC9elV4fMkkDNCv7QVJ7qE1mgC
         GhiN+oBgSZfLotaDTrBnG2ovcDrRBWf4isFaqwgcdwYxJCBsmjyu/q/yTolMiqtqpm6b
         3jUhK14qh+3QMZvpdTBfc3eMPeE1FVRrZmPU50w95MXpysSmcpyioLvifhnMIpwGl6ho
         xz7gv6rY4nYZ2D7SrybvmL8/zTEZWfecZC+/7WO2c1ejbC67+QahafadsPJhYWS9ANkT
         oJJqEKP+UVkwmIBMs7tc0+aYGAq0qKT12hobCoXhArh+uJJ+xwxiTqk+9Az8fbqqMQDY
         G8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HCTXvjvCph24DEkMzpVFI7z1KfM5XrIGnv5g1ieUcQA=;
        b=VhN0lP8R0Uadj/wsl8P8JC7pbFuGoCYvum13XHgPEurRE8WPyXC40DI6kjomm+4uI1
         n04mZqQLRCnApu8n5IFJdT/zgLj5QfaeFdyoN4H651WDTfA0V8dT4hSc5dPV6J2Tpp1y
         fNZFwFnF95k4OhHAnMPD4HEVz4X73WDgyeW4rJZupSv8BRtu4CZlQo5xD+hxxnh74S/r
         rok2IPwydxGpHQDzvA3iPjqlGbjesIHaYxqLkBMKPiGBmOArcugfD3CujjrUSUYsa73I
         v8ncfDhKLP1S2JB4fyTFUMXaAlphjjcAX3OZpChLK3BQ22FtLhGfDhqrFkSc+JBUQm74
         Fddw==
X-Gm-Message-State: AGi0PubV0EJncChjsZAZlqf6XzKnzG91cyTnMCHRZWGL4Fw0CrPtqGKb
        yN95pma17Rah150SErdvrbgSZhax
X-Google-Smtp-Source: APiQypL5lCvaX2b1ma8hp4DkKbdagZ+7Jn4osDYAdoBb6d00+X8pgLMKQ2YQAMmJ/mV57qCtyhho5A==
X-Received: by 2002:a63:b51b:: with SMTP id y27mr15677430pge.400.1589240843391;
        Mon, 11 May 2020 16:47:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e21sm3455317pga.71.2020.05.11.16.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 16:47:22 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] net: dsa: tag_sja1105: Constify dsa_device_ops
Date:   Mon, 11 May 2020 16:47:15 -0700
Message-Id: <20200511234715.23566-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511234715.23566-1-f.fainelli@gmail.com>
References: <20200511234715.23566-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sja1105_netdev_ops should be const since that is what the DSA layer
expects.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..5ecac5921a7d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -304,7 +304,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
-static struct dsa_device_ops sja1105_netdev_ops = {
+static const struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
 	.xmit = sja1105_xmit,
-- 
2.17.1

