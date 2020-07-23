Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAD722A3A8
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733310AbgGWAcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGWAck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:32:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6EAC0619DC;
        Wed, 22 Jul 2020 17:32:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so2174367pgb.6;
        Wed, 22 Jul 2020 17:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o2TfIZbr0tB7FWTK1wRxzEVs1jR7h/mG1R1czpo8E0o=;
        b=WvOF78rMynNWq4L5bZHpbZijqbhfRZ4RIyhCN9aLCpAnNpscWngnwBqNwqBxTLLaqr
         4ybwawWViVgx7EKTGW7RZaGlgC748PpEuAxNNl6mUNwhUWRBt6x88Rqjb6sU7WJYOVzH
         G6gc8JWw1QJCY+HpV+bK4oAlEfWh9Jhq3TNscL9/PLEZbpzSkQDkbredcJsbHmKLuHWN
         keLA15/dFU+32gt+NX/Np0VM7EsLaYxrDEI8OMnuxbK21XcZH6Zqyw3mMjSLsbeAFNLo
         dQXlDOhMjxQ30NeBpcvELkzGfyRa95z2Ijw2qh7hxuua6JvortufqCfmpxyymfuOB1tN
         xRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o2TfIZbr0tB7FWTK1wRxzEVs1jR7h/mG1R1czpo8E0o=;
        b=UJZeMmGtWRcd3t2xMsUl+0YfXC+i/e2Lw8JStewgvAElK/pgitnruPOjshlNfFr2j4
         AiNnTfZdrkqcKyGIqRkqg9++CmGfxky7Va43/zZfkF+8h9d3+GIR904LTXD8FUoReyZu
         b+hhp1htzEfobe+UoSp0n0I3gjJhNHlDs6a+vsO4H68PjQJMdfZlrQ/fULxxA2xa7iB+
         oBXr3fZT/g5FIbu02ZVhNHSyWutClPSEWzmuJ28WC9MEiutVx0kgwdSfCaecQTbnPl2r
         ZH9NzfwZ5YMQIncI+P/AfCNPm/kCejY2i1I3+GF6OVrcNVrcbG5j+RCv22xLoIy6QguD
         3jAQ==
X-Gm-Message-State: AOAM531bTFx3Xkh9mV7fYaGcEg0aIIpGHRriXZAYWk6a/dIblVeWBAXp
        AAqZ8Q70nmav6D1HvqS3R1E=
X-Google-Smtp-Source: ABdhPJwHR/Rh8dJRbGoQ4jnedK+0B5c0OEf3apGeDKtukcF2DNNFwhMGkyjixXtWXD/If3kRX2173g==
X-Received: by 2002:a62:cdc4:: with SMTP id o187mr1973639pfg.200.1595464360089;
        Wed, 22 Jul 2020 17:32:40 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6cd6])
        by smtp.gmail.com with ESMTPSA id 127sm830832pgf.5.2020.07.22.17.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 17:32:39 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:32:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
Message-ID: <20200723003236.w2z7sqbd4jjqamgx@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk>
 <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk>
 <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
 <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYtD9dGUy3hZRRAA56CaVvW7xTR9tp0dXKyVQXym046eQ@mail.gmail.com>
 <20200722002918.574pruibvlxfblyq@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbdE441MgpEAv+nLBYUXZRz_tzGvmf87rw68hOvT0bwfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbdE441MgpEAv+nLBYUXZRz_tzGvmf87rw68hOvT0bwfw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 11:02:04PM -0700, Andrii Nakryiko wrote:
> 
> Just one technical moment, let me double-check my understanding again.
> You seem to be favoring pre-creating bpf_tracing_link because there is
> both tgt_prog (that we refcnt on EXT prog load) and we also lookup and
> initialize trampoline in check_attach_btf_id(). Of course there is
> also expected_attach_type, but that's a trivial known enum, so I'm
> ignoring it. So because we have those two entities which on attach are
> supposed to be owned by bpf_tracing_link, you just want to pre-create
> a "shell" of bpf_tracing_link, and then on attach complete its
> initialization, is that right? That certainly simplifies attach logic
> a bit and I think it's fine.

Right. It just feels cleaner to group objects for the same purpose.

> But also it seems like we'll be creating and initializing a
> **different** trampoline on re-attach to prog Y. Now attach will do
> different things depending on whether tgt_prog_fd is provided or not.

Right, but it can be a common helper instead that is creating a 'shell'
of bpf_tracing_link.
Calling it from prog_load and from raw_tp_open is imo clean enough.
No copy paste of code.
If that was the concern.

> So I wonder why not just unify this trampoline initialization and do
> it at attach time? For all valid EXT use cases today the result is the
> same: everything still works the same. For cases where we for some
> reason can't initialize bpf_trampoline, that failure will happen at
> attach time, not on a load time. But that seems fine, because that's
> going to be the case for re-attach (with tgt_prog_fd) anyways. Looking
> through the verifier code, it doesn't seem like it does anything much
> with prog->aux->trampoline, unless I missed something, so it must be
> ok to do it after load? It also seems to avoid this double BTF
> validation concern you have, no? Thoughts?

bpf_trampoline_link_prog() is attach time call.
but bpf_trampoline_lookup() is one to one with the target.
When load_prog holds the target it's a right time to prep all things
about the target. Notice that key into trampoline_lookup() is
key = ((u64)aux->id) << 32 | btf_id;
of the target prog.
Can it be done at raw_tp_open time?
I guess so, but feels kinda weird to me to split the target preparation
job into several places.
