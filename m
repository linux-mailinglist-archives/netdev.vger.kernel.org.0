Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4599226E095
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIQQXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgIQQW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:22:59 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1FDC061351
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:05:19 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 60so2401469otw.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pr1+qs169BJdik6aLXHXMXH0H1gPFgPGvLMJONF6cEM=;
        b=N5soSJzGI2P0TqxBg6k9zuJHKVxrcFJ3lrfwE5KYH3wAMEWUHjR9zkMX5RlssERxlc
         JJ7wUcfYvE8wqcVBu7/8qvEz1BOzXWkRoWBQ25oUl7qIi0TuRR9su+CI1CBQd514VIXf
         HJcCuVT69bL3/vxI7mC2sL/u6m+adTV7MUCdEdUZm+a/zKGSqvTz539wEVcaxNKXGIRt
         N45FBLJXu04R3qZFZAV2DXIkS8i3BgSho/1ijhT8D5pf0PobZvUwlVnE4jnO21vxc/MZ
         MNXQc3fIRvUgoPL7Qv6+ZIhz1Z6wLqQSVloyWAdFJ22HrWLUjuJy28g3i4AzymSHr+dd
         Jg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pr1+qs169BJdik6aLXHXMXH0H1gPFgPGvLMJONF6cEM=;
        b=J9wJww5SCBxeTE1Pc2CE3IQyKh7RmZMoNKxdDGnofh3/4hxpHQLI5FFtciyT1LcvzN
         YwA82+zZcVMKsGn2SsXCYY5hhicRPfoThMvBDk+t7td/G0sPj4At5K4eHqxCpfDxPp10
         44rjiQgRVhe5xbLv95PPwm44e/TGWmktdif58/CmFab5gvt7lm9FDqXJfJMVOFgE6Ddu
         wWqFW02gZ6uZ7HG/0s+q0+sqYBWtADHa2Nd2B8vFttLAL6cu+f9cE80zXFqk8vkA9bJK
         gKL5vvSFNOfyeEj5i8Q5CDF7lBgleHN0uwqHLE6Idp8pXiItCWjy8Xru3OeIruuTW5Ng
         KDig==
X-Gm-Message-State: AOAM532y8gdq+NVWta3BbTyL1C8kapOhsMA2Y6oNpcwKM06rJu9VOE7O
        W2NP1UsMxgGeXhbzMolajFeXjw==
X-Google-Smtp-Source: ABdhPJytIlwv42T4bgYbg4zEeGXT5Vo0QknqPxpyp035i82pDqTmYMRQRKb1oPTJrb+JbY5Fv2Z52g==
X-Received: by 2002:a9d:7084:: with SMTP id l4mr20954675otj.161.1600358718870;
        Thu, 17 Sep 2020 09:05:18 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:7cad:6eff:fec8:37e4])
        by smtp.gmail.com with ESMTPSA id h35sm109614otb.81.2020.09.17.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 09:05:18 -0700 (PDT)
Date:   Thu, 17 Sep 2020 11:05:13 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: qmi: Skip host capability request for Xiaomi
 Poco F1
Message-ID: <20200917160513.GO1893@yoga>
References: <1600328501-8832-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600328501-8832-1-git-send-email-amit.pundir@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 17 Sep 02:41 CDT 2020, Amit Pundir wrote:

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

What happens if you skip sending the host-cap message? I had one
firmware version for which I implemented a
"qcom,snoc-host-cap-skip-quirk".

But testing showed that the link was pretty unusable - pushing any real
amount of data would cause it to silently stop working - and I realized
that I could use the linux-firmware wlanmdsp.mbn instead, which works
great on all my devices...

> Attempts are being made to debug the failure reasons but no
> luck so far. Hence this device specific workaround instead
> of checking for QMI_ERR_MALFORMED_MSG_V01 error message.
> Tried ath10k/WCN3990/hw1.0/wlanmdsp.mbn from the upstream
> linux-firmware project but it didn't help and neither did
> building board-2.bin file from stock bdwlan* files.
> 

"Didn't work" as in the wlanmdsp.mbn from linux-firmware failed to load
or some laer problem?

Regards,
Bjorn

> This workaround will be removed once we have a viable fix.
> Thanks to postmarketOS guys for catching this.
> 
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Device-tree for Xiaomi Poco F1(Beryllium) got merged in
> qcom/arm64-for-5.10 last week
> https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?id=77809cf74a8c
> 
>  drivers/net/wireless/ath/ath10k/qmi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index 0dee1353d395..37c5350eb8b1 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -651,7 +651,8 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
>  
>  	/* older FW didn't support this request, which is not fatal */
>  	if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
> -	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01) {
> +	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01 &&
> +	    !of_machine_is_compatible("xiaomi,beryllium")) { /* Xiaomi Poco F1 workaround */
>  		ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);
>  		ret = -EINVAL;
>  		goto out;
> -- 
> 2.7.4
> 
