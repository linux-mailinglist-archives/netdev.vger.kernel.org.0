Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D421DF00B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgEVTd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730866AbgEVTd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:33:29 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E445BC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 12:33:28 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id i22so10248719oik.10
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 12:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZuECOtx3J77EAMXdn8Amlz7Lrsr5QoUpWlX5W2gc3M=;
        b=VwSsGWruYsu/KpDG3eAj7H57QaF6Yk6s2H+RJahEvFKnPhMRyP68cDoWU7Ksv8uSm6
         j9f5sgv7zJ8gHKyIZnDGJpK44Uqajewud/WyzabNnEXW7NADVhJP4ADsQcUwFVfawWGr
         F1jubI83yaetOPZpDTa4zWB3DfwVz9Exori2nXWURx6UGa+4CkvuRmpgHae7pLjsmyu7
         BWzrm5ISolwjcPco6+2VXoIjWHRIrukhGFXDKhm74d8xxmc8NhCWBnoyPYs8RdQwmuKp
         USzrRphEJ3LJg1LExJ5mOSFdOufDyuUEG2qOyXhi2JjF3j9x+sx7iWcAjdyXiMTVDUTX
         hcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZuECOtx3J77EAMXdn8Amlz7Lrsr5QoUpWlX5W2gc3M=;
        b=NcV0YG8uMXdyRxAZEuVGrcB2L3+HqNXnT7JZwtCQVCyz5t5vsLBG5qBlsnoVFKjABI
         UYTOs3KizMBzvDEslNqQiS6rLD/ZQLB6XXcqRoZj8v6ONE9h0yFq8+jd6sx7yLgFsIS7
         s6nY7+Qnku5izmxOl9lMG9/w1GrLAXykzoX5Ndwvukvt864Try09xSqvTj+JCqyNbvqq
         wmFD9s31kPfRxEYcCGoEVorfYB7UWsT18yLMLk+xSM037G+kgchWdsm1R5DYFw1qCIcL
         UQDfodh2/z+9T3w8nYbnfUu8Jo89C7KjXaM9CFDKwxoCxH1c8lt3kcQ8AiiQZ0809zaI
         6KkA==
X-Gm-Message-State: AOAM5304q+6VNclllymgYs62tzi5Oc6NwKBsqO1R5rk5gsla4ioQdmVN
        DsUBnDJ/QjfHZRUBd+bl2wD8Uz2N7CKyG/Rp2+o=
X-Google-Smtp-Source: ABdhPJwpVJfwEYanTVxZyKwOp6+d8m1474NVuhCDFC/K/5HCNw2W07ILuWLTvJulj/udWCqAs7Q9BahGcDajNZKnXAQ=
X-Received: by 2002:aca:c341:: with SMTP id t62mr3861464oif.5.1590176008210;
 Fri, 22 May 2020 12:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
 <vbfo8qkb8ip.fsf@mellanox.com> <CAM_iQpXqLdAJOcwyQ=DZs5zi=zEtr97_LT9uhPtTTPke=8Vvdw@mail.gmail.com>
 <vbfv9krvzkv.fsf@mellanox.com>
