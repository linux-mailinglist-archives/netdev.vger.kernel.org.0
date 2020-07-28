Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5106230348
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgG1Gud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:50:33 -0400
Received: from verein.lst.de ([213.95.11.211]:46915 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgG1Gud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 02:50:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB49E68BEB; Tue, 28 Jul 2020 08:50:29 +0200 (CEST)
Date:   Tue, 28 Jul 2020 08:50:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 15/21] net/tcp: add MSG_NETDMA flag for sendmsg()
Message-ID: <20200728065029.GA21479@lst.de>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-16-jonathan.lemon@gmail.com> <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com> <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com> <CANn89iKY27R=ryQLohFPWa9dr6R9dMgB-hj+9eJO6H4NqfVKVw@mail.gmail.com> <20200727173528.tfsrweswpyjxlqv6@bsd-mbp.dhcp.thefacebook.com> <CANn89iKStB8=Exyopi1sufuYhA-rZvYVMOEm9LDgKTLBYiqSmA@mail.gmail.com> <20200728021130.bjrlcj7tzebfxsz3@bsd-mbp.dhcp.thefacebook.com> <CANn89iL=p3pgDpPeWz5rZqGeCdHg=X=hkEPe=mk9TDa=bk7ZRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL=p3pgDpPeWz5rZqGeCdHg=X=hkEPe=mk9TDa=bk7ZRQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 07:17:51PM -0700, Eric Dumazet wrote:
> > The thing is, the existing zero copy code is zero-copy to /host/ memory,
> > which is not the same thing as zero-copy to other memory areas.
> 
> You have to really explain what difference it makes, and why current
> stuff can not be extended.

There basically is none.  You need to call a different dma mapping
routine and make sure to never access the device pages.  See
drivers/pci/p2pdma.c and its users for an example on how to do it
properly.  But the author wants all his crazy hacks to hook into his
proprietary crap, so everyone should be ignore this horrible series.
