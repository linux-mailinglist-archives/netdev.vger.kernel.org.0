Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A259E66B072
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 11:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjAOKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 05:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjAOKyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 05:54:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C51F742
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 02:54:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t5so20504492wrq.1
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 02:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1SzhRqDdaruRzMKbe2ZTWqkPv+S3xA53bfB6fJhmOk=;
        b=KmXR+OUrtkIgRZwtpc/M4klmS1Dk4t1gvrQ326+uq8eroX+O5gETA1WtKpkeZtsUTF
         mLBnwyY7Mu8e8DBuSpxh0tldS70WQoCESHRiV07XNb8aUKbMlEtWUDi1bP6wnUQOydaD
         U3fgQcg0aSlyrphzscDzmpkFjubWWkjDHx8DEnapN+UUWIf4XH/KozKZX889jqB/iOVG
         mE5fAuvraJrqFQfW7avLyAkCLicvMRV01rWgX7YemUiGhqM6rDXmSw5uA7oI0PgsBLFf
         N6BiITy389kom52KqVzK3cjBBdAiawLlNIxglhtdJhwkFY8azILuisN6FGQ5vl5iTWMj
         tczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K1SzhRqDdaruRzMKbe2ZTWqkPv+S3xA53bfB6fJhmOk=;
        b=fFxPTeiJYPbzQB8mSJBO7R37tAnkQzof52y5VQVxTT+wWmPRNG1DAEWAol08gMHiY3
         5Qs9U1U/houhbOF67iS0EF+7lZbmjhZCn1wtG5s/5zD9YEEBW5KnIxI7TFoG7FE2YDb4
         IUClQvC3XHMM+V4UoZ5NCJvKtjCvqQT6liNQexPVU/xzPnMaqSykAueKND0pFwZdMjG5
         cjD6xunTYVXU1ScoTTWcyqmSkZ5EgwgSuzeWJzRSif2RHF5OR3nurN1dNU2sQ7ODJLWl
         ieX1S1ktjSs9FmoI1JntVcbQRqelj47zddktnon8i3ZYn4O0zt9oBlshRy98A1LPtRkG
         92/Q==
X-Gm-Message-State: AFqh2kqW+E4pl569B0KFS+PtVM2yCJ/NUkYR7z0PWeY4NCf1Uwaz7hIV
        Hihwe3lGzgG871rVvsihCsE=
X-Google-Smtp-Source: AMrXdXuPX3gWvuffilEE2tGzSbiUNewDZ+OfDfbRs5OUMo9E45pfhOxCzvvBvk9Uaoi0SUCklPLQVQ==
X-Received: by 2002:a5d:5108:0:b0:2bb:32b0:b0f9 with SMTP id s8-20020a5d5108000000b002bb32b0b0f9mr4648754wrt.61.1673780054405;
        Sun, 15 Jan 2023 02:54:14 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e61:8c00:154f:326e:8d45:8ce7? (dynamic-2a01-0c22-6e61-8c00-154f-326e-8d45-8ce7.c22.pool.telefonica.de. [2a01:c22:6e61:8c00:154f:326e:8d45:8ce7])
        by smtp.googlemail.com with ESMTPSA id r9-20020adff709000000b00291f1a5ced6sm2704664wrp.53.2023.01.15.02.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 02:54:13 -0800 (PST)
Message-ID: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
Date:   Sun, 15 Jan 2023 11:54:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: mdio: validate parameter addr in mdiobus_get_phy()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller may pass any value as addr, what may result in an out-of-bounds
access to array mdio_map. One existing case is stmmac_init_phy() that
may pass -1 as addr. Therefore validate addr before using it.

Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to a bus.")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 902e1c88e..132dd1f90 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -108,7 +108,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
-	struct mdio_device *mdiodev = bus->mdio_map[addr];
+	struct mdio_device *mdiodev;
+
+	if (addr < 0 || addr >= ARRAY_SIZE(bus->mdio_map))
+		return NULL;
+
+	mdiodev = bus->mdio_map[addr];
 
 	if (!mdiodev)
 		return NULL;
-- 
2.39.0

