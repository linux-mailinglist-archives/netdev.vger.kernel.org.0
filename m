Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2A5AF622
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiIFUdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIFUdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:33:14 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C369DB65
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:33:14 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id a15so9099735qko.4
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 13:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qQZPOsnx78bkLeEjXNpouhjSi2jnlf8mcXowoQcn1Gw=;
        b=dhFirpFskgz+APVI5JwgrWH7jIBvH4waPV1DepFwLVGGEMMoyZRHAt5iUANUA6vl+q
         Hw3f54TmDUHUgdTkSwsxk6IJzmVRfE410sLhERIVp/F03ezUMFqwLVZ5tg0NizMMRj+B
         I1A0YzhJEXYfIefGt/vOCA68hQ+603x7C2doiRpKuWzErI+xArNqntNk7TGpqy51mw6i
         NZxky1vL8usJOnCJRfxfc/ppvN/0bL9A86wHSVF60oQ5bJMfAlUs6ulCccwGxMm1oDz/
         MOS+42BfPU7JciLchASEMscndIwOD5xDySnUhjS0+FQ/LpvIDPsDK9i93zU8nyq0sW6T
         +g5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qQZPOsnx78bkLeEjXNpouhjSi2jnlf8mcXowoQcn1Gw=;
        b=oW8FLMOE5OR9vylMj1y8vN1gqdc69nN2rON+xbP0mm9TuMo5wfo5Rd3f5AmniZP/t5
         y/7b4Ip3KmqCatOVC5sgqW/Y9KSU7rJC7epIA8MmD2Bti8p0VT3OxkD0MSeMh1mS0XCf
         pQJRf5gP+Q0AgaVohd9DLViyZ8joOgpVhbcOuEvnDTGAtghfAcT5ZnR6+o1oXElt+fjO
         /kSVx9whTUIWwpWxVdsqZjyJeEHmjRJG/iBHX0cjQ6BfH2kRukSXXSg6IuFS9e1sB2+k
         BWgwFfE1Xt60aKzwTpaa7MRQjTEIUby1qFki8dTx/pVFmqTwemvLWl9T7CFjV8S86U8l
         NvuA==
X-Gm-Message-State: ACgBeo0dPJL35iZcfUlCZ63IA2qY4tYsoz1MnUxD8y3FpsDv3JJn1x8G
        TJcVFjcim2hUIZMjoW3BJYvgt6jaxQw=
X-Google-Smtp-Source: AA6agR5gN0OpqJq0jgblnqmzWMK0pbrdDxeATgpYIKsAJnKdY5ckW3nPFXeJZ82kF9yh/lOW0PwjWw==
X-Received: by 2002:a37:cd0:0:b0:6ba:c1db:6aa9 with SMTP id 199-20020a370cd0000000b006bac1db6aa9mr386413qkm.232.1662496393241;
        Tue, 06 Sep 2022 13:33:13 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t24-20020a37ea18000000b006b95f832aebsm11932478qkj.96.2022.09.06.13.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 13:33:12 -0700 (PDT)
Message-ID: <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
Date:   Tue, 6 Sep 2022 13:33:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YxeoFfxWwrWmUCkm@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2022 1:05 PM, Andrew Lunn wrote:
>> [ Alternative answer: how about "schnauzer"? I always liked how that word sounds. ]
> 
> Unfortunately, it is not gender neutral, which i assume is a
> requirement?
> 
> Plus the plural is also schnauzer, which would make your current
> multiple CPU/schnauzer patches confusing, unless you throw the rule
> book out and use English pluralisation.

What a nice digression, I had no idea you two mastered German that well 
:). How about "conduit" or "mgmt_port" or some variant in the same lexicon?
-- 
Florian
