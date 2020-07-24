Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E5622CF0F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXUI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGXUI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:08:57 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8DCC0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:08:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 8so5955152pjj.1
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WsEvrzfoUskktB89gyOOTdTVlRYOXFqhzIdDvtg7ajY=;
        b=Nya/LAj22r7YPGKMb08e41oJEKYga6ZQPOu0OJAu4FF8LRDqYaorsvT7Br56iqvJky
         /YiOgwoq1BCB0l1woHtMfUpAgmk5sgGaERWxRVr87QNDvfoZPdgP66Ir2d1MzldxJfWk
         tOK6vtlsKSThxOhtK7214XoGcJI1ITxEvXjhBy6J8QqrZztnFy7BJqB1Lk44p8AnmrS7
         vA/+p0Z1PeimN45uNAw8JIf6qA5xQwRDDFlXcBsEBzdRGnfgINCPhUPKVQzbVrw2LjlE
         O/mPDggEJxOLF5vwl0nWpeAxzoZGnWZh+xIwpjFvoa79VYNxMcHJRl8RWHDlT90hKBQ5
         xxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WsEvrzfoUskktB89gyOOTdTVlRYOXFqhzIdDvtg7ajY=;
        b=E2MGEZHUkQByz3FC9v8Pll6lRgLDizywl0Uj4SUADbvuXrtMCAmLgWkrnonBIBbTKM
         FI3bNAkxI+wVvBLYuFqe9qoe6gLtfvYrN9xIuAuXq++8AtHH4VKEHDp4Wf0q/+oxKiJ6
         jE1iu+rVNdmF0hwBCPd1BgPX3TkjTCsMdKfapTCclq01sK8UZbjYCCkn5o6hk+GBJcVw
         HpHEzBdQreAUkVjgUQvJiXYcdm8NpZfySpJAOKGk1bEJSXa+sH/cCOnO9QDF9EAPui8G
         B7kYwO6YFAlO9Pwh1+LWoMSg4DTgy49f17i74hePJjC9XENc4PL/dlV4sxZ1iMubw/Vf
         6tNQ==
X-Gm-Message-State: AOAM5327zZhJL/s48j6C8QFcU/l3L5FjwZcmC5/K16eCyrbiAzq+HcvR
        uvPyNPS8JOa9ml6tOVlDxRTC5g==
X-Google-Smtp-Source: ABdhPJxzEBSwdp/uBpz7baY0bvSfia5SyOjO+X9fkuCzxcIOCCy+ydaEypohuwQDNC40qwQWOlZ9JA==
X-Received: by 2002:a17:90a:ff03:: with SMTP id ce3mr7456208pjb.174.1595621336201;
        Fri, 24 Jul 2020 13:08:56 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id 190sm7196234pfz.41.2020.07.24.13.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 13:08:55 -0700 (PDT)
Date:   Fri, 24 Jul 2020 13:05:17 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ipa: new notification infrastructure
Message-ID: <20200724200517.GB63496@builder.lan>
References: <20200724181142.13581-1-elder@linaro.org>
 <20200724181142.13581-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724181142.13581-2-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 24 Jul 11:11 PDT 2020, Alex Elder wrote:

> Use the new SSR notifier infrastructure to request notifications of
> modem events, rather than the remoteproc IPA notification system.
> The latter was put in place temporarily with the knowledge that the
> new mechanism would become available.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> David:  If you approve, please only ACK; Bjorn will merge.
> 

David, this depends on changes I carry in the rproc-next tree, so if
you're okay with it I can pick this patch through my tree.

Otherwise it will have to wait until 5.9 is out and I won't be able to
remove the old ipa_notify code that this depends on until 5.11...

Thanks,
Bjorn

