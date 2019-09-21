Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3EDB9DBC
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 13:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437795AbfIUL7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 07:59:09 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:59266 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405761AbfIUL7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 07:59:09 -0400
Received: from localhost.localdomain (p200300E9D742D2CA2F74A2557F82CAC1.dip0.t-ipconnect.de [IPv6:2003:e9:d742:d2ca:2f74:a255:7f82:cac1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id ED2B6C18BE;
        Sat, 21 Sep 2019 13:59:06 +0200 (CEST)
Subject: Re: [PATCH 4/5] ieee802154: enforce CAP_NET_RAW for raw sockets
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, orinimron123@gmail.com
References: <20190920073549.517481-1-gregkh@linuxfoundation.org>
 <20190920073549.517481-5-gregkh@linuxfoundation.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <5c100446-037a-cdc2-5491-fd10385a98fd@datenfreihafen.org>
Date:   Sat, 21 Sep 2019 13:58:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920073549.517481-5-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 20.09.19 09:35, Greg Kroah-Hartman wrote:
> From: Ori Nimron <orinimron123@gmail.com>
> 
> When creating a raw AF_IEEE802154 socket, CAP_NET_RAW needs to be
> checked first.
> 
> Signed-off-by: Ori Nimron <orinimron123@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/ieee802154/socket.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index badc5cfe4dc6..d93d4531aa9b 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -1008,6 +1008,9 @@ static int ieee802154_create(struct net *net, struct socket *sock,
>  
>  	switch (sock->type) {
>  	case SOCK_RAW:
> +		rc = -EPERM;
> +		if (!capable(CAP_NET_RAW))
> +			goto out;
>  		proto = &ieee802154_raw_prot;
>  		ops = &ieee802154_raw_ops;
>  		break;
> 

I assume this will go as a whole series into net. If you want me to pick
it up into my tree directly let me know.

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
