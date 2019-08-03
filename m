Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB5880738
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 18:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbfHCQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 12:26:02 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:42627 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387464AbfHCQ0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 12:26:02 -0400
Received: by mail-pf1-f180.google.com with SMTP id q10so37516081pff.9;
        Sat, 03 Aug 2019 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E5w+W8bz4charNSY/Sd+qsB1bjx54D05GDrNpMB2JCs=;
        b=puXO2Hnmm+dRFDD1uqqCTYxuWK+TG0nYMIz4OWz1dD4ykboF9YMOiovpHjTHvXQ5WU
         HAPWY7uGB3/6msQYlViWVGrYmI9Ku6Oi0zye/+g5vLAYxYrnp6ik5xFwWYILPUi+wYzc
         7fkcdA1Vuc6vOd07XDtKjMqfm81tN8Thic37nXiv7Cada1kUMlo7zjTUrr/lT2h8eafJ
         +YxuBK8ifYlKEU1bnR55sO0w3p6JWpFFobwyJYGU26cKL7OC7I+5j0yJkT4S1wLefmh/
         Qi3b5Fg5n0ZKdfh1Jt7AmZUmZ1QyIUeq8a75o7zHDTODAXENYpnpx7GWUqQZ6wK71UU1
         RWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E5w+W8bz4charNSY/Sd+qsB1bjx54D05GDrNpMB2JCs=;
        b=J6kHPAuLZ6vvAPHbbD/W29pQ9gldtccbJREHKMXAZMmbZkFODgOdW7gl5dO21NR4q9
         OgPQtmo+HR0k3UmOlSx5yqYnnQgNqEkmZ4ic1LC+CtFS9M5/qG+NGJPnrG9K/jCTd0U3
         WLFXWLQL1dFEfG/Nka29Faw9CXLGUp6jcxNMq8jEnKmsq9cdr2bp8FcgWYkw7RA+v7kX
         mUaTbZfoQB1L763oXa9LZ50M/SOynZo0A2vRzJehwb/Ed+hV5hS6gdyrN8nOdH9REKOL
         dkk3kEojJqBPF+iaWOZDxAVewApRXzspB60ILlgFiNwH1D02f1QZda73ToaBmbn0zxRN
         EFKw==
X-Gm-Message-State: APjAAAWeBDdm/c/xpGUfRw1em3+PyF50s5pzFrTx5XD+s2ii+oAUQhsh
        mdOQ2Bgk+I7V44NKhoSamHM9MUf2
X-Google-Smtp-Source: APXvYqxD3wSRZ0r0+xghGyiu/bWc7Q1yweEqVIS9+v0Q1XRhMs/HsrbwNiPGIA7jn9ByUA+mB47SRA==
X-Received: by 2002:a63:550d:: with SMTP id j13mr66832096pgb.173.1564849560930;
        Sat, 03 Aug 2019 09:26:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::e23a])
        by smtp.gmail.com with ESMTPSA id bo20sm9779373pjb.23.2019.08.03.09.25.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Aug 2019 09:26:00 -0700 (PDT)
Date:   Sat, 3 Aug 2019 09:25:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
Message-ID: <20190803162556.pdbckv7yta4wigjk@ast-mbp.dhcp.thefacebook.com>
References: <20190801064803.2519675-1-andriin@fb.com>
 <20190801064803.2519675-3-andriin@fb.com>
 <20190801235030.bzssmwzuvzdy7h7t@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzarjODxo5c-UKtCL_dGGNb1m-3QPAGGR0eq_0tcZVMt8g@mail.gmail.com>
 <20190802215604.onihsysinwiu3shl@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzY46=Vosd+kha+_Yh_iXNXhgfSW3ihePApb4GfuzoUU6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY46=Vosd+kha+_Yh_iXNXhgfSW3ihePApb4GfuzoUU6w@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 11:30:21PM -0700, Andrii Nakryiko wrote:
