Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE07C1B18B3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTVnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728091AbgDTVnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:43:45 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8549CC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:43:45 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id n26so2574160uap.11
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g6mslA+ZAlFPPiF3/X0cAe5Oou9a45SAhWdz0xEMkbQ=;
        b=rUKo50ePOvmWy4AD5K1fItw/ZVHR+koWpT9awCFpRrT41GHTWG2Lb4yn8OgaVgZJQw
         E810No7MGcQ1oeuOYonKQlqUs89htMXjGmoVlNX/ijdM53KIzFx9CqNLHIVDJpBqAKOo
         NaU4XhFPh+0gK3W/6/sU9fvL8Jtgrg5wGn3QdR5n7V5MzQy+z21r18UCZUe2DED5Q2oC
         HSOu3YwWazMHZRbL6R4NypVR9lR8luSVJC/Jv4dE58t4b79R5nd1HsHcApCqsMwH9F/8
         svz5ypiyHM/971KPEuefGZjd1KnoQXAqWlk6A1kbQOHxPer1EqG5kPpWbQMry8p8v1t5
         YVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g6mslA+ZAlFPPiF3/X0cAe5Oou9a45SAhWdz0xEMkbQ=;
        b=cTmQZ9lBJPs1lX6UpMdUb29UmGwOazmXFRAWZU43SIm/nrxLgomukkON3jhtO2AhJv
         rUsWg6YJN1LWguhaV/FlE0RdfVluY0y/t4IAZNHA29l/W8ZFzJuljlosQ4dAwzXwGEPM
         qlI+b8zgcm1gxKuT3F3VHA8t+t3VIBhPelP2+pFy4xgEI+CRKY+cWw3m51wDFGhlrF8w
         zpH20pz2Bx9cpeiVNACIctFfv1ejyXJRoCxYvQ60jeiqDfdSA0U4SachxIw0k8XkYbee
         OKxnCMyuwKZJXBOPBaNZ7Xg81o3V1df5ejxzmPMd65B0c9grDMeB75tz8pGfPEMfmwof
         D84Q==
X-Gm-Message-State: AGi0PuZYIODm6oyEaNNCiHS3oen0zBlNyxkr6nqEdbh0+W3oYVqFqOer
        GphZxEBOhTSbHjDE9g7q22yY+FzrHk2WkwTrQhM=
X-Google-Smtp-Source: APiQypI1QWqpJqkJztVS9aLMHCJiugHFKAEMYltBq+KtHGjyP858BuZLEhYfGL6bpcZ7D71HCp6lysSjrf8AC3ysg1U=
X-Received: by 2002:ab0:74cf:: with SMTP id f15mr8010124uaq.118.1587419024571;
 Mon, 20 Apr 2020 14:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-2-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_Ape956tPpdMaRv-J2CdaWxkLf5ph57wxSL-6E7pUQ6vg@mail.gmail.com> <CAMDZJNXh_1BFRnypUNLgmF5E4s-qN1cg=0Jqr5RoR5bSNgV-FQ@mail.gmail.com>
