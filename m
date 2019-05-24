Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A029FBA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404098AbfEXUUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:20:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40290 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403762AbfEXUUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:20:22 -0400
Received: by mail-pl1-f195.google.com with SMTP id g69so4585737plb.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 13:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=jn/dM10djkegtPlL7Sb55El8ON07t/o4IMLGKNU09Wk=;
        b=dSdA4XKJphgdBP4R18tB+k2uO6rQX3ddrHhVVGYMhPrPsJila5ldAhulVOP1Zo8FFx
         ++lVxrQ8PY2p0LC1s8MK1Je8H+i4ORQW8U6YDs/+YeMa2RSzvTRH/9Vz79ecwvB7uL5e
         rOxHPuZCvzt0q7Y72IIDn518QXLevd7AkTlL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=jn/dM10djkegtPlL7Sb55El8ON07t/o4IMLGKNU09Wk=;
        b=DLOFi51L6gOsZbnGyVxFPN/p1CVHWDBPyd/SwbU098hm8hDIAwv6M/RMDUjZIZUcnw
         zrQPoKEHLVmWV0XKDw2zujaOta1gHvRJdDp5BDm0L7uFyoegtbrWNEv+srj0Y48RBDkA
         3HS5g8zlN2zxmphXvnu1umgMkc0W4g9byB/TFZqWc1kYdlkGJnw3KvPlDTFn4dl3F37A
         eJN+XBxW3BS8aJVxc9D+mSGZdeXUb83k/1Tc6Khz0ssQwZxU3ICa7solP1Of2/8bN+JJ
         1eE/IFIASOUepdXvM5MvkQXOhULxd/Kml98KDwkJviMy56gBnSmHQIazHIVumkJySXM9
         +ZUg==
X-Gm-Message-State: APjAAAW5MWy7+mDrVhXw0yTHpwgDUc3ZRKmK/Y86CPv2Jg0kyPmmur0a
        OLS8wpgM2+e3nHHlBkwJqgiHrQ==
X-Google-Smtp-Source: APXvYqwG6Voqp5ZNVFg2FoYgXTfsgicPu/GqE9QTLsxIXS/jYwIVRk8sK/mKSYh+fnVbkMgwe+fpaw==
X-Received: by 2002:a17:902:a81:: with SMTP id 1mr62618907plp.287.1558729222121;
        Fri, 24 May 2019 13:20:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9sm3530373pgs.28.2019.05.24.13.20.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 13:20:20 -0700 (PDT)
Date:   Fri, 24 May 2019 13:20:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()
Message-ID: <201905241318.229430E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building with Clang reports the redundant use of MODULE_DEVICE_TABLE():

drivers/net/ethernet/dec/tulip/de4x5.c:2110:1: error: redefinition of '__mod_eisa__de4x5_eisa_ids_device_table'
MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
^
./include/linux/module.h:229:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
extern typeof(name) __mod_##type##__##name##_device_table               \
                    ^
<scratch space>:90:1: note: expanded from here
__mod_eisa__de4x5_eisa_ids_device_table
^
drivers/net/ethernet/dec/tulip/de4x5.c:2100:1: note: previous definition is here
MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
^
./include/linux/module.h:229:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
extern typeof(name) __mod_##type##__##name##_device_table               \
                    ^
<scratch space>:85:1: note: expanded from here
__mod_eisa__de4x5_eisa_ids_device_table
^

This drops the one further from the table definition to match the common
use of MODULE_DEVICE_TABLE().

Fixes: 07563c711fbc ("EISA bus MODALIAS attributes support")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 66535d1653f6..f16853c3c851 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -2107,7 +2107,6 @@ static struct eisa_driver de4x5_eisa_driver = {
 		.remove  = de4x5_eisa_remove,
         }
 };
-MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
 #endif
 
 #ifdef CONFIG_PCI
-- 
2.17.1


-- 
Kees Cook
