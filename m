Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD372DB98E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 04:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLPDNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 22:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgLPDNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 22:13:42 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E090C0613D6;
        Tue, 15 Dec 2020 19:13:02 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id w18so8742870iot.0;
        Tue, 15 Dec 2020 19:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zciCfroef8BEDYm6Z8Bx+E+7ujr0YogOSSSjOTq2zwY=;
        b=M8kbnm+h1SZN8rrINPdNdUAp4S3HtGAzOZoN5OJflf4URO17tZfBgAIDGGXc4yfU2e
         rUt2t0TuDKum+jxw6JfYVFuhEl50hz/TIajbAJzgLWqrpqJip8BbDSviVex0RuQR0PyB
         DwFY+8jSI0mHBi//MQro4j795Y1hi1AO56xGt2rvYdAV1HeXdSzuRghIP+6nQYu33URX
         dnc6/+TiCyArR5gYiCbup1+QjlTTjJ52W+xZqlTMPbPDxzDOieetLIUABYdYinBOL9qz
         1bDriQTBTCdjhNLd3TzpCjlp3ARBNTHJIIxwTtxOlG/7IqYmPK2poHT6SjLg5G//orLJ
         rV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zciCfroef8BEDYm6Z8Bx+E+7ujr0YogOSSSjOTq2zwY=;
        b=pB6fX5ZgxXZKkqH439Omu44RewypJCiOuxqnm6b9pVhFDXTcWYAFygazumqZmiMPid
         G6mcmVBnKvAMZjpM2FW9zSIYjWWM7mdmNpuGO3PD+bAJR2TUJs019F9BqyhyhF3YbUXI
         0u23tKcFGEXAuonfhADAm2D+M7zUlq+3Ls8WSXSjvnSfaw9Vfb6B40VNCjBcok/TQsHI
         Bar5CB9pFod++ARTaAoQ0XSndelx3Dp4WsJ35FprBvRdp/PqPY11owHNEWOxateRTSFz
         Iy4u3g7pFA/SvH48DSgfkxue0ixnEgysRV8AyJyq0uhSai2h+2vGhVRvGQWlfgEYUi7P
         zdxQ==
X-Gm-Message-State: AOAM533WNex5kaEb1/jUPwln40yjJe1buUG1uOK+NJ0Mg181m8VlHhZn
        lmQsWLDPn9XgVumGyAJQH5fYosfmroHmh0HBT5E7F2rBEO/Gfw==
X-Google-Smtp-Source: ABdhPJwwYvJvMgPT0JqbhiGHU7nc799eUND5Xfys3fDlokbHxynSavv7tdmvK/9QTROinEXCoIldQcSNCvY1mtTdETU=
X-Received: by 2002:a02:4:: with SMTP id 4mr41347021jaa.121.1608088381652;
 Tue, 15 Dec 2020 19:13:01 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com> <CAKOOJTybz71h6V5228vk1erusfb-QJQEQPOaRKzmspfotRHYhA@mail.gmail.com>
In-Reply-To: <CAKOOJTybz71h6V5228vk1erusfb-QJQEQPOaRKzmspfotRHYhA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 15 Dec 2020 19:12:50 -0800
Message-ID: <CAKgT0UdXxLB-TAOB3BbP2NuDeeoza5XwPh-TO+b-KzJe4dEcLw@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
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

On Tue, Dec 15, 2020 at 5:13 PM Edwin Peer <edwin.peer@broadcom.com> wrote:
>
> On Tue, Dec 15, 2020 at 10:49 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>
> > It isn't "SR-IOV done right" it seems more like "VMDq done better".
>
> I don't think I agree with that assertion. The fact that VMDq can talk
> to a common driver still makes VMDq preferable in some respects. Thus,
> subfunctions do appear to be more of a better SR-IOV than a better
> VMDq, but I'm similarly not sold on whether a better SR-IOV is
> sufficient benefit to warrant the additional complexity this
> introduces. If I understand correctly, subfunctions buy two things:
>
> 1) More than 256 SFs are possible: Maybe it's about time PCI-SIG
> addresses this limit for VFs? If that were the only problem with VFs,
> then fixing it once there would be cleaner. The devlink interface for
> configuring a SF is certainly more sexy than legacy SR-IOV, but it
> shouldn't be fundamentally impossible to zhuzh up VFs either. One can
> also imagine possibilities around remapping multiple PFs (and their
> VFs) in a clever way to get around the limited number of PCI resources
> exposed to the host.

The fact is SR-IOV just wasn't designed to scale well. I think we are
probably going to see most vendors move away from it.

The fact is what we are talking about now is the future of all this
and how to implement Scalable I/O Virtualization
(https://software.intel.com/content/www/us/en/develop/download/intel-scalable-io-virtualization-technical-specification.html).
The document is a good primer to many of the features we are
discussing as it describes how to compose a device.

The problem is as it was with SR-IOV that the S-IOV specification is
very PCIe centric and doesn't do a good job explaining how to deal
with the network as it relates to all this. Then to complicate things
the S-IOV expected this to be used with direct assigned devices for
guests/applications and instead we are talking about using the devices
in the host which makes things a bit messier.

> 2) More flexible division of resources: It's not clear that device
> firmwarre can't perform smarter allocation than N/<num VFs>, but
> subfunctions also appear to allow sharing of certain resources by the
> PF driver, if desirable. To the extent that resources are shared, how
> are workloads isolated from each other?
>
> I'm not sure I like the idea of having to support another resource
> allocation model in our driver just to support this, at least not
> without a clearer understanding of what is being gained.

I view this as the future alternative to SR-IOV. It is just a matter
of how we define it. Eventually we probably would be dropping the
SR-IOV implementation and instead moving over to S-IOV as an
alternative instead. As such if this is done right I don't see this as
a thing where we need to support both. Really we should be able to
drop support for one if we have the other.
