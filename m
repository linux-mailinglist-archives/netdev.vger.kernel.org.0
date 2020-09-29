Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9CF27D2DE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgI2Pfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgI2Pfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:35:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBF9C0613D1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:35:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q123so4930826pfb.0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8ouYvJ11GUvmankQF/7U1i7ZXcYaX9D7igBLN8Zdxa0=;
        b=ffnUz12QPqQ8+EYUCJcWTxFgtMCk6BAB2P/mlYZkUvgK+FzAyWNxmcRAbeHCC5z2gN
         dfdt2xo3DhM7bBaZkq55I6jeJLlTUCSMc9SRyy4IpvYNnCwYy9Al85AwN58Tfyov/XZf
         ynqooyn5OcM5BLGpCpyAszVY80XccZDTZfWOuDvb0GNFeoAWgwxSYZoCfDKc1G96aFeU
         voXfJw2xJP96BJFtOqCNujgz5zfdugKGJzehxI+YzikdJQRGFKEy+8D5gtE+Bn42t4b6
         t9kPkm+DfvFEhOsy2fA+jbEY7jMjBfNQqM7Lo1KoekasKBbJYq2xMprKxvqGWweDb9Ss
         f67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8ouYvJ11GUvmankQF/7U1i7ZXcYaX9D7igBLN8Zdxa0=;
        b=WLX6t1ra6bbtwJCrpdZssJKMBDzO+uEnYrgw5C+Q2BuwWVDgkXFo3qc+DNMZO9EY29
         LZVJr2HFp95lDXNl7EQTRei7Ed4Rzur1QBpR0wDlgmM4QQc00jB8PC+DQQtUQCGLw2h0
         +KMLIG07MxI01OcPweYE6T5er+kFuKtEuzc6No5J2upmZsib4B9Ke+eZqlMAT8nqEZH7
         kbv0rQKJWJcTw7coFdrwCbbkMHrkdWesC39r6g1Lx04gCk9urp0VNrezxjT4Xs2wsVRp
         GMKPRPZACUq6b5DZ31eFFfaD1J5NU8+ZjrHCwGbrRTCn4fuisr4bBlMzZvSdB2lXtKO4
         QKEQ==
X-Gm-Message-State: AOAM533M3Yxkz5d15ctiB7OBHFMFrzewQtHIfkLvUJQW/xxjRjTnXA2F
        33kbY9SMSG4kLf+Bl3g9bONV
X-Google-Smtp-Source: ABdhPJzqZEBdNDpZI0r75IgOozmaEa/xnQcX3rbHKgba8WbhAS9a5Yr3tOG2O/1frtQUWERSV2rP+A==
X-Received: by 2002:a63:5d58:: with SMTP id o24mr1674695pgm.115.1601393738619;
        Tue, 29 Sep 2020 08:35:38 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id gb19sm5029947pjb.38.2020.09.29.08.35.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 08:35:38 -0700 (PDT)
Date:   Tue, 29 Sep 2020 21:05:31 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath11k@lists.infradead.org
Subject: Re: linux-next: build failure after merge of the mhi tree
Message-ID: <20200929153531.GB17845@Mani-XPS-13-9360>
References: <20200928184230.2d973291@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928184230.2d973291@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 28, 2020 at 06:42:30PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the mhi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/wireless/ath/ath11k/mhi.c:27:4: error: 'struct mhi_channel_config' has no member named 'auto_start'
>    27 |   .auto_start = false,
>       |    ^~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mhi.c:42:4: error: 'struct mhi_channel_config' has no member named 'auto_start'
>    42 |   .auto_start = false,
>       |    ^~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mhi.c:57:4: error: 'struct mhi_channel_config' has no member named 'auto_start'
>    57 |   .auto_start = true,
>       |    ^~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mhi.c:72:4: error: 'struct mhi_channel_config' has no member named 'auto_start'
>    72 |   .auto_start = true,
>       |    ^~~~~~~~~~
> 
> Caused by commit
> 
>   ed39d7816885 ("bus: mhi: Remove auto-start option")
> 

After having the discussion with Kalle, we decided to drop these offending
patches from mhi-next (reason is net-next will be broken without these patches).
So we'll deal with this in next merge window.

Thanks,
Mani

> interacting with commit
> 
>   1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
> 
> from the net-next tree.
> 
> I applied the following merge fix patch, but maybe more is required.
> Even if so, this could be fixed now in the net-next tree.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 28 Sep 2020 18:39:41 +1000
> Subject: [PATCH] fix up for "ath11k: register MHI controller device for QCA6390"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/ath/ath11k/mhi.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index aded9a719d51..47a1ce1bee4f 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -24,7 +24,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
>  		.offload_channel = false,
>  		.doorbell_mode_switch = false,
>  		.auto_queue = false,
> -		.auto_start = false,
>  	},
>  	{
>  		.num = 1,
> @@ -39,7 +38,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
>  		.offload_channel = false,
>  		.doorbell_mode_switch = false,
>  		.auto_queue = false,
> -		.auto_start = false,
>  	},
>  	{
>  		.num = 20,
> @@ -54,7 +52,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
>  		.offload_channel = false,
>  		.doorbell_mode_switch = false,
>  		.auto_queue = false,
> -		.auto_start = true,
>  	},
>  	{
>  		.num = 21,
> @@ -69,7 +66,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
>  		.offload_channel = false,
>  		.doorbell_mode_switch = false,
>  		.auto_queue = true,
> -		.auto_start = true,
>  	},
>  };
>  
> -- 
> 2.28.0
> 
> -- 
> Cheers,
> Stephen Rothwell


