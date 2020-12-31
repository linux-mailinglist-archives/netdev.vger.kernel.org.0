Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96882E81EA
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 21:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgLaUT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 15:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLaUT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 15:19:26 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D23BC061573
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 12:18:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b123so35137092ybh.17
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 12:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LzgfXQnATqRtYelRGlHRH58XptD8Of2PDPLNvG/AR60=;
        b=XdaFEgHJ0EWdvsIBqTPR2VA6SxjVcYpUv5Qe9zgBUdmzghmLeLCQguh7j385TH7Few
         1BbC9pqpSNYeSybjmyPlPqRkyZ5VvhFjKyK7v9F+daUSOL+Be7t6tgAjnRvZzGF9pjGK
         DBUh2YfQGZckHHuqySF+PoTIS1HXLo5/jzvKZbu6OZKZnt1EJ0bmwLV2V+mTZS/nirGN
         LQGAZ68aZIJOXSFXFoi1RDWO/UBjGCXqBZeD1dCSQiNeN1uAZImuLqu+kFJUT2X3YAty
         v/LFahXVeigH4+4/CornOobcY2wfxeBFRiKJBs0xiT0Er3+RIcoHVfrCXijkjYY9nJLe
         K2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LzgfXQnATqRtYelRGlHRH58XptD8Of2PDPLNvG/AR60=;
        b=LRd1Eq2c9Kzm6XZpgLQiZr0MzNFsifBNQh2ohBzGh0CuQeQHcrcH/fIvyC9STVm7yq
         kT9meEL8k2srNsW8xu6mtYg8HePG6WFr+NPUP52z/B3AhBWOIqXW8v33+qTHnUTLgGqn
         9Er3MEbvxynVmK0iW8qtnwoe+GomoSPFtynRrjskZR04lKOxYo/Qbb0sjm9wj3gNJHZd
         IcWIpgn37yMzJTVEvq7bp4dwnaVfMOJ9HINNG/tQllrNszUfoy8PE4caN5qUdgT+2x5a
         t+MvRCMOxEy4lXDR1QeueC9XgUGBROSmieqZC4sXtQWEdmqdU11rj7+otnxf2wUlQFlO
         wdHQ==
X-Gm-Message-State: AOAM532l35Tajgo973OwpHXOF1QTIqHYc7dP2cwxnY/m5b87On48MyfA
        C2pnz0XRgH0WU2q6fOD97T7ksTM=
X-Google-Smtp-Source: ABdhPJyRIQo3+iBwF7nGv66MMMXOkbLFxzibr3JNAwigWy1nOJduBviUbN03guoor7QJKDFNMXyiUaM=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:cf12:: with SMTP id f18mr84837187ybg.18.1609445924922;
 Thu, 31 Dec 2020 12:18:44 -0800 (PST)
Date:   Thu, 31 Dec 2020 12:18:43 -0800
In-Reply-To: <20201231065038.k637ewwyqclq2nxh@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <X+4yIzNsb3X52T9s@google.com>
Mime-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-2-sdf@google.com>
 <20201222191107.bbg6yafayxp4jx5i@kafai-mbp.dhcp.thefacebook.com>
 <X+K07Rh+2qECwxJp@google.com> <20201231065038.k637ewwyqclq2nxh@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30, Martin KaFai Lau wrote:
> On Tue, Dec 22, 2020 at 07:09:33PM -0800, sdf@google.com wrote:
> > On 12/22, Martin KaFai Lau wrote:
> > > On Thu, Dec 17, 2020 at 09:23:23AM -0800, Stanislav Fomichev wrote:
> > > > When we attach a bpf program to cgroup/getsockopt any other  
> getsockopt()
> > > > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > > > not an issue, sometimes it is, like in the case of  
> TCP_ZEROCOPY_RECEIVE.
> > > > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > > > fastpath for incoming TCP, we don't want to have extra allocations  
> in
> > > > there.
> > > >
> > > > Let add a small buffer on the stack and use it for small (majority)
> > > > {s,g}etsockopt values. I've started with 128 bytes to cover
> > > > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > > > currently, with some planned extension to 64 + some headroom
> > > > for the future).
> > > >
> > > > It seems natural to do the same for setsockopt, but it's a bit more
> > > > involved when the BPF program modifies the data (where we have to
> > > > kmalloc). The assumption is that for the majority of setsockopt
> > > > calls (which are doing pure BPF options or apply policy) this
> > > > will bring some benefit as well.
> > > >
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  include/linux/filter.h |  3 +++
> > > >  kernel/bpf/cgroup.c    | 41  
> +++++++++++++++++++++++++++++++++++++++--
> > > >  2 files changed, 42 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > > index 29c27656165b..362eb0d7af5d 100644
> > > > --- a/include/linux/filter.h
> > > > +++ b/include/linux/filter.h
> > > > @@ -1281,6 +1281,8 @@ struct bpf_sysctl_kern {
> > > >  	u64 tmp_reg;
> > > >  };
> > > >
> > > > +#define BPF_SOCKOPT_KERN_BUF_SIZE	128
> > > Since these 128 bytes (which then needs to be zero-ed) is modeled  
> after
> > > the TCP_ZEROCOPY_RECEIVE use case, it will be useful to explain
> > > a use case on how the bpf prog will interact with
> > > getsockopt(TCP_ZEROCOPY_RECEIVE).
> > The only thing I would expect BPF program can do is to return EPERM
> > to cause application to fallback to non-zerocopy path (and, mostly,
> > bypass). I don't think BPF can meaningfully mangle the data in struct
> > tcp_zerocopy_receive.
> >
> > Does it address your concern? Or do you want me to add a comment or
> > something?
> I was asking because, while 128 byte may work best for  
> TCP_ZEROCOPY_RECEIVCE,
> it is many unnecessary byte-zeroings for most options though.
> Hence, I am interested to see if there is a practical bpf
> use case for TCP_ZEROCOPY_RECEIVE.
I don't see any practical use-case for TCP_ZEROCOPY_RECEIVE right now
(but you never know, maybe somebody would like to count the number
of ZQ calls? inspect the arguments? idk).

Ideally, we should bypass BPF if (optname == TCP_ZEROCOPY_RECEIVE),
but then it's not 'generic' anymore :-/
