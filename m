Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE81A24C419
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgHTRHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730354AbgHTRFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:05:15 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE038C061386
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:05:06 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o18so3360740eje.7
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Io5tdLMfOwzBnOTgWMWIIWlg9YYSmolrrRZ0RRvwKR8=;
        b=kh+7Oi77zCYs0Sv7wjusq4Fc5vU9fpUjsb6r/DE/kUtxx0CQITSCQqoDaZMzjaZZ0n
         b1VJBkGhEFH8feITupWHQFvEFbhGDN845BnvjWUre/C1K2N+lPbdhqaIylz5UM+JGll+
         GAVJaLbBjUVw3gF32YxoWxhiSe7a6YeLphd03FE7liKLJ5lz6XlIf+0N3dLp2wHQZ2P2
         53QhRJ8b2V+Ssvr4++sy0/W/vhM+NV6FRxAvOqnSw4Nm2O2HY9sBxZRz1vMCOGY4jAbH
         UjkJOxnjy+aZJDIrRyJTTdd0XsUtqpmNCMnzV1KqEUvUC7x54C+Gl0x7HdYdkHKrC7ng
         JLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Io5tdLMfOwzBnOTgWMWIIWlg9YYSmolrrRZ0RRvwKR8=;
        b=Tg/BVaDlgBZviSP5G7GJzOYykj/wxJwqxVijzu/YYj+wp/qv2n8j7R7sEwoXw4Nx4i
         3V1VIDl8du+vJuX5K4amVDnK4n/9Fj0aFb4nYKBoDmZNeoSiscF3Bqcqr7uUM7ZZ+vFn
         +cFXPDegrKYzkcfeshms0mI8f5Dn26miiU4rWpYDsKppsSRF4EZLW50gRM1NLcamAs/o
         v8Qihy9f2F1jC353OL5uoyY9l9d7i8Mj+0IGX2VWb4i0qMG7Mbpn8XExzzD2hXp96D5w
         YqjS+DNxgFVmY43hk5UYhPW/5OkjbLELHwet1OuEK/GPAgHwBe8pII2+bfRuT6ubxSRQ
         w+9g==
X-Gm-Message-State: AOAM530kuKa6brOckMfilFIEWsr4WpvDK/3IMtJK0t2PFAb7CYJM4nv/
        PLowbvUF1BJTrpN2H9OF+tuyHTYmFuusT8NAovshog==
X-Google-Smtp-Source: ABdhPJxmhN2XhjhlawKzSbrnBdxU0whJpUJmBc0bEkLW6GcfQwO/fGclhykmEtouej1+n+vSOnBFgnayetnB0wumRKM=
X-Received: by 2002:a17:906:54d3:: with SMTP id c19mr4419389ejp.408.1597943104367;
 Thu, 20 Aug 2020 10:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-2-haoluo@google.com>
 <35519fec-754c-0a17-4f01-9d6e39a8a7e8@fb.com>
In-Reply-To: <35519fec-754c-0a17-4f01-9d6e39a8a7e8@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 20 Aug 2020 10:04:53 -0700
Message-ID: <CA+khW7jYgRxsjvqSWwLQDP5PpuXB0HJDNMLGFAOPddi7SdMP0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
To:     Yonghong Song <yhs@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong,

Thank you for taking a look. Explicitly cc'ing Arnaldo to see if he
has any immediate insights. In the meantime, I'll dedicate time to
investigate this issue you found.

Thanks,
Hao


