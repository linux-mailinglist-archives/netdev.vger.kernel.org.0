Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9242A37A5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKCATp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgKCATp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:19:45 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1042225E;
        Tue,  3 Nov 2020 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604362784;
        bh=rLRezgozMo36bMQEdpj1d95Jvx+If6mlRaMG5lcBdrs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MbvkXAq0VUXFsJuj2ZnX3LnowoI1qdCl/SgPBttkyxSaq4tckfVjdJVL1M41GarSN
         vmkquE8NaEmjduVpMqy3/P6P3NU/G5T5EYfBw154R86gBXSzSKUFmEyW/tZ0sG75DF
         wzIuIV2kQzVd3re/LNYLmrx8CWw9OLaXcYZGonAw=
Date:   Mon, 2 Nov 2020 16:19:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] ethernet: igb: e1000_phy: Check for
 ops.force_speed_duplex existence
Message-ID: <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102231307.13021-3-pmenzel@molgen.mpg.de>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
        <20201102231307.13021-3-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 00:13:07 +0100 Paul Menzel wrote:
> From: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
> 
> The ops field might no be defined, so add a check.

This change should be first, otherwise AFAIU if someone builds the
kernel in between the commits (e.g. for bisection) it will crash.

> The patch is taken from Open Network Linux (ONL), and it was added there
> as part of the patch
> 
>     packages/base/any/kernels/3.16+deb8/patches/driver-support-intel-igb-bcm5461X-phy.patch
> 
> in ONL commit f32316c63c (Support the BCM54616 and BCM5461S.) [1]. Part
> of this commit was already upstreamed in Linux commit eeb0149660 (igb:
> support BCM54616 PHY) in 2017.
> 
> I applied the forward-ported
> 
>     packages/base/any/kernels/5.4-lts/patches/0002-driver-support-intel-igb-bcm5461S-phy.patch
> 
> added in ONL commit 5ace6bcdb3 (Add 5.4 LTS kernel build.) [2].
> 
> [1]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/f32316c63ce3a64de125b7429115c6d45e942bd1
> [2]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/5ace6bcdb37cb8065dcd1d4404b3dcb6424f6331

No need to put this in every commit message.

We preserve the cover letter in tree as a merge commit message, so
explaining things once in the cover letter is sufficient.

> Cc: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>

Jefferey will need to provide a sign-off as the author.

> Cc: John W Linville <linville@tuxdriver.com>
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
