Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B211746CF0F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhLHIhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240716AbhLHIhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:37:01 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF906C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:33:29 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v1so5841429edx.2
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 00:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HhbhdM+UVkV69ylyGAUrfry6xL5WJfe10RQ3MgDri3E=;
        b=eaX02OEPSS+RjOClG9DGc+v6cgQ88a34E72u12SEvVTKae7LfSyBfOb82cG4ik+ihQ
         vMC/UinqwVByxQYNyaTphU4u1cPFoa3FXqjaXb9X9cmergltDcgJY6geO6dTNjMs/2Cr
         2ckYlk3wDqtGK3dMjrahko4FFZAV2ZLENLDoRtZJulXk1fVkjlKnE9ISE0Zkh/Lv5x6d
         3WHnHmdLbdozO2mDzEn3AK9XR42fFN9yqUlC6TVJAjiG2+oVvxbL3wlzbFnUlZMr9iVU
         YwDGI5KC09SF8tOHXYvP5dtqvieq6x4p02D04zO16Lh/5pIAR3UtwpUgEBbKD8H37KIh
         9+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HhbhdM+UVkV69ylyGAUrfry6xL5WJfe10RQ3MgDri3E=;
        b=1faTSww1SXfTFoHgswk8f5zssi5xiwHla2JF4pOgV9G/lD0bYFKoiwKV+aqPdUB7pB
         KHdVkrFXWnSWuAj9luHVZEoQTz7ROhar51D/Cx2+Qlq5zbgwswz2apAX7Z+m5xaLVOiu
         TelcsqzH20NkougsCd72kgGdHUwIra+7E87/WeOSDwfBeFjP7HygmOUwJnFz0TdFq7y2
         e2qY3M/doXcnhNS/p2lLNID2X6vkvuvdDQUHyKKf8o6rZhYssxUWT4xBAMix2wa+u5/o
         T9Yo1JfiJxcGTxoh1/xhDX0OJxDR1vhRgtlTX0YSeVL46bs8v9WKucNPIt8KcDGAKT7j
         TSzA==
X-Gm-Message-State: AOAM5338NOUkTw2InLPAI/RjPOyAyXnNP1+sqnGxSetrjddNOSuB5Xr+
        hIvj5E5vbtu/TQUA/jPJL8JYSQ==
X-Google-Smtp-Source: ABdhPJz/Aub/CN7cwflA5aTaNqCW0zeff09QK+an5jfSI+P/yEVmx3XrZ525aOOBfp2sz8qeApVlag==
X-Received: by 2002:a17:906:40c4:: with SMTP id a4mr5430305ejk.185.1638952407946;
        Wed, 08 Dec 2021 00:33:27 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id z22sm1716370edd.78.2021.12.08.00.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:33:27 -0800 (PST)
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
Subject: [PATCH v2 1/7] pid: Introduce helper task_is_in_init_pid_ns()
Date:   Wed,  8 Dec 2021 16:33:14 +0800
Message-Id: <20211208083320.472503-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208083320.472503-1-leo.yan@linaro.org>
References: <20211208083320.472503-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the kernel uses open code in multiple places to check if a
task is in the root PID namespace with the kind of format:

  if (task_active_pid_ns(current) == &init_pid_ns)
      do_something();

This patch creates a new helper function, task_is_in_init_pid_ns(), it
returns true if a passed task is in the root PID namespace, otherwise
returns false.  So it will be used to replace open codes.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 include/linux/pid_namespace.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 7c7e627503d2..07481bb87d4e 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -86,4 +86,9 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pid_idr_init(void);
 
+static inline bool task_is_in_init_pid_ns(struct task_struct *tsk)
+{
+	return task_active_pid_ns(tsk) == &init_pid_ns;
+}
+
 #endif /* _LINUX_PID_NS_H */
-- 
2.25.1

