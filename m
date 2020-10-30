Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E952A09D4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgJ3P1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgJ3P1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:27:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003CEC0613CF;
        Fri, 30 Oct 2020 08:27:42 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 133so5589749pfx.11;
        Fri, 30 Oct 2020 08:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=cerH7A6E9c/e7WcTUbUIVWqeE/Rr/7wvJ+hfwZcTH2M=;
        b=vU48EE9gtfxsPSE1qCZVWuji8LUolC0C0N3wjAgbFuG2MkTpF0cVc7AtiitxPCETOF
         1Z+Lt1XUjUPmZS/+LNdgVdDoYSUtbjzVeh1+gydIBgOKfd3ZRmXd3hvDgkOPGNdYl+Mv
         AlLhs7VlOcwtFohsSCdvOJ+P9S86UV1Ky8my2UhjjCUAp5bdgFMBPLQZ1L4eVUtHSxX3
         J+2SsbX0u1JHtWO8+jFYaazhzWHO9B1Zl6ogbXwmXATYwmz35VBRwj3j7IlA09DKM795
         w56PxDOkjqSE8dmYpm27EUSmwUzLh7Dz7/3AABLDxyvfz6mBebUB4gD+b/u3+wPVdLuz
         fukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cerH7A6E9c/e7WcTUbUIVWqeE/Rr/7wvJ+hfwZcTH2M=;
        b=EopTPaZZmqmhd2g2+YduZ44k3prEkyYph9uKZ36vIBvC1DAdH2eTzZLv9AOGsqk5rP
         w38F5zhuze25MvUeFrMHo9tcjs2OQsx5FW4gSLXq3WtR3tmaky2OYsDwCVN0zPRJQb+D
         EwOy+BkT8IVVZmTqC51cCTAXV/1BYzZX5HfNETe9LdDxookeIVZUhVYJAUZRNlawyBWj
         gkDBPzMMJyWUXBDIbxnh8YTijbb/VYu1mlRwBMhLthkW9sm0Uq7jXky3srMo2df1iKkR
         9eH5cIyu7tZiuDhoUUgBSLDyGk4TlqS8Txr5tz23OAGChWrclXsI/Fp9ktg6rHqD2Cuo
         qsiw==
X-Gm-Message-State: AOAM531Fvrlvv2KAHvt/2045xZVKkj9gZ0Ze3utPeGiUvIp10Xc4IkBQ
        yGPwz7KEK46zZfFdEEMimOI=
X-Google-Smtp-Source: ABdhPJwT1P1hFDAuzcrR9sqdQhfD+6b3w88a5fVOPwka4NSUniKB1T7kBqWnKLP7kLK39qyXiDRCeA==
X-Received: by 2002:a65:6158:: with SMTP id o24mr2757919pgv.120.1604071662384;
        Fri, 30 Oct 2020 08:27:42 -0700 (PDT)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id b4sm6404480pfi.208.2020.10.30.08.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:27:41 -0700 (PDT)
