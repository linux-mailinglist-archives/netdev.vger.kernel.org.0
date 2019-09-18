Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A6FB5AF0
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfIRFeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:34:04 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37598 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfIRFeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 01:34:03 -0400
Received: by mail-qk1-f195.google.com with SMTP id u184so6760971qkd.4;
        Tue, 17 Sep 2019 22:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2KTni67QeY65KHrP8GaDvnakNrehjhBO4czvpB338c=;
        b=B7CIqFuM8ETsZhGVqNQ1XsZXtm3fq3qmbF59nybqfWLI0FHkTtCdYNcsiU/l05Qt8S
         zOMGPMXWOILvyxb+Us0Zv6uZc+YOo+k1oeG2N4OViCmEjMeIu9SGmcbC2M9mXnCG4pxL
         Kny1RH+pr5PTZi+01X+xr/tR/nWHqnAoT+P5d8euEpLPPwEB2o2tuFSDM0OgVQ7rWBJ1
         aAUTwoBca0mOuu5Rt29zTw1hhYEcs7P+Lku0yIuEsLI2fHAkRCCdZI77N4b8LmKUPdm0
         M2Pwv/yjBODbibtiElZrsGWeerNf0LXDk2uUuXeNeRuTHmoEa9NRYHcnxEgiRIh3xUHA
         P3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2KTni67QeY65KHrP8GaDvnakNrehjhBO4czvpB338c=;
        b=mGMRaCGmz0TO2Oa1oLPExRrwf+T0qAJEnxRZhQbFH0aTqQHrIH4I+0SOwjg0kjts6E
         4NGY1KPdpiHJkWQRl3iZrbi3kYpdySCTItZm0m3kMdLLiQkMBfIgZ54JYejVo9J9E354
         ICFWRe7uveRQ3ffb+uNFUu8yps7LsAY5ja/e3neWfX34PLuoGb7/blmxuOaG6xto72nt
         LQe7MApNu8+rflMbnEGbIBYjym6YUpBqfxMAhNcSwn+n8Z2jjbLi1koHoxkiQ0EDh2Bh
         gnUXSJPrD2XqPZNNDjBY2B6zKImsWDfI4MDlagAhzaVTD9CkjXkWnEXFBsHfpYZlIzQL
         NXvw==
X-Gm-Message-State: APjAAAXsCuH2UyYErXpkIM8nT/JckAH2G9Ykvb9K5qN43ML4z7DKYqZy
        ZAY95MmWc+KLy0CUGlKja425NozMxx7teX2eL7c=
X-Google-Smtp-Source: APXvYqxng9krzF0F82a4JSVaYVRwft2L4XAMet0T5vGr6cKWUXmgMUSthsucqalRfBASWbpPHSv4KlcK9XTrLPOhJbs=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr2257626qkb.437.1568784842596;
 Tue, 17 Sep 2019 22:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 22:33:51 -0700
Message-ID: <CAEf4BzbdAuns7RKfPTbc2+WQF=vz4FMaZWQ0JjE1u_CsGACHxg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 00/14] samples: bpf: improve/fix cross-compilation
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 4:02 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>

Thanks for these changes, they look good overall. It would be great if
someone else could test and validate that cross-compilation works not
just in your environment and generated binaries successfully run on
target machines, though...

[...]


>
> Ivan Khoronzhuk (14):
>   samples: bpf: makefile: fix HDR_PROBE "echo"
>   samples: bpf: makefile: fix cookie_uid_helper_example obj build
>   samples: bpf: makefile: use --target from cross-compile
>   samples: bpf: use own EXTRA_CFLAGS for clang commands
>   samples: bpf: makefile: use __LINUX_ARM_ARCH__ selector for arm
>   samples: bpf: makefile: drop unnecessarily inclusion for bpf_load
>   samples: bpf: add makefile.target for separate CC target build
>   samples: bpf: makefile: base target programs rules on Makefile.target
>   samples: bpf: makefile: use own flags but not host when cross compile
>   samples: bpf: makefile: use target CC environment for HDR_PROBE
>   libbpf: makefile: add C/CXX/LDFLAGS to libbpf.so and test_libpf
>     targets
>   samples: bpf: makefile: provide C/CXX/LD flags to libbpf
>   samples: bpf: makefile: add sysroot support
>   samples: bpf: README: add preparation steps and sysroot info
>

Prefixes like "samples: bpf: makefile: " are very verbose without
adding much value. We've been converging to essentially this set of
prefixes:

- "libbpf:" for libbpf changes
- "bpftool:" for bpftool changes
- "selftests/bpf:" for bpf selftests
- "samples/bpf:" for bpf samples

There is no need to prefix with "makefile: " either. Please update
your patch subjects in the next version. Thanks!

>  samples/bpf/Makefile        | 179 +++++++++++++++++++++---------------
>  samples/bpf/Makefile.target |  75 +++++++++++++++
>  samples/bpf/README.rst      |  41 ++++++++-
>  tools/lib/bpf/Makefile      |  11 ++-
>  4 files changed, 225 insertions(+), 81 deletions(-)
>  create mode 100644 samples/bpf/Makefile.target
>
> --
> 2.17.1
>
