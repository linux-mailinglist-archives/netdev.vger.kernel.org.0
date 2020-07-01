Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5035211669
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgGAW4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGAW4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:56:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D837F207E8;
        Wed,  1 Jul 2020 22:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593644183;
        bh=T6ekkhn+iF9x8o48xN/TLMGKd4e1Ev+jySO+peOLlag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bO/YQu9JAewubvLfPACE4jql1VyrpU5o4QesvK7Mo68sn3FcCnPWngBzr8GeYcqsP
         2tcz2RQz8eja0nWFVzrBeUYE0XZCbIpI9ov3W9KuKFBnOpz+1tc8qJeQNo5N2xhzfk
         hnKmRiIF77IGHf5mbsnZdt+3ZheOUyKjtGLSC1cI=
Date:   Wed, 1 Jul 2020 15:56:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 03/10] net: ethtool: netlink: Add support
 for triggering a cable test
Message-ID: <20200701155621.2b6ea9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510191240.413699-5-andrew@lunn.ch>
References: <20200510191240.413699-1-andrew@lunn.ch>
        <20200510191240.413699-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 21:12:33 +0200 Andrew Lunn wrote:
> diff --git a/net/Kconfig b/net/Kconfig
> index c5ba2d180c43..5c524c6ee75d 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -455,6 +455,7 @@ config FAILOVER
>  config ETHTOOL_NETLINK
>  	bool "Netlink interface for ethtool"
>  	default y
> +	depends on PHYLIB=y || PHYLIB=n
>  	help
>  	  An alternative userspace interface for ethtool based on generic
>  	  netlink. It provides better extensibility and some new features,

Since ETHTOOL_NETLINK is a bool we end up not enabling it on
allmodconfig builds, (PHYLIB=m so ETHTOOL_NETLINK dependency 
can't be met) - which is v scary for build testing.

Is there a way we can change this dependency? Some REACHABLE shenanigans?

Or since there are just two callbacks maybe phylib can "tell" ethtool
core the pointers to call when it loads?
