Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FEF1FFF39
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgFSA0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgFSA0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:26:06 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B2C06174E;
        Thu, 18 Jun 2020 17:26:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h22so3526912pjf.1;
        Thu, 18 Jun 2020 17:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=aj0imADQg4RStSAonDZf7sUXgDdngAlbzeglnzpV/aM=;
        b=mFfa+OD7OeQiJetxno6Uu4wfmDt3N19Wy0ic3Cio41JNJh0erskPnECViZVdlGb2MI
         VWtY8wMO6HSZIjWxLVhjU571YFNypyYbO53q3CLeGM6XNI/h49BHmH+PfCIoMkJhTx4R
         /atUw5t65unWzC5p1TS5fz87X6GaDXtDz+2kvGNat74+8qVczlmfR51uEUHWvn+GT+2C
         fWHGp2iu+AkS+cc+t3neWLLJ8TmKzWdbADpHtfkn3OGfdOGzB+74hedUvqRat+S3rG4k
         U8LKjbkv9QkHtPJH5EkkoRJvilpZ2JVcm8aiZWB3mDGNVz6ZUuVd9lYF8DkGsN1ItL3D
         VqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=aj0imADQg4RStSAonDZf7sUXgDdngAlbzeglnzpV/aM=;
        b=r4PQnHbwcrd4Bf6eY5lHlDz4kQv8mlwAwvs7ayeebE0Le0Zckyi/l3EfIfQB+rzunX
         yI86QIBCRR+8FFksr5/oM2LdNw6axs1U53Kx/lWbIQQOTFhtkuK4jfi0k7vYdnCgHELi
         b2Xc5+ftb6LH/y16Eji33DM5/QxOgmjjjBA2wRyVFFP3XuYxH7xLgzfGmgx2zXy2+hwd
         LO13WKGv7Ro1y56979bN6Vf8Oad4PTzRcaH3UgupMVZwLspbOp5R+BVEJMILuHOBmEBp
         Ej9ua+Cjhcutr41aKk3F5xNTczakhwbGxJfMsl4H23UbO6UDYbUpUkbE/nuwEgdiwWaS
         53Tg==
X-Gm-Message-State: AOAM533Fh/rw2XZcZgrw0TDwmFVrlBljzj7zqJG48QuRUS6w9MmF35jj
        PdcOajZDg+0A7lGptVT73f8=
X-Google-Smtp-Source: ABdhPJwU4+Yl5BnuV+VHSrhXddxtutWKvJx62LeZVWGBnc1GkcJZgqToQbAD3q6rD4BA5HpOIo9Q9Q==
X-Received: by 2002:a17:90a:39ce:: with SMTP id k14mr886264pjf.39.1592526365973;
        Thu, 18 Jun 2020 17:26:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q6sm3913172pff.79.2020.06.18.17.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 17:26:05 -0700 (PDT)
Date:   Thu, 18 Jun 2020 17:25:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Message-ID: <5eec061598dcf_403f2afa5de805bcde@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
 <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
 <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, Jun 18, 2020 at 3:50 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Jiri Olsa wrote:
> > > On Wed, Jun 17, 2020 at 04:20:54PM -0700, John Fastabend wrote:
> > > > Jiri Olsa wrote:
> > > > > This way we can have trampoline on function
> > > > > that has arguments with types like:
> > > > >
> > > > >   kuid_t uid
> > > > >   kgid_t gid
> > > > >
> > > > > which unwind into small structs like:
> > > > >
> > > > >   typedef struct {
> > > > >         uid_t val;
> > > > >   } kuid_t;
> > > > >
> > > > >   typedef struct {
> > > > >         gid_t val;
> > > > >   } kgid_t;
> > > > >
> > > > > And we can use them in bpftrace like:
> > > > > (assuming d_path changes are in)
> > > > >
> > > > >   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
> > > > >   Attaching 1 probe...
> > > > >   uid 0, gid 0
> > > > >   uid 1000, gid 1000
> > > > >   ...
> > > > >
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > ---
> > > > >  kernel/bpf/btf.c | 12 +++++++++++-
> > > > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > > index 58c9af1d4808..f8fee5833684 100644
> > > > > --- a/kernel/bpf/btf.c
> > > > > +++ b/kernel/bpf/btf.c
> > > > > @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
> > > > >   return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> > > > >  }
> > > > >
> > > > > +/* type is struct and its size is within 8 bytes
> > > > > + * and it can be value of function argument
> > > > > + */
> > > > > +static bool btf_type_is_struct_arg(const struct btf_type *t)
> > > > > +{
> > > > > + return btf_type_is_struct(t) && (t->size <= sizeof(u64));
> > > >
> > > > Can you comment on why sizeof(u64) here? The int types can be larger
> > > > than 64 for example and don't have a similar check, maybe the should
> > > > as well?
> > > >
> > > > Here is an example from some made up program I ran through clang and
> > > > bpftool.
> > > >
> > > > [2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED
> > > >
> > > > We also have btf_type_int_is_regular to decide if the int is of some
> > > > "regular" size but I don't see it used in these paths.
> > >
> > > so this small structs are passed as scalars via function arguments,
> > > so the size limit is to fit teir value into register size which holds
> > > the argument
> > >
> > > I'm not sure how 128bit numbers are passed to function as argument,
> > > but I think we can treat them separately if there's a need
> > >
> >
> > Moving Andrii up to the TO field ;)
> 
> I've got an upgrade, thanks :)
> 
> >
> > Andrii, do we also need a guard on the int type with sizeof(u64)?
> > Otherwise the arg calculation might be incorrect? wdyt did I follow
> > along correctly.
> 
> Yes, we probably do. I actually never used __int128 in practice, but
> decided to look at what Clang does for a function accepting __int128.
> Turns out it passed it in two consecutive registers. So:
> 
> __weak int bla(__int128 x) { return (int)(x + 1); }
> 
> The assembly is:
> 
>       38:       b7 01 00 00 fe ff ff ff r1 = -2
>       39:       b7 02 00 00 ff ff ff ff r2 = -1
>       40:       85 10 00 00 ff ff ff ff call -1
>       41:       bc 01 00 00 00 00 00 00 w1 = w0
> 
> So low 64-bits go into r1, high 64-bits into r2.
> 
> Which means the 1:1 mapping between registers and input arguments
> breaks with __int128, at least for target BPF. I'm too lazy to check
> for x86-64, though.

OK confirms what I suspected. For a fix we should bound int types
here to pointer word size which I think should be safe most everywhere.
I can draft a patch if you haven't done one already. For what its worth
RISC-V had some convention where it would use the even registers for
things. So

 foo(int a, __int128 b)

would put a in r0 and b in r2 and r3 leaving a hole in r1. But that
was some old reference manual and  might no longer be the case
in reality. Perhaps just spreading hearsay, but the point is we
should say something about what the BPF backend convention
is and write it down. We've started to bump into these things
lately.
