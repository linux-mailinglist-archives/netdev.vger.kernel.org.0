Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A7D2C6DDC
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 01:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbgK1AF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732260AbgK1ACr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 19:02:47 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11166C0613D1;
        Fri, 27 Nov 2020 16:02:38 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id 38so30014edr.8;
        Fri, 27 Nov 2020 16:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KWhSOPXqMdFB4SW715QCZaTpclu8Nr4wyPo7qFGgjvU=;
        b=Ueg1D/xVtkoGTmnAMeYjB/+/dfINB43YqLWIF07B1dbaBll+7LImL97JbPb4y/hlT+
         i23OEQ466AibAGZimGPhP6I1M4rFgfjPikceXR8KqsxTl2q9FXdA+FQjLZ+euD8KOnGK
         epvMVYwdao1BfnNETkKDp+zeprJX7qDVqm0cjhq6hMZ5KKB0zuxYGCwvLzvbd7mZ3B9s
         eAhVKPFGIEMgnbBGCUOxOCKXAR4G4FyYhMeIigpZp309sR1Xyv+IT+aoMqglBaZRQTrD
         RpGY4cBklt7qXemBizQwQGkM8Mx1qx7IBonnNn+F0Kcag2jCYrtpofxQimmHa4UM1Plp
         6iqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KWhSOPXqMdFB4SW715QCZaTpclu8Nr4wyPo7qFGgjvU=;
        b=dnXsXLsa9O8BchXsjKasD6b3OjxJ2K/g7mCpxXk5VMmjEWBJMhdbl8V81xR68jlNR7
         lzTybpRcseLmrkPgYQPE3NBd2ItaAZlFJOLQxR+eTSL9W4mK68FW9+Ncog9zQO5XNd+i
         C8UV+t46EP4gINWG4+G5VcQxgF0y7n8gUCBZ8hXjdf3gtVfZrKuZK6Iqjv6+rf2Rul4H
         XaCoDIUk5J9ajVZ4eMS4ktt9FmjOVDPX9DfnXdF29QwDaXKNNJfi0YRZPjrUbDrFjwE1
         tkChBFGOWAjweJlBFON16s0HgATOxWlZggLOKQnVoWskaOI0e73UIZpxWkzv7Lc3FQ7J
         XwUQ==
X-Gm-Message-State: AOAM533EBJB8rHYU3jiriA2Tr+9LP5Qhs6j0JLH2DJv92ouwPJKG/lo0
        1zudEfdNNQe7I/U2UhsTLBw=
X-Google-Smtp-Source: ABdhPJy7C4owACmjVdRjL0RJI9pokRF6kbGmdpQMAv66enq/GsHuPWBYn2ZK8fsbUCawH785N7c0qQ==
X-Received: by 2002:aa7:d891:: with SMTP id u17mr10862840edq.0.1606521756746;
        Fri, 27 Nov 2020 16:02:36 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id k23sm5532964ejo.108.2020.11.27.16.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 16:02:36 -0800 (PST)
Date:   Sat, 28 Nov 2020 02:02:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201128000234.hwd5zo2d4giiikjc@skbuf>
References: <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
 <20201127233916.bmhvcep6sjs5so2e@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127233916.bmhvcep6sjs5so2e@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 01:39:16AM +0200, Vladimir Oltean wrote:
> On Sat, Nov 28, 2020 at 12:30:48AM +0100, Andrew Lunn wrote:
> > > If there is a better alternative I'm all ears but having /proc and
> > > ifconfig return zeros for error counts while ip link doesn't will lead
> > > to too much confusion IMO. While delayed update of stats is a fact of
> > > life for _years_ now (hence it was backed into the ethtool -C API).
> >
> > How about dev_seq_start() issues a netdev notifier chain event, asking
> > devices which care to update their cached rtnl_link_stats64 counters.
> > They can decide if their cache is too old, and do a blocking read for
> > new values.
> >
> > Once the notifier has completed, dev_seq_start() can then
> > rcu_read_lock() and do the actual collection of stats from the drivers
> > non-blocking.
>
> That sounds smart. I can try to prototype that and see how well it
> works, or do you want to?

The situation is like this:

static int call_netdevice_notifiers_info(unsigned long val,
					 struct netdev_notifier_info *info);

expects a non-NULL info->dev argument.

To get a net device you need to call:

#define for_each_netdev(net, d)		\
		list_for_each_entry(d, &(net)->dev_base_head, dev_list)

which has the following protection rules:

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

This means, as far as I understand, 2 things:
1. call_netdevice_notifiers_info doesn't help, since our problem is the
   same
2. I think that holding the RTNL should also be a valid way to iterate
   through the net devices in the current netns, and doing just that
   could be the simplest way out. It certainly worked when I tried it.
   But those could also be famous last words...
