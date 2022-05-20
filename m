Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F07952F570
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353821AbiETWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiETWA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:00:59 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF03D116;
        Fri, 20 May 2022 15:00:57 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id s12so6357454iln.11;
        Fri, 20 May 2022 15:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5LP2LIe+3dg0Ns3WLvfbA/mpjcRdxbZZTeIf8hpFzg=;
        b=mWbQqr3Eo/woi67Rkec0dQ5oP4bMID1ncR7y8jmdgFNYY2O6M5gj8coWMLX3OwBsyK
         q1cOSxtRo8VSS2jktb9nHi2ZrTbUs9Wyc3ZXFTeFcDGMG+tBdyqasMBOF+a4KNpYb6FH
         d7lgzmn1EATifjMZwFckFsvHocP5/Jb4+cAUNalZ9Fvrbh/AmLk3suZrlX1UdrfzbGpx
         u2jiB3Hsrv4h0k+gAJkk7EnA+bQF5H29KeSly50OEiwBvgyI9IJNjSPrEuD+ybEo7HW5
         +S3xhzHcL87JpOm/3DfE3DODprQZ0ct1o1pMMlv2zFRHScESS/sKnb61csRKua8jS3j3
         h0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5LP2LIe+3dg0Ns3WLvfbA/mpjcRdxbZZTeIf8hpFzg=;
        b=FflSkezWMJGCXDK3gRjS1TfZ48X0dZsvQ+22ui5DVBrl7g96A6lEIsgroY12mVBIVT
         EU9ZVzZG8Y+gjLCXFKkHjquJ5g7vaODf/Hx51w+oEY+qVtvpkaTHmxec4V1gRCrQvxHx
         1Rf6E+CXy9GIL9bQu3Dg62W6GrmK+ZNZ6yRD0HXaN2KGIX+nWm2yNpcJQXQIdlMYGjoZ
         rOx0ZZHI3M7akrMUMJVtO6Wza+iPsh7Fdd+YojfYdrtPh7diQA7YjwwJ75KQqYzMjIRc
         lRjh+iqPzCieurZKMzhRe8v+ZFA8QXkk/pWrQPX1n21kYkGZfAytn7gatV0tjsGu1R1v
         peoQ==
X-Gm-Message-State: AOAM532MqjMjt4eEFq+ksmXacAQkPbUWeprb4cM4Lkvb3RLySHhhtsm9
        zLbHB+bMvc+qvzOep5nMqfm5uGx7/KKqI27v0cA=
X-Google-Smtp-Source: ABdhPJyJb0eVNhgKBfC77kDmoao+VgMr3e9kEx3X2a00wVO7CgIbfAgL7/YAUXBddLKw+ZIPQcW30W2lm27Ua6wsjjs=
X-Received: by 2002:a05:6e02:1a6e:b0:2d1:68e9:e8da with SMTP id
 w14-20020a056e021a6e00b002d168e9e8damr4910952ilv.252.1653084056901; Fri, 20
 May 2022 15:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220518025053.20492-1-zhoufeng.zf@bytedance.com> <cd5bb286-506b-5cdb-f721-0464a58659db@fb.com>
In-Reply-To: <cd5bb286-506b-5cdb-f721-0464a58659db@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 May 2022 15:00:45 -0700
Message-ID: <CAEf4BzaE_WJBQ6xxMy8VmJy3OsPyCCjyRKi_F-CdPLwVVp+7Ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
To:     Yonghong Song <yhs@fb.com>
Cc:     Feng zhou <zhoufeng.zf@bytedance.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 8:44 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/17/22 7:50 PM, Feng zhou wrote:
> > From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >
> > comments from Andrii Nakryiko, details in here:
> > https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
> >
> > use /* */ instead of //
> > use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
> > use 8 bytes for value size
> > fix memory leak
> > use ASSERT_EQ instead of ASSERT_OK
> > add bpf_loop to fetch values on each possible CPU
> >
> > Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
> > Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>


I've fixed remaining formatting issues and added my_pid check to avoid
accidental interference with other tests/processes. Applied to
bpf-next, thanks.
