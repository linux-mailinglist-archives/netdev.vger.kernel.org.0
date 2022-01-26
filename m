Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F69749C2E3
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 06:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiAZFEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 00:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiAZFEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 00:04:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B16C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 21:04:41 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h12so22219662pjq.3
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 21:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IsRrzz+vVs7xKnz/lewoZVNy+C+wQYHvRJd0f1wPM9U=;
        b=yTNl4GKIQ/5sP5Z523fXUAs1DDokQFHNusk8CX8rNrFO0EPJSeD8VmPbmYKwmGs/hR
         slidDNH735KMBT7U6lZNrIa11M02+QwD3g6P9ySWvc+C23T/vq4iK/2Uf8y/NqpMN6oo
         oipk2ZKmqo50gHE1JnohScTHv8xHFU9r2YyWOsXLbNiIBFjFCK2tGI9MaqwwNCqO5gI0
         a3BYuWqDSnPF04DeQ+jay9xGY33PQ0BqKxTm9J3ML1Ge3I5S2QYKuzTgT0ZXjvJQrb0q
         ezua+4vJSJCEtVXueb7nS/Ehiy2zm/tkO/f34lVKzTbNtLvBOCzt51QCUzKxp+zfj+vt
         S6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IsRrzz+vVs7xKnz/lewoZVNy+C+wQYHvRJd0f1wPM9U=;
        b=YGp/rOOOlj8PSLeVFD8ffLiRn94SUnUmomYKOHuuiC9GVu55ihMeA13s5JK/b5IHF0
         RFhL+pbrmGouAMpirgAz/t4w5s9DLfWi9OWtQxB1VhNld7P1E/XcyV5E4gfABK7QLUkt
         ROaoYZvJ7FA2gz+tHW5nkZ+HB6akqAa6WJ2M5vGDLBT3mHUAoox8Op/i5a0d2lDf73JM
         C2m2Cjrrml7e/cgWNvqJLTKznNkAzV9L+PrKgECjEVnTO5C8OGDoAJRwgYxT22psc7QK
         yp6C1K7Zrg6HhgDyHlHUqXV/lmW1T9hWB+vswgv/Jpjsc3PPEHUUP04JEfz9Rha0NgKo
         BfvA==
X-Gm-Message-State: AOAM530zcVyWO3dayaipHR4fspElFx0BgJ/620GarrpCjkWS8ivG9vzX
        Uwj5DIvjJOJWSs6s/WNmZuDjJA==
X-Google-Smtp-Source: ABdhPJxszbNAqj/l4IZvFbc/AbIG8iGJgTZTmq8m52MLo0OKtFoeA8a8da/ozBdlX1RPVgXvW6mAwQ==
X-Received: by 2002:a17:902:ce8d:b0:14b:562d:2b3b with SMTP id f13-20020a170902ce8d00b0014b562d2b3bmr11096216plg.57.1643173480550;
        Tue, 25 Jan 2022 21:04:40 -0800 (PST)
Received: from localhost ([134.195.101.46])
        by smtp.gmail.com with ESMTPSA id bf23sm1854660pjb.52.2022.01.25.21.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 21:04:39 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH net v3 0/2] pid: Introduce helper task_is_in_root_ns()
Date:   Wed, 26 Jan 2022 13:04:25 +0800
Message-Id: <20220126050427.605628-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces a helper function task_is_in_init_pid_ns()
to replace open code.  The two patches are extracted from the original
series [1] for network subsystem.

As a plan, we can firstly land this patch set into kernel 5.18; there
have 5 patches are left out from original series [1], as a next step,
I will resend them for appropriate linux-next merging.

[1] https://lore.kernel.org/lkml/20211208083320.472503-1-leo.yan@linaro.org/

Changes from v2:
* No any code change.
* Extract two patches for network subsystem. (Jakub)
* Added reviewed and acked tags. (Leon, Suzuki and Balbir)

Changes from v1:
* Renamed helper function from task_is_in_root_ns() to
  task_is_in_init_pid_ns(). (Leon Romanovsky)
* Improved patches' commit logs for more neat.


Leo Yan (2):
  pid: Introduce helper task_is_in_init_pid_ns()
  connector/cn_proc: Use task_is_in_init_pid_ns()

 drivers/connector/cn_proc.c   | 2 +-
 include/linux/pid_namespace.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.25.1

