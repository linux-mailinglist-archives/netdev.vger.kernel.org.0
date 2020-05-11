Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB71CE950
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgEKXrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKXrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:47:22 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C17EC061A0C;
        Mon, 11 May 2020 16:47:22 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u15so639385plm.2;
        Mon, 11 May 2020 16:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2aN7Cc+ecLn2AN4hTPEYCcEFGy0vCnbNbuGEAazl+nE=;
        b=trGriItODDn5LxmZY499BPD3ZM64n7iI7WWrfrCAPKogO+9XzYEYD00ZKfGoTdviWy
         c+QSa4DH5InfBU1Hp7WZnL4ptS7Eg6hpQMqiuNEbaj0C2gJDRiem1DVZK+Q2QAeNNc+c
         xtzXQptz4rAZhpXSG/Rlo/Ti4tEAXvhYnhkrS/IeB95G7Luqp+WlEXwYrrYf8MIJ0Ek4
         YttsdIzNqjdT0WgtpOA/rAyY5+Wc4zb0LAlEU62PrOQgk0YNKMfKbzc1ivnQpg/iVhDF
         sTuJv/E9cuJ4+fn2avmWeqvKCH4Art+tVCZMABP9ecm5PmZLdURShfXxnZ7ycmX5sU7g
         94Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2aN7Cc+ecLn2AN4hTPEYCcEFGy0vCnbNbuGEAazl+nE=;
        b=nk4EqVEXTkVzFNzikEPda3mIkAb5hyz9QGih3TwTeNxMrpXkCcH4qezzWIvqdKfTyk
         bNUpXBh+28M2etO6hh0IVimY85hTn4OEurzUMVpuEFB5BlShQLsxLJK1D1AjlE9CbkKV
         bwLMZdjFBbh8T76g8yIUNEHgLl0Ebvf0upfbP+sDnFExSXzvzzWy4Ig8XAsOltC+cm0H
         g9tu4U6dCocNcJVRwPYro/vpCP2C+X5y7cuH10TuVfh10Khn1twA3UtDWiTaDMLggiPq
         FwwBveTC95teQGklHfUF1PmsCO2smQgk1doopynMFt9vMXQwRqst3sQbs4hqBsry9G2O
         hUeg==
X-Gm-Message-State: AGi0PuahFwBqdX7WfBHqqyeMgN4HScjDer2lMgW8iJ0Unee5iL+bIVZz
        5y5yxbysPWcwwi4Cm07Xz6+14KaM
X-Google-Smtp-Source: APiQypLGj292GQzlhfWzELk6GcRUwWP/XqlPXNZA4N/npKSfaUkeV1FQMABKnmIPq3a1L7aqLiyi9g==
X-Received: by 2002:a17:902:740a:: with SMTP id g10mr17389067pll.137.1589240841704;
        Mon, 11 May 2020 16:47:21 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e21sm3455317pga.71.2020.05.11.16.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 16:47:21 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] net: dsa: ocelot: Constify dsa_device_ops
Date:   Mon, 11 May 2020 16:47:14 -0700
Message-Id: <20200511234715.23566-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511234715.23566-1-f.fainelli@gmail.com>
References: <20200511234715.23566-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_netdev_ops should be const since that is what the DSA layer
expects.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 59de1315100f..b0c98ee4e13b 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -228,7 +228,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	return skb;
 }
 
-static struct dsa_device_ops ocelot_netdev_ops = {
+static const struct dsa_device_ops ocelot_netdev_ops = {
 	.name			= "ocelot",
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
-- 
2.17.1

