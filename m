Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B6B40CC42
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhIOSEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 14:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOSEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 14:04:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61123C061574;
        Wed, 15 Sep 2021 11:03:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c4so2125310pls.6;
        Wed, 15 Sep 2021 11:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XXnmttG0K9/s3C5s0it4kHj463m57ylorfqwjiFEtkg=;
        b=ck+xXSRnHfQV33X3IR9KM12Jzz9EjIEq4YHTfzjkqyhJ+JhNNQvwP4vtB7C0EdJ//S
         zwAhZmP56OTMQXHq2s53P5hmvSbwO8f8IC42qCaQHvYLllwTlrnRsg6ENHeWJb/dxuBG
         HSxvZMA3LMBUpbYeeCK3uR9SFy/lkjEtyz8NALq96+8uVTvGALvYNdQeze7BFmA92ik6
         LknKSqyyVEiorItL9FWmS9nL5krvmW6DQtOL+KwksnwFNjDeeplD7d2Z1Y4EOeqDOqXH
         L2lcOi7AgUh1w3Ivl+UK3cIWvwyaz30JCD9zDXgWSPPw2mfiJ58yYomXCih6Ckn2Xv1n
         NEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XXnmttG0K9/s3C5s0it4kHj463m57ylorfqwjiFEtkg=;
        b=iviGtv1QjQNQ+076FIrV8EUXY89rfIrkVElNQ5EHDR878KigefevWc/OUM3f3sQTAb
         mJqxY1tCTZJx0VGLkvSQo21pbCB+cLQSZFvexI9p2BOqXxV6wWyjeyFd1isqspJsyFCX
         ObqP0DR6Wu6xN5hlIOOPPgHpoo0AVcG57/M6+nCA8+txlLm5DdXoFiwyeMknCd7foInE
         k+wzsvjbyf4A470UPQh/1wm1RrCvTWDS/DH614wY4X7rW2kgIXq/YvCFEJFvf/CpxLej
         wdJ3jk262v7G6iQ6yLfMbJkL7uQmyo7icF+pAt5c1ywAfQ/V8NhfUgP24LMIe0kZ2d2O
         Ogzg==
X-Gm-Message-State: AOAM5315FL7WXINTuVmp6DTnYwjH8DN1gcXR00XtkSzDWGcU+JGaobxC
        7ZMT0fJ/v+lU83AFXB7pkdo=
X-Google-Smtp-Source: ABdhPJxQTYrORWPkxbxhjGHKKLtBh7JLirKS/TThr+aM2RW5pO/HS5b3ra7mbfQcQWXl57LIRZrhxg==
X-Received: by 2002:a17:90b:168a:: with SMTP id kv10mr9769676pjb.35.1631728983738;
        Wed, 15 Sep 2021 11:03:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id y15sm585467pfq.32.2021.09.15.11.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 11:03:03 -0700 (PDT)
Date:   Wed, 15 Sep 2021 23:33:01 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 00/10] Support kernel module function calls
 from eBPF
Message-ID: <20210915180301.cm3o6yolrnirh4sg@apollo.localdomain>
References: <20210915050943.679062-1-memxor@gmail.com>
 <CAEf4BzYwredoHa6Wv3AEMCfnqOXKcxk2yW3bSu3t6s_TmRmE5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYwredoHa6Wv3AEMCfnqOXKcxk2yW3bSu3t6s_TmRmE5Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 09:34:21PM IST, Andrii Nakryiko wrote:
> On Tue, Sep 14, 2021 at 10:09 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This set enables kernel module function calls, and also modifies verifier logic
> > to permit invalid kernel function calls as long as they are pruned as part of
> > dead code elimination. This is done to provide better runtime portability for
> > BPF objects, which can conditionally disable parts of code that are pruned later
> > by the verifier (e.g. const volatile vars, kconfig options). libbpf
> > modifications are made along with kernel changes to support module function
> > calls. The set includes gen_loader support for emitting kfunc relocations.
> >
> > It also converts TCP congestion control objects to use the module kfunc support
> > instead of relying on IS_BUILTIN ifdef.
> >
> > Changelog:
> > ----------
> > v2 -> v3:
> > v2: https://lore.kernel.org/bpf/20210914123750.460750-1-memxor@gmail.com
> >
> >  * Fix issues pointed out by Kernel Test Robot
> >  * Fix find_kfunc_desc to also take offset into consideration when comparing
>
> See [0]:
>
>
>   [  444.075332] mod kfunc i=42
>   [  444.075383] mod kfunc i=42
>   [  444.075522] mod kfunc i=42
>   [  444.075578] mod kfunc i=42
>   [  444.075631] mod kfunc i=42
>   [  444.075683] mod kfunc i=42
>   [  444.075735] mod kfunc i=42
>   [  444.0
> This step has been truncated due to its large size. Download the full
> logs from the
> menu once the workflow run has completed.
>
>   [0] https://github.com/kernel-patches/bpf/runs/3606513281?check_suite_focus=true
>

I'll change it to not use printk in the next spin (maybe just set a variable).
This probably blew up because of parallel test_progs stuff, since it would be
called for each sys_enter as long the raw_tp prog is attached.

--
Kartikeya
