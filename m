Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427C3644325
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiLFMam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLFMak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:30:40 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EFD28E2C;
        Tue,  6 Dec 2022 04:30:38 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D970C32009D6;
        Tue,  6 Dec 2022 07:30:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 06 Dec 2022 07:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670329836; x=1670416236; bh=jE2AKhiday7rIVXVatfMZmacEC94
        FeR0G3T3H1swJ8Y=; b=Ny7jLi5P8j4TjF5rVK3gvSYaXgEW6vskaSmN3qdDP2iQ
        5nmHAUY5r8RySL+guzL//8B9pYMy5aASBysH0BW4/wlAsJDqvAtHMKL3ABnsQgSa
        BMgKqhJgI36dhqlYSsQgcvyGxhPtaWJL1SqaUkDBV7gI+qezOd4AidpS964O90A0
        zogMaWgu/FfmN7aD8YJi+Os6W/viOxWlCYkqIPeh1DpbhXUc7YZA3aspKRyD4TTS
        3BnjrlpyuAXZhPfkytGsj2d9cGOrYa8Qi8e3yRF9N1TFGEm3CLyt7BWKsD6qdl/K
        Li7NE1Ul/MR80TvoctNk3f4qZcxP+PoC1qtRdMN2dg==
X-ME-Sender: <xms:6zWPYwFgRhGbbzL4DmSOOtWwGOTpok2rDk7xbk-u2GGU0YDKlQuT3Q>
    <xme:6zWPY5XiGTz4j8w8S6tzXCD3dobyBZ7GtIfj6cAr9vu4pBVpcguVhBSqufN8letXn
    o-m66Ywmh8-lEw>
X-ME-Received: <xmr:6zWPY6KvU-fQvWm-y5_xi7QT1MF3jrMTcn4m49VNDHXqSzTjtuwz6cMhcedASreOiCRUbuQEjiehgzX6gwJogIzVHxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6zWPYyHAqFj7Px3AppSXu2E-FAD5IwZrCJQdNTa7zQTqh6XUMJKilQ>
    <xmx:6zWPY2U4J1XwMqmYlU5mD2L3BMREVFiLfPguTfhQnO5mmXB_LIfClA>
    <xmx:6zWPY1NdYJIQTxmjnTZwKvheiglADn2AXUtvK-Ub6u-Idx8SIw0GBg>
    <xmx:7DWPYxE8RfRCpUY6gsqDaEyncwaISF4tF6EByuG0CdOPUq1ubGG6xQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Dec 2022 07:30:34 -0500 (EST)
Date:   Tue, 6 Dec 2022 14:30:29 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: change default return
 of mv88e6xxx_port_bridge_flags
Message-ID: <Y4815esuJ0H9tx7s@shredder>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205185908.217520-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 07:59:07PM +0100, Hans J. Schultz wrote:
> The default return value -EOPNOTSUPP of mv88e6xxx_port_bridge_flags()
> came from the return value of the DSA method port_egress_floods() in
> commit 4f85901f0063 ("net: dsa: mv88e6xxx: add support for bridge flags"),
> but the DSA API was changed in commit a8b659e7ff75 ("net: dsa: act as
> passthrough for bridge port flags"), resulting in the return value
> -EOPNOTSUPP not being valid anymore.

The commit message needs to explain the motivation for the change and
why the change is not a bug fix / safe. I guess the motivation is the
next patch where a change in the MAB flag cannot fail and therefore it
has no reason to reset the 'err' variable. The change is only safe if
upper layers only invoke the operation when supported bridge port flags
are changed. That is, the default error code is never used.
