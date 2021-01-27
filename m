Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA919306849
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhA0XuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231265AbhA0XuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:50:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3124264DD2;
        Wed, 27 Jan 2021 23:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611791375;
        bh=uBnY7nmVp5ae1WCAyiVQYnxspEEFqiw2bmuZqgmuyQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WBQVpj5Z+QYetLMFlw32NrzfKUjNk26dW+vJbg7CeNQ7++2dwaMLLUvvijE6kVuGa
         zohsJeS9XcRtRM0sEnJY6xa/pDeiwsHGJxAKrGCZgel4Fy3GxxlJSLGq5etQhd9XsA
         gp0rru+GobxTeOYMO/fsJNAUv7UYbCMPvtVKNJnX1znFxTCvrNLu4lWzR3BzDnBUlz
         LzFtZLqMrfs04IgLb6AUUEwsnHcAb5Fg3FuPewUX3p63pFvdaueCGb/ZVb8X+ZtuS8
         bcYM4vMQg2dU0qrQoa8T+SX9e3kYufdx+yTNCl+Ndbkn9sGfo/a6AKG5P8d0Od+0ev
         kDCR6Mc+pwbsw==
Date:   Wed, 27 Jan 2021 15:49:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, saeedm@nvidia.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210127154934.2afbadda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127101648.513562-1-cmi@nvidia.com>
References: <20210127101648.513562-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 18:16:48 +0800 Chris Mi wrote:
> @@ -35,4 +45,21 @@ static inline void psample_sample_packet(struct psample_group *group,
>  
>  #endif
>  
> +static void

static inline

> +psample_nic_sample_packet(struct psample_group *group,
> +			  struct sk_buff *skb, u32 trunc_size,
> +			  int in_ifindex, int out_ifindex,
> +			  u32 sample_rate)
> +{
> +	const struct psample_ops *ops;
> +
> +	rcu_read_lock();
> +	ops = rcu_dereference(psample_ops);
> +	if (ops)
> +		ops->sample_packet(group, skb, trunc_size,
> +				   in_ifindex, out_ifindex,
> +				   sample_rate);
> +	rcu_read_unlock();
> +}
