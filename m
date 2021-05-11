Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3937AE94
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhEKSiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhEKSiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 14:38:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE47C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 11:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=XndQ+T+f0pBAzvowmJCGafDYlfQgKlSbPmzDSOTnijY=; b=MAl+Gh22xTokllBVZMiDv0StUQ
        uu8BXFGe/sQSpNhWY9Gx60688kdBJYiFnDXL1pM2MkiAuz5pTMYItuk7aUF7wEAHZGlrw+P6RgSKN
        FrxhVmKp7k1LBJQvi9POMUU0fpBApYtred060gPnEmLDIczjFJwXVXMn9/tJEayRbOyh2mSS7pDEm
        U1e7V/s69dDzMKG5BP68Bi70YDoV4pngVd+G220ax8q4oMIVd4DOhtxjpE9xeJIanHTJOKlWKpaAO
        GEeTGoHY7DNcEW4/+7orlyT5XwqX04l3Vpa2KSz6yWO3hU2wKF+sooC54sc9/gzs4cgVxcZO42l8x
        VqsbY9uw==;
Received: from [2601:1c0:6280:3f0:d7c4:8ab4:31d7:f0ba]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgXFa-009qZz-0m; Tue, 11 May 2021 18:36:58 +0000
Subject: Re: [PATCH v4 net] ionic: fix ptp support config breakage
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210511181132.25851-1-snelson@pensando.io>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <83bbecd2-086c-47c2-d62d-3312004fff4d@infradead.org>
Date:   Tue, 11 May 2021 11:36:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511181132.25851-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/21 11:11 AM, Shannon Nelson wrote:
> When IONIC=y and PTP_1588_CLOCK=m were set in the .config file
> the driver link failed with undefined references.
> 
> We add the dependancy
> 	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
> to clear this up.
> 
> If PTP_1588_CLOCK=m, the depends limits IONIC to =m (or disabled).
> If PTP_1588_CLOCK is disabled, IONIC can be any of y/m/n.
> 
> Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Allen Hubbe <allenbh@pensando.io>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> 
> v4 - Jakub's rewrite
> v3 - put version notes below ---, added Allen's Cc
> v2 - added Fixes tag
> ---
>  drivers/net/ethernet/pensando/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
> index 5f8b0bb3af6e..202973a82712 100644
> --- a/drivers/net/ethernet/pensando/Kconfig
> +++ b/drivers/net/ethernet/pensando/Kconfig
> @@ -20,6 +20,7 @@ if NET_VENDOR_PENSANDO
>  config IONIC
>  	tristate "Pensando Ethernet IONIC Support"
>  	depends on 64BIT && PCI
> +	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	select NET_DEVLINK
>  	select DIMLIB
>  	help
> 


-- 
~Randy

