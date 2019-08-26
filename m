Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAFA9D979
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfHZWr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:47:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36505 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfHZWr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:47:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so11456838pgm.3;
        Mon, 26 Aug 2019 15:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vfBwbhpjT5DDXg/b1tHfiGL1LIP+KALZAiSRjZRhFW0=;
        b=jMfKpk44Jvxiv/8WYVfpubE3dWKNaUMJFNhkAJKvvYgVLBTTIKfD/1krRVXeyWdeyn
         J68MftaxW0E2UXygu4eq1uUx/sVLvdc3vJ5VjJ/m25eULT5OMfhCiLPgDtRn46BGVjCh
         yEN3yXefa0ET+WZcgMJYKouiCAMT3HppxN/eJMlBcgOb1W1MsejwocbnHsrNV0hLDHow
         O9mxwuMpOW28B2qbsQskhHDzHD8gGI/axcYhs7/KP59WtknbpPnd0BnARQXjVnFF5Xdb
         5W/w/xFsQjdN3x0geRA6MuVbSpyEeAArH7tZKJ21nywrZExVeHyg138Ck0L4UsdkqW+7
         yQyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vfBwbhpjT5DDXg/b1tHfiGL1LIP+KALZAiSRjZRhFW0=;
        b=I4a3jGKtqnHBinkSisybsFCfJs+C5tK/54q4a1WOHp03bFVLN1Hh+nn7d8ZjpAK1fO
         AkqI47ylL2KrJ3b0dXQElVazbHCOx3sIisF9Nae5VlaSTXEwrQoGYXMDaReGAYHhuDeZ
         knlCAXqaJh5u+O6CQZryFWhaHGLLMigaz3rcx/WB36/fYBJ76yxGQg5cp/u+XW3a6Oh4
         birwPB1LshBf3bgwxlkWyUYJcPFRDl756mXbvHmT1LV0AYVh+UuJ1mEGSOzOZp3K2QUJ
         dgkslOInkLUz/Ad+c6D/3PmwxUEpxO8AZHqATiV2C/4hcmHetXdcezFQN7U3jCR1szrF
         TT0w==
X-Gm-Message-State: APjAAAVSCIrnlcBmVYpeXz1pgoQp5WdxW+oH8yfTELDZTVYknOV9j3zL
        yEnUheZH1Pu1D4v88kSR910=
X-Google-Smtp-Source: APXvYqySFsi7e4MU6si+RrZZq/LHkAT+ZHKD0w+9K4dHQntt8WtCBuXgiPvsegWRrAZmwfz7adK2wA==
X-Received: by 2002:a62:ce8a:: with SMTP id y132mr22653290pfg.240.1566859647706;
        Mon, 26 Aug 2019 15:47:27 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::f983])
        by smtp.gmail.com with ESMTPSA id k5sm13370252pfg.167.2019.08.26.15.47.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 15:47:26 -0700 (PDT)
Date:   Mon, 26 Aug 2019 15:47:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: verifier precise tests
Message-ID: <20190826224724.edxfxbkv6r5wkg6o@ast-mbp>
References: <20190823055215.2658669-1-ast@kernel.org>
 <20190823055215.2658669-4-ast@kernel.org>
 <CAPhsuW54=MiBfLp+AL2ASqaoGOf+p9D_VXxBYcR5fFpBrdEGSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW54=MiBfLp+AL2ASqaoGOf+p9D_VXxBYcR5fFpBrdEGSg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 10:22:13PM -0700, Song Liu wrote:
> On Fri, Aug 23, 2019 at 2:59 AM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Use BPF_F_TEST_STATE_FREQ flag to check that precision
> > tracking works as expected by comparing every step it takes.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >
> > +static bool cmp_str_seq(const char *log, const char *exp)
> 
> Maybe call it str_str_seq()?

imo cmp*() returns the result of comparison.
Which is either boolean or -1,0,1.
Whereas str*() should return the address, index, or offset.
Hence I used cmp_ prefix here.

> >  static void do_test_single(struct bpf_test *test, bool unpriv,
> >                            int *passes, int *errors)
> >  {
> > @@ -897,14 +929,20 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >                 pflags |= BPF_F_STRICT_ALIGNMENT;
> >         if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
> >                 pflags |= BPF_F_ANY_ALIGNMENT;
> > +       if (test->flags & ~3)
> > +               pflags |= test->flags;
> ^^^^^^ why do we need these two lines?

To pass flags from test into attr.prog_flags.
Older F_NEEDS_* and F_LOAD_* may use some cleanup and can be removed,
but it would be a different patch.

