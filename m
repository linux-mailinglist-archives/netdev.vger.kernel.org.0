Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EFF4D2731
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiCIC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 21:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiCIC6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 21:58:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA280122222
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 18:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=jQ9RONz9O8FC2hQrWwhrjkxhFQM7KNfAJCVMAKs1IKE=; b=YHLojdO9EMtUa5+WxaiRiFgdkc
        gCCQiyo1Xqa1hIZkxZh01In4lbVSHaJKDi5zF/b/m/VGNwtBFIV948rS+UbyvfsVD8n4ku0OlBjrZ
        yz+RDfpoMroEENw8+4FFEtQEJOTpe3/w2PInXMZoZAufB1Hd6FZXCxUBdqYngKJIjnl49l3x3LW3L
        cgYTE/ryTRl1jBZOxUO6Kpfw0Vs8I0GsYQ2YWCKwGp/jy954PW2J5pEeWj+LR685a0/24dTRzgij1
        hV2SvGn4jsFYWioxyohqn5vQA2D6qoBc+y3NzUbZ3l+osu/VsmpTBe8aA/W2GsZrxuNgqqt5z9Ojy
        VozH1b1A==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRmVg-00Gcqq-8S; Wed, 09 Mar 2022 02:57:08 +0000
Message-ID: <7ec5946d-a400-b3d9-3ec4-0200aac785f3@infradead.org>
Date:   Tue, 8 Mar 2022 18:57:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2] net/fungible: CONFIG_FUN_CORE needs SBITMAP
Content-Language: en-US
To:     Dimitris Michailidis <d.michailidis@fungible.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20220308081234.3517-1-dmichail@fungible.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220308081234.3517-1-dmichail@fungible.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/22 00:12, Dimitris Michailidis wrote:
> fun_core.ko uses sbitmaps and needs to select SBITMAP.
> Fixes below errors:
> 
> ERROR: modpost: "__sbitmap_queue_get"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_finish_wait"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_clear"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_prepare_to_wait"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_init_node"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_wake_all"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> 
> v2: correct "Fixes" SHA
> 
> Fixes: 749efb1e6d73 ("net/fungible: Kconfig, Makefiles, and MAINTAINERS")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  drivers/net/ethernet/fungible/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/fungible/Kconfig b/drivers/net/ethernet/fungible/Kconfig
> index 2ff5138d0448..1ecedecc0f6c 100644
> --- a/drivers/net/ethernet/fungible/Kconfig
> +++ b/drivers/net/ethernet/fungible/Kconfig
> @@ -18,6 +18,7 @@ if NET_VENDOR_FUNGIBLE
>  
>  config FUN_CORE
>  	tristate
> +	select SBITMAP
>  	help
>  	  A service module offering basic common services to Fungible
>  	  device drivers.

-- 
~Randy
