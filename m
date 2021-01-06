Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FABB2EB939
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 06:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbhAFFLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 00:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbhAFFLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 00:11:35 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1459BC06134C;
        Tue,  5 Jan 2021 21:10:55 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d37so1760566ybi.4;
        Tue, 05 Jan 2021 21:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zXdX42ua40xKPxCS3alHiWCo/OZpqmT3ZMbLUhJVIoQ=;
        b=ScquwSv3l1zJD5Zz7N+SxbCl1vS0Ry24uNIc6MXY5OsLM9r/Yv7dwjlqA0o8jhmd7M
         0kD4V/zkTef/juusVHqbvV6x7ZKrS19sFnBBm8SAdqWf4bc+4GcxtKQR2Uc6oBMZbpIN
         CNTmynMWVoLj7vgb980TnUtePUsWYc+flj5iysjRCbXA/ZNHlEgVQeRe8pIrfddAAZ9y
         LGKF+TEbRf+9+0Wg+/d53zAk83Mcng6h3N1wsrORQULhaZSE6MDn+RPrbLrI66FRzzT8
         zsg9gbEhXdh8Pq51Vy2WMYvjWbi02gfR03AYxr7wkraNvqZ7yI2EXTG0MW84I3BJ2dLc
         NukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zXdX42ua40xKPxCS3alHiWCo/OZpqmT3ZMbLUhJVIoQ=;
        b=EcTd+rwUthkCrGJXvsYixjH2pZiWR7RcHpKRbeysGlyVzpp6HRxs4xJaQl9DsrupUa
         bx1CFPZCMKK8BVUHjoPTZVY5jgb0R1SikY249St1ivUN2CEc/kWFnlHfH5+2N+ALCPFU
         Wl8wPtXGMLGB5i7fejRlSu/SFKg63TuXyKXqWkt1qkIKKvTHATkq3IBTb8SQwrGmCg0j
         wGWjmNIL4/jqoZNv5YWNd0LXNq4KVIRzPLtznIWmTAu69sUW26acxk7c8zLzQGXZUmi7
         ZWFKoffEVQJAY5x1mRf12nnF6+2d1CGLVkzv1h8y8vcLU0QirkdMvFIk7q+8mSO68BjP
         O5Fw==
X-Gm-Message-State: AOAM531/Zkvahvni3TFHIHlwSBOnn4zPeQvZPdmX2s0mqrDmNhH9AyIO
        ZM1UrNC6g8Y6Q7FF/Hqo/UApdqbGmTN7I9/+LQc=
X-Google-Smtp-Source: ABdhPJzibH1Jx33aQqyK0T+FEsVCOYsD6mY+Ni1wTcXokioTjSOKv22NRgxCBbGm9JXS4QgLpHZmWs8hUeoKOxBhWjQ=
X-Received: by 2002:a25:d44:: with SMTP id 65mr3853240ybn.260.1609909853620;
 Tue, 05 Jan 2021 21:10:53 -0800 (PST)
MIME-Version: 1.0
References: <cover.1609855479.git.sean@mess.org> <13cfab3593e0ea960ca732c259bfa60bf3c16b3b.1609855479.git.sean@mess.org>
In-Reply-To: <13cfab3593e0ea960ca732c259bfa60bf3c16b3b.1609855479.git.sean@mess.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jan 2021 21:10:42 -0800
Message-ID: <CAEf4BzZgPx7YZ_S6a142gu+0XqxOq5-0=iMnAr1-DDJqyNOQrg@mail.gmail.com>
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

