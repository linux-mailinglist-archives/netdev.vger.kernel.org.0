Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31951709F1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 21:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgBZUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 15:42:40 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43127 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbgBZUmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 15:42:40 -0500
Received: by mail-qt1-f195.google.com with SMTP id g21so557884qtq.10
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 12:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i88oqqwGwa149ArRLuVW7H77TVeoVzHvwQKN4q66IIM=;
        b=MEr0ISDHqnCdVLRtSfviOXm6RbiP7/A1qgWyYq0gIb/y4VyyvBE5gVdLxHAHoo0wca
         HH+WDRnHo7qnzjeTQDBW9rUyUmlwd/5UsPmOjzCYeBGg21bXmnWMCg+1D+enEY74ZnB0
         5tssh0vpdDn/hhryTYlqVHUtoGnGvKAy9I42SNw0Y/cJChLwdIsxFXLU5TTec7NUcHg4
         vZVmiF+SIWdAUBntw4jskQj49pP72/EumL5+hQuyBIev/ESdfXaTYCSlRmekzjuAJIrj
         hyI3D79b7CAqZtO0RjjYL638NAXYE1qvUQMv9JZzXeCvGb1/Wm625j6+VLFYkESI+vRn
         elsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i88oqqwGwa149ArRLuVW7H77TVeoVzHvwQKN4q66IIM=;
        b=knwHvi10afPfiztSdQa5Q3GPGtftxdCOfU66a3bOF2iKHsTr0UByKhI3QlOJB+6sg8
         8ddbIgwlz6TwjJxY6l5hwkQ7hDaDqFNXN31Dm3wyqoCGlgRgkR71x7FVqJxN8QUmsyWk
         lteO6D3KsE/9pE273PRVREDJTUg2BnGODSNMq8Pzodf9rNFXd+q7uugBRrWrFdHt0mKW
         UzEH6jeiTFJKYVb/IP/MpBMj2C3wAnHoGfQL1z1dWBiw+7y5OCesKVijOfNbrS8TlS+B
         qJgqa33QeCcYVay5nWvmw4okIPIoTKsO0iYPuCXlxM3nIrrLppLC5ru8XLbeWo+lDfFV
         Mc+Q==
X-Gm-Message-State: APjAAAWMnIIAKRhxhmCP0glB/VwaLAJ0tSRnEfKIEC5Ffh8xx6FzdOfY
        YTfNghU3sBzAWGwqqvuHTOxIPA==
X-Google-Smtp-Source: APXvYqx53Kv6dlkpnWhxarlrn/AR/8PRwFcE3tS1Fxn5FfuavCYSzPwTtNfx7Ycj+DTtHjqHDi/dcQ==
X-Received: by 2002:ac8:377a:: with SMTP id p55mr785701qtb.87.1582749759314;
        Wed, 26 Feb 2020 12:42:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t13sm1726812qkm.60.2020.02.26.12.42.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Feb 2020 12:42:38 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j73Vu-0007FH-8G; Wed, 26 Feb 2020 16:42:38 -0400
Date:   Wed, 26 Feb 2020 16:42:38 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     syzbot <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>
Cc:     chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: possible deadlock in cma_netdev_callback
Message-ID: <20200226204238.GC31668@ziepe.ca>
References: <000000000000153fac059f740693@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000153fac059f740693@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 09:39:10PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    6132c1d9 net: core: devlink.c: Hold devlink->lock from the..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=16978909e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
> dashboard link: https://syzkaller.appspot.com/bug?extid=55de90ab5f44172b0c90
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12808281e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134ca6fde00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com
> 
> iwpm_register_pid: Unable to send a nlmsg (client = 2)
> infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
> netlink: 'syz-executor639': attribute type 1 has an invalid length.
> 8021q: adding VLAN 0 to HW filter on device bond1
> bond1: (slave gretap1): making interface the new active one
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.6.0-rc2-syzkaller #0 Not tainted
> syz-executor639/9689 is trying to acquire lock:
> ffffffff8a5d2a60 (lock#3){+.+.}, at: cma_netdev_callback+0xc6/0x380 drivers/infiniband/core/cma.c:4605
> 
> but task is already holding lock:
> ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
> ffffffff8a74da00 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5433
>

Bernard, this is a siw bug too, it is not allowed to get RTNL in
siw_create_listen() (though this is probably for silly reasons and
could be fixed)

It is not easy to get this into the lockdep, I'll send a different
patch too

Jason
