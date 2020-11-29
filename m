Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36BC2C7B41
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 21:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgK2U7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 15:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK2U7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 15:59:06 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A48C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 12:58:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id f9so14831549ejw.4
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 12:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L+KNo8xk2VL+3MREnNS2JE/nY4P3J+0LBr4sVzMJogw=;
        b=NKjoQY9qrxrjxygghx1K7fdyRRSEwxaC43O9MC+5ZSEzOpqmbVWa8klb0YismxxP46
         CP2BtE10PXn0U3qUOCa61axrKXBVXH1FJDcuephG5ei2sK71vNS9sk1cOq41DBza//RP
         lOVxjw2qM9Sjk9SzgxSnvOCPHp6uMTIJVUIX3EdzsSfLEvzYUyaC1LGNJreIFlR5ii4r
         bI/1ldDgf2GCacmBbWbNm6/O5QNZG1GGK0kMuH/wbAeUpBygJO9A7WXE0BlqZG2VTNs1
         +P53wPdnTObnHTSBeZ44HbrTbTMXht9hOBkl0h8Bd4hrx8ONqKi6t81EVmTfPdjlSk7M
         WaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L+KNo8xk2VL+3MREnNS2JE/nY4P3J+0LBr4sVzMJogw=;
        b=tiyPZqsG5PP9j2pc5NvASYA4MSDDP17vMfN2e0W+EyeRnYmt1iN02ae/qu9R3vyuT5
         6iD5uZ7jN7Csiof4plb00fNrrZ9+/gfLsl+fKjmY8MuHcQ/IY9HkyjtlJvnaTTi641dC
         bjQ6QmHCxokQ88Z3NkyRxoMlWhRVGZuoQd8MqAD45ecFrDc06lirC/8XmL9Xy1cIx67i
         tBXEaTb4CfS/nazkDsuGHTI+9WSRia+K8nZCg+ttqH6PMr3XcsUpB/G4XpEQERiGJtEs
         EbK7LMr+osCf4WjXGGDBVyXQZD5BbUjR6yhmO0vuCkG/szX+dKNv5frEEaQLFYB+CYU4
         bi8g==
X-Gm-Message-State: AOAM53127XI2z8vx/ldlGzuHeZu6aLqhpXtNVQNFf6mJy5VmRUv2XeIs
        +ywbZ46WAMDOngkOrw6+xVuQ9Bbr5xs=
X-Google-Smtp-Source: ABdhPJxDOm0TSjvgsLEPbY90GAeuVk8yw022Xx25JYWHyIndXCJLRnjYUQmAXd9pREnhrOnYXegEXg==
X-Received: by 2002:a17:906:470a:: with SMTP id y10mr15488240ejq.180.1606683498836;
        Sun, 29 Nov 2020 12:58:18 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id cb14sm3583470ejb.105.2020.11.29.12.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 12:58:18 -0800 (PST)
Date:   Sun, 29 Nov 2020 22:58:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201129205817.hti2l4hm2fbp2iwy@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129182435.jgqfjbekqmmtaief@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ resent, had forgot to copy the list ]

Hi,

net/core/dev.c has this to say about the locking rules around the network
interface lists (dev_base_head, and I can only assume that it also applies to
the per-ifindex hash table dev_index_head and the per-name hash table
dev_name_head):

/*
 * The @dev_base_head list is protected by @dev_base_lock and the rtnl
 * semaphore.
 *
 * Pure readers hold dev_base_lock for reading, or rcu_read_lock()
 *
 * Writers must hold the rtnl semaphore while they loop through the
 * dev_base_head list, and hold dev_base_lock for writing when they do the
 * actual updates.  This allows pure readers to access the list even
 * while a writer is preparing to update it.
 *
 * To put it another way, dev_base_lock is held for writing only to
 * protect against pure readers; the rtnl semaphore provides the
 * protection against other writers.
 *
 * See, for example usages, register_netdevice() and
 * unregister_netdevice(), which must be called with the rtnl
 * semaphore held.
 */

