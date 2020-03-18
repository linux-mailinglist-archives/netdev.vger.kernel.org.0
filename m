Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F831896B1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgCRILI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgCRILI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BD93148783E5;
        Wed, 18 Mar 2020 01:11:07 -0700 (PDT)
Date:   Tue, 17 Mar 2020 22:40:30 -0700 (PDT)
Message-Id: <20200317.224030.840555474337698762.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH REPOST net-next] net: dsa: mv88e6xxx: fix vlan setup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jEB0y-0006iF-5g@rmk-PC.armlinux.org.uk>
References: <E1jEB0y-0006iF-5g@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 17 Mar 2020 12:08:08 +0000

> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Provide an option that drivers can set to indicate they want to receive
> vlan configuration even when vlan filtering is disabled. This is safe
> for Marvell DSA bridges, which do not look up ingress traffic in the
> VTU if the port is in 8021Q disabled state. Whether this change is
> suitable for all DSA bridges is not known.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> This patch depends on, and completes the changes previously merged in
> net-next in 2b99e54b30ed ("Merge branch 'VLANs-DSA-switches-and-multiple-bridges'")
> It has been delayed due to the lack of discussion concerning the
> naming of "vlan_bridge_vtu" which remains unresolved.

Looks like some alternative names have been suggested finally, please
repost with that change.

Thanks.
