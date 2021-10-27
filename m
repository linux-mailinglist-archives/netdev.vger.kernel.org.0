Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF7D43D05F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbhJ0SOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:14:36 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50185 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236967AbhJ0SOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:14:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 09E9B5803EA;
        Wed, 27 Oct 2021 14:12:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 27 Oct 2021 14:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=j/RULZ
        tDpc+y/lprxEvKQj5w0p1vn9r8YHg3R7LWoz8=; b=MCPufT7RQPN3cp+7jiAfUB
        O0lBNoHNVx95HeZTrmsMUUO4cuFgyYJ9JTbPSn/wuwJEGMsTnqFQKdk4CFvKkuVn
        BaY2kmN+BWrinuvylKNQ2kMWOt7uNUgu7qU9VRJXfryC+W3/VtVkRufrbc1Q5o5e
        JOjhI+imtgIKA3dXlWyRxO3LjyiE4XXUC/ZoH/W/O48BbDRQcoQfB8o8NoBn034G
        Kfj+nyGEKjYALnis/ctOUlZ0E7+56B2KF0JRZRJPzBffOTc2mcsCYHfKriCw2OCG
        gVzO1E99yvbxqhkuFki5qGB6CqstfBqPa1cD5NReakDBlAf6Ei98jY8QMvRwUrWA
        ==
X-ME-Sender: <xms:dJZ5YQcnFeJYlPFnIheOAUQWfrlY3D3E_-FGd1ey7WAqHmvebgI-4A>
    <xme:dJZ5YSMEfJgp-I2owuv27y_gggp54ShzQO12_Yo0S-l2jX8GX9i3aYfbgPFx_l1Wh
    7Fppww7J2LepIQ>
X-ME-Received: <xmr:dJZ5YRiNKXoiez2Oh1q_5oBuvmbdEvLS0u_SzfJX_wv0_wpcKQgWSZp8vwYVoqESwB6dv9LWJPtCv3lXYXU9eacD7s4vUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfg
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:dJZ5YV8PeH-ZnVCtGYSmCVOlCE4I_Wbf1tDVtlMhnNLTPc6Q7h3j5w>
    <xmx:dJZ5Ycupxe0ppbPpVp3XpirvFadYbON-IY2UcZiDoyMYkyImGeHRaQ>
    <xmx:dJZ5YcFJwOW4Ug7Y7SSAFUCjqHINeJT7kEESg-MRZedWklBWGERqtg>
    <xmx:dZZ5YdlE5ooIxg8GxGFtIsPDu2HKgnPEhVoJfB6sbow5jzY4pHdPRw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 14:12:03 -0400 (EDT)
Date:   Wed, 27 Oct 2021 21:11:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <YXmWb2PZJQhpMfrR@shredder>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
 <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
 <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:08:57AM -0700, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 22:13:32 +0530 sundeep subbaraya wrote:
> > > On Wed, 27 Oct 2021 16:01:14 +0530 Subbaraya Sundeep wrote:  
> > > > From: Rakesh Babu <rsaladi2@marvell.com>
> > > >
> > > > The physical/SerDes link of an netdev interface is not
> > > > toggled on interface bring up and bring down. This is
> > > > because the same link is shared between PFs and its VFs.
> > > > This patch adds devlink param to toggle physical link so
> > > > that it is useful in cases where a physical link needs to
> > > > be re-initialized.  
> > >
> > > So it's a reset? Or are there cases where user wants the link
> > > to stay down?  
> > 
> > There are cases where the user wants the link to stay down and debug.
> > We are adding this to help customers to debug issues wrt physical links.
> 
> Intel has a similar thing, they keep adding a ethtool priv flag called 
> "link-down-on-close" to all their drivers.

This is the list I compiled the previous time we discussed it:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c3880bd159d431d06b687b0b5ab22e24e6ef0070
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5ec9e2ce41ac198de2ee18e0e529b7ebbc67408
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ab4ab73fc1ec6dec548fa36c5e383ef5faa7b4c1

It seems that various drivers default to not shutting down the link upon
ndo_stop(), but some users want to override it. I hit that too as it
breaks ECMP (switch thinks the link is up).

> Maybe others do this, too.  It's time we added a standard API for
> this.

The new parameter sounds like a reset, but it can also be achieved by:

# ethtool --set-priv-flags eth0 link-down-on-close on
# ip link set dev eth0 down
# ip link set dev eth0 up

Where the first command is replaced by a more standard ethtool API.
