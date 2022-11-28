Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571AC63ACD8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiK1Ppm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiK1Ppi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:45:38 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A391DA61
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:45:36 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q83so11964976oib.10
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4X8A53ulORBnCcwMhZUUP9R/rJfZDI3pek+o+9DmJvY=;
        b=RJNo45GcFHh7U6+GdAfH6LhVsvArypn3hZoJxgsXdPu07tmxzq6Osw4Q+7zJNqqA+9
         S/Nps2SmU/ubFSvDIjqHuXTDlJB5nGljD7sQxvVRpgYa2Rt3Tgko0uiFyhrjgsBGb+1t
         7Xaeu+VLJ7DSNJ4DzfPvJSwMcWj+sQEe9H30rfDBbLWeLlqM2u5YWesThSgBSH2GlUrB
         mIVnBIwOl7rrGXuAFHMvDzM9Nw4XvdGrVRzNUAXc0BA+dCgx1mKmKArQh4iVj6N3LP6y
         XH70EloTEOsnRWHCLKytB3ew4ZJKQnPBEd+mp+95bkxHleNzBRAj0yh2ouLrfquZXaK7
         ESxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4X8A53ulORBnCcwMhZUUP9R/rJfZDI3pek+o+9DmJvY=;
        b=rWR+/R6C6wHK97MmQgYRvKi1FJyDWP3io5xwJhej2LXjIyKEbkToL826fTimyKBlcD
         vTgs4F8iMCxZjhkjgUOn7XT/3uuQ+MyzdPZmLfYKFAZJ1d8X2/qSn4dQm/CEUcef9Tyw
         IeI3kCYC7GtVmni3hivcrq5r5yb1NewngHR4aSZ523e5fg9YoN2BWQi/fGw71Pn6PVy2
         I5BhVf2mxN7HCUNRCryfX5ItB1vQeOOTzU//wtQefnS3KHMdIJUfsQY4xEMKtSON4TZN
         u1Xwm3zpQuH1wXkfDjzy8exMhOdZCxU6eAdcjfcGCoAuhhhJmv1QjRihMR1KMk9DIbEY
         +raQ==
X-Gm-Message-State: ANoB5pmleU3n8dFG+BuVo++NNL1DQPy6eXw++84MsekzcKnYa86f+mgA
        Wflrjgu9w9VTrAsxwSOD9Q1PsTTpg/cWmA==
X-Google-Smtp-Source: AA0mqf6dKPfnI/d+HAS9NI2wSLoH9qVQKSxufauNnKfcU1Qot/4NxhP/pQ0atOCXq+UuBr/4otIl7Q==
X-Received: by 2002:aca:ba83:0:b0:35a:1d11:dd37 with SMTP id k125-20020acaba83000000b0035a1d11dd37mr15991825oif.208.1669650335800;
        Mon, 28 Nov 2022 07:45:35 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:562:c37c:87b7:acb4])
        by smtp.gmail.com with ESMTPSA id bx19-20020a056830601300b0066c55e23a16sm4885012otb.2.2022.11.28.07.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 07:45:35 -0800 (PST)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 0/3] net/sched: retpoline wrappers for tc
Date:   Mon, 28 Nov 2022 12:44:53 -0300
Message-Id: <20221128154456.689326-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
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

In tc all qdics, classifiers and actions can be compiled as modules.
This results today in indirect calls in all transitions in the tc hierarchy.
Due to CONFIG_RETPOLINE, CPUs with mitigations=on might pay an extra cost on
indirect calls. For newer Intel cpus with IBRS the extra cost is
nonexistent, but AMD Zen cpus and older x86 cpus still go through the
retpoline thunk.

Known built-in symbols can be optimized into direct calls, thus
avoiding the retpoline thunk. So far, tc has not been leveraging this
build information and leaving out a performance optimization for some
CPUs. In this series we wire up 'tcf_classify()' and 'tcf_action_exec()'
with direct calls when known modules are compiled as built-in as an
opt-in optimization.

