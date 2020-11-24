Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834172C2E23
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390624AbgKXRMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390534AbgKXRMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 12:12:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AABA20715;
        Tue, 24 Nov 2020 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606237941;
        bh=A9kI0sXskid0dUQ+4tbWVmia8SQLYDJbB7Ex5MCCzzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MvLN/4KA5aLMPkVzKsrYg3EDhtuxHElHwE4Za16V3OubguwhQ3WJLo+k3eUAvWimx
         9wV6ExJSVtj7Rt92gY46rkHsPxEs21zL6QleiRwOj4fxzwMkAUzPSBxA+hBiUFm/6y
         n2SvLRjWzlMo9CufPzc7hz2O5xZWz2+HTTmr9y0U=
Date:   Tue, 24 Nov 2020 09:12:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
References: <20201120230339.651609-1-saeedm@nvidia.com>
        <20201120230339.651609-12-saeedm@nvidia.com>
        <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 08:41:58 +0200 Eli Cohen wrote:
> On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote:
> > On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:  
> > > From: Eli Cohen <eli@mellanox.com>
> > > 
> > > Add a new namespace type to the NIC RX root namespace to allow for
> > > inserting VDPA rules before regular NIC but after bypass, thus allowing
> > > DPDK to have precedence in packet processing.  
> > 
> > How does DPDK and VDPA relate in this context?  
> 
> mlx5 steering is hierarchical and defines precedence amongst namespaces.
> Up till now, the VDPA implementation would insert a rule into the
> MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus taking
> all the incoming traffic.
> 
> The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
> MLX5_FLOW_NAMESPACE_BYPASS.

Our policy was no DPDK driver bifurcation. There's no asterisk saying
"unless you pretend you need flow filters for RDMA, get them upstream
and then drop the act".

What do you expect me to do?
