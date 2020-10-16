Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F82028FC4A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 03:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390135AbgJPBui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 21:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388885AbgJPBui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 21:50:38 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0CEC061755;
        Thu, 15 Oct 2020 18:50:38 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n6so1763391ioc.12;
        Thu, 15 Oct 2020 18:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Lnz+3X498d+Pw84uYesLONlxmmcjlWUIkyxJu0l46jM=;
        b=rm2viusRTPBp0TJU8pgk7dKrwSZHWURw3hbfsPPeR3W1h1/UsXUEwl1ioBQI2hRXd5
         c+MohwMXmt+BxSgwzF7ygp+LFqAeVmopFAnrtD2hC99SzOgk93txz/QDDWzixmHAiYex
         yg0pxm1zvDUy6H+HTvQcDRFnwDWirlfuAUEEUlgCv7BpcO11TnNbcC6MsW6JjiDtQGCe
         9F70JUoWqvtzUAv6ztft/mNvBHokjZsYMnllOqdn+P6eM9CEMk9sPtrumniDcjOUFVLr
         qMp1+PMhFjR0XPP17eX3ddc24kmOY/CfbICHLgqVSsWO5CG1oqTDd4O07mx2XeSYKhT5
         CK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Lnz+3X498d+Pw84uYesLONlxmmcjlWUIkyxJu0l46jM=;
        b=m7kPTSr3yf/IqxzvOpLKMLF8BoNcOW0IDBsLddSj8jHrG0DfJb1cddCvvjYvDDqAWF
         8uTegt9xwzgWonrnOd0qsaFDt3qIM3X2jatJAoewkxhN2MYQDL9Zg1wve0o2gzb8GFxn
         t/fQ2233xV8HlDoDzfpcvjR6EAQMnO0uPPwxi+vAkLMcZAIKuzZD3a40p6+i8I1ppsev
         yEhtoCBpY+VEWBHjeXsVgXFWb6EqZcjjWUoxmoHo9Jp6TAue3ZsqclS1p08SXGGFVwYA
         ul3rqQZKLrHwz82W4t+SXeWOzqw/LmLtHy0feDJTL5Kuow83xH7AxhYuyvf4S9MvOY80
         sU4g==
X-Gm-Message-State: AOAM532sT9gMXZrBibfHzaEURDu3hQjkKrt3yuRwfOqkEgW1/3mpwFP/
        mp0vlGQkK3hZthbcgza1v0w=
X-Google-Smtp-Source: ABdhPJw58WzznEotpeyXbMPb7MnVHRD71RKnqhwSc4tdNfgdfsbrRRLZ/GSpcwJWk/nqYlTFXz2iEA==
X-Received: by 2002:a6b:9243:: with SMTP id u64mr711338iod.197.1602813037247;
        Thu, 15 Oct 2020 18:50:37 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45d1:2600::3])
        by smtp.gmail.com with ESMTPSA id s17sm793793ioa.38.2020.10.15.18.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 18:50:36 -0700 (PDT)
Date:   Thu, 15 Oct 2020 18:50:34 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 8/8] staging: wfx: improve robustness of wfx_get_hw_rate()
Message-ID: <20201016015034.GA2122229@ubuntu-m3-large-x86>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
 <20201009171307.864608-9-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201009171307.864608-9-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 07:13:07PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Smatch complains:
> 
>     data_tx.c:37 wfx_get_hw_rate() warn: constraint '(struct ieee80211_supported_band)->bitrates' overflow 'band->bitrates' 0 <= abs_rl '0-127' user_rl '' required = '(struct ieee80211_supported_band)->n_bitrates'
>     23          struct ieee80211_supported_band *band;
>     24
>     25          if (rate->idx < 0)
>     26                  return -1;
>     27          if (rate->flags & IEEE80211_TX_RC_MCS) {
>     28                  if (rate->idx > 7) {
>     29                          WARN(1, "wrong rate->idx value: %d", rate->idx);
>     30                          return -1;
>     31                  }
>     32                  return rate->idx + 14;
>     33          }
>     34          // WFx only support 2GHz, else band information should be retrieved
>     35          // from ieee80211_tx_info
>     36          band = wdev->hw->wiphy->bands[NL80211_BAND_2GHZ];
>     37          return band->bitrates[rate->idx].hw_value;
> 
> Add a simple check to make Smatch happy.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/data_tx.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
> index 8db0be08daf8..41f6a604a697 100644
> --- a/drivers/staging/wfx/data_tx.c
> +++ b/drivers/staging/wfx/data_tx.c
> @@ -31,6 +31,10 @@ static int wfx_get_hw_rate(struct wfx_dev *wdev,
>  		}
>  		return rate->idx + 14;
>  	}
> +	if (rate->idx >= band->n_bitrates) {
> +		WARN(1, "wrong rate->idx value: %d", rate->idx);
> +		return -1;
> +	}
>  	// WFx only support 2GHz, else band information should be retrieved
>  	// from ieee80211_tx_info
>  	band = wdev->hw->wiphy->bands[NL80211_BAND_2GHZ];
> -- 
> 2.28.0
> 

This now causes a clang warning:

drivers/staging/wfx/data_tx.c:34:19: warning: variable 'band' is uninitialized when used here [-Wuninitialized]
        if (rate->idx >= band->n_bitrates) {
                         ^~~~
drivers/staging/wfx/data_tx.c:23:39: note: initialize the variable 'band' to silence this warning
        struct ieee80211_supported_band *band;
                                             ^
                                              = NULL
1 warning generated.

Cheers,
Nathan
