Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E45F10EF92
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfLBSym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:54:42 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32952 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfLBSym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:54:42 -0500
Received: by mail-qt1-f193.google.com with SMTP id d5so874550qto.0;
        Mon, 02 Dec 2019 10:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Q+km/f32wNPmuJKYXN+UMoF0b6NSliqWpDUpI204bWk=;
        b=dDtBW9Xl19goZYg0ymdeTAVghXD5B/NSctJHlHqhEEWZv0XvMmaz0pGWljjJZZXjNO
         Dx/LfknM/v7/T9aF5QAYcaUOpCVUef5KWXbDcRANpAJDopJ7ULrO+L0MBoFotGn/TSdg
         fXu2ViYbWOtT3WibenKpyOIsAH7kHlMhMG055/xQLxViH/PiXnpn5LSItT1vUnEXFH01
         /aaisaVDXvp0mbdH2eYlY2lw4blLfSqs5YXimQ0MOr4LyDOecJ4Bdqxv8i/v9eyQQ71y
         zSamElZjTBTQAE77E4KVpPQTMY3+JxSACODQTItvXF7rELNAmERVa9tYAXdmqF/NDuir
         CshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Q+km/f32wNPmuJKYXN+UMoF0b6NSliqWpDUpI204bWk=;
        b=Fkv8ICJLmkOYoJrNvK7FqVfCgsayrpGSTpI2PV0Z8ENIUI3Of95As1DR8Qy0obB7bQ
         J4CcxPt2paP9KvCoyvWTz8WI+c078/jBG+EoNY4SMvXvBKBpJlVnHH7zRJycXjR+R2oc
         YoWpJ+j98FN4KbGo7cf5aCJxGUYr9deGGzDKZyL3+B2fxI2NgrdqJBEXN3FMoxt0TU5R
         CCaAIXowtFwg0qAwW0IU0gYsZE67u9v8p1A0+mCZOIlpKcxP0/zF+3f+oSTeH7A5ZGvN
         OP90xnMcI3D2o2WpOtR5VL8v79I+/vpHJ9byR1fryZka4a5uARdpFCJdpn0I71IocmU/
         C2vw==
X-Gm-Message-State: APjAAAXA4Rnqb2QUIR4vxk3CfRInpM/SuuosvNPTvwwDQeWnMQDEkjxx
        m569KqDaS4BheEC7nMfOXrU=
X-Google-Smtp-Source: APXvYqzHdM3/QSgrJ44KrRmrxwpAka45CYVys9Ev++GURc/Uutt3BdxZdTk/YFZdcc3u0BjBAp/suQ==
X-Received: by 2002:ac8:3a27:: with SMTP id w36mr907843qte.204.1575312880987;
        Mon, 02 Dec 2019 10:54:40 -0800 (PST)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id q130sm219864qka.114.2019.12.02.10.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:54:40 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 079D8405B6; Mon,  2 Dec 2019 15:54:35 -0300 (-03)
Date:   Mon, 2 Dec 2019 15:54:34 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191202185434.GG4063@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
 <87zhgappl7.fsf@toke.dk>
 <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Dec 02, 2019 at 10:42:53AM -0800, Andrii Nakryiko escreveu:
> On Mon, Dec 2, 2019 at 10:09 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> > > On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >> adding support to link bpftool with libbpf dynamically,
> > >> and config change for perf.

> > >> It's now possible to use:
> > >>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1

> > > I wonder what's the motivation behind these changes, though? Why is
> > > linking bpftool dynamically with libbpf is necessary and important?
> > > They are both developed tightly within kernel repo, so I fail to see
> > > what are the huge advantages one can get from linking them
> > > dynamically.

> > Well, all the regular reasons for using dynamic linking (memory usage,
> > binary size, etc).

> bpftool is 327KB with statically linked libbpf. Hardly a huge problem
> for either binary size or memory usage. CPU instruction cache usage is
> also hardly a concern for bpftool specifically.

> > But in particular, the ability to update the libbpf
> > package if there's a serious bug, and have that be picked up by all
> > utilities making use of it.

> I agree, and that works only for utilities linking with libbpf
> dynamically. For tools that build statically, you'd have to update
> tools anyways. And if you can update libbpf, you can as well update
> bpftool at the same time, so I don't think linking bpftool statically
> with libbpf causes any new problems.

> > No reason why bpftool should be special in that respect.

> But I think bpftool is special and we actually want it to be special
> and tightly coupled to libbpf with sometimes very intimate knowledge
> of libbpf and access to "hidden" APIs. That allows us to experiment
> with new stuff that requires use of bpftool (e.g., code generation for
> BPF programs), without having to expose and seal public APIs. And I
> don't think it's a problem from the point of code maintenance, because
> both live in the same repository and are updated "atomically" when new
> features are added or changed.

> Beyond superficial binary size worries, I don't see any good reason
> why we should add more complexity and variables to libbpf and bpftool
> build processes just to have a "nice to have" option of linking
> bpftool dynamically with libbpf.

s/bpftool/perf/g
s/libbpf/libperf/g

And I would also agree 8-)

- Arnaldo