We measured these changes in one AMD Zen 3 cpu (Retpoline), one Intel 10th
Gen CPU (IBRS), one Intel 3rd Gen cpu (Retpoline) and one Intel Xeon CPU (IBRS)
using pktgen with 64b udp packets. Our test setup is a dummy device with
clsact and matchall in a kernel compiled with every tc module as built-in.
We observed a 3-6% speed up on the retpoline CPUs, when going through 1
tc filter, and a 60-100% speed up when going through 100 filters.
For the IBRS cpus we observed a 1-2% degradation in both scenarios, we believe
the extra branches checks introduced a small overhead therefore we added
a Kconfig option to make these changes opt-in even in CONFIG_RETPOLINE kernels.

We are continuing to test on other hardware variants as we find them:

1 filter:
CPU        | before (pps) | after (pps) | diff
R9 5950X   | 4237838      | 4412241     | +4.1%
R9 5950X   | 4265287      | 4413757     | +3.4%   [*]
i5-3337U   | 1580565      | 1682406     | +6.4%
i5-10210U  | 3006074      | 3006857     | +0.0%
i5-10210U  | 3160245      | 3179945     | +0.6%   [*]
Xeon 6230R | 3196906      | 3197059     | +0.0%
Xeon 6230R | 3190392      | 3196153     | +0.01%  [*]

100 filters:
CPU        | before (pps) | after (pps) | diff
R9 5950X   | 313469       | 633303      | +102.03%
R9 5950X   | 313797       | 633150      | +101.77% [*]
i5-3337U   | 127454       | 211210      | +65.71%
i5-10210U  | 389259       | 381765      | -1.9%
i5-10210U  | 408812       | 412730      | +0.9%    [*]
Xeon 6230R | 415420       | 406612      | -2.1%
Xeon 6230R | 416705       | 405869      | -2.6%    [*]

[*] In these tests we ran pktgen with clone set to 1000.

v1->v2:
- Fix build errors found by the bots
- Address Kuniyuki Iwashima suggestions

Pedro Tammela (3):
  net/sched: add retpoline wrapper for tc
  net/sched: avoid indirect act functions on retpoline kernels
  net/sched: avoid indirect classify functions on retpoline kernels

 include/net/tc_wrapper.h   | 232 +++++++++++++++++++++++++++++++++++++
 net/sched/Kconfig          |  13 +++
 net/sched/act_api.c        |   3 +-
 net/sched/act_bpf.c        |   6 +-
 net/sched/act_connmark.c   |   6 +-
 net/sched/act_csum.c       |   6 +-
 net/sched/act_ct.c         |   5 +-
 net/sched/act_ctinfo.c     |   6 +-
 net/sched/act_gact.c       |   6 +-
 net/sched/act_gate.c       |   6 +-
 net/sched/act_ife.c        |   6 +-
 net/sched/act_ipt.c        |   6 +-
 net/sched/act_mirred.c     |   6 +-
 net/sched/act_mpls.c       |   6 +-
 net/sched/act_nat.c        |   7 +-
 net/sched/act_pedit.c      |   6 +-
 net/sched/act_police.c     |   6 +-
 net/sched/act_sample.c     |   6 +-
 net/sched/act_simple.c     |   6 +-
 net/sched/act_skbedit.c    |   6 +-
 net/sched/act_skbmod.c     |   6 +-
 net/sched/act_tunnel_key.c |   6 +-
 net/sched/act_vlan.c       |   6 +-
 net/sched/cls_api.c        |   3 +-
 net/sched/cls_basic.c      |   6 +-
 net/sched/cls_bpf.c        |   6 +-
 net/sched/cls_cgroup.c     |   6 +-
 net/sched/cls_flow.c       |   6 +-
 net/sched/cls_flower.c     |   6 +-
 net/sched/cls_fw.c         |   6 +-
 net/sched/cls_matchall.c   |   6 +-
 net/sched/cls_route.c      |   6 +-
 net/sched/cls_rsvp.c       |   2 +
 net/sched/cls_rsvp.h       |   6 +-
 net/sched/cls_rsvp6.c      |   2 +
 net/sched/cls_tcindex.c    |   7 +-
 net/sched/cls_u32.c        |   6 +-
 37 files changed, 375 insertions(+), 67 deletions(-)
 create mode 100644 include/net/tc_wrapper.h

-- 
2.34.1

