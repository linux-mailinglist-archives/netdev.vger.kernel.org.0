Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6740449D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 06:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350475AbhIIEvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 00:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhIIEvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 00:51:06 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3941C061575;
        Wed,  8 Sep 2021 21:49:57 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso1001882otu.0;
        Wed, 08 Sep 2021 21:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSdDJmykDz9RTad7mrV36cJkuuQOB/FNuOcap03OkbQ=;
        b=WhMD+ExrGhJW1OHa5voKbQZpKXvfpplr6A2O+kLcKVPh9VhkAFPZdWQnSIfi1dO3Pc
         IEYcRwc00hz+0TfbtGfjxrZfKqzx+1NnJIYUEadNVbHmrOOILrYtRsAz3SCTEvgSeOsI
         Trk5CVsi3yC1NUko5efAQkZPA4ZwiOjviaiXSaeVdXM0RioH+wa/N7bSmgj8lJIyWbQ1
         Mhw0o310t5SnQYzzxGa5q0d4jyyvVe1uPWU6z2+zcwgxDIm8EFgQhNlR7aWDfcvjP/wX
         /RZoXYLsRjPzFR0HyVBnatWw13/bMe1SX0EGVJ61jkBaqkyDKRWF0MT/xm2E/0QBCq92
         r05A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=zSdDJmykDz9RTad7mrV36cJkuuQOB/FNuOcap03OkbQ=;
        b=e9nk4yAyKlrqM76zddkKYTnzg4ymmoPE5Leo9wQR1fzLTNSOASYdngSFFbEO5dm02+
         PVStDlV9QVek1KQFF2k37RfcxTKfAq0gUFovj2uJOXjfI86yR3F72W4R6IjT+B8hvF+Q
         1Em5qWZtFWr+VawfncmJFHHf2szxn5OqKDoaj+n4M8ysF3Me9TJIf2TiIolpBS0TjZz9
         8tM3aKgYz9j9U8/c/9+4gV3c3uft5HWfs5U/tfoVXDqmzGTzcDKHakgli+bK5R8vU36l
         ntPehnKdG1ezVqOZmM+6L0P1XvFdLMbNTqZD3aSVvfGCEE7HymJ1PM98AWE2MMmNcQdP
         Q3gQ==
X-Gm-Message-State: AOAM530gpjPzDGp0Mks456fYdE8oGMyA+WhMOJV3lukc20RChtVyLL/Z
        sQmabP5SmRrg3YaRy5est6U6T8yjGTI=
X-Google-Smtp-Source: ABdhPJwEm11UZMvKdp3qo1Wj2KPQIelfNBHGRzB8M6PTnjqGCcHcgmAXjNotYVd5/Wq9v0MYEEbwKA==
X-Received: by 2002:a05:6830:2781:: with SMTP id x1mr927266otu.334.1631162997005;
        Wed, 08 Sep 2021 21:49:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 97sm180427otv.26.2021.09.08.21.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 21:49:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH] net: ni65: Avoid typecast of pointer to u32
Date:   Wed,  8 Sep 2021 21:49:53 -0700
Message-Id: <20210909044953.1564070-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building alpha:allmodconfig results in the following error.

drivers/net/ethernet/amd/ni65.c: In function 'ni65_stop_start':
drivers/net/ethernet/amd/ni65.c:751:37: error:
	cast from pointer to integer of different size
		buffer[i] = (u32) isa_bus_to_virt(tmdp->u.buffer);

'buffer[]' is declared as unsigned long, so replace the typecast to u32
with a typecast to unsigned long to fix the problem.

Cc: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/amd/ni65.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index b5df7ad5a83f..032e8922b482 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -748,7 +748,7 @@ static void ni65_stop_start(struct net_device *dev,struct priv *p)
 #ifdef XMT_VIA_SKB
 			skb_save[i] = p->tmd_skb[i];
 #endif
-			buffer[i] = (u32) isa_bus_to_virt(tmdp->u.buffer);
+			buffer[i] = (unsigned long)isa_bus_to_virt(tmdp->u.buffer);
 			blen[i] = tmdp->blen;
 			tmdp->u.s.status = 0x0;
 		}
-- 
2.33.0

