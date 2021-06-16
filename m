Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EBC3A9E88
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhFPPHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234397AbhFPPHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 11:07:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A016115C;
        Wed, 16 Jun 2021 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623855947;
        bh=T89VH1+HKVD7NSHxavAH3LMsQLINFiajbWGG7dgcOQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oa9T4Eant5cAxWfTsOsiXH3eMLX3XcDDgAufhlRfXEz/eQv/2dZa3O6glknbpAo5X
         ih3Is5FjII8ge87AgZtUQRdqSgtzZFJQfkn7Nc8s+UvvuKNxcN0jRAyA1gxRZbzOYp
         5OynPbKeIJDhkUFPPoaJKttoWBLzKyRFLsKtEdQM=
Date:   Wed, 16 Jun 2021 17:05:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linyu Yuan <linyyuan@codeaurora.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: cdc_eem: fix tx fixup skb leak
Message-ID: <YMoTSAHnSpmpen6l@kroah.com>
References: <20210616144044.20693-1-linyyuan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616144044.20693-1-linyyuan@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:40:44PM +0800, Linyu Yuan wrote:
> when usbnet transmit a skb, eem fixup it in eem_tx_fixup(),
> if skb_copy_expand() failed, it return NULL,
> usbnet_start_xmit() will have no chance to free original skb.
> 
> fix it by free orginal skb in eem_tx_fixup() first,
> then check skb clone status, if failed, return NULL to usbnet.
> 
> Signed-off-by: Linyu Yuan <linyyuan@codeaurora.org>
> ---
>  drivers/net/usb/cdc_eem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What commit does this "Fix:"?  Can you please add that to the
signed-off-by area?

thanks,

greg k-h
