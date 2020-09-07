Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE0D26063B
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgIGVZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:25:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:45304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgIGVZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:25:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90EB1ABA2;
        Mon,  7 Sep 2020 21:25:43 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8D162603AD; Mon,  7 Sep 2020 23:25:42 +0200 (CEST)
Date:   Mon, 7 Sep 2020 23:25:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Kevin(Yudong) Yang" <yyd@google.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH ethtool,v2] ethtool: add support show/set-time-stamping
Message-ID: <20200907212542.rnwzu3cn24uewyk4@lion.mk-sys.cz>
References: <20200903140714.1781654-1-yyd@google.com>
 <20200907125312.evg6kio5dt3ar6c6@lion.mk-sys.cz>
 <CANn89iKZ19+AJOf5_5orPrUObYef+L-HrwF_Oay6o75ZbG7UhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKZ19+AJOf5_5orPrUObYef+L-HrwF_Oay6o75ZbG7UhQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 06:56:20PM +0200, Eric Dumazet wrote:
> On Mon, Sep 7, 2020 at 2:53 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > As I said in response to v1 patch, I don't like the idea of adding a new
> > ioctl interface to ethool when we are working on replacing and
> > deprecating the existing ones. Is there a strong reason why this feature
> > shouldn't be implemented using netlink?
> 
> I do not think this is a fair request.
> 
> All known kernels support the ioctl(), none of them support netlink so far.

Several years ago, exactly the same was true for bonding, bridge or vlan
configuration: all known kernels supported ioctl() or sysfs interfaces
for them, none supported netlink at that point. By your logic, the right
course of action would have been using ioctl() and sysfs for iproute2
support. Instead, rtnetlink interfaces were implemented and used by
iproute2. I believe it was the right choice.

> Are you working on the netlink interface, or are you requesting us to
> implement it ?

If it helps, I'm willing to write the kernel side. Or both, if
necessary, just to avoid adding another ioctl monument that would have
to be kept and maintained for many years, maybe forever.

> The ioctl has been added years ago, and Kevin patch is reasonable enough.

And there is a utility using the ioctl, as Andrew pointed out. Just like
there were brctl and vconfig and ioctl they were using. The existence of
those ioctl was not considered sufficient reason to use them when bridge
and vlan support was added to iproute2. I don't believe today's
situation with ethtool is different.

Michal
