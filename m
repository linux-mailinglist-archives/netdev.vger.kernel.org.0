Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4CC4553EC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242309AbhKREwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:52:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhKREwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:52:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B96B261AA9;
        Thu, 18 Nov 2021 04:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637210971;
        bh=lJFDHSsqV7NCzkdnIJxwt/k0k5Wl7IKnURedtNP2mk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pu2qkk6pB6Xi/MEgV5z1b0MFzM9PXUOVhe7uzpX+lGdF0JM4lyDHFkfnRYVngqsdd
         NB7Z4bQhBe2h6TF29ktVNnIwjK/Vf8XEOFETMTQL8bGmMEpfT1h2O/HNC1o1T3dubw
         gFsQbyyTAQb47Kt+9Z5xtKIhL92zVwvGEa1rUcWXB0g2ELDbrAZftg3lnXsfuybC5A
         F7IjkQe0YOfucXA7NQnAlW4VyOwbo9Oww6ruuQprWMB3b3FyQ1YVUlfwO1+/BcxxFX
         VbB7cx6lOp5TRGE7HJFp9snGgX4pZ89X13GFGFraVQs2Zxv19jvV1jxqYIAbjTKyCo
         aWYBPCH9Xrwfg==
Date:   Wed, 17 Nov 2021 20:49:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 4/6] devlink: Clean registration of devlink
 port
Message-ID: <20211117204929.4bd24597@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9c3eb77a90a2be10d5c637981a8047160845f60f.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
        <9c3eb77a90a2be10d5c637981a8047160845f60f.1637173517.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 20:26:20 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> devlink_port_register() is in-kernel API and as such can't really fail
> as long as driver author didn't make a mistake by providing already existing
> port index. Instead of relying on various error prints from the driver,
> convert the existence check to be WARN_ON(), so such a mistake will be
> caught easier.
> 
> As an outcome of this conversion, it was made clear that this function
> should be void and devlink->lock was intended to protect addition to
> port_list.

Leave this error checking in please.
