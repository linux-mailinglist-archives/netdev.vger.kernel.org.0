Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0931BC743
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgD1RyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgD1RyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:54:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDB9C03C1AB;
        Tue, 28 Apr 2020 10:54:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z1so9358337pfn.3;
        Tue, 28 Apr 2020 10:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9LVxdCqe8GcaM6V/NfQ/jyAUUHMCTSNVSZtzWyQPYA4=;
        b=AflD+FVKHd2uEdIxbnt+JK1aFO46QvtvC3FZHlROlLulhYblzgDioCcyl86EfD6m3q
         Y6xpkAW1vI44cr4AYrH+mGvSj5Zm7GRr97+lz8d9ZFQCYH48AByjDN3uDGKVL2608UXS
         Me/EA1S1O2ojy7GmaPL4sizfFclE9GULa7AfOZAM7vRGQYH3/lefyOKsN5FMC4Kzyufl
         la8/ARMxFcXrZocjB0uSGXubKKvajwbfyJYtcdJJfDWsIgYmPb3OCfLevoPB1AVys1ZT
         3jl3RzROa744HpSpm8mr9g0j8sqMxdlSPow3kNsAvnMZiL4M/tDz22ClZO0jL/VNYX2n
         KZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9LVxdCqe8GcaM6V/NfQ/jyAUUHMCTSNVSZtzWyQPYA4=;
        b=SgI1SNdbIGfzvq8cLqENqezEVdIJOJ7VE46KoELMDKAlNy3iFoRmOeDBc7o/5fKfH7
         vexWV8HQGRbC/FhslW9j8ouvIrJzLSjt1bo/v+vYEY9cuNP3EBfbZAv+3n+vKiqXiWyn
         Zv6OwVoYVkvIGtj2m6juGvYImCj79dwjHIBarKofx18l3fRq0uxf7MuOI2uJVXgydh6p
         R9idT98smcjn9TM1Zwg1bV/0VZX6/G/TaYYb1TL39OHDVblvQrMqIs12b9bdFdvG1DAr
         td/MwpCHhZ+6tSQP+KDCp+vPhkCKB+dos5K2jS6xUUbfYhcKUMzFWcQV8Z36aQlSLtBM
         hmrA==
X-Gm-Message-State: AGi0PuajyUUh5LRixetH3cEs6LkFZkbljUFB1nweJgK5lUtwSxzMfuoa
        NdemMIbQIiYjceh8j8EcygE=
X-Google-Smtp-Source: APiQypJfsXdDP1OtD03LUwR136DjGl+yzTlpMX9ePtiK5XvivgnHCmlmLAyAZQWGY7CZfd0fIdbnmg==
X-Received: by 2002:a63:9801:: with SMTP id q1mr30366088pgd.447.1588096440937;
        Tue, 28 Apr 2020 10:54:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id o9sm2586635pjp.4.2020.04.28.10.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 10:53:59 -0700 (PDT)
Date:   Tue, 28 Apr 2020 10:53:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] [RFC] net: bpf: make __bpf_skb_max_len(skb) an
 skb-independent constant
Message-ID: <20200428175357.xshl4lbsqmzwt6v7@ast-mbp.dhcp.thefacebook.com>
References: <20200420231427.63894-1-zenczykowski@gmail.com>
 <20200421102719.06bdfe02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHo-Oow5HZAYNT6UZsCvzAG89R4KkERYCaoTzwefXerN3+UZ9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-Oow5HZAYNT6UZsCvzAG89R4KkERYCaoTzwefXerN3+UZ9A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:36:08PM -0700, Maciej Żenczykowski wrote:
> > > This function is used from:
> > >   bpf_skb_adjust_room
> > >   __bpf_skb_change_tail
> > >   __bpf_skb_change_head
> > >
> > > but in the case of forwarding we're likely calling these functions
> > > during receive processing on ingress and bpf_redirect()'ing at
> > > a later point in time to egress on another interface, thus these
> > > mtu checks are for the wrong device.
> >
> > Interesting. Without redirecting there should also be no reason
> > to do this check at ingress, right? So at ingress it's either
> > incorrect or unnecessary?
> 
> Well, I guess there's technically a chance that you'd want to mutate
> the packet somehow during ingress pre-receive processing (without
> redirecting)...
> But yeah, I can't really think of a case where that would be
> increasing the size of the packet.
> 
> Usually you'd be decapsulating at ingress and encapsulating at egress,
> or doing ingress rewrite & redirect to egress...
> 
> (Also, note that relying on a sequence where at ingress you first call
> bpf_redirect(ifindex, EGRESS); then change the packet size, and then
> return TC_ACT_REDIRECT; thus being able to use the redirect ifindex
> for mtu checks in the packet mutation functions is potentially buggy,
> since there's no guarantee you won't call bpf_redirect again to change
> the ifinidex, or even return from the bpf program without returning
> TC_ACT_REDIRECT --- so while that could be *more* correct, it would
> still have holes...)

yeah. there is no good fix here, since target netdev is not known,
but dropping the check also doesn't seem right.
How about:
 if (skb->dev) {
    u32 header_len = skb->dev->hard_header_len;

    if (!header_len)
       header_len = ETH_HLEN;
    return skb->dev->mtu + header_len;
  } else {
    return SKB_MAX_ALLOC;
  }

the idea that l3 devices won't have l2 and here we will assume
that l2 can be added sooner or later.
It's not pretty either, but it will solve your wifi->eth use case?
While keeping basic sanity for other cases.
