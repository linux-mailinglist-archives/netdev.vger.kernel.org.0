Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9546C6B86CC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCNATx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjCNATv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:19:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A1C4EC0;
        Mon, 13 Mar 2023 17:19:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id cy23so55470302edb.12;
        Mon, 13 Mar 2023 17:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678753189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFIpno07BSq8MwYzPmRcNG46Hf4hTVpOQFFbvO8ouCY=;
        b=VyWAynUmuVYJdEEjIQq8UUl1KyV1qPPTo0Ip7fnK22szw+jbk7XjtOfJ8l02sFJ1rC
         etR6lIpu1TxjPEJ1veDi2yZT7FLvNw2YlIB7X9xvEJ+L2sKcAjZNxrk0HdDQTiH8Bx1i
         Q6iYpH7tFK/gGVBD8amzuR7hSnI5XH/h/REpsY9TBfcbxZDHIa5MNf6oTqYLI5xfanMv
         I/KpKe1NdM5vX4qo/UtCvCEe4qLGp5XCTljCO88R7JZ8xHmmBXfxrKNe0LrbHGdPMu3g
         BsigwiczJQYkdkJiv2UAhVmmIMcOEmCIjhCxClyC5tQCTArp8GUwkxXdDz2KBxcOd5Or
         ts9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678753189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eFIpno07BSq8MwYzPmRcNG46Hf4hTVpOQFFbvO8ouCY=;
        b=JM8vwosW1IGwIdySeA1CDHqg9ukICNdPCwFHCOqoGmMJAqfHN7FxCvMr/T1doI+mqU
         puN6U/cJZ9kQU576mGRgFBX99gSeyEs2A7E5sGLS8SOH4xcX6HMRTpzYQsUCgzyG7kEu
         rBx/JEDQ8Plej/ZInjE+PB+FrU2UyTLOxEdhduAdIkMfnEyG1Psj8d6Gm/umxWcUeDrl
         v+f4DFKtJmcuFtBMDdnbYbsA4iAN55nUkbQn2apxFaYo2/B+ipLZ/OqXLBfBmcI9voDp
         GBB7eD1W/Ce9wNXoXoUn4VVmTRhjzCMHL9bhBwlfktrvuVlYF+boUpodXnIRXiSm36+K
         yAMQ==
X-Gm-Message-State: AO0yUKWovbv6qIiwHPo0SPrp6iTc+cWryyWk0cYsspPIIPqtE1OkxSQl
        LQ5+F70BFfX4v0tsDP/MopIGSpoQR6lMYxlWRJk=
X-Google-Smtp-Source: AK7set+rhhlSrmhPvvsMJ4cjQCYc1Tp3e7Ujo1JZhsFvNyNxGq6PDKB0O5gdA7SitwXjEZiDhB53gHdTjoZhSNCxBts=
X-Received: by 2002:a17:906:4d57:b0:90a:33e4:5a69 with SMTP id
 b23-20020a1709064d5700b0090a33e45a69mr175766ejv.3.1678753188784; Mon, 13 Mar
 2023 17:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
 <20230313235845.61029-4-alexei.starovoitov@gmail.com> <20230314001512.GC202344@maniforge>
In-Reply-To: <20230314001512.GC202344@maniforge>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Mar 2023 17:19:37 -0700
Message-ID: <CAADnVQJbPpjC6CF=R86PG3N4r3gXMUkaLdUfTSpa3TUQFvgZeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add various tests to check
 helper access into ptr_to_btf_id.
To:     David Vernet <void@manifault.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 5:15=E2=80=AFPM David Vernet <void@manifault.com> w=
rote:
>
> On Mon, Mar 13, 2023 at 04:58:45PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Add various tests to check helper access into ptr_to_btf_id.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Thanks a lot for the quick turnaround on this.
>
> LGTM, just left one small nit below.
>
> Acked-by: David Vernet <void@manifault.com>
>
> > ---
> >  .../selftests/bpf/progs/task_kfunc_failure.c  | 36 +++++++++++++++++++
> >  .../selftests/bpf/progs/task_kfunc_success.c  |  4 +++
> >  2 files changed, 40 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_failure.c b/t=
ools/testing/selftests/bpf/progs/task_kfunc_failure.c
> > index 002c7f69e47f..27994d6b2914 100644
> > --- a/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
> > +++ b/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
> > @@ -301,3 +301,39 @@ int BPF_PROG(task_kfunc_from_lsm_task_free, struct=
 task_struct *task)
> >       bpf_task_release(acquired);
> >       return 0;
> >  }
> > +
> > +SEC("tp_btf/task_newtask")
> > +__failure __msg("access beyond the end of member comm")
> > +int BPF_PROG(task_access_comm1, struct task_struct *task, u64 clone_fl=
ags)
> > +{
> > +     bpf_strncmp(task->comm, 17, "foo");
>
> Instead of 17, can you do either TASK_COMM_LEN + 1, or
> sizeof(task->comm) + 1, to make the test a bit less brittle? Applies to
> the other testcases as well.

I'd rather not, since it's not brittle.
There were several attempts in the past to increase TASK_COMM_LEN
and all failed. It will stay 16 for the foreseeable future.
