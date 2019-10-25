Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE65E458C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405768AbfJYIXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:23:43 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37438 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405677AbfJYIXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:23:42 -0400
Received: by mail-io1-f66.google.com with SMTP id 1so1447202iou.4
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 01:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+AkMK2g+khHwrVLkASmBpj3rO7UZC8MLQIZFzEo7Xj8=;
        b=1wy+Cc/n9C9TiAM1co+/vGES60ZHgF5t1X2oHliPsX69Rc+YzilBgC0lGDALB7lj/S
         dCHfpBnfU1GV5qtI8sucN9pkDCwATpygt4rE61izd3WIDZCSQ+3grvmPrKvZsJ5M2u5L
         HfQsqoOmnPhF1SNm/SMo2bl/YrxcnQmrFeRiE1hEEd8j9f8/fMCGXxAoj/l17CgDqnns
         lSQzbR0bQFdxCYp66zbjn+lXIM7tg7Dj0wMtx5ILm03ng+Pcgwmymigs9JtIECeXB1Eo
         RXqxb6JTw1c7+5y5VlNxRSF2p/mP+5rOlYOYvZBmFPWkGWWXvZ3UIvkc9jFjwhcOMAxq
         1uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+AkMK2g+khHwrVLkASmBpj3rO7UZC8MLQIZFzEo7Xj8=;
        b=Hei5LZrTQI10uDCxjkbS5YwitJUdO8ffsXj8nwyRUdNQEyO5aixdaV9gi5J3lZate+
         eZ1KaTHUJg3Ng0P1mx4whqCg/ajFwKPy6Dicafk7dwSTh6tYQkBsOL8P0fPMPtS3q6rz
         SS1Gh+WuGBeXlC9XTKw06ba8m6dzP2M1UsI/6S/X+PIlS/mo3uxMDROFjzntHGsrwJFZ
         Gs++F5SQrHyf4RLTfUrBimqXPpksDHJ2O43TvJwKv1IvdsSW0n/ahiEURtupWCqbv0wa
         n4gBViHmWAGb7nLFzg3eWe0hoIba5VITFlANeHLNvJ1Z9/EwH6Dm+vB1P5wfr9fpo+7r
         a/Fw==
X-Gm-Message-State: APjAAAV3mgvUe5VviAzF89aw/9mYOiZp0RvOcFc4YHHoPWrdPuFzl6B4
        78FfgU7FjUOYPQz1Nh9prxWMxjXqc/332QK4vNeEOw==
X-Google-Smtp-Source: APXvYqwTgBpvAfHaFpJLFpPgz3jA5peGQKDipKyWOmfXI29RrZJCnjdabPs5sHy44Xv2HmTn4uAVIjyuTEBKg6ZpmiU=
X-Received: by 2002:a5d:9ecc:: with SMTP id a12mr2412913ioe.195.1571991819782;
 Fri, 25 Oct 2019 01:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <1571914887-1364-1-git-send-email-john.hurley@netronome.com>
 <vbfr2326la0.fsf@mellanox.com> <CAK+XE=mvAjBYKpqGnraxk=B5axAgTDoN3mntsne63g351nanug@mail.gmail.com>
 <vbfmudp715s.fsf@mellanox.com>
