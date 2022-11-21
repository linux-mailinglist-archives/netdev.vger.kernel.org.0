Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDBB631ACE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 08:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiKUH5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 02:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKUH5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 02:57:18 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C48BC04;
        Sun, 20 Nov 2022 23:57:17 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id j4so17670274lfk.0;
        Sun, 20 Nov 2022 23:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vs2l23NxmyfDzTeykhjw4XnqjbPvSyKWp0TKAT504Gs=;
        b=qZ5TqP+tU7NjssMr6vD8VJ70uIGXA+SK4QPz6fglRMTHclkDx/hz9TcruN6hw9XTMk
         JuDdr5vV0v8XrXshakEitOkB1K6RHeaTBIW8uLhJBYjJKS+w3nF8WjxgmpciZIrcK2mY
         EloizFriSWMWsMxGPDDXwtsqtUJWdhPJAWgzwkkUQ9sWpYS2zAFBLVLjPntiIfHmWkzP
         TMeuFaRBQn7q9M69nb6JF/hMrFzHs5mgtLQbScUVKQf9DgjmMHmbT6rFsPfS86MMMJhQ
         w64IGNmISHNJ9A9zzBV1v/z8YG7o1cnFIddNGfhMGdOZxxFWY/af1ti5gTHGynLLQtWe
         C2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vs2l23NxmyfDzTeykhjw4XnqjbPvSyKWp0TKAT504Gs=;
        b=0BMn/r6N/ZuFFi8Tg13IwmrUoJ7RvwYHgt3S8HYJ8rhgofXRmu340nNcy0Pysh9vBE
         +hCral1ClY1yzjiKTZHaynAy/1BV6i0FXvEJXwagdbsUvkoYLIen0RQxcXrzqPbu+MmS
         4OJ+SF9yoh+CmzADvwpTI0Jll/Z41UFYBmL49MSdDOh2g8Yhofk1O4GabouN7QIlFMFB
         bBBJaqhFv4gsIP5ee43Na/rHLRKW7jSDuGKUrv3TMpG9nmilAHn+RcX6XoUQ91RLWcDR
         nr2Q50Kv9r9qZv0XoOgxUf+XTzKX2CTlJPrceHuI14uVSruPyjhhuTmwLCZuLvXGcdah
         o0sA==
X-Gm-Message-State: ANoB5pmn2usfSCjVcJ5JaIZ001zeMyWk0wcAknID7Zg4m6RVlplGI89e
        YlL3dWhytPeyndGRYEadVh/gr2nLiFn9yIiQ9Idt3w==
X-Google-Smtp-Source: AA0mqf4m6QUsMqZQdvZ8Mj+V6wwfroTLEtPD1osHScALU5pHabMfzEKi82v2T1XBNFbV69Vy8AJz+Q==
X-Received: by 2002:a05:6512:280e:b0:4a2:5154:ead9 with SMTP id cf14-20020a056512280e00b004a25154ead9mr5836045lfb.32.1669017435541;
        Sun, 20 Nov 2022 23:57:15 -0800 (PST)
Received: from mkor.rasu.local ([212.22.67.162])
        by smtp.gmail.com with ESMTPSA id y18-20020a05651c107200b0027741daec09sm1292904ljm.107.2022.11.20.23.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 23:57:15 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Tom Rix <trix@redhat.com>,
        Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Mon, 21 Nov 2022 10:56:18 +0300
Message-Id: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of an arithmetic expression "n * id.data" is subject
to possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Added cast of first operand to u64
for avoiding overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2adc6edcaec0 ("ethtool: fix error handling in ethtool_phys_id")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6a7308de192d..cf87e53c2e74 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2007,7 +2007,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	} else {
 		/* Driver expects to be called at twice the frequency in rc */
 		int n = rc * 2, interval = HZ / n;
-		u64 count = n * id.data, i = 0;
+		u64 count = (u64)n * id.data, i = 0;
 
 		do {
 			rtnl_lock();
-- 
2.17.1

