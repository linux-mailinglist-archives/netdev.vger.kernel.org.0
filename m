Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958E363B152
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiK1Sbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiK1SbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:31:21 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C99EB51
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:26:44 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j196so14446844ybj.2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hrg3QkvwjAdRDqmvitVvxLjgPruGdgXxRmrfg+kNiw4=;
        b=ZF45eOfjgGbhKRdBYvn10a6SHeAzUtkaGX8V1L3sn1g1wLEpyt+U6JCp8o/9B4zfQ+
         MaQsFsfOBuhvUBFPjysMAG6uKUEwuQSoB2TS4zX8nRvF3BjaoS4ggOk30NybaTVfi1cA
         jDok9uvKNtUd7gVb2sDZoMzDALv90rL0eB+amSyXpcj+Ws9HEGn8gkjWTSckHrB1rcYV
         s0HZYQj6CGzoOdkiYYnpgrHZu5nP0tfaFw2fS3UfL8cte+tmBPWS5ChHFAzyctH1DDkG
         KGDmapGHhj/Q2yDhfNn/Q+idrzDfKtyPJBU0HL7ry+iGHR3u+KPosIHHyqkBa5U4bhA1
         qj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrg3QkvwjAdRDqmvitVvxLjgPruGdgXxRmrfg+kNiw4=;
        b=kbq5p1JTUQ/E+UFQkLfBbPhDlwZROdD4RJlOo8jpmTzEGWh4yJrEdk6CHTIvwVS83f
         qpWPFmfuKw21r/7RKgLQ+pAa/4wIgYM488uXUzdGQiZU8ZDTvZ23zNkLEz7uzapAyr4B
         m4gbyAXY6aNNNZCG6cVTf5nr6+3d5e0HUgJ+G2pv7J/zQk0yHALTs56WuqngdVb9fVaV
         uY4ipdMEyk7FbwsosZggLWVUaW8JV24rEW0hV7XXrUR5G9MjeVo7sznWWvCKc/+mn0no
         t4bbsjKoZLCTC3hlmRA29zC6zT9Lspin4yiLMZ98mAd3ZDLTdy5rbpcHYC51IH+bG6XV
         W3WA==
X-Gm-Message-State: ANoB5pk7DPOmwAhlY/OI24k/X3HxdEI2IIsg1RLw7WRTU25VZkw9znNF
        HmTDRTtbokRY3dFv3dDjmfvoulehFquGNgwZkWTUWy77zWg=
X-Google-Smtp-Source: AA0mqf4vk+jwLzncu2kS9xf/0x6W8CQcS/bnNXvvtN/5x0VPYRI/uBKdu5VpIFPJ+UUFYiGfaO/p7oY7fEYwMhoqZWY=
X-Received: by 2002:a25:2591:0:b0:6ee:c506:7338 with SMTP id
 l139-20020a252591000000b006eec5067338mr29487012ybl.509.1669660003744; Mon, 28
 Nov 2022 10:26:43 -0800 (PST)
MIME-Version: 1.0
References: <20221125175207.473866-1-pctammela@mojatatu.com>
In-Reply-To: <20221125175207.473866-1-pctammela@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 28 Nov 2022 13:26:32 -0500
Message-ID: <CAM0EoM=9CdeZoHnFDAGjtmm07B=QBrrTNzoZVWUXf6+1Y4LdYg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] net/sched: retpoline wrappers for tc
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You forgot to add the RFC tag. Also add my reviewed-by:

cheers,
jamal

