Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7768848F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjBBQgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjBBQgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:36:20 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2B06A32A;
        Thu,  2 Feb 2023 08:36:19 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 10E625C00EE;
        Thu,  2 Feb 2023 11:36:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 02 Feb 2023 11:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675355779; x=1675442179; bh=TIhEi6ttvP0lJU+5WCdxSL+GeMSa
        1GjHCMM3WgC2HbI=; b=VSnQjrveDF/yWKN17jbl9A9KQ/20d/BLeyFmh0sJKD56
        mr2sArWTxPJqrq0t21IsDdsmuGPwzjV8N3BCxZkYApxD4AySNsR8Q5pubCcrm6N9
        v0HNjbvyq7XNxz9EYe+S74z9J/64clwZjICyOemliKqsmTlJfD7umrgNMaGtDvZF
        7JacA/sjYffBIvZagOMjNOrS0z10yFIYqa8FiZMC5IFBwQCfv4xQy+FRhe582e1k
        A8T2NY+LPGDILcFXSBNzbXL2a2UtxlBylDyeMxSkQTdTwfh7P3BFj3neTk9MmiRM
        rIWs41yaVPnc6rZqsp87EV/xcK6pkXDGagWgLvyOJQ==
X-ME-Sender: <xms:gubbY2mWtJKWdeSSVE06Aek0cGNbhJzeMMrGAKxcn_TK2Ng30JRL2Q>
    <xme:gubbY918yLTkJYlAhXXKg7cr5nOcIaWwfpawyVv8QpWxsOTyUcJs3gKe0eRv9K5qm
    wRW_yI1PUHKIf0>
X-ME-Received: <xmr:gubbY0oQqNIg5AkMnNYrS2sf6vsC6ickC58MFja4vDCJD0xJs59FdJXmtSCv5MKEiC5UYqrMui9ZEyLRluPc83UrD2Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepjeekleettddtgfeuvdffieffudegffetgedtteffvefgjeejvefhffehtddv
    ueevnecuffhomhgrihhnpehpohhrthdrshhhnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gubbY6nXTCXRXeWi6bB90tWCVKo-qovC2w_L8YAeoAMmQ7YZa3RVIA>
    <xmx:gubbY01tiYUQjZ5IqExcJAnycYueDhINqRyRNAGYB8hpy1z37n9Iew>
    <xmx:gubbYxtUmV23mFbKOXD0zibUfsJe8o69CY22lGbvqSx0lYiz_IijZw>
    <xmx:g-bbY7DyFj7busEn_AKs8QZ42D8JPz7UDRQ4WGE-ObJwnhEtyASZDg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 11:36:17 -0500 (EST)
Date:   Thu, 2 Feb 2023 18:36:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 0/5] ATU and FDB synchronization on locked ports
Message-ID: <Y9vmfoaFxPdKvgxt@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <Y9lrIWMnWLqGreZL@shredder>
 <e2535b002be9044958ab0003d8bd6966@kapio-technology.com>
 <Y9vaIOefIf/gI0BR@shredder>
 <3cecf4425b0e6f38646e25e40fd8f0fd@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cecf4425b0e6f38646e25e40fd8f0fd@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:19:07PM +0100, netdev@kapio-technology.com wrote:
> On 2023-02-02 16:43, Ido Schimmel wrote:
> > On Thu, Feb 02, 2023 at 08:37:08AM +0100, netdev@kapio-technology.com
> > wrote:
> > > On 2023-01-31 20:25, Ido Schimmel wrote:
> > > >
> > > > Will try to review tomorrow, but it looks like this set is missing
> > > > selftests. What about extending bridge_locked_port.sh?
> > > 
> > > I knew you would take this up. :-)
> > > But I am not sure that it's so easy to have selftests here as it is
> > > timing
> > > based and it would take the 5+ minutes just waiting to test in the
> > > stadard
> > > case, and there is opnly support for mv88e6xxx driver with this
> > > patch set.
> > 
> > The ageing time is configurable: See commit 081197591769 ("selftests:
> > net: bridge: Parameterize ageing timeout"). Please add test cases in the
> > next version.
> 
> When I was looking at configuring the ageing time last time, my finding was
> that the ageing time could not be set very low as there was some part in the
> DSA layer etc, and confusion wrt units. I think the minimum secured was like
> around 2 min. (not validated), which is not that much of an improvement for
> fast testing. If you know what would be a good low timeout to set, I would
> like to know.

My point is that the ageing time is parametrized via 'LOW_AGEING_TIME'
in forwarding.config so just use '$LOW_AGEING_TIME' in the selftest and
set it as high as it needs to be for mv88e6xxx in your own
forwarding.config.
