Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2B10B5FC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfK0Spb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:45:31 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:37580 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfK0Spa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:45:30 -0500
Received: by mail-qv1-f66.google.com with SMTP id s18so9338198qvr.4;
        Wed, 27 Nov 2019 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Su3f/KAzMyPTWNIDhXsgBVojnqo7amrhCXux/PYTe5s=;
        b=bfHq2w59fjt5G2fX+ANvpBMsqPsgC0Sn8zUNGTKM/JjXHgHA5zMox1qMEkEsQuhSHQ
         CS7zF2ym1ywVUZRlvJ1qWMnSUBxvGSE1Uaa+tV3tjB1xUIq8gnAqZ2nnExGtF9oObjyE
         IVo+0yKxbuoNpi0Ey6INkhvd0FrIqFXbn54CW6vq4hOs8wfT8SCdd2k/jQWY/T+UAxwE
         rlPT/TPxKsRyYfoqo8Uhjf5Wxc2N07i66N5eOgG9iSkY/eMgGpLU51OS+rP4hY8kzAmq
         DKy7/j6wPxCBN76wMbs9e9mwQsGAyTq3C5eAOJv3o3xxkLU4OSYkU0T2X8rfxKM6OTLv
         u8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Su3f/KAzMyPTWNIDhXsgBVojnqo7amrhCXux/PYTe5s=;
        b=uXwtXzow0G2WRLTYZXttWpWiVcOvT/cOEuWiNavt57230FJCPdtzuAiwuAK+M4+HOn
         +tVvWI/Yq6kDEtUuEjd0G9/D4hXBuDaED4SxwfVKhsWkAAv89pmYeA+ukjTpK6Ql11ow
         /+ZyZFAseAZ0HM4Zl4wSi3oN9ec4v670WsmG/Q1V4fzP0znNRbbOI+rCx4gVRyaMjDJ7
         uZrmQqCfxvpqgYgBI2Gh4/mDMTgTIXC1v6oN9j2O28+AyFLgQ34d3si9qp/reUs14t0V
         tWsXfhkv7s4mHoyuxrgwqUdKKpIv3REfcJLQRTauN76fWjwctq2MuKNuxJ10rlJgTZ5a
         q8oA==
X-Gm-Message-State: APjAAAWmWV/i2J9jCoZNRep+vdju8+7uPgwkpVcHCYV0pJyiJ7PMJMi4
        UzA/qM6LxW+v9H787gs+jPA=
X-Google-Smtp-Source: APXvYqxaHMdz+bQyDMLSBySLTuBfXMIZjfYqHeUzgvltJKd2auOU1lv54lzRz+8gWbfp3PifszK0Tw==
X-Received: by 2002:ad4:4e26:: with SMTP id dm6mr6786961qvb.200.1574880329554;
        Wed, 27 Nov 2019 10:45:29 -0800 (PST)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id l34sm792566qtd.71.2019.11.27.10.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 10:45:28 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4629C40D3E; Wed, 27 Nov 2019 15:45:26 -0300 (-03)
Date:   Wed, 27 Nov 2019 15:45:26 -0300
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
Message-ID: <20191127184526.GB4063@kernel.org>
References: <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org>
 <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
 <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org>
 <20191127134553.GC22719@kernel.org>
 <CAADnVQKkEqhdTOxytVbcm1QnBcf4MQ+q4KYaHzsuqkq3r=X-VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKkEqhdTOxytVbcm1QnBcf4MQ+q4KYaHzsuqkq3r=X-VA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 27, 2019 at 08:39:28AM -0800, Alexei Starovoitov escreveu:
> On Wed, Nov 27, 2019 at 5:45 AM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Another fix I'm carrying in my perf/core branch,
 
> Why in perf/core?
> I very much prefer all libbpf patches to go via normal route via bpf/net trees.
> We had enough conflicts in this merge window. Let's avoid them.

Humm, if we both carry the same patch the merge process can do its magic
and nobody gets hurt? Besides these are really minor things, no?

- Arnaldo
