Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5E44CE0F9
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiCDX31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCDX30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:29:26 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC205A159;
        Fri,  4 Mar 2022 15:28:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so8140145pju.2;
        Fri, 04 Mar 2022 15:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3jguvTkqKcEZ/HBhYmv9QpAb/I7YDZMEjZodZMyLC8=;
        b=iar2pwnu/4SGq1bOwgCA5BsuAbFsWSGCZWwY/RZK/QYc9Ox19ddZxrPNNvOSqgMXzs
         lrjAi1hZt9G9BedqYyCmMjmWUlU6eexr4pTH/cT7T1iAvJdAwT0n41OnuTeusYf5NVes
         rrar7DZ17ukPvRtj7QvBAin+SLTwUl4hCF9lVOC3SyEbOJX1/7ifE5Cz+n1Vn/7EWFsy
         ss8/kFCc59WeeTJHxGYBQ2HO875V1M8aThGdwaVitketQ7Yfd074/H8ceDJSB60b5krx
         LxTDAr4suGHwBgVemMutfqAO12jMou4glfH2qyAp6ymztKIMjdTOcAR0DWrtkUHiFkXX
         Jm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=B3jguvTkqKcEZ/HBhYmv9QpAb/I7YDZMEjZodZMyLC8=;
        b=dFHw3WIoiUTgsO9wm4zpGHNajiRgIJZ1wKe8yHAjST+Mkb5LuFI6RnAiamW5mUYJTi
         BdFvP4k+UMHrgAPtrcCh6Xwfh5zm2RgRn5A1fL4e5qdOLJruvRtbV7nTUuSVU6qqgTrr
         7PvaolmnLdY9fEDdJJD0QJTDkJfD9UAx265giRTejJNK6LOsfbHPz5gye1bB0lKYl7Bd
         up91KArHLzoDx+Z3FwlFBnBdcXIU96tHNAQMiQC90zSeWxwyBn+KJxjFkBE/KeY3Rq3C
         O8J53LTEblHrBV/ENW0LiV/n6lsqzfUSIPJJxn3pebV8lHTrfzD4GOAMxOktYUnNs8k8
         OmMA==
X-Gm-Message-State: AOAM5318qlbzv7D6nkLJxRuSy2N4SlLp95cZUJrMlwFYRUysHO3cKTqY
        ychcwzrt9JqwPIorjX+KYFk=
X-Google-Smtp-Source: ABdhPJyFrIzjdeceg1RGuqUqAr14A4sWSg1XcwjY+9sywQkGZkN1wDWkxene6UP/Gxxa2CUFBAoRPg==
X-Received: by 2002:a17:90b:1a8b:b0:1bf:33e0:a6dc with SMTP id ng11-20020a17090b1a8b00b001bf33e0a6dcmr993324pjb.115.1646436516881;
        Fri, 04 Mar 2022 15:28:36 -0800 (PST)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:3540:80fb:e053:2773:a0bb])
        by smtp.gmail.com with ESMTPSA id g7-20020a056a000b8700b004e1bed5c3bfsm6899428pfj.68.2022.03.04.15.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 15:28:36 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eugene Loh <eugene.loh@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hao Luo <haoluo@google.com>
Subject: [RFC] A couple of issues on BPF callstack
Date:   Fri,  4 Mar 2022 15:28:32 -0800
Message-Id: <20220304232832.764156-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

While I'm working on lock contention tracepoints [1] for a future BPF
use, I found some issues on the stack trace in BPF programs.  Maybe
there are things that I missed but I'd like to share my thoughts for
your feedback.  So please correct me if I'm wrong.

The first thing I found is how it handles skipped frames in the
bpf_get_stack{,id}.  Initially I wanted a short stack trace like 4
depth to identify callers quickly, but it turned out that 4 is not
enough and it's all filled with the BPF code itself.

So I set to skip 4 frames but it always returns an error (-EFAULT).
After some time I figured out that BPF doesn't allow to set skip
frames greater than or equal to buffer size.  This seems strange and
looks like a bug.  Then I found a bug report (and a partial fix) [2]
and work on a full fix now.

But it revealed another problem with BPF programs on perf_event which
use a variant of stack trace functions.  The difference is that it
needs to use a callchain in the perf sample data.  The perf callchain
is saved from the begining while BPF callchain is saved at the last to
limit the stack depth by the buffer size.  But I can handle that.

More important thing to me is the content of the (perf) callchain.  If
the event has __PERF_SAMPLE_CALLCHAIN_EARLY, it will have context info
like PERF_CONTEXT_KERNEL.  So user might or might not see it depending
on whether the perf_event set with precise_ip and SAMPLE_CALLCHAIN.
This doesn't look good.

After all, I think it'd be really great if we can skip those
uninteresting info easily.  Maybe we could add a flag to skip BPF code
perf context, and even some scheduler code from the trace respectively
like in stack_trace_consume_entry_nosched().

Thoughts?

Thanks,
Namhyung


[1] https://lore.kernel.org/all/20220301010412.431299-1-namhyung@kernel.org/
[2] https://lore.kernel.org/bpf/30a7b5d5-6726-1cc2-eaee-8da2828a9a9c@oracle.com/
