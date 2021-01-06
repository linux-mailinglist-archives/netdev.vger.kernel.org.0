Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267D42EB943
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 06:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbhAFFRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 00:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbhAFFRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 00:17:38 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC03CC06134C;
        Tue,  5 Jan 2021 21:16:57 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id o144so1801754ybc.0;
        Tue, 05 Jan 2021 21:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VFpdV6pRJZEFwxkogw1SPlzH3MjscLRM9pi8S+Tq6RI=;
        b=Vsy/aiqQTqzLnlEa8ixwJ8tp87H7kE+palKoVrYil9kmvsUs9O2yd5GKmFWBz39gLD
         /4ViVoyd3D5T1rx2gMa3UQV6A4+wsjO/8nEmKg9pP5x7m7SsKOHlvxL67yEJFhrMOJx6
         ylT5jGF0CqE9zkI2uwrIEQB+iGrEfLXR50P8hN8d1kUYcs6bpPDnXdN6NkIk8jyb5X0c
         s+vDCTmNxR2P0diwl9/IOgBkm1wacEodtygQ1L/ElBAnS46QXRlP2iO+J0ksuAPcDzar
         yC+bsvwKTOqMByZWakWJknN1yk+tnXP/hfpB/ErOqyHK8EtaipAZeionUbYv6EkN1Sh2
         kryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VFpdV6pRJZEFwxkogw1SPlzH3MjscLRM9pi8S+Tq6RI=;
        b=sy2LtcrHC1SkeQ1nUNgQ12mDyQfqA9ZFOVSFgLRsDTDRpdAlowZZSzdO88jOOI4oqh
         2eMFrSl6zXyJr2PKcWd52/RiWIzTlLWBmXw5Rx2eyUUyIp21O+vKA6xMcOHnx8D2l4tP
         gmihr8oujgg+wFwspuPW26+/KHd+1f8a9hLsptqoXS9mXfWBPRHiEHNmrvm/lXi2CP21
         cIIs3fp4R+936tw+rKBoxQg/nEfqk9TTf+358ryE89S1yZteH9Uqa6YoLn4DNM6KEVtL
         uOullV9ammWz40bDH2kcvFudKpQcktuR8Vi7z5qGae7+DGhnyj+nzx7zScxim5bMrrUj
         DfsQ==
X-Gm-Message-State: AOAM531yo1IgnK5MTPD6qes3SwAQp4IjiAon5Xvble2c7vSi1oCB9xR9
        2RxJQ5RE2L+Bn69w3zdHnPCTTfDmu95/D4Sielw=
X-Google-Smtp-Source: ABdhPJyt26pp7RQJLF36iWpvzxY1MJ4Z9aBlSFrdtXPwmWkwrIky5hV7UAboKbGev+6SDc9VAOvshb/oAqaVQjxHmlo=
X-Received: by 2002:a25:2c4c:: with SMTP id s73mr3906453ybs.230.1609910217022;
 Tue, 05 Jan 2021 21:16:57 -0800 (PST)
MIME-Version: 1.0
References: <cover.1609855479.git.sean@mess.org> <13cfab3593e0ea960ca732c259bfa60bf3c16b3b.1609855479.git.sean@mess.org>
 <CAEf4BzZgPx7YZ_S6a142gu+0XqxOq5-0=iMnAr1-DDJqyNOQrg@mail.gmail.com>
