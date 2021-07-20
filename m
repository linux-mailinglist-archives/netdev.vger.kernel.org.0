Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9559C3CFB41
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhGTNM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:12:56 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:52399 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239277AbhGTNKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:10:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 22F84580A2D;
        Tue, 20 Jul 2021 09:51:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 20 Jul 2021 09:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RnfYnU
        XKt4Ke4MftA5VvFPElPeokJ2dpZfg8rcz5Vu0=; b=QrTUmqt2py7V7koT/9N+ll
        EutBd4CkyQUnJKhZbJexgiMBQcqlkrJ43sCf3Z47PFHsce55J/Zx57A3jQe3F9ia
        WdjQ9zQvWPnIGSG/Ige0kp4yVJy1cv7WnpIuJW4CrWA+slOYCDivgZtPzu4jVVEE
        9fxXZf6jk33tQrKal3Y3gG0otZit+XIrohpBty8+WvPEFnvqOMzSCOcLC+Y+tAUK
        L9wx6M2B51kThhrXrArKT+acjtiikH1kptNwMksZOIV+GoUaEqdae8c0cwwA6sQI
        GAGoIIa0lANqk2uqLwb+yvRHIPdFyTSsK9Rt7hMxfR9/XsoVMHnXeGYidrgIcr8w
        ==
X-ME-Sender: <xms:39T2YGTqkFPemr1uXnsgcTs17ZEP1jd0PuICYM65fe2yO5pCLCS8bQ>
    <xme:39T2YLzAb9tRyLYzl0t6bxOLWDsKSKD5DL2vkKepxNMJoqhO7IVHev4j0CkSUry0H
    zxuhYtJAiNAeWI>
X-ME-Received: <xmr:39T2YD1QboIZuCTGVZ7fw_7gc5578J1odOMTpHLYXvXxHMiP32F2GKFCB_638HU8tmTMwu65xbycp3VWga17ZMXWjd4yuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedvgdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:39T2YCBkLsgjlR-WIrhJvuFNoe-K6qRhYzEQQ-NxTXtt0_lwD0enpg>
    <xmx:39T2YPgleTO_seiWkFTjWOjtDJihSCT_kE2mofEcYAmfLKGnpLQDBQ>
    <xmx:39T2YOqWOFT8qSygj2atL7iW-hkUXXlcjkrrJI8fTf6NyVZ7g7u-sA>
    <xmx:4dT2YKQG3-DLtTwfgw2_0bxrL1gj-Qvp8j53y8CLTG4Nt9Inz8gVxQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jul 2021 09:51:27 -0400 (EDT)
Date:   Tue, 20 Jul 2021 16:51:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
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
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 00/15] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Message-ID: <YPbU20/cjkz04s8b@shredder>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <YPaybQZE8l6mRE2l@shredder>
 <20210720132026.mpk3iq3z6vmmzxyd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720132026.mpk3iq3z6vmmzxyd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:20:26PM +0300, Vladimir Oltean wrote:
> On Tue, Jul 20, 2021 at 02:24:29PM +0300, Ido Schimmel wrote:
> > Too many things are squashed into this one patchset. It needs to be
> > split.
> >
> > The TX forwarding offload in mv88e6xxx is not related to the replay
> > stuff and should be added in a separate patchset. This can be done by
> > first adding the switchdev_bridge_port_offload() /
> > switchdev_bridge_port_unoffload() APIs that only take care of setting /
> > unsetting the hardware domain for the bridge port. Then, in a different
> > patchset, these APIs can be augmented with a parameter for the replay
> > stuff. It should be easier to review that way and require less
> > unnecessary surgeries in drivers that do not require the added
> > functionality.
> 
> Fair point. I will submit patches 1-10 and 11-15 separately.

Not sure if you mean in that order or not, but I suggested first getting
the TX forwarding offload (patches 11-15) in and then extending the new
APIs with replay argument so that drivers can opt-in. This should reduce
the complexity of the second patchset and make it less likely to
introduce bugs.

> 
> > According to the title, the patchset is focused on improving
> > performance, but there are no performance numbers that I could see and
> > most of the patches deal with the replay stuff instead.
> 
> Maybe, but the truth is that it is not really the performance
> improvement that I care about. The performance quote is from Tobias'
> original cover letter, which I took as-is. I can build a synthetic test
> for multicasting on 10 mv88e6xxx ports or something like that, or maybe
> Tobias can provide a more relevant example out of Westermo's use cases.
> But it would be silly if this patchset's acceptance would depend on the
> numbers. This is one of those cases where completely different interests
> led me and Tobias to the the same solution.
> 
> I don't want to bore you to death with details, but for some switches
> (DSA or otherwise), being able to send bridge packets as they are (data
> plane packets) instead of what they aren't (control plane packets) is a
> matter of functionality and not performance. Such switches only use
> control plane packets for link-local packet traps, and sending/receiving
> a control packet is expensive.
> 
> For this class of switches (some may call them "dumb", but whatever),
> this patch series makes the difference between supporting and not
> supporting local IP termination through a VLAN-aware bridge, bridging
> with a foreign interface, bridging with software upper interfaces like
> LAG, etc.

OK, so this can be mentioned in the cover letter as well as an argument
for the feature. Wanted to make sure the patches were actually tested
given Tobias was the first to publish them and I'm not sure if he tested
them in the new form or if you have the required hardware.
