Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CB02A70E7
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732449AbgKDXBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgKDXBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 18:01:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02BC9204EF;
        Wed,  4 Nov 2020 23:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604530878;
        bh=LR7Oa9z0ZI2Kv7jNobevpVpXQl8zHQk2JTzbbYfcOFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8qvvUckwKSSrT2mBYr3Yycnu4HTBBSMxbOcjmpRHOoa0i/U8HbpmvAo8phRAc1NW
         dGIHCEK9fG9ra43jdmGvCgaK4fSbI16thZ7Bc00cJohIVP1EgFw5nmeEshIsgHC6EP
         xcy2v3xahoSVJovDZbmN+1kfhareEw2OKcho2x4I=
Date:   Wed, 4 Nov 2020 15:01:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Jianbo Liu" <jianbol@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [net 6/9] net/mlx5e: E-Switch, Offload all chain 0 priorities
 when modify header and forward action is not supported
Message-ID: <20201104150117.1f139777@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103191830.60151-7-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
        <20201103191830.60151-7-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 11:18:27 -0800 Saeed Mahameed wrote:
> From: Jianbo Liu <jianbol@mellanox.com>
> 
> Miss path handling of tc multi chain filters (i.e. filters that are
> defined on chain > 0) requires the hardware to communicate to the
> driver the last chain that was processed. This is possible only when
> the hardware is capable of performing the combination of modify header
> and forward to table actions. Currently, if the hardware is missing
> this capability then the driver only offloads rules that are defined
> on tc chain 0 prio 1. However, this restriction can be relaxed because
> packets that miss from chain 0 are processed through all the
> priorities by tc software.
> 
> Allow the offload of all the supported priorities for chain 0 even
> when the hardware is not capable to perform modify header and goto
> table actions.
> 
> Fixes: 0b3a8b6b5340 ("net/mlx5: E-Switch: Fix using fwd and modify when firmware doesn't support it")
> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Sounds like a feature TBH.
