Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07D53FF728
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhIBW3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:29:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239498AbhIBW2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630621676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dU50Em8L/3rwISxM8UhZTDS5RT6NS6Mf6nQKCXSeZ6U=;
        b=GhoH+cJbWxRJ7Bi64LlXzpyAfBP9mrS2S5nd2YS8D95ZYrUjdqQOerwKVQLlQfS2/ECHBZ
        K6G5ppt1w80H6D3d8GmDcq79trlp3oB4QDv2M8YVcbO2+PYeQPkRlUb4LBNTdGSrr1DfS6
        VMv9Wpza6WSlDU0JdWEknz3czi7cFz0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-OUTfZgOGP6uNYhhUIs6WrQ-1; Thu, 02 Sep 2021 18:27:55 -0400
X-MC-Unique: OUTfZgOGP6uNYhhUIs6WrQ-1
Received: by mail-ej1-f72.google.com with SMTP id bx10-20020a170906a1ca00b005c341820edeso1705166ejb.10
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 15:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dU50Em8L/3rwISxM8UhZTDS5RT6NS6Mf6nQKCXSeZ6U=;
        b=nohn/B85fT9RjkazGhkx7oEh3GRW6BNdQEbiV3EzHe+RVBRZYUDfR1pUrSPq9IyG87
         50hGKS0syo6s5f1NaP/8Sg46Xu5MjTBhhaBqzsxdUorbT/aG1CAhM++RcHVV8Ot4VBUd
         IqMHFMc0aLaxOcO26fAe6HmE/ksP7trjVIZiXmtMAuH0H4ds/3GCb61UL8xowox2GQkD
         i9aT3pmUtd3E2jPnEty9ziIhXaN3ETh16Ld40GHi4BbUkpnb9UtlRXoVn7J3cBPTZd+h
         QK6UQ6wWO9FyyT5g0LUh9iK7/BSljws8m6qpufulRGHHMLcBM+BPc6geZepYkluUhJuR
         MB/g==
X-Gm-Message-State: AOAM532q52ClggSInRXOSf/rKvl3EBe8O697BXVRqiqYUmrV3TSAZ5I8
        x5JDGzgRfH46YBnQZHZPnrpgO6yKpUvUXss4ln7HuOgIf/Ns8vHYEp7YgdbJViDqQ+9OaauuHc1
        7Q7ra5OxJN2BnsoyQ
X-Received: by 2002:a17:906:26c4:: with SMTP id u4mr437815ejc.511.1630621673811;
        Thu, 02 Sep 2021 15:27:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVs9SuGz83WFaQ8DLJiU+jUpq6uQD5VWykU7iHyTKNNCmeUToMMOnrorSTWEYLVSmLE0wc5Q==
X-Received: by 2002:a17:906:26c4:: with SMTP id u4mr437782ejc.511.1630621673478;
        Thu, 02 Sep 2021 15:27:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o3sm1749091eju.123.2021.09.02.15.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 15:27:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 283171800EB; Fri,  3 Sep 2021 00:27:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
In-Reply-To: <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk>
 <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Sep 2021 00:27:52 +0200
Message-ID: <87bl5asjdj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Martin KaFai Lau <kafai@fb.com> writes:
>>=20
>> > On Wed, Sep 01, 2021 at 12:42:03PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> John Fastabend <john.fastabend@gmail.com> writes:
>> >>=20
>> >> > Cong Wang wrote:
>> >> >> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wr=
ote:
>> >> >> > Please explain more on this.  What is currently missing
>> >> >> > to make qdisc in struct_ops possible?
>> >> >>=20
>> >> >> I think you misunderstand this point. The reason why I avoid it is
>> >> >> _not_ anything is missing, quite oppositely, it is because it requ=
ires
>> >> >> a lot of work to implement a Qdisc with struct_ops approach, liter=
ally
>> >> >> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
>> >> >> WIth current approach, programmers only need to implement two
>> >> >> eBPF programs (enqueue and dequeue).
>> > _if_ it is using as a qdisc object/interface,
>> > the patch "looks" easier because it obscures some of the ops/interface
>> > from the bpf user.  The user will eventually ask for more flexibility
>> > and then an on-par interface as the kernel's qdisc.  If there are some
>> > common 'ops', the common bpf code can be shared as a library in usersp=
ace
>> > or there is also kfunc call to call into the kernel implementation.
>> > For existing kernel qdisc author,  it will be easier to use the same
>> > interface also.
>>=20
>> The question is if it's useful to provide the full struct_ops for
>> qdiscs? Having it would allow a BPF program to implement that interface
>> towards userspace (things like statistics, classes etc), but the
>> question is if anyone is going to bother with that given the wealth of
>> BPF-specific introspection tools already available?
>
> If its a map value then you get all the goodness with normal map
> inspection.

