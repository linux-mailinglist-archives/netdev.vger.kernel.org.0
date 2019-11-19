Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91842102A54
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfKSRAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:00:24 -0500
Received: from foss.arm.com ([217.140.110.172]:55510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727968AbfKSRAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 12:00:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 876951FB;
        Tue, 19 Nov 2019 09:00:23 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB02E3F703;
        Tue, 19 Nov 2019 09:00:22 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:00:21 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Heiko Stuebner <heiko@sntech.de>, linux-pci@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-rdma@vger.kernel.org, maz@kernel.org, phil@raspberrypi.org,
        iommu@lists.linux-foundation.org,
        linux-rockchip@lists.infradead.org, f.fainelli@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, mbrugger@suse.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com, Tom Joseph <tjoseph@cadence.com>,
        wahrenst@gmx.net, james.quinlan@broadcom.com,
        Robin Murphy <robin.murphy@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH v2 1/6] linux/log2.h: Add roundup/rounddown_pow_two64()
 family of functions
Message-ID: <20191119170019.GU43905@e119886-lin.cambridge.arm.com>
References: <20191112155926.16476-1-nsaenzjulienne@suse.de>
 <20191112155926.16476-2-nsaenzjulienne@suse.de>
 <20191119111320.GP43905@e119886-lin.cambridge.arm.com>
 <052d07fb4eb79b29dd58cab577d59bab6684329a.camel@suse.de>
 <56cbba61d92f9bc7d0a33c1de379bcd5cf411cb8.camel@suse.de>
 <20191119162849.GT43905@e119886-lin.cambridge.arm.com>
 <20191119165502.GB4991@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119165502.GB4991@ziepe.ca>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 12:55:02PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 19, 2019 at 04:28:50PM +0000, Andrew Murray wrote:
> > On Tue, Nov 19, 2019 at 01:43:39PM +0100, Nicolas Saenz Julienne wrote:
> > > On Tue, 2019-11-19 at 12:30 +0100, Nicolas Saenz Julienne wrote:
> > > > Hi Andrew, thanks for the review.
> > > > > > +/**
> > > > > > + * __roundup_pow_of_two64() - round 64bit value up to nearest power of
> > > > > > two
> > > > > > + * @n: value to round up
> > > > > > + */
> > > > > > +static inline __attribute__((const)) __u64 __roundup_pow_of_two64(__u64
> > > > > > n)
> > > > > 
> > > > > To be consistent with other functions in the same file (__ilog_u64) you may
> > > > > want to rename this to __roundup_pow_of_two_u64.
> > > > 
> > > > Sounds good to me.
> > > > 
> > > > > Also do you know why u64 is used in some places and __u64 in others?
> > > > 
> > > > That's unwarranted, it should be __u64 everywhere.
> > > 
> > > Sorry, now that I look deeper into it, it should be u64.
> > 
> > Do you know the reason why? I'd be interested to know.
> 
> __u64 must be used in header files that are under uapi - ie it is the
> name of the symbol in userspace, and u64 does not exist.
> 
> u64 should be used in all code that is only inside the kernel, ie .c
> files, internal headers, etc
> 
> I routinely discourage use of __uXX in kernel native code.

Thanks for this, much appreciated!

Andrew Murray

> 
> Jason
