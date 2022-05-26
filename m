Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CD0534A2F
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbiEZFPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiEZFPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:15:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED117AEE3A;
        Wed, 25 May 2022 22:15:40 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so549570plk.8;
        Wed, 25 May 2022 22:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=otO7xdqCT+yY4LUUIxNziQrNuKyNI8ooKQupIav3Xn0=;
        b=JNi1TOaRaFhncqCxK3nH77geRd3mmIyVCrsAu3dEtIGZyXgdUw1RmbA10zg5wylHz9
         Gb89v2l1142XVJgTN1KUcoz4Tq8j0F7v8gBAY83FT6s4D77sLJsHKcwMPxlh/c4U583P
         HyGtUwXECu3noqmstDx/nKZCK3BHkPYUrOq4u1Ie6/luiJgMXUX/P9LZnXajuBFvltp6
         TWOudWX8tEtJtFs8a1PJnon4yK5VBWoe5Qpz8I5eUq6zXY3/y6jR7U9EtMsjf2FwgCRh
         EKQo8rIr7Ug8Cvs0rA/umXKrsjyLhyYJcJzpyUt8rKCukDTbKtJJ+TFj6NpOvW3vw1bR
         PFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=otO7xdqCT+yY4LUUIxNziQrNuKyNI8ooKQupIav3Xn0=;
        b=sUyyriLcl3/RE4Nd2h9M1fGUeZuHQ9SREPUvZVA7ERmsZtJpyqUmsPsnpcSFbv+xqt
         YWKJKvRiqwo5aPK0CWQ8cVRmvBIlN+pGvU68Xolq4YJB5B2IL4Xm+gCaJFrlm0Qe+ujK
         GUKhAVLBY9RBhxlETsXFMdT9X+/j55lTh1lR6qCtWyDdIppflzftrF0aoZL16YJJGmBX
         lR+AVgrvlgUrUuphmIt8fKoGMza3ECF49UYZ8IxRO0mZ9hS8uEsE43pPl3gXBUxZXnae
         +WuG6cZYToJDQSpbR/lgmr4AB9Aiopx0d4704oXZYDedLGUb1FT7YoQ5CHJm9/TudQVJ
         GRQw==
X-Gm-Message-State: AOAM531vxe9bEf4+fwEgScBzqpqkoTLDVHMsZkrfhkVEqItYhQ/aQBAm
        WLXvy4yRV9BdD/nevaW2Jps=
X-Google-Smtp-Source: ABdhPJyStKqvxduU1Oj6mtc2HUIGv0zEw3M5fkzdPxP7N/4QFviYnDQ1ujPx1SMyDIm9I2kb/OupDQ==
X-Received: by 2002:a17:90b:24f:b0:1df:264c:e828 with SMTP id fz15-20020a17090b024f00b001df264ce828mr764384pjb.174.1653542140366;
        Wed, 25 May 2022 22:15:40 -0700 (PDT)
Received: from localhost ([157.51.122.0])
        by smtp.gmail.com with ESMTPSA id 65-20020a620644000000b0050dc7628166sm356630pfg.64.2022.05.25.22.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 22:15:39 -0700 (PDT)
Date:   Thu, 26 May 2022 10:45:35 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v8 09/10] selftests/bpf: Extend kfunc selftests
Message-ID: <20220526051227.bqoejq7kyymfxba4@apollo.legion>
References: <20220114163953.1455836-1-memxor@gmail.com>
 <20220114163953.1455836-10-memxor@gmail.com>
 <Yo7Wc2xGyuq/1tq1@d3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo7Wc2xGyuq/1tq1@d3>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 06:52:59AM IST, Benjamin Poirier wrote:
> On 2022-01-14 22:09 +0530, Kumar Kartikeya Dwivedi wrote:
> > Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
> > support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
> > testing the various failure cases for invalid kfunc prototypes.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  net/bpf/test_run.c                            | 129 +++++++++++++++++-
> >  .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
> >  .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++++++-
> >  tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++++++++
> >  4 files changed, 258 insertions(+), 4 deletions(-)
> >
>
> It looks like this patch broke building the bpf tests:
>
> tools/testing/selftests/bpf$ make
>   CLNG-BPF [test_maps] kfunc_call_test.o
> progs/kfunc_call_test.c:13:46: error: declaration of 'struct prog_test_pass1' will not be visible outside of this function [-Werror,-Wvisibility]
> extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
>                                              ^
>
> The only definition of struct prog_test_pass1 that I see is in
> net/bpf/test_run.c. How is this supposed to work?
>
>
> commit 87091063df5d ("selftests/bpf: Add test for unstable CT lookup
> API") from the same series added a similar problem in
> progs/test_bpf_nf.c:
>
> progs/test_bpf_nf.c:31:21: error: variable has incomplete type 'struct bpf_ct_opts'
>         struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
>

Both of them should have their definition in vmlinux.h. Can you check? Also for
BPF selftests we require conntrack to be built into the kernel, instead of as a
module.

--
Kartikeya
