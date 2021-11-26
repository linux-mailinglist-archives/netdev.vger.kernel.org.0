Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D745F328
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhKZRtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbhKZRrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:47:49 -0500
X-Greylist: delayed 412 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Nov 2021 09:26:29 PST
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A03C061A15
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 09:26:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDDB612E8
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 17:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCCCC93056;
        Fri, 26 Nov 2021 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637947176;
        bh=B0JthiTwVJS2p4dYMGDsJJOtVKcs8RNVenQIEPjvoS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nxc5zD2ODLdvbALn0/X+2WU6dKjIpXwK7phgmogn4ucUQewuqm2Eta8W2HDBZ6e1K
         mw2u9Bpwn/uj8AEXYyxkE+Bo5NWgoZnwakkKpkN5xqaDVptIywDeX2BQd7JBBi/v0t
         kZfq2Mw91Z25rnkYQHXFA6n1043uBjdabo02ExKAZVF7RZ8ndKTlrbQ7lmyPqWdE9P
         zB4sHLUFYiBhQnTB5cOKQd07YnKj8DASQDPLxUaKN1uSAaVbGEOldLyYacP/J3z2YC
         tOFjmna04c3G0kZ67QDLhbvjFl6iukZeiFY7KVyanpPLd+l1g6bzh7zer/LXura2R1
         b3wxe86gm2qXg==
Date:   Fri, 26 Nov 2021 09:19:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP
 VF devices
Message-ID: <20211126091927.29f96b59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+sq2Cc9E+vSusMd+zZtkN0UOE_vtL5jT7XjE5t9gyCRn0sA_Q@mail.gmail.com>
References: <20211125021822.6236-1-radhac@marvell.com>
        <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
        <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
        <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY3PR18MB47374C791CA6CA0E3CB4C528C6639@BY3PR18MB4737.namprd18.prod.outlook.com>
        <CA+sq2CdrO-Zsf5zAj9UbAqVpKdbxeP+QoDAJ6dK2hwDmmuQQ8A@mail.gmail.com>
        <20211125205800.74e1b07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+sq2Cc9E+vSusMd+zZtkN0UOE_vtL5jT7XjE5t9gyCRn0sA_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 10:51:24 +0530 Sunil Kovvuri wrote:
> On Fri, Nov 26, 2021 at 10:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 26 Nov 2021 09:44:10 +0530 Sunil Kovvuri wrote:  
> > > What is the objection here ?
> > > Is kernel netdev not supposed to be used with-in end-point ?  
> >
> > Yes.  
> 
> If you don't mind can you please write these rules somewhere and push
> to kernel documentation.
> So that we are clear on what restrictions kernel netdev imposes.

Kernel develops by precedent. You're making a precedent with your
patches and have not bothered documenting it. In fact there isn't 
even a proper commit message.

> > > If customers want to use upstream kernel with-in endpoint and not
> > > proprietary SDK, why to impose restrictions.  
> >
> > Because our APIs and interfaces have associated semantics. That's
> > the primary thing we care about upstream. You need to use or create
> > standard interfaces, not come up with your own thing and retrofit it
> > into one of the APIs. Not jam PTP configuration thru devlink params,
> > or use netdevs to talk to your FW because its convenient. Trust me,
> > you're not the first one to come up with this idea.
> 
> I see that you are just assuming how it's used and making comments.
> In scenarios where OcteonTx2 is used as a offload card (DPU) or VRAN,
> some of the pkts
> will be sent to host for processing. This path is used to forward such
> pkts to host and viceversa.
> It's not for internal communication between host and firmware.

Sounds like you should be implementing the switchdev model, then.

> It's using the standard netdev interfaces, APIs and network stack
> packet forwarding.
> I don't understand what's wrong with this.

Again, upstream comes with expectations around semantics of objects 
and modeling.

> The devlink params are being used across drivers to do proprietary
> HW settings. There is no PTP protocol or pkt related configuration
> that's being jammed through in the other patch.

I don't even know how to respond to this. And guess what, PTP is
relatively well documented, which clearly proves that your "please
document.." request is empty rhetoric.

> > Frankly if the octeontx2 team continues on its current path I think
> > the driver should be removed. You bring no benefit to the community
> > I don't see why we'd give you the time of day.  
> 
> That's an unnecessary comment crossing the lines.

I'm not sure why. Please elucidate how working with your team is
bringing any benefit to the community.
