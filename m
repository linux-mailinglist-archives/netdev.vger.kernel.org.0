Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEEA1FFDA9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgFRWFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgFRWFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:05:15 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C3BC06174E;
        Thu, 18 Jun 2020 15:05:15 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e9so3550138pgo.9;
        Thu, 18 Jun 2020 15:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2DMNzW+GPQTZ6J+BWzPlSfpCXxGFmix9cEiVxbwMHso=;
        b=e9yraZdGnH6rdJxbjV0DVp9IzGl9kjC6WhSeIyqQh3RSLCH1YS/Tzz9ZrvciWJ58Ql
         dTXTk3IUE5XQJ0G1tDprQiIqmtdKnsvH34hyXWeVIfgXfLx09nIyjUz2mAwKIq8/DE6s
         lSgGVzR+OHLcQdhg95KaQn5Osv74HnU1hGONsQK8IsKvnolnUeI7tkQNVXTA11F+SHEK
         D3iKgiArPSVmQLjTUBvdx2QsAA/GuDEfsA1SfNfDsHodZP2lSjJjr+Begy8dBFqlZFRC
         dUD5l6DDqk61K7YfHQAEPhkWcKJFulu3MmMj0Edx5lM+k4oSieW+NKsghqk4Lct7v5qo
         q14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2DMNzW+GPQTZ6J+BWzPlSfpCXxGFmix9cEiVxbwMHso=;
        b=KqfnDNEtV9+PoS7jTTHIpXm3mINXlDjsk4qOyh06u/0ZXUFJjtWPeTZo7fH2DQniDl
         G3nKDKhbAvy8TqmcxNEhLGbfrQ+Oiy3ECsOKtDHc7STlLD17ZguxTjHDng246c9TenVd
         74dfgF/OYcnRFT+KD4tug8wgjmTIHJt5YJ/KaWuhyvnKPiaGudKpydRWritWU8n6md/v
         XjC9fgVhpV0QEtopOPTF3/Y1oz7d3wmsXfgkhQWISb+BwC09pPDsIW+y6ZsJxDxQJ5lo
         yHgsEIP4VnG5zox2kCnTzHtxYJWY+rwSc1/sjKbAsdbqVMBwXr5QZ1BWZKhn6roQxswU
         683Q==
X-Gm-Message-State: AOAM533ibWTlQc2/3M83KPhnIxu8O+sgsVAKCDjlN+a5La4WkbkUzaiA
        FApJI2XTHvPLXLpsPL8hekI=
X-Google-Smtp-Source: ABdhPJxlmBAKDAE2MTdp2FLQI5ROVwoMLev8vVnk5R3IYEXhI82iW/tasyQ5Fn8KueUccrM7QoUgkA==
X-Received: by 2002:a62:1917:: with SMTP id 23mr5352808pfz.272.1592517915097;
        Thu, 18 Jun 2020 15:05:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5bc2])
        by smtp.gmail.com with ESMTPSA id 191sm3883870pfz.30.2020.06.18.15.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 15:05:14 -0700 (PDT)
Date:   Thu, 18 Jun 2020 15:05:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
Message-ID: <20200618220511.jrwes44dfh7v52tt@ast-mbp.dhcp.thefacebook.com>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618114806.GA2369163@krava>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 01:48:06PM +0200, Jiri Olsa wrote:
> On Wed, Jun 17, 2020 at 04:20:54PM -0700, John Fastabend wrote:
> > Jiri Olsa wrote:
> > > This way we can have trampoline on function
> > > that has arguments with types like:
> > > 
> > >   kuid_t uid
> > >   kgid_t gid
> > > 
> > > which unwind into small structs like:
> > > 
> > >   typedef struct {
> > >         uid_t val;
> > >   } kuid_t;
> > > 
> > >   typedef struct {
> > >         gid_t val;
> > >   } kgid_t;
> > > 
> > > And we can use them in bpftrace like:
> > > (assuming d_path changes are in)

the patch doesn't seem to be related to d_path. Unless I'm missing something.

Please add a selftest. bpftrace example is nice, but selftest is still mandatory.

> > > 
> > >   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
> > >   Attaching 1 probe...
> > >   uid 0, gid 0
> > >   uid 1000, gid 1000
> > >   ...
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/bpf/btf.c | 12 +++++++++++-
> > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 58c9af1d4808..f8fee5833684 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
> > >  	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> > >  }
> > >  
> > > +/* type is struct and its size is within 8 bytes
> > > + * and it can be value of function argument
> > > + */
> > > +static bool btf_type_is_struct_arg(const struct btf_type *t)
> > > +{
> > > +	return btf_type_is_struct(t) && (t->size <= sizeof(u64));

extra () are unnecessary.

the function needs different name. May btf_type_is_struct_by_value() ?

> > 
> > Can you comment on why sizeof(u64) here? The int types can be larger
> > than 64 for example and don't have a similar check, maybe the should
> > as well?
> > 
> > Here is an example from some made up program I ran through clang and
> > bpftool.
> > 
> > [2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED
> > 
> > We also have btf_type_int_is_regular to decide if the int is of some
> > "regular" size but I don't see it used in these paths.
> 
> so this small structs are passed as scalars via function arguments,
> so the size limit is to fit teir value into register size which holds
> the argument
> 
> I'm not sure how 128bit numbers are passed to function as argument,
> but I think we can treat them separately if there's a need
> 
> jirka
> 
> > 
> > > +}
> > > +
> > >  static bool __btf_type_is_struct(const struct btf_type *t)
> > >  {
> > >  	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
> > > @@ -3768,7 +3776,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> > >  	/* skip modifiers */
> > >  	while (btf_type_is_modifier(t))
> > >  		t = btf_type_by_id(btf, t->type);
> > > -	if (btf_type_is_int(t) || btf_type_is_enum(t))
> > > +	if (btf_type_is_int(t) || btf_type_is_enum(t) || btf_type_is_struct_arg(t))
> > >  		/* accessing a scalar */
> > >  		return true;

It probably needs to be x86 gated?
I don't think all archs do that for small structs.

What kind of code clang generates for bpf prog?
I don't remember what we told clang to do for struct by value.
That has to be carefully defined and tested.
