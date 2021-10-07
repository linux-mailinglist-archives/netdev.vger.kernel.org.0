Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8023D425F9F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbhJGWDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJGWDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 18:03:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307ACC061570;
        Thu,  7 Oct 2021 15:01:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m21so1111961pgu.13;
        Thu, 07 Oct 2021 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tKYokhDuCrXFoQAg4uCTe+6FzRa3RSmt1UdyzpQnNNA=;
        b=QKWu7zw2veBdKp2NqEOT5JGkeQ5h3pN7OAd+YcQNk/t2Bs9Zue+h8vGp/vnxz6Exjk
         uz/SkMLpVayyZWHPy74nMvZ6WgF/BA9EDL/QBkoFVe0D/YAJrXd/oXRe4RYWPggXR4n5
         LiRpXFxZlObyDjqhrMlB6EorNNMuWrFlcnNzAqA32VTEFYQPNDqU9al4dNzfu/KwexFE
         BVHUnkAZRVfyVsOGBbkdKIIjIjj03K55v1jlm9mYHemWNOZbtb7kBLMRXvsZlerW1EG1
         0Q/UOe+OURnPyTJpdnmeGWbK7dg3aF89zSmt0V3LKG5g72KSFI19zjdwbDR2gXhKq0QO
         NPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tKYokhDuCrXFoQAg4uCTe+6FzRa3RSmt1UdyzpQnNNA=;
        b=TBrY+Ps5K1ublreeQESslMzTfMAUNwDDSihGlzQnkY3+v252tqBg01h6uBgo0UUZFu
         t+DEOVp3HP7ZSoZznTiLMVRtiG29s6gvVHTQiLDkwPUTiAHgx5tD0g5g6waU/0wvm0IY
         jLzo0x/Xrp+4qHoUrFBQUbQ6HSU/q645GprB4Cd9pNjQmYgAXTlayPVBDgDgibWO+Ash
         XIKdawXFLHs1lcKrGQTZlkyaTLkH+uL2+JeJ4foA1pdvxZWxfJMSr6jxw13NkWDVqmjf
         st6lXsogpSHPp8yp8EIMhapwC6T7RQo6t7+tZxP1iR6fNMzpDvYnMboY24DDvFLShIWo
         LRXw==
X-Gm-Message-State: AOAM533/L0jnKb4MmkoU8tSPQftTsiOBHgsew9lKK039coWvzCueFJDB
        GMW3fHQa/8wj7rTz3mOLlsOOOJuiFCk=
X-Google-Smtp-Source: ABdhPJxEiTVY2/ctpsEy36WEs6YzZXDuuv7jvYIO7jDINFyyxKpy4lO+oGyqVshAMKFSVX2ynOThYg==
X-Received: by 2002:a65:538e:: with SMTP id x14mr1641116pgq.364.1633644079485;
        Thu, 07 Oct 2021 15:01:19 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id q6sm228992pjd.26.2021.10.07.15.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:01:17 -0700 (PDT)
Date:   Fri, 8 Oct 2021 03:31:14 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 2/6] libbpf: Add typeless and weak ksym
 support to gen_loader
Message-ID: <20211007220114.igqbftwpox3batj2@apollo.localdomain>
References: <20211006002853.308945-1-memxor@gmail.com>
 <20211006002853.308945-3-memxor@gmail.com>
 <CAPhsuW6nCQK71aeyR1YthvMWGNgH--RwbLnA0_rhi071juTsYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6nCQK71aeyR1YthvMWGNgH--RwbLnA0_rhi071juTsYg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 03:15:10AM IST, Song Liu wrote:
> On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > This patch adds typeless and weak ksym support to BTF_KIND_VAR
> > relocation code in gen_loader. For typeless ksym, we use the newly added
> > bpf_kallsyms_lookup_name helper.
> >
> > For weak ksym, we simply skip error check, and fix up the srg_reg for
> > the insn, as keeping it as BPF_PSEUDO_BTF_ID for weak ksym with its
> > insn[0].imm and insn[1].imm set as 0 will cause a failure.  This is
> > consistent with how libbpf relocates these two cases of BTF_KIND_VAR.
> >
> > We also modify cleanup_relos to check for typeless ksyms in fd closing
> > loop, since those have no fd associated with the ksym. For this we can
> > reuse the unused 'off' member of ksym_desc.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> [...]
>
> Everything above (trimmed) makes sense to me.
>
> > +/* Expects:
> > + * BPF_REG_8 - pointer to instruction
> > + */
> > +static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> > +{
>
> But I don't quite follow why we need these changes to emit_relo_ksym_btf.
> Maybe we should have these changes in a separate patch and add some
> more explanations?
>

Before, if the bpf_btf_find_by_name_kind call failed, we just bailed out due to
the emit_check_err. Now, if it is weak, the error check is conditional, so
we set 0 as the default values and skip the store for btf_id and btf_fd if the
btf lookup failed. Till here, it is similar to the case for emit_relo_kfunc_btf.

Note that we only reach this path once for each unique symbol: the next time, we
enter the kdesc->ref > 1 branch, which copies from the existing insn.

Regarding src_reg stuff: in bpf_object__relocate_data, for obj->gen_loader,
ext->is_set is always true. For the normal libbpf case, it is only true if the
lookup succeeded for BTF (in bpf_object__resolve_ksym_var_btf_id). So depending
on if ext->is_set, it skips assigning BPF_PSEUDO_BTF_ID to src_reg and zeroes
out insn[0].imm and insn[1].imm. Also, the case for ext->is_set = false for
libbpf is only reached if we don't fail on lookup error, and that depends on
ext->is_weak. TLDR; ext->is_weak and lookup failure means src_reg is not
assigned.

For gen_loader, since this src_reg assignment is always there, we need to clear
it for the case where lookup failed, hence the:
-log:
+	emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));

otherwise we end up with src_reg = BPF_PSEUDO_BTF_ID, imm[0] = 0, imm[1] = 0,
which ends up failing the load.

Similarly, we jump over the src_reg adjustment from the kdesc->ref > 1 case if
imm is not equal to 0 (if it were 0, then this is weak ksym). Error check
ensures this instruction is only reached if relo->is_weak (for the same symbol),
so we don't need to check it again there.

Doing it the other way around (not assigning BPF_PSEUDO_BTF_ID by default for
gen_loader) would still involve writing to it in the success case, so IMO
touching it seems unavoidable. If there are better ideas, please lmk.

I added the debug statements so that the selftest reloc result can be inspected
easily, but not sure I can/should verify it from the selftest itself.  I'll
split typeless and weak ksym support into separate patches next time, and
explain this in the commit message.

> Thanks,
> Song
>
> [...]

--
Kartikeya
