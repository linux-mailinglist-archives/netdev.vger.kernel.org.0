Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AB35A5D55
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiH3Huj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH3Huh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:50:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB7B61DA1
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:50:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b5so13027035wrr.5
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=64wgGbs0DBfUpPziVS9x+n1HKy442DoGh/y/cbZpGow=;
        b=aspiewfm4qYEQeCK14i0vjKBaQqMKjiS8W6zjN6bQEXCNWS4/yVuhiY4xPgOPTEV14
         5L7EFuBnZ5q9H3Bq19I9C2MuB86oN9hs5+UlOoldzKKYZTAV2+r/PGXsPZIz0tz+Dguz
         oOLdlqDmQ+5QwRe26RAd25YhCDEbLQ+5pbKO/rrJG8c4aWUDE20mY9hAD4biCOURyNvv
         EdgZkuBg1bPZYA1hhQPGIgfUtTKQZU/WOAlmTDBxXfETuvOic/rSGK2rmKOwc1ZbBnqn
         +dmpzj7PQCCwECfGYpVv86SG8ARk4Cu8ypT9z40TenOKgdrevcQktWsBteGEOw0QHeAI
         IRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=64wgGbs0DBfUpPziVS9x+n1HKy442DoGh/y/cbZpGow=;
        b=sx2ALSpgrlfkxf3iB+Mlcw/DEYAdLS8mxYF24LZT686jvxJXCir6qJy3h/ZDzu4Y8Q
         0K21N6c61zNOqqepSXXfJH8/weWEWhjrM4XQJr8daMaLTCXHZGYZWqFG/2sCVQe9HYFP
         ufCakkYPeFlWIVXUyXHmc4E1LSwwvbJ+mc6pMJDbXTWpvI73R9xfWPOTkYhgXzQUnNoM
         tRvjVP+japrGPRnaRk5sqniVRh5gllRxu2lxo4nk04s0IUNc0/He8Zv6rrItSkkqOtzB
         U+u3jHR2PalhYSGVPA26aDIZMbBZv97mPcncEPoDv6+mAvacEOPbfdmcbUojJ6OxKwot
         CdSg==
X-Gm-Message-State: ACgBeo2VM+q0nayCE95LqU7nrBGC9OJrmCrcmIFm9A/0dCGZCnpWJUZX
        gBS+ktCnlRyXiiD6eCK/tbfOxg==
X-Google-Smtp-Source: AA6agR4xLgFjvDhcocc53NlmhYrEo+99Iy9Oz0w5V7HGLbZwTvFLtw1NzepizyJXuM6iDGN4J29viQ==
X-Received: by 2002:a5d:5848:0:b0:222:c8cd:288 with SMTP id i8-20020a5d5848000000b00222c8cd0288mr8176652wrf.34.1661845831991;
        Tue, 30 Aug 2022 00:50:31 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id cc2-20020a5d5c02000000b0021e4bc9edbfsm9296249wrb.112.2022.08.30.00.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 00:50:31 -0700 (PDT)
Message-ID: <4945e90a-15df-174c-eaea-f73be4d73dce@smile.fr>
Date:   Tue, 30 Aug 2022 09:50:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] net: dsa: microchip: add KSZ9896 switch support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        arun.ramadoss@microchip.com, Romain Naour <romain.naour@skf.com>
References: <20220825213943.2342050-1-romain.naour@smile.fr>
 <Ywfx5ZpqQ3b1GMBn@lunn.ch> <7e5ac683-130e-2a00-79c5-b5ec906d41d1@smile.fr>
 <20220826174926.60347d43@kernel.org>
 <5628a48f-b521-a940-63a0-52f8db0d2961@smile.fr>
 <20220829220715.10b707a2@kernel.org>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <20220829220715.10b707a2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le 30/08/2022 à 07:07, Jakub Kicinski a écrit :
> On Mon, 29 Aug 2022 09:20:06 +0200 Romain Naour wrote:
>>> It's pretty common to use a different email server than what's
>>> on the From and S-o-b lines. You can drop the second S-o-b.  
>>
>> Thanks for clarification.
>>
>> Should resend the series now or wait for a review?
> 
> Resend, please.

ok.

> 
> Looking quickly at the code it's interesting to see the compatible
> already listed in the DT schema but the driver not supporting it. 
> Is this common in the embedded world?
> 
> That's orthogonal to your patch, I'm just curious.

I was surprised too about the compatible being listed in the DT schema but being
missing in the driver.

AFAIK, the DT schema was merged in 2019 (kernel 5.1) but the corresponding
driver patch didn't pass the review and no further patch was sent on the mailing
list for the KSZ9896.

It's true that the KSZ9896 is really close to the KSZ9897 (only one CPU port is
missing) but the driver reject this device due to a mismatch in the check
between the device id and the compatible. I tried to workaround this check but
the driver really need to know how many port are really present on the ethernet
switch otherwise there is a kernel oops.

Best regards,
Romain

