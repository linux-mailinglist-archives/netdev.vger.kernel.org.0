Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93143FF50C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344384AbhIBUl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhIBUl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:41:57 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C068C061575;
        Thu,  2 Sep 2021 13:40:58 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z1so4221856ioh.7;
        Thu, 02 Sep 2021 13:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ok5omVsaNNUvb0c4sPlY1Y6livoKu49iy7zv9aZhIPw=;
        b=CHDF4W/NXwSxkr90HDgp1dVilUUJzLpor94XATBDQAqHQ8PaLIYy8Uv2P4MDEwmgpQ
         vlx4tvKgQBVDRbCxWgyn+B08+H4bq5VUjm8VlAsEVBdG6S/MkceR6OrhqMKgujl+IwdP
         1xatP5h0cN/e0C5tkg5JBvlk13O0hic9COemMaWGHlAIWOGHZz8T+4bays/AfJaX929R
         Va1tiI04Amil06EsK3ffzcAn3n1VNpWCzxe2Qk28LvBO4JGg9xqpUVDjZkUFce/jUeex
         RjOkuO87or4zQs3oJiTJTq9aKNqv4JeqHq20XuhOIgjw/5EZ0BRK//vQCVgXUySWotvS
         cdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ok5omVsaNNUvb0c4sPlY1Y6livoKu49iy7zv9aZhIPw=;
        b=ETw71ue+uXYLifPcxD4lmjhD/Mo4XpPMOnrqICDtvtQiI4eoijCDNfSzL7P5cPXp3c
         PWv4eq6/3SHylVkJMfUXeIqNOs/N4BSuMGb86e3NrcIkFmhGW4ut6y8slIiuCu322se+
         EemE3oF2IRSE4ZZ3DTSpHcfRMNqB0lhE/9OlOTv7x0zYDrC3g7qM9Qof7sGsfaK7TWoa
         7OwPz9Q/gtByn7Q4XSYCerDvsH2xQNoZHg5N7XUKL95pT4CLVTILB9FKVUvs24qbgPPf
         spvoBq60HoWyeNIW4+ndv7j7Mm0HHvzIOJEFpjo3J6z3gmV6Dbb0DdroQmHiaf27OEfE
         Y7yQ==
X-Gm-Message-State: AOAM533FmRBDAMLVrmvafoaq20cqxP37C0IS6nPj3EEWU8X8m2EL6r6W
        zK0gZh3OOcNZ93E0LPGlnBU=
X-Google-Smtp-Source: ABdhPJwJhvhQXIa0U6iDMRjJnMuOAw6T6Zz84ty0r6XPtAGMpr4YHhljRWdFaobQaKouMw9LeMJjgg==
X-Received: by 2002:a6b:296:: with SMTP id 144mr203739ioc.114.1630615257662;
        Thu, 02 Sep 2021 13:40:57 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id g12sm1492821iok.32.2021.09.02.13.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:40:57 -0700 (PDT)
Date:   Thu, 02 Sep 2021 13:40:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Message-ID: <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
In-Reply-To: <871r66ud8y.fsf@toke.dk>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> =

> > On Wed, Sep 01, 2021 at 12:42:03PM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> >> John Fastabend <john.fastabend@gmail.com> writes:
> >> =

> >> > Cong Wang wrote:
> >> >> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> w=
rote:
> >> >> > Please explain more on this.  What is currently missing
> >> >> > to make qdisc in struct_ops possible?
> >> >> =

> >> >> I think you misunderstand this point. The reason why I avoid it i=
s
> >> >> _not_ anything is missing, quite oppositely, it is because it req=
uires
> >> >> a lot of work to implement a Qdisc with struct_ops approach, lite=
rally
> >> >> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops=
).
> >> >> WIth current approach, programmers only need to implement two
> >> >> eBPF programs (enqueue and dequeue).
> > _if_ it is using as a qdisc object/interface,
> > the patch "looks" easier because it obscures some of the ops/interfac=
e
> > from the bpf user.  The user will eventually ask for more flexibility=

> > and then an on-par interface as the kernel's qdisc.  If there are som=
e
> > common 'ops', the common bpf code can be shared as a library in users=
pace
> > or there is also kfunc call to call into the kernel implementation.
> > For existing kernel qdisc author,  it will be easier to use the same
> > interface also.
> =

