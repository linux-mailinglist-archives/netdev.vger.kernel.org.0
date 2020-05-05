Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD971C4CBE
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgEEDtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:49:23 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85768C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:49:21 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g16so718848eds.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yOMTzEy2S3SFRjLrr+vV6gL3ymR68k5By2uEMe2II8s=;
        b=FH05kXvsUoUso7Pyq2TayOLjgFfo9k+pPbWVrGkMAxBjgeBvj2gPwLrgkfkT8vHaFq
         /zK0Ft9McltzHcumRJ1JeaQ6pgF/m41dF3SRLSNYDt40OaG3bjCppiA/KV+BGfIjx6rV
         dkFqCRIleCfT87UA00jnnI0+Y0eThdhV+JppU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yOMTzEy2S3SFRjLrr+vV6gL3ymR68k5By2uEMe2II8s=;
        b=fDP1yc4KeQlR4pIownOfJc9wU0KJs0YmH9s3pTn1HUqRp34I700DqEkOni4W8i39cU
         ktzW9xfeb4iw9dw0bq/0pFnZd0EfsvC7kdlLAaziBq/6d2OyjnLluSzdykPYi2wH3TvZ
         dRWP91q2lzoiq7TvAVMbjF5gYBAqBghjb7OmznQs1u4QxgEBWA2T44/ruqIEKQleiCpy
         lfuOLmIm9EBCF6Par9UZsGS1SVZupvhUPsKlZGWfB0EqgEJsW+voT6j+CL9M+nirtpZm
         jPU0RStQikkHb8PlUoq57ym4ijEdosZ37zJt39+d1PGeC0NXsuuKN1UpzZmxUscVyQgy
         04vQ==
X-Gm-Message-State: AGi0PubCPeTVhmnPrBS37dDC3iCS5llKycupHo5Mj+kSNghxVRuhXbmY
        5p5X1slAksKfvJA2r44T7ASkTSNJ7Yk/RR2sYa/OGg==
X-Google-Smtp-Source: APiQypKBC5fn5kMeNueCdwzHVKSAMWU6V2BQGs2jyJhl6CyxlXhGkD2lhcUh8TxXYhM5CWD0CL66J+hT15bnnQhmg+4=
X-Received: by 2002:a05:6402:17c4:: with SMTP id s4mr965579edy.348.1588650560115;
 Mon, 04 May 2020 20:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
 <1588631301-21564-2-git-send-email-roopa@cumulusnetworks.com> <0d535a96-addf-111c-0418-7b313300e3f7@gmail.com>
In-Reply-To: <0d535a96-addf-111c-0418-7b313300e3f7@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 4 May 2020 20:49:12 -0700
Message-ID: <CAJieiUjtqVkxL2JRXWNGVeRvqWDP5f+kKyEsC-8jX9SP8g+EZw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/5] nexthop: support for fdb ecmp nexthops
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 8:23 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/4/20 4:28 PM, Roopa Prabhu wrote:
> >  include/net/nexthop.h        |  14 ++++++
> >  include/uapi/linux/nexthop.h |   1 +
> >  net/ipv4/nexthop.c           | 101 +++++++++++++++++++++++++++++++++----------
> >  3 files changed, 93 insertions(+), 23 deletions(-)
>
> pretty cool that you can extend this from routes to fdb entries with
> such a small change stat.

yep, exactly. everything fell into place so neatly.