Yup, exactly, so why bother with struct_ops to implement all the other
qdisc ops (apart from enqueue/dequeue)?

>> My hope is that we can (longer term) develop some higher-level tools to
>> express queueing policies that can then generate the BPF code needed to
>> implement them. Or as a start just some libraries to make this easier,
>> which I think is also what you're hinting at here? :)
>
> The P4 working group has thought about QOS and queuing from P4 side if
> you want to think in terms of a DSL. Might be interesting and have
> some benefits if you want to drop into hardware offload side. For example
> compile to XDP for fast CPU architectures, Altera/Xilinx backend for FPGA=
 or
> switch silicon for others. This was always the dream on my side maybe
> we've finally got close to actualizing it, 10 years later ;)

Yup, would love to see this! Let's just hope it doesn't take another
decade ;)

>> >> > Another idea. Rather than work with qdisc objects which creates all
>> >> > these issues with how to work with existing interfaces, filters, et=
c.
>> >> > Why not create an sk_buff map? Then this can be used from the exist=
ing
>> >> > egress/ingress hooks independent of the actual qdisc being used.
>> >>=20
>> >> I agree. In fact, I'm working on doing just this for XDP, and I see no
>> >> reason why the map type couldn't be reused for skbs as well. Doing it
>> >> this way has a couple of benefits:
>> >>=20
>> >> - It leaves more flexibility to BPF: want a simple FIFO queue? just
>> >>   implement that with a single queue map. Or do you want to build a f=
ull
>> >>   hierarchical queueing structure? Just instantiate as many queue maps
>> >>   as you need to achieve this. Etc.
>> > Agree.  Regardless how the interface may look like,
>> > I even think being able to queue/dequeue an skb into different bpf maps
>> > should be the first thing to do here.  Looking forward to your patches.
>>=20
>> Thanks! Guess I should go work on them, then :D
>
> Happy to review any RFCs.
>
>>=20
>> >> - The behaviour is defined entirely by BPF program behaviour, and does
>> >>   not require setting up a qdisc hierarchy in addition to writing BPF
>> >>   code.
>> > Interesting idea.  If it does not need to use the qdisc object/interfa=
ce
>> > and be able to do the qdisc hierarchy setup in a programmable way, it =
may
>> > be nice.  It will be useful for the future patches to come with some
>> > bpf prog examples to do that.
>>=20
>> Absolutely; we plan to include example algorithm implementations as well!
>
> A weighted round robin queue setup might be a useful example and easy
> to implement/understand, but slightly more interesting than a pfifo. Also
> would force understanding multiple cpus and timer issues.

Yup, some sort of RR queueing is definitely on the list!

>> >> - It should be possible to structure the hooks in a way that allows
>> >>   reusing queueing algorithm implementations between the qdisc and XDP
>> >>   layers.
>> >>=20
>> >> > You mention skb should not be exposed to userspace? Why? Whats the
>> >> > reason for this? Anyways we can make kernel only maps if we want or
>> >> > scrub the data before passing it to userspace. We do this already in
>> >> > some cases.
>> >>=20
>> >> Yup, that's my approach as well.
>
> Having something reported back to userspace as the value might be helpful
> for debugging/tracing. Maybe the skb->hash? Then you could set this and
> then track a skb through the stack even when its in a bpf skb queue.

Yeah. I've just been using the pointer value for my initial testing.
That's not a good solution, of course, but having a visible identifier
would be neat. skb->hash makes sense for the qdisc layer, but not for
XDP...

>> >>=20
>> >> > IMO it seems cleaner and more general to allow sk_buffs
>> >> > to be stored in maps and pulled back out later for enqueue/dequeue.
>> >>=20
>> >> FWIW there's some gnarly details here (for instance, we need to make
>> >> sure the BPF program doesn't leak packet references after they are
>> >> dequeued from the map). My idea is to use a scheme similar to what we=
 do
>> >> for XDP_REDIRECT, where a helper sets some hidden variables and doesn=
't
>> >> actually remove the packet from the queue until the BPF program exits
>> >> (so the kernel can make sure things are accounted correctly).
>> > The verifier is tracking the sk's references.  Can it be reused to
>> > track the skb's reference?
>>=20
>> I was vaguely aware that it does this, but have not looked at the
>> details. Would be great if this was possible; will see how far I get
>> with it, and iterate from there (with your help, hopefully :))
>
> Also might need to drop any socket references from the networking side
> so an enqueued sock can't hold a socket open.

Not sure I'm following you here?

-Toke

