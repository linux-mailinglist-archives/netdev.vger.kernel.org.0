Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BC027F2F8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgI3UHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:07:01 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:40813 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3UHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:07:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 4308BED5;
        Wed, 30 Sep 2020 16:06:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 30 Sep 2020 16:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6/QNCe
        k+qf3qboJuylnkPSWPFM2M0K6i7LJTlRF0tN4=; b=i52Lk0jeeQ+EmRyAXnouFN
        rzGg9auBXOGc1gqtm0jYxtAV0Vx+WCp7TE7XAjRckdmyvT4qt78F0ldXAnH/OaxI
        +HVjEDrwlMET/owbDXQ2iZBk1LsTu171wDdvoc7JAbsqFntmvBt6clM38leIlArb
        DiM37HFgFbwM1Iw97+VY/bhFBSoxxw3uOTeRtk5YQDBdHD9ERAeYl80sLcvRSIu+
        MZ1k8xqRoVUYESLKfScUjjVT9UwCJbVahmFDjNYHgm1tV+oX7Eh694d5aMkxJyWP
        +iMPl3tOX2A8kmVjs2zYLf0oxRJ5UdmK4roLEpxR+aUJJEPteysZh0Ki2otR35NQ
        ==
X-ME-Sender: <xms:YeV0Xw6r9pSxcAk2t7kVI3ij5xpzxNjaiIiiSYNzYMLc9PJ6H4YdMA>
    <xme:YeV0Xx6Fkyclo-hp7FTe3JvMjjOhH8NCmYITFnmR_MteMDIzoBoXFTMbr199UVVh9
    XLYHLBZPh1IeXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgddugedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefjedrudegkeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YeV0X_f5cBa9CeDNwksCUE1aNmfnHVMAkloT8ZcYVwxRpuJo0civiQ>
    <xmx:YeV0X1LERfXcpjgziGRUd3XGgKQ8wQhb3M-ME7Tll1JidpR5yXWb9g>
    <xmx:YeV0X0IH8nCgEKslzN1DQsxi0HOLAm731TUOcYSl89d1KOtDaYxbuQ>
    <xmx:YuV0X9qSgLdSToPYO8h_1ujOPPoXRKdBuj50kogik9ePMCQAxKAqjJERh7c>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 026323280060;
        Wed, 30 Sep 2020 16:06:56 -0400 (EDT)
Date:   Wed, 30 Sep 2020 23:06:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, ayal@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930200653.GC1850258@shredder>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
 <20200930072529.GA1788067@shredder>
 <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:59:17AM +0200, Michal Kubecek wrote:
> How about this compromise? Let's introduce a "legacy" flag which would
> allow "ethtool -s <dev> autoneg on" do what it used to do while we would
> not taint the kernel-userspace API with this special case so that
> ETHTOOL_MSG_LINKMODES_SET request with only ETHTOOL_A_LINKMODES_AUTONEG
> (but no other attributes like _SPEED or _DUPLEX) would leave advertised
> link modes untouched unless the "legacy" flag is set. If the "legacy"
> flag is set in the request, such request would set advertised modes to
> all supported.

Sorry for the delay, busy with other obligations. Regarding the "legacy"
flag suggestion, do you mean that the ethtool user space utility will
always set it in ETHTOOL_MSG_LINKMODES_SET request in order to maintain
backward compatibility with the ioctl interface?

Thanks for spending time on this issue.
