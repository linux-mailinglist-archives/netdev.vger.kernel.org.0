Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA1C20693B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgFXA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgFXA4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 20:56:12 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A29C061573;
        Tue, 23 Jun 2020 17:56:12 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f18so380622qkh.1;
        Tue, 23 Jun 2020 17:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=B5VfZpM+X8knN3/rl+qFLVkBLatYrIcGjOd49U7irJo=;
        b=FB7Wp9k2DtXFJmIaWB3oECTv0wgsvU24hTRkD4h0tPWO/EJgiINucfpnNW9ronDECQ
         /mB9Oagm3HakllppJyaBINmmTIdGBEV54UhW+vGVaXKeGiegR0uXTEOFiiDdCGXcasyL
         vI6WD398RSOslpNrFEHeWr8LPjdkUuoYptEt3BSiH5B0ZS4OFWXZUoDzpLir4yE84jhK
         Bn2MBzmxWmnA6ZIzCScOtRSzArNGUTdFu2BZ4IZKkwqB2QZOgqa425DXdFrljROvcXit
         mq7V4WgmPozFZSBuQ6shyRvgEzJ71PDSCbQhiYEeO9bc4WPIHbcwbPkOu5sfwcoby4GI
         DySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=B5VfZpM+X8knN3/rl+qFLVkBLatYrIcGjOd49U7irJo=;
        b=NpD7JMC/6vLH/eoYtR7OXJk+Xb5CctuV2T1ETrGY12qVgz+FWjNrnolj+1IZ3oY6+F
         Q+ASAy/E8qAGfRrXjME8RyICr4EVotlRMHpm2ptr3HgdC5ugkyW6RhFenChL5pwQCAbA
         Qm4XcKfuORKaoCcfyVdZ5Zcu9WIml6sydUZlYePTEBS0cebLrGlyw5qSvGyIGkVI0Saj
         2EbcHQjoqpKhCuXaTuKCdke+3nDx1hE1gSNU+R2MFchx/Uoz3ErbTAuKf8yfFz3jUduz
         cBfOl8dg6VQrBQC7YbXWS+NBTXtkl+lw5O76045qIQLQC0nS64M52xIW9CoRpGwNm8a8
         ZQiw==
X-Gm-Message-State: AOAM532EZKDS6e8i0iifcEJzmlZln1n8zqHJBZ7EC0URsnL8RXbwvmYu
        ew4nfKgzC5MCPWf3NmsujN7QyBud8F3erA==
X-Google-Smtp-Source: ABdhPJznmQh0zjKtoWJeyATq6kU0U7s3P+5svTFZ+MIG/nWMp+29V+NExqsIW9laipwnG8iSiP7Gvw==
X-Received: by 2002:a05:620a:635:: with SMTP id 21mr22919093qkv.491.1592960171903;
        Tue, 23 Jun 2020 17:56:11 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:596e:7d49:a74:946e])
        by smtp.googlemail.com with ESMTPSA id u20sm1096681qtj.39.2020.06.23.17.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 17:56:11 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ethernet] do_reset: remove dev null check
Date:   Tue, 23 Jun 2020 20:55:45 -0400
Message-Id: <20200624005600.2221-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev cannot be NULL here since its already being accessed
before. Remove the redundant null check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 480ab7251515..3e3883ad88b0 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1473,7 +1473,7 @@ do_reset(struct net_device *dev, int full)
     unsigned int ioaddr = dev->base_addr;
     unsigned value;
 
-    pr_debug("%s: do_reset(%p,%d)\n", dev? dev->name:"eth?", dev, full);
+    pr_debug("%s: do_reset(%p,%d)\n", dev->name, dev, full);
 
     hardreset(dev);
     PutByte(XIRCREG_CR, SoftReset); /* set */
-- 
2.17.1

