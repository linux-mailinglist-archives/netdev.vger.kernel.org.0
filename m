Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438E746CF16
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244948AbhLHIhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244917AbhLHIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:37:13 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B30C061D5F
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:33:40 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x15so5868694edv.1
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 00:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWkrWIVd0/tR6K54G/x68wI67h0lySobA9zdXOmvIu4=;
        b=defM02iiv0IuxmhLtI7Q91bOiZbH9EqLeP10tH5ALqWf7R+haF+jgmUJ9uAyaKbBQK
         k3h8RCQOzjyxiA2Nt9jTqv9wJow4oQK1mOTwjiankLQ+2J92Ml5eYsOmSKs9HLE0TGhK
         nlz7h+3ca/HKUfg723Vt0Bal0l19de2P1lx1goPBgFEVtxjaSWVsvLWEHSWTXeYQNs0s
         C/V1RAckrBlIKHtfpw3tlSk4ncANDAe+YfGbE98zhwCu9y5wUNNORJyNtXRZr6DNPysi
         YQfk/eqDVG94A41nzcjytS3Go9SvHW+T/dD70WTpUSNgtWIgl/jKmiaK428o8YJ7V7YD
         Z9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWkrWIVd0/tR6K54G/x68wI67h0lySobA9zdXOmvIu4=;
        b=lShhasdDYvXiEP/dzio7LxrUuuYMbHJ9hq6U/vX0d/GFkQmVyeT8t38uLYrIWzpiPY
         uAroKjvJ3wRNH8BjheSYbShflSOWnHVD472LspoM2oro4A07Yx9WU112IpWoWJ7Ilq7h
         4Bh7oG60I+ZllYY1xzLxO/R52x57EulbrzbcnaWPW25MtgOwlXMJ6Zw0+1+2DkVO6ujo
         1xvnqjB7WRWo+PCTidZ+hznyRfLe1zKQmxMLSmj0B7oCJk6uLvpSklLXhglQZ0NniIHi
         3ANex+ZMp/CXmsLb/4nO2mcrfWecVtx3avD2dWNdsH2pnuJG96h3hiODW3i47mBYg5Im
         4+Tg==
X-Gm-Message-State: AOAM530t+OGpV5aDmKDM9OAyYcUX076NtCGAZHUnwXMvFldsgZ4s4edj
        uYD614sc1uyhg7FMBIRJVP5WhQ==
X-Google-Smtp-Source: ABdhPJz4wjRib7Te/OFIfhE1RhBahkANQSzD5tFXSlekwOc7sbVMSqZYx/8aXbTYVdMw6+UCNgG39g==
X-Received: by 2002:a50:fd16:: with SMTP id i22mr17261360eds.224.1638952418992;
        Wed, 08 Dec 2021 00:33:38 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id f7sm1491975edw.44.2021.12.08.00.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:33:38 -0800 (PST)
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
Subject: [PATCH v2 5/7] coda: Use task_is_in_init_pid_ns()
Date:   Wed,  8 Dec 2021 16:33:18 +0800
Message-Id: <20211208083320.472503-6-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208083320.472503-1-leo.yan@linaro.org>
References: <20211208083320.472503-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace open code with task_is_in_init_pid_ns() for checking root PID
namespace.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 fs/coda/inode.c | 2 +-
 fs/coda/psdev.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index d9f1bd7153df..931f4560fdd0 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -152,7 +152,7 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	int error;
 	int idx;
 
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_init_pid_ns(current))
 		return -EINVAL;
 
 	idx = get_device_index((struct coda_mount_data *) data);
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index b39580ad4ce5..73457661fbe8 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -270,7 +270,7 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 	struct venus_comm *vcp;
 	int idx, err;
 
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_init_pid_ns(current))
 		return -EINVAL;
 
 	if (current_user_ns() != &init_user_ns)
-- 
2.25.1

