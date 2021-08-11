Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957993E9AF6
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhHKWi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhHKWi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:38:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B566052B;
        Wed, 11 Aug 2021 22:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628721514;
        bh=LngB2gyzyj0u0kOLEtiuYjvMgVoOLt1HsBvzhRgFvwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BqOesHNtb+k+aST3Bt2GqYgZiQShTEL0IHDLnGqC+kImHj7eQQqCBrLDPoV09FzP4
         F+eSwftDvhPOxNd/PCcm4XhBxiqDWwCK8+Uz5aHkcC+O28AyWLOa9pMlywTuUWcfFm
         KRNBiIZ/YZDMQeK9xZlY4iuHO+hWDW4zYwEtoKZ1wYMSmKlvK5Ciu7JqT2JUuRFxnH
         pEtEW8qrqCw3FRd4YQjGpPRc5k3iPhu29DCOIbpPhGygXP5mDDji5gIOgOslL+8dtf
         m6kxbyi1Lrdbe2KUwbpGAi0QZ73PtEchkRopN5NJERm/QuUXYjN/Ybj27K5s5D5ucF
         fB0dZiwJ3z/xQ==
Date:   Wed, 11 Aug 2021 15:38:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: apply MTU normalization for ports that
 join a LAG under a bridge too
Message-ID: <20210811153833.0f63e9f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811164441.vrg4pmivx4f6cuv6@skbuf>
References: <20210811124520.2689663-1-vladimir.oltean@nxp.com>
        <20210811164441.vrg4pmivx4f6cuv6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 19:44:41 +0300 Vladimir Oltean wrote:
> On Wed, Aug 11, 2021 at 03:45:20PM +0300, Vladimir Oltean wrote:
> > We want the MTU normalization logic to apply each time
> > dsa_port_bridge_join is called, so instead of chasing all callers of
> > that function, we should move the call within the bridge_join function
> > itself.
> > 
> > Fixes: 185c9a760a61 ("net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---  
> 
> I forgot to rebase this patch on top of 'net' and now I notice that it
> conflicts with the switchdev_bridge_port_offload() work.
> 
> Do we feel that the issue this patch fixes isn't too big and the patch
> can go into net-next, to avoid conflicts and all that?

The commit message doesn't really describe the impact so hard to judge,
but either way you want to go - we'll need a repost so it can be build
tested.

Conflicts are not a huge deal. Obviously always best to wait for trees
to merge if that fixes things, but if net has dependency on net-next
you should just describe what you want the resolution to look like we
should be able to execute :)
