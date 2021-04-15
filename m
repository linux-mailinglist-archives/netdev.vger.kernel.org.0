Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52E335FFC6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhDOCCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDOCCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:02:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33367C061574;
        Wed, 14 Apr 2021 19:01:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t23so11215813pjy.3;
        Wed, 14 Apr 2021 19:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KqVKCx08Iagul3orIQJ9a4pRof71PVw3e9GLFVbSdIg=;
        b=Sr/y4PYYBWJgq/9kuT/DpaL4/bOMb0qpjyla4kyeV3igVnJM0vgtXvDoVW44HeNQDg
         1IB6Gyc1ve2mL5nJwAHpn/YNAH9UXieDzsJNZoQ1eyKhPXB0SlKCQHWltg9LgjsLoRAu
         Wa37wlAEfohpYCBNLeq28p7bMMDJsekBMMHmnOKWOIE7GMypKZwxuX0tkkLnV1CA0LMg
         frsqWmEQnNpbpwJsyczF1LAt+3tW0QZk4rNloCiVHdGZwWLeNK50T+iI/ZWCQ2xIkomz
         N96fRnxt6+hSX9dQwjUYHpW+a0ICFqDvkItem7iqt0vK2yihIClBEf6/+bX4FKCV1OYb
         2clQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KqVKCx08Iagul3orIQJ9a4pRof71PVw3e9GLFVbSdIg=;
        b=M3lqUUWKeB35gyfASkyNyCWmnMKzAa2REZ4yHEFB0iRmRx8l7QrlwzfZBlj5Si+nmO
         T6xsH1ivXwL2/zSknPvm9rfGNn2uOtyHVeD8q6JXXW6p2IgUAGG4N7xej+mR+6zaNCAt
         J4wZYtAXF0R/vxO5c1I5OaxgF036wOFyOsdxLQi9JNBfjYcBXTbehNqh8+SrWLHSEWwI
         4XhzZk7vc4KWN5daKiY5fN7YnjfNOFAAbajDvoMsV4CSsyWKeeR1gmp7xbvZCaAfAJ11
         qSrYQUOHB/DgssM6Ek6K/bDNwBCs8iluX4q4TTL7NB1XXH/fYh6LnwJTVnGNvANyifTh
         ER1g==
X-Gm-Message-State: AOAM530PiQmCVPSRb4JW/aga6D0bQ0MoTmVgzveBYe9VW1Ct4T3V8Gwe
        FNKJHcCiJ02IE8HvLD1R5wC/2stNUgw=
X-Google-Smtp-Source: ABdhPJx42pXbdNpCdN0qwejMPe/nUfAr8gRzfAtGqw5MAAbBmzm4RxKdiFmAQUaXEJHVNfS6+ZlmhQ==
X-Received: by 2002:a17:90a:aa15:: with SMTP id k21mr1167544pjq.115.1618452101411;
        Wed, 14 Apr 2021 19:01:41 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c1f1])
        by smtp.gmail.com with ESMTPSA id q63sm536510pjq.17.2021.04.14.19.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 19:01:40 -0700 (PDT)
Date:   Wed, 14 Apr 2021 19:01:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
Message-ID: <20210415020138.2dbcflpxq2zwu6b2@ast-mbp>
References: <20210414200146.2663044-1-andrii@kernel.org>
 <20210414200146.2663044-13-andrii@kernel.org>
 <f3f3bcc5-be1a-6d11-0c6e-081fc30367c4@fb.com>
 <CAEf4BzZnyij-B39H_=RahUV2=RzNHTHt4Bdrw2sPY9eraW4p7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZnyij-B39H_=RahUV2=RzNHTHt4Bdrw2sPY9eraW4p7A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 04:48:25PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 14, 2021 at 3:00 PM Alexei Starovoitov <ast@fb.com> wrote:
> >
> > On 4/14/21 1:01 PM, Andrii Nakryiko wrote:
> > > Add extra logic to handle map externs (only BTF-defined maps are supported for
> > > linking). Re-use the map parsing logic used during bpf_object__open(). Map
> > > externs are currently restricted to always and only specify map type, key
> > > type and/or size, and value type and/or size. Nothing extra is allowed. If any
> > > of those attributes are mismatched between extern and actual map definition,
> > > linker will report an error.
> >
> > I don't get the motivation for this.
> > It seems cumbersome to force users to do:
> > +extern struct {
> > +       __uint(type, BPF_MAP_TYPE_HASH);
> > +       __type(key, key_type);
> > +       __type(value, value_type);
> > +       /* no max_entries on extern map definitions */
> > +} map1 SEC(".maps");
> 
> The intent was to simulate what you'd have in a language with
> generics. E.g., if you were declaring extern for a map in C++:
> 
> extern std::map<key_type, value_type> my_map;

