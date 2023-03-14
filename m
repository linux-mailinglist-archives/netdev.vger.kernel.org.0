Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA406B8B94
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCNG6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCNG6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:58:43 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318175616C
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:58:42 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id ce7so9064083pfb.9
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678777121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6h3vj+sRxRiXdxfLFzJp8oSMU2miRQBhSNGDwjqvmhM=;
        b=iEdO7X+mTxHUmrHGOINo0+5eQ0EXjv5fzXeS0DMLede/joNLcJO95AY0Byr5VvwVtM
         dzyAHcqdoDcPf5daqEYTfGaeaHIqdRubuqQ+hfiB0EFUVCqko3b/bMAZFy2oeVsTSMzK
         aTYkuc8CssOOJ/lOJf5OjxDgZBdutJcthImXTeNUt5MeT75XBsZoZrhuI0+JxJ67MjLK
         R1E3NZOQJN6XQ2s1SBDIg2D416lYRx5R2uiGkEcrsMzO9GiYJ7VPVZpzuyOaCAHrZdEQ
         CW1HqsiYAiSIx0kAdDSIFGnrm3+GVRufC4SIsyqspptD2UaGWT/wdFVdGpeyz5WD+JK7
         Uxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678777121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6h3vj+sRxRiXdxfLFzJp8oSMU2miRQBhSNGDwjqvmhM=;
        b=noUs9/6EX7K2+glwccCmD9kIWLDm0RZ0gUXL50OpVvdFA53Yd7E1KShMNW9NvxfkEJ
         z6/pv0yDIlw1pT+TiAj7CeDOb1+qIJboTDvKULcQVn3mir78m+aYQIfzlEN91OxwsMQt
         XYiQjPtkoeb5Tr0gz/0uNHaAlbJV60REsZS78IoBiuSFzGF357nlNuB9IF2HvbDmFJAO
         SbfhkaoKOccKNqMqcsqarcGWzc/q6NXmQKWhc0BDJwUeHNFmuYJQ9ylnfLfPOCbX65m2
         6A8QXbf3vfc8XXCkWAOi8uB2DDfzsUGzohB1EYVkyjzSqs1iPK1PuJrAYUwi4UbzuFyr
         9Yng==
X-Gm-Message-State: AO0yUKUzpmPn1q15YEmho9CmaQkSomuBu/E3Cv7c4zhnp1+lmSUbMmu/
        37s5eJ0skljKbbShFRFtfXvy/jCjUnOb8spT
X-Google-Smtp-Source: AK7set/SAFluwUx1w2jKGZYNnxJQ+Nxizo4ROw4kTfcxkYaus45MThRHhOlAQLtNRyCE4fppAaKqOg==
X-Received: by 2002:aa7:9607:0:b0:5e4:f700:f876 with SMTP id q7-20020aa79607000000b005e4f700f876mr31994107pfg.28.1678777121044;
        Mon, 13 Mar 2023 23:58:41 -0700 (PDT)
Received: from localhost.localdomain ([8.218.113.75])
        by smtp.gmail.com with ESMTPSA id j20-20020a62b614000000b005dae7d1b61asm808291pff.154.2023.03.13.23.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 23:58:40 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for tc action
Date:   Tue, 14 Mar 2023 14:58:00 +0800
Message-Id: <20230314065802.1532741-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
to report tc extact message") I didn't notice the tc action use different
enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.

Let's rever the previous fix 923b2e30dc9c ("net/sched: act_api: move
TCA_EXT_WARN_MSG to the correct hierarchy") and add a new
TCA_ACT_EXT_WARN_MSG for tc action specifically.

Here is the tdc test result:

1..1119
ok 1 d959 - Add cBPF action with valid bytecode
ok 2 f84a - Add cBPF action with invalid bytecode
ok 3 e939 - Add eBPF action with valid object-file
ok 4 282d - Add eBPF action with invalid object-file
ok 5 d819 - Replace cBPF bytecode and action control
ok 6 6ae3 - Delete cBPF action
ok 7 3e0d - List cBPF actions
ok 8 55ce - Flush BPF actions
ok 9 ccc3 - Add cBPF action with duplicate index
ok 10 89c7 - Add cBPF action with invalid index
[...]
ok 1115 2348 - Show TBF class
ok 1116 84a0 - Create TEQL with default setting
ok 1117 7734 - Create TEQL with multiple device
ok 1118 34a9 - Delete TEQL with valid handle
ok 1119 6289 - Show TEQL stats

Hangbin Liu (2):
  Revert "net/sched: act_api: move TCA_EXT_WARN_MSG to the correct
    hierarchy"
  net/sched: act_api: add specific EXT_WARN_MSG for tc action

 include/uapi/linux/rtnetlink.h | 1 +
 net/sched/act_api.c            | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.38.1

