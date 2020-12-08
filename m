Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E62D2152
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgLHDMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgLHDMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:12:51 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF39C0613D6;
        Mon,  7 Dec 2020 19:12:10 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id bj5so6240345plb.4;
        Mon, 07 Dec 2020 19:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KQ9uRpmBuJGJjQzyCNv6aAvsoTL8pzGuqnCLRpSMCuE=;
        b=Acfz00LgKxRmaEQgc6hVcS/CaUrWpMs9L/FRpmlup1VUbqPqBbTCn5UYRRLrdxoEv7
         4hXs7iplcJVBOSYAoJgOFxjKN84hhQi733S/zNunoOdUBqu/zcvIexyfy86ZtQKeCKXr
         FF8CZJ3E2VQ0OtN7JHLl5mU4/EE//9jp56/IiRDilUrTubaB+0mx2mRt9GY19wFB5vdv
         K9G1N3k3pYbaM98cSv757Fh5WTPyigD8NF+X03KZd6WK51AfFYmaQwwgKMTawV/y9zwc
         RYFCohbWoqpvLp7lr2XDNzcCnbX7M1pPlVJIikLYRVz+u2QD+UR05BS5wsvslKyAMGEM
         JHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KQ9uRpmBuJGJjQzyCNv6aAvsoTL8pzGuqnCLRpSMCuE=;
        b=pq8TOs1Na/+xExjNJpGzAt7DjU3Ye6yXxAXnBYSCG2LfhKluW41veZzlKynD4LV8H2
         OzSApC8v1UXe7Ti6AO2YE6GlCDgbiWeWK5i9OhL35Q5wP1VLdjORfk9+2aVJC37+1qph
         lc2aVreojQVgzay9q1dSCDO+lNQqsmcTnFqvcUtIN2q5XCWbOYPm/2sa6eb6fAXPxVcu
         PVCraK9I3vNpkqIf0XMItaxYHgTHWXxL4+FUKPz+pk85WY/fbjKM1ULATnkf2wUusMXa
         YK4Ax/W6A172CrR335Ylpxv7Ah9g8Va6LiajMX8OUz64wgUsRwYs0YgnGOia4JbP3++0
         5gQQ==
X-Gm-Message-State: AOAM532qC7UavFb0nGQXJ6CqA/Avx6o9zMW9iJwF1MgBDYDhbMrT4gLR
        oQba90WIxhSWoVsi5ngj/HOd8dTZiWI=
X-Google-Smtp-Source: ABdhPJwA6US2Pl81XZE38AJ1RVMqyM4bpDFYjf5ZTP8XIudG+4NI6thbos5Oq7vokil1MB1cw5lBeg==
X-Received: by 2002:a17:902:b7cb:b029:db:c0d6:96ee with SMTP id v11-20020a170902b7cbb02900dbc0d696eemr864841plz.21.1607397130338;
        Mon, 07 Dec 2020 19:12:10 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:7f0])
        by smtp.gmail.com with ESMTPSA id a124sm16300222pfd.43.2020.12.07.19.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 19:12:09 -0800 (PST)
Date:   Mon, 7 Dec 2020 19:12:06 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for
 BPF_TYPE_ID_TARGET CO-RE relocation
Message-ID: <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
References: <20201205025140.443115-1-andrii@kernel.org>
 <alpine.LRH.2.23.451.2012071623080.3652@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.23.451.2012071623080.3652@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 04:38:16PM +0000, Alan Maguire wrote:
