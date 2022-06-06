Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9153E6D3
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiFFNqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiFFNqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:46:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B315E2A25F3
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:46:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id fd25so18912894edb.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnPeSuEupDbmGQ7GCHy4it+pAl5TcIPr5v39wk3VDWY=;
        b=STlEAzxRwWbhrR37+QIghU6zligTbGACIocWguIbaXysVb7dqmW3Z161foAucHd9Fq
         WNIf8NieYkCmdcGQTS1p1cXcFVxm1KlqCanD4uHpbsnV0AbX8PW+G0J8vmPYJSKHPA6m
         z+Ou3/2aC6js2qQUDtJnp31U0ToUuhybLK5Qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnPeSuEupDbmGQ7GCHy4it+pAl5TcIPr5v39wk3VDWY=;
        b=e8hzCHKOwqj6DDeEfOzE9bWtfecjehZzWnIevNfih/Ik/mhlZkuJrghTcDbdf+IQYL
         SAjEL2u7+JDt7E05zA/nZLnQFk/ijYZOL/+i6NgqAGOrq4o2VR48ERi8KWj0D685jhiO
         h6iywRtR8SABYIhmLM6C0Zb2Dh7hp7Nd9KyLqoq0+bOAnDrsgYId4+FlUz770uCCw5d8
         GD4O+rsws4fKOuZ/p1MRO8c3AH5wmsIW4D6e60RAOAMjdk5RIANwyBjkLVv3+VGxhQMW
         sBOQsWTQsvQWmIVk+Y24W3/NKCYQgZCk8gTdSP7vr5lM0MBe9RkmuUoiNIGMmiEGKHMK
         X0/w==
X-Gm-Message-State: AOAM53129P7VTwhcT099S5kJ3kMeHOJc3ZN8BN6T9tnPkHIF7x/kU/4d
        biyk11oG84gwI1xCUqveeGZINw==
X-Google-Smtp-Source: ABdhPJzUbpoI88p20ePtUpE/Efbx+rxctOBRmEkVhIGUkdBZ5Jl3JJOTojP18Va0VLSDZe/khPlZFw==
X-Received: by 2002:a05:6402:1941:b0:413:2822:9c8 with SMTP id f1-20020a056402194100b00413282209c8mr27443321edz.13.1654523176298;
        Mon, 06 Jun 2022 06:46:16 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id a26-20020a1709062b1a00b006f3ef214db4sm5496538ejg.26.2022.06.06.06.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:46:15 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: dsa: realtek: rtl8365mb: correct the max number of ports
Date:   Mon,  6 Jun 2022 15:45:51 +0200
Message-Id: <20220606134553.2919693-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220606134553.2919693-1-alvin@pqrs.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The maximum number of ports is actually 11, according to two
observations:

1. The highest port ID used in the vendor driver is 10. Since port IDs
   are indexed from 0, and since DSA follows the same numbering system,
   this means up to 11 ports are to be presumed.

2. The registers with port mask fields always amount to a maximum port
   mask of 0x7FF, corresponding to a maximum 11 ports.

In view of this, I also deleted the comment.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index c64219271a2b..392047558656 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -115,8 +115,7 @@
 #define RTL8365MB_PHYADDRMAX		7
 #define RTL8365MB_NUM_PHYREGS		32
 #define RTL8365MB_PHYREGMAX		(RTL8365MB_NUM_PHYREGS - 1)
-/* RTL8370MB and RTL8310SR, possibly suportable by this driver, have 10 ports */
-#define RTL8365MB_MAX_NUM_PORTS		10
+#define RTL8365MB_MAX_NUM_PORTS		11
 #define RTL8365MB_LEARN_LIMIT_MAX	2112
 
 /* valid for all 6-port or less variants */
-- 
2.36.0

