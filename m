Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58616CB3E3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 06:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbfJDEZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 00:25:43 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39990 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387763AbfJDEZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 00:25:43 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so4583936edm.7
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 21:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8HMEu+jreVsWeHvWxr8+6LBYymdI3AZpPwxRBBoc8n8=;
        b=d6b/0rpMJO+d+itLygFJgJTBHKJzwoGFTllY8h18GXSW8rPW2B1GpntqvHfoHP+ybv
         zGZlCLAIkrS3YLKOQ+sjEsR3nF2hJSOSyygOGp3bgRh9IK7KvxkLSRkKTr9QYyosN+/l
         p3wf7ciIQqQki8RfT6ECNWwrbDOYp4xCx3ld4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8HMEu+jreVsWeHvWxr8+6LBYymdI3AZpPwxRBBoc8n8=;
        b=EEDp5beUWt5EhPPgJ1n3KnRYpx7Jrg9d2qlMFIx6zNS/857LeuKb40kZvc55U4JX6z
         YH9k6MLyC/8qLr+UtdEfDwwoBfzbSx2J//v8Nx6jQavBqqOoEblyF3jepPjg1hiiCc36
         ETHB9YKmqdfLp7YWMJeYJAVjCgKEbLTLPl8LVdx+iE5KCQQgFzieiwZ+MklFvpBQmSjJ
         NDpJ3Gtbb/WDSx3uHqBLuLWPsm9W+u9BS1aK4Yxk5q/qo74OQ9/e8abBO2lolLWLVDgX
         ESgPkH0uggVxz+BWxHA/L/CY3k+qI1C3n8PJpOJqc86A2BgCCEx+wRYTqXze1ExzRGnQ
         fdDA==
X-Gm-Message-State: APjAAAVpvNrUGKnd43Q2GEVhyjAR+HofPox549ae0YGfuBQG0whHo5Rj
        UN6+OATf7KKXM6lcLyIxMev2XqhDHUTJmZRF/qlz+Q==
X-Google-Smtp-Source: APXvYqxhNUKApwBuqe2LK32LP4LtVjdhy8QFB4LTlpJiakh2C7EeeK8fcs89TOM5fm0YlcJXWymDeD0PBmh2xmoavF8=
X-Received: by 2002:a17:906:9498:: with SMTP id t24mr10452898ejx.88.1570163139930;
 Thu, 03 Oct 2019 21:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191002084103.12138-1-idosch@idosch.org> <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com> <20191003125912.GA18156@splinter>
