Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB59352C60F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiERWPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiERWPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:15:11 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA542044F0;
        Wed, 18 May 2022 15:15:10 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id k8so2989368qvm.9;
        Wed, 18 May 2022 15:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enoN8YamLTZQDCPT/IioiS3FR9i+0CD9q8GbGOVgy2E=;
        b=Y0dofW+vrrsSEtS+FB/J+Vo3e4uVyjyNqG9EN4QefQQpXySwr2AaCWGCi3u8DFn2rq
         FR9eRwL/AsDmizJ1r7aYsLYsX2pT8zeO7JjhCprp6WMw/DIcbGdIVzNFdaD48i5rE8K8
         YcAp2/J3vDkG7VFhveCxnOKiQt94UNvGIi7uBf7BYGTVocyyABpmCtznjClRnCNYBoQI
         ogtfog6D9xGDdpe8D0aKhpljgqTypH+Xjy9j9y/fj1YyKmtAV52zjTBkYS9fxDI5yvk9
         TPuZJnVflO7+AQPYTPOX9+sYG04oVeRJA05behpQTI4BK/IAuQzARIIgJyO7j/KPLLzK
         N7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enoN8YamLTZQDCPT/IioiS3FR9i+0CD9q8GbGOVgy2E=;
        b=VAUQ0ntsi5TSPPfg85Ml3Wem6aFwIyRogjcFD0XydkuLP6QYPuxBWADL/G2NNH5cq7
         R0Lc2BjmrRK6RJlbvhOxH83Kb2f/Re3Xo9ml6jX8mOwhotrTkqnHdq+9EennYXd8ykIq
         FJ9o/jTUbb1/+J7WzxwBDl5J6HeCb99XR/B/p/HfMjGW8Sn8ndjnsx8Pn78vujxSs5Ve
         QjfVawPalekNlGEAIaLzxJ68X4G4MIAMXl5L6ruXL/wYxhRY9R12GA+CFkH20pCMPFok
         +b7vQjzZfe5RHeehuHfOjI+vx78MItE+NIb+6GicUmXseLiY22YloxLLIgRPhCG93FOn
         vbIg==
X-Gm-Message-State: AOAM530Pcr4jHMoQ0fmWw6czmURoJPJPmQdw05eslzX2TKq5wfeK2GXv
        fp8Iw6h4Ivz0NpOtPu114MkeEMbdckL80VF2QFsMaDu9
X-Google-Smtp-Source: ABdhPJxwW6aEFTfMhNTC0Qct8xHwec+vq6XWgLPrQqWwnegoSdKR5o9OuNKRUCwM0jEV9wFurPPCPUna5HaWBgwPv+g=
X-Received: by 2002:ad4:5bea:0:b0:45b:1f7:eee7 with SMTP id
 k10-20020ad45bea000000b0045b01f7eee7mr1859026qvc.11.1652912109171; Wed, 18
 May 2022 15:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652870182.git.lorenzo@kernel.org> <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
 <87y1yy8t6j.fsf@toke.dk> <YoVgZ8OHlF/OpgHq@lore-desk>
