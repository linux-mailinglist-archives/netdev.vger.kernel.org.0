Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578628BAFC
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfHMOA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:00:28 -0400
Received: from scorn.kernelslacker.org ([45.56.101.199]:46110 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfHMOA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:00:28 -0400
Received: from [2601:196:4600:6634:ae9e:17ff:feb7:72ca] (helo=wopr.kernelslacker.org)
        by scorn.kernelslacker.org with esmtp (Exim 4.92)
        (envelope-from <davej@codemonkey.org.uk>)
        id 1hxXLe-0002cu-1v; Tue, 13 Aug 2019 10:00:26 -0400
Received: by wopr.kernelslacker.org (Postfix, from userid 1026)
        id 542FE560187; Tue, 13 Aug 2019 10:00:25 -0400 (EDT)
Date:   Tue, 13 Aug 2019 10:00:25 -0400
From:   Dave Jones <davej@codemonkey.org.uk>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alexis Bauvin <abauvin@scaleway.com>, netdev@vger.kernel.org
Subject: Re: tun: mark small packets as owned by the tap sock
Message-ID: <20190813140025.GA17823@codemonkey.org.uk>
References: <git-mailbomb-linux-master-4b663366246be1d1d4b1b8b01245b2e88ad9e706@kernel.org>
 <20190812221954.GA13314@codemonkey.org.uk>
 <6b16739e-ab96-9c93-9636-5b80b81c2b20@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b16739e-ab96-9c93-9636-5b80b81c2b20@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Note: SpamAssassin invocation failed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 04:33:59PM +0800, Jason Wang wrote:
 > 
 > On 2019/8/13 上午6:19, Dave Jones wrote:
 > > On Wed, Aug 07, 2019 at 12:30:07AM +0000, Linux Kernel wrote:
 > >   > Commit:     4b663366246be1d1d4b1b8b01245b2e88ad9e706
 > >   > Parent:     16b2084a8afa1432d14ba72b7c97d7908e178178
 > >   > Web:        https://git.kernel.org/torvalds/c/4b663366246be1d1d4b1b8b01245b2e88ad9e706
 > >   > Author:     Alexis Bauvin <abauvin@scaleway.com>
 > >   > AuthorDate: Tue Jul 23 16:23:01 2019 +0200
 > >   >
 > >   >     tun: mark small packets as owned by the tap sock
 > >   >
 > >   >     - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size
 > >
 > > This commit breaks ipv6 routing when I deployed on it a linode.
 > > It seems to work briefly after boot, and then silently all packets get
 > > dropped. (Presumably, it's dropping RA or ND packets)
 > >
 > > With this reverted, everything works as it did in rc3.
 > >
 > Two questions:
 > 
 > - Are you using XDP for TUN?

not knowingly.  
$ grep XDP .config
# CONFIG_XDP_SOCKETS is not set

What's configured on the hypervisor side I have no idea.

 > - Does it work before 66ccbc9c87c2?

that's been around since 4.14-rc1, and at one point it ran whatever was
in debian9 (4.9).  I don't recall it ever not working, so I'd say yes.

I can build a 4.13 if it'll prove something, but it'll take me a while.
(This is my primary MX, so it's dropping email while it's on the broken
 kernel, so I need to plan some time to be around to babysit it)

 > If yes, could you show us the result of net_dropmonitor?

where do I get that?  It doesn't seem packaged for debian.

	Dave

