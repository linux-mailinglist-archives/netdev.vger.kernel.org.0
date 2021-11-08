Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A12B44806C
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhKHNrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:47:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237322AbhKHNrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 08:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xEHMVQxQzXWXbVjjxt2s0c6U82YUUn7Z9UHtoS4BjNU=; b=wRcAvExq+9faWw9zHyTUSxF4ZY
        ZIe6/waXzMA+1N+43Rhts/lnsRHIAtyGPJWwlGcJPFkOPHt4KH4PaQ+O/FMoXgOHfAz+1sLGV0b7t
        lYF7Hqr0v/5CUkWv6BXXfIaI9i41xsex8Duw7lPj1BbQ+RttjClePAbz9Gj/pGirxX1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk4wu-00Ctp4-4D; Mon, 08 Nov 2021 14:44:36 +0100
Date:   Mon, 8 Nov 2021 14:44:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>, Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <YYkpxML6243IkbeK@lunn.ch>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
 <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4655F97255C0E8AEF5E3FDCDC4869@PH0PR18MB4655.namprd18.prod.outlook.com>
 <BY3PR18MB4612A7CB285470543A6A3C3CAB919@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB4612A7CB285470543A6A3C3CAB919@BY3PR18MB4612.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello Jakub et al,
> 
> Just following up based on the comments put by Ariel a week
> back. The earlier firmware has caused some important regression
> w.r.t SR-IOV compatibility, so it's critical to have these new FW
> patches to be accepted sooner (thinking of the impact on various
> Linux distributions/kernels where that bug/regression will be
> carried over with earlier firmware), as Ariel pointed out the
> complexities, in general making the FW backwards compatible on these
> devices architecture meaning supporting different data/control path
> (which is not good from performance perspective), However these two
> particular versions are not changing that much (from data/control
> path perspective) so we could have made them backward compatible for
> these two particular versions but given the time criticality,
> regression/bug introduced by the earlier FW, bnx2x devices being
> almost EOL, this would be our last FW submission hopefully so we
> don't want to re-invent something which has been continued for many
> years now for these bnx2* devices.

> PS: this series was not meant for stable (I have Cced stable
> mistakenly), please let me know if I can send v2 with stable removed
> from recipients.

I'm i right in says, the bad firmware was introduced with:

commit 0a6890b9b4df89a83678eba0bee3541bcca8753c
Author: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date:   Mon Nov 4 21:51:09 2019 -0800

    bnx2x: Utilize FW 7.13.15.0.
    
    Commit 97a27d6d6e8d "bnx2x: Add FW 7.13.15.0" added said .bin FW to
    linux-firmware tree. This FW addresses few important issues in the earlier
    FW release.
    This patch incorporates FW 7.13.15.0 in the bnx2x driver.

And that means v5.5 through to at least 5.16 will be broken? It has
been broken for a little under 2 years? And both 5.10 and 5.15 are
LTS. And you don't care. You will leave them broken, even knowing that
distribution kernels are going to use these LTS kernel?

And you could of avoided this by not breaking the firmware ABI. Which
you now say is actually possible. And after being broken for 2 years
it is now time critical?


    Andrew
