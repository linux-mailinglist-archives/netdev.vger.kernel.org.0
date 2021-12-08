Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D48546CF0D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbhLHIg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhLHIg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:36:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC05CC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:33:26 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w1so5752920edc.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 00:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ezHbFwEHOgtVXrEPyC2/Vvb45wpR1NFY6XpUn36BJXE=;
        b=Oaf+owd/RxE7FUplEWeI5CqQzsjKbRXuQa43xyIk8paq/kW39V2Jk0nlY1ZWyhxpzU
         X+N7Df1mmj2hufjljaOYnx6hIp5QRnh87y5eornCGGFjBBGRy+28h36VkFJBkOLHAIn0
         tP4YpbDPUYZNhTcWm7KU3yIvoj6iSxSMmyAepmyNHhV38hpTgWKrg9ic9zKd9uOxTAMR
         Ig9dgtPY0sOotTxVnxNOvU8F+wcYjME6qhBsYZAjLi568fI6/TBQTAaVRtg3oolVohXr
         AToDvZFgbftWn0HolfqaZyNLXnSZwSbZ1HBfyMnqcJv3yyJR4VduqbXUBvD4tfZkn7Kw
         43ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ezHbFwEHOgtVXrEPyC2/Vvb45wpR1NFY6XpUn36BJXE=;
        b=s24JW/dIHKhZVJakHbPEAvLBs7ZnNAytQ9WoIp35uTZkAwTVVyQvwK+MDHrvFb+a0Q
         VZfZGM9+fTo4aPlFUQbf4HYJDkZzyhyVAF1a0K6K8DjAh0mbupSHNGa/6SFmV3zgz7nr
         zATpimH1NFiuJRQAysOyCqDMEHV8py8mmrD5ZBh2+npTn0DWFHsNXYT6edeFclqnUE5M
         kJhJDqnJfKMKOmASzy4fZhzbVj87/zsVq6olkxD1rhfrHqIJVGMVNJM/DaQpRty19MAH
         J0ziYtJl/XF6tEy3n0cJC3AU02aBJQylm9b+a8ExkXZhOgaxcxsWe5j9oYYl9UhsHA+x
         vWrQ==
X-Gm-Message-State: AOAM530ltTVIUZjWBwUvw0AKXhFrf0tgpxDwZZ+x07L1bOB+8EYVUwco
        pajoL1fEC0TE1rUaU4W7u3mcMIGLXUw5aAjy2TY=
X-Google-Smtp-Source: ABdhPJxHqGG5uVa6peGzKP9j9aIy5j3Okpl/7+N6i/8RUzX2jx1jDDBoDhwrbHIhuMk49gm26vKjEw==
X-Received: by 2002:a17:906:580a:: with SMTP id m10mr6157826ejq.213.1638952405323;
        Wed, 08 Dec 2021 00:33:25 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id f17sm1493865edq.39.2021.12.08.00.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:33:24 -0800 (PST)
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
Subject: [PATCH v2 0/7] pid: Introduce helper task_is_in_root_ns()
Date:   Wed,  8 Dec 2021 16:33:13 +0800
Message-Id: <20211208083320.472503-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel uses open code to check if a process is in root PID namespace
or not in several places.

Suggested by Suzuki, this patch set is to create a helper function
task_is_in_init_pid_ns() to replace open code.

This patch set has been applied on the mainline kernel and built for
Arm64 kernel with enabling all relevant modules.

Changes from v1:
* Renamed helper function from task_is_in_root_ns() to
  task_is_in_init_pid_ns(). (Leon Romanovsky)
* Improved patches' commit logs for more neat.


Leo Yan (7):
  pid: Introduce helper task_is_in_init_pid_ns()
  coresight: etm3x: Use task_is_in_init_pid_ns()
  coresight: etm4x: Use task_is_in_init_pid_ns()
  connector/cn_proc: Use task_is_in_init_pid_ns()
  coda: Use task_is_in_init_pid_ns()
  audit: Use task_is_in_init_pid_ns()
  taskstats: Use task_is_in_init_pid_ns()

 drivers/connector/cn_proc.c                         | 2 +-
 drivers/hwtracing/coresight/coresight-etm3x-sysfs.c | 8 ++++----
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 8 ++++----
 fs/coda/inode.c                                     | 2 +-
 fs/coda/psdev.c                                     | 2 +-
 include/linux/pid_namespace.h                       | 5 +++++
 kernel/audit.c                                      | 2 +-
 kernel/taskstats.c                                  | 2 +-
 8 files changed, 18 insertions(+), 13 deletions(-)

-- 
2.25.1

