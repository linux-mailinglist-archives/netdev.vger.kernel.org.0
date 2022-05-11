Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4C523F2B
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 23:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347945AbiEKVCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 17:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbiEKVCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 17:02:48 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B60C69733
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 14:02:47 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so1324421wma.4
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 14:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QvfkesjSNuOwIjf9l2gZz9qIKJCVfAIttP04KcQ8xI=;
        b=mr12LmZ4pHNSvjXUsUK6TXqML18coxgaTmvaYkp6lFDFzA/X5P8gP764X0VpIqo/vQ
         6KbDlUSIeLI8RF54RiX24I05OSGsPikF7UJOIHVn+ZT+t738JPanuY7gZR63pstpkBGs
         oDkoazIl6Xrg2B09XIws4yd1TxFk9FHYRtLfQKr4w3EWFK6y+ei5HWS+J+U/ex35kf/J
         Pu3DfjDvxWiYfrYaB2DkSSo2k+loS+m455Ya6GWdGeIwz+0rYbfrOjmAnNmqyctUi29h
         ThKwt5/mrmd3spyM+2hR0MK8A491PbV7NdQ631imNBIS3UFiV7JdZJZWcumchdIDTsZc
         Si2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QvfkesjSNuOwIjf9l2gZz9qIKJCVfAIttP04KcQ8xI=;
        b=6J7cZxVIdDsfVWzgVBq4mr+BsNqmHGn4KC3rFYDG9MnUd5e1E+2DK2X7iRyEghH8Sp
         7vcPKSyvew6DJvg8x/wFWgDFdiAM9A6FvK4oPzh6GnJqEW4+WiLQwCELadhfqpSHtdjM
         OQk+ReWFuRLypQDtBbA5l5cj3gM+TfxF5RBmSry3oUtZs/uEInr+FPZmNo8ccut4b7k0
         d10C7hQrWLvAQYF7MbFPmBHAhkhv8++q8k6ZcGN5uDcMqK0d1gW6LpU3xdbhkqC+BXSs
         ywr2mHvo+wMkaFsduX/DpgwvasWUeEpy20Kro6fzZ1heP+rlojk57WdWEQl3YK9IgFZ2
         0VOg==
X-Gm-Message-State: AOAM532eP5D4ebYTOOd8vrX0Bgh7D8TwwCv9+ChzDsYJRfRl9N4VE6Cw
        mtDthzUj9+TUzSTsCVqrr6c=
X-Google-Smtp-Source: ABdhPJwipuvXYIV7n4KGsC71mXWuKGYmJH8hnmkL8DCjlzOwdM5KsRE3K3iUrYLM56LIHgcuDB1bHA==
X-Received: by 2002:a05:600c:154d:b0:394:880f:ae3a with SMTP id f13-20020a05600c154d00b00394880fae3amr6613944wmg.13.1652302965695;
        Wed, 11 May 2022 14:02:45 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d6-20020adffbc6000000b0020c5253d91asm2488846wrs.102.2022.05.11.14.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 14:02:45 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] eth: switch to netif_napi_add_weight()
To:     Jakub Kicinski <kuba@kernel.org>,
        Martin Habets <habetsm.xilinx@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com
References: <20220506170751.822862-1-kuba@kernel.org>
 <20220506170751.822862-4-kuba@kernel.org>
 <d61cf1ea-94bc-6f71-77b6-939ba9e115c4@gmail.com>
 <20220511124551.1766aa66@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <86183449-cb7f-2804-89ad-5c714d99ff5b@gmail.com>
Date:   Wed, 11 May 2022 22:02:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220511124551.1766aa66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/05/2022 20:45, Jakub Kicinski wrote:
> On Wed, 11 May 2022 18:57:53 +0100 Edward Cree wrote:
>> This isn't really a custom weight; napi_weight is initialised to
>>  64 and never changed, so probably we ought to be just using
>>  NAPI_POLL_WEIGHT here and end up on the non-_weight API.
>> Same goes for Falcon.
> 
> Ack, I wanted to be nice. I figured this must be a stub for a module
> param in your our of tree driver.

I mean, it *is*... but there's almost certainly a better way.  Configuring
 NAPI weight for tuning purposes (as opposed to some kind of correctness
 limitation in a driver) probably ought to be left to generic infrastructure
 rather than vendor-specific modparams in driver code.

> Should I send a patch to remove
> the non-const static napi_weight globals and switch back to non-_weight?

Yes please, unless Martin has any objections...?

-ed
