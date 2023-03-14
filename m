Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FDD6B9CF3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCNRYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNRYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:24:36 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEFF90084
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:24:34 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso816195wmr.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678814673;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FS1rt/yVGX+pfpqGcClOW8r+tUcfSmNslUJ9jjHqHtc=;
        b=YilZuVJuwN0uR6DEcojlTtkyW3xGDrMLxiTiWOqL43LsEMzUAX4CFVZwYV68/j8tZz
         f5lrPknGn7MfuGeQrrY1wsXJPuEjsefPfxOy8La/3obXC19MPEnHZdbhBJe3qdWRiiF/
         UiWkHJHeeJZFLpL8r30exVsFGJ6MYFfGuvoGG6kAjoe+43JJfF3pRj/sJnZMvqYN1uMX
         LovBOWbcVb3OQL3v4BzZIQnhjyv7sYWGhVmUQwTjQRfKSuxKo9bH8unUtno/Heh0hErZ
         4DzGLniLNVcv/m3rXm8P9Xd9bQPrFg49jprsu/fdylEhMiL2C2zseOH4hA17e0OAJX7w
         WFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814673;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FS1rt/yVGX+pfpqGcClOW8r+tUcfSmNslUJ9jjHqHtc=;
        b=KoVeaRxGrFKjNmao3nxWx4Wjy20RMZtE00nusVwF48jFyyd/sXw8exLnHOEJjrnQe1
         4e7FZsd17gk7CbCN3weRRjv0h3qsaPn6SWXnMnLCCQk3tMRMJAjvN7yu2w/7IVULbm0o
         M22DCeigxT6YwwpKYI9sko+9eNcMKplO+fAPgtMvocL6B8nhYe6IWBPxC58b2v1inZPQ
         k7hjwUGVzEUHvFBBqCm6fH0hb3jjjX7czb/eiRvuIkDd+VykYOdRE7Z+236+bIKVS8Yk
         P1HV9SWxHq1y5uLW0q2dlzOe/xVwttIDfU1gngiAsvLTXRPuC/1HBdau9L3Eyr5r8O3m
         9BlQ==
X-Gm-Message-State: AO0yUKVNKb1W8t6yr6zjI/GOXvhvHZTt8StalgFRaBfzH/tOOwNR0aDf
        SP4uwxaKCXOpH+L8XeyjDaA=
X-Google-Smtp-Source: AK7set8MtFoAvdRgqBwhtDPrMg5IG6HQJreGgmGOTy+l6bdWg4HvT9TEllUVn+SWKcyrHjcP7K6o4A==
X-Received: by 2002:a05:600c:358a:b0:3e1:e149:b67b with SMTP id p10-20020a05600c358a00b003e1e149b67bmr2880820wmq.18.1678814673279;
        Tue, 14 Mar 2023 10:24:33 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id 20-20020a05600c021400b003e20970175dsm3414416wmi.32.2023.03.14.10.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 10:24:33 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next v4 4/4] sfc: remove expired unicast PTP
 filters
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-5-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <fcd12738-5e59-3483-540a-b0f6bb639bbd@gmail.com>
Date:   Tue, 14 Mar 2023 17:24:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230314100925.12040-5-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 10:09, Íñigo Huguet wrote:
> Filters inserted to support unicast PTP mode might become unused after
> some time, so we need to remove them to avoid accumulating many of them.
> 
> Actually, it would be a very unusual situation that many different
> addresses are used, normally only a small set of predefined
> addresses are tried. Anyway, some cleanup is necessary because
> maintaining old filters forever makes very little sense.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
but again a couple of nits to think about...

>  static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
>  {
> +	struct efx_ptp_data *ptp = efx->ptp_data;
>  	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
>  	struct efx_filter_spec spec;
>  
> @@ -1418,7 +1437,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
>  	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
>  	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
>  	spec.ether_type = htons(ETH_P_1588);
> -	return efx_ptp_insert_filter(efx, &efx->ptp_data->rxfilters_mcast, &spec);
> +	return efx_ptp_insert_filter(efx, &ptp->rxfilters_mcast, &spec, 0);
>  }

If respinning for any reason, maybe move the addition of the
 local to patch #2.

> +static void efx_ptp_drop_expired_unicast_filters(struct efx_nic *efx)
> +{
> +	struct efx_ptp_data *ptp = efx->ptp_data;
> +	struct efx_ptp_rxfilter *rxfilter, *tmp;
> +
> +	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
> +		if (time_is_before_jiffies(rxfilter->expiry))
> +			efx_ptp_remove_one_filter(efx, rxfilter);
> +	}
> +}
> +
>  static int efx_ptp_start(struct efx_nic *efx)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> @@ -1631,6 +1666,8 @@ static void efx_ptp_worker(struct work_struct *work)
>  
>  	while ((skb = __skb_dequeue(&tempq)))
>  		efx_ptp_process_rx(efx, skb);
> +
> +	efx_ptp_drop_expired_unicast_filters(efx);
>  }
PTP worker runs on every PTP packet TX or RX, which might be
 quite frequent.  It's probably fine but do we need to consider
 limiting how much time we spend repeatedly scanning the list?
Conversely, if all PTP traffic suddenly stops, I think existing
 unicast filters will stay indefinitely.  Again probably fine
 but just want to check that sounds sane to everyone.
