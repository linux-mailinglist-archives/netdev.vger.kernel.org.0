Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D400B2694F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbfEVRpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:45:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45550 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfEVRpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:45:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id t1so3386326qtc.12;
        Wed, 22 May 2019 10:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tozdxVPBBTKPFtVyskCMo3XRbMEfZfCDiynnPlMVjdY=;
        b=J/VXpoNRPYfNv7LDu6rtEcPlwkCXzEvNpP9bh24NzfXmhHVMox+B+Qmf3g7fYjqoLF
         dBhqPJIQjMQo2tyP1Wfj1pIJhdzTGBb7AoazoF1vDa6Q7Yl7/17P4WinUop3jr1g+ChC
         PgWShFTaCrIqK/ofePMMl4+/RfSsvdu/TZWulpKAKGyW7iqG8Vk7juyXUAkL5PJUzaoh
         Du2vZlvr4mE1WENw7x5GAcE9NXWF+kyTHg1EtbGbUyPE6lLog7L0uKPJnFxD0EB93hal
         R1mcrHbRkhMfBtO/ZuZlc3gAfwncU9jljA8LxpIBS3YtBg1WFzSqEzACjZL80OWMSKXR
         Hwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tozdxVPBBTKPFtVyskCMo3XRbMEfZfCDiynnPlMVjdY=;
        b=labuVfofwQmEShyUJXTEoi6Fpzy2eWef3JGFdNuJKGlJgwHMdHyHW1TJCdIWbcYhXf
         IUVStF12FCqcmU/6OUMNQS2WEjCQM6MVLbLrBvhaBvWyFlBN+OBZnJePpZoIoLKMhZ5Z
         cLiDWcmnonvo2dYV2Lm9KiJB3/qCxiQ0GZlne6wVOD1yDoX8XKn6NtdqTjQICoY+/rPG
         T2U3pPcEUaUhEZKfEhUVejUJS5jW4Cwjwy+AlxxoGKAMOaU+wd9Yish0SMAZI6IcsEN+
         mBOP8WAa/p+RCijsJT64IXLBYhQNZQKhpN2A/k7pHWmnRb1yky08STD2GLiZkeTs+7dP
         I/Cw==
X-Gm-Message-State: APjAAAU5diHPi+BkG1sWO7LuCG04v0XDBzcvtH8lpHOyObSAuApdNZf6
        OzEtkWiy1ybNm/tvhdcBWlOJpgT0EkzpQ8768xL9wYsxvVk=
X-Google-Smtp-Source: APXvYqyWJ+pUIANuvovHRTN3MwhiIGlpeVDvtDDOyICvKETMNFaHoUyS/j/7R5lzVQLzT385CPuQG+UOmMCmStJwafU=
X-Received: by 2002:a0c:d0d4:: with SMTP id b20mr41244173qvh.38.1558547102239;
 Wed, 22 May 2019 10:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190522161520.3407245-1-andriin@fb.com> <1b027a52-4ac7-daf8-ee4a-eb528f53e526@fb.com>
In-Reply-To: <1b027a52-4ac7-daf8-ee4a-eb528f53e526@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 10:44:51 -0700
Message-ID: <CAEf4BzbdNv-azRNQpyH91-Ms59Uw7-990Dadix-_t851pXRRLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: emit diff of mismatched public API, if any
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 9:21 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 5/22/19 9:15 AM, Andrii Nakryiko wrote:
> > It's easy to have a mismatch of "intended to be public" vs really
> > exposed API functions. While Makefile does check for this mismatch, if
> > it actually occurs it's not trivial to determine which functions are
> > accidentally exposed. This patch dumps out a diff showing what's not
> > supposed to be exposed facilitating easier fixing.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/.gitignore | 2 ++
> >   tools/lib/bpf/Makefile   | 8 ++++++++
> >   2 files changed, 10 insertions(+)
> >
> > diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> > index d9e9dec04605..c7306e858e2e 100644
> > --- a/tools/lib/bpf/.gitignore
> > +++ b/tools/lib/bpf/.gitignore
> > @@ -3,3 +3,5 @@ libbpf.pc
> >   FEATURE-DUMP.libbpf
> >   test_libbpf
> >   libbpf.so.*
> > +libbpf_global_syms.tmp
> > +libbpf_versioned_syms.tmp
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index f91639bf5650..7e7d6d851713 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -204,6 +204,14 @@ check_abi: $(OUTPUT)libbpf.so
> >                    "versioned symbols in $^ ($(VERSIONED_SYM_COUNT))." \
> >                    "Please make sure all LIBBPF_API symbols are"       \
> >                    "versioned in $(VERSION_SCRIPT)." >&2;              \
> > +             readelf -s --wide $(OUTPUT)libbpf-in.o |                 \
> > +                 awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
> > +                 sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
> > +             readelf -s --wide $(OUTPUT)libbpf.so |                   \
> > +                 grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
> > +                 sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
> > +             diff -u $(OUTPUT)libbpf_global_syms.tmp                  \
> > +                  $(OUTPUT)libbpf_versioned_syms.tmp;                 \
> >               exit 1;                                                  \
>
> good idea.
> how about removing tmp files instead of adding them to .gitignore?

ok, will remove them
