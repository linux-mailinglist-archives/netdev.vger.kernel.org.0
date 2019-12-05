Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79E8113925
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfLEBJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:09:36 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33647 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728459AbfLEBJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:09:36 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so498869plb.0;
        Wed, 04 Dec 2019 17:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ViAayKR33rl8zoSyX9hQw1dJ+O1axe3RVZLwKJ3XZ7M=;
        b=gpVPjjISpjaQDzRkWgoacbeNWtX3XqEujzMcmQTYYJKAyJOVxwUNJNkSO8Qtswy8c9
         M69PdRWMKIzgyp78ulFAaJSW/MF6DCfouFUVX7Z2vkyIStA2z9oXrVqZiR1IPBqied8v
         oFpu8HM/Wr4OmyR97uwqRXqrrUzhQlC/Ru2gEvSWhKpOmn6r5DWolobjaw3aNlEK2Z6j
         s1bpcvZ8DKkRnlpuFKqexZB9ZnaGlbpRANjY1YB/stprGxt9QUDUAQMByrJqMmcLKI/k
         RLyOKiBXQUJCut95xszk6iEpFf1AEn35Wv3yOk1sqmT15hdb1iIHdMJkEn08akIAM9HR
         2L5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ViAayKR33rl8zoSyX9hQw1dJ+O1axe3RVZLwKJ3XZ7M=;
        b=W7mgVqmptyuWGOpOM+VhCVF+dwYyyUku+j+5uBK95l1qronp8zrsOByTueGqgSfMIv
         oqc7f9xSSOMCm4goSqo390iNZo9rT39GY/X53JSNj8nyrNo7TslPA+aQ/KmiXbL1QKXy
         NJBlUaFYsum/dnz4pJM7hzcbZ5bwQZbiSilpwUkazuQfd/wdRcv1FeU76jqsuCDkmcr7
         xbrB0C3ybcyDuTilpck/nLvoM06CRlb/P7Hs01JP8QHiukuKa7kvJ3oiMxxJo5VcGp/K
         UYLXe/psfwZA9FgJYI5aLBn+oS8LAwGlBcf1eo9qDqxF7PcS7JPeKVCmI6UfXncKTTHr
         CRHA==
X-Gm-Message-State: APjAAAXOwT0XOyFpRxGijlxl+m3CJgQyS11BECarqXioZzoON3Ub+OWa
        N/FTYPH9+EYtahpYqHOPHMA=
X-Google-Smtp-Source: APXvYqxucCMfUYo4o+CNZalKxqwuG8BC6llJtVcFLGRk6pwcY+EmrNa58uOkgZ9fPjL4nMVVjE7HoA==
X-Received: by 2002:a17:902:be10:: with SMTP id r16mr6417014pls.169.1575508175325;
        Wed, 04 Dec 2019 17:09:35 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f9fe])
        by smtp.gmail.com with ESMTPSA id b73sm9923090pfb.72.2019.12.04.17.09.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 17:09:34 -0800 (PST)
Date:   Wed, 4 Dec 2019 17:09:32 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191205010930.izft6kv5xlnejgog@ast-mbp.dhcp.thefacebook.com>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
 <20191204135405.3ffb9ad6@cakuba.netronome.com>
 <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
 <20191204162348.49be5f1b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204162348.49be5f1b@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 04:23:48PM -0800, Jakub Kicinski wrote:
> On Wed, 4 Dec 2019 15:39:49 -0800, Alexei Starovoitov wrote:
> > > Agreed. Having libbpf on GH is definitely useful today, but one can hope
> > > a day will come when distroes will get up to speed on packaging libbpf,
> > > and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> > > bpftool in the same boat is just more baggage.  
> > 
> > Distros should be packaging libbpf and bpftool from single repo on github.
> > Kernel tree is for packaging kernel.
> 
> Okay, single repo on GitHub:
> 
> https://github.com/torvalds/linux

and how will you git submodule only libbpf part of kernel github into bcc
and other projects?

> You also said a few times you don't want to merge fixes into bpf/net.
> That divergence from kernel development process is worrying.

worrying - why? what exactly the concern you see?
Tying user space release into kernel release and user space process into
kernel process makes little sense to me. Packaging is different. Compatibility
requirements are different. CI is different. Integration with other projects is
different.

libbpf source code is in the kernel tree only because kernel changes plus
libbpf changes plus selftests changes come as single patchset. That is really
the only reason. Packaging scripts, CI scripts, etc should be kept out of
kernel tree. All that stuff belongs at github/libbpf.

> None of this makes very much sense to me. We're diverging from well
> established development practices without as much as a justification.

The kernel development process was never used for libbpf. Even coding style is
different. I'm puzzled why you think user space should be tied to kernel.
Everything is so vastly different.
Some people say that 8 weeks to bump libbpf version is too long.
Other people say that it's too often.
libbpf version numbers != kernel version numbers.
There is no definition of LTS for libbpf. One day it will be
and the version of libbpf picked for LTS will likely have
nothing to do with kernel LTS choices.
libbpf has to run on all kernels. Newer and older. How do you support that if
libbpf is tied with the kernel?

> Perhaps I'm not clever enough to follow. But if I'm allowed to make an
> uneducated guess it would be that it's some Facebook internal reason,
> like it's hard to do backports? :/

hard to do backports? of what?

