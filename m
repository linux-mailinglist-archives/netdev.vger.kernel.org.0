Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1883F7BB6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242375AbhHYRuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbhHYRuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:50:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB992C061757;
        Wed, 25 Aug 2021 10:49:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id mf2so144811ejb.9;
        Wed, 25 Aug 2021 10:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcEebA36vr8enUaVJqJ/pvS0MfHmb+Qb5dVsVqdn6SI=;
        b=qeVnSVC2VFOawDIl4VJUnBt7I+eyjPHB6gI1dLk2vsVExMlaKKyzA58m08KnPF8P4+
         SO5XoQx7vublw6h1frTjJKNJde+DzlY+FbK75JqUHFKuvy3ba4+F4QesPe1G6ris4wBh
         551YS6jzbiyrfXjuNMG4GuNqYqkeiXwpW2UH2igIL2qiaPpT2hbmgPoh9//5rrHYra1N
         JOcCzqZiAV1HDAUfZhEbFY8gqJHo/SVeSsskfegBqwyqzXOZgTpfX4dQJDKxYJOE1i55
         xgJ5eD9jO+stEnziX+KkyZ4iOYn0tH8LU/NdnbENl+1tTDgTjPQ4hJNNDfc717uM1GHd
         Fzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcEebA36vr8enUaVJqJ/pvS0MfHmb+Qb5dVsVqdn6SI=;
        b=DIF38t9wmbIeuLN0eH+lfVdCu/6048aUxY4Ic9J9TskRC3bAyADy30RAw+pFHSmZJJ
         1jG2EbQofXqpxB1g/rOF1elnjtuXn66iGVJnpXorD2jeivxpbav6uQ4Xjo4KhflxTnb5
         F4BGwtIk/jihVzPVIiNfFp6NtqprlfkLKhQZ8z16BPcWaNi89nhfeNq+KhbmNRCgAfc+
         4gQgrTC2c3k4HQgRIDjr2Pe5iTkBq5JPz8eUBC3+y3XN40ikZMu7Sb1n/8IrZIjxfM52
         lpToaSZUrUNUXGzW+hxhmu9LOm0gmgVqRDyoOk1A1lnsccmJrp4To8BXoo5byv35wKk+
         FnNw==
X-Gm-Message-State: AOAM530AXoVZ2zXb95N2D0Qz/vn4azW0DXy122BLE3Qeod5Vjemsj4lk
        9pFxizEIK3r2CEECp6NDXSGdgq8q1hWhUyi0eRo=
X-Google-Smtp-Source: ABdhPJyXrmGoMw3Z7YelYdJMRHtsSgUSLbfBfB6xokDzz2dtvZt7EkW5Uf/nq+E04QPsbsGQahrrmv6ErdhszRt7Q08=
X-Received: by 2002:a17:906:b0b:: with SMTP id u11mr18606689ejg.458.1629913766413;
 Wed, 25 Aug 2021 10:49:26 -0700 (PDT)
MIME-Version: 1.0
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
 <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com> <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
 <1c12b056-79d2-126a-3f78-64629f072345@gmail.com> <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
 <bd90616e-8e86-016b-0979-c4f4167b8bc2@gmail.com> <4fe6edb4-a364-0e59-f902-9a362dd998d4@virtuozzo.com>
 <61da35a1-e609-02d5-609d-5228e184e43f@virtuozzo.com>
