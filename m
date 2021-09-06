Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE2A40123B
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 02:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhIFAom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 20:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhIFAoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 20:44:39 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753BCC06175F
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 17:43:35 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w144so6879737oie.13
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 17:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VXz3E7pt4ytJZFiidta6LWpYOPkipEqLXRupmapbEkg=;
        b=hG0uEpCkucAjn2t8kIfAgSG7UwOiEnFhcQemLyHrWcRloRDLXWznn6ZN3Z9qmKEJp/
         stQb9NvQo+/tXaM8tSPvQGrrM12aGphPU9BROyJNOaVij0ZZANc7SO6fnSoH5XjHkRYE
         T0O3janIJjd11ceL5oFXFhpFsBQxu+Vcub48fzPxz3LglWw10a1DFhS0TBvElFyTBIoU
         DPg8TWiX3NbiTnM9dQQ4cPJOuJIBDnDPMfI18A5K79JANydFKd/PVjOaL48hk2hbt/qx
         jcchydaLfw0arkQ8f3IadtWggyLwbnU68bGVYTaV8QxdiYbh0IKFmAiBWPN99aq5ugw3
         xGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VXz3E7pt4ytJZFiidta6LWpYOPkipEqLXRupmapbEkg=;
        b=avnRR09IL1aaDxzDCE0c81xTq5f0r8k86p1Lqr0zm2h/ApOXtjOzFpiNAP58My3gXS
         1z6RmK0LRDvpn3pOgLMmUrniDkgQxafEW5wazMfE278fD5e1fwKue1G35PTrXTIxEzB5
         crAqb3b/Sv3PWNXb1WjciDw+J35rWrWgiVRXfyb8tZBu2oQ0Ij1xU6HgbsUzNqcMSamj
         7P8AndYR1cqxg6BrCkmUaat4pgJIdl9tExx11g2sN1qGzkBSlB84ViMru45VdT1LCwSZ
         K9ngQZTapTxCQ0JjPe4gGSbpPHfA9zyDuWxjiv3PyfgX0Z4LF/xn2M5lBDmLcNmW23MT
         +SOQ==
X-Gm-Message-State: AOAM530KnZJ5BDI1xk1bYjvCP/VTqZdDNU3smNqE50TJ6vkoQBv6G4+D
        2LYXUESef8H8zFIEOkydOiaVog==
X-Google-Smtp-Source: ABdhPJxMgzd1ppDDtypbqleJZ+qHh8aZdbGzv7WtFvDErUHqWWycI0D7asw3iyPTo4fjijSD3iB68Q==
X-Received: by 2002:a05:6808:a01:: with SMTP id n1mr6665277oij.52.1630889014515;
        Sun, 05 Sep 2021 17:43:34 -0700 (PDT)
Received: from MacBook-Pro.hackershack.net (cpe-173-173-107-246.satx.res.rr.com. [173.173.107.246])
        by smtp.gmail.com with ESMTPSA id u14sm1482783oth.73.2021.09.05.17.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 17:43:34 -0700 (PDT)
Subject: Re: [PATCH] ath10k: Don't always treat modem stop events as crashes
To:     Stephen Boyd <swboyd@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, Govind Singh <govinds@codeaurora.org>,
        Youghandhar Chintala <youghand@codeaurora.org>,
        Abhishek Kumar <kuabhs@chromium.org>
