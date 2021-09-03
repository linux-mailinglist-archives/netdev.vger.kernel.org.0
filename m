Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02A240016A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349429AbhICOpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 10:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348882AbhICOpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 10:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630680248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzCAudKDCHUGW3YEsgSMZs1BCDwPAvi4fTUjFk0q5v0=;
        b=LE+nZ+TUKk7PKXxP2U5oXL2GWqWbxT6b1SSsnyuFziaViI3tfuc7UaqF6ca/NUvwjDvxSr
        EgJyUb1I7WY7Fb5HfscZ3V1nvKLvicFVtQ5mJlsss66LZi2p+5W14VbjGBc6wNqtKiqZqw
        pQQUrqgArhzWxCrusNkPU9vENmDoSHc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-v6VcE4y-OKmr-T3pYU-jsg-1; Fri, 03 Sep 2021 10:44:07 -0400
X-MC-Unique: v6VcE4y-OKmr-T3pYU-jsg-1
Received: by mail-ed1-f71.google.com with SMTP id ch11-20020a0564021bcb00b003c8021b61c4so821966edb.23
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 07:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tzCAudKDCHUGW3YEsgSMZs1BCDwPAvi4fTUjFk0q5v0=;
        b=sio2CKE/97S5AfVm8FVKzOzY2X2vBDJKyEx1EIddAJtmMZ/yzcw+/6shxWIy1i24Yr
         B6tDEd/f/xSTcKhXK34ybZ+0RNY8/Reukbm9vltqGMCclA6Y9qqNNh48YityRlfm91zH
         EuNCPflzvWngdtTeHGrLBZ/Fu0WbnwJOQ5dOVD7QYfhjmVzvweh5UBJ/F1bXE3n1kHC1
         ZtEeWYMSiJ9QBrLUIqCGRILHCKVSkql2ilGi2GMiTnf3sAe4sjB/p/cEdO90myPwnQvO
         WLnxao7kgezdcKIcQSE3poOWQzpzN3+hmOBSh6Ev9U0TRqGqXNoFnrX1F3TMIRDTdNKa
         UspA==
X-Gm-Message-State: AOAM530kpQVMAXd/sIvyMWLhSCO3vbXfNkIvhGtb/Mk7NDgyzutcxnzU
        lXX/v6vb8tzHTBubsP5TcIS9lIDG+MwQx09PlfAIz0+EEphgij6S/M9CJyYnMUd5xfqZnZvX6JN
        VjP/KLBJAXQxCUHQX
X-Received: by 2002:aa7:c1ca:: with SMTP id d10mr4421092edp.294.1630680246329;
        Fri, 03 Sep 2021 07:44:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws8r0eF6pqn5eUk3akGSZKVi5DjUKMVWXoQo6QB5DDpIqNVVwGLr0GDn3cD61h/oazHLKidQ==
X-Received: by 2002:aa7:c1ca:: with SMTP id d10mr4421070edp.294.1630680246078;
        Fri, 03 Sep 2021 07:44:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id jx21sm2809412ejb.41.2021.09.03.07.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 07:44:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7002D18016F; Fri,  3 Sep 2021 16:44:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
In-Reply-To: <20210902233510.gnimg2krwwkzv4f2@kafai-mbp.dhcp.thefacebook.com>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk>
 <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
 <87bl5asjdj.fsf@toke.dk>
 <20210902233510.gnimg2krwwkzv4f2@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Sep 2021 16:44:04 +0200
Message-ID: <87zgstra6j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Fri, Sep 03, 2021 at 12:27:52AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> >> The question is if it's useful to provide the full struct_ops for
>> >> qdiscs? Having it would allow a BPF program to implement that interfa=
ce
>> >> towards userspace (things like statistics, classes etc), but the
>> >> question is if anyone is going to bother with that given the wealth of
>> >> BPF-specific introspection tools already available?
> Instead of bpftool can only introspect bpf qdisc and the existing tc
> can only introspect kernel qdisc,  it will be nice to have bpf
> qdisc work as other qdisc and showing details together with others
> in tc.  e.g. a bpf qdisc export its data/stats with its btf-id
> to tc and have tc print it out in a generic way?

I'm not opposed to the idea, certainly. I just wonder if people who go
to the trouble of writing a custom qdisc in BPF will feel it's worth it
to do the extra work to make this available via a second API. We could
certainly encourage it, and some things are easy (drop and pkt counters,
etc), but other things (like class stats) will depend on the semantics
of the qdisc being implemented, so will require extra work from the BPF
qdisc developer...

-Toke

