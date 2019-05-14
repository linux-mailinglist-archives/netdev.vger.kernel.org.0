Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994211CC82
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfENQIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:08:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36776 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENQIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:08:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id c14so10660153qke.3;
        Tue, 14 May 2019 09:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXr1g3xOC4PTdyCnAyKXyup2MROvJkS98vqNa+18ebM=;
        b=rb11Y31UvHytVgRs+xTrr7OZ6oz9dSmMFHvQRY4kbsQVQrsql1Whv2364A7bRlmYTv
         25xpTBt2Judvd/s58nMRqcPHnc0O4N3Oe4pAm576H88snV/sKCMgERDVkI/cpaTQxY6f
         qTVlMpGQ1UTTjlkCqwYbndO7qDKcFmlDxlV1QdR5frO6WchqqN8TL23nfPISSh+1oChq
         UARUex7O5JTcJe3cS7T+t4GUYv9jVhimKyrdSPKJ/vMOhxCJXOqpH/3vha2eAPN9nHFj
         Q6MzO+sVVDwmY0K29HW41lWec5eBYSb9z0DHX+nb2Oyc9/WbJYMRe40B6U3GpWOJggm2
         NNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXr1g3xOC4PTdyCnAyKXyup2MROvJkS98vqNa+18ebM=;
        b=J5Dk6kxlM/4DGweFckR0CrYnx6YCJgPUq1RdPFfSGp18HSCxRFriFgifk18ewAy8hp
         SjVxAKgxE37WuOFxVmtmUiPJqK1MqFE4a4molnhvwchy/tYG0vmpaCOlE2cFd1Yw4fL9
         qVOREzVUG5taKGtZH7Dcz46vtNxFfu5vCHyeDUEzVtFUT1D5jiaT8Vr6aOPDQcSbQNN+
         PDHCHxqhaKRcHcJ7nJ6KRPwq3CLKU7nfnfpcSjYAuy4sq/WNrgN4J2BX3N3hiVB6fqRr
         SsA64bzW5mDHGirGynqm61u5+Q9xUc7WddzA1HS1viNEzLEiEfJNEgPaO1rbluuu0YIV
         ifug==
X-Gm-Message-State: APjAAAUbiRl5XHBM10JGy6z3EJaDTFFeT6NORn3mupuKNoFPwkV5fRyK
        XM9EDuWyfYsaAOeLionG2Yg98WH3NmThZY5HRKOG3AjjrKM=
X-Google-Smtp-Source: APXvYqwjv4qGUA/8+hHqlSUi55BO9z8a0QcI0hMS1ITGGi4KLa8crVBicRs2rGUFwH6Fj2MEZbqXFMWgkzE7ThFtszQ=
X-Received: by 2002:ae9:f40c:: with SMTP id y12mr28888055qkl.48.1557850094041;
 Tue, 14 May 2019 09:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190510043723.3359135-1-andriin@fb.com> <CACAyw9_9Q4CPzPm-ikMyMMmWR56u+5c7RpW-7o0YBG5JoheF2A@mail.gmail.com>
 <CAEf4BzafBqC63EW8Pf8Du4McL9veOU_SUOHoE9_94zTv9r1XJg@mail.gmail.com>
 <CACAyw99Rpmn1=jgOJfbvBsTfTn2txK1mFcbYhMCtLq1_OtD7Pw@mail.gmail.com>
 <CAEf4BzYYAcKwPaWr_K030kHqyG3+pOEyPL-FqNdZsEyYJ6GLag@mail.gmail.com> <CACAyw9_zM+R3TN1PNc5cGPp6SoPwYhiWfGiOjvRafaDu5+fEWA@mail.gmail.com>
