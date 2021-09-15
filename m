Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CBF40BE99
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhIODyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbhIODx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:53:58 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAD7C061766;
        Tue, 14 Sep 2021 20:52:40 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so1750928otq.7;
        Tue, 14 Sep 2021 20:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LJ4f8HmngmERpwG7jIZZPQRjRc0k1LbYpBN6nK8NBIc=;
        b=LEgWaiRibOmqug5ZHTfRHkoXMuKiJ6jf2lFXyKM5BFmlPas2u3osFBzaEvEqGYmluF
         bdeb5F9zoHSh9FIkwLNOi7uxo/di6b5B8XaK1+yojDAmnRwkJqTFPivpleBy+oTuPANb
         N5tlheoijyXkHvQgLHRIfn1dLRz5B7qIgEOOOOdHvhejLR/9HJIhCjK3PN1B20Q+y16j
         35mjX7Yk7E6L4CTd4qX4AU9HuPrM9G9Tdk3tOGtJMFqn2jOxUWvfdEjGTu0DV6aRJfI/
         F+N/PN778SdT/lrcjXqwLfQ8R09Ba76wHGBB06qmoCqeHxOl08ZnLwAb76zmHlQtPxpJ
         xXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LJ4f8HmngmERpwG7jIZZPQRjRc0k1LbYpBN6nK8NBIc=;
        b=MiyilRJuyzM7vtmMMQPmykxohvsCOZArjc+zoX/sQjLLuYBDJfZYKolQODAkUnylRL
         GXHjYGU57jqsWmH3O8csg8MsPnUvmvs5feMgyohDVyM6we/yAbIb52VJWBntYpR/7lk6
         rbUG5GRIDKTJOGdvy9AEGP0yL28fueGOwdgpIhgpXN6Y+/U3sqHuYGsEcH/YKqAnREG1
         etARF9Mhbk5NuYTDQtCB0FTWmT8zzXin6Oj1KH1lZF+8DsCoNJS4oLeUJgm8vjaXHrTw
         gYaTik7X3o/q1lSDr0CzO7ZDbIuAfU5xcm9+pbvks2ykvCzxNKuZA9JZwBCoF5tWwZsW
         zJjQ==
X-Gm-Message-State: AOAM531CBgBU9DnNFGOEy3Sj2QqQUm+SKTBdkiqlV//hdx5W+bHltRl4
        JSuxs2+we8fwV7/qgMLapZK2x/rc9tQ=
X-Google-Smtp-Source: ABdhPJxe9e8UK7Sg6myyOGKSATtdvIhjCl3M+NXOvgAnzPQvbCtjJL2f8NojZzRjCkXoju56AhAL7Q==
X-Received: by 2002:a9d:d35:: with SMTP id 50mr17575124oti.22.1631677959552;
        Tue, 14 Sep 2021 20:52:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y16sm3060719otq.1.2021.09.14.20.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 20:52:38 -0700 (PDT)
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
Subject: [PATCH v2 4/4] alpha: Use absolute_pointer to define COMMAND_LINE
Date:   Tue, 14 Sep 2021 20:52:27 -0700
Message-Id: <20210915035227.630204-5-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915035227.630204-1-linux@roeck-us.net>
References: <20210915035227.630204-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

alpha:allmodconfig fails to build with the following error
when using gcc 11.x.

arch/alpha/kernel/setup.c: In function 'setup_arch':
arch/alpha/kernel/setup.c:493:13: error:
	'strcmp' reading 1 or more bytes from a region of size 0

Avoid the problem by declaring COMMAND_LINE as absolute_pointer().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Declare COMMAND_LINE as absolute_pointer instead of using absolute_pointer
    on the define

 arch/alpha/include/asm/setup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/setup.h b/arch/alpha/include/asm/setup.h
index 58fe3f45a235..262aab99e391 100644
--- a/arch/alpha/include/asm/setup.h
+++ b/arch/alpha/include/asm/setup.h
@@ -36,7 +36,7 @@
  * place.
  */
 #define PARAM			ZERO_PGE
-#define COMMAND_LINE		((char *)(PARAM + 0x0000))
+#define COMMAND_LINE		((char *)(absolute_pointer(PARAM + 0x0000)))
 #define INITRD_START		(*(unsigned long *) (PARAM+0x100))
 #define INITRD_SIZE		(*(unsigned long *) (PARAM+0x108))
 
-- 
2.33.0

