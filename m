Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F96EBA0F
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDVP40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDVP4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:56:24 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7994A171C
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:23 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6a60630574aso2625191a34.1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682178982; x=1684770982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+5kiv9CThmYX1c8Ys0tNuj3zbXq+D3JMAhVXyckyzw=;
        b=dR+XKByBCTZFzZ2eaCYWSLCaXzLo/UzGIkcHEZPtGlmxNa2e27mI3IXMfKlYLzNaJN
         SWKQaFPmjPs/1gglWw/ZLNN1hzLIyDTkbb2Isk6wwtNDPhE07pW+7o3BIYn5ubvoOymA
         sSGjbR7/DbHnQU1ez+7PrKbFD0uq43PLyxshYghIR7yMRKwwSlcsTZ3J0f3f1lUyCqBG
         uQGyrZM01U9dwZrEd08frmsz3R58eVXU+hM5YYM3Ps0oXhHHISONMi7Cx+kwqAYU4bXd
         RCPmVmnaSY+zs31rU/Qt5RFhFLzsIaax5ALv6kBY1Y8qUaWVl372ELF2DIU9xlCw16eO
         yE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682178982; x=1684770982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z+5kiv9CThmYX1c8Ys0tNuj3zbXq+D3JMAhVXyckyzw=;
        b=hONiWKBIk93WBdqMmJn8hnR9iQHkJEhoNmd1Fz+MLcF8pp//pwxkndFP9VoDU+5biI
         Cn6uvRGzYYwavYdS3YgDOg4byLwkGVfUbo5LnRlVX+0sfso1/cWl6Nz3oIkUbXRmMgIx
         roFQwOCxRuSRQqcWDS7RVpo+jNRONzoobAZurHGknzlhoieZk5uawsqQvnpEUX66fE63
         AG+AKs4EsDqPLaJf7cVfawXK1XyyZ3QTUE47xORemJ89qhRhpVIE6X5YuGXVAxFt+bOM
         AWY5LAk4Y+lGQWB+KolEcqwYYeIR97Q5xLY6zpdY1Rz+46iX9J04Kj47+MA7b44+/r2l
         TShw==
X-Gm-Message-State: AAQBX9eKV85orM1b3uU1GdLHvqRHGbBI8m/804U0SSAr5FuiNbQ9k4Vq
        Bujz6poYaNqGsHNrypdKxl0aj7wbUGMMG6j9T2E=
X-Google-Smtp-Source: AKy350aVsFZJYGZGiNlXbtCSSmZEUD8Uf66XUvYWkC1UTFeqTgmfqn+NR1dOso70hmNYFQxC8OmPCw==
X-Received: by 2002:a9d:7ac5:0:b0:6a4:2e3a:6e29 with SMTP id m5-20020a9d7ac5000000b006a42e3a6e29mr4809171otn.24.1682178982697;
        Sat, 22 Apr 2023 08:56:22 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:da55:60e0:8cc2:c48e])
        by smtp.gmail.com with ESMTPSA id v1-20020a05683018c100b006a32eb9e0dfsm2818255ote.67.2023.04.22.08.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 08:56:22 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 0/4] net/sched: cleanup parsing prints in htb and qfq
Date:   Sat, 22 Apr 2023 12:56:08 -0300
Message-Id: <20230422155612.432913-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two qdiscs are still using prints on dmesg to report parsing
errors. Since the parsing code has access to extack, convert these error
messages to extack.

QFQ also had the opportunity to remove some redundant code in the
parameters parsing by transforming some attributes into parsing
policies.

v4->v5: Rebased
v3->v4: Drop 'BITification' as suggested by Eric
v2->v3: Address suggestions by Jakub and Simon
v1->v2: Address suggestions by Jakub

Pedro Tammela (4):
  net/sched: sch_htb: use extack on errors messages
  net/sched: sch_qfq: use extack on errors messages
  net/sched: sch_qfq: refactor parsing of netlink parameters
  selftests: tc-testing: add more tests for sch_qfq

 net/sched/sch_htb.c                           | 17 ++---
 net/sched/sch_qfq.c                           | 34 +++++----
 .../tc-testing/tc-tests/qdiscs/qfq.json       | 72 +++++++++++++++++++
 3 files changed, 97 insertions(+), 26 deletions(-)

-- 
2.34.1

