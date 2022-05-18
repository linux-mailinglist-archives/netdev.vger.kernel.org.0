Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C242652C677
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiERWmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiERWmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:42:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F61B14D782;
        Wed, 18 May 2022 15:42:43 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l14so3464624pjk.2;
        Wed, 18 May 2022 15:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/5HbRUzUeishq4OoRNF2vTxxeTguE/szejcn40/RQ8=;
        b=XL6GlW8tbi15ldh/hhco82zJ+xLlWJgXXEKw36mepVErwbWRXrPknk4m4+QR03LSQF
         OcvYbg90vkXwmL0VMKX9siCStdsl0e55o/N1Nye5JaeGwPPiUGGxJzcRQYisRWAfgfe7
         OP7JBxmRa+Qx3XfaNe1Ndv8JAYqqg2RYcYXegTYuGIM4yI8nR1DY+aRQKYD4LJ8mUoKu
         kzSJvQaOR0Q0IzpJ9byM7LnKXtALM31Jr9+jDNTzq3ByT6SPzSxOPn3i7kxU+6vZbCeq
         +C5i7ojt+z0/45D7BVISXEJ0hx5D67qwIpuinbOairOBDM86tHouDVHlcDRgzICalbaZ
         jyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/5HbRUzUeishq4OoRNF2vTxxeTguE/szejcn40/RQ8=;
        b=Zgtt5pdeLwC7MfF0nplNiwR5cCCoGaPR1QaTiQlppfJUdzEbH8RBDMd1EA1IjpAvqj
         hRmwyvhRswAFkYmm7ZUa6SYP/GM5fSG3MdVUmnZz7uvTR0Pe/wKqbDiWdPzhmhYCrxdh
         NcHl80T7st7rvg1HSfAoxmX0Yn4pWxC2DOQ9Y057qIpR+HV+yMN4VHG+CWWkcp2Zoxkd
         cDxii4rZSJRbyHXf6bVzpnLVaMsS6I7jfJhCDCAnSWNfJxrJxhbyxnFMdoIy9HUetSsQ
         9fJwZTubw4GhBwSfcBgBqczlNIXEtndbXxYwFuNIL7NBlNG3O9gnHbjs+e7Dw6tGOqaJ
         OhTw==
X-Gm-Message-State: AOAM530uuLJg5965r1NZCQPpTDfi3k2KOh2XWioEhkDpyTuu4tB1WJmY
        WciVnJxw5NZhfFy5prPX1cU=
X-Google-Smtp-Source: ABdhPJxqrql2Mi72Vgj+Hv9WaAqmjbILCqjPcNYNfKcmZqvZIxkPzhuq/7QbRMUBgSqtHkrhFoa5qQ==
X-Received: by 2002:a17:90b:4d90:b0:1dc:c03e:3a39 with SMTP id oj16-20020a17090b4d9000b001dcc03e3a39mr2317650pjb.116.1652913762949;
        Wed, 18 May 2022 15:42:42 -0700 (PDT)
Received: from localhost ([157.51.69.231])
        by smtp.gmail.com with ESMTPSA id k11-20020aa788cb000000b0050dc76281c7sm2486111pff.161.2022.05.18.15.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 15:42:42 -0700 (PDT)
Date:   Thu, 19 May 2022 04:13:30 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
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
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add
 a new ct entry
Message-ID: <20220518224330.omsokbbhqoe5mc3v@apollo.legion>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
 <87y1yy8t6j.fsf@toke.dk>
 <YoVgZ8OHlF/OpgHq@lore-desk>
 <CAADnVQ+6-cywf0StZ_K0nKSSdXJsZ4S_ZBhGZPHDmKtaL3k9-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+6-cywf0StZ_K0nKSSdXJsZ4S_ZBhGZPHDmKtaL3k9-g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 03:44:58AM IST, Alexei Starovoitov wrote:
