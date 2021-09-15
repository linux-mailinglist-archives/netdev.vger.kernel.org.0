Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE93540BE91
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhIODx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbhIODxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:53:54 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDC0C061766;
        Tue, 14 Sep 2021 20:52:36 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso436344ooq.8;
        Tue, 14 Sep 2021 20:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YbkO6eX3svmIKG5IOf3KbQnfzJzo05Zk/s9XsuhsdgM=;
        b=jkECE0ZRStw6Q+C2y91NLFDDGbMCo24+eUfO5W8Zf2UooRooEgR6+ccD826ws8BQOT
         egJP6pkgfrD8D/D6WBg4ybOgNN97BuF+ALm8IV7syJCNG23dtJrUQudCvZ2eBpar56cd
         eXOODyByiVqpceuqOrBtJivz6GOuicpHqM1jNQItDPt0BTo3c1gp+4LrFetDoRfKSbLp
         AZ5bmv7IwRLgfFKMSGwzJY4qpA3DTZ9o9t2d5Rm6WZI9XngbNVIHyBNwpuBO+ZWFWj9N
         1ZAu1KhTyBj+FCIZTl/sex87MzTpSA33dMlts9CowFJlanAOw1xGk1UY0jtyPWRXC59T
         rqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=YbkO6eX3svmIKG5IOf3KbQnfzJzo05Zk/s9XsuhsdgM=;
        b=ds9yFT0Mx5b6BX+99r36QhjxmNWxzdgKfcJCp8lYZuQMWfJkzvq8Bz0Nbce9D8r6Aj
         JoCqa1Bl1YDrqB+gTKIJK6vt5nZGSu1UUAfn5e8iinK5lK6wa0uQXXV8P+k9B52B8KBd
         XN1+oSKbAJrdW1YREvpzBFGsBikQokeSAY9TIjSM4MRpg00s1ixH4hyf6EksDksfRjWz
         /dyXzCB9VURzNIGfrpW+1+/Hov8qY30mGLtijtyTDYPIr5KWpR10y2++rpeRJMZvD3Mu
         kxW7d4SBHF8PiXRFTjqtOx4xaFEGvYXzt2Wgqw7ZkodI/wyGoiV1ovHOnOLBf6t31MU0
         2wsw==
X-Gm-Message-State: AOAM533+icDGokGalj494KTIjfFhhbkOSGxYPRxDGkK3zwiLxtiBmZGt
        DZ2aI0FAZYgKG2/WjMYitVg=
X-Google-Smtp-Source: ABdhPJz2YaJRzesVNAbWeshh6RZ6+fKrBG3TZLysCiV5rwm0LZkxT7peixep+VGV0LcI9nsEKF8ejQ==
X-Received: by 2002:a4a:e60e:: with SMTP id f14mr16906786oot.84.1631677955492;
        Tue, 14 Sep 2021 20:52:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12sm3107794oor.23.2021.09.14.20.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 20:52:34 -0700 (PDT)
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
Subject: [PATCH v2 2/4] net: i825xx: Use absolute_pointer for memcpy from fixed memory location
Date:   Tue, 14 Sep 2021 20:52:25 -0700
Message-Id: <20210915035227.630204-3-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915035227.630204-1-linux@roeck-us.net>
References: <20210915035227.630204-1-linux@roeck-us.net>
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

Use absolute_pointer() to work around the problem.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: No change

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

