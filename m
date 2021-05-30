Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDE439534F
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 01:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhE3XBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhE3XBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 19:01:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2FEC06174A
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:50 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b11so4545936edy.4
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SdS22aYbHQ3OEwk90g2szFYzKzQ9ixoar1urYFeE5rM=;
        b=KGQKWGXOtgE27zjKwRuni/AhGNbvc5TwFi92YjbNrtb9ZMa7lIDYwObSzmNvHEPFOf
         OgMg+n73dZW0MVqtCrBEuYqiQ6tkMEAHVpOAbK7CvKExDkv3CAumrIP7NwkwVuTKu7f3
         Bqno6NnANyv4RzeV1Ef57RsuIhDuUVR4O9z04QnzE1b5+HWaOl/564xD34hoOHrgYtMn
         C7Jhv9hP1mfJ5Ud/OnO8z8HG76lpqpbixtgqA84wC0Q/+GwdHsyFuOUTUGSVjyMhDc9f
         /57qNsHUyZhOXKcRAZjkTssrY7K9Dgz0GB5/glw9tpq55BTkCXXzeV7kO+u/N7Z+aROS
         rEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SdS22aYbHQ3OEwk90g2szFYzKzQ9ixoar1urYFeE5rM=;
        b=biVtgikYxTgVgvjxWZ6hZhBYX844pIJu0dLn8WgJOQOI5IotuZThho4bGhdHONuUa8
         07QSRAVuAR7evi6Jk+dxR/ahkt3qu4S4KC6LeDMwo/Bj+bcA8A1AUWK/XW84ECq3GNIR
         D9cqhRdlaqnt0XTFx74WYm8KCnPQhy4gWGiv48C4RnKv9cQk4I3C1UoBDxAkZz5uPdAc
         DaF9iOOgX6rZLq7h27ii6VakU7i285t6lIsdM2Cj8jd5wvju9rHHkqalXjz0s0FT+RB7
         3D5E7gREe4BRDGLUD16OsTulp8RxBqNp7e64ux6OcoeBHmJ8pZ3bn4GmcdklGevU4MaA
         CsBw==
X-Gm-Message-State: AOAM531rgNVXVYKWyB6Ambz4xP/Hy9i7fU116Ftgfdq2dq5ct9JHEld4
        pE05cHc2WkyUVWHFVA8KFjg=
X-Google-Smtp-Source: ABdhPJwMT4IUJ3X45NwRxqZN5KADCGT6vqfvh/FtqwTyno2fYgJAVTQ0+9c7/5jkMJqHifhW13AUfA==
X-Received: by 2002:aa7:c44b:: with SMTP id n11mr9404106edr.4.1622415589067;
        Sun, 30 May 2021 15:59:49 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c6sm5135120eje.9.2021.05.30.15.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 15:59:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 1/8] net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
Date:   Mon, 31 May 2021 01:59:32 +0300
Message-Id: <20210530225939.772553-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530225939.772553-1-olteanv@gmail.com>
References: <20210530225939.772553-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since commit f2f3e09396be ("net: dsa: sja1105: be compatible with
"ethernet-ports" OF node name"), DSA supports the "ethernet-ports" name
for the container node of the ports, but the sja1105 driver doesn't,
because it handles some device tree parsing of its own.

Add the second node name as a fallback.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2080f36ff25b..4c776bd7ce25 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -885,6 +885,8 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	int rc;
 
 	ports_node = of_get_child_by_name(switch_node, "ports");
+	if (!ports_node)
+		ports_node = of_get_child_by_name(switch_node, "ethernet-ports");
 	if (!ports_node) {
 		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
 		return -ENODEV;
-- 
2.25.1

