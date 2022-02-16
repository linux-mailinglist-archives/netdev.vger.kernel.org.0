Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943E64B9010
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbiBPSUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:20:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiBPSUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:20:53 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D4B1C559E;
        Wed, 16 Feb 2022 10:20:40 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id m185so699072iof.10;
        Wed, 16 Feb 2022 10:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KsP8rx0XkdrsC3Lhi1IhRsdvFU9EtlyQ43jY9b8qnY4=;
        b=L96RhhKiycXAE/uN3LW9lp523pBZShcCx6ZEoDHJBIe4QoxwWS6zmgZ/EeTC9zCaRo
         ei06R71Fhm4uI7r6CNIN/BsBtqhmCSFwVF03vli6sgEEpR9lvc7YaKadI95lGSH3kxaL
         mgy2O4UIuFQTS4Y4aDBjC9I4j8qCouqED8qkMdk4IEjmZJVfCzVgihBqZApTLZrNayYa
         U7QhiWxgaO3Kija69d85Ik0Z/G+g7moh1tXHcoppU8DtCUMQhv4odQv3Q2wgcqJlSXQR
         BC/9g1bg/Vf5cXckiDeEtR26mmbwFwLw5GY0RON16iyw/gxclAgUHxxz8iTEjklW7Dye
         rvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KsP8rx0XkdrsC3Lhi1IhRsdvFU9EtlyQ43jY9b8qnY4=;
        b=iKNcfuIL8iaY+f6BIH/OZSMFkBcq6W2DNHjrX+YScv84OwSa8CZQlgIZy9kZeqn7L5
         Mg/sQtummUwz1TK8LgsMqjWTL/uq3eCe3f61jy2xVfXiLglWOaBry4R7PYGqiOjdOFEy
         07+NkU7H0Jd0yd3bWejT9KELiFQ7xZtBi2zlAf9+at2wfxpeSINLP8W7mw+INk2CW1UM
         ivszg41sd8/crdAPM3hXAw/Yeh/bkHSC+b2VdaDdO6Jhnws6BIZXrr/L2cGAbWv7YTN6
         TkS4C5EP3au8wzojY/UrB9G6YmXfdoWuKBbppH8IAaj50h3whO+EwmhocibZA+SBcdfw
         jKDg==
X-Gm-Message-State: AOAM531VAhnbdqCfqbAnQEBG4S+qLGULIGu0ptcuoA6cuq/mp8QNwcfo
        KaVsA0mIkpK6YoG6kqRJ6fC6aovJ0s+GvCLzzpQ=
X-Google-Smtp-Source: ABdhPJy4xtHoT4xw7QQRBgR12hSC2bs6zl3H6ZHue+L5QpMX4lmQG+9Dn7+BevAMVOpHCOLLGQJ0T/R9j+hRNr98kOk=
X-Received: by 2002:a6b:7a45:0:b0:638:ce15:2045 with SMTP id
 k5-20020a6b7a45000000b00638ce152045mr2632184iop.79.1645035639887; Wed, 16 Feb
 2022 10:20:39 -0800 (PST)
