Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5427A6D482
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390987AbfGRTO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:14:59 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38939 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfGRTO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:14:58 -0400
Received: by mail-qt1-f193.google.com with SMTP id l9so28396793qtu.6;
        Thu, 18 Jul 2019 12:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rbZZEQaSV7Bs+eYGCj8Ecg6EGR0JPgaSb337xR9VEsA=;
        b=KjWcVADfwNQ5UFpFcr1wZzYW7AhCZ6VxD3w6xF3ysi1EjALuvWiar4S0qr9ezJwv6l
         YnkIRdNIaGZ7SkK1rFCXhhU0DuUWDR4XgfwjaRMp2jQGrTYyvEN9BJXmrCB0yqeINMRl
         RsiBKUkb7S4+ZI73O1hxcJSfkxbidrWy61usGU4lVtshIaEZmGkplywdbCRS02+Kk8xT
         TCEeWZ6g8juoNQgyB4TVr91RGxlr2n3MuZ13kLye+BjX2i3ny8+IzBMdnXRN17QJraJE
         GX+y6XeBt8S+USgwQfCTLzZXYz12DJHbUnf53D5YqZU7Ru92kX6v1+QxIWpbFX28AWLc
         /d1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rbZZEQaSV7Bs+eYGCj8Ecg6EGR0JPgaSb337xR9VEsA=;
        b=ueMzKGFk29NP7HA3LeEr7Sy7JM8/w6T6aUZ7yrkWj3pUtVYTwiNa9AXxIdrDc7WJ/4
         ILtEVfPNpK1lmXjc0gyEzsnzXcu7k7FZUQGucUA/W1QPX0x089ZScXAunavh11odsd4v
         MU4tq4o7RZjaAjJ03yAUv3wsDa+hccyTiAWqvIdA5iOX0Nxe8pDy7bFMZVlJJkPSaS6j
         PlSbDNJlo50GtGEkVYLI6n7I4Qs7PaEND8SrQCIlA5jeP8hHBTHQj/PimEtKyxqV5HdK
         ptvn2ZRlraANqAcHah59tpHBGCFAGIllAztfXiuETfh4vLM1WyEzseI+DY6B/ju34Ga1
         h9uw==
X-Gm-Message-State: APjAAAWt9oAYH0r2IaMc2pgr7AUv/0KpHByu6bloaiOg9w0+zSaHALZn
        bbz/3WG5tOMJKFXDIz1Yktc=
X-Google-Smtp-Source: APXvYqzTkr/IojD4mXFV+wGe/YP9y5uEjc90Iqe+4LQ3E+Qv2izdlR0+WKx6fA+icEc1shtzK49aWw==
X-Received: by 2002:a0c:f193:: with SMTP id m19mr34819477qvl.20.1563477297600;
        Thu, 18 Jul 2019 12:14:57 -0700 (PDT)
Received: from quaco.ghostprotocols.net (179-240-162-69.3g.claro.net.br. [179.240.162.69])
        by smtp.gmail.com with ESMTPSA id l63sm12650008qkb.124.2019.07.18.12.14.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 12:14:57 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D366940340; Thu, 18 Jul 2019 16:14:52 -0300 (-03)
Date:   Thu, 18 Jul 2019 16:14:52 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
Message-ID: <20190718191452.GM3624@kernel.org>
References: <20190718172513.2394157-1-andriin@fb.com>
 <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718185619.GL3624@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jul 18, 2019 at 03:56:19PM -0300, Arnaldo Carvalho de Melo escreveu:
> I'll stop and replace my patch with yours to see if it survives all the
> test builds...

So, Alpine:3.4, the first image for this distro I did when I started
these builds, survives the 6 builds with gcc and clang with your patch:


[perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
[perfbuilder@quaco linux-perf-tools-build]$ dm
   1  alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)


[perfbuilder@quaco linux-perf-tools-build]$ grep "+ make" dm.log/alpine\:3.4
+ make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf
+ make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf
+ make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
+ make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= NO_LIBELF=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
+ make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf CC=clang
+ make ARCH= CROSS_COMPILE= EXTRA_CFLAGS= LIBCLANGLLVM=1 -C /git/linux/tools/perf O=/tmp/build/perf
[perfbuilder@quaco linux-perf-tools-build]$

Probably all the rest will go well, will let you know.

Daniel, do you mind if I carry this one in my perf/core branch? Its
small and shouldn't clash with other patches, I think. It should go
upstream soon:

Andrii, there are these others:

8dfb6ed300bf tools lib bpf: Avoid designated initializers for unnamed union members
80f7f8f21441 tools lib bpf: Avoid using 'link' as it shadows a global definition in some systems
d93fe741e291 tools lib bpf: Fix endianness macro usage for some compilers

If you could take a look at them at my tmp.perf/core branch at:

https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/core

I'm force pushing it now to replace my __WORDSIZE patch with yours, the
SHAs should be the 3 above and the one below.

And to build cleanly I had to cherry pick this one:

3091dafc1884 (HEAD -> perf/core) libbpf: fix ptr to u64 conversion warning on 32-bit platforms

Alpine:3.5 just finished:

   2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 20160822, clang version 3.8.1 (tags/RELEASE_381/final)

- Arnaldo
