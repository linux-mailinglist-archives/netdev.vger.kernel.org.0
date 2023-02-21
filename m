Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C6F69E2BA
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 15:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjBUOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 09:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbjBUOxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 09:53:09 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D97EE055
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:52:58 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j3so1505638wms.2
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4flrelf56q/oJe/E7sU2PM2CO001TFeEynbBfVMOqMI=;
        b=TW4K5RWWKJ3o5Vx79Kq3QzNBAAIz5xgZ5XFegj8oUmvhpe72VJ45FRDjWQ8vobE6Fp
         B8XtcbwbqOzf8sXQeMps5N4cQMHG4GhGrhQzu49+nna+GVNLPh5vX/YPj5sE4tB68cA3
         mYUwX1wvTdPzy04ZNbvIkH/BJrRTkzTHFNuPclm+p095AyHFcuPPOTZlW4ANHoipa1TS
         tuAN1P1aFuDBfQTN7PKmUNCQfbiGSqKB0rnEe/r/6Wjy40+b4YE2F/RMbeW8EYdRW4ZV
         IO2fpMF/mXs9ma0lXrwyFhUD6PYdI0yVXRzXBwiMzhNrMkWB+qeiVbR2wKDqFdbYn/QL
         DLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4flrelf56q/oJe/E7sU2PM2CO001TFeEynbBfVMOqMI=;
        b=otLimr2JBbotNkhPug+fNyJ8EGxjlVJyK4uO9FhJeVy6zp8Y8V/wGDPpl3jnH7rADR
         2kwlwxTomCa9YWV9l7cJsuWyyGgN18YDrA+/u2vOHD86VAyW6xgYBaHejBT+ZlEao9Qt
         unq0OVFy3LdSnJOFT14Vw3S6tt9u2ZUiZ6HYVkTN+ECK3jB9pmHcxnIR4ZIpSW/Hg1xH
         Nx7RnxFKBOz+0hCzqjBtZQ9CUh/ealOcvj6/CbX5U9Sccj9cBq3aX8DPonLmiOrpbaNA
         MbnPmkImFbsA2qIrU/EJH8RmZB24maRPw1BL8Ugs161bFf/bPhGwYkQIFtXrlHoSzNnM
         wvow==
X-Gm-Message-State: AO0yUKUUnV+6cpyFTg1TnpzDLLYrN7WyfqXYeV07Domx5ZHTJULdbu6Q
        igKSXdhqkr8cN8sWIM+9ZvjMWA==
X-Google-Smtp-Source: AK7set/xqZCuwDpnjxxc1vPFmsVK2UHSxoaT6SmGE+l6AjtIshfzen7HC5pVbj8Hsj/HDQPViIh30A==
X-Received: by 2002:a05:600c:2ad6:b0:3df:eb5d:fbf with SMTP id t22-20020a05600c2ad600b003dfeb5d0fbfmr3336047wme.38.1676991176778;
        Tue, 21 Feb 2023 06:52:56 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id j16-20020a056000125000b002c5706f7c6dsm1686184wrx.94.2023.02.21.06.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 06:52:55 -0800 (PST)
Message-ID: <c4224fa7-c206-17d3-641b-6f3f53dd813d@arista.com>
Date:   Tue, 21 Feb 2023 14:52:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
References: <20230215183335.800122-1-dima@arista.com>
 <20230215183335.800122-2-dima@arista.com>
 <Y/NAXtPrOkzjLewO@gondor.apana.org.au>
 <bd40ff2f-b015-4ed4-7755-f9d547c8b868@arista.com>
 <Y/Qv3eEk+1zytBGG@gondor.apana.org.au>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y/Qv3eEk+1zytBGG@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 02:43, Herbert Xu wrote:
> On Mon, Feb 20, 2023 at 04:57:20PM +0000, Dmitry Safonov wrote:
> . 
>> Do you have a timeline for that work?
>> And if you don't mind I keep re-iterating, as I'm trying to address TCP
>> reviews and missed functionality/selftests.
> 
> I'm hoping to get it ready for the next merge window.

Nice! I'll mark this 1/21 patch as [draft], mentioning your work as it
will need to be re-made using per-request keys.
Still, I will keep iterating TCP-AO patches set during 6.3 RCs in order
to get more reviews/suggestions related to TCP changes.

>> 1) before your per-request key patches - it's not possible.
>> 2) after your patches - my question would be: "is it better to
>> kmalloc(GFP_ATOMIC) in RX/TX for every signed TCP segment, rather than
>> pre-allocate it?"
>>
>> The price of (2) may just well be negligible, but worth measuring before
>> switching.
> 
> Please keep in mind that you're already performing crypto which
> is usually a lot slower than a kmalloc.  In any case, if there is
> any optimisation to be done to make the kmalloc faster by using
> pools, then that optimisation should go into mm.

Fair point. Probably, kmalloc() is negligible. I'll measure as I have a
patch for iperf for TCP-MD5/TCP-AO measurements.

Thanks,
          Dmitry
