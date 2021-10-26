Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60A43B50F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhJZPIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231447AbhJZPIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 905D8604AC;
        Tue, 26 Oct 2021 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635260736;
        bh=BvqYX+7GjgSKbWqekRU5mv66eEPOcTi4Yn543r+A7w8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OAbzf2DOHf+c6k5P90p5gHXQ1L8QWwsUQf6FfccCZyFYWjQDhMZD/xKlP/vB+G33W
         KdM2MyEJIyUpYN3k7/YArpvc4/+gveTwnXXi3KPXIQ+99UkXe7ZzTOWxkvX2d7qU6j
         BDc9Yw8+1qhsBjH8OhJYmNokZfUlv3RaIGA2u/CIeIWI177Qz0ZbkVmx405OCSMx3E
         i49mEgWM2Hcy5NSu9NZV0IKW9n7vyGLL9JfNIsH5Mow40PqezcWXeX0aSaZRk3xbBl
         7z3RiqVS6Q+vYMPExoLGy+ngElfst0/hEYSbyQ3IqRy2dPXUQQYwExD8CWHXYzlnku
         dEMUzfPU3XPMg==
Date:   Tue, 26 Oct 2021 08:05:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Message-ID: <20211026080535.1793e18c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025205431.365080-11-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
        <20211025205431.365080-11-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 13:54:27 -0700 Saeed Mahameed wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Currently, each I/O EQ is taking 128KB of memory. This size
> is not needed in all use cases, and is critical with large scale.
> Hence, allow user to configure the size of I/O EQs.
> 
> For example, to reduce I/O EQ size to 64, execute:
> $ devlink resource set pci/0000:00:0b.0 path /io_eq_size/ size 64
> $ devlink dev reload pci/0000:00:0b.0

This sort of config is needed by more drivers,
we need a standard way of configuring this.

Sorry, I didn't have the time to look thru your patches
yesterday, I'm sending a revert for all your new devlink
params.
