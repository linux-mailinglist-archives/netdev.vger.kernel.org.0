Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD7A4FAC4F
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 08:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbiDJG2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 02:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiDJG2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 02:28:35 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A675A08E
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 23:26:25 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r13so18517342wrr.9
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 23:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t6cNF1cm/fyPyoSwJ6ELNZJ37M1lAzsTMW16OSgY8u4=;
        b=NFeR5nIlsX0MFGmj+va8HVa6Qoe/YuQMdDOPpd+lQ+hx+vtM/IOKEbD0UGQZ5mdVrU
         ZZUdoEp7M0oleinNshkO0K+Dj2pvpYJbhQw3aYplCBysH+XmGxlunaGWgbB0MIbkTYyc
         cX88Yh91idRlYeJ7ktV2qCqCU024mV/+vnDKUIMuxBQWQRMslpeONo6qlWiPDbTCihTZ
         kKBI8qrdgDsd3uA1dJ6Y+Ky+U0+1FnrtDy1pVdElWq3LElyupW2s7nmYmSUuZpyGz5jP
         8FbjvWiYV196+oMs9J1PQ7j8nqmxsIfJSv4yrGclXHMhEhSWSdi+ruC0OcKxgMuIO2Cr
         z16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t6cNF1cm/fyPyoSwJ6ELNZJ37M1lAzsTMW16OSgY8u4=;
        b=K4/BNSiNZY1263QLuNfhxfR7yTDKcE+0idAyo+TOHUcZyVTG76X9yC7DbqFyvlFn6F
         9PVpUDIqnzpskiyjjL//x6LSFM/RE1nV17pCn2zzB0o51oMTd6+vPl9ptftkdBxf3HyC
         Mdk7WVFFdY8nlcMWrhIXYxQpj22paZ5/Q4m5bfDgydpcLsdOQnW1SSEpLgXSp4EEKV+3
         x1VXmyV9zk1QBQnaNyofs+XnWd+eJZhZJOAc7PDjEI57jY1uqr3AAkTbNPsF2Nt6bmKa
         /qqrPy+75d9H9F9TDAg4f9bnedkwoUALZLMa6XFAOat1wCa/uz1Gwzqd2tLpmOp7w05E
         9HDA==
X-Gm-Message-State: AOAM531WzAD0e3m6nPbloX4IafnkfDHkwl9w+pzeKF0iQVN3IoJia8KW
        35qibZUTKVFmpnyYECxv5Lo=
X-Google-Smtp-Source: ABdhPJxeqZtsf01hkhzzWHe9frzK+B5d/nTIPHZwtkjRfln6SGvZVin66sMq9xwVB3k+aqhPlM9/Pw==
X-Received: by 2002:adf:f781:0:b0:207:9c12:5bee with SMTP id q1-20020adff781000000b002079c125beemr5381606wrp.122.1649571983956;
        Sat, 09 Apr 2022 23:26:23 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id r4-20020a1c2b04000000b0038a0e15ee13sm14591720wmr.8.2022.04.09.23.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 23:26:23 -0700 (PDT)
Date:   Sat, 9 Apr 2022 23:26:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/5] ptp: Add cycles support for virtual
 clocks
Message-ID: <20220410062621.GA212299@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403175544.26556-2-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 03, 2022 at 07:55:40PM +0200, Gerhard Engleder wrote:

> @@ -225,6 +233,21 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  	mutex_init(&ptp->n_vclocks_mux);
>  	init_waitqueue_head(&ptp->tsev_wq);
>  
> +	if (!ptp->info->getcycles64 && !ptp->info->getcyclesx64) {

Please swap blocks, using non-negated logical test:

	if (ptp->info->getcycles64 || ptp->info->getcyclesx64)

> +		/* Free running cycle counter not supported, use time. */
> +		ptp->info->getcycles64 = ptp_getcycles64;
> +
> +		if (ptp->info->gettimex64)
> +			ptp->info->getcyclesx64 = ptp->info->gettimex64;
> +
> +		if (ptp->info->getcrosststamp)
> +			ptp->info->getcrosscycles = ptp->info->getcrosststamp;
> +	} else {
> +		ptp->has_cycles = true;
> +		if (!ptp->info->getcycles64 && ptp->info->getcyclesx64)
> +			ptp->info->getcycles64 = ptp_getcycles64;
> +	}
> +
>  	if (ptp->info->do_aux_work) {
>  		kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
>  		ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);


> @@ -231,10 +231,12 @@ static ssize_t n_vclocks_store(struct device *dev,
>  			*(ptp->vclock_index + ptp->n_vclocks - i) = -1;
>  	}
>  
> -	if (num == 0)
> -		dev_info(dev, "only physical clock in use now\n");
> -	else
> -		dev_info(dev, "guarantee physical clock free running\n");
> +	if (!ptp->has_cycles) {

Not sure what this test means ...

> +		if (num == 0)
> +			dev_info(dev, "only physical clock in use now\n");

Shouldn't this one print even if has_cycles == false?

> +		else
> +			dev_info(dev, "guarantee physical clock free running\n");
> +	}
>  
>  	ptp->n_vclocks = num;
>  	mutex_unlock(&ptp->n_vclocks_mux);

Thanks,
Richard
