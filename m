Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4E4EEEA3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiDAN7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiDAN7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:59:46 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEF5280EC2
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:57:55 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j18so4398544wrd.6
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 06:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Zgqy7GQZmgbvAfbg+2D6i0b8GYNEDitfPB3uSRjzkhQ=;
        b=Cz7ic6u56Eym4MCIewPzWJY5CbNp8FCGOR07jegXXQnq9WTb1RVK9ikmFeeTZ9uZ38
         vLqzlcmRxQiF5hwiTq3+gRfGd6ypw6djjK1+lOO3XUz4e///AyyH0iJxhFuJXU4PoGIT
         V8zv2gKrUXL1TXzxIDW3WAWk1Yju9ktl6eKIUAoVTqN3/EtS7+ecwzslk3ztlvA2w7MO
         Us3LDm6YRRS13KFPF80JkYPUPt9f1r9xbmVRoAHf21AXrYVi+jdm5op145sR4kbQkABG
         +PaJd23XJG8oLEQ4I6s15lLMjxymYe90edPznjm84hIaZLVMm8CPbmHE2jMJRiCQ+xJ/
         K/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zgqy7GQZmgbvAfbg+2D6i0b8GYNEDitfPB3uSRjzkhQ=;
        b=u+KwcZzA2V2/zywgtzQGzN7ji4jFcLwvHdqp7u7QXPAiSlHODErOQuZtG6lBrv/nPM
         LGM8qIRidp8YtN9KN+ZqQY2TWMVTY70x+RpFI5HZnwcZ5PWVcqKBK7vAsBAWcCLjrW3Z
         tznMGL4fIT7SD5dto2WVdLpYVNpTaVNio4K3yhEp4zvannd06RahcuU1Y6QQOWeyrftz
         M4sAgBFTafPUUTlIs4FF5sD66gsp/MqRGlhZARbRkOfF9lLMsRuynLWoXUIXlaRlzXEB
         3YLA83qYQo6nAEE5aM1AZJWry8fZCqSO/I2v1G2hBk1m9TpT5Tgu/qu8y5hI/0AnFrhw
         PR9g==
X-Gm-Message-State: AOAM5307zj3deVqfB82xmGP3lDK5aD92P+1U35c1ftcMg+AnW6NJoNGM
        BYm4o8hWxHNt1SgdEtEYjrI2xCWsrXNYvA==
X-Google-Smtp-Source: ABdhPJx82NgvVbtSjiA2/KeQD00ojVRUl4JJSek8KzQ2QUiLbOpGAAC8+c/JMnZTdttiiSyGeJt5hg==
X-Received: by 2002:adf:d1cc:0:b0:203:e857:85b4 with SMTP id b12-20020adfd1cc000000b00203e85785b4mr7641392wrd.666.1648821474363;
        Fri, 01 Apr 2022 06:57:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:993:6ec0:600b:7e72:20dd:d263? ([2a01:e0a:993:6ec0:600b:7e72:20dd:d263])
        by smtp.gmail.com with ESMTPSA id x3-20020a5d6b43000000b001e317fb86ecsm2086805wrw.57.2022.04.01.06.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 06:57:53 -0700 (PDT)
Message-ID: <ba682166-956f-1eb7-1180-04b903234752@wifirst.fr>
Date:   Fri, 1 Apr 2022 15:57:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] rtnetlink: return ENODEV when ifname does not
 exist and group is given
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Brian Baboch <brian.baboch@wifirst.fr>
References: <20220331123502.6472-1-florent.fourcot@wifirst.fr>
 <20220331203637.004709d4@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220331203637.004709d4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

> Please run the patches thru ./scripts/get_maintainer.pl.
> netdev is high volume (and Gmail hates it), we really need people 
> to CC potential reviewers.

Sorry for that. I was unable to choose relevant reviewers in 
get_maintainer output (too few or too many lines). I will add CC in next 
post.

> 
> Would it be slightly cleaner to have a similar check in
> validate_linkmsg()? Something like:
> 
> 	if (!dev && !ifm->ifi_index && tb[IFLA_GROUP] &&
> 	    (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]))


That will add some complexity in validate_linkmsg, since we will need to 
check NLM_F_CREATE flag before (it's probably not an error when 
NLM_F_CREATE is set), and to give ifm as argument to check ifi_index.

I do not have a strong opinion on this topic, and if you think your idea 
is a better solution I can give a try in a v2.

Thanks,

-- 
Florent Fourcot
