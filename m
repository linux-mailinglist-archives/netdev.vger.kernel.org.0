Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C630E3F77DB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbhHYO5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhHYO5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 10:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE1E36101A;
        Wed, 25 Aug 2021 14:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629903417;
        bh=01RvTi53kWwY1p/XGYd00O30ciAQK3IhAd1LXE71E60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oFfdb4U5mywPCgNICrItDXIaTTfeOUT/9iCF9+8wnPGJgJY8rDuvBrqsc4cnqDn9W
         /aSjI4SDMDEbE+IA1Cm0NFBXCkH/c54WiRi06u7h8hSp9RjGjv36iOynTFN9gUgLr4
         LNloZKdzD0RvGxw7wLrV7wXq7NcsBu6g3fuK2zZG4ICXrf5eiQkN+fqcSAWql3QlXI
         H1w4isvmgNFknCpziUb+84UGVJg1TXy/7Og3Wubvo5wjhQiCWw5Vh6/BEEbPytP3V1
         1pfmXi5HiDukDgC8RQdq6MklKDqgLdlg1BaHlmyfyT+h3PsG/wcByoVtSKiXJgx8V4
         B94EGxTbRUG5w==
Date:   Wed, 25 Aug 2021 07:56:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 1/5] ethtool: add support to set/get tx spare
 buf size
Message-ID: <20210825075656.4db0890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629873655-51539-2-git-send-email-huangguangbin2@huawei.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
        <1629873655-51539-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 14:40:51 +0800 Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add support for ethtool to set/get tx spare buf size.
> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  include/uapi/linux/ethtool.h | 1 +
>  net/ethtool/ioctl.c          | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index b6db6590baf0..266e95e4fb33 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -231,6 +231,7 @@ enum tunable_id {
>  	ETHTOOL_RX_COPYBREAK,
>  	ETHTOOL_TX_COPYBREAK,
>  	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
> +	ETHTOOL_TX_COPYBREAK_BUF_SIZE,

We need good documentation for the new tunable.

>  	/*
>  	 * Add your fresh new tunable attribute above and remember to update
>  	 * tunable_strings[] in net/ethtool/common.c
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index f2abc3152888..9fc801298fde 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2377,6 +2377,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
>  	switch (tuna->id) {
>  	case ETHTOOL_RX_COPYBREAK:
>  	case ETHTOOL_TX_COPYBREAK:
> +	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
>  		if (tuna->len != sizeof(u32) ||
>  		    tuna->type_id != ETHTOOL_TUNABLE_U32)
>  			return -EINVAL;

