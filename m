Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00CE804AC
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 08:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfHCGae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 02:30:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46689 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfHCGae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 02:30:34 -0400
Received: by mail-qk1-f193.google.com with SMTP id r4so56463198qkm.13;
        Fri, 02 Aug 2019 23:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qO36HbXDPxEiCbth+LZLsbvPAVPJdkhtygqrnzEPIvc=;
        b=UU+brhdIWkXuNYgeNXEnJqtWs4IOE0EA8tMq05FPhRcbIUP1UsCSK3yWwb5o7HDIGn
         G7apIjwA35X4P135FdOsr1tObbZneljA68/RzHTaaVSgVdZSfjD2F0uYLzw4RwjKdsLo
         NbIW8VKH+hUawLJOog8AhGXUai0cEZNFQgEkwbAP2QzusQhIZMueOTKKXAXLcKMIxxQo
         gz50qj1vo/t+PBNjmUs8CGo0de77JnOevhJBTAqLt5XpKORajF4vwb4Dy0wcWBZkOsrj
         SHvqjiCXI2wG3N1ofAr3S3tFk5I2ThlGTjqwWNHKN1b74ibudHXjY7WbSEvkgrxhTylL
         bQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qO36HbXDPxEiCbth+LZLsbvPAVPJdkhtygqrnzEPIvc=;
        b=OLDT+2B4gHV2YM23ZX/n0L36KY2mqy05NVlBmCcsgCkTUefreXc9DxwcvKyvQtSAwd
         n1lDxWLuUBBNuExV5kb5+8sgnhDqRruJd1oHNJ6fxoDmcJ1Cw53UB+uS72A0mfuTphwS
         YK+nlVmZLSPYUuO8anHUS0AAxCGG23rcwwLroH/t7S54pi5NRb+lzxVl5FUEdS6UxsjY
         K8+sSGbppR8iLxexsq79y9dvbb6AHVUPuKevbgQop9PoT6XAxnYFXiNo+gmkDi03IueE
         oGxay9ZgPkTpnJNstMaaAadq6ZV4tQ50IV8oYfabE+IVCCyiGWEnYL77Hp0nkRozLKsa
         bmew==
X-Gm-Message-State: APjAAAXfDxtSX7Jb0VfNFF7TcVkxfvDUx+vBJsB+ynVQj1z3/4vJDAZR
        KL1nkdPUwqaNYfG0++ZkhMuUBYnfVc8zSjpk0AE50qdCgz0AVA==
X-Google-Smtp-Source: APXvYqy1IHNyUHr8x4u0hQ+YJ62Z4O/Du09j/mXcCBZSz2MU1j68U3heF3xJ9A4g3TjLC5VxijjRj+J+QsYNa26MkN4=
X-Received: by 2002:a37:660d:: with SMTP id a13mr66710345qkc.36.1564813832731;
 Fri, 02 Aug 2019 23:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190801064803.2519675-1-andriin@fb.com> <20190801064803.2519675-3-andriin@fb.com>
 <20190801235030.bzssmwzuvzdy7h7t@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzarjODxo5c-UKtCL_dGGNb1m-3QPAGGR0eq_0tcZVMt8g@mail.gmail.com> <20190802215604.onihsysinwiu3shl@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190802215604.onihsysinwiu3shl@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Aug 2019 23:30:21 -0700
