Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064FF6E4E5A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDQQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:35:10 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01243102
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:35:08 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id ca8so3176248oib.11
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681749308; x=1684341308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nk4b8hLk7mCe6V4y1n8m9lEmfP1unaPOQEdWmNyyPao=;
        b=pSmVw6NaAPx7Klo77JJIJcrwudwVQ5wFkX+NN0wJngvoBLEDM7eOvpHfK2eYICEdEW
         TOCLiPYTODO6s+tUkZn7Phayoxv6m2QODsBlTsAbv89yQ0ciUuBbJBAXxU8pBbRoX6l5
         8gvH4S+h5ZdN9fQagmxbtcyRsAs7K8eYpFFeAKYEohgW36noR39uJjK/zMQBYqzuJU9D
         A3/Ojkua4k6MQJaUaLaJdg09HXSNdykz8E4xEy31XaaZZJPTzfonfhRF3m+tHS0hrO0w
         8JUK71aWcvUSYxoVdhzLMfbywAw0O/3oq7ZO1VfRSGFKHcMXnCJ0VaTbI/xjWyHgVsbE
         rB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681749308; x=1684341308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nk4b8hLk7mCe6V4y1n8m9lEmfP1unaPOQEdWmNyyPao=;
        b=RRwsyxdBMp6MwAQwCGVYYTyjviLIAR1eGZAm3cPBnv7+dTHprI5Vjgalne18z+0tNI
         pZbqtvaRTIGE0WNTDjvLRwPXuCI2j9B1uS3e9mmks09OtwR/ZBp9c/Qw6g+PWqPYyL5E
         alawLA3GLXcoi7Xghi6eDOhzhN95d9KHwksURFvDrTqAgUPuRUPS7LpT+Kk0yAcLWFAd
         GFlFpVX7KYS9NY9bPDxLIJ6QVQkkNVqndMVXcRH3yCgqdhmZKxrVCvF8xYQIOwF47eVY
         KJux1PVqqlZAxDm51C1Lt/Wcp63e706Zd0E6jKY8hFta4UUryqVQfJv0YrRZHpAay7SI
         LltA==
X-Gm-Message-State: AAQBX9fcxz/lb5U+fSbK7i4V3A5yevOt8Zm8WMHoTaSXabJ0arMNa0S0
        E9zu4Q2lVf1qKpsr7t3L0Dm6Qw==
X-Google-Smtp-Source: AKy350YSvqKcax6uNuF2VNGv8rM9fowSG5fpgHXVyzS1REpQjcUw49Rs8zT6TxkK0Sassr9SurLGnQ==
X-Received: by 2002:a05:6808:8f:b0:387:5d7b:8606 with SMTP id s15-20020a056808008f00b003875d7b8606mr7406268oic.57.1681749308309;
        Mon, 17 Apr 2023 09:35:08 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:150:be5b:9489:90ac? ([2804:14d:5c5e:44fb:150:be5b:9489:90ac])
        by smtp.gmail.com with ESMTPSA id w185-20020aca62c2000000b0038c0a359e74sm4887850oib.31.2023.04.17.09.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 09:35:07 -0700 (PDT)
Message-ID: <da22f057-806f-5ad8-f56c-7d3bf6a61746@mojatatu.com>
Date:   Mon, 17 Apr 2023 13:35:04 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] net/sched: sch_htb: use extack on errors
 messages
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
References: <20230414185309.220286-1-pctammela@mojatatu.com>
 <20230414185309.220286-2-pctammela@mojatatu.com>
 <20230414181345.34114441@kernel.org>
 <CAM0EoMkYCZovRqu4KRvgoO0YfEf0UXm0tU_uTmfJ5Ln2kbD1mQ@mail.gmail.com>
 <20230417085251.6b031b1e@kernel.org>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230417085251.6b031b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/04/2023 12:52, Jakub Kicinski wrote:
> [...]
> 
> The rule of thumb I had was that if the message comes from "core" of
> a family then _MOD() is unnecessary. In this case HTB is a one-of-many
> implementations so _MOD() seems fine. Then again errors about parsing
> TCA_HTB_* attrs are unlikely to come from something else than HTB..

Agreed, will re-spin with this in mind.

Pedro
