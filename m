Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9EAA728D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfICSdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 14:33:35 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:40073 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfICSdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 14:33:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6A2FE2B0E;
        Tue,  3 Sep 2019 14:33:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=0oVSMAna4kl3ETzzaxWLpTjV167
        ytiAyprd3AP+QQXw=; b=PserZJwwfQjDUhVLwb/5F3N1u/ETLAjozYldNmdsd59
        C12dTcJOKvfjFMJBpYqcE8lBbu0G0B2EDDZYNbYj/XcdoDJtgKOyyD/lx4zM6Cqr
        pcJl1oXdXENQcB5/nnaKcxQf+4JqmtgAD+/gFV858lksC6KktQpTM7cy7ZC7aZS8
        SodE2PzZRNgZlOc54gsETmMzAz8B38LtP/0B8lS2afS8Vs0bXIC/6ysCrs+QuSem
        UARqh0pvVnp3bA77ndzrjJx/vaRQiHyIUz47S/JU4ESiceV8nhQmih9l2reoxiHl
        hdyrCqMewL20r9tRgsHcFIhf0hxxUDg0+SVlqF78iMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0oVSMA
        na4kl3ETzzaxWLpTjV167ytiAyprd3AP+QQXw=; b=1AxtKOYrmlq6eSttWS8/0h
        N1IF6Kb+qO2ihJcgUrNpcbYIG5QSGOOfP/6eRXt4Gkke1NPTbn8mJOFpOIZVNYvD
        8BVqaZ8yqdXg90wcl2h3qjoC3X4DKIDFenHStLj0GQnytHkQ6HAiWub0QwH5/bXL
        c0ky4AFwOfUcfKzViNlffue+Mkr9eveH2sYngzmZA1ksbs7Yua27CeVl82WgcVGU
        EboAfYV6A3wmQr6RfTvWZR2aA4kUxPotd75gmPsmRLXl6/QPXcOdKtpluPBQdgYH
        mtRiH9J3+NqwxPyRFOgzXjPFCcQHB9+NhSZ9Cp71/JUfpNMkxlOPzJac8c/07URg
        ==
X-ME-Sender: <xms:_bFuXeHlbcEIwt-w9gyEdsbOdEogfPHRw0o8ZvVgB95SsAe78d2Yiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehnvggvuggvug
    drnhgvthenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_bFuXcsXOYeI7lCn8pNMPn4p_9g9uT5VRTOnQAjwrQotwpYtt9WjUw>
    <xmx:_bFuXXDPFV3bBOQY7O5eBBTgLN_G1b-brbKWrUSDd_dwJGmjKv6PVQ>
    <xmx:_bFuXRQEfS3vOYsq_2-4MSqwe95WFfcClzC6irEJKVdPhLu60ecP7A>
    <xmx:_rFuXXSQVSipUIezTmy7mUaCzax62G-NbHj3REnGt3Qaj66pFKTQjw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30D57D6005E;
        Tue,  3 Sep 2019 14:33:33 -0400 (EDT)
Date:   Tue, 3 Sep 2019 20:33:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Baolin Wang <baolin.wang@linaro.org>, stable@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, arnd@arndb.de, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before
 some freeing functions is not needed"
Message-ID: <20190903183331.GB26562@kroah.com>
References: <cover.1567492316.git.baolin.wang@linaro.org>
 <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
 <20190903145206.GB3499@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903145206.GB3499@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 11:52:06AM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Sep 03, 2019 at 02:58:16PM +0800, Baolin Wang wrote:
> > From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> > 
> > This patch removes NULL checks before calling kfree.
> > 
> > fixes below issues reported by coccicheck
> > net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> > net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> > net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> > net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> > freeing functions is not needed.
> 
> Hi. This doesn't seem the kind of patch that should be backported to
> such old/stable releases. After all, it's just a cleanup.

I agree, this does not seem necessary _unless_ it is needed for a later
real fix.

thanks,

greg k-h
