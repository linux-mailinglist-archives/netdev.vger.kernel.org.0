Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE2829D3AF
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgJ1VqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgJ1VqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:46:03 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2005BC0613CF;
        Wed, 28 Oct 2020 14:46:03 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id g13so555000qvu.1;
        Wed, 28 Oct 2020 14:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M0Id+lw9Of6UC60PIbuj6rvWATtUtP0jL73q0kFivlE=;
        b=qQnf/tTIFCP0y9lU+3NshF3ZMTKIboKI9lC/rdfOC29wNopWqz8e0gtgy4J/9BWwWi
         CD65fiyrIhgTv/TswX1k/YGjd1eNmcwV7LiR/9El7qU7PHEIR0uYRv8yxsS3OX0Tc+2t
         gwMflVgpJrtDbODmOFKZ924UKl533Y1+kC4kNakxDmud6njRzgW8x4gQ/jBQhaoL4TnQ
         fu58+U95M2EpfY2P4Z54n16eE3EwlYqM56ckWbEfWbAjBYHX4VggqMPNA3FF1z9PkqQ2
         CwACMMJd1rZbnkSTTPeV0TBBDf4yLtVKF23SJ2UGWU6XTjnfcO5IIwRNrjE5HM7D6nYI
         +BFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M0Id+lw9Of6UC60PIbuj6rvWATtUtP0jL73q0kFivlE=;
        b=dyQzcFsCjjkyni125cjvMz6cwmliiT8rLs9FpRN0YzdUB6pgbsTmxs5uaeHOhUQkmk
         ttC2kzpOxzxZ3UQfA076PQ7qTvGR9DqjHMVKxQjkYhcPokNIjlCIxeltuzOrXgXu69RF
         VrbAGubFq10pCSQjgbqLSx0kXh7wEcrnekiXD6Ixlh/9hRO3runum0fKZRlXPrv+kTdh
         MWGedAcCbow89RQY7tYaD3l7G/BLc/Chrm2Ak3wfmHSgU2XeIXRrYJYz3uKfhd/vozS+
         +3yA9yG2CXM4y3k7wWv3Yvp5eyxUYCZhfHMMOySYqw2Jgqhn+T0SQqMRGtL/95+PM0ol
         eXmA==
X-Gm-Message-State: AOAM53210I2GH3DG10rewGbWuUZnyBk6xF5rCUvIdEkSogltKrjc0lfh
        2Nd2nh8m/DXyNhbsBMuXr4TGcFzoNlF9ig==
X-Google-Smtp-Source: ABdhPJyXl6ak1fCiDMEea9bQ6LqqIJ8F7sRSH//Csfhz7buSAobZSU1PqKW3m91YRBZVhSab1LQprg==
X-Received: by 2002:a17:902:6bc8:b029:d6:d9d:f28c with SMTP id m8-20020a1709026bc8b02900d60d9df28cmr891051plt.17.1603919613960;
        Wed, 28 Oct 2020 14:13:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:1c8])
        by smtp.gmail.com with ESMTPSA id t129sm498179pfc.140.2020.10.28.14.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 14:13:33 -0700 (PDT)
Date:   Wed, 28 Oct 2020 14:13:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201028211325.vstp37ukcvoilmk3@ast-mbp.dhcp.thefacebook.com>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
 <20201022141154.GB2332608@krava>
 <20201022104205.728dd135@gandalf.local.home>
 <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
 <20201027142803.GJ2900849@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027142803.GJ2900849@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 03:28:03PM +0100, Jiri Olsa wrote:
> On Mon, Oct 26, 2020 at 09:30:14PM -0700, Alexei Starovoitov wrote:
> > On Thu, Oct 22, 2020 at 10:42:05AM -0400, Steven Rostedt wrote:
> > > On Thu, 22 Oct 2020 16:11:54 +0200
> > > Jiri Olsa <jolsa@redhat.com> wrote:
> > > 
> > > > I understand direct calls as a way that bpf trampolines and ftrace can
> > > > co-exist together - ebpf trampolines need that functionality of accessing
> > > > parameters of a function as if it was called directly and at the same
> > > > point we need to be able attach to any function and to as many functions
> > > > as we want in a fast way
> > > 
> > > I was sold that bpf needed a quick and fast way to get the arguments of a
> > > function, as the only way to do that with ftrace is to save all registers,
> > > which, I was told was too much overhead, as if you only care about
> > > arguments, there's much less that is needed to save.
> > > 
> > > Direct calls wasn't added so that bpf and ftrace could co-exist, it was
> > > that for certain cases, bpf wanted a faster way to access arguments,
> > > because it still worked with ftrace, but the saving of regs was too
> > > strenuous.
> > 
> > Direct calls in ftrace were done so that ftrace and trampoline can co-exist.
> > There is no other use for it.
> > 
> > Jiri,
> > could you please redo your benchmarking hardcoding ftrace_managed=false ?
> > If going through register_ftrace_direct() is indeed so much slower
> > than arch_text_poke() then something gotta give.
> > Either register_ftrace_direct() has to become faster or users
> > have to give up on co-existing of bpf and ftrace.
> > So far not a single user cared about using trampoline and ftrace together.
> > So the latter is certainly an option.
> 
> I tried that, and IIRC it was not much faster, but I don't have details
> on that.. but it should be quick check, I'll do it
> 
> anyway later I realized that for us we need ftrace to stay, so I abandoned
> this idea ;-) and started to check on how to keep them both together and
> just make it faster
> 
> also currently bpf trampolines will not work without ftrace being
> enabled, because ftrace is doing the preparation work during compile,
> and replaces all the fentry calls with nop instructions and the
> replace code depends on those nops...  so if we go this way, we would
> need to make this preparation code generic

I didn't mean that part.
I was talking about register_ftrace_direct() only.
Could you please still do ftrace_managed=false experiment?
Sounds like the time to attach/detach will stay the same?
If so, then don't touch ftrace internals then. What's the point?
