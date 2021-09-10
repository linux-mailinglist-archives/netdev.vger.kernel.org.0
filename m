Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED56406AB9
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 13:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhIJLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 07:32:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232755AbhIJLcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 07:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631273466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MgZpunMwRsx/HKG8133Hqd4YNO163VRr9FdTYPCJcJM=;
        b=P74E7y1gpL7r4KNKz+KXHMUIVlgwezNdNADktQlf2bVp2DG3D1UoF5BWp2D0An6nCeEiWZ
        n9Hkw1cKeVsm/L1jq3QTGH4xqXRYS0qhLfE/uOmLmgz4F/Ahxt9qjqReiokaGnadsKgzID
        qu0BbpkNBXd3agG271MVnU+sPRGrHho=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-muyfqufYNHKFi_jc83fKuw-1; Fri, 10 Sep 2021 07:31:05 -0400
X-MC-Unique: muyfqufYNHKFi_jc83fKuw-1
Received: by mail-ed1-f71.google.com with SMTP id y21-20020a056402359500b003cd0257fc7fso758856edc.10
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 04:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MgZpunMwRsx/HKG8133Hqd4YNO163VRr9FdTYPCJcJM=;
        b=V7OPtRrlEh1eu1s7GZ/UqB9SozUT/qDfVBlMTWUaP4vIJKGO4UEWl5ycMLZ8sWo2ZY
         k1Nd9FnVboqa6ueSvkcYjrLnOif6A2qjkkcz2y2up3zaKHFtDEBSJKI/2mekJO3HhpbV
         oMfSv7LS1z/3qevmGkhyPjGJG+iGk99riXJiBFUyadFtVSlZ0VadeBllmsJDhaHiHpsk
         rIq0ylr7kGQdcVUQ/xcjT17OQUnX7NF/so1y/KyXJD/hf41idmfP0XWkWfUqBMzQggbf
         GmbOC6Tw/v6oMQVlQQF7MXihXYNcfVeUJI4Gscc7G2YWfwZ1D8fBK1MN7dF4gwLFiZ9g
         WkUA==
X-Gm-Message-State: AOAM531IjAw6mMQ8qBzwn0dITK4Z6NXIBGJ8VLkc3moprF9mqWLeAIsi
        RFMt5fqRY30sVyeO3DrpSq6zr2+FHHQE0nz2IQZGDR7xTvsWIETFrgd9/hQrX+lCPJm1ZffVdJI
        smDnLlvJNsPzn/ImH
X-Received: by 2002:aa7:c784:: with SMTP id n4mr8537980eds.99.1631273463941;
        Fri, 10 Sep 2021 04:31:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI5YrwS+0ERVHYZlZnF2Wl30iULHObEWf4EdeoOej/ES155Q+tOh54L26URfB6ln6yiRzjCg==
X-Received: by 2002:aa7:c784:: with SMTP id n4mr8537952eds.99.1631273463690;
        Fri, 10 Sep 2021 04:31:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j14sm2670239edk.7.2021.09.10.04.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 04:31:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 435371802C6; Fri, 10 Sep 2021 13:31:01 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
In-Reply-To: <20210910065535.vtwafxy2a7boipqg@kafai-mbp.dhcp.thefacebook.com>
References: <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk>
 <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
 <87bl5asjdj.fsf@toke.dk>
 <20210902233510.gnimg2krwwkzv4f2@kafai-mbp.dhcp.thefacebook.com>
 <87zgstra6j.fsf@toke.dk>
 <20210910065535.vtwafxy2a7boipqg@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Sep 2021 13:31:01 +0200
Message-ID: <87o890mzuy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Fri, Sep 03, 2021 at 04:44:04PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Martin KaFai Lau <kafai@fb.com> writes:
>>=20
>> > On Fri, Sep 03, 2021 at 12:27:52AM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> >> The question is if it's useful to provide the full struct_ops for
>> >> >> qdiscs? Having it would allow a BPF program to implement that inte=
rface
>> >> >> towards userspace (things like statistics, classes etc), but the
>> >> >> question is if anyone is going to bother with that given the wealt=
h of
>> >> >> BPF-specific introspection tools already available?
>> > Instead of bpftool can only introspect bpf qdisc and the existing tc
>> > can only introspect kernel qdisc,  it will be nice to have bpf
>> > qdisc work as other qdisc and showing details together with others
>> > in tc.  e.g. a bpf qdisc export its data/stats with its btf-id
>> > to tc and have tc print it out in a generic way?
>>=20
>> I'm not opposed to the idea, certainly. I just wonder if people who go
>> to the trouble of writing a custom qdisc in BPF will feel it's worth it
>> to do the extra work to make this available via a second API. We could
>> certainly encourage it, and some things are easy (drop and pkt counters,
>> etc), but other things (like class stats) will depend on the semantics
>> of the qdisc being implemented, so will require extra work from the BPF
>> qdisc developer...
> Right, different qdisc has different stats, I think it is currently
> stored in qdisc_priv()?  When a qdisc is created, a separate priv is
> created together.
>
> Yes, the bpf qdisc prog can store its stats to a bpf map, but then
> when the same prog attached to different qdiscs, it has to create
> different stats maps?

Hmm, yeah, I guess it would. But if it's storing the packets in a map it
would need to have separate instances of those as well. I was kinda
assuming that a separate instance of the BPF program would be loaded
into the kernel for each qdisc instance, with its own instance of all
maps etc.

> Also, instead of ->enqueue() itself is a bpf prog, having an
> ->enqueue() preparing a bpf ctx (zeroing, assigning...etc) and then
> make another call to a bpf prog will all add some costs.

Hmm, yeah, I guess, but I kinda doubt we can avoid having *some* kind of
setup to get the right semantics for the BPF program, which might as
well be in the qdisc enqueue() func. But let's see, happy to be proved
wrong on this :)

> That said, I still think it needs a bpf skb map that can queue/dequeue
> skb first.  Then it will become possible to prototype different interface
> ideas.

Agreed!

-Toke

