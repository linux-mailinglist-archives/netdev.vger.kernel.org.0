Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A01F268363
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 06:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgINEMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 00:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgINEMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 00:12:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4E2C06174A;
        Sun, 13 Sep 2020 21:12:43 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d20so15699489qka.5;
        Sun, 13 Sep 2020 21:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4o8RiiIeaPF2zk+jHK0lxqhUIj20gFmE3NZMfj4jASE=;
        b=q0VNm+NCAOkP3UHGcO43wBi7uIiYu8Kk5SjsLlEL5eT9lANDY8IGZwKyPxfSzx8Uz0
         UiVFfRpnVLRNV9+FcSqJAlJSdHGF0I0km5pJsi6ERXH43D4Y75pPaCaLFbuerDx7QS6n
         LyrxN4OlOAoJY8R+5nsiOKcOlqAa4ObjQXCbt2m2rQJOp8K5ZAtcc0AJcNAioWRe6LiQ
         2UbIcOigvBjGNCuBMxuYh0NWtfCJQncUXkKuqNi8FmmyUykLCelAr6IKOxcRmRaEdJbq
         OGvHxBuZI/ziM00T+iVm1GrjolAs3z2etY19xbZ4l61yPtYdDS7jTW0pwHWxHRjIoBsB
         DulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4o8RiiIeaPF2zk+jHK0lxqhUIj20gFmE3NZMfj4jASE=;
        b=mXVQMazV2RiZo2zms3Fia/c6OSgwxlecAqruP3iWSdmYvHOxyFvrD6mlYi6dSCgk/A
         0lmprl82t86J1LIkh3qEw3w7BRloyzT98ZbbrBVkD6JroEJhJkVOTNIL5xk2Qlx9TXZS
         GGAkt7mN7n53az+FjaXo06vcl1zWvKlP/b/FS/X91/r/X+BMDSw+8dCEMAScoY5rkivY
         eA04u9+x5WiDztKSPIW0dBjPUeucbHNL9k9MLQ6UBOeYRA3DlwPchsuP5U9scyGyv+cz
         X1wfuZffy7koO/dIyrmjmme/1P7MJZ6plK2sn1u9oSao5oVGs+tmoMxXYGp83/GUgNaA
         HlbA==
X-Gm-Message-State: AOAM533+FArNXFv3ePNcL4Z+lXdN7MQkgyMijVXBvyI54LYGEHb86HJk
        LeuJYYCymjkX3nClelSu3v4=
X-Google-Smtp-Source: ABdhPJyy7rjpXizx9K98PSN0CKUJxoD3UnOeQPTEx6bOtOU4oOacDfwttILbZ9f21OPLFHge+6boiA==
X-Received: by 2002:a37:a054:: with SMTP id j81mr10359104qke.23.1600056752350;
        Sun, 13 Sep 2020 21:12:32 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id o4sm12672845qkk.75.2020.09.13.21.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 21:12:31 -0700 (PDT)
Date:   Sun, 13 Sep 2020 21:12:29 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     trix@redhat.com
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, ndesaulniers@google.com, smoch@web.de,
        dan.carpenter@oracle.com, double.lo@cypress.com, digetx@gmail.com,
        frank.kao@cypress.com, amsr@cypress.com, stanley.hsu@cypress.com,
        saravanan.shanmugham@cypress.com, jean-philippe@linaro.org,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] brcmfmac: initialize variable
Message-ID: <20200914041229.GA1600388@ubuntu-n2-xlarge-x86>
References: <20200913143522.20390-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200913143522.20390-1-trix@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 07:35:22AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this problem
> sdio.c:3265:13: warning: Branch condition evaluates to
>   a garbage value
>         } else if (pending) {
>                    ^~~~~~~
> 
> brcmf_sdio_dcmd_resp_wait() only sets pending to true.
> So pending needs to be initialized to false.
> 
> Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index d4989e0cd7be..403b123710ec 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -3233,7 +3233,7 @@ brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
>  {
>  	int timeleft;
>  	uint rxlen = 0;
> -	bool pending;
> +	bool pending = false;
>  	u8 *buf;
>  	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
>  	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> -- 
> 2.18.1
> 
