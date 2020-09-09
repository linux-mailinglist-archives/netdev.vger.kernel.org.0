Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F42226260D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgIIEE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIIEE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 00:04:56 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A31C061755;
        Tue,  8 Sep 2020 21:04:56 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u8so844412lff.1;
        Tue, 08 Sep 2020 21:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PcIwnCyB/mqlMobJqUXVXH0vAK306iYzRjWvFPkuYlw=;
        b=bEO5/lUu+ugYAlOleAfFJvIGtFoYJZrmuUv3O+9X9ZkpwMakNctaDHZNtxPop0FYbK
         ic8I+8K+SXTKREjMP2J5kYj8toeIhdk8NDEtYZRv78U+F4cGcYhEXyIX6RL+vzIqqwgn
         94QcGS5lATJ/5DM536cyJ9ofVmw+jxW6pPpxCru6Xbi70TjEgMSlC3jblvQMn/i3hl8U
         X5kjtYhOCJ+CPICDmb7obMZ9QfoV2CgeAGsu1QZUj3ecnwhtcumMo+LIi5no/Y52drAM
         KQsiDmIrWyRhwPhr8rlXxwck6V3L6MMK9ffBUAyCAHXIZIuUrXm2UsCsE5XInJg4h6A+
         vXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PcIwnCyB/mqlMobJqUXVXH0vAK306iYzRjWvFPkuYlw=;
        b=IcdstWbPo1fEpm9ox/CU7Dj8FXWenvDirUMBS1GzJ6/qeN/n432lJA8Q+9tuFGu+gd
         IyWEwwDWp1vA0tMUEPR89HkkQV1p142R8UTs3/dQ30jMF6D8kCzhl5bHsa01VIzdw+NZ
         BWWFR9Jnekl8dI0iaRYZ+arHgJ6IvfDyB0pFK4FkQEJF6QdNUHIf+j+qWghQotIiP6i0
         ZNroXRh1f9lg/DYzQI2kF1b8uKprkb7HuizivHTDjRNGPXt1n5pF7BF33VYmO4JWPbxb
         XPxL5ZN9/hmFr/t5hl705G8Rp1Uanyu8RkmFOVvFMCO7N8k7md87qIHZTPC8h3YgRPZe
         F6UA==
X-Gm-Message-State: AOAM532hqdPhx0p+oUP3OptVoe0Sj0r1yTbrggtbrqHwaREq59ywC7uh
        Ry2tVFesBeGIgN2PUCoTmociZHXVJmUnZQm22NvcAz1NqYk=
X-Google-Smtp-Source: ABdhPJyErlBfAAUjJrwngSCHQm/mPhj53AaZjMrDlhFHL3xR3RtIuRk91VlnSNRgIvmzNfu0cPVsWGzWJPOj0xzjA3o=
X-Received: by 2002:a19:f513:: with SMTP id j19mr971789lfb.174.1599624294281;
 Tue, 08 Sep 2020 21:04:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200909031227.963161-1-yhs@fb.com>
In-Reply-To: <20200909031227.963161-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Sep 2020 21:04:43 -0700
Message-ID: <CAADnVQKgZyAMgChwtnHPY2VTgNQN_s+dn2rwFqySiMq_c+C5iw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_sysctl_loop{1,2} failure
 due to clang change
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 8:12 PM Yonghong Song <yhs@fb.com> wrote:
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> index b2e6f9b0894d..3c292c087395 100644
> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> @@ -18,9 +18,9 @@
>  #define MAX_ULONG_STR_LEN 7
>  #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>
> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>  static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
>  {
> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";

It fixes the issue with new llvm, but breaks slightly older llvm:
 ./test_progs -n 7/21
libbpf: load bpf program failed: Permission denied
libbpf: -- BEGIN DUMP LOG ---
libbpf:
invalid stack off=0 size=1
verification time 6975 usec
stack depth 160+64
processed 889 insns (limit 1000000) max_states_per_insn 4 total_states
14 peak_states 14 mark_read 10

libbpf: -- END LOG --
libbpf: failed to load program 'sysctl_tcp_mem'
libbpf: failed to load object 'test_sysctl_loop2.o'
test_bpf_verif_scale:FAIL:114
#7/21 test_sysctl_loop2.o:FAIL

clang --version
clang version 12.0.0 (https://github.com/llvm/llvm-project.git
6f3511a01a5227358a334803c264cfce4175ca5d)
