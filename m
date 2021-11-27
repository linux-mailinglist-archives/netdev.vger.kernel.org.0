Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC0D45FFF0
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 16:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351543AbhK0PuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 10:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349130AbhK0PsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 10:48:03 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363A1C06173E;
        Sat, 27 Nov 2021 07:44:49 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id n66so24898201oia.9;
        Sat, 27 Nov 2021 07:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lg+3JUm4XUhcDPB3ZKGKQ7XkYrBjHN/owjr7MFkGNrw=;
        b=NP38bi5QKotdYrMQ6e/CVEqxqzH6tYJl5WI6voKU9lZm3mLSn9VT6DsuigHKtgY8Q8
         CgMdl8+ubN6pCC0H/8J01A9O9WcghebBmY3NQ/d17SpxJ9Q/BnAA0i7XFRvM2AKfpc8n
         bAUbd3dW2Qp2N9j/M9VxQxpg5OAJ7WqIBZ7SPnq8wFoZOPn0oHh3F+FFNgsaX5p/hBI5
         x5pn0xIfYiwTS/uSOtWeYvO0B1/GfArOHLS25wGy7XqlrJCubKW8DFmhdeZvH9emcOfD
         LqJvb1sYVJxy7TGS0Jgqfao648lRuI61lx0EVj4I7mqy1tDxP5VNR5nYoHwUzM4kcuaL
         Omrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lg+3JUm4XUhcDPB3ZKGKQ7XkYrBjHN/owjr7MFkGNrw=;
        b=xDVl6P4EEh/s3QA8abXBP5nOrLDU2ZgpwCArEkDA6q64QzHI9AOp3BJyI4kRDMLL7Z
         n7RMbSykOHIVaDwx3Nf49ZjN/YyngD6tB8gIu8t1PIpoP1KYuboxhOgSKu7v0ScqzkRi
         rd6nl/JYmB+RlVRdEPCGA8IljsKscU18XEO6ybB3UOjvRgT/7I2HqVV4xNf7prqVUiFI
         OvcIMmCZyylTtSBN4ZuxFsL6hoePjIYyYRhHecowb53vxYZjSIgsUyENkx2dcrwz5Eyb
         fshm5ZS+gzxq9lNz2jjY/nIdhwPgt9rzW1IWXwyFhVLiRgSHKcj9Dh697V7Yrwof2ne7
         4gkQ==
X-Gm-Message-State: AOAM531b2OTABIg7fBEuwcL856DaFI/tojZMkE11+Xo9U7yVm+PSJTs8
        av4y0ybq1MkY7aHY1eOcQBQ=
X-Google-Smtp-Source: ABdhPJz9W/Qtypp1NpAE0GFFdJmDpFd19Ozj+wqcwYVAu2ePOUp6XdhGN83Xim2BdB6tvCchlYcv1Q==
X-Received: by 2002:a05:6808:c7:: with SMTP id t7mr30492132oic.30.1638027888626;
        Sat, 27 Nov 2021 07:44:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16sm1894333oig.15.2021.11.27.07.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 07:44:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 1/3] arch: Add generic Kconfig option indicating page size smaller than 64k
Date:   Sat, 27 Nov 2021 07:44:40 -0800
Message-Id: <20211127154442.3676290-2-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211127154442.3676290-1-linux@roeck-us.net>
References: <20211127154442.3676290-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NTFS_RW and VMXNET3 require a page size smaller than 64kB. Add generic
Kconfig option for use outside architecture code to avoid architecture
specific Kconfig options in that code.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Added patch: declare new configuration flag in generic code

 arch/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 26b8ed11639d..d3c4ab249e9c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -991,6 +991,16 @@ config HAVE_ARCH_COMPAT_MMAP_BASES
 	  and vice-versa 32-bit applications to call 64-bit mmap().
 	  Required for applications doing different bitness syscalls.
 
+config PAGE_SIZE_LESS_THAN_64KB
+	def_bool y
+	depends on !ARM64_64K_PAGES
+	depends on !IA64_PAGE_SIZE_64KB
+	depends on !PAGE_SIZE_64KB
+	depends on !PARISC_PAGE_SIZE_64KB
+	depends on !PPC_64K_PAGES
+	depends on !PPC_256K_PAGES
+	depends on !PAGE_SIZE_256KB
+
 # This allows to use a set of generic functions to determine mmap base
 # address by giving priority to top-down scheme only if the process
 # is not in legacy mode (compat task, unlimited stack size or
-- 
2.33.0