In-Reply-To: <YoVgZ8OHlF/OpgHq@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 May 2022 15:14:58 -0700
Message-ID: <CAADnVQ+6-cywf0StZ_K0nKSSdXJsZ4S_ZBhGZPHDmKtaL3k9-g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add a
 new ct entry
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Wed, May 18, 2022 at 2:09 PM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > Lorenzo Bianconi <lorenzo@kernel.org> writes:
> >
> > > Introduce bpf_xdp_ct_add and bpf_skb_ct_add kfunc helpers in order to
> > > add a new entry to ct map from an ebpf program.
> > > Introduce bpf_nf_ct_tuple_parse utility routine.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  net/netfilter/nf_conntrack_bpf.c | 212 +++++++++++++++++++++++++++----
> > >  1 file changed, 189 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> > > index a9271418db88..3d31b602fdf1 100644
> > > --- a/net/netfilter/nf_conntrack_bpf.c
> > > +++ b/net/netfilter/nf_conntrack_bpf.c
> > > @@ -55,41 +55,114 @@ enum {
> > >     NF_BPF_CT_OPTS_SZ = 12,
> > >  };
> > >
> > > -static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
> > > -                                     struct bpf_sock_tuple *bpf_tuple,
> > > -                                     u32 tuple_len, u8 protonum,
> > > -                                     s32 netns_id, u8 *dir)
> > > +static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
> > > +                            u32 tuple_len, u8 protonum, u8 dir,
> > > +                            struct nf_conntrack_tuple *tuple)
> > >  {
> > > -   struct nf_conntrack_tuple_hash *hash;
> > > -   struct nf_conntrack_tuple tuple;
> > > -   struct nf_conn *ct;
> > > +   union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
> > > +   union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
> > > +   union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
> > > +                                             : &tuple->src.u;
> > > +   union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
> > > +                                             : (void *)&tuple->dst.u;
> > >
> > >     if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
> > > -           return ERR_PTR(-EPROTO);
> > > -   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
> > > -           return ERR_PTR(-EINVAL);
> > > +           return -EPROTO;
> > > +
> > > +   memset(tuple, 0, sizeof(*tuple));
> > >
> > > -   memset(&tuple, 0, sizeof(tuple));
> > >     switch (tuple_len) {
> > >     case sizeof(bpf_tuple->ipv4):
> > > -           tuple.src.l3num = AF_INET;
> > > -           tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
> > > -           tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
> > > -           tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
> > > -           tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
> > > +           tuple->src.l3num = AF_INET;
> > > +           src->ip = bpf_tuple->ipv4.saddr;
> > > +           sport->tcp.port = bpf_tuple->ipv4.sport;
> > > +           dst->ip = bpf_tuple->ipv4.daddr;
> > > +           dport->tcp.port = bpf_tuple->ipv4.dport;
> > >             break;
> > >     case sizeof(bpf_tuple->ipv6):
> > > -           tuple.src.l3num = AF_INET6;
> > > -           memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
> > > -           tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
> > > -           memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
> > > -           tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
> > > +           tuple->src.l3num = AF_INET6;
> > > +           memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
> > > +           sport->tcp.port = bpf_tuple->ipv6.sport;
> > > +           memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
> > > +           dport->tcp.port = bpf_tuple->ipv6.dport;
> > >             break;
> > >     default:
> > > -           return ERR_PTR(-EAFNOSUPPORT);
> > > +           return -EAFNOSUPPORT;
> > >     }
> > > +   tuple->dst.protonum = protonum;
> > > +   tuple->dst.dir = dir;
> > > +
> > > +   return 0;
> > > +}
> > >
> > > -   tuple.dst.protonum = protonum;
> > > +struct nf_conn *
> > > +__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
> > > +                   u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
> > > +{
> > > +   struct nf_conntrack_tuple otuple, rtuple;
> > > +   struct nf_conn *ct;
> > > +   int err;
> > > +
> > > +   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
> > > +           return ERR_PTR(-EINVAL);
> > > +
> > > +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
> > > +                               IP_CT_DIR_ORIGINAL, &otuple);
> > > +   if (err < 0)
> > > +           return ERR_PTR(err);
> > > +
> > > +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
> > > +                               IP_CT_DIR_REPLY, &rtuple);
> > > +   if (err < 0)
> > > +           return ERR_PTR(err);
> > > +
> > > +   if (netns_id >= 0) {
> > > +           net = get_net_ns_by_id(net, netns_id);
> > > +           if (unlikely(!net))
> > > +                   return ERR_PTR(-ENONET);
> > > +   }
> > > +
> > > +   ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
> > > +                           GFP_ATOMIC);
> > > +   if (IS_ERR(ct))
> > > +           goto out;
> > > +
> > > +   ct->timeout = timeout * HZ + jiffies;
> > > +   ct->status |= IPS_CONFIRMED;
> > > +
> > > +   memset(&ct->proto, 0, sizeof(ct->proto));
> > > +   if (protonum == IPPROTO_TCP)
> > > +           ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> >
> > Hmm, isn't it a bit limiting to hard-code this to ESTABLISHED
> > connections? Presumably for TCP you'd want to use this when you see a
> > SYN and then rely on conntrack to help with the subsequent state
> > tracking for when the SYN-ACK comes back? What's the usecase for
> > creating an entry in ESTABLISHED state, exactly?
>
> I guess we can even add a parameter and pass the state from the caller.
> I was not sure if it is mandatory.

It's probably cleaner and more flexible to split
_alloc and _insert into two kfuncs and let bpf
prog populate ct directly.
