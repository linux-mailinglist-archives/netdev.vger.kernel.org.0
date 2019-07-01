Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C225C0D4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfGAQEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:04:36 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44966 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfGAQEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:04:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so7577013plr.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m7hn1FB7HgPD12gNF3RBhvZ+wkylf9MdvJIRxXEy20A=;
        b=YAa7zZembPHIvh/jtboDu7qSWbUG3YgAWycv+NblMW3aCX3tYnFhdPRJtji71VHLRd
         7tdrHx1UDqy6Rb/mf9A4Fc1ASM+/g4jRuoIORIhRBye0d8zJEl5+TfrRjeiZ5v+hQA1n
         zqPDea6RU4xqsXrtMRvUPwxo7IfKP00Lw36BWy6GzDSHJSdqBLTBwLIo7iAIMr4jWUre
         SHpxFsiEbdjYeUNmjawl+0kwx2XqXoJ/U1my4t3TDPDz06Fmbz6DUjRqcgd9zr5egmB2
         iDK5kSfEhyz0qjb1LWOH41x1EhvkztPqhfvwgBPI5L+RpL7GWr+44cnorP2hh8YeHF3a
         CVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m7hn1FB7HgPD12gNF3RBhvZ+wkylf9MdvJIRxXEy20A=;
        b=Ks4FeqjNfWFDUb/+Lf99FSHF5AvOAcgFTh0k7CIfYViVgTAuvUaa83waxhoEI3VTg7
         6RwoP+JRBVHeImL/rPDSJjMnUqFNaOoFdckGMHKQ2p5ZbGk4Zc3m6//0pBz4HEKWxM/H
         xA9FMKOb16VxvQX4/fIH+hqmFViBiWIPTP7xnOQjvrQRnrR7y59E5kz0hQ5nHHmOX5UT
         DxJylxilDPHxHmiKIR6/RT/AbYrbQOPOS/OjN8uDkMa9e2oi2fP1gJHUxuxC4m9Euta4
         NZZLjE+zJF1xry0A3CLTVBQ6mzJbG9UVGn1+iECNetWKfqQHoRwZTpZgGGoOK6HoZosH
         u0vg==
X-Gm-Message-State: APjAAAVby4COOQ9Dc3lk8KXtQVwgFQt/Ezeq9DzOr98mhEMwK9rtzcJx
        c7iGFwDZR8rSeUi/WBrw0A1ScQ==
X-Google-Smtp-Source: APXvYqyIDhzuApXzY65fVEB+WTMKYZYXEbK/8ZwbR0+SG8Pf/jZTbjyjX9YEtLkqShP47KcoJf91kA==
X-Received: by 2002:a17:902:6a2:: with SMTP id 31mr22794399plh.296.1561997075867;
        Mon, 01 Jul 2019 09:04:35 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f19sm7020695pfk.180.2019.07.01.09.04.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 09:04:35 -0700 (PDT)
Date:   Mon, 1 Jul 2019 09:04:34 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
Message-ID: <20190701160434.GD6757@mini-arch>
References: <20190628231049.22149-1-sdf@google.com>
 <be223396-b181-e587-d63c-2b15eaca3721@fb.com>
 <CAEf4BzbT7h2oDapgSwQr8gSMnunCssqu88KMdymMjgBGpZpA4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbT7h2oDapgSwQr8gSMnunCssqu88KMdymMjgBGpZpA4Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01, Andrii Nakryiko wrote:
