Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715B02AE3EF
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgKJXVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:21:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJXVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:21:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16FC920781;
        Tue, 10 Nov 2020 23:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050481;
        bh=0rDoeudqKPtJBp8DtjiQhq8n6ZrK2pPbyfa4jEsjAmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cf7wfcKJMJRaZm0XbtUF6K0chci0z8n0lbusMrAhTm7XKPhZ/woGszacNVVpPWXmj
         OEEG9S90G4MGhYv4kJXB01YYSD1zd6v7Xmxr9SNceoDXQR6zkAvq2Td6nCviidu6zS
         IObhu13kwtwxw59xTX0dSzt8Ai++Zlkka9hDLojA=
Date:   Tue, 10 Nov 2020 15:21:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Vincent Bernat <vincent@bernat.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH net-next v2 2/3] net: evaluate
 net.ipv4.conf.all.proxy_arp_pvlan
Message-ID: <20201110152118.3636794d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107193515.1469030-3-vincent@bernat.ch>
References: <20201107193515.1469030-1-vincent@bernat.ch>
        <20201107193515.1469030-3-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 20:35:14 +0100 Vincent Bernat wrote:
> Introduced in 65324144b50b, the "proxy_arp_vlan" sysctl is a
> per-interface sysctl to tune proxy ARP support for private VLANs.
> While the "all" variant is exposed, it was a noop and never evaluated.
> We use the usual "or" logic for this kind of sysctls.
> 
> Fixes: 65324144b50b ("net: RFC3069, private VLAN proxy arp support")
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> ---
>  include/linux/inetdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

CC Jesper 

I know this is 10 year old code, but can we get an ack for applying
this to net-next?

> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index 3bbcddd22df8..53aa0343bf69 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -105,7 +105,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
>  
>  #define IN_DEV_LOG_MARTIANS(in_dev)	IN_DEV_ORCONF((in_dev), LOG_MARTIANS)
>  #define IN_DEV_PROXY_ARP(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP)
> -#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_CONF_GET(in_dev, PROXY_ARP_PVLAN)
> +#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP_PVLAN)
>  #define IN_DEV_SHARED_MEDIA(in_dev)	IN_DEV_ORCONF((in_dev), SHARED_MEDIA)
>  #define IN_DEV_TX_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), SEND_REDIRECTS)
>  #define IN_DEV_SEC_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), \

