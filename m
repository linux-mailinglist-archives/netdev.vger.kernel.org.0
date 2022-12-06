Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E46443BB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiLFM7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiLFM7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:59:00 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87127103B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:58:40 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1445ca00781so10690603fac.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 04:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AXABF6GahJ5uOpVbSZV8u0ecAMpQJGAQnzmKRSLwYEk=;
        b=ex1EdoqiAJc4tjbN/Tz4YyF0KO4oTAn7mgHjIfTRRnHA1cVzEGSK/B9ir+AJCaNP1Q
         X4M0OHzPhyNPJPBglGSE9QXE+igy80R/4T4mz3yZQLdKvMQWYb3ps/pYH5Bbwju/xUNS
         wADteRoHzPRm+wrUC61NhyIYyLJeYZ7DjWMvSkJE2xvsVph2OX0N0lqU7FK7F1ZwtVPx
         A99MQ7aHbn5HFaB3qlY7UnnnYKp93QPqs7z9p5gxldpVyi/Dqx1U6BpTT2f1AqftNvbD
         yLK7lHQsyobd9mdGp513JF3Bd6FP53MQwABbDuaK/PI9bM83FAWYygTQOsox2PaIkDVr
         LhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AXABF6GahJ5uOpVbSZV8u0ecAMpQJGAQnzmKRSLwYEk=;
        b=ej+HpQo2SEAAPSprsKFOVJbFj3Eq9izSKk+4WWwaGOAlMThJ9FKNWLLzzIlJI8Kgbd
         u4QXSdDhYVtgjNgTuBbJhnq+WvPanRRQXPiA+TPoL94l1ct8nLHMC/nYNAFr+TpkMMVg
         QiTyiZ0nFF73Lo8qL3LGENuObk3l6JvSng0Idg8tNNq8nYPqAkVJRFVMKGkpPF/aD6Xs
         RGOE2X000PVvAxHYW/ix/QszUbzy1cBdoysptRXFPP3hVOx0WQ7souvd5M39YjcRZg4t
         4QzxO+/PArs862vldWELy+2AKHOLMXt+qLSkkaam+L9o3WJry/7x5jiJVp/FkaMD1RUc
         3IDw==
X-Gm-Message-State: ANoB5pnL3UEgf7jgVwWCwxglU8Vl3oa1wPQboQO+jZsEkkj+3GLK8JAb
        hQ+f2mcAmEL2Yk+3WD/Oz/HCbVwlHPJ5gK8k
X-Google-Smtp-Source: AA0mqf40eH9/qycqllTU3A9EOqnVU51GRG5wJLyI7Y9tymEtPGy6GiT1U1rr37aJI/qSh0SwKL+OOQ==
X-Received: by 2002:a05:6870:9a08:b0:144:af5:915a with SMTP id fo8-20020a0568709a0800b001440af5915amr15510583oab.115.1670331519626;
        Tue, 06 Dec 2022 04:58:39 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:6544:c4a9:5a4c:3545])
        by smtp.gmail.com with ESMTPSA id cm5-20020a056830650500b0066b9a6bf3bcsm8944770otb.12.2022.12.06.04.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:58:39 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 0/4] net/sched: retpoline wrappers for tc
Date:   Tue,  6 Dec 2022 09:58:23 -0300
Message-Id: <20221206125827.1832477-1-pctammela@mojatatu.com>
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

We measured these changes in one AMD Zen 4 cpu (Retpoline), one AMD Zen 3 cpu (Retpoline),
one Intel 10th Gen CPU (IBRS), one Intel 3rd Gen cpu (Retpoline) and one
Intel Xeon CPU (IBRS) using pktgen with 64b udp packets. Our test setup is a
dummy device with clsact and matchall in a kernel compiled with every
tc module as built-in.  We observed a 3-8% speed up on the retpoline CPUs,
when going through 1 tc filter, and a 60-100% speed up when going through 100 filters.
For the IBRS cpus we observed a 1-2% degradation in both scenarios, we believe
the extra branches check introduced a small overhead therefore we added
a static key that bypasses the wrapper on kernels not using the retpoline mitigation,
but compiled with CONFIG_RETPOLINE.

1 filter:
CPU        | before (pps) | after (pps) | diff
R9 7950X   | 5914980      | 6380227     | +7.8%
R9 5950X   | 4237838      | 4412241     | +4.1%
R9 5950X   | 4265287      | 4413757     | +3.4%   [*]
i5-3337U   | 1580565      | 1682406     | +6.4%
i5-10210U  | 3006074      | 3006857     | +0.0%
i5-10210U  | 3160245      | 3179945     | +0.6%   [*]
Xeon 6230R | 3196906      | 3197059     | +0.0%
Xeon 6230R | 3190392      | 3196153     | +0.01%  [*]

100 filters:
CPU        | before (pps) | after (pps) | diff
R9 7950X   | 373598       | 820396      | +119.59%
R9 5950X   | 313469       | 633303      | +102.03%
R9 5950X   | 313797       | 633150      | +101.77% [*]
i5-3337U   | 127454       | 211210      | +65.71%
i5-10210U  | 389259       | 381765      | -1.9%
i5-10210U  | 408812       | 412730      | +0.9%    [*]
Xeon 6230R | 415420       | 406612      | -2.1%
Xeon 6230R | 416705       | 405869      | -2.6%    [*]

[*] In these tests we ran pktgen with clone set to 1000.

On the 7950x system we also tested the impact of filters if iteration order
placement varied, first by compiling a kernel with the filter under test being
the first one in the static iteration and then repeating it with being last (of 15 classifiers existing today).
We saw a difference of +0.5-1% in pps between being the first in the iteration vs being the last.
Therefore we order the classifiers and actions according to relevance per our current thinking.

v4->v5:
- Rebase

v3->v4:
- Address Eric Dumazet suggestions

v2->v3:
- Address suggestions by Jakub, Paolo and Eric
- Dropped RFC tag (I forgot to add it on v2)

v1->v2:
- Fix build errors found by the bots
- Address Kuniyuki Iwashima suggestions


Pedro Tammela (4):
  net/sched: move struct action_ops definition out of ifdef
  net/sched: add retpoline wrapper for tc
  net/sched: avoid indirect act functions on retpoline kernels
  net/sched: avoid indirect classify functions on retpoline kernels

 include/net/act_api.h      |  10 +-
 include/net/tc_wrapper.h   | 250 +++++++++++++++++++++++++++++++++++++
 net/sched/act_api.c        |   5 +-
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
 net/sched/cls_api.c        |   5 +-
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
 37 files changed, 389 insertions(+), 72 deletions(-)
 create mode 100644 include/net/tc_wrapper.h

-- 
2.34.1

