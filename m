Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999E8372535
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 06:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhEDEoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 00:44:54 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:45811 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhEDEow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 00:44:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id E7FCF1B0E;
        Tue,  4 May 2021 00:43:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 04 May 2021 00:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=myMLMhEQ7RWnOdFkGtWzXDzHzlP
        xU9Etz1COB68N1NQ=; b=EyUO8kOvWIuRt0hXZjWg55qFjOgTXJFkqPYpTmkp03u
        yWYzGkpdCeJXznx+Zn56OfS7MDAwBbYDVtCmt8/YPXmjDiclgB8zmPwKRc+61/sb
        JkwQFeYxDFSaSnSdayoixZuHdc2GQVuL3opfTP9XV+cyDWfRbMHgi7V5HFgOrEa9
        D5dIeZd3IM1ccG3Dunb41tnqHmz657qSAwwqtRwmiCu/LjRBjmykPBywFAYtKX7J
        H29Q6ccgzKaisbvNfMpvn7xNF9MgIZ2c2zm92YA2m2WP+QT1NmWoLgVXBYH6tqWm
        JDIVtC5Qzl+SKKYJybkPbhy0B0fZDkchm0nz5yn4enA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=myMLMh
        EQ7RWnOdFkGtWzXDzHzlPxU9Etz1COB68N1NQ=; b=uoOAoKFKj7QeFC//AfdsV1
        aT9WAw4hdqKZevZSubuskVW0CGbEAW/hdQ0WC9ZcYtAeJuxZryHyTgl8ImiKlTrQ
        B1acpc2UvKOBFrt1ND8yiqxt8xRSx1/7tJgd8CGrEo6BAL05djgK+cIpfcHoa5Dt
        0N1ohpHztrG7VXOHmCW4eXkTge/6x+0Nor6i2vkHxRoZV3ySqhMfz8bU6NNwSoNC
        r1d6Etlmm+9132aHNJfBMdHlLcZCzER138tHC3kanHMgzKd+t5o5xp9s0Y4P3mxe
        2w6A8TB4bgE1dLRQHjJ6wvDbVMPuIrUyx3bM70RqOjaB+obZHJAn/ItMs/V+Smgg
        ==
X-ME-Sender: <xms:C9GQYCrhAVk7oxVJzGxoJAQmY34_pz1npKcPlmYiFVKsueTt7JiRJw>
    <xme:C9GQYAq3xtx_oTTUgII5hEDH5wG5f3GX7xus765rqlMd5hA1sGwMdYBtZpgkImMs4
    s554TRqgfAq9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefhedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:C9GQYHNDp-lGLxDKa8am9wxh6dcvs7bw9QHWtPrQvpCRxdWDYrQNkw>
    <xmx:C9GQYB52uO8x2K9rXXG4aNDcmtYZKfFMAk85s7EUURaG97y-C62UCA>
    <xmx:C9GQYB4Dle9cEHVD38YwgNWHzMB_tIG1STRM-13Mqi9pRJXlhlutTQ>
    <xmx:DNGQYAK1cBnmymMmFDa-9A6b12dhm2eFkKdykbzKKXsdZNETIkzLCKmoJeE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue,  4 May 2021 00:43:55 -0400 (EDT)
Date:   Tue, 4 May 2021 06:43:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Nick Lowe <nick.lowe@gmail.com>
Cc:     stable@vger.kernel.org,
        Matt Corallo <linux-wired-list@bluematt.me>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: Stable inclusion request - igb: Enable RSS for Intel I211
 Ethernet Controller
Message-ID: <YJDRCSRHSqu0yE7T@kroah.com>
References: <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
 <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
 <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <69e92a09-d597-2385-2391-fee100464c59@bluematt.me>
 <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
 <20210201123350.159feabd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADSoG1sf9zXj9CQfJ3kQ1_CUapmZDa6ZeKtbspUsm34c7TSKqw@mail.gmail.com>
 <20210503113010.774e4ca6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADSoG1stdPVOE2N0dg10T6tgTUN1nqafY_m+K1CLwB6z2Y9j5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADSoG1stdPVOE2N0dg10T6tgTUN1nqafY_m+K1CLwB6z2Y9j5Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 08:53:48PM +0100, Nick Lowe wrote:
> Hi,
> 
> Please may we request that commit 6e6026f2dd20 ("igb: Enable RSS for
> Intel I211 Ethernet Controller") be backported to the 5.4 and 5.10 LTS
> kernels?
>

Also added to 5.11 as it's still alive for another week or so :)

thanks,

greg k-h