> On Wed, May 18, 2022 at 2:09 PM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > > Lorenzo Bianconi <lorenzo@kernel.org> writes:
> > >
> > > > Introduce bpf_xdp_ct_add and bpf_skb_ct_add kfunc helpers in order to
> > > > add a new entry to ct map from an ebpf program.
> > > > Introduce bpf_nf_ct_tuple_parse utility routine.
> > > >
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  net/netfilter/nf_conntrack_bpf.c | 212 +++++++++++++++++++++++++++----
> > > >  1 file changed, 189 insertions(+), 23 deletions(-)
> > > >
> > > > diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> > > > index a9271418db88..3d31b602fdf1 100644
> > > > --- a/net/netfilter/nf_conntrack_bpf.c
> > > > +++ b/net/netfilter/nf_conntrack_bpf.c
> > > > @@ -55,41 +55,114 @@ enum {
> > > >     NF_BPF_CT_OPTS_SZ = 12,
> > > >  };
> > > >
> > > > -static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
> > > > -                                     struct bpf_sock_tuple *bpf_tuple,
> > > > -                                     u32 tuple_len, u8 protonum,
> > > > -                                     s32 netns_id, u8 *dir)
> > > > +static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
> > > > +                            u32 tuple_len, u8 protonum, u8 dir,
> > > > +                            struct nf_conntrack_tuple *tuple)
> > > >  {
> > > > -   struct nf_conntrack_tuple_hash *hash;
> > > > -   struct nf_conntrack_tuple tuple;
> > > > -   struct nf_conn *ct;
> > > > +   union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
> > > > +   union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
> > > > +   union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
> > > > +                                             : &tuple->src.u;
> > > > +   union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
> > > > +                                             : (void *)&tuple->dst.u;
> > > >
> > > >     if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
> > > > -           return ERR_PTR(-EPROTO);
> > > > -   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
> > > > -           return ERR_PTR(-EINVAL);
> > > > +           return -EPROTO;
> > > > +
> > > > +   memset(tuple, 0, sizeof(*tuple));
> > > >
> > > > -   memset(&tuple, 0, sizeof(tuple));
> > > >     switch (tuple_len) {
> > > >     case sizeof(bpf_tuple->ipv4):
> > > > -           tuple.src.l3num = AF_INET;
> > > > -           tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
> > > > -           tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
> > > > -           tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
> > > > -           tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
> > > > +           tuple->src.l3num = AF_INET;
> > > > +           src->ip = bpf_tuple->ipv4.saddr;
> > > > +           sport->tcp.port = bpf_tuple->ipv4.sport;
> > > > +           dst->ip = bpf_tuple->ipv4.daddr;
> > > > +           dport->tcp.port = bpf_tuple->ipv4.dport;
> > > >             break;
> > > >     case sizeof(bpf_tuple->ipv6):
> > > > -           tuple.src.l3num = AF_INET6;
> > > > -           memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
> > > > -           tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
> > > > -           memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
> > > > -           tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
> > > > +           tuple->src.l3num = AF_INET6;
> > > > +           memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
> > > > +           sport->tcp.port = bpf_tuple->ipv6.sport;
> > > > +           memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
> > > > +           dport->tcp.port = bpf_tuple->ipv6.dport;
> > > >             break;
> > > >     default:
> > > > -           return ERR_PTR(-EAFNOSUPPORT);
> > > > +           return -EAFNOSUPPORT;
> > > >     }
> > > > +   tuple->dst.protonum = protonum;
> > > > +   tuple->dst.dir = dir;
> > > > +
> > > > +   return 0;
> > > > +}
> > > >
> > > > -   tuple.dst.protonum = protonum;
> > > > +struct nf_conn *
> > > > +__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
> > > > +                   u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
> > > > +{
> > > > +   struct nf_conntrack_tuple otuple, rtuple;
> > > > +   struct nf_conn *ct;
> > > > +   int err;
> > > > +
> > > > +   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
> > > > +           return ERR_PTR(-EINVAL);
> > > > +
> > > > +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
> > > > +                               IP_CT_DIR_ORIGINAL, &otuple);
> > > > +   if (err < 0)
> > > > +           return ERR_PTR(err);
> > > > +
> > > > +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
> > > > +                               IP_CT_DIR_REPLY, &rtuple);
> > > > +   if (err < 0)
> > > > +           return ERR_PTR(err);
> > > > +
> > > > +   if (netns_id >= 0) {
> > > > +           net = get_net_ns_by_id(net, netns_id);
> > > > +           if (unlikely(!net))
> > > > +                   return ERR_PTR(-ENONET);
> > > > +   }
> > > > +
> > > > +   ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
> > > > +                           GFP_ATOMIC);
> > > > +   if (IS_ERR(ct))
> > > > +           goto out;
> > > > +
> > > > +   ct->timeout = timeout * HZ + jiffies;
> > > > +   ct->status |= IPS_CONFIRMED;
> > > > +
> > > > +   memset(&ct->proto, 0, sizeof(ct->proto));
> > > > +   if (protonum == IPPROTO_TCP)
> > > > +           ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> > >
> > > Hmm, isn't it a bit limiting to hard-code this to ESTABLISHED
> > > connections? Presumably for TCP you'd want to use this when you see a
> > > SYN and then rely on conntrack to help with the subsequent state
> > > tracking for when the SYN-ACK comes back? What's the usecase for
> > > creating an entry in ESTABLISHED state, exactly?
> >
> > I guess we can even add a parameter and pass the state from the caller.
> > I was not sure if it is mandatory.
>
> It's probably cleaner and more flexible to split
> _alloc and _insert into two kfuncs and let bpf
> prog populate ct directly.

Right, so we can just whitelist a few fields and allow assignments into those.
One small problem is that we should probably only permit this for nf_conn
PTR_TO_BTF_ID obtained from _alloc, and make it rdonly on _insert.

We can do the rw->ro conversion by taking in ref from alloc, and releasing on
_insert, then returning ref from _insert.

For the other part, either return a different shadow PTR_TO_BTF_ID with only the
fields that can be set, convert insns for it, and then on insert return the
rdonly PTR_TO_BTF_ID of struct nf_conn, or otherwise store the source func in
the per-register state and use that to deny BPF_WRITE for normal nf_conn.
Thoughts?

--
Kartikeya
