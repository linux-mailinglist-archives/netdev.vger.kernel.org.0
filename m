Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599AC6968CF
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjBNQIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjBNQIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:08:34 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BC21AC
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:08:29 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id m10so7285782wrn.4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pf7ytvlBLZENcHNKpeG/2R1MP8HKO5bmTvLm57pwD88=;
        b=IFZ5/qfkc4MX9gGABsAHCEzy2KvCIgDGr7GByKEduO5z8OmSo5e2jWCckExB6Dgjt6
         N3m7/Tnq5BEm7SlzMKuCN85SnA//167WmodS6vb5dSQJILPCXnVeZLqBReVGphUgDb7a
         yIatJqgyPMZY18MksfZtLig9/YfsK5Uqx0E+dDbydviTIJ3id47CvgWZ2RC5g4iITHKY
         GNh63rPr6axL/pBqZQraQ8dSV0TO1zzclx9FBGbKXtqqFMcmrka5ZtWgH0tApph9GWEW
         RnhItsVY5FZyPPhsXXQi3RGuh89q04pFN7V0rk5L0J1xeg/H7G44utwemCgtqeZeZabo
         DAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pf7ytvlBLZENcHNKpeG/2R1MP8HKO5bmTvLm57pwD88=;
        b=hQZW+T41JpQMtvjlKwwULruFNwLYwqMA3IiDNtiEbfoyVCP4s95ncOxxI1zgf/oHk4
         cackAewQmY6fftqQXuS1LoN+wCZJgPXyYogxP/kwBICjaS8LMNrd1hTiIbrkc3qWfTo8
         ZIafW5j0LZnM4HAOCbaItTt+dYzWWjA5uAi0GjDR7Tso+OPBZ/ooDmQ+O/pI+i5qB76s
         mJgXreUQIeqYiJjfObUJ44zQkQ5q7RZWnA8wWSrztvRuTiuEY5fq2StMFqJOu7Is4ixS
         VXWD2r9ThdPIDKUPUvwu33r6raRuSJt/xGfIw0CwATxdfqmyLtE+c623BmQjLj9uSWOx
         4FGw==
X-Gm-Message-State: AO0yUKWmKq/DB32nI59CFRwxJ3DJBMND1ZgRx2jll1nOO8mt/sYCyaV9
        srsWBjjNE99Aw6VGOUS+n/w=
X-Google-Smtp-Source: AK7set+gez3yUbD7cc+k5+ywqus80yHVbogGCsjhnrqopY0pcI1lX5McVgyVdPA6d5MdKOILnUDRSg==
X-Received: by 2002:adf:ee89:0:b0:2c5:5234:882c with SMTP id b9-20020adfee89000000b002c55234882cmr2685709wro.7.1676390908326;
        Tue, 14 Feb 2023 08:08:28 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q19-20020a05600c46d300b003dc434b39c7sm3760132wmo.0.2023.02.14.08.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 08:08:27 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/4] sfc: store PTP filters in a list
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230209104349.15830-1-ihuguet@redhat.com>
 <20230209104349.15830-2-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <85284c1a-d6ab-321b-570e-e9392979ab0d@gmail.com>
Date:   Tue, 14 Feb 2023 16:08:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230209104349.15830-2-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2023 10:43, Íñigo Huguet wrote:
> Instead of using a fixed sized array for the PTP filters, use a list.
> 
> This is not actually necessary at this point because the filters for
> multicast PTP are a fixed number, but this is a preparation for the
> following patches adding support for unicast PTP.
> 
> To avoid confusion with the new struct type efx_ptp_rxfilter, change the
> name of some local variables from rxfilter to spec, given they're of the
> type efx_filter_spec.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
...
> @@ -1311,48 +1320,55 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
>  }
>  
>  static int efx_ptp_insert_filter(struct efx_nic *efx,
> -				 struct efx_filter_spec *rxfilter)
> +				 struct efx_filter_spec *spec)
>  {
>  	struct efx_ptp_data *ptp = efx->ptp_data;
> +	struct efx_ptp_rxfilter *rxfilter;
>  
> -	int rc = efx_filter_insert_filter(efx, rxfilter, true);
> +	int rc = efx_filter_insert_filter(efx, spec, true);
>  	if (rc < 0)
>  		return rc;
> -	ptp->rxfilters[ptp->rxfilters_count] = rc;
> -	ptp->rxfilters_count++;
> +
> +	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
> +	if (!rxfilter)
> +		return -ENOMEM;
Doesn't this leak the filter?
I'd be tempted to put the malloc first, that way in the failure
 ladder we'll only be doing a free, not a filter removal that
 may involve MCDI.

Apart from that, patch (and series) LGTM.
-ed
