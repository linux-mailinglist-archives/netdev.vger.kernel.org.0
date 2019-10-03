Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1615C9EF3
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 14:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbfJCM7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 08:59:21 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58975 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbfJCM7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 08:59:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9918321C7D;
        Thu,  3 Oct 2019 08:59:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 08:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ky4p9S
        OCdTDAUMD6dKltyj8Vo7qIooCkdsV5lvtGE/4=; b=X8r6JvFxGIX/Rt/BKkM1yl
        TFDzSkEFXgHQ4YmYJ5tx4swYUz9QDlcjlomL3Pbwkw5epPtyPLep7IrhTGz6EoY7
        hz3fk7BXmlk0vgHQTBuBI+NNs3Nw469oSx94lb9CDDljGWS7u4g/KJYseL2r/bME
        FNgszhjLll6taCFeMzUlaR0k4iICLwPvHyMkYZyD5cqY54x/sMSs/2cHQSpNWDQD
        oLAO6AIut9UCb2b7pwTeLlYsWaEmZW57d9xm/yyLaFlE9vaDNcdoSquwvdRatjtw
        MDZlrTZcixeMGsX6o/jQ0P/o1bRl7tNXsqcmxQQnpaVp90XbjAdEoVHSWBfg8h7g
        ==
X-ME-Sender: <xms:pvCVXZvnBfXz1nTygHmXi7zypEwn3wQ66soyLAleYafi39QhNGHUqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:pvCVXdPvqOYZEgWarqELYRDLwmivQCXVhWzwIS-Uvfob6D7ikhgtWg>
    <xmx:pvCVXbp-jBq6rm6Bqrn3GcWCfsNQrsjkt8jKOgdWleFPc3KB0Y-fBw>
    <xmx:pvCVXW9qbUOAs3gQx0uteITwA4smO8-KPHi8g-S9niEGBF36alA-YQ>
    <xmx:pvCVXcKGPfrWYqzZAdkCM0265lx210S-39AE0pb-FBdXfsMbjpvV4A>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 47764D60062;
        Thu,  3 Oct 2019 08:59:15 -0400 (EDT)
