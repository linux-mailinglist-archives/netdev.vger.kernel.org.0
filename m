Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0FF1A4EE9
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgDKIOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 04:14:32 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:34280 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgDKIOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 04:14:31 -0400
Received: by mail-vk1-f194.google.com with SMTP id p123so1101064vkg.1
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 01:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qw7Q2dGOvh2sPJ12pU557DCszrP9W9lT4rpRZcvcwnw=;
        b=slC8l6qjbvo0LqK2S83/X0ZaCO08aDqlWS1M+yO+oz/JyU5nKaETx1HFFNnn/LqZal
         xCsqP+u8/wyIfmKL9piFZk/NBMNE7G4C0+j/0WIwA7AOxfeqrtxczHuwt/1M9nrrZQ08
         jbqdIrgfa20vasj00AEXDyUSjgORC1e+gLZg0TNVXI4JkQqUeOqXWm+vtXKH/6J8znHQ
         7eg6tzLkNS/V5nOrTwiXNLVvatpvOx91Q3mVFCL4yKW5EJYGk3yu1/UQOZYYZgFD9g2q
         DAEZFCGR0x8jAT7vHJBg5Ziw6tLDBmNzSVqobOrm2vkgVvzGE/2+4bhPs1EfEFwg7QwS
         I3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qw7Q2dGOvh2sPJ12pU557DCszrP9W9lT4rpRZcvcwnw=;
        b=af2dIwGW7UdeCLilcOJD2powLGJ1TXn0yg0+3CXZe6sNVCbQQoZhiz3Ug1miDB2E/z
         OHIP6X2KUwbDhdHrmUK3zY9sdqLYFbgokkX/ZKNBBElSXVr/Y+9UslhB7ZPaUVl7RV0a
         CI4PlvN0jZ+NUC7Bt7ceHMC3TowfQgu6Tcz+MRXV5Px1Hpt0TjCO1V66VShcYYF42ZHf
         xERtP4E0pLDjbwSNlcIjNKaurvW1bdeG63h7M9GtBzSLPni0NzYSt72K3dTI1PO75YbV
         cYLAFVeVtmOuqpPvpFEQsx1yxlCcPwGig5QuH8ZLyBYWwYwatpxAaenFzp4EhGIc00dg
         pkAw==
X-Gm-Message-State: AGi0PubBsL4sz3W9VGwRrMt/4VwOjCPM/9Jfr9v7S4xMV2RHmIMW6WhW
        /YOLCKmDGU+hIu50Qm/tAz0wDIONFVQR8A+L6l0=
X-Google-Smtp-Source: APiQypIDFxzxTR2+U3WLdDCTHuMUI9Pwm8qXxqXZRPKCDkjcdgSfRgmEYIArMKPRPhkERpfTgvSdJF+kVPnVUQ92iBQ=
X-Received: by 2002:a1f:9541:: with SMTP id x62mr5591116vkd.82.1586592870803;
 Sat, 11 Apr 2020 01:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_BZ2Sqjooc9u1osbrEsbL5w003CL54v_bd3YPcqkjOzjg@mail.gmail.com>
 <CAMDZJNV1+zA9EGRMDrZDBNxTg3fr+4ZeH7bcLgfVginx3p4Cww@mail.gmail.com>
 <CAOrHB_Bw1cUANoKe_1ZeGQkVVX6rj5YPTzzcNUjv3_KKRWehdQ@mail.gmail.com>
 <CAMDZJNWHaQ_fYPdjC0hhQZbr_vXReDXeA5TgFNHy8SG79SzU1g@mail.gmail.com>
 <20200408150916.GA54720@gmail.com> <CAMDZJNUHLM5nx_ek1uJO4MkPNDoD4Or+SZKVry0+dPkq--VGGg@mail.gmail.com>
 <20200409214142.GB85978@gmail.com> <CAMDZJNX8v4_=0qzHTTS_9x=0bBoM=_ihpsTdaeSZ30n=DpR3bw@mail.gmail.com>
