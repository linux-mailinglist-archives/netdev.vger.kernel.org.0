Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471654FAD11
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiDJJ3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 05:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbiDJJ3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 05:29:22 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BC92F38D
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 02:27:12 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 21so1601931edv.1
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 02:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MiKcNgHPysVksAeiUPuLNSzzsqdmSQxn0sjGO4AtJP0=;
        b=y2vLQ6v7uwVSrmTro7v2rSCzi/+xfyGVXRmFz3FKu10pW1feN8g9Y4heo6MJeYZTYc
         oJqp4ac9J+ysPk7OfWevr/Wc+x5kWNz3t1O7JMz8puxj/LpEVFo1pyw1bVJqobpp4Dov
         DumM3XgwPWETQ01syNldCAAzEdHwpEyJ/D+XvTFGSHdkvl9N5rAfm7FTrmqcfGk6dMWv
         ik+GWgQYootvDbOkpVQ+NeNca3sLFd+3D/Vo6A09ieyXJm2qgms+/DKXc/sWP9y/Mub5
         rLpEVQmnatsBNnKkSdaG5YO8L/T7fxBoHJvDwiqqUOD+CEiHfbt4l6FBRfKpOW5MmgpR
         CLJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MiKcNgHPysVksAeiUPuLNSzzsqdmSQxn0sjGO4AtJP0=;
        b=ZZug23so+lC+X++iZ30GibZ4+uDHt5WIOnlPQxTtF9z9xs+0r4xONu7pqCBThYda6m
         cr4Sv/j7333WSzjWCTXYqZPIri1OGuPFspZ+UVYcpXATyAdV5c8oo4kJpu8mCqDWDcPs
         cFj0IXTZdoLh2TvgNNE1ESDggXBlh6cj2xq3r0XfHJk/mnFv0JWPLdxdIuuB0IrDngYi
         DJX4/TCLlryr+65GcAC/BWnedQ1Rq6GVw8oqsjMWV2dL+Ea2O15STXhVh4DXOS6NcOzn
         u+1/WLXLP2BwixR8dyVPhRXQkiY84mEqFIcsNQ/ty9e0XA5IPHIsybydTVrbtIDKyIH7
         3OGw==
X-Gm-Message-State: AOAM532EhtyK4j9vyAFUaslKb0TdgoJmbTeg/9QA+R07u/T/1J5MhhpS
        SX81Jxerl3FN6mQEEJEU8ygPdw==
X-Google-Smtp-Source: ABdhPJxCTGzhXew8mIXy+074j24ZWgxYnxXB9sOqvAN6sr31TiG0AMPoBinlq3rB1g3tMitZYIBOeg==
X-Received: by 2002:a05:6402:1695:b0:41d:6b06:f81 with SMTP id a21-20020a056402169500b0041d6b060f81mr6272342edv.98.1649582831145;
        Sun, 10 Apr 2022 02:27:11 -0700 (PDT)
Received: from [192.168.0.188] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id x3-20020a50d9c3000000b0041c8ce4bcd7sm12026414edj.63.2022.04.10.02.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 02:27:10 -0700 (PDT)
Message-ID: <6781b193-cd3b-e5ab-ce99-263edd4146bb@linaro.org>
Date:   Sun, 10 Apr 2022 11:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: nfc: nfcmrvl: fix double free bug in
 nfcmrvl_nci_unregister_dev()
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
References: <20220410083125.62909-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220410083125.62909-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04/2022 10:31, Duoming Zhou wrote:
> There is a potential double bug in nfcmrvl usb driver between
> unregister and resume operation.
> 

Thank you for your patch. There is something to discuss/improve.

> The race that cause that double free bug can be shown as below:

Your patch solves the most visible race, but because of lack of locking,
I believe race still might exist:

   (FREE)                   |      (USE)
                            | nfcmrvl_resume
                            |  nfcmrvl_submit_bulk_urb
                            |   nfcmrvl_bulk_complete
                            |    nfcmrvl_nci_recv_frame
                            |     nfcmrvl_fw_dnld_recv_frame
                            |      queue_work
                            |       fw_dnld_rx_work
nfcmrvl_disconnect          |
 nfcmrvl_nci_unregister_dev |
  nfcmrvl_fw_dnld_deinit    |
   wait for the workqueue to finish |
                            |        fw_dnld_over
                            |         release_firmware
                            |          kfree(fw);
                            |          no synchronization //(1)
  if (fw_download_in_progress)
    - no synchronization, so CPU sees old value
  nfcmrvl_fw_dnld_abort     |
   fw_dnld_over             |         ...
    if (priv->fw_dnld.fw)   |
    release_firmware        |
     kfree(fw); //(2)       |
     ...                    |         fw = NULL;

The kfree() from (2) would still free old value. Even if fw=NULL happens
earlier, it is not propagated back to the other CPU, unless there are
some implicit barriers due to workqueue?

Is it safe then to rely on such implicit barriers from workqueue?

> 
>    (FREE)                   |      (USE)
>                             | nfcmrvl_resume
>                             |  nfcmrvl_submit_bulk_urb
>                             |   nfcmrvl_bulk_complete
>                             |    nfcmrvl_nci_recv_frame
>                             |     nfcmrvl_fw_dnld_recv_frame
>                             |      queue_work
>                             |       fw_dnld_rx_work
>                             |        fw_dnld_over
>                             |         release_firmware
>                             |          kfree(fw); //(1)
> nfcmrvl_disconnect          |
>  nfcmrvl_nci_unregister_dev |
>   nfcmrvl_fw_dnld_abort     |
>    fw_dnld_over             |         ...
>     if (priv->fw_dnld.fw)   |
>     release_firmware        |
>      kfree(fw); //(2)       |
>      ...                    |         fw = NULL;
> 

Best regards,
Krzysztof
