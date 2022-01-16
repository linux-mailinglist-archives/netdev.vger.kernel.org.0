Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2704648FBE2
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 10:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiAPJGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 04:06:19 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35547 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbiAPJGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 04:06:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E1585C0109;
        Sun, 16 Jan 2022 04:06:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 16 Jan 2022 04:06:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6mUN6l
        nPhi4vK/sE2Mm7bN1HxPdtLdxKReDfFKNJihk=; b=cTlCShiscwQFt/z0ajChuO
        wKoXTD0m1d3tAEwe6Bb6TiuQcgcXl3wnpE/zbry9o4GBwSlclQv4787j3m8tAHXD
        glHCLyzlL9amfddeY3PS3RBY1g8L6KiIPEbmg/ctFhmwCtphogjC0+ARG5sA32vc
        3bY+ZAtKE3w1qq5iV39xH1EQUOmvxbFB9SmDWbZgcCUJyYBqKlbVAEdJrKLgVrjn
        4d5h/7ptV4X5gtyTlgM1nD4daPdpKTrC0e0QLYcWDD46JDa1EiQdOa7oSt0kegVw
        Su0NX5JnG9N55lKxrpMM06+Ckt2cqebZldSOXhzANfnzj3Z8f+ge81pZ17oOy8mw
        ==
X-ME-Sender: <xms:CeDjYU2KFwqvtCeFsrhcZbt58vHegTzCRuxYA5vNNytZG5AqL6DT2g>
    <xme:CeDjYfEsOf9UvG_uRuab-OBUNpeKnlSdCKoQpP0o0DSF66wuZE4gRIvPIdZtdZHwB
    bwaOG0R1OXccYg>
X-ME-Received: <xmr:CeDjYc4ARW1Pgcz1M6LlqBdN7QGkEpYplwhfSYedkm4DzUYGQbyxFPrgRVkLxrOYY0dF2LxnFGWBD-ybxpMaxVmoIyt1lQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrtdekgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CuDjYd3X5StYpMOpeMD8EWSNqISq6v9IVASfVOmhny9X5WArVV0Vcw>
    <xmx:CuDjYXE7zRLFqs0LlUBaiQyh2KypEHjmzV-6o12wHHDHiSc8Edhf9Q>
    <xmx:CuDjYW9x3K-6akQGUtimimoigN_V6ngTO7NRm-XPhlAuCsp2tMdEDw>
    <xmx:CuDjYc4cYPW9EeBzLsGjAwEuSnvubgx1XqJIc_iFOfm_lGJX_A1y9g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Jan 2022 04:06:17 -0500 (EST)
Date:   Sun, 16 Jan 2022 11:06:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Laight <David.Laight@aculab.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock
 protection
Message-ID: <YePgBu5Wj/NHpt32@shredder>
References: <20220116090220.2378360-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220116090220.2378360-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 01:02:20AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In the past, free_fib_info() was supposed to be called
> under RTNL protection.
> 
> This eventually was no longer the case.
> 
> Instead of enforcing RTNL it seems we simply can
> move fib_info_cnt changes to occur when fib_info_lock
> is held.
> 
> v2: David Laight suggested to update fib_info_cnt
> only when an entry is added/deleted to/from the hash table,
> as fib_info_cnt is used to make sure hash table size
> is optimal.

[...]

> Fixes: 48bb9eb47b27 ("netdevsim: fib: Add dummy implementation for FIB offload")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Ido Schimmel <idosch@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
