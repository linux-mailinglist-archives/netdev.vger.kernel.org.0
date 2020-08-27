Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6080253AE1
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgH0AJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgH0AJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:09:09 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DEFC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:09:07 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v15so2045831pgh.6
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=sCDkWfuRrzyzZ2AxFN5fYL2CC8I1JuClW9TnYN0xx2o=;
        b=Xiuel13dBAMAaThOfDU5hsqfeLjieZD2Nma3ua/QBFkoNG6FeAPYH9eG2ur5xYeXw+
         uSw+sUKFxnpwK3VGn8xiLPYqXQ21jvKmXyhz0MnWkJo6+yocrE6x3TKO9WAZwYD2G1A5
         FcvRyeL2+FgrOFn364BdBQ44dvYYpRpij+QH36o3+erSLHdeVkMP8AdlwzXgjVSmlz46
         fm8c/oCZUpiSqEIeyF7YtYuzTfwL5ODOkCvVIIpX6E3XuUmLkxDZtlvpVJCrn0rXHIE0
         dvj52mWBLZCqx6Ucuzpp1R5TiEaUsJIOS6jUpsIaVJkq1RDjoBBAQhAvdI2xKtvh/mmH
         GXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sCDkWfuRrzyzZ2AxFN5fYL2CC8I1JuClW9TnYN0xx2o=;
        b=HimXeQjVrKZqXSCRle1RNBfnZIHSmi6DvqLlsR/0hKNs0XAlQh1NNDFRzwBsY/Kcoy
         Qhf77aiFU1qaAzpktLUTLTQV4Mz/6UVlvyfVvgKCRXRK6QEi1z/nHjeY9mQWvavIqyPI
         IOu2TqIrA4SP3q2jWmgYwhOVNFt1spQIpjMRDRI9H6Oe1UHfld8JmxYvbkhtI8HzWfap
         yumE3pSi3r+NxF9iv4WiHcl4DbViJrlTiWe/sl3LmPlqMxpthxSVfJ1GfPINWZKEiPKY
         kHyKqEsxRr5/NWHXTDarVrKihRZnTePHCoTwKK9vNaescdhy7E0a1dxWpRNUEFELTzyg
         buKA==
X-Gm-Message-State: AOAM533XuU60pGZpCik//p9KvqydfWlxStP9talfcJfPrYzZ8lEJmvki
        PGvkdWSruZtbvD1OW6Zwf+VdIw==
X-Google-Smtp-Source: ABdhPJybRUGf8L2cUG0yMCX9XtOodxulRvaH6xDX2ECrO9QgWO0+tPlubF2+g9IFw9B4/Aj2ta+lRQ==
X-Received: by 2002:aa7:9a44:: with SMTP id x4mr2994393pfj.199.1598486947002;
        Wed, 26 Aug 2020 17:09:07 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id a200sm321392pfd.182.2020.08.26.17.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 17:09:06 -0700 (PDT)
Subject: Re: [PATCH net-next 11/12] ionic: change queue count with no reset
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200826164214.31792-1-snelson@pensando.io>
 <20200826164214.31792-12-snelson@pensando.io>
 <20200826141450.532ee89a@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <6318e105-e48c-2d1e-1099-6b3ef428c899@pensando.io>
Date:   Wed, 26 Aug 2020 17:09:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826141450.532ee89a@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 2:14 PM, Jakub Kicinski wrote:
> On Wed, 26 Aug 2020 09:42:13 -0700 Shannon Nelson wrote:
>> +	if (qparam->nxqs != lif->nxqs) {
>> +		err = netif_set_real_num_tx_queues(lif->netdev, lif->nxqs);
>> +		if (err)
>> +			goto err_out;
>> +		err = netif_set_real_num_rx_queues(lif->netdev, lif->nxqs);
>> +		if (err)
>> +			goto err_out;
> does error handling reset real_num_tx_queues to previous value?
>
>> +	}

No, the point was to not change the real_num values until we knew that 
everything else was sorted out and swapped.  However, it looks like that 
could be put right after the queues are stopped and before the swap, so 
that if the real_num change fails we can reactivate everything as it was 
and dump all the new allocations.

I'll work that up and see what it looks like.

Thanks,
sln
