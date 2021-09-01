Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EFC3FD7E2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhIAKnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236042AbhIAKnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:43:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630492929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ylLWjea9xm9l8vXltLGPLEQyUT5/ObE17rwxNz68/Lo=;
        b=EU2v7ckVO4lApfAluOQqthfVaMehHPnKrW0ZGDvOsoc34+CHWAZZuVWUdBNmI9GTtaCuUF
        Ip3CPBJZrG9fqT6pYIvrpvnlDEmOwbr9DLM6bnqXpeGLbczVU2EVnJjLxmLI9vh0XNqEwz
        HzeR4QAwEjHe9t+n6EenCeIWRO0tweU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-_wbvELiLOvauUdbdNJzfLQ-1; Wed, 01 Sep 2021 06:42:08 -0400
X-MC-Unique: _wbvELiLOvauUdbdNJzfLQ-1
Received: by mail-ej1-f69.google.com with SMTP id q19-20020a1709064cd3b02904c5f93c0124so1192033ejt.14
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ylLWjea9xm9l8vXltLGPLEQyUT5/ObE17rwxNz68/Lo=;
        b=gJ+ovnpZT9sm8dZen5D5ea0gWwkv16jBhjKTz94CZ9POliRRppXm3EyKpsYaMsNnum
         FZN00qwy6sNbo0Q9igaemZiXRIiOcdpkTnhn63dPN3b0Y1J3mwLyxXiXdn0HyJ6i90Cd
         QjA5u8PnXlhX7N998mwDBnNDGgPSP0ROFTFMJ+bPe9jkIQfwdvF0+dYA/ruEd3s0zwES
         S8NmcJiON++bysMsmSA2rGcEH/PY4ExZ3nlp7UOut/OWA9NJl2zih69wntUmAzslA+Ao
         rYLbJBExHvQZC0mnIjMi0uU+QgxuHiU9jBD/ib/5YPlEzEDxt0uPdovTdnX2wNmdwTOW
         9Qiw==
X-Gm-Message-State: AOAM531Nu2gYwl+gzMv5Mk2qrCiM4yb3qualBL5mrgWCILcqRO/V08vO
        4WSj7VaYxVf5ePXCpw0sJGwNlQMh4SDtHY13YY+612HCauFe2BGDiQhvZSoo1dc+87FSWfq9wV9
        +yGUxDlQVcrZsixWi
X-Received: by 2002:aa7:d303:: with SMTP id p3mr35205734edq.184.1630492926497;
        Wed, 01 Sep 2021 03:42:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzENHpT4hHuD6yibw7Jn0uczYDS8QbdS0pQ+oiQpD3G9ztZ+PedZLvTfOMVUd9pL4yx5Ce0xg==
X-Received: by 2002:aa7:d303:: with SMTP id p3mr35205666edq.184.1630492925442;
        Wed, 01 Sep 2021 03:42:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v13sm7036633ejx.72.2021.09.01.03.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:42:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C3EF01800EB; Wed,  1 Sep 2021 12:42:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
In-Reply-To: <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 01 Sep 2021 12:42:03 +0200
Message-ID: <871r68vapw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Cong Wang wrote:
>> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
>> > Please explain more on this.  What is currently missing
>> > to make qdisc in struct_ops possible?
>> 
>> I think you misunderstand this point. The reason why I avoid it is
>> _not_ anything is missing, quite oppositely, it is because it requires
>> a lot of work to implement a Qdisc with struct_ops approach, literally
>> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
>> WIth current approach, programmers only need to implement two
>> eBPF programs (enqueue and dequeue).
>> 
>> Thanks.
>
> Another idea. Rather than work with qdisc objects which creates all
> these issues with how to work with existing interfaces, filters, etc.
> Why not create an sk_buff map? Then this can be used from the existing
> egress/ingress hooks independent of the actual qdisc being used.

I agree. In fact, I'm working on doing just this for XDP, and I see no
reason why the map type couldn't be reused for skbs as well. Doing it
this way has a couple of benefits:

- It leaves more flexibility to BPF: want a simple FIFO queue? just
  implement that with a single queue map. Or do you want to build a full
  hierarchical queueing structure? Just instantiate as many queue maps
  as you need to achieve this. Etc.

- The behaviour is defined entirely by BPF program behaviour, and does
  not require setting up a qdisc hierarchy in addition to writing BPF
  code.

- It should be possible to structure the hooks in a way that allows
  reusing queueing algorithm implementations between the qdisc and XDP
  layers.

> You mention skb should not be exposed to userspace? Why? Whats the
> reason for this? Anyways we can make kernel only maps if we want or
> scrub the data before passing it to userspace. We do this already in
> some cases.

Yup, that's my approach as well.

> IMO it seems cleaner and more general to allow sk_buffs
> to be stored in maps and pulled back out later for enqueue/dequeue.

FWIW there's some gnarly details here (for instance, we need to make
sure the BPF program doesn't leak packet references after they are
dequeued from the map). My idea is to use a scheme similar to what we do
for XDP_REDIRECT, where a helper sets some hidden variables and doesn't
actually remove the packet from the queue until the BPF program exits
(so the kernel can make sure things are accounted correctly).

> I think one trick might be how to trigger the dequeue event on
> transition from stopped to running net_device or other events like
> this, but that could be solved with another program attached to
> those events to kick the dequeue logic.

This is actually easy in the qdisc case, I think: there's already a
qdisc_dequeue() operation, which just needs to execute a BPF program
that picks which packet to dequeue (by pulling it off a queue map). For
XDP we do need a new hook, on driver TX completion or something like
that. Details TBD. Also, we need a way to BPF to kick an idle interface
and make it start transmitting; that way we can implement a traffic
shaper (that delays packets) by using BPF timers :)

-Toke

