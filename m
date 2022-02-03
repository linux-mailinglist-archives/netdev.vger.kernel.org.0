Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83FA4A8FD8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354983AbiBCV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiBCV0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:26:01 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA614C061714;
        Thu,  3 Feb 2022 13:26:00 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m11so8787374edi.13;
        Thu, 03 Feb 2022 13:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qSedLl6huFit38vknN8k5h+0pAfo5CN6zPDzj3GSbuQ=;
        b=b1QRm24e5W46pwSgaZgEIef9zPC0H7nASIrVS2gX10c9zlGIKiqCt/s4y+3RGV4UwC
         KxU1CAa0w6rbhp1cOlYfu2ECrYVKibICHFIZPnTH/VM048PZdrxuEr+OVfyhF/TbHllE
         jaesglKgoA5Qzco5j3w+mcd4UvmXxoDyTTzssD5wTGZbltqkpCPd+FB1ohXWWXhBwvLH
         oXQ7WjYiQ7OGf3i+krGCDW54QPp1WQv9NmxAqKPEWnuB6iFtunc7+yoE80L1APBWGNVQ
         Xem5kA3iYtKbje+s0P3x34b6aq2sOYgXWLHEnBbixz36u85JLeFEvnRlPLS1PVGonEPf
         7dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qSedLl6huFit38vknN8k5h+0pAfo5CN6zPDzj3GSbuQ=;
        b=VTxLokH7swM89LcQajgRoMQUPmreSAI0E4RoavaYvxNwVIr+4Xi2XuGzgO6qoek/Wj
         RwIPoF51vm+C9xEk4L5YzoKZtxlvsTT8orH2IQ8BjFnb9n8mPL44E0YUXaAACqNNSEVX
         J050LrKjYS7fvS3OjOoQSHEwbTrstU4KynCUCDQ2wgDyV1wGOlWTNPkDw9uhZLNW41w1
         fMTb8MJ6kdBpqd+Lhyp15H5jWDGQ5jAcEyXvmoGRkIO3nt43uR79AKkAJUYWbiQOi+6m
         dUBsQzWg4VE/SfzGrdibuepxRDuc3P5oxP0azPI2nf5zzQ9D6DlwYe6klEX0Q13/vimd
         atqw==
X-Gm-Message-State: AOAM5303Ad923d0NRZeXSfCpOkdMZ2N5juhQYBNlxZ4PbGA0bfXAd1Ti
        WYuNUGdtjEKhvtwyyWu4uAH5MY/ILjY=
X-Google-Smtp-Source: ABdhPJxUz0AgGUBHTzi7oCJ5XCmE5O2dUd8FVaM9IMyplvMq9VntN+9o+qYBSb3lpJGFvbModdI6Fg==
X-Received: by 2002:a05:6402:1caa:: with SMTP id cz10mr43289edb.435.1643923559099;
        Thu, 03 Feb 2022 13:25:59 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id r13sm10435ejy.205.2022.02.03.13.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 13:25:58 -0800 (PST)
Date:   Thu, 3 Feb 2022 23:25:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Message-ID: <20220203212557.unupodfyfdcb24tk@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
 <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
 <YfwX8YDDygBEsyo3@Ansuel-xps.localdomain>
 <20220203182128.z6xflse7fezccvhx@skbuf>
 <20220203121027.7a6ea0f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203121027.7a6ea0f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 12:10:27PM -0800, Jakub Kicinski wrote:
> On Thu, 3 Feb 2022 20:21:28 +0200 Vladimir Oltean wrote:
> > To my knowledge, when you call dev_queue_xmit(), the skb is no longer
> > yours, end of story, it doesn't matter whether you increase the refcount
> > on it or not. The DSA master may choose to do whatever it wishes with
> > that buffer after its TX completion interrupt fires: it may not call
> > napi_consume_skb() but directly recycle that buffer in its pool of RX
> > buffers, as part of some weird buffer recycling scheme. So you'll think
> > that the buffer is yours, but it isn't, because the driver hasn't
> > returned it to the allocator, and your writes for the next packet may be
> > concurrent with some RX DMA transactions. I don't have a mainline
> > example to give you, but I've seen the pattern, and I don't think it's
> > illegal (although of course, I stand to be corrected if necessary).
>
> Are we talking about holding onto the Tx skb here or also recycling
> the Rx one? Sorry for another out of context comment in advance..

We're talking about the possibility that the DSA master holds onto the
TX skb, for the purpose of saving a netdev_alloc_skb() call later in the
RX path.

> AFAIK in theory shared skbs are supposed to be untouched or unshared
> explicitly by the driver on Tx. pktgen takes advantage of it.
> We have IFF_TX_SKB_SHARING.
>
> In practice everyone gets opted into SKB_SHARING because ether_setup()
> sets the flag. A lot of drivers are not aware of the requirement and
> will assume full ownership (and for example use skb->cb[]) :/
>
> I don't think there is any Tx completion -> Rx pool recycling scheme
> inside the drivers (if that's what you described).

You made me go look again at commit acb600def211 ("net: remove skb
recycling"), a revert of which is still carried in some vendor kernels.
So there was a skb_is_recycleable() function with this check:

	if (skb_shared(skb))
		return false;

which means that yes, my argument is basically invalid, skb_get() in DSA
will protect against skb recycling.

I know Ansuel is using OpenWRT, so not a stranger to vendor kernels &
network drivers. My comment wasn't as much a hard NACK as it was a word
of caution. DSA allows pairing any switch driver to any host controller
driver. If somebody hits the jackpot (probably won't be me, won't be
Ansuel), it won't be exactly fun for them until they figure out what's
going on, with the symptoms being random data corruption during switch
register access. But after I revisited the exact situation, I don't have
an example that proves to be problematic.
