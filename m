Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3310B6E6
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfK0Tjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:39:31 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33104 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbfK0Tjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:39:31 -0500
Received: by mail-qt1-f193.google.com with SMTP id y39so26569652qty.0;
        Wed, 27 Nov 2019 11:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hvh4ApSOq4vH8WRE4/4kJ0XOOD72pG3W3faiSBH+W8I=;
        b=DAHd+Ygpowq2ZOzmJF6j1c/JPuN75msi8S3XSbonSHGfmtLhWA9NftJ8F7W3CHabVC
         BEAPldIeYObsikZP+ITC4YV/wU9ZdmjoP4I5xtNp9D0hcd9qoKEO8rMiR2xN/t0TNMGK
         RlSwRGdTHP9ZlkV74W6HU/UTTWSZP6OvzqCRif8GFnR5BFOGvJntoe2T1VEWCUa+9wED
         BWJCi6HW5X/ncrQP3cyR1YJh9j3dTWkU34E23kTUZ9lMi4Cq8muHUoWA8NEaeEZZTSM0
         an3Han93Ya9qs/YXDwp5Nr9JDIzcJtf3YqkMz8+65DtmbNyq7GiJQ24iOcLUR0s7HWL8
         8Ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hvh4ApSOq4vH8WRE4/4kJ0XOOD72pG3W3faiSBH+W8I=;
        b=kbc1g8Eg6c6wbK+WaH9GRKSr0cp6jykBd/DZtx2GltzyQ5qihlZkSpDlxfpyIIFZTK
         BOtmuLVo+Ry2qbEm2MSUn0iTzD7jmFdf7urlxVMDrWiwcTPVIctNH76ZnXYMiXGJ1u0R
         77/oshzx7Y+Z+rk7s45Q8F0yICFHifOeE+mBcFLHdAF8hTwKqDMVwqd4S8Ue+2VFWno1
         0/pR5A76MhogaNkBYFq7EbqGcMY/tBeJ20CzrtllyxqdatHTeqJYfvaSMVqbOUfhFCj7
         QGdfoGVhScd0smtKMbcOvrLZeKCRr6x3QdeYJ9hjWdj9bEzbVDQnNY6x6QI88pJm4ZoC
         UL5g==
X-Gm-Message-State: APjAAAVzaoxVXLq+zoMrEMHZGTwaDoqUuN18nzMGPhA778f6Gaumt9t0
        BW3IFVn1FgrEq2672/MMQlvVHhrt4e3hbQ==
X-Google-Smtp-Source: APXvYqw4tBiud3vxaep4ankqGufF9gEPFqUW/nVDKv9gnvZooJkRfrlLQMSfKLMN3NcMFqs3cD+nrg==
X-Received: by 2002:ac8:41c9:: with SMTP id o9mr9288836qtm.82.1574883570009;
        Wed, 27 Nov 2019 11:39:30 -0800 (PST)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id q15sm7352458qkq.120.2019.11.27.11.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 11:39:29 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C6106405B6; Wed, 27 Nov 2019 16:39:25 -0300 (-03)
Date:   Wed, 27 Nov 2019 16:39:25 -0300
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] libbpf: Use PRIu64 for sym->st_value to fix build on
 32-bit arches
Message-ID: <20191127193925.GC4063@kernel.org>
References: <20191126221018.GA22719@kernel.org>
 <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
 <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org>
 <20191127134553.GC22719@kernel.org>
 <CAADnVQKkEqhdTOxytVbcm1QnBcf4MQ+q4KYaHzsuqkq3r=X-VA@mail.gmail.com>
 <20191127184526.GB4063@kernel.org>
 <CAADnVQLs-=f8E8ahiW7F+_Qb1JiR4-7tXwVNbdyH1FF04RrOHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLs-=f8E8ahiW7F+_Qb1JiR4-7tXwVNbdyH1FF04RrOHA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 27, 2019 at 10:55:31AM -0800, Alexei Starovoitov escreveu:
> On Wed, Nov 27, 2019 at 10:45 AM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Wed, Nov 27, 2019 at 08:39:28AM -0800, Alexei Starovoitov escreveu:
> > > On Wed, Nov 27, 2019 at 5:45 AM Arnaldo Carvalho de Melo
> > > <acme@kernel.org> wrote:
> > > >
> > > > Another fix I'm carrying in my perf/core branch,
> >
> > > Why in perf/core?
> > > I very much prefer all libbpf patches to go via normal route via bpf/net trees.
> > > We had enough conflicts in this merge window. Let's avoid them.
> >
> > Humm, if we both carry the same patch the merge process can do its magic
> > and nobody gets hurt? Besides these are really minor things, no?
> 
> I thought so too, but learned the hard lesson recently.
> We should try to avoid that as much as possible.
> Andrii's is fixing stuff in the same lines:
> https://patchwork.ozlabs.org/patch/1201344/
> these two patches will likely conflict. I'd rather have them both in bpf tree.
> What is the value for this patch in perf tree?
> To fix the build on 32-bit arches, right?
> But how urgent is it? Can you wait few days until this one and other
> libbpf fixes
> land via bpf/net trees?

Ok, I'll add a note to the pull request report about where the perf
build is clean in all containers because I added these two patches, but
that they'll go via the bpf tree, as soon as that gets merged, the
problem will go away.

And I wasn't strictly defending that I should carry this in perf/core,
just said I was, to fix something minor that I found while doing my
usual testing, patch was posted, you got notified and got the patch,
I'll remove it from perf/core now since you stated that it'll eventually
land upstream.

Thanks,

- Arnaldo
