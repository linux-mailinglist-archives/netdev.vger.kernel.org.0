Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3BF591FBA
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiHNM1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 08:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiHNM1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 08:27:32 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BE71C92B;
        Sun, 14 Aug 2022 05:27:31 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D8585C00A6;
        Sun, 14 Aug 2022 08:27:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 14 Aug 2022 08:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660480048; x=1660566448; bh=Hz0ZhyzIO3X/y1kG7So53cSJfTIn
        sJ3nYEy6fIrN1Mg=; b=B2+jX9BHCYo6YvCkh+pBofceaa5C3scLD5LMAexH/D7s
        ixH/KzBQL32cHqE9OgpJRcvUrq1FMIMLG6uqJJMnmOz/p1cm23g8sJB7NvYCN5DP
        dPqwzBkQcT2qR1+gFt6A0WMZZB4vip7hWwQG+KYGOSlzjGEkPbWXfpnC4KZdoHG2
        GF4w4lNTgZov8WNR17qh/adIBYYJ1TlB2L8dT4424DMXLYAnVisBqFL76dW6sOpA
        ip1pUMq8DRFF9WNFz2LNqdNBsZlnRwIEutjhbz3iGWRynRTEffiBWrSTbNyQJHFX
        4UM+JIpzB/SY47gfNz4MZHlpqWMdbVJ7d59cjUEIAg==
X-ME-Sender: <xms:L-r4Yslxr4A-mP5aNJaZ-scQxXzR69adzyMWmLUEDIIm5OPVgpqHsA>
    <xme:L-r4Yr0kMOa7bZYCnN5GeCUxBxNT4_H_G82SWOy36KTFMk8vR-n1rfq_Pjn9hG7wu
    OCj9xCKigSro3k>
X-ME-Received: <xmr:L-r4YqrKHf8j2qwNJxZU9YdaFvKLAy-pAC8TBowKLPnI-kEMa3CxLK9T7Dt0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehtddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefhffejgefhjeehjeevheevhfetve
    evfefgueduueeivdeijeeihfegheeljefgueenucffohhmrghinhepghhithhhuhgsrdgt
    ohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:L-r4YolyX-kqvXmZqP4NmSsVvUvtp34KtQo0erJS7txJVvAD2pnNtQ>
    <xmx:L-r4Yq2eGr9OccEetK9WkejQvHbQOuk7foXBiLOSLALoYurVKcPt1w>
    <xmx:L-r4YvuZRxdWRcQpFR5-G0gNSotGp3edxeY00A4xJwpEGODW-G3anA>
    <xmx:MOr4YnshtJygL7f6jwCR_QqHJdGTMd_HxsWIOwE3XXIysfJXhP0Cdg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 14 Aug 2022 08:27:27 -0400 (EDT)
Date:   Sun, 14 Aug 2022 15:27:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 4/4] ynl: add a sample user for ethtool
Message-ID: <YvjqLDnWUONvnv3E@shredder>
References: <20220811022304.583300-1-kuba@kernel.org>
 <20220811022304.583300-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811022304.583300-5-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 07:23:04PM -0700, Jakub Kicinski wrote:
> @@ -0,0 +1,115 @@
> +# SPDX-License-Identifier: BSD-3-Clause
> +
> +name: ethtool
> +
> +description: |
> +  Ethernet device configuration interface.
> +
> +attr-cnt-suffix: CNT
> +
> +attribute-spaces:
> +  -
> +    name: header
> +    name-prefix: ETHTOOL_A_HEADER_
> +    attributes:
> +      -
> +        name: dev_index
> +        val: 1
> +        type: u32
> +      -
> +        name: dev_name
> +        type: nul-string
> +        len: ALTIFNAMSIZ - 1
> +      -
> +        name: flags
> +        type: u32
> +  -
> +    name: channels
> +    name-prefix: ETHTOOL_A_CHANNELS_
> +    attributes:
> +      -
> +        name: header
> +        val: 1
> +        type: nest
> +        nested-attributes: header
> +      -
> +        name: rx_max
> +        type: u32
> +      -
> +        name: tx_max
> +        type: u32
> +      -
> +        name: other_max
> +        type: u32
> +      -
> +        name: combined_max
> +        type: u32
> +      -
> +        name: rx_count
> +        type: u32
> +      -
> +        name: tx_count
> +        type: u32
> +      -
> +        name: other_count
> +        type: u32
> +      -
> +        name: combined_count
> +        type: u32

Another interesting use case for the schema can be automatic generation
of syzkaller descriptions. These are the corresponding descriptions for
syzkaller:

https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink_generic_ethtool.txt#L125

Last I checked, these descriptions had to be written by hand, which is
why they are generally out of date, leading to sub-optimal fuzzing. If
schemas are sent along with the kernel code and syzkaller/syzbot
automatically derives descriptions from them, then we should be able to
get meaningful fuzzing as soon as a feature lands in net-next.

> +
> +headers:
> +  user: linux/if.h
> +  uapi: linux/ethtool_netlink.h
> +
> +operations:
> +  name-prefix: ETHTOOL_MSG_
> +  async-prefix: ETHTOOL_MSG_
> +  list:
> +    -
> +      name: channels_get
> +      val: 17
> +      description: Get current and max supported number of channels.
> +      attribute-space: channels
> +      do:
> +        request:
> +          attributes:
> +            - header
> +        reply: &channel_reply
> +          attributes:
> +            - header
> +            - rx_max
> +            - tx_max
> +            - other_max
> +            - combined_max
> +            - rx_count
> +            - tx_count
> +            - other_count
> +            - combined_count
> +      dump:
> +        reply: *channel_reply
> +
> +    -
> +      name: channels_ntf
> +      description: Notification for device changing its number of channels.
> +      notify: channels_get
> +      mcgrp: monitor
> +
> +    -
> +      name: channels_set
> +      description: Set number of channels.
> +      attribute-space: channels
> +      do:
> +        request:
> +          attributes:
> +            - header
> +            - rx_count
> +            - tx_count
> +            - other_count
> +            - combined_count
> +
> +mcast-groups:
> +  name-prefix: ETHTOOL_MCGRP_
> +  name-suffix: _NAME
> +  list:
> +    -
> +      name: monitor
