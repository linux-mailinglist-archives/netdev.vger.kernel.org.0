Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FD65B2E65
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiIIGAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiIIGAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:00:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E27C7AC20
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:00:33 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b16so960921edd.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 23:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=pue1FTBtBZs7iZRT1k2IpN1VjMwKbLWktKzSTHYgTik=;
        b=UyhlYUVuaI9qLmooqed8mqswsWt61S5fD6bwO1nqtysPul+VJdwBOjIeOck+EvTiYp
         wtyK+RMfiD2Y3XuljouZZPM31OT4Qa649l4RXQG5ss7UKv4TdtulzK7SAG/sxbmMzuz7
         ULL6dvTgpxphOYjswEjlCX6iAyyYko2tfXnMA9gDh6my82g7bXUS7U2R0XgEgaJtIucX
         i/re/n0Sw7+1N4vlyWgu6GW5ulXhhwXS+7sfac1FHuGBJ7OnSsE7IdbM52VbPAUZbFz5
         u9j96ZCCoRY5ynQXGREEDkYFkjUmi/Vi3tzB+DS5cJr8DyNIAN5OTqzruAMFVJr9eDkr
         OIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=pue1FTBtBZs7iZRT1k2IpN1VjMwKbLWktKzSTHYgTik=;
        b=eIqP9G4E4DiFrFiREtKJShAoEdyLhIcsELQyxwayzpOtlRvcOLm32sQocXmbPVRw7v
         PM+h45SyDowzbYm1wwSSpPatHGNgLs7dxz7BfqCXn2MoHbMtwTacdsLwYr6oPE42NCo9
         2pqkGmP1hCxKl7wx8oGm0CuvkclRfOwR18xHjTBUIARF4rbEsWLGGvckEtr7cRgM4mS3
         wqGYLEcs3M810lfT04dMB03m376Co8MWrjaZcLWUuQHepcIwBGTv1FvuqoSQ1rTzCiSe
         S2MeHcfLG3lC+SX3w39FDW3epx8VaYtPvnxTI2Gq4TmWXgDIO4fmJP/G5JVxVm4grpHx
         FHOg==
X-Gm-Message-State: ACgBeo37BVzxlu6qSBeYqkD6ah3mc6HnpQBJxg17oNXBznN4g2+HMfM0
        l3pEagfsJ6KVrnDXEjISRjI=
X-Google-Smtp-Source: AA6agR6vgQCkp9xeeUCuz2v8M7zq5iCctKrzLALAIPTY1V7bPaMIOoOqW1JAAQco2c0Iv1TjxmuZrQ==
X-Received: by 2002:a05:6402:5192:b0:43d:cc0d:6ea4 with SMTP id q18-20020a056402519200b0043dcc0d6ea4mr9986852edd.111.1662703232047;
        Thu, 08 Sep 2022 23:00:32 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7333:db00:29a8:b45d:4396:2330? (dynamic-2a01-0c22-7333-db00-29a8-b45d-4396-2330.c22.pool.telefonica.de. [2a01:c22:7333:db00:29a8:b45d:4396:2330])
        by smtp.googlemail.com with ESMTPSA id f14-20020a17090631ce00b006fe0abb00f0sm460272ejf.209.2022.09.08.23.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 23:00:31 -0700 (PDT)
Message-ID: <ac622d4a-ae0a-3817-710f-849db4015c78@gmail.com>
Date:   Fri, 9 Sep 2022 08:00:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: disable detection of chip version 36
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found no evidence that this chip version ever made it to the mass
market. Therefore disable detection. Like in similar cases before:
If nobody complains, we'll remove support for this chip version after
few months.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1d571af4d..8e1dae4de 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1998,7 +1998,10 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168F family. */
 		{ 0x7c8, 0x488,	RTL_GIGA_MAC_VER_38 },
-		{ 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
+		/* It seems this chip version never made it to
+		 * the wild. Let's disable detection.
+		 * { 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
+		 */
 		{ 0x7cf, 0x480,	RTL_GIGA_MAC_VER_35 },
 
 		/* 8168E family. */
-- 
2.37.3

