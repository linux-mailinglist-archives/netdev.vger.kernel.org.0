Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C57B407E54
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbhILQDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbhILQDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:03:13 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70903C06175F;
        Sun, 12 Sep 2021 09:01:59 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso9867983ots.5;
        Sun, 12 Sep 2021 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tyfgbpEWB0om8tzf9mpCL7ZcoNm2ky582Pji67hHRFQ=;
        b=FipBo31bo4Y9wn2cwKQRxkhXZxLWCn+R45DcIskkVp75c1TgMGyjogwJwyZOXFC4tv
         stoxC1TbwWGQ+SVkngtXViHocHoaVTtD2BBYiJPvDjNTybowvZ5OzMJ0BvcZBw1tSFVV
         WvuF8X0N5/D8+gT4APANqLNRhq+59UrNncv3vpGQBPma8SCO7gYwVE6iGXjpUZDSx5LK
         Mrre1qNJSrKUOp7Bz8xYEI5VjP5yPoQFMHyY65D1co3w7stKAEc0MHHesMO+X31r8VOS
         nbGd99VOHdmPbZHJyPppMEZ1X8zmprSmHfblrUwwAkfgGe5JEZF/CJPrdQSQaVVyJAYv
         OeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=tyfgbpEWB0om8tzf9mpCL7ZcoNm2ky582Pji67hHRFQ=;
        b=kuVVKphCs7lCFENKBeX639R8znLBqOyB4vueN6wQvvDRbHtmLZMQo3yjcLwzQ5S9h7
         PPWhTYDltwBsNdfjUGyc8ONSv9YXRSwEBkYMvfqDLn0vjIvnN/Bb0wYFzHUtoiEEb2ed
         6drADNG0LVEMUVajecAuvbjhITcu6tsD2mOXwq2NNVhC62U1ck0zKp7YvtPHRDC7tnMg
         fnbx9UGborB4PTnpZTbajG9nOT+/i58PKB1AKhL6HNwBotmh72zLGerCYGeExwANYFIV
         T7Qpx6wdr/MnqVsUzewvOlN+Y8MYgABaqOMlCYZOA/TMNh04CWvuh68crMsGgPwXnnuT
         p8Og==
X-Gm-Message-State: AOAM533sXR8jF19Tyslzm7I+RpovkAlOCUT+AGWHTz/zYET6GbxR1TIk
        KQZAio+3hiuJcEmtYLPtBBE=
X-Google-Smtp-Source: ABdhPJxxG3bEJyuh5jpoScB+mVZoZXu5mY1xmvYgshRPfbEKeGsAX+9/2UT/b42Hz89aP+JjI1OTIA==
X-Received: by 2002:a9d:410:: with SMTP id 16mr6428022otc.83.1631462518827;
        Sun, 12 Sep 2021 09:01:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t1sm1208957otp.9.2021.09.12.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:01:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-alpha@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-sparse@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/4] net: i825xx: Use absolute_pointer for memcpy on fixed memory location
Date:   Sun, 12 Sep 2021 09:01:47 -0700
Message-Id: <20210912160149.2227137-3-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210912160149.2227137-1-linux@roeck-us.net>
References: <20210912160149.2227137-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc 11.x reports the following compiler warning/error.

drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
    ./arch/m68k/include/asm/string.h:72:25: error:
            '__builtin_memcpy' reading 6 bytes from a region of size 0
                    [-Werror=stringop-overread]

Use absolute_address() to work around the problem.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/i825xx/82596.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index b8a40146b895..b482f6f633bd 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1144,7 +1144,7 @@ static struct net_device * __init i82596_probe(void)
 			err = -ENODEV;
 			goto out;
 		}
-		memcpy(eth_addr, (void *) 0xfffc1f2c, ETH_ALEN);	/* YUCK! Get addr from NOVRAM */
+		memcpy(eth_addr, absolute_pointer(0xfffc1f2c), ETH_ALEN); /* YUCK! Get addr from NOVRAM */
 		dev->base_addr = MVME_I596_BASE;
 		dev->irq = (unsigned) MVME16x_IRQ_I596;
 		goto found;
-- 
2.33.0

