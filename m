Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8434FB402
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 08:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiDKGxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 02:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245083AbiDKGx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 02:53:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A9E19015
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 23:51:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id s18so6325110ejr.0
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 23:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7Slat8Otwi8YD3f2O6U1F4skSs07T3wtKnKLozauCy4=;
        b=QzqlKicApRIj3OGzoU/T4/bSMF3g+AW/WIQtjjBt7B4rsk7m7Vroa7SEnODkM7EMxM
         F9B37vxcvZEYzX700IdMdxOfFB0V66SdSCTWEfFS12nu7GFDe2sYGopdLqcK48xpXY9h
         YG+LQMQkHZ8vtBhG35qailH/T6VLkRhQaN5El5AaX9oLut8RcJKBomnMuweQ00XQv4J9
         H++a+vQvcXMXayQi73jUwIE4IXLk6qqEaakWxq9zu93++DpNV75jSdMBvz57O6G8kI5/
         Wbia7Hgu5cbECPCw3C1ZacNCQBg+CgUJaO3nfWtv1O4oPjuiBnejVC99V/HjiEThYbPi
         B1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7Slat8Otwi8YD3f2O6U1F4skSs07T3wtKnKLozauCy4=;
        b=cVZMTG/Ae/5WXr/VHjyYnufCTIc1BzZXIKeGAMjhADheAyII98HEcVGUOXXhOTyB71
         vZXLnMnMcp3msFP+FEpfItog0MpHEHitW3VSnQ0AU4QhBCrg2wR4bezpBSCcyKVd7iPI
         Tc/0fThVGbJhsLOWuK6n+SXCWSpTa/mgtWxuaWLl7MkoQpZyeMr/0PhS+6PPIeuXYIh+
         J4YQbS/D2U4NDTlMaa6ALwHJ/doenqakQMmYigLU1ptNz81mY31dExnmz/B5kg0fsvpl
         RZwnxjnVYi4vyplvrCrQ54gcY7e7JFTPOP3volBeeT7ReVkXLuRNE4rInbDaLA6iYQtv
         UldA==
X-Gm-Message-State: AOAM532A+PgOym2vNDf3gzi6Q9kUmGWniytmSz1lV9zYRgUyGWi8k6l8
        CPTJDYTHcBqyRFc3Btpr6wLlqQ==
X-Google-Smtp-Source: ABdhPJw80eetpL8taacvAB0OdQVHJpvJav6Fqk5macXwWAZsg+WzBeBsLYL6FxbP/u6/35PkMUcTiw==
X-Received: by 2002:a17:907:1623:b0:6e8:8678:640d with SMTP id hb35-20020a170907162300b006e88678640dmr5011923ejc.189.1649659872995;
        Sun, 10 Apr 2022 23:51:12 -0700 (PDT)
Received: from [192.168.0.191] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090679ca00b006e888606ce3sm1489235ejo.16.2022.04.10.23.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 23:51:12 -0700 (PDT)
Message-ID: <37416e93-5ccc-79c9-b340-356fcac0ec51@linaro.org>
Date:   Mon, 11 Apr 2022 08:51:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V2] drivers: nfc: nfcmrvl: fix double free bug in
 nfcmrvl_nci_unregister_dev()
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
References: <20220410135214.74216-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220410135214.74216-1-duoming@zju.edu.cn>
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

On 10/04/2022 15:52, Duoming Zhou wrote:
> There is a potential double bug in nfcmrvl usb driver between
> unregister and resume operation.
> 
> The race that cause that double free bug can be shown as below:
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
>      ...                    |         priv->fw_dnld.fw = NULL;
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
