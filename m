Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73154226CCE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbgGTRDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389038AbgGTRDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:03:19 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7539FC0619D5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:03:18 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so18855632ejb.2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/D99yVB3Oiz5Mh00scTWz5/c04ErKfScrbcBA6SkIPw=;
        b=D1kNZ97uQbS+psUY/wpbNhL+V3j7kvil0De+3fNHHIbbmYkbXypwfizcVy0gp1lzE8
         7PRzu+A/DJqCiXG3TFpg0CU2LqyzqlAcLEyovIpxOpRNKdKE/EdUIu5z2kXMQr928Q39
         FS4Ga5tFbkn8/CP6o4go59NrA+6hN8L6Jic2QioJZzyLlPcKr0PoP434tfoWNi2AjRQC
         JgNnc1qxestfxBJdBYM3QGUwlDRa96HrLWyP2xLc1v6hPUO+iB07p7nxvDyVMXF+3oaY
         jGpI+XBdZQzcP4bCwpYBZrLCv/cGRpWAH+ITrpaSHEORxOjlOgZTjHcyXWHex5YWmq9d
         8I7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/D99yVB3Oiz5Mh00scTWz5/c04ErKfScrbcBA6SkIPw=;
        b=JIxY2ur8LVUh7/RyZZ4Z7+MNqlq+wtU21QcCNcpzTQmfbBu7fONuqAclUwr+zKhhJn
         5qE9X3KeCMKKcPLC/GDiuEyBmkquVLdcdE/B/tum4lI6CKBZZgnfWay9kGUpdWyOeAfH
         p1SHQvC7vdhsCfniun3v8qDkticxu+TMoicNlM4y+DGmGvQfSXw99HrAsQ36pqBZDoYY
         rijEwlHrYd+cLpHw804sNG+3Do0NDJjkxMoWYkI6PN4PqqAF72123GHnBlY3g0HUSCey
         jE/vSd4IfaZZAmBL3RkL6rbEtiQd5GLsgMbLMDP/NsJPtJwWscfshQP9EV392F13LE2h
         DOWQ==
X-Gm-Message-State: AOAM533gDdWOV9kM9hPECjCNMincxU9CNVeEnkucDnNqPq4UGYsbLSrC
        d8CiwNWjq9P7qsW1NLBHxjQ8iILAFdpeBbWuXrpvUw==
X-Google-Smtp-Source: ABdhPJzW7jeqn8/HrRf1zvDOSBhWBELyOoysxnoaonrBp2ayMlaTV+GUKzwc1g6K05h7+lORk8nrO2ZkuRfId+MHg7g=
X-Received: by 2002:a17:907:10d4:: with SMTP id rv20mr22660986ejb.413.1595264596856;
 Mon, 20 Jul 2020 10:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200715214312.2266839-1-haoluo@google.com> <20200715214312.2266839-2-haoluo@google.com>
 <CAEf4BzZ5A+uMPFEmgom+0x+jju3JgTLXuuy=QB_dm2Skf--5Dg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ5A+uMPFEmgom+0x+jju3JgTLXuuy=QB_dm2Skf--5Dg@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 20 Jul 2020 10:03:05 -0700
Message-ID: <CA+khW7h1HBmV5LdALswF2d2q9cD_EU1CfbBEogdHszbHLnTVAQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: BTF support for __ksym externs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii,

Thanks for taking a look at this. You comments are clear, I will fix them in v2.

> Also, in the next version, please split kernel part and libbpf part
> into separate patches.
>

Got it. Will do.

> I don't think that's the right approach. It can't be the best effort.
> It's actually pretty clear when a user wants a BTF-based variable with
> ability to do direct memory access vs __ksym address that we have
> right now: variable type info. In your patch you are only looking up
> variable by name, but it needs to be more elaborate logic:
>
> 1. if variable type is `extern void` -- do what we do today (no BTF required)
> 2. if the variable type is anything but `extern void`, then find that
> variable in BTF. If no BTF or variable is not found -- hard error with
> detailed enough message about what we expected to find in kernel BTF.
> 3. If such a variable is found in the kernel, then might be a good
> idea to additionally check type compatibility (e.g., struct/union
> should match struct/union, int should match int, typedefs should get
> resolved to underlying type, etc). I don't think deep comparison of
> structs is right, though, due to CO-RE, so just high-level
> compatibility checks to prevent the most obvious mistakes.
>

Ack.

> >
> > Also note since we need to carry the ksym's address (64bits) as well as
> > its btf_id (32bits), pseudo_btf_id uses ld_imm64's both imm and off
> > fields.
>
> For BTF-enabled ksyms, libbpf doesn't need to provide symbol address,
> kernel will find it and substitute it, so BTF ID is the only
> parameter. Thus it can just go into the imm field (and simplify
> ldimm64 validation logic a bit).
>

Ack.

> >  /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
> >   * offset to another bpf function
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 3c1efc9d08fd..3c925957b9b6 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7131,15 +7131,29 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
> >                 verbose(env, "invalid BPF_LD_IMM insn\n");
> >                 return -EINVAL;
> >         }
> > +       err = check_reg_arg(env, insn->dst_reg, DST_OP);
> > +       if (err)
> > +               return err;
> > +
> > +       /*
> > +        * BPF_PSEUDO_BTF_ID insn's off fields carry the ksym's btf_id, so its
> > +        * handling has to come before the reserved field check.
> > +        */
> > +       if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
> > +               u32 id = ((u32)(insn + 1)->off << 16) | (u32)insn->off;
> > +               const struct btf_type *t = btf_type_by_id(btf_vmlinux, id);
> > +
>
> This is the kernel, we should be paranoid and assume the hackers want
> to do bad things. So check t for NULL. Check that it's actually a
> BTF_KIND_VAR. Check the name, find ksym addr, etc.
>

Ack.
