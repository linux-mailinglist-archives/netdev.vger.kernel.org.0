Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781462D8E12
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406185AbgLMO5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:57:06 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42007 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405496AbgLMO4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 09:56:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D158758032E;
        Sun, 13 Dec 2020 09:55:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 13 Dec 2020 09:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dpcwTT
        z/sesD3B1rZoBYSQwgGPQNjssdt5XLEtahVEc=; b=HosWXGNIaVwtkVUadRZphf
        vpGtRomJMH/cvw37j0NuQLej2sw8tqNCj9GFX9+Mg03v+Bk34NG37Po68y14S1s9
        gtje7ny4yNPNulCrcApDMja4srFBDpTzz9q5+/A8KKThMczApn5Y8qoWp/XdF+ay
        oE4safZdDFaCtLrv7kgXZLTEWtyP2IZ6KcSfgsx5T9L6dumu83jXTNVrb4gJWpIe
        wlk7BCyyM5Mdz2+6E6vWvmA6GEK2G0b7G6tQbgSxB9KaEglCrNl2eFOnORiMpO1g
        nqAEskOoS8nvrY63A8yj78ZefU02Qq4fg/4Xx4rnJmAGdIiBwQzwBdVJohAApAiQ
        ==
X-ME-Sender: <xms:civWX_INofMYSLDeo9a-pXLqhRdVTvASyltTSSbW9J3GPnMGSKfPWw>
    <xme:civWXzJ4KG2NadP5GQmFgRYJZBfYLsxKGEMBlUkQES679EPsmPx37CE8ZuVdWelPD
    -wzGpj1dQ85uDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekiedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduhedvrddvjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:civWX3txsPdj8soGqTHXvWqAqnOtW1-6ZLkNzkxD81m99myoBtHBkw>
    <xmx:civWX4Y_XIivAyt3NKavMS9BSUxTEz6ORzo3mWUtyEBoR_IJFZ6rQA>
    <xmx:civWX2Y0JfCkNjq3893pdIBdRW9EF2UtuyL6CW8UbbsIi6wGans3RQ>
    <xmx:dCvWX7Ku_M9SovOxHfJ4-zuE8WpDH3q4eEaNQbRl97Icxq1xS9AsAA>
Received: from localhost (igld-84-229-152-27.inter.net.il [84.229.152.27])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC8C2108005C;
        Sun, 13 Dec 2020 09:55:45 -0500 (EST)
Date:   Sun, 13 Dec 2020 16:55:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 1/7] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Message-ID: <20201213145543.GA2539586@shredder.lan>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
 <20201213140710.1198050-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213140710.1198050-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 04:07:04PM +0200, Vladimir Oltean wrote:
> Currently the bridge emits atomic switchdev notifications for
> dynamically learnt FDB entries. Monitoring these notifications works
> wonders for switchdev drivers that want to keep their hardware FDB in
> sync with the bridge's FDB.
> 
> For example station A wants to talk to station B in the diagram below,
> and we are concerned with the behavior of the bridge on the DUT device:
> 
>                    DUT
>  +-------------------------------------+
>  |                 br0                 |
>  | +------+ +------+ +------+ +------+ |
>  | |      | |      | |      | |      | |
>  | | swp0 | | swp1 | | swp2 | | eth0 | |
>  +-------------------------------------+
>       |        |                  |
>   Station A    |                  |
>                |                  |
>          +--+------+--+    +--+------+--+
>          |  |      |  |    |  |      |  |
>          |  | swp0 |  |    |  | swp0 |  |
>  Another |  +------+  |    |  +------+  | Another
>   switch |     br0    |    |     br0    | switch
>          |  +------+  |    |  +------+  |
>          |  |      |  |    |  |      |  |
>          |  | swp1 |  |    |  | swp1 |  |
>          +--+------+--+    +--+------+--+
>                                   |
>                               Station B
> 
> Interfaces swp0, swp1, swp2 are handled by a switchdev driver that has
> the following property: frames injected from its control interface bypass
> the internal address analyzer logic, and therefore, this hardware does
> not learn from the source address of packets transmitted by the network
> stack through it. So, since bridging between eth0 (where Station B is
> attached) and swp0 (where Station A is attached) is done in software,
> the switchdev hardware will never learn the source address of Station B.
> So the traffic towards that destination will be treated as unknown, i.e.
> flooded.
> 
> This is where the bridge notifications come in handy. When br0 on the
> DUT sees frames with Station B's MAC address on eth0, the switchdev
> driver gets these notifications and can install a rule to send frames
> towards Station B's address that are incoming from swp0, swp1, swp2,
> only towards the control interface. This is all switchdev driver private
> business, which the notification makes possible.
> 
> All is fine until someone unplugs Station B's cable and moves it to the
> other switch:
> 
>                    DUT
>  +-------------------------------------+
>  |                 br0                 |
>  | +------+ +------+ +------+ +------+ |
>  | |      | |      | |      | |      | |
>  | | swp0 | | swp1 | | swp2 | | eth0 | |
>  +-------------------------------------+
>       |        |                  |
>   Station A    |                  |
>                |                  |
>          +--+------+--+    +--+------+--+
>          |  |      |  |    |  |      |  |
>          |  | swp0 |  |    |  | swp0 |  |
>  Another |  +------+  |    |  +------+  | Another
>   switch |     br0    |    |     br0    | switch
>          |  +------+  |    |  +------+  |
>          |  |      |  |    |  |      |  |
>          |  | swp1 |  |    |  | swp1 |  |
>          +--+------+--+    +--+------+--+
>                |
>            Station B
> 
> Luckily for the use cases we care about, Station B is noisy enough that
> the DUT hears it (on swp1 this time). swp1 receives the frames and
> delivers them to the bridge, who enters the unlikely path in br_fdb_update
> of updating an existing entry. It moves the entry in the software bridge
> to swp1 and emits an addition notification towards that.
> 
> As far as the switchdev driver is concerned, all that it needs to ensure
> is that traffic between Station A and Station B is not forever broken.
> If it does nothing, then the stale rule to send frames for Station B
> towards the control interface remains in place. But Station B is no
> longer reachable via the control interface, but via a port that can
> offload the bridge port learning attribute. It's just that the port is
> prevented from learning this address, since the rule overrides FDB
> updates. So the rule needs to go. The question is via what mechanism.

Can you please clarify why the FDB replacement notification is not
enough? Is it because the hardware you are working with manages MACs to
CPU in a separate table from its FDB table? I assume that's why you
refer to it as a "rule" instead of FDB entry? How common is this with
DSA switches?

Asking because it is not clear to me from the commit message. The patch
looks fine.

> 
> It sure would be possible for this switchdev driver to keep track of all
> addresses which are sent to the control interface, and then also listen
> for bridge notifier events on its own ports, searching for the ones that
> have a MAC address which was previously sent to the control interface.
> But this is cumbersome and inefficient. Instead, with one small change,
> the bridge could notify of the address deletion from the old port, in a
> symmetrical manner with how it did for the insertion. Then the switchdev
> driver would not be required to monitor learn/forget events for its own
> ports. It could just delete the rule towards the control interface upon
> bridge entry migration. This would make hardware address learning be
> possible again. Then it would take a few more packets until the hardware
> and software FDB would be in sync again.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