On Tue, Jan 5, 2021 at 6:45 AM Sean Young <sean@mess.org> wrote:
>
> clang supports arbitrary length ints using the _ExtInt extension. This
> can be useful to hold very large values, e.g. 256 bit or 512 bit types.
>
> Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> case for these.
>
> This requires the _ExtInt extension enabled in clang, which is under
> review.
>
> Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> Link: https://reviews.llvm.org/D93103
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  Documentation/bpf/btf.rst      |  4 +--
>  include/uapi/linux/btf.h       |  2 +-
>  kernel/bpf/btf.c               | 54 ++++++++++++++++++++++++++++------
>  tools/include/uapi/linux/btf.h |  2 +-
>  4 files changed, 49 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
> index 44dc789de2b4..784f1743dbc7 100644
> --- a/Documentation/bpf/btf.rst
> +++ b/Documentation/bpf/btf.rst
> @@ -132,7 +132,7 @@ The following sections detail encoding of each kind.
>
>    #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
>    #define BTF_INT_OFFSET(VAL)     (((VAL) & 0x00ff0000) >> 16)
> -  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000000ff)
> +  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000003ff)
>
>  The ``BTF_INT_ENCODING`` has the following attributes::
>
> @@ -147,7 +147,7 @@ pretty print. At most one encoding can be specified for the int type.
>  The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
>  type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
>  The ``btf_type.size * 8`` must be equal to or greater than ``BTF_INT_BITS()``
> -for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
> +for the type. The maximum value of ``BTF_INT_BITS()`` is 512.
>
>  The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
>  for this int. For example, a bitfield struct member has:
> diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
> index 5a667107ad2c..1696fd02b302 100644
> --- a/include/uapi/linux/btf.h
> +++ b/include/uapi/linux/btf.h
> @@ -84,7 +84,7 @@ struct btf_type {
>   */
>  #define BTF_INT_ENCODING(VAL)  (((VAL) & 0x0f000000) >> 24)
>  #define BTF_INT_OFFSET(VAL)    (((VAL) & 0x00ff0000) >> 16)
> -#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000000ff)
> +#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000003ff)
>
>  /* Attributes stored in the BTF_INT_ENCODING */
>  #define BTF_INT_SIGNED (1 << 0)
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 8d6bdb4f4d61..44bc17207e9b 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -166,7 +166,8 @@
>   *
>   */
>
> -#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
> +#define BITS_PER_U128 128
> +#define BITS_PER_U512 512
>  #define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
>  #define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
>  #define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
> @@ -1907,9 +1908,9 @@ static int btf_int_check_member(struct btf_verifier_env *env,
>         nr_copy_bits = BTF_INT_BITS(int_data) +
>                 BITS_PER_BYTE_MASKED(struct_bits_off);
>
> -       if (nr_copy_bits > BITS_PER_U128) {
> +       if (nr_copy_bits > BITS_PER_U512) {
>                 btf_verifier_log_member(env, struct_type, member,
> -                                       "nr_copy_bits exceeds 128");
> +                                       "nr_copy_bits exceeds 512");
>                 return -EINVAL;
>         }
>
> @@ -1963,9 +1964,9 @@ static int btf_int_check_kflag_member(struct btf_verifier_env *env,
>
>         bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
>         nr_copy_bits = nr_bits + BITS_PER_BYTE_MASKED(struct_bits_off);
> -       if (nr_copy_bits > BITS_PER_U128) {
> +       if (nr_copy_bits > BITS_PER_U512) {
>                 btf_verifier_log_member(env, struct_type, member,
> -                                       "nr_copy_bits exceeds 128");
> +                                       "nr_copy_bits exceeds 512");
>                 return -EINVAL;
>         }
>
> @@ -2012,9 +2013,9 @@ static s32 btf_int_check_meta(struct btf_verifier_env *env,
>
>         nr_bits = BTF_INT_BITS(int_data) + BTF_INT_OFFSET(int_data);
>
> -       if (nr_bits > BITS_PER_U128) {
> -               btf_verifier_log_type(env, t, "nr_bits exceeds %zu",
> -                                     BITS_PER_U128);
> +       if (nr_bits > BITS_PER_U512) {
> +               btf_verifier_log_type(env, t, "nr_bits exceeds %u",
> +                                     BITS_PER_U512);
>                 return -EINVAL;
>         }
>
> @@ -2080,6 +2081,37 @@ static void btf_int128_print(struct btf_show *show, void *data)
>                                      lower_num);
>  }
>
> +static void btf_bigint_print(struct btf_show *show, void *data, u16 nr_bits)
> +{
> +       /* data points to 256 or 512 bit int type */
> +       char buf[129];
> +       int last_u64 = nr_bits / 64 - 1;
> +       bool seen_nonzero = false;
> +       int i;
> +
> +       for (i = 0; i <= last_u64; i++) {
> +#ifdef __BIG_ENDIAN_BITFIELD
> +               u64 v = ((u64 *)data)[i];
> +#else
> +               u64 v = ((u64 *)data)[last_u64 - i];
> +#endif
> +               if (!seen_nonzero) {
> +                       if (!v && i != last_u64)
> +                               continue;
> +
> +                       snprintf(buf, sizeof(buf), "%llx", v);
> +
> +                       seen_nonzero = true;
> +               } else {
> +                       size_t off = strlen(buf);

this is wasteful, snprintf() returns number of characters printed, so
you can maintain offset properly

> +
> +                       snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
> +               }
> +       }
> +
> +       btf_show_type_value(show, "0x%s", buf);
> +}

seen_nonzero is a bit convoluted, two simple loops might be more
straightforward:

u64 v;
int off;

/* find first non-zero u64 (or stop on the last one regardless) */
for (i = 0; i < last_u64; i++) {
  v = ...;
  if (!v)
    continue;
}
/* print non-zero or zero, but last u64 */
off = snprintf(buf, sizeof(buf), "%llx", v);
/* print the rest with zero padding */
for (i++; i <= last_u64; i++) {
  v = ...;
  off += snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
}

> +
>  static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
>                              u16 right_shift_bits)
>  {
> @@ -2172,7 +2204,7 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
>         u32 int_data = btf_type_int(t);
>         u8 encoding = BTF_INT_ENCODING(int_data);
>         bool sign = encoding & BTF_INT_SIGNED;
> -       u8 nr_bits = BTF_INT_BITS(int_data);
> +       u16 nr_bits = BTF_INT_BITS(int_data);
>         void *safe_data;
>
>         safe_data = btf_show_start_type(show, t, type_id, data);
> @@ -2186,6 +2218,10 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
>         }
>
>         switch (nr_bits) {
> +       case 512:
> +       case 256:
> +               btf_bigint_print(show, safe_data, nr_bits);
> +               break;
>         case 128:
>                 btf_int128_print(show, safe_data);

btf_bigint_print() supersedes btf_int128_print(), why maintain both?

>                 break;
> diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
> index 5a667107ad2c..1696fd02b302 100644
> --- a/tools/include/uapi/linux/btf.h
> +++ b/tools/include/uapi/linux/btf.h
> @@ -84,7 +84,7 @@ struct btf_type {
>   */
>  #define BTF_INT_ENCODING(VAL)  (((VAL) & 0x0f000000) >> 24)
>  #define BTF_INT_OFFSET(VAL)    (((VAL) & 0x00ff0000) >> 16)
> -#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000000ff)
> +#define BTF_INT_BITS(VAL)      ((VAL)  & 0x000003ff)
>
>  /* Attributes stored in the BTF_INT_ENCODING */
>  #define BTF_INT_SIGNED (1 << 0)
> --
> 2.29.2
>
