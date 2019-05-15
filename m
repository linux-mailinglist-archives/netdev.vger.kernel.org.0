Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121DF1E72D
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 05:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfEODiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 23:38:18 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44733 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfEODiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 23:38:18 -0400
Received: by mail-lf1-f68.google.com with SMTP id n134so783141lfn.11
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 20:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3B6QOQeixS1xdatpREEZMmyQLJmZXqRtBMKmot8P8Y4=;
        b=sgun8DKNsZtpXOzp+H55fE9TGdmdInwrZ8VqydYARvjDU/Gl8FfUeNAwBZy5vbUJz5
         iypTpXF2VuC1Z+GRqbE0kL4FjMWSqN8cceCnNVvXpXvqffqcq4umKB7wSbh/19hNZMwi
         ajhN5eFhl2+yPsx7xzVtuwfoELF1ok8O/rZxckFsiAd9d5t+NzWphCVllHXsnw9H99oc
         vG//ZF4xHdOec46rc5tNbpoKu8GCLmLOe2C/kRUXY7LuyMNijDjV1/p4B1KUJUGI1f07
         E8kp8mN8QsSluT/99rcENPB1DfEoNL7To6hkPfgRTL8j89p3YkFPa0R84Q4wPhC1Xupd
         3mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3B6QOQeixS1xdatpREEZMmyQLJmZXqRtBMKmot8P8Y4=;
        b=lbXzcdwvOVHnvJjsAcQuBrn761/7PsF4rWSglDFjPZbr4OUZN9qd65UVxtDzjS7BIC
         O1wEqYt/pZuqgq9dloqtQkQfpTN0aYH8aHYyPx/pXSwYWU4dujTp7oWnkceSdRErYUNb
         3w9FOkSKN6Q2A1NPm+su0TF8va7xKi9mVCz2s6tVh7TGisA05JKmbe5RxY03dUV1fixT
         jPJPHlEa6m46PbtOJetFOvBEcJC+WwrvYZJFSfEefdIupdAVIy+c7PTfyHm/YM5LGg/1
         2Lfn1z9rjDs/f1wLCpqaRxKh+O6knK2NaiIUJfRRdzlPIf28NnwQSFzfjW4b9334Bf4C
         TY7w==
X-Gm-Message-State: APjAAAW7TInxA5KrZGF32GgvrVyRnasvciU/GgSQmvVJIrT17UqABCa5
        PfsCM1HMITCzeNeLhfZtELZLqeOEGJeyiJup+irF+g==
X-Google-Smtp-Source: APXvYqx9xhVA9OM4RjD4F2ROnmIkkArFTfJAqehp8RyQSu3Gw/n25DiQFGBhiGdgj0dN0fFrlZa/oTUmp5xNMOlzZQk=
X-Received: by 2002:a19:4a04:: with SMTP id x4mr18273922lfa.124.1557891495795;
 Tue, 14 May 2019 20:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185724.GB24057@mini-arch> <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch> <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch> <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch> <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
 <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com> <20190515025636.GE10244@mini-arch>
 <20190515031643.blzxa3sgw42nelzd@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190515031643.blzxa3sgw42nelzd@ast-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 14 May 2019 20:38:03 -0700
Message-ID: <CAKH8qBuSM3a6j6xupaWOGqT3XM9rUzZRLujg_E_8WLjsd2t-DA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 8:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 14, 2019 at 07:56:36PM -0700, Stanislav Fomichev wrote:
> > On 05/14, Eric Dumazet wrote:
> > >
> > >
> > > On 5/14/19 7:27 PM, Alexei Starovoitov wrote:
> > >
> > > > what about activate_effective_progs() ?
> > > > I wouldn't want to lose the annotation there.
> > > > but then array_free will lose it?
> > It would not have have it because the input is the result of
> > bpf_prog_array_alloc() which returns kmalloc'd pointer (and
> > is not bound to an rcu section).
> >
> > > > in some cases it's called without mutex in a destruction path.
> > Hm, can you point me to this place? I think I checked every path,
> > maybe I missed something subtle. I'll double check.
>
> I thought cgroup dying thingy is not doing it, but looks like it is.
I was looking at the following chain:
css_release_work_fn
  mutex_lock(&cgroup_mutex);
    cgroup_bpf_put
      bpf_prog_array_free
  mutex_unlock(&cgroup_mutex);

I'll take another look tomorrow with a fresh mind :-)

> > > > also how do you propose to solve different 'mtx' in
> > > > lockdep_is_held(&mtx)); ?
> > > > passing it through the call chain is imo not clean.
> > Every caller would know which mutex protects it. As Eric said below,
> > I'm adding a bunch of xxx_dereference macros that hardcode mutex, like
> > the existing rtnl_dereference.
>
> I have a hard time imagining how it will look without being a mess.
> There are three mutexes to pass down instead of single rtnl_derefernce:
> cgroup_mutex, ir_raw_handler_lock, bpf_event_mutex.
We don't need to pass them down, we need those xxx_dereference
wrappers only in the callers of those apis. They are private
to cgroup.c/lirc.c/bpf_trace.c.

Take a look at the patches 2-4 in the current series where I convert
the callers.

(Though, I'd rename xxx_dereference to xxx_rcu_dereference for clarity we
get to a v2).
>
> Anyway, let's see how the patches look and discuss further.
