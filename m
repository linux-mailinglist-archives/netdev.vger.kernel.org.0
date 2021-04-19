Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C76363B60
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbhDSGU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhDSGUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 02:20:55 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F93C06174A;
        Sun, 18 Apr 2021 23:20:26 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id p2so8074274pgh.4;
        Sun, 18 Apr 2021 23:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ezRYPA67jeMC8C9EWs9Ki9/ijbprU5hhVKkaedlFpEU=;
        b=t9idlPCVG7qbp5TtcZvprGTEr875JbVd+8+CZQ662DhQGxJYPoMHPIhaekZa11e/DJ
         Dwtyt0gTlUNZPpZT3+n3MSwu0DgsrZyJiWK7zNM0JxIIzBDPS3F4rZDavBtmvZB4dg8Z
         +AWgnqAgPrM67Htw3N0BIqgXJpidNcCtqaoE6y3E4sZJF2weU33sWvD9dproLbHpJk8g
         Q5CPweoD5y/bc3iherPcPFI9MzJVOcZk4lb5Bcv5aY1qR2pAd/YKC41nyo3ZZXqEYoTl
         cdL7B6CA7LxZVlqix4649mOR/Vq/tzsp7TQAjHFL1hCKvMXpmMyKXiNThbKOjsmWPA2s
         SLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ezRYPA67jeMC8C9EWs9Ki9/ijbprU5hhVKkaedlFpEU=;
        b=coHTCQeBlu/cOOYeKusgnXDzOtAAyhvOEgdfovPGPaGz02KUWN/PHLySBfpuueXZdi
         y1yEvXKq+mIDivEYz8f3DO+CLJCKusSkdcQA2EmbYsDovqvIiAi/JF5RYml6iTwT9P73
         KXW0k6/076uT3/cXer6RTaO5R+otuual3yatjWXk6EPyjIgMowRJnoz0fUd66wXUcVTE
         yvgqYEpTd9EJV08QgiXuZ5AF6d82YievNH6YPbLxQfsBFCJDa81lrMANtlBSrI7ZaolM
         Wi3xPs7iggmZna5B/ZJLK1F+n5azgRJoayxJ3YnDHNmrXixSwy/L2iEvLMDL4s5kD9pl
         TptA==
X-Gm-Message-State: AOAM532GCDoe0P5QPqsjOi6BRhAqFBvMl6u3i3xDxZW993HcDJgZOwHF
        hfbwcteXB1b0bjbnm3I+xtKF5WuPuGSVGPJnAzw=
X-Google-Smtp-Source: ABdhPJzjH0rLVvRnal7R8v1xBeXGip3oImljC4hpaa4en3m2jNjU4oziXL0bpGhfe40IZmOG7carm1daWIfDsLbnrOo=
X-Received: by 2002:aa7:82ce:0:b029:242:deb4:9442 with SMTP id
 f14-20020aa782ce0000b0290242deb49442mr18724815pfn.73.1618813225693; Sun, 18
 Apr 2021 23:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org> <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <20210418181801.17166935@carbon>
In-Reply-To: <20210418181801.17166935@carbon>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 19 Apr 2021 08:20:14 +0200
Message-ID: <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 6:18 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Fri, 16 Apr 2021 16:27:18 +0200
> Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
>
> > On Thu, Apr 8, 2021 at 2:51 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > > please focus on how these new types of xdp_{buff,frame} packets
> > > traverse the different layers and the layout design. It is on purpose
> > > that BPF-helpers are kept simple, as we don't want to expose the
> > > internal layout to allow later changes.
> > >
> > > For now, to keep the design simple and to maintain performance, the XDP
> > > BPF-prog (still) only have access to the first-buffer. It is left for
> > > later (another patchset) to add payload access across multiple buffers.
> > > This patchset should still allow for these future extensions. The goal
> > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > same performance as before.
> [...]
> > >
> > > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
> > > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> > > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver (XDPmulti-buffers section)
> >
> > Took your patches for a test run with the AF_XDP sample xdpsock on an
> > i40e card and the throughput degradation is between 2 to 6% depending
> > on the setup and microbenchmark within xdpsock that is executed. And
> > this is without sending any multi frame packets. Just single frame
> > ones. Tirtha made changes to the i40e driver to support this new
> > interface so that is being included in the measurements.
>
> Could you please share Tirtha's i40e support patch with me?

We will post them on the list as an RFC. Tirtha also added AF_XDP
multi-frame support on top of Lorenzo's patches so we will send that
one out as well. Will also rerun my experiments, properly document
them and send out just to be sure that I did not make any mistake.

Just note that I would really like for the multi-frame support to get
in. I have lost count on how many people that have asked for it to be
added to XDP and AF_XDP. So please check our implementation and
improve it so we can get the overhead down to where we want it to be.

Thanks: Magnus

> I would like to reproduce these results in my testlab, in-order to
> figure out where the throughput degradation comes from.
>
> > What performance do you see with the mvneta card? How much are we
> > willing to pay for this feature when it is not being used or can we in
> > some way selectively turn it on only when needed?
>
> Well, as Daniel says performance wise we require close to /zero/
> additional overhead, especially as you state this happens when sending
> a single frame, which is a base case that we must not slowdown.
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
