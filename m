Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53F2534808
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 03:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbiEZBXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 21:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiEZBXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 21:23:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5D76EC4F;
        Wed, 25 May 2022 18:23:03 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h186so134810pgc.3;
        Wed, 25 May 2022 18:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0nqWB/LSEwThisZLz/wW12YmDGCojhBcUDE6LDvsPV0=;
        b=ThWslwVu5+xITBYy/y8OV9wmC80QfQLOPsP221cWT9FtRu11K+uu5ur4UCa6BSs37c
         gjW4chHRLzLmEoOgPnM7YRFM3upFuJ7bOpXUQGrzJthaTPlYSk9YxCUz6sQ0KT2/vbRN
         6xB+2TH+7fqVtDQXrhgFgmKp+3jaTSWJ984J60cuzPl6MPsYpbGsn2wB6JbgGIiA9jN+
         0CiIZv5m2X7qFNzAw0D2kI2krSHwqarAOY21kq7s214vTOW5RWIzc+TxVskjXED/cMTv
         /91609019Ln4SoO2hMoJKtforPWi1s+aMl/pDU+EDyZmmRJuMdp5ilqKwZFW3uvdfHyK
         TQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0nqWB/LSEwThisZLz/wW12YmDGCojhBcUDE6LDvsPV0=;
        b=KVv4rD3Yt06MvPhGXK9ERWdYtaqAesMtMHRIKJXSd5l6mHibK91hgQHKAP5sPrOGMr
         kLxDuY3RfFr8g9UUKkziQwrqm/UNQSILRcc1t4XSFltU2bhYDCjlerp94r6eddZ820iZ
         34AgYVqAJh1cT58Km3ZM8bQ+ZEmUkLGikNcpbiFsIMTgPMNr2/4zIKswVos01h6lDSPb
         YP1wGy2UyIfBxHcG4YCk9ZKCpNohrAJdE9s8fpCx5l9Zmhs9tBEYVbNnhstup/bONARW
         ws8vsULQsNm6woh9cVgBgS7+fonsNW8zZP5fP6XjxYdgnecANrP+0re099j7dVKXUh8i
         f3Ww==
X-Gm-Message-State: AOAM533rcyGCT7srlyjm9YlxtwwhaSxNVPuaGgucnf0QmhV4risNv0WK
        R4aPtJHk1o5w9iJ8vACLDm0=
X-Google-Smtp-Source: ABdhPJwqevSetUTrgBGV0OADIxks6YW6FZUIO9P2LGG3VCfy3/qJHDrjU0rOXV9e8n2rgmzRL8McRw==
X-Received: by 2002:a63:6cc7:0:b0:3f6:ba59:1bcc with SMTP id h190-20020a636cc7000000b003f6ba591bccmr25222379pgc.188.1653528182711;
        Wed, 25 May 2022 18:23:02 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902ef4900b0015e8d4eb1c1sm66497plx.11.2022.05.25.18.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 18:23:01 -0700 (PDT)
Date:   Thu, 26 May 2022 10:22:59 +0900
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
Message-ID: <Yo7Wc2xGyuq/1tq1@d3>
References: <20220114163953.1455836-1-memxor@gmail.com>
 <20220114163953.1455836-10-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114163953.1455836-10-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-14 22:09 +0530, Kumar Kartikeya Dwivedi wrote:
> Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
> support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
> testing the various failure cases for invalid kfunc prototypes.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  net/bpf/test_run.c                            | 129 +++++++++++++++++-
>  .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
>  .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++++++-
>  tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++++++++
>  4 files changed, 258 insertions(+), 4 deletions(-)
> 

It looks like this patch broke building the bpf tests:

tools/testing/selftests/bpf$ make
  CLNG-BPF [test_maps] kfunc_call_test.o
progs/kfunc_call_test.c:13:46: error: declaration of 'struct prog_test_pass1' will not be visible outside of this function [-Werror,-Wvisibility]
extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
                                             ^

The only definition of struct prog_test_pass1 that I see is in
net/bpf/test_run.c. How is this supposed to work?


commit 87091063df5d ("selftests/bpf: Add test for unstable CT lookup
API") from the same series added a similar problem in
progs/test_bpf_nf.c:

progs/test_bpf_nf.c:31:21: error: variable has incomplete type 'struct bpf_ct_opts'
        struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
                           ^
