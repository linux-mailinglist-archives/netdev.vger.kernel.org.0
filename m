Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7ABC69655E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjBNNvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjBNNu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:50:57 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1965DBB9E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:50:28 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id g8so17349561qtq.13
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kcrSYMXirs/Q7Pma3g2KBbNLjiTzW4KQvdMqdIATNZA=;
        b=FLc8Z0iDCvsQpUCpPKLwcKTy/h8rGr5HIxv5D6z9JWYhFGW1Mf1GDZLzme0NSsYa3Z
         SL8JTDRuTPSOEOFIMGThkfpxjbrKsDXlcsvj5cVmeJspPAvp1q/NNbu838RUuYz6po3a
         RXEAFHHFthwiNBJexPNWVL/Z6YvKmknwm3W3WnZ13DPFPv4JL9Lbm9Zbtol77rKczd2n
         NCNX3+FEirHnoaCBaY/FRZrhoruXfWkIWf1YOjGaYlQbgZLfcDhvV37zAtfeiOJZMtUK
         wH1Oqj5qex84QVdaOg0dkxxLhb7Sro8spgdar2/ezk6ZpeylrtgYJN3HCzU/eUKXrfJt
         tTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcrSYMXirs/Q7Pma3g2KBbNLjiTzW4KQvdMqdIATNZA=;
        b=ys82ZcBMhVd99tqNQgZga2LMr/91yoa3fM7R6i5kY9KUeNjlNL6v73kNx9kJPWKL+9
         GLdDRIbseAXiYC81M0QNV/wyxnFZM4FczLhtSgcjGmzquXRLrjamw2Fyj5WjsKrVnAAX
         CGy+Gc7AfxULVl4SuRD0Cbhmx1XcEGtjP1UpMi5qCEELVWQG2BLN/yeQCXzL4dXAew3Q
         RhAcfJUxtsPQ38BDAJPXqzTUfuziLXvtixYUtzwzAdRqCUEXz5kbL6wgYLcHBWwFozhx
         PtRjmQg66A9/zVnkR/BTuHQ/7ghZRuECjlnq4/isAnh5Zuu+ivawvYBYU9L1ol2H1jpV
         h+mg==
X-Gm-Message-State: AO0yUKU1qyWJfzc7kH0PIlUn3mpnY62j7ndmRhzvaYKc9tJSQL/KzCQP
        UnbG6cgpRxbcmWGu/FjLAa5Zocfu1luypmog
X-Google-Smtp-Source: AK7set8PfbOTEnofZ0PqSxRt1Ydbon9DI2wfBmKDEvs2mRo83VvL2nhEvu5X7t+ykpKPghswPQO2yg==
X-Received: by 2002:a05:622a:1994:b0:3b9:bf7f:66ff with SMTP id u20-20020a05622a199400b003b9bf7f66ffmr3467300qtc.67.1676382561216;
        Tue, 14 Feb 2023 05:49:21 -0800 (PST)
Received: from localhost.localdomain ([142.181.246.182])
        by smtp.gmail.com with ESMTPSA id fg10-20020a05622a580a00b003b63238615fsm11512110qtb.46.2023.02.14.05.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 05:49:20 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        stephen@networkplumber.org, dsahern@gmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and classifiers
Date:   Tue, 14 Feb 2023 08:49:10 -0500
Message-Id: <20230214134915.199004-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CBQ + dsmark qdiscs and the tcindex + rsvp classifiers have served us for
over 2 decades. Unfortunately, they have not been getting much attention due
to reduced usage. While we dont have a good metric for tabulating how much use
a specific kernel feature gets, for these specific features we observed that
some of the functionality has been broken for some time and no users complained.
In addition, syzkaller has been going to town on most of these and finding
issues; and while we have been fixing those issues, at times it becomes obvious
that we would need to perform bigger surgeries to resolve things found while
getting a syzkaller fix in place. After some discussion we feel that in order
to reduce the maintenance burden it is best to retire them.

This patchset leaves the UAPI alone. I could send another version which deletes
the UAPI as well. AFAIK, this has not been done before - so it wasnt clear what
how to handle UAPI. It seems legit to just delete it but we would need to
coordinate with iproute2 (given they sync up with kernel uapi headers). There
are probably other users we don't know of that copy kernel headers.
If folks feel differently I will resend the patches deleting UAPI for these
qdiscs and classifiers.

I will start another thread on iproute2 before sending any patches to iproute2.

Jamal Hadi Salim (5):
  net/sched: Retire CBQ qdisc
  net/sched: Retire ATM qdisc
  net/sched: Retire dsmark qdisc
  net/sched: Retire tcindex classifier
  net/sched: Retire rsvp classifier

 include/net/tc_wrapper.h                      |   15 -
 net/sched/Kconfig                             |   81 -
 net/sched/Makefile                            |    6 -
 net/sched/cls_rsvp.c                          |   26 -
 net/sched/cls_rsvp.h                          |  764 --------
 net/sched/cls_rsvp6.c                         |   26 -
 net/sched/cls_tcindex.c                       |  716 -------
 net/sched/sch_atm.c                           |  706 -------
 net/sched/sch_cbq.c                           | 1727 -----------------
 net/sched/sch_dsmark.c                        |  518 -----
 .../tc-testing/tc-tests/filters/rsvp.json     |  203 --
 .../tc-testing/tc-tests/filters/tcindex.json  |  227 ---
 .../tc-testing/tc-tests/qdiscs/atm.json       |   94 -
 .../tc-testing/tc-tests/qdiscs/cbq.json       |  184 --
 .../tc-testing/tc-tests/qdiscs/dsmark.json    |  140 --
 15 files changed, 5433 deletions(-)
 delete mode 100644 net/sched/cls_rsvp.c
 delete mode 100644 net/sched/cls_rsvp.h
 delete mode 100644 net/sched/cls_rsvp6.c
 delete mode 100644 net/sched/cls_tcindex.c
 delete mode 100644 net/sched/sch_atm.c
 delete mode 100644 net/sched/sch_cbq.c
 delete mode 100644 net/sched/sch_dsmark.c
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/rsvp.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/atm.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/dsmark.json

-- 
2.34.1