In-Reply-To: <CAMDZJNXh_1BFRnypUNLgmF5E4s-qN1cg=0Jqr5RoR5bSNgV-FQ@mail.gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Mon, 20 Apr 2020 14:43:33 -0700
Message-ID: <CAOrHB_BXnoBsNiExF4NsDvXaLO5RAqZ7e8keLVR1Vd2z7y_sOQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/5] net: openvswitch: expand the meters
 supported number
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 5:23 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Apr 20, 2020 at 1:29 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> >
> > On Sat, Apr 18, 2020 at 10:25 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > In kernel datapath of Open vSwitch, there are only 1024
> > > buckets of meter in one dp. If installing more than 1024
> > > (e.g. 8192) meters, it may lead to the performance drop.
> > > But in some case, for example, Open vSwitch used as edge
> > > gateway, there should be 200,000+ at least, meters used for
> > > IP address bandwidth limitation.
> > >
> > > [Open vSwitch userspace datapath has this issue too.]
> > >
> > > For more scalable meter, this patch expands the buckets
> > > when necessary, so we can install more meters in the datapath.
> > > Introducing the struct *dp_meter_instance*, it's easy to
> > > expand meter though changing the *ti* point in the struct
> > > *dp_meter_table*.
> > >
> > > Cc: Pravin B Shelar <pshelar@ovn.org>
> > > Cc: Andy Zhou <azhou@ovn.org>
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >  net/openvswitch/datapath.h |   2 +-
> > >  net/openvswitch/meter.c    | 200 +++++++++++++++++++++++++++++--------
> > >  net/openvswitch/meter.h    |  15 ++-
> > >  3 files changed, 169 insertions(+), 48 deletions(-)
> > >
> > > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > > index e239a46c2f94..785105578448 100644
> > > --- a/net/openvswitch/datapath.h
> > > +++ b/net/openvswitch/datapath.h
> > > @@ -82,7 +82,7 @@ struct datapath {
> > >         u32 max_headroom;
> > >
> > >         /* Switch meters. */
> > > -       struct hlist_head *meters;
> > > +       struct dp_meter_table *meters;
> > lets define it as part of this struct to avoid indirection.
> >
> > >  };
> > >
> > >  /**
> > > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > > index 5010d1ddd4bd..494a0014ecd8 100644
> > > --- a/net/openvswitch/meter.c
> > > +++ b/net/openvswitch/meter.c
> > > @@ -19,8 +19,6 @@
> > >  #include "datapath.h"
> > >  #include "meter.h"
> > >
> > > -#define METER_HASH_BUCKETS 1024
> > > -
> > >  static const struct nla_policy meter_policy[OVS_METER_ATTR_MAX + 1] = {
> > >         [OVS_METER_ATTR_ID] = { .type = NLA_U32, },
> > >         [OVS_METER_ATTR_KBPS] = { .type = NLA_FLAG },
> > > @@ -39,6 +37,11 @@ static const struct nla_policy band_policy[OVS_BAND_ATTR_MAX + 1] = {
> > >         [OVS_BAND_ATTR_STATS] = { .len = sizeof(struct ovs_flow_stats) },
> > >  };
> > >
> > > +static u32 meter_hash(struct dp_meter_instance *ti, u32 id)
> > > +{
> > > +       return id % ti->n_meters;
> > > +}
> > > +
> > >  static void ovs_meter_free(struct dp_meter *meter)
> > >  {
> > >         if (!meter)
> > > @@ -47,40 +50,141 @@ static void ovs_meter_free(struct dp_meter *meter)
> > >         kfree_rcu(meter, rcu);
> > >  }
> > >
> > > -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> > > -                                           u32 meter_id)
> > > -{
> > > -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> > > -}
> > > -
> > >  /* Call with ovs_mutex or RCU read lock. */
> > > -static struct dp_meter *lookup_meter(const struct datapath *dp,
> > > +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
> > >                                      u32 meter_id)
> > >  {
> > > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > > +       u32 hash = meter_hash(ti, meter_id);
> > >         struct dp_meter *meter;
> > > -       struct hlist_head *head;
> > >
> > > -       head = meter_hash_bucket(dp, meter_id);
> > > -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> > > -                               lockdep_ovsl_is_held()) {
> > > -               if (meter->id == meter_id)
> > > -                       return meter;
> > > -       }
> > > +       meter = rcu_dereference_ovsl(ti->dp_meters[hash]);
> > > +       if (meter && likely(meter->id == meter_id))
> > > +               return meter;
> > > +
> > >         return NULL;
> > >  }
> > >
> > > -static void attach_meter(struct datapath *dp, struct dp_meter *meter)
> > > +static struct dp_meter_instance *dp_meter_instance_alloc(const u32 size)
> > > +{
> > > +       struct dp_meter_instance *ti;
> > > +
> > > +       ti = kvzalloc(sizeof(*ti) +
> > > +                     sizeof(struct dp_meter *) * size,
> > > +                     GFP_KERNEL);
> > > +       if (!ti)
> > > +               return NULL;
> > Given this is a kernel space array we need to have hard limit inplace.
> In patch 2, I limited the meter number, should we add hard limit here ?
I guess its not needed here.
...

> > >  static struct sk_buff *
> > > @@ -303,9 +407,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
> > >         meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
> > >
> > >         /* Cannot fail after this. */
> > > -       old_meter = lookup_meter(dp, meter_id);
> > > -       detach_meter(old_meter);
> > > -       attach_meter(dp, meter);
> > > +       old_meter = lookup_meter(dp->meters, meter_id);
> > in new scheme this can fail due to hash collision, lets check for NULL.
> If old_meter is NULL, detach_meter will do nothing.

Lets return error.
