Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75A82D8295
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 00:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437016AbgLKXGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 18:06:33 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:56078 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436997AbgLKXGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 18:06:03 -0500
Received: (qmail 2808 invoked by uid 89); 11 Dec 2020 23:05:21 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 11 Dec 2020 23:05:21 -0000
Date:   Fri, 11 Dec 2020 15:05:15 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
Message-ID: <20201211230515.n5i2i2w23zdwnl6q@bsd-mbp.dhcp.thefacebook.com>
References: <20201207210649.19194-3-borisp@mellanox.com>
 <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
 <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
 <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
 <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
 <20201210180108.3eb24f2b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <5cadcfa0-b992-f124-f006-51872c86b804@gmail.com>
 <20201211104445.30684242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <281b12de-7730-05a7-1187-e4f702c19cda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <281b12de-7730-05a7-1187-e4f702c19cda@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 12:59:52PM -0700, David Ahern wrote:
> On 12/11/20 11:45 AM, Jakub Kicinski wrote:
> > Ack, these patches are not exciting (to me), so I'm wondering if there
> > is a better way. The only reason NIC would have to understand a ULP for
> > ZC is to parse out header/message lengths. There's gotta be a way to
> > pass those in header options or such...
> > 
> > And, you know, if we figure something out - maybe we stand a chance
> > against having 4 different zero copy implementations (this, TCP,
> > AF_XDP, netgpu) :(
> 
> AF_XDP is for userspace IP/TCP/packet handling.
> 
> netgpu is fundamentally kernel stack socket with zerocopy direct to
> userspace buffers. Yes, it has more complications like the process is
> running on a GPU, but essential characteristics are header / payload
> split, a kernel stack managed socket, and dedicated H/W queues for the
> socket and those are all common to what the nvme patches are doing. So,
> can we create a common framework for those characteristics which enables
> other use cases (like a more generic Rx zerocopy)?

AF_XDP could also be viewed as a special case of netgpu.
-- 
Jonathan
