Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE19629952
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiKOMyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiKOMx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:53:57 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6908A28717
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:53:47 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p184so10527323iof.11
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7T8Z9k/WSW3C/sE+kXbNggOaFfWMjgf59LaJO7rAnEU=;
        b=xpSP1Z0yFq9lAZSnyC0nQyN2VqA+WArLaNIOK2PliGH4W2ajvZvydR5maGEqkDyWAX
         /6StPGUvpVEYfx6VjtQNdjhgpp78BuwegZOTdhJ6mNnJlsa7fVi7Ls2AJMDKkOpdxlo7
         KAukloV0CwCwoeJZgw/JeARuEnA1QCbalFomoLRhGqBdnhiR0SGVPcrtdTGmg5E/KuQs
         mO9CUZFgQNlSucFqreGh11NRPkPxubMdQD1bVYN6MRD+8by9/Tp5kY3LV+FzzKZWjMzZ
         fzFUwcg7LZfeZ64kRlnCDsAguisHSk6c91e2JC5Eic+CgXC7zB9MTg60ifzSpSyWgCca
         Q+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7T8Z9k/WSW3C/sE+kXbNggOaFfWMjgf59LaJO7rAnEU=;
        b=GCdC7XjzgiZ8OhDNJr14T9Br8TNjBqjvjm8VsE5kUq/PWjma6nfybixZcu04NYTvKX
         7CyGzDROxBViW7Z3U+IPs5022XbXf+taJvSoLQrKH6yUx7/Wy7yp0WmdsZvE7ZdiDOoO
         IECzCK8dY9/OLaNGUkzH2g3Vv/3rP4UV1bdp3FoLcoAqwrEV5RQ+AeKmYx1JIEEMBHwq
         JtIkucaOssxgZgfjKSZl1y6BavEBwE0I6tZcCjM74ctQ5EZ8wq81I5wif5oc+8JEfZhQ
         tmcL3WX8qtWR3jdAQiIEj1tbjxTSwot/BeWmulIpVQ5o1yOjXF8M7fPRQ+B3ovKCVgRe
         J9aA==
X-Gm-Message-State: ANoB5pm9CzGZIz54bwEflFnjn9c2Ma8/q7lYifeYJ3CwD7VR3WKuDA1y
        hmrwPZ2wNrZPymj3ooRN3z7mPqBJdSiCtlrZsGk76R6n2aXW8JCC
X-Google-Smtp-Source: AA0mqf53cL6DyqN7ZIzesNpzPUxXbF6j/A6pn+eQUj0mRp9WIogr3QKH+MJHbCSIQX+UGalSXPxT9m9UdWI2F4Jdyzg=
X-Received: by 2002:a02:ccf1:0:b0:375:ab48:de95 with SMTP id
 l17-20020a02ccf1000000b00375ab48de95mr7628617jaq.14.1668516826738; Tue, 15
 Nov 2022 04:53:46 -0800 (PST)
MIME-Version: 1.0
References: <878rkc1jk7.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <878rkc1jk7.fsf@all.your.base.are.belong.to.us>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 15 Nov 2022 13:53:36 +0100
Message-ID: <CADYN=9LfU3g9MCk0TZZN=tv6keAM_xPUhe9bMTczLdNw=FHELQ@mail.gmail.com>
Subject: Re: BPF, cross-compiling, and selftests
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 at 13:36, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wrot=
e:
>

Hi,

Adding the kselftest list

> I ran into build issues when building selftests/net on Ubuntu/Debian,
> which is related to that BPF program builds usually needs libc (and the
> corresponding target host configuration/defines).
>
> When I try to build selftests/net, on my Debian host I get:

I've ran into this issue too building with tuxmake [1] that uses
debian containers.

>
>   clang -O2 -target bpf -c bpf/nat6to4.c -I../../bpf -I../../../../lib -I=
../../../../../usr/include/ -o /home/bjorn/src/linux/linux/tools/testing/se=
lftests/net/bpf/nat6to4.o
>   In file included from bpf/nat6to4.c:27:
>   In file included from /usr/include/linux/bpf.h:11:
>   /usr/include/linux/types.h:5:10: fatal error: 'asm/types.h' file not fo=
und
>   #include <asm/types.h>
>            ^~~~~~~~~~~~~
>   1 error generated.
>
> asm/types.h lives in /usr/include/"TRIPLE" on Debian, say
> /usr/include/x86_64-linux-gnu. Target BPF does not (obviously) add the
> x86-64 search path. These kind of problems have been worked around in,
> e.g., commit 167381f3eac0 ("selftests/bpf: Makefile fix "missing"
> headers on build with -idirafter").
>
> However, just adding the host specific path is not enough. Typically,
> when you start to include libc files, like "sys/socket.h" it's
> expected that host specific defines are set. On my x86-64 host:
>
>   $ clang -dM -E - < /dev/null|grep x86_
>   #define __x86_64 1
>   #define __x86_64__ 1
>
>   $ clang -target riscv64-linux-gnu -dM -E - < /dev/null|grep xlen
>   #define __riscv_xlen 64
>
> otherwise you end up with errors like the one below.
>
> Missing __x86_64__:
>   #if !defined __x86_64__
>   # include <gnu/stubs-32.h>
>   #endif
>
>   clang -O2 -target bpf -c bpf/nat6to4.c -idirafter /usr/lib/llvm-16/lib/=
clang/16.0.0/include -idirafter /usr/local/include -idirafter /usr/include/=
x86_64-linux-gnu -idirafter /usr/include  -Wno-compare-distinct-pointer-typ=
es -I../../bpf -I../../../../lib -I../../../../../usr/include/ -o /home/bjo=
rn/src/linux/linux/tools/testing/selftests/net/bpf/nat6to4.o
>   In file included from bpf/nat6to4.c:28:
>   In file included from /usr/include/linux/if.h:28:
>   In file included from /usr/include/x86_64-linux-gnu/sys/socket.h:22:
>   In file included from /usr/include/features.h:510:
>   /usr/include/x86_64-linux-gnu/gnu/stubs.h:7:11: fatal error: 'gnu/stubs=
-32.h' file not found
>   # include <gnu/stubs-32.h>
>             ^~~~~~~~~~~~~~~~
>   1 error generated.
>
> Now, say that we'd like to cross-compile for a platform. Should I make
> sure that all the target compiler's "default defines" are exported to
> the BPF-program build step? I did a hack for RISC-V a while back in
> commit 6016df8fe874 ("selftests/bpf: Fix broken riscv build"). Not
> super robust, and not something I'd like to see for all supported
> platforms.
>
> Any ideas? Maybe a convenience switch to Clang/target bpf? :-)

I added the same thing selftests/bpf have in their Makefile [2] and that
highlighted another issue which is that selftests/net/bpf depends on
bpf_helpers.h
which in turn depends on the generated file bpf_helper_defs.h...


Cheers,
Anders
[1] https://tuxmake.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/tools/testing/selftests/bpf/Makefile#n305
