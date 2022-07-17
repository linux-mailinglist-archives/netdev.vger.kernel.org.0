Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F865777CE
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 20:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiGQSlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 14:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGQSlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 14:41:49 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38925BC36;
        Sun, 17 Jul 2022 11:41:48 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c17so4059505ilq.5;
        Sun, 17 Jul 2022 11:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BXzSWJuR+HatQtKSZsbVI8HehWW99ZvHcPiK1j2ZXgY=;
        b=a4sxj+YijTJbBgW0ouqBSoIi50oKKwJSmMeUBpp9t/ZDDWSSX5oeucLqGLA4PSlsI8
         jzTxDdMKiSm4sV6l/nsABZNyy0RbYATrMKhVGEJzrT7U+O2lhqeTlRDzgU6hFsl51kIV
         K22zLKXS7L0pd2Q+yyU+QvHCu/LeKmLvIxATO+8a+0g6L8aOPy9rK+KIG5Hh3Kry3fGl
         FvlomLMewxZ1cZEo9bazEyAO5OUXSdfKklkSqFOz1jiAugZa9PdQcH1QRylCwdzHyd/N
         YEk9uYieiuj2zdnylbSNOynr8+ggibLvpCZdAvpNLMz02LCrCWJ4tSaPq/0ZwK24ZEWh
         cDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BXzSWJuR+HatQtKSZsbVI8HehWW99ZvHcPiK1j2ZXgY=;
        b=ZcFFixRNw7dJbrpy3/hN5bKCZN0BZL++ct66e6NGiTdGC4SqU6ZK0ZnNX86BD+ue1T
         7rkKU+dH2pQLm9Amfvk+Mndr4i6mmNcxywo28u68XOLRpFu1GKNFjt91TEStP8MJlLae
         F/B3yB0s0kETT52jj11a/8yFRJsS+PZIwRdCCHPZkuA/VkD3IMwFq8duLLYDGhoucOkE
         z/1cmTQsOeI+a9+hKrtugBnunt2Ds7+MWXqnN9eivGi7UlsZ1oCSP3jeMf2cPR6aeuiW
         l+VGM0jO36HyGG+ssmwGgwLcEAg4WTU082ShoaYjdSLCgM2W/OcozO8GzkCWOFzO1MWV
         Z7LA==
X-Gm-Message-State: AJIora9hspWGruo2LyISdT1B6vSAybBL9sdMg8tnAIxqZnQ2ZjPeAuEO
        8Xn6KaiIwOxczwqJunzG73asc9BR3Uffe5UIa/8=
X-Google-Smtp-Source: AGRyM1tWPVnx4gm+70xT98CKsUMEweZMk8f/+URq8xtgNBkN3L0KGX6/fgyL0mJBUa5Rz8uTEHT/c24J/ma4br8YMgY=
X-Received: by 2002:a05:6e02:1c08:b0:2dc:bd57:f80a with SMTP id
 l8-20020a056e021c0800b002dcbd57f80amr6964909ilh.68.1658083307408; Sun, 17 Jul
 2022 11:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk> <YtRSOaCtujBfzHUS@pop-os.localdomain>
In-Reply-To: <YtRSOaCtujBfzHUS@pop-os.localdomain>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sun, 17 Jul 2022 20:41:10 +0200
Message-ID: <CAP01T77ov2ARuR+on+D-8cgYSsndF9JKTuYMT9dc1Qu8wuG5sQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling capabilities
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jul 2022 at 20:17, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Jul 13, 2022 at 11:52:07PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> > > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > >>
> > >> Packet forwarding is an important use case for XDP, which offers
> > >> significant performance improvements compared to forwarding using th=
e
> > >> regular networking stack. However, XDP currently offers no mechanism=
 to
> > >> delay, queue or schedule packets, which limits the practical uses fo=
r
> > >> XDP-based forwarding to those where the capacity of input and output=
 links
> > >> always match each other (i.e., no rate transitions or many-to-one
> > >> forwarding). It also prevents an XDP-based router from doing any kin=
d of
> > >> traffic shaping or reordering to enforce policy.
> > >>
> > >> This series represents a first RFC of our attempt to remedy this lac=
k. The
> > >> code in these patches is functional, but needs additional testing an=
d
> > >> polishing before being considered for merging. I'm posting it here a=
s an
> > >> RFC to get some early feedback on the API and overall design of the
> > >> feature.
> > >>
> > >> DESIGN
> > >>
> > >> The design consists of three components: A new map type for storing =
XDP
> > >> frames, a new 'dequeue' program type that will run in the TX softirq=
 to
> > >> provide the stack with packets to transmit, and a set of helpers to =
dequeue
> > >> packets from the map, optionally drop them, and to schedule an inter=
face
> > >> for transmission.
> > >>
> > >> The new map type is modelled on the PIFO data structure proposed in =
the
> > >> literature[0][1]. It represents a priority queue where packets can b=
e
> > >> enqueued in any priority, but is always dequeued from the head. From=
 the
> > >> XDP side, the map is simply used as a target for the bpf_redirect_ma=
p()
> > >> helper, where the target index is the desired priority.
> > >
> > > I have the same question I asked on the series from Cong:
> > > Any considerations for existing carousel/edt-like models?
> >
> > Well, the reason for the addition in patch 5 (continuously increasing
> > priorities) is exactly to be able to implement EDT-like behaviour, wher=
e
> > the priority is used as time units to clock out packets.
>
> Are you sure? I seriouly doubt your patch can do this at all...
>
> Since your patch relies on bpf_map_push_elem(), which has no room for
> 'key' hence you reuse 'flags' but you also reserve 4 bits there... How
> could tstamp be packed with 4 reserved bits??
>
> To answer Stanislav's question, this is how my code could handle EDT:
>
> // BPF_CALL_3(bpf_skb_map_push, struct bpf_map *, map, struct sk_buff *, =
skb, u64, key)
> skb->tstamp =3D XXX;
> bpf_skb_map_push(map, skb, skb->tstamp);

It is also possible here, if we could not push into the map with a
certain key it wouldn't be a PIFO.
Please look at patch 16/17 for an example (test_xdp_pifo.c), it's just
that the interface is different (bpf_redirect_map),
the key has been expanded to 64 bits to accommodate such use cases. It
is also possible in a future version of the patch to amortize the cost
of taking the lock for each enqueue by doing batching, similar to what
cpumap/devmap implementations do.

>
> (Please refer another reply from me for how to get the min when poping,
> which is essentially just a popular interview coding problem.)
>
> Actually, if we look into the in-kernel EDT implementation (net/sched/sch=
_etf.c),
> it is also based on rbtree rather than PIFO. ;-)
>
> Thanks.
