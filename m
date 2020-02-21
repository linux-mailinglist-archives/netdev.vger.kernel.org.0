Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9080E166C36
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 02:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgBUBRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 20:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbgBUBRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 20:17:17 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0175206E2;
        Fri, 21 Feb 2020 01:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582247837;
        bh=B8mOKtFcqhWLKhEYl/BUPLYNUvoelaAXi6ga+Ze5FzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N2UiOVVegb8UfCA5/+QnF6nynbWIH4xPYPajS4ylfmvr8RkgvJfpp/Z0OEgiT0Ls9
         j1GEiCKL1iqKPgjGOYFp/rEhDMs8eHcxkTn3ryypG6qXTX9RK/UTbbUtEfYI4im5SB
         wzg3lNAafYzXdJcpLBsfeysL4hCcU93ynEBkJu1k=
Date:   Thu, 20 Feb 2020 17:17:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 00/16] Clean driver, module and FW versions
Message-ID: <20200220171714.60a70238@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 16:58:39 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This is first patchset to netdev (already sent RDMA [1] and arch/um)
> in attempt to unify the version management for in-tree kernel code.
> The patches follow already accepted ethtool change [2] to set as
> a default linux kernel version.
> 
> It allows us to remove driver version and present to the users unified
> picture of driver version, which is similar to default MODULE_VERSION().

Thanks for doing this! The patches look good to me.

A few minor nit picks I registered, IDK how hard we want to press 
on these:

 - it seems in couple places you remove the last user of DRV_RELDATE,
   but not the define. In case of bonding maybe we can remove the date
   too. IDK what value it brings in the description, other than perhaps
   humoring people;
 - we should probably give people a heads up by CCing maintainers
   (regardless of how dumb we find not bothering to read the ML as
   a maintainer);
 - one on the FW below..

> As part of this series, I deleted various creative attempts to mark
> absence of FW. There is no need to set "N/A" in ethtool ->fw_version
> field and it is enough to do not set it.

These seem reasonable to me, although in abundance of caution it could
be a good idea to have them as separate commits so we can revert more
easily. Worse come to worst.

> 1.
> The code is compile tested and passes 0-day kbuild.
> 2.
> The proposed changes are based on commit:
>   2bb07f4e1d86 ("tc-testing: updated tdc tests for basic filter")
> 3.
> WIP branch is [3].
> 
> [1] https://lore.kernel.org/linux-rdma/20200220071239.231800-1-leon@kernel.org/
> [2] https://lore.kernel.org/linux-rdma/20200127072028.19123-1-leon@kernel.org/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=ethtool
