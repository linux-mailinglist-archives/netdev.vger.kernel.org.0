Return-Path: <netdev+bounces-6344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB51F715D72
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CFE31C20B36
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75BB17FE6;
	Tue, 30 May 2023 11:40:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C928017FE2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:40:30 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365BEC5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:40:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64d577071a6so5042703b3a.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446827; x=1688038827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JO+xdar3MejOJZdKmBkA9ihZEhu1lJTvdVxsMRKinbc=;
        b=WsDOY9jQoN7Z60/CfCewtBbx5WDKyT8UAnjmpj9OQeIMppc40tAvX12MUibOoFeC7F
         1yvBEnazT7feLsOMV4EmMc7BN0meQQncwW7I8uk5n4K35FpQV1ssrM64kI8qNjo86HCU
         q2b3VVlCgdXlWT5ljhv4SobkdECX9a/4ycYrCXq4U/GEy8xocCxQ5uD1oj2uZquQ3me1
         XgBo5tCmkqXMjg0hRKZfkVek1kAWtxJIuKw9xheE9KTLYc2oxLxe/7utv8B1FrJyg2CW
         1Sn6hEVW5ZWW1PfUOx9Kpa62nIcl20BGmKkT1L1FZjER2FvJLR2KYjVryJv1rdsTTDE9
         movg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685446827; x=1688038827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JO+xdar3MejOJZdKmBkA9ihZEhu1lJTvdVxsMRKinbc=;
        b=M3ge72y1xd2gkzKO5P4Vle0z8rh/8jLtSo3eMUgFomZ5k/ZUTEq37IYZsDMP8uqkYI
         lnjQY+8nVmab+TrbtoSziS229KoIghqxXKFgdb5X9stNJNZlnp1FXWlwamERProasagS
         YJKA3+LW1z2Tb5KYKlPGKxj+kYC4K3DMfjNXJfyZnbomR0tpFEvSPtBQFdwGYS6EWZ2T
         QuLVKOUQ3+LnIeVfYhO3x09u4LpewcC8M+nKnw62Yi9m0dDC68r1tg9f+dnu5tGYyh0R
         qbUdKnV+/rlI1r0TBxNceERx/umq5+d5BGi28vTv75Z6LC3Xafb54QA9U1Jsj1OxkCCh
         rZtA==
X-Gm-Message-State: AC+VfDxYAOtoRznrrWkXlPn8DNeN7EbtGbtkQ93ml+ecxo8yNqHT7RQz
	sZNbENH+xtJ5y6t3nG/8Y1J9VQ==
X-Google-Smtp-Source: ACHHUZ7vxE2I8AcBFyrCBnPtSDWf+89hv2cMdNzv+jUYl+x0Xx48DRjOu9QgyvfV/5n8S9vBOlxxDg==
X-Received: by 2002:a05:6a20:3d85:b0:100:60f3:2975 with SMTP id s5-20020a056a203d8500b0010060f32975mr2490885pzi.4.1685446827713;
        Tue, 30 May 2023 04:40:27 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j20-20020aa78dd4000000b00642ea56f06fsm1515103pfr.0.2023.05.30.04.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 04:40:27 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v4 0/4] sock: Improve condition on sockmem pressure 
Date: Tue, 30 May 2023 19:40:07 +0800
Message-Id: <20230530114011.13368-1-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently the memcg's status is also accounted into the socket's
memory pressure to alleviate the memcg's memstall. But there are
still cases that can be improved. Please check the patches for
detailed info.

v4:
  - Per Shakeel's suggestion, removed the patch that suppresses
    allocation under net-memcg pressure to avoid further keeping
    the senders waiting if SACKed segments get dropped from the
    OFO queue.

v3:
  - Fixed some coding style issues pointed out by Simon
  - Fold dependency into memcg pressure func to improve readability

v2:
  - Splited into several patches and modified commit log for
    better readability.
  - Make memcg's pressure consideration function-wide in
    __sk_mem_raise_allocated().

v1: https://lore.kernel.org/lkml/20230506085903.96133-1-wuyun.abel@bytedance.com/
v2: https://lore.kernel.org/lkml/20230522070122.6727-1-wuyun.abel@bytedance.com/
v3: https://lore.kernel.org/lkml/20230523094652.49411-1-wuyun.abel@bytedance.com/

Abel Wu (4):
  net-memcg: Fold dependency into memcg pressure cond
  sock: Always take memcg pressure into consideration
  sock: Fix misuse of sk_under_memory_pressure()
  sock: Remove redundant cond of memcg pressure

 include/linux/memcontrol.h |  2 ++
 include/net/sock.h         | 14 ++++++++------
 include/net/tcp.h          |  3 +--
 net/core/sock.c            | 10 ++++++++--
 4 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.37.3


