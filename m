Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E51534A57
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 08:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346157AbiEZGT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 02:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiEZGTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 02:19:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F491A2043;
        Wed, 25 May 2022 23:19:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nn3-20020a17090b38c300b001e0e091cf03so332533pjb.1;
        Wed, 25 May 2022 23:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uNCmIUI6bGk9gKzc35zeftxv5C4FG/+UvyUeaZT9up8=;
        b=Pcz9WnTUB8AMHjC8aod5dZO/O4GN7SA38WkpYBF/BhtxK17uXTqaqGOfht28BNRGa0
         U2LNF+4UQj8eiGQRBN5E43lDiwo41tH8tycOFU/uxY0qhXy/AbWkT/NzWSM9MoHgOJmd
         LS3E1v4FXIo+pV+WGTaYOr3O1FQ+kPwYMXwUJ7mBbKOTLt2arb45rOP87rcwtzafj4Rw
         9GPiTGh8C+AU4r18u6hYIVQ46KNvOSx9JOcDef1JBo+H+Lb/RBRnnJEBg0CjpqK0FG60
         V2sshlBmahkxtrFlWuKiVQtS9xiwhi2u4jiUn0fXeqXfS3xB1FRSl6CYCoZUw2RWNJJq
         gbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uNCmIUI6bGk9gKzc35zeftxv5C4FG/+UvyUeaZT9up8=;
        b=zXCDyzv/khCBAXIitmlYAumJ0l28M4PCmJiLbfXkTCgWbhlhpar7cvju1lOTKPuFDU
         7w3U7EpGY4BdNv2b96bgRLJbCG4I3U+c406fCOxjRyJLo9l17Zt96HGVtpCn6/fXg92Y
         HjRiID4dxG2Eakc/GYd73K6e7hl0HkhbDbQB4+qVLEm1q5VCHQVBCyPFzvkKfJ1YyTzR
         r7xS10VYwa8XBq6rq996iJ84NlJ11bvkjzEX/+ePrDmBvYkxYBA4jxPvNXo5za+ysr3j
         w1XX9PNJQKniW/WzsYd0s1cK5N8kJkriQi1KChlzEiDEWpqV9ZlpCM2/imSevkEGCeh6
         dx8A==
X-Gm-Message-State: AOAM5317J0iXWhFwZBA39W2+rmA7CU5q9HHUElX1s1mIzCxUIds66O3A
        uJ2a+B2GevNcjtFU2DB8Hfw=
X-Google-Smtp-Source: ABdhPJxxZtcnVPZaeWL0GTzT1uAoBQQjBp6oZ/mi8dusNt0KQqThJ/T1u7ZiuIgiF6cVoBVCRV0ajQ==
X-Received: by 2002:a17:90a:4a03:b0:1df:4583:cb26 with SMTP id e3-20020a17090a4a0300b001df4583cb26mr950036pjh.173.1653545960902;
        Wed, 25 May 2022 23:19:20 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id b19-20020aa78113000000b005190ce21500sm504612pfi.110.2022.05.25.23.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 23:19:20 -0700 (PDT)
Date:   Thu, 26 May 2022 15:19:17 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v8 09/10] selftests/bpf: Extend kfunc selftests
Message-ID: <Yo8b5W5VdW1NpLyL@d3>
References: <20220114163953.1455836-1-memxor@gmail.com>
 <20220114163953.1455836-10-memxor@gmail.com>
 <Yo7Wc2xGyuq/1tq1@d3>
 <20220526051227.bqoejq7kyymfxba4@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526051227.bqoejq7kyymfxba4@apollo.legion>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-26 10:45 +0530, Kumar Kartikeya Dwivedi wrote:
> On Thu, May 26, 2022 at 06:52:59AM IST, Benjamin Poirier wrote:
> > On 2022-01-14 22:09 +0530, Kumar Kartikeya Dwivedi wrote:
> > > Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
> > > support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
> > > testing the various failure cases for invalid kfunc prototypes.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  net/bpf/test_run.c                            | 129 +++++++++++++++++-
> > >  .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
> > >  .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++++++-
> > >  tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++++++++
> > >  4 files changed, 258 insertions(+), 4 deletions(-)
> > >
> >
> > It looks like this patch broke building the bpf tests:
> >
> > tools/testing/selftests/bpf$ make
> >   CLNG-BPF [test_maps] kfunc_call_test.o
> > progs/kfunc_call_test.c:13:46: error: declaration of 'struct prog_test_pass1' will not be visible outside of this function [-Werror,-Wvisibility]
> > extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
> >                                              ^
> >
> > The only definition of struct prog_test_pass1 that I see is in
> > net/bpf/test_run.c. How is this supposed to work?
> >
> >
> > commit 87091063df5d ("selftests/bpf: Add test for unstable CT lookup
> > API") from the same series added a similar problem in
> > progs/test_bpf_nf.c:
> >
> > progs/test_bpf_nf.c:31:21: error: variable has incomplete type 'struct bpf_ct_opts'
> >         struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
> >
> 
> Both of them should have their definition in vmlinux.h. Can you check?

My bad, I didn't realize it was generated from the running kernel. The
build works after trying again while running v5.18.
