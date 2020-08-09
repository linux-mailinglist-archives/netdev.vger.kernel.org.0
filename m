Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E54F23FC25
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 04:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgHICRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 22:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgHICRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 22:17:36 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF5C061756;
        Sat,  8 Aug 2020 19:17:35 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e5so4285546qth.5;
        Sat, 08 Aug 2020 19:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=N9Cxjqana//WEni2QSUMEdjKG1ybH4mJ0UhJQDd8N9Q=;
        b=iOEmf5SBqdR8ZYXhHSpNYLbXvvfwXzyuBDRb/XP1bG4O0ogQEdUasEIWwtDEga5cyW
         4OyRAR9GjI7yw1gaye/RYMPYU+6mAgRcZh2ZnUN/KtqSeXqzG4MRiWILSxG3HRdpWk3V
         IxWHU7VqpH4ChJW6A2ikxnc8hfRFxC6ZhYSyuykKxG2kExTebUx0uzxAtysgfZaHtPjz
         8ErWZ9yOr4havrqHcX8VekC3mIRfLWzj7mxL1ouM2ZpyxA7DqClB4v+863Jta6/8A09n
         jfDfliklTjNT3Wn98WERRsaYg1JaBKHb7MD5RcCFDIh4PLUjPwaINQ+d6D7sTej/VZK0
         enow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=N9Cxjqana//WEni2QSUMEdjKG1ybH4mJ0UhJQDd8N9Q=;
        b=ZwBq9S2EPmMG5fNm15VFgKA6p+s9EOpoSU1FCXM0E8DQ4EVM+P1y+R4aCPj4I45xxV
         +cWqsSLjuv88hqnrmVTOhzSEqelTi6cuOpgXydbHAQ0IHphIXXtUZB5aMzqtsWyz9spy
         wLcgaHIIAPEOVQh7eaw1HLKeMyPZ3CbGgn9prEwCrs6du6uApKd37vVMlG0ZvqaEX6Z+
         fldBbMTKZEAANt+wunTdcOEJQgPSiCU2gY6N6I/3/LIWtH/54CXAc1Mp3lRRcFn1wq5y
         DYwX9kqUJqzKvK63eUp+kHQPIzqed9VLxwi/2v18ApQNwfeSuCAYGlOjpjo4xwcgXw9t
         1MFw==
X-Gm-Message-State: AOAM531tXAfyS7lVmc+kVPejk8EMm90ahbxqhV0/QYcG4qKoNsEKugjb
        gFr4I9fI/GmgjUsZZtb0htM=
X-Google-Smtp-Source: ABdhPJwBFV/x0aNfatq9WLPnP9IdRT3hGwSB2vUkre4eawfo6J75qig8NMyDmmyWXCMBkNNzE2BfKA==
X-Received: by 2002:ac8:5189:: with SMTP id c9mr20625837qtn.202.1596939455059;
        Sat, 08 Aug 2020 19:17:35 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:c96d:c91a:c6a9:dcf8])
        by smtp.googlemail.com with ESMTPSA id n6sm10466456qkh.74.2020.08.08.19.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 19:17:34 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:FAILOVER MODULE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net/failover: remove redundant fops null check
Date:   Sat,  8 Aug 2020 22:17:28 -0400
Message-Id: <20200809021728.17431-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant fops null check
Fixes: 30c8bd5aa8b2c ("net: Introduce generic failover module")

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/core/failover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/failover.c b/net/core/failover.c
index b5cd3c727285..63213347f51c 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -82,7 +82,7 @@ static int failover_slave_register(struct net_device *slave_dev)
 
 	slave_dev->priv_flags |= (IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
 
-	if (fops && fops->slave_register &&
+	if (fops->slave_register &&
 	    !fops->slave_register(slave_dev, failover_dev))
 		return NOTIFY_OK;
 
-- 
2.17.1

