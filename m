Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02CA21F3B0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgGNOQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:16:18 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6915 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgGNOQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:16:17 -0400
X-IronPort-AV: E=Sophos;i="5.75,350,1589234400"; 
   d="scan'208";a="459696777"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 16:16:15 +0200
Date:   Tue, 14 Jul 2020 16:16:15 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Suraj Upadhyay <usuraj35@gmail.com>
cc:     davem@davemloft.net, kuba@kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] decnet: dn_dev: Remove an unnecessary label.
In-Reply-To: <20200714141309.GA3184@blackclown>
Message-ID: <alpine.DEB.2.22.394.2007141615490.2355@hadrien>
References: <20200714141309.GA3184@blackclown>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 14 Jul 2020, Suraj Upadhyay wrote:

> Remove the unnecessary label from dn_dev_ioctl() and make its error
> handling simpler to read.
>
> Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> ---
>  net/decnet/dn_dev.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
> index 65abcf1b3210..64901bb9f314 100644
> --- a/net/decnet/dn_dev.c
> +++ b/net/decnet/dn_dev.c
> @@ -462,7 +462,9 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
>  	switch (cmd) {
>  	case SIOCGIFADDR:
>  		*((__le16 *)sdn->sdn_nodeaddr) = ifa->ifa_local;
> -		goto rarok;
> +		if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
> +			ret = -EFAULT;
> +			break;

The indentation on break does not look correct.

julia

>
>  	case SIOCSIFADDR:
>  		if (!ifa) {
> @@ -485,10 +487,6 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
>  	rtnl_unlock();
>
>  	return ret;
> -rarok:
> -	if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
> -		ret = -EFAULT;
> -	goto done;
>  }
>
>  struct net_device *dn_dev_get_default(void)
> --
> 2.17.1
>
>
