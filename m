Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C233155EB
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhBIS2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:28:32 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:55427 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233340AbhBISW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:22:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5660C5802DA;
        Tue,  9 Feb 2021 13:00:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 09 Feb 2021 13:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=apMIh8
        1zHTwrdiLkYm/FdsFavFVD8+FsPBR4HWhPa2U=; b=TeOeHWpIBlLMsdNiMMUs19
        cQ52jAyJcvO/gFYpHT4LKstRXjXlP+KZTXE2jmEJulRJBm2G+kWiuiXiC0GPoTjV
        V7b+MMxWxtC8nGDsNXAr7LXOsKJ3/Y96SxktYrBKxLf4PQ1PZU/QQxRc8OYsRHzi
        t1HfCb9Z5A+XmCLkJkD5iQX9ITZjSKCCroI4Z/kz/AEnphvke8KffOmt7izQDX9H
        kyl2/WitQ9QmObM+Y/PLEly5PHhKtvteG8Zt29HJRFrrbHZcHncbecpRTQNLHNBk
        pdqJMm4onota2IWfcztPN3tXcRoMUttvgPlUJ3cY4Zrlr38oQ+3MDcRYqqO6nVmA
        ==
X-ME-Sender: <xms:uM0iYLn2jAXoGYPTRNtJxwXdF5KM8bwb4Yq12fwbCU2k-L3rKh7YMw>
    <xme:uM0iYO1eMSvDiETvzYTmrwwV8XJH99ACpQpwo5OXQgmvMKT0hL3vlwo0uCOP5z3QM
    HKEXB-HkJrBO38>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheehgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:uM0iYBqxKr_eSnGWqXgOaJRGutiEJpBmkSdXEOA8g00Wf6MbAZIC3w>
    <xmx:uM0iYDkwJtWJIxnFCfVjC-W0okkmy7xMvQCOfCBxMIu2SGwaBZK3Sg>
    <xmx:uM0iYJ2CZS-2sh4j4gcXrzlri7P0xINrHGgiUW8IPZUCpE17pX2-YQ>
    <xmx:u80iYF6YKAbIP052gotWsGfb737pdMzYpkzg7Ya66r1ik1RKes7roQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 766FF24005C;
        Tue,  9 Feb 2021 13:00:24 -0500 (EST)
Date:   Tue, 9 Feb 2021 20:00:20 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 01/11] net: switchdev: propagate extack to
 port attributes
Message-ID: <20210209180020.GA262892@shredder.lan>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209151936.97382-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:19:26PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a struct switchdev_attr is notified through switchdev, there is no
> way to report informational messages, unlike for struct switchdev_obj.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
