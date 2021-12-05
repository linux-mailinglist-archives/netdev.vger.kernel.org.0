Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F560468B7F
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhLEOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 09:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbhLEOzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 09:55:02 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB12C061751
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 06:51:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so8864291pja.1
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 06:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LxgaAqKPfY9+Fs9lU8SAVq20rT6hH9OdOm/kBs8bn3Q=;
        b=EGa7KxHBtggk+Rt/PaGDK60Ju5BJXpK5BICGg1t9YLhhLSgWFEbDxCeP6p2bnbMPGw
         8NA0bwcpajU/GsYvoZSlTHwfAA+hqBSz+dqJXTB0yNbQlNZeANFqPv9cS1GnJf8nuWKQ
         dHkqQ7W5plSFalua9EQlzAoYGcZ4R7C6xS943c+/rF8QupsRxzqdWp32jPHgy23A16vx
         QhZ5WkRQlFdsHQy5SWANoxuN+0Ic2vX+Ewz9RTFITW+g056VdCViMP7aDzHklEHPP1oh
         mXHUybqyppw9ZPsCm/nTxE/hl7tYOE1zOnRg3kgHjDv9thUoHuMDnmjRYE1hGNge5CvS
         XZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LxgaAqKPfY9+Fs9lU8SAVq20rT6hH9OdOm/kBs8bn3Q=;
        b=8LmXgf1sLHGTC5OhDBfl9m5mk0NOBF2dcUJ7IUkHteuxRTA9EkeHt3Got3FzNoD4BG
         6wWzM2G2Y1pqLy6+Es1qCfVRqxXoOAR3bcRlEboh78NUvx7rhYhiDol68asqC1MULXfC
         R2g6X2YyqEOyYYtPFnuIbVrmz+jCzg0qxID30nHzs13zeria/UuK77PHrSdM28OmIEIC
         3UebE26K5ILMbdA10ibDDd1aXq238JtqlMTPl0xR6YYclbBdAPdg7EMjBYvVmFGILxwf
         Zjmx14wqWK2zemopLP7bVOo2j+ykWEHp0DYMuqc3P0JELfLj6jd/M73hvD7krp0Quetc
         J6YQ==
X-Gm-Message-State: AOAM531NkMguWZHtu1x8G/huDdhJanbA4M1ldhhqnGsfm6ZUoMdlKzuL
        rrvteUJTgl8YMFS19OqUes970A==
X-Google-Smtp-Source: ABdhPJyhz7mhy7c/6gh3uw7e17BV124wmThyRYdSZZNNApgX+01Pi1PcCXUsHi1AFphndxNGVWNNQQ==
X-Received: by 2002:a17:90b:155:: with SMTP id em21mr30713254pjb.12.1638715895026;
        Sun, 05 Dec 2021 06:51:35 -0800 (PST)
Received: from localhost ([2602:feda:ddd:e0c7:4151:8a98:ebd2:b9e3])
        by smtp.gmail.com with ESMTPSA id o16sm10043005pfu.72.2021.12.05.06.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:51:34 -0800 (PST)
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
Subject: [PATCH v1 5/7] coda: Use task_is_in_root_ns()
Date:   Sun,  5 Dec 2021 22:51:03 +0800
Message-Id: <20211205145105.57824-6-leo.yan@linaro.org>
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
 fs/coda/inode.c | 2 +-
 fs/coda/psdev.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index d9f1bd7153df..a7d630ac522e 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -152,7 +152,7 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	int error;
 	int idx;
 
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_root_ns(current))
 		return -EINVAL;
 
 	idx = get_device_index((struct coda_mount_data *) data);
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index b39580ad4ce5..54db13bf2e06 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -270,7 +270,7 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 	struct venus_comm *vcp;
 	int idx, err;
 
-	if (task_active_pid_ns(current) != &init_pid_ns)
+	if (!task_is_in_root_ns(current))
 		return -EINVAL;
 
 	if (current_user_ns() != &init_user_ns)
-- 
2.25.1

