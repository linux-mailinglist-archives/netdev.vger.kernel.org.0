Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E724BA680
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiBQQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:58:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiBQQ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:58:27 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B92158DA3;
        Thu, 17 Feb 2022 08:58:13 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso7654427pjs.1;
        Thu, 17 Feb 2022 08:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8rUjvLAIL/XwjLJsf2D2kvWqtcMkKvDgD4sS2jxGVw=;
        b=KbKhkgc0nVCJ4HUg9bfB2hgDA4L0g+pgfBLsT+Vj+wu18yFiiu0853fzGrG8pxVNiZ
         RUu1JAK5jTc0cqSbRjb+0x/XaKJnJrH3FxQUHH+bjlIyLTgzLIxIwCWuN51W108PKvxB
         IXW6mowcgFyCHUBRzn5YTNF1XbbLWYJmj65cPH0ZftSAV4L0cWJN7y9SVpkvrLfuOj6P
         UYNCOdo4Bh4b+0Uzg3evxg0LYmWDZByyF7gpkioaB5U+k78YB+jVhRVIH/33bv7zuS8k
         fBrUBI0eRA+2U/LVB4aWVkcQUlv/Lyn+gfWSKcnmk0JLZmyya4QqQY/dqXB6Fk54sKtN
         XmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8rUjvLAIL/XwjLJsf2D2kvWqtcMkKvDgD4sS2jxGVw=;
        b=tzBMjR4LEI/bcSPaVsaXqED1SQSuSzEnJDOHdbLJapS5WiGIrTZhSptYCd6KYyQBFP
         ZejxJElg1v1hAgjO1BL/+KQ67tGYReM6N2A200QvWrLBaOjihKOkOmN7Uba3cz9k0S+H
         QnkKJn6Q9sn6oA9byxYJv+lEAk9x4gRTjMAUQxxu+NqL/P/A77QD+0OxQQFTkDrPIuR7
         XeFqPy2SWl9Xe/BsxFPaGu8tgwr+wPl8uRHaqJ9HfX0mgKQaoew4P39nhRMg2/hdZvft
         GmJpZndUmYlz3y3mxNCbfmMrk0Z7xKe2VhZMGYT5nttib0a2o78zUpCr2Kbi0N5X89k4
         2gGw==
X-Gm-Message-State: AOAM532xbw0etL0T6jI58gOznicWbj0oLbwUFFjFuMY5K1aJTibttEbx
        iRUUr68gE7Db6uJ2NHbl4XRfuQ67nwTEYB1HWBA=
X-Google-Smtp-Source: ABdhPJwdAyB6s5HjNWiHvHfuYr/fbddHxWvDwAuLh4GnAmVmvBW5pX09ck0dVlZsWx3jzIyh2QED+TD6sd7KJz9iM98=
X-Received: by 2002:a17:90a:b017:b0:1b9:485b:3005 with SMTP id
 x23-20020a17090ab01700b001b9485b3005mr8204455pjq.33.1645117092659; Thu, 17
 Feb 2022 08:58:12 -0800 (PST)
MIME-Version: 1.0
References: <20220216001241.2239703-1-sdf@google.com> <20220216001241.2239703-2-sdf@google.com>
 <20220217023849.jn5pcwz23rj2772x@ast-mbp.dhcp.thefacebook.com> <Yg52EAB3ncoj22iK@google.com>
In-Reply-To: <Yg52EAB3ncoj22iK@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Feb 2022 08:58:01 -0800
Message-ID: <CAADnVQLHHf=WT2iZ3j7ja6nvy4MzzLM9u7=orVSw9SBj-amRXg@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/4] bpf: cgroup_sock lsm flavor
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Thu, Feb 17, 2022 at 8:21 AM <sdf@google.com> wrote:
> > As far as api the attach should probably be to a cgroup+lsm_hook pair.
> > link_create.target_fd will be cgroup_fd.
> > At prog load time attach_btf_id should probably be one
> > of existing bpf_lsm_* hooks.
> > Feels wrong to duplicate the whole set into lsm_cgroup_sock set.
>
> lsm_cgroup_sock is there to further limit which particular lsm
> hooks BPF_LSM_CGROUP_SOCK can use. I guess I can maybe look at
> BTF's first argument to verify that it's 'struct socket'? Let
> me try to see whether it's a good alternative..

That's a great idea.
We probably would need 2 flavors of __cgroup_bpf_run_lsm_sock wrapper.
One for 'struct socket *' and another for 'struct sock *'.
In lsm hooks they come as the first argument and BTF will tell us what it is.
There are exceptions like socket_create hook
which would have to use current->cgroup.
So ideally we can have a single attach_type BPF_LSM_CGROUP
and use proper wrapper socket/sock/current depending on BTF of the lsm hook.

> > Would it be fast enough?
> > We went through a bunch of optimization for normal cgroup and ended with:
> >          if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) &&
> >              cgroup_bpf_sock_enabled(sk, CGROUP_INET_INGRESS))
> > Here the trampoline code plus call into __cgroup_bpf_run_lsm_sock
> > will be there for all cgroups.
> > Since cgroup specific check will be inside BPF_PROG_RUN_ARRAY_CG.
> > I suspect it's ok, since the link_create will be for few specific lsm
> > hooks
> > which are typically not in the fast path.
> > Unlike traditional cgroup hook like ingress that is hot.
>
> Right, cgroup_bpf_enabled() is not needed because lsm is by definition
> off/unattached by default. Seems like we can add cgroup_bpf_sock_enabled()
> to
> __cgroup_bpf_run_lsm_sock.

I guess we can, but that feels redundant.
If we attach the wrapper to a particular lsm hook then cgroup_bpf_sock
is surely enabled.

>
> > For BPF_LSM_CGROUP_TASK it will take cgroup from current instead of sock,
> > right?
>
> Right. Seems like the only difference is where we get the cgroup pointer
> from: current vs sock->cgroup. Although, I'm a bit unsure whether to
> allow hooks that are clearly sock-cgroup-based to use
> BPF_LSM_CGROUP_TASK. For example, should we allow
> BPF_LSM_CGROUP_TASK to attach to that socket_post_create? I'd prohibit that
> at
> least initially to avoid some subtle 'why sometimes my
> programs trigger on the wrong cgroup' types of issues.

Agree. With a single BPF_LSM_CGROUP attach type will get correct
behavior automatically.

Looking forward to non rfc patches. Exciting feature!
