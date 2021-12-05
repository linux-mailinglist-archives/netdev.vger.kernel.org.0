Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98EE468B83
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhLEOz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 09:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbhLEOzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 09:55:13 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955CC061A83
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 06:51:45 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 133so7962223pgc.12
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 06:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WoYH3kUyU3rR597Qe29Tyg1cbdekiS3zv4yqA77Ra+o=;
        b=PQrQcoOw1V9KP76uLbFLDEDyrU9vqBzJPlKj+pTPusgS4daHAq7p66wzfdvZqqIJc2
         QRKtdzA1IbWpSH8mHpn027kXF9Mild4jnXfXrzwYxqZxzF9JDoK6kTv1YaFv05Il+rEv
         lIvw4Xq6j53moojd4Yjl4KoUFlH9LWXrmjmmWREieVyxw8BExrw3buKuSVltSk3mNAaz
         mh2fAPVWvCLZscc+IivAkObQD8K+H0FitLX6DJ4jpbHnoQAEwMEadj7f8xY8967azkF6
         Q5w6kToRbIlON6L0NmISOYfuZ8vwO6RrksQaoigaYoCM56mEQPl8QUiaddf/27eSZl0n
         V4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WoYH3kUyU3rR597Qe29Tyg1cbdekiS3zv4yqA77Ra+o=;
        b=k4kuLasNom7gWF2p00j4xnr+65ka9HIhm5WI7ZBOQ1r0+P8VZwLHI0JnNDeipQ8OVU
         lKU/q8dd11QUAZhXYNCnDsRb3vD6aGUHyQxFCl6L2OqNMP0XjEcm/2vcROk49IeT7yH6
         LMKPXX5K/MBXn4iF1TbvJrb4TQVi2eRBa4yT+QAxK7bAtV130+Uj8y7MQsr/pdr2iJjP
         C/1Khu/WDTmvqEArylEouDVuG0bFaomELFGWkH1P04h/BanEBkjUoE9Js5vcvULK6gM/
         a2V7UHai29PqoBv/woGu2TLgZEO4nZy4e5SPrCN78CTzS5lanlxXxjmxitzWsb4w27nm
         EfKA==
X-Gm-Message-State: AOAM5312b/SE1qPVAo1jBmKh9RMPwrLb6a5f8eidUzSoqjKfxR/bJVMG
        cHH3LvkNp2OkwoZf6S2C2rICnA==
X-Google-Smtp-Source: ABdhPJycmQqaqKyYV6rADGSOztK52rZFL5guaz/TJWi/jAvOjSlm3KATDKooWY63M7hIdTmll6FeGw==
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id j10-20020aa78d0a000000b004a282d71695mr31790299pfe.86.1638715904962;
        Sun, 05 Dec 2021 06:51:44 -0800 (PST)
Received: from localhost ([2602:feda:ddb:737a:816:168e:3e5a:d93])
        by smtp.gmail.com with ESMTPSA id c3sm9960145pfv.67.2021.12.05.06.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:51:44 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: [PATCH v1 7/7] taskstats: Use task_is_in_root_ns()
Date:   Sun,  5 Dec 2021 22:51:05 +0800
Message-Id: <20211205145105.57824-8-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205145105.57824-1-leo.yan@linaro.org>
References: <20211205145105.57824-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace open coded checking root PID namespace with
task_is_in_root_ns().

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 kernel/taskstats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 2b4898b4752e..c6a19d3911b3 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -284,7 +284,7 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 	if (current_user_ns() != &init_user_ns)
 		return -EINVAL;
 
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_root_ns(current))
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-- 
2.25.1