On Thu, Aug 20, 2020 at 8:23 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/19/20 3:40 PM, Hao Luo wrote:
> > Pseudo_btf_id is a type of ld_imm insn that associates a btf_id to a
> > ksym so that further dereferences on the ksym can use the BTF info
> > to validate accesses. Internally, when seeing a pseudo_btf_id ld insn,
> > the verifier reads the btf_id stored in the insn[0]'s imm field and
> > marks the dst_reg as PTR_TO_BTF_ID. The btf_id points to a VAR_KIND,
> > which is encoded in btf_vminux by pahole. If the VAR is not of a struct
> > type, the dst reg will be marked as PTR_TO_MEM instead of PTR_TO_BTF_ID
> > and the mem_size is resolved to the size of the VAR's type.
> >
> >  From the VAR btf_id, the verifier can also read the address of the
> > ksym's corresponding kernel var from kallsyms and use that to fill
> > dst_reg.
> >
> > Therefore, the proper functionality of pseudo_btf_id depends on (1)
> > kallsyms and (2) the encoding of kernel global VARs in pahole, which
> > should be available since pahole v1.18.
>
> I tried your patch with latest pahole but it did not generate
> expected BTF_TYPE_VARs. My pahole head is:
>    f3d9054ba8ff btf_encoder: Teach pahole to store percpu variables in
> vmlinux BTF.
>
> First I made the following changes to facilitate debugging:
> diff --git a/btf_encoder.c b/btf_encoder.c
> index 982f59d..f94c3a6 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -334,6 +334,9 @@ int cu__encode_btf(struct cu *cu, int verbose, bool
> force)
>                  /* percpu variables are allocated in global space */
>                  if (variable__scope(var) != VSCOPE_GLOBAL)
>                          continue;
> +               /* type 0 is void, probably an internal error */
> +               if (var->ip.tag.type == 0)
> +                       continue;
>                  has_global_var = true;
>                  head = &hash_addr[hashaddr__fn(var->ip.addr)];
>                  hlist_add_head(&var->tool_hnode, head);
> @@ -399,8 +402,8 @@ int cu__encode_btf(struct cu *cu, int verbose, bool
> force)
>                  }
>
>                  if (verbose)
> -                       printf("symbol '%s' of address 0x%lx encoded\n",
> -                              sym_name, addr);
> +                       printf("symbol '%s' of address 0x%lx encoded,
> type %u\n",
> +                              sym_name, addr, type);
>
>                  /* add a BTF_KIND_VAR in btfe->types */
>                  linkage = var->external ? BTF_VAR_GLOBAL_ALLOCATED :
> BTF_VAR_STATIC;
> diff --git a/libbtf.c b/libbtf.c
> index 7a01ded..3a0d8d7 100644
> --- a/libbtf.c
> +++ b/libbtf.c
> @@ -304,6 +304,8 @@ static const char * const btf_kind_str[NR_BTF_KINDS] = {
>          [BTF_KIND_RESTRICT]     = "RESTRICT",
>          [BTF_KIND_FUNC]         = "FUNC",
>          [BTF_KIND_FUNC_PROTO]   = "FUNC_PROTO",
> +       [BTF_KIND_VAR]          = "VAR",
> +       [BTF_KIND_DATASEC]      = "DATASEC",
>   };
>
>   static const char *btf_elf__name_in_gobuf(const struct btf_elf *btfe,
> uint32_t offset)
> @@ -671,7 +673,7 @@ int32_t btf_elf__add_var_type(struct btf_elf *btfe,
> uint32_t type, uint32_t name
>                  return -1;
>          }
>
> -       btf_elf__log_type(btfe, &t.type, false, false, "type=%u name=%s",
> +       btf_elf__log_type(btfe, &t.type, false, false, "type=%u name=%s\n",
>                            t.type.type, btf_elf__name_in_gobuf(btfe,
> t.type.name_off));
>
>          return btfe->type_index;
>
> It would be good if you can add some of the above changes to
> pahole for easier `pahole -JV` dump.
>
> With the above change, I only got static per cpu variables.
> For example,
>     static DEFINE_PER_CPU(unsigned int , mirred_rec_level);
> in net/sched/act_mirred.c.
>
> [10] INT 'unsigned int' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [74536] VAR 'mirred_rec_level' type_id=10, linkage=static
>
> The dwarf debug_info entry for `mirred_rec_level`:
> 0x0001d8d6:   DW_TAG_variable
>                  DW_AT_name      ("mirred_rec_level")
>                  DW_AT_decl_file
> ("/data/users/yhs/work/net-next/net/sched/act_mirred.c")
>                  DW_AT_decl_line (31)
>                  DW_AT_decl_column       (0x08)
>                  DW_AT_type      (0x00000063 "unsigned int")
>                  DW_AT_location  (DW_OP_addr 0x0)
> It is not a declaration and it contains type.
>
> All global per cpu variables do not have BTF_KIND_VAR generated.
> I did a brief investigation and found this mostly like to be a
> pahole issue. For example, for global per cpu variable
> bpf_prog_active,
>    include/linux/bpf.h
>          DECLARE_PER_CPU(int , bpf_prog_active);
>    kernel/bpf/syscall.c
>          DEFINE_PER_CPU(int , bpf_prog_active);
> it is declared in the header include/linux/bpf.h and
> defined in kernel/bpf/syscall.c.
>
> In many cu's, you will see:
> 0x0003592a:   DW_TAG_variable
>                  DW_AT_name      ("bpf_prog_active")
>                  DW_AT_decl_file
> ("/data/users/yhs/work/net-next/include/linux/bpf.h")
>                  DW_AT_decl_line (1074)
>                  DW_AT_decl_column       (0x01)
>                  DW_AT_type      (0x0001fa7e "int")
>                  DW_AT_external  (true)
>                  DW_AT_declaration       (true)
>
> In kernel/bpf/syscall.c, I see
> the following dwarf entry for real definition:
> 0x00013534:   DW_TAG_variable
>                  DW_AT_name      ("bpf_prog_active")
>                  DW_AT_decl_file
> ("/data/users/yhs/work/net-next/include/linux/bpf.h")
>                  DW_AT_decl_line (1074)
>                  DW_AT_decl_column       (0x01)
>                  DW_AT_type      (0x000000d6 "int")
>                  DW_AT_external  (true)
>                  DW_AT_declaration       (true)
>
> 0x00021a25:   DW_TAG_variable
>                  DW_AT_specification     (0x00013534 "bpf_prog_active")
>                  DW_AT_decl_file
> ("/data/users/yhs/work/net-next/kernel/bpf/syscall.c")
>                  DW_AT_decl_line (43)
>                  DW_AT_location  (DW_OP_addr 0x0)
>
> Note that for the second entry DW_AT_specification points to the
> declaration. I am not 100% sure whether pahole handle this properly or
> not. It generates a type id 0 (void) for bpf_prog_active variable.
>
> Could you investigate this a little more?
>
> I am using gcc 8.2.1. Using kernel default dwarf (dwarf 2) exposed
> the above issue. Tries to use dwarf 4 and the problem still exists.
>
>
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >   include/linux/btf.h      | 15 +++++++++
> >   include/uapi/linux/bpf.h | 38 ++++++++++++++++------
> >   kernel/bpf/btf.c         | 15 ---------
> >   kernel/bpf/verifier.c    | 68 ++++++++++++++++++++++++++++++++++++++++
> >   4 files changed, 112 insertions(+), 24 deletions(-)
> >
> [...]