MIME-Version: 1.0
References: <20220215225856.671072-1-mauricio@kinvolk.io>
In-Reply-To: <20220215225856.671072-1-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Feb 2022 10:20:27 -0800
Message-ID: <CAEf4BzbxcoP8hoHM_1+QX4Nx=F0NPkc-CXDq=H_JkQfc9PAzLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/7] libbpf: Implement BTFGen
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:59 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> CO-RE requires to have BTF information describing the kernel types in
> order to perform the relocations. This is usually provided by the kernel
> itself when it's configured with CONFIG_DEBUG_INFO_BTF. However, this
> configuration is not enabled in all the distributions and it's not
> available on kernels before 5.12.
>
> It's possible to use CO-RE in kernels without CONFIG_DEBUG_INFO_BTF
> support by providing the BTF information from an external source.
> BTFHub[0] contains BTF files to each released kernel not supporting BTF,
> for the most popular distributions.
>
> Providing this BTF file for a given kernel has some challenges:
> 1. Each BTF file is a few MBs big, then it's not possible to ship the
> eBPF program with all the BTF files needed to run in different kernels.
> (The BTF files will be in the order of GBs if you want to support a high
> number of kernels)
> 2. Downloading the BTF file for the current kernel at runtime delays the
> start of the program and it's not always possible to reach an external
> host to download such a file.
>
> Providing the BTF file with the information about all the data types of
> the kernel for running an eBPF program is an overkill in many of the
> cases. Usually the eBPF programs access only some kernel fields.
>
> This series implements BTFGen support in bpftool. This idea was
> discussed during the "Towards truly portable eBPF"[1] presentation at
> Linux Plumbers 2021.
>
> There is a good example[2] on how to use BTFGen and BTFHub together
> to generate multiple BTF files, to each existing/supported kernel,
> tailored to one application. For example: a complex bpf object might
> support nearly 400 kernels by having BTF files summing only 1.5 MB.
>
> [0]: https://github.com/aquasecurity/btfhub/
> [1]: https://www.youtube.com/watch?v=3DigJLKyP1lFk&t=3D2418s
> [2]: https://github.com/aquasecurity/btfhub/tree/main/tools
>
> Changelog:
> v6 > v7:
> - use array instead of hashmap to store ids
> - use btf__add_{struct,union}() instead of memcpy()
> - don't use fixed path for testing BTF file
> - update example to use DECLARE_LIBBPF_OPTS()
>
> v5 > v6:
> - use BTF structure to store used member/types instead of hashmaps
> - remove support for input/output folders
> - remove bpf_core_{created,free}_cand_cache()
> - reorganize commits to avoid having unused static functions
> - remove usage of libbpf_get_error()
> - fix some errno propagation issues
> - do not record full types for type-based relocations
> - add support for BTF_KIND_FUNC_PROTO
> - implement tests based on core_reloc ones
>
> v4 > v5:
> - move some checks before invoking prog->obj->gen_loader
> - use p_info() instead of printf()
> - improve command output
> - fix issue with record_relo_core()
> - implement bash completion
> - write man page
> - implement some tests
>
> v3 > v4:
> - parse BTF and BTF.ext sections in bpftool and use
>   bpf_core_calc_relo_insn() directly
> - expose less internal details from libbpf to bpftool
> - implement support for enum-based relocations
> - split commits in a more granular way
>
> v2 > v3:
> - expose internal libbpf APIs to bpftool instead
> - implement btfgen in bpftool
> - drop btf__raw_data() from libbpf
>
> v1 > v2:
> - introduce bpf_object__prepare() and =E2=80=98record_core_relos=E2=80=99=
 to expose
>   CO-RE relocations instead of bpf_object__reloc_info_gen()
> - rename btf__save_to_file() to btf__raw_data()
>
> v1: https://lore.kernel.org/bpf/20211027203727.208847-1-mauricio@kinvolk.=
io/
> v2: https://lore.kernel.org/bpf/20211116164208.164245-1-mauricio@kinvolk.=
io/
> v3: https://lore.kernel.org/bpf/20211217185654.311609-1-mauricio@kinvolk.=
io/
> v4: https://lore.kernel.org/bpf/20220112142709.102423-1-mauricio@kinvolk.=
io/
> v5: https://lore.kernel.org/bpf/20220128223312.1253169-1-mauricio@kinvolk=
.io/
> v6: https://lore.kernel.org/bpf/20220209222646.348365-1-mauricio@kinvolk.=
io/
>
> Mauricio V=C3=A1squez (6):
>   libbpf: split bpf_core_apply_relo()
>   libbpf: Expose bpf_core_{add,free}_cands() to bpftool
>   bpftool: Add gen min_core_btf command
>   bpftool: Implement "gen min_core_btf" logic
>   bpftool: Implement btfgen_get_btf()
>   selftests/bpf: Test "bpftool gen min_core_btf"
>
> Rafael David Tinoco (1):
>   bpftool: gen min_core_btf explanation and examples
>
>  kernel/bpf/btf.c                              |  13 +-
>  .../bpf/bpftool/Documentation/bpftool-gen.rst |  91 +++
>  tools/bpf/bpftool/Makefile                    |   8 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |   6 +-
>  tools/bpf/bpftool/gen.c                       | 591 +++++++++++++++++-
>  tools/lib/bpf/libbpf.c                        |  88 +--
>  tools/lib/bpf/libbpf_internal.h               |   9 +
>  tools/lib/bpf/relo_core.c                     |  79 +--
>  tools/lib/bpf/relo_core.h                     |  42 +-
>  .../selftests/bpf/prog_tests/core_reloc.c     |  50 +-
>  10 files changed, 864 insertions(+), 113 deletions(-)
>
> --
> 2.25.1
>

Fixed up few things I pointed out in respective patches. Applied to
bpf-next. Great work, congrats!

It would be great as a next step to add this as (probably optional at
first) step for libbpf-tools in BCC repo, so that those CO-RE-based
tools can be used much more widely than today. How much work that
would be, do you think? And how slow would it be to download all those
BTFs and run min_core_btf on all of them?
