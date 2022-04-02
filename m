Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515854EFFD9
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 11:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347466AbiDBJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 05:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiDBJDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 05:03:42 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867251697AF
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 02:01:50 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r13so7249979wrr.9
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 02:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mSsp3gulvuPtfic8HEdbySJNKTs7kkn6JpO5CVU05R8=;
        b=wvjO3DKxDeUzdJ++d94HjzVRMTyJD2I7OhuEQg4IspHKnMq019uoY4rOKkD21q8C2h
         ZwVakuZckVwrh0jYhTiuWHQpqVtA0rGwj5eWI1VngDq94MmVVcMGIqvXhZ8cbYT1BT/2
         QfqoN0KbPVVusaErpDM3anW1HiAks4NM97OCgVqGuEv9pte9sM4TSHG5lkYfg8kYddH9
         GyhFIFsd2xPFsFairIgXTKsEjp6fDoMCjsj54BlCIs2Y8uxkEwodCW/XmWqwEIEqzLrb
         zDxxvIGPkLr32ju+gaUSULa9R9VI9jqkizES2UbPAJ+qogt8tIoB0dm6MujJ49hg0M3e
         7gVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mSsp3gulvuPtfic8HEdbySJNKTs7kkn6JpO5CVU05R8=;
        b=C+VrWXgzOmghl/CFc5nLx3aQLGLXwVF9yf2YA/yw2pQBjhfb+0eFR0wlL68B3ZgKgZ
         7S6h8NODVzPXlOtXo/6di0kzsDe6VELA8btTU3KZDQp4C81cdABSJ5jYczEG3KydHfMf
         MGY0hiKxc9j0Ty97sbwV4cciR2s3v7giOSF0Ta2kCzMz7stgro+kAwiozJCAWX6vyCTP
         ee2cvrJg2+sJ2SEvU29OMDh58w5EbYctbwXeKzg8dJALA9oAbibYZ3yfSlV2Z/rL6S7K
         UpsBxj6vkneu/Bmx8/X0uAmgzNBCPwW+KFe4PG3LYJAS+YqW79g/873UpuHePQZjuDpe
         yj3w==
X-Gm-Message-State: AOAM532WE/rnweE0rX3s1lZHl14OSH/ll8d6fQ2Z6g7TeGssj+Han+jF
        /fkPVdITDprtVIDFlLl++m98+QUwnRLS7xB8
X-Google-Smtp-Source: ABdhPJwbqrLf4swLnIL4kj3OCg0lX0HdnBKRPCMPxOABdZGi9J6XvizOyqZuiUwoVQkI25UrqAMSCg==
X-Received: by 2002:a5d:6452:0:b0:205:b196:4a9a with SMTP id d18-20020a5d6452000000b00205b1964a9amr10428211wrw.655.1648890107117;
        Sat, 02 Apr 2022 02:01:47 -0700 (PDT)
Received: from [192.168.0.170] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id bh16-20020a05600c3d1000b0038ceba454f9sm3780506wmb.20.2022.04.02.02.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 02:01:46 -0700 (PDT)
Message-ID: <6bb1d5bf-7ee1-c559-aafc-98664b9519dc@linaro.org>
Date:   Sat, 2 Apr 2022 11:01:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/3] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION
 handling
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@chromium.org>, netdev@vger.kernel.org,
        kuba@kernel.org, christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
References: <20220401181032.2026076-1-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401181032.2026076-1-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/04/2022 20:10, Martin Faltesek wrote:
> Error paths do not free previously allocated memory. Add devm_kfree() to
> those failure paths.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---
>  drivers/nfc/st21nfca/se.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
