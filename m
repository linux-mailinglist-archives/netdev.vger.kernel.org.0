Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8F44B4313
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 08:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiBNHoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 02:44:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbiBNHoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 02:44:18 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4645A59E
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:44:10 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D40F65C00F2;
        Mon, 14 Feb 2022 02:44:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 02:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4dSVolvJBKEgqDGgP
        djwbbEgmtJVcyb7tHJDTHg95ko=; b=C21JRaAGTlsqW9Oid/ss47GnL4rJwL/bY
        q+gxGRj/sLuceSQCgl1J3XgwkLm3xcH6n8D2ueFlV3uChy1FkMoSd9IT3f8xLQzJ
        cJSUVm/ENPnxEYQDJ4sWqQavibkQAsOOM5HaeEgbWuj6+LuCNrjCm4jDcwlk00me
        RHEUNJezHI6oAJ+lSenfiwIOaBjULQq35Et6Bop+rFdpy7djdvl8va2rsiV2p2U9
        bubW+85VXubzxeN/F/iwW+h+r05GPJwxZ1f4d1U1ovbDjDBEzS00rf0K4GE8DPxT
        cZyRS6V2qOau6W6VKYVKwCU+QxGejGb8cdRdww5869AEiWBGyWNyw==
X-ME-Sender: <xms:RwgKYngN_d1O5d5OViPvFRF6xtG_tZnYpEje8t1yFWvUXMyhq3fbVw>
    <xme:RwgKYkCobqEUY6TLVdLEIz13mB2Hrtd_Tsl12wK-UynPynydeLI6hcp2R71HLobuf
    CXz7ZukVhq2Des>
X-ME-Received: <xmr:RwgKYnF7p7nOl8eGm4AEmYR3pKyBLjTYCaPAnZ9HDAoI-w4d-s2dEh7Lg6C_KVwM2yyQGexstBHyJnbVGOJ4bR45A8Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedugdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RwgKYkSBRpT7LiHsGiRkcII-WtHaMVExa98-uSIRhmQamG3PtVqZlg>
    <xmx:RwgKYkzmG9lZTSGjdZIeWVbncHUYlxDtbu9qQR1XpIqNvloZqF0T_Q>
    <xmx:RwgKYq7yvziD47ZHgHFmyl6inui0VIi9GQ9qoC1PSsL5PnI8LLKSBA>
    <xmx:RwgKYuvfFC48qJOqsUZR6P2SQbwXn_3WzhHWXDGf3RmNfmYoNuvQYg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 02:44:06 -0500 (EST)
Date:   Mon, 14 Feb 2022 09:44:02 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] ipv6: blackhole_netdev needs snmp6 counters
Message-ID: <YgoIQtZSkual5TsU@shredder>
References: <20220214021056.389298-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214021056.389298-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 06:10:56PM -0800, Eric Dumazet wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Whenever rt6_uncached_list_flush_dev() swaps rt->rt6_idev
> to the blackhole device, parts of IPv6 stack might still need
> to increment one SNMP counter.
> 
> Root cause, patch from Ido, changelog from Eric :)
> 
> This bug suggests that we need to audit rt->rt6_idev usages
> and make sure they are properly using RCU protection.
> 
> Fixes: e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Thanks for taking care of this, Eric. I applied the patch to our tree
last night before logging off and regression does look fine.
