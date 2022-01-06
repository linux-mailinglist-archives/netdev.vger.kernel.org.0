Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752E4486A94
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243385AbiAFTjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243378AbiAFTjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:39:16 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7787C061245;
        Thu,  6 Jan 2022 11:39:15 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id x6so4347993iol.13;
        Thu, 06 Jan 2022 11:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Ta/qPPLbIegMeyk44wXJPPazJMwHROpJTWS1AQ/mvc=;
        b=LslgYxrTvXzwlynzwtXIOVQSAr/+bEM84i/DqusI8EmAPUrBTmdoXxTNNzgEF9tTsP
         9Eq9RBiCXul4GaPekPhChtsFZ54yP+CilNhPkv1wkTcJAHTplhCQ00GTGRqB598f1aX6
         533q6l0q/65935uHyqzqxmXtLy+HN+JAe9n7JqZwj3XLWhZ7G6ztzV+dtpzIchSwaTIB
         W5ilgJJUsLK0eFngOAgkqEvJKc0JwXRm+21Yaw01/M4VASgs0JuD/cwjzqvXM1IG/giE
         Lzo1w9Fob/lzdMWj4madf2k6udPi3GBWlSoPHhGQjaq6NEVNVw+A+W3zw2cJRjU86PbG
         SgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Ta/qPPLbIegMeyk44wXJPPazJMwHROpJTWS1AQ/mvc=;
        b=jGkNVDTyEJ8Z8VqbDwgWW+CitaVqbp4vBKRwRDpyzd69IZRHq1aYZ0bO+Dr3twJMQN
         aRmJiHnVUqaDCney0YNVfVhzSVWQf334L/Ak8ZzBk1B6lAxdF1p1Mjq5byOW4n5xAgZ7
         nHGyruH4JKEDWsXgi1CFvDC+UZnrbRfJoujhVOimZRnZSSev3Xr1AKGcFk14inMjrQEk
         i75tYTqPugEVx0U2WprNLRO1G1eM3H0LAsV2vFiyC7PF+n7eZihlhheccZPdVJ9hEDlD
         DOaOPrwG0/Cvr2fxj10CJUXdOeo99pPVQjYl6eLX1JKRL0gsCgMmZayvb32iF40kinRh
         jxnA==
X-Gm-Message-State: AOAM533egs9y8kwuFya7hTP+yMf3B7RTxAZOYkU1DuXxjY/YRGEltSa8
        4Al7AjPdeBxaZDf+jtJRtUqoCOBtQD1K/vu1iHg=
X-Google-Smtp-Source: ABdhPJxruaX0rHD+Z49e5KKfazUlOGeR/t1gW1Ajl6nWzn8ug6T5acRIRO1l5L0/hI9+JG8TGbbn1gRkcBHou7trq+I=
X-Received: by 2002:a6b:3b51:: with SMTP id i78mr28375567ioa.63.1641497955241;
 Thu, 06 Jan 2022 11:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20220102162115.1506833-1-memxor@gmail.com> <20220102162115.1506833-12-memxor@gmail.com>
 <20220105062033.lufu57xhpyou3sie@ast-mbp.dhcp.thefacebook.com> <20220106090400.6p34bempgv2wzocj@apollo.legion>
In-Reply-To: <20220106090400.6p34bempgv2wzocj@apollo.legion>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Jan 2022 11:39:04 -0800
Message-ID: <CAEf4BzYsVC0cOuxVB2A-WWv+zW7zEFNQGrD0WKWhhOWDbYw3PQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 11/11] selftests/bpf: Add test for race in btf_try_get_module
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 1:04 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Wed, Jan 05, 2022 at 11:50:33AM IST, Alexei Starovoitov wrote:
> > On Sun, Jan 02, 2022 at 09:51:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > This adds a complete test case to ensure we never take references to
> > > modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
> > > ensures we never access btf->kfunc_set_tab in an inconsistent state.
> > >
> > > The test uses userfaultfd to artifically widen the race.
> >
> > Fancy!
> > Does it have to use a different module?
> > Can it be part of bpf_testmod somehow?
>
> I was thinking of doing it with bpf_testmod, but then I realised it would be a
> problem with parallel mode of test_progs, where another selftest in parallel may
> rely on bpf_testmod (which this test would unload, load and make it fault, and
> then fail the load before restoring it by loading again), so I went with
> bpf_testmod.
>
> Maybe we can hardcode a list of tests to be executed serially in --workers=n > 1
> mode? All serial tests are then executed in the beginning (or end), and then it
> starts invoking others in parallel as usual.

you can mark test as serial with "serial_" prefix, grep for that, we
have a bunch of tests like this. But if you are going to unload and
reload bpf_testmod, you will be forcing any bpf_testmod-using test to
be serial, which I'm not sure is such a great idea.

>
> --
> Kartikeya
