Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8785A43A4
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiH2HUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH2HUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:20:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D643186C0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:20:09 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i188-20020a1c3bc5000000b003a7b6ae4eb2so2697220wma.4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Pzu7q1MFuVpsfr0FZEpre8fOe5/FTWhUgP49OKAe72Y=;
        b=tOtoo5MY5SfAMlTpyltwHvGaEy21MTgYuF+d/OE/xuFoKni/ZvZErZp+SLYkxKGAqe
         z4eEpleG+37l9W8hp5FPG2cR76T+buTP7faqdUf4Vfw6Qupg7hykoD5UO95OQPjaxNm5
         jltpZuppkQ9lzRQaQreq1/yT0yNHwgpNAIrHwyFjx6a+qLbUKouG9Fl0kLi575nAU1KV
         j0aMWxlPKTp62eZCe872GgPz/Sy5roiT2c8Q5O3puHZTiwnFLru2S4YicxQ89kvesrpx
         FKK7eg8ijC2rCIOv6a/hOv/ifHVVt9XvRgPZteV8mvcYupj4JuaUTjtiqmE0+kJbuMCK
         RAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Pzu7q1MFuVpsfr0FZEpre8fOe5/FTWhUgP49OKAe72Y=;
        b=TvAiphnwL72E/ky11ShIRF3TfbHnX23kq4KJaS6q0ZdOX36HcSrywrvV//22eCZ3Bf
         GVyDOag/heVsODIQNlvGiZt9n9DWuoUZhBrT+cqkcTTe2LrT3TjaMYSABs4gkiJIWJJM
         DSADDcADLahh4jj2yByRMxAfcIyro7rTh90nVjzDqec2qz4SbJgNn5G4v4LfdA6R7T6X
         wkSpsUds1M9Omdsz0WsAsIJEWjzBsb3rmY7TNLq48WqASBu/jnNUk0gMzGvyIpSOaqC2
         Pm0gwbcUZJcIpUjrpbmlamhrPA1X6ufHwUcdSBwfB2aQ+7lM9zh+xS0UC7nvJf2Si2CZ
         ruYg==
X-Gm-Message-State: ACgBeo3VEUbPYw7W2htZFsbfe9zq/pNzrLz9WQHlJ/vZe7LAN45SLoMV
        tJgcgCzIKf7S8dtAOTz03EKopg==
X-Google-Smtp-Source: AA6agR79l3ltiQPu9AJPp8YIjxhz7f3RlgfrwgzI5M1k7xxaL+bJePHh6/0XB/mM4pSDBuN/xw1uWg==
X-Received: by 2002:a1c:ed0b:0:b0:3a6:30c:12f with SMTP id l11-20020a1ced0b000000b003a6030c012fmr5906173wmh.133.1661757607625;
        Mon, 29 Aug 2022 00:20:07 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id v7-20020adfe287000000b002250f9abdefsm7087924wri.117.2022.08.29.00.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 00:20:07 -0700 (PDT)
Message-ID: <5628a48f-b521-a940-63a0-52f8db0d2961@smile.fr>
Date:   Mon, 29 Aug 2022 09:20:06 +0200
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
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <20220826174926.60347d43@kernel.org>
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

Le 27/08/2022 à 02:49, Jakub Kicinski a écrit :
> On Fri, 26 Aug 2022 09:31:00 +0200 Romain Naour wrote:
>>>> Signed-off-by: Romain Naour <romain.naour@skf.com>
>>>> Signed-off-by: Romain Naour <romain.naour@smile.fr>  
>>>
>>> Two signed-off-by from the same person is unusual :-)  
>>
>> Indeed, but my customer (skf) asked me to use the skf.com address for the patch
>> but I use my smile.fr (my employer) git/email setup for mailing list.
> 
> It's pretty common to use a different email server than what's
> on the From and S-o-b lines. You can drop the second S-o-b.

Thanks for clarification.

Should resend the series now or wait for a review?

Best regards,
Romain
