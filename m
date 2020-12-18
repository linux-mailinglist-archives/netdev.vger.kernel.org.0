Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16F22DE700
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgLRPyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbgLRPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 10:54:54 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6CCC0617B0;
        Fri, 18 Dec 2020 07:54:14 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id g1so2542499ilk.7;
        Fri, 18 Dec 2020 07:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GG5YSJLZCFDt7QNCE/vwN55fkJ3cTJGKNzrFWdqOj4Y=;
        b=I8OHrapLlq6YAySgnLzaUG5fIukPRzi2ypDxQHAlwDFwWbDbzP4Gx4Vjh3FN3q70Yi
         RuPAXhI9fya4UUTbF3QNGeY0lOcAG6JR2YlRCOrS1xFq6d0lRP/ADWEzMw+tVtzkkOgI
         HsuOAARvvFpjFhEZPfY7Ba9Thof223Rn8eIrjVH+8isZPpez3+R6dVNDcNPJSh8umblt
         WIu5O1OjITKeMKLLnoPi1XltIOVPD+oGRSynTEdoiZKx2shYeYgx2GXWKhAHSpixOa/R
         TEPF2AKOQZ67c6Z/I5tv99+xMsNYP3mmHMQeSfjWIO1Zml63ybQlk4wn8gxKdXDrhqnk
         IyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GG5YSJLZCFDt7QNCE/vwN55fkJ3cTJGKNzrFWdqOj4Y=;
        b=ectchmDsqoTI94cDuU97Bol5+SmgpEltMJpKuYcSq19bYJ+PdhooIbsadxpHHaLgMe
         +nFfzvgT1dRDNPobwj+hnkUnocUfDdzAP88BE4a1JqQeLC9Ulf8QHhPrTEEXS5hC1c/s
         XKh/1x2OaX9vxD7cekOPJWivGf73vfsNWx34l7pmSe1EHz2FKUBPAO17hNtYATA29OgB
         o1tiV1NZBmTd4vQ0L2AbkCkFtHpoBdDv2JCa3UkZamitpX0nQ5EHHTvuZHD3ssRcQjbM
         hyQS9pdyeD1vPrEi48RedAdoBsv5Y6Dq8N/6CH0kuzZZJCnvWgXcVKUgfcGYYdqteeu6
         8aCg==
X-Gm-Message-State: AOAM533ZevvCv6D+n0wII3I0PVgU/ly351Yd5oXn1gxoj19G/AOYden2
        wgh57osiBG45VSHJm/LtafPkdCbmIeLueUNmAZo=
X-Google-Smtp-Source: ABdhPJzRTRU+B7kA5MlG5AyxI9xE6wNPHLtokoBbiINqAgP2ChnLZdvQboeLJBHdjHtSw/YJYgOnJZ5rFEXdk3XSq1k=
X-Received: by 2002:a92:d8cc:: with SMTP id l12mr4455778ilo.64.1608306853720;
 Fri, 18 Dec 2020 07:54:13 -0800 (PST)
MIME-Version: 1.0
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com> <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
 <fa864ac9-8a7e-ce42-b93b-1a2762386caf@gmail.com>
In-Reply-To: <fa864ac9-8a7e-ce42-b93b-1a2762386caf@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 18 Dec 2020 07:54:02 -0800
Message-ID: <CAKgT0UcyyaWOw1BnH8XSW2Endpm+1EqHGtrwj1kjtkTDpNUprw@mail.gmail.com>
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

On Thu, Dec 17, 2020 at 7:55 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/17/20 8:11 PM, Alexander Duyck wrote:
> > On Thu, Dec 17, 2020 at 5:30 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 12/16/20 3:53 PM, Alexander Duyck wrote:
> >>> The problem in my case was based on a past experience where east-west
> >>> traffic became a problem and it was easily shown that bypassing the
> >>> NIC for traffic was significantly faster.
> >>
> >> If a deployment expects a lot of east-west traffic *within a host* why
> >> is it using hardware based isolation like a VF. That is a side effect of
> >> a design choice that is remedied by other options.
> >
> > I am mostly talking about this from past experience as I had seen a
> > few instances when I was at Intel when it became an issue. Sales and
> > marketing people aren't exactly happy when you tell them "don't sell
> > that" in response to them trying to sell a feature into an area where
>
> that's a problem engineers can never solve...
>
> > it doesn't belong. Generally they want a solution. The macvlan offload
> > addressed these issues as the replication and local switching can be
> > handled in software.
>
> well, I guess almost never. :-)
>
> >
> > The problem is PCIe DMA wasn't designed to function as a network
> > switch fabric and when we start talking about a 400Gb NIC trying to
> > handle over 256 subfunctions it will quickly reduce the
> > receive/transmit throughput to gigabit or less speeds when
> > encountering hardware multicast/broadcast replication. With 256
> > subfunctions a simple 60B ARP could consume more than 19KB of PCIe
> > bandwidth due to the packet having to be duplicated so many times. In
> > my mind it should be simpler to simply clone a single skb 256 times,
> > forward that to the switchdev ports, and have them perform a bypass
> > (if available) to deliver it to the subfunctions. That's why I was
> > thinking it might be a good time to look at addressing it.
> >
>
> east-west traffic within a host is more than likely the same tenant in
> which case a proper VPC is a better solution than the s/w stack trying
> to detect and guess that a bypass is needed. Guesses cost cycles in the
> fast path which is a net loss - and even more so as speeds increase.

Yes, but this becomes the hardware limitations deciding the layout of
the network. I lean towards more flexibility to allow more
configuration options being a good thing rather than us needing to
dictate how a network has to be constructed based on the limitations
of the hardware and software.

For broadcast/multicast it isn't so much a guess. It would be a single
bit test. My understanding is the switchdev setup is already making
special cases for things like broadcast/multicast due to the extra
overhead incurred. I mentioned ARP because in many cases it has to be
offloaded specifically due to these sorts of issues.