On Fri, Nov 25, 2022 at 12:52 PM Pedro Tammela <pctammela@gmail.com> wrote:
>
> In tc all qdics, classifiers and actions can be compiled as modules.
> This results today in indirect calls in all transitions in the tc hierarchy.
> Due to CONFIG_RETPOLINE, CPUs with mitigations=on might pay an extra cost on
> indirect calls. For newer Intel cpus with IBRS the extra cost is
> nonexistent, but AMD Zen cpus and older x86 cpus still go through the
> retpoline thunk.
>
> Known built-in symbols can be optimized into direct calls, thus
> avoiding the retpoline thunk. So far, tc has not been leveraging this
> build information and leaving out a performance optimization for some
> CPUs. In this series we wire up 'tcf_classify()' and 'tcf_action_exec()'
> with direct calls when known modules are compiled as built-in as an
> opt-in optimization.
>
> We measured these changes in one AMD Zen 3 cpu (Retpoline), one Intel 10th
> Gen CPU (IBRS), one Intel 3rd Gen cpu (Retpoline) and one Intel Xeon CPU (IBRS)
> using pktgen with 64b udp packets. Our test setup is a dummy device with
> clsact and matchall in a kernel compiled with every tc module as built-in.
> We observed a 6-10% speed up on the retpoline CPUs, when going through 1
> tc filter, and a 60-100% speed up when going through 100 filters.
> For the IBRS cpus we observed a 1-2% degradation in both scenarios, we believe
> the extra branches checks introduced a small overhead therefore we added
> a Kconfig option to make these changes opt-in even in CONFIG_RETPOLINE kernels.
>
> We are continuing to test on other hardware variants as we find them:
>
> 1 filter:
> CPU        | before (pps) | after (pps) | diff
> R9 5950X   | 4237838      | 4412241     | +4.1%
> R9 5950X   | 4265287      | 4413757     | +3.4%   [*]
> i5-3337U   | 1580565      | 1682406     | +6.4%
> i5-10210U  | 3006074      | 3006857     | +0.0%
> i5-10210U  | 3160245      | 3179945     | +0.6%   [*]
> Xeon 6230R | 3196906      | 3197059     | +0.0%
> Xeon 6230R | 3190392      | 3196153     | +0.01%  [*]
>
> 100 filters:
> CPU        | before (pps) | after (pps) | diff
> R9 5950X   | 313469       | 633303      | +102.03%
> R9 5950X   | 313797       | 633150      | +101.77% [*]
> i5-3337U   | 127454       | 211210      | +65.71%
> i5-10210U  | 389259       | 381765      | -1.9%
> i5-10210U  | 408812       | 412730      | +0.9%    [*]
> Xeon 6230R | 415420       | 406612      | -2.1%
> Xeon 6230R | 416705       | 405869      | -2.6%    [*]
>
> [*] In these tests we ran pktgen with clone set to 1000.
>
> Pedro Tammela (3):
>   net/sched: add retpoline wrapper for tc
>   net/sched: avoid indirect act functions on retpoline kernels
>   net/sched: avoid indirect classify functions on retpoline kernels
>
>  include/net/tc_wrapper.h   | 274 +++++++++++++++++++++++++++++++++++++
>  net/sched/Kconfig          |  13 ++
>  net/sched/act_api.c        |   3 +-
>  net/sched/act_bpf.c        |   6 +-
>  net/sched/act_connmark.c   |   6 +-
>  net/sched/act_csum.c       |   6 +-
>  net/sched/act_ct.c         |   4 +-
>  net/sched/act_ctinfo.c     |   6 +-
>  net/sched/act_gact.c       |   6 +-
>  net/sched/act_gate.c       |   6 +-
>  net/sched/act_ife.c        |   6 +-
>  net/sched/act_ipt.c        |   6 +-
>  net/sched/act_mirred.c     |   6 +-
>  net/sched/act_mpls.c       |   6 +-
>  net/sched/act_nat.c        |   7 +-
>  net/sched/act_pedit.c      |   6 +-
>  net/sched/act_police.c     |   6 +-
>  net/sched/act_sample.c     |   6 +-
>  net/sched/act_simple.c     |   6 +-
>  net/sched/act_skbedit.c    |   6 +-
>  net/sched/act_skbmod.c     |   6 +-
>  net/sched/act_tunnel_key.c |   6 +-
>  net/sched/act_vlan.c       |   6 +-
>  net/sched/cls_api.c        |   3 +-
>  net/sched/cls_basic.c      |   6 +-
>  net/sched/cls_bpf.c        |   6 +-
>  net/sched/cls_cgroup.c     |   6 +-
>  net/sched/cls_flow.c       |   6 +-
>  net/sched/cls_flower.c     |   6 +-
>  net/sched/cls_fw.c         |   6 +-
>  net/sched/cls_matchall.c   |   6 +-
>  net/sched/cls_route.c      |   6 +-
>  net/sched/cls_rsvp.c       |   2 +
>  net/sched/cls_rsvp.h       |   7 +-
>  net/sched/cls_rsvp6.c      |   2 +
>  net/sched/cls_tcindex.c    |   7 +-
>  net/sched/cls_u32.c        |   6 +-
>  37 files changed, 417 insertions(+), 67 deletions(-)
>  create mode 100644 include/net/tc_wrapper.h
>
> --
> 2.34.1
>
