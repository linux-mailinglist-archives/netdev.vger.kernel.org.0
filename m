Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699E840976A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244811AbhIMPgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241181AbhIMPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:30 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A874C12C75D
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:45 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bq5so21629068lfb.9
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TW72UxNYbzv4qy0lUe963kdNXAzTIo48VP5lfoV3wMY=;
        b=D6tgEkIXRm/WemOYu7la3Im2tL8nIEMHEpcTJD/ZI4zbaFdyNpKjcqIjwLE+408xe9
         DK8lwxI01vyfBTT3sYWa8tmfQk7Rd2tv1CyHu0CRTmJoBcQaSmZVc5rDPU3VW7qN1BYq
         5Ls5O7P/XhcnV8wfEW10uH4S2OGzeriH/s54KHKsUo8ih/WpyNhRKnBK60h4q7mW9miw
         O0YVk8yMGc5iUFvpGtJBZoIx48yn7weCp1Gnva37+EuXcbHaHHo5DwSSuYFRl3EpJI7h
         HTLWFUKL8lLjH/SD9XPo0xP0OSyPXTHAdDt8vfI3YLJ4n7tNKEZ7XO5HQM9ewlhYtT11
         eLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TW72UxNYbzv4qy0lUe963kdNXAzTIo48VP5lfoV3wMY=;
        b=wE2535mBnvLOE6jZN4ZOMPeSBZW/hY88++AUHPnlqGPg9/PMWwl0nh5rIsR8u1wpIl
         OS/40BibnmUQmB55/ZYYWrhPlb9slsIFPYwBet2VpfgJi/xOQhNQqJIIWNo/oIbQjWUS
         7I1zbo8VTzu3WTodVxuoXODPPRus89/Is0BDxSOrPGGaOjkD/wQUdCwsE5fZvxXWGZHJ
         0z+CjBbDvNYaJ8C/w0S6VNlE7+qS3Z/u8FQXxQK6q9sNWzoe56NuSXzLrQQ/wDF/ZhaI
         4TiQ6mOei9WjF0vBz0+L1L3fu5W0VtUFrLOuqowVGQn17oN33NLD9TaIY/Yrbr1h6qWs
         PkeA==
X-Gm-Message-State: AOAM531GV/sloJwLhQkttbEdhUkwNu5Yr7G2VUJaucTbc/ITeOpYamwE
        nRYe9xqV75axKR7hgJEK2ItPHQ==
X-Google-Smtp-Source: ABdhPJzqNGuQYfABBVvRR9EEYJE2fPQPGeQCjE205ECthrkpPR6kJuYeT85nHG9SyT+7MCxZRc9v7A==
X-Received: by 2002:a05:6512:2213:: with SMTP id h19mr9371515lfu.598.1631544343759;
        Mon, 13 Sep 2021 07:45:43 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:43 -0700 (PDT)
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
Subject: [PATCH net-next 8/8] net: dsa: rtl8366: Drop and depromote pointless prints
Date:   Mon, 13 Sep 2021 16:43:00 +0200
Message-Id: <20210913144300.1265143-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913144300.1265143-1-linus.walleij@linaro.org>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
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
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v4:
- New patch to deal with confusing messages and too talkative
  DSA bridge.
---
 drivers/net/dsa/rtl8366.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index fd725cfa18e7..cf2e9d91d62d 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -325,12 +325,9 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
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
 
@@ -363,7 +360,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 	struct realtek_smi *smi = ds->priv;
 	int ret, i;
 
-	dev_info(smi->dev, "del VLAN %04x on port %d\n", vlan->vid, port);
+	dev_dbg(smi->dev, "del VLAN %d on port %d\n", vlan->vid, port);
 
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		struct rtl8366_vlan_mc vlanmc;
-- 
2.31.1

