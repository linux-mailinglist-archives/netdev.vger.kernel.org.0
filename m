Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969B15E6E6B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIVVao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIVVam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:30:42 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D09E722C
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:30:40 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id w2so7265197qtv.9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=KTvgqzdEj4UeM/sRuP4/ASLGgNatM4DunxAKZgaY9BE=;
        b=J7xupCtklC+7rZ1iQqyRuYfvAasX19LSeTJJbKZ9AKTssmN7fk41zIjPLh/ImOQvGp
         w7B5proHz5AZ2eKf2dHYxnA6W9XXasqrmZa+v7tWOeTbebiqjhrlggMPLZAPi679PEMd
         wNtqNWOwg+2lNUUcSF3eantkxYOaVDE+to5D1yYrQmErDzkpz0Yx/N8LC3Sl0TUY1Rzv
         s9+erT5CU0CHGqNT3dOzj4Z47pQdTp/dsURzRjthczrxr2OmLIw6zC2DeAMeM2mdwbaW
         Ef0xCCIJIijUhtV4ahNdlfVolQXxetg9CBiErBo8CHxW05tMZX6dh8F7Jmok+UfsdR/o
         hPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KTvgqzdEj4UeM/sRuP4/ASLGgNatM4DunxAKZgaY9BE=;
        b=KiGvhQRMFnEILOoQ/4fRN5luf0heDWCTJ1oVFQU8bb1VNNAuOAbzwlj19SqIBe0Im8
         fFp7bM8V0fE3GB/ym7c1C3Od5EDJSFlAQj0DUgUEntMOsArzxwgDr4Phpp6QkhSQS3Gi
         T0fxr2yn0oONhnRrQOz65ur/PkJo4EdLqsDEwYjaJJfdvWJnP+NKdm0GekWmxGPjhi0H
         0xJYLqusemHHV4Y3GCLH+yuxUjkGQYOj4/UjcPKJ4gEXYKWe6bedVyVZCupERmktPnfk
         6f9kEUZcFGMuO7tQjfqd+Lprez4wZFOPowwLS8IzkDt4KvVPmXNtHZYB0yRSft++lBqz
         mlAQ==
X-Gm-Message-State: ACrzQf3tWVDVf/rWP/MJlBKrz33jF9bMA4ZGA1Mh1gqP7I2aYi0Mm8G6
        Mkvbt9j5fxCcSfycxMnFZfA=
X-Google-Smtp-Source: AMsMyM68TvtaemoZnmabu7Csoj4NuwFl4FguC3RAaD3IIakRGvQs0M5G/2NsdTBzfnzFDxL3ZGNl8Q==
X-Received: by 2002:a05:622a:148e:b0:35c:db7a:168d with SMTP id t14-20020a05622a148e00b0035cdb7a168dmr4746500qtx.171.1663882239855;
        Thu, 22 Sep 2022 14:30:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bs13-20020a05620a470d00b006b5d9a1d326sm4778196qkb.83.2022.09.22.14.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:30:39 -0700 (PDT)
Message-ID: <fa76bef5-50c5-d9d7-c2ed-e743dcbdcf2c@gmail.com>
Date:   Thu, 22 Sep 2022 14:30:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
 <20220922193648.5pt4w7vt4ucw3ubb@skbuf> <YyzGvyWHq+aV+RBP@lunn.ch>
 <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
 <20220922212809.jameu6d4jtputjft@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220922212809.jameu6d4jtputjft@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 14:28, Vladimir Oltean wrote:
> On Thu, Sep 22, 2022 at 02:25:53PM -0700, Florian Fainelli wrote:
>> On 9/22/22 13:34, Andrew Lunn wrote:
>>>> Ok, if there aren't any objections, I will propose a v3 in 30 minutes or
>>>> so, with 'conduit' being the primary iproute2 keyword and 'master'
>>>> defined in the man page as a synonym for it, and the ip-link program
>>>> printing just 'conduit' in the help text but parsing both, and printing
>>>> just 'conduit' in the json output.
>>>
>>> Sounds good to me.
>>
>> Works for me as well! Thanks Vladimir.
>> -- 
>> Florian
> 
> Hmm, did you see the parallel sub-thread with Jakub's proposed 'via'?
> I was kind of reworking to use that, and testing it right now. What do
> you prefer between the 2?

Emails crossed, I just responded to the parallel thread and do prefer 
"conduit".
-- 
Florian
