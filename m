Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020EC43CE14
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbhJ0P5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242859AbhJ0P5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F34610A3;
        Wed, 27 Oct 2021 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635350129;
        bh=mXFBOgkp6zrMVhxpacqPdiJRh/NH/mFYzuUwo4gK7D8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HWhCWVfmES7cvHsXB5s/k/LyyWI1942reYECwdyAdhPR1kKaekLsxc+kmzLbJiCOP
         pUMZKCqtqC9Ta/IuWYRtXpb31E2tcZ7veC7rzqroFsDqeKXVjyWpMient8InF4B7Ix
         Y2VNqzgDF1ICTa+TmIAg56hP2ZLzQAVlBCxEsHQ7gSNBQMoePgzS1N2nVkUbwm+8bn
         dTxsaF7UbMJu8zk+YyRtaqaHuTkGWWVP52yQJn1qcFxfsAPIib9vqYtDa8JgdU5f1b
         5GV0Hprhv56Q3V4pLWeb88XJ6VFlWKSH/Eli2o3jsiZ1w/Ybaaix+/GDDI5DZxIow6
         L8IgzGBVs+dCA==
Date:   Wed, 27 Oct 2021 08:55:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] virtio-net: enable virtio indirect cache
Message-ID: <20211027085528.01c4b313@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211027061913.76276-4-xuanzhuo@linux.alibaba.com>
References: <20211027061913.76276-1-xuanzhuo@linux.alibaba.com>
        <20211027061913.76276-4-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 14:19:13 +0800 Xuan Zhuo wrote:
> +static bool virtio_desc_cache = true;
>  module_param(csum, bool, 0444);
>  module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
> +module_param(virtio_desc_cache, bool, 0644);

Can this be an ethtool priv flag? module params are discouraged because
they can't be controlled per-netdev.