In-Reply-To: <CACAyw9_zM+R3TN1PNc5cGPp6SoPwYhiWfGiOjvRafaDu5+fEWA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 May 2019 09:08:02 -0700
Message-ID: <CAEf4BzYT_axE2hV7HoJtMWU4=o3GLeOgmENWq-9a=pw_2xKwHw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: detect supported kernel BTF features and
 sanitize BTF
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 2:24 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 10 May 2019 at 17:19, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, May 10, 2019 at 8:17 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Fri, 10 May 2019 at 15:16, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, May 10, 2019 at 2:46 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > >
> > > > > On Fri, 10 May 2019 at 05:37, Andrii Nakryiko <andriin@fb.com> wrote:
> > > > > >
> > > > > > Depending on used versions of libbpf, Clang, and kernel, it's possible to
> > > > > > have valid BPF object files with valid BTF information, that still won't
> > > > > > load successfully due to Clang emitting newer BTF features (e.g.,
> > > > > > BTF_KIND_FUNC, .BTF.ext's line_info/func_info, BTF_KIND_DATASEC, etc), that
> > > > > > are not yet supported by older kernel.
> > > > >
> > > > > For sys_bpf, we ignore a zero tail in struct bpf_attr, which gives us
> > > > > backwards / forwards compatibility
> > > > > as long as the user doesn't use the new fields.
> > > > > Do we need a similar mechanism for BTF? Is it possible to discard
> > > > > unknown types at load time?
> > > >
> > > > Unfortunately, unknown BTF types can be intermixed with older, known
> > > > BTF types, so it's not as simple as trimming at the end of data. Also,
> > > > to skip some type, you have to know which kind of type is it, as we
> > > > don't explicitly encode the length of BTF type descriptor. So it's
> > > > just impossible to do from kernel side.
> > >
> > > That's a really good point. I stumbled on the same problem when writing a BTF
> > > PoC in Go. Doesn't this mean that libbpf itself suffers from this
> > > problem as well?
> > > If I upgrade my clang, it might emit BTF that libbpf can't understand, and we're
> > > back to square one.
> >
> > Yep, you are absolutely right. The difference with libbpf, though, is
> > that it's much easier to upgrade it and distribute it with an
> > application, while kernel have much slower upgrade cycle. I'd also
> > assume that Clang updates happen slower, than libbpf's. So I think in
> > practice, outdated libbpf shouldn't be a problem.
>
> I guess this boils down to the packaging model distros are going to follow.
> Will libbpf be packaged alongside a kernel, like perf or iproute2? Or
> is it standalone,
> packaged from github.com/libbpf? Maybe this needs to be a discussion separate
> of this patch.

I think we are encouraging to use github.com/libbpf/libbpf as an
official sources for libbpf.

>
> >
> > >
> > > Would it be possible to add such type_length to the format?
> >
> > The only way I see to do this is to add extra 4 bytes of overhead to
> > each type, which doesn't sound like a great option to me. So I don't
> > know how realistic it is.
> >
> > I guess the other alternative, that might be more compact, is to have
> > sort of "type index", where we encode length of each type by
> > specifying a variable-encoded length. And store that as a separate
> > part of BTF (in addition to types data and string section).
>
> Why four bytes? Seems like u16 or maybe u8 would be sufficient?

u8 - certainly not enough. struct task_struct has >=164 members, which
already adds up to almost 2KB. u16 might be ok, though might be
limiting in some rare cases.

>
> I'm not sure I understand your idea with the extra section. Wouldn't that
> end up adding 4 + 1-4 bytes per type for type ID and length?

Yes, critical difference from storing length with each type is that if
we have a separate section for that, we can have variable-length
encoding, depending on size of a type. So most type length will fit
within 1 byte.

>
> > But both ways are pretty wasteful. And both will require kernel
> > changes to support, so we still have a problem of supporting old
> > kernels.
>
> True, but at least going forward we wouldn't have to extend this
> compat layer every time a new BTF type was added. I imagine that
> might happen a fair bit seeing how useful BTF is.

That's assuming we'll keep adding new BTF kinds actively. We also have
.BTF.ext section, which pre-defines record sizes, so it's possible to
skip unknown sections. It might be better to keep adding stuff there,
if we need to do this often. That's what we are doing w/ BPF CO-RE
relocations, btw.

>
> Finally, I was talking to a co-worker about the possibility that eBPF
> programs might be signed in the future. How would that work if
> libbpf needs to routinely patch up the BTF?

I don't know, it will need to be solved somehow. But we already have
at least two routine cases of patching up BTF: DATASEC size adjustment
and line_info adjustment, so the problem is already there.

>
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > This patch adds detection of BTF features and sanitizes BPF object's BTF
> > > > > > by substituting various supported BTF kinds, which have compatible layout:
> > > > > >   - BTF_KIND_FUNC -> BTF_KIND_TYPEDEF
> > > > > >   - BTF_KIND_FUNC_PROTO -> BTF_KIND_ENUM
> > > > > >   - BTF_KIND_VAR -> BTF_KIND_INT
> > > > > >   - BTF_KIND_DATASEC -> BTF_KIND_STRUCT
> > > > > >
> > > > > > Replacement is done in such a way as to preserve as much information as
> > > > > > possible (names, sizes, etc) where possible without violating kernel's
> > > > > > validation rules.
> > > > > >
> > > > > > Reported-by: Alexei Starovoitov <ast@fb.com>
> > > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > > > ---
> > > > > >  tools/lib/bpf/libbpf.c | 185 ++++++++++++++++++++++++++++++++++++++++-
> > > > > >  1 file changed, 184 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > > index 11a65db4b93f..0813c4ad5d11 100644
> > > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > > @@ -128,6 +128,10 @@ struct bpf_capabilities {
> > > > > >         __u32 name:1;
> > > > > >         /* v5.2: kernel support for global data sections. */
> > > > > >         __u32 global_data:1;
> > > > > > +       /* BTF_KIND_FUNC and BTF_KIND_FUNC_PROTO support */
> > > > > > +       __u32 btf_func:1;
> > > > > > +       /* BTF_KIND_VAR and BTF_KIND_DATASEC support */
> > > > > > +       __u32 btf_datasec:1;
> > > > > >  };
> > > > > >
> > > > > >  /*
> > > > > > @@ -1021,6 +1025,81 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
> > > > > >         return false;
> > > > > >  }
> > > > > >
> > > > > > +static void bpf_object__sanitize_btf(struct bpf_object *obj)
> > > > > > +{
> > > > > > +#define BTF_INFO_ENC(kind, kind_flag, vlen) \
> > > > > > +       ((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
> > > > > > +#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
> > > > > > +       ((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
> > > > > > +
> > > > > > +       bool has_datasec = obj->caps.btf_datasec;
> > > > > > +       bool has_func = obj->caps.btf_func;
> > > > > > +       struct btf *btf = obj->btf;
> > > > > > +       struct btf_type *t;
> > > > > > +       int i, j, vlen;
> > > > > > +       __u16 kind;
> > > > > > +
> > > > > > +       if (!obj->btf || (has_func && has_datasec))
> > > > > > +               return;
> > > > > > +
> > > > > > +       for (i = 1; i <= btf__get_nr_types(btf); i++) {
> > > > > > +               t = (struct btf_type *)btf__type_by_id(btf, i);
> > > > > > +               kind = BTF_INFO_KIND(t->info);
> > > > > > +
> > > > > > +               if (!has_datasec && kind == BTF_KIND_VAR) {
> > > > > > +                       /* replace VAR with INT */
> > > > > > +                       t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
> > > > > > +                       t->size = sizeof(int);
> > > > > > +                       *(int *)(t+1) = BTF_INT_ENC(0, 0, 32);
> > > > > > +               } else if (!has_datasec && kind == BTF_KIND_DATASEC) {
> > > > > > +                       /* replace DATASEC with STRUCT */
> > > > > > +                       struct btf_var_secinfo *v = (void *)(t + 1);
> > > > > > +                       struct btf_member *m = (void *)(t + 1);
> > > > > > +                       struct btf_type *vt;
> > > > > > +                       char *name;
> > > > > > +
> > > > > > +                       name = (char *)btf__name_by_offset(btf, t->name_off);
> > > > > > +                       while (*name) {
> > > > > > +                               if (*name == '.')
> > > > > > +                                       *name = '_';
> > > > > > +                               name++;
> > > > > > +                       }
> > > > > > +
> > > > > > +                       vlen = BTF_INFO_VLEN(t->info);
> > > > > > +                       t->info = BTF_INFO_ENC(BTF_KIND_STRUCT, 0, vlen);
> > > > > > +                       for (j = 0; j < vlen; j++, v++, m++) {
> > > > > > +                               /* order of field assignments is important */
> > > > > > +                               m->offset = v->offset * 8;
> > > > > > +                               m->type = v->type;
> > > > > > +                               /* preserve variable name as member name */
> > > > > > +                               vt = (void *)btf__type_by_id(btf, v->type);
> > > > > > +                               m->name_off = vt->name_off;
> > > > > > +                       }
> > > > > > +               } else if (!has_func && kind == BTF_KIND_FUNC_PROTO) {
> > > > > > +                       /* replace FUNC_PROTO with ENUM */
> > > > > > +                       vlen = BTF_INFO_VLEN(t->info);
> > > > > > +                       t->info = BTF_INFO_ENC(BTF_KIND_ENUM, 0, vlen);
> > > > > > +                       t->size = sizeof(__u32); /* kernel enforced */
> > > > > > +               } else if (!has_func && kind == BTF_KIND_FUNC) {
> > > > > > +                       /* replace FUNC with TYPEDEF */
> > > > > > +                       t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
> > > > > > +               }
> > > > > > +       }
> > > > > > +#undef BTF_INFO_ENC
> > > > > > +#undef BTF_INT_ENC
> > > > > > +}
> > > > > > +
> > > > > > +static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
> > > > > > +{
> > > > > > +       if (!obj->btf_ext)
> > > > > > +               return;
> > > > > > +
> > > > > > +       if (!obj->caps.btf_func) {
> > > > > > +               btf_ext__free(obj->btf_ext);
> > > > > > +               obj->btf_ext = NULL;
> > > > > > +       }
> > > > > > +}
> > > > > > +
> > > > > >  static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> > > > > >  {
> > > > > >         Elf *elf = obj->efile.elf;
> > > > > > @@ -1164,8 +1243,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> > > > > >                         obj->btf = NULL;
> > > > > >                 } else {
> > > > > >                         err = btf__finalize_data(obj, obj->btf);
> > > > > > -                       if (!err)
> > > > > > +                       if (!err) {
> > > > > > +                               bpf_object__sanitize_btf(obj);
> > > > > >                                 err = btf__load(obj->btf);
> > > > > > +                       }
> > > > > >                         if (err) {
> > > > > >                                 pr_warning("Error finalizing and loading %s into kernel: %d. Ignored and continue.\n",
> > > > > >                                            BTF_ELF_SEC, err);
> > > > > > @@ -1187,6 +1268,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> > > > > >                                            BTF_EXT_ELF_SEC,
> > > > > >                                            PTR_ERR(obj->btf_ext));
> > > > > >                                 obj->btf_ext = NULL;
> > > > > > +                       } else {
> > > > > > +                               bpf_object__sanitize_btf_ext(obj);
> > > > > >                         }
> > > > > >                 }
> > > > > >         }
> > > > > > @@ -1556,12 +1639,112 @@ bpf_object__probe_global_data(struct bpf_object *obj)
> > > > > >         return 0;
> > > > > >  }
> > > > > >
> > > > > > +static int try_load_btf(const char *raw_types, size_t types_len,
> > > > > > +                       const char *str_sec, size_t str_len)
> > > > > > +{
> > > > > > +       char buf[1024];
> > > > > > +       struct btf_header hdr = {
> > > > > > +               .magic = BTF_MAGIC,
> > > > > > +               .version = BTF_VERSION,
> > > > > > +               .hdr_len = sizeof(struct btf_header),
> > > > > > +               .type_len = types_len,
> > > > > > +               .str_off = types_len,
> > > > > > +               .str_len = str_len,
> > > > > > +       };
> > > > > > +       int btf_fd, btf_len;
> > > > > > +       __u8 *raw_btf;
> > > > > > +
> > > > > > +       btf_len = hdr.hdr_len + hdr.type_len + hdr.str_len;
> > > > > > +       raw_btf = malloc(btf_len);
> > > > > > +       if (!raw_btf)
> > > > > > +               return -ENOMEM;
> > > > > > +
> > > > > > +       memcpy(raw_btf, &hdr, sizeof(hdr));
> > > > > > +       memcpy(raw_btf + hdr.hdr_len, raw_types, hdr.type_len);
> > > > > > +       memcpy(raw_btf + hdr.hdr_len + hdr.type_len, str_sec, hdr.str_len);
> > > > > > +
> > > > > > +       btf_fd = bpf_load_btf(raw_btf, btf_len, buf, 1024, 0);
> > > > > > +       if (btf_fd < 0) {
> > > > > > +               free(raw_btf);
> > > > > > +               return 0;
> > > > > > +       }
> > > > > > +
> > > > > > +       close(btf_fd);
> > > > > > +       free(raw_btf);
> > > > > > +       return 1;
> > > > > > +}
> > > > > > +
> > > > > > +#define BTF_INFO_ENC(kind, kind_flag, vlen) \
> > > > > > +       ((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
> > > > > > +#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
> > > > > > +#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
> > > > > > +       ((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
> > > > > > +#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
> > > > > > +       BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
> > > > > > +       BTF_INT_ENC(encoding, bits_offset, bits)
> > > > > > +#define BTF_PARAM_ENC(name, type) (name), (type)
> > > > > > +#define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
> > > > > > +static int bpf_object__probe_btf_func(struct bpf_object *obj)
> > > > > > +{
> > > > > > +       const char strs[] = "\0int\0x\0a";
> > > > > > +       /* void x(int a) {} */
> > > > > > +       __u32 types[] = {
> > > > > > +               /* int */
> > > > > > +               BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
> > > > > > +               /* FUNC_PROTO */                                /* [2] */
> > > > > > +               BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_FUNC_PROTO, 0, 1), 0),
> > > > > > +               BTF_PARAM_ENC(7, 1),
> > > > > > +               /* FUNC x */                                    /* [3] */
> > > > > > +               BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
> > > > > > +       };
> > > > > > +       int res;
> > > > > > +
> > > > > > +       res = try_load_btf((char *)types, sizeof(types), strs, sizeof(strs));
> > > > > > +       if (res < 0)
> > > > > > +               return res;
> > > > > > +       if (res > 0)
> > > > > > +               obj->caps.btf_func = 1;
> > > > > > +       return 0;
> > > > > > +}
> > > > > > +
> > > > > > +static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
> > > > > > +{
> > > > > > +       const char strs[] = "\0x\0.data";
> > > > > > +       /* static int a; */
> > > > > > +       __u32 types[] = {
> > > > > > +               /* int */
> > > > > > +               BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
> > > > > > +               /* VAR x */                                     /* [2] */
> > > > > > +               BTF_TYPE_ENC(1, BTF_INFO_ENC(BTF_KIND_VAR, 0, 0), 1),
> > > > > > +               BTF_VAR_STATIC,
> > > > > > +               /* DATASEC val */                               /* [3] */
> > > > > > +               BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
> > > > > > +               BTF_VAR_SECINFO_ENC(2, 0, 4),
> > > > > > +       };
> > > > > > +       int res;
> > > > > > +
> > > > > > +       res = try_load_btf((char *)&types, sizeof(types), strs, sizeof(strs));
> > > > > > +       if (res < 0)
> > > > > > +               return res;
> > > > > > +       if (res > 0)
> > > > > > +               obj->caps.btf_datasec = 1;
> > > > > > +       return 0;
> > > > > > +}
> > > > > > +#undef BTF_INFO_ENC
> > > > > > +#undef BTF_TYPE_ENC
> > > > > > +#undef BTF_INT_ENC
> > > > > > +#undef BTF_TYPE_INT_ENC
> > > > > > +#undef BTF_PARAM_ENC
> > > > > > +#undef BTF_VAR_SECINFO_ENC
> > > > > > +
> > > > > >  static int
> > > > > >  bpf_object__probe_caps(struct bpf_object *obj)
> > > > > >  {
> > > > > >         int (*probe_fn[])(struct bpf_object *obj) = {
> > > > > >                 bpf_object__probe_name,
> > > > > >                 bpf_object__probe_global_data,
> > > > > > +               bpf_object__probe_btf_func,
> > > > > > +               bpf_object__probe_btf_datasec,
> > > > > >         };
> > > > > >         int i, ret;
> > > > > >
> > > > > > --
> > > > > > 2.17.1
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Lorenz Bauer  |  Systems Engineer
> > > > > 25 Lavington St., London SE1 0NZ
> > > > >
> > > > > www.cloudflare.com
> > >
> > >
> > >
> > > --
> > > Lorenz Bauer  |  Systems Engineer
> > > 25 Lavington St., London SE1 0NZ
> > >
> > > www.cloudflare.com
>
>
>
> --
> Lorenz Bauer  |  Systems Engineer
> 25 Lavington St., London SE1 0NZ
>
> www.cloudflare.com
