Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20B53899CA
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 01:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhESX1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 19:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhESX1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 19:27:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5261EC061574;
        Wed, 19 May 2021 16:26:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso4278103pjx.1;
        Wed, 19 May 2021 16:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=901XtcdIeveiScJhtrCQVBeYdzlqlmAAURFKU5hazKo=;
        b=soWGurdFRwckL89ICi7z9aHL6nAOrObdolh7fj1ew2XiR9rtz6ELVniBNpbVaVHHT3
         j12PbqkPKBQUCqRSVEVbOsYXtokED8FX+Xpwc+eVHjY7IeG9HVaqDu8AD6brFzfVCxlz
         BVYMly5lQ9v+AcZnVKy9ZEKonvAVDksmBw4yOzsibOwchebQC7d1MXSv4348TtkFHNLA
         ppiNjXRgSnSp/rQYhR3fd1bhSOJA4e0+19yP9+9AZqoRf1GIKHD89HDgzZer8lTaSvVg
         PurA+My7EAy921UBOS5MBS7fY7WWLHBftMFgiLBk3LaIqraF3+af+4hZRPaFsRgPocvJ
         8fPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=901XtcdIeveiScJhtrCQVBeYdzlqlmAAURFKU5hazKo=;
        b=sfsKzVAJ1QuVuezJffFWmrx5N+z2wNigPoNaj2aTnVaS57AQcacS/iLjzHK7O6K99P
         65uGtNu7Edf9h6pF8YdTSwpUw0u6gf1iOm1ipOYNjXg8QDeM70C6ytXo8SMqTHjFD91u
         56hV856+fgNDkjMCCkX3hf9E+iLjRRl7LrlPiwhv9+mzBVJUaXpVhwCG8yfMMAlW4VFX
         PXu9BsiD4PowBe9X/fygQbJwRu3I590ggy2T0ko+eOJ+DBP2YNaAYqdSndffW6GQJ+O3
         3jAuJN5SllYgc3T/2/TicgfyQQbN8AoM8ZOA/bLK+nfqqnOio57H08iWEgS6oj4IXKck
         9aDQ==
X-Gm-Message-State: AOAM531kYgrKzYpM8yYCjjZ1+g3t9tW4kY2ND6HXAybD4yW16TEdVB+z
        K4NWDsKcQ8MOevjksF3QeUwrQAU0Y5pQu19gQAQwqB1pIZlhXg==
X-Google-Smtp-Source: ABdhPJy8lpFAzNse6hOMVJbVqIeAsLfXoIN2pqrsW/ill7KySdX1E8J7LtpMEkvEPm/POmBCt9xyPRQy3AQQuWzuxq8=
X-Received: by 2002:a17:902:a60a:b029:f0:ad94:70bf with SMTP id
 u10-20020a170902a60ab02900f0ad9470bfmr2286701plq.31.1621466791889; Wed, 19
 May 2021 16:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch> <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch> <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch> <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
 <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch>
In-Reply-To: <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 19 May 2021 16:26:20 -0700
Message-ID: <CAM_iQpU5HEB_=+ih7_4FKqdkXJ4eYuw_ej5BTOdRK8wFVa7jig@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 2:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Wed, May 19, 2021 at 12:06 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > On Tue, May 18, 2021 at 12:56 PM John Fastabend
> > > > <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Cong Wang wrote:
> > > > > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > >
> > > > > > > Cong Wang wrote:
> > > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > > >
> > > > > > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > > > > > afterward, so udp_read_sock() should free the original skb after
> > > > > > > > done using it.
> > > > > > >
> > > > > > > The clone only happens if sk_psock_verdict_recv() returns >0.
> > > > > >
> > > > > > Sure, in case of error, no one uses the original skb either,
> > > > > > so still need to free it.
> > > > >
> > > > > But the data is going to be dropped then. I'm questioning if this
> > > > > is the best we can do or not. Its simplest sure, but could we
> > > > > do a bit more work and peek those skbs or requeue them? Otherwise
> > > > > if you cross memory limits for a bit your likely to drop these
> > > > > unnecessarily.
> > > >
> > > > What are the benefits of not dropping it? When sockmap takes
> > > > over sk->sk_data_ready() it should have total control over the skb's
> > > > in the receive queue. Otherwise user-space recvmsg() would race
> > > > with sockmap when they try to read the first skb at the same time,
> > > > therefore potentially user-space could get duplicated data (one via
> > > > recvmsg(), one via sockmap). I don't see any benefits but races here.
> > >
> > > The benefit of _not_ dropping it is the packet gets to the receiver
> > > side. We've spent a bit of effort to get a packet across the network,
> > > received on the stack, and then we drop it at the last point is not
> > > so friendly.
> >
> > Well, at least udp_recvmsg() could drop packets too in various
> > scenarios, for example, a copy error. So, I do not think sockmap
> > is special.
>
> OK I am at least convinced now that dropping packets is OK and likely
> a useful performance/complexity compromise.
>
> But, at this point we wont have any visibility into these drops correct?
> Looks like the pattern in UDP stack to handle this is to increment
> sk_drops and UDP_MIB_INERRORS. How about we do that here as well?

We are not dropping the packet, the packet is cloned and deliver to
user-space via sk_psock_verdict_recv(), thus, we are simply leaking
the original skb, regardless of any error. Maybe udp_read_sock()
should check desc->error, but it has nothing to do with this path which
only aims to address a memory leak. A separate patch is need to check
desc->error, if really needed.

Thanks.
