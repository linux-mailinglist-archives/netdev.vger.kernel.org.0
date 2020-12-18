Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7F2DDD33
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 04:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbgLRDML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 22:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbgLRDML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 22:12:11 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B09C06138C;
        Thu, 17 Dec 2020 19:11:31 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id x15so910429ilq.1;
        Thu, 17 Dec 2020 19:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBUXaP6l2Qi4Gx1FjoPyjKe2Fr+H1yUYAGwBlsF05jM=;
        b=CW3GrgoHk6PhhRj2enQgSJm9hhe+kQRuY4x0LmTgCnbSumhbkHSHmp5/RVl2jSor9s
         81wh+c/tAmiH/uGPp4wjQoIn3ft2riGRpfd6EasiwsK3uVF8mbkzht5a+C4YwTzK4kH2
         V+yYc6iXO82feXMER1pKmdqJZqLUnd/QLXbP48sBlagmnPkVP52m1WHm4Z0xbd7Y6Jkf
         mhCrwdcAK6RXJSHfkNU3pCdisCVReeO55NLYhCn+D3IsOqI1YX4yxE1FHmXXXCVI/5L6
         TstsQyfv7Rt+cmhW3ftO8/B0AgYLtMqTGA0YDtfh083/C/sC+uIIHc9PZNpObv6if+JB
         Bluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBUXaP6l2Qi4Gx1FjoPyjKe2Fr+H1yUYAGwBlsF05jM=;
        b=mRULnnPcsi5OmVTb+z7+A3xIxk3u3jl9CBsK+mLDB0WxD1F1dMcn0+luKEGdr+VfyY
         4bGdvV+36NhUXmB8KSBQ3OmhTUqDSP+KqCqP0NpwdXPoLrEXbccTqD57ktY+fFUE8IfR
         ueFMsm8+UJjuoP7OOdjnnD9NTgLEEENuFc1KIXvW8YVa4SoKaGL6T9V+P+UHkkO31RyE
         k7j8A6kOqMf8dKJbrnjXCboOtBEdEm6tFAxeONg2lg3QQF1cTRjI3zQgg8eW7dU709Wx
         CPJNdNPeoljl97ZJdWNwtYj91Tap+ETTN8832Yz5HEt4kZaipk0/UCmGo/mD98BmXoSM
         2grg==
X-Gm-Message-State: AOAM531yVWmlYDQY1sNmElZbq41Q21OOjMmBtjFfxcnhG4NEVAcDj0+u
        rLLX0W4ePEHwWisNEOX9vvU8S5in/H/nC+JQpew=
X-Google-Smtp-Source: ABdhPJyvesF1cyHa/WiJRus8Y9gicNHDSRJRA/LpcROSeW+GWRXM4cOKk8egTBuvuDP6SaZKxuDqz8hFTxX8NKwbBow=
X-Received: by 2002:a92:d44f:: with SMTP id r15mr1867518ilm.237.1608261090360;
 Thu, 17 Dec 2020 19:11:30 -0800 (PST)
MIME-Version: 1.0
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
In-Reply-To: <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 17 Dec 2020 19:11:19 -0800
Message-ID: <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     David Ahern <dsahern@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 5:30 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/16/20 3:53 PM, Alexander Duyck wrote:
> > The problem in my case was based on a past experience where east-west
> > traffic became a problem and it was easily shown that bypassing the
> > NIC for traffic was significantly faster.
>
> If a deployment expects a lot of east-west traffic *within a host* why
> is it using hardware based isolation like a VF. That is a side effect of
> a design choice that is remedied by other options.

I am mostly talking about this from past experience as I had seen a
few instances when I was at Intel when it became an issue. Sales and
marketing people aren't exactly happy when you tell them "don't sell
that" in response to them trying to sell a feature into an area where
it doesn't belong. Generally they want a solution. The macvlan offload
addressed these issues as the replication and local switching can be
handled in software.

The problem is PCIe DMA wasn't designed to function as a network
switch fabric and when we start talking about a 400Gb NIC trying to
handle over 256 subfunctions it will quickly reduce the
receive/transmit throughput to gigabit or less speeds when
encountering hardware multicast/broadcast replication. With 256
subfunctions a simple 60B ARP could consume more than 19KB of PCIe
bandwidth due to the packet having to be duplicated so many times. In
my mind it should be simpler to simply clone a single skb 256 times,
forward that to the switchdev ports, and have them perform a bypass
(if available) to deliver it to the subfunctions. That's why I was
thinking it might be a good time to look at addressing it.
