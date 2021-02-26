Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46158326A62
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZX3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZX3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:29:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF53564E83;
        Fri, 26 Feb 2021 23:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614382118;
        bh=F85BR5ebR/OVGgfjKHekNtFpBCED1iHf4z/2Foe9GLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=afIFfBBxldu0ODKf70IZZEFPdiRzTXXBNJ5ZD9C1eZ4R7UvTRMWtTCABnGxQivEG9
         oT3O8Vyceb9NjndQiEC0dOFEnAlryv3V3osJSkYoLstbZLpe8mWdDT6mUxZigQ0G42
         v/3hrhf/MdFyuta3b1s+v14DKLq+RVpgSaWx/kNJeDKYe2EexeY6R6hmKpwPfaP1Wl
         JbqGWvH+k/npI6ggkMQe4j5bvFv9IPb2sSuYKH+CD5U+PUvtNnrMOrZvNtrTUdJ909
         whlfwfCiipP+0dFxMmu/dHzTI0e7aL+9eoZFvwfGFS3vMnB2OnfqAFsAv+z5CEbhDd
         GbJoF6CYtmXaQ==
Date:   Fri, 26 Feb 2021 15:28:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?UTF-8?B?QmzDtmNobA==?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225121835.3864036-6-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
        <20210225121835.3864036-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 14:18:34 +0200 Vladimir Oltean wrote:
> Quoting from the blamed commit:
> 
>     In promiscuous mode, it is more intuitive that all traffic is received,
>     including VLAN tagged traffic. It appears that it is necessary to set
>     the flag in PSIPVMR for that to be the case, so VLAN promiscuous mode is
>     also temporarily enabled. On exit from promiscuous mode, the setting
>     made by ethtool is restored.
> 
> Intuitive or not, there isn't any definition issued by a standards body
> which says that promiscuity has anything to do with VLAN filtering - it
> only has to do with accepting packets regardless of destination MAC address.
> 
> In fact people are already trying to use this misunderstanding/bug of
> the enetc driver as a justification to transform promiscuity into
> something it never was about: accepting every packet (maybe that would
> be the "rx-all" netdev feature?):
> https://lore.kernel.org/netdev/20201110153958.ci5ekor3o2ekg3ky@ipetronik.com/
> 
> So we should avoid that and delete the bogus logic in enetc.

I don't understand what you're fixing tho.

Are we trying to establish vlan-filter-on as the expected behavior?
