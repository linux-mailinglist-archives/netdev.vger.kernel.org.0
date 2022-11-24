Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9D263791D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 13:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiKXMmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 07:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiKXMmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 07:42:08 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFAFF72F5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 04:41:40 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A90635C0129;
        Thu, 24 Nov 2022 07:41:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 24 Nov 2022 07:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669293696; x=1669380096; bh=VitFjZtJvWpj3F2lJqlagGHTV0Ec
        x94SxdP9qRlazko=; b=EgDBEDaM9gUdgJZu6aNO+mTgVkxJ9c++evMUKD7oiHP6
        +LoO6XkSnHlczG+3lrMEAwTkdOEiPIY7nKBYxpqjAs9leoucTgMI+kExtCrrOIQe
        9TEJiI4ef5ccpPpOF+82If4orX3xnLDYZW/89/GY9AIDQ1u6+cI0taR0mIqT07bI
        BDv35oaofuNlxJbBRpISNm6JBjce4en54I8FwCRtLJLwK2q/F8E5NN5AL+U1GNUn
        15WwfpqbO5TIOMDBsj/59GgWxpL30+Bcd22EVL1b08615m5bz8t3T7PwhYvLQ+ko
        PJyGTz5zM+TNiY53nIAm/Q73P91jrMqG6bDOJnTBmA==
X-ME-Sender: <xms:gGZ_Y8Ef2HBaJb7DVXH7GvdNmbdtE6tujJxYB-_MWhxNE_z_XRPqtA>
    <xme:gGZ_Y1UHbyQUsMOJS9K9BuGZoJ8BdW8uSmfSyBRLE8bGbuZxg9wjxc--pHs7Glz4o
    Orhqcl0PXh6AXE>
X-ME-Received: <xmr:gGZ_Y2LVmLMl3TABcff4xO8c1bd89snLYlNbN9Zf-NDzhB8wKREAuZI4_7ctMP7M4xxPI8MQKozsDtqk6D9N5jzUHNE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieefgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gGZ_Y-FSBL9SpzeFMTAkz-PUfoMmoYmpmNjgM_RafXb7VEN3X7jOKA>
    <xmx:gGZ_YyU0_fh6rbqIHKRkAAlU1booCbUyfTG3bAonK5Vco8GNVM-7lA>
    <xmx:gGZ_YxMOqylmOa-T8KotauYzrkTdzRA6ZHpp6j_dthc1L_ctX-i30Q>
    <xmx:gGZ_Y7d8svCYX-lzskkdY6yqU76P2sRPuAkEpiK8SIFxLsb_92KXtQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Nov 2022 07:41:35 -0500 (EST)
Date:   Thu, 24 Nov 2022 14:41:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1
Message-ID: <Y39me56NhhPYewYK@shredder>
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 10:20:00AM +0100, Jonas Gorski wrote:
> Hello,
> 
> when an IPv4 route gets removed because its nexthop was deleted, the
> kernel does not send a RTM_DELROUTE netlink notifications anymore in
> 6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
> multipath route when fib_info contains an nh reference"), and
> reverting it makes it work again.
> 
> It can be reproduced by doing the following and listening to netlink
> (e.g. via ip monitor)
> 
> ip a a 172.16.1.1/24 dev veth1
> ip nexthop add id 100 via 172.16.1.2 dev veth1
> ip route add 172.16.101.0/24 nhid 100
> ip nexthop del id 100
> 
> where the nexthop del will trigger a RTM_DELNEXTHOP message, but no
> RTM_DELROUTE, but the route is gone afterwards anyways.

I tried the reproducer and I get the same notifications in ip monitor
regardless of whether 61b91eb33a69 is reverted or not.

Looking at the code and thinking about it, I don't think we ever
generated RTM_DELROUTE notifications when IPv4 routes were flushed (to
avoid a notification storm).

Are you running an upstream kernel?

Thanks

> 
> Doing the same thing with IPv6 still works as expected
> 
> ip a a 2001:db8:91::1/64 dev veth1
> ip nexthop add id 100 via 2001:db8:91::2 dev veth1
> ip route add 2001:db8:101::/64 nhid 100
> ip nexthop del id 100
> 
> Here the kernel will send out both the RTM_DELNEXTHOP and the
> RTM_DELROUTE netlink messages.
> 
> Unfortunately my net-foo is not good enough to propose a fix.
> 
> Best regards
> Jonas
