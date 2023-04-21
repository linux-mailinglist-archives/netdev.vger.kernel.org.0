Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116416EACC4
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjDUOYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjDUOYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:24:14 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710371BD
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:24:13 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-38dfbbfe474so709394b6e.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682087053; x=1684679053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sUvjCbdOR79JVJVKzDyw8N1QBhUOMvVcNvfN5UU4S68=;
        b=I1jHxcxQUE5fFonGiz7kgSuJvsjMRc4RJzmWhMvflb+xWNWt4VuUtMfPQgu1NyVVSd
         87pFNysIxMjZ0CHq1y3i8lx1DmFhzzpmVopa2/1YbQ7VCStWI82yRU4xjuIHw7CMuju0
         5hCNpJ3bd94MWtxcWUZKwIqE67ED3hWjjPDmGsByUHFbglZDoTl3BFWSDMYYizuaNkrC
         ZS5Xj+8BvNJCyFZgi1cjaVAHohPEzmmYECYE4284cRlpIE+xlpI2+Aw5oF0/deUWq2He
         HAF/AE6l3MzWUOFXnsPRCJja+ModmX6m+RCYpaJuhCGKdapr4+STkvVeXugCGZqhFQxT
         QNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087053; x=1684679053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUvjCbdOR79JVJVKzDyw8N1QBhUOMvVcNvfN5UU4S68=;
        b=Tp1KX2eKT0DhPgLs7kneJoWMUIXGGrJ+k4Gs6eQa45CXplyCspCq2hjtdSzGW9Czn6
         mpkDjFaNE6C79BkFuZQDszaOeLiXZ1aUQ5r/kztmF/+nPcswKiREThsORPhfF+hkhfbS
         vlxO1MIisQ02iz8K+a39ImdxiHo2m+38xgbc2Y0IDMHEthStpbQn/7p2z/zdWiKJ2gNt
         EYOhisRMV1z5V+PRrdW6WpwPtHc12guNotCmXYCVuX61P82YoMfDYtRPjHJzEJdWyfx/
         7AH6nYjM1hrMa6LpQ7Et7xJMDPwe5RBLG/cLL5u5BTqAGaNrg5Ljxmf3R1bdgxsAJ3IO
         8YdA==
X-Gm-Message-State: AAQBX9eus5E7yF8UpLfuU1xAmpgVYwKC5Daqo0W0ZOUF0b1t3C8SIisr
        Vjid690Aiuwkoo7sA+uZTH3YWQ==
X-Google-Smtp-Source: AKy350YJZ85BjNa54QjuSGAPO9SuTpyd5PeFR7GHJdlT2NKnXEoncbP/3ouJTBBWaDdVsPKTs/nMcw==
X-Received: by 2002:a05:6870:7026:b0:188:53:a7bd with SMTP id u38-20020a056870702600b001880053a7bdmr3515125oae.49.1682087052810;
        Fri, 21 Apr 2023 07:24:12 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75? ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id q123-20020a4a4b81000000b00546daaf33cfsm1810486ooa.14.2023.04.21.07.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 07:24:12 -0700 (PDT)
Message-ID: <a0acecb6-6af7-9353-e3ed-cef69a88d4f2@mojatatu.com>
Date:   Fri, 21 Apr 2023 11:24:07 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2] net/sched: sch_fq: fix integer overflow of
 "credit"
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
References: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
 <4e8324cf-e6de-acff-5e30-373d015a3cb4@mojatatu.com>
 <20230420162435.1d5a79df@kernel.org>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230420162435.1d5a79df@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2023 20:24, Jakub Kicinski wrote:
> On Thu, 20 Apr 2023 13:25:33 -0300 Pedro Tammela wrote:
>>>            "id": "9398",
>>>            "name": "Create FQ with maxrate setting",
>>
>> You probably don't want to backport the test as well? If so I would
>> break this patch into two.
> 
> IIRC the preference of stable folks is to backport more not fewer
> selftests. Practicality of that aside, I think the patch is good as is.

My concern here was mostly due to conflicts with the tdc code base. 
Davide explained to me privately that he will take care of this so it's 
all good.
