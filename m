Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50903326A8B
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBZX4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:56:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhBZX4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:56:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0915564F03;
        Fri, 26 Feb 2021 23:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383764;
        bh=iR7P4SkzF3nPAWbmhMR3Rouj0JoAcmY+IsCNgsX8Q7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R9XM8gwB/2ioo1+337SymgNfGCc8ag7eVpSJqEqmA6gYtfPscZ4nYrKLe1guTcnpt
         dK5i/qufglzx3OBajMkfjXqkf0yHP3QplrvBwheZeCKqWh1I4/CCylfn+kVyWyoSv0
         y+xQf/OnwjEkygQ3BipOkUGGBygSwGXGtV3waCyyxAOJneRNRPW0Qt6KNCGLPwYVYd
         8ebacs7YNOwTqDw3FvO4MUG3Y2sV70iG3yHJPUv3kUmYWvMgVqaZK633CWQ1A6z1dE
         PFKLxE0J4OrTDXcQeKNtiq7+KCZ0OdMA4vpgJWlQJph85M8lkTItbH322/wkUYISob
         FI60rIm0jt1ow==
Date:   Fri, 26 Feb 2021 15:56:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net] net: phy: fix save wrong speed and duplex problem
 if autoneg is on
Message-ID: <20210226155603.6a1cda0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1614325482-25208-1-git-send-email-tanhuazhong@huawei.com>
References: <1614325482-25208-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 15:44:42 +0800 Huazhong Tan wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> If phy uses generic driver and autoneg is on, enter command
> "ethtool -s eth0 speed 50" will not change phy speed actually, but
> command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
> has been set to 50 and no update later.
> 
> And duplex setting has same problem too.
> 
> However, if autoneg is on, phy only changes speed and duplex according to
> phydev->advertising, but not phydev->speed and phydev->duplex. So in this
> case, phydev->speed and phydev->duplex don't need to be set in function
> phy_ethtool_ksettings_set() if autoneg is on.

Can we get a Fixes tag for this one? How far back does this behavior
date?
