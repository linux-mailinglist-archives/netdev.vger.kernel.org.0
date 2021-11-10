Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5844CB82
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 22:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhKJWCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhKJWCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:02:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B54DC061766;
        Wed, 10 Nov 2021 13:59:55 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b11so4083576pld.12;
        Wed, 10 Nov 2021 13:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a/dZwpcxMt9ZsfLiHZSN+dkIyTMokFGSQXIG7qYAWk0=;
        b=iokFCfxWpUBRV5khYo3c5s5ZDfnWZ6jVFRrxc1fmu6MA6IxWDcBpJXPfwyQk/ZIrck
         s7CLoaA78R68uaE1wKMjdtKohY9IVqNGMmOCRLsvwRjS1GuDNBJrvZ1eH46+33x03src
         AR6TWT2KonYBr1MwewSwbUj51jZUt/eCjNPQPz56BpI0damWbEc5qMcHjHvuaLAq+igc
         qRQYyyEGccO7SnGmlkJBC8JOPhnypl8Z+PFCW7bVL58z3TBwWK6O2wLB4T+05OjXoYpR
         rIltws5/FU6h2fzV955ekCzj7Ltl4IDOiZkymaY7DdntCrQm75CpRbDaF6QHBqGsj4C2
         4EwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a/dZwpcxMt9ZsfLiHZSN+dkIyTMokFGSQXIG7qYAWk0=;
        b=3bUkQ7JYdYOo8XqlwWf78arFrMnicC15KZEQh6ROeg797MxrbLxSpX62xYsmUU2XhP
         iDt8Fw/Mkm07UpEt0qregJOcUkOu+txUxRJnVcQPf9g1226nyo/0lCZCkrS2z2Z++Gw/
         bYIYoKpp5T5hDlvdreQjHBTE7bFC5w/VCVYtNFkcecM5oTPUUiuyAZ5G4xEymGmNIQ3X
         Z2CGlLoPqZ9sVK1S8Fq+oxcA5QDLi8nC5ADa7CJicU65TB7mgzxKQ0fAbR9WVRq+xAWU
         MNjA4DBRapufW3N3YtgC3s1G7LMn1rpqvGFHHBM4vPTFUVLwtbW3Onvq7N0mZ2OXLxne
         s2LQ==
X-Gm-Message-State: AOAM530WrHrjkkdHyzSONH7DZF4TPI/PpDLKS5U9F/E0zXmcCyH5Gij9
        1OJHjFloyAhEKpokilYLdBT2dTQbV9IuvD45d+Y=
X-Google-Smtp-Source: ABdhPJwJLUmBx5Zr/KfKBBvxSajdn7QzgOIDLVtagmaAyqUzFK7Z8XNCfTQsaUrMDXTcuAWU2J8BCDj2FbgGkV68AoQ=
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr2683894pjy.138.1636581594626;
 Wed, 10 Nov 2021 13:59:54 -0800 (PST)
MIME-Version: 1.0
References: <20211110205418.332403-1-vinicius.gomes@intel.com> <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
In-Reply-To: <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 10 Nov 2021 13:59:43 -0800
Message-ID: <CAADnVQKqjLM1P7X+iTfnH-QFw5=z5L_w8MLsWtcNWbh5QR7VVg@mail.gmail.com>
Subject: Re: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 1:25 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, Nov 11, 2021 at 02:24:18AM IST, Vinicius Costa Gomes wrote:
> > When CONFIG_DEBUG_INFO_BTF is enabled and CONFIG_BPF_SYSCALL is
> > disabled, the following compilation error can be seen:
> >
> >   GEN     .version
> >   CHK     include/generated/compile.h
> >   UPD     include/generated/compile.h
> >   CC      init/version.o
> >   AR      init/built-in.a
> >   LD      vmlinux.o
> >   MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.btf
> > ld: net/ipv4/tcp_cubic.o: in function `cubictcp_unregister':
> > net/ipv4/tcp_cubic.c:545: undefined reference to `bpf_tcp_ca_kfunc_list'
> > ld: net/ipv4/tcp_cubic.c:545: undefined reference to `unregister_kfunc_btf_id_set'
> > ld: net/ipv4/tcp_cubic.o: in function `cubictcp_register':
> > net/ipv4/tcp_cubic.c:539: undefined reference to `bpf_tcp_ca_kfunc_list'
> > ld: net/ipv4/tcp_cubic.c:539: undefined reference to `register_kfunc_btf_id_set'
> >   BTF     .btf.vmlinux.bin.o
> > pahole: .tmp_vmlinux.btf: No such file or directory
> >   LD      .tmp_vmlinux.kallsyms1
> > .btf.vmlinux.bin.o: file not recognized: file format not recognized
> > make: *** [Makefile:1187: vmlinux] Error 1
> >
> > 'bpf_tcp_ca_kfunc_list', 'register_kfunc_btf_id_set()' and
> > 'unregister_kfunc_btf_id_set()' are only defined when
> > CONFIG_BPF_SYSCALL is enabled.
> >
> > Fix that by moving those definitions somewhere that doesn't depend on
> > the bpf() syscall.
> >
> > Fixes: 14f267d95fe4 ("bpf: btf: Introduce helpers for dynamic BTF set registration")
> > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> Thanks for the fix.
>
> But instead of moving this to core.c, you can probably make the btf.h
> declaration conditional on CONFIG_BPF_SYSCALL, since this is not useful in
> isolation (only used by verifier for module kfunc support). For the case of
> kfunc_btf_id_list variables, just define it as an empty struct and static
> variables, since the definition is still inside btf.c. So it becomes a noop for
> !CONFIG_BPF_SYSCALL.
>
> I am also not sure whether BTF is useful without BPF support, but maybe I'm
> missing some usecase.

Unlikely. I would just disallow such config instead of sprinkling
the code with ifdefs.
