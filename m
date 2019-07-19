Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26596EAB7
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfGSSe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 14:34:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39368 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbfGSSe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 14:34:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so32003079qtu.6;
        Fri, 19 Jul 2019 11:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XtoWI4Uk1PxN7qr3ck/K2wpPdgEKwl4YnKgDVeW8w78=;
        b=ILbsnE08dEefchtNOzMoux9etDvlyx1sRR5HK9Qipe5rKjWRrrnZtVWOXTJ5ZliO/s
         K9Fhya26XoGaShT7pweCwjtJq2lGgVzkDdzpfg8C53NJaBG2OVDA161uvUbxYbIFFcj5
         Jb9kyWcRHE/LG4dxA7vNT8+/GENyliM3u1eyAt4prxM25OCXkxfV4ZCGf2j0/zEDouXk
         RrLIciRcXfBtAX3qKibwlp5sqO3bCl88IUH1ugUKdRXkWqyPSeMeaF5cqMWzBbd7WZip
         +qGSkTcf+TEW//28CbQtbDdfk8ttUGUpHeonfakAF7qdkzjkel82MAbMVUjGXJ741hcn
         2DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XtoWI4Uk1PxN7qr3ck/K2wpPdgEKwl4YnKgDVeW8w78=;
        b=qncXVSoYIx5BazaCOiSbjGyWz05vxOtfANRJRRfNcAnGpwW1c3mCpMkRznIDxI1ivG
         XoyWdLp0Kd0JXJVTxPInfCWC7Mcd9VEjWo5KUNHXoxW5kGPn4LpBcFiz2yVdxghOBgsb
         vLoYDt1y/nsXMpU4deqYLOI5lyxCCYYLpDNKvmzbQDiq36tgN3zyJbHcS6nd8WpTCrKN
         9QGODQL1eP+JjtIOCgu3XmzQZ2CJaY4MAbFdWb4y2SIxTFB1T/qhsRGOkZueNjtwY5KG
         XbGDZXjCkesb/z0+Z2CQ5v1xu34vT2XBnxOSy0ZcxkzqffwNRMSPB6oXLNIJWb0YgVjK
         uPdA==
X-Gm-Message-State: APjAAAVcAbDjaJTYc8J26EOqj4cJnmuwC9XORbRqSu/JXfZ74bsWrQ2a
        UbnF31vmDNiArBV3/i3sox0=
X-Google-Smtp-Source: APXvYqxN9++plo0hgXyGgBq8nTAoKANNTcVegm7Dsn4rhlfK8FubZco5XDBKLtRiqDOOUq0GeAjH0A==
X-Received: by 2002:ac8:336a:: with SMTP id u39mr37963635qta.178.1563561266520;
        Fri, 19 Jul 2019 11:34:26 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id e18sm11210558qkm.49.2019.07.19.11.34.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 11:34:25 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 642AE40340; Fri, 19 Jul 2019 15:34:17 -0300 (-03)
Date:   Fri, 19 Jul 2019 15:34:17 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
Message-ID: <20190719183417.GQ3624@kernel.org>
References: <20190718172513.2394157-1-andriin@fb.com>
 <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org>
 <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
 <20190719011644.GN3624@kernel.org>
 <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
 <20190719181423.GO3624@kernel.org>
 <CAEf4BzZtYnVG3tnn25-TTJLOmeevv9fSZnAf7S2pG3VA+dMM+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZtYnVG3tnn25-TTJLOmeevv9fSZnAf7S2pG3VA+dMM+Q@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jul 19, 2019 at 11:26:50AM -0700, Andrii Nakryiko escreveu:
> On Fri, Jul 19, 2019 at 11:14 AM Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> > Em Fri, Jul 19, 2019 at 10:54:44AM -0700, Andrii Nakryiko escreveu:
> > > Ok, did some more googling. This warning (turned error in your setup)
> > > is emitted when -Wshadow option is enabled for GCC/clang. It appears
> > > to be disabled by default, so it must be enabled somewhere for perf
> > > build or something.

> > Right, I came to the exact same conclusion, doing tests here:

> > [perfbuilder@3a58896a648d tmp]$ gcc -Wshadow shadow_global_decl.c   -o shadow_global_decl
> > shadow_global_decl.c: In function 'main':
> > shadow_global_decl.c:9: warning: declaration of 'link' shadows a global declaration
> > shadow_global_decl.c:4: warning: shadowed declaration is here
> > [perfbuilder@3a58896a648d tmp]$ gcc --version |& head -1
> > gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
> > [perfbuilder@3a58896a648d tmp]$ gcc shadow_global_decl.c   -o shadow_global_decl
> > [perfbuilder@3a58896a648d tmp]$

> > So I'm going to remove this warning from the places where it causes
> > problems.

> > > Would it be possible to disable it at least for libbpf when building
> > > from perf either everywhere or for those systems where you see this
> > > warning? I don't think this warning is useful, to be honest, just
> > > random name conflict between any local and global variables will cause
> > > this.

> > Yeah, I might end up having this applied.

> Thanks!

So, I'm ending up with the patch below, there is some value after all in
Wshadow, that is, from gcc 4.8 onwards :-)

- Arnaldo

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 495066bafbe3..ded7a950dc40 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wno-system-headers
 EXTRA_WARNINGS += -Wold-style-definition
 EXTRA_WARNINGS += -Wpacked
 EXTRA_WARNINGS += -Wredundant-decls
-EXTRA_WARNINGS += -Wshadow
 EXTRA_WARNINGS += -Wstrict-prototypes
 EXTRA_WARNINGS += -Wswitch-default
 EXTRA_WARNINGS += -Wswitch-enum
@@ -69,8 +68,16 @@ endif
 # will do for now and keep the above -Wstrict-aliasing=3 in place
 # in newer systems.
 # Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
+#
+# See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
+# that takes into account Linus's comments (search for Wshadow) for the reasoning about
+# -Wshadow not being interesting before gcc 4.8.
+
 ifneq ($(filter 3.%,$(MAKE_VERSION)),)  # make-3
 EXTRA_WARNINGS += -fno-strict-aliasing
+EXTRA_WARNINGS += -Wno-shadow
+else
+EXTRA_WARNINGS += -Wshadow
 endif
 
 ifneq ($(findstring $(MAKEFLAGS), w),w)
