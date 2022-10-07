Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E175F7AA3
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJGPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 11:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJGPgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:36:47 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3350FCA89D
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 08:36:46 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id v134so5885831oie.10
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 08:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F3MVRdCe71nXE3jWp7eZq9fozG/36xJqzS75oTzvWkA=;
        b=vu8Hjsg92IcCBOMC646zQt7RWHHieFggIyNc2WrKo9hKxZS9txFAZ7UskNuwHHvs0t
         3+lGugPCczWv01GIva0zcyJHV4GICZPOUs1UAMfoIkt+w9uPVuSKiqQXosF2z603jfTu
         h+tDYzb/Q6eQV9jfbiLKuawhO5Gb2QnkQtqDYEvfkCZ36E0bSTKt7/bSEbik6GfQ+Tyg
         oGAuE1yNP+GlZFpWv6ucTuFXpeKQqIPpjYtYJ0YYH1lhKejkUkmAsvQ7b7HxHsl0Z5jR
         0d8tKLAB9YEk37uYhjNmvBm+Zo+DaqdVhVFzsjJgfz3OAwZyWAPvmnU3cYvqB275HJZA
         5Mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F3MVRdCe71nXE3jWp7eZq9fozG/36xJqzS75oTzvWkA=;
        b=lCStZMkzvzbcLQg+Ju0dlA6PNFh+KsMwndMQdecmSFZ9GgIRXD5xDa1R9bPWRDV7DZ
         Q9sN7VV2jCw7vbOVYBil+T+VurGf3OakR/keePV4VlfLDRhKAJ8YY39Z8AUcXwFpI17Q
         ilUJXT/itT3dXnlAiBT/Bmt2lactr/wmPhlnlkgc4cIjEaMehT8jSh/8iYYWYWfkeLGV
         mvQxQqozj5JTztth8MMP4/9Kh4jc9ckltkC8QW2ZBKauGElkOYu0glIRr19oStthmxys
         lH6XFObi+k4aPqzWWqfpF45TvQWtgNIepmo1+gikPDBcIIX+mDmHDrgSXQsKdTe4xaeQ
         bdmw==
X-Gm-Message-State: ACrzQf02CF5Ef5RDqkxqo38eKrFMEeN4q2vp6RJXjPqPVigMGvZHdEod
        zPc2YDfPjjX04wPUi7pwZCTvy8YwlmdIkd+zaRpIlA==
X-Google-Smtp-Source: AMsMyM4Km5GLY3FfrPCzSZTgEZmF4LR9fPO+lJQY8rHBEjRQNJRYYXfl4OzGSVmmnFBhkYnv2KzpXU+ya1KcyMbwOd0=
X-Received: by 2002:a05:6808:1997:b0:34f:d372:b790 with SMTP id
 bj23-20020a056808199700b0034fd372b790mr2708228oib.2.1665157005437; Fri, 07
 Oct 2022 08:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
 <CAM0EoM=i_zFMQ5YEtaaWyu-fSE7=wq2LmNTXnwDJoXcBJ9de6g@mail.gmail.com> <aa8034e8-a64e-3587-1e1f-1d07c69edd98@iogearbox.net>
In-Reply-To: <aa8034e8-a64e-3587-1e1f-1d07c69edd98@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Oct 2022 11:36:33 -0400
Message-ID: <CAM0EoMmWM5ZBtRjPSjd8AU2SkzYxHGgdEixBxGpoWvkh0dbCWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 6, 2022 at 4:49 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Jamal,
>
> On 10/5/22 9:04 PM, Jamal Hadi Salim wrote:
> [...]

>
> Yes and no ;) In the specific example I gave there was an application bug that
> led to this race of one evicting the other, so it was not intentional and also
> not triggered on all the nodes in the cluster, but aside from the example, the
> issue is generic one for tc BPF users. Not fd ownership, but ownership of BPF
> link solves this as it does similarly for other existing BPF infra which is one
> of the motivations as outlined in patch 2 to align this for tc BPF, too.

Makes sense. I can see how noone would evict you with this; but it is still
a race for whoever gets installed first, no? i.e you still need an
arbitration scheme.
And if you have a good arbitration scheme you may not need the changes.

