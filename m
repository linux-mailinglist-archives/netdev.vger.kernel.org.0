Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1955F2C7D9F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 06:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgK3FNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 00:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgK3FNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 00:13:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B7FC0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 21:12:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x4so4106417pln.8
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 21:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TCIfA60uRRkGUN8lqiQ0JQbfujfGJj0UDLYJgT7MPNo=;
        b=Y0ZuV0XjMb9jf9x4kgGSCWJp0fm7+rtyGKgfmxsaI49nmqoUlR6SOJ5o1ljNMKZolU
         33z1JqkTzJcDgUfxwQEjeOFmV3xyfMN/wO7ZiwyIlS3klwQhV5gVn6X+rvQ3UBICS68K
         DDBGL8ulrnNXIVAZYT1psnbRroCOjdanr5uGhPRGyhFzdWZVQWQQIlkcbe2mfhoSld2V
         4JgoBJxGuwJjn2Ktpr5X31xkYTAiXJmq3+od46I8q1hsoo0K53Zdnbc9XdfrfKiY4Zix
         2ffPWNG9ZEALWxyjQWnxbNqTfw2lLR3Syq4cxB5hprbCx8P/MxiDT7NQ8esrc5vcfzEI
         2l6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TCIfA60uRRkGUN8lqiQ0JQbfujfGJj0UDLYJgT7MPNo=;
        b=lXvipH+YLZw7/8Fv8uTEfhANp7jpvmG42eydDNQdUPBGMMPKyd/8MZ/305DlxYkPGY
         1EZ268F0aOxaa1+nRjAWcwdBFqQV+Zn80U08mqJiX6DpMnswA6GRs/86UIv8iMOmXN5i
         CGfIPjFcZHZ1U60krUzx8sHWMi5l723/LgzFVcCwHYcD0bbROsm6oq9Sb0mf26CkpTIp
         sCoxzRfcAcd8xpa5pKa/sW6ab+i65D8d8229IBExOnS7kwlABNQuBPFO88qfEsLqzTBd
         cF0rsVUqX3jKqlf/wRYh/NhAkCSiVplDup1vtDS2yUx4IVuGbw/6kqrV5Lzjr9Nza2iC
         yvQQ==
X-Gm-Message-State: AOAM530jRosKh/oPRcQHGP0PEu0UII9en6vvCI8VqOGLpux3ALhpjz4I
        12605bTDWXxQ86AoTNciPS7xig==
X-Google-Smtp-Source: ABdhPJz8+g0VSQLjZLfA/t5CoxVhv3r8Yjx6pdzVRszjT/RB2kuv0MJ3XLgTiGiSOzqn8e3XJqNiSA==
X-Received: by 2002:a17:90a:5d0e:: with SMTP id s14mr24513663pji.53.1606713154268;
        Sun, 29 Nov 2020 21:12:34 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f7sm14014634pfe.30.2020.11.29.21.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 21:12:33 -0800 (PST)
Date:   Sun, 29 Nov 2020 21:12:30 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201129211230.4d704931@hermes.local>
In-Reply-To: <20201129205817.hti2l4hm2fbp2iwy@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
        <20201129205817.hti2l4hm2fbp2iwy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020 22:58:17 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> [ resent, had forgot to copy the list ]