References: <20210905210400.1157870-1-swboyd@chromium.org>
From:   Steev Klimaszewski <steev@kali.org>
Message-ID: <2ab941df-f604-59b7-28ab-d1a9a6ced2c7@kali.org>
Date:   Sun, 5 Sep 2021 19:43:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210905210400.1157870-1-swboyd@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/5/21 4:04 PM, Stephen Boyd wrote:
> When rebooting on sc7180 Trogdor devices I see the following crash from
> the wifi driver.
>
>  ath10k_snoc 18800000.wifi: firmware crashed! (guid 83493570-29a2-4e98-a83e-70048c47669c)
>
> This is because a modem stop event looks just like a firmware crash to
> the driver, the qmi connection is closed in both cases. Use the qcom ssr
> notifier block to stop treating the qmi connection close event as a
> firmware crash signal when the modem hasn't actually crashed. See
> ath10k_qmi_event_server_exit() for more details.
>
> This silences the crash message seen during every reboot.
>
> Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
> Cc: Govind Singh <govinds@codeaurora.org>
> Cc: Youghandhar Chintala <youghand@codeaurora.org>
> Cc: Abhishek Kumar <kuabhs@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/net/wireless/ath/ath10k/snoc.c | 75 ++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/snoc.h |  4 ++
>  2 files changed, 79 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index ea00fbb15601..fc4970e063f8 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -12,6 +12,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/property.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/remoteproc/qcom_rproc.h>
>  #include <linux/of_address.h>
>  #include <linux/iommu.h>
>  
> @@ -1477,6 +1478,70 @@ void ath10k_snoc_fw_crashed_dump(struct ath10k *ar)
>  	mutex_unlock(&ar->dump_mutex);
>  }
>  
> +static int ath10k_snoc_modem_notify(struct notifier_block *nb, unsigned long action,
> +				    void *data)
> +{
> +	struct ath10k_snoc *ar_snoc = container_of(nb, struct ath10k_snoc, nb);
> +	struct ath10k *ar = ar_snoc->ar;
> +	struct qcom_ssr_notify_data *notify_data = data;
> +
> +	switch (action) {
> +	case QCOM_SSR_BEFORE_POWERUP:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem starting event\n");
> +		clear_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
> +		break;
> +
> +	case QCOM_SSR_AFTER_POWERUP:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem running event\n");
> +		break;
> +
> +	case QCOM_SSR_BEFORE_SHUTDOWN:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem %s event\n",
> +			   notify_data->crashed ? "crashed" : "stopping");
> +		if (!notify_data->crashed)
> +			set_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
> +		else
> +			clear_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
> +		break;
> +
> +	case QCOM_SSR_AFTER_SHUTDOWN:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem offline event\n");
> +		break;
> +
> +	default:
> +		ath10k_err(ar, "received unrecognized event %lu\n", action);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int ath10k_modem_init(struct ath10k *ar)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	void *notifier;
> +
> +	ar_snoc->nb.notifier_call = ath10k_snoc_modem_notify;
> +
> +	notifier = qcom_register_ssr_notifier("mpss", &ar_snoc->nb);
> +	if (IS_ERR(notifier))
> +		return PTR_ERR(notifier);
> +
> +	ar_snoc->notifier = notifier;
> +
> +	return 0;
> +}
> +
> +static void ath10k_modem_deinit(struct ath10k *ar)
> +{
> +	int ret;
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +
> +	ret = qcom_unregister_ssr_notifier(ar_snoc->notifier, &ar_snoc->nb);
> +	if (ret)
> +		ath10k_err(ar, "error %d unregistering notifier\n", ret);
> +}
> +
>  static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
>  {
>  	struct device *dev = ar->dev;
> @@ -1740,10 +1805,19 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>  		goto err_fw_deinit;
>  	}
>  
> +	ret = ath10k_modem_init(ar);
> +	if (ret) {
> +		ath10k_err(ar, "failed to initialize modem notifier: %d\n", ret);
> +		goto err_qmi_deinit;
> +	}
> +
>  	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
>  
>  	return 0;
>  
> +err_qmi_deinit:
> +	ath10k_qmi_deinit(ar);
> +
>  err_fw_deinit:
>  	ath10k_fw_deinit(ar);
>  
> @@ -1771,6 +1845,7 @@ static int ath10k_snoc_free_resources(struct ath10k *ar)
>  	ath10k_fw_deinit(ar);
>  	ath10k_snoc_free_irq(ar);
>  	ath10k_snoc_release_resource(ar);
> +	ath10k_modem_deinit(ar);
>  	ath10k_qmi_deinit(ar);
>  	ath10k_core_destroy(ar);
>  
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
> index 5095d1893681..d986edc772f8 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.h
> +++ b/drivers/net/wireless/ath/ath10k/snoc.h
> @@ -6,6 +6,8 @@
>  #ifndef _SNOC_H_
>  #define _SNOC_H_
>  
> +#include <linux/notifier.h>
> +
>  #include "hw.h"
>  #include "ce.h"
>  #include "qmi.h"
> @@ -75,6 +77,8 @@ struct ath10k_snoc {
>  	struct clk_bulk_data *clks;
>  	size_t num_clks;
>  	struct ath10k_qmi *qmi;
> +	struct notifier_block nb;
> +	void *notifier;
>  	unsigned long flags;
>  	bool xo_cal_supported;
>  	u32 xo_cal_data;
>
> base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f


I was also seeing this on the Lenovo Yoga C630, so I pulled the patch in
to test here and after testing 20 reboots, I have not seen the message once.

Tested-By: Steev Klimaszewski <steev@kali.org>

