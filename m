Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D176138D092
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhEUWLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhEUWLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:11:07 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4B6C061574;
        Fri, 21 May 2021 15:09:42 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e17so9099215iol.7;
        Fri, 21 May 2021 15:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bGDmmwhi54T3dfOmVp6LaAX6cHC70SI7w2h1y8q33qI=;
        b=WAtciiIICJPGRDbUNkD9NQzWUfNUeljFRtypa+y+0CTy/p9k4GuFFZEDj8oXN9kP/d
         N9m4YtEe8Xen+FHLlVVj2pSsxZgUMe5sLForJrHxF8SVXKkIVrdAqpI+SpkbXg0KpFAr
         7oln+J0LnPjKLuWL4hHRByLvQfBQmsRR8EhV1PdtnVo1q1grRmyn/loh6iQEKy6LRX2K
         C2dtAzUNHkFvwmvGF6nzmY0vK22fZ6H5IQwLt32/ddThxE6LBD/im9ExbGIuHx7PJFsU
         dJjxW1l+xduVcnxhsFZmS4jiOIwCJ1UkhTpDtrtEE9NxrECSbyueR7w/ER5RU6Sj/AB1
         cJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bGDmmwhi54T3dfOmVp6LaAX6cHC70SI7w2h1y8q33qI=;
        b=Xj0ijBG5WqfcS2BgQ0tsomeKObG/sUj662ea2KKAKXQvS0Sl4bEBy+ZWMVL0GF/xTx
         DXWU4pVtrVqmx1af8sUA/NbJAYeRPKABbd//Jjlt+agpsyCnSfpKrfJgrfpKc2gv2GnC
         jnje07USeteLn+LlIHjjFDvgFTebUkKIjnasT6nxHS8VdKoUOI6kMNTyCoYAs0c+S/Zp
         /QSEEdZDVtwEK30YuaUUOib/cBL8180vVsDh/vUdX04uJAQMV5Tap5OAi34uF/0cZ8Zy
         9ihYV9cteXU5uqBsqHdhQmu7LqI3AjoztDlHFVsCjT5xQm/3cLHuoJ0uB3TngBXmVuOz
         vEQw==
X-Gm-Message-State: AOAM531AmPnhLZH5OOW1ITaAXamKyQt1JfFK0Y5zVbd8CvNmxd3eccD5
        Fqyf0Agd2FGodzT2qw+7iww=
X-Google-Smtp-Source: ABdhPJw6V+yvSoWBzhLYEvwQTKWsLXQPM8eQm8yNNgQ0gNrw1MDrG0SaxALyalBdsl+SF7mkSz1VVQ==
X-Received: by 2002:a05:6638:505:: with SMTP id i5mr7007405jar.141.1621634981708;
        Fri, 21 May 2021 15:09:41 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id o5sm1009524ilm.78.2021.05.21.15.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 15:09:41 -0700 (PDT)
Date:   Fri, 21 May 2021 15:09:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a82f9c96de2_1c22f2086e@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWxJrXhdxyhO6O+h1d9dz=4BBk8i-EYrVG6v8ix_0gCnQ@mail.gmail.com>
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
 <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
 <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch>
 <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
 <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch>
 <CAM_iQpU5HEB_=+ih7_4FKqdkXJ4eYuw_ej5BTOdRK8wFVa7jig@mail.gmail.com>
 <60a69f9f1610_4ea08208a3@john-XPS-13-9370.notmuch>
 <CAM_iQpWxJrXhdxyhO6O+h1d9dz=4BBk8i-EYrVG6v8ix_0gCnQ@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, May 20, 2021 at 10:43 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Wed, May 19, 2021 at 2:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Cong Wang wrote:
> > > > > On Wed, May 19, 2021 at 12:06 PM John Fastabend
> > > > > <john.fastabend@gmail.com> wrote:
> > > > > >
> > > > > > Cong Wang wrote:
> > > > > > > On Tue, May 18, 2021 at 12:56 PM John Fastabend
> > > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > > >
> > > > > > > > Cong Wang wrote:
> > > > > > > > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > > > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Cong Wang wrote:
> > > > > > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > > > > > >

[...]

> >
> > "We are not dropping the packet" you'll need to be more explicit on
> > how this path is not dropping the skb,
> 
> You know it is cloned, don't you? So if we clone an skb and deliver
> the clone then free the original, what is dropped here? Absolutely
> nothing.
> 
> By "drop", we clearly mean nothing is delivered. Or do you have
> any different definition of "drop"?

This is my meaning of 'drop'.

> 
> >
> >   udp_read_sock()
> >     skb = skb_recv_udp()
> >      __skb_recv_udp()
> >        __skb_try_recv_from_queue()
> >         __skb_unlink()              // skb is off the queue
> >     used = recv_actor()
> >       sk_psock_verdict_recv()
> 
> Why do you intentionally ignore the fact the skb is cloned
> and the clone is delivered??

I'm only concerned about the error case here.

> 
> >         return 0;
> >     if (used <= 0) {
> >       kfree(skb)         // skb is unlink'd and kfree'd
> 
> Why do you ignore the other kfree_skb() I added in this patch?
> Which is clearly on the non-error path. This is why I said the
> skb needs to be freed _regardless_ of error or not. You just
> keep ignoring it.

Agree it needs a kfree_skb in both cases I'm not ignoring it. My
issue with this fix is it is not complete. We need some counter
to increment the udp stats so we can learn about these drops.
And it looks like an extra two lines will get us that.

> 
> 
> >       break;
> >     return 0
> >
> > So if in the error case the skb is unlink'd from the queue and
> > kfree'd where is it still existing, how do we get it back? It
> > sure looks dropped to me. Yes, the kfree() is needed to not
> > leak it, but I'm saying we don't want to drop packets silently.
> 
> See above, you clearly ignored the other kfree_skb() which is
> on non-error path.

Ignored in this thread because its correct and looks good to me.
My only issue is with the error path.

> 
> > The convention in UDP space looks to be inc sk->sk_drop and inc
> > the MIB. When we have to debug this on deployed systems and
> > packets silently get dropped its going to cause lots of pain so
> > lets be sure we get the counters correct.
> 
> Sure, let me quote what I already said:
> " A separate patch is need to check desc->error, if really needed."

Check desc->error or even just used <= 0 is sufficient here. Yes it is
really needed I don't want to debug this in a prod environment
without it.

> 
> This patch, as its subject tells, aims to address a memory leak, not
> to address error counters. BTW, TCP does not increase error

OK either add the counters in this patch or as a series of two
patches so we get a complete fix in one series. Without it some
box out there will randomly drop UDP packets, probably DNS
packets for extra fun, and we will have no way of knowing other
than sporadic packet loss. Unless your arguing against having the
counters or that the counters don't make sense for some reason?

> counters either, yet another reason it deserves a separate patch
> to address both.

TCP case is different if we drop packets in a TCP error case
thats not a 'lets increment the counters' problem the drop needs
to be fixed we can't let data fall out of a TCP stream because
no one will retransmit it. We've learned this the hard way.

> 
> Thanks.
