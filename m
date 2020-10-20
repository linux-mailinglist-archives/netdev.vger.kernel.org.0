Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7138429329C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 03:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbgJTBH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 21:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389793AbgJTBH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 21:07:57 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BEAC0613CE;
        Mon, 19 Oct 2020 18:07:57 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so481585ior.2;
        Mon, 19 Oct 2020 18:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=p6oCxSl0NxHBGpRF0Csh1Ota/+f24EPc/qZsIIjTsdU=;
        b=mU393MiUidI9lhYo7eRWYGH4kcEYs2KhAe5eGHziG6lNNA+UgmdmNSorh4u2iBcqzR
         Q5cEbqS8JEFlKs79WKpq2wSp5UdONcPw6WMXA6KEwNPe6aEddElxw2wMmGA8rea5Qcn1
         opc5cTGw311OWXelQ/A6z5jvuZfJDf9qxgqE3p+dm65DZRFQxK6Y+pArEusIeg/LNcjZ
         Kj1EraDBaZfV+RAaa4yrgh85cX9wAHWyrk5OHDK4Qx7J5xwNw8VlCVnIAJEKJ4NSCvWy
         7qhb2lkMsA7XnBQVmzResc546/eZL0e+83Pc1UVLboD4RUc4svsQPnaNWsILGdVMlrIO
         KmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=p6oCxSl0NxHBGpRF0Csh1Ota/+f24EPc/qZsIIjTsdU=;
        b=paEmZPGOBhKOZLZKdaXGkQ9msnHpQp4ZNiN59dwLkEDDHOGdAGkLrJIiNtheUsXLRq
         /TA88zsuO8B+v5Zyp54/1ZwJbQVhtd+Bw6ZyTsSDhrO8J1N/oP5DETagHiOd1/QarpIB
         f2zEw94wdh5sf9wLYKrU8BtojdXM/LTnRWBazl0OTkWLzSa4mPaXBxiM9XnZwfOAMXmE
         +w9QM7qPgX1GEVfLfal70kNaK8Pip1VLOeom7cFdPzCaZWRIXze6++2GJhqJygmVUBmw
         bkZOIXLPmaorrLtbLPNa56YM5c3+BHDC0Hvv5VdYP7HvwICQSAkCT60uwQnqMZvMRsgv
         bt/A==
X-Gm-Message-State: AOAM532RSvzt2In1xlK0j8K6vhv+nSRLe1BPnc3yJ8Q1U7qKvHbfFUwS
        cHmK7XeNRFlk6E0HI9/eYa0=
X-Google-Smtp-Source: ABdhPJw/gkp/YEp4mC5SU0UwrWcYSOqWSCeVCgimt0fr9KxWgSWFEoh2ANrwgq/8HwL7RR03j8xUSg==
X-Received: by 2002:a02:3b54:: with SMTP id i20mr354726jaf.94.1603156077138;
        Mon, 19 Oct 2020 18:07:57 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45d1:2600::3])
        by smtp.gmail.com with ESMTPSA id 80sm313059ilv.13.2020.10.19.18.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 18:07:56 -0700 (PDT)
Date:   Mon, 19 Oct 2020 18:07:54 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] staging: wfx: fix use of uninitialized pointer
Message-ID: <20201020010754.GB1817488@ubuntu-m3-large-x86>
References: <20201019160604.1609180-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201019160604.1609180-1-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 06:06:03PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> With -Wuninitialized, the compiler complains:
> 
> drivers/staging/wfx/data_tx.c:34:19: warning: variable 'band' is uninitialized when used here [-Wuninitialized]
>     if (rate->idx >= band->n_bitrates) {
>                          ^~~~
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Fixes: 868fd970e187 ("staging: wfx: improve robustness of wfx_get_hw_rate()")
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/staging/wfx/data_tx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
> index 41f6a604a697..36b36ef39d05 100644
> --- a/drivers/staging/wfx/data_tx.c
> +++ b/drivers/staging/wfx/data_tx.c
> @@ -31,13 +31,13 @@ static int wfx_get_hw_rate(struct wfx_dev *wdev,
>  		}
>  		return rate->idx + 14;
>  	}
> -	if (rate->idx >= band->n_bitrates) {
> -		WARN(1, "wrong rate->idx value: %d", rate->idx);
> -		return -1;
> -	}
>  	// WFx only support 2GHz, else band information should be retrieved
>  	// from ieee80211_tx_info
>  	band = wdev->hw->wiphy->bands[NL80211_BAND_2GHZ];
> +	if (rate->idx >= band->n_bitrates) {
> +		WARN(1, "wrong rate->idx value: %d", rate->idx);
> +		return -1;
> +	}
>  	return band->bitrates[rate->idx].hw_value;
>  }
>  
> -- 
> 2.28.0
> 
