Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB8407E50
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhILQDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhILQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:03:11 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0B1C061574;
        Sun, 12 Sep 2021 09:01:57 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id h133so10790859oib.7;
        Sun, 12 Sep 2021 09:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r6G6ldfRmdQpkB7KqHuOk4bEneXh0SM7mr0HLHhwSw8=;
        b=Bu0ce9k4resy7k5SZrD1WQhVmkSYhOoeHGzkZzv5Nc0B8bWGhxx/Aj4TjiehegdBaI
         LjN9bn+MJyB7uApcAcmFGLSTx5bDUpvklEmd8X2zd9/X7xA87vJr2zOo3Hy18p0Fx+zG
         ncXGtq1jgqh4lE2zR97Jo/+BtoriyOKylSjH6n726eJSSNyu18uZrhdqxsT5Y9mkfWRb
         5fKb1KLr5LG134I5wVxPxDxnWX+1+7H9M1Llt2mzRMrlwo3T+xzlbL1swSN0eY7g9FA+
         vNtAm8yzpANFF9m69/crzCeMa/716WoXl3nZNCzx7m/colUgdcATEKlSjQMIPHd4C/bp
         qrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=r6G6ldfRmdQpkB7KqHuOk4bEneXh0SM7mr0HLHhwSw8=;
        b=trzuX56VWWp2EyS9+a1SA/KjWxTUI3/sALIPUZPXgsqE67Rz3vy7n1mwKxJRR2CZHS
         6HVJpZX5B6BhXu+LRuHfvjDKdrW6StF8FaOV+qA2mHFiVOeXNgT/NupEawdGQ71+gFOS
         WOdhbV0mNQgrGEMrVyx8PFsUIzYusOxGhAjaHsS6dQ7UPDBIqkzLw8MY88v6oAiDyxJ8
         9wqIrPvXQ/qFc0Qiwvmat2C03k97+XVHcWSMnGGVZet/1kwrWsPNnK9V4u5vhjdsO4Ib
         6Bjh3yigrwK4qvl6IcR+H5jXlvAWd9Jt57JPTLMnKkFDNb03h5LMJ89SYffUibTpChBP
         pstw==
X-Gm-Message-State: AOAM5323lC07+Dv/s5GLvPZmbCMAf1nx0bKvb6gSGhqfbrb3dwitaCLF
        2w5zO04Z+9MLyHa/cdkjf2o=
X-Google-Smtp-Source: ABdhPJyKGqBaOj81pr0qET58gYEEBpqySIzGQ108MPp0ABoUxX6pME3N37AAiPoHuKPvfsSilR0TQw==
X-Received: by 2002:a54:4714:: with SMTP id k20mr4992666oik.103.1631462516902;
        Sun, 12 Sep 2021 09:01:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b11sm1195841ooi.0.2021.09.12.09.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:01:56 -0700 (PDT)
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
Subject: [PATCH 1/4] compiler.h: Introduce absolute_pointer macro
Date:   Sun, 12 Sep 2021 09:01:46 -0700
Message-Id: <20210912160149.2227137-2-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210912160149.2227137-1-linux@roeck-us.net>
References: <20210912160149.2227137-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

absolute_pointer() disassociates a pointer from its originating symbol
type and context. Use it to prevent compiler warnings/errors such as

drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
./arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 6 bytes from a region of size 0
		[-Werror=stringop-overread]

Such warnings may be reported by gcc 11.x for string and memory operations
on fixed addresses.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/compiler.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b67261a1e3e9..3d5af56337bd 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -188,6 +188,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 /* Make the optimizer believe the variable can be manipulated arbitrarily. */
 #define OPTIMIZER_HIDE_VAR(var)						\
-- 
2.33.0