>  drivers/net/ipa/ipa.h       |  3 ++
>  drivers/net/ipa/ipa_modem.c | 56 +++++++++++++++++++++++--------------
>  2 files changed, 38 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
> index b10a853929525..55115cfb29720 100644
> --- a/drivers/net/ipa/ipa.h
> +++ b/drivers/net/ipa/ipa.h
> @@ -10,6 +10,7 @@
>  #include <linux/device.h>
>  #include <linux/notifier.h>
>  #include <linux/pm_wakeup.h>
> +#include <linux/notifier.h>
>  
>  #include "ipa_version.h"
>  #include "gsi.h"
> @@ -73,6 +74,8 @@ struct ipa {
>  	enum ipa_version version;
>  	struct platform_device *pdev;
>  	struct rproc *modem_rproc;
> +	struct notifier_block nb;
> +	void *notifier;
>  	struct ipa_smp2p *smp2p;
>  	struct ipa_clock *clock;
>  	atomic_t suspend_ref;
> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
> index ed10818dd99f2..e34fe2d77324e 100644
> --- a/drivers/net/ipa/ipa_modem.c
> +++ b/drivers/net/ipa/ipa_modem.c
> @@ -9,7 +9,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/skbuff.h>
>  #include <linux/if_rmnet.h>
> -#include <linux/remoteproc/qcom_q6v5_ipa_notify.h>
> +#include <linux/remoteproc/qcom_rproc.h>
>  
>  #include "ipa.h"
>  #include "ipa_data.h"
> @@ -311,43 +311,40 @@ static void ipa_modem_crashed(struct ipa *ipa)
>  		dev_err(dev, "error %d zeroing modem memory regions\n", ret);
>  }
>  
> -static void ipa_modem_notify(void *data, enum qcom_rproc_event event)
> +static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
> +			    void *data)
>  {
> -	struct ipa *ipa = data;
> -	struct device *dev;
> +	struct ipa *ipa = container_of(nb, struct ipa, nb);
> +	struct qcom_ssr_notify_data *notify_data = data;
> +	struct device *dev = &ipa->pdev->dev;
>  
> -	dev = &ipa->pdev->dev;
> -	switch (event) {
> -	case MODEM_STARTING:
> +	switch (action) {
> +	case QCOM_SSR_BEFORE_POWERUP:
>  		dev_info(dev, "received modem starting event\n");
>  		ipa_smp2p_notify_reset(ipa);
>  		break;
>  
> -	case MODEM_RUNNING:
> +	case QCOM_SSR_AFTER_POWERUP:
>  		dev_info(dev, "received modem running event\n");
>  		break;
>  
> -	case MODEM_STOPPING:
> -	case MODEM_CRASHED:
> +	case QCOM_SSR_BEFORE_SHUTDOWN:
>  		dev_info(dev, "received modem %s event\n",
> -			 event == MODEM_STOPPING ? "stopping"
> -						 : "crashed");
> +			 notify_data->crashed ? "crashed" : "stopping");
>  		if (ipa->setup_complete)
>  			ipa_modem_crashed(ipa);
>  		break;
>  
> -	case MODEM_OFFLINE:
> +	case QCOM_SSR_AFTER_SHUTDOWN:
>  		dev_info(dev, "received modem offline event\n");
>  		break;
>  
> -	case MODEM_REMOVING:
> -		dev_info(dev, "received modem stopping event\n");
> -		break;
> -
>  	default:
> -		dev_err(&ipa->pdev->dev, "unrecognized event %u\n", event);
> +		dev_err(dev, "received unrecognized event %lu\n", action);
>  		break;
>  	}
> +
> +	return NOTIFY_OK;
>  }
>  
>  int ipa_modem_init(struct ipa *ipa, bool modem_init)
> @@ -362,13 +359,30 @@ void ipa_modem_exit(struct ipa *ipa)
>  
>  int ipa_modem_config(struct ipa *ipa)
>  {
> -	return qcom_register_ipa_notify(ipa->modem_rproc, ipa_modem_notify,
> -					ipa);
> +	void *notifier;
> +
> +	ipa->nb.notifier_call = ipa_modem_notify;
> +
> +	notifier = qcom_register_ssr_notifier("mpss", &ipa->nb);
> +	if (IS_ERR(notifier))
> +		return PTR_ERR(notifier);
> +
> +	ipa->notifier = notifier;
> +
> +	return 0;
>  }
>  
>  void ipa_modem_deconfig(struct ipa *ipa)
>  {
> -	qcom_deregister_ipa_notify(ipa->modem_rproc);
> +	struct device *dev = &ipa->pdev->dev;
> +	int ret;
> +
> +	ret = qcom_unregister_ssr_notifier(ipa->notifier, &ipa->nb);
> +	if (ret)
> +		dev_err(dev, "error %d unregistering notifier", ret);
> +
> +	ipa->notifier = NULL;
> +	memset(&ipa->nb, 0, sizeof(ipa->nb));
>  }
>  
>  int ipa_modem_setup(struct ipa *ipa)
> -- 
> 2.20.1
> 