> 
> No, not anonymous.
> 
> struct my_struct___local {
>     int a;
> };
> 
> struct my_struct___target {
>     long long a;
> };
> 
> my_struct___local->a will not match my_struct___target->a, but it's
> not a reason to stop relocation process due to error.

why? It feels that this is exactly the reason to fail relocation.
struct names matched. field names matched.
but the types are different. Why proceed further?

Also what about str->a followed by str->b.
Is it possible that str->a will pick up one flavor when str->b different one?
That will likely lead to wrong behavior?

> 
> All the tests I added use non-numeric flavors. While technically I can
> use just ___1, ___2 and so on, it will greatly reduce readability,
> while not really solving any problem (nothing prevents someone to add
> something like lmc___1 eventually).
> 
> I think it's not worth it to complicate this logic just for
> lmc___{softc,media,ctl}, but we can do 2) - try to match any struct as
> is. If that fails, see if it's a "flavor" and match flavors.

Could you please share benchmarking results of largish bpf prog
with couple thousands relocations against typical vmlinux.h ?
I'm concerned that this double check will be noticeable.
May be llvm should recognize "flavor" in the type name and
encode them differently in BTF ?
Or add a pre-pass to libbpf to sort out all types into flavored and not.
If flavored search is expensive may be all flavors could be a linked list
from the base type. The typical case is one or two flavors, right?

> > > > > +     for (i = 0, j = 0; i < cand_ids->len; i++) {
> > > > > +             cand_id = cand_ids->data[i];
> > > > > +             cand_type = btf__type_by_id(targ_btf, cand_id);
> > > > > +             cand_name = btf__name_by_offset(targ_btf, cand_type->name_off);
> > > > > +
> > > > > +             err = bpf_core_spec_match(&local_spec, targ_btf,
> > > > > +                                       cand_id, &cand_spec);
> > > > > +             if (err < 0) {
> > > > > +                     pr_warning("prog '%s': relo #%d: failed to match spec ",
> > > > > +                                prog_name, relo_idx);
> > > > > +                     bpf_core_dump_spec(LIBBPF_WARN, &local_spec);
> > > > > +                     libbpf_print(LIBBPF_WARN,
> > > > > +                                  " to candidate #%d [%d] (%s): %d\n",
> > > > > +                                  i, cand_id, cand_name, err);
> > > > > +                     return err;
> > > > > +             }
> > > > > +             if (err == 0) {
> > > > > +                     pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match spec ",
> > > > > +                              prog_name, relo_idx, i, cand_id, cand_name);
> > > > > +                     bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
> > > > > +                     libbpf_print(LIBBPF_DEBUG, "\n");
> > > > > +                     continue;
> > > > > +             }
> > > > > +
> > > > > +             pr_debug("prog '%s': relo #%d: candidate #%d matched as spec ",
> > > > > +                      prog_name, relo_idx, i);
> > > >
> > > > did you mention that you're going to make a helper for this debug dumps?
> > >
> > > yeah, I added bpf_core_dump_spec(), but I don't know how to shorten
> > > this further... This output is extremely useful to understand what's
> > > happening and will be invaluable when users will inevitably report
> > > confusing behavior in some cases, so I still want to keep it.
> >
> > not sure yet. Just pointing out that this function has more debug printfs
> > than actual code which doesn't look right.
> > We have complex algorithms in the kernel (like verifier).
> > Yet we don't sprinkle printfs in there to this degree.
> >
> 
> We do have a verbose verifier logging, though, exactly to help users
> to debug issues, which is extremely helpful and is greatly appreciated
> by users.
> There is nothing worse for developer experience than getting -EINVAL
> without any useful log message. Been there, banged my head against the
> wall wishing for a bit more verbose log. What are we trying to
> optimize for here?

All I'm saying that three printfs in a row that essentially convey the same info
look like clowntown. Some level of verbosity is certainly useful.

