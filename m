Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B125280B3F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbgJAXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJAXQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:16:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D78206C1;
        Thu,  1 Oct 2020 23:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601594160;
        bh=H+dcucJ4STU7LMOUgRY8nTpNgSIe4iv/bRK1KL1Ig5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e9QKeY//duY5x7epLGUHh7jvTjhk+E9Hy161W3LHuc2uwD+BQFGscaUMX3BIO1SVO
         sw6PnEGxff79AhAWiQsHF4X3xkdfrJsGKEY7E0QM64kIZ0go2IHn6UTj2QWWP8YJ+y
         q3FKTnSgOFfMU4UUTXdRD/AKSPMPWwneQj5kVdvE=
Date:   Thu, 1 Oct 2020 16:15:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shay Drory <shayd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net V2 01/15] net/mlx5: Don't allow health work when device is
 uninitialized
Message-ID: <20201001161558.1a095385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001195247.66636-2-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
        <20201001195247.66636-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 12:52:33 -0700 saeed@kernel.org wrote:
> From: Shay Drory <shayd@mellanox.com>
> 
> On error flow due to failure on driver load, driver can be
> un-initializing while a health work is running in the background,
> health work shouldn't be allowed at this point, as it needs resources to
> be initialized and there is no point to recover on driver load failures.
> 
> Therefore, introducing a new state bit to indicated if device is
> initialized, for health work to check before trying to recover the driver.

Can't you cancel this work? Or make sure it's not scheduled?
IMHO those "INITILIZED" bits are an anti-pattern.

> Fixes: b6e0b6bebe07 ("net/mlx5: Fix fatal error handling during device load")
> Signed-off-by: Shay Drory <shayd@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

You signed off twice :)

We should teach verify_signoff to catch that..