In-Reply-To: <CAEf4BzZgPx7YZ_S6a142gu+0XqxOq5-0=iMnAr1-DDJqyNOQrg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jan 2021 21:16:46 -0800
Message-ID: <CAEf4Bza-D-FtFkeEt3jEpR-9QNpXdRCnhx2Sekkj44xqRv+i-Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] btf: add support for ints larger than 128 bits
To:     Sean Young <sean@mess.org>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 9:10 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jan 5, 2021 at 6:45 AM Sean Young <sean@mess.org> wrote:
> >
> > clang supports arbitrary length ints using the _ExtInt extension. This
> > can be useful to hold very large values, e.g. 256 bit or 512 bit types.
> >
> > Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> > case for these.
> >
> > This requires the _ExtInt extension enabled in clang, which is under
> > review.
> >
> > Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> > Link: https://reviews.llvm.org/D93103
> >
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  Documentation/bpf/btf.rst      |  4 +--
> >  include/uapi/linux/btf.h       |  2 +-
> >  kernel/bpf/btf.c               | 54 ++++++++++++++++++++++++++++------
> >  tools/include/uapi/linux/btf.h |  2 +-
> >  4 files changed, 49 insertions(+), 13 deletions(-)
> >
> > diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
> > index 44dc789de2b4..784f1743dbc7 100644
> > --- a/Documentation/bpf/btf.rst
> > +++ b/Documentation/bpf/btf.rst
> > @@ -132,7 +132,7 @@ The following sections detail encoding of each kind.
> >
> >    #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
> >    #define BTF_INT_OFFSET(VAL)     (((VAL) & 0x00ff0000) >> 16)
> > -  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000000ff)
> > +  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000003ff)
> >
> >  The ``BTF_INT_ENCODING`` has the following attributes::
> >
> > @@ -147,7 +147,7 @@ pretty print. At most one encoding can be specified for the int type.
> >  The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
> >  type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
> >  The ``btf_type.size * 8`` must be equal to or greater than ``BTF_INT_BITS()``
> > -for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
> > +for the type. The maximum value of ``BTF_INT_BITS()`` is 512.
> >
> >  The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
> >  for this int. For example, a bitfield struct member has:
> > diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
> > index 5a667107ad2c..1696fd02b302 100644
> > --- a/include/uapi/linux/btf.h
> > +++ b/include/uapi/linux/btf.h
> > @@ -84,7 +84,7 @@ struct btf_type {
> >   */
> >  #define BTF_INT_ENCODING(VAL)  (((VAL) & 0x0f000000) >> 24)
> >  #define BTF_INT_OFFSET(VAL)    (((VAL) & 0x00ff0000) >> 16)
> > -#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000000ff)
> > +#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000003ff)
> >
> >  /* Attributes stored in the BTF_INT_ENCODING */
> >  #define BTF_INT_SIGNED (1 << 0)
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 8d6bdb4f4d61..44bc17207e9b 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -166,7 +166,8 @@
> >   *
> >   */
> >
> > -#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
> > +#define BITS_PER_U128 128
> > +#define BITS_PER_U512 512
> >  #define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
> >  #define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
> >  #define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
> > @@ -1907,9 +1908,9 @@ static int btf_int_check_member(struct btf_verifier_env *env,
> >         nr_copy_bits = BTF_INT_BITS(int_data) +
> >                 BITS_PER_BYTE_MASKED(struct_bits_off);
> >
> > -       if (nr_copy_bits > BITS_PER_U128) {
> > +       if (nr_copy_bits > BITS_PER_U512) {
> >                 btf_verifier_log_member(env, struct_type, member,
> > -                                       "nr_copy_bits exceeds 128");
> > +                                       "nr_copy_bits exceeds 512");
> >                 return -EINVAL;
> >         }
> >
> > @@ -1963,9 +1964,9 @@ static int btf_int_check_kflag_member(struct btf_verifier_env *env,
> >
> >         bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
> >         nr_copy_bits = nr_bits + BITS_PER_BYTE_MASKED(struct_bits_off);
> > -       if (nr_copy_bits > BITS_PER_U128) {
> > +       if (nr_copy_bits > BITS_PER_U512) {
> >                 btf_verifier_log_member(env, struct_type, member,
> > -                                       "nr_copy_bits exceeds 128");
> > +                                       "nr_copy_bits exceeds 512");
> >                 return -EINVAL;
> >         }
> >
> > @@ -2012,9 +2013,9 @@ static s32 btf_int_check_meta(struct btf_verifier_env *env,
> >
> >         nr_bits = BTF_INT_BITS(int_data) + BTF_INT_OFFSET(int_data);
> >
> > -       if (nr_bits > BITS_PER_U128) {
> > -               btf_verifier_log_type(env, t, "nr_bits exceeds %zu",
> > -                                     BITS_PER_U128);
> > +       if (nr_bits > BITS_PER_U512) {
> > +               btf_verifier_log_type(env, t, "nr_bits exceeds %u",
> > +                                     BITS_PER_U512);
> >                 return -EINVAL;
> >         }
> >
> > @@ -2080,6 +2081,37 @@ static void btf_int128_print(struct btf_show *show, void *data)
> >                                      lower_num);
> >  }
> >
> > +static void btf_bigint_print(struct btf_show *show, void *data, u16 nr_bits)
> > +{
> > +       /* data points to 256 or 512 bit int type */
> > +       char buf[129];
> > +       int last_u64 = nr_bits / 64 - 1;
> > +       bool seen_nonzero = false;
> > +       int i;
> > +
> > +       for (i = 0; i <= last_u64; i++) {
> > +#ifdef __BIG_ENDIAN_BITFIELD
> > +               u64 v = ((u64 *)data)[i];
> > +#else
> > +               u64 v = ((u64 *)data)[last_u64 - i];
> > +#endif

to avoid duplicating this #ifdef with my suggestion, you can do something like

#ifdef __BIG_ENDIAN_BITFIELD
u64 *v = (u64 *)data;
int step = 1;
#else
u64 *v = (u64 *)data + last_u64;
int step = -1;
#endif

and then just `v += step;` everywhere

> > +               if (!seen_nonzero) {
> > +                       if (!v && i != last_u64)
> > +                               continue;
> > +
> > +                       snprintf(buf, sizeof(buf), "%llx", v);
> > +
> > +                       seen_nonzero = true;
> > +               } else {
> > +                       size_t off = strlen(buf);
>
> this is wasteful, snprintf() returns number of characters printed, so
> you can maintain offset properly
>
> > +
> > +                       snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
> > +               }
> > +       }
> > +
> > +       btf_show_type_value(show, "0x%s", buf);
> > +}
>
> seen_nonzero is a bit convoluted, two simple loops might be more
> straightforward:
>
> u64 v;
> int off;
>
> /* find first non-zero u64 (or stop on the last one regardless) */
> for (i = 0; i < last_u64; i++) {
>   v = ...;
>   if (!v)
>     continue;
> }
> /* print non-zero or zero, but last u64 */
> off = snprintf(buf, sizeof(buf), "%llx", v);
> /* print the rest with zero padding */
> for (i++; i <= last_u64; i++) {
>   v = ...;
>   off += snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
> }
>
> > +
> >  static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
> >                              u16 right_shift_bits)
> >  {
> > @@ -2172,7 +2204,7 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
> >         u32 int_data = btf_type_int(t);
> >         u8 encoding = BTF_INT_ENCODING(int_data);
> >         bool sign = encoding & BTF_INT_SIGNED;
> > -       u8 nr_bits = BTF_INT_BITS(int_data);
> > +       u16 nr_bits = BTF_INT_BITS(int_data);
> >         void *safe_data;
> >
> >         safe_data = btf_show_start_type(show, t, type_id, data);
> > @@ -2186,6 +2218,10 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
> >         }
> >
> >         switch (nr_bits) {
> > +       case 512:
> > +       case 256:
> > +               btf_bigint_print(show, safe_data, nr_bits);
> > +               break;
> >         case 128:
> >                 btf_int128_print(show, safe_data);
>
> btf_bigint_print() supersedes btf_int128_print(), why maintain both?
>
> >                 break;
> > diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
> > index 5a667107ad2c..1696fd02b302 100644
> > --- a/tools/include/uapi/linux/btf.h
> > +++ b/tools/include/uapi/linux/btf.h
> > @@ -84,7 +84,7 @@ struct btf_type {
> >   */
> >  #define BTF_INT_ENCODING(VAL)  (((VAL) & 0x0f000000) >> 24)
> >  #define BTF_INT_OFFSET(VAL)    (((VAL) & 0x00ff0000) >> 16)
> > -#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000000ff)
> > +#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000003ff)
> >
> >  /* Attributes stored in the BTF_INT_ENCODING */
> >  #define BTF_INT_SIGNED (1 << 0)
> > --
> > 2.29.2
> >