>
> >
> > diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> > index c440ccc..3ad4e97 100644
> > --- a/include/net/nexthop.h
> > +++ b/include/net/nexthop.h
> > @@ -26,6 +26,7 @@ struct nh_config {
> >       u8              nh_family;
> >       u8              nh_protocol;
> >       u8              nh_blackhole;
> > +     u8              nh_fdb;
> >       u32             nh_flags;
> >
> >       int             nh_ifindex;
> > @@ -52,6 +53,7 @@ struct nh_info {
> >
> >       u8                      family;
> >       bool                    reject_nh;
> > +     bool                    fdb_nh;
> >
> >       union {
> >               struct fib_nh_common    fib_nhc;
> > @@ -80,6 +82,7 @@ struct nexthop {
> >       struct rb_node          rb_node;    /* entry on netns rbtree */
> >       struct list_head        fi_list;    /* v4 entries using nh */
> >       struct list_head        f6i_list;   /* v6 entries using nh */
> > +     struct list_head        fdb_list;   /* fdb entries using this nh */
> >       struct list_head        grp_list;   /* nh group entries using this nh */
> >       struct net              *net;
> >
> > @@ -88,6 +91,7 @@ struct nexthop {
> >       u8                      protocol;   /* app managing this nh */
> >       u8                      nh_flags;
> >       bool                    is_group;
> > +     bool                    is_fdb_nh;
> >
> >       refcount_t              refcnt;
> >       struct rcu_head         rcu;
> > @@ -304,4 +308,14 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
> >  int nexthop_for_each_fib6_nh(struct nexthop *nh,
> >                            int (*cb)(struct fib6_nh *nh, void *arg),
> >                            void *arg);
> > +
> > +static inline struct nh_info *nexthop_path_fdb(struct nexthop *nh,  u32 hash)
>
> this is used in the next patch. Any way to not leak the nh_info struct
> into vxlan code? Right now nh_info is only used in nexthop.{c,h}.
>

yes, sure I think I can do that. I will add an api to get the nh
family and use nh everywhere.

> > +{
> > +     struct nh_info *nhi;
> > +
> > +     nh = nexthop_select_path(nh, hash);
> > +     nhi = rcu_dereference(nh->nh_info);
> > +
> > +     return nhi;
> > +}
> >  #endif
> > diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
> > index 7b61867..19a234a 100644
> > --- a/include/uapi/linux/nexthop.h
> > +++ b/include/uapi/linux/nexthop.h
> > @@ -48,6 +48,7 @@ enum {
> >        */
> >       NHA_GROUPS,     /* flag; only return nexthop groups in dump */
> >       NHA_MASTER,     /* u32;  only return nexthops with given master dev */
> > +     NHA_FDB,        /* nexthop belongs to a bridge fdb */
>
> please add the 'type' to the comment; I tried to make this uapi file
> completely self-documenting. ie., no one should have to consult the code
> to know what kind of attribute NHA_FDB is.
>

yep, will do. not sure how i missed it,


> >
> >       __NHA_MAX,
> >  };
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index 3957364..98f8d2a 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -33,6 +33,7 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
> >       [NHA_ENCAP]             = { .type = NLA_NESTED },
> >       [NHA_GROUPS]            = { .type = NLA_FLAG },
> >       [NHA_MASTER]            = { .type = NLA_U32 },
> > +     [NHA_FDB]               = { .type = NLA_FLAG },
> >  };
> >
> >  static unsigned int nh_dev_hashfn(unsigned int val)
> > @@ -107,6 +108,7 @@ static struct nexthop *nexthop_alloc(void)
> >               INIT_LIST_HEAD(&nh->fi_list);
> >               INIT_LIST_HEAD(&nh->f6i_list);
> >               INIT_LIST_HEAD(&nh->grp_list);
> > +             INIT_LIST_HEAD(&nh->fdb_list);
> >       }
> >       return nh;
> >  }
> > @@ -227,6 +229,9 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
> >       if (nla_put_u32(skb, NHA_ID, nh->id))
> >               goto nla_put_failure;
> >
> > +     if (nh->is_fdb_nh && nla_put_flag(skb, NHA_FDB))
> > +             goto nla_put_failure;
> > +
> >       if (nh->is_group) {
> >               struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
> >
> > @@ -241,7 +246,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
> >               if (nla_put_flag(skb, NHA_BLACKHOLE))
> >                       goto nla_put_failure;
> >               goto out;
> > -     } else {
> > +     } else if (!nh->is_fdb_nh) {
> >               const struct net_device *dev;
> >
> >               dev = nhi->fib_nhc.nhc_dev;
> > @@ -393,6 +398,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
> >       unsigned int len = nla_len(tb[NHA_GROUP]);
> >       struct nexthop_grp *nhg;
> >       unsigned int i, j;
> > +     u8 nhg_fdb = 0;
> >
> >       if (len & (sizeof(struct nexthop_grp) - 1)) {
> >               NL_SET_ERR_MSG(extack,
> > @@ -421,6 +427,8 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
> >               }
> >       }
> >
> > +     if (tb[NHA_FDB])
> > +             nhg_fdb = 1;
> >       nhg = nla_data(tb[NHA_GROUP]);
> >       for (i = 0; i < len; ++i) {
> >               struct nexthop *nh;
> > @@ -432,11 +440,16 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
> >               }
> >               if (!valid_group_nh(nh, len, extack))
> >                       return -EINVAL;
> > +             if (nhg_fdb && !nh->is_fdb_nh) {
> > +                     NL_SET_ERR_MSG(extack, "FDB Multipath group can only have fdb nexthops");
> > +                     return -EINVAL;
> > +             }
>
> you should check the reverse as well -- non-nhg_fdb can not use an fdb
> nh. ie., a group can not be a mix of fdb and route entries.
>
> Make sure the selftests covers the permutations as well.
>

yep, will do

> >       }
> >       for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
> >               if (!tb[i])
> >                       continue;
> > -
> > +             if (tb[NHA_FDB])
> > +                     continue;
> >               NL_SET_ERR_MSG(extack,
> >                              "No other attributes can be set in nexthop groups");
> >               return -EINVAL;
>
>