> On Fri, 4 Dec 2020, Andrii Nakryiko wrote:
> 
> > When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
> > put module BTF FD, containing target type, into upper 32 bits of imm64.
> > 
> > Because this FD is internal to libbpf, it's very cumbersome to test this in
> > selftests. Manual testing was performed with debug log messages sprinkled
> > across selftests and libbpf, confirming expected values are substituted.
> > Better testing will be performed as part of the work adding module BTF types
> > support to  bpf_snprintf_btf() helpers.
> > 
> > Cc: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 9be88a90a4aa..539956f7920a 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4795,6 +4795,7 @@ static int load_module_btfs(struct bpf_object *obj)
> >  
> >  		mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
> >  
> > +		btf__set_fd(btf, fd);
> >  		mod_btf->btf = btf;
> >  		mod_btf->id = id;
> >  		mod_btf->fd = fd;
> > @@ -5445,6 +5446,10 @@ struct bpf_core_relo_res
> >  	__u32 orig_type_id;
> >  	__u32 new_sz;
> >  	__u32 new_type_id;
> > +	/* FD of the module BTF containing the target candidate, or 0 for
> > +	 * vmlinux BTF
> > +	 */
> > +	int btf_obj_fd;
> >  };
> >  
> >  /* Calculate original and target relocation values, given local and target
> > @@ -5469,6 +5474,7 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
> >  	res->fail_memsz_adjust = false;
> >  	res->orig_sz = res->new_sz = 0;
> >  	res->orig_type_id = res->new_type_id = 0;
> > +	res->btf_obj_fd = 0;
> >  
> >  	if (core_relo_is_field_based(relo->kind)) {
> >  		err = bpf_core_calc_field_relo(prog, relo, local_spec,
> > @@ -5519,6 +5525,9 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
> >  	} else if (core_relo_is_type_based(relo->kind)) {
> >  		err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
> >  		err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val);
> > +		if (!err && relo->kind == BPF_TYPE_ID_TARGET &&
> > +		    targ_spec->btf != prog->obj->btf_vmlinux) 
> > +			res->btf_obj_fd = btf__fd(targ_spec->btf);
> 
> Sorry about this Andrii, but I'm a bit stuck here.
> 
> I'm struggling to get tests working where the obj fd is used to designate
> the module BTF. Unless I'm missing something there are a few problems:
> 
> - the fd association is removed by libbpf when the BPF program has loaded; 
> the module fds are closed and the module BTF is discarded.  However even if 
> that isn't done (and as you mentioned, we could hold onto BTF that is in 
> use, and I commented out the code that does that to test) - there's 
> another problem:
> - I can't see a way to use the object fd value we set here later in BPF 
> program context; btf_get_by_fd() returns -EBADF as the fd is associated 
> with the module BTF in the test's process context, not necessarily in 
> the context that the BPF program is running.  Would it be possible in this 
> case to use object id? Or is there another way to handle the fd->module 
> BTF association that we need to make in BPF program context that I'm 
> missing?
> - A more long-term issue; if we use fds to specify module BTFs and write 
> the object fd into the program, we can pin the BPF program such that it 
> outlives fds that refer to its associated BTF.  So unless we pinned the 
> BTF too, any code that assumed the BTF fd-> module mapping was valid would 
> start to break once the user-space side went away and the pinned program 
> persisted. 

All of the above are not issues. They are features of FD based approach.
When the program refers to btf via fd the verifier needs to increment btf's refcnt
so it won't go away while the prog is running. For module's BTF it means
that the module can be unloaded, but its BTF may stay around if there is a prog
that needs to access it.
I think the missing piece in the above is that btf_get_by_fd() should be
done at load time instead of program run-time.
Everything FD based needs to behave similar to map_fds where ld_imm64 insn
contains map_fd that gets converted to map_ptr by the verifier at load time.
In this case single ld_imm64 with 32-bit FD + 32-bit btf_id is not enough.
So either libbpf or the verifier need to insert additional instruction.
I'm not sure yet how to extend 'struct btf_ptr' cleanly, so it looks good
from C side. 
In the other patch I saw:
struct btf_ptr {
        void *ptr;
        __u32 type_id;
-       __u32 flags;            /* BTF ptr flags; unused at present. */
+       __u32 obj_id;           /* BTF object; vmlinux if 0 */
 };
The removal of flags cannot be done, since it will break progs.
Probably something like this:
struct btf_ptr {
  void *ptr;
  __u32 type_id;
  __u32 flags;
  __u64 btf_obj_fd; /* this is 32-bit FD for libbpf which will become pointer after load */
};
would be the most convenient from the bpf prog side. The ld_imm64 init of
btf_obj_fd will be replaced with absolute btf pointer by the verifier. So when
bpf_snprintf_btf() is called the prog will pass the kernel internal pointer
of struct btf to the helper. No extra run-time checks needed.
bpf_snprintf_btf() would print that type_id within given struct btf object.
libbpf would need to deal with two relos. One to store btf_id from
bpf_core_type_id_kernel() into type_id. And another to find module's BTF and
store its FD into btf_obj_fd with ld_imm64. I'm still thinking to how to frame
that cleanly from C side.
Other ideas?
