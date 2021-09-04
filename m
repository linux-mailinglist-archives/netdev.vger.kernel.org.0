Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEFF4008E5
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 03:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbhIDBHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 21:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhIDBHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 21:07:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD09C061575;
        Fri,  3 Sep 2021 18:06:06 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e7so703781pgk.2;
        Fri, 03 Sep 2021 18:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=URtXbERcX1hFldPCxGbUfIs7DpN4XapqZNG7PJb51qU=;
        b=ABSVh68UpEHDM9hWM950OfMcSFVrXeoHC8C7LCt0A/mopidcvdX7mlefMl3pmhc8S7
         fm7kbYOxM/SJ4kf50IENFVM6qrnjGs8UJAs8dUXj0w5FMR4cJnmjJ8nqHn/UtNJ2et10
         5UOQbptpqlZ/0FHgK8NwE/1YxL1tVsFcuxC6ayMr2DH3wDE3TqJENsiSAbQ60x9AQ6Cr
         1aEtdQUWdzlWXMh5ghlAz6nhOm6BfmM1+Z+VwVYh9S5f6MpOruoDjuIjSsFfjTxJEwy2
         08O/uzdrFEccfd6/crNEeDOWltjpRS5vhlrOrYcwweajfulb3XABNZn1uZXg8b/xhAP4
         NxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=URtXbERcX1hFldPCxGbUfIs7DpN4XapqZNG7PJb51qU=;
        b=b8jNZe96s4oUTl6gNh6t8VZ+Ry2UQpJ/4NSR5jTHvu8nsI6rrg5WTyHkza8GuboFFS
         jzIx27kzhwUnNX86OtsQMBYRhszyTK/jFAra257DSpwJkKvLjMSW5OfVdXRgLyj942d8
         M5dJNc1O5xj+JF+qTQ0fIWk2RhcWpePEjj3uZfjufmAvLk64Ob2vgA2I7c+HfwbXUxSV
         whz1G/VnxieOkEjkbI9kDnnegozTFC/vlKx4DEfi+osxQ8FPhdz011BYlphVDkMJ23h5
         EjssukrFp9aNUVZ0kjp3Ss6uy9qMY4B8M9r3yiH4HWdhw6dfV6sDArewZFMC5n0X+ZgQ
         cztA==
X-Gm-Message-State: AOAM530Tp6mxHhipMQEfzRZguMZt0JgI2dodqunvkr22HWcvwE5kXG9N
        ePfeVWxXOR7hxh6qjOIbtxuaswtmH64WbfxvFzk=
X-Google-Smtp-Source: ABdhPJzul0i99nZFoGmownCWnqYj4j+jCrS/0rCm8IZDIP4pSqVupSCGqBj8rewdVyLDo2iBR2ts3Dg9jRIWHV9aw5M=
X-Received: by 2002:a05:6a00:8c3:b0:3fd:4333:897 with SMTP id
 s3-20020a056a0008c300b003fd43330897mr1423583pfu.67.1630717566338; Fri, 03 Sep
 2021 18:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp> <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
In-Reply-To: <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 3 Sep 2021 18:05:55 -0700
Message-ID: <CAM_iQpUSJ=QRdjwo-0DG4O1MRkhu8k1yQQx2KM_UhPp=bkeOeA@mail.gmail.com>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 10:45 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > Please explain more on this.  What is currently missing
> > > to make qdisc in struct_ops possible?
> >
> > I think you misunderstand this point. The reason why I avoid it is
> > _not_ anything is missing, quite oppositely, it is because it requires
> > a lot of work to implement a Qdisc with struct_ops approach, literally
> > all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
> > WIth current approach, programmers only need to implement two
> > eBPF programs (enqueue and dequeue).
> >
> > Thanks.
>
> Another idea. Rather than work with qdisc objects which creates all
> these issues with how to work with existing interfaces, filters, etc.
> Why not create an sk_buff map? Then this can be used from the existing
> egress/ingress hooks independent of the actual qdisc being used.

Because it is pointless to expose them to user-space in this context.
For example, what is the point of dropping a packet from user-space
in the context of Qdisc?

And I don't think there is a way for user-space to read those skb's inside
a map, which makes it more pointless.

>
> You mention skb should not be exposed to userspace? Why? Whats the
> reason for this? Anyways we can make kernel only maps if we want or
> scrub the data before passing it to userspace. We do this already in
> some cases.

I am not aware of any kernel-only map. For starters, we can't create
a map from kernel-space.

>
> IMO it seems cleaner and more general to allow sk_buffs
> to be stored in maps and pulled back out later for enqueue/dequeue.

Which exact map are you referring to? The queue map? It would only
provide FIFO. We want to give users as much freedom to order the
skbs as we can, I doubt hashmap could offer such freedom.

>
> I think one trick might be how to trigger the dequeue event on
> transition from stopped to running net_device or other events like
> this, but that could be solved with another program attached to
> those events to kick the dequeue logic.

I think we can still use current enqueue/dequeue eBPF program
except we need to transfer skb ownership and storage to map.

Thanks.