In-Reply-To: <vbfmudp715s.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 25 Oct 2019 09:23:28 +0100
Message-ID: <CAK+XE==ZSpGf-AjTcypqEe2NiFUHnSSr518vmVg_+ZRMf2CLVQ@mail.gmail.com>
Subject: Re: [RFC net-next 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 8:08 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Fri 25 Oct 2019 at 01:27, John Hurley <john.hurley@netronome.com> wrote:
> > On Thu, Oct 24, 2019 at 7:39 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >> On Thu 24 Oct 2019 at 14:01, John Hurley <john.hurley@netronome.com> wrote:
> >> > When a new filter is added to cls_api, the function
> >> > tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
> >> > determine if the tcf_proto is duplicated in the chain's hashtable. It then
> >> > creates a new entry or continues with an existing one. In cls_flower, this
> >> > allows the function fl_ht_insert_unque to determine if a filter is a
> >> > duplicate and reject appropriately, meaning that the duplicate will not be
> >> > passed to drivers via the offload hooks. However, when a tcf_proto is
> >> > destroyed it is removed from its chain before a hardware remove hook is
> >> > hit. This can lead to a race whereby the driver has not received the
> >> > remove message but duplicate flows can be accepted. This, in turn, can
> >> > lead to the offload driver receiving incorrect duplicate flows and out of
> >> > order add/delete messages.
> >> >
> >> > Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
> >> > hash table per block stores each unique chain/protocol/prio being
> >> > destroyed. This entry is only removed when the full destroy (and hardware
> >> > offload) has completed. If a new flow is being added with the same
> >> > identiers as a tc_proto being detroyed, then the add request is replayed
> >> > until the destroy is complete.
> >> >
> >> > Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
> >> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> >> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> >> > Reported-by: Louis Peens <louis.peens@netronome.com>
> >> > ---
> >>
> >> Hi John,
> >>
> >> Thanks again for doing this!
> >>
> >> >  include/net/sch_generic.h |   3 ++
> >> >  net/sched/cls_api.c       | 108 ++++++++++++++++++++++++++++++++++++++++++++--
> >> >  2 files changed, 107 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> >> > index 637548d..363d2de 100644
> >> > --- a/include/net/sch_generic.h
> >> > +++ b/include/net/sch_generic.h
> >> > @@ -414,6 +414,9 @@ struct tcf_block {
> >> >               struct list_head filter_chain_list;
> >> >       } chain0;
> >> >       struct rcu_head rcu;
> >> > +     struct rhashtable proto_destroy_ht;
> >> > +     struct rhashtable_params proto_destroy_ht_params;
> >> > +     struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
> >> >  };
> >> >
> >> >  #ifdef CONFIG_PROVE_LOCKING
> >> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> >> > index 8717c0b..7f7095a 100644
> >> > --- a/net/sched/cls_api.c
> >> > +++ b/net/sched/cls_api.c
> >> > @@ -47,6 +47,77 @@ static LIST_HEAD(tcf_proto_base);
> >> >  /* Protects list of registered TC modules. It is pure SMP lock. */
> >> >  static DEFINE_RWLOCK(cls_mod_lock);
> >> >
> >> > +struct tcf_destroy_proto {
> >> > +     struct destroy_key {
> >> > +             u32 chain_index;
> >> > +             u32 prio;
> >> > +             __be16 protocol;
> >> > +     } key;
> >> > +     struct rhash_head ht_node;
> >> > +};
> >> > +
> >> > +static const struct rhashtable_params destroy_ht_params = {
> >> > +     .key_offset = offsetof(struct tcf_destroy_proto, key),
> >> > +     .key_len = offsetofend(struct destroy_key, protocol),
> >> > +     .head_offset = offsetof(struct tcf_destroy_proto, ht_node),
> >> > +     .automatic_shrinking = true,
> >> > +};
> >> > +
> >> > +static void
> >> > +tcf_proto_signal_destroying(struct tcf_chain *chain, struct tcf_proto *tp)
> >> > +{
> >> > +     struct tcf_block *block = chain->block;
> >> > +     struct tcf_destroy_proto *entry;
> >> > +
> >> > +     entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> >>
> >> Did you consider putting tcf_proto instance itself into
> >> block->proto_destroy_ht? Might simplify the code since entry is
> >> destroyed together with tcf_proto by tcf_proto_destroy() anyway. If such
> >> approach is possible (I might be missing some obvious corner cases), it
> >> might also be a good idea to use old-good intrusive hash table from
> >> hashtable.h which will allow whole solution not to use dynamic memory
> >> allocation at all.
> >>
> >
> > Hi Vlad, thanks for the comments!
> > I don't think we can use the tcf_proto instance unfortunately.
> > The purpose of this is to detect the addition of a new tcf_proto when
> > one with the same identifiers is currently being destroyed.
> > Therefore, the (in process of being destroyed) tcf_proto could be out
> > of the chain table (so tcf_chain_tp_find will return NULL) but the
> > associated filters may still be in HW as the delete hook has yet to be
> > triggered.
> > This leads to the race in flower with adding filters to a new
> > tcf_proto when other duplicates have not been deleted etc. etc.
> > Using the 3 tuple identifier means we can detect these tcf_protos
> > irrespective of the chain table's current state.
>
> Yes, but I didn't propose to change hash table key. struct tcf_proto has
> access to all the fields of the 3 tuple: tp->chain->index, tp->prio,
> tp->protocol.
>

agh, with you now.
I agree that approach would simplify the code a bit.
Let me look at it and see if there are any potential issues

> >
> > On the hashtable front, the rhash seems more intuitive to me as we
> > really don't know how often or how many of these destroys will occur.
> > Is there any other reason you would want to move to hashtable bar
> > dynamic memory saves?
> > I may be missing something here and need to give it more thought.
>
> No major objections. Removing/creating tcf_proto instance is already
> quite heavy, so couple more allocations likely don't impact anything.
> Its just that currently tcf_proto_signal_destroying() fails silently, if
> it can't allocate entry. I guess this might cause the problem to
> reappear in high memory pressure situations and root cause will be
> unclear since such case doesn't cause any explicit errors or generate
> logs. Don't know how important it is in practice.
>

Yes, fair point.
I think I should at least add some sort of error checking or indicator here.
Thanks

> >
> >> > +     if (!entry)
> >> > +             return;
> >> > +
> >> > +     entry->key.chain_index = chain->index;
> >> > +     entry->key.prio = tp->prio;
> >> > +     entry->key.protocol = tp->protocol;
> >> > +
> >> > +     mutex_lock(&block->proto_destroy_lock);
> >> > +     /* If key already exists or lookup errors out then free new entry. */
> >> > +     if (rhashtable_lookup_get_insert_fast(&block->proto_destroy_ht,
> >> > +                                           &entry->ht_node,
> >> > +                                           block->proto_destroy_ht_params))
> >> > +             kfree(entry);
> >> > +     mutex_unlock(&block->proto_destroy_lock);
> >> > +}
> >> > +
> >> > +static struct tcf_destroy_proto *
> >> > +tcf_proto_lookup_destroying(struct tcf_block *block, u32 chain_idx, u32 prio,
> >> > +                         __be16 proto)
> >> > +{
> >> > +     struct destroy_key key;
> >> > +
> >> > +     key.chain_index = chain_idx;
> >> > +     key.prio = prio;
> >> > +     key.protocol = proto;
> >> > +
> >> > +     return rhashtable_lookup_fast(&block->proto_destroy_ht, &key,
> >> > +                                   block->proto_destroy_ht_params);
> >> > +}
> >> > +
> >> > +static void
> >> > +tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto *tp)
> >> > +{
> >> > +     struct tcf_block *block = chain->block;
> >> > +     struct tcf_destroy_proto *entry;
> >> > +
> >> > +     mutex_lock(&block->proto_destroy_lock);
> >> > +     entry = tcf_proto_lookup_destroying(block, chain->index, tp->prio,
> >> > +                                         tp->protocol);
> >> > +     if (entry) {
> >> > +             rhashtable_remove_fast(&block->proto_destroy_ht,
> >> > +                                    &entry->ht_node,
> >> > +                                    block->proto_destroy_ht_params);
> >> > +             kfree(entry);
> >> > +     }
> >> > +     mutex_unlock(&block->proto_destroy_lock);
> >> > +}
> >> > +
> >> >  /* Find classifier type by string name */
> >> >
> >> >  static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char *kind)
> >> > @@ -234,9 +305,11 @@ static void tcf_proto_get(struct tcf_proto *tp)
> >> >  static void tcf_chain_put(struct tcf_chain *chain);
> >> >
> >> >  static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
> >> > -                           struct netlink_ext_ack *extack)
> >> > +                           bool sig_destroy, struct netlink_ext_ack *extack)
> >> >  {
> >> >       tp->ops->destroy(tp, rtnl_held, extack);
> >> > +     if (sig_destroy)
> >> > +             tcf_proto_signal_destroyed(tp->chain, tp);
> >> >       tcf_chain_put(tp->chain);
> >> >       module_put(tp->ops->owner);
> >> >       kfree_rcu(tp, rcu);
> >> > @@ -246,7 +319,7 @@ static void tcf_proto_put(struct tcf_proto *tp, bool rtnl_held,
> >> >                         struct netlink_ext_ack *extack)
> >> >  {
> >> >       if (refcount_dec_and_test(&tp->refcnt))
> >> > -             tcf_proto_destroy(tp, rtnl_held, extack);
> >> > +             tcf_proto_destroy(tp, rtnl_held, true, extack);
> >> >  }
> >> >
> >> >  static int walker_check_empty(struct tcf_proto *tp, void *fh,
> >> > @@ -370,6 +443,8 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
> >> >  static void tcf_block_destroy(struct tcf_block *block)
> >> >  {
> >> >       mutex_destroy(&block->lock);
> >> > +     rhashtable_destroy(&block->proto_destroy_ht);
> >> > +     mutex_destroy(&block->proto_destroy_lock);
> >> >       kfree_rcu(block, rcu);
> >> >  }
> >> >
> >> > @@ -545,6 +620,12 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
> >> >
> >> >       mutex_lock(&chain->filter_chain_lock);
> >> >       tp = tcf_chain_dereference(chain->filter_chain, chain);
> >> > +     while (tp) {
> >> > +             tp_next = rcu_dereference_protected(tp->next, 1);
> >> > +             tcf_proto_signal_destroying(chain, tp);
> >> > +             tp = tp_next;
> >> > +     }
> >> > +     tp = tcf_chain_dereference(chain->filter_chain, chain);
> >> >       RCU_INIT_POINTER(chain->filter_chain, NULL);
> >> >       tcf_chain0_head_change(chain, NULL);
> >> >       chain->flushing = true;
> >> > @@ -857,6 +938,16 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
> >> >       /* Don't store q pointer for blocks which are shared */
> >> >       if (!tcf_block_shared(block))
> >> >               block->q = q;
> >> > +
> >> > +     block->proto_destroy_ht_params = destroy_ht_params;
> >> > +     if (rhashtable_init(&block->proto_destroy_ht,
> >> > +                         &block->proto_destroy_ht_params)) {
> >> > +             NL_SET_ERR_MSG(extack, "Failed to initialise block proto destroy hashtable");
> >> > +             kfree(block);
> >> > +             return ERR_PTR(-ENOMEM);
> >> > +     }
> >> > +     mutex_init(&block->proto_destroy_lock);
> >> > +
> >> >       return block;
> >> >  }
> >> >
> >> > @@ -1621,6 +1712,13 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
> >> >
> >> >       mutex_lock(&chain->filter_chain_lock);
> >> >
> >> > +     if (tcf_proto_lookup_destroying(chain->block, chain->index, prio,
> >> > +                                     protocol)) {
> >>
> >> Function tcf_proto_lookup_destroying() is called with
> >> block->proto_destroy_lock protection previously in the code. I assume it
> >> is also needed here.
> >>
> >
> > I think we are ok to avoid taking the lock here so I purposefully left
> > this out -  this helps as we are not delaying concurrent adds to
> > different chains/tcf_protos in the same block.
> > tcf_proto_lookup_destroying() uses rhashtable_lookup_fast() which
> > calls rcu_read_lock so should find the entry safely.
> > While the function returns the entry, we are not accessing it (which
> > would require locking), just checking for non-NULL.
>
> Makes sense, thanks.
>
> >
> >> > +             mutex_unlock(&chain->filter_chain_lock);
> >> > +             tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
> >> > +             return ERR_PTR(-EAGAIN);
> >> > +     }
> >> > +
> >> >       tp = tcf_chain_tp_find(chain, &chain_info,
> >> >                              protocol, prio, false);
> >> >       if (!tp)
> >> > @@ -1628,10 +1726,10 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
> >> >       mutex_unlock(&chain->filter_chain_lock);
> >> >
> >> >       if (tp) {
> >> > -             tcf_proto_destroy(tp_new, rtnl_held, NULL);
> >> > +             tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
> >> >               tp_new = tp;
> >> >       } else if (err) {
> >> > -             tcf_proto_destroy(tp_new, rtnl_held, NULL);
> >> > +             tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
> >> >               tp_new = ERR_PTR(err);
> >> >       }
> >> >
> >> > @@ -1669,6 +1767,7 @@ static void tcf_chain_tp_delete_empty(struct tcf_chain *chain,
> >> >               return;
> >> >       }
> >> >
> >> > +     tcf_proto_signal_destroying(chain, tp);
> >> >       next = tcf_chain_dereference(chain_info.next, chain);
> >> >       if (tp == chain->filter_chain)
> >> >               tcf_chain0_head_change(chain, next);
> >> > @@ -2188,6 +2287,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
> >> >               err = -EINVAL;
> >> >               goto errout_locked;
> >> >       } else if (t->tcm_handle == 0) {
> >> > +             tcf_proto_signal_destroying(chain, tp);
> >> >               tcf_chain_tp_remove(chain, &chain_info, tp);
> >> >               mutex_unlock(&chain->filter_chain_lock);
