Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EA44A9174
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356150AbiBDAKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356182AbiBDAKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:44 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27580C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:44 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y5so2687394pfe.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jZQROXOP0pza6cD/HAg54T+BPrYK4YdGCqA3Sg45Jw8=;
        b=YyC3YF9Wj9RrKPYZuyme1WaLLkniV1GiY0yR3OfB/JxRfuPdzOJTK8V0ya5fHsZHOA
         8GG2OSdfLTR7ZyjtmnHUhk9uQunclMI2I2OrHcPyazWt66u28DSYH3ZcWbiB5+7Z4Z/c
         2jcBT2pNvvzUOZjd/525xPMzNsgtJf0zuqJdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jZQROXOP0pza6cD/HAg54T+BPrYK4YdGCqA3Sg45Jw8=;
        b=kJ9gItqQSomXWW0fz4YLc9PY7C6+sxXe8L9b2EFiLRIoN7rESA3oY8MlNroF6gTNUW
         p5UsXxQh90i6tMQFw8Gx6ApUmT4RS0Ed+CjeNX753872lHQy8AoHN/bd/fLyHwG3htB8
         ulZRz/DUMa1Rgp2BJy1LOfYSl3sawWqliaKFDmqYVuFQjHS8KvZYX9Lk3srLQgA4ISWR
         zdismcZgajMW1A+d+oRQEoIBcV9W6irYYRO8mowB9WXcgi4n+6DxQ9rentP7RfhKrzaP
         ya926hpowJKXIVHgI9XGy+uY17pv7I7vyDgObjtS5NFih75smZZ7KDA9HFchjeWcQhL5
         7V8A==
X-Gm-Message-State: AOAM530GZiXiNYZuQ3w3HE8uGPNTKoL74e5lq5UzajtcbCZ9TH8wCNQe
        3Fa8MdeTbZGN+JWuxCzchVK4bFUWjDrlYzUciJ7jSn8dihb2o57Dx28SwrcjjZLNKL6IDVO4NJb
        QNchTeVl9xDPJGBPyh26kD0+ONHSZprPka12ct4yvtVmCMHGSwbcWU6oCTNZhgmx4LkGa
X-Google-Smtp-Source: ABdhPJzZtGpgeuzre265LqPXdn4f30r/FjfyqFpFhsmkty55bMzE+8cUObILC3Bv8ssgcMWhuHTQDA==
X-Received: by 2002:a62:7a0b:: with SMTP id v11mr617125pfc.22.1643933443269;
        Thu, 03 Feb 2022 16:10:43 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:42 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 01/11] page_pool: kconfig: Add flag for page pool stats
Date:   Thu,  3 Feb 2022 16:09:23 -0800
Message-Id: <1643933373-6590-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
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
index 8a1f9d0..604b3eb 100644
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

