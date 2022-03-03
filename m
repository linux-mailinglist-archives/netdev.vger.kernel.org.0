Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51164CBE98
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 14:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiCCNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 08:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiCCNOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 08:14:20 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19000151D21
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 05:13:34 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A8CA53F600
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646313212;
        bh=LMY/CePsTOMSqNYl6Ts31E/1/fcnzCoQjKnJ0fOnEQc=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=VXC59FZ/yvUOtxhhfQPWntnmeYqNbP8P+qXIxEI5qW3733+/8ivWZlpgMz2l4ePtv
         UTbVWg98DmW3aBcnKCd4MxhTie5CL3ZYucFR9kS9zXyrQRBVzJPpeitPQ+MYB6JxZ+
         whn1jBPMThw6C/uCMo4ubccxsaYdfw1lxdCiwG3FNKdaqwvuYipDA/LZDFmwhr3kdt
         aznJ+Lp1rrXcifz5UntldxdpgdvI8UvAk6SFX8rMfqGKRDO9Lpk8XAzGW6V9NXjAM7
         xywO808tYrBbaycSLqy0AyRLMen+0Zc1/r5YCjZ0/uOQJmdOCAYdhSrP6W88cI2RMi
         QauhOoCjX3i5A==
Received: by mail-wm1-f70.google.com with SMTP id o21-20020a05600c511500b003818c4b98b5so1320241wms.0
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 05:13:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LMY/CePsTOMSqNYl6Ts31E/1/fcnzCoQjKnJ0fOnEQc=;
        b=ZQwWM5DQs2IgT9WkFkW4V8Hu51vr7UitrQZFOA1GmFr5kQ+pRYtqrvdqoeXskS/zSY
         4GzTiubRLqMxLPJnYogFTGra2remb/sBz5A1N60jRmqdS6ukHwCbvbMRpQY2PwqRF6Gq
         I6PhngjLHtlGlkig9ilHlmENffJxIZj5QSsvXTUipOfJAT5mVSHuyR1DGHeLdrt4OxCG
         aELKqNtvE7EahngsWX3EXAmtu9NZBAweyc9UNw8k/OD1Ysi7wllQ/zKaR04apwEy12n/
         NTRxqRFq6hGZc4THkVt1wiYiOo3XJz6GUMBxHOnVsjCEMQaYg5LO6ryZk/zHniJRgb3J
         wWtA==
X-Gm-Message-State: AOAM5325S2/NDWJ/pBopQ1XiIONnrDhpGr7YoPvghFmGxOpVZz+wdQ+y
        YMjC6NwuBn8ofBn5QvwuwuGNQPyrY3MGaIvpzJLojd1WaH8nPIyjZS3R90eHkjJQWdMhPVfuJQx
        mICD9GF0mGl3cvgSqH1YjgjuucFAIUE/eaw==
X-Received: by 2002:a05:600c:1c1c:b0:381:45b4:3f69 with SMTP id j28-20020a05600c1c1c00b0038145b43f69mr3697485wms.86.1646313212177;
        Thu, 03 Mar 2022 05:13:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvYjeIPKK1xybBBwrybTxPehOwM+dcpiu2dLD6jZaYYr/U3PXkimjpZxKtXdvaWl32PpTVkA==
X-Received: by 2002:a05:600c:1c1c:b0:381:45b4:3f69 with SMTP id j28-20020a05600c1c1c00b0038145b43f69mr3697468wms.86.1646313211951;
        Thu, 03 Mar 2022 05:13:31 -0800 (PST)
Received: from [192.168.0.137] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c358500b0038167e239a2sm2444025wmq.19.2022.03.03.05.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 05:13:31 -0800 (PST)
Message-ID: <92ecef5a-cd8d-09e6-a8af-201e04b251c1@canonical.com>
Date:   Thu, 3 Mar 2022 14:13:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RESEND PATCH v2 4/6] nfc: llcp: use test_bit()
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
 <20220302192523.57444-5-krzysztof.kozlowski@canonical.com>
 <7fc4cb250bb8406cadf80649e366b249@AcuMS.aculab.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <7fc4cb250bb8406cadf80649e366b249@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/03/2022 01:10, David Laight wrote:
> From: Krzysztof Kozlowski
>> Sent: 02 March 2022 19:25
>>
>> Use test_bit() instead of open-coding it, just like in other places
>> touching the bitmap.
> 
> Except it isn't a bitmap, it is just a structure member that contains bits.
> So all the other places should be changes to use C shifts and masks (etc).
> 

It's not declared as bitmap but it is unsigned long, so an appropriate
type (and same type) for test_bit.


Best regards,
Krzysztof
