Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4776EAAA
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 20:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfGSSbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 14:31:05 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45549 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfGSSbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 14:31:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id x22so27110186qtp.12;
        Fri, 19 Jul 2019 11:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nT6m0QoguARdl5/N3ErvTP42gI8fYQRA6DxRwaoHrfU=;
        b=MlZhlySzkIXCBUJyZUzWJupynfKB4r5J7rCgdcCNuIpbuYCu1odBLiVfvuEvPJmT1R
         nwidBLekH8aQrbWczqIKVQbrHqCyJPgyrsvrH47vckFgeEDL0U3YsL74FQ3mCbWLgzu4
         qoiys2r3fYqSzrkDWEjbiWksR7iocG9ElpYvuxwfDWOConXADBJVWaQUzEW9HCDcEF8F
         0q5w1MY9FFBfA/oIiR9iGY7qWhsbVXYlCImO/pvNLRhvzG3GYGrP5BN3MePXsuvmlMnQ
         rH5Mhanl4cSkohtavDNZKjWgXoDwvm2OXqW6bAjhHus5tNelKOukPMECVfAsVL8g4ckU
         u2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nT6m0QoguARdl5/N3ErvTP42gI8fYQRA6DxRwaoHrfU=;
        b=t/fu079jk4X7lSciJvNj6WAkRTGnmmcfoKzNqojJzm/23BDEsAEfmgFih3IgnSsUqI
         pfQRhnG7rRuDi021Ybn/GrvUFja0+v/9mul206vhtag5Kjvo+rTDLL8dS8ylQFd7xEPc
         iWwM3lPC58slfSmQgiDykWoErBGANkTQFs/EpkdNS2aoAKRshy7FFJ9UQfw8AjS83Wbe
         gnZP1lZuyB3uHiQUVvbvrWGrw+WO+DFaado4YYC4hNJen1iXry3823zGGq093gi4pbqg
         IL3MwVMPQ0NrjPRNEPv9L0DPhmrv7QwrguySYaBI5j5obnO7F/hUV1vkvwBv8vPT7hQC
         vPqQ==
X-Gm-Message-State: APjAAAUKEMAmrEDg5snS9FQlqRsDm5fl2e0zCvgAYEtq6XCdSino4+8U
        L7tHL46wb3S1/Mn6nG5RkWBLoX+T
X-Google-Smtp-Source: APXvYqxlz/x55PIBkE9xX7EFZCYkeEPBdG4B/BxMJVIuqvSIvrOZTlJOdIMsRO+s5+YcpiIR4pAU3Q==
X-Received: by 2002:ac8:24b8:: with SMTP id s53mr39363557qts.276.1563561063335;
        Fri, 19 Jul 2019 11:31:03 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id v4sm13106211qtq.15.2019.07.19.11.31.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 11:31:02 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0C00D40340; Fri, 19 Jul 2019 15:30:58 -0300 (-03)
Date:   Fri, 19 Jul 2019 15:30:57 -0300
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Clark Williams <williams@redhat.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/2] libbpf: Fix endianness macro usage for some compilers
Message-ID: <20190719183057.GP3624@kernel.org>
References: <20190719143407.20847-1-acme@kernel.org>
 <20190719143407.20847-2-acme@kernel.org>
 <CAH3MdRXDz+Yn104Y3U0u-q_zW0cwSaH0QAPA8aWK9hpBc4hukw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3MdRXDz+Yn104Y3U0u-q_zW0cwSaH0QAPA8aWK9hpBc4hukw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jul 19, 2019 at 09:25:07AM -0700, Y Song escreveu:
> On Fri, Jul 19, 2019 at 7:35 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > Using endian.h and its endianness macros makes this code build in a
> > wider range of compilers, as some don't have those macros
> > (__BYTE_ORDER__, __ORDER_LITTLE_ENDIAN__, __ORDER_BIG_ENDIAN__),
> > so use instead endian.h's macros (__BYTE_ORDER, __LITTLE_ENDIAN,
> > __BIG_ENDIAN) which makes this code even shorter :-)
> 
> gcc 4.6.0 starts to support __BYTE_ORDER__, __ORDER_LITTLE_ENDIAN__, etc.
> I guess those platforms with failing compilation have gcc < 4.6.0.
> Agree that for libbpf, which will be used outside kernel bpf selftest should
> try to compile with lower versions of gcc.

Yeah, I wouldn't mind at all if the answer to this patch was hey, the
minimal version for building libbpf is X.Y, no problem, its just that in
this case there is an alternative that works everywhere and the
resulting source code is even more compact :-)

- Arnaldo
 
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Fixes: 12ef5634a855 ("libbpf: simplify endianness check")
> > Fixes: e6c64855fd7a ("libbpf: add btf__parse_elf API to load .BTF and .BTF.ext")
> > Link: https://lkml.kernel.org/n/tip-eep5n8vgwcdphw3uc058k03u@git.kernel.org
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/lib/bpf/btf.c    | 5 +++--
> >  tools/lib/bpf/libbpf.c | 5 +++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 467224feb43b..d821107f55f9 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -1,6 +1,7 @@
> >  // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> >  /* Copyright (c) 2018 Facebook */
> >
> > +#include <endian.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > @@ -419,9 +420,9 @@ struct btf *btf__new(__u8 *data, __u32 size)
> >
> >  static bool btf_check_endianness(const GElf_Ehdr *ehdr)
> >  {
> > -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> > +#if __BYTE_ORDER == __LITTLE_ENDIAN
> >         return ehdr->e_ident[EI_DATA] == ELFDATA2LSB;
> > -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> > +#elif __BYTE_ORDER == __BIG_ENDIAN
> >         return ehdr->e_ident[EI_DATA] == ELFDATA2MSB;
> >  #else
> >  # error "Unrecognized __BYTE_ORDER__"
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 794dd5064ae8..b1dec5b1de54 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -20,6 +20,7 @@
> >  #include <inttypes.h>
> >  #include <string.h>
> >  #include <unistd.h>
> > +#include <endian.h>
> >  #include <fcntl.h>
> >  #include <errno.h>
> >  #include <asm/unistd.h>
> > @@ -612,10 +613,10 @@ static int bpf_object__elf_init(struct bpf_object *obj)
> >
> >  static int bpf_object__check_endianness(struct bpf_object *obj)
> >  {
> > -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> > +#if __BYTE_ORDER == __LITTLE_ENDIAN
> >         if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2LSB)
> >                 return 0;
> > -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> > +#elif __BYTE_ORDER == __BIG_ENDIAN
> >         if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2MSB)
> >                 return 0;
> >  #else
> > --
> > 2.21.0
> >

-- 

- Arnaldo
