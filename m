Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF92CAB3A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389574AbgLAS7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730132AbgLAS7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:59:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA147C0613D6
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 10:58:25 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id x16so6372397ejj.7
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 10:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=49Q3WvH1zVuyulDVrhe7ChoMzZcJJW/puksp1ss72wk=;
        b=VRgLqWa5JaLmgqxbcSvS/Q3092WuW5pxs3ZodMb5rUvSuvs60UAS43KFSdbWyL0rM5
         ngsyI8IliC99ebsA2swaQFkMezgWiP34szOWwpm0hpT1DkVIqxIynGqdPcoC3pwzoDWC
         tQ5PZIpQ9yQAMq5zDLPWiRC6TEM9sU44eB9O8QowofZI84fNTLRDC54TipPkX3XpeBNL
         aI2DM7pVDUgzgMI21zdbsfXIHjkp14G9AVrhpnhKeTzmEExr4cxRyREufqSfjgjUpOLE
         CCmHsxL36SIpuJNM35FSip1ADXch3CBIFNnB6P15bWwviWCNsb5jzD26x/Eku3G27lqj
         6u+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=49Q3WvH1zVuyulDVrhe7ChoMzZcJJW/puksp1ss72wk=;
        b=b/oy/CtAssG0IIINCLzd8uDk0afxYrHBmyGei4I+VDP0JYXisYpBTADBg+L3oPjKPx
         nZX50UboFQfM6rfHCpUuJV1o3TIArU0KNOjc+WFc2ck9ppcXz2rkf6mQflsLl2oDa9zJ
         j38ZCnS4nx4MMSiIiw7IZK1hgJnsGcR9WlgMxIyurHbLod27JOgJRHvFG5v6uMWWvUgn
         ONP8G8H9wtPFQMVNzyeF1sJCyWoClOxSC1wM9bdXPVYmbdVlDiuBUM7CugXrHA/JVm2b
         1pdIMQyQXreBVC3AvXQii2Dq+gcUvxfjxSMzWerXDbCTxbGBNihUdrjlwVDtdeZdSO23
         b5AQ==
X-Gm-Message-State: AOAM5319i8xkUgt6h2aj1iAf0xJIUTn8h4pn9EtDp/iIi1lfAQsXjy2p
        pKGPniIwFKJXuRjke8IWxJAAoJWbjqA=
X-Google-Smtp-Source: ABdhPJwOVwTnQACsZeFrKeD7E7B7/3tL/wuBjDPhowIpCaCtAjvKfmVCyoltwSKn5nJee5xRBLx4yg==
X-Received: by 2002:a17:907:3f9e:: with SMTP id hr30mr4381124ejc.258.1606849104322;
        Tue, 01 Dec 2020 10:58:24 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id p4sm275265ejx.64.2020.12.01.10.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 10:58:23 -0800 (PST)
Date:   Tue, 1 Dec 2020 20:58:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, fw@strlen.de
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201201185822.ggkdhnkmdh3wi5v2@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <20201201144238.GA5970@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144238.GA5970@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 03:42:38PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 30, 2020 at 08:48:28PM +0200, Vladimir Oltean wrote:
> [...]
> > There are 2 separate classes of problems:
> > - We already have two ways of protecting pure readers: via RCU and via
> >   the rwlock. It doesn't help if we also add a second way of locking out
> >   pure writers. We need to first clean up what we have. That's the
> >   reason why I started the discussion about the rwlock.
> > - Some callers appear to not use any sort of protection at all. Does
> >   this code path look ok to you?
> > 
> > nfnetlink_rcv_batch
> > -> NFT_MSG_NEWCHAIN
> 
> This path holds the nft commit mutex.
> 
> >    -> nf_tables_addchain
> >       -> nft_chain_parse_hook
> >          -> nft_chain_parse_netdev
> >             -> nf_tables_parse_netdev_hooks
> >                -> nft_netdev_hook_alloc
> >                   -> __dev_get_by_name
> >                      -> netdev_name_node_lookup: must be under RTNL mutex or dev_base_lock protection
> 
> The nf_tables_netdev_event() notifier holds the nft commit mutex too.
> Assuming worst case, race between __dev_get_by_name() and device
> removal, the notifier waits for the NFT_MSG_NEWCHAIN path to finish.
> If the nf_tables_netdev_event() notifier wins race, then
> __dev_get_by_name() hits ENOENT.
> 
> The idea is explained here:
> 
> commit 90d2723c6d4cb2ace50fc3b932a2bcc77710450b
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue Mar 20 17:00:19 2018 +0100
> 
>     netfilter: nf_tables: do not hold reference on netdevice from preparation phase
> 
>     The netfilter netdevice event handler hold the nfnl_lock mutex, this
>     avoids races with a device going away while such device is being
>     attached to hooks from the netlink control plane. Therefore, either
>     control plane bails out with ENOENT or netdevice event path waits until
>     the hook that is attached to net_device is registered.
> 
> I can submit a patch adding a comment so anyone else does not get
> confused :-)

Ok, so since you are holding the net->nft.commit_mutex from a code path
that is called under RTNL (call_netdevice_notifiers_info), then you are
indirectly serializing all the other holders of the commit_mutex with
the RTNL mutex.

I think it would really help if you could add a comment, yes.


Some other code paths that call __dev_get_by_name() while not holding
the RTNL mutex or the dev_base_lock:

atrtr_ioctl_addrt() <- atalk_ioctl() <- not under RTNL or dev_base_lock
handle_ip_over_ddp() <- atalk_rcv() <- not under RTNL or dev_base_lock
net/bridge/br_sysfs_if.c: store_backup_port() <- sysfs <- not under RTNL or dev_base_lock

net/netfilter/ipvs/ip_vs_sync.c: start_sync_thread() <- not under RTNL or dev_base_lock

include/net/pkt_cls.h: tcf_change_indev() <- fl_set_key() <- fl_set_parms <- RTNL potentially held depending on bool rtnl_held, dev_base_lock definitely not
