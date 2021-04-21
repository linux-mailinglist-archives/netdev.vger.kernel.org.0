Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46614366529
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhDUGGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbhDUGGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:06:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA6DC06174A;
        Tue, 20 Apr 2021 23:06:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f29so28732294pgm.8;
        Tue, 20 Apr 2021 23:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VXsey0RwpfWZz1dMxTFv91NI3cXCqYhle9Gy2Y5ms5k=;
        b=o62pCh/71fsYL2K4w7ztDEk5hlT1j5O716srizOFivtojP2NM0TU+rrPVeFWJNWVY7
         Nu3D9mV4s9mn1u/e8Zx0H+GNZKnVpoK+C/DN8OGFS78fbpPMr871Lt+3Oh4IYz9m/Ucg
         jkRwUHn6R+2g4v2Jh7ECWtGcFWuwR9UfjosKcO9fuTtRlUp8fDMBuTulCtBf55ZG9zRr
         QT7SnFf/v4csTeyKSR9xuw7mIyjdr84xH8AD1SzeTMpmstxHwGHLDpmFgNPm/o0exMSs
         UjGACb96apa+wKOcImUIEMxNyS499HtPN6yYTiaF9mAKmVWQlk1mqKkPBpR2XB/shuY3
         4fIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VXsey0RwpfWZz1dMxTFv91NI3cXCqYhle9Gy2Y5ms5k=;
        b=kiQkYVwQI+xinpUBkpio0/SUujRGZDAo/bFyRM2CvY9xuVCid1DrxtM8jCl69JxFf0
         yF1CEbauTCEQ6Ij59MKPJKXuAipsJWtBtsSGohR06eocW5CZFlnYLHVLI0MNb1twOJ2L
         o1fjR3uQt/V2w4l9R/TC1JLN4U4jMyitkBmUSj3FYCvTk33jCEz0HW0Hws5LH3xFMaxF
         vhMTNEv4FNUjdTiiVdeHx3E/vMhdfAjZ6hSH2UG+8KspRLfICtAzrpQ6yQ95+MD9msP3
         hFW41OXD3O+d6+P2d8Y+CwHoj+vRda7fpoTynPuFtXNiyYYakNKmtSB8ziYzOr1qXZPS
         ScCQ==
X-Gm-Message-State: AOAM532dpOXaO2WFniDU9SE/u99AQNjp89x9TrGKbXSgXJAtE4zYT3gx
        rnzusBIGC0IPHBFUabKg5y4=
X-Google-Smtp-Source: ABdhPJznuABtTRMgOMF9SNf0A5s8ApjtG+sJYbunMcPfgB81G4JkGnlyLyu8DF8sY/uQAh7z2lRCWg==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr9209938pjx.196.1618985171258;
        Tue, 20 Apr 2021 23:06:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f3c3])
        by smtp.gmail.com with ESMTPSA id l18sm856094pjq.33.2021.04.20.23.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 23:06:10 -0700 (PDT)
Date:   Tue, 20 Apr 2021 23:06:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 13/15] libbpf: Generate loader program out of
 BPF ELF file.
Message-ID: <20210421060608.ktllw2v3bhgd5pvm@ast-mbp.dhcp.thefacebook.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-14-alexei.starovoitov@gmail.com>
 <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
 <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com>
 <2ff1a3d4-0aba-e678-d04c-621ab18b7dd0@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ff1a3d4-0aba-e678-d04c-621ab18b7dd0@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 10:30:21PM -0700, Yonghong Song wrote:
> > > > +
> > > > +static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)
> > > 
> > > Maybe change the return type to size_t? Esp. in the below
> > > we have off + size > UINT32_MAX.
> > 
> > return type? it's 0 or error. you mean argument type?
> > I think u32 is better. The prog size and all other ways
> > the bpf_gen__add_data is called with 32-bit values.
> 
> Sorry, I mean
> 
> +static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, __u32
> size)
> 
> Since we allow off + size could be close to UINT32_MAX,
> maybe bpf_gen__add_data should return __u32 instead of int.

