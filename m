Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD12286B9B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgJGXxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbgJGXxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 19:53:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB45C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 16:53:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id z5so4042741ilq.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 16:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3whrFZj3yjrkwvdOp2R9dTQELPnB8gGnTrz+6UI+SQA=;
        b=STQqU0Qas6+7bY+LdGtPaV0U9M7BIOw6TuqzEZ+LVZFGsWZmEmR055QZMWVwEs/gav
         xPqYXpNI66FexRLSWZjJgDMX+rOaH8ibeYoRk7fyy6dBYdLWi3EhXoWxTJrHG4kI2p1L
         ZA3/TcatputE7ZYbfUtUPnTdEHnMFt0dfbnZxgsBZaK5v+rxPJLIDPVyQAeV1qS3bzIJ
         wpJegaX8Rvm46fksOtelJeTy8YSivZLWu3GUdbKpFHFxg1L+2R4IbmcjrjwvN2rb/9pe
         MDWcYXQfebN+8/WziLLtrf61DviIW4hs4BlWxIAv2VoEJd1Y4ME1ztJd1/dbsZUdnNk0
         b4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3whrFZj3yjrkwvdOp2R9dTQELPnB8gGnTrz+6UI+SQA=;
        b=eIQA9PNVOjYaVhefCfmzAO/yA/Z+DLSxNqXZTyURBAFqJnZtO9lml5YoXkg/NFFZ0Z
         0J7gyx6lQ7BbW4hCH3TDM5T/tt/1xebZBZD+UoAea4nnkE5wbawGTi2hyeiKmQ7Iq83j
         ODedORPM5IZPa4t4yvDJ42P9+tPWqvr2rPL6eap98OzfZm2SdRonfRbKuB6XMnkrv6NX
         XzU5zhYlEfWjKFJvgsuB+LXUt2Uk8uZvUpXgTwdLxz/GZDC+fqbkyEckW6t7bHKc8k8c
         L5ZPhETa2UXxhv3Xtnp66NVuJu09e3gf5FC+upNcugsfMYNbHKQeoKtp1/rzKFkDA6WQ
         Z6mA==
X-Gm-Message-State: AOAM5315s0FLYSuHJ3bgRgPbb9+2XlH7HJ2a7q5SRvmb/vfuRrP+jDXw
        RnEpEn48w0KpVupdn2f1VfUgUFZikXqSgYUU3mH+pg==
X-Google-Smtp-Source: ABdhPJxx8nshvTV9n63SLJ5ye3zXfZisivQRTvlQzOWapUJe4tERYosW2iGW8nB1cj6CnFuggzXdWWhxldMGkh1GKyY=
X-Received: by 2002:a92:ccc2:: with SMTP id u2mr4217852ilq.278.1602114784408;
 Wed, 07 Oct 2020 16:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
 <160208778070.798237.16265441131909465819.stgit@firesoul> <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
 <5f7e430ae158b_1a8312084d@john-XPS-13-9370.notmuch>
In-Reply-To: <5f7e430ae158b_1a8312084d@john-XPS-13-9370.notmuch>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 7 Oct 2020 16:52:53 -0700
Message-ID: <CANP3RGdcqmcrxWDKPsZ8A0+qK1hzD0tZvRFsVMPvSCNDk+LrHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 3:37 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Daniel Borkmann wrote:
> > On 10/7/20 6:23 PM, Jesper Dangaard Brouer wrote:
> > [...]
> > >   net/core/dev.c |   24 ++++++++++++++++++++++--
> > >   1 file changed, 22 insertions(+), 2 deletions(-)
>
> Couple high-level comments. Whats the problem with just letting the driver
> consume the packet? I would chalk it up to a buggy BPF program that is
> sending these packets. The drivers really shouldn't panic or do anything
> horrible under this case because even today I don't think we can be
> 100% certain MTU on skb matches set MTU. Imagine the case where I change
> the MTU from 9kB->1500B there will be some skbs in-flight with the larger
> length and some with the shorter. If the drivers panic/fault or otherwise
> does something else horrible thats not going to be friendly in general case
> regardless of what BPF does. And seeing this type of config is all done
> async its tricky (not practical) to flush any skbs in-flight.
>
> I've spent many hours debugging these types of feature flag, mtu
> change bugs on the driver side I'm not sure it can be resolved by
> the stack easily. Better to just build drivers that can handle it IMO.
>
> Do we know if sending >MTU size skbs to drivers causes problems in real
> cases? I haven't tried on the NICs I have here, but I expect they should
> be fine. Fine here being system keeps running as expected. Dropping the
> skb either on TX or RX side is expected. Even with this change though
> its possible for the skb to slip through if I configure MTU on a live
> system.

I wholeheartedly agree with the above.

Ideally the only >mtu check should happen at driver admittance.
But again ideally it should happen in some core stack location not in
the driver itself.
However, due to both gso and vlan offload, even this is not trivial to do...
The mtu is L3, but drivers/hardware/the wire usually care about L2...
(because ultimately that's what gets received and must fit in receive buffers)