In-Reply-To: <20191003125912.GA18156@splinter>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 3 Oct 2019 21:25:28 -0700
Message-ID: <CAJieiUj9foz=P6tVXi99AXSxFUqN44kaidCKUuT4kemg_b5dGQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to routes
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 5:59 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Wed, Oct 02, 2019 at 08:58:52AM -0700, Roopa Prabhu wrote:
> > On Wed, Oct 2, 2019 at 1:41 AM Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > From: Ido Schimmel <idosch@mellanox.com>
> > >
> > > When performing L3 offload, routes and nexthops are usually programmed
> > > into two different tables in the underlying device. Therefore, the fact
> > > that a nexthop resides in hardware does not necessarily mean that all
> > > the associated routes also reside in hardware and vice-versa.
> > >
> > > While the kernel can signal to user space the presence of a nexthop in
> > > hardware (via 'RTNH_F_OFFLOAD'), it does not have a corresponding flag
> > > for routes. In addition, the fact that a route resides in hardware does
> > > not necessarily mean that the traffic is offloaded. For example,
> > > unreachable routes (i.e., 'RTN_UNREACHABLE') are programmed to trap
> > > packets to the CPU so that the kernel will be able to generate the
> > > appropriate ICMP error packet.
> > >
> > > This patch adds an "in hardware" indication to IPv4 routes, so that
> > > users will have better visibility into the offload process. In the
> > > future IPv6 will be extended with this indication as well.
> > >
> > > 'struct fib_alias' is extended with a new field that indicates if
> > > the route resides in hardware or not. Note that the new field is added
> > > in the 6 bytes hole and therefore the struct still fits in a single
> > > cache line [1].
> > >
> > > Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
> > > with the route's key in order to set / clear the "in hardware
> > > indication".
> > >
> > > The new indication is dumped to user space via a new flag (i.e.,
> > > 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
> > >
> >
> > nice series Ido.
>
> Thanks, Roopa. Forgot to copy you on this RFC. Will copy you on v1.

Thanks Ido.

>
> > why not call this RTM_F_OFFLOAD to keep it consistent with the nexthop
> > offload indication ?.
>
> I can call it RTM_F_OFFLOAD to be consistent with RTNH_F_OFFLOAD, but it
> should really be displayed as "in_hw" to the user which is why I
> preferred to use RTM_F_IN_HW.

ok, i missed that part. So you are trying to add a variant of hardware
offloaded routes.
In that case I prefer you keep the display string a direct translation
of the flag name.

>
> We probably need to document the semantics better, but as I see it
> "offload" is for functionality that we actually offload from the kernel.
> For example, prefix and gatewayed routes. We do not set the offload mark
> on host routes that are used to locally receive packets. We do mark them
> as offloaded if they are used to decap IP-in-IP or VXLAN traffic.
>
> Given the above, we do not have an easy way today to understand which
> routes actually reside in hardware and which are not. Having this
> information is very useful for debugging and testing (as evident by the
> last patch in the series).
>
> > But this again does not seem to be similar to the other request flags
> > like: RTM_F_FIB_MATCH
>
> Not sure I understand, similar in what way? Can you clarify?

ignore that...i was just trying to understand again why you are adding
it in rtm_flags with RTM_F_
instead of RTNH_F. I think your below point clarifies it.

>
> > (so far i think all the RTNH_F_* flags are used on routes too IIRC
> > (see iproute2: print_rt_flags)
> > RTNH_F_DEAD seems to fall in this category)
>
> The 'rtm_flags' field in the ancillary header is actually divided
> between RTNH_F_ and RTM_F_ flags. When the route has a single nexthop
> the RTNH_F_ flags are communicated to user space via this field.
>
> Since I'm interested in letting user space know if the route itself
> resides in hardware (not the nexthop) it seemed logical to me to use
> RTM_F_ and encode it in 'rtm_flags'.

ok understood. so you really are introducing a variant of OFFLOAD flag.
and yes, it will need to be documented correctly..the names can lead
to confusion.
....maybe having it RTM_F_OFFLOAD_IN_HW would keep them related by
name... up to you.

>
> Shana tova (have a good year)!

you too!

>
> >
> >
> > > [1]
> > > struct fib_alias {
> > >         struct hlist_node  fa_list;                      /*     0    16 */
> > >         struct fib_info *          fa_info;              /*    16     8 */
> > >         u8                         fa_tos;               /*    24     1 */
> > >         u8                         fa_type;              /*    25     1 */
> > >         u8                         fa_state;             /*    26     1 */
> > >         u8                         fa_slen;              /*    27     1 */
> > >         u32                        tb_id;                /*    28     4 */
> > >         s16                        fa_default;           /*    32     2 */
> > >         u8                         in_hw:1;              /*    34: 0  1 */
> > >         u8                         unused:7;             /*    34: 1  1 */
> > >
> > >         /* XXX 5 bytes hole, try to pack */
> > >
> > >         struct callback_head rcu __attribute__((__aligned__(8))); /*    40    16 */
> > >
> > >         /* size: 56, cachelines: 1, members: 11 */
> > >         /* sum members: 50, holes: 1, sum holes: 5 */
> > >         /* sum bitfield members: 8 bits (1 bytes) */
> > >         /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
> > >         /* last cacheline: 56 bytes */
> > > } __attribute__((__aligned__(8)));
> > >
> > > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > > ---
> > >  include/net/ip_fib.h           |  5 +++
> > >  include/uapi/linux/rtnetlink.h |  1 +
> > >  net/ipv4/fib_lookup.h          |  4 ++
> > >  net/ipv4/fib_semantics.c       |  4 ++
> > >  net/ipv4/fib_trie.c            | 71 ++++++++++++++++++++++++++++++++++
> > >  5 files changed, 85 insertions(+)
> > >
> > > diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> > > index 52b2406a5dfc..019a138a79f4 100644
> > > --- a/include/net/ip_fib.h
> > > +++ b/include/net/ip_fib.h
> > > @@ -454,6 +454,11 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *fc_encap,
> > >  void fib_nh_common_release(struct fib_nh_common *nhc);
> > >
> > >  /* Exported by fib_trie.c */
> > > +void fib_alias_in_hw_set(struct net *net, u32 dst, int dst_len,
> > > +                        const struct fib_info *fi, u8 tos, u8 type, u32 tb_id);
> > > +void fib_alias_in_hw_clear(struct net *net, u32 dst, int dst_len,
> > > +                          const struct fib_info *fi, u8 tos, u8 type,
> > > +                          u32 tb_id);
> > >  void fib_trie_init(void);
> > >  struct fib_table *fib_trie_table(u32 id, struct fib_table *alias);
> > >
> > > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > > index 1418a8362bb7..e5a104f5ce35 100644
> > > --- a/include/uapi/linux/rtnetlink.h
> > > +++ b/include/uapi/linux/rtnetlink.h
> > > @@ -309,6 +309,7 @@ enum rt_scope_t {
> > >  #define RTM_F_PREFIX           0x800   /* Prefix addresses             */
> > >  #define RTM_F_LOOKUP_TABLE     0x1000  /* set rtm_table to FIB lookup result */
> > >  #define RTM_F_FIB_MATCH                0x2000  /* return full fib lookup match */
> > > +#define RTM_F_IN_HW            0x4000  /* route is in hardware */
> > >
> > >  /* Reserved table identifiers */
> > >
> > > diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
> > > index b34594a9965f..65a69a863499 100644
> > > --- a/net/ipv4/fib_lookup.h
> > > +++ b/net/ipv4/fib_lookup.h
> > > @@ -16,6 +16,8 @@ struct fib_alias {
> > >         u8                      fa_slen;
> > >         u32                     tb_id;
> > >         s16                     fa_default;
> > > +       u8                      in_hw:1,
> > > +                               unused:7;
> > >         struct rcu_head         rcu;
> > >  };
> > >
> > > @@ -28,6 +30,8 @@ struct fib_rt_info {
> > >         int                     dst_len;
> > >         u8                      tos;
> > >         u8                      type;
> > > +       u8                      in_hw:1,
> > > +                               unused:7;
> > >  };
> > >
> > >  /* Dont write on fa_state unless needed, to keep it shared on all cpus */
> > > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > > index 3c9d47804d93..94f201d44844 100644
> > > --- a/net/ipv4/fib_semantics.c
> > > +++ b/net/ipv4/fib_semantics.c
> > > @@ -519,6 +519,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
> > >         fri.dst_len = dst_len;
> > >         fri.tos = fa->fa_tos;
> > >         fri.type = fa->fa_type;
> > > +       fri.in_hw = fa->in_hw;
> > >         err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
> > >         if (err < 0) {
> > >                 /* -EMSGSIZE implies BUG in fib_nlmsg_size() */
> > > @@ -1801,6 +1802,9 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
> > >                         goto nla_put_failure;
> > >         }
> > >
> > > +       if (fri->in_hw)
> > > +               rtm->rtm_flags |= RTM_F_IN_HW;
> > > +
> > >         nlmsg_end(skb, nlh);
> > >         return 0;
> > >
> > > diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> > > index 646542de83ca..e3486bde6c5a 100644
> > > --- a/net/ipv4/fib_trie.c
> > > +++ b/net/ipv4/fib_trie.c
> > > @@ -1028,6 +1028,74 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
> > >         return NULL;
> > >  }
> > >
> > > +static struct fib_alias *
> > > +fib_find_matching_alias(struct net *net, u32 dst, int dst_len,
> > > +                       const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
> > > +{
> > > +       u8 slen = KEYLENGTH - dst_len;
> > > +       struct key_vector *l, *tp;
> > > +       struct fib_table *tb;
> > > +       struct fib_alias *fa;
> > > +       struct trie *t;
> > > +
> > > +       tb = fib_get_table(net, tb_id);
> > > +       if (!tb)
> > > +               return NULL;
> > > +
> > > +       t = (struct trie *)tb->tb_data;
> > > +       l = fib_find_node(t, &tp, dst);
> > > +       if (!l)
> > > +               return NULL;
> > > +
> > > +       hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
> > > +               if (fa->fa_slen == slen && fa->tb_id == tb_id &&
> > > +                   fa->fa_tos == tos && fa->fa_info == fi &&
> > > +                   fa->fa_type == type)
> > > +                       return fa;
> > > +       }
> > > +
> > > +       return NULL;
> > > +}
> > > +
> > > +void fib_alias_in_hw_set(struct net *net, u32 dst, int dst_len,
> > > +                        const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
> > > +{
> > > +       struct fib_alias *fa_match;
> > > +
> > > +       rcu_read_lock();
> > > +
> > > +       fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
> > > +                                          tb_id);
> > > +       if (!fa_match)
> > > +               goto out;
> > > +
> > > +       fa_match->in_hw = 1;
> > > +
> > > +out:
> > > +       rcu_read_unlock();
> > > +}
> > > +EXPORT_SYMBOL_GPL(fib_alias_in_hw_set);
> > > +
> > > +void fib_alias_in_hw_clear(struct net *net, u32 dst, int dst_len,
> > > +                          const struct fib_info *fi, u8 tos, u8 type,
> > > +                          u32 tb_id)
> > > +{
> > > +       struct fib_alias *fa_match;
> > > +
> > > +       rcu_read_lock();
> > > +
> > > +       fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
> > > +                                          tb_id);
> > > +       if (!fa_match)
> > > +               goto out;
> > > +
> > > +       fa_match->in_hw = 0;
> > > +
> > > +out:
> > > +       rcu_read_unlock();
> > > +}
> > > +EXPORT_SYMBOL_GPL(fib_alias_in_hw_clear);
> > > +
> > >  static void trie_rebalance(struct trie *t, struct key_vector *tn)
> > >  {
> > >         while (!IS_TRIE(tn))
> > > @@ -1236,6 +1304,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
> > >                         new_fa->fa_slen = fa->fa_slen;
> > >                         new_fa->tb_id = tb->tb_id;
> > >                         new_fa->fa_default = -1;
> > > +                       new_fa->in_hw = 0;
> > >
> > >                         hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
> > >
> > > @@ -1294,6 +1363,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
> > >         new_fa->fa_slen = slen;
> > >         new_fa->tb_id = tb->tb_id;
> > >         new_fa->fa_default = -1;
> > > +       new_fa->in_hw = 0;
> > >
> > >         /* Insert new entry to the list. */
> > >         err = fib_insert_alias(t, tp, l, new_fa, fa, key);
> > > @@ -2218,6 +2288,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
> > >                                 fri.dst_len = KEYLENGTH - fa->fa_slen;
> > >                                 fri.tos = fa->fa_tos;
> > >                                 fri.type = fa->fa_type;
> > > +                               fri.in_hw = fa->in_hw;
> > >                                 err = fib_dump_info(skb,
> > >                                                     NETLINK_CB(cb->skb).portid,
> > >                                                     cb->nlh->nlmsg_seq,
> > > --
> > > 2.21.0
> > >
