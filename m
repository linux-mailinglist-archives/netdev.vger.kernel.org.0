Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64232702A2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIRQxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgIRQxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 12:53:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8142220848;
        Fri, 18 Sep 2020 16:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600448032;
        bh=jt99wjCTrwNvm6t176XkQ+cxOSHpk5BHFp5VFlM+c9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aSNP7o2tpohkepOFv9FbcQXoHeMxktcc772WpCwvfjqIdBwhGyfvaqWpFaWq1giq9
         pYC7e89LEa5KqRp1YYw6a2TQjZP4BfQVIY4FZIWv3LggbOE3XVBntghCafyHCe1Lru
         AY/Kug30CwoNaXbIoklhGqbqzlAZK2WckLYTR+jU=
Date:   Fri, 18 Sep 2020 09:53:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v6 1/5] devlink: check flash_update parameter support
 in net core
Message-ID: <20200918095350.346c018b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918004529.533989-2-jacob.e.keller@intel.com>
References: <20200918004529.533989-1-jacob.e.keller@intel.com>
        <20200918004529.533989-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 17:45:25 -0700 Jacob Keller wrote:
> When implementing .flash_update, drivers which do not support
> per-component update are manually checking the component parameter to
> verify that it is NULL. Without this check, the driver might accept an
> update request with a component specified even though it will not honor
> such a request.
> 
> Instead of having each driver check this, move the logic into
> net/core/devlink.c, and use a new `supported_flash_update_params` field
> in the devlink_ops. Drivers which will support per-component update must
> now specify this by setting DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT in
> the supported_flash_update_params in their devlink_ops.
> 
> This helps ensure that drivers do not forget to check for a NULL
> component if they do not support per-component update. This also enables
> a slightly better error message by enabling the core stack to set the
> netlink bad attribute message to indicate precisely the unsupported
> attribute in the message.
> 
> Going forward, any new additional parameter to flash update will require
> a bit in the supported_flash_update_params bitfield.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
