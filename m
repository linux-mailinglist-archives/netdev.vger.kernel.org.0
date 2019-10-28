Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C7AE6C86
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 07:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbfJ1Gti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 02:49:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37875 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730497AbfJ1Gti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 02:49:38 -0400
Received: by mail-io1-f67.google.com with SMTP id 1so9487785iou.4
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 23:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdCcbOGODVr+bbjKqCz74DBWQSfxcfrGp37nudpr7Ho=;
        b=gL/qwMXfzeSZ3cBBaRgq/zDlH/2wGsfxrq+84jaezhoRX9zthaAFvY7ruju3kiVlMp
         2ZA5H4MlRJQjtnNI1YSsU/PD1wS0dlrQqZmX6st7GVMEiKo0CebFqLNkIY9UikAVsXmA
         esLCfDLFs2iAyIuTcJixJhEHCtQ3D+BLhA6th1ipBtMg3cJ1FV/Xk+RAOnJPuv2prgt3
         osUWU9zsno+u3Pk9tpfhvRDlmPHHDv7wg/nwgYaEz3CJYYnql/GCTEJRIUBgQIa08Ib8
         Sm7rEHKQlLgFk7zRQySsHbbEKKC4XC9uSwE4BLTr5UfH6KC7SVOv5mGriSLq/zMuDtxC
         ih0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdCcbOGODVr+bbjKqCz74DBWQSfxcfrGp37nudpr7Ho=;
        b=pVzhMam3B1r82kVNu0pcS7jGYfurqn448Hag0RFaXNHkKd5fbT/cfazcrZsJJqOVhx
         v3aD0Ubb2ztcRYhc05j6Q7+Tz2vEQBDddW28Pv3U26JcldUaYkJWpJyKMSN9ra78Djhb
         9Ly4SMhg0D83qejqslWN9xPuKZpDHET98KHL59E40xo5NCRkM4Cnl0ZAK58F05lcqhdx
         BGjmQ2QWUzgGWVuWnBssbfkdLFwyLAsb2M7z9mITDDuY3OyS4ZbDBEITj45oMnobiIQz
         QC0AENOqPEdRJdJj9+8lmD5hVd6+BFyEWiKzBPte3y/UJZepMKjAv1e+AaOVZ+vIWKTn
         Wgbg==
X-Gm-Message-State: APjAAAXHkh4IRBlmiWAJkc9xJODtg4Z/40ABAlPleD37dVpytWH2/sOD
        BXuSBgcROE6TgOvq3lkxzkdWUzq8kK6HMxHfmHJAyiIl
X-Google-Smtp-Source: APXvYqxvBVv1EIZuf29n2OFkax6h0b6V5r/96EfNqT/C2b3l7P01PGjFq7g96ju8pw4CjOuszrpnaioyexCeAlCDVko=
X-Received: by 2002:a05:6638:a0e:: with SMTP id 14mr15682761jan.4.1572245376491;
 Sun, 27 Oct 2019 23:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
 <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
 <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
 <CAMDZJNXdu3R_GkHEBbwycEpe0wnwNmGzHx-8gUxtwiW1mEy7uw@mail.gmail.com>
 <CAOrHB_DdMX7sZkk79esdZkmb8RGaX_XiMAxhGz1LgWx50eFD9g@mail.gmail.com>
 <CAMDZJNVfyzmnd4qhp_esE-s3+-z8K=6tBP63X+SCEcjBon60eQ@mail.gmail.com> <CAOrHB_CnpcQoztqnfBkaDhTCK5nti8agtRmbbzZH+BfrPpiZ1g@mail.gmail.com>