Message-ID: <8c56efa5420eb4211b1af789ef63931d3504d8e1.camel@gmail.com>
Subject: Re: [RFC PATCH] mwifiex: pcie: use shutdown_sw()/reinit_sw() on
 suspend/resume
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Sat, 31 Oct 2020 00:27:36 +0900
In-Reply-To: <20201028142719.18765-1-kitakar@gmail.com>
References: <20201028142719.18765-1-kitakar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-28 at 23:27 +0900, Tsuchiya Yuto wrote:
> On Microsoft Surface devices (PCIe-88W8897), there are issues with S0ix
> achievement and AP scanning after suspend with the current Host Sleep
> method.
>
> When using the Host Sleep method, it prevents the platform to reach S0ix
> during suspend. Also, sometimes AP scanning won't work, resulting in
> non-working wifi after suspend.
>
> To fix such issues, perform shutdown_sw()/reinit_sw() instead of Host
> Sleep on suspend/resume.
>
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> ---
> As a side effect, this patch disables wakeups (means that Wake-On-WLAN
> can't be used anymore, if it was working before), and might also reset
> some internal states.
>
> Of course it's the best to rather fix Host Sleep itself. But if it's
> difficult, I'm afraid we have to go this way.
>
> I reused the contents of suspend()/resume() functions as much as possible,
> and removed only the parts that are incompatible or redundant with
> shutdown_sw()/reinit_sw().
>
> - Removed wait_for_completion() as redundant
>   mwifiex_shutdown_sw() does this.
> - Removed flush_workqueue() as incompatible
>   Causes kernel crashing.
> - Removed mwifiex_enable_wake()/mwifiex_disable_wake()
>   as incompatible and redundant because the driver will be shut down
>   instead of entering Host Sleep.
>
> I'm worried about why flush_workqueue() causes kernel crash with this
> suspend method. Is it OK to just drop it? At least We Microsoft Surface
> devices users used this method for about one month and haven't observed
> any issues.
>
> Note that suspend() no longer checks if it's already suspended.
> With the previous Host Sleep method, the check was done by looking at
> adapter->hs_activated in mwifiex_enable_hs() [sta_ioctl.c], but not
> MWIFIEX_IS_SUSPENDED. So, what the previous method checked was instead
> Host Sleep state, not suspend itself.
>
> Therefore, there is no need to check the suspend state now.
> Also removed comment for suspend state check at top of suspend()
> accordingly.

This patch depends on the following mwifiex_shutdown_sw() fix I sent
separately.

[PATCH 1/2] mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
https://lore.kernel.org/linux-wireless/20201028142110.18144-2-kitakar@gmail.com/

>  drivers/net/wireless/marvell/mwifiex/pcie.c | 29 +++++++--------------
>  1 file changed, 10 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 6a10ff0377a24..3b5c614def2f5 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -293,8 +293,7 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
>   * registered functions must have drivers with suspend and resume
>   * methods. Failing that the kernel simply removes the whole card.
>   *
> - * If already not suspended, this function allocates and sends a host
> - * sleep activate request to the firmware and turns off the traffic.
> + * This function shuts down the adapter.
>   */
>  static int mwifiex_pcie_suspend(struct device *dev)
>  {
> @@ -302,31 +301,21 @@ static int mwifiex_pcie_suspend(struct device *dev)
>  	struct pcie_service_card *card = dev_get_drvdata(dev);
>  
>  
> -	/* Might still be loading firmware */
> -	wait_for_completion(&card->fw_done);
> -
>  	adapter = card->adapter;
>  	if (!adapter) {
>  		dev_err(dev, "adapter is not valid\n");
>  		return 0;
>  	}
>  
> -	mwifiex_enable_wake(adapter);
> -
> -	/* Enable the Host Sleep */
> -	if (!mwifiex_enable_hs(adapter)) {
> +	/* Shut down SW */
> +	if (mwifiex_shutdown_sw(adapter)) {
>  		mwifiex_dbg(adapter, ERROR,
>  			    "cmd: failed to suspend\n");
> -		clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
> -		mwifiex_disable_wake(adapter);
>  		return -EFAULT;
>  	}
>  
> -	flush_workqueue(adapter->workqueue);
> -
>  	/* Indicate device suspended */
>  	set_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
> -	clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
>  
>  	return 0;
>  }
> @@ -336,13 +325,13 @@ static int mwifiex_pcie_suspend(struct device *dev)
>   * registered functions must have drivers with suspend and resume
>   * methods. Failing that the kernel simply removes the whole card.
>   *
> - * If already not resumed, this function turns on the traffic and
> - * sends a host sleep cancel request to the firmware.
> + * If already not resumed, this function reinits the adapter.
>   */
>  static int mwifiex_pcie_resume(struct device *dev)
>  {
>  	struct mwifiex_adapter *adapter;
>  	struct pcie_service_card *card = dev_get_drvdata(dev);
> +	int ret;
>  
>  
>  	if (!card->adapter) {
> @@ -360,9 +349,11 @@ static int mwifiex_pcie_resume(struct device *dev)
>  
>  	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
>  
> -	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
> -			  MWIFIEX_ASYNC_CMD);
> -	mwifiex_disable_wake(adapter);
> +	ret = mwifiex_reinit_sw(adapter);
> +	if (ret)
> +		dev_err(dev, "reinit failed: %d\n", ret);
> +	else
> +		mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
>  
>  	return 0;
>  }


