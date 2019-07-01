Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F745C05D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfGAPgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:36:16 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42161 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbfGAPgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:36:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so15058286qtk.9;
        Mon, 01 Jul 2019 08:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkx/qJ8eI3y0m6A4MBTtNAvtV8T8ESk/GkGO0UYcsNM=;
        b=GxqJoOIApBZHzobayrcuAqJlSdNKhKYFWFaLw/v6b3hDe8238Fe7EDQph9waZcoxDn
         DW+egfkCCR5g8bJKuaN+p6Oj3DRURuoiXQIjuiupypuNyIQA2JQ6ImEfLd+VxkpvB4KT
         9EPbuf5YSKwvBo8uZXQ9S6ID9XeCx2/Hqs4YOs363TR1vJS6tyadG1yyLJT8iOpLhDIW
         fBamoF+3XWPv6wFeLrInNsp9xcyAbF6rInEoo0QdnNZAvQtxWWmoGaML6ubA+em9UOGZ
         wejXxtMt/N7+Hi2HMS+D2jDTvqXoRXHZCKlGct7zZNCIH2R56SezAoFsIfIsRhnFRNXJ
         uqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkx/qJ8eI3y0m6A4MBTtNAvtV8T8ESk/GkGO0UYcsNM=;
        b=TfyGQ2Nx0JnQwDzOqVzxdMh9MxUcl2kHzZLMkYWeg/t40MtoyzG2CbdSQy+rMBkhIC
         dcAt59zEbDVJxLcYaNGt7mCggQ0Co2HYRb7UCDz2dRpF0JXLW7UyFbB1Iy19/ftq8YVU
         z3aaCJky2Fwx6430bwPpspFF9eb7+lX2VIPPXonTTwuoqCevLumSAqhziIllZgvfYQUd
         ugf2mYokyOebP712/Ebfka4hZG62CojNoV3MuZFl/cUFJKphYzNFREXMevMOTiXIxy4b
         lN1ljdvfE5RwRpCOF1DxNGTSjPcPjnw48fBFHjtTbiIpDtLT5ELPN4fLemfQp1wJ3hId
         NCGg==
X-Gm-Message-State: APjAAAUJPBhD+s8GbO1Newiw+zijgh57TMl9EFyBQ2npdQvSl0DXmwWc
        XpoHiA7Y2ieJ34q/ObnjBFTj5keMI1coser3wWA=
X-Google-Smtp-Source: APXvYqwCGpbkxLueVdnYY2wo4dyIXr3ZwLLdZih8GlBpjIDXsi2Od/xlKq4jnJaIYKTF4MI+q4XUcYMK1DIig0yAntw=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr20760377qta.171.1561995375099;
 Mon, 01 Jul 2019 08:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190628231049.22149-1-sdf@google.com> <be223396-b181-e587-d63c-2b15eaca3721@fb.com>
In-Reply-To: <be223396-b181-e587-d63c-2b15eaca3721@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 08:36:04 -0700
Message-ID: <CAEf4BzbT7h2oDapgSwQr8gSMnunCssqu88KMdymMjgBGpZpA4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 10:53 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 4:10 PM, Stanislav Fomichev wrote:
> > Since commit cd17d7770578 ("bpf/tools: sync bpf.h") clang decided
> > that it can do a single u64 store into user_ip6[2] instead of two
> > separate u32 ones:
> >
> >   #  17: (18) r2 = 0x100000000000000
> >   #  ; ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
> >   #  19: (7b) *(u64 *)(r1 +16) = r2
> >   #  invalid bpf_context access off=16 size=8
> >
> >  From the compiler point of view it does look like a correct thing
> > to do, so let's support it on the kernel side.
> >
> > Credit to Andrii Nakryiko for a proper implementation of
> > bpf_ctx_wide_store_ok.
> >
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Fixes: cd17d7770578 ("bpf/tools: sync bpf.h")
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> The change looks good to me with the following nits:
>    1. could you add a cover letter for the patch set?
>       typically if the number of patches is more than one,
>       it would be a good practice with a cover letter.
>       See bpf_devel_QA.rst .
>    2. with this change, the comments in uapi bpf.h
>       are not accurate any more.
>          __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4-byte write.
>                                   * Stored in network byte order.
>
>                                   */
>          __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4-byte write.
>                                   * Stored in network byte order.
>                                   */
>       now for stores, aligned 8-byte write is permitted.
>       could you update this as well?
>
>  From the typical usage pattern, I did not see a need
> for 8-tye read of user_ip6 and msg_src_ip6 yet. So let
> us just deal with write for now.

But I guess it's still possible for clang to optimize two consecutive
4-byte reads into single 8-byte read in some circumstances? If that's
the case, maybe it's a good idea to have corresponding read checks as
well?

But overall this looks good to me:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> With the above two nits,
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   include/linux/filter.h |  6 ++++++
> >   net/core/filter.c      | 22 ++++++++++++++--------
> >   2 files changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 340f7d648974..3901007e36f1 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -746,6 +746,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
> >       return size <= size_default && (size & (size - 1)) == 0;
> >   }
> >
> > +#define bpf_ctx_wide_store_ok(off, size, type, field)                        \
> > +     (size == sizeof(__u64) &&                                       \
> > +     off >= offsetof(type, field) &&                                 \
> > +     off + sizeof(__u64) <= offsetofend(type, field) &&              \
> > +     off % sizeof(__u64) == 0)
> > +
> >   #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
> >
> >   static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index dc8534be12fc..5d33f2146dab 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6849,6 +6849,16 @@ static bool sock_addr_is_valid_access(int off, int size,
> >                       if (!bpf_ctx_narrow_access_ok(off, size, size_default))
> >                               return false;
> >               } else {
> > +                     if (bpf_ctx_wide_store_ok(off, size,
> > +                                               struct bpf_sock_addr,
> > +                                               user_ip6))
> > +                             return true;
> > +
> > +                     if (bpf_ctx_wide_store_ok(off, size,
> > +                                               struct bpf_sock_addr,
> > +                                               msg_src_ip6))
> > +                             return true;
> > +
> >                       if (size != size_default)
> >                               return false;
> >               }
> > @@ -7689,9 +7699,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >   /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
> >    * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
> >    *
> > - * It doesn't support SIZE argument though since narrow stores are not
> > - * supported for now.
> > - *
> >    * In addition it uses Temporary Field TF (member of struct S) as the 3rd
> >    * "register" since two registers available in convert_ctx_access are not
> >    * enough: we can't override neither SRC, since it contains value to store, nor
> > @@ -7699,7 +7706,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >    * instructions. But we need a temporary place to save pointer to nested
> >    * structure whose field we want to store to.
> >    */
> > -#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)                     \
> > +#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)               \
> >       do {                                                                   \
> >               int tmp_reg = BPF_REG_9;                                       \
> >               if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)          \
> > @@ -7710,8 +7717,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >                                     offsetof(S, TF));                        \
> >               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,         \
> >                                     si->dst_reg, offsetof(S, F));            \
> > -             *insn++ = BPF_STX_MEM(                                         \
> > -                     BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,        \
> > +             *insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,              \
> >                       bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),           \
> >                                      target_size)                            \
> >                               + OFF);                                        \
> > @@ -7723,8 +7729,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >                                                     TF)                      \
> >       do {                                                                   \
> >               if (type == BPF_WRITE) {                                       \
> > -                     SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF,    \
> > -                                                      TF);                  \
> > +                     SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE,   \
> > +                                                      OFF, TF);             \
> >               } else {                                                       \
> >                       SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(                  \
> >                               S, NS, F, NF, SIZE, OFF);  \
> >
