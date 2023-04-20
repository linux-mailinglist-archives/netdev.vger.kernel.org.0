Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA66E99E4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjDTQuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjDTQuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:50:08 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C7D40EE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:49:57 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6a5f8e1f6d1so468172a34.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682009396; x=1684601396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EDLH8jZHBeAwu5g8qPpcrh7WRnBfaVaCWyQrlzbmp80=;
        b=gOiSpYisAbd89nc3f30imdEfFADlAr5BqXq1Qhisw2aZmLjtl1iiA4/TTWiqIWff8S
         UoiwaXUAFQXf00PhT8D5LdxIWu9IKIOUv4S1LQuahP+19qID0ZovCfbwOdVmqDUEzdEe
         mV+yqgS4DS3cuI8Iu8pRihhcUy5ZLasTG3m162FOt68j8rmicz8y4QGBqamKly9x/yPp
         QwZCrvxNc3aASYP2dD6zFMMwHxwxdOn/udVrrlEXq61ujwaUaVQvrB0aiMSDN63ku3Xu
         sxPBzQSU9guTciscrPcestiMaiq55OU7upvhMP0PJ/eC13muN/O3jBVIwXzE/qqMWNEK
         kp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009396; x=1684601396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EDLH8jZHBeAwu5g8qPpcrh7WRnBfaVaCWyQrlzbmp80=;
        b=AohbI45crtJKa7ZoWp/C/+l1azIY4nfThh7gAYrYVP08daLmGfhEXNfGrnood0PCEk
         Epvs79yZmBgW/eWDzp32yv5RjTkMOH+Zwuvocc3zBCZ2iavZlc9n55E4huBsKo7Si8wf
         BtjQiwUrZLpC8/QHipMvH1HWd9KR96QyrMmvMq3HSxCkc41AxD84GpfM+bGjWZeYsnl1
         rICSghEsJjvciCw7xVn4BNKXUVlDL/L1OS2e/i5nMTCBkV32aMU2Eh895sxrEeeo5Wm9
         d0IQGR/aEru30GeP+St1yt/qXlhyhkiJNZlxr4oH5n6V8qV0DzBL12lQXEGwhG80/bHJ
         +8cw==
X-Gm-Message-State: AAQBX9eE3fpZRkFWgxj5tJ2VaWkFFdlqTclaQDSR7fEEbZMHTCw56yG9
        mu07jCn9d+M+/a+afGCfgohAnTPSyVFQPsByUf8=
X-Google-Smtp-Source: AKy350YIlLkJ3RhshJQqUlrbH38Dw4uAN9LhWQG4/bpIHTobE4aMui8W7k00RUB/gZGt2OxDgAWm6Q==
X-Received: by 2002:a9d:6f8a:0:b0:6a6:a14:21f3 with SMTP id h10-20020a9d6f8a000000b006a60a1421f3mr1003187otq.35.1682009396592;
        Thu, 20 Apr 2023 09:49:56 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id p26-20020a9d695a000000b006a13dd5c8a2sm894542oto.5.2023.04.20.09.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:49:56 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 0/5] net/sched: cleanup parsing prints in htb and qfq
Date:   Thu, 20 Apr 2023 13:49:23 -0300
Message-Id: <20230420164928.237235-1-pctammela@mojatatu.com>
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

v2->v3: Address suggestions by Jakub and Simon
v1->v2: Address suggestions by Jakub

Pedro Tammela (5):
  net/sched: sch_htb: use extack on errors messages
  net/sched: sch_qfq: use extack on errors messages
  net/sched: sch_qfq: refactor parsing of netlink parameters
  selftests: tc-testing: add more tests for sch_qfq
  net/sched: sch_qfq: BITify two bound definitions

 net/sched/sch_htb.c                           | 17 ++---
 net/sched/sch_qfq.c                           | 39 +++++-----
 .../tc-testing/tc-tests/qdiscs/qfq.json       | 72 +++++++++++++++++++
 3 files changed, 100 insertions(+), 28 deletions(-)

-- 
2.34.1