Message-ID: <CAEf4BzY46=Vosd+kha+_Yh_iXNXhgfSW3ihePApb4GfuzoUU6w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 2:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Aug 02, 2019 at 12:16:52AM -0700, Andrii Nakryiko wrote:
> > On Thu, Aug 1, 2019 at 4:50 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Jul 31, 2019 at 11:47:53PM -0700, Andrii Nakryiko wrote:
> > > > This patch implements the core logic for BPF CO-RE offsets relocations.
> > > > Every instruction that needs to be relocated has corresponding
> > > > bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> > > > to match recorded "local" relocation spec against potentially many
> > > > compatible "target" types, creating corresponding spec. Details of the
> > > > algorithm are noted in corresponding comments in the code.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > ...
> > > > +             if (btf_is_composite(t)) {
> > > > +                     const struct btf_member *m = (void *)(t + 1);
> > > > +                     __u32 offset;
> > > > +
> > > > +                     if (access_idx >= BTF_INFO_VLEN(t->info))
> > > > +                             return -EINVAL;
> > > > +
> > > > +                     m = &m[access_idx];
> > > > +
> > > > +                     if (BTF_INFO_KFLAG(t->info)) {
> > > > +                             if (BTF_MEMBER_BITFIELD_SIZE(m->offset))
> > > > +                                     return -EINVAL;
> > > > +                             offset = BTF_MEMBER_BIT_OFFSET(m->offset);
> > > > +                     } else {
> > > > +                             offset = m->offset;
> > > > +                     }
> > >
> > > very similar logic exists in btf_dump.c
> > > probably makes sense to make a common helper at some point.
> >
> > Will add btf_member_bit_offset(type, member) and
> > btf_member_bit_size(type, member).
> >
> > >
> > > > +static size_t bpf_core_essential_name_len(const char *name)
> > > > +{
> > > > +     size_t n = strlen(name);
> > > > +     int i = n - 3;
> > > > +
> > > > +     while (i > 0) {
> > > > +             if (name[i] == '_' && name[i + 1] == '_' && name[i + 2] == '_')
> > > > +                     return i;
> > > > +             i--;
> > > > +     }
> > > > +     return n;
> > > > +}
> > >
> > > that's a bit of an eye irritant. How about?
> > >         size_t n = strlen(name);
> > >         int i, cnt = 0;
> > >
> > >         for (i = n - 1; i >= 0; i--) {
> > >                 if (name[i] == '_') {
> > >                     cnt++;
> > >                 } else {
> > >                    if (cnt == 3)
> > >                       return i + 1;
> > >                    cnt = 0;
> > >                 }
> > >         }
> > >         return n;
> >
> > I find this one much harder to read and understand. What's
> > eye-irritating about that loop?
> >
> > Your loop will also handle `a____b` differently. My version will
> > return "a_" as essential name, yours "a____b". Was this intentional on
> > your part?
>
> hmm. I think both will return sizeof("a") == 1

nope, there are 4 underscores, your implementation will bump cnt to 4
without checking it for `cnt == 3`, so will never detect flavor and
will just return sizeof("a____b"). It's easily fixable, but the point
is that my original irritating code is very straightforward and harder
to get wrong an, easier to understand at a glimpse, yours require much
more conscious thought to understand.

>
> > I'd rather use this instead, if you hate the first one:
> >
> > size_t n = strlen(name);
> > int i;
> >
> > for (i = n - 3; i > 0; i--) {
> >     if (strncmp(name + i, "___", 3) == 0)
> >         return i;
> > }
> >
> > Is this better?
>
> that is worse.
> What I don't like about it is that every byte is
> compared N=sizeof(string-to-found) times.
> I guess it's not such a big performance criticial path,
> but libbpf has to keep the bar high.

We are talking about searching for *three* characters in a short
string. Performance difference is negligible at best, unnoticeable at
worst. I'd rather have straightforward and easy code, but I'll rewrite
it as a state machine the way you proposed.

>
> > >
> > > > +     case BTF_KIND_ARRAY: {
> > > > +             const struct btf_array *loc_a, *targ_a;
> > > > +
> > > > +             loc_a = (void *)(local_type + 1);
> > > > +             targ_a = (void *)(targ_type + 1);
> > > > +             local_id = loc_a->type;
> > > > +             targ_id = targ_a->type;
> > >
> > > can we add a helper like:
> >
> > Yes, we can. I was thinking about that, but decided to not expand
> > patch set. But we do need to extract all those small, but nice
> > helpers. I'll put them in libbpf_internal.h for now, but I think it
> > might be good idea to expose them as part of btf.h. Thoughts?
>
> part of btf.h make sense to me.
>
> >
> > > const struct btf_array *btf_array(cosnt struct btf_type *t)
> > > {
> > >         return (const struct btf_array *)(t + 1);
> > > }
> > >
> > > then above will be:
> > >         case BTF_KIND_ARRAY: {
> > >                 local_id = btf_array(local_type)->type;
> > >                 targ_id = btf_array(targ_type)->type;
> > >
> > > and a bunch of code in btf.c and btf_dump.c would be cleaner as well?
> >
> > Yep, some of those are already scattered around btf.c and btf_dump.c,
> > will clean up and add patch to this patch set.
> >
> > >
> > > > +             goto recur;
> > > > +     }
> > > > +     default:
> > > > +             pr_warning("unexpected kind %d relocated, local [%d], target [%d]\n",
> > > > +                        kind, local_id, targ_id);
> > > > +             return 0;
> > > > +     }
> > > > +}
> > > > +
> > > > +/*
> > > > + * Given single high-level named field accessor in local type, find
> > > > + * corresponding high-level accessor for a target type. Along the way,
> > > > + * maintain low-level spec for target as well. Also keep updating target
> > > > + * offset.
> > > > + *
> > > > + * Searching is performed through recursive exhaustive enumeration of all
> > > > + * fields of a struct/union. If there are any anonymous (embedded)
> > > > + * structs/unions, they are recursively searched as well. If field with
> > > > + * desired name is found, check compatibility between local and target types,
> > > > + * before returning result.
> > > > + *
> > > > + * 1 is returned, if field is found.
> > > > + * 0 is returned if no compatible field is found.
> > > > + * <0 is returned on error.
> > > > + */
> > > > +static int bpf_core_match_member(const struct btf *local_btf,
> > > > +                              const struct bpf_core_accessor *local_acc,
> > > > +                              const struct btf *targ_btf,
> > > > +                              __u32 targ_id,
> > > > +                              struct bpf_core_spec *spec,
> > > > +                              __u32 *next_targ_id)
> > > > +{
> > > > +     const struct btf_type *local_type, *targ_type;
> > > > +     const struct btf_member *local_member, *m;
> > > > +     const char *local_name, *targ_name;
> > > > +     __u32 local_id;
> > > > +     int i, n, found;
> > > > +
> > > > +     targ_type = skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
> > > > +     if (!targ_type)
> > > > +             return -EINVAL;
> > > > +     if (!btf_is_composite(targ_type))
> > > > +             return 0;
> > > > +
> > > > +     local_id = local_acc->type_id;
> > > > +     local_type = btf__type_by_id(local_btf, local_id);
> > > > +     local_member = (void *)(local_type + 1);
> > > > +     local_member += local_acc->idx;
> > > > +     local_name = btf__name_by_offset(local_btf, local_member->name_off);
> > > > +
> > > > +     n = BTF_INFO_VLEN(targ_type->info);
> > > > +     m = (void *)(targ_type + 1);
> > >
> > > new btf_member() helper?
> > >
> > > > +     for (i = 0; i < n; i++, m++) {
> > > > +             __u32 offset;
> > > > +
> > > > +             /* bitfield relocations not supported */
> > > > +             if (BTF_INFO_KFLAG(targ_type->info)) {
> > > > +                     if (BTF_MEMBER_BITFIELD_SIZE(m->offset))
> > > > +                             continue;
> > > > +                     offset = BTF_MEMBER_BIT_OFFSET(m->offset);
> > > > +             } else {
> > > > +                     offset = m->offset;
> > > > +             }
> > > > +             if (offset % 8)
> > > > +                     continue;
> > >
> > > same bit of code again?
> > > definitely could use a helper.
> >
> > Different handling (continue here, return error above), but can use
> > those helpers I mentioned above.
> >
> > >
> > > > +     for (i = 0; i < local_spec->len; i++, local_acc++, targ_acc++) {
> > > > +             targ_type = skip_mods_and_typedefs(targ_spec->btf, targ_id,
> > > > +                                                &targ_id);
> > > > +             if (!targ_type)
> > > > +                     return -EINVAL;
> > > > +
> > > > +             if (local_acc->name) {
> > > > +                     matched = bpf_core_match_member(local_spec->btf,
> > > > +                                                     local_acc,
> > > > +                                                     targ_btf, targ_id,
> > > > +                                                     targ_spec, &targ_id);
> > > > +                     if (matched <= 0)
> > > > +                             return matched;
> > > > +             } else {
> > > > +                     /* for i=0, targ_id is already treated as array element
> > > > +                      * type (because it's the original struct), for others
> > > > +                      * we should find array element type first
> > > > +                      */
> > > > +                     if (i > 0) {
> > > > +                             const struct btf_array *a;
> > > > +
> > > > +                             if (!btf_is_array(targ_type))
> > > > +                                     return 0;
> > > > +
> > > > +                             a = (void *)(targ_type + 1);
> > > > +                             if (local_acc->idx >= a->nelems)
> > > > +                                     return 0;
> > >
> > > am I reading it correctly that the local spec requested out-of-bounds
> > > index in the target array type?
> > > Why this is 'ignore' instead of -EINVAL?
> >
> > Similar to any other mismatch (e.g., int in local type vs int64 in
> > target type). It just makes candidate not matching. Why would that be
> > error that will stop the whole relocation and subsequently object
> > loading process?
>
> Did the field name match or this is for anon types?
> I've read it as names matched and type miscompared.

No, not anonymous.

struct my_struct___local {
    int a;
};

struct my_struct___target {
    long long a;
};

my_struct___local->a will not match my_struct___target->a, but it's
not a reason to stop relocation process due to error.

>
> >
> > >
> > > > +/*
> > > > + * Probe few well-known locations for vmlinux kernel image and try to load BTF
> > > > + * data out of it to use for target BTF.
> > > > + */
> > > > +static struct btf *bpf_core_find_kernel_btf(void)
> > > > +{
> > > > +     const char *locations[] = {
> > > > +             "/lib/modules/%1$s/vmlinux-%1$s",
> > > > +             "/usr/lib/modules/%1$s/kernel/vmlinux",
> > > > +     };
> > > > +     char path[PATH_MAX + 1];
> > > > +     struct utsname buf;
> > > > +     struct btf *btf;
> > > > +     int i, err;
> > > > +
> > > > +     err = uname(&buf);
> > > > +     if (err) {
> > > > +             pr_warning("failed to uname(): %d\n", err);
> > >
> > > defensive programming ?
> > > I think uname() can fail only if &buf points to non-existing page like null.
> >
> > I haven't checked source for this syscall, but man page specified that
> > it might return -1 on error.
>
> man page says that it can only return EFAULT.

Ah, yeah, seems to be the only reason. I'll remove the check, it
wasn't paranoia :)

>
> >
> > >
> > > > +             return ERR_PTR(err);
> > > > +     }
> > > > +
> > > > +     for (i = 0; i < ARRAY_SIZE(locations); i++) {
> > > > +             snprintf(path, PATH_MAX, locations[i], buf.release);
> > > > +             pr_debug("attempting to load kernel BTF from '%s'\n", path);
> > >
> > > I think this debug message would have been more useful after access().
> >
> > Sure, will move.
> >
> > >
> > > > +
> > > > +             if (access(path, R_OK))
> > > > +                     continue;
> > > > +
> > > > +             btf = btf__parse_elf(path, NULL);
> > > > +             if (IS_ERR(btf))
> > > > +                     continue;
> > > > +
> > > > +             pr_debug("successfully loaded kernel BTF from '%s'\n", path);
> > > > +             return btf;
> > > > +     }
> > > > +
> > > > +     pr_warning("failed to find valid kernel BTF\n");
> > > > +     return ERR_PTR(-ESRCH);
> > > > +}
> > > > +
> > > > +/* Output spec definition in the format:
> > > > + * [<type-id>] (<type-name>) + <raw-spec> => <offset>@<spec>,
> > > > + * where <spec> is a C-syntax view of recorded field access, e.g.: x.a[3].b
> > > > + */
> > > > +static void bpf_core_dump_spec(int level, const struct bpf_core_spec *spec)
> > > > +{
> > > > +     const struct btf_type *t;
> > > > +     const char *s;
> > > > +     __u32 type_id;
> > > > +     int i;
> > > > +
> > > > +     type_id = spec->spec[0].type_id;
> > > > +     t = btf__type_by_id(spec->btf, type_id);
> > > > +     s = btf__name_by_offset(spec->btf, t->name_off);
> > > > +     libbpf_print(level, "[%u] (%s) + ", type_id, s);
> > >
> > > imo extra []() don't improve readability of the dump.
> >
> > [<num>] is the general convention I've been using throughout libbpf to
> > specify type ID, so I'd rather keep it for consistency. I can drop
> > parens, though, no problem.
> >
> > >
> > > > +
> > > > +     for (i = 0; i < spec->raw_len; i++)
> > > > +             libbpf_print(level, "%d%s", spec->raw_spec[i],
> > > > +                          i == spec->raw_len - 1 ? " => " : ":");
> > > > +
> > > > +     libbpf_print(level, "%u @ &x", spec->offset);
> > > > +
> > > > +     for (i = 0; i < spec->len; i++) {
> > > > +             if (spec->spec[i].name)
> > > > +                     libbpf_print(level, ".%s", spec->spec[i].name);
> > > > +             else
> > > > +                     libbpf_print(level, "[%u]", spec->spec[i].idx);
> > > > +     }
> > > > +
> > > > +}
> > > > +
> > > > +static size_t bpf_core_hash_fn(const void *key, void *ctx)
> > > > +{
> > > > +     return (size_t)key;
> > > > +}
> > > > +
> > > > +static bool bpf_core_equal_fn(const void *k1, const void *k2, void *ctx)
> > > > +{
> > > > +     return k1 == k2;
> > > > +}
> > > > +
> > > > +static void *u32_to_ptr(__u32 x)
> > > > +{
> > > > +     return (void *)(uintptr_t)x;
> > > > +}
> > >
> > > u32 to pointer on 64-bit arch?!
> > > That surely needs a comment.
> >
> > I should probably call it u32_to_hash_key() to make it obvious it's
> > conversion to hashmap's generic `void *` key type.
> >
> > >
> > > > +
> > > > +/*
> > > > + * CO-RE relocate single instruction.
> > > > + *
> > > > + * The outline and important points of the algorithm:
> > > > + * 1. For given local type, find corresponding candidate target types.
> > > > + *    Candidate type is a type with the same "essential" name, ignoring
> > > > + *    everything after last triple underscore (___). E.g., `sample`,
> > > > + *    `sample___flavor_one`, `sample___flavor_another_one`, are all candidates
> > > > + *    for each other. Names with triple underscore are referred to as
> > > > + *    "flavors" and are useful, among other things, to allow to
> > > > + *    specify/support incompatible variations of the same kernel struct, which
> > > > + *    might differ between different kernel versions and/or build
> > > > + *    configurations.
> > > > + *
> > > > + *    N.B. Struct "flavors" could be generated by bpftool's BTF-to-C
> > > > + *    converter, when deduplicated BTF of a kernel still contains more than
> > > > + *    one different types with the same name. In that case, ___2, ___3, etc
> > > > + *    are appended starting from second name conflict. But start flavors are
> > > > + *    also useful to be defined "locally", in BPF program, to extract same
> > > > + *    data from incompatible changes between different kernel
> > > > + *    versions/configurations. For instance, to handle field renames between
> > > > + *    kernel versions, one can use two flavors of the struct name with the
> > > > + *    same common name and use conditional relocations to extract that field,
> > > > + *    depending on target kernel version.
> > >
> > > there are actual kernel types that have ___ in the name.
> > > Ex: struct lmc___media
> > > We probably need to revisit this 'flavor' convention.
> >
> > There are only these:
> > - lmc___softc
> > - lmc___media
> > - lmc___ctl (all three in drivers/net/wan/lmc/lmc_var.h)
> > - ____ftrace_##name set of structs
> >
> > I couldn't come up with anything cleaner-looking. I think we can still
> > keep ___ convention, but:
> >
> > 1. Match only exactly 3 underscores, delimited by non-underscore from
> > both sides (so similar to your proposed loop above);
> > 2. We can also try matching candidates assuming full name without
> > ___xxx part removed, in addition to current logic. This seems like an
> > overkill at this point and unlikely to be useful in practice, so I'd
> > postpone implementing this until we really need it.
> >
> > What do you think? Which other convention did you have in mind?
>
> may be match ___[0-9]+ instead for now?
> Not as flexible, but user supplied "flavors" is not an immediate task.

All the tests I added use non-numeric flavors. While technically I can
use just ___1, ___2 and so on, it will greatly reduce readability,
while not really solving any problem (nothing prevents someone to add
something like lmc___1 eventually).

I think it's not worth it to complicate this logic just for
lmc___{softc,media,ctl}, but we can do 2) - try to match any struct as
is. If that fails, see if it's a "flavor" and match flavors.

>
> >
> > >
> > > > +     for (i = 0, j = 0; i < cand_ids->len; i++) {
> > > > +             cand_id = cand_ids->data[i];
> > > > +             cand_type = btf__type_by_id(targ_btf, cand_id);
> > > > +             cand_name = btf__name_by_offset(targ_btf, cand_type->name_off);
> > > > +
> > > > +             err = bpf_core_spec_match(&local_spec, targ_btf,
> > > > +                                       cand_id, &cand_spec);
> > > > +             if (err < 0) {
> > > > +                     pr_warning("prog '%s': relo #%d: failed to match spec ",
> > > > +                                prog_name, relo_idx);
> > > > +                     bpf_core_dump_spec(LIBBPF_WARN, &local_spec);
> > > > +                     libbpf_print(LIBBPF_WARN,
> > > > +                                  " to candidate #%d [%d] (%s): %d\n",
> > > > +                                  i, cand_id, cand_name, err);
> > > > +                     return err;
> > > > +             }
> > > > +             if (err == 0) {
> > > > +                     pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match spec ",
> > > > +                              prog_name, relo_idx, i, cand_id, cand_name);
> > > > +                     bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
> > > > +                     libbpf_print(LIBBPF_DEBUG, "\n");
> > > > +                     continue;
> > > > +             }
> > > > +
> > > > +             pr_debug("prog '%s': relo #%d: candidate #%d matched as spec ",
> > > > +                      prog_name, relo_idx, i);
> > >
> > > did you mention that you're going to make a helper for this debug dumps?
> >
> > yeah, I added bpf_core_dump_spec(), but I don't know how to shorten
> > this further... This output is extremely useful to understand what's
> > happening and will be invaluable when users will inevitably report
> > confusing behavior in some cases, so I still want to keep it.
>
> not sure yet. Just pointing out that this function has more debug printfs
> than actual code which doesn't look right.
> We have complex algorithms in the kernel (like verifier).
> Yet we don't sprinkle printfs in there to this degree.
>

We do have a verbose verifier logging, though, exactly to help users
to debug issues, which is extremely helpful and is greatly appreciated
by users.
There is nothing worse for developer experience than getting -EINVAL
without any useful log message. Been there, banged my head against the
wall wishing for a bit more verbose log. What are we trying to
optimize for here?
