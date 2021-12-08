Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31A246CF11
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbhLHIhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbhLHIhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:37:04 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B04C061574
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:33:32 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z5so5821494edd.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 00:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFpFNbcBX+lPeRGnonpR3BH6HPTPVDEm6tJ4QkqNbVo=;
        b=fyG2uCc9nPoybzx4IqY3kG3z4y/lzE2jNZjrff8vePl8GWtgZSaNMC65PLruzfzUFf
         dnAryvQpAWnYYa+ME9rtNg1BTldjtTWg8VMYpcbot++nJgPC/ZvNC6kvI9qPx5jokeor
         FLe6DmMQqJ6Xdfyq3TIhyZprBoXpZvj3lBY/aE6+D94wICjzXxClnejSEVcBq/MV9IzW
         HrGn3gPWi+N9sN8OZXa3LEvuAMppB3NSf2FAbkU2AzptV5XKKGctLZSdg2jCAIt+V7jH
         6fHxN+eiDJ/z+RtnCyZ2TsqW3jbM4KHQCxYjmcLv5BGrsVHdBbRouve9mNV6lsfHWB21
         WaGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFpFNbcBX+lPeRGnonpR3BH6HPTPVDEm6tJ4QkqNbVo=;
        b=75cA+0yfTty932J0a5sTQrO/XMG6CRb4/svcsRphd8Cqfxe57+aB9nhozqJq9YdQIi
         BhpZRuAwzarzdV5XecgBKkaKfs6HWT6LtT5oMzgR92BsRFzmQFYiAI4yDJpdnHIZJXpY
         LmFHBbfCrMqEphoJbFBP+jMy4zZjtF1LCDO+VY6M3lxygONbhGYlsifIYO5f5LEdM9VR
         jrnAhSy6Cl1LgzJSZPByQcDy2G3fGTlaFvZszmGqqA5TTHBUCwYD81I5R5pke5tzQe7o
         xEVcVCMWwcVC4cWoXNde0GT4t81wFraHEiq6JOOWK7NzDj9FZlTlZIBxcvr1sahEvIus
         bgBA==
X-Gm-Message-State: AOAM530WXVI0BKM7UTIpvKHMjgJCJl9mpziRylKTwkPOfwDJMLn2Gy/O
        kCpLxfMBjEycu/oQPIWZQCq+lg==
X-Google-Smtp-Source: ABdhPJwjB4j2qwDPyk+4ObiPFmUCJJ3bfOq7wkfrgeKtjhkWvjp7+SQ4o/Bu5lKqkBurHaCAuz088g==
X-Received: by 2002:a17:907:7e91:: with SMTP id qb17mr5835776ejc.449.1638952410925;
        Wed, 08 Dec 2021 00:33:30 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id d10sm1089074eja.4.2021.12.08.00.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:33:30 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 2/7] coresight: etm3x: Use task_is_in_init_pid_ns()
Date:   Wed,  8 Dec 2021 16:33:15 +0800
Message-Id: <20211208083320.472503-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208083320.472503-1-leo.yan@linaro.org>
References: <20211208083320.472503-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces open code with task_is_in_init_pid_ns() to check if
a task is in root PID namespace.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 drivers/hwtracing/coresight/coresight-etm3x-sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
index e8c7649f123e..ff76cb56b727 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
@@ -1030,7 +1030,7 @@ static ssize_t ctxid_pid_show(struct device *dev,
 	 * Don't use contextID tracing if coming from a PID namespace.  See
 	 * comment in ctxid_pid_store().
 	 */
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_init_pid_ns(current))
 		return -EINVAL;
 
 	spin_lock(&drvdata->spinlock);
@@ -1058,7 +1058,7 @@ static ssize_t ctxid_pid_store(struct device *dev,
 	 * As such refuse to use the feature if @current is not in the initial
 	 * PID namespace.
 	 */
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_init_pid_ns(current))
 		return -EINVAL;
 
 	ret = kstrtoul(buf, 16, &pid);
@@ -1084,7 +1084,7 @@ static ssize_t ctxid_mask_show(struct device *dev,
 	 * Don't use contextID tracing if coming from a PID namespace.  See
 	 * comment in ctxid_pid_store().
 	 */
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_init_pid_ns(current))
 		return -EINVAL;
 
 	val = config->ctxid_mask;
@@ -1104,7 +1104,7 @@ static ssize_t ctxid_mask_store(struct device *dev,
 	 * Don't use contextID tracing if coming from a PID namespace.  See
 	 * comment in ctxid_pid_store().
 	 */
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_init_pid_ns(current))
 		return -EINVAL;
 
 	ret = kstrtoul(buf, 16, &val);
-- 
2.25.1

