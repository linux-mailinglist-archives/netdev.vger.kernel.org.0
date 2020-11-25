Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096F52C40F4
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 14:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgKYNO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 08:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgKYNO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 08:14:27 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD345C0613D4;
        Wed, 25 Nov 2020 05:14:26 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id h20so4304720qkk.4;
        Wed, 25 Nov 2020 05:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kOEITRpnYakfcSLbFccn0O0+ahuDFsX14pnUV2GB37k=;
        b=k6aAs+LcWnsNYwcoC5zoKECpknCaYxxTOQSXGadxLHypBtH9p9phyWFDmgG/GhD8Sv
         Nl7p3+4BIeb4O/4G5Ne+k5A9Fbq03GMYJWYqaJUimY4Ll5HlzvyfGxD3ElGrpBUeF0PK
         /vy45nCx+fUsPkVR7dsol/tbuUFJnUqUdAvoWQt/6Owf6g1AucADpEtY5M9anmDXScrW
         5OHsblxzGCC/cV/miusbQ9uGE/20TLLFLJQFEBp+k4AofuT793Q7JFK1Owmx0RWGbAif
         T3537iKJ3AOI0N0sELq0T9Ty6TocU2GD4qkgXneMwFmFNN0rmhLkEEe9277OXIZWcGTL
         qw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kOEITRpnYakfcSLbFccn0O0+ahuDFsX14pnUV2GB37k=;
        b=sQ0DGISWCcnS6ylie9VGHV8pdydFD9Ht8kpWYzhiFrkjzePtZBuUCDdsUKFJQH1HIQ
         FpaYELD8rBlskjIwcbpo184o6QV8vRs40494EayYlw4bFVKSTkjmRy3ytSy4r+Z2k8on
         jKGDljtKQ1L1HVWFsIXnaIgt4jIeZBWtEZQtHnUNowHfr8pPIkflk1kKtUB4VRG3Su7z
         4ycSKsKYoVUaOSx7SW10GD5ZdJl2AjDPMvcMqXHgCgqiX9cm/9ZDkWtDbIcSRvd1yYGp
         kxwL4GNgMDt9kMj+EWs+zXlw1ZuMJqvNm4bYqiGAOUhV8/V4poHRsRQb/+8MMvKhq7S0
         D8wA==
X-Gm-Message-State: AOAM530XHHz4tgHjQdlKLTBIfGn9/GavV2yIqenCY9aBitc+Ank9lHFT
        lmlhe4XlsHB80j/1ntIhmvoDeHewV5Szrw==
X-Google-Smtp-Source: ABdhPJywuho9H+JFOlMKEP6BR+7QwVe13ZNZiT7YzlL2J8RhpOo9HnJYl82wP312bZt/I348Rx/G8A==
X-Received: by 2002:ae9:dec3:: with SMTP id s186mr3274213qkf.210.1606310065815;
        Wed, 25 Nov 2020 05:14:25 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id t2sm2202631qtr.24.2020.11.25.05.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 05:14:25 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 25 Nov 2020 08:14:02 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] workqueue: Add support for exposing singlethread
 workqueues in sysfs
Message-ID: <X75Ymvo1AhSLAKNP@mtj.duckdns.org>
References: <20201006120607.20310-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006120607.20310-1-tariqt@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This generally looks fine to me. Some nits below.

On Tue, Oct 06, 2020 at 03:06:07PM +0300, Tariq Toukan wrote:
> @@ -432,6 +433,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>  			WQ_MEM_RECLAIM, 1, (name))
>  #define create_singlethread_workqueue(name)				\
>  	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> +#define create_singlethread_sysfs_workqueue(name)			\
> +	alloc_ordered_workqueue("%s", __WQ_MAX_ACTIVE_RO |		\
> +				__WQ_LEGACY | WQ_MEM_RECLAIM, name)

Please don't add a new wrapper. Just convert the user to call
alloc_ordered_workqueue() directly. I don't think we need __WQ_MAX_ACTIVE_RO
as a separate flag. The behavior can be implied in __WQ_ORDERED_EXPLICIT,
and __WQ_LEGACY is there just to disable dependency check because users of
older interace aren't marking MEM_RECLAIM correctly.

> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index c41c3c17b86a..a80d34726e68 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4258,6 +4258,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>  	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
>  		flags |= WQ_UNBOUND;
>  
> +	if (flags & __WQ_MAX_ACTIVE_RO)
> +		flags |= WQ_SYSFS;

Just let the user set WQ_SYSFS like other users?

Thanks.

-- 
tejun
