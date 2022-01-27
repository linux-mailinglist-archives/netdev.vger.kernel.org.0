Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C2049E476
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbiA0OTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:19:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237608AbiA0OTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 09:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cjKh8nU6Ws/EwFeJ4a3+ZytHvgkO0kh4RAs39+WpTkM=; b=bZm/yb+dks+bRU1iCSRMOtWtrM
        E2mrRnyO4iBJ2SCCXt3v1ME9bQ5N4MNfRNuYDEFFmvjKf+aNbOaaKtVHdURgiL6P5wxuhbmuY3kxq
        3mFrciXX+SH1rVc3ERWDh3+DamsCvotBp7NyJN09QcJwg5o17JTPnBLh5j3lT+JHcsLA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nD5cZ-002zus-NN; Thu, 27 Jan 2022 15:19:31 +0100
Date:   Thu, 27 Jan 2022 15:19:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     Mario.Limonciello@amd.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Message-ID: <YfKp81yJWd95Jrg7@lunn.ch>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127100109.12979-1-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 06:01:09PM +0800, Aaron Ma wrote:
> RTL8153-BL is used in Lenovo Thunderbolt4 dock.
> Add the support of MAC passthrough.
> This is ported from Realtek Outbox driver r8152.53.56-2.15.0.
> 
> There are 2 kinds of rules for MAC passthrough of Lenovo products,
> 1st USB vendor ID belongs to Lenovo, 2nd the chip of RTL8153-BL
> is dedicated for Lenovo. Check the ocp data first then set ACPI object
> names.
> 
> Suggested-by: Hayes Wang <hayeswang@realtek.com>
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 44 ++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index ee41088c5251..df997b330ee4 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -718,6 +718,7 @@ enum spd_duplex {
>  #define AD_MASK			0xfee0
>  #define BND_MASK		0x0004
>  #define BD_MASK			0x0001
> +#define BL_MASK                 BIT(3)

Just to be sure, this is defined by Realtek? This is not just Lenovo
just misusing a reserved bit?

     Andrew
