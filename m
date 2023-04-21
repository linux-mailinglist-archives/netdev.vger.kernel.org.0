Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B43A6EB13A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjDURyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjDURyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:54:08 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B16F1736
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:07 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6a5dd2558a1so967575a34.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682099646; x=1684691646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ek17iB6M54WUSBig3QTU4AT2mpN4QVQPKox6I2E9Kr0=;
        b=eAmOoHrQ1lq0M5KhX73QYvAI7i08SvPwDkPKjZbluldbo+u0rrCJ1J3rTuy/NmdOf3
         /5fGednzoE5jo8Hedew9v5D4jZok8ygSpSHEcLTwlQUr3gvtAr6ReQt1MWz1lxh1PYjV
         5lgRJ7PatvjASEc7Gro2ITgmM/NbCs10NCYG2KwCvuMqXjQ0X46T56NOxA9eVjUVoWq4
         0BJHALj2JRmm2tIDt9jj8fWuSKrh8EHZm2mDEQS59yne66fUP+Soqj+udjiQ3+M2w4C+
         chAMlmjjCu+hzB5V+/cWx9qMuRJ58JfCQAKrFtrhZ0EoyZ/tNF+gQz3otelCGwnQL0Zw
         OJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682099646; x=1684691646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ek17iB6M54WUSBig3QTU4AT2mpN4QVQPKox6I2E9Kr0=;
        b=SGTEhazFXBo/owqDESOx0FeNHsnQnnbkTaRLCOSO/r6LW3W2O06oILNokccXYROzV3
         pMhRe3XYwINQmgISdMYLAOFtEtY+gqGGDjV9O/DopT4UcvuV9mxQhowroy3pzdkm0SGA
         j5kHdwmucHAKJa0kH4TNm7v/Qddqa0SuspMfX4+oT/du2ZXW1gD+tJ7XKOnJJq4+SQnJ
         zMp+oT82qUlYXDnhOmSZz20TkAwer2as/MKgcI2IjFSM2jDDd5sknfdvukQXVdS7qhf8
         62Vcyc/3agpdKP1O4UUeu+g2gjNY4Glwrni9bSbUDcuaDUqITgvaiqlM804NRssHziSu
         lq8g==
X-Gm-Message-State: AAQBX9diOaqgdwNL7g22feg9TFW/J1G3iz+OjY5CvBm3j5m0D82fT7Ze
        yRoR6u/bW4k2GbWhxKUP0y2Gpr1NIg7yZYSmGag=
X-Google-Smtp-Source: AKy350YrBpubjojhj+HfUsLtREUJqHEqH9FI1Rvgi3nvt8J+5dX6QZlrm3SnTl5FJuCi72oC9XNHfQ==
X-Received: by 2002:a9d:6c0c:0:b0:6a6:814:609c with SMTP id f12-20020a9d6c0c000000b006a60814609cmr3121579otq.5.1682099646537;
        Fri, 21 Apr 2023 10:54:06 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id e3-20020a9d5603000000b006a633d75310sm850426oti.16.2023.04.21.10.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 10:54:06 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 0/4] net/sched: cleanup parsing prints in htb and qfq
Date:   Fri, 21 Apr 2023 14:53:40 -0300
Message-Id: <20230421175344.299496-1-pctammela@mojatatu.com>
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

v3->v4: Drop 'BITification' as suggested by Eric
v2->v3: Address suggestions by Jakub and Simon
v1->v2: Address suggestions by Jakub

Pedro Tammela (4):
  net/sched: sch_htb: use extack on errors messages
  net/sched: sch_qfq: use extack on errors messages
  net/sched: sch_qfq: refactor parsing of netlink parameters
  selftests: tc-testing: add more tests for sch_qfq

 net/sched/sch_htb.c                           | 17 ++---
 net/sched/sch_qfq.c                           | 37 +++++-----
 .../tc-testing/tc-tests/qdiscs/qfq.json       | 72 +++++++++++++++++++
 3 files changed, 99 insertions(+), 27 deletions(-)

-- 
2.34.1

