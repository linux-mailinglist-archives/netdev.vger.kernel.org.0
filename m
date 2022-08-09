Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA27B58D94F
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 15:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbiHINWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 09:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242943AbiHINV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 09:21:59 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF4C186F3
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 06:21:58 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k26so22199047ejx.5
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=YZymVWR4RcnYjx+F2HCcR3PjSEgBjjeSIuVRDCI0cJI=;
        b=nQ1MfZcZz36NzYtldtkha5fHAWBwai5pnd0P1R1ulsU8pRhgb+b0dGoXcluG26BwOW
         H4LyedYxHL/mYSX1Ax5YZEBj/9e8YC4xAPA/3j+qurpEuXZkj3vJpUBu3O3SkWmpsF5I
         7/Xlp9xax2+5ipjMifJsHn1rSXHPBC9FNSBQbgR36hGvB//cHmCjkBQPpQsrV397LRaw
         yEn4ByleQboQQDy+CqE4N/OJzEcOGnd+WeYojxDqtptyB/U9SHWRHxK4Cdp6LrpahxOv
         3uKkp8VCscioxGL8WMK2kDucYH1dumgiirTCJAaVCvmziM9lOAwVA6UMlxz+P9N1jobe
         ZLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=YZymVWR4RcnYjx+F2HCcR3PjSEgBjjeSIuVRDCI0cJI=;
        b=X1HS/qvQchcptmsiVcE5dw7MQWGEZBQfxqGjsuiWIK3nOk+o+HFOrDDv8cIqBu0BnZ
         yR1impnHyLtF1Ju0WMiOknP3ADe8LL8Nho7qwE0Yiat5ihgWSMbfpYSDkmK1PrQvs9Lq
         VkrZMfLuigPQLxkAGWf1Zh2NjMABDyrJnTog82kEd+iSfl7ew+J5KmZfDgqIh8ILSxZ4
         b3SE3oXTnX4o13AmLBDhrtFFXoQ9Cs5kVwkQfpPggzk30YcFjPXGMQOH82Pn0lrSV1mn
         loxCe1bhNDc6iT5ZijlPbd7sf3CxAb9G0cv/krJhB3VJ0yP4YGAVuOUmq5BVUDC2KdCw
         QGrA==
X-Gm-Message-State: ACgBeo2EXfErVJVaOdD6jddIPDJ97A7F04ENCszzNKylEPlEyYcLwTxS
        ygB6XJff5xySASG33wWkfTYQJncgyqc=
X-Google-Smtp-Source: AA6agR63Lshx+RJ58pVHAwc2G5uqfHFdGpKsU0UvGTG9NwXAuMxs8Pmm+fFNIBiK2bHNRO5WgnMltg==
X-Received: by 2002:a17:907:a073:b0:730:a5a4:4b7d with SMTP id ia19-20020a170907a07300b00730a5a44b7dmr15877421ejc.533.1660051317385;
        Tue, 09 Aug 2022 06:21:57 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id dm13-20020a05640222cd00b0043cb1a83c9fsm6089979edb.71.2022.08.09.06.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 06:21:57 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] sfc: support PTP over IPv6/UDP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220809092002.17571-1-ihuguet@redhat.com>
 <20220809092002.17571-3-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <51e81ce8-38c9-3721-a8bb-eede3525f65c@gmail.com>
Date:   Tue, 9 Aug 2022 14:21:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220809092002.17571-3-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2022 10:20, Íñigo Huguet wrote:
> @@ -1297,28 +1299,46 @@ static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
>  	}
>  }
>  
> -static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, __be16 port)
> +static inline void efx_ptp_init_filter(struct efx_nic *efx,
> +				       struct efx_filter_spec *rxfilter)
>  {
> -	struct efx_ptp_data *ptp = efx->ptp_data;
> -	struct efx_filter_spec rxfilter;
> -	int rc;
> -
> -	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
> -			   efx_rx_queue_index(
> -				   efx_channel_get_rx_queue(ptp->channel)));
> +	efx_filter_init_rx(rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
> +			   efx_rx_queue_index(efx_channel_get_rx_queue(
> +					      efx->ptp_data->channel)));

This indentation is misleading, it makes it look as though
 efx->ptp_data->channel is an argument to efx_rx_queue_index().
Please just use a local (how about struct efx_rx_queue *?).

Otherwise looks good.

-ed
