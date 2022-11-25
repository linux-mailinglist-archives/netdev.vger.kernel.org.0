Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29E2638F56
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiKYRwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKYRwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:52:35 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C2C10D5
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:52:32 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1433ef3b61fso5906723fac.10
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FGqHMepnRV/zsTIwnNjU+rrqQbn4zQ/yRsy6ha/dfKc=;
        b=OhraSyOyUhOwpGIBkiYekujbggbbfFwgQwEsC9L4NIULgJI3qjCCr6YNzLzs9DvFfz
         Ql4nZprb/Z0qbSCCQpXmzToc38wJos01o+/ofhIf1CsVBrMI6WfYGGOiLiTmMvJGeZFH
         hHT8r8oNq1Ej021b9QScTkZFEx8J5saTGDL+cczOQdjxDaDkQVcCKA/3vOdYV+ofBJiB
         ZTxarUMZCe2XClfkwLOvz29Fj2uE2MNeCtQkigOfikPuDDn5RfaivyzWchaa7mDIyUW8
         LEmB3KHRdz2BhMTRD7ccK16dBNYiGIymFIkVkf5mxeZdLhRj7piG+uvPRfZK8zdN3gjA
         dmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FGqHMepnRV/zsTIwnNjU+rrqQbn4zQ/yRsy6ha/dfKc=;
        b=qI1ILr2NjDsqK03iZmQ1ax3uDP1rEhcZZ6dRcvpNIzxOnpS21fJ6P9jZGQ7fSMUbg+
         7+7nb4CTFrL85za/d704eWSrwAHNPG2FLwBdiRRqKv/f94u1fMnaL2H9Y6imsJ9KuIk3
         XPUycyKzyxjS6uCQMvX53YO8U8kEZW2KET1ZheL1nlcSt8nEN5iDQu2Lt/nmgLlAmvfq
         p7vKFYeXRwpD60nmvPBO2FRfeaFJo8o9SnndB5IRfZlIWbuat876OrnJczgZzdOFSDrJ
         xYmv43aWx7CzFH+oQcmsuu/RDA5IGKT7hLQFXJvXf1rfZLBAG+l+u72OQzTWNzUP1rxB
         BjrA==
X-Gm-Message-State: ANoB5pmTwoLu/GDTPSeAIvkBQLW0JsJIXcv1Isgd3PXSl7VA5UPkfUmc
        h/o7TdzNmUJXPeK4s5BUMuMPnxRlqrzKZmi+
X-Google-Smtp-Source: AA0mqf7u08MJv7QEFUAOSPyNyO5Lpm6voHmXGEsq1g9CvtF9Mq9U35vHznqompa2g+zSHEmsgCg9aw==
X-Received: by 2002:a05:6870:41c9:b0:142:6216:64bd with SMTP id z9-20020a05687041c900b00142621664bdmr12684312oac.232.1669398751303;
        Fri, 25 Nov 2022 09:52:31 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:e90:8a20:11c9:921b])
        by smtp.gmail.com with ESMTPSA id j44-20020a4a946f000000b0049fcedf1899sm1771570ooi.3.2022.11.25.09.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:52:30 -0800 (PST)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH RFC net-next 0/3] net/sched: retpoline wrappers for tc
Date:   Fri, 25 Nov 2022 14:52:04 -0300
Message-Id: <20221125175207.473866-1-pctammela@mojatatu.com>
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
We observed a 6-10% speed up on the retpoline CPUs, when going through 1
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

Pedro Tammela (3):
  net/sched: add retpoline wrapper for tc
  net/sched: avoid indirect act functions on retpoline kernels
  net/sched: avoid indirect classify functions on retpoline kernels

 include/net/tc_wrapper.h   | 274 +++++++++++++++++++++++++++++++++++++
 net/sched/Kconfig          |  13 ++
 net/sched/act_api.c        |   3 +-
 net/sched/act_bpf.c        |   6 +-
 net/sched/act_connmark.c   |   6 +-
 net/sched/act_csum.c       |   6 +-
 net/sched/act_ct.c         |   4 +-
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
 net/sched/cls_rsvp.h       |   7 +-
 net/sched/cls_rsvp6.c      |   2 +
 net/sched/cls_tcindex.c    |   7 +-
 net/sched/cls_u32.c        |   6 +-
 37 files changed, 417 insertions(+), 67 deletions(-)
 create mode 100644 include/net/tc_wrapper.h

-- 
2.34.1

