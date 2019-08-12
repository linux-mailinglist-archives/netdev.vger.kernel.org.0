Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C58A9ED
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfHLVwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41671 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfHLVwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so3638923wrr.8
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhDH6IJtKxcK2QewBnVvLIdFZGW/seVbjuI1A2YOJuo=;
        b=Ie9YLi+9a+JYwEWTwh6lUHH8mEco/CJRa6/3edsnEi+xJDxg3o9W57Mo+rU8Qek+Fm
         3yB5EWfOBhiGJ0eOjJZjNYR4Zaqc6CaWTKyOaG3FFQSknpDMMBCueljY8HH6kWV2jR0K
         QuyvLH38U9wDllykFxlk8+EDiOKQ5u/5luOIO2HCTb2z3OMsQ/KSNodPewW+F8MdYSzb
         +79dnebMWn5n+DiNxnlXimYVY3jUY8RDfImIX7QfGpjoT1JS2Frcu5P3hC8MEqsAJTpo
         4eUNsy5QhJniPPP7aVYULM5iwom0SBS5y/qitioRbTfSabKBY3CNdkkoub3KAolejbzw
         ERsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhDH6IJtKxcK2QewBnVvLIdFZGW/seVbjuI1A2YOJuo=;
        b=gekmGVpLrHKUEfI0jLRlz33ynFNVdSJ0Wr5unXJyIWh9TlthjQnEIBhGzeyN8zPRHS
         fKQa/8Z8LdHafrnWWHzbBLKF/9TQHAc95RkisjNL5DJ8O57eK4TipnSkF367jDLmPcPC
         iyEodfZYlgfOXWq21SVzFhZlrIzPcbqXu/YXFA2XhXOEz66a4pKHt+9SoqbNqeYWuEv4
         pMTQuY5fMSxMn8PxG4ibc3jI/X+l3v3xGI80GjBaRwa9+tYD76RqUJ7U/93D4aXDflCI
         kPl2VmXkAPusd1nOPdRI/ZmJSmYwwi5xQew4kkKlsjUCCGrkBTLLetXwE/HnQ1OM0v68
         m84w==
X-Gm-Message-State: APjAAAUubr4IKr54Zy/nGNcJ20Kb1s8VgowxwEJaeFG2NVUjkq/ZkAKO
        Bo3pZo8cSHVVjW+qhKC07cimydWU
X-Google-Smtp-Source: APXvYqySiXYkuIV4R1LOGxyomfhoj22m74sspxU+CezDYMgmhEduETAjCXG2bOl7RXSzMhlxMEgqkg==
X-Received: by 2002:a5d:4bc1:: with SMTP id l1mr21166781wrt.259.1565646750837;
        Mon, 12 Aug 2019 14:52:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id z8sm23896691wru.13.2019.08.12.14.52.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:52:30 -0700 (PDT)
Subject: [PATCH net-next v2 1/3] net: phy: add __set_linkmode_max_speed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Message-ID: <4c77b801-6005-834c-da0e-f32847961f81@gmail.com>
Date:   Mon, 12 Aug 2019 23:50:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will need the functionality of __set_linkmode_max_speed also for
linkmode bitmaps other than phydev->supported. Therefore split it.

v2:
- remove unused parameter from __set_linkmode_max_speed

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9ae3abb2d..95f1e85d0 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -207,14 +207,14 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
 	return count;
 }
 
-static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
+static int __set_linkmode_max_speed(u32 max_speed, unsigned long *addr)
 {
 	const struct phy_setting *p;
 	int i;
 
 	for (i = 0, p = settings; i < ARRAY_SIZE(settings); i++, p++) {
 		if (p->speed > max_speed)
-			linkmode_clear_bit(p->bit, phydev->supported);
+			linkmode_clear_bit(p->bit, addr);
 		else
 			break;
 	}
@@ -222,6 +222,11 @@ static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
 	return 0;
 }
 
+static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
+{
+	return __set_linkmode_max_speed(max_speed, phydev->supported);
+}
+
 int phy_set_max_speed(struct phy_device *phydev, u32 max_speed)
 {
 	int err;
-- 
2.22.0