right, because C++ will mangle types into names.
When llvm bpf backend will support C++ front-end it will do the mangling too.
I think BPF is ready for C++, but it's a separate discussion, of course.

> > but there is only one such full map definition.
> > Can all externs to be:
> > extern struct {} map1 SEC(".maps");
> 
> I can certainly modify logic to allow this. But for variables and
> funcs we want to enforce type information, right? So I'm not sure why
> you think it's bad for maps.

I'm not saying it's bad.
Traditional linker only deals with names, since we're in C domain, so far,
I figured it's an option, but more below.
C++ is good analogy too.

> So if it's just a multi-file application and you don't care which file
> declares that map, you can do a single __weak definition in a header
> and forget about it.
> 
> But imagine a BPF library, maintained separately from some BPF
> application that is using it. And imagine that for some reason that
> BPF library wants/needs to "export" its map directly. In such case,
> I'd imagine BPF library author to provide a header with pre-defined
> correct extern definition of that map.

I'm mainly looking at patch 17 and thinking how that copy paste can be avoided.
In C and C++ world the user would do:
defs.h:
  struct S {
    ...
  };
  extern struct S s;
file.c:
  #include "defs.h"
  struct S s;
and it would work, but afaics it won't work for BPF C in patch 17.
If the user does:
defs.h:
  struct my_map {
          __uint(type, BPF_MAP_TYPE_HASH);
          __type(key, struct my_key);
          __type(value, struct my_value);
          __uint(max_entries, 16);
  };
  extern struct my_map map1 SEC(".maps");
file.c:
  #include "defs.h"
  struct my_map map1;  // do we need SEC here too? probably not?

It won't work for another_filer.c since max_entries are not allowed?
Why, btw?

So how the user suppose to do this? With __weak in .h ?
But if that's the only reasonable choice whe bother supporting extern in the linker?

> I originally wanted to let users define which attributes matter and
> enforce them (as I mention in the commit description), but that
> requires some more work on merging BTF. Now that I'm done with all the
> rest logic, I guess I can go and address that as well.

I think that would be overkill. It won't match neither C style nor C++.
Let's pick one.

> So see above about __weak. As for the BPF library providers, that felt
> unavoidable (and actually desirable), because that's what they would
> do with extern func and extern vars anyways.

As far as supporting __weak for map defs, I think __weak in one file.c
should be weak for all attributes. Another_file.c should be able
to define the same map name without __weak and different types, value/type
sizes. Because why not? Sort-of C++ style of override.

> so forcing to type+key+value is to make sure that currently all
> externs (if there are many) are exactly the same. Because as soon as I
> allow some to specify max_entries and some don't,

I don't get why max_entries is special.
They can be overridden in typical skeleton usage. After open and before load.
So max_entries is a default value in map init. Whether it's part of
extern or not why should that matter?

> Maybe nothing, just there is no single right answer (except the
> aspirational implementation I explained above). I'm open to
> discussion, btw, not claiming my way is the best way.

I'm not suggesting that extern struct {} my_map; is the right answer either.
Mainly looking into how user code will look like and trying to
make it look the most similar to how C, C++ code traditionally looks.
BPF C is reduced and extended C at the same time.
BPF C++ will be similar. Certain features will be supported right away,
some others will take time.
I'm looking at BTF as a language independent concept.
Both C and C++ will rely on it.

To summarize if max_entries can be supported and ingored in extern
when the definition has a different value then it's probably good to enforce
that the rest of map fields are the same. Then my .h/.c example above will work.
In case of __weak probably all map fields can change.
It can be seen as a weak definition of the whole map. Not just weak of the variable.
It's a default for everything that can be overridden.
While non-weak can override max_entries only.

btw for signed progs I'm thinking to allow override of max_entries only,
since this attribute doesn't affect safety, correctness, behavior.
Meaning max_entries will and will not be part of a signature at the same time.
In other words it's necessary to support existing bcc/libbpf-tools.
If we go with 'allow max_entries in extern' that would match that behavior.