> The question is if it's useful to provide the full struct_ops for
> qdiscs? Having it would allow a BPF program to implement that interface=

> towards userspace (things like statistics, classes etc), but the
> question is if anyone is going to bother with that given the wealth of
> BPF-specific introspection tools already available?

If its a map value then you get all the goodness with normal map
inspection.

> =

> My hope is that we can (longer term) develop some higher-level tools to=

> express queueing policies that can then generate the BPF code needed to=

> implement them. Or as a start just some libraries to make this easier,
> which I think is also what you're hinting at here? :)

The P4 working group has thought about QOS and queuing from P4 side if
you want to think in terms of a DSL. Might be interesting and have
some benefits if you want to drop into hardware offload side. For example=

compile to XDP for fast CPU architectures, Altera/Xilinx backend for FPGA=
 or
switch silicon for others. This was always the dream on my side maybe
we've finally got close to actualizing it, 10 years later ;)

> =

> >> > Another idea. Rather than work with qdisc objects which creates al=
l
> >> > these issues with how to work with existing interfaces, filters, e=
tc.
> >> > Why not create an sk_buff map? Then this can be used from the exis=
ting
> >> > egress/ingress hooks independent of the actual qdisc being used.
> >> =

> >> I agree. In fact, I'm working on doing just this for XDP, and I see =
no
> >> reason why the map type couldn't be reused for skbs as well. Doing i=
t
> >> this way has a couple of benefits:
> >> =

> >> - It leaves more flexibility to BPF: want a simple FIFO queue? just
> >>   implement that with a single queue map. Or do you want to build a =
full
> >>   hierarchical queueing structure? Just instantiate as many queue ma=
ps
> >>   as you need to achieve this. Etc.
> > Agree.  Regardless how the interface may look like,
> > I even think being able to queue/dequeue an skb into different bpf ma=
ps
> > should be the first thing to do here.  Looking forward to your patche=
s.
> =

> Thanks! Guess I should go work on them, then :D

Happy to review any RFCs.

> =

> >> - The behaviour is defined entirely by BPF program behaviour, and do=
es
> >>   not require setting up a qdisc hierarchy in addition to writing BP=
F
> >>   code.
> > Interesting idea.  If it does not need to use the qdisc object/interf=
ace
> > and be able to do the qdisc hierarchy setup in a programmable way, it=
 may
> > be nice.  It will be useful for the future patches to come with some
> > bpf prog examples to do that.
> =

> Absolutely; we plan to include example algorithm implementations as wel=
l!

A weighted round robin queue setup might be a useful example and easy
to implement/understand, but slightly more interesting than a pfifo. Also=

would force understanding multiple cpus and timer issues.

> =

> >> - It should be possible to structure the hooks in a way that allows
> >>   reusing queueing algorithm implementations between the qdisc and X=
DP
> >>   layers.
> >> =

> >> > You mention skb should not be exposed to userspace? Why? Whats the=

> >> > reason for this? Anyways we can make kernel only maps if we want o=
r
> >> > scrub the data before passing it to userspace. We do this already =
in
> >> > some cases.
> >> =

> >> Yup, that's my approach as well.

Having something reported back to userspace as the value might be helpful=

for debugging/tracing. Maybe the skb->hash? Then you could set this and
then track a skb through the stack even when its in a bpf skb queue.

> >> =

> >> > IMO it seems cleaner and more general to allow sk_buffs
> >> > to be stored in maps and pulled back out later for enqueue/dequeue=
.
> >> =

> >> FWIW there's some gnarly details here (for instance, we need to make=

> >> sure the BPF program doesn't leak packet references after they are
> >> dequeued from the map). My idea is to use a scheme similar to what w=
e do
> >> for XDP_REDIRECT, where a helper sets some hidden variables and does=
n't
> >> actually remove the packet from the queue until the BPF program exit=
s
> >> (so the kernel can make sure things are accounted correctly).
> > The verifier is tracking the sk's references.  Can it be reused to
> > track the skb's reference?
> =

> I was vaguely aware that it does this, but have not looked at the
> details. Would be great if this was possible; will see how far I get
> with it, and iterate from there (with your help, hopefully :))

Also might need to drop any socket references from the networking side
so an enqueued sock can't hold a socket open.

> =

> -Toke
> =
