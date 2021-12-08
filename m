Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1446CF15
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244958AbhLHIhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbhLHIhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:37:09 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4598C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:33:37 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r11so5689984edd.9
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 00:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hWyoQ03AyiBHBWIuTqdgSeOsB5qpmILnrb6mYHioPfI=;
        b=GK/tVEYgxyUvQFbH1SFaI008Q6trqxRp+nDnHpWJh12YtgZvbGJk7hLGvDKtbMk0zL
         xwxFOvtPy5Xws67MVe0W3I1aNVjzUyGZyPf3+O1fQL3ZgDQjB7hbdqzibnwyeKrAcu0N
         cSC1DwRNG2Bi/kRBZPruIAUWTmK9G9R9L61HhNugyhWORaHFD6KuBK2n54VgavYyRtWX
         xWjRuUE9N4UFyNalIs+WgArU0ULJWBg5CFsNz+up0sQflSRhtjbfTo3eED7zMHqY7CCh
         TxoVqGs1HEsiyMx/GajB/vBzL9/2K0vzgb4+KGOfFP61CG2M2VeinnQQud5jG93QQ3vr
         XM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hWyoQ03AyiBHBWIuTqdgSeOsB5qpmILnrb6mYHioPfI=;
        b=nQ2tMaNACMob2MFjirKodzqQFv7EhZ//O95RFUTURUVPwvx7WpyIkGX3OjagwYTO3L
         R1hAEARu4yNrl99bruBwcXI63xUlz1/F9+WtWliUJYiOyXCWPwOIILL9FcliTM2S4VGC
         B2oDGK8XHHcTQABmiNlfw+zNl1TG7quFSf9cIqSDtvrdNiuI+50ZLQb7fMjUKiy1WbtV
         KK0uT71qZIQGbx3jYGYpPwTe+um3MOcpPSHBge5wfLjKD44KR5cHo0tqC5Dgu5Kxr1E5
         EDzgf3lnE0DOawky6tA2KLvStqB3byYPH3xNnlA9DpqpQ55adjOtD6jCzI2pvjbu/Zeg
         spUg==
X-Gm-Message-State: AOAM532nklqpsk4sPVsvjhlV0DlkaAy29P4aZi17ZE+2K9kyaGeyY4e5
        Db34HlJKVbWjP3WVYBu22yZKGw==
X-Google-Smtp-Source: ABdhPJxuBtI+/+kQ5BUm3igh6ZDVewoV1vYV0z/0/tl6BZ5inncH5WbsQjgaDaLRdh5hJdL1dj1EgA==
X-Received: by 2002:a17:906:7b53:: with SMTP id n19mr5897162ejo.538.1638952416319;
        Wed, 08 Dec 2021 00:33:36 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id t5sm1564891edd.68.2021.12.08.00.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:33:36 -0800 (PST)
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
Subject: [PATCH v2 4/7] connector/cn_proc: Use task_is_in_init_pid_ns()
Date:   Wed,  8 Dec 2021 16:33:17 +0800
Message-Id: <20211208083320.472503-5-leo.yan@linaro.org>
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
 drivers/connector/cn_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 646ad385e490..ccac1c453080 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -358,7 +358,7 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	 * other namespaces.
 	 */
 	if ((current_user_ns() != &init_user_ns) ||
-	    (task_active_pid_ns(current) != &init_pid_ns))
+	    !task_is_in_init_pid_ns(current))
 		return;
 
 	/* Can only change if privileged. */
-- 
2.25.1