> On Sat, Jun 29, 2019 at 10:53 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 6/28/19 4:10 PM, Stanislav Fomichev wrote:
> > > Since commit cd17d7770578 ("bpf/tools: sync bpf.h") clang decided
> > > that it can do a single u64 store into user_ip6[2] instead of two
> > > separate u32 ones:
> > >
> > >   #  17: (18) r2 = 0x100000000000000
> > >   #  ; ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
> > >   #  19: (7b) *(u64 *)(r1 +16) = r2
> > >   #  invalid bpf_context access off=16 size=8
> > >
> > >  From the compiler point of view it does look like a correct thing
> > > to do, so let's support it on the kernel side.
> > >
> > > Credit to Andrii Nakryiko for a proper implementation of
> > > bpf_ctx_wide_store_ok.
> > >
> > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > Cc: Yonghong Song <yhs@fb.com>
> > > Fixes: cd17d7770578 ("bpf/tools: sync bpf.h")
> > > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >
> > The change looks good to me with the following nits:
> >    1. could you add a cover letter for the patch set?
> >       typically if the number of patches is more than one,
> >       it would be a good practice with a cover letter.
> >       See bpf_devel_QA.rst .
> >    2. with this change, the comments in uapi bpf.h
> >       are not accurate any more.
> >          __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4-byte write.
> >                                   * Stored in network byte order.
> >
> >                                   */
> >          __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4-byte write.
> >                                   * Stored in network byte order.
> >                                   */
> >       now for stores, aligned 8-byte write is permitted.
> >       could you update this as well?
> >
> >  From the typical usage pattern, I did not see a need
> > for 8-tye read of user_ip6 and msg_src_ip6 yet. So let
> > us just deal with write for now.
> 
> But I guess it's still possible for clang to optimize two consecutive
> 4-byte reads into single 8-byte read in some circumstances? If that's
> the case, maybe it's a good idea to have corresponding read checks as
> well?
I guess clang can do those kinds of optimizations. I can put it on my
todo and address later (or when we actually see it out in the wild).

> But overall this looks good to me:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
Thanks for a review!

> >
> > With the above two nits,
> > Acked-by: Yonghong Song <yhs@fb.com>
> >
> > > ---
> > >   include/linux/filter.h |  6 ++++++
> > >   net/core/filter.c      | 22 ++++++++++++++--------
> > >   2 files changed, 20 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > index 340f7d648974..3901007e36f1 100644
> > > --- a/include/linux/filter.h
> > > +++ b/include/linux/filter.h
> > > @@ -746,6 +746,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
> > >       return size <= size_default && (size & (size - 1)) == 0;
> > >   }
> > >
> > > +#define bpf_ctx_wide_store_ok(off, size, type, field)                        \
> > > +     (size == sizeof(__u64) &&                                       \
> > > +     off >= offsetof(type, field) &&                                 \
> > > +     off + sizeof(__u64) <= offsetofend(type, field) &&              \
> > > +     off % sizeof(__u64) == 0)
> > > +
> > >   #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
> > >
> > >   static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index dc8534be12fc..5d33f2146dab 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -6849,6 +6849,16 @@ static bool sock_addr_is_valid_access(int off, int size,
> > >                       if (!bpf_ctx_narrow_access_ok(off, size, size_default))
> > >                               return false;
> > >               } else {
> > > +                     if (bpf_ctx_wide_store_ok(off, size,
> > > +                                               struct bpf_sock_addr,
> > > +                                               user_ip6))
> > > +                             return true;
> > > +
> > > +                     if (bpf_ctx_wide_store_ok(off, size,
> > > +                                               struct bpf_sock_addr,
> > > +                                               msg_src_ip6))
> > > +                             return true;
> > > +
> > >                       if (size != size_default)
> > >                               return false;
> > >               }
> > > @@ -7689,9 +7699,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> > >   /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
> > >    * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
> > >    *
> > > - * It doesn't support SIZE argument though since narrow stores are not
> > > - * supported for now.
> > > - *
> > >    * In addition it uses Temporary Field TF (member of struct S) as the 3rd
> > >    * "register" since two registers available in convert_ctx_access are not
> > >    * enough: we can't override neither SRC, since it contains value to store, nor
> > > @@ -7699,7 +7706,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> > >    * instructions. But we need a temporary place to save pointer to nested
> > >    * structure whose field we want to store to.
> > >    */
> > > -#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)                     \
> > > +#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)               \
> > >       do {                                                                   \
> > >               int tmp_reg = BPF_REG_9;                                       \
> > >               if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)          \
> > > @@ -7710,8 +7717,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> > >                                     offsetof(S, TF));                        \
> > >               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,         \
> > >                                     si->dst_reg, offsetof(S, F));            \
> > > -             *insn++ = BPF_STX_MEM(                                         \
> > > -                     BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,        \
> > > +             *insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,              \
> > >                       bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),           \
> > >                                      target_size)                            \
> > >                               + OFF);                                        \
> > > @@ -7723,8 +7729,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> > >                                                     TF)                      \
> > >       do {                                                                   \
> > >               if (type == BPF_WRITE) {                                       \
> > > -                     SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF,    \
> > > -                                                      TF);                  \
> > > +                     SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE,   \
> > > +                                                      OFF, TF);             \
> > >               } else {                                                       \
> > >                       SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(                  \
> > >                               S, NS, F, NF, SIZE, OFF);  \
> > >