> > IIUC,  this is an issue of resource contention. Both users who have
> > root access think they should be prio 1. Kubernetes has no controls for this?
> > For debugging, wouldnt listening to netlink events have caught this?
> > I may be misunderstanding - but if both users took advantage of this
> > feature seems the root cause is still unresolved i.e  whoever gets there first
> > becomes the owner of the highest prio?
>
> This is independent of K8s core; system applications for observability, runtime
> enforcement, networking, etc can be deployed as Pods via kube-system namespace into
> the cluster and live in the host netns. These are typically developed independently
> by different groups of people. So it all depends on the use cases these applications
> solve, e.g. if you try to deploy two /main/ CNI plugins which both want to provide
> cluster networking, it won't fly and this is also generally understood by cluster
> operators, but there can be other applications also attaching to tc BPF for more
> specialized functions (f.e. observing traffic flows, setting EDT tstamp for subsequent
> fq, etc) and interoperability can be provided to a certain degree with prio settings &
> unspec combo to continue the pipeline. Netlink events would at best only allow to
> observe the rig being pulled from underneath us, but not prevent it compared to tc
> BPF links, and given the rise of BPF projects we see in K8s space, it's becoming
> more crucial to avoid accidental outage just from deploying a new Pod into a
> running cluster given tc BPF layer becomes more occupied.

I got it i think: seems like the granularity of resource control is
much higher then.
Most certainly you want protection against wild-west approach where everyone
wants to have the highest priority.


> > Other comments on just this patch (I will pay attention in detail later):
> > My two qualms:
> > 1) Was bastardizing all things TC_ACT_XXX necessary?
> > Maybe you could create #define somewhere visible which refers
> > to the TC_ACT_XXX?
>
> Optional as mentioned in the other thread. It was suggested having enums which
> become visible via vmlinux BTF as opposed to defines, so my thought was to lower
> barrier for new developers by making the naming and supported subset more obvious
> similar/closer to XDP case. I didn't want to pull in new header, but I can move it
> to pkt_cls.h.
>

I dont think those values will ever change - but putting them in the
same location
will make it easier to find.

> > 2) Why is xtc_run before tc_run()?
>
> It needs to be first in the list because its the only hook point that has an
> 'ownership' model in tc BPF layer. If its first we can unequivocally know its
> owner and ensure its never skipped/bypassed/removed by another BPF program either
> intentionally or due to users bugs/errors. If we put it after other hooks like cls_bpf
> we loose the statement because those hooks might 'steal', remove, alter the skb before
> the BPF link ones are executed.

I understand - its a generic problem in shared systems which from your
description
it seems kubernetes takes to another level.

> Other option is to make this completely flexible, to
> the point that Stan made, that is, tcf_classify() is just callback from the array at
> a fixed position and it's completely up to the user where to add from this layer,
> but we went with former approach.

I am going to read the the thread again. If you make it user definable where
tcf_classify() as opposed to some privilege that you are first in the code path
because you already planted your flag already, then we're all happy.
Let 1000 flowers bloom.

It's a contentious issue Daniel. You are fixing it only for ebpf - to
be precise only
for new users of ebpf who migrate to new interface and not for users
who are still
using the existing hooks. I havent looked closely, would it not have
worked to pass
the link info via some TLV to current tc code? That feels like it would be more
compatible with older code assuming the infra code in user space can
hide things,
so if someone doesnt specify their prio through something like bpftool
or tc then a
default of prio 0 gets sent and the kernel provides whatever that
reserved space it
uses today. And if they get clever they can specify a prio and it is a
race of who gets
there first.
I think this idea of having some object for ownership is great and i am hoping
it can be extended in general for tc; but we are going to need more granularity
for access control other than just delete (or create); example would it make
sense that permissions to add or delete table/filter/map entries could
be controled
this way? I'd be willing to commit resources if this was going to be done for tc
in general.

That aside:
We dont have this problem when it comes to hardware offloading because such
systems have very strict admin of control: there's typically a daemon in charge;
which by itself is naive in the sense someone with root could go underneath you
and do things - hence my interest in not just ownership but also access control.

cheers,
jamal