However, as of today, most if not all the read-side accessors of the network
interface lists have been converted to run under rcu_read_lock. As Eric explains,

commit fb699dfd426a189fe33b91586c15176a75c8aed0
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon Oct 19 19:18:49 2009 +0000

    net: Introduce dev_get_by_index_rcu()

    Some workloads hit dev_base_lock rwlock pretty hard.
    We can use RCU lookups to avoid touching this rwlock.

    netdevices are already freed after a RCU grace period, so this patch
    adds no penalty at device dismantle time.

    dev_ifname() converted to dev_get_by_index_rcu()

    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

A lot of work has been put into eliminating the dev_base_lock rwlock
completely, as Stephen explained here:

[PATCH 00/10] netdev: get rid of read_lock(&dev_base_lock) usages
https://www.spinics.net/lists/netdev/msg112264.html

However, its use has not been completely eliminated. It is still there, and
even more confusingly, that comment in net/core/dev.c is still there. What I
see the dev_base_lock being used for now are complete oddballs.

- The debugfs for mac80211, in net/mac80211/debugfs_netdev.c, holds the read
  side when printing some interface properties (good luck disentangling the
  code and figuring out which ones, though). What is that read-side actually
  protecting against?

- HSR, in net/hsr/hsr_device.c (called from hsr_netdev_notify on NETDEV_UP
  NETDEV_DOWN and NETDEV_CHANGE), takes the write-side of the lock when
  modifying the RFC 2863 operstate of the interface. Why?
  Actually the use of dev_base_lock is the most widespread in the kernel today
  when accessing the RFC 2863 operstate. I could only find this truncated
  discussion in the archives:
    Re: Issue 0 WAS (Re: Oustanding issues WAS(IRe: Consensus? WAS(RFC 2863)
    https://www.mail-archive.com/netdev@vger.kernel.org/msg03632.html
  and it said:

    > be transitioned to up/dormant etc. So an ethernet driver doesnt know it
    > needs to go from detecting peer link is up to next being authenticated
    > in the case of 802.1x. It just calls netif_carrier_on which checks
    > link_mode to decide on transition.

    we could protect operstate with a spinlock_irqsave() and then change it either
    from netif_[carrier|dormant]_on/off() or userspace-supplicant. However, I'm
    not feeling good about it. Look at rtnetlink_fill_ifinfo(), it is able to
    query a consistent snapshot of all interface settings as long as locking with
    dev_base_lock and rtnl is obeyed. __LINK_STATE flags are already an
    exemption, and I don't want operstate to be another. That's why I chose
    setting it from linkwatch in process context, and I really think this is the
    correct approach.

- rfc2863_policy() in net/core/link_watch.c seems to be the major writer that
  holds this lock in 2020, together with do_setlink() and set_operstate() from
  net/core/rtnetlink.c. Has the lock been repurposed over the years and we
  should update its name appropriately?

- This usage from netdev_show() in net/core/net-sysfs.c just looks random to
  me, maybe somebody can explain:

	read_lock(&dev_base_lock);
	if (dev_isalive(ndev))
		ret = (*format)(ndev, buf);
	read_unlock(&dev_base_lock);

- This also looks like nonsense to me, maybe somebody can explain.
  drivers/infiniband/hw/mlx4/main.c, function mlx4_ib_update_qps():

	read_lock(&dev_base_lock);
	new_smac = mlx4_mac_to_u64(dev->dev_addr);
	read_unlock(&dev_base_lock);

  where mlx4_mac_to_u64 does:

static inline u64 mlx4_mac_to_u64(u8 *addr)
{
	u64 mac = 0;
	int i;

	for (i = 0; i < ETH_ALEN; i++) {
		mac <<= 8;
		mac |= addr[i];
	}
	return mac;
}

  basically a duplicate of ether_addr_to_u64. So I can only assume that the
  dev_base_lock was taken to protect against what, against changes to
  dev->dev_addr? :)

So it's clear that the dev_base_lock needs to be at least renamed, if not
removed (and at least some instances of it removed). But it's not clear what to
rename it to.

Thanks,
-Vladimir
