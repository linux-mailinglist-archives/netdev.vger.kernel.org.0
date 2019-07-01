Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394295C20A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfGAReZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:34:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40657 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfGAReZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:34:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so6362100pgj.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5dGpNATvf/pkmooAKTXYIY1xsKuc4aJJ9EqJ2cl/D8s=;
        b=lFTqFLvtblPXLlqVk4KD2kptgWr7UKi38CYgCm201xz6C6sAt2LUdVHf4i9O5KcHv8
         OG3ibx27Yx+tRarxqFwzwJwMUOolvgz2TDsE4vZQBI4vycQ2CX5CLOOqIFLfjk7P0x3a
         s6OOp55/P3/oWYFumyQvR9ussU+zuB0FNFC2Wm7Zkb8BoxwvJvvHMCQoDUDTxVGXuQV0
         95FOcmcYZCrBMWlsx3Uy0u6lDyoUFT+k29xTU5krrOoRO3Cp16jVegGUk7D7IQkS8Oul
         irgnmYwCVwJ1IyC3oSKihjQ9IzJMwnU42aS53a/d6gGt9J5YPGp81MbZ95jxXCiJ7cPN
         sVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5dGpNATvf/pkmooAKTXYIY1xsKuc4aJJ9EqJ2cl/D8s=;
        b=Hlxik9dpQoDOcxo8LmCe1mHz8iEW9O0WinSlrrtH//ALSwhx8n0wjpw15fca6v/v3b
         EXu8j9Bw5RFz/xxFObJVj23X7azBtXzS5KnrxtG+OT7ivJKRR3cZBBgQbq6KgROjB6Bt
         MNtRls2yBPnYZtdjjl6ZFvdkte4M84MB0sUJEvAp/W/3+pxkfMsjfp1n76BUu3l/50a7
         3JpRT6bDAdznjPLJcxmQiRrfmU2C2v3iSYevSORgiek8iLvdS/Ya4sGET2HGGNZpuKF8
         0nbav8mCsQbGwyr8J5w/DkaLUSuJClryJ9yZMdIDh0vtj8HcKbhQjLDxmWt7XMIQ08h3
         vXiw==
X-Gm-Message-State: APjAAAXsjAMPpL2EWm36KzVpdeNgfCT748q1zWf8BFtSdkkkWu1x2Vxq
        E3VO81wIX24iwUF6moMBUGlPoQ==
X-Google-Smtp-Source: APXvYqxLhayidHQc9pIJ+Pfn16WGxpADn+obGN7xv+ppk/8MIcAV9/JI4/wQn2I3J/cRkfU3MvHJTA==
X-Received: by 2002:a65:51cb:: with SMTP id i11mr25096224pgq.390.1562002464338;
        Mon, 01 Jul 2019 10:34:24 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id c83sm15541045pfb.111.2019.07.01.10.34.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 10:34:23 -0700 (PDT)
Date:   Mon, 1 Jul 2019 10:34:22 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
Message-ID: <20190701173422.GF6757@mini-arch>
References: <20190701163103.237550-1-sdf@google.com>
 <20190701163103.237550-2-sdf@google.com>
 <CAEf4BzYRHjkuKKk+eR3-zbTFjjxae1Ks3SXr7kkAVgZxmVWU-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYRHjkuKKk+eR3-zbTFjjxae1Ks3SXr7kkAVgZxmVWU-A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01, Andrii Nakryiko wrote:
