Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29125540479
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbiFGRNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344575AbiFGRNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:13:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61137A5012
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:13:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg6so16711914ejb.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=l5jecJ7m6j6+wfJuaqL9TGi12DzOxHHnCuf6mP4CPsk=;
        b=w7M+C0ahijC0B5bCeZUW56ccB+U14/4XaFNlbPajEWNY4D3QmZd+Z/NAU9yzJyYr4U
         R7Jx/ojQ8aPKjojbyH/h1fab4Md0weTfxuTxVCpLeZVanf2ezcYP0pfFLiNtfQjfXuQ4
         jLSq1U4egGPuSPIiN4zbA8XSua49XD0PMrAsJ0eapthyJQSSuHJWohuQBjrJSDZxaojC
         V6U+tchZeJ+U9/fISn3ka080i+l4dupD0mPfUZ8+fjI1mXJ2bWHreq9cESDHxTSuz2uT
         1fBFpmEaljN9m2CUBO8zQ5kHPGdGaeZ39kt+ioHEXadSFWbhxev4cYsEbLoCZZCMRUg5
         hkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l5jecJ7m6j6+wfJuaqL9TGi12DzOxHHnCuf6mP4CPsk=;
        b=NONxqfAo4PWwpnKfDQGI4yF3czGZIxsE9WVH/5es4OSRdIZ55fjTvGgc6qmw1At9nC
         7GSEEnKeHpwEqcr4TQm57G+G/bZXu6EKaecATeTXrn0nPw7AMxgzpH1yYE46rglxV97C
         ku2d1LoiGx4ClVxlJgjQ2Tf5uEYgwOSy3j3+PKbdweqz6go3otHWKKPCHk/tWrsQEueZ
         nTCACThbst+wAAzDS+bWuW9z9Xz/xVtINpZAw9cd57o9RlaxbgP/dsAdq0yIpFQPRxme
         YlHSP3VPMEWBLhSVODTrH+5nwmThLYBLD+zT8pvlIzH/R6GtuDrNSI9UmCCOxK4eepZe
         GYVA==
X-Gm-Message-State: AOAM530KcrkfgzPxgEdd2uEx2LBVb6eTV7Vko6VMU2PKOabSA4BEBUFg
        oSr2Fs4p5ZDwzUWq0WGWmNAVSg==
X-Google-Smtp-Source: ABdhPJyW10sSpBHf1hhEgmGHXRYXoBPu1ntTLE8Y/VNzIW34xyZ5qg5+Mno2iViaMjRzgjN9HrJCdQ==
X-Received: by 2002:a17:906:7944:b0:6da:b834:2f3e with SMTP id l4-20020a170906794400b006dab8342f3emr28510928ejo.353.1654622019855;
        Tue, 07 Jun 2022 10:13:39 -0700 (PDT)
Received: from [192.168.0.186] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id a23-20020aa7cf17000000b0042dc882c823sm10738047edy.70.2022.06.07.10.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 10:13:39 -0700 (PDT)
Message-ID: <e24f904b-0eaa-dd48-2647-8aaee510beca@linaro.org>
Date:   Tue, 7 Jun 2022 19:13:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net v3 1/3] nfc: st21nfca: fix incorrect validating logic
 in EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        martin.faltesek@gmail.com, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, sameo@linux.intel.com, wklin@google.com,
        theflamefire89@gmail.com, stable@vger.kernel.org
References: <20220607025729.1673212-1-mfaltesek@google.com>
 <20220607025729.1673212-2-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220607025729.1673212-2-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2022 04:57, Martin Faltesek wrote:
> The first validation check for EVT_TRANSACTION has two different checks
> tied together with logical AND. One is a check for minimum packet length,
> and the other is for a valid aid_tag. If either condition is true (fails),
> then an error should be triggered.  The fix is to change && to ||.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---
>  drivers/nfc/st21nfca/se.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

https://elixir.bootlin.com/linux/v5.17/source/Documentation/process/submitting-patches.rst#L540

If a tag was not added on purpose, please state why and what changed.



Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
