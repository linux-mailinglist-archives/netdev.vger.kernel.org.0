Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77C9487D84
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiAGUKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiAGUKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:10:14 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F73C061574;
        Fri,  7 Jan 2022 12:10:13 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id x15so5476522ilc.5;
        Fri, 07 Jan 2022 12:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8QIhxmCvKbO3DvUUrpQLaxUs1aKpnKSDTCEltov4H8E=;
        b=oIsFPBc8TxQ0oM8DDQASnSeiIuLK4jIvkaJQsKoksSpfN2tsTRlhiXkGQiOxKeRPLn
         vUo3Osz6AfkEQQny+2Fyv6AvjaB/+4/Ow5ean+ccb9aTnVoXhvx1/dZNWVORsR2TDron
         pKHMxdMtrzy3C5d2EXTFWPHonf4Olgd7qadmYcIiYZQHyByKii9VXENUnodDR/jTwG6T
         7Y4oro/V52hRghIoY5A1gfczdaQQRjyQlBwPI/IgmZdjre6AFeXoj/DLggVV/bufg9fF
         FuU79R34wkgd7vtxrzP1MJSSgKPO1n0yj5GlT7BCLBPEileRmxdsS/uHVeSByY84Rxw1
         FvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8QIhxmCvKbO3DvUUrpQLaxUs1aKpnKSDTCEltov4H8E=;
        b=HsNOyq1m7mC/z3RzvFevffAp5KCRB1n1N7v2O+tn72NUdsWSejP/CKDN6i29nnVjKB
         1wKh5fiKORV9th+yIuwoOCZCrNE5hTOpjuHUVUatINIGpqOhGKVyIRnRqLWKXA1w801r
         37PMKPKG+f+gTad0AF4E0+HgMy3nsqvtCkBR38N39g/P02Jze/L2Nz32cHeXX9x5LUkY
         mENB5k11M/UxT5e6XHpNm9q/iCxqZBNtO1UTMaly6r7eTW2dcxnNxTCYwQiZVx2Nowck
         5KplK9GOUiqxskwHQXK/HFeNFuLwdKAPU8l07cMY4sATBxgLPYRhN4/Q0jBgqbckjaGs
         UVVw==
X-Gm-Message-State: AOAM5306MYvlAgzOCiaTCCOzE/x661/PqL93Fg7bLYso+O9S75KdSDFa
        hsioMsJEIOzsFC8RwnTcckSbv0c72nfP6M2Iics=
X-Google-Smtp-Source: ABdhPJxQnUpG1KGsv7lcJfa3f7MIEXog7VRSgWmQns70TznlOAeX+NWfwxsGwmZ3PXWmfelhkTOpit07Z8RmPTfECTM=
X-Received: by 2002:a05:6e02:b4c:: with SMTP id f12mr29109993ilu.252.1641586213274;
 Fri, 07 Jan 2022 12:10:13 -0800 (PST)
MIME-Version: 1.0
References: <20220102162115.1506833-1-memxor@gmail.com> <20220102162115.1506833-12-memxor@gmail.com>
 <20220105062033.lufu57xhpyou3sie@ast-mbp.dhcp.thefacebook.com>
 <20220106090400.6p34bempgv2wzocj@apollo.legion> <CAEf4BzYsVC0cOuxVB2A-WWv+zW7zEFNQGrD0WKWhhOWDbYw3PQ@mail.gmail.com>
 <20220107072236.ayhibs3bllcl4d6c@apollo.legion>
In-Reply-To: <20220107072236.ayhibs3bllcl4d6c@apollo.legion>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Jan 2022 12:10:02 -0800
Message-ID: <CAEf4Bzatpi7dWR3mo4gAXGtmYwWLQqyh3xkLdJO_wAOVhU1XNA@mail.gmail.com>
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

On Thu, Jan 6, 2022 at 11:22 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Jan 07, 2022 at 01:09:04AM IST, Andrii Nakryiko wrote:
> > On Thu, Jan 6, 2022 at 1:04 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > On Wed, Jan 05, 2022 at 11:50:33AM IST, Alexei Starovoitov wrote:
> > > > On Sun, Jan 02, 2022 at 09:51:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > This adds a complete test case to ensure we never take references to
> > > > > modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
> > > > > ensures we never access btf->kfunc_set_tab in an inconsistent state.
> > > > >
> > > > > The test uses userfaultfd to artifically widen the race.
> > > >
> > > > Fancy!
> > > > Does it have to use a different module?
> > > > Can it be part of bpf_testmod somehow?
> > >
> > > I was thinking of doing it with bpf_testmod, but then I realised it would be a
> > > problem with parallel mode of test_progs, where another selftest in parallel may
> > > rely on bpf_testmod (which this test would unload, load and make it fault, and
> > > then fail the load before restoring it by loading again), so I went with
> > > bpf_testmod.
> > >
> > > Maybe we can hardcode a list of tests to be executed serially in --workers=n > 1
> > > mode? All serial tests are then executed in the beginning (or end), and then it
> > > starts invoking others in parallel as usual.
> >
> > you can mark test as serial with "serial_" prefix, grep for that, we
>
> Thanks for pointing that out!
>
> > have a bunch of tests like this. But if you are going to unload and
> > reload bpf_testmod, you will be forcing any bpf_testmod-using test to
> > be serial, which I'm not sure is such a great idea.
> >
>
> Didn't get the last part, based on my reading it will execute serial tests one
> by one (after finishing parallel tests), so if my serial test restores the
> loaded bpf_testmod after completing, it shouldn't really impact other tests,
> right? Did I miss something?

No, sorry, my bad. You are right, we'll run all serial tests after (or
maybe before, don't remember) all the parallel tests completed. So
yeah, just mark this one serial.

>
> --
> Kartikeya
