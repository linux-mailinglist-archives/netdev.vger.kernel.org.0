Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A0B6E4EE3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDQRMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDQRMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:12:34 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D56D6A7B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:33 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id k21-20020a9d4b95000000b006a5f3eeb94aso675062otf.10
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681751552; x=1684343552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YnRLJAzJTbnV9YGK3fHJy2Jvpb3ZXOTCjITXd8Zbw+E=;
        b=b14QLwNzj2miW75+IelsEHDA2RJiAk7Fou49yWxCqKsfzod/w8SkbLxLGELlG+pCtE
         z3iBfh798prwxFeckBRSb3OG6kBSEB5q8ahLF4pl4rBaGhIueeeJ+V1NgX4jdtVBraAg
         nlNAfONFPVb5Sk2/evsX6VHeHzDIsiSfWKOCNWKkGSX4B7rAnafJCL+Op/d3QCa1SqUA
         Vw5k9ikSSjw108/Kx5tgFEzEliFTLmyv1kpcwL5UlPg7ZF0LiXSlATmYXoiry4ZR0v4W
         BfeyKF2PhSvyZssLA3P+2U8i/mJZdjzVYt5fVsS+raRHl88ancRM0PjTB0sPj4HdQsnT
         AOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751552; x=1684343552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YnRLJAzJTbnV9YGK3fHJy2Jvpb3ZXOTCjITXd8Zbw+E=;
        b=dnNQ4JKT6sUOpM0bUfa1pzEBWm/brdBqMKP+nvTw3XhmDrR4S3n8U6oKj+wxyzjkJO
         GyKakEHCl9/OSkG/7GaSXS0rKaDwqF/l3kthp8oNgqvgm56w5CKe5yYSHl8JsCm9YEaw
         l8mrzZQkB26p/MskynGMZK14m1wTED8Cz2KyiOK7u/Z7V2QHgu9TaT+KfBpXmbNqC1Os
         ouv1tv/C2jbjVK0Q/oPMS1F62uxWHpsJEGZo/njLt/dL8HMqMxJsdfJmUHoY59uqaOWS
         kZ+XdLA7zH3vqXnJZvmQvNUFZuM/NXOLofgIvMG/vTUGM2A2tQ0aGI2LdG5vAeOXcTpB
         jYPQ==
X-Gm-Message-State: AAQBX9fwyzGyMUO9jgUB0E/emG0bAuEeY4HtOemWK96TkV88a7NROEKj
        Ah5m7L5dMFsiHo/dNacPEbf+Dar92B4ySPia3fg=
X-Google-Smtp-Source: AKy350bsbkR6NjsAonlXFc/sb5H7HlF+7A642Zdm4RhFsBCuSARl+sHzXTjlN+KmLz8fbbc5N0DO/A==
X-Received: by 2002:a05:6830:1d8c:b0:6a5:df4b:1d95 with SMTP id y12-20020a0568301d8c00b006a5df4b1d95mr2729201oti.8.1681751552471;
        Mon, 17 Apr 2023 10:12:32 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:150:be5b:9489:90ac])
        by smtp.gmail.com with ESMTPSA id v17-20020a9d5a11000000b006a205a8d5bdsm4761248oth.45.2023.04.17.10.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 10:12:32 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 0/4] net/sched: cleanup parsing prints in htb and qfq
Date:   Mon, 17 Apr 2023 14:12:14 -0300
Message-Id: <20230417171218.333567-1-pctammela@mojatatu.com>
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

