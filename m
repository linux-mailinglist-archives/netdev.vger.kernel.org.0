Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEE14A32A4
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353437AbiA2XkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiA2XkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:05 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D66C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:05 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t32so8638947pgm.7
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kAXoMksJwSvCPGdPeM29rSArb1Q2ozVaNB51iTgnTDA=;
        b=r884UGDy9y8Xn5nmGJVhyXu1J52ewolzs/A9nOBWnD2Op70O2KR0lSLb8bQsTFrZfZ
         +MsdmluQdRhguW1kggl8JfdUWF5S0psH0JgXoGJ4f3SsZf0j8ndoHirwwRWD6MjMwuE9
         9xAa2SgB7DufOlEtsw235rTsV54m3Cy/cl58w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kAXoMksJwSvCPGdPeM29rSArb1Q2ozVaNB51iTgnTDA=;
        b=wj3Irefc6amrYAKWg6vln8hSOYYgCv2BziSTe6xnfg3rD9ogQ31BEy4xtYkxRhXFDT
         p4qjIFpwTnvIPD20iqO4zTI8NM6gb53t9mlYPbCEgisjMFwPqJv5XYnfywratrzu263z
         n2ps0P6pX8dk1uhdv6yOaC7JGKhbAuBgTpoz0JK9jVUxrWJCQoPeMHVqhOhnfVFtQYyu
         GshO8UDZbhWuJmoNNX3b84rmw4du0Q9lVk6XV3bUbv3s9fDSzFiY7bDkp7MUzdpSQQu3
         OVFAIHeky/h9f/OKglXNB5vdS89qpe5NdhUGjoCktpenLNeHnQktA7o8wuRAQX1i/c/I
         yUAA==
X-Gm-Message-State: AOAM530wsQ5v11oMvqkbwOcOA1JC9xoIrvrUZtUKWaZVcktgEBlfZDfY
        63/f6uDHJSNGR+wx7obVl5AzHX5ezxDbiyB4/u8OSXU5Ulc3hQo3Yr2ORPeLfdeXL8S0UPyc6mR
        TytTS2xHkM7Xtt3Ik+RU7Q45cuWgaXPP65DVv9kBFwVRePKnhL8psZpAA2WR/KB8a6C29
X-Google-Smtp-Source: ABdhPJwQgMQKv6eZG9AtKv3Ce4SLWw6KkoH8JcQsdkmtDZeuF4Qq242M71oQT7CJw0dzRQ3k/HVKIw==
X-Received: by 2002:a63:d318:: with SMTP id b24mr11789629pgg.255.1643499604337;
        Sat, 29 Jan 2022 15:40:04 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:03 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 01/10] page_pool: kconfig: Add flag for page pool stats
Date:   Sat, 29 Jan 2022 15:38:51 -0800
Message-Id: <1643499540-8351-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Control enabling / disabling page_pool_stats with a kernel config option.
Option is defaulted to N.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0..feeca42 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -434,6 +434,18 @@ config NET_DEVLINK
 config PAGE_POOL
 	bool
 
+config PAGE_POOL_STATS
+	default n
+	bool "Page pool stats"
+	depends on PAGE_POOL
+	help
+	  Enable page pool statistics to track allocations. Stats are exported
+	  to the file /proc/net/page_pool_stat. Users can examine these
+	  stats to better understand how their drivers and the kernel's
+	  page allocator, and the page pool interact with each other.
+
+	  If unsure, say N.
+
 config FAILOVER
 	tristate "Generic failover module"
 	help
-- 
2.7.4

