Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50CC63E383
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiK3WdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK3WdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:33:10 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E08E42F4A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:33:09 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d1so29427486wrs.12
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HTTBMT3Ltily5bujTueJXBAjhEv3/Qej3tONjtdAIXU=;
        b=qxvX7OJxTGRHQMjxr8HVYiDODX5CzVA2rnl6ghPPF+OQVgeNb9bgfu2aLGJxj7A14j
         54rHA0f9s42kK+qUegktQmeB0NcxrLsEVaBCw/LkJhC02qdRjDIkIWg8rAFPL3s8sZKA
         ijSryJcyOcYbQneS8eVxP/sEGfQwHCaG6s3jepBSkPFCANr1VZoI4Rh0Vv90APe6LfFQ
         aN2tGZ4VzhIOmkFki7hv+M5ZbS35ZlQKsO6p+1GexALR2p5FxFD5EzR3yx2eQnXQ26j1
         Y4xQZjClqLKC4/N/3GsW8B07W8hh1KMKPzMm2MKIZPHSRQTSM+E2m5uNS8IFgj3sqH71
         CmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HTTBMT3Ltily5bujTueJXBAjhEv3/Qej3tONjtdAIXU=;
        b=oNPDMnU7j7bwLKPNSYI9FCeLh80bREFUG35qsdgnxFpc1yc8ul5FsT1kSb2FDd64gK
         F1lNM1gJdfO5KnF1y7tH6Xon3SJQWgWwiQwdq0NhJ2zrEsZgS2aGPYTSUBo/ddpopGNA
         qIXODzleeQ9vNgX+0FWFv7Z33lflaHHVLpod8S9a3+YSrLXqDpjA7+Nq3hI0Q54ExsN2
         6NBquMnYLw8AkA4zQSkKZ4nlG0MgGG5Mz0mdWLfDeHSKD9nvL3WbjxWqXXXdANmI0PVE
         hb7SZcuebAC7Ol5NWMEAkWo8Wf8qiMoEAKTZtpBUXJx3NIMu+/ekxOT04N/T7LG2brci
         m6Bw==
X-Gm-Message-State: ANoB5pk5NWu/4ej39KxGkAZaVI6L1iPuSCtiCWjosa+TJNEezoqYAwXP
        FvqQEULVZ5jK3sVD5kQLNHE=
X-Google-Smtp-Source: AA0mqf5fcqSf8DP8cVwMx51jlBx+3bNE/bhgLlnABd3d9BS2WzlRHLgxU+gtJ+0WF+J7BkpBznWS3w==
X-Received: by 2002:a5d:4a4c:0:b0:242:322c:c098 with SMTP id v12-20020a5d4a4c000000b00242322cc098mr1550579wrs.210.1669847587911;
        Wed, 30 Nov 2022 14:33:07 -0800 (PST)
Received: from ?IPV6:2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65? (dynamic-2a01-0c22-77d6-e700-1465-fbc6-a2a6-9b65.c22.pool.telefonica.de. [2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65])
        by smtp.googlemail.com with ESMTPSA id g13-20020a05600c310d00b003a2f2bb72d5sm8633698wmo.45.2022.11.30.14.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:33:07 -0800 (PST)
Message-ID: <a2c09a19-02a9-726f-ecaf-2fb087386a72@gmail.com>
Date:   Wed, 30 Nov 2022 23:33:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next] r8169: enable GRO software interrupt coalescing
 per default
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9d94f2d8-d297-7550-2932-793a34e5efb9@gmail.com>
 <20221128190757.2e4d92dc@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20221128190757.2e4d92dc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2022 04:07, Jakub Kicinski wrote:
> On Sat, 26 Nov 2022 15:07:07 +0100 Heiner Kallweit wrote:
>> There are reports about r8169 not reaching full line speed on certain
>> systems (e.g. SBC's) with a 2.5Gbps link.
>> There was a time when hardware interrupt coalescing was enabled per
>> default, but this was changed due to ASPM-related issues on few systems.
>>
>> Meanwhile we have sysfs attributes for controlling kind of
>> "software interrupt coalescing" on the GRO level. However most distros
>> and users don't know about it. So lets set a conservative default for
>> both involved parameters. Users can still override the defaults via
>> sysfs. Don't enable these settings on the fast ethernet chip versions,
>> they are slow enough.
>>
>> Even with these conservative setting interrupt load on my 1Gbps test
>> system reduced significantly.
> 
> Sure, why not. Could you please wrap the init into a helper?
> Should help us ensure the params are not wildly different between
> drivers and make any later refactoring easier.
> 
> Maybe something like:
> 
> /**
>  * netdev_sw_irq_coalesce_default_on() - enable SW IRQ coalescing by default
>  * @dev: netdev to enable the IRQ coalescing on
>  * bla bla bla
>  */
> int netdev_sw_irq_coalesce_default_on(struct net_device *dev)
> {
> 	WARN_ON(dev->reg_state != NETREG_UNREGISTERED);
> 
> 	dev->gro_flush_timeout = 20000;
> 	dev->napi_defer_hard_irqs = 1;
> }
> EXPORT...

Great, you did the most difficult work and chose a proper function name.
I followed your suggestion and put this (slightly adjusted) function
into net core. Just submitted the series including it.

