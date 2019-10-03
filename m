Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397BDCA948
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404910AbfJCQkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:40:05 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37636 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392440AbfJCQkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:40:03 -0400
Received: by mail-io1-f65.google.com with SMTP id b19so7100540iob.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qMQ79L19zLA8+V2V5SAkp5Lpb5k/cMQIg/SGtpo1q78=;
        b=SSFstXAiynmwZ1zCN6oK1iqyFF9NudIbBxsHQOnWOl+5SV9S+hj03pEXRmxqRxe3Wc
         b4yt3qNA+DknhJFWQrWhNP6g4NYgZjBK6Thu+6vgYxvrn2EgzzcO8sepvHj6fStwaXFn
         9MQSWIPIHGtinq7BHd+PZu4YQ84hcTWdFUkh8kMS2ZqQZ4eDr1Zvu7E3HqlmwT7pIDct
         DwtfBNhF0F/+ZCa7x5htYhOg3/z++ve9lCZW86n21yzUkGet8uw+76EyGsL+nmrfIJSZ
         2Xuv2L7KIiGw80bsImYoNcRtQjBVZQ6e8tVjsVzf8zVCWUp6YqAQmlE+Uh7CdnF2I2xF
         /wRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qMQ79L19zLA8+V2V5SAkp5Lpb5k/cMQIg/SGtpo1q78=;
        b=BO3X6+mAYuPHJq52V0S1RmOz4K1HsLYk62eiw3OpPSb9CqaCU7zRbRYqRTKO+tleSS
         FityIvwwSS7GhSQJwZ7ubl4LHkzHzNPb4ySBtdktRlEiIyJQvjhPNnLwB5tVJe84A9+c
         d0sYhR/kM53rvXSGtDP6BWhYa8lxB4wIqGhbyagMweUhGxM1n+S5H/XPQD9s7QWITrA4
         yoAgQdwQ63NY5pCQ7aCynYzDVbokFSwgI9tyrFGZqOThw4tvCo9YIW58uRC2iWZ9xn4x
         gD86cNKqlv0wvL/VKxrmP/z+DzUZR0vVdKzfcIwSi/d6XON7TseLTaIT7fCwVBe/KfCo
         ioNQ==
X-Gm-Message-State: APjAAAWuMjiJjE30kenD4dB+NjEvbXM3l7FwBL3KvGh3UWl34lSmC7lh
        F3/6DTVALpSpWhrFTKdaAM5RP6FYrc5aG3NsoKDoow==
X-Google-Smtp-Source: APXvYqy5pZqpxuhyF7GbiBdqtlLtJuN/El7hdB274V6kjHgykrijcD5aAhWarngfQ4mJ+8OjwcGv7ydx6ammqjoYVCM=
X-Received: by 2002:a5e:8c15:: with SMTP id n21mr8720849ioj.246.1570120801923;
 Thu, 03 Oct 2019 09:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
 <1570058072-12004-3-git-send-email-john.hurley@netronome.com> <vbflfu1olaj.fsf@mellanox.com>