> 
> Hi,
> 
> net/core/dev.c has this to say about the locking rules around the network
> interface lists (dev_base_head, and I can only assume that it also applies to
> the per-ifindex hash table dev_index_head and the per-name hash table
> dev_name_head):
> 
> /*
>  * The @dev_base_head list is protected by @dev_base_lock and the rtnl
>  * semaphore.
>  *
>  * Pure readers hold dev_base_lock for reading, or rcu_read_lock()
>  *
>  * Writers must hold the rtnl semaphore while they loop through the
>  * dev_base_head list, and hold dev_base_lock for writing when they do the
>  * actual updates.  This allows pure readers to access the list even
>  * while a writer is preparing to update it.
>  *
>  * To put it another way, dev_base_lock is held for writing only to
>  * protect against pure readers; the rtnl semaphore provides the
>  * protection against other writers.
>  *
>  * See, for example usages, register_netdevice() and
>  * unregister_netdevice(), which must be called with the rtnl
>  * semaphore held.
>  */
> 
> However, as of today, most if not all the read-side accessors of the network
> interface lists have been converted to run under rcu_read_lock. As Eric explains,
> 
> commit fb699dfd426a189fe33b91586c15176a75c8aed0
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Mon Oct 19 19:18:49 2009 +0000
> 
>     net: Introduce dev_get_by_index_rcu()
> 
>     Some workloads hit dev_base_lock rwlock pretty hard.
>     We can use RCU lookups to avoid touching this rwlock.
> 
>     netdevices are already freed after a RCU grace period, so this patch
>     adds no penalty at device dismantle time.
> 
>     dev_ifname() converted to dev_get_by_index_rcu()
> 
>     Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> A lot of work has been put into eliminating the dev_base_lock rwlock
> completely, as Stephen explained here:
> 
> [PATCH 00/10] netdev: get rid of read_lock(&dev_base_lock) usages
> https://www.spinics.net/lists/netdev/msg112264.html
> 
> However, its use has not been completely eliminated. It is still there, and
> even more confusingly, that comment in net/core/dev.c is still there. What I
> see the dev_base_lock being used for now are complete oddballs.
> 
> - The debugfs for mac80211, in net/mac80211/debugfs_netdev.c, holds the read
>   side when printing some interface properties (good luck disentangling the
>   code and figuring out which ones, though). What is that read-side actually
>   protecting against?
> 
> - HSR, in net/hsr/hsr_device.c (called from hsr_netdev_notify on NETDEV_UP
>   NETDEV_DOWN and NETDEV_CHANGE), takes the write-side of the lock when
>   modifying the RFC 2863 operstate of the interface. Why?
>   Actually the use of dev_base_lock is the most widespread in the kernel today
>   when accessing the RFC 2863 operstate. I could only find this truncated
>   discussion in the archives:
>     Re: Issue 0 WAS (Re: Oustanding issues WAS(IRe: Consensus? WAS(RFC 2863)
>     https://www.mail-archive.com/netdev@vger.kernel.org/msg03632.html
>   and it said:
> 
>     > be transitioned to up/dormant etc. So an ethernet driver doesnt know it
>     > needs to go from detecting peer link is up to next being authenticated
>     > in the case of 802.1x. It just calls netif_carrier_on which checks
>     > link_mode to decide on transition.  
> 
>     we could protect operstate with a spinlock_irqsave() and then change it either
>     from netif_[carrier|dormant]_on/off() or userspace-supplicant. However, I'm
>     not feeling good about it. Look at rtnetlink_fill_ifinfo(), it is able to
>     query a consistent snapshot of all interface settings as long as locking with
>     dev_base_lock and rtnl is obeyed. __LINK_STATE flags are already an
>     exemption, and I don't want operstate to be another. That's why I chose
>     setting it from linkwatch in process context, and I really think this is the
>     correct approach.
> 
> - rfc2863_policy() in net/core/link_watch.c seems to be the major writer that
>   holds this lock in 2020, together with do_setlink() and set_operstate() from
>   net/core/rtnetlink.c. Has the lock been repurposed over the years and we
>   should update its name appropriately?
> 
> - This usage from netdev_show() in net/core/net-sysfs.c just looks random to
>   me, maybe somebody can explain:
> 
> 	read_lock(&dev_base_lock);
> 	if (dev_isalive(ndev))
> 		ret = (*format)(ndev, buf);
> 	read_unlock(&dev_base_lock);


So dev_base_lock dates back to the Big Kernel Lock breakup back in Linux 2.4
(ie before my time). The time has come to get rid of it.

The use is sysfs is because could be changed to RCU. There have been issues
in the past with sysfs causing lock inversions with the rtnl mutex, that
is why you will see some trylock code there.

My guess is that dev_base_lock readers exist only because no one bothered to do
the RCU conversion.

Complex locking rules lead to mistakes and often don't get much performance
gain.  There are really two different domains being covered by locks here.

The first area is change of state of network devices. This has traditionally
been covered by RTNL because there are places that depend on coordinating
state between multiple devices. RTNL is too big and held too long but getting
rid of it is hard because there are corner cases (like state changes from userspace
for VPN devices).

The other area is code that wants to do read access to look at list of devices.
These pure readers can/should be converted to RCU by now. Writers should hold RTNL.

You could change the readers of operstate to use some form of RCU and atomic
operation (seqlock?). The state of the device has several components flags, operstate
etc, and there is no well defined way to read a consistent set of them.

Good Luck on your quest.


