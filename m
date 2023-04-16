Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681656E37C0
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 13:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjDPLdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 07:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDPLdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 07:33:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB302D56
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 04:33:18 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-94a34d3812dso526677666b.3
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 04:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681644796; x=1684236796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IrTKJjTJHokz1JVmg6evE//cXzGHX237sfmxIOemnyc=;
        b=PYXUd6RCkeCZcWCdKkNLR6gr10WO5N83tjqEYN48P091LaCpEhglCfP9n9k3YcOFvo
         bUjarQWNOfDp6hsyq1VJKLuzSCkWpxsytPpLPiM3z8U5NngHarI1tfPAqpJhuQEf3KiL
         ffQow5Fya4452h4Q7EekE4xytnJQyYc/OQuABJR8ut3ADAXBKHgnmrwwVdSUdnFv0S2g
         TNYWGWO5wsdl1cnZQs79+zuONSFiSLjC+o7aVgdWVxDEluGWfwSy32PZjMm4QXRmvm6l
         Dqgab2K79nl52msniFuKXlL4Ngp5QaiIadVvaWf9NVY+llzNJA4354A1jPjMj3R+pQTD
         O3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681644796; x=1684236796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrTKJjTJHokz1JVmg6evE//cXzGHX237sfmxIOemnyc=;
        b=Z8VvUbwwi+4UAK4TUWthtkfySzfbsUZeQeXecNgds1trWu1SMmZ4LKW/Kuzc54NZHw
         94nxZ+ED6jkwQhZeblEtcH25fgpXwHW5uM4mAJcCw+kF/ZKcUiEaXMZ7/ofCjqj4taUP
         77C0tGeDed9oMPLKWfAOTXjhwrrl3xII1nJ0K6e1JARjVvri8XBKnpV7QPsX8hwkhQWq
         8OMJtzqZxWOoMPfDkIHDsaGhGOepN0oD1oGGp8+vGbAaFaPnOktQpSPUG0epBhNyCScm
         cHzVQasiIo3UWFxwRZx1iLWbEs2PaoIpO41nBM/dEf3frFLO3wEe2uSqpuNzFUl4AogF
         v1Ww==
X-Gm-Message-State: AAQBX9dnqGSRH7JPG3yK9E7Nx2k9k3UkkRqQ05Z8ew3z3jl5Wvg/GMVD
        Sn1wtA2WlV0tLZ2ESSUhV0c=
X-Google-Smtp-Source: AKy350b52XM5fIWPGjyHTcG+A6++3PP+YftNKHcpFYMcuuJlrXUi71HSyXkoblf54CRagX5X9HEVJg==
X-Received: by 2002:aa7:d44a:0:b0:504:8efb:c103 with SMTP id q10-20020aa7d44a000000b005048efbc103mr12246439edr.0.1681644796471;
        Sun, 16 Apr 2023 04:33:16 -0700 (PDT)
Received: from ?IPV6:2a02:3100:90eb:5c00:c072:8c2c:2c92:c192? (dynamic-2a02-3100-90eb-5c00-c072-8c2c-2c92-c192.310.pool.telefonica.de. [2a02:3100:90eb:5c00:c072:8c2c:2c92:c192])
        by smtp.googlemail.com with ESMTPSA id g25-20020a056402115900b004c4eed3fe20sm4416845edw.5.2023.04.16.04.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Apr 2023 04:33:15 -0700 (PDT)
Message-ID: <1ea8c541-2f96-9a01-4355-fb0c98ddcdac@gmail.com>
Date:   Sun, 16 Apr 2023 13:33:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
 <69c2eec2-d82c-290a-d6ce-fba64afb32c6@gmail.com>
 <20230416102058.GC15386@unreal>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230416102058.GC15386@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2023 12:20, Leon Romanovsky wrote:
> On Sat, Apr 15, 2023 at 09:22:11AM +0200, Heiner Kallweit wrote:
>> Use new net core macro netif_subqueue_maybe_stop in the start_xmit path
>> to simplify the code. Whilst at it, set the tx queue start threshold to
>> twice the stop threshold. Before values were the same, resulting in
>> stopping/starting the queue more often than needed.
>>
>> v2:
>> - ring doorbell if queue was stopped
> 
> Please put changelog under "---" markup, below tags section.
> 
I know that this would be the standard. IIRC Dave once requested to
make the change log part of the commit message.

> Thanks
> 