In-Reply-To: <vbflfu1olaj.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Thu, 3 Oct 2019 17:39:51 +0100
Message-ID: <CAK+XE=kKyfrm8Zf1j5YqA0Bz_S9j9=_xR0p4c_n-QyUPddE2pA@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: sched: fix tp destroy race conditions in flower
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 5:18 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wrote:
> > Flower has rule HW offload functions available that drivers can choose to
> > register for. For the deletion case, these are triggered after filters
> > have been removed from lookup tables both at the flower level, and the
> > higher cls_api level. With flower running without RTNL locking, this can
> > lead to races where HW offload messages get out of order.
> >
> > Ensure HW offloads stay in line with the kernel tables by triggering
> > the sending of messages before the kernel processing is completed. For
> > destroyed tcf_protos, do this at the new pre_destroy hook. Similarly, if
> > a filter is being added, check that it is not concurrently being deleted
> > before offloading to hw, rather than the current approach of offloading,
> > then checking and reversing the offload if required.
> >
> > Fixes: 1d965c4def07 ("Refactor flower classifier to remove dependency on rtnl lock")
> > Fixes: 272ffaadeb3e ("net: sched: flower: handle concurrent tcf proto deletion")
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > Reported-by: Louis Peens <louis.peens@netronome.com>
> > ---
> >  net/sched/cls_flower.c | 55 +++++++++++++++++++++++++++-----------------------
> >  1 file changed, 30 insertions(+), 25 deletions(-)
> >
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index 74221e3..3ac47b5 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -513,13 +513,16 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
> >  }
> >
> >  static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
> > -                    bool *last, bool rtnl_held,
> > +                    bool *last, bool rtnl_held, bool do_hw,
> >                      struct netlink_ext_ack *extack)
> >  {
> >       struct cls_fl_head *head = fl_head_dereference(tp);
> >
> >       *last = false;
> >
> > +     if (do_hw && !tc_skip_hw(f->flags))
> > +             fl_hw_destroy_filter(tp, f, rtnl_held, extack);
> > +
> >       spin_lock(&tp->lock);
> >       if (f->deleted) {
> >               spin_unlock(&tp->lock);
> > @@ -534,8 +537,6 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
> >       spin_unlock(&tp->lock);
> >
> >       *last = fl_mask_put(head, f->mask);
> > -     if (!tc_skip_hw(f->flags))
> > -             fl_hw_destroy_filter(tp, f, rtnl_held, extack);
> >       tcf_unbind_filter(tp, &f->res);
> >       __fl_put(f);
> >
> > @@ -563,7 +564,7 @@ static void fl_destroy(struct tcf_proto *tp, bool rtnl_held,
> >
> >       list_for_each_entry_safe(mask, next_mask, &head->masks, list) {
> >               list_for_each_entry_safe(f, next, &mask->filters, list) {
> > -                     __fl_delete(tp, f, &last, rtnl_held, extack);
> > +                     __fl_delete(tp, f, &last, rtnl_held, false, extack);
> >                       if (last)
> >                               break;
> >               }
> > @@ -574,6 +575,19 @@ static void fl_destroy(struct tcf_proto *tp, bool rtnl_held,
> >       tcf_queue_work(&head->rwork, fl_destroy_sleepable);
> >  }
> >
> > +static void fl_pre_destroy(struct tcf_proto *tp, bool rtnl_held,
> > +                        struct netlink_ext_ack *extack)
> > +{
> > +     struct cls_fl_head *head = fl_head_dereference(tp);
> > +     struct fl_flow_mask *mask, *next_mask;
> > +     struct cls_fl_filter *f, *next;
> > +
> > +     list_for_each_entry_safe(mask, next_mask, &head->masks, list)
> > +             list_for_each_entry_safe(f, next, &mask->filters, list)
> > +                     if (!tc_skip_hw(f->flags))
> > +                             fl_hw_destroy_filter(tp, f, rtnl_held, extack);
> > +}
> > +
> >  static void fl_put(struct tcf_proto *tp, void *arg)
> >  {
> >       struct cls_fl_filter *f = arg;
> > @@ -1588,6 +1602,13 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> >       if (err)
> >               goto errout_mask;
> >
> > +     spin_lock(&tp->lock);
> > +     if (tp->deleting || (fold && fold->deleted)) {
> > +             err = -EAGAIN;
> > +             goto errout_lock;
> > +     }
> > +     spin_unlock(&tp->lock);
> > +
>
> But what if one of these flag are set after this block? It would be
> possible to insert dangling filters on tp that is being deleted, or
> double list_replace_rcu() and idr replace() if same filter is replaced
> concurrently, etc.
>

Hi Vlad, yes, I alluded to this in the cover letter - 'Note that there
are some issues that will need fixed in the RFC before it becomes a
patch such as potential races between releasing locks and re-taking
them.'
It is definitely an issue I'd need to think on more. Maybe mark the tp
as 'cant delete' in the first lock here or something. Although perhaps
this may just push the races to a different place.

> >       if (!tc_skip_hw(fnew->flags)) {
> >               err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
> >               if (err)
> > @@ -1598,22 +1619,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> >               fnew->flags |= TCA_CLS_FLAGS_NOT_IN_HW;
> >
> >       spin_lock(&tp->lock);
> > -
> > -     /* tp was deleted concurrently. -EAGAIN will cause caller to lookup
> > -      * proto again or create new one, if necessary.
> > -      */
> > -     if (tp->deleting) {
> > -             err = -EAGAIN;
> > -             goto errout_hw;
> > -     }
> > -
> >       if (fold) {
> > -             /* Fold filter was deleted concurrently. Retry lookup. */
> > -             if (fold->deleted) {
> > -                     err = -EAGAIN;
> > -                     goto errout_hw;
> > -             }
> > -
> >               fnew->handle = handle;
> >
> >               if (!in_ht) {
> > @@ -1624,7 +1630,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> >                                                    &fnew->ht_node,
> >                                                    params);
> >                       if (err)
> > -                             goto errout_hw;
> > +                             goto errout_lock;
> >                       in_ht = true;
> >               }
> >
> > @@ -1667,7 +1673,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> >                                           INT_MAX, GFP_ATOMIC);
> >               }
> >               if (err)
> > -                     goto errout_hw;
> > +                     goto errout_lock;
> >
> >               refcount_inc(&fnew->refcnt);
> >               fnew->handle = handle;
> > @@ -1683,11 +1689,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> >
> >  errout_ht:
> >       spin_lock(&tp->lock);
> > -errout_hw:
> > +errout_lock:
> >       fnew->deleted = true;
> >       spin_unlock(&tp->lock);
> > -     if (!tc_skip_hw(fnew->flags))
> > -             fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
> >       if (in_ht)
> >               rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
> >                                      fnew->mask->filter_ht_params);
> > @@ -1713,7 +1717,7 @@ static int fl_delete(struct tcf_proto *tp, void *arg, bool *last,
> >       bool last_on_mask;
> >       int err = 0;
> >
> > -     err = __fl_delete(tp, f, &last_on_mask, rtnl_held, extack);
> > +     err = __fl_delete(tp, f, &last_on_mask, rtnl_held, true, extack);
> >       *last = list_empty(&head->masks);
> >       __fl_put(f);
> >
> > @@ -2509,6 +2513,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
> >       .kind           = "flower",
> >       .classify       = fl_classify,
> >       .init           = fl_init,
> > +     .pre_destroy    = fl_pre_destroy,
> >       .destroy        = fl_destroy,
> >       .get            = fl_get,
> >       .put            = fl_put,
>
