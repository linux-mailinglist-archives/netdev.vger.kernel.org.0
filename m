Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4BE54A1FB
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 00:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbiFMWPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 18:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiFMWPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 18:15:14 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C032C67D;
        Mon, 13 Jun 2022 15:15:13 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g25so13680855ejh.9;
        Mon, 13 Jun 2022 15:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+2PglEldv0HYHksy5djPq2g3MZD4lIsMqBUNoVjzkw=;
        b=Rce/Y7ilXJlidhIhVtwS7WAqUTuNY57Krrblz/fK0qZuLLmW/Co6Xbkh2Sr9za8ToF
         ukK+t8dbrTn736MKYqUYCn7CDHoIVMmf69soKwthY4na99xUcyQHxcR6qk7tFUxv8Owf
         UNqncORjMq/mZAPusiPCl7qFVwSaYB3SRVVuo3KAVZriLtMwS55hPW5rZMWMQ4ElY/1n
         Uvs60Gxhxg4ce9u1Ed8LQ5L61AITYuijMwUzHQd2khpEUgLZGZziGA4GT3JV0sY/WoYO
         hpJ6m/wxtD3GKTgt0ofjEWUVaIxH14WW6aRC1bi1Qwo1AitXAmYBnOg4fFPRPzL9QxOq
         EoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+2PglEldv0HYHksy5djPq2g3MZD4lIsMqBUNoVjzkw=;
        b=Nhb8atjAtD3Wa/IG445v87fDA6QNYfOfo3NxR+CZsEtbQ+8X0ypBrcKPhcfaAaKKT/
         fnzwZL6pbY1qa31VeYQu9CsnCZfs7rM13NlOxxFCdAIgtDZLk/J7J0TqkZbEdDiQpowA
         taD3Why28ZjuxXocawFn2GHC03R00S9UJgciBR5eqw+SHgO3dONf4ik5bS5C9v2v0FTi
         SH2nq3Ll5IvCcIo2SLjKrkiKI1GBsa+UksOhSJIExZIutR1vLsd6XGMtmN/m6lAHvfYi
         xW7Og/ht0LCbnH8JgDHGu7YnJG35J5JZcy+x9GrTxsRDZF2iAndGhkVaiEdpqEltJnwW
         ssQw==
X-Gm-Message-State: AOAM531TocahrQutNJBr9gbJvoi87lAKhyoetDmbNVXM84zn8Qkl8+1y
        ti57/5kvFTW4ByAVN2/xUs4W+LZDGtXeaXKi+y0=
X-Google-Smtp-Source: ABdhPJyhEOjKSdoSTzlCp0usTun9X0cG4MrMT6dkJfNubqK/TEJ2LOObaQwZUy+2st6iPeV4p2+natOk8MhtrBuyoxQ=
X-Received: by 2002:a17:906:449:b0:711:c975:cfb8 with SMTP id
 e9-20020a170906044900b00711c975cfb8mr1697453eja.58.1655158511985; Mon, 13 Jun
 2022 15:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1653600577.git.lorenzo@kernel.org> <20220611201117.euqca7rgn5wydlwk@macbook-pro-3.dhcp.thefacebook.com>
 <20220613161413.sowe7bv3da2nuqsg@apollo.legion>
In-Reply-To: <20220613161413.sowe7bv3da2nuqsg@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jun 2022 15:15:00 -0700
Message-ID: <CAADnVQKk9LPm=4OeosxLZCmv+_PnowPZdz9QP4f-H8Vd4HSLVw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/14] net: netfilter: add kfunc helper to
 update ct timeout
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 9:14 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sun, Jun 12, 2022 at 01:41:17AM IST, Alexei Starovoitov wrote:
> > On Thu, May 26, 2022 at 11:34:48PM +0200, Lorenzo Bianconi wrote:
> > > Changes since v3:
> > > - split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
> > >   bpf_ct_insert_entry
> > > - add verifier code to properly populate/configure ct entry
> > > - improve selftests
> >
> > Kumar, Lorenzo,
> >
> > are you planning on sending v5 ?
> > The patches 1-5 look good.
> > Patch 6 is questionable as Florian pointed out.
>
> Yes, it is almost there.
>
> > What is the motivation to allow writes into ct->status?
>
> It will only be allowed for ct from alloc function, after that ct = insert(ct)
> releases old one with new read only ct. I need to recheck once again with the
> code what other bits would cause problems on insert before I rework and reply.

I still don't understand why you want to allow writing after alloc.

> > The selftest doesn't do that anyway.
>
> Yes, it wasn't updated, we will do that in v5.
>
> > Patch 7 (acquire-release pairs) is too narrow.
> > The concept of a pair will not work well. There could be two acq funcs and one release.
>
> That is already handled (you define two pairs: acq1, rel and acq2, rel).
> There is also an example: bpf_ct_insert_entry -> bpf_ct_release,
> bpf_xdp_ct_lookup -> ct_release.

If we can represent that without all these additional btf_id sets
it would be much better.

> > Please think of some other mechanism. Maybe type based? BTF?
> > Or encode that info into type name? or some other way.
>
> Hmm, ok. I kinda dislike this solution too. The other idea that comes to mind is
> encapsulating nf_conn into another struct and returning pointer to that:
>
>         struct nf_conn_alloc {
>                 struct nf_conn ct;
>         };
>
>         struct nf_conn_alloc *bpf_xdp_ct_alloc(...);
>         struct nf_conn *bpf_ct_insert_entry(struct nf_conn_alloc *act, ...);
>
> Then nf_conn_alloc gets a different BTF ID, and hence the type can be matched in
> the prototype. Any opinions?

Yes. Or maybe typedef ?
typedef struct nf_conn nf_conn__alloc;
typedef struct nf_conn nf_conn__ro;

C will accept silent type casts from one type to another,
but BTF type checking can be strict?
Not sure. wrapping a struct works too, but extra '.ct' accessor
might be annoying? Unless you only use it with container_of().
I would prefer double or triple underscore to highlight a flavor.
struct nf_conn___init {...}
The main benefit, of course, is no need for extra btf_id sets.
Different types take care of correct arg passing.
In that sense typedef idea doesn't quite work,
since BTF checks with typedef would be unnecessarily strict
compared to regular C type checking rules. That difference
in behavior might bite us later.
So let's go with struct wrapping.
