Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42AC407F98
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhILTNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhILTNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 15:13:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1D86103D;
        Sun, 12 Sep 2021 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631473916;
        bh=VGU2+TdB4prMfLgkuaY2tvLR1iXGYB+nJkWyfFxSn+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfvPYU3n3xGNmiDRwTjwdfNbs3uf2xgzRDPK+UVbtTKhCIvxuvAmNAm9+nRbyyLhe
         JwfL16h4bRhSNHa50W0AZNUB5KZDtbMBvc9Iu8qfr6qo25EhXGjknPJBnkRwH9bSRs
         y/kVKmNA2Howot+IBPrweRpgUV2SFiK9rBbUOHABgjkhfaXzssIHNaTLBYFGwhDcIk
         iH13pfaQJNsG1t5GN5gd5UiP1mY/p+yRsw8Y3xr3ZGYvlT0JikeAaJDZneA7mFmDZa
         iqgpbXzJr6nzTE/jQCf7j47gnQdL047dTW8+JM397zMpcBIcE+2L3AAJzepza/SUUo
         IUJGVpn9LMLBQ==
Date:   Sun, 12 Sep 2021 14:15:36 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Replace zero-length array with flexible array
 member
Message-ID: <20210912191536.GB146608@embeddedor>
References: <20210904092217.2848-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210904092217.2848-1-len.baker@gmx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 04, 2021 at 11:22:17AM +0200, Len Baker wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use "flexible array members"[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> Also, make use of the struct_size() helper in devm_kzalloc().
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

I'll take this in my -next tree. :)

Thanks, Len.
--
Gustavo

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 2 +-
>  include/linux/platform_data/brcmfmac.h                | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index 2f7bc3a70c65..513c7e6421b2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -29,7 +29,7 @@ static int brcmf_of_get_country_codes(struct device *dev,
>  		return (count == -EINVAL) ? 0 : count;
>  	}
> 
> -	cc = devm_kzalloc(dev, sizeof(*cc) + count * sizeof(*cce), GFP_KERNEL);
> +	cc = devm_kzalloc(dev, struct_size(cc, table, count), GFP_KERNEL);
>  	if (!cc)
>  		return -ENOMEM;
> 
> diff --git a/include/linux/platform_data/brcmfmac.h b/include/linux/platform_data/brcmfmac.h
> index 1d30bf278231..2b5676ff35be 100644
> --- a/include/linux/platform_data/brcmfmac.h
> +++ b/include/linux/platform_data/brcmfmac.h
> @@ -125,7 +125,7 @@ struct brcmfmac_pd_cc_entry {
>   */
>  struct brcmfmac_pd_cc {
>  	int				table_size;
> -	struct brcmfmac_pd_cc_entry	table[0];
> +	struct brcmfmac_pd_cc_entry	table[];
>  };
> 
>  /**
> --
> 2.25.1
> 
