Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E485D4C892B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiCAKYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiCAKYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:24:47 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541B156223
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:24:06 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 98E193F19B
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646130244;
        bh=Xjhp/CXOOSUteuBUcGQJQGfNTsSZQGbcPmAbNzxC4NQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=MZCxDQ/CnvCAHxh3L87F9sSvqUAHig+8AKQpvR5rwtRGzHVWF9V1k9g6aDiDVOQUK
         Ytxa3qa4ds1Y6P1dgePbRC15A4ccJE2WSxuV58ydAOZ1uC6BQPl80ZZazi5VGG3DC8
         n8XP3WXZAB7kNicsji8lFQeF4zZnDdi8Qdj9R9sKsJle8Be7AVn1oxBfP9O4xbmPUT
         hRwCxWB2R/fVzAjBXVKEJCKWv+fC2jv5EK/ClDhaQEQkHgEl9x9Nur31f0oUPqabwn
         LI0gYRFwz2whX/o0v8Zh7i6W4ONnmL5dBogD73UgqjQQaWZ1u4HwLKNpgbm+5KL+Xi
         dha17QMl3FlYQ==
Received: by mail-ej1-f70.google.com with SMTP id nb1-20020a1709071c8100b006d03c250b6fso6618314ejc.11
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:24:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xjhp/CXOOSUteuBUcGQJQGfNTsSZQGbcPmAbNzxC4NQ=;
        b=WaQ6H3pbBBWh8dXoB0e/1wMRI0baPcbUPAKbAw53NYsXAPjfz9l1Pgpb4gdIi6b50U
         EJqmOEf3U4+mwTZohmhv9M2I1cvfhS5X0IZIY5OQkyfxUVCffZfaQ49OLsxp2CuncMd6
         rp15Qtse45/Qk1FmXRa+ohXygIT/nsDmX93jtG0PghjD13EgHNOxhoSUs/ma7k+Dol/u
         HWNYZTubB7oXaqw2vZrCM715B9et1NvP1C49o+88nzTXnX2egFt5PG9gBXC4nsEjQymp
         dsnrI9jjJazMtyzNnQWD/kG90KsirMQwsGrcr1U9dW1V6hXaP71r+7X4T5o8EA85IT8d
         zjig==
X-Gm-Message-State: AOAM530JEbgoInjT4I4kPPqsffT+lvBS+O3He6Vn6OQhLcYMPemqZseh
        pckErKnzQIEevFXUqIztGXGgqF71Y6Y5fnbvFOuVWB6NHGtueoIC8/5jmeG8RMWeDaN6kPQbFbi
        S8Fvzf5SIYSJkpbaSsw4UTBYmbUfDESiYpA==
X-Received: by 2002:a17:907:a088:b0:6d6:f8f9:b15a with SMTP id hu8-20020a170907a08800b006d6f8f9b15amr824001ejc.203.1646130244349;
        Tue, 01 Mar 2022 02:24:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWe/UtN8F4RzBRq5b4m/3WBqmFuFUYvz/vZz9tEnuqk0rT7rK+KwECBeH8+rP48tkDqNED8w==
X-Received: by 2002:a17:907:a088:b0:6d6:f8f9:b15a with SMTP id hu8-20020a170907a08800b006d6f8f9b15amr823986ejc.203.1646130244136;
        Tue, 01 Mar 2022 02:24:04 -0800 (PST)
Received: from [192.168.0.136] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b006b2511ea97dsm5174727ejc.42.2022.03.01.02.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 02:24:03 -0800 (PST)
Message-ID: <c7fea223-b958-deea-70b2-a649e3cc0ec4@canonical.com>
Date:   Tue, 1 Mar 2022 11:24:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net/nfc/nci: use memset avoid infoleaks
Content-Language: en-US
To:     Lv Ruyi <cgel.zte@gmail.com>
Cc:     chi.minghao@zte.com.cn, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        zealci@zte.com.cn
References: <664af071-badf-5cc9-c065-c702b0c8a13d@canonical.com>
 <20220301093424.2053471-1-lv.ruyi@zte.com.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220301093424.2053471-1-lv.ruyi@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/03/2022 10:34, Lv Ruyi wrote:
> hello sir
> 
> I think this way: On 64-bit systems, struct nci_set_config_param has 
> an added padding of 7 bytes between struct members id and len. Even 
> though all struct members are initialized, the 7-byte hole will 
> contain data from the kernel stack. 
> 

That's reasonable. This explanation should be mentioned in the commit
msg. Also just initialize the array to 0, instead of separate memset call.


Best regards,
Krzysztof
