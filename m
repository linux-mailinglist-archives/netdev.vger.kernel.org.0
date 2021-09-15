Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7795940BE8B
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbhIODx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbhIODxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:53:52 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC7EC061574;
        Tue, 14 Sep 2021 20:52:34 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso1796904otp.1;
        Tue, 14 Sep 2021 20:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aSjFc8iMNGiFbg7CQVDwoW1UzNaNt3hOiMgdB3yaK6Q=;
        b=avFYgPC7uaqq4BQUqTkrdfHqJOlz0Pvdl1zxUeSN961ECarn+UhUThOo+h8V6dp6Xm
         QTFpftfBJLDOqb8FviFk9y4kf92iTH45DoWBmeS02OKmmxWKEYROpsgPMmgOYmB53rND
         JFo70jqrQAIVZe2+M4oqVVUQ36Co96fZdV1yG2iMIJIz7uydiQASPbq7QzORALwhcZ4y
         yzCPf1IxUFITfqyoQFzxeyvV7tCQk9ZFa5uBTpXlYJEAshRcy1UUZvs1ykHaXNGZG0pV
         X0IY7Oj9CLSa9Gyq/A7pDZkCLBM6euB8D4FE4LKOyWHvX/N1p52re2oFsGk7PuIc/mqQ
         dGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=aSjFc8iMNGiFbg7CQVDwoW1UzNaNt3hOiMgdB3yaK6Q=;
        b=VRM/VAxz1t9HwB2KXTMHETXf19831ZvcY95MTFmyg18xv8QeH5z6oP/qwT4nsqx7a3
         tXksWAaEfJB74AtCfCPlJRxCHkqqMYJvl7u10I+I/ia426KXXUCR8wB9q+tn0bwaLwML
         X1aURwNiy/dKzWBcbCfS3R0v92cU/OKUvVLX2jz0oAwfsW1SuWb0PBafq4TapJ4JcDJW
         I86svVd471M/pz0ivMH/Xe6BGrH4RjmRClayUU/GnfgSBNVAlMLCfL4/yuDuFsc5ZuUZ
         4D3kcAZU6yVVsAEiAvsZI50SpP28nAqac0icvmr366eke3+nepItj5zrvfWCbMhGOig6
         4hPw==
X-Gm-Message-State: AOAM530xcyGGYcmMJng2byN4OUOhp5gUqmZ0fKidtRXoeUkDwoCMorw4
        ie1kULApeQCA0EqX/fucerQ=
X-Google-Smtp-Source: ABdhPJw0v47/LJ893OiE+UK6aswRsKGBkLU0SMU74HXJBIT9m0EsHDxb2wdGsIGhNCTWQFkPKDN35Q==
X-Received: by 2002:a9d:6a4b:: with SMTP id h11mr17799987otn.5.1631677953527;
        Tue, 14 Sep 2021 20:52:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n19sm3018134otl.63.2021.09.14.20.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 20:52:33 -0700 (PDT)
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
Subject: [PATCH v2 1/4] compiler.h: Introduce absolute_pointer macro
Date:   Tue, 14 Sep 2021 20:52:24 -0700
Message-Id: <20210915035227.630204-2-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915035227.630204-1-linux@roeck-us.net>
References: <20210915035227.630204-1-linux@roeck-us.net>
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
v2: No change

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