> On Mon, Jul 1, 2019 at 9:51 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Since commit cd17d7770578 ("bpf/tools: sync bpf.h") clang decided
> > that it can do a single u64 store into user_ip6[2] instead of two
> > separate u32 ones:
> >
> >  #  17: (18) r2 = 0x100000000000000
> >  #  ; ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
> >  #  19: (7b) *(u64 *)(r1 +16) = r2
> >  #  invalid bpf_context access off=16 size=8
> >
> > From the compiler point of view it does look like a correct thing
> > to do, so let's support it on the kernel side.
> >
> > Credit to Andrii Nakryiko for a proper implementation of
> > bpf_ctx_wide_store_ok.
> >
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Fixes: cd17d7770578 ("bpf/tools: sync bpf.h")
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/filter.h   |  6 ++++++
> >  include/uapi/linux/bpf.h |  4 ++--
> >  net/core/filter.c        | 22 ++++++++++++++--------
> >  3 files changed, 22 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 340f7d648974..3901007e36f1 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -746,6 +746,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
> >         return size <= size_default && (size & (size - 1)) == 0;
> >  }
> >
> > +#define bpf_ctx_wide_store_ok(off, size, type, field)                  \
> > +       (size == sizeof(__u64) &&                                       \
> > +       off >= offsetof(type, field) &&                                 \
> > +       off + sizeof(__u64) <= offsetofend(type, field) &&              \
> > +       off % sizeof(__u64) == 0)
> > +
> >  #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
> >
> >  static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a396b516a2b2..586867fe6102 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3237,7 +3237,7 @@ struct bpf_sock_addr {
> >         __u32 user_ip4;         /* Allows 1,2,4-byte read and 4-byte write.
> >                                  * Stored in network byte order.
> >                                  */
> > -       __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4-byte write.
> > +       __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4,8-byte write.
> 
> typo: an -> and
Oh, I was thinking that it was an article :-/
Will send a v3 with a fix, thanks!

> >                                  * Stored in network byte order.
> >                                  */
> >         __u32 user_port;        /* Allows 4-byte read and write.
> > @@ -3249,7 +3249,7 @@ struct bpf_sock_addr {
> >         __u32 msg_src_ip4;      /* Allows 1,2,4-byte read an 4-byte write.
> 
> same
> 
> >                                  * Stored in network byte order.
> >                                  */
> > -       __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4-byte write.
> > +       __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4,8-byte write.
> 
> the power of copy/paste! :)
> 
> >                                  * Stored in network byte order.
> >                                  */
> >         __bpf_md_ptr(struct bpf_sock *, sk);
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index dc8534be12fc..5d33f2146dab 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6849,6 +6849,16 @@ static bool sock_addr_is_valid_access(int off, int size,
> >                         if (!bpf_ctx_narrow_access_ok(off, size, size_default))
> >                                 return false;
> >                 } else {
> > +                       if (bpf_ctx_wide_store_ok(off, size,
> > +                                                 struct bpf_sock_addr,
> > +                                                 user_ip6))
> > +                               return true;
> > +
> > +                       if (bpf_ctx_wide_store_ok(off, size,
> > +                                                 struct bpf_sock_addr,
> > +                                                 msg_src_ip6))
> > +                               return true;
> > +
> >                         if (size != size_default)
> >                                 return false;
> >                 }
> > @@ -7689,9 +7699,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >  /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
> >   * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
> >   *
> > - * It doesn't support SIZE argument though since narrow stores are not
> > - * supported for now.
> > - *
> >   * In addition it uses Temporary Field TF (member of struct S) as the 3rd
> >   * "register" since two registers available in convert_ctx_access are not
> >   * enough: we can't override neither SRC, since it contains value to store, nor
> > @@ -7699,7 +7706,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >   * instructions. But we need a temporary place to save pointer to nested
> >   * structure whose field we want to store to.
> >   */
> > -#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)                       \
> > +#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)         \
> >         do {                                                                   \
> >                 int tmp_reg = BPF_REG_9;                                       \
> >                 if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)          \
> > @@ -7710,8 +7717,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >                                       offsetof(S, TF));                        \
> >                 *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,         \
> >                                       si->dst_reg, offsetof(S, F));            \
> > -               *insn++ = BPF_STX_MEM(                                         \
> > -                       BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,        \
> > +               *insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,              \
> >                         bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),           \
> >                                        target_size)                            \
> >                                 + OFF);                                        \
> > @@ -7723,8 +7729,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >                                                       TF)                      \
> >         do {                                                                   \
> >                 if (type == BPF_WRITE) {                                       \
> > -                       SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF,    \
> > -                                                        TF);                  \
> > +                       SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE,   \
> > +                                                        OFF, TF);             \
> >                 } else {                                                       \
> >                         SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(                  \
> >                                 S, NS, F, NF, SIZE, OFF);  \
> > --
> > 2.22.0.410.gd8fdbe21b5-goog
> >
