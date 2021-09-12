Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F583407E5E
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhILQDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhILQDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:03:21 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515F3C0613D8;
        Sun, 12 Sep 2021 09:02:03 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id bd1so10763730oib.5;
        Sun, 12 Sep 2021 09:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k7vOSXJvuBFedGqEmsc9y4fLwgAcNpSGF+uyNF/6Rc4=;
        b=GVTomCds0oHSZwZ+CTeT02sfHZ+uX8vQBFkmUFHVSBVMyoMK1poVF7DH8H5r1UYFRK
         aPCLOAbhNTN0Pf73m3EnkBCGrCx8Sz8mfm4fpr03P50xQCkmjPnx6H1fMBfR8TXi2yql
         7EpXjBZQjVBhuRLjaeIAzrOfigBrZLiN1cMRentTn0+/xh9NknH0Wl8VZJEOKW2wEAbz
         cLq7gUjvQS/t3euFq+3g8iDOzvLSyu8Sijmu75+aIQRni0rJJTrPiWLF1zYZ7e0lMEjv
         TCPoA1bHoUyY94AnRaVage1SFWbZ2fb2dbI3Hl/OEyUsEJ3gyUrP6RZBCknb7+wWO1mY
         VqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=k7vOSXJvuBFedGqEmsc9y4fLwgAcNpSGF+uyNF/6Rc4=;
        b=WS2tJITiLSR5jdYu9qbSAHAIcbycQfiWLVmlBoryw9sa3DTwlencz1lfn3ySQawgP+
         dyYAKCJ0kvmvZ6fTJ29EKQ08kfd8vMGO5DmfRKhB97jtSLSWzI3MkMJTFJPZlrnzU7wK
         gUKLCrxDuLJ10A/ThiyIKHCOMonl4vBVItq+YpP9BtJ//ydHymWnSzRoJy+iXnTWAbpD
         rSikyl7BBLUjDgM9HgUVHOXp0Sv3o7BKFVzXXotK+0Nd0eA03qlByUu0e5Ym2iaObXrz
         kjbba8gUwkEGnJrPLMjFooyP9iRWs0j/P253O6t5f1hpV1SoBH0RVuBSyBWi5MB5Gt89
         spWg==
X-Gm-Message-State: AOAM531ciwSOECCpjocAT1rXbghXqrWa9loaiEjx9BVOD67Z9X7Gp7jX
        NQXtWsR35mhzRPZiIPcW37Q=
X-Google-Smtp-Source: ABdhPJxb1VPXMwcXDAB2MTnc8E2tBnOL9N7CU6cFnuCzUVgrOk+LibtThqzlA+vv5VXasU/DM9aWpA==
X-Received: by 2002:a05:6808:2cd:: with SMTP id a13mr5006585oid.3.1631462522711;
        Sun, 12 Sep 2021 09:02:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z1sm1202256ooj.25.2021.09.12.09.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:02:02 -0700 (PDT)
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
Subject: [PATCH 4/4] alpha: Use absolute_pointer for strcmp on fixed memory location
Date:   Sun, 12 Sep 2021 09:01:49 -0700
Message-Id: <20210912160149.2227137-5-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210912160149.2227137-1-linux@roeck-us.net>
References: <20210912160149.2227137-1-linux@roeck-us.net>
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

Avoid the problem by using absolute_pointer() when providing a memory
address to strcmp().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/alpha/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index b4fbbba30aa2..aab477a76c30 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -490,7 +490,7 @@ setup_arch(char **cmdline_p)
 	/* Hack for Jensen... since we're restricted to 8 or 16 chars for
 	   boot flags depending on the boot mode, we need some shorthand.
 	   This should do for installation.  */
-	if (strcmp(COMMAND_LINE, "INSTALL") == 0) {
+	if (strcmp(absolute_pointer(COMMAND_LINE), "INSTALL") == 0) {
 		strlcpy(command_line, "root=/dev/fd0 load_ramdisk=1", sizeof command_line);
 	} else {
 		strlcpy(command_line, COMMAND_LINE, sizeof command_line);
-- 
2.33.0

