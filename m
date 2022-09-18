Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547DE5BC0A2
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiIRX2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiIRX06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:58 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022B218361;
        Sun, 18 Sep 2022 16:26:46 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id j8so9838469qvt.13;
        Sun, 18 Sep 2022 16:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+WHyUg/3fPOf0tvuBkaVWxhr5RVI5uDGWpfIxZnn/5A=;
        b=D9OR9hB1I3e8PywGWEUW5fHz/j9AVs9Y8bD1XA/q4K+iSf0bY/l06DAZWQAf/eJFkY
         7AtdNTe+6LOTMyySsWjHy/Q3uZPTv8Sqc8DCZ5IrPjryYIEHeeUFH4JUUQxAIioXSvlQ
         J6OAN343q4xczn7xIwgg0FxtADu6twiWwFxBIst47ogbFPIYU+3NhTkcoRhdGV/i9uMl
         2qB3kPw/LX8uWg65FchiCCSNACFtJWu+G40fiENxDTh/lI3RHbf+uTOYzRy8yvkLuLXY
         ZTHCuDDq/mIO7OrAhLMfliHBZSJkN89b+6H5H19Yl30rLC7HgOpfqkYqBM9unRdr3Wby
         v7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+WHyUg/3fPOf0tvuBkaVWxhr5RVI5uDGWpfIxZnn/5A=;
        b=ONqWpcX0strTVML7VtzHhjtWI+HA/tU9f7+wcYiiOB3w7SDFi1BuoQc7/rbfVIIA4A
         GCkl8ZFm+R+hLUI1rn6yWs5lk36+7cXzw1SP4Wyt1AcNHW/xCRHmEqEfOnwfVWeYVN4y
         lJ7tnXuFYW1MXxX8FgoVyDEoZe/+QTe8QjPWZwLG3wBClf18td9cX5mBM4gcnKVXJKPA
         klDxFDdewnoDnkkkrRrW8WqPfSzOClG649VStgzTpmfAhNVhe7R7Emd2EZrFNoLLW+zO
         mrEh6ke6siYP2LRjkkf6/VlQBIMBwcJfHxYHZBsfroNhLdx91f7W7qzcct885jRtL7y/
         lpKA==
X-Gm-Message-State: ACrzQf1eh8ed1Z4oqXBWhMus0e/ECZqH2clPWpbieRwyPMhiP7VPd3Pl
        trTrhTzV1NhNf1cINAMu8ZY=
X-Google-Smtp-Source: AMsMyM4MAqGyqAze9Cw5ZFpjl9sDST4Ovz9Y2TGOpIQy/y64eH9GpikgNZPe74ivPsu3/+5gN2Bfyg==
X-Received: by 2002:ad4:5b8b:0:b0:4ad:2b21:3390 with SMTP id 11-20020ad45b8b000000b004ad2b213390mr5450789qvp.20.1663543605554;
        Sun, 18 Sep 2022 16:26:45 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id de42-20020a05620a372a00b006b945519488sm11637556qkb.88.2022.09.18.16.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:45 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 13/13] sunhme: Add myself as a maintainer
Date:   Sun, 18 Sep 2022 19:26:26 -0400
Message-Id: <20220918232626.1601885-14-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have the hardware so at the very least I can test things.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 74036b51911d..381e1457f601 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19491,6 +19491,11 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
+SUN HAPPY MEAL ETHERNET DRIVER
+M:	Sean Anderson <seanga2@gmail.com>
+S:	Maintained
+F:	drivers/net/ethernet/sun/sunhme.*
+
 SUNPLUS ETHERNET DRIVER
 M:	Wells Lu <wellslutw@gmail.com>
 L:	netdev@vger.kernel.org
-- 
2.37.1

