Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13483987B7
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFBLMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:12:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52655 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBLMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:12:02 -0400
Received: from mail-ed1-f72.google.com ([209.85.208.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1loOlO-0004Tu-Am
        for netdev@vger.kernel.org; Wed, 02 Jun 2021 11:10:18 +0000
Received: by mail-ed1-f72.google.com with SMTP id v18-20020a0564023492b029038d5ad7c8a8so1189086edc.11
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 04:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GM346qMDm5SkBVsnz+0MTRWteUg3MTSMm7l18tLMkIc=;
        b=DmU47cOmK6ypUDUPaFnqbzKr+W8B+LI4+fWVzuu0je8+g/5WoGzJH1VG7GjpnnWBMA
         Ck3Pi3rXoEtN/+QGzVlFMVbT3eUNg666UiqGxAE59ZlLOq/D09b8bUPBBtRl4BK6iHWV
         Gmesx2FoCjkXlSKKbLG9KEPKQLZLorDZsgXAJD8cJR1wvpPaVB93GHM6G9DxAYl1VVWh
         4L5nwUMDqbparXyOHPPfFL/mMI78EbahAy4LjxNnxB6Sqo9MuiyU+AbXj2ePMlpg62rL
         zwZS9x27vVlz5JuTAb2bqY0xbW7F7GVJkWWUqPCh8bFLnmHi1BVgDHJk+fObK1AmprPx
         t+Vw==
X-Gm-Message-State: AOAM532gJUzyZ8e70gzAtB0VzSIu5sOafTsxZEpchGRiatLWJni9Qs7a
        gzaPpsH5YqjKt6TLvqcNwbt5ujiADfFimGArHU+h1avep8LmDefQcd1FyaelCjicrzxGJv420V5
        CMx5UdzufSxDYDlqMjI2Pk6UGEcQPDL3LTg==
X-Received: by 2002:a50:fd13:: with SMTP id i19mr13052915eds.280.1622632218081;
        Wed, 02 Jun 2021 04:10:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw06pkyMIjDmtQIx52ngcNxG9a4Pd49N7BCx77O2/Snm6f9UtSwWihRBF+HkFpauz9Ft3wqoQ==
X-Received: by 2002:a50:fd13:: with SMTP id i19mr13052906eds.280.1622632217929;
        Wed, 02 Jun 2021 04:10:17 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id d24sm1142127edp.7.2021.06.02.04.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 04:10:17 -0700 (PDT)
Subject: Re: [PATCH] nfc: mrvl: remove useless "continue" at end of loop
To:     Joe Perches <joe@perches.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210601160713.312622-1-krzysztof.kozlowski@canonical.com>
 <5780056e09dbbd285d470a313939e5d3cc1a0c3e.camel@perches.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <c3641235-6cd0-99dc-2e4b-c61875bdb52c@canonical.com>
Date:   Wed, 2 Jun 2021 13:10:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <5780056e09dbbd285d470a313939e5d3cc1a0c3e.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2021 18:30, Joe Perches wrote:
> On Tue, 2021-06-01 at 18:07 +0200, Krzysztof Kozlowski wrote:
>> The "continue" statement at the end of a for loop does not have an
>> effect.
> []
>> diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
> []
>> @@ -325,7 +325,6 @@ static int nfcmrvl_probe(struct usb_interface *intf,
>>  		if (!drv_data->bulk_rx_ep &&
>>  		    usb_endpoint_is_bulk_in(ep_desc)) {
>>  			drv_data->bulk_rx_ep = ep_desc;
>> -			continue;
>>  		}
>>  	}
> 
> I think this code would be clearer with an if/else instead of
> multiple continues.

Makes sense. I'll send a v2.


Best regards,
Krzysztof
