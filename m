Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E3F5EE4AD
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiI1S6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiI1S63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:58:29 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40792ECCCA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:58:26 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s14so21287482wro.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=3aioaX5aVyk1IROPNVcQJHxTK+Qoz4i+22iXsRVii4I=;
        b=O9qz5JgKum0mFHe1nHG165ZurYM9tlv2qRPl/mW7ozsrK30iTbZTlQxNeePDWVYvAX
         Y5fJENKwTYSwZ0yYjIA9r1ac0VDhpOtpNTcOFRwUS1mfzWAchdQ73VkEcswE1XOLp3Xk
         QS3DqKb/lcZ0zsxdcyHufhfSvDr0dtm0+SoF8VJ/PsYQaDydPAe/Swr7CNeiYv7cP4Af
         B/VMuGoa/4MqLAh1GxQg6SrJL2FHB81MvtjsGvPquvr4HfWqMSX7mrPBYk9COw+rECIO
         19oXjcVjyqbvjvNaFoiJZQlJ/iiSZMPgF7kSdlnTrY4ZEAlWpPDY2J3Bq0WaPDActGKo
         A/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3aioaX5aVyk1IROPNVcQJHxTK+Qoz4i+22iXsRVii4I=;
        b=isIYU8NJtZ5bTHPcFdFbEctlizDEl2hVGHfkbgtJliRZ+WpJBnHvJ2PwMLYal8ZvUp
         SLpULcARVGvQIUQKIr0CAQEuWTSaMzZMZD4jkEckKfklRR2zB1844ONzJGvdGs1v85Og
         KFKAhOba2dvq43CHr1gh0TS4GKL7s1pxNzXLjmyO3yHm/RC76IEfgfddTmvGPJJkY5d8
         srEjmmM9eoyE78RTYqL/IhditYYKIPzq4P4+KLw60MnMKlXFymife/jmmqB832NnCw2U
         iYIl7lwXDiINh9vfcMtpvE9UieImhib6tpJuNJ3Z6bn7jROcqtczJnFOLsBhFip0Nj/J
         X9wQ==
X-Gm-Message-State: ACrzQf1BXWMY6i+gOJ3wfprzs2A/TZnhCizrugCc67GGykcoAX5n/kIr
        /S0B42IyPWRv5LWm0T8pJcQ=
X-Google-Smtp-Source: AMsMyM7SFXhQsBEj8n3JmMXVbOdQdfaDvxuamOqbPfyTzJLChr+pt0S0ERCq2yCvo8O+eyOpu2yvrw==
X-Received: by 2002:a05:6000:2a4:b0:226:da29:2afb with SMTP id l4-20020a05600002a400b00226da292afbmr20998909wry.206.1664391504704;
        Wed, 28 Sep 2022 11:58:24 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id w11-20020adfee4b000000b002206203ed3dsm1722755wro.29.2022.09.28.11.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 11:58:24 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
 <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
 <20220928104426.1edd2fa2@kernel.org>
 <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
 <20220928113253.1823c7e1@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
Date:   Wed, 28 Sep 2022 19:58:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220928113253.1823c7e1@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 19:32, Jakub Kicinski wrote:
> I won't help with the indirect stuff, I fixed it once a while
> back already and it keeps getting broken. It must be a case of 
> the extack not being plumbed thru, or people being conservative
> because the errors are not fatal, right? Solvable.

The conceptual problem, as I see it, is that multiple hw drivers /
 driver instances might be trying to offload the same tunnel rule,
 because the ingress device isn't actually specified anywhere in
 the weird inside-out way TC tunnel rules work.
So how do you deal with the case where one driver succeeds and
 another fails to offload, or two fail with different rc and
 extack messages?

But I really need to go and check what it does right now, because
 my information might be out of date — some of this driver code
 was first written two years ago so maybe it's since been solved.

> The printf'ing? I recon something simple like adding a destructor 
> for the message to the exack struct so you can allocate the message, 

What about just a flag to say "please kfree() the msg on destruct"?
I have a hard time imagining a destructor that would need to do
 anything different.

> or adding a small buffer in place (the messages aren't very long,
> usually) come to mind.

Also an option, yeah.  Downside is that it consumes that memory
 (I guess 80B or so?) for every netlink response whether it's using
 formatted extack or not; idk if people with lots of netlink
 traffic might start to care about that.
Should I rustle up an RFC patch for one of these, or post an RFD to
 the list to canvass other vendors' opinions?

-ed
