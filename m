Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA386D5BE8
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjDDJ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjDDJ3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:29:43 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D4E1BDC;
        Tue,  4 Apr 2023 02:29:41 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id j7so37908085ybg.4;
        Tue, 04 Apr 2023 02:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680600580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m+eL/z8RH/5rtw+dy/g/xT9VEmo4zwfmYNqhFX98Cqw=;
        b=E21CLEBXl/AvExfe4X9ObKgn0tL4bMgbcWOtk9mmVcWVa3bwDSurtjprFskIdwsWmL
         F7Fv6vv4tQiYeubOtRWhlpmSeESdJO9sDFFjoPpMEmrMNMPX3/DIFlmx/LVCnfg/x5yg
         YIHrUlTJ7oksO67eUW12uxiaEOh0VM9fBTjiSl14jj8hXOatuLnBmjLdALFR0qaYAYfh
         1YgaVcGcB/ixrMM08U7kgRhNGmZQTyvGmb+yEH/fds4Kma1wpri+WjMRog2FuEMUdpv7
         iHu6YGokiH2qtYIE2HkK8yPShpCwDPKoUiBYBrX2y5JVA3AW+Zd09fjUEGGdiUW/th3Q
         LQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680600580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+eL/z8RH/5rtw+dy/g/xT9VEmo4zwfmYNqhFX98Cqw=;
        b=yqRa/PdgcgYkYa8VdGfrw7WirYQAQVWZlAzIidxInJb1E+M1zZlvReWxzlz32sbdNK
         h3MOUcwewS4Yyx2E8GeF2+eev8d5rqlaCaLylpDe44zAVcrvJBXUnK3x5RFrEmBcHAPy
         ZRX1cARU6VoRxw8PLj5kVGVWUg4ZQSDwmLo4/1SYtCGyiJPE/Q4LaagUN+1qNRV5ijik
         VRJYVz1EmPAKY+HutxWE06EY7ZpNLMIE7qcjrNRoybC+qR68Ln+BUa3qgmSaK3pqgOrN
         M9mGyv0vJwEy8m0xq7+L99V3AD8U64JBGy8WxS65u/f5XgoEAzTVSRI/n1v8+84vZ0bC
         IQ8A==
X-Gm-Message-State: AAQBX9fAMr+fOOCQuLVbMpoKCi0Ff/rZRqf0Nbe7oKyMvx0Ll9sZpaeu
        bbyoge6P14pGLxro71R9NhU0ciQLH3+g7pMrdMk=
X-Google-Smtp-Source: AKy350YMnjVKc1oUniZ14UmKxTE2eBETlKxxRUa6bi1S7O7Gs/iVA8trnOr5nx5pqm+8zgB6e53f/vGt3ig4k+Zz4JE=
X-Received: by 2002:a25:cb83:0:b0:b6a:5594:5936 with SMTP id
 b125-20020a25cb83000000b00b6a55945936mr1430996ybg.5.1680600580420; Tue, 04
 Apr 2023 02:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-9-kal.conley@dectris.com> <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
 <CAHApi-nfBM=i1WeZ-jtHN87AWPvURo0LygT9yYxF=cUeYthXBQ@mail.gmail.com>
In-Reply-To: <CAHApi-nfBM=i1WeZ-jtHN87AWPvURo0LygT9yYxF=cUeYthXBQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 11:29:29 +0200
Message-ID: <CAJ8uoz0SEkcXQuoqYd94GreJqpCxQuf1QVgm9=Um6Wqk=s8GBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 at 10:15, Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> > Is not the max 64K as you test against XDP_UMEM_MAX_CHUNK_SIZE in
> > xdp_umem_reg()?
>
> The absolute max is 64K. In the case of HPAGE_SIZE < 64K, then it
> would be HPAGE_SIZE.

Is there such a case when HPAGE_SIZE would be less than 64K? If not,
then just write 64K.

> > > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > > index e96a1151ec75..ed88880d4b68 100644
> > > --- a/include/net/xdp_sock.h
> > > +++ b/include/net/xdp_sock.h
> > > @@ -28,6 +28,9 @@ struct xdp_umem {
> > >         struct user_struct *user;
> > >         refcount_t users;
> > >         u8 flags;
> > > +#ifdef CONFIG_HUGETLB_PAGE
> >
> > Sanity check: have you tried compiling your code without this config set?
>
> Yes. The CI does this also on one of the platforms (hence some of the
> bot errors in v1).

Perfect!

> > >  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> > >  {
> > > +#ifdef CONFIG_HUGETLB_PAGE
> >
> > Let us try to get rid of most of these #ifdefs sprinkled around the
> > code. How about hiding this inside xdp_umem_is_hugetlb() and get rid
> > of these #ifdefs below? Since I believe it is quite uncommon not to
> > have this config enabled, we could simplify things by always using the
> > page_size in the pool, for example. And dito for the one in struct
> > xdp_umem. What do you think?
>
> I used #ifdef for `page_size` in the pool for maximum performance when
> huge pages are disabled. We could also not worry about optimizing this
> uncommon case though since the performance impact is very small.
> However, I don't find the #ifdefs excessive either.

Keep them to a minimum please since there are few of them in the
current code outside of some header files. And let us assume that
CONFIG_HUGETLB_PAGE is the common case.

> > > +static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, u32 page_size)
> > >  {
> > > -       u32 i;
> > > +       u32 stride = page_size >> PAGE_SHIFT; /* in order-0 pages */
> > > +       u32 i, j;
> > >
> > > -       for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> > > -               if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> > > -                       dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> > > -               else
> > > -                       dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> > > +       for (i = 0; i + stride < dma_map->dma_pages_cnt;) {
> > > +               if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + stride]) {
> > > +                       for (j = 0; j < stride; i++, j++)
> > > +                               dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> > > +               } else {
> > > +                       for (j = 0; j < stride; i++, j++)
> > > +                               dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> > > +               }
> >
> > Still somewhat too conservative :-). If your page size is large you
> > will waste a lot of the umem.  For the last page mark all the 4K
> > "pages" that cannot cross the end of the umem due to the max size of a
> > packet with the XSK_NEXT_PG_CONTIG_MASK bit. So you only need to add
> > one more for-loop here to mark this, and then adjust the last for-loop
> > below so it only marks the last bunch of 4K pages at the end of the
> > umem as not contiguous.
>
> I don't understand the issue. The XSK_NEXT_PG_CONTIG_MASK bit is only
> looked at if the descriptor actually crosses a page boundary. I don't
> think the current implementation wastes any UMEM.

I stand corrected. You do not waste any space, so please ignore.