In-Reply-To: <CAOrHB_CnpcQoztqnfBkaDhTCK5nti8agtRmbbzZH+BfrPpiZ1g@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 28 Oct 2019 14:49:00 +0800
Message-ID: <CAMDZJNWeUoXD9SOBXfWes7Xk=BLRPs1iti+Kwz7YfC0NSE6oig@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 3:14 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Tue, Oct 22, 2019 at 7:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Tue, Oct 22, 2019 at 2:58 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > >
> ...
>
> > > > >
> > > Sure, I can review it, Can you send the patch inlined in mail?
> > >
> > > Thanks.
> > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > index 5df5182..5b20793 100644
> > --- a/net/openvswitch/flow_table.c
> > +++ b/net/openvswitch/flow_table.c
> > @@ -257,10 +257,75 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
> >         __table_instance_destroy(ti);
> >  }
> >
> > -static void table_instance_destroy(struct table_instance *ti,
> > -                                  struct table_instance *ufid_ti,
> > +static void tbl_mask_array_del_mask(struct flow_table *tbl,
> > +                                   struct sw_flow_mask *mask)
> > +{
> > +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > +       int i, ma_count = READ_ONCE(ma->count);
> > +
> > +       /* Remove the deleted mask pointers from the array */
> > +       for (i = 0; i < ma_count; i++) {
> > +               if (mask == ovsl_dereference(ma->masks[i]))
> > +                       goto found;
> > +       }
> > +
> > +       BUG();
> > +       return;
> > +
> > +found:
> > +       WRITE_ONCE(ma->count, ma_count -1);
> > +
> > +       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
> > +       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
> > +
> > +       kfree_rcu(mask, rcu);
> > +
> > +       /* Shrink the mask array if necessary. */
> > +       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> > +           ma_count <= (ma->max / 3))
> > +               tbl_mask_array_realloc(tbl, ma->max / 2);
> > +}
> > +
> > +/* Remove 'mask' from the mask list, if it is not needed any more. */
> > +static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
> > +{
> > +       if (mask) {
> > +               /* ovs-lock is required to protect mask-refcount and
> > +                * mask list.
> > +                */
> > +               ASSERT_OVSL();
> > +               BUG_ON(!mask->ref_count);
> > +               mask->ref_count--;
> > +
> > +               if (!mask->ref_count)
> > +                       tbl_mask_array_del_mask(tbl, mask);
> > +       }
> > +}
> > +
> > +static void table_instance_remove(struct flow_table *table, struct
> > sw_flow *flow)
> > +{
> > +       struct table_instance *ti = ovsl_dereference(table->ti);
> > +       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> > +
> > +       BUG_ON(table->count == 0);
> > +       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
> > +       table->count--;
> > +       if (ovs_identifier_is_ufid(&flow->id)) {
> > +               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
> > +               table->ufid_count--;
> > +       }
> > +
> > +       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
> > +        * accessible as long as the RCU read lock is held.
> > +        */
> > +       flow_mask_remove(table, flow->mask);
> > +}
> > +
> > +static void table_instance_destroy(struct flow_table *table,
> >                                    bool deferred)
> >  {
> > +       struct table_instance *ti = ovsl_dereference(table->ti);
> > +       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> >         int i;
> >
> >         if (!ti)
> > @@ -274,13 +339,9 @@ static void table_instance_destroy(struct
> > table_instance *ti,
> >                 struct sw_flow *flow;
> >                 struct hlist_head *head = &ti->buckets[i];
> >                 struct hlist_node *n;
> > -               int ver = ti->node_ver;
> > -               int ufid_ver = ufid_ti->node_ver;
> >
> > -               hlist_for_each_entry_safe(flow, n, head, flow_table.node[ver]) {
> > -                       hlist_del_rcu(&flow->flow_table.node[ver]);
> > -                       if (ovs_identifier_is_ufid(&flow->id))
> > -                               hlist_del_rcu(&flow->ufid_table.node[ufid_ver]);
> > +               hlist_for_each_entry_safe(flow, n, head,
> > flow_table.node[ti->node_ver]) {
> > +                       table_instance_remove(table, flow);
> >                         ovs_flow_free(flow, deferred);
> >                 }
> >         }
> > @@ -300,12 +361,9 @@ static void table_instance_destroy(struct
> > table_instance *ti,
> >   */
> >  void ovs_flow_tbl_destroy(struct flow_table *table)
> >  {
> > -       struct table_instance *ti = rcu_dereference_raw(table->ti);
> > -       struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> > -
> >         free_percpu(table->mask_cache);
> >         kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> > -       table_instance_destroy(ti, ufid_ti, false);
> > +       table_instance_destroy(table, false);
> >  }
> >
> >  struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
> > @@ -400,10 +458,9 @@ static struct table_instance
> > *table_instance_rehash(struct table_instance *ti,
> >         return new_ti;
> >  }
> >
> > -int ovs_flow_tbl_flush(struct flow_table *flow_table)
> > +int ovs_flow_tbl_flush(struct flow_table *table)
> >  {
> > -       struct table_instance *old_ti, *new_ti;
> > -       struct table_instance *old_ufid_ti, *new_ufid_ti;
> > +       struct table_instance *new_ti, *new_ufid_ti;
> >
> >         new_ti = table_instance_alloc(TBL_MIN_BUCKETS);
> >         if (!new_ti)
> > @@ -412,16 +469,12 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
> >         if (!new_ufid_ti)
> >                 goto err_free_ti;
> >
> > -       old_ti = ovsl_dereference(flow_table->ti);
> > -       old_ufid_ti = ovsl_dereference(flow_table->ufid_ti);
> > +       table_instance_destroy(table, true);
> >
> This would destroy running table causing unnecessary flow miss. Lets
> keep current scheme of setting up new table before destroying current
> one.
>
> > -       rcu_assign_pointer(flow_table->ti, new_ti);
> > -       rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
> > -       flow_table->last_rehash = jiffies;
> > -       flow_table->count = 0;
> > -       flow_table->ufid_count = 0;
> > +       rcu_assign_pointer(table->ti, new_ti);
> > +       rcu_assign_pointer(table->ufid_ti, new_ufid_ti);
> > +       table->last_rehash = jiffies;
> >
> > -       table_instance_destroy(old_ti, old_ufid_ti, true);
> >         return 0;
> >
> >  err_free_ti:
> > @@ -700,69 +753,10 @@ static struct table_instance
> > *table_instance_expand(struct table_instance *ti,
> >         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
> >  }
> >
> > -static void tbl_mask_array_del_mask(struct flow_table *tbl,
> > -                                   struct sw_flow_mask *mask)
> > -{
> > -       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > -       int i, ma_count = READ_ONCE(ma->count);
> > -
> > -       /* Remove the deleted mask pointers from the array */
> > -       for (i = 0; i < ma_count; i++) {
> > -               if (mask == ovsl_dereference(ma->masks[i]))
> > -                       goto found;
> > -       }
> > -
> > -       BUG();
> > -       return;
> > -
> > -found:
> > -       WRITE_ONCE(ma->count, ma_count -1);
> > -
> > -       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
> > -       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
> > -
> > -       kfree_rcu(mask, rcu);
> > -
> > -       /* Shrink the mask array if necessary. */
> > -       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> > -           ma_count <= (ma->max / 3))
> > -               tbl_mask_array_realloc(tbl, ma->max / 2);
> > -}
> > -
> > -/* Remove 'mask' from the mask list, if it is not needed any more. */
> > -static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
> > -{
> > -       if (mask) {
> > -               /* ovs-lock is required to protect mask-refcount and
> > -                * mask list.
> > -                */
> > -               ASSERT_OVSL();
> > -               BUG_ON(!mask->ref_count);
> > -               mask->ref_count--;
> > -
> > -               if (!mask->ref_count)
> > -                       tbl_mask_array_del_mask(tbl, mask);
> > -       }
> > -}
> > -
> >  /* Must be called with OVS mutex held. */
> >  void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
> >  {
> > -       struct table_instance *ti = ovsl_dereference(table->ti);
> > -       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> > -
> > -       BUG_ON(table->count == 0);
> > -       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
> > -       table->count--;
> > -       if (ovs_identifier_is_ufid(&flow->id)) {
> > -               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
> > -               table->ufid_count--;
> > -       }
> > -
> > -       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
> > -        * accessible as long as the RCU read lock is held.
> > -        */
> > -       flow_mask_remove(table, flow->mask);
> > +       table_instance_remove(table, flow);
> Can you just rename table_instance_remove() to ovs_flow_tbl_remove()?

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 5df5182..4871ab8 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -210,6 +210,74 @@ static int tbl_mask_array_realloc(struct
flow_table *tbl, int size)
        return 0;
 }

+static int tbl_mask_array_add_mask(struct flow_table *tbl,
+                                  struct sw_flow_mask *new)
+{
+       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+       int err, ma_count = READ_ONCE(ma->count);
+
+       if (ma_count >= ma->max) {
+               err = tbl_mask_array_realloc(tbl, ma->max +
+                                             MASK_ARRAY_SIZE_MIN);
+               if (err)
+                       return err;
+
+               ma = ovsl_dereference(tbl->mask_array);
+       }
+
+       BUG_ON(ovsl_dereference(ma->masks[ma_count]));
+
+       rcu_assign_pointer(ma->masks[ma_count], new);
+       WRITE_ONCE(ma->count, ma_count +1);
+
+       return 0;
+}
+
+static void tbl_mask_array_del_mask(struct flow_table *tbl,
+                                   struct sw_flow_mask *mask)
+{
+       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+       int i, ma_count = READ_ONCE(ma->count);
+
+       /* Remove the deleted mask pointers from the array */
+       for (i = 0; i < ma_count; i++) {
+               if (mask == ovsl_dereference(ma->masks[i]))
+                       goto found;
+       }
+
+       BUG();
+       return;
+
+found:
+       WRITE_ONCE(ma->count, ma_count -1);
+
+       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
+       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
+
+       kfree_rcu(mask, rcu);
+
+       /* Shrink the mask array if necessary. */
+       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+           ma_count <= (ma->max / 3))
+               tbl_mask_array_realloc(tbl, ma->max / 2);
+}
+
+/* Remove 'mask' from the mask list, if it is not needed any more. */
+static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
+{
+       if (mask) {
+               /* ovs-lock is required to protect mask-refcount and
+                * mask list.
+                */
+               ASSERT_OVSL();
+               BUG_ON(!mask->ref_count);
+               mask->ref_count--;
+
+               if (!mask->ref_count)
+                       tbl_mask_array_del_mask(tbl, mask);
+       }
+}
+
 int ovs_flow_tbl_init(struct flow_table *table)
 {
        struct table_instance *ti, *ufid_ti;
@@ -257,7 +325,28 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
        __table_instance_destroy(ti);
 }

-static void table_instance_destroy(struct table_instance *ti,
+static void table_instance_remove(struct flow_table *table,
+                                 struct table_instance *ti,
+                                 struct table_instance *ufid_ti,
+                                 struct sw_flow *flow,
+                                 bool count)
+{
+       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
+       if (count)
+               table->count--;
+
+       if (ovs_identifier_is_ufid(&flow->id)) {
+               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
+
+               if (count)
+                       table->ufid_count--;
+       }
+
+       flow_mask_remove(table, flow->mask);
+}
+
+static void table_instance_destroy(struct flow_table *table,
+                                  struct table_instance *ti,
                                   struct table_instance *ufid_ti,
                                   bool deferred)
 {
@@ -274,13 +363,11 @@ static void table_instance_destroy(struct
table_instance *ti,
                struct sw_flow *flow;
                struct hlist_head *head = &ti->buckets[i];
                struct hlist_node *n;
-               int ver = ti->node_ver;
-               int ufid_ver = ufid_ti->node_ver;

-               hlist_for_each_entry_safe(flow, n, head, flow_table.node[ver]) {
-                       hlist_del_rcu(&flow->flow_table.node[ver]);
-                       if (ovs_identifier_is_ufid(&flow->id))
-                               hlist_del_rcu(&flow->ufid_table.node[ufid_ver]);
+               hlist_for_each_entry_safe(flow, n, head,
+                                         flow_table.node[ti->node_ver]) {
+
+                       table_instance_remove(table, ti, ufid_ti, flow, false);
                        ovs_flow_free(flow, deferred);
                }
        }
@@ -305,7 +392,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)

        free_percpu(table->mask_cache);
        kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
-       table_instance_destroy(ti, ufid_ti, false);
+       table_instance_destroy(table, ti, ufid_ti, false);
 }

 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
@@ -421,7 +508,7 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
        flow_table->count = 0;
        flow_table->ufid_count = 0;

-       table_instance_destroy(old_ti, old_ufid_ti, true);
+       table_instance_destroy(flow_table, old_ti, old_ufid_ti, true);
        return 0;

 err_free_ti:
@@ -700,51 +787,6 @@ static struct table_instance
*table_instance_expand(struct table_instance *ti,
        return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }

-static void tbl_mask_array_del_mask(struct flow_table *tbl,
-                                   struct sw_flow_mask *mask)
-{
-       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
-       int i, ma_count = READ_ONCE(ma->count);
-
-       /* Remove the deleted mask pointers from the array */
-       for (i = 0; i < ma_count; i++) {
-               if (mask == ovsl_dereference(ma->masks[i]))
-                       goto found;
-       }
-
-       BUG();
-       return;
-
-found:
-       WRITE_ONCE(ma->count, ma_count -1);
-
-       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
-       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
-
-       kfree_rcu(mask, rcu);
-
-       /* Shrink the mask array if necessary. */
-       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
-           ma_count <= (ma->max / 3))
-               tbl_mask_array_realloc(tbl, ma->max / 2);
-}
-
-/* Remove 'mask' from the mask list, if it is not needed any more. */
-static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
-{
-       if (mask) {
-               /* ovs-lock is required to protect mask-refcount and
-                * mask list.
-                */
-               ASSERT_OVSL();
-               BUG_ON(!mask->ref_count);
-               mask->ref_count--;
-
-               if (!mask->ref_count)
-                       tbl_mask_array_del_mask(tbl, mask);
-       }
-}
-
 /* Must be called with OVS mutex held. */
 void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 {
@@ -752,17 +794,7 @@ void ovs_flow_tbl_remove(struct flow_table
*table, struct sw_flow *flow)
        struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);

        BUG_ON(table->count == 0);
-       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
-       table->count--;
-       if (ovs_identifier_is_ufid(&flow->id)) {
-               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
-               table->ufid_count--;
-       }
-
-       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
-        * accessible as long as the RCU read lock is held.
-        */
-       flow_mask_remove(table, flow->mask);
+       table_instance_remove(table, ti, ufid_ti, flow, true);
 }

 static struct sw_flow_mask *mask_alloc(void)
@@ -805,29 +837,6 @@ static struct sw_flow_mask *flow_mask_find(const
struct flow_table *tbl,
        return NULL;
 }

-static int tbl_mask_array_add_mask(struct flow_table *tbl,
-                                  struct sw_flow_mask *new)
-{
-       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
-       int err, ma_count = READ_ONCE(ma->count);
-
-       if (ma_count >= ma->max) {
-               err = tbl_mask_array_realloc(tbl, ma->max +
-                                             MASK_ARRAY_SIZE_MIN);
-               if (err)
-                       return err;
-
-               ma = ovsl_dereference(tbl->mask_array);
-       }
-
-       BUG_ON(ovsl_dereference(ma->masks[ma_count]));
-
-       rcu_assign_pointer(ma->masks[ma_count], new);
-       WRITE_ONCE(ma->count, ma_count +1);
-
-       return 0;
-}
-
 /* Add 'mask' into the mask list, if it is not already there. */
 static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
                            const struct sw_flow_mask *new)
