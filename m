Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38A910B2DC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfK0P7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:59:40 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:35721 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0P7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 10:59:40 -0500
Received: by mail-qt1-f178.google.com with SMTP id n4so25858657qte.2;
        Wed, 27 Nov 2019 07:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UP/A/8ZyD4j1YZR182zTc2bHEQDWRudBnSjV/1JGrFA=;
        b=Ti3BTgK5d2HEDPSqrLdjysff5a2gLfcqTfMXe658LeJ6coCSw4ae3Nxb2aBHjLoNoS
         sAoZq/egbd21qkGXjcG9Yjzh8LQbBQIcuYU1ep39iOXf/KUndbuOg4cWMkt8/2T70GX5
         m40KSGqgDJyWjmt2nj8honGUBTX+YY7d0PBNvJfgHt4576HaHBFHUk+Vm+71IJS4x4Ra
         fU8b+q0gH7ZwgVwLU016Bi8N/kNKXzXUo9KjnLJm/XDSaoaIEKe9Zvlc3kk99Oz+j6xE
         L9ItnqvOr0GVM5wVUE7qJB6RytJq135V44rd49/Va81VNv+2AOhtyRqj2q62Ce/MV0IG
         yczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UP/A/8ZyD4j1YZR182zTc2bHEQDWRudBnSjV/1JGrFA=;
        b=YshUeHjzAH4NEPYHhyXvAucYXcnPrLotgSQNJEDtZL+T/TIaZbdGa6YYFnQJs2Ll/E
         xq5DfJL4WHL4BVtPEkDsM/iZSgXFzwymH7Ywi0AmnZ71h50hDaBY5quebZT9YizkjxWJ
         bv7m/Se6K4NUqxMyF0Kpl8nktNof4u8MbPBetwbBKJ64eRWlCLKiU//eMHBWnFxrBBIj
         HnS/1d0Fmtjamh52a85KLQggUFQa6JZG67KoJv2MGpMwIk8SfEtquliCgu8h9ghTed3q
         lFoTrGyTHWyvwLdgCPThA9s+IxfvmGoTborvVFA+OjSl/AqTyoR6cPTuqxJxGpeg8je0
         cxVQ==
X-Gm-Message-State: APjAAAXq5iQcn/xeAj/fnmN+MXq7YotOcx3Btahe6EiGIurLueoUQ7Uk
        /kqba1DgmF6XSf2hUgWpESM=
X-Google-Smtp-Source: APXvYqyRSLfj0P2QBGvATZSgjsonhKDW4HXos0PDYoN5r18l/hkhwGaq+b8rfkd3OUjePYRr/zboyg==
X-Received: by 2002:ac8:104:: with SMTP id e4mr26478494qtg.37.1574870379268;
        Wed, 27 Nov 2019 07:59:39 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id m29sm8124177qtf.1.2019.11.27.07.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 07:59:38 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1BB2440D3E; Wed, 27 Nov 2019 12:59:36 -0300 (-03)
Date:   Wed, 27 Nov 2019 12:59:36 -0300
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Message-ID: <20191127155936.GL22719@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <20191127094837.4045-4-jolsa@kernel.org>
 <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
 <20191127141520.GJ32367@krava>
 <20191127142449.GD22719@kernel.org>
 <d9bc04a6-0f72-9408-7c2e-2fb30e6a8f74@netronome.com>
 <20191127154849.GK22719@kernel.org>
 <d78a306f-a736-63d1-4d14-695ba33d3d9c@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d78a306f-a736-63d1-4d14-695ba33d3d9c@netronome.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 27, 2019 at 03:52:06PM +0000, Quentin Monnet escreveu:
> 2019-11-27 12:48 UTC-0300 ~ Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Em Wed, Nov 27, 2019 at 02:31:31PM +0000, Quentin Monnet escreveu:
> >> 2019-11-27 11:24 UTC-0300 ~ Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> >>> Em Wed, Nov 27, 2019 at 03:15:20PM +0100, Jiri Olsa escreveu:
> >>>> On Wed, Nov 27, 2019 at 01:38:55PM +0000, Quentin Monnet wrote:
> >>>>> 2019-11-27 10:48 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
> >>>>> On the plus side, all build attempts from
> >>>>> tools/testing/selftests/bpf/test_bpftool_build.sh pass successfully on
> >>>>> my setup with dynamic linking from your branch.

> >>>> cool, had no idea there was such test ;-)

> >>> Should be the the equivalent to 'make -C tools/perf build-test' :-)

> >>> Perhaps we should make tools/testing/selftests/perf/ link to that?

> >> It is already run as part of the bpf selftests, so probably no need.

> > You mean 'make -C tools/perf build-test' is run from the bpf selftests?

> Ah, no, sorry for the confusion. I meant that test_bpftool_build.sh is
> run from the bpf selftests.

> I am not familiar with perf build-test, but maybe that's something worth
> adding to perf selftests indeed.

Yeah, I think is worth considering plugging perf's build-test to
selftests, if only to expose it to the people that are used with
selftests and may start testing perf builds more regularly.

- Arnaldo
