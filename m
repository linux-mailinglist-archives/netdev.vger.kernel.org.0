Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A136ECC5
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 01:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732985AbfGSXgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 19:36:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35761 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732936AbfGSXgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 19:36:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so14822579pfn.2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 16:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=adPQzI1v5diG916E3ftdRP7KVUpoq7ni2PbSErONVno=;
        b=G3cOINU5IIalyfSzoeJGzYHjbbTayjz7uKTmRzNWMjmloTNLmboShFlXotMdaNFDe8
         LAdBksnVHUYSUdjAjmD3cROKn41n3SKUCER9oghvqyO+rKroqQj7uNodSK+RT3bUNB1S
         DXoVHjQtNrBXRF4FRkraXhiN3WesLyTqJ7RQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=adPQzI1v5diG916E3ftdRP7KVUpoq7ni2PbSErONVno=;
        b=AzG8likF4tAinCfYzqpXGJMR+i8nHvJuk6ZSKCYnxUoC45kXXMlBcs55FhCv9ARFwI
         mc2X+8jI6iCCKp754l+G8Gt7CQN9O59icJqC6axcI3KxKDj4HXarAQn4+16r1kCq+ixM
         ffNGQfs6vu+G3X486N7vtMV9Q1+szYiPEYwp75bgH97QkazKOk+ztZ4n7HpGL9zGcyE3
         D6Yt1vwNobtNZ0XkgBr20/Re/T+B7xfreSbBXSroDLHWLhF7K1WpiuDAyOmFq/58yZLf
         gTmXeJsTvMDD09+IoK1ry4cJnyCsINbRSdCKfOhx0YyO4mbfgvv/a/GQDhJULPamC8i2
         WDSA==
X-Gm-Message-State: APjAAAUABMV7ol5yh/5tubHj84hxxjy7VVyTck1EfpiS9vCFTmgH+m4n
        ETro52D9XR6qqnw7Qo2ypA8m9A==
X-Google-Smtp-Source: APXvYqxbqPCgcMawQkjn4LpCVpIZIiiIhPeZYJ2X7r56FNvFvPhSCu3KoIIFPtYjLuP6gyd08GrXzQ==
X-Received: by 2002:a63:e54f:: with SMTP id z15mr56615815pgj.4.1563579371281;
        Fri, 19 Jul 2019 16:36:11 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id a21sm38313759pfi.27.2019.07.19.16.36.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 16:36:09 -0700 (PDT)
Date:   Fri, 19 Jul 2019 16:36:06 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-mmc@vger.kernel.org, davem@davemloft.net,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, Andreas Fenkart <afenkart@gmail.com>
Subject: Re: [PATCH 2/2] mwifiex: Make use of the new sdio_trigger_replug()
 API to reset
Message-ID: <20190719233605.GA66171@google.com>
References: <20190716164209.62320-1-dianders@chromium.org>
 <20190716164209.62320-3-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716164209.62320-3-dianders@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug,

On Tue, Jul 16, 2019 at 09:42:09AM -0700, Doug Anderson wrote:
> As described in the patch ("mmc: core: Add sdio_trigger_replug()
> API"), the current mwifiex_sdio_card_reset() is broken in the cases
> where we're running Bluetooth on a second SDIO func on the same card
> as WiFi.  The problem goes away if we just use the
> sdio_trigger_replug() API call.

I'm unfortunately not a good evaluator of SDIO/MMC stuff, so I'll mostly
leave that to others and assume that the "replug" description is pretty
much all I need to know.

> NOTE: Even though with this new solution there is less of a reason to
> do our work from a workqueue (the unplug / plug mechanism we're using
> is possible for a human to perform at any time so the stack is
> supposed to handle it without it needing to be called from a special
> context), we still need a workqueue because the Marvell reset function
> could called from a context where sleeping is invalid and thus we
> can't claim the host.  One example is Marvell's wakeup_timer_fn().
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> 
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 24c041dad9f6..f77ad2615f08 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -2218,14 +2218,6 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
>  {
>  	struct sdio_mmc_card *card = adapter->card;
>  	struct sdio_func *func = card->func;
> -	int ret;
> -
> -	mwifiex_shutdown_sw(adapter);

I'm very mildly unhappy to see this driver diverge from the PCIe one
again, but the only way it makes sense to do things the same is if there
is such thing as a "function level reset" for SDIO (i.e., doesn't also
kill the Bluetooth function). But it appears we don't really have such a
thing.

> -
> -	/* power cycle the adapter */
> -	sdio_claim_host(func);
> -	mmc_hw_reset(func->card->host);
> -	sdio_release_host(func);
>  
>  	/* Previous save_adapter won't be valid after this. We will cancel

^^^ FTR, the "save_adapter" note was already obsolete as of

  cc75c577806a mwifiex: get rid of global save_adapter and sdio_work

but the clear_bit() calls were (before this patch) still useful for
other reasons.

>  	 * pending work requests.
> @@ -2233,9 +2225,9 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
>  	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
>  	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);

But now, I don't think you need these clear_bit() calls any more --
you're totally destroying the card and its workqueue on remove(). (And
anyway, MWIFIEX_IFACE_WORK_CARD_RESET was just cleared by your caller.)

>  
> -	ret = mwifiex_reinit_sw(adapter);
> -	if (ret)
> -		dev_err(&func->dev, "reinit failed: %d\n", ret);
> +	sdio_claim_host(func);
> +	sdio_trigger_replug(func);
> +	sdio_release_host(func);

And...we're approximately back to where we were 4 years ago :)

commit b4336a282db86b298b70563f8ed51782b36b772c
Author: Andreas Fenkart <afenkart@gmail.com>
Date:   Thu Jul 16 18:50:01 2015 +0200

    mwifiex: sdio: reset adapter using mmc_hw_reset

Anyway, assuming the "function reset" thing isn't workable, and you drop
the clear_bit() stuff, I think this is fine:

Reviewed-by: Brian Norris <briannorris@chromium.org>

>  }
>  
>  /* This function read/write firmware */
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
