Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946213D0943
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 08:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhGUGPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 02:15:04 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39579 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbhGUGPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 02:15:03 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 521AD581609;
        Wed, 21 Jul 2021 02:55:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 21 Jul 2021 02:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6yi/O0
        LyOJ89V3sggDKStxOVOB4l9oGGCJnJDXDH4Io=; b=SmeNKoI4xLKnlWMFOlUQZc
        3VKleiE/Q7H0nBLuW0vQLhMdSU8bX/eNwmCqzta5i2lRmUTd+lANGA3NEBJqMUcR
        8LE6Ipvrj1I1rUjUPNi0/jnrhcMXGGZrqVxevV1ss5EVMIXS0FAScd1IUy7Ri9c0
        xZGhGvUrMujY/EOyvlzP7HIDMqhmq6BTLkC7BfRwU1hNSrgbe5Hs6rn2phkXDK4E
        DK51xDUEvXDtHReR/3LLgiClgn2gFkz3GMEbW72jcrxaM3lREjE1nP8L0tki/xbu
        COhHaTbHcwtUBQDdGZaMnZpca0VpKo/ZefkLr2Knzu+t0FEVJSYV8BP5Tq4A633g
        ==
X-ME-Sender: <xms:1cT3YCH2icXFKSg9wxJ7YGeau_xYlMAKJvRAI55bpwo3t9_I0T1dzQ>
    <xme:1cT3YDWOQduCITenGlx4hUjOFnBzrs2nNLDPJJvWATYhccX-FCWLmp5QcHEKoqxoA
    aWNa1XWBoh5CHY>
X-ME-Received: <xmr:1cT3YMKC6Ua95jz6yFXvQ_bArY8DkBM5oPkT3OAtfaLtflwXJBNuchIJLO4bnOvfEgud-3wt5pCGh4sV20pzdcdN9IEzaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeefgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1cT3YMFkogiDK8LhnXmNGE0PUVslZYHUdyGrY32oZfbexY-0zPAuqg>
    <xmx:1cT3YIUQ2g9VUJ6ehVx2i9jCNjjKjXmYImt3YphwqZofLXoUqasWLw>
    <xmx:1cT3YPMiM7yj4rQ4GngtrT1SakM8noLfNu9ND-_6a0iRTchNA6feWw>
    <xmx:18T3YJUlqZoL9lC1gXQFTASrDXNHO9_kDwHEeQfH_4yvEDDHxaGF8w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 02:55:17 -0400 (EDT)
Date:   Wed, 21 Jul 2021 09:55:14 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Message-ID: <YPfE0oEfwVe1u4rM@shredder>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder>
 <20210720141200.xgk3mlipp2mzerjl@skbuf>
 <YPbcxPKjbDxChnlK@shredder>
 <20210720194717.qbdz5mmmxqbn3y3z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720194717.qbdz5mmmxqbn3y3z@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 07:47:18PM +0000, Vladimir Oltean wrote:
> On Tue, Jul 20, 2021 at 05:25:08PM +0300, Ido Schimmel wrote:
> > If you don't want to change the order, then at least make the
> > replay/cleanup optional and set it to 'false' for mlxsw. This should
> > mean that the only change in mlxsw should be adding calls to
> > switchdev_bridge_port_offload() / switchdev_bridge_port_unoffload() in
> > mlxsw_sp_bridge_port_create() / mlxsw_sp_bridge_port_destroy(),
> > respectively.
> 
> Is there any specific reason why you suggested me to move the
> switchdev_bridge_port_offload() call from the top-level
> mlxsw_sp_port_bridge_join() into mlxsw_sp_bridge_port_create()
> (and similarly, from _pre_bridge_leave to _destroy)?
> 
> Even if you don't support replays right now, you'd need to move a bunch
> of code around before you would get them to work. As far as I can see,
> mlxsw_sp_bridge_port_create() is a bit too early and
> mlxsw_sp_bridge_port_destroy() is a bit too late. The port needs to be
> fairly up and running to be able to process the switchdev notifiers at
> that stage.
> 
> Do you mind if I keep the hooks where they are, which is what I do for
> all drivers? I don't think I am missing to handle any case.

I want to avoid introducing unnecessary changes. I will do them when
needed.

Thanks
