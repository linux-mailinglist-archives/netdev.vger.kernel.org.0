Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D3A58D5AD
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 10:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbiHIIsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 04:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241141AbiHIIsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 04:48:04 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5015D222AA
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 01:48:03 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id a11so5978403wmq.3
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 01:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=LuKqlVYKWsafszP4iMMFVYlR6h3QkfP1Xb5EBCUkHEY=;
        b=HpvzmHyd2z67jYHOPTRlqGtUFVtZOYvN+DXtdYVQOoW80uktsizILbEv6y84VgyfN/
         oz98hNW7i05Y1vMJNdiiYhtc0Sm/NFOSwuDlqV3vye0OtAd7gWYYOhsnaD1fYchOdn7l
         Sq7MPzeixCFcdczppZlw/X83RtEL7laErwSfeIZoa4bLz+HvmrCeEvwqORJmwEVgNwaW
         1SVxRomtL8veLyWfNUgCKfqDjwvoeGJbfq/eEn18GdSbq69UuYE4nuuSpQVsYjU159A1
         U0LvayYbHJl+h9sQwb+UcM+ozQZhAqp+lG428W09rDHwtw63HfrMnfraxAc5soVjJl5z
         41eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=LuKqlVYKWsafszP4iMMFVYlR6h3QkfP1Xb5EBCUkHEY=;
        b=ChvMEY0olOKPPHAQzHZlWfQ2YbIv4iz9JmJTCM89rBSsjOA4Aj81ciZoyfWXz4toGj
         vXnkMd1LcdyAztiv8SrYERy+LYZvCd4W4gCH8GBlKxJDfv+Z5+H1v9o321ENyRDrq0fO
         dVOiBIkePr0XySfv9jaXVq8xBMM91jctYV5hHuve6kF87v5iqjSbTy5L5I67/o3hxPvO
         uvDr7Wo/QkXwGE5giaMcCW+SA0j1ag6L/JUeGse4eHh/2FrGxPdw9S7naBq0RMo97AjV
         XKLj15OajsU14nwEnmjwUIDODqEa6RrryXDf/FwMZjqbsmwcKPyvkmiPBmof6byhY2Yi
         nGBg==
X-Gm-Message-State: ACgBeo0lV1y7+zGJULojtmLNrZUcJpLtvz29hAFFQMv5F26eqBIA/L03
        BA9Asn4WPNeehIAM3PmYTvE=
X-Google-Smtp-Source: AA6agR7APU4Djby9/bLRWQhLU1ha2Oiu7FEAgzzQAoBwuBldfjkVgjS6wU1/o+t1oHiXvidHrNnjcw==
X-Received: by 2002:a05:600c:25d1:b0:3a5:371d:38f with SMTP id 17-20020a05600c25d100b003a5371d038fmr7695133wml.75.1660034881877;
        Tue, 09 Aug 2022 01:48:01 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id v128-20020a1cac86000000b003a327b98c0asm15975818wme.22.2022.08.09.01.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 01:48:01 -0700 (PDT)
Message-ID: <b7ef2c41-12d4-ebea-74bb-e37982cf975b@gmail.com>
Date:   Tue, 9 Aug 2022 11:47:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
 <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
 <20220803182432.363b0c04@kernel.org>
 <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
 <20220804085950.414bfa41@kernel.org>
 <5696e2f2-1a0d-7da9-700b-d665045c79d9@gmail.com>
 <1513fb1a-e196-bc2c-cdb8-34f962282ea2@gmail.com>
 <20220808112417.7839cb5d@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220808112417.7839cb5d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/2022 9:24 PM, Jakub Kicinski wrote:
> On Mon, 8 Aug 2022 08:24:05 +0300 Tariq Toukan wrote:
>>> Thanks for the patch.
>>> We're testing it and I'll update.
>>
>> Trace is gone. But we got TlsDecryptError counter increasing by 2.
> 
> Does the connection break? Is there a repro?

Hi Jakub,

Please ignore my previous email regarding the TlsDecryptError. It was a 
false alarm.

Fix looks goods.

Tested-by: Ran Rozenstein <ranro@nvidia.com>

Regards,
Tariq
