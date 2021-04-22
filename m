Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900C1367F23
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhDVK74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:59:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235455AbhDVK7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 06:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619089158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jXNqgpkvJIOW6Rt8kqHFZkkNxiI31FFU9sMkTfD7ohA=;
        b=CVLojpTDZ6SE3vOIRWQqhRIpC8JJHyfbK4CcMsQKwBTdGuW3IBTBxamRY1JTggnxcHnO4F
        nwD2yoGwNVTFU8X5eDDME4MBFH5QscfoK0YinOAjOJZ19c3zTfkxMN3Y5bO6OUZ65KMoED
        TpoZvlRnWpxO4ZTcq7il9XFISw8Ioyk=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-fy-y-uw3P-yWy8J5Xyumxg-1; Thu, 22 Apr 2021 06:59:16 -0400
X-MC-Unique: fy-y-uw3P-yWy8J5Xyumxg-1
Received: by mail-yb1-f199.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so19383061ybi.2
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 03:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXNqgpkvJIOW6Rt8kqHFZkkNxiI31FFU9sMkTfD7ohA=;
        b=XMBY2NdvnQpZ0ib35YndWVC78V9PQpOCXQF3fW9NUtBpOKQ082BzcMDPsrsWvHhDhj
         i1ViHFzfT4Y5Fc5P1E6J6paE1sAyWwWp95Q7rFoVKQLlA8DqtBqfzvAHixRfRB8ZOdVD
         I0Get63QtUHdhCTw7uOL8apvcvERCDOWfIxLLIN6/4DSUS/N8R6Dzmfo4L7bnvz88YON
         AnOquTr+ekjQdlTpV84ZBMRImflj1x6E47eWh6zKnLdCiCV0GwbgcmQ//WU0QLP0XTfb
         lKchylLWJiRk3hS2Mf6HL+AusohBXd3b3+ibNA+3JywpIci3MZBCl+ZqsWfEd+CHJwW7
         XIfA==
X-Gm-Message-State: AOAM530P4WaBG0Rr/k0YJkkbw3CriYmq/MQOdvET9n0FdBUzbyNB/MXU
        R0WhizVt66xfW+f0ElGLlMpQ9HHXbsvodRYfVcBbfiMu4nCtRwI5D2E8u/InEGyt/XMCDN1DEKW
        924OYa87482X4I9k0qTcfupG30jS6fHVa
X-Received: by 2002:a25:3585:: with SMTP id c127mr3926068yba.494.1619089155923;
        Thu, 22 Apr 2021 03:59:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbSavXiKuXISIWG4lDMx1DpdqRbDapWghhX7SXS7dMcL+73FMg0jHtgYPGDi4OvA7FZTXtYyB2luur95DYKP8=
X-Received: by 2002:a25:3585:: with SMTP id c127mr3926032yba.494.1619089155577;
 Thu, 22 Apr 2021 03:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <01cd8afa22786b2c8a4cd7250d165741e990a771.1618927173.git.lorenzo@kernel.org>
 <20210420185440.1dfcf71c@carbon> <YH8K0gkYoZVfq0FV@lore-desk>
In-Reply-To: <YH8K0gkYoZVfq0FV@lore-desk>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 22 Apr 2021 12:59:31 +0200
Message-ID: <CAJ0CqmVozWi5uCnzWCpkc5kccnEJWRNbLMb-5YmWe7te9E_Odg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>,
        Toke Hoiland Jorgensen <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> [...]
> > > +   TP_ARGS(map_id, processed, sched, xdp_stats),
> > >
> > >     TP_STRUCT__entry(
> > >             __field(int, map_id)
> > >             __field(u32, act)
> > >             __field(int, cpu)
> > > -           __field(unsigned int, drops)
> > >             __field(unsigned int, processed)
> >
> > So, struct member @processed will takeover the room for @drops.
> >
> > Can you please test how an old xdp_monitor program will react to this?
> > Will it fail, or extract and show wrong values?
>
> Ack, right. I think we should keep the struct layout in order to maintain
> back-compatibility. I will fix it in v4.
>
> >
> > The xdp_mointor tool is in several external git repos:
> >
> >  https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/xdp_monitor_kern.c
> >  https://github.com/xdp-project/xdp-tutorial/tree/master/tracing02-xdp-monitor

Running an old version of xdp_monitor with a patched kernel, I
verified the xdp sample does not crash but it reports wrong values
(e.g. pps are reported as drops for tracepoint disagliment).
I think we have two possibilities here:
- assuming tracepoints are not a stable ABI, we can just fix xdp
samples available in the kernel tree and provide a patch for
xdp-project
- keep current tracepoint layout and just rename current drop variable
in bpf/cpumap.c in something like skb_alloc_drop.

I am not against both of them. What do you think?

Regards,
Lorenzo

> >
> > Do you have any plans for fixing those tools?
>
> I update xdp_monitor_{kern,user}.c and xdp_redirect_cpu_{kern,user}.c in the
> patch. Do you mean to post a dedicated patch for xdp-project tutorial?
>
> Regards,
> Lorenzo
>
> >
> >
> >
> >
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> >

