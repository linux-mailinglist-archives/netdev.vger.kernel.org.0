Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0B5838B1
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732788AbfHFSiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:38:24 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34263 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbfHFSiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:38:24 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so63705205qkt.1
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t0FZaLhTQo8X5m9sJH3jai3ugnitzUTUhXxicv7YDk8=;
        b=DzULNXQEJNZwg345/aqx14lziCowwmZZ111AycKfFi5XM1I301Ud8rtZZt1wgeF5Pl
         UU6wbBcMywCdYe2A00lP3rFFRmRHkverVEso5c/xpaLDR8J1XMlG7KG83Vs1L8jQdWhi
         o82MwcEtBdtL0DJveIufG1vt+LkvzW6Fe5LtJGtcF3gNTJmIummsJdbcVlAV3fyEpO46
         6VVPQLT6TIe9NED3IcRJk8e+lTOltkPSvmuu6jEvNkJHdRpRrIsHpypmQJKpFVqidOGc
         9UEGDh2qogUsM6aedOr0W515t9WTNWR1c68j4XvUSFM/riUM3zuVVTRliMQEO0XOPTUX
         EA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t0FZaLhTQo8X5m9sJH3jai3ugnitzUTUhXxicv7YDk8=;
        b=Fzd/EpZmIDrVPx0WkJ6N45zSC/OiQwOcU0jqySJ1XEO4+nmdrUTbNpaKumvN0NjRRA
         sFNt4pkrB4LOkjRv18kUL53ZEKCTeQdVgDf1tuukXKf3pRjsq708I8PnrNZ1Gvab8mRz
         ChZWMDgl8cW6LoUD1O+0rXfivnEx7LIBaSaoFi/Lzwtt//LUwLiXxJxihffN8Y+jMJtk
         DzKfNRT7ConNfkM7dmZTKGhSbxJqB/RY46WdGex9s9JR+qlZ8a36Y6b8AUmyccRGuXwm
         jvj7/8C+61+FaIFF/scEdGZVdqgvjMY/mkyrNtQ4sz5lCIGxGsgXn+2WTVf77w1u+kef
         zEDg==
X-Gm-Message-State: APjAAAXygKr2+nQBkG+IKGRz4crUS8Yg/e0sHyYknJUSX2dQR2B72cMq
        2udoXu6WMKqthkdfzaiH6IhLBg==
X-Google-Smtp-Source: APXvYqyTCcAt6GJ8H61tbGk2kUskSoko6Ijz7dJpmZwAc8BT25Kjo621gYUI55QkHQ/0656a/D+FUw==
X-Received: by 2002:a05:620a:124f:: with SMTP id a15mr4630085qkl.173.1565116702615;
        Tue, 06 Aug 2019 11:38:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id d141sm37790010qke.3.2019.08.06.11.38.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Aug 2019 11:38:21 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hv4Ll-0004NN-6J; Tue, 06 Aug 2019 15:38:21 -0300
Date:   Tue, 6 Aug 2019 15:38:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Message-ID: <20190806183821.GR11627@ziepe.ca>
References: <20190802164828.20243-1-hslester96@gmail.com>
 <20190804125858.GJ4832@mtr-leonro.mtl.com>
 <CANhBUQ2H5MU0m2xM0AkJGPf7+MJBZ3Eq5rR0kgeOoKRi4q1j6Q@mail.gmail.com>
 <20190805061320.GN4832@mtr-leonro.mtl.com>
 <CANhBUQ0tUTXQKq__zvhNCUxXTFfDyr2xKF+Cwupod9xmvSrw2A@mail.gmail.com>
 <b19b7cd49d373cc51d3e745a6444b27166b88304.camel@mellanox.com>
 <20190806065958.GQ4832@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806065958.GQ4832@mtr-leonro.mtl.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 09:59:58AM +0300, Leon Romanovsky wrote:
> On Mon, Aug 05, 2019 at 08:06:36PM +0000, Saeed Mahameed wrote:
> > On Mon, 2019-08-05 at 14:55 +0800, Chuhong Yuan wrote:
> > > On Mon, Aug 5, 2019 at 2:13 PM Leon Romanovsky <leon@kernel.org>
> > > wrote:
> > > > On Sun, Aug 04, 2019 at 10:44:47PM +0800, Chuhong Yuan wrote:
> > > > > On Sun, Aug 4, 2019 at 8:59 PM Leon Romanovsky <leon@kernel.org>
> > > > > wrote:
> > > > > > On Sat, Aug 03, 2019 at 12:48:28AM +0800, Chuhong Yuan wrote:
> > > > > > > refcount_t is better for reference counters since its
> > > > > > > implementation can prevent overflows.
> > > > > > > So convert atomic_t ref counters to refcount_t.
> > > > > >
> > > > > > I'm not thrilled to see those automatic conversion patches,
> > > > > > especially
> > > > > > for flows which can't overflow. There is nothing wrong in using
> > > > > > atomic_t
> > > > > > type of variable, do you have in mind flow which will cause to
> > > > > > overflow?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > I have to say that these patches are not done automatically...
> > > > > Only the detection of problems is done by a script.
> > > > > All conversions are done manually.
> > > >
> > > > Even worse, you need to audit usage of atomic_t and replace there
> > > > it can overflow.
> > > >
> > > > > I am not sure whether the flow can cause an overflow.
> > > >
> > > > It can't.
> > > >
> > > > > But I think it is hard to ensure that a data path is impossible
> > > > > to have problems in any cases including being attacked.
> > > >
> > > > It is not data path, and I doubt that such conversion will be
> > > > allowed
> > > > in data paths without proving that no performance regression is
> > > > introduced.
> > > > > So I think it is better to do this minor revision to prevent
> > > > > potential risk, just like we have done in mlx5/core/cq.c.
> > > >
> > > > mlx5/core/cq.c is a different beast, refcount there means actual
> > > > users
> > > > of CQ which are limited in SW, so in theory, they have potential
> > > > to be overflown.
> > > >
> > > > It is not the case here, there your are adding new port.
> > > > There is nothing wrong with atomic_t.
> > > >
> > >
> > > Thanks for your explanation!
> > > I will pay attention to this point in similar cases.
> > > But it seems that the semantic of refcount is not always as clear as
> > > here...
> > >
> >
> > Semantically speaking, there is nothing wrong with moving to refcount_t
> > in the case of vxlan ports.. it also seems more accurate and will
> > provide the type protection, even if it is not necessary. Please let me
> > know what is the verdict here, i can apply this patch to net-next-mlx5.
> 
> There is no verdict here, it is up to you., if you like code churn, go
> for it.

IMHO CONFIG_REFCOUNT_FULL is a valuable enough reason to not open code
with an atomic even if overflow is not possible. 

Races resulting in incrs on 0 refcounts is a common enough mistake.

Jason
