Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F96449E81
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhKHVza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:55:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhKHVz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 16:55:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ovPaXzYtv4dqZpHKUHD2SKIBwktpdZxt9iGlCiyHgaI=; b=amNr8+7oAkSd/1r4EQBEYMW0Rx
        3fND2hx88wQD8vghRSZ0XcBeS4ZCDSEvpD2NoSGprYeaeGVc4X/HUvXuf45d8euSouyyx8GaabDEb
        8q+CyEOyapc0fH/pgB9sfWUum/utKFU2NqKqFKvkrFZ8n2hAGeTQyvGDowxrSfnukX5I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkCZF-00CvxY-Ca; Mon, 08 Nov 2021 22:52:41 +0100
Date:   Mon, 8 Nov 2021 22:52:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Message-ID: <YYmcKa7H6l+k6KYg@lunn.ch>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
 <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4655F97255C0E8AEF5E3FDCDC4869@PH0PR18MB4655.namprd18.prod.outlook.com>
 <BY3PR18MB4612A7CB285470543A6A3C3CAB919@BY3PR18MB4612.namprd18.prod.outlook.com>
 <YYkpxML6243IkbeK@lunn.ch>
 <PH0PR18MB465524FFA9F75FE858918CE8C4919@PH0PR18MB4655.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB465524FFA9F75FE858918CE8C4919@PH0PR18MB4655.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm i right in says, the bad firmware was introduced with:
> Correct.
> 
> > commit 0a6890b9b4df89a83678eba0bee3541bcca8753c
> > Author: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Date:   Mon Nov 4 21:51:09 2019 -0800
> > 
> >     bnx2x: Utilize FW 7.13.15.0.
> > 
> >     Commit 97a27d6d6e8d "bnx2x: Add FW 7.13.15.0" added said .bin FW to
> >     linux-firmware tree. This FW addresses few important issues in the earlier
> >     FW release.
> >     This patch incorporates FW 7.13.15.0 in the bnx2x driver.
> > 
> > And that means v5.5 through to at least 5.16 will be broken? It has
> > been broken for a little under 2 years? And both 5.10 and 5.15 are
> > LTS. And you don't care.You will leave them broken, even knowing that
> > distribution kernels are going to use these LTS kernel?
> Not Correct. We would like to solve the problem here too. But what we plan
> is to push these fixes upstream

Isn't mainline the top of upstream? You cannot get any further up. Yet
you plan to drop stable? Please could you explain some more.

Are you thinking of releasing a 7.13.15.1 which only fixes the
problem, keeping ABI compatibility, so it can be added to stable?
And then submit 7.13.20.0 for net-next?

> It is not correct that this would have been avoided by not Breaking the ABI.
> The breakage was a bug introduced in the FW for SR-IOV. Having
> backwards/forwards compatible ABI would not change the fact that the bug
> would be there. The bug is only exposed with old VM running on new
> Hypervisor, so it is not correct to say "bug was there for 2 years".
> Although problem was introduced 2 years ago, it was exposed now, and now
> we want to fix it. Whether the fix is done in a manner by which driver
> can work with old FW file on disk or not is not related to the problem itself.
> 
> I stand by that *generally* this HW architecture is not designed for
> backward/forward compatibility with regard to this FW. But it is true that in
> this case it can be done. Numerous FW versions of this device which were already
> accepted and all were non backwards compatible and all had this same issue
> (updating driver mandates syncing up to latest FW tree, otherwise driver load
> gracefully fails). Since this is the last FW we are pushing for this EOLing
> device it seems a bit meticulous to insist on this for this (hopefully) last
> version of the device FW.

Part of the problem is the Marvell keeps doing this for its
products. See the discussion with Prestera. It is like there is a
Marvell policy to not even bother to try to keep ABI compatibility
with the firmware.

If the community wants Marvell to get better in this respect, we need
to push back and say ABI compatibility is important. I hope Prestera
has learned its lesion, they say they will never break ABI
compatibility again, but i think we need to wait a few years before we
can actually trust that statement.

What about other NIC drivers. I hope you don't have any other ABI
breaks planned.

       Andrew
