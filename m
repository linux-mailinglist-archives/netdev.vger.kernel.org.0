Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B490A279556
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgIZAFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgIZAFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:05:14 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A38C0613D3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:05:14 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c2so3946579otp.7
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7/y3L9VN/lSk2/yPUqjWQt/iBis6Y2WvD6aC+aqQ45k=;
        b=wA/fSUbCe7cC28vTLS/YT0tT76JDS+7fxa3cGEfRScdzizM7/d4lQ3G5tDwq+j6tRr
         f5NKLkUjfVDSdnhoUZmcx8NdhLxwkjkvQhuABf7iRnPqEGlQH9hynBsQNLi25WLXaCuY
         /rbGD6cjXl93vWRGQA871YKIp7Bb7P56tOOV7vpfvIxU+WeLVp5CzbsaUZEjn6jUWQLl
         tBbG/ZZLXGAW2hpmGTBKUgBZwan0THbmz06m+HhLdBHqCthxfN+EEVWknR7xrRuqrfPq
         5HdvFmKneiLFEdQ2JEkOvXVlGupA3b/GMjrPdu4BrpI6cfDnx5XLs2mZXcCznuC2UVdw
         Y7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7/y3L9VN/lSk2/yPUqjWQt/iBis6Y2WvD6aC+aqQ45k=;
        b=iIdnrSZJwvi6BKbBeniuc/JJ/Savlb6euchGjeChccjoWifbPNdwEMjN6iXrZ04ox5
         amZuh9DAGC9dAZFyZszWBl2fClwkvjOcOqBQAxEibgaj+w9NBNGWV9fGvl7wSXrXWlSQ
         VZcaN3WwtoXtbNB8G2JVkuzNv8QNuCwuns/xLGATjgVcOUo5O1m76yX+RR/HhzGMzuFg
         +jQ+yyKpfd2aISmCt3rdG92kwtsy2hnOOS94YFpooTcDUVRur9geFgZruaBAp5EUoGuc
         qZEOpdiXPfv9qL6SOUQIwGjRywDEVXPrKjektwp1CMwcMRfNy2/3SqhY+oXDKmM98Ngy
         kn6w==
X-Gm-Message-State: AOAM533ndt4+jsbDb5MKFIRL3HsPKOIDNNxMApzIlqy1AxG+alezJLVe
        dFqUwHEQSLYOyzp8duJ94l3G4g==
X-Google-Smtp-Source: ABdhPJyxRPMklUI0IGQBC65+pPVzl0orUnkXc+fxoQ3qhoC120rZYlU136YEqY+6sBrtpVDVgjtRkg==
X-Received: by 2002:a9d:7d89:: with SMTP id j9mr1926888otn.205.1601078713572;
        Fri, 25 Sep 2020 17:05:13 -0700 (PDT)
Received: from builder.lan (99-135-181-32.lightspeed.austtx.sbcglobal.net. [99.135.181.32])
        by smtp.gmail.com with ESMTPSA id m25sm1030777otl.71.2020.09.25.17.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 17:05:12 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:00:39 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap
 QMI requests
Message-ID: <20200926000039.GA2441@builder.lan>
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 25 Sep 11:29 PDT 2020, Amit Pundir wrote:

> There are firmware versions which do not support host capability
> QMI request. We suspect either the host cap is not implemented or
> there may be firmware specific issues, but apparently there seem
> to be a generation of firmware that has this particular behavior.
> 
> For example, firmware build on Xiaomi Poco F1 (sdm845) phone:
> "QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1"
> 
> If we do not skip the host cap QMI request on Poco F1, then we
> get a QMI_ERR_MALFORMED_MSG_V01 error message in the
> ath10k_qmi_host_cap_send_sync(). But this error message is not
> fatal to the firmware nor to the ath10k driver and we can still
> bring up the WiFi services successfully if we just ignore it.
> 
> Hence introducing this DeviceTree quirk to skip host capability
> QMI request for the firmware versions which do not support this
> feature.
> 
> Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt        |  5 +++++
>  drivers/net/wireless/ath/ath10k/qmi.c                       | 13 ++++++++++---
>  drivers/net/wireless/ath/ath10k/snoc.c                      |  3 +++
>  drivers/net/wireless/ath/ath10k/snoc.h                      |  1 +
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index 65ee68efd574..135c7ecd4487 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -86,6 +86,11 @@ Optional properties:
>  	Value type: <empty>
>  	Definition: Quirk specifying that the firmware expects the 8bit version
>  		    of the host capability QMI request
> +- qcom,snoc-host-cap-skip-quirk:
> +	Usage: Optional
> +	Value type: <empty>
> +	Definition: Quirk specifying that the firmware wants to skip the host
> +		    capability QMI request
>  - qcom,xo-cal-data: xo cal offset to be configured in xo trim register.
>  
>  - qcom,msa-fixed-perm: Boolean context flag to disable SCM call for statically
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index 5468a41e928e..5adff7695e18 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -770,6 +770,7 @@ ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
>  static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
>  {
>  	struct ath10k *ar = qmi->ar;
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
>  	int ret;
>  
>  	ret = ath10k_qmi_ind_register_send_sync_msg(qmi);
> @@ -781,9 +782,15 @@ static void ath10k_qmi_event_server_arrive(struct ath10k_qmi *qmi)
>  		return;
>  	}
>  
> -	ret = ath10k_qmi_host_cap_send_sync(qmi);
> -	if (ret)
> -		return;
> +	/*
> +	 * Skip the host capability request for the firmware versions which
> +	 * do not support this feature.
> +	 */
> +	if (!test_bit(ATH10K_SNOC_FLAG_SKIP_HOST_CAP_QUIRK, &ar_snoc->flags)) {

Could have made this an early return inside
ath10k_qmi_host_cap_send_sync(), but this works.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> +		ret = ath10k_qmi_host_cap_send_sync(qmi);
> +		if (ret)
> +			return;
> +	}
>  
>  	ret = ath10k_qmi_msa_mem_info_send_sync_msg(qmi);
>  	if (ret)
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 354d49b1cd45..4efbf1339c80 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -1281,6 +1281,9 @@ static void ath10k_snoc_quirks_init(struct ath10k *ar)
>  
>  	if (of_property_read_bool(dev->of_node, "qcom,snoc-host-cap-8bit-quirk"))
>  		set_bit(ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK, &ar_snoc->flags);
> +
> +	if (of_property_read_bool(dev->of_node, "qcom,snoc-host-cap-skip-quirk"))
> +		set_bit(ATH10K_SNOC_FLAG_SKIP_HOST_CAP_QUIRK, &ar_snoc->flags);
>  }
>  
>  int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
> index a3dd06f6ac62..2a0045f0af7e 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.h
> +++ b/drivers/net/wireless/ath/ath10k/snoc.h
> @@ -47,6 +47,7 @@ enum ath10k_snoc_flags {
>  	ATH10K_SNOC_FLAG_UNREGISTERING,
>  	ATH10K_SNOC_FLAG_RECOVERY,
>  	ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK,
> +	ATH10K_SNOC_FLAG_SKIP_HOST_CAP_QUIRK,
>  };
>  
>  struct clk_bulk_data;
> -- 
> 2.7.4
> 
