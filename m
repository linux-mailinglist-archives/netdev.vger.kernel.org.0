Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D624C196D7
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 04:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfEJC5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 22:57:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39973 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbfEJC5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 22:57:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 052E221C46;
        Thu,  9 May 2019 22:57:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 09 May 2019 22:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P0E+vg
        w7gVRhrh8/UI9GOpgCdpeDnUgHcsc0wsgCABU=; b=hWfK03kaNW7Ohu10St/HLh
        wuLsm4DJNPEP7VHvtse/oH/duT+siM0gUEPsKB9Ls2IzHjTZJntjWyWHbPa5Z4QK
        /1pJF4xj5SymqPMXgnOtbeZWuPZTLfMnC4H3UDb9h+sQSnUJOYM3mlPjVQHifPBH
        6zF1IOWBmGkgCmAxvGSrIRaoSlYLKOYwX52MQ4CUrH+9WtwjQ17Obh8KCIIVQtbc
        K0D0ZjhQZBSRHfcs5wJUftuOsIM4vy2EJf57LJ6MUSJDFdX6uqR9QkFLYb+HdQ4V
        6PgMcGGGpxIGgsFJblZXDJLayynxOGB7pDVxpums+6Jj7d6yDfkIttD8rYz8orqg
        ==
X-ME-Sender: <xms:nejUXFX_Q43KL53FLlaHUqufjQ6X-SFdIKyPKz5Js5pp3wwJoc4a7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigdduieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goteeftdduqddtudculdduhedmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttder
    tdforedvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehtohgsih
    hnsehkvghrnhgvlhdrohhrgheqnecukfhppeduvdegrddujedurddvuddrhedvnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehtohgsihhnsehkvghrnhgvlhdrohhrghenucevlhhush
    htvghrufhiiigvpedt
X-ME-Proxy: <xmx:nujUXH0ZhFTU65I-EcVfmRis3pett1tHFJ2l6YCOrz32guLO3gDt7Q>
    <xmx:nujUXDoEpXskTuMcvuJUiwfrSe7urfxXcdnXbzaxt_2To1p1dpSRWg>
    <xmx:nujUXOVWNqfmGgQ2ntI4yDMxAow3UMRKBRSLIOyFNbTNCk_wGe6o8Q>
    <xmx:nujUXCTEKWE3S_HvjcmtNvgk3oSVx6Fl3ULiQZ3aZZj5TlSen4cKzA>
Received: from localhost (124-171-21-52.dyn.iinet.net.au [124.171.21.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43B6C10379;
        Thu,  9 May 2019 22:57:33 -0400 (EDT)
Date:   Fri, 10 May 2019 12:57:02 +1000
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bridge: Fix error path for kobject_init_and_add()
Message-ID: <20190510025702.GA10709@eros.localdomain>
References: <20190510025212.10109-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510025212.10109-1-tobin@kernel.org>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 12:52:12PM +1000, Tobin C. Harding wrote:

Please ignore - I forgot about netdev procedure and the merge window.
My bad.

Will re-send when you are open.

thanks,
Tobin.
