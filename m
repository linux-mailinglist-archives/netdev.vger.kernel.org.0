Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C60468B75
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhLEOyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 09:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhLEOyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 09:54:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF06C061714
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 06:51:16 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h24so5854704pjq.2
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 06:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uX2NVH/p4XWwvuMtSonYvqXVGhVcHlyl1MPTyjaypn0=;
        b=PaMy4nrJdo1cDW6ZbiNHyyzXar8/bwxYeaE9YGrcEvKHRMZ7IBPDoZ8dPHtJ9f5TDW
         Wt62+MdjtdPOmb+svcwZLUAjXyfphJFeiE6mHLZr8fAV3FaXdR91qW0ASgo7jgn3rqkL
         s7F9+7CbI1PHTjUrQFJZU3aERsA7/48IakhiyY3wfnHrgszsTlAg4roR/+7bULuh4vOH
         mtDLD70CarYhOIAOqPaXLbyoF6jjoe78diqfNQ6CXIK3O0OApICEcMnk5MnrUYgL5QPI
         E8dzVCF3S/vabXi0WxV0DgNGnBGhlO0KX2y48ylqXyOwNUK8/AZtLZ6q+g1l4TejB5e6
         AxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uX2NVH/p4XWwvuMtSonYvqXVGhVcHlyl1MPTyjaypn0=;
        b=21bHXv1EWqc10y9Hhn/Rmm/TvZb/rf2F6eEhJOVmKKbo0m9GaMufgsvZ/RxPvGWgVT
         8os9btA2jtiB5vdaw9hTcqvhkVNA6Ze8M+lZGVt05ef0nVtv240woB52WEocSM2d7+rv
         NSTaCCis3vtBXXNCy3bbqP6ggzXhQipm+L7sZx1fWx/JMxdDuf/hj07v7ts97oE2o7LG
         jQI8CkalMPaGbEDEJfaL4xdm+pdL3L1eG6WkPz4sALhB3izU5MqZb6HA78MCSbatAO+M
         yzv78rltrmec3VxmgQfB9PkUCsxPg5MBuYZ9HJ68PcUtbyZMVVhzO4EEf6MxetLD+OdM
         bZpA==
X-Gm-Message-State: AOAM531Bz2JiIFoOGI6PJ446XVRkDQ9Xf3AqYv60Axy7utkQezwkcgGy
        nhNAFtOfpumizmo8BeBSG//p0g==
X-Google-Smtp-Source: ABdhPJwIOvPWvYd84S7H/yFRTlICWYP9VDs8JGx/x+rzDNk2TRJA5YnOqtqrDB73G+o+IYj1tQbg2Q==
X-Received: by 2002:a17:90b:384d:: with SMTP id nl13mr30543184pjb.80.1638715875608;
        Sun, 05 Dec 2021 06:51:15 -0800 (PST)
Received: from localhost ([2602:feda:dda:dc04:ff07:a102:a8ea:7103])
        by smtp.gmail.com with ESMTPSA id b6sm9417632pfm.170.2021.12.05.06.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:51:15 -0800 (PST)
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
Subject: [PATCH v1 0/7] pid: Introduce helper task_is_in_root_ns()
Date:   Sun,  5 Dec 2021 22:50:58 +0800
Message-Id: <20211205145105.57824-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel uses open code to check if a process is in root PID namespace
or not in several places.

Suggested by Suzuki, this patch set is to create a helper function
task_is_in_root_ns() so we can use it replace open code.

To test this patch set, I built Arm64 kernel with enabling all relevant
modules, and verified the kernel with CoreSight module on Arm64 Juno
board.


Leo Yan (7):
  pid: Introduce helper task_is_in_root_ns()
  coresight: etm3x: Use task_is_in_root_ns() to check PID namespace
  coresight: etm4x: Use task_is_in_root_ns() to check PID namespace
  connector/cn_proc: Use task_is_in_root_ns() to check PID namespace
  coda: Use task_is_in_root_ns()
  audit: Use task_is_in_root_ns()
  taskstats: Use task_is_in_root_ns()

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

