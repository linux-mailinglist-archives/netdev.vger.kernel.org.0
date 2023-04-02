Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B81A6D36AC
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDBJs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDBJsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:45 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A1A5FD0
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:37 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so16377879wms.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428916;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtMfU//EjnJXIFHUDZIKeAuLL38xF7hEOoaS7TmL8WE=;
        b=i7H5pOkK1gU389XfjyQBiYjEK+//qaGoMmblu+DDslhSt41GTUoAqg1A3mSW7rOEFI
         5DtrEFk2HACplNAqgxUdVZ04Cq3EI0evGXnXWicvhrOl0X9EHuEzxV5rMH+cc8Zd6eHF
         p/5FD4PCfVAo1MwhakMJiJlKN6rwt8/NCMWDe1Ryk/gF6O5qt5n1CiTR6DG4kLUaVQvy
         c50lAtgNxbrCL340LS8KaFGxrrb++eb6wxpxCxUbl1vFhbGo2ikSg7EBD6gp8ZrJDjsw
         +vXCHIduCuTmHozzmVUebgjVZ7IvBufdtPC97rF/3U8dVyDhxrsr64mOu7/IqtC9sv36
         u3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428916;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtMfU//EjnJXIFHUDZIKeAuLL38xF7hEOoaS7TmL8WE=;
        b=moniilb4q+ZEhgUAIYHBydhCqTffztBUrStXcbNK7AxfnnaFp5GyODEsgvM4L3hc50
         zaQVCffI2zryi1O5vMQMjDrRHfDwLBEuG3POPcZyXX6ZA69kfWurs00dyLdYZYuhNVhP
         07Rs4NSdDxOO029+CjJWS0LBj9T4TFdo1X/wz4s8UYPGYRW2zxZrLDOC+7AsWcQ2Z7gO
         AmcL84iq8QEHJS+nEIuhq66QL8N1AcsgpyZj1ayj/pij7t7ZcUfddchXbhkFmZrc1/Uc
         iWYKWRqxPcoK2/SqDUq8I0KYaaVezbIXsl9REjF+XJ1N6q6XDAb5yJadPT8KqSqt6bPI
         Ok3Q==
X-Gm-Message-State: AO0yUKWuxdXpzsy/YO3Pbnm+F4nP6JM1NfWWi+JoqAsb0M1IMmkl6bbg
        OC3zt4saO3TvjMi8kHbqrkI=
X-Google-Smtp-Source: AK7set8M8MWH6c6GFp74+7s0Dz27ozCvFJ3y67uCZWa0rD6OCzAMtXJL4rQlFK4TQ7ECIx4koDY4zg==
X-Received: by 2002:a1c:f619:0:b0:3ed:514d:e07f with SMTP id w25-20020a1cf619000000b003ed514de07fmr25464147wmc.3.1680428915751;
        Sun, 02 Apr 2023 02:48:35 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id q3-20020a05600c46c300b003ebf73acf9asm24968293wmo.3.2023.04.02.02.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:35 -0700 (PDT)
Message-ID: <48dc7962-f9e1-4489-d73e-28716f586b56@gmail.com>
Date:   Sun, 2 Apr 2023 11:48:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 7/7] net: phy: smsc: enable edpd tunable support
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
In-Reply-To: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable EDPD PHY tunable support for all drivers using
lan87xx_read_status.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index cca5bf46f..a85763c02 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -476,6 +476,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -520,6 +523,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -546,6 +552,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -576,6 +585,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.40.0


