Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25FB22FEAB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgG1A6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG1A6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 20:58:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F156820809;
        Tue, 28 Jul 2020 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595897924;
        bh=3yAu5O3paSd/QeeodRmlsjC6aicSe9poTbKk3ohlPLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XEaX6DK+yDFqqA4Gc97FtWLhCpZKoubmE0xncy0IrwFQFpg3q68xbPV70GF5KKRbL
         m/8nwJ3GQV1EKmFgFrvQqhST7kVO3IMzEcYo/PRuHHaYkggn3AVnFzIc1nEDaui/cd
         LtXQHeQz9VMAL4yt3KOwqrXliAebzleycNddSX0M=
Date:   Mon, 27 Jul 2020 17:58:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC 02/13] devlink: Add reload levels data to
 dev get
Message-ID: <20200727175842.42d35ee3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595847753-2234-3-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 14:02:22 +0300 Moshe Shemesh wrote:
> Expose devlink reload supported levels and driver's default level to the
> user through devlink dev get command.
> 
> Examples:
> $ devlink dev show
> pci/0000:82:00.0:
>   reload_levels_info:
>     default_level driver
>     supported_levels:
>       driver fw_reset fw_live_patch
> pci/0000:82:00.1:
>   reload_levels_info:
>     default_level driver
>     supported_levels:
>       driver fw_reset fw_live_patch
> 
> $ devlink dev show -jp
> {
>     "dev": {
>         "pci/0000:82:00.0": {
>             "reload_levels_info": {
>                 "default_level": "driver",
>                 "supported_levels": [ "driver","fw_reset","fw_live_patch" ]
>             }
>         },
>         "pci/0000:82:00.1": {
>             "reload_levels_info": {
>                 "default_level": "driver",
>                 "supported_levels": [ "driver","fw_reset","fw_live_patch" ]
>             }
>         }
>     }
> }
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

The fact that the driver supports fw_live_patch, does not necessarily
mean that the currently running FW can be live upgraded to the
currently flashed one, right? 

This interface does not appear to be optimal for the purpose.

Again, documentation of what can be lost (in terms of configuration and
features) upon upgrade is missing.
