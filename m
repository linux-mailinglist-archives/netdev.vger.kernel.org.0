Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FE2C2F36
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404071AbgKXRui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403994AbgKXRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:50:34 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02E7C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 09:50:32 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id y24so14612819otk.3
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 09:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CxnIfXHdix7GS8g6GFHW2wnM4FONLsoFnSqqsSh6GHc=;
        b=CIAKGGvoM96bHX3qTKMq571WXskFxiweMjicyDzm9KHiiheeWHdpTze+EgY18uIFGx
         TXFUYqijSsUYaxZiQcM7TYGH3z11FfmFvQNv2y3S2sIjM3xz6X9Dv3/H71SwBzYqqehJ
         HzjZ8sV6azFHmOF4wsalz23pw0MbUDHblBMgZc1G4Mq3HT85EILFV28n0mWxd09wBj18
         CBTshWNFG/8o2TuKB972+0ln4ohBt/IOIzkYBfbGgUBtgBnE0DZujjGJ3ECGLzzLonFi
         a9nA/bXdldgtzi2sb+U0j2TAu+sT8TMQJG0Vwb/FZiGMNGbCzD3f292aS5hLoEeyqePk
         yKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CxnIfXHdix7GS8g6GFHW2wnM4FONLsoFnSqqsSh6GHc=;
        b=ii53tPp14P9i8zF8mSt2fYELzoqoJJt6FuySlRYgW5HKRB7ms1nzMu8B3W9SH63yof
         Ck+RoDZboTY04WytUZqwBHrqYyXCDMc5A44h/+wxINvbTH4GKVGIHPVd+j7qbvzQdXM1
         /r7VTUswGcO2LdTYR5AeT0L6RVyCg0prC9klgTL6207DzozaQX3h1xon5IO/HmmeSolY
         qokVPkoX/VZafiwEEbt5lpR+PrsPuCH1ZD1TexxsoJdtl1jjywWHUf33DmRxYjnkhqX3
         tOH2gYS+7F/Vf8/8B3W+lPuSy4tHzHsSo9MmEvLjO1SR9Vww/CDnqUyXy1PnvhLcVebq
         IArw==
X-Gm-Message-State: AOAM533kYmd2rPqVsx6yjeSvH/xZGkZv/nkapkPyxh3Wqp0h1ogHxUD9
        WTgvrvAIjPIAY4HITVYTS9Zo4w==
X-Google-Smtp-Source: ABdhPJyZvx5cnvHRa/z/iiGkOzVz/4uQCaX+SxK6/doJ9JNN3u9FKbqfKaLVCF+7bhrzd4wOCRtp/w==
X-Received: by 2002:a9d:3d06:: with SMTP id a6mr4103420otc.368.1606240232274;
        Tue, 24 Nov 2020 09:50:32 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id t126sm9735070oih.51.2020.11.24.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:50:31 -0800 (PST)
Date:   Tue, 24 Nov 2020 11:50:29 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>, Joel S <jo@jsfamily.in>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, phone-devel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: qmi: Skip host capability request for Xiaomi
 Poco F1
Message-ID: <20201124175029.GF185852@builder.lan>
References: <1606127329-6942-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606127329-6942-1-git-send-email-amit.pundir@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 23 Nov 04:28 CST 2020, Amit Pundir wrote:

> Workaround to get WiFi working on Xiaomi Poco F1 (sdm845)
> phone. We get a non-fatal QMI_ERR_MALFORMED_MSG_V01 error
> message in ath10k_qmi_host_cap_send_sync(), but we can still
> bring up WiFi services successfully on AOSP if we ignore it.
> 
> We suspect either the host cap is not implemented or there
> may be firmware specific issues. Firmware version is
> QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1
> 
> qcom,snoc-host-cap-8bit-quirk didn't help. If I use this
> quirk, then the host capability request does get accepted,
> but we run into fatal "msa info req rejected" error and
> WiFi interface doesn't come up.
> 
> Attempts are being made to debug the failure reasons but no
> luck so far. Hence this device specific workaround instead
> of checking for QMI_ERR_MALFORMED_MSG_V01 error message.
> Tried ath10k/WCN3990/hw1.0/wlanmdsp.mbn from the upstream
> linux-firmware project but it didn't help and neither did
> building board-2.bin file from stock bdwlan* files.
> 
> This workaround will be removed once we have a viable fix.
> Thanks to postmarketOS guys for catching this.
> 
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> We dropped this workaround last time in the favor of
> a generic dts quirk to skip host cap check. But that
> is under under discussion for a while now,
> https://lkml.org/lkml/2020/9/25/1119, so resending
> this short term workaround for the time being.
> 

I still want the quirk, because we have this on other machines as well.

> v2: ath10k-check complained about a too long line last
>     time, so moved the comment to a new line.
>     
>  drivers/net/wireless/ath/ath10k/qmi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index ae6b1f402adf..1c58b0ff1d29 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -653,7 +653,9 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
>  
>  	/* older FW didn't support this request, which is not fatal */
>  	if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
> -	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01) {
> +	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01 &&
> +	    /* Xiaomi Poco F1 workaround */

If we go with a temporary approach this comment should describe why this
is here. (And it probably shouldn't be in the middle of the expression
list in the conditional.

Regards,
Bjorn

> +	    !of_machine_is_compatible("xiaomi,beryllium")) {
>  		ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);
>  		ret = -EINVAL;
>  		goto out;
> -- 
> 2.7.4
> 
