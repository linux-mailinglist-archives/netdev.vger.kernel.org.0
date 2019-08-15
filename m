Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8D8E464
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 07:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbfHOFLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 01:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730169AbfHOFLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 01:11:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 008DB2A09A0;
        Thu, 15 Aug 2019 05:11:43 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C39CA5D6A5;
        Thu, 15 Aug 2019 05:11:41 +0000 (UTC)
Subject: Re: tun: mark small packets as owned by the tap sock
To:     Dave Jones <davej@codemonkey.org.uk>
Cc:     Alexis Bauvin <abauvin@scaleway.com>, netdev@vger.kernel.org
References: <git-mailbomb-linux-master-4b663366246be1d1d4b1b8b01245b2e88ad9e706@kernel.org>
 <20190812221954.GA13314@codemonkey.org.uk>
 <6b16739e-ab96-9c93-9636-5b80b81c2b20@redhat.com>
 <20190813140025.GA17823@codemonkey.org.uk>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b89eae9f-edae-0efd-109f-3b7849baa8ed@redhat.com>
Date:   Thu, 15 Aug 2019 13:11:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813140025.GA17823@codemonkey.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 15 Aug 2019 05:11:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/13 下午10:00, Dave Jones wrote:
> On Tue, Aug 13, 2019 at 04:33:59PM +0800, Jason Wang wrote:
>   >
>   > On 2019/8/13 上午6:19, Dave Jones wrote:
>   > > On Wed, Aug 07, 2019 at 12:30:07AM +0000, Linux Kernel wrote:
>   > >   > Commit:     4b663366246be1d1d4b1b8b01245b2e88ad9e706
>   > >   > Parent:     16b2084a8afa1432d14ba72b7c97d7908e178178
>   > >   > Web:        https://git.kernel.org/torvalds/c/4b663366246be1d1d4b1b8b01245b2e88ad9e706
>   > >   > Author:     Alexis Bauvin <abauvin@scaleway.com>
>   > >   > AuthorDate: Tue Jul 23 16:23:01 2019 +0200
>   > >   >
>   > >   >     tun: mark small packets as owned by the tap sock
>   > >   >
>   > >   >     - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size
>   > >
>   > > This commit breaks ipv6 routing when I deployed on it a linode.
>   > > It seems to work briefly after boot, and then silently all packets get
>   > > dropped. (Presumably, it's dropping RA or ND packets)
>   > >
>   > > With this reverted, everything works as it did in rc3.
>   > >
>   > Two questions:
>   >
>   > - Are you using XDP for TUN?
>
> not knowingly.
> $ grep XDP .config
> # CONFIG_XDP_SOCKETS is not set
>
> What's configured on the hypervisor side I have no idea.


Ok, please tell me more about your setups:

- Are you using TUN in host or guest?

- Are you using it for VM or VPN(tunneling)?

- Where did the packet get dropped?


>
>   > - Does it work before 66ccbc9c87c2?
>
> that's been around since 4.14-rc1, and at one point it ran whatever was
> in debian9 (4.9).  I don't recall it ever not working, so I'd say yes.
>
> I can build a 4.13 if it'll prove something, but it'll take me a while.
> (This is my primary MX, so it's dropping email while it's on the broken
>   kernel, so I need to plan some time to be around to babysit it)


If possible please try that.


>
>   > If yes, could you show us the result of net_dropmonitor?
>
> where do I get that?  It doesn't seem packaged for debian.
>
> 	Dave


It's part of perf-script(1). You can simply start it through perf script 
record net_dropmonitor.

Thanks

>
