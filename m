Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954F0315638
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhBISnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:43:21 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:33465 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233471AbhBIS25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:28:57 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id C2BC9580171;
        Tue,  9 Feb 2021 13:26:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Tue, 09 Feb 2021 13:26:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jbTXSE
        kHbtCMu+f135EDu0ufO51m7hO7fIyJQPnw2cM=; b=Av5rWJhyVsredRqpbe+/Uz
        F6LRuAWYNgnYiqjcioKGv21NJd19zUqh8Yz62DRSZbvWqOEATjoeCug2VAQND4o3
        rSu7q7pXakLyzIaBI89YmdmqqKNzd9PhP4WqX04efbSc5lGj193sXRzM2g4Gd6/z
        pwrWh8hiX4DvPGJat9nzP4a2GPMF5KgWu3vYqg0IW/xV6cKuPD50OP2+FSJIMK3x
        G7lOEM4+dZWPDWW0F69f1QqzHpN0r+mvCTEHNUAjFT6lJdiOqr7wyCC/VrXdbKJ9
        L9y+7Q7imyAVmXrCRAw42xW2hVQWj9u4dYh6Q/QxgFHcLo5YGsB1PLeUb6e2ee+Q
        ==
X-ME-Sender: <xms:zNMiYP3haaEoL0jF1iJoVGmPbWsCguNeDd3w4o9KskECGTpZpLSPHA>
    <xme:zNMiYAHyfBICO7zxoJq3Neb4Iesy3u5ZBbegiXQngD2R7g2SUZF_cXccjZ77viGHQ
    sinNXDrmuG1Kp8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheehgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvddvledrudehfe
    drgeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zNMiYJRxAYDMnRHOHA0WoUtVVEdSj4mQobBjnoJDI802tand7mi_ig>
    <xmx:zNMiYHBJPXqqxcD7RB1HHiMbeQ_FD8QPLOIR4h0qr45TGGM98Zcx0g>
    <xmx:zNMiYJ3R_bCNPZscbk0g_qj79gAW3SkLz16iJu5fXQJgffjtxFYFeQ>
    <xmx:0NMiYMg3AiQ6JXmNSLpUYMQXU4uLmtnHQHR6f5u-HFBvBDdB-sXH9w>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7364424005D;
        Tue,  9 Feb 2021 13:26:20 -0500 (EST)
Date:   Tue, 9 Feb 2021 20:26:17 +0200
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
Subject: Re: [PATCH v2 net-next 03/11] net: bridge: don't print in
 br_switchdev_set_port_flag
Message-ID: <20210209182617.GB262892@shredder.lan>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-4-olteanv@gmail.com>
 <20210209173631.c75cdjxphwzipeg5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209173631.c75cdjxphwzipeg5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 07:36:31PM +0200, Vladimir Oltean wrote:
> On Tue, Feb 09, 2021 at 05:19:28PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Currently br_switchdev_set_port_flag has two options for error handling
> > and neither is good:
> > - The driver returns -EOPNOTSUPP in PRE_BRIDGE_FLAGS if it doesn't
> >   support offloading that flag, and this gets silently ignored and
> >   converted to an errno of 0. Nobody does this.
> > - The driver returns some other error code, like -EINVAL, in
> >   PRE_BRIDGE_FLAGS, and br_switchdev_set_port_flag shouts loudly.
> >
> > The problem is that we'd like to offload some port flags during bridge
> > join and leave, but also not have the bridge shout at us if those fail.
> > But on the other hand we'd like the user to know that we can't offload
> > something when they set that through netlink. And since we can't have
> > the driver return -EOPNOTSUPP or -EINVAL depending on whether it's
> > called by the user or internally by the bridge, let's just add an extack
> > argument to br_switchdev_set_port_flag and propagate it to its callers.
> > Then, when we need offloading to really fail silently, this can simply
> > be passed a NULL argument.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> 
> The build fails because since I started working on v2 and until I sent
> it, Jakub merged net into net-next which contained this fix:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210207194733.1811529-1-olteanv@gmail.com/
> for which I couldn't change prototype due to it missing in net-next.
> I think I would like to rather wait to gather some feedback first before
> respinning v3, if possible.

It seems that in the sysfs call path br_switchdev_set_port_flag() will
be called with the bridge lock held, which is going to be a problem
given that patch #8 allows this function to block.
