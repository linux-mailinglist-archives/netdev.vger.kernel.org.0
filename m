Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC79721166B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgGAXAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGAXAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 19:00:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E7AC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 16:00:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 094D01190C146;
        Wed,  1 Jul 2020 16:00:15 -0700 (PDT)
Date:   Wed, 01 Jul 2020 16:00:14 -0700 (PDT)
Message-Id: <20200701.160014.637327748926165441.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, cphealy@gmail.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next v4 03/10] net: ethtool: netlink: Add support
 for triggering a cable test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701155621.2b6ea9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200510191240.413699-1-andrew@lunn.ch>
        <20200510191240.413699-5-andrew@lunn.ch>
        <20200701155621.2b6ea9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 16:00:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 1 Jul 2020 15:56:21 -0700

> On Sun, 10 May 2020 21:12:33 +0200 Andrew Lunn wrote:
>> diff --git a/net/Kconfig b/net/Kconfig
>> index c5ba2d180c43..5c524c6ee75d 100644
>> --- a/net/Kconfig
>> +++ b/net/Kconfig
>> @@ -455,6 +455,7 @@ config FAILOVER
>>  config ETHTOOL_NETLINK
>>  	bool "Netlink interface for ethtool"
>>  	default y
>> +	depends on PHYLIB=y || PHYLIB=n
>>  	help
>>  	  An alternative userspace interface for ethtool based on generic
>>  	  netlink. It provides better extensibility and some new features,
> 
> Since ETHTOOL_NETLINK is a bool we end up not enabling it on
> allmodconfig builds, (PHYLIB=m so ETHTOOL_NETLINK dependency 
> can't be met) - which is v scary for build testing.
> 
> Is there a way we can change this dependency? Some REACHABLE shenanigans?
> 
> Or since there are just two callbacks maybe phylib can "tell" ethtool
> core the pointers to call when it loads?

This has been discussed a few times and it's very irritating to me as well
as allmodconfig is the standard test build I do for all new changes.
