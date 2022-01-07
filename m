Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9E2487378
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 08:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbiAGHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 02:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbiAGHWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 02:22:51 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D7C061245;
        Thu,  6 Jan 2022 23:22:51 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id m1so4494732pfk.8;
        Thu, 06 Jan 2022 23:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/iKuZuECKdgKrRCy3kPaNIUdSvOv4DODSZrCc3vNZOM=;
        b=Rjxgbu2/Wm6o0d0SP8O01j2vFBGuy+h9mgdXFLRL5ARMz8AevWEc7teyW/nXi0H4Zh
         BKbFnb49MtMulRQryHddxCVEg+Q0B7zVnd6cf47iBvNtCvgyHJ1ttnmbUgMt7OifQJ0i
         YQqXla94aMrCm/dk1hkiZzh2UPsy8Soyxzf4pxGY33HQ20w/thil7WMMm9tMr6GhjStF
         flfz070nJg/M/QUQi/wfGmEqbXlkPFpmAa01i1T3PV6CbExShDKK34P+n1wa2K5fmNrY
         33ijo03AUQjfukWOjW3fqkIAwkIHWNH+QmJ8gBQJxiKs5W3PZjX+Ege2UfucFtpYNYWS
         cnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/iKuZuECKdgKrRCy3kPaNIUdSvOv4DODSZrCc3vNZOM=;
        b=KNvbyu8r74BorcRwAeNiXuShIsE8CFGt0ka0R70WP38mT0qd4y2cdJY14e5vILD484
         6erj8XV+tfym1NLuV8KqiTpuu5515o26fQM07yMQrPTADMzSaLhy4uC0d4k9AWzECNe5
         75y/BtfhvqAm10/2X+ZLz7S+6OvuFGPljrrKZDAqdsjWasJ698ZBC58+2e5eb1KYs2Mb
         IelfQtecyjtQxKwkIfUffWaq56e8MUSQSWQJAegfv2+aAHFRvremZyv6gU2kFJoMjIiM
         DvQZh30mz6SiZA9OmN6j4pTHoeUYKI20VV2bbgXenfWsBjtDwNiPPhbTxUulfcmU13cA
         MRQQ==
X-Gm-Message-State: AOAM5322G9oh5UIQrpQRgXGjbIqZpVlOKA2cvUhUYwJ8Vt6/VhnRcD68
        vTW9J+G2okxikfFYbJmgWWg=
X-Google-Smtp-Source: ABdhPJxndjXO/VYrAT8vaE3rI5nZ5nXObuFTnepGOuUBuIapKt1EKfg8ok4wDHRYRI7AWhVXK8jzXQ==
X-Received: by 2002:a63:7b59:: with SMTP id k25mr491897pgn.190.1641540171040;
        Thu, 06 Jan 2022 23:22:51 -0800 (PST)
Received: from localhost ([14.96.13.220])
        by smtp.gmail.com with ESMTPSA id y14sm3803535pgo.87.2022.01.06.23.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 23:22:50 -0800 (PST)
Date:   Fri, 7 Jan 2022 12:52:36 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 11/11] selftests/bpf: Add test for race in
 btf_try_get_module
Message-ID: <20220107072236.ayhibs3bllcl4d6c@apollo.legion>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-12-memxor@gmail.com>
 <20220105062033.lufu57xhpyou3sie@ast-mbp.dhcp.thefacebook.com>
 <20220106090400.6p34bempgv2wzocj@apollo.legion>
 <CAEf4BzYsVC0cOuxVB2A-WWv+zW7zEFNQGrD0WKWhhOWDbYw3PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYsVC0cOuxVB2A-WWv+zW7zEFNQGrD0WKWhhOWDbYw3PQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 01:09:04AM IST, Andrii Nakryiko wrote:
> On Thu, Jan 6, 2022 at 1:04 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > On Wed, Jan 05, 2022 at 11:50:33AM IST, Alexei Starovoitov wrote:
> > > On Sun, Jan 02, 2022 at 09:51:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > This adds a complete test case to ensure we never take references to
> > > > modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
> > > > ensures we never access btf->kfunc_set_tab in an inconsistent state.
> > > >
> > > > The test uses userfaultfd to artifically widen the race.
> > >
> > > Fancy!
> > > Does it have to use a different module?
> > > Can it be part of bpf_testmod somehow?
> >
> > I was thinking of doing it with bpf_testmod, but then I realised it would be a
> > problem with parallel mode of test_progs, where another selftest in parallel may
> > rely on bpf_testmod (which this test would unload, load and make it fault, and
> > then fail the load before restoring it by loading again), so I went with
> > bpf_testmod.
> >
> > Maybe we can hardcode a list of tests to be executed serially in --workers=n > 1
> > mode? All serial tests are then executed in the beginning (or end), and then it
> > starts invoking others in parallel as usual.
>
> you can mark test as serial with "serial_" prefix, grep for that, we

Thanks for pointing that out!

> have a bunch of tests like this. But if you are going to unload and
> reload bpf_testmod, you will be forcing any bpf_testmod-using test to
> be serial, which I'm not sure is such a great idea.
>

Didn't get the last part, based on my reading it will execute serial tests one
by one (after finishing parallel tests), so if my serial test restores the
loaded bpf_testmod after completing, it shouldn't really impact other tests,
right? Did I miss something?

--
Kartikeya
