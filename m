Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5767600D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjATWSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjATWSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:18:43 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A483645D
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:18:42 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s3so8368003edd.4
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuGjYCQBNPhc7HVIKJsmvXAfhGrae2zpvDjUPkYHPRg=;
        b=OpJB99pjdCqsFQk0exUg5V305xaRbBoSVHCSGiS2q0uPh69DSJp/jwxbPf8hyJs+hx
         XVyySzT9+U/ipmmolk7VYjHvycVOQvS7FjU37Rw8KqZZgC5OBDbZ2/U1BS9enAAQ2b95
         BkYYfMSxdRY+ZkftKAi87vIfyBMkCirqwaPA0Ye+ROH8KKpATG7KO23/d7v+ODb8pwZ7
         NXl7jsTfxjL95zoyolsjnFi6WdRDxDF2E24FSh2qW4d9ozUIKIlys33hc55zq3dbXJjt
         kW06EqOTwyejSwG3DIPrOYgiPb/3FsIKYUw6TpWY+IRA25wc/pJ9jawOWsYSCzghIzMi
         +Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CuGjYCQBNPhc7HVIKJsmvXAfhGrae2zpvDjUPkYHPRg=;
        b=GDEyU7p7vuEz72D5bQgua5JzUtZYwMHSzbeNfPVK3o5ZSTd4ypWw6mxcMNs9ka0I0s
         IfO1m8MhzCSjAGDlYEs0IeRUI85CkRnXOLbhj85emZ0o/wuAe++T2AUuaFsmCmqaq9Pl
         H0Qutza325NqHQEI91IasDdZM6SLr43Gl5j3a2S0E9E7dygwdP18zhBWyIu5z/UQoWVH
         xgsdDqsKx+TPjkthG+8X6Y3XzfiLWfRuWPXhC00GpEBWCCUvHJljnVmBQNeCFZU+VFMS
         mdAG4Wd8UGkTMTEaTaobLYY46cIRkzAes8Bw8f1hm80wXp+IjZLduqxk+4IMl08Qfcu4
         pInQ==
X-Gm-Message-State: AFqh2ko19jSgE+d+tQNwk8MhZ9gssOKzbK/RB2Wx2e6lqKrtksQKc/AU
        Eu2Q8NBm2EN00cKhD1DKVgpgvZLVZHo=
X-Google-Smtp-Source: AMrXdXvphhpeCoY/bwyHkwXZ1TtZMXihVsMMQWiMf1MoDlwTyMIhwTYpP4+F+856wvee8yYCgipTmA==
X-Received: by 2002:aa7:d9d1:0:b0:46c:b25a:6d7f with SMTP id v17-20020aa7d9d1000000b0046cb25a6d7fmr30230847eds.8.1674253121074;
        Fri, 20 Jan 2023 14:18:41 -0800 (PST)
Received: from ?IPV6:2a01:c23:bc41:e300:9132:97ef:2317:4564? (dynamic-2a01-0c23-bc41-e300-9132-97ef-2317-4564.c23.pool.telefonica.de. [2a01:c23:bc41:e300:9132:97ef:2317:4564])
        by smtp.googlemail.com with ESMTPSA id b2-20020a0564021f0200b0048c85c5ad30sm17731731edb.83.2023.01.20.14.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 14:18:40 -0800 (PST)
Message-ID: <daec3f08-6192-ba79-f74b-5beb436cab6c@gmail.com>
Date:   Fri, 20 Jan 2023 23:18:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: mdio: warn once if addr parameter is invalid in
 mdiobus_get_phy()
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

If mdiobus_get_phy() is called with an invalid addr parameter, then the
caller has a bug. Print a call trace to help identifying the caller.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 16e021b47..ed66a1986 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -108,9 +108,10 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
+	bool addr_valid = addr >= 0 && addr < ARRAY_SIZE(bus->mdio_map);
 	struct mdio_device *mdiodev;
 
-	if (addr < 0 || addr >= ARRAY_SIZE(bus->mdio_map))
+	if (WARN_ONCE(!addr_valid, "addr %d out of range\n", addr))
 		return NULL;
 
 	mdiodev = bus->mdio_map[addr];
-- 
2.39.0

