Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5336CB561
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjC1ETi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1ETh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:19:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7928E0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:19:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q19so7691623wrc.5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679977175;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNQHPxdZ+Cbyy9oETw99m/xvPB3qYGRr2tA758CH77k=;
        b=PN5DF07i3byPQ9Qmpu43UVA0NFTN/1KPTYZmA92Byi3qOK0d6diOLvrFj609R8BW/E
         S6p8tLrTibRWvC2PUgdR/kQyod6oJblvTxox+6hBMCHIx/JIQgGktpS9GKGgtCAYbppl
         hUvtx1Oedh+B1rRvXvdNG8cOTmrinyP3J6y/bB3XPo8jLbnOc0Rhzk8ePzYl9E4aDAzT
         pRPBIeK0qv/hJpkswZOFkevUMW53pMHK5YPakWNOrON2AD1ZogKtlJuvK6hqyviO4Fce
         AIvOuPSbIB4Cxu/9UkS3UzUUTnViOGmwj7elGsSrVLtj1X3ei7i6gTDq8LBvspfXpPY9
         g41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679977175;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNQHPxdZ+Cbyy9oETw99m/xvPB3qYGRr2tA758CH77k=;
        b=FfdeQH7qa+KUdx9hcmhvl6TMHM52EOOQ98RwH8NAVXMg+tkYwvAR3XZOHIQPOc9b4q
         UljZoLiHDhXSBsaeZQubdhoSONb7Bnl91mnMh3gZn4La8Idn95sE7eBYcmkD4IoX5Pe5
         8e+8bJwurO9j+Jmds1tr0YPPSJKZZTasseZ6mK/V8PDYQC3wzvbL5cHGsH34O9susFbU
         KIJhPDh3R/dPfvHwfLLzoZWMNaKeUmtzWSetJkFBQFZftMbY7iMfitz320W2WNlzJW3E
         et8DQ3sijpj80UXVAiUeD6DYERAFyMB8iZkeytw9LPNWi/3WyW8PXTOfPWP3qBTE4I+V
         QwAQ==
X-Gm-Message-State: AAQBX9cQ5/cRR7lvCHF6BU+55P0ZLJBvR7l7Jy/0NZLV0/b4yzXKrsBn
        B/2iTMjvtuW0km8dkKYz5vc=
X-Google-Smtp-Source: AKy350bf1zf9Iaq4wCcQD/syqdv5qD3A1VslKm4KkXWPgXTIzNm1bdO5cGvpqLg7Qamn5nN93s5Tvg==
X-Received: by 2002:a5d:63cc:0:b0:2d1:14fa:8048 with SMTP id c12-20020a5d63cc000000b002d114fa8048mr10944620wrw.39.1679977174886;
        Mon, 27 Mar 2023 21:19:34 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id b7-20020a5d4d87000000b002c707785da4sm26408671wru.107.2023.03.27.21.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 21:19:34 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 4/4] sfc: remove expired unicast PTP filters
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
References: <20230327105755.13949-1-ihuguet@redhat.com>
 <20230327105755.13949-5-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <b1cb1f82-d5db-af2b-ceeb-956501abc639@gmail.com>
Date:   Tue, 28 Mar 2023 05:19:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230327105755.13949-5-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2023 11:57, Íñigo Huguet wrote:
> Filters inserted to support unicast PTP mode might become unused after
> some time, so we need to remove them to avoid accumulating many of them.
> 
> Refresh the expiration time of a filter each time it's used. Then check
> periodically if any filter hasn't been used for a long time (30s) and
> remove it.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
...
> @@ -1378,8 +1394,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
>  	rxfilter->ether_type = spec->ether_type;
>  	rxfilter->loc_port = spec->loc_port;
>  	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
> +	rxfilter->expiry = expiry;
>  	list_add(&rxfilter->list, filter_list);
>  
> +	queue_delayed_work(ptp->workwq, &ptp->cleanup_work,
> +			   UCAST_FILTER_EXPIRY_JIFFIES);

Why not +1 here...

> +static void efx_ptp_cleanup_worker(struct work_struct *work)
> +{
> +	struct efx_ptp_data *ptp =
> +		container_of(work, struct efx_ptp_data, cleanup_work.work);
> +	struct efx_ptp_rxfilter *rxfilter, *tmp;
> +
> +	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
> +		if (time_is_before_jiffies(rxfilter->expiry))
> +			efx_ptp_remove_one_filter(ptp->efx, rxfilter);
> +	}
> +
> +	if (!list_empty(&ptp->rxfilters_ucast)) {
> +		queue_delayed_work(ptp->workwq, &ptp->cleanup_work,
> +				   UCAST_FILTER_EXPIRY_JIFFIES + 1);
> +	}

... like you have here?  (Or vice-versa.)
Other than that LGTM.