In-Reply-To: <CAMDZJNX8v4_=0qzHTTS_9x=0bBoM=_ihpsTdaeSZ30n=DpR3bw@mail.gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sat, 11 Apr 2020 01:14:19 -0700
Message-ID: <CAOrHB_DKEHOmqT1XvQ=UiF-rgsGENymkD88B=zzjLxUz0RiVyw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v1 1/3] net: openvswitch: expand the
 meters number supported
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     William Tu <u9012063@gmail.com>, ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that we already use id-pool, we can significantly reduce
probability of the negative case of meter lookup. Therefore I do not
see need to use hash table in the datapath.

On Thu, Apr 9, 2020 at 4:29 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Fri, Apr 10, 2020 at 5:41 AM William Tu <u9012063@gmail.com> wrote:
> >
> > On Wed, Apr 08, 2020 at 11:59:25PM +0800, Tonghao Zhang wrote:
> > > On Wed, Apr 8, 2020 at 11:09 PM William Tu <u9012063@gmail.com> wrote:
> > > >
> > > > On Wed, Apr 01, 2020 at 06:50:09PM +0800, Tonghao Zhang wrote:
> > > > > On Tue, Mar 31, 2020 at 11:57 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > > >
> > > > > > On Sun, Mar 29, 2020 at 5:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Mar 30, 2020 at 12:46 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > > > > >
> > > > > > > > On Sat, Mar 28, 2020 at 8:46 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > > >
> > > > > > > > > In kernel datapath of Open vSwitch, there are only 1024
> > > > > > > > > buckets of meter in one dp. If installing more than 1024
> > > > > > > > > (e.g. 8192) meters, it may lead to the performance drop.
> > > > > > > > > But in some case, for example, Open vSwitch used as edge
> > > > > > > > > gateway, there should be 200,000+ at least, meters used for
> > > > > > > > > IP address bandwidth limitation.
> > > > > > > > >
> > > > > > > > > [Open vSwitch userspace datapath has this issue too.]
> > > > > > > > >
> > > > > > > > > For more scalable meter, this patch expands the buckets
> > > > > > > > > when necessary, so we can install more meters in the datapath.
> > > > > > > > >
> > > > > > > > > * Introducing the struct *dp_meter_instance*, it's easy to
> > > > > > > > >   expand meter though change the *ti* point in the struct
> > > > > > > > >   *dp_meter_table*.
> > > > > > > > > * Using kvmalloc_array instead of kmalloc_array.
> > > > > > > > >
> > > > > > > > Thanks for working on this, I have couple of comments.
> > > > > > > >
> > > > > > > > > Cc: Pravin B Shelar <pshelar@ovn.org>
> > > > > > > > > Cc: Andy Zhou <azhou@ovn.org>
> > > > > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > > > ---
> > > > > > > > >  net/openvswitch/datapath.h |   2 +-
> > > > > > > > >  net/openvswitch/meter.c    | 168 ++++++++++++++++++++++++++++++-------
> > > > > > > > >  net/openvswitch/meter.h    |  17 +++-
> > > > > > > > >  3 files changed, 153 insertions(+), 34 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > > > > > > > > index e239a46c2f94..785105578448 100644
> > > > > > > > > --- a/net/openvswitch/datapath.h
> > > > > > > > > +++ b/net/openvswitch/datapath.h
> > > > > > > > > @@ -82,7 +82,7 @@ struct datapath {
> > > > > > > > >         u32 max_headroom;
> > > > > > > > >
> > > > > > > > >         /* Switch meters. */
> > > > > > > > > -       struct hlist_head *meters;
> > > > > > > > > +       struct dp_meter_table *meters;
> > > > > > > > >  };
> > > > > > > > >
> > > > > > > > >  /**
> > > > > > > > > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > > > > > > > > index 5010d1ddd4bd..98003b201b45 100644
> > > > > > > > > --- a/net/openvswitch/meter.c
> > > > > > > > > +++ b/net/openvswitch/meter.c
> > > > > > > > > @@ -47,40 +47,136 @@ static void ovs_meter_free(struct dp_meter *meter)
> > > > > > > > >         kfree_rcu(meter, rcu);
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> > > > > > > > > +static struct hlist_head *meter_hash_bucket(struct dp_meter_instance *ti,
> > > > > > > > >                                             u32 meter_id)
> > > > > > > > >  {
> > > > > > > > > -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> > > > > > > > > +       u32 hash = jhash_1word(meter_id, ti->hash_seed);
> > > > > > > > > +
> > > > > > > > I do not see any need to hash meter-id, can you explain it.
> > > > > > > >
> > > > > > > > > +       return &ti->buckets[hash & (ti->n_buckets - 1)];
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > >  /* Call with ovs_mutex or RCU read lock. */
> > > > > > > > > -static struct dp_meter *lookup_meter(const struct datapath *dp,
> > > > > > > > > +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
> > > > > > > > >                                      u32 meter_id)
> > > > > > > > >  {
> > > > > > > > > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > > > > > > > >         struct dp_meter *meter;
> > > > > > > > >         struct hlist_head *head;
> > > > > > > > >
> > > > > > > > > -       head = meter_hash_bucket(dp, meter_id);
> > > > > > > > > -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> > > > > > > > > -                               lockdep_ovsl_is_held()) {
> > > > > > > > > +       head = meter_hash_bucket(ti, meter_id);
> > > > > > > > > +       hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
> > > > > > > > > +                                lockdep_ovsl_is_held()) {
> > > > > > > > >                 if (meter->id == meter_id)
> > > > > > > > >                         return meter;
> > > > > > > > >         }
> > > > > > > > > +
> > > > > > > > This patch is expanding meter table linearly with number meters added
> > > > > > > > to datapath. so I do not see need to have hash table. it can be a
> > > > > > > > simple array. This would also improve lookup efficiency.
> > > > > > > > For hash collision we could find next free slot in array. let me know
> > > > > > > > what do you think about this approach.
> > > > > > > Hi Pravin
> > > > > > > If we use the simple array, when inserting the meter, for hash collision, we can
> > > > > > > find next free slot, but one case, when there are many meters in the array.
> > > > > > > we may find many slot for the free slot.
> > > > > > > And when we lookup the meter, for hash collision, we may find many
> > > > > > > array slots, and
> > > > > > > then find it, or that meter does not exist in the array, In that case,
> > > > > > > there may be a lookup performance
> > > > > > > drop.
> > > > > > >
> > > > > > I was thinking that users can insure that there are no hash collision,
> > > > > > but time complexity of negative case is expensive. so I am fine with
> > > > > > the hash table.
> > > >
> > > > IIUC, there will be hash collision. meter id is an 32-bit value.
> > > > Currenly in lib/dpif-netdev.c, MAX_METERS = 65536.
> > > Hi, William
> > > but id-pool makes sure the meter id is from 0, 1, 2, 3 ... n, but not n, m, y.
> > > so if we alloc 1024 meters, the last meter id should be 1023, and then
> > > use the simple array to expand the meter is better ?
> > >
> >
> > I see, so you want to set the # of hash bucket = max # of meter id,
> > so there is no hash collision, (with the cost of using more memory)
> Not really, there are 1024 buckets as default, and will expand to
> 1024*2, and then 1024*2*2  if necessary
> if the most meter is deleted, we will shrink it.
>
> > I don't have strong opinion on which design is better. Let's wait for
> > Pravin's feedback.
> >
> > William
> >
> > > > I think what Pravin suggest is to use another hash function to make
> > > > the hash table more condense. Ex: hash1 and hash2.
> > > > For lookup, if hash1(key) misses, then try hash2(key).
> > > >
> > > > William
> > > >
> > > > > Hi Pravi
> > > > > I check again the meter implementation of ovs, ovs-vswitchd use the id-pool to
> > > > > get a valid meter-id which passed to kernel, so there is no hash collision. You
> > > > > are right. we use the single array is the better solution.
> > > > > > > For hash meter-id in meter_hash_bucket, I am not 100% sure it is
> > > > > > > useful. it just update
> > > > > > > hash_seed when expand meters. For performance, we can remove it. Thanks.
> > > > > > ok.
> >
>
>
> --
> Best regards, Tonghao
