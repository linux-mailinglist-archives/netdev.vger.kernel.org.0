Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56D45B4198
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 23:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiIIVnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 17:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiIIVnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 17:43:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F2D13E4C7
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 14:43:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j15-20020a056902020f00b006aea95548b0so290151ybs.19
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 14:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=RQ/RHVVHpmpB1V0DuvGfzSeOFbDRdXln7rq3LTWarTA=;
        b=Y9COy7bDApy6jOXUDs8cE/zwtaXpJVQs2yW5bcVJUB9dEen41pIRSOfHXVEy3XpSMr
         In1BWDC4ycuBveJyi34VQdSRPykN8pakuW1CdhDdvg2KmEW/9K55JFtORM9Zzbuwc8UM
         YbQ/ghAlbbAAFF1kOkK5N9S89JsdjbS60gmnh6oNl/ut1jCSz21+k+9fiZIREwDWFrSK
         NXFJWd8OAt+sTzRI9S7CN1P8dYDaGrnXc4gqLtbT7mSzgg1U5JSXaL8E+FfXULJZ/rJM
         J2SMtm04BpMuLnTwrpW8SL7iid6zwqKbu6bKDIsl6pj5Y5HgtWT8O+Ee6YOi6s3hURjQ
         eKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=RQ/RHVVHpmpB1V0DuvGfzSeOFbDRdXln7rq3LTWarTA=;
        b=I1iG+wJYWpvy5CiYcLKipqvuRw+dgA3xq3YoP8wrQkYZDSYTv9TVE6KJpIB7K6Fyoj
         0rSe97reN0eiZtmQ/tnCcz0mkyO3befNxWmdpxUfgTEXWkv46f9cZeN2WrFiwkJqlbuD
         qFWwIbbW7GjVhfFL+2tltMjqvxO7iQAZixXhJRLS5mTbLUFl7jzBBRtRMHFmdydPWh9q
         Vuw9bgG9Txmnj7d+SgMA+J8LjlGAxGk09+BdArqY718Fo5D+2icQqkbc9nQA0NBfPJXa
         g3a/eG9KhlzN7ksNoRnWvTBeWEDO02S9sgUyg2MOG8VNoxkqZgc+m2PwK4ZZueRoLWiO
         7fXw==
X-Gm-Message-State: ACgBeo3dBPgUr5hBf8NWQe+/0S/8M+1enZQr72quKbM6gWJxBtSVp6zi
        l3TTfgE+5z4SDhAO3zOZVHORmME=
X-Google-Smtp-Source: AA6agR6hPX1FHMMsmDh95SYa0O35eolLvLx65t+G3+4vzi9V2C7ZvZaasr4ExgdC0ocMNamDN1DmEaw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:bed1:0:b0:695:8192:8d1d with SMTP id
 k17-20020a25bed1000000b0069581928d1dmr13187190ybm.533.1662759800271; Fri, 09
 Sep 2022 14:43:20 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:43:18 -0700
In-Reply-To: <20220909211540.GA11304@bytedance>
Mime-Version: 1.0
References: <000000000000e506e905e836d9e7@google.com> <YxtrrG8ebrarIqnc@google.com>
 <CAO-hwJJyrhmzWY4fth5miiHd3QXHvs4KPuPRacyNp8xrTxOucA@mail.gmail.com>
 <YxuZ3j0PE0cauK1E@google.com> <20220909211540.GA11304@bytedance>
Message-ID: <YxuzdhmaHeyycyRi@google.com>
Subject: Re: [syzbot] WARNING in bpf_verifier_vlog
From:   sdf@google.com
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        haoluo@google.com, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, kuba@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev,
        martin.lau@linux.dev, nathan@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, Song Liu <song@kernel.org>,
        syzkaller-bugs@googlegroups.com, Tom Rix <trix@redhat.com>,
        Yonghong Song <yhs@fb.com>, Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09, Peilin Ye wrote:
> Hi all,

> On Fri, Sep 09, 2022 at 12:54:06PM -0700, sdf@google.com wrote:
> > On 09/09, Benjamin Tissoires wrote:
> > Yeah, good point. I've run the repro. I think the issue is that
> > syzkaller is able to pass btf with a super long random name which
> > then hits BPF_VERIFIER_TMP_LOG_SIZE while printing the verifier
> > log line. Seems like a non-issue to me, but maybe we need to
> > add some extra validation..

> In btf_func_proto_check_meta():

> 	if (t->name_off) {
> 		btf_verifier_log_type(env, t, "Invalid name");
> 		return -EINVAL;
> 	}

> In the verifier log, maybe we should just say that  
> BTF_KIND_FUNC_PROTO "must
> not have a name" [1], instead of printing out the user-provided
> (potentially very long) name and say it's "Invalid" ?

> Similarly, for name-too-long errors, should we truncate the name to
> KSYM_NAME_LEN bytes (see __btf_name_valid()) in the log ?

Both suggestions sound good to me. Care to cook and send a patch with a
fix?

> [1] commit 2667a2626f4d ("bpf: btf: Add BTF_KIND_FUNC and  
> BTF_KIND_FUNC_PROTO")

> Thanks,
> Peilin Ye