Date:   Thu, 3 Oct 2019 15:59:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
Message-ID: <20191003125912.GA18156@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:58:52AM -0700, Roopa Prabhu wrote:
> On Wed, Oct 2, 2019 at 1:41 AM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > From: Ido Schimmel <idosch@mellanox.com>
> >
> > When performing L3 offload, routes and nexthops are usually programmed
> > into two different tables in the underlying device. Therefore, the fact
> > that a nexthop resides in hardware does not necessarily mean that all
> > the associated routes also reside in hardware and vice-versa.
> >
> > While the kernel can signal to user space the presence of a nexthop in
> > hardware (via 'RTNH_F_OFFLOAD'), it does not have a corresponding flag
> > for routes. In addition, the fact that a route resides in hardware does
> > not necessarily mean that the traffic is offloaded. For example,
> > unreachable routes (i.e., 'RTN_UNREACHABLE') are programmed to trap
> > packets to the CPU so that the kernel will be able to generate the
> > appropriate ICMP error packet.
> >
> > This patch adds an "in hardware" indication to IPv4 routes, so that
> > users will have better visibility into the offload process. In the
> > future IPv6 will be extended with this indication as well.
> >
> > 'struct fib_alias' is extended with a new field that indicates if
> > the route resides in hardware or not. Note that the new field is added
> > in the 6 bytes hole and therefore the struct still fits in a single
> > cache line [1].
> >
> > Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
> > with the route's key in order to set / clear the "in hardware
> > indication".
> >
> > The new indication is dumped to user space via a new flag (i.e.,
> > 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
> >
> 
> nice series Ido.

Thanks, Roopa. Forgot to copy you on this RFC. Will copy you on v1.

> why not call this RTM_F_OFFLOAD to keep it consistent with the nexthop
> offload indication ?.

I can call it RTM_F_OFFLOAD to be consistent with RTNH_F_OFFLOAD, but it
should really be displayed as "in_hw" to the user which is why I
preferred to use RTM_F_IN_HW.

We probably need to document the semantics better, but as I see it
"offload" is for functionality that we actually offload from the kernel.
For example, prefix and gatewayed routes. We do not set the offload mark
on host routes that are used to locally receive packets. We do mark them
as offloaded if they are used to decap IP-in-IP or VXLAN traffic.

Given the above, we do not have an easy way today to understand which
routes actually reside in hardware and which are not. Having this
information is very useful for debugging and testing (as evident by the
last patch in the series).

> But this again does not seem to be similar to the other request flags
> like: RTM_F_FIB_MATCH

Not sure I understand, similar in what way? Can you clarify?

> (so far i think all the RTNH_F_* flags are used on routes too IIRC
> (see iproute2: print_rt_flags)
> RTNH_F_DEAD seems to fall in this category)

The 'rtm_flags' field in the ancillary header is actually divided
between RTNH_F_ and RTM_F_ flags. When the route has a single nexthop
the RTNH_F_ flags are communicated to user space via this field.

Since I'm interested in letting user space know if the route itself
resides in hardware (not the nexthop) it seemed logical to me to use
RTM_F_ and encode it in 'rtm_flags'.

Shana tova (have a good year)!

> 
> 
> > [1]
> > struct fib_alias {
> >         struct hlist_node  fa_list;                      /*     0    16 */
> >         struct fib_info *          fa_info;              /*    16     8 */
> >         u8                         fa_tos;               /*    24     1 */
> >         u8                         fa_type;              /*    25     1 */
> >         u8                         fa_state;             /*    26     1 */
> >         u8                         fa_slen;              /*    27     1 */
> >         u32                        tb_id;                /*    28     4 */
> >         s16                        fa_default;           /*    32     2 */
> >         u8                         in_hw:1;              /*    34: 0  1 */
> >         u8                         unused:7;             /*    34: 1  1 */
> >
> >         /* XXX 5 bytes hole, try to pack */
> >
> >         struct callback_head rcu __attribute__((__aligned__(8))); /*    40    16 */
> >
> >         /* size: 56, cachelines: 1, members: 11 */
> >         /* sum members: 50, holes: 1, sum holes: 5 */
> >         /* sum bitfield members: 8 bits (1 bytes) */
> >         /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
> >         /* last cacheline: 56 bytes */
> > } __attribute__((__aligned__(8)));
> >
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > ---
> >  include/net/ip_fib.h           |  5 +++
> >  include/uapi/linux/rtnetlink.h |  1 +
> >  net/ipv4/fib_lookup.h          |  4 ++
> >  net/ipv4/fib_semantics.c       |  4 ++
> >  net/ipv4/fib_trie.c            | 71 ++++++++++++++++++++++++++++++++++
> >  5 files changed, 85 insertions(+)
> >
> > diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> > index 52b2406a5dfc..019a138a79f4 100644
> > --- a/include/net/ip_fib.h
> > +++ b/include/net/ip_fib.h
> > @@ -454,6 +454,11 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *fc_encap,
> >  void fib_nh_common_release(struct fib_nh_common *nhc);
> >
> >  /* Exported by fib_trie.c */
> > +void fib_alias_in_hw_set(struct net *net, u32 dst, int dst_len,
> > +                        const struct fib_info *fi, u8 tos, u8 type, u32 tb_id);
> > +void fib_alias_in_hw_clear(struct net *net, u32 dst, int dst_len,
> > +                          const struct fib_info *fi, u8 tos, u8 type,
> > +                          u32 tb_id);
> >  void fib_trie_init(void);
> >  struct fib_table *fib_trie_table(u32 id, struct fib_table *alias);
> >
> > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > index 1418a8362bb7..e5a104f5ce35 100644
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -309,6 +309,7 @@ enum rt_scope_t {
> >  #define RTM_F_PREFIX           0x800   /* Prefix addresses             */
> >  #define RTM_F_LOOKUP_TABLE     0x1000  /* set rtm_table to FIB lookup result */
> >  #define RTM_F_FIB_MATCH                0x2000  /* return full fib lookup match */
> > +#define RTM_F_IN_HW            0x4000  /* route is in hardware */
> >
> >  /* Reserved table identifiers */
> >
> > diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
> > index b34594a9965f..65a69a863499 100644
> > --- a/net/ipv4/fib_lookup.h
> > +++ b/net/ipv4/fib_lookup.h
> > @@ -16,6 +16,8 @@ struct fib_alias {
> >         u8                      fa_slen;
> >         u32                     tb_id;
> >         s16                     fa_default;
> > +       u8                      in_hw:1,
> > +                               unused:7;
> >         struct rcu_head         rcu;
> >  };
> >
> > @@ -28,6 +30,8 @@ struct fib_rt_info {
> >         int                     dst_len;
> >         u8                      tos;
> >         u8                      type;
> > +       u8                      in_hw:1,
> > +                               unused:7;
> >  };
> >
> >  /* Dont write on fa_state unless needed, to keep it shared on all cpus */
> > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > index 3c9d47804d93..94f201d44844 100644
> > --- a/net/ipv4/fib_semantics.c
> > +++ b/net/ipv4/fib_semantics.c
> > @@ -519,6 +519,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
> >         fri.dst_len = dst_len;
> >         fri.tos = fa->fa_tos;
> >         fri.type = fa->fa_type;
> > +       fri.in_hw = fa->in_hw;
> >         err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
> >         if (err < 0) {
> >                 /* -EMSGSIZE implies BUG in fib_nlmsg_size() */
> > @@ -1801,6 +1802,9 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
> >                         goto nla_put_failure;
> >         }
> >
> > +       if (fri->in_hw)
> > +               rtm->rtm_flags |= RTM_F_IN_HW;
> > +
> >         nlmsg_end(skb, nlh);
> >         return 0;
> >
> > diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> > index 646542de83ca..e3486bde6c5a 100644
> > --- a/net/ipv4/fib_trie.c
> > +++ b/net/ipv4/fib_trie.c
> > @@ -1028,6 +1028,74 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
> >         return NULL;
> >  }
> >
> > +static struct fib_alias *
> > +fib_find_matching_alias(struct net *net, u32 dst, int dst_len,
> > +                       const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
> > +{
> > +       u8 slen = KEYLENGTH - dst_len;
> > +       struct key_vector *l, *tp;
> > +       struct fib_table *tb;
> > +       struct fib_alias *fa;
> > +       struct trie *t;
> > +
> > +       tb = fib_get_table(net, tb_id);
> > +       if (!tb)
> > +               return NULL;
> > +
> > +       t = (struct trie *)tb->tb_data;
> > +       l = fib_find_node(t, &tp, dst);
> > +       if (!l)
> > +               return NULL;
> > +
> > +       hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
> > +               if (fa->fa_slen == slen && fa->tb_id == tb_id &&
> > +                   fa->fa_tos == tos && fa->fa_info == fi &&
> > +                   fa->fa_type == type)
> > +                       return fa;
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > +void fib_alias_in_hw_set(struct net *net, u32 dst, int dst_len,
> > +                        const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
> > +{
> > +       struct fib_alias *fa_match;
> > +
> > +       rcu_read_lock();
> > +
> > +       fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
> > +                                          tb_id);
> > +       if (!fa_match)
> > +               goto out;
> > +
> > +       fa_match->in_hw = 1;
> > +
> > +out:
> > +       rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL_GPL(fib_alias_in_hw_set);
> > +
> > +void fib_alias_in_hw_clear(struct net *net, u32 dst, int dst_len,
> > +                          const struct fib_info *fi, u8 tos, u8 type,
> > +                          u32 tb_id)
> > +{
> > +       struct fib_alias *fa_match;
> > +
> > +       rcu_read_lock();
> > +
> > +       fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
> > +                                          tb_id);
> > +       if (!fa_match)
> > +               goto out;
> > +
> > +       fa_match->in_hw = 0;
> > +
> > +out:
> > +       rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL_GPL(fib_alias_in_hw_clear);
> > +
> >  static void trie_rebalance(struct trie *t, struct key_vector *tn)
> >  {
> >         while (!IS_TRIE(tn))
> > @@ -1236,6 +1304,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
> >                         new_fa->fa_slen = fa->fa_slen;
> >                         new_fa->tb_id = tb->tb_id;
> >                         new_fa->fa_default = -1;
> > +                       new_fa->in_hw = 0;
> >
> >                         hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
> >
> > @@ -1294,6 +1363,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
> >         new_fa->fa_slen = slen;
> >         new_fa->tb_id = tb->tb_id;
> >         new_fa->fa_default = -1;
> > +       new_fa->in_hw = 0;
> >
> >         /* Insert new entry to the list. */
> >         err = fib_insert_alias(t, tp, l, new_fa, fa, key);
> > @@ -2218,6 +2288,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
> >                                 fri.dst_len = KEYLENGTH - fa->fa_slen;
> >                                 fri.tos = fa->fa_tos;
> >                                 fri.type = fa->fa_type;
> > +                               fri.in_hw = fa->in_hw;
> >                                 err = fib_dump_info(skb,
> >                                                     NETLINK_CB(cb->skb).portid,
> >                                                     cb->nlh->nlmsg_seq,
> > --
> > 2.21.0
> >