In-Reply-To: <61da35a1-e609-02d5-609d-5228e184e43f@virtuozzo.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Wed, 25 Aug 2021 10:49:15 -0700
Message-ID: <CALMXkpZYGC5HNkJAi4wCuawC-9CVNjN1LqO073YJvUF5ONwupA@mail.gmail.com>
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 10:22 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> On 8/24/21 11:50 AM, Vasily Averin wrote:
> > On 8/24/21 1:23 AM, Eric Dumazet wrote:
> >> On 8/23/21 2:51 PM, Eric Dumazet wrote:
> >>> On 8/23/21 2:45 PM, Eric Dumazet wrote:
> >>>> On 8/23/21 10:25 AM, Christoph Paasch wrote:
> >>>>> Hello,
> >>>>>
> >>>>> On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
> >>>>>>
> >>>>>> Christoph Paasch reports [1] about incorrect skb->truesize
> >>>>>> after skb_expand_head() call in ip6_xmit.
> >>>>>> This happen because skb_set_owner_w() for newly clone skb is called
> >>>>>> too early, before pskb_expand_head() where truesize is adjusted for
> >>>>>> (!skb-sk) case.
> >>>>>>
> >>>>>> [1] https://lkml.org/lkml/2021/8/20/1082
> >>>>>>
> >>>>>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> >>>>>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> >>>>>> ---
> >>>>>>  net/core/skbuff.c | 24 +++++++++++++-----------
> >>>>>>  1 file changed, 13 insertions(+), 11 deletions(-)
> >>>>>>
> >>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>>>> index f931176..508d5c4 100644
> >>>>>> --- a/net/core/skbuff.c
> >>>>>> +++ b/net/core/skbuff.c
> >>>>>> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
> >>>>>>
> >>>>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
> >>>>>>  {
> >>>>>> +       struct sk_buff *oskb = skb;
> >>>>>> +       struct sk_buff *nskb = NULL;
> >>>>>>         int delta = headroom - skb_headroom(skb);
> >>>>>>
> >>>>>>         if (WARN_ONCE(delta <= 0,
> >>>>>> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
> >>>>>>
> >>>>>>         /* pskb_expand_head() might crash, if skb is shared */
> >>>>>>         if (skb_shared(skb)) {
> >>>>>> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
> >>>>>> -
> >>>>>> -               if (likely(nskb)) {
> >>>>>> -                       if (skb->sk)
> >>>>>> -                               skb_set_owner_w(nskb, skb->sk);
> >>>>>> -                       consume_skb(skb);
> >>>>>> -               } else {
> >>>>>> -                       kfree_skb(skb);
> >>>>>> -               }
> >>>>>> +               nskb = skb_clone(skb, GFP_ATOMIC);
> >>>>>>                 skb = nskb;
> >>>>>>         }
> >>>>>>         if (skb &&
> >>>>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> >>>>>> -               kfree_skb(skb);
> >>>>>> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
> >>>>>>                 skb = NULL;
> >>>>>> +
> >>>>>> +       if (!skb) {
> >>>>>> +               kfree_skb(oskb);
> >>>>>> +               if (nskb)
> >>>>>> +                       kfree_skb(nskb);
> >>>>>> +       } else if (nskb) {
> >>>>>> +               if (oskb->sk)
> >>>>>> +                       skb_set_owner_w(nskb, oskb->sk);
> >>>>>> +               consume_skb(oskb);
> >>>>>
> >>>>> sorry, this does not fix the problem. The syzkaller repro still
> >>>>> triggers the WARN.
> >>>>>
> >>>>> When it happens, the skb in ip6_xmit() is not shared as it comes from
> >>>>> __tcp_transmit_skb, where it is skb_clone()'d.
> >>>>>
> >>>>>
> >>>>
> >>>> Old code (in skb_realloc_headroom())
> >>>> was first calling skb2 = skb_clone(skb, GFP_ATOMIC);
> >>>>
> >>>> At this point, skb2->sk was NULL
> >>>> So pskb_expand_head(skb2, SKB_DATA_ALIGN(delta), 0, ...) was able to tweak skb2->truesize
> >>>>
> >>>> I would try :
> >>>>
> >>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>> index f9311762cc475bd38d87c33e988d7c983b902e56..326749a8938637b044a616cc33b6a19ed191ac41 100644
> >>>> --- a/net/core/skbuff.c
> >>>> +++ b/net/core/skbuff.c
> >>>> @@ -1804,6 +1804,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
> >>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
> >>>>  {
> >>>>         int delta = headroom - skb_headroom(skb);
> >>>> +       struct sk_buff *oskb = NULL;
> >>>>
> >>>>         if (WARN_ONCE(delta <= 0,
> >>>>                       "%s is expecting an increase in the headroom", __func__))
> >>>> @@ -1813,19 +1814,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
> >>>>         if (skb_shared(skb)) {
> >>>>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
> >>>>
> >>>> -               if (likely(nskb)) {
> >>>> -                       if (skb->sk)
> >>>> -                               skb_set_owner_w(nskb, skb->sk);
> >>>> -                       consume_skb(skb);
> >>>> -               } else {
> >>>> +               if (unlikely(!nskb)) {
> >>>>                         kfree_skb(skb);
> >>>> +                       return NULL;
> >>>>                 }
> >>>> +               oskb = skb;
> >>>>                 skb = nskb;
> >>>>         }
> >>>> -       if (skb &&
> >>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> >>>> +       if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> >>>>                 kfree_skb(skb);
> >>>> -               skb = NULL;
> >>>> +               kfree_skb(oskb);
> >>>> +               return NULL;
> >>>> +       }
> >>>> +       if (oskb) {
> >>>> +               skb_set_owner_w(skb, oskb->sk);
> >>>> +               consume_skb(oskb);
> >>>>         }
> >>>>         return skb;
> >>>>  }
> >>>
> >>>
> >>> Oh well, probably not going to work.
> >>>
> >>> We have to find a way to properly increase skb->truesize, even if skb_clone() is _not_ called.
> >
> > Can we adjust truesize outside pskb_expand_head()?
> > Could you please explain why it can be not safe?
>
> Do you mean truesize change should not break balance of sk->sk_wmem_alloc?

AFAICS, that's the problem around adjusting truesize. So, maybe "just"
refcount_add the increase of the truesize.

The below does fix the syzkaller bug for me and seems to do the right
thing overall. But I honestly think that this is becoming too hacky
and not worth it... and who knows what other corner-cases this now
exposes...

Maybe a revert is a better course of action?

---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f9311762cc47..9cc18a0fdd1c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -71,6 +71,7 @@
 #include <net/mpls.h>
 #include <net/mptcp.h>
 #include <net/page_pool.h>
+#include <net/tcp.h>

 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -1756,9 +1757,14 @@ int pskb_expand_head(struct sk_buff *skb, int
nhead, int ntail,
  * For the moment, we really care of rx path, or
  * when skb is orphaned (not attached to a socket).
  */
- if (!skb->sk || skb->destructor == sock_edemux)
+ if (!skb->sk || skb->destructor == sock_edemux || skb->destructor ==
tcp_wfree) {
  skb->truesize += size - osize;

+ if (skb->sk && skb->destructor == tcp_wfree) {
+ refcount_add(size - osize, &skb->sk->sk_wmem_alloc);
+ }
+ }
+
  return 0;

 nofrags:
