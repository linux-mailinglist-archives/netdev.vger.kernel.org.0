Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224CF4B60DB
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiBOCRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:17:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiBOCQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:16:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F3A2646C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644891409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OES9eo0if6aMt90j7pDi9qQJl5u1pvSze5SYytpvGsE=;
        b=RjmdJg0WqS5v5ARJjcj1g/JXd/p+bT+Bj8tQ7G6wZT08KDkCef7o1vSbkutdN7Yiu0imDq
        lsUuK4YOxIFjjB6Ggg6DQmRCdHn6CFxUHl1Y0a8qW7KDODmGwuCt0FL+k5ZmyjMkeGRM7q
        DMZ0yw4he8d73Pm2/p5fmF2TAyQHB8o=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-4lBMRBWjPXC-steTt-i-8w-1; Mon, 14 Feb 2022 21:16:48 -0500
X-MC-Unique: 4lBMRBWjPXC-steTt-i-8w-1
Received: by mail-ot1-f72.google.com with SMTP id e110-20020a9d01f7000000b0059ecb99d288so11393549ote.12
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:16:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OES9eo0if6aMt90j7pDi9qQJl5u1pvSze5SYytpvGsE=;
        b=F7Nxo8ZijLi/GKETVll1jqIwN7hLHOwXNvA4murBFxFMfAHGGkjs+ZEfEnOLl1a4dg
         CZ6pyiR64nvHcWVKctOH3WYol2+uB/9m9P76ef78p2THU7KUKKxMIpm31ijGLy/C0jjR
         Rs5G4VEHUlUXoMFj0yCjmqqmNdGgK6/cbCt5Mrx8beXv0sRHRKfLzOG/p38R+Mz+vcXw
         vm3X2N7nKlaxCEWFiYyoeSpQMOvxZJcQPSxdr2YyMfVOULPbzcEjtIj9MDBkcTvL3Jh8
         Y+buXA/knH6eSkxQ208aLOnwkYQxIBmAeADGqcMHOoqx3Vekh6aohWe0GW2FDf16XkoE
         F5jg==
X-Gm-Message-State: AOAM531dPVnBsgzpejuUBnc/OFYYKU5m4TL2nNkWnx20HeOYr7tHhKza
        HOUFOTJgLupcdzYONp1eERiFUiVqwBpYO6fu4EkQyD2b2Mr35tAu5lSQUGx6qge+6jTgypkheyB
        PfS6jxug1P0hHVmBW
X-Received: by 2002:a9d:2006:: with SMTP id n6mr624194ota.280.1644891407274;
        Mon, 14 Feb 2022 18:16:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNReslkyHcan04SVrO66oIRVvUmrz6T/DGJgUso3HMcO0lO54yqkB9k5GXi2Cs08NXfNdIqw==
X-Received: by 2002:a9d:2006:: with SMTP id n6mr624189ota.280.1644891407067;
        Mon, 14 Feb 2022 18:16:47 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id q4sm13092321otk.39.2022.02.14.18.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 18:16:46 -0800 (PST)
Subject: Re: [PATCH] mctp: fix use after free
To:     Jeremy Kerr <jk@codeconstruct.com.au>, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20220214175138.2902947-1-trix@redhat.com>
 <daabe69d3863caa62f7874a472edbf2bc892d99e.camel@codeconstruct.com.au>
From:   Tom Rix <trix@redhat.com>
Message-ID: <6590666e-524d-51c3-0859-f8bf0c43c5ca@redhat.com>
Date:   Mon, 14 Feb 2022 18:16:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <daabe69d3863caa62f7874a472edbf2bc892d99e.camel@codeconstruct.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/14/22 4:44 PM, Jeremy Kerr wrote:
> Hi Tom,
>
>> Clang static analysis reports this problem
>> route.c:425:4: warning: Use of memory after it is freed
>>    trace_mctp_key_acquire(key);
>>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> When mctp_key_add() fails, key is freed but then is later
>> used in trace_mctp_key_acquire().  Add an else statement
>> to use the key only when mctp_key_add() is successful.
> Looks good to me, thanks for the fix.
>
> However, the Fixes tag will need an update; at the point of
> 4a992bbd3650 ("mctp: Implement message fragmentation"), there was no
> use of 'key' after the kfree() there.
>
> Instead, this is the hunk that introduced the trace event:
>
>    @@ -365,12 +368,16 @@
>                            if (rc)
>                                    kfree(key);
>     
>    +                       trace_mctp_key_acquire(key);
>    +
>                            /* we don't need to release key->lock on exit */
>                            key = NULL;
>   
> - which is from 4f9e1ba6de45. The unref() comes in later, but the
> initial uaf is caused by this change.
>
> So, I'd suggest this instead:
>
> Fixes: 4f9e1ba6de45 ("mctp: Add tracepoints for tag/key handling")
ok - see v2
>
> (this just means we need the fix for 5.16+, rather than 5.15+).
>
> Also, can you share how you're doing the clang static analysis there?
> I'll get that included in my checks too.

build clang, then use it

scan-build \
     --use-cc=clang \
     make CC=clang

There are a couple of configs that aren't happy with clang, these you 
can sed away with

sed -e 's/CONFIG_FRAME_WARN=2048/CONFIG_FRAME_WARN=0/; 
s/CONFIG_RETPOLINE=y/CONFIG_RETPOLINE=n/; 
s/CONFIG_READABLE_ASM=y/CONFIG_READABLE_ASM=n/; 
s/CONFIG_FORTIFY_SOURCE=y/CONFIG_FORTIFY_SOURCE=n/'

I am using clang 14

Tom

>
> Cheers,
>
>
> Jeremy
>

