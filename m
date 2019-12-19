Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFAAF127044
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfLSWEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:04:08 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41266 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSWEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:04:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so4047193pfw.8;
        Thu, 19 Dec 2019 14:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iKSHvrn/3r8/ReeJhzgkZ/w1RHXoQnMBbiU9xmGogzM=;
        b=t8R6Dq6vslycH7CC3VcjeWk28+hY/EsPTeudJAJsWxh5exwtPFDpaFw5OjwuXaa04B
         Yq2FuKA4HGrzfm6MVowzp1h6iV65fAfxysUh/YPd/w2pVe0EMJc3xmDZLWRAh8CagsXb
         lgK0Hclm279SquBjrW5kL2E30X+Gs0I0f1WSrCDGXpECFwc8fy+fHHQTLsIsQqcOES1O
         Zh3yNiYOh9Uy4jVv6ZzaWhuou4jRj3qRrev6a/tvnJQDhT/BAYmOApaydUnX/AO+MA4N
         /qJhpqyQROy94Q2fZyJMOb6ftnOBU5CzYyk0qAleQmJ5Lr4jJkmU8h9r5LSdohXR9D1S
         5aVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iKSHvrn/3r8/ReeJhzgkZ/w1RHXoQnMBbiU9xmGogzM=;
        b=d8ftHccV4q/bqcdyHavF1FTQG80eXe9NbG/l6ZwW1MdmB4XXX7TJFHF0kkma5Wv8Mh
         lHh+Y1cj/ZSpare+kV4s8n+ydNHXjwyCFj+KV4Vtvv16kkNXiHPvW1Ap+BJA6/SKDfpm
         363eB1C2/zcWJF9X3F5YsRtg2jvcuX6vQqA7hZsLZypTKTTALgHBAQXlXf3nTDceSdOu
         Osz45iBz6hZ28M6SvTj6e7/sPkddmANeHkXRr/NrAYC44sOLEADwM8Ll+jSRfurRugjs
         slWhGqm0yH7tWoKx929uF3w1FJk0ZMh1vXnXF0YZLyA6e+nXz1AqBe3gfczCOOWpyRRS
         3I+A==
X-Gm-Message-State: APjAAAXMa3fnRRLKErcKXn5CKv5Dysdn+2V2mf01zFIjR6xXFexaW4aF
        gNBoGHQbGp689EEqe1zelU2eJ70A
X-Google-Smtp-Source: APXvYqx6WhMI/pC0qKh3qCXAqIXdHi0Sth1kXisyGajGpzBSrlUZ8nO8k2telIXUkh1l4gbO62y7rQ==
X-Received: by 2002:a63:3484:: with SMTP id b126mr11052537pga.17.1576793046092;
        Thu, 19 Dec 2019 14:04:06 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::b180])
        by smtp.gmail.com with ESMTPSA id y128sm7957829pfy.146.2019.12.19.14.04.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 14:04:04 -0800 (PST)
Date:   Thu, 19 Dec 2019 14:04:03 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump
 command
Message-ID: <20191219220402.cdmxkkz3nmwmk6rc@ast-mbp.dhcp.thefacebook.com>
References: <20191219070659.424273-1-andriin@fb.com>
 <20191219070659.424273-2-andriin@fb.com>
 <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYKf=+WNZv5HMv=W8robWWTab1L5NURAT=N7LQNW4oeGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYKf=+WNZv5HMv=W8robWWTab1L5NURAT=N7LQNW4oeGQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 01:07:38PM -0800, Andrii Nakryiko wrote:
> On Thu, Dec 19, 2019 at 9:06 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Dec 18, 2019 at 11:06:56PM -0800, Andrii Nakryiko wrote:
> > > +     if (core_mode) {
> > > +             printf("#if defined(__has_attribute) && __has_attribute(preserve_access_index)\n");
> > > +             printf("#define __CLANG_BPF_CORE_SUPPORTED\n");
> > > +             printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
> > > +             printf("#endif\n\n");
> >
> > I think it's dangerous to automatically opt-out when clang is not new enough.
> > bpf prog will compile fine, but it will be missing co-re relocations.
> > How about doing something like:
> >   printf("#ifdef NEEDS_CO_RE\n");
> >   printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
> >   printf("#endif\n\n");
> > and emit it always when 'format c'.
> > Then on the program side it will look:
> > #define NEEDS_CO_RE
> > #include "vmlinux.h"
> > If clang is too old there will be a compile time error which is a good thing.
> > Future features will have different NEEDS_ macros.
> 
> Wouldn't it be cleaner to separate vanilla C types dump vs
> CO-RE-specific one? I'd prefer to have them separate and not require
> every application to specify this #define NEEDS_CO_RE macro.
> Furthermore, later we probably are going to add some additional
> auto-generated types, definitions, etc, so plain C types dump and
> CO-RE-specific one will deviate quite a bit. So it feels cleaner to
> separate them now instead of polluting `format c` with irrelevant
> noise.

Say we do this 'format core' today then tomorrow another tweak to vmlinux.h
would need 'format core2' ? I think adding new format to bpftool for every
little feature will be annoying to users. I think the output should stay as
'format c' and that format should be extensible/customizable by bpf progs via
#define NEEDS_FEATURE_X. Then these features can grow without a need to keep
adding new cmd line args. This preserve_access_index feature makes up for less
than 1% difference in generated vmlinux.h. If some feature extension would
drastically change generated .h then it would justify new 'format'. This one is
just a small tweak. Also #define NEEDS_CO_RE is probably too broad. I think
#define CLANG_NEEDS_TO_EMIT_RELO would be more precise and less ambiguous.