ahh. that makes sense.

> > This helper is only used as mark_feat_supported(FEAT_FD_IDX)
> > to tell libbpf that it shouldn't probe anything.
> > Otherwise probing via prog_load screw up gen_trace completely.
> > May be it will be mark_all_feat_supported(void), but that seems less flexible.
> 
> Maybe add some comments here to explain why marking explicit supported
> instead if probing?

will do.

> > 
> > > > @@ -9383,7 +9512,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
> > > >    	}
> > > >    	/* kernel/module BTF ID */
> > > > -	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> > > > +	if (prog->obj->gen_trace) {
> > > > +		bpf_gen__record_find_name(prog->obj->gen_trace, attach_name, attach_type);
> > > > +		*btf_obj_fd = 0;
> > > > +		*btf_type_id = 1;
> > > 
> > > We have quite some codes like this and may add more to support more
> > > features. I am wondering whether we could have some kind of callbacks
> > > to make the code more streamlined. But I am not sure how easy it is.
> > 
> > you mean find_kernel_btf_id() in general?
> > This 'find' operation is translated differently for
> > prog name as seen in this hunk via bpf_gen__record_find_name()
> > and via bpf_gen__record_extern() in another place.
> > For libbpf it's all find_kernel_btf_id(), but semantically they are different,
> > so they cannot map as-is to gen trace bpf_gen__find_kernel_btf_id (if there was
> > such thing).
> > Because such 'generic' callback wouldn't convey the meaning of what to do
> > with the result of the find.
> 
> I mean like calling
>     err = obj->ops->find_kernel_btf_id(...)
> where gen_trace and normal libbpf all registers their own callback functions
> for find_kernel_btf_id(). Similar ideas can be applied to
> other places or not. Not 100% sure this is the best approach or not,
> just want to bring it up for discussion.

What args that 'ops->find_kernel_btf_id' will have?
If it's done as-is with btf_obj_fd, btf_type_id pointers to store the results
how libbpf will invoke it?
Where this destination pointers point to?
In one case the desitination is btf_id inside bpf_attr to load a prog.
In other case the destination is a btf_id inside bpf_insn ld_imm64.
In other case it could be different bpf_insn.
That's what I meant that semantical context matters
and cannot be expressed a single callback.
bpf_gen__record_find_name vs bpf_gen__record_extern have this semantical
difference builtin into their names. They will be called by libbpf differently.

If you mean to allow to specify all such callbacks via ops and indirect
pointers instead of specific bpf_gen__foo/bar callbacks then it's certainly
doable I just don't see a use case for it. No one bothered to do this
kind of 'strace of libbpf'. It's also not exactly an strace. It's
recording the sequence of events that libbpf is doing.
Consider patch 12. It changes the order of
bpf_object__relocate_data and text. It doesn't call any new bpf_gen__ methods.
But the data these methods will see later is different. In this case they will
see relo->insn_idx that is correct for the whole 'main' program after
subprogs were appended to the end instead of relo->insn_idx that points
within a given subprog.
So this gen_trace logic is very tightly built around libbpf loading
internals and will change in the future as more features will be supported
by this loader prog (like CO-RE).
Hence I don't think 'callback' idea fits here, since callback assumes
generic infra that will likely stay. Whereas here bpf_gen__ methods
are more like tracepoints inside libbpf that will be added and removed.
Nothing stable about them.
If this loader prog logic was built from scratch it probably would be different.
It would just parse elf and relocate text and data.
It would certainly not have hacks like "*btf_obj_fd = 0; *btf_type_id = 1;"
They're only there to avoid changing every check inside libbpf that
assumes that if a helper succeeded these values are valid.
Like if map_create is a success the resulting fd != -1.
The alternative is to do 'if (obj->gen_trace)' in a lot more places
which looks less appealing. I hope to reduce the number of such hacks, of course.