In-Reply-To: <vbfv9krvzkv.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 22 May 2020 12:33:17 -0700
Message-ID: <CAM_iQpVJ-MT0t1qtvWBp2=twPq6GWsn5-sAW6=QVf4Gc97Mmeg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:24 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Tue 19 May 2020 at 21:58, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Tue, May 19, 2020 at 2:04 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> >> I considered that approach initially but decided against it for
> >> following reasons:
> >>
> >> - Generic data is covered by current terse dump implementation.
> >>   Everything else will be act or cls specific which would result long
> >>   list of flag values like: TCA_DUMP_FLOWER_KEY_ETH_DST,
> >>   TCA_DUMP_FLOWER_KEY_ETH_DST, TCA_DUMP_FLOWER_KEY_VLAN_ID, ...,
> >>   TCA_DUMP_TUNNEL_KEY_ENC_KEY_ID, TCA_DUMP_TUNNEL_KEY_ENC_TOS. All of
> >>   these would require a lot of dedicated logic in act and cls dump
> >>   callbacks. Also, it would be quite a challenge to test all possible
> >>   combinations.
> >
> > Well, if you consider netlink dump as a database query, what Edward
> > proposed is merely "select COLUMN1 COLUMN2 from cls_db" rather
> > than "select * from cls_db".
> >
> > No one said it is easy to implement, it is just more elegant than you
> > select a hardcoded set of columns for the user.
>
> As I explained to Edward, having denser netlink packets with more
> filters per packet is only part of optimization. Another part is not
> executing some code at all. Consider fl_dump_key() which is 200 lines
> function with bunch of conditionals like that:
>
> static int fl_dump_key(struct sk_buff *skb, struct net *net,
>                        struct fl_flow_key *key, struct fl_flow_key *mask)
> {
>         if (mask->meta.ingress_ifindex) {
>                 struct net_device *dev;
>
>                 dev = __dev_get_by_index(net, key->meta.ingress_ifindex);
>                 if (dev && nla_put_string(skb, TCA_FLOWER_INDEV, dev->name))
>                         goto nla_put_failure;
>         }
>
>         if (fl_dump_key_val(skb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
>                             mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
>                             sizeof(key->eth.dst)) ||
>             fl_dump_key_val(skb, key->eth.src, TCA_FLOWER_KEY_ETH_SRC,
>                             mask->eth.src, TCA_FLOWER_KEY_ETH_SRC_MASK,
>                             sizeof(key->eth.src)) ||
>             fl_dump_key_val(skb, &key->basic.n_proto, TCA_FLOWER_KEY_ETH_TYPE,
>                             &mask->basic.n_proto, TCA_FLOWER_UNSPEC,
>                             sizeof(key->basic.n_proto)))
>                 goto nla_put_failure;
>
>         if (fl_dump_key_mpls(skb, &key->mpls, &mask->mpls))
>                 goto nla_put_failure;
>
>         if (fl_dump_key_vlan(skb, TCA_FLOWER_KEY_VLAN_ID,
>                              TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan, &mask->vlan))
>                 goto nla_put_failure;
>     ...
>
>
> Now imagine all of these are extended with additional if (flags &
> TCA_DUMP_XXX). All gains from not outputting some other minor stuff into
> netlink packet will be negated by it.

Interesting, are you saying a bit test is as expensive as appending
an actual netlink attribution to the dumping? I am surprised.


>
>
> >
> > Think about it, what if another user wants a less terse dump but still
> > not a full dump? Would you implement ops->terse_dump2()? Or
> > what if people still think your terse dump is not as terse as she wants?
> > ops->mini_dump()? How many ops's we would end having?
>
> User can discard whatever he doesn't need in user land code. The goal of
> this change is performance optimization, not designing a generic
> kernel-space data filtering mechanism.

You optimize the performance by reducing the dump size, which is
already effectively a data filtering. This doesn't have to be your goal,
you are implementing it anyway.


>
> >
> >
> >>
> >> - It is hard to come up with proper validation for such implementation.
> >>   In case of terse dump I just return an error if classifier doesn't
> >>   implement the callback (and since current implementation only outputs
> >>   generic action info, it doesn't even require support from
> >>   action-specific dump callbacks). But, for example, how do we validate
> >>   a case where user sets some flower and tunnel_key act dump flags from
> >>   previous paragraph, but Qdisc contains some other classifier? Or
> >>   flower classifier points to other types of actions? Or when flower
> >>   classifier has and tunnel_key actions but also mirred? Should the
> >
> > Each action should be able to dump selectively too. If you think it
> > as a database, it is just a different table with different schemas.
>
> How is designing custom SQL-like query language (according to your
> example at the beginning of the mail) for filter dump is going to
> improve performance? If there is a way to do it in fast a generic manner
> with BPF, then I'm very interested to hear the details. But adding
> hundred more hardcoded conditionals is just not a solution considering
> main motivations for this change is performance.

I still wonder how a bit test is as expensive as you claim, it does
not look like you actually measure it. This of course depends on the
size of the dump, but if you look at other netlink dump in kernel,
not just tc filters, we already dump a lot of attributes per record.

Thanks.
