Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA4D401AB8
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 13:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbhIFLqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 07:46:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238683AbhIFLqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 07:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630928749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FD68V5/mIZyw6+xqFrXs0v7DkrCCsMsknSF1z9hZHDc=;
        b=DLj08bwhOlzzzSWL79Hj36hOLSoEGUwXbKu7XmU7ZRohua0+H+/K48I6nX77yOwmlzEPnG
        kY0aXomXhybbKJeVujdk6pu3uxCJ50P/s0CTuIZb5PerbA4aQdSh5D90d3CtTNLSWbcGJa
        UKiMYzn/QShUuoF1GN6Aqb9ZGUNRC3s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-MKibeZu5NWamKxJtrDIwyQ-1; Mon, 06 Sep 2021 07:45:48 -0400
X-MC-Unique: MKibeZu5NWamKxJtrDIwyQ-1
Received: by mail-ed1-f71.google.com with SMTP id w18-20020aa7cb52000000b003c95870200fso3420651edt.16
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 04:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FD68V5/mIZyw6+xqFrXs0v7DkrCCsMsknSF1z9hZHDc=;
        b=p7P+eUCcmT6MZOQy7gZB3Z+X8mE0Rfm0h2xjxEnaDhK7Q8GSp9NlSstcT0rRrtWXv0
         0sYRTlpHv//RMf0gEbSiKPBrT+l2SzX6/z0Ii5zTJd2O9qWcWcJWG5RZ4yt0S2ruJ0/H
         cOtIi8BeyIFNYGRkMu0lWIDyOCrlxBGo/CAlc2dl2nwkmAlJQJR3m5Glr8kFA2iyEG6C
         K8RXdZwMD2KzCj/Dh+4EDNpB3sKzs/vSV8CxUmjE4ds5SWEYQ/OVG21Wnbqwr8pl/4Nw
         MDg7jXFv18j4rJ7c2X6XXvsFR4/fmi9LLs3PhxIVofJoHgr9TUJ3ixHqn91mcCzH/9lr
         TJAQ==
X-Gm-Message-State: AOAM533921XCQMGupCD58Gh19YDDu1k3ZCifmqHDSkt2M00KVJpXtGV5
        ClenZcWc0T69ExCXLGzpuJ3lS3zAiBMUEEKDLyaWyPQEkmqvZrFZ7Zrm4YuS6srjjS3ks+s9qQa
        9GRResIDX0FqFB6TL
X-Received: by 2002:aa7:c5cb:: with SMTP id h11mr13094562eds.255.1630928746060;
        Mon, 06 Sep 2021 04:45:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRiM23jDm9wRkk6LQ5A09USsfHjsc69oq/+XQi954hhFssz+ZFE01x3Ag1TEC1myedjDBmvg==
X-Received: by 2002:aa7:c5cb:: with SMTP id h11mr13094459eds.255.1630928744621;
        Mon, 06 Sep 2021 04:45:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h22sm3738217eji.112.2021.09.06.04.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:45:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3C3D418022B; Mon,  6 Sep 2021 13:45:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
In-Reply-To: <CAM_iQpUhmYBvu7p_jdiYxxPLqMmo3EFfRPfEsciCypUpM58UnQ@mail.gmail.com>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <CAM_iQpUhmYBvu7p_jdiYxxPLqMmo3EFfRPfEsciCypUpM58UnQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 06 Sep 2021 13:45:38 +0200
Message-ID: <87fsuiq659.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, Sep 1, 2021 at 3:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> John Fastabend <john.fastabend@gmail.com> writes:
>>
>> > Cong Wang wrote:
>> >> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
>> >> > Please explain more on this.  What is currently missing
>> >> > to make qdisc in struct_ops possible?
>> >>
>> >> I think you misunderstand this point. The reason why I avoid it is
>> >> _not_ anything is missing, quite oppositely, it is because it requires
>> >> a lot of work to implement a Qdisc with struct_ops approach, literally
>> >> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
>> >> WIth current approach, programmers only need to implement two
>> >> eBPF programs (enqueue and dequeue).
>> >>
>> >> Thanks.
>> >
>> > Another idea. Rather than work with qdisc objects which creates all
>> > these issues with how to work with existing interfaces, filters, etc.
>> > Why not create an sk_buff map? Then this can be used from the existing
>> > egress/ingress hooks independent of the actual qdisc being used.
>>
>> I agree. In fact, I'm working on doing just this for XDP, and I see no
>> reason why the map type couldn't be reused for skbs as well. Doing it
>> this way has a couple of benefits:
>
> I do see a lot of reasons, for starters, struct skb_buff is very different
> from struct xdp_buff, any specialized map can not be reused. I guess you
> are using a generic one, how do you handle the refcnt at least for skb?

Well, you can't keep XDP frames and skbs in the same map instance, but
you can create a map type that can be instantiated to hold either type
and otherwise keep the same semantics. The map can just inc/dec the
refcnt as skbs are added/removed from it.

>> - It leaves more flexibility to BPF: want a simple FIFO queue? just
>>   implement that with a single queue map. Or do you want to build a full
>>   hierarchical queueing structure? Just instantiate as many queue maps
>>   as you need to achieve this. Etc.
>
> Please give an example without a queue. ;) Queue is too simple, show us
> something more useful please. How do you plan to re-implement EDT with
> just queues?

I'm using 'queue' as a shorthand for any queueing/scheduling algorithm
implementable by a qdisc. We need to cover them all, obviously, not just
FIFO queues (in fact I think we should actively be discouraging those,
but that's a different story :) )

For EDT it would be something like:

- On enqueue, stick frames into the map with a rank corresponding to
  their transmission time (the map implements the PIFO queue, just like
  your patch).

- (re-)arm a BPF timer to fire at the time of the next transmission
  event, and have that timer trigger interface TX.

The first bit is straight-forward, and that last bit needs a new helper
or something like it. For qdiscs I guess we could just expose
qdisc_watchdog()? For XDP we'd need something new...


>> - The behaviour is defined entirely by BPF program behaviour, and does
>>   not require setting up a qdisc hierarchy in addition to writing BPF
>>   code.
>
> I have no idea why you call this a benefit, because my goal is to
> replace Qdisc's, not to replace any other things. You know there are
> plenty of Qdisc's which are not implemented in Linux kernel.

It's a benefit because it means you can keep everything together. I.e.,
you don't need to *both* write BPF code implementing your qdisc, *and* a
setup script to build the qdisc hierarchy. That simplifies deployment.

I suppose we could support inserting BPF qdiscs into a qdisc hierarchy
as well if needed. I don't personally see much use for that, but if
there's a use case, sure, why not?

>> - It should be possible to structure the hooks in a way that allows
>>   reusing queueing algorithm implementations between the qdisc and XDP
>>   layers.
>
> XDP has no skb but xdp_buff, no? And again, why only queues?

See above :)

-Toke

