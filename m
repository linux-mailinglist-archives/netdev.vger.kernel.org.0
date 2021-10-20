Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17843458D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 08:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJTG6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 02:58:09 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:50952
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhJTG6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 02:58:08 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1D0D43FE01
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 06:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634712954;
        bh=vDbodlL+sCRBOe1NJEZmj/bDaElzNmMuyTFDojIVq1U=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=en23U8jZhkYWrbkoEdNQ7QREWV/WAeapcNt4dlQLc8WzQB/WNDecD9yDB81mcwaSD
         U9EOGU6pHZGme0iVtIJ0gvpvvIsp29338w7cZz4TSV4aAgZgBIPd3pHM2lbmwogsHo
         lSwN4Q/jmpQhwHwgm4a88VORqCubJXvBPGZqt1ZbYAXRnwf0/7zWbIrv4iaqOa+0AB
         lU+WEfPPJ1UfcAywFtuQznCvG4dUqra37lNYs6m2TUVmZyxaUEs3Rk3pR9bXwG/l0l
         S1pIoXZE8/EwMEo/ZDBbv6YIgjZMy4v2zR6aLRMzLYCzM4ClbJkPC3SimoQ4+RHXj5
         55MqSFeJ40u6A==
Received: by mail-lf1-f71.google.com with SMTP id z29-20020a195e5d000000b003fd437f0e07so2678588lfi.20
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 23:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vDbodlL+sCRBOe1NJEZmj/bDaElzNmMuyTFDojIVq1U=;
        b=cc2pXeCFUvau5l3f0yc7lwsSCWllHER+FOWOBPaAqixq8aWxTp+I3ZHT1rB/Dy/hCI
         4UhrH2SLVE7npvOTX1H5Ab8WRH2B9w1uGZ08mXX1fO38tCFglhnpNTTyhv7y5aJz6p3l
         3O7/dL6MaseojxqM+70NUsPRcMV+hWYlrz0etp2sn2InV757o3PXoU2MgXwTpm2rPftp
         +JzaSmI4HW3BOEtfepLkp2VwklNb++5FQ0UFfi4j2z29BpzjbHX42PIk3V8slOzeB/Vn
         /GfRSjHVyH3iU9yjRDz5WJ4MHz829ZkiRlFjn1S21TyfH/sUi1PyOCuhG1aR7hMErg+S
         4hxQ==
X-Gm-Message-State: AOAM530fitBgI8gGzeR5eQ/sxJZnx1aT8DKtPzy9A09/q+oJNjuIA1v1
        mHmcKIGrMlNC/le3WHE5RoBW4qfF3cmCqA89YRQrqQLbcLfDn5fZszGJ1C97oKUBMbUq8CUPV49
        iVCS8k0x7FNm0kncw8jN3SQIXiMUvlBWR+Q==
X-Received: by 2002:a05:6512:220d:: with SMTP id h13mr9965113lfu.623.1634712953097;
        Tue, 19 Oct 2021 23:55:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQror5EwilCR4ZUwREWsS50INzQatVQZXkD8PM6xcPRc7/pHZsnShL1UwBgPTM7ApRt+eFfg==
X-Received: by 2002:a05:6512:220d:: with SMTP id h13mr9965103lfu.623.1634712952948;
        Tue, 19 Oct 2021 23:55:52 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id f16sm123456ljn.19.2021.10.19.23.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 23:55:52 -0700 (PDT)
Subject: Re: [PATCH] nfc: st95hf: Make spi remove() callback return zero
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
References: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <da88faf5-33db-b20d-e019-7cca6779b626@canonical.com>
Date:   Wed, 20 Oct 2021 08:55:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/2021 22:49, Uwe Kleine-König wrote:
> If something goes wrong in the remove callback, returning an error code
> just results in an error message. The device still disappears.
> 
> So don't skip disabling the regulator in st95hf_remove() if resetting
> the controller via spi fails. Also don't return an error code which just
> results in two error messages.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/nfc/st95hf/core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
