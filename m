Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A346D5619AA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiF3Lzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiF3Lzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:55:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F02851B0B;
        Thu, 30 Jun 2022 04:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC04BB8291F;
        Thu, 30 Jun 2022 11:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB89DC34115;
        Thu, 30 Jun 2022 11:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656590139;
        bh=vPWuxNJBYkbc1W6dGQfHh61XCux8abgMoO29pSWCpvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rYpTALMGXAsA1FSYl6IYBoxGshd/GXdcap7vYa/Nm5AvIK+pUKU28KjldQniSuxGp
         Ilp64ntmKO/8npn097lw9U7BlskdyjSLsF9y62t7kLD5RXBC4O9Kt94vTHFfbQa3N3
         LFiWB8gr/vlF9ilRict3dRwSxQVCT2lF95+Kob/g=
Date:   Thu, 30 Jun 2022 13:55:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        masterzorag <masterzorag@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH 5.15 2/2] rtw88: rtw8821c: enable rfe 6 devices
Message-ID: <Yr2POPOQ7fYi08CL@kroah.com>
References: <20220630114621.19688-1-tangmeng@uniontech.com>
 <20220630114621.19688-2-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630114621.19688-2-tangmeng@uniontech.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_BTC_ID,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 07:46:21PM +0800, Meng Tang wrote:
> commit e109e3617e5d563b431a52e6e2f07f0fc65a93ae upstream.
> 
> Ping-Ke Shih answered[1] a question for a user about an rtl8821ce device that
> reported RFE 6, which the driver did not support. Ping-Ke suggested a possible
> fix, but the user never reported back.
> 
> A second user discovered the above thread and tested the proposed fix.
> Accordingly, I am pushing this change, even though I am not the author.
> 
> [1] https://lore.kernel.org/linux-wireless/3f5e2f6eac344316b5dd518ebfea2f95@realtek.com/
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Reported-and-tested-by: masterzorag <masterzorag@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>
> Link: https://lore.kernel.org/r/20220107024739.20967-1-Larry.Finger@lwfinger.net
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> index 746f6f8967d8..897da3ed2f02 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> @@ -1513,6 +1513,7 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
>  	[0] = RTW_DEF_RFE(8821c, 0, 0),
>  	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
>  	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +	[6] = RTW_DEF_RFE(8821c, 0, 0),
>  };
>  
>  static struct rtw_hw_reg rtw8821c_dig[] = {
> -- 
> 2.20.1
> 
> 
> 

Both now queued up, thanks.

greg k-h
